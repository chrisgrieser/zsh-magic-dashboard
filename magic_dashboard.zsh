#!/usr/bin/env zsh
# shellcheck disable=2086 # simpler for various pseudo-options

# draws a separator line with terminal width
function _separator {
	local sep_char="═" # ─ ═
	local sep=""
	for ((i = 0; i < COLUMNS; i++)); do
		sep="$sep$sep_char"
	done
	print "\033[1;30m$sep\033[0m"
}

function _gitlog {
	# pseudo-option to suppress graph
	local graph
	if [[ "$1" == "--no-graph" ]]; then
		shift
		graph=""
	else
		graph="--graph"
	fi

	# so less displays nerdfont correctly https://github.com/ryanoasis/nerd-fonts/issues/1337
	export LESSUTFCHARDEF=23fb-23fe:p,2665:p,26a1:p,2b58:p,e000-e00a:p,e0a0-e0a2:p,e0a3:p,e0b0-e0b3:p,e0b4-e0c8:p,e0ca:p,e0cc-e0d4:p,e200-e2a9:p,e300-e3e3:p,e5fa-e6a6:p,e700-e7c5:p,ea60-ebeb:p,f000-f2e0:p,f300-f32f:p,f400-f532:p,f500-fd46:p,f0001-f1af0:p

	# INFO inserting ansi colors via sed requires leading $
	local the_log
	the_log=$(
		git log --all --color $graph \
			--format="%C(yellow)%h%C(red)%d%C(reset) %s %C(green)(%cr) %C(bold blue)%an%C(reset)" "$@" |
			sed -e 's/ seconds* ago)/s)/' \
				-e 's/ minutes* ago)/m)/' \
				-e 's/ hours* ago)/h)/' \
				-e 's/ days* ago)/d)/' \
				-e 's/ weeks* ago)/w)/' \
				-e 's/ months* ago)/mo)/' \
				-e 's/grafted/ /' \
				-e 's/origin\//󰞶  /g' \
				-e 's/upstream\//  /g' \
				-e 's/HEAD/󱍞 /g' \
				-e 's/tag: /  /' \
				-e 's/\* /∘ /' \
				-Ee $'s/ (fix|refactor|build|ci|docs|feat|style|test|perf|chore|revert|break|improv)(\\(.+\\)|!)?:/ \033[1;35m\\1\033[1;36m\\2\033[0;38;5;245m:\033[0m/' \
				-Ee $'s/ (fixup|squash)!/\033[1;32m&\033[0m/g' \
				-Ee $'s/`[^`]*`/\033[1;36m&\033[0m/g' \
				-Ee $'s/#[0-9]+/\033[1;31m&\033[0m/g'
	)

	if [[ "$MAGIC_DASHBOARD_USE_HYPERLINKS" != "0" ]]; then
		echo "$the_log" | delta --hyperlinks
	else
		echo "$the_log"
	fi
}

function _list_files_here {
	if [[ ! -x "$(command -v eza)" ]]; then print "\033[1;33mMagic Dashboard: \`eza\` not installed.\033[0m" && return 1; fi

	local eza_output
	local max_files_lines=${MAGIC_DASHBOARD_FILES_LINES:-6}
	# local use_hyperlinks
	# use_hyperlinks=$([[ "$MAGIC_DASHBOARD_USE_HYPERLINKS" != "0" ]] && echo "--hyperlink" || echo "")
	eza_output=$(
		eza --width="$COLUMNS" --all --grid --color=always --icons \
			--git-ignore --ignore-glob=".DS_Store|Icon?" \
			--sort=name --group-directories-first --no-quotes \
			--git --long --no-user --no-permissions --no-filesize --no-time
	)
	# $use_hyperlinks PENDING https://github.com/eza-community/eza/issues/693

	if [[ $(echo "$eza_output" | wc -l) -gt $max_files_lines ]]; then
		local shortened
		shortened="$(echo "$eza_output" | head -n"$max_files_lines")"
		printf "%s \033[1;36m…\033[0m" "$shortened"
	elif [[ -n "$eza_output" ]]; then
		echo -n "$eza_output"
	fi
}

