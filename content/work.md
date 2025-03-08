+++
type = "info"
date = "2017-02-21T14:14:38-05:00"
draft = false
title = "My Work"
description = "Listing of my humble projects and publications"
+++

<style>
strong {
  color: #555;
  font-weight: bold;
  text-decoration: none;
}
.smallcaps {
  font-variant-caps: small-caps;
}
</style>

Selected publications (for more, see my [Google Scholar profile][16]):

1. Austin J. Adams, Sharjeel Khan, Arjun S. Bhamra, Ryan R. Abusaada, Anthony M. Cabrera, Cameron C. Hoechst, Travis S. Humble, Jeffrey S. Young, and Thomas M. Conte.
   "[<span class="smallcaps">Asdf</span>: A Compiler for Qwerty, a Basis-Oriented Quantum Programming Language][pub3]."
   _2025 IEEE/ACM International Symposium on Code Generation and Optimization (CGO '25)_. March 2025. [\[slides\]][pub3slides] [\[artifact\]][pub3artifact] [\[github\]][pub3code]
2. Austin J. Adams, Sharjeel Khan, Jeffrey S. Young, and Thomas M. Conte.
   "[Qwerty: A Basis-Oriented Quantum Programming Language][pub2]." arXiv. April 2024. [\[website\]][pub2website]
3. Austin Adams, Elton Pinto, Jeffrey Young, Creston Herold, Alex McCaskey, Eugene Dumitrescu, and Thomas M. Conte.
   "[Enabling a Programming Environment for an Experimental Ion Trap Quantum Testbed][pub1]." [_2021 IEEE International Conference on Rebooting Computing (ICRC '21)_][pub1venue]. November 2021. [\[slides\]][pub1slides]
4. Austin Adams, Pulkit Gupta, Blaise Tine, and Hyesoon Kim.
   "[Cryptography Acceleration in a RISC-V GPGPU][pub0]." [_Fifth
   Workshop on Computer Architecture Research with RISC-V (Co-located
   with ISCA 2021)_][pub0venue]. June 2021. [\[slides\]][pub0slides]

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
[16]: https://scholar.google.com/citations?user=7xRKdbwAAAAJ

[p0]: https://github.com/zucchini/zucchini
[p1]: https://github.com/ausbin/nsdo
[p2]: https://github.com/zucchini/novice
[p3]: https://github.com/ausbin/gong
[p4]: https://github.com/ausbin/toolbag
[p5]: https://github.com/ausbin/mccmd
[p6]: https://github.com/ausbin/webzone

[pub0]: https://carrv.github.io/2021/papers/CARRV2021_paper_87_Adams.pdf
[pub0venue]: https://carrv.github.io/2021/
[pub0slides]: /img/work/carrv_2021_slides.pdf
[pub1]: https://arxiv.org/abs/2111.00146
[pub1venue]: https://icrc.ieee.org/
[pub1slides]: /img/work/icrc_2021_slides.pdf
[pub2]: https://arxiv.org/abs/2404.12603
[pub2website]: https://qwerty.cc.gatech.edu/
[pub3]: https://dl.acm.org/doi/10.1145/3696443.3708966
[pub3code]: https://github.com/gt-tinker/qwerty/
[pub3artifact]: https://doi.org/10.5281/zenodo.14505385
[pub3slides]: /img/work/cgo_2025_slides.pdf
