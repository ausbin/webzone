+++
type = "info"
date = "2017-02-21T14:14:38-05:00"
draft = false
title = "My Work"
description = "Listing of my humble projects and publications"
+++

My humble list of publications:

1. Austin Adams, Elton Pinto, Jeffrey Young, Creston Herold, Alex McCaskey, Eugene Dumitrescu,
and Thomas M. Conte.
   "[Enabling a Programming Environment for an Experimental Ion Trap Quantum Testbed][pub1]." [_2021 IEEE International Conference on Rebooting Computing (ICRC '21)_][pub1venue]. November 2021.
2. Austin Adams, Pulkit Gupta, Blaise Tine, and Hyesoon Kim.
   "[Cryptography Acceleration in a RISC-V GPGPU][pub0]." [_Fifth
   Workshop on Computer Architecture Research with RISC-V (Co-located
   with ISCA 2021)_][pub0venue]. June 2021.

I have also written some free software projects. You can check my
[github][1] for a complete list, but here are the highlights:

1. [nsdo][p1]: A simple C program for running particular applications in [Linux
   network namespaces][3]. With some system configuration described in
   [the README][4], you can use it to run particular applications in VPNs.
2. [zucchini][p0]: An extensible Python autograding framework used in CS
   2110\. Connects with the [Canvas][13] API to auto-upload grades and
   grade logs, and can auto-generate autograder .zips for [Gradescope
   Cloud Autograding][15].
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
[4]: https://github.com/ausbin/nsdo#readme
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

[pub0]: https://carrv.github.io/2021/papers/CARRV2021_paper_87_Adams.pdf
[pub0venue]: https://carrv.github.io/2021/
[pub1]: https://arxiv.org/abs/2111.00146
[pub1venue]: https://icrc.ieee.org/
