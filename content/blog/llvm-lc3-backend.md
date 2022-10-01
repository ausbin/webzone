+++
date = "2022-09-25T00:35:04-04:00"
draft = false
title = "Writing an LLVM Backend for the LC-3"
description = "A step-by-step guide for creating a new LLVM backend for a toy architecture"
hasmath = false
unlisted = true
+++

My research agenda is beginning to creep from compiler middle-end towards
compiler back-end, so I've decided to start investigating LLVM backends. What
better way to do that than to implement one?

This is a step-by-step guide of how I did it. Writing this is partially
inspired by my labmate Pulkit Gupta's experience following the [official
guide][1], which has some questionable suggestions (namely to start with
SPARC).

Starting Out
============

Initial Build
-------------

I began by cloning llvm and creating my new branch based on the
newly-released LLVM 15.0.1:

    $ git clone git@github.com:llvm/llvm-project.git
    $ cd llvm-project
    $ g ch -b lc3-backend llvmorg-15.0.1

Now it was time to do my initial build. Choosing to have only one parallel link jobs
running at once seems pretty random but it's actually necessary if you're like
me and only have 16 GB of RAM, since LLVM link jobs are going to contain a ton
of object files. Otherwise, your build (or my tmux server in my case) may get OOM-killed.

    $ mkdir build
    $ cd build
    $ cmake -G Ninja -DLLVM_ENABLE_PROJECTS=clang -DCMAKE_BUILD_TYPE=Debug -DLLVM_PARALLEL_LINK_JOBS=1 ../llvm
    $ time ninja

You don't need to `time` ninja, but just for fun, I did, and a clean build took
2 hours to compile and then 1 hour to link.

Creating the LC3 Target
-----------------------

First, I'll create a new LC3 target

    $ cd llvm/lib/Target/
    $ cp -rn RISCV LC3
    $ cd LC3
    $ for f in RISCV*; do mv -nv "$f" "LC3${f#RISCV}"; done

Then, in my new `LC3` directory and each of the subdirectories `Disassembler/`,
`MCTargetDesc/`, `TargetInfo/`, and `AsmParser/`, I run

    $ for f in *.*; do sed -i -e 's/RISCV/LC3/g' -e 's/RV/LC3/g' -e 's/riscv/lc3/g' "$f"; done

I also need to add `LC3` to the list of default targets when building LLVM in
`llvm/CMakeLists.txt`:
 
    --- a/llvm/CMakeLists.txt
    +++ b/llvm/CMakeLists.txt
    @@ -372,6 +372,7 @@ set(LLVM_ALL_TARGETS
       AVR
       BPF
       Hexagon
    +  LC3
       Lanai
       Mips
       MSP430

This almost compiles, but now we have to deal with intrinsics. This is a good
start:

    $ cp -nv llvm/include/llvm/IR/Intrinsics{RISCV,LC3}.td
    $ sed -i -e 's/RISCV/LC3/g' -e 's/RV/LC3/g' -e 's/riscv/lc3/g' llvm/include/llvm/IR/IntrinsicsLC3.td

Also, we need to reference this new header file in a couple of places:

    --- a/llvm/include/llvm/IR/CMakeLists.txt
    +++ b/llvm/include/llvm/IR/CMakeLists.txt
    @@ -10,6 +10,7 @@ tablegen(LLVM IntrinsicsARM.h -gen-intrinsic-enums -intrinsic-prefix=arm)
     tablegen(LLVM IntrinsicsBPF.h -gen-intrinsic-enums -intrinsic-prefix=bpf)
     tablegen(LLVM IntrinsicsDirectX.h -gen-intrinsic-enums -intrinsic-prefix=dx)
     tablegen(LLVM IntrinsicsHexagon.h -gen-intrinsic-enums -intrinsic-prefix=hexagon)
    +tablegen(LLVM IntrinsicsLC3.h -gen-intrinsic-enums -intrinsic-prefix=lc3)
     tablegen(LLVM IntrinsicsMips.h -gen-intrinsic-enums -intrinsic-prefix=mips)
     tablegen(LLVM IntrinsicsNVPTX.h -gen-intrinsic-enums -intrinsic-prefix=nvvm)
     tablegen(LLVM IntrinsicsPowerPC.h -gen-intrinsic-enums -intrinsic-prefix=ppc)
    --- a/llvm/include/llvm/IR/Intrinsics.td
    +++ b/llvm/include/llvm/IR/Intrinsics.td
    @@ -2043,6 +2043,7 @@ include "llvm/IR/IntrinsicsARM.td"
     include "llvm/IR/IntrinsicsAArch64.td"
     include "llvm/IR/IntrinsicsXCore.td"
     include "llvm/IR/IntrinsicsHexagon.td"
    +include "llvm/IR/IntrinsicsLC3.td"
     include "llvm/IR/IntrinsicsNVVM.td"
     include "llvm/IR/IntrinsicsMips.td"
     include "llvm/IR/IntrinsicsAMDGPU.td"

This _almost_ compiles, but unfortunately there are some classes in our new
`IntrinsicsLC3.td` that will clash with the existing `IntrinsicsRISCV.td`. It's
tempting to nuke the whole file, but we might want to use some intrinsics
later. So for now, I'll remove all the intrinsics except for those for the
RISC-V bitmanip extension, since it's a pretty simple one (and one of my
favorite RISC-V extensions, of course). Clearly, the vector extension won't
help us much, for example, despite the huge number of intrinsics it has.

