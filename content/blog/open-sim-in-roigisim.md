+++
date = "2018-01-24T10:20:07-05:00"
draft = false
title = "Opening .sim files in Roigisim (CircuitSim)"
description = "Run a bunch of weird commands to see pretty icons, it's great"
unlisted = true
+++

On GNU/Linux, to make `.sim` files have a [Roigisim][1] icon and open in
Roigisim, run the following (except replace `1.6.0` with [the version
you want][2]):

    curl -Ls https://austinjadams.com/img/blog/open-sim-in-roigisim/roigisim-setup.sh | bash -s 1.6.0

After the script completes, log out and log back in, just in case.

This is a copy-paste job of [my earlier script for Brandonsim][3].

[1]: https://github.com/ra4king/circuitsim
[2]: https://www.roiatalla.com/public/CircuitSim/Linux/
[3]: {{< relref "open-circ-in-brandonsim.md" >}}