function _gitstatus {
	# so new files show up in `git diff`
	git ls-files --others --exclude-standard | xargs -I {} git add --intent-to-add {} &>/dev/null

	if [[ -n "$(git status --porcelain)" ]]; then
		local unstaged staged
		unstaged=$(git diff --color="always" --compact-summary --stat=$COLUMNS | sed -e '$d')
		staged=$(git diff --staged --color="always" --compact-summary --stat=$COLUMNS | sed -e '$d' \
			-e $'s/^ /+/') # add marker for staged files
		local diffs
		if [[ -n "$unstaged" && -n "$staged" ]]; then
			diffs="$unstaged\n$staged"
		elif [[ -n "$unstaged" ]]; then
			diffs="$unstaged"
		elif [[ -n "$staged" ]]; then
			diffs="$staged"
		fi
		print "$diffs" | sed \
			-e $'s/\\(gone\\)/\033[1;31mD     \033[0m/' \
			-e $'s/\\(new\\)/\033[1;32mN    \033[0m/' \
			-e $'s/(\\(new .*\\))/\033[1;34m\\1\033[0m/' \
			-e 's/ Bin /    /' \
			-e $'s/ \\| Unmerged /  \033[1;31m  \033[0m /' \
			-Ee $'s|([^/+]*)(/)|\033[1;36m\\1\033[1;33m\\2\033[0m|g' \
			-e $'s/^\\+/\033[1;35m \033[0m /' \
			-e $'s/ \\|/ \033[1;30m│\033[0m/'
		_separator
	fi
}

#───────────────────────────────────────────────────────────────────────────────

# show files + git status + brief git log
function _magic_dashboard {
	# check if pwd still exists
	if [[ ! -d "$PWD" ]]; then
		printf '\n\033[1;33m"%s" has been moved or deleted.\033[0m\n' "$(basename "$PWD")"
		if [[ -d "$OLDPWD" ]]; then
			print '\033[1;33mMoving to last directory.\033[0m'
			# shellcheck disable=2164
			cd "$OLDPWD"
		fi
		return 0
	fi

	# show dashboard
	if git rev-parse --is-inside-work-tree &>/dev/null; then
		local max_gitlog_lines=${MAGIC_DASHBOARD_GITLOG_LINES:-5}
		_gitlog -n "$max_gitlog_lines"
		_separator
		_gitstatus
	fi
	_list_files_here
}

#───────────────────────────────────────────────────────────────────────────────

# Based on Magic-Enter by @dufferzafar (MIT License)
# https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/magic-enter

function _magic_enter {
	# GUARD only in PS1 and when BUFFER is empty
	# DOCS http://zsh.sourceforge.net/Doc/Release/Zsh-Line-Editor.html#User_002dDefined-Widgets
	[[ -z "$BUFFER" && "$CONTEXT" == "start" ]] || return 0

	# GUARD only when in terminal with sufficient height
	local disabled_below_height=${MAGIC_DASHBOARD_DISABLED_BELOW_TERM_HEIGHT:-15}
	[[ $LINES -gt $disabled_below_height ]] || return 0

	# shellcheck disable=2012
	[[ "$(eza --git-ignore | wc -l)" -gt 0 ]] && echo
	_magic_dashboard
}

# WRAPPER FOR THE ACCEPT-LINE ZLE WIDGET (RUN WHEN PRESSING ENTER)
# If the wrapper already exists don't redefine it
type _magic_enter_accept_line &>/dev/null && return

widget_name="accept-line" # need to put into variable so `shfmt` does not break it

# shellcheck disable=2154
case "${widgets[$widget_name]}" in
# Override the current accept-line widget, calling the old one
user:*)
	zle -N _magic_enter_orig_accept_line "${widgets[$widget_name]#user:}"
	function _magic_enter_accept_line {
		_magic_enter
		zle _magic_enter_orig_accept_line -- "$@"
	}
	;;

	# If no user widget defined, call the original accept-line widget
builtin)
	function _magic_enter_accept_line {
		_magic_enter
		zle .accept-line
	}
	;;
esac

zle -N accept-line _magic_enter_accept_line
