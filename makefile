build:
	idrin build

watch:
	nix-shell -p inotify-tools --run "./scripts/watch.sh"
