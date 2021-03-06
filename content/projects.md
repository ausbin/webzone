+++
type = "info"
date = "2017-02-21T14:14:38-05:00"
draft = false
title = "Projects"
description = "My personal projects"
+++

You can check my [github][1] or [cgit][2] for a complete list of my free
software projects, but here are the highlights:

1. [zucchini][p0]: An extensible Python autograding framework used in CS
   2110\. Connects with the [Canvas][13] API to auto-upload grades and
   grade logs, and can auto-generate autograder .zips for [Gradescope
   Cloud Autograding][15].
2. [nsdo][p1]: A simple C program for running particular applications in [Linux
   network namespaces][3]. With some system configuration I've described in
   blog posts ([OpenVPN][4], [Cisco AnyConnect][5]), you can use it to run
   particular applications in VPNs.
3. [novice][p2]: A work-in-progress assembler written in
   [TypeScript][14] which hopes to bring the convenience of the current
   tools used in CS 2110 for teaching assembly language to platforms
   other than GNU/Linux and to classes with other ISAs, such as CS 2200
4. [gong][p3]: A prototype git repository viewer written in [Go][6] intended to
   be a reboot of [cgit][7] for my personal use cases.
5. [toolbag][p4]: Some Go tools for my website ([link to live instance][8]),
   which include a web frontend to [figlet][9] and a silly 404 generator.
6. [mccmd][p5]: Tinkering with running a Minecraft server in [systemd][10].
   Includes a systemd unit for the Minecraft server plus a Java [Bukkit][11]
   plugin and client C program for issuing server commands.
7. [This Website][p6], which is statically generated using [Hugo][12].

[1]: https://github.com/ausbin/
[2]: https://code.austinjadams.com/
[3]: https://lwn.net/Articles/580893/
[4]: {{< ref "blog/running-select-applications-through-openvpn.md" >}}
[5]: {{< ref "blog/running-select-applications-through-anyconnect.md" >}}
[6]: https://golang.org/
[7]: https://git.zx2c4.com/cgit/about/
[8]: /tools
[9]: http://www.figlet.org/
[10]: https://www.freedesktop.org/wiki/Software/systemd/
[11]: https://bukkit.org/
[12]: https://gohugo.io/
[13]: https://www.canvaslms.com/
[14]: https://www.typescriptlang.org/
[15]: https://gradescope-autograders.readthedocs.io/

[p0]: https://github.com/zucchini/zucchini
[p1]: https://github.com/ausbin/nsdo
[p2]: https://github.com/zucchini/novice
[p3]: https://github.com/ausbin/gong
[p4]: https://github.com/ausbin/toolbag
[p5]: https://github.com/ausbin/mccmd
[p6]: https://github.com/ausbin/webzone
