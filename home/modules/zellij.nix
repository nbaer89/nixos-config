{ config, pkgs, ... }:

{
  programs.zellij = {
    enable = true;

    # CUSTOMIZE: This is intentionally simple.
    # You can replace this with a full config.kdl using xdg.configFile below.
    settings = {
      theme = "default";
      default_shell = "zsh";
      pane_frames = false;
    };
  };

  # CUSTOMIZE: Bake a complete zellij config if desired.
  # xdg.configFile."zellij/config.kdl".source = ../../dotfiles/zellij/config.kdl;
}
