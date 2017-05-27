+++
date = "2017-02-28T17:24:44-05:00"
title = "Including a List of Recent git Commits in a Hugo page"
draft = false
description = "How I made my Hugo homepage include a list of recent commits"
+++

When redesigning my website recently, I realized I needed some meat on
my homepage. Ideally, instead of a blank space, I could show off stuff
I'm working on without having to maintain my show-off list by hand. Two
ideas came to mind: recent blog posts and recent git commits.

Since I already stored my blog posts in the static site generator
[Hugo][8], adding them to the homepage took me only a few minutes. But
since Hugo provides no way of interfacing with git repositories, adding
my git commits was much more challenging and, of course, much more fun.

On a high level, my solution works like the following:

 1. A script runs, which scans my git repositories for recent commits
    and generates Hugo content files for them.
 2. *Then* I run Hugo, and my Hugo templates can access the commits
 3. Whenever I push to one of my git repositories, rebuild the site.
    (This currently takes less than a tenth of a second.)

Part 1: The Script
==================

Named after the station inspector played by Sacha Baron Cohen in
[*Hugo*][3] (for a weak attempt at humor), [gustave][2] is about 400
lines of C (for speed) which uses [libgit2][1] (for convenience).

Because I [use cgit for hosting my git repositories][4], gustave reads
the list of repository paths to check from `/etc/cgitrc` ([manpage][5]),
ignoring those with `repo.hide=1`. With the git repositories to check
down, there's one thing left for the script to do:

Finding Recent Commits in a git Repository
------------------------------------------

Unlike in version control systems like Subversion which have a linear
revision history, git commits form a a directed acyclic graph by
pointing to their parents. Consequently, to find the most recent N git
commits, you can't simply walk backwards from the most recent one.
Instead, you have to traverse the graph starting from the commit to
which the target branch points.

The following diagram shows a real example [from the repository where
this blog is stored][6]. Notice the commit [cf7a0d083c][7] has two
parents!

![Diagram of my webzone repository][i1]

My first idea for traversal was brute force; that is, looking at every
dang commit in the repository and then sorting them by date. However,
for gigantic repositories like the Linux kernel, this approach searches
much more of the commit graph than necessary.

To inspect as little of the graph as possible while still finding recent
commits, I settled on a [breadth-first search][9] which stops after
examining 32 commits. This allows for examining as much of the graph as
possible nearby the starting commit without going too deep into old
stuff.

I then combine each set of 32 commits from each repository into one big
array, and sort the whole array by date, writing the latest 8 as Hugo
content.

Part 2: Reading the Commits in a Hugo Template
==============================================

Gustave writes content files that look like the following
(`content/commit/c01b6580a0.md`):

    +++
    type = "commit"
    date = "2017-03-05T00:15:07-00:00"
    draft = false
    hash = "c01b6580a07b138f0f22b130a101b1582cecd72f"
    summary = "style.css: Center images in posts"
    repo = "webzone"
    +++

So in a template, you can write something like (copy-paste incoming):

    <ul>
      {{ range first 8 (where .Site.Pages "Section" "=" "commit") }}
        <li>
          <div class="recent-git-meta">
              <a href="https://code.austinjadams.com/{{ .Params.repo }}/">{{ .Params.repo }}</a>
              <span class="recent-date">{{ .Date.Format "2006-01-02" }}:</span>
          </div>
          <a class="recent-git-summary" href="https://code.austinjadams.com/{{ .Params.repo }}/commit/?id={{ .Params.hash }}">{{ .Params.summary }}</a>
        </li>
      {{ end }}
    </ul>

Just like with any other type of content in Hugo!

Part 3: Regenerating the Site after a Push
==========================================

I already wrote [a post about regenerating Hugo sites with git
hooks][10], so I only needed to make some small changes to my
post-receive hook to make it work when called from any repository.

    #!/bin/bash
    set -e

    # Change to the repository with the site to rebuild
    siterepo=/path/to/webzone/repo
    pushd "$siterepo"

    worktree="$(mktemp -d)"
    desttmp=/var/www/webzone
    destlink="$desttmp/HEAD"
    destlinktmp="$destlink.tmp"
    destdir="$desttmp/$(git rev-parse HEAD)"
    # Important change from the old script: Don't assume this generation
    # has a different commit in the webzone repo than the last — this
    # push is not necessarily an update to the webzone repo!
    destdir="$(mktemp -p "$desttmp" -d "$(git rev-parse HEAD).XXXXXXXXXX")"
    olddestdir="$(readlink -e "$destlink" || true)"

    # Create a temporary working tree and delete it
    # after building the site
    GIT_WORK_TREE="$worktree" git checkout -f
    pushd "$worktree"
        # Run gustave to generate commit content files
        mkdir content/commit
        gustave
        hugo --destination="$destdir"
    popd
    rm -rvf "$worktree"

    # Point to the new version of the site (atomically!)
    # and delete the old version of the site
    ln -svnrf "$destdir" "$destlinktmp"
    # Use rename(2), which is atomic
    mv -Tv "$destlinktmp" "$destlink"
    rm -rvf "$olddestdir"

Then I simply added this as a post-receive hook to all the git
repositories that I wanted to update my homepage upon receving a push.
(In truth, to make the situation less messy, I made it a binary in
`/usr/local/bin` called by the post-receive hook in every repository.)

[1]: https://libgit2.github.com/
[2]: https://code.austinjadams.com/gustave/
[3]: https://en.wikipedia.org/wiki/Hugo_(film)
[4]: https://code.austinjadams.com/
[5]: https://git.zx2c4.com/cgit/tree/cgitrc.5.txt
[6]: https://code.austinjadams.com/webzone/commit/?id=1b60a667d22d7f5665c7e25fd027249a22dbbc7f
[7]: https://code.austinjadams.com/webzone/commit/?id=cf7a0d083caabd4e237ad8fd688381df8185a114
[8]: https://gohugo.io/
[9]: https://en.wikipedia.org/wiki/Breadth-first_search
[10]: {{< ref "blog/using-git-to-deploy-a-hugo-blog-atomically.md" >}}

[i1]: /img/blog/including-recent-commits-hugo/commit-diagram.svg
