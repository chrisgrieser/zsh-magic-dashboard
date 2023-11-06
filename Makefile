.PHONY: transfer

# transfer from my zsh config
transfer:
	cp -vf $$ZDOTDIR/plugins/magic_dashboard.zsh ./ && \
	echo "Transferred local magic_dashboard.zsh"
