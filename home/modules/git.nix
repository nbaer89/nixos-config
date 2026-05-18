{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;

    # CUSTOMIZE: Your Git identity.
    userName = "Nathan Baer";
    userEmail = "nathan@whittingtonelectric.com";

    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = false;
      push.autoSetupRemote = true;
    };
  };
}
