+++
date = "2016-08-14T18:37:12-04:00"
draft = false
title = "Using git to Deploy a Hugo Blog... Atomically!"
+++

For years, I've been meaning to set up a blog, but characteristically I
couldn't muster the effort to even try. Yesterday, however, I found
[Hugo][1], a simple but useful static site generator, and finally
decided to stop being lazy.

Despite the benefits (and despite writing [a surprisingly similar
tool][2] myself ~4 years ago), I'd never felt drawn to static site
generation. Often, I got stuck on how to (1) copy my changed content
over to the webserver and (2) how to do it [atomically][3]. That is,
when I update my blog, how do I easily delete the old files and copy
over the new ones without any time period, however brief, during which
some of the files are missing?

(For example, simply `rm -r`ing `/my/docroot/blog/*` and then copying in
the new files won't work because between the time you delete some page X
and copy it over, requests to X will 404.)

My answer, of course, is git combined with ~~a kludgey atrocity~~ some
elegant git hooks!

# The Process

 1. Locally, I change the source files for the site, which live in [a git
    repository][4]
 2. I commit my changes and push them over SSH to a bare git repository
    on the server
 3. On the server, the [git `post-receive` hook][5] runs, which:
    1. Checks out the new `HEAD` in a temporary directory
    2. `cd`s into the temporary directory and runs Hugo with another new
       directory as the destination
    3. Replace the symlink from `/my/docroot/blog` to the old
       destination with a new symlink pointing to the new destination.
       Using the [`rename(2)`][6] syscall via `mv` makes this atomic.

Because I host [cgit][4] and this blog on the same server, I reused the
existing public, bare repository as the remote repo which has the hook.
And because I like to keep my docroot tidy, my hook creates all of the
directories and links mentioned above in a separate directory,
`/var/www/blog/`.

Here's my `hooks/post-receive`:

    #!/bin/bash
    set -e

    # Store the built site snapshots outside of the docroot
    destroot=/var/www/blog
    destlink="$destroot/HEAD"
    destlinktmp="$destlink.tmp"
    # Use the SHA-1 of the current commit to name the new
    # destination directory
    destdir="$destroot/$(git rev-parse HEAD)"
    olddestdir="$(readlink -e "$destlink" || true)"
    worktree="$(mktemp -d)"
    
    # Create a temporary working tree and delete it
    # after building the site
    GIT_WORK_TREE="$worktree" git checkout -f
    pushd "$worktree"
        hugo --destination="$destdir"
    popd
    rm -rvf "$worktree"
    
    # Point to the new version of the site (atomically!)
    # and delete the old version of the site
    ln -svnrf "$destdir" "$destlinktmp"
    # Use rename(2), which is atomic
    mv -Tv "$destlinktmp" "$destlink"
    rm -rvf "$olddestdir"

Then I simply point my HTTP server to the symlink, `/var/www/blog/HEAD`,
like (in the case of nginx):

    location /blog {
        alias /var/www/blog/HEAD/;
    }

Tada! Now I can just `git push` to deploy changes to my blog.

## A Warning on `ln -f` versus `mv`

My hook above creates a temporary link and uses `mv` to replace the old
link with it. Why not use `ln -f`?

Well, as [Tom Moertel pointed out][7] back in 2005, `ln -f` ain't
atomic, at least with GNU coreutils on the Linux kernel. The following
`strace` output for `ln -s /x/y/z foo` confirms this:

    symlink("/x/y/z", "foo") = -1 EEXIST (File exists)
    unlink("foo")            = 0
    symlink("/x/y/z", "foo") = 0

So instead, I (and Tom) would suggest creating a temporary symlink and
then moving it into place using `mv`, which uses `rename(2)`, an atomic
operation according to [the manpage][6]. `strace` output from `mv -T
foo.tmp foo`:

    rename("foo.tmp", "foo") = 0

[1]: https://gohugo.io/
[2]: https://github.com/ausbin/sandvich
[3]: https://en.wikipedia.org/wiki/Atomicity_%28database_systems%29
[4]: https://code.austinjadams.com/blog
[5]: https://git-scm.com/book/en/v2/Customizing-Git-Git-Hooks#Server-Side-Hooks
[6]: http://man7.org/linux/man-pages/man2/rename.2.html
[7]: http://blog.moertel.com/posts/2005-08-22-how-to-change-symlinks-atomically.html
