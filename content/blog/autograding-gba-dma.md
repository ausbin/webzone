+++
date = "2018-11-29T00:00:00-05:00"
draft = true
title = "Autograding Gameboy Advance DMA Transfers"
description = "A tale of using (abusing?) Linux virtual memory features to autograde GBA DMA for CS 2110"
hasmath = true
+++

In CS 2110 at Georgia Tech, we use the Gameboy Advance to demonstrate
how C code can interact directly with hardware. On a high level,
students create games by reading button states directly from
memory-mapped registers and write directly to a special region of memory
called the "video buffer," which the video controller continuously reads
and draws on the screen.

But my favorite example of students poking with the GBA hardware
introduces them to an important real-life example: [Direct Memory Access
(DMA)][2]! The GBA has a DMA controller which amounts to a fast `memcpy()`
in hardware which some additional switches to flip. ([See tonc for more
details on GBA DMA][1].)

Students use DMA as follows:

```c
// provided boilerplate
typedef struct {
	const volatile void *src;
	volatile void *dst;
	volatile uint32_t cnt;
} DMA_CONTROLLER;

#define DMA ((volatile DMA_CONTROLLER *) 0x040000B0)

#define DMA_DEST_INC (0 << 21)
#define DMA_DEST_DEC (1 << 21)
#define DMA_DEST_FIX (2 << 21)

#define DMA_SRC_INC (0 << 23)
#define DMA_SRC_DEC (1 << 23)
#define DMA_SRC_FIX (2 << 23)

#define DMA_ON (1 << 31)

// STUDENT CODE:
// Turns the whole screen red
void redscreen(void) {
    volatile u16 color = RED;
    DMA[3].src = &color;
    DMA[3].dst = videoBuffer;
    // dimensions of gba screen
    DMA[3].cnt = DMA_ON | DMA_SRC_FIX | DMA_DEST_INC | (240 * 160);
}
```

Notice that the student code above does not call a function we can mock
out in an autograder, like how a student's `malloc()` could call a fake
`sbrk()` --- it's just hitting memory at some weird address.

You might think: well Austin, this is easy you dumbass, just make the
`DMA` macro point to some chunk of memory which you can check after
their code returns! However, you forget that DMA normally stops the CPU
while it makes the copy, and that would not. Let's
look at a less trivial example of DMA:

```
void redsquare(int width, int height) {
    volatile u16 color = RED;
    for (int row = 0; row < height; row++) {
        DMA[3].src = &color;
        DMA[3].dst = videoBuffer + row * 240;
        // dimensions of gba screen
        DMA[3].cnt = DMA_ON | DMA_SRC_FIX | DMA_DEST_INC | width;
    }
}
```

If we used the "magic DMA buffer" idea mentioned above, later DMA
transfers would clobber src/dst/cnt values from earlier transfers. So
that ain't gonna work.

Consequently, before this semester, we never autograded DMA. Instead, we
would `grep` students' code for `for` loops in addition to making sure
the emulator showed the right image. My goal in life is to automate
tedious tasks so I decided to take this opportunity to flex so hard I
caused permanent muscle damage.


[1]: https://www.coranac.com/tonc/text/dma.htm
[2]: https://en.wikipedia.org/wiki/Direct_memory_access
