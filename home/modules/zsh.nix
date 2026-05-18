{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    shellAliases = {
      cl = "clear";
      ls = "eza --icons --group-directories-first";
      l = "eza -l --icons --git -a";
      ll = "eza -lah --icons --group-directories-first";
      la = "eza -la --icons --group-directories-first";
      lt = "eza --tree --level=2 --long --icons --git";
      ltree = "eza --tree --level=2 --icons --git";
      cat = "bat";
      grep = "rg";
      vi = "nvim";
      vim = "nvim";
      zj = "zellij";
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#devbox";
      test-rebuild = "sudo nixos-rebuild test --flake /etc/nixos#devbox";
    };

    initContent = ''
      if [[ -f "$HOME/.cargo/env" ]]; then
        source "$HOME/.cargo/env"
      fi

      if [[ -f "$HOME/.local/bin/env" ]]; then
        source "$HOME/.local/bin/env"
      fi

      export NVM_DIR="$HOME/.config/nvm"
      if [[ -s "$NVM_DIR/nvm.sh" ]]; then
        source "$NVM_DIR/nvm.sh"
      fi
      if [[ -s "$NVM_DIR/bash_completion" ]]; then
        source "$NVM_DIR/bash_completion"
      fi

      # CUSTOMIZE: Auto-start zellij for SSH sessions.
      # Comment this block out if you prefer plain shell on login.
      if [[ -z "$ZELLIJ" && -n "$SSH_CONNECTION" ]]; then
        zellij attach main -c
      fi
    '';
  };
}
