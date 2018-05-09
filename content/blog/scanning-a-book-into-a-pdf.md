+++
date = "2018-05-08T17:55:38-04:00"
draft = false
title = "Scanning a Book into a PDF"
description = "Some notes on the process of converting a physical book into a nice PDF with selectable text and an index"
unlisted = false
hasmath = true
+++

I've always wondered how the shady PDF wizards make those shady textbook
PDFs you find online, and I was bored yesterday, so I decided to find
out.

Preparing the Patient
---------------------

At first, I tried to spreading the book and placing each pair of pages
on a flatbed scanner, but that led only to frustration because the pages
made poor contact with the scanner. Instead of trying to sort out the
blurring, I drove to Kinkos and paid $2.50 to cut the binding off the
book. The result looked like this:

{{< figure src="/img/blog/scanning-a-book-into-a-pdf/unbound.jpg" alt="Diagram of my webzone repository" >}}

That is, a nice stack of loose sheets you can easily feed into an
Automatic Document Feeder on your local neighborhood scanner. I scanned
to [TIFF][2]s at 300 dpi grayscale. Three little catches: 

1. In your scanner software, choose a paper size as close as the actual
   paper size as possible. This book was almost A5, so I chose that.
   Otherwise your scans will have a funny angle, or at least moreso.
2. Building on #1: Your scanner may not support duplex scanning of the
   weird page size, so you will have to roll simplex. I am proof you can
   survive this; scan all the odd pages, then reverse the order of
   the pages and feed them in the opposite direction to scan the even
   pages. Just make sure to put the results of those scans in two
   different directories.
3. Before you start scanning, check that the Kinkos guy can do his job
   properly, because my Kinkos guy did not. Probably like 20% of my
   pages were still stuck together, so I had to separate them with [a
   paper trimmer][1] by slicing off a tiny bit of the edge of the two
   attached pages.

Wrangling the Scans
-------------------

At this point, I had two directories: one full of scans of odd pages,
and one full of scans of even pages. Fortunately, the scanner software
numbered them sequentially, like `Scan_2018_05_07_0000.tif`,
`Scan_2018_05_07_0001.tif`, and so on.

First, I did some bash magic to remove the big ol prefixes:

    $ for f in *.tif; do mv -nv "$f" "${f##*_}.tif"; done

leaving me with more manageable filenames like `0000.tif`, `0001.tif`,
and so on. But these page numbers are wrong! So by messing around with
numbers, I found a formula that given a page number $n$ produces the
correct page number, say, $2n - 3$ and plugged this into more bash
magic:

    $ for i in {60..2}; do mv -nv "$(printf '%04d' i).tif" "$(printf '%04d' $(( 2 * i - 3 ))).tif"; done

Going from 60 to 2 matters here because otherwise we might clobber some
scans with others.

Thanks to point #3 above, I was missing a bunch of pages in my scan. So
I sat down with the stack of papers and my scans and checked if the
first and last page numbers matched. If not, I did a binary search on
the pages until I found the missing page. Then, to shift them over, I
used a similar trick to above, if page 37 is the first page after the missing one:

    $ for i in {117..37}; do mv -nv "$(printf '%04d' i).tif" "$(printf '%04d' $(( i + 2 ))).tif"; done

Now, after checking for missing pages and assigning the right page
numbers I merged the two directories (even and odd pages) and went on to
the next step.

Finishing Up
------------

With the most tedious part done --- scanning pages and numbering them
--- then I just fed my images into some programs.

First, to straighten out, crop, and generally clean up the scans, I
sicced [Scan Tailor][3] on my directory of page images. Somehow it
automatically fixed all the images, it was pretty great.

Then, to make text selectable, I installed the latest version of
[Tesseract][4] and used it to convert each image output by Scan Tailor
into a pdf with selectable text:

    $ for f in *.tif; do tesseract "$f" "${f%%.tif}" pdf; done

Then I used `pdfunite`, a utility in poppler, to combine all these pdfs
together:

    $ pdfunite *.pdf combined.pdf

Now, one last step: add the index because that's a lifesaver for larger
books. First, dump the metadata into a file as follows:

    $ pdftk combined.pdf dump_data >data.txt

Then edit `data.txt` to add table of contents entries like this:

    BookmarkTitle: Some Section
    BookmarkLevel: 1
    BookmarkPageNumber: 1
    BookmarkBegin
    BookmarkTitle: Another Section
    BookmarkLevel: 1
    BookmarkPageNumber: 5
    BookmarkBegin
    BookmarkTitle: Wow Another Section
    BookmarkLevel: 1
    BookmarkPageNumber: 27

Finally, to update the PDF metadata wtih these, I ran:

    $ pdftk combined.pdf update_info data.txt output book.pdf

And tada! I had a high-quality scan, `book.pdf`, of some textbook I
probably won't read!

[1]: https://www.joann.com/paper-crafting/tools-and-machine/scrapbooking-cutting-tools/personal-paper-trimmers/
[2]: https://en.wikipedia.org/wiki/TIFF
[3]: http://scantailor.org/
[4]: https://github.com/tesseract-ocr/tesseract
