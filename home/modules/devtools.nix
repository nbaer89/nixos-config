{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Python / uv
    basedpyright
    black
    isort
    python3Packages.debugpy
    ruff
    ty
    uv
    python3

    # Rust
    rustup
    cargo
    rust-analyzer

    # Nix / Lua / editor tooling
    lua-language-server
    nixd
    nixfmt
    nodejs
    stylua
    tree-sitter

    # Containers
    docker
    docker-compose

    # Remote/dev quality of life
    gh
    jujutsu
    openssh
    rsync

    # CUSTOMIZE: Add pi.dev package here once the exact package/tool is confirmed.
    # Example format:
    # some-package-name
  ];
}
