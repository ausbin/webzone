+++
type = "info"
date = "2017-02-21T14:14:38-05:00"
draft = false
title = "Projects"
description = "My personal projects"
+++

For a full list of free software I'm working on, see my [github][1] or [cgit][2], but here are the highlights:

1. [nsdo][p1]: A simple C program for GNU/Linux allowing running particular
   applications in [Linux network namespaces][3]. With some system
   configuration I described in blog posts ([1][4], [2][5]), you can use it to
   isolate applications in VPNs.
2. [gong][p2]: A prototype git repository viewer written in [Go][6] intended to
   be a reboot of [cgit][7] for my personal use cases.
3. [toolbag][p3]: Some Go tools for my website ([link][8]), which include a web
   frontend to [figlet][9] and a silly 404 generator.
4. [mccmd][p4]: Tinkering with running a Minecraft server in [systemd][10].
   Includes a systemd unit for the minecraft server and a Java [Bukkit][11]
   plugin plus a client C program for issuing server commands.

[1]: https://github.com/ausbin/
[2]: https://code.austinjadams.com/
[3]: https://lwn.net/Articles/580893/
[4]: {{< ref "blog/running-select-applications-through-openvpn.md" >}}
[5]: {{< ref "blog/running-select-applications-through-anyconnect.md" >}}
[6]: https://golang.org/
[7]: https://git.zx2c4.com/cgit/about/
[8]: /tools/
[9]: http://www.figlet.org/
[10]: https://www.freedesktop.org/wiki/Software/systemd/
[11]: https://bukkit.org/

[p1]: https://github.com/ausbin/nsdo
[p2]: https://github.com/ausbin/gong
[p3]: https://github.com/ausbin/toolbag
[p4]: https://github.com/ausbin/mccmd
