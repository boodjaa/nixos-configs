# /etc/nixos/packages.nix
{ pkgs, ... }: {
	environment.systemPackages = with pkgs; [
		git
		wget
		curl
		htop
		btrfs-progs
		neovim
		kitty
		home-manager
	];

	# Hyprland
	programs.hyprland.enable = true;

	# Zsh global
	programs.zsh.enable = true;
}
