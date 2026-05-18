{ config, pkgs, username, ... }:

{
  home.username = username;
  home.homeDirectory = "/home/${username}";

  home.sessionPath = [
    "$HOME/bin"
    "$HOME/.local/bin"
    "$HOME/.cargo/bin"
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_PICTURES_DIR = "$HOME/Pictures";
    XDG_STATE_HOME = "$HOME/.local/state";
    TALOSCONFIG = "$HOME/talos/talosconfig";
    UV_LINK_MODE = "copy";
  };

  imports = [
    ../../home/modules/cli.nix
    ../../home/modules/git.nix
    ../../home/modules/pi.nix
    ../../home/modules/zsh.nix
    ../../home/modules/starship.nix
    ../../home/modules/zellij.nix
    ../../home/modules/devtools.nix
    ../../home/modules/nvim.nix
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
