{ config, pkgs, username, ... }:

{
  imports = [
    # CUSTOMIZE: Generate this on the target machine with:
    # sudo nixos-generate-config --root /
    ./hardware-configuration.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  nix.optimise.automatic = true;

  # CUSTOMIZE: Change hostname for each machine.
  networking.hostName = "devbox";

  # CUSTOMIZE: Set your timezone.
  time.timeZone = "America/Los_Angeles";

  # Base user.
  users.users.${username} = {
    isNormalUser = true;
    description = "Nathan Baer"; # CUSTOMIZE
    shell = pkgs.zsh;
    extraGroups = [
      "wheel"
      "docker"
    ];

    # CUSTOMIZE: Prefer SSH keys over passwords on remote dev boxes.
    # Paste your public keys here, not private keys.
    openssh.authorizedKeys.keys = [
      # "ssh-ed25519 AAAA... your-key-comment"
    ];
  };

  security.sudo.wheelNeedsPassword = true;

  programs.zsh.enable = true;

  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  # Permissive remote-dev policy: SSH, common web ports, high TCP dev ports,
  # and Mosh's default UDP range.
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      22
      80
      443
    ];
    allowedTCPPortRanges = [
      {
        from = 1024;
        to = 65535;
      }
    ];
    allowedUDPPortRanges = [
      {
        from = 60000;
        to = 61000;
      }
    ];
  };

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;

    # CUSTOMIZE: Uncomment if you want Docker data somewhere else.
    # daemon.settings = {
    #   data-root = "/var/lib/docker";
    # };
  };

  # System-wide packages: tools useful even before Home Manager loads.
  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    vim
    neovim
    htop
    btop
    ripgrep
    fd
    jq
    unzip
    gcc
    gnumake
    pkg-config
    docker-compose
  ];

  # CUSTOMIZE: Keep this at the version from your original install.
  # Do not casually change after deployment.
  system.stateVersion = "25.05";
}
