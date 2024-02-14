+++
date = "2024-02-13T18:29:15-05:00"
draft = true
title = "Installing Debian on a VisionFiveV2"
description = "How I installed Debian on a StarFive VisionFiveV2 Board"
hasmath = false
+++

I do not trust the [official download for VisionFiveV2 images][1]
since it is perhaps the most suspicious-looking website I have ever
seen.

Drawn from:
https://wiki.debian.org/InstallingDebianOn/StarFive/VisionFiveV2
https://wiki.debian.org/InstallingDebianOn/StarFive/VisionFiveV1
https://doc-en.rvspace.org/VisionFive2/Quick_Start_Guide/VisionFive2_SDK_QSG/boot_mode_settings.html

Using v6.8-rc4

sudo apt install binutils-riscv64-linux-gnu gcc-riscv64-linux-gnu

export KERNEL_ARCH=riscv

make ARCH=$KERNEL_ARCH defconfig

Enable multicore here:
make ARCH=$KERNEL_ARCH xconfig

make CROSS_COMPILE=riscv64-linux-gnu- ARCH=$KERNEL_ARCH -j$(nproc) bindeb-pkg

results at ../linux*.deb

why sid/unstable below? riscv64 is not available in testing and definitely not bookworm

sudo debootstrap --foreign --arch=riscv64 unstable /tmp/rv-chroot http://mirrors.namecheap.com/debian/

Needed to make riscv binaries runnable in the chroot. thanks binfmt-misc!
sudo apt install qemu-user-static

sudo chroot /tmp/rv-chroot/ /debootstrap/debootstrap --second-stage

gparted with config (mbr):
* 100 MiB unallocated
* 512 MiB fat32
* remaining space ext4 with boot flag set

printf 'UUID=6d11c153-9fe7-4358-bfc6-30553df316f6 / ext4 errors=remount-ro 0 1\n' | sudo tee /tmp/rv-chroot/etc/fstab
printf 'UUID=98B6-537B /boot/efi vfat umask=0077 0 1\n' | sudo tee -a /tmp/rv-chroot/etc/fstab

printf 'hubie\n' | sudo tee /tmp/rv-chroot/etc/hostname

printf '127.0.0.1\thubie\n' | sudo tee -a /tmp/rv-chroot/etc/hosts

mount -t sysfs sysfs /mnt/sid/sys
mount -t proc proc /mnt/sid/proc
mount -o bind /dev /mnt/sid/dev
sudo chroot /tmp/rv-chroot/ /bin/bash
passwd
ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
apt install locales
dpkg-reconfigure locales
dpkg -i the kernel .debs
apt install initramfs-tools
apt install u-boot-menu
printf 'U_BOOT_PARAMETERS="rw console=tty0 console=ttyS0,115200 earlycon rootwait stmmaceth=chain_mode:1 selinux=0"\n' >>/etc/default/u-boot
dpkg-reconfigure linux-image-6.8.0-rc4


sudo mount /dev/mmcblk0p2 /mnt/hubie/
sudo umount /tmp/rv-chroot/dev
sudo umount /tmp/rv-chroot/proc
sudo umount /tmp/rv-chroot/sys
sudo cp -va /tmp/rv-chroot/* /mnt/hubie/
sudo sync

set dip switches
https://doc-en.rvspace.org/VisionFive2/Quick_Start_Guide/VisionFive2_SDK_QSG/boot_mode_settings.html

[1]: https://debian.starfivetech.com/
