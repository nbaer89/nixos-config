{ config, pkgs, username, ... }:

{
  home.username = username;
  home.homeDirectory = "/home/${username}";

  imports = [
    ../../home/modules/cli.nix
    ../../home/modules/git.nix
    ../../home/modules/zsh.nix
    ../../home/modules/starship.nix
    ../../home/modules/zellij.nix
    ../../home/modules/devtools.nix
  ];

  # CUSTOMIZE: User-level packages belong here or in modules under home/modules.
  home.packages = with pkgs; [
    lazygit
    just
    tree
    fzf
    bat
  ];

  programs.home-manager.enable = true;

  # CUSTOMIZE: Keep this aligned with the Home Manager release you started with.
  home.stateVersion = "25.05";
}
