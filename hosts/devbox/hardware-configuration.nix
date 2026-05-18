{ lib, ... }:

{
  # Placeholder for local flake evaluation.
  #
  # Before deploying, replace this file with the target machine's generated
  # hardware configuration:
  #
  #   sudo nixos-generate-config --root /
  #
  # The generated file should define the target's fileSystems, swapDevices,
  # boot initrd modules, and other hardware-specific settings.
  fileSystems."/" = lib.mkDefault {
    device = "/dev/disk/by-label/nixos";
    fsType = "ext4";
  };

  boot.loader.grub.devices = lib.mkDefault [ "/dev/sda" ];
}
