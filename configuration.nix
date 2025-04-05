# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    <home-manager/nixos>
  ];

  ###use flakes?
  ##nix = {
  ##  package = pkgs.nixFlakes;
  ##  extraOptions = ''
  ##    experimental-features = nix-command flakes
  ##  '';
  ##};

  # make sway work with home-manager
  security.polkit.enable = true;
  hardware.graphics.enable = true;

  home-manager.users.kyle =
    { pkgs, ... }:
    {
      home.packages = [ pkgs.httpie ]; # just to confirm that custom home pkgs work
      home.stateVersion = "24.11";

      home.file."kdmc.pub".source = ./kdmc.pub;

      programs.home-manager.enable = true;

      programs.gpg = {
        enable = true;
	publicKeys = [
	  {source = ./kdmc.pub;}
	];
      };

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

      wayland.windowManager.sway = {
        enable = true;
        ##    bar = {
        ##        position = "top";
        ##    };
        config = rec {
          modifier = "Mod4"; # super / logo key
          startup = [
            { command = "foot"; } # new terminal on startup
          ];
          colors = {
            focused = {
              background = "#552277";
              border = "#9944ee";
              childBorder = "#9944ee";
              indicator = "#ffff00";
              text = "#eeeeee";
            };
          };
          defaultWorkspace = "workspace number 1";
          ##      input = {
          ##        "1739:52619:SYNA8006:00_06CB:CD8B_Touchpad" = {
          ##           naturalScroll = true;
          ##        };
          ##      };
          ##	output = {
          ##	  "*" = {
          ##	    bg =
          ##	  };
          ##      };
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

            "Mod4+o" = "splitv"; # add below ("open line")
            "Mod4+Mod1+j" = "splitv"; # add below ("alt+down")
            "Mod4+a" = "splith"; # add right ("append")
            "Mod4+Mod1+l" = "splith"; # add right ("alt+right")
            "Mod4+Tab" = "split toggle";
            "Mod4+Escape" = "split none";

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

            ##        bindsym $mod+f fullscreen
            ##        bindsym $mod+Shift+space floating toggle
            ##        bindsym $mod+space focus mode_toggle
            ##        bindsym $mod+a focus parent
            ##        "Mod4+y" = "move scratchpad";
            ##        "Mod4+p" = "scratchpad show";
            ##        bindsym $mod+s layout stacking
            ##        bindsym $mod+w layout tabbed
            ##        bindsym $mod+e layout toggle split

          }; # end keybindings
        }; # end sway config
      }; # end sway
    }; # end home-manager

  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  ##boot.loader.grub = {
  ##  enable = true;
  ##  efiSupport = true;
  ##  enableCryptodisk = true;
  ##  device = "nodev";
  ##};

  boot.initrd.luks.devices = {
    crypted = {
      device = "/dev/disk/by-uuid/24eb7f28-a715-47e4-ac53-b9e7605532e8";
      preLVM = true;
    };
  };
  boot.kernelParams = [
    "processor.max_cstate=4"
    "amd_iomu=soft"
    "idle=nomwait"
  ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  ##boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];

  networking.hostName = "thelonius"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  ##console = {
  ##  font = "Lat2-Terminus16";
  ##  keyMap = "us";
  ##  useXkbConfig = true; # use xkb.options in tty.
  ##};

  ##Enable CUPS to print documents.
  ##services.printing.enable = true;

  ##Enable sound.
  ##hardware.pulseaudio.enable = true;
  ##OR
  ##services.pipewire = {
  ##  enable = true;
  ##  pulse.enable = true;
  ##};

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  programs.light.enable = true; # brightness and volume keys

  programs.foot = {
    enable = true;
    theme = "solarized";
    settings.main.font = "monospace:size=11";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.kyle = {
    isNormalUser = true;
    extraGroups = [
      "docker"
      "video" # brightness and volume fn keys
      "wheel"
    ];
    packages = with pkgs; [
      tree
    ];
  };

  virtualisation.docker.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    acpi
    git
    grim # screenshot functionality
    nixfmt-rfc-style
    mako # notifications system developed by swaym maintainer
    pass # git-based password manager
    pinentry-curses
    python311Full
    slurp # screenshot functionality
    vscode
    wget
    wl-clipboard # wl-copy and wl-paste
  ];

  # Run sway on startup
  environment.loginShellInit = ''
    [[ "$(tty)" == /dev/tty1 ]] && sway
  '';

  ## Some programs need SUID wrappers, can be configured further or are
  ## started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  fonts.enableDefaultPackages = true;

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };
  programs.firefox = {
    enable = true;
  };
  programs.chromium = {
    enable = true;
  };

  # List services that you want to enable:

  services.getty.autologinUser = "kyle";

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  powerManagement.enable = true;

  ### Open ports in the firewall.
  ##networking.firewall.allowedTCPPorts = [ ... ];
  ##networking.firewall.allowedUDPPorts = [ ... ];

  ### Or disable the firewall altogether.
  ##networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  system.copySystemConfiguration = true;

  ### Enable the gnome-keyring secrets vault
  ### Will be exposed through DBus to programs willing to store secrets
  ##system.gnome.gnome-keyring.enable = true;

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
