+++
type = "info"
date = "2017-02-21T14:14:38-05:00"
draft = false
title = "Projects"
description = "My personal projects"
+++

You can check my [github][1] or [cgit][2] for a complete list of my free
software projects, but here are the highlights:

1. [nsdo][p1]: A simple C program for running particular applications in [Linux
   network namespaces][3]. With some system configuration I've described in
   blog posts ([OpenVPN][4], [Cisco AnyConnect][5]), you can use it to run
   particular applications in VPNs.
2. [gong][p2]: A prototype git repository viewer written in [Go][6] intended to
   be a reboot of [cgit][7] for my personal use cases.
3. [toolbag][p3]: Some Go tools for my website ([link to live instance][8]),
   which include a web
   frontend to [figlet][9] and a silly 404 generator.
4. [mccmd][p4]: Tinkering with running a Minecraft server in [systemd][10].
   Includes a systemd unit for the Minecraft server plus a Java [Bukkit][11]
   plugin and client C program for issuing server commands.
5. [This Website][p5], which is statically generated using [Hugo][12].

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
[12]: https://gohugo.io/

[p1]: https://github.com/ausbin/nsdo
[p2]: https://github.com/ausbin/gong
[p3]: https://github.com/ausbin/toolbag
[p4]: https://github.com/ausbin/mccmd
[p5]: https://github.com/ausbin/webzone
