How to install NixOs on Htzner VPS

✅ Modern NixOS Install on Hetzner VPS (UEFI, systemd-boot)

1. Become root
```bash
sudo -i
```

2. Partition disk (GPT + ESP + root)
```bash
umount -R /mnt || true

parted /dev/sda --script \
mklabel gpt \
mkpart ESP fat32 1MiB 513MiB \
set 1 esp on \
mkpart primary ext4 513MiB 100%
```

3. Format partitions
```bash
mkfs.fat -F32 -n EFI /dev/sda1
mkfs.ext4 -L nixos /dev/sda2
```

4. Mount
```bash
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount /dev/disk/by-label/EFI /mnt/boot
```
Verify:
```bash
/mnt → ext4
/mnt/boot → vfat
```

5. Generate config
```bash
nixos-generate-config --root /mnt
```

6. Ensure UEFI bootloader settings
```bash
nano /mnt/etc/nixos/configuration.nix
```
Make sure this exists (add if missing):
```bash
boot.loader.systemd-boot.enable = true;
boot.loader.efi.canTouchEfiVariables = true;
boot.loader.efi.efiSysMountPoint = "/boot";
```
(Remove any GRUB lines if present.)

7. Install
```bash
nixos-install --no-root-passwd
```

8. Set admin password
```bash
nixos-enter --root /mnt
passwd admin
exit
```

9. poweroff
```bash
poweroff
```
Unmount iso in Hetzner console

10. Operate via Github (GitHub is your source of truth)
on the server:
```bash
sudo mkdir -p /etc/nixos-repo
sudo chown -R root:root /etc/nixos-repo
sudo chmod 700 /etc/nixos-repo
sudo git clone <your-repo-url> /etc/nixos-repo
```
Then symlink (optional but tidy):
```bash
sudo rm -rf /etc/nixos
sudo ln -s /etc/nixos-repo/hosts/myhetzner /etc/nixos
```

Now updates are:
```bash
cd /etc/nixos-repo
sudo git pull --ff-only
sudo nixos-rebuild switch
```

# Channels
```bash
sudo nix-channel --add https://nixos.org/channels/nixos-25.11 nixos
sudo nix-channel --update
sudo nixos-rebuild switch --upgrade
```
