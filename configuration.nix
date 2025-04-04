# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Home Manager
      <home-manager/nixos>
    ];

   ## FUTURE: use flakes
   # nix = {
   #   package = pkgs.nixFlakes;
   #   extraOptions = ''
   #     experimental-features = nix-command flakes
   #   '';
   # };

  home-manager.users.kyle = { pkgs, ... }: {
    home.packages = [ pkgs.httpie ];  # just to confirm that custom home pkgs work
    home.stateVersion = "24.11";

    programs.home-manager.enable = true;

    programs.bash.enable = true;
    programs.bash.bashrcExtra = "set -o vi";

    programs.git = {
      enable = true;
      userName = "Kyle D McCormick";
      userEmail = "kyle@axim.org";
    };
    programs.swaylock = {
      enable = true;
      settings = {
          color = "#110022";
      };
    };
#    programs.waybar = {
#      enable = true;
#      settings = {
#        mainBar = {
#          layer = "top";
#          position = "top";
#          height = 30;
##          output = [
##            "eDP-1"
##            "HDMI-A-1"
##          ];
#          modules-left = [ "sway/workspaces" "sway/mode" "wlr/taskbar" ];
##          modules-center = [ "sway/window" "custom/hello-from-waybar" ];
##          modules-right = [ "mpd" "temperature" ];
#      
#          "sway/workspaces" = {
#            disable-scroll = true;
#            all-outputs = true;
#	    persistent-workspaces = {
#	      "1" = [];
#	      "2" = [];
#	      "3" = [];
#	      "8" = [];
#	      "9" = [];
#	      "0" = [];
#	    };
#          };
#          "custom/hello-from-waybar" = {
#            format = "hello {}";
#            max-length = 40;
#            interval = "once";
#            exec = pkgs.writeShellScript "hello-from-waybar" ''
#              echo "from within waybar"
#            '';
#          };
#        };
#      };
#    };

    wayland.windowManager.sway = {
      enable = true;
      config = rec {
        modifier = "Mod4";  # super / logo key
        startup = [
	  {command = "foot";}  # new terminal on startup
	];
	colors = {
            focused = {
		 background = "#552277";
	         border = "#9944ee";
		 childBorder = "#9944ee";
		 indicator = "#ff00ff";
		 text = "#eeeeee";
	    };
	};
	defaultWorkspace = "3";
        keybindings = {
          "Mod4+Delete" = "kill";
          "Mod4+End" = "exec systemctl suspend";
          "Mod4+Home" = "exec swaylock";

          "Mod4+Return" = "exec ${pkgs.foot}/bin/foot";
	  "Mod4+Space" = "exec wmenu-run";
          "Mod4+Backslash" = "exec firefox";

	  "Mod4+h" = "focus left";
	  "Mod4+l" = "focus right";
	  "Mod4+j" = "focus down";
	  "Mod4+k" = "focus up";
	  "Mod4+Shift+h" = "move left";
	  "Mod4+Shift+l" = "move right";
	  "Mod4+Shift+j" = "move down";
	  "Mod4+Shift+k" = "move up";

	  "Mod4+Equal" = "resize grow width 40px";
	  "Mod4+Minus" = "resize shrink width 40px";
	  "Mod4+Shift+Equal" = "resize grow height 40px";
	  "Mod4+Shift+Minus" = "resize shrink height 40px";

          "Mod4+Mod1+o" = "splitv";  # add below ("open line")
          "Mod4+Mod1+j" = "splitv";  # add below ("alt+down")
          "Mod4+Mod1+a" = "splith";  # add right ("append")
          "Mod4+Mod1+l" = "splith";  # add right ("alt+right")
          "Mod4+Tab" = "split toggle";
          "Mod4+Escape" = "split none";

#          "Mod4+y" = "move scratchpad";
#          "Mod4+p" = "scratchpad show";

	  "Mod4+bracketleft" = "workspace prev";
          "Mod4+bracketright" = "workspace next";
          "Mod4+Shift+bracketleft" = "move container to workspace prev";
          "Mod4+Shift+bracketright" = "move container to workspace next";
          "Mod4+Mod1+bracketleft" = "move container to workspace prev, workspace prev";
          "Mod4+Mod1+bracketright" = "move container to workspace next, workspace next";
	  "Mod4+1" = "workspace number 1";
	  "Mod4+2" = "workspace number 2";
	  "Mod4+3" = "workspace number 3";
	  "Mod4+8" = "workspace number 8";
	  "Mod4+9" = "workspace number 9";
	  "Mod4+0" = "workspace number 10";
	  "Mod4+Shift+1" = "move container to workspace number 1";
	  "Mod4+Shift+2" = "move container to workspace number 2";
	  "Mod4+Shift+3" = "move container to workspace number 3";
	  "Mod4+Shift+8" = "move container to workspace number 8";
	  "Mod4+Shift+9" = "move container to workspace number 9";
	  "Mod4+Shift+0" = "move container to workspace number 10";
        };  # end keybindings
      };  # end sway config
    };  # end sway
  };  # end home-manager

  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # boot.loader.grub = {
  #   enable = true;
  #   efiSupport = true;
  #   enableCryptodisk = true;
  #   device = "nodev";
  # };
  boot.initrd.luks.devices = {
    crypted = {
      device = "/dev/disk/by-uuid/24eb7f28-a715-47e4-ac53-b9e7605532e8";
      preLVM = true;
    };
  };
  boot.kernelParams = [ "processor.max_cstate=4" "amd_iomu=soft" "idle=nomwait" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
#  boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];

  networking.hostName = "thelonius"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

#  # Enable the X11 windowing system.
#  services.xserver.enable = true;
#  services.xserver.windowManager.xmonad = {
#    enable = true;
#    enableContribAndExtras = true;
#    extraPackages = haskellPackages: [
#      haskellPackages.dbus
#      haskellPackages.List
#      haskellPackages.monad-logger
#    ];
#  };
#  services.xserver.displayManager.startx.enable = true;
#  
  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kyle = {
    isNormalUser = true;
    extraGroups = [ "docker" "wheel" ];
    packages = with pkgs; [
      tree
    ];
  };

  virtualisation.docker.enable = true;

  programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    acpi
    firefox
    git
    grim  # screenshot functionality
    mako  # notifications system developed by swaym maintainer
    pass  # git-based password manager
    python311Full
    slurp  # screenshot functionality
    vscode
    wget
    wl-clipboard  # wl-copy and wl-paste
  ];

  # Run sway on startup
  environment.loginShellInit = ''
    [[ "$(tty)" == /dev/tty1 ]] && sway
  '';

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias= true;
  };

  # List services that you want to enable:

  services.getty.autologinUser = "kyle";

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  powerManagement.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

#  # Enable the gnome-keyring secrets vault
#  # Will be exposed through DBus to programs willing to store secrets
#  system.gnome.gnome-keyring.enable = true;
#
  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?

}

