{ config, pkgs, ... }:

{
  programs.eza = {
    enable = true;
    icons = "auto";
    git = true;
  };

  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };
}
