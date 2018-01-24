+++
date = "2017-08-22T09:23:22-04:00"
draft = false
title = "Opening .circ files in Brandonsim"
description = "Run a bunch of weird commands to see pretty icons, it's great"
unlisted = false
+++

Sometimes you gotta have pretty icons and pretty buttons, y'know? In the case of Brandonsim on GNU/Linux, specifically to give it and `.circ` files pretty icons which open Brandonsim when clicked, do one of the following:

Option 1: Use a Script
----------------------

Download `Brandonsim-X.Y.Z.jar` from T-Square, put it somewhere permanent (moving it will break the files the script creates), and run the following command:

    curl -Ls https://austinjadams.com/img/blog/open-circ-in-brandonsim/brandonsim-setup.sh | bash

After the script completes, log out and log back in, just in case.

Option 2: By Hand
-----------------

If you don't like piping random shell scripts from the internet into a shell,
you can do the following instead:

1. Run `mkdir -p ~/.local/share/applications/ ~/.local/share/mime/packages/`
2. Install icons stolen from [Brandon's Brandonsim repo][1] by running:

        tmpfile=$(mktemp --suffix=.png); for size in 16 20 24 48 64 128; do curl -L https://austinjadams.com/img/blog/open-circ-in-brandonsim/brandonsim-icon-$size.png -o "$tmpfile" && xdg-icon-resource install --size $size "$tmpfile" brandonsim-icon; done; rm "$tmpfile"

3. Create `~/.local/share/mime/packages/brandonsim.xml` with the following contents:

        <?xml version="1.0" encoding="UTF-8"?>
        <mime-info xmlns='http://www.freedesktop.org/standards/shared-mime-info'>
          <mime-type type="application/brandonsim">
            <comment>Brandonsim circuit</comment>
            <glob pattern="*.circ"/>
            <icon name="brandonsim-icon"/>
          </mime-type>
        </mime-info>

4. Run `update-mime-database ~/.local/share/mime`
5. Create `~/.local/share/applications/brandonsim.desktop` with the following
   contents, except with _your_ path to the Brandonsim jar instead of
   `/PATH/TO/YOUR/Brandonsim-2.7.4.jar`:

        [Desktop Entry]
        Version=1.0

        Type=Application
        Name=Brandonsim
        Icon=brandonsim-icon
        GenericName=Logic circuit simulator
        Comment=Digital logic circuit simulator
        Categories=Development
        MimeType=application/brandonsim;
        Exec=java -jar /PATH/TO/YOUR/Brandonsim-2.7.4.jar %U
        Terminal=false
        StartupWMClass=com-cburch-logisim-Main

6. Run `xdg-mime default brandonsim.desktop application/brandonsim`

Might need to log out and log back in somewhere in there, YMMV. Just [restarting gnome-shell][2] at the end worked for me.

[1]: https://github.com/TricksterGuy/Brandonsim/tree/master/resources/logisim/img
[2]: http://askubuntu.com/a/496999/369541
