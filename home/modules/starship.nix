{ config, pkgs, ... }:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    # CUSTOMIZE: Prompt styling lives here.
    settings = {
      add_newline = false;

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };

      directory = {
        truncation_length = 4;
        truncate_to_repo = true;
      };

      docker_context.disabled = false;
      nix_shell.disabled = false;
      rust.disabled = false;
      python.disabled = false;
    };
  };
}
