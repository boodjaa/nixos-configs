# /etc/nixos/packages.nix
{ pkgs, ... }: {
	environment.systemPackages = with pkgs; [
		git
		wget
		curl
		unzip
		htop
		btrfs-progs
		neovim
		kitty
		home-manager
		xdg-terminal-exec
		psmisc
	];
	nixpkgs.config.allowUnfree = true;

	fonts.packages = with pkgs; [
		nerd-fonts.jetbrains-mono
		jetbrains-mono
	];
	fonts.fontconfig.enable = true;

	# Hyprland
	programs.uwsm.enable = true;
	programs.hyprland.enable = true;

	# Zsh global
	programs.zsh.enable = true;
}
