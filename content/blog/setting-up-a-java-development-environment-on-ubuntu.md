+++
date = "2016-08-29T15:38:20-04:00"
draft = false
title = "Setting Up a Java Development Environment on Ubuntu"
unlisted = true
+++

On GNU/Linux, I suggest using the [OpenJDK][1], a [free][2]
implementation of Java, and [IntelliJ][3], so this guide will use both.

First Steps
===========

Getting a Compatible Release
----------------------------

You'll need to install (or upgrade to) a recent release of Ubuntu to
install Java 8. 14.04, for instance, has only Java 7. As the time of
writing, 16.04 LTS is the most recent, so I'd suggest that.

If you have an earlier release installed, run:

    $ sudo do-release-upgrade

Otherwise, download Ubuntu 16.04 (or a later release) from [the download
page][7] and install it.

Updating the Package Cache & Packages
-------------------------------------

To ensure we don't have a stale package list or out-of-date packages:

    $ sudo apt-get update && sudo apt-get upgrade

This isn't really necessary, but it won't hurt.

OpenJDK
=======

In a shell, install the OpenJDK and optionally OpenJFX:

    $ sudo apt-get install openjdk-8-jdk openjfx

IntelliJ
========

Unfortunately, IntelliJ is [not packaged in Ubuntu][4], so you'll need
to download the [tarball][6] directly from JetBrains at the [IntelliJ
download page][5]. Choose the Community edition; Ultimate, the nonfree
edition with additional features, costs money.

Create an installation directory in your homedir. I chose
`~/bin/intellij`:

    $ mkdir -p ~/bin/intellij

Then extract the tarball you downloaded from [the downloads page][5]
into the install directory:

    $ tar xf ~/Downloads/ideaIC-*.tar.gz -C ~/bin/intellij

Now, run the install script:

    $ cd ~/bin/intellij/idea-IC-*/bin/
    $ ./idea.sh

IntelliJ should start up. If it doesn't create application menu
shortcuts on its own, you tell it to create them by choosing "Tools" →
"Create Desktop Entry..." in the top menu.

[1]: https://en.wikipedia.org/wiki/OpenJDK
[2]: https://en.wikipedia.org/wiki/Free_software
[3]: https://en.wikipedia.org/wiki/IntelliJ_IDEA
[4]: http://packages.ubuntu.com/search?keywords=intellij&searchon=names&suite=xenial&section=all
[5]: https://www.jetbrains.com/idea/download/#section=linux
[6]: https://en.wikipedia.org/wiki/Tar_%28computing%29 
[7]: http://www.ubuntu.com/download
