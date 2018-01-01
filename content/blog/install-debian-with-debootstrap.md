+++
title = "Install Debian with debootstrap"
draft = false
date = "2017-12-31T19:26:03-05:00"
description = "How I installed Debian from another GNU/Linux installation, no installer needed"
+++

A driver on Ubuntu 16.04 was giving me some trouble, so I wanted to
quickly install Debian sid on an external hard drive to see if later
versions of Debian/Ubuntu fixed the issue. However, I didn't want to
bother with downloading and booting from an installer disc, so took the
following [chroot][1] approach.

This bootstrap-and-chroot process isn't new and is documented in bits
and pieces all over the web ([some other distributions][4] even use it
as their official install process!) but I wanna put all the steps for
Debian here, in one place. For my personal reference, at least.

 1. **Partition the disk**

    I used [gparted][2] for this since I was feeling lazy, but all I had
    to do was shrink an existing NTFS partition, create a new partition,
    and format it as ext4.

 2. **Mount the partition**

    So that I could chroot into the disk, create a mountpoint and mount
    it (the device was `/dev/sda2` in this case):

        # mkdir /mnt/sid
        # mount /dev/sda2 /mnt/sid

 3. **Bootstrap the partition**

    Then, I installed a base Debian sid system to the partition. This
    will take a while.

        # debootstrap sid /mnt/sid/ http://www.gtlib.gatech.edu/pub/debian/

 4. **Chroot in**

    Now I've got a system I can [chroot][1] into, which is nice, but it
    doesn't won't have a kernel or anything, so it's not something I can
    boot into really. The first step to fixing this is to chroot in:

        # mount -t sysfs sysfs /mnt/sid/sys
        # mount -t proc proc /mnt/sid/proc
        # mount -o bind /dev /mnt/sid/dev
        # chroot /mnt/sid/dev bash

 5. **Configure system**

    At the least, you gotta tell a new system where to find the root
    filesystem, what its hostname is, what its timezone is, what
    [locale][3] to use, and the root password.

    You can find the UUID used below by running `blkid` in the chroot or
    on the host. And I chose `en_US.UTF-8 UTF-8` as my locale when
    prompted.

        (chroot)# printf 'UUID=0592bfeb-0f9a-415f-be4a-b10948b25e63 / ext4 errors=remount-ro 0 1\n' >/etc/fstab
        (chroot)# printf 'pretentiousanimehostname\n' >/etc/hostname
        (chroot)# printf '127.0.0.1\tpretentiousanimehostname\n'>>/etc/hosts
        (chroot)# ln -sf /usr/share/zoneinfo/America/New_York /etc/localtime
        (chroot)# dpkg-reconfigure locales
        (chroot)# passwd

 6. **Install nonfree packages**

    By default, `debootstrap` configures the package manager not to
    install nonfree packages. I needed some wireless firmware, so I
    changed the following line in `/etc/apt/sources.list`:

        deb http://www.gtlib.gatech.edu/pub/debian sid main

     to

        deb http://www.gtlib.gatech.edu/pub/debian sid main contrib non-free

    and then ran

        (chroot)# apt-get update

    Then I could install whatever gross nonfree stuff I needed, like
    `apt-get install firmware-atheros` for my wireless card firmware.

 7. **Install packages**

    Now, install the good stuff:

        (chroot)# apt-get install vim tmux htop sudo gnome linux-image-amd64 initramfs-tools

    The last two are really the most important ones here, at least for
    getting the dang thing to boot. In particular, installing
    `initramfs-tools` should generate an initramfs, which you'll need to
    boot.

 8. **Create your user**

    Finally, I created my user account:

        (chroot)# adduser austin

    Since I installed sudo above and wanted to actually use it, I put
    myself in the `sudo` group:

        (chroot)# usermod -aG sudo austin

 9. **Update bootloader**

    The system from which I was doing all this already had a bootloader,
    GRUB 2, which has really nice autodetection, so I all I had to use
    it to boot my system was (on the original system, not the chroot):

        # update-grub

    (which is equivalent to `grub-mkconfig -o /boot/grub/grub.cfg`)

 10. **Reboot!**

     Then I simply rebooted and chose my new installation at the GRUB
     menu! Tada!

[1]: https://en.wikipedia.org/wiki/Chroot
[2]: https://gparted.org/
[3]: https://en.wikipedia.org/wiki/Locale_(computer_software)#POSIX_platforms
[4]: https://wiki.archlinux.org/index.php/installation_guide
