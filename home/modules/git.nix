{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;

    settings = {
      # CUSTOMIZE: Your Git identity.
      user = {
        name = "Nathan Baer";
        email = "nathan@whittingtonelectric.com";
      };

      init.defaultBranch = "main";
      pull.rebase = false;
      push.autoSetupRemote = true;
    };
  };
}