To fix the naming clashes, I just need to rename `BitManipGPRIntrinsics`,
`BitManipGPRGPRIntrinsics`, and `BitManipGPRGPRGRIntrinsics` to
`LC3BitManipGPRIntrinsics`, `LC3BitManipGPRGPRIntrinsics`, and
`LC3BitManipGPRGPRGRIntrinsics`, respectively, throughout the
`IntrinsicsLC3.td`. We end up with something like this in `IntrinsicsLC3.td`:

    //===----------------------------------------------------------------------===//
    // Bitmanip (Bit Manipulation) Extension

    let TargetPrefix = "lc3" in {

      class LC3BitManipGPRIntrinsics
          : Intrinsic<[llvm_any_ty],
                      [LLVMMatchType<0>],
                      [IntrNoMem, IntrSpeculatable, IntrWillReturn]>;
      class LC3BitManipGPRGPRIntrinsics
          : Intrinsic<[llvm_any_ty],
                      [LLVMMatchType<0>, LLVMMatchType<0>],
                      [IntrNoMem, IntrSpeculatable, IntrWillReturn]>;
      class LC3BitManipGPRGPRGRIntrinsics
          : Intrinsic<[llvm_any_ty],
                      [LLVMMatchType<0>, LLVMMatchType<0>, LLVMMatchType<0>],
                      [IntrNoMem, IntrSpeculatable, IntrWillReturn]>;

      // Zbb
      def int_lc3_orc_b : LC3BitManipGPRIntrinsics;

      // Zbc or Zbkc
      def int_lc3_clmul  : LC3BitManipGPRGPRIntrinsics;
      def int_lc3_clmulh : LC3BitManipGPRGPRIntrinsics;

      // ...
    } // TargetPrefix = "lc3"

But we're still not done. Those now-deleted intrinsics are of course used in
the backend, so we need to nuke all occurences of them. Let's go!

    $ rm -vf LC3ExpandAtomicPseudoInsts.cpp LC3MakeCompressible.cpp LC3InsertVSETVLI.cpp LC3InstrFormats{C,V}.td LC3InstrInfo{A,C,D,F,M,V,VPseudos,VSDPatterns,VVLPatterns,Zfh,Zicbo,Zk}.td LC3ScheduleV.td LC3SchedRocket.td LC3SchedSiFive7.td

I also needed to remove `LC3ExpandAtomicPseudoInsts.cpp`,
`LC3MakeCompressible.cpp`, and `LC3InsertVSETVLI.cpp` from
`llvm/lib/Target/LC3/CMakeLists.txt`; and `include "LC3ScheduleV.td"` from
`LC3Schedule.td`; and these lines from `LC3InstrInfo.td`:

    include "LC3InstrInfoM.td"
    include "LC3InstrInfoA.td"
    include "LC3InstrInfoF.td"
    include "LC3InstrInfoD.td"
    include "LC3InstrInfoC.td"
    include "LC3InstrInfoZk.td"
    include "LC3InstrInfoV.td"
    include "LC3InstrInfoZfh.td"
    include "LC3InstrInfoZicbo.td"

and these from `LC3.td`:

    include "LC3SchedRocket.td"
    include "LC3SchedSiFive7.td"
    # ...
    def : ProcessorModel<"rocket-rv32", RocketModel, []>;
    def : ProcessorModel<"rocket-rv64", RocketModel, [Feature64Bit]>;

    # thru
    def : ProcessorModel<"sifive-u74", SiFive7Model, [Feature64Bit,
                                                      FeatureStdExtM,
                                                      FeatureStdExtA,
                                                      FeatureStdExtF,
                                                      FeatureStdExtD,
                                                      FeatureStdExtC],
                         [TuneSiFive7]>;

But we're not done yet. We also need to remove the handling for all the many
extensions RISC-V has. First, remove the stuff in the backend related to this
(and also remove this file from `MCTargetDesc/CMakeLists.txt`):

    $ rm MCTargetDesc/LC3BaseInfo.{cpp,h}

Now, the most tedious part thus far, is removing all the references to ABIs. I
changed too much to fully describe here, but I removed everything related to
the ABI enum originally defined in `LC3BaseInfo.h`, and adjusting conditionals
based on the ABI to always use ILP32, since that's closest to the LC-3.


**TODO: I don't think this is advancing my research, so I should drop it. My
takeway from this is that I should probably avoid backends at all costs. Not
because I can't figure them out (I can), but because they're incredibly
complex, even for a "simple" ISA like RISC-V.** If I ever change my mind, the
next thing I need to do is restore some parts of LC3BaseInfo.h, since it seems
to have had more important things than I realized.


**TODO: better todo is to just use the lanai backend as pulkit suggested**

Back in the `build/` directory, it compiles, at last!

    $ cd build
    $ cmake -G Ninja -DLLVM_ENABLE_PROJECTS=clang -DCMAKE_BUILD_TYPE=Debug -DLLVM_PARALLEL_LINK_JOBS=1 ../llvm
    $ time ninja

<!--
2. investigate if these places need to be updated:

clang/lib/CodeGen/CGBuiltin.cpp:47:#include "llvm/IR/IntrinsicsRISCV.h"
llvm/include/llvm/IR/CMakeLists.txt:17:tablegen(LLVM IntrinsicsRISCV.h -gen-intrinsic-enums -intrinsic-prefix=riscv)
llvm/include/llvm/IR/Intrinsics.td:2052:include "llvm/IR/IntrinsicsRISCV.td"
-->

[1]: https://llvm.org/docs/WritingAnLLVMBackend.html
