+++
type = "post"
date = "2016-08-22T23:55:03-04:00"
draft = false
title = "Unbricking a TP-Link Archer C7 v2 Router"
description = "How I used tftpd-hpa to unbrick a TP-Link Archer C7 v2 Router"
+++

I'm a pro at using things incorrectly, so of course I'd brick my [Archer
C7 v2][2] a few hours after I got it. Fortunately, however, I didn't
find flashing working firmware too difficult. Here's a quick attempt at
a guide:

 1. Give your machine an IP address of `192.168.0.66/24`, stopping any
    existing network daemons (e.g., NetworkManager). With iproute2 on
    GNU/Linux:

        # systemctl stop NetworkManager
        # ip link set dev eth0 up
        # ip addr add 192.168.0.66/24 dev eth0

 2. Install a [TFTP][3] server. I used `tftpd-hpa`:

        # apt-get install tftpd-hpa
        # systemctl start tftpd-hpa

 3. Put your firmware image in the docroot as
    `ArcherC7v2_tp_recovery.bin`. Debian seems to use `/srv/tftp/` by
    default, so I did something like:

        # cp ~/my/firmware/image /srv/tftp/ArcherC7v2_tp_recovery.bin

 4. Plug your computer into LAN port 1.
 5. Turn off the router with the power button.
 6. Press and hold the WPS/reset button.
 7. Turn the router back on again. When the WPS light lights up and
    stays lit, you can let off the WPS/reset button.
 8. **Tada! With any luck, your router is de-bricked**. To tidy up and
    re-connect:

        # ip addr del 192.168.0.66/24 dev eth0
        # ip link set dev eth0 down
        # systemctl start NetworkManager

I learned most of this from [the OpenWRT wiki][1], which should have
more information.

[1]: https://wiki.openwrt.org/toh/tp-link/archer-c5-c7-wdr7500#tftp_recovery_de-bricking
[2]: https://wiki.openwrt.org/toh/tp-link/archer-c5-c7-wdr7500
[3]: https://en.wikipedia.org/wiki/Trivial_File_Transfer_Protocol
