{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Python / uv
    uv
    python3

    # Rust
    rustup
    cargo
    rustc
    rust-analyzer

    # Containers
    docker
    docker-compose

    # Remote/dev quality of life
    gh
    openssh
    rsync

    # CUSTOMIZE: Add pi.dev package here once the exact package/tool is confirmed.
    # Example format:
    # some-package-name
  ];
}
