# /etc/nixos/home.nix
{ pkgs, inputs, config, ... }:

{
	home.stateVersion = "26.05";		# DO NOT EDIT

	home.username = "jamig";
	home.homeDirectory = "/home/jamig";

	# --- User-level packages ------------------
	home.packages = with pkgs; [
		wofi	
	];

	# --- Shell configuration ------------------
	programs.zsh = {
		enable = true;
		autosuggestion.enable = true;
		syntaxHighlighting.enable = true;
		shellAliases = {
			nrs = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
			nrb = "sudo nixos-rebuild boot --flake /etc/nixos#nixos";
		};
		initContent = ''
			# .zshrc additions go here
		'';
	};

	# --- Git ----------------------------------
	programs.git = {
		enable = true;
		settings = {
			user.name = "Jamie Gostin";
			user.email = "jgos0015@student.monash.edu";
			init.defaultBranch = "main";
			pull.rebase = true;
		};
	};

	# --- Neovim -------------------------------
	programs.neovim = {
		enable = true;
		defaultEditor = true;
		extraConfig = ''
			set tabstop=4 shiftwidth=4
		'';
	};	

	# --- Hyprpaper ----------------------------
	services.hyprpaper = {
		enable = true;
		settings = {
			preload = [ "/home/jamig/wallpaper.png" ];
			wallpaper = [{
				monitor = "HDMI-A-1";
				path = "/home/jamig/wallpaper.png";
			}];
		};
	};

	# --- Wofi ---------------------------------
	programs.wofi.enable = true;

	# --- Waybar -------------------------------
	programs.waybar.enable = true;

	# --- nnn ----------------------------------
	programs.nnn = {
		enable = true;
		package = pkgs.nnn.override { withNerdIcons = true; };

		bookmarks = {
			H = "~";
			D = "~/Downloads";
		};
	};

	# --- Home Manager -------------------------
	programs.home-manager.enable = true;
}
