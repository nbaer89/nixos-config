{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    shellAliases = {
      ls = "eza --icons --group-directories-first";
      ll = "eza -lah --icons --group-directories-first";
      la = "eza -la --icons --group-directories-first";
      cat = "bat";
      grep = "rg";
      zj = "zellij";
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#devbox";
      test-rebuild = "sudo nixos-rebuild test --flake /etc/nixos#devbox";
    };

    initExtra = ''
      export EDITOR=nvim
      export VISUAL=nvim
      export UV_LINK_MODE=copy
      export PATH="$HOME/.cargo/bin:$PATH"

      # CUSTOMIZE: Auto-start zellij for SSH sessions.
      # Comment this block out if you prefer plain shell on login.
      if [[ -z "$ZELLIJ" && -n "$SSH_CONNECTION" ]]; then
        zellij attach main -c
      fi
    '';
  };
}
