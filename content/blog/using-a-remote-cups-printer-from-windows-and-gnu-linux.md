+++
date = "2016-08-21T13:05:37-04:00"
draft = false
title = "Using a Remote CUPS Printer from Windows and GNU/Linux"
description = "How I configured CUPS on GNU/Linux to use a printer on a remote CUPS instance"
+++

In my college dorm, my roommate and I have three machines on the same
network:

 1. My laptop (GNU/Linux)
 3. My roommate's laptop (Windows)
 2. My desktop, a headless GNU/Linux server with my printer connected

Because my roommate doesn't have a printer and I often take my laptop
places, I wanted my desktop to act as a print server.

Server Setup
============

 1. Install [CUPS][1] and if you're on systemd, and make sure
    `org.cups.cupsd.service` is enabled and started.
 2. Add printers as needed.

Connecting from Windows with Samba
==================================

Server
------

Install [samba][2] and start+enable `smbd.service` and `nmbd.service`.
Uncomment the `[printers]` section in `/etc/samba/smb.conf` and set it
to something along the lines of:

    [printers]
       comment = All Printers
       path = /var/spool/samba
       browseable = no
       public = yes
       guest ok = yes
       writable = no
       printable = yes
       printing = CUPS

Run `systemctl reload smbd`. CUPS printers on the server should show up
to Windows guests automatically under the same name they have in CUPS.

### Adding a User

In my case, Windows wanted a username+password, so I added an account
named `bob`:

    # useradd -U bob
    # smbpasswd -a bob

But I think this is because I've misconfigured Samba. If I get around to
it, I'll fix my configuration and update this post.

Client (Windows)
----------------

I found the server in Windows Explorer, found my printer, and entered
the credentials for the account I created earlier.

Connecting from GNU/Linux with IPP
==================================

Server
------

To allow other machines to reach the CUPS server hosting the printer,
`/etc/cups/cupsd.conf` needs some modifications.

First, to tell CUPS not to bind on localhost, change

    Listen localhost:631

to

    Listen *:631

Then, so I don't get a [403 (Forbidden) response][3], add `Allow from
192.168.1.*` to each `<Location>` section as follows:


    # Restrict access to the server...
    <Location />
      Order allow,deny
      Allow from 192.168.1.*
    </Location>

    # Restrict access to the admin pages...
    <Location /admin>
      Order allow,deny
      Allow from 192.168.1.*
    </Location>

    ...

Client (GNU/Linux)
------------------

At the local CUPS web interface at <http://localhost:631/>, add a
printer with an IPP URL of `ipp://192.168.1.X/printers/d1660`. **Be sure
to choose the raw driver**; otherwise (in my case) I got a "Filter
failed" error message whenever I tried to print something.

[1]: https://www.cups.org/
[2]: https://www.samba.org/
[3]: https://en.wikipedia.org/wiki/HTTP_403
