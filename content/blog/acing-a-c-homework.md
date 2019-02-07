+++
date = "2019-02-07T05:36:59-05:00"
draft = false
title = "Acing a C Homework Using Inline Assembly"
description = "A little article showing how to cheat on a C homework"
hasmath = false
+++

In courses taught in Java (such as a data structures class), you can
build pretty robust autograders for homeworks --- after all, the
student's code runs in the JVM, which prevents it from doing spooky
things like corrupting memory or branching to weird places. So you can
run the grader instantly after submission on a service like
[Gradescope][3] and boom, they've got their grade. But C homeworks
provide students a lot more opportunities to write... unconventional
solutions.

I've posted an [example homework/POC on GitHub][1]; clone it if you
want. The assignment asks students to complete `fib()` in
`assignment.c`, like the following:

    int fib(int n) {
        if (n < 0)
            return -1;
    
        int *arr = malloc(sizeof (int) * (n + 1));
        if (!arr)
            return -1;
    
        arr[0] = 0;
        if (n > 0)
            arr[1] = 1;
    
        for (int i = 2; i <= n; i++)
            arr[i] = arr[i - 1] + arr[i - 2];
    
        int ret = arr[n];
    
        free(arr);
    
        return ret;
    }

The test suite `assignment_suite.c` tests their implementation (don't
worry about this too much, it's [libcheck][2] stuff):

    static int input[] =  {-200, 0, 1, 2, 3, 5, 10,  15,     27};
    static int output[] = {  -1, 0, 1, 1, 2, 5, 55, 610, 196418};

    START_TEST(test_fib) {
        ck_assert_int_eq(fib(input[_i]), output[_i]);
    }
    END_TEST

But let's be honest, sometimes you're a little stressed and you just
don't have time for that homework. That's 19 whole lines of code! This
leaves you with two options:

 1. Copy your fraternity brother's homework
 2. Use inline assembly to jump past the failing assertions back into
    the grader --- specifically, to the end of the `test_fib` function

I'll write a post on how to do #1 later, but first I'll stub out `fib()`
as follows:

    int fib(int n) {
        (void)n; // don't complain about how this is unused
        return -1;
    }

and then run it in gdb and step instruction-by-instruction until we're
back in `test_fib()`:

    $ make run-gdb
    (gdb) layout asm
    (gdb) b fib
    (gdb) r
    (gdb) si
    (gdb) si
    (gdb) si

Then gdb shows the following, which shows the instruction immediately
following the instruction that calls `fib()` is 65 bytes after the
beginning of `test_fib()`:

     |0x555555555d4d <test_fib+55>    mov    (%rdx,%rax,1),%eax
     |0x555555555d50 <test_fib+58>    mov    %eax,%edi
     |0x555555555d52 <test_fib+60>    callq  0x555555555bb0 <fib>
    >|0x555555555d57 <test_fib+65>    cltq
     |0x555555555d59 <test_fib+67>    mov    %rax,-0x8(%rbp)
     |0x555555555d5d <test_fib+71>    mov    -0x14(%rbp),%eax
     |0x555555555d60 <test_fib+74>    cltq

Why do we care? Well, this means the return address pushed onto the
stack when calling `fib()` must be 65 bytes after the beginning of
`test_fib()`. If we grab this return address off the stack, we can add
some predetermined offset to it and perform an indirect jump to skip to
the end of the test function, past any nasty failing assertions!

Looking at the disassembly of the test suite object file
`assignment_suite.o` (`assignment_suite.asm` in the repository), we can
see the teardown for `test_fib()` begins at `0xc3 = 195` bytes after the
beginning of `test_fib()`:

      b2:	48 8d 3d 00 00 00 00 	lea    0x0(%rip),%rdi        # b9 <test_fib+0xb9>
      b9:	b8 00 00 00 00       	mov    $0x0,%eax
      be:	e8 00 00 00 00       	callq  c3 <test_fib+0xc3>
    END_TEST
      c3:	c9                   	leaveq 
      c4:	c3                   	retq   

So we need to add `195-65 = 130` bytes to the return address to jump to
the end of `test_fib()`. Now we can write our cooked solution using
inline assembly:

    int fib(int n) {
        __asm__ ("leave\n\t"
                 "popq %rax\n\t"
                 "addq $130, %rax\n\t"
                 "jmp *%rax");

        (void)n;
        return -1;
    }

Each instruction does the following:

 1. `leave` will restore the frame pointer of the caller so it doesn't
     get confused
 2. `popq %rax` pops the return return address off the stack and puts it in
    `%rax`
 3. `addq $130, %rax` adds our precalculated offset to the return address
 4. `jmp *%rax` jumps to the location we want, the end of `test_fib()`,
    past all the assertions

And behold, it "passes" all tests!

    $ make run-tests
    ./tests
    Running suite(s): fun assignment
    100%: Checks: 9, Failures: 0, Errors: 0

Mitigation
----------

You'd think you could avoid this by passing `-fno-asm` to gcc, but it
turns out this only disables `asm`, not `__asm__` which still works
according to `gcc(1)`:

    -fno-asm
       Do not recognize "asm", "inline" or "typeof" as a
       keyword, so that code can use these words as
       identifiers.  You can use the keywords "__asm__",
       "__inline__" and "__typeof__" instead.

You could also pass `-D__asm__=YOUREABADBOY` to gcc, but this seems to
break standard library headers, and the student could thwart this anyway
by simply saying `#undef __asm__`.

So if you ask me, the best way to prevent this form of cheating is to
tweak the Makefile rule that builds `.c` files:

    %.o: %.c $(HFILES)
        sed -i 's/\<__asm__\>/YOUREABADBOY/g' $<
        $(CC) $(CFLAGS) -c $< -o $@

But, of course, the dream is to run student code in a separate address
space entirely, like QEMU or something. This way, they can't mess with
the autograder's memory --- a viable option I didn't even try exploring.

[1]: https://github.com/ausbin/c-autograder-exploit-poc
[2]: https://libcheck.github.io/check/
[3]: https://www.gradescope.com/
