{ lib, ... }:

{
  # Placeholder for local flake evaluation.
  #
  # On the target machine, replace this file with the generated hardware config:
  #
  #   sudo nixos-generate-config --root /mnt
  #
  # During install this path is expected to be:
  #
  #   /mnt/etc/nixos/hardware-configuration.nix
  fileSystems."/" = lib.mkDefault {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };
}
