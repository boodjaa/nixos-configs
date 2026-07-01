# /etc/nixos/configuration.nix
{ config, pkgs, inputs, ... }:

{
	imports = [
		./hardware-configuration.nix
		./packages.nix			# <------ System packages declarations live here
		./persist.nix			# <------ Persisting files declarations live here baby
	];

	# --- Bootloader --------------------
	boot.loader.systemd-boot.enable		 = true;
	boot.loader.efi.canTouchEfiVariables = true;

	# --- Networking --------------------
	networking.hostName = "nixos";
	networking.networkmanager.enable = true;

	# --- Locale ------------------------
	time.timeZone		= "Australia/Melbourne";
	i18n.defaultLocale	= "en_AU.UTF-8";

	# --- Nix Settings ------------------
	nix.settings = {
		experimental-features = [ "nix-command" "flakes" ];
		auto-optimise-store	  = true;
	};

	# --- Users -------------------------
	users.mutableUsers = false;

	users.users.jamig = {
		isNormalUser		= true;
		extraGroups			= [ "wheel" "networkmanager" "video" "audio" ];
		hashedPasswordFile	= "/persist/passwords/jamig";
		shell				= pkgs.zsh;
	};

	# Uncomment to enable root password
	# users.users.root.hashedPasswordFile = "/persist/passwords/root";

	security.sudo.wheelNeedsPassword = true;

	# --- DO NOT EDIT -------------------
	system.stateVersion = "26.05";
}
