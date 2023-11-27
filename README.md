<!-- LTeX: enabled=false -->
# zsh-magic-dashboard
<!-- LTeX: enabled=true -->
Pressing `enter` on an empty buffer displays an information-rich and pretty 
dashboard.

![Showcase](https://github.com/chrisgrieser/zsh-magic-dashboard/assets/73286100/1ae9ca48-cdca-4f54-8c8c-7e87fa051351)
<!-- LTeX: enabled=false -->
*Terminal: WezTerm – Theme: Tinacious Design – Font: Iosevka Term with partial
ligatures – Prompt: Starship*
<!-- LTeX: enabled=true -->

- **Top:** Recent commits (`git log`)  
- **Center:** Current Status (hybrid of `git status` and `git diff --stat`)  
- **Bottom:** Files in the current directory (via `eza`)

Empty components, such as `git status` in a clean repo, are automatically
hidden.

## Table of Contents

<!-- toc -->

- [Installation](#installation)
	* [Requirements](#requirements)
	* [Manual](#manual)
	* [Package Managers](#package-managers)
- [Configuration](#configuration)
- [Usage](#usage)
	* [Other Usages](#other-usages)
- [Credits](#credits)

<!-- tocstop -->

## Installation

### Requirements
- [eza](https://github.com/eza-community/eza)
- [Nerdfont](https://www.nerdfonts.com/)

### Manual
Clone this repository somewhere on your machine. This manual assumes
you are using `~/.zsh/`.

```bash
cd ~/.zsh # where to install the plugin
git clone https://github.com/chrisgrieser/zsh-magic-dashboard
```

Add the following to your `~/.zshrc`:

```bash
source ~/.zsh/zsh-magic-dashboard/magic_dashboard.zsh
```

### Package Managers
<!-- vale Google.FirstPerson = NO -->
I don't use a package manager, since they [are mostly
unnecessary](https://www.youtube.com/watch?v=21_WkzBErQk) and even [increasing
zsh loading time considerably](https://blog.jonlu.ca/posts/speeding-up-zsh).

I am open to pull requests adding instructions for package
managers, though.
<!-- vale Google.FirstPerson = YES -->

## Configuration
Export these variables in your `~/.zshrc`. The values displayed are the default.

```bash
# Size of the dashboard
export MAGIC_DASHBOARD_GITLOG_LINES=5
export MAGIC_DASHBOARD_FILES_LINES=6

# Disable dashboard in low terminal windows. 
# (Useful for tmux or for terminals embedded in your IDE.)
export MAGIC_DASHBOARD_DISABLED_BELOW_TERM_HEIGHT=15

# Make commit hashes & files clickable. Requires `git-delta`.
export MAGIC_DASHBOARD_USE_HYPERLINKS=0 # set to `1` to enable
```

## Usage
<!-- vale Google.Exclamation = NO -->
Just press `enter` on an empty buffer. That's it!
<!-- vale Google.Exclamation = YES -->

### Other Usages

The dashboard call also be called via `_magic_dashboard`. One use case would be
to modify your `cd` command to display the dashboard after the directory change.

```bash
function cd {
	builtin cd "$@" && _magic_dashboard
}
```

The pretty git log is available independently via `_gitlog` and accepts the same
arguments as `git log`, for example:

```bash
# display the last ten log entry
_gitlog -n10

# call via git's core.pager, like git log
_gitlog
alias gl='_gitlog'

# Can also be piped to `fzf`. (Use the _gitlog-specific option `--no-graph` to
# disable the graph, which messes up a lot of fzf-related things.)
selected_hash=$(_gitlog --no-graph | fzf --ansi --no-sort | cut -d' ' -f1)
```

<!-- vale Google.FirstPerson = NO -->
## Credits
This plugin is based on [Magic
Enter](https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/magic-enter)
by [@dufferzafar](https://github.com/dufferzafar).

**About me**  
In my day job, I am a sociologist studying the social mechanisms underlying the
digital economy. For my PhD project, I investigate the governance of the app
economy and how software ecosystems manage the tension between innovation and
compatibility. If you are interested in this subject, feel free to get in touch.

**Profiles**  
- [Academic Website](https://chris-grieser.de/)
- [ResearchGate](https://www.researchgate.net/profile/Christopher-Grieser)
- [Discord](https://discordapp.com/users/462774483044794368/)
- [GitHub](https://github.com/chrisgrieser/)
- [Twitter](https://twitter.com/pseudo_meta)
- [LinkedIn](https://www.linkedin.com/in/christopher-grieser-ba693b17a/)

<a href='https://ko-fi.com/Y8Y86SQ91' target='_blank'>
<img
	height='36'
	style='border:0px;height:36px;'
	src='https://cdn.ko-fi.com/cdn/kofi1.png?v=3'
	border='0'
	alt='Buy Me a Coffee at ko-fi.com'
/></a>
