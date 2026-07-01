# /etc/nixos/persist.nix
{ config, ... }:

{
	preservation = {
		enable = true;

		preserveAt."/persist" = {

			files = [
			
				# --- System Identity -----------------
				"/etc/machine-id"
				"/etc/adjtime"

				# --- SSH host keys -------------------
				{ file = "/etc/ssh/ssh_host_rsa_key";		  how = "symlink"; }
				{ file = "/etc/ssh/ssh_host_rsa_key.pub";	  how = "symlink"; }
				{ file = "/etc/ssh/ssh_host_ed25519_key";	  how = "symlink"; }
				{ file = "/etc/ssh/ssh_host_ed25519_key.pub"; how = "symlink"; }

			];

			directories = [

				# --- NixOS Core ----------------------
				{
					directory = "/var/lib/nixos";
					how = "bindmount";
					user = "root"; group = "root"; mode = "0755";
				}
				{
					directory = "/etc/nixos";
					how = "bindmount";
					user = "root"; group = "root"; mode = "0755";
				}

				# --- Connection Profiles -------------
				{
					directory = "/etc/NetworkManager/system-connections";
					how = "bindmount";
					user = "root"; group = "root"; mode = "0700";
				}
				{
					directory = "/var/lib/bluetooth";
					how = "bindmount";
					user = "root"; group = "root"; mode = "0700";
				}

				# --- Systemd Timers ------------------
				{
					directory = "/var/lib/systemd/timers";
					how = "bindmount";
					user = "root"; group = "root"; mode = "0755";
				}
			];
		};
	};
}
