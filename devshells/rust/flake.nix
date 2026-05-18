{
  description = "Rust project dev shell";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs = { nixpkgs, ... }:
  let
    system = "x86_64-linux"; # CUSTOMIZE if needed.
    pkgs = import nixpkgs { inherit system; };
  in {
    devShells.${system}.default = pkgs.mkShell {
      packages = with pkgs; [
        rustup
        rust-analyzer
        pkg-config
        openssl
        uv
      ];

      shellHook = ''
        echo "Rust dev shell ready"
      '';
    };
  };
}
