# /etc/nixos/configuration.nix
{ config, pkgs, inputs, ... }:

{
	imports = [
		./hardware-configuration.nix
		./packages.nix			# <------ System packages declarations live here
		./persist.nix			# <------ Persisting files declarations live here baby
	];

	# --- Kernel/Latest -----------------
	boot.kernelPackages = pkgs.linuxPackages_latest;

	# --- Bootloader --------------------
	boot.loader.systemd-boot.enable		 = true;
	boot.loader.efi.canTouchEfiVariables = true;

	# --- Networking --------------------
	networking.hostName = "nixos";
	networking.networkmanager.enable = true;

	# --- Locale ------------------------
	time.timeZone		= "Australia/Melbourne";
	i18n.defaultLocale	= "en_AU.UTF-8";

	# --- Graphics ----------------------
	boot.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
	boot.kernelParams = [ "nvidia-drm.modeset=1" ];

	hardware.graphics.enable = true;
	nixpkgs.config.allowUnfree = true;

	services.xserver.videoDrivers = [ "nvidia" ];

	hardware.nvidia = {
		modesetting.enable = true;
		open = true;
		package = config.boot.kernelPackages.nvidiaPackages.stable;
	};

	environment.sessionVariables = {
		__GLX_VENDOR_LIBRARY_NAME = "nvidia";
		LIBVA_DRIVER_NAME = "nvidia";
		GBM_BACKEND = "nvidia-drm";
		WLR_NO_HARDWARE_CURSORS = "1";
	};

	# --- Nix Settings ------------------
	nix.settings = {
		experimental-features = [ "nix-command" "flakes" ];
		auto-optimise-store	  = true;
	};

	# --- Users -------------------------
	users.mutableUsers = false;

	users.users.jamig = {
		isNormalUser		= true;
		extraGroups		= [ "wheel" "networkmanager" "video" "audio" "uinput" ];
		hashedPasswordFile	= "/persist/passwords/jamig";
		shell			= pkgs.zsh;
	};

	users.users.greeter = {
		isSystemUser = true;
		group = "greeter";
		extraGroups = [ "video" " render" "input" ];
	};

	# Uncomment to enable root password
	# users.users.root.hashedPasswordFile = "/persist/passwords/root";

	security.sudo.wheelNeedsPassword = true;

	# --- Display Manager ---------------
	services.sysc-greet = {
		enable = true;
		compositor = "hyprland";
	};

	# --- Folder Permissions ------------
	systemd.tmpfiles.rules = [
		"d /var/cache/sysc-greet 775 greeter greeter - -"	# Needed for greeter
		"d /var/lib/greeter 	 775 greeter greeter - -"	# Needed for greeter
		"d /mnt/internie	 775 jamig   users   - -"
		"d /mnt/ssd		 775 jamig   users   - -"
	];

	# --- Automount Drives --------------
	fileSystems."/mnt/internie" = {
		device = "/dev/disk/by-label/internie";
		fsType = "ext4";
		options = [ "defaults" "nofail" "noauto" "x-systemd.automount" "x-systemd.idle-timeout=60" "x-systemd.device-timeout=5s" "x-systemd.mount-timeout=5s" "noatime" ];
	};

	fileSystems."/mnt/ssd" = {
		device = "/dev/disk/by-label/ssd";
		fsType = "ext4";
		options = [ "defaults" "nofail" "noauto" "x-systemd.automount" "x-systemd.idle-timeout=60" "x-systemd.device-timeout=5s" "x-systemd.mount-timeout=5s" "noatime" ];
	};

	# --- DO NOT EDIT -------------------
	system.stateVersion = "26.05";
}
