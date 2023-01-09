+++
date = "2020-12-02T23:04:45-08:00"
draft = false
title = "Fixing Spotify on HiDPI on Ubuntu"
description = "Some notes on how to use Spotify on Ubuntu without needing a telescope"
hasmath = false
unlisted = true
+++

HI!!! Whoops, my bad

The [official "Spotify for Linux" page][1] states:

> Spotify for Linux is a labor of love from our engineers that wanted to
> listen to Spotify on their Linux development machines. They work on it
> in their spare time and it is currently not a platform that we
> actively support.

These brave engineers should be commended ...for their incredible
eyesight:

{{< figure src="/img/blog/spotify-hidpi-ubuntu/music-streaming-for-ants.png" alt="Screenshot of tiny Spotify" link="/img/blog/spotify-hidpi-ubuntu/music-streaming-for-ants.png" target="_blank" >}}

For those of us with HiDPI displays, here's how to make the Spotify UI
readable on Ubuntu. I installed the `spotify` snap package, so these
notes assume you have too.

 1. Create the user desktop entries directory:

        mkdir -p ~/.local/share/applications
        cd ~/.local/share/applications

 2. Copy the snap Spotify `.desktop` entry to your user desktop entries directory ([source for this approach][2]):

        cp -nrv /var/lib/snapd/desktop/applications/spotify_spotify.desktop .

 3. I changed the following two lines of `spotify_spotify.desktop`:

        Icon=/snap/spotify/43/usr/share/spotify/icons/spotify-linux-128.png
        Exec=env BAMF_DESKTOP_FILE_HINT=/var/lib/snapd/desktop/applications/spotify_spotify.desktop /snap/bin/spotify %U

    to the following:

        Icon=/snap/spotify/current/usr/share/spotify/icons/spotify-linux-128.png
        Exec=env BAMF_DESKTOP_FILE_HINT=/home/austin/.local/share/applications/spotify_spotify.desktop /snap/bin/spotify --force-device-scale-factor=2 %U

    Note the [`--force-device-scale-factor=2` flag][3] at the end there.
    It could be something other than 2 for you, depending on your
    display configuration.

 4. Now if you close Spotify and log out and log back in, you should
    hopefully be able to actually see things when you reopen Spotify.
    (If you use GNOME and don't want to log out, you can do Alt-F2 and
    run `r` to reload GNOME Shell.)

[1]: https://www.spotify.com/us/download/linux/
[2]: https://forum.snapcraft.io/t/overriding-desktop-files-on-ubuntu-snaps/6599/2
[3]: https://community.spotify.com/t5/Desktop-Linux/Feature-Request-Fix-HiDPI-scaling-in-linux/m-p/2257705/highlight/true#M3028

<style>
    #content figure img {
        max-width: 100%;
    }
</style>
