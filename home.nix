# /etc/nixos/home.nix
{ pkgs, inputs, config, ... }:

{
	home.stateVersion = "26.05";		# DO NOT EDIT

	home.username = "jamig";
	home.homeDirectory = "/home/jamig";

	# --- User-level packages ------------------
	home.packages = with pkgs; [
		wofi	
		gh
	];

	# --- Shell configuration ------------------
	programs.zsh = {
		enable = true;
		autosuggestion.enable = true;
		syntaxHighlighting.enable = true;
		shellAliases = {
			nrs = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
			nrb = "sudo nixos-rebuild boot --flake /etc/nixos#nixos";
			nnn = "n";
		};
		initContent = ''
			export PATH=$PATH:/home/jamig/.local/bin	
			eval "$(oh-my-posh init zsh --config '~/.config/gruvbox.omp.json')"
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
			safe.directory = "/etc/nixos";
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
			splash = false;
		};
	};

	# --- Wofi ---------------------------------
	programs.wofi.enable = true;

	# --- Waybar -------------------------------
	programs.waybar.enable = true;

	# --- Cursor -------------------------------
	home.pointerCursor = {
		name = "phinger-cursors-light";
		package = pkgs.phinger-cursors;
		gtk.enable = true;
		size = 32;
	};

	# --- nnn ----------------------------------
	programs.nnn = {
		enable = true;
		package = pkgs.nnn.override { withNerdIcons = true; };

		bookmarks = {
			H = "~";
			D = "~/Downloads";
		};
	};

	# --- Firefox ------------------------------
	programs.firefox = {
		enable = true;

		policies = {
			DisableTelemetry = true;
		};
	};

	# --- Home Manager -------------------------
	programs.home-manager.enable = true;
}
