+++
date = "2022-04-16T12:05:52-04:00"
draft = false
title = "Proof of the Expectation Value of Z for a Qubit State"
description = "I outline my proof of how to find the expectation value of Z for an arbitrary qubit state"
hasmath = true
unlisted = true
+++

It has been a few years since I wrote a post on this blog, so I wanted to share
a fun proof, even if it's a little trivial.$
\newcommand{bra}\[1\]{\langle #1 |}
\newcommand{ket}\[1\]{| #1 \rangle}
\newcommand{braket}\[2\]{\langle #1 | #2 \rangle}
\newcommand{bramket}\[3\]{\langle #1 | #2 | #3 \rangle}
$

For many quantum applications, you care about $\bramket{\psi}{Z}{\psi}$. That
is, the [expectation value][1] of the [Pauli operator][2] $Z$. I'm a computer
scientist, so $\ket{\psi}$ is a qubit state for me, but this is defined for any quantum
state $\ket{\psi}$. One way to calculate it may be common knowledge, but I
couldn't find a proof online (only [some code][3]), so here is my little proof.

Examples for One and Two Qubits
-------------------------------

First, let's consider the case where $\ket{\psi}$ is a single-qubit state. It's
useful to know that

\\[ \begin{align} Z &= \begin{bmatrix}1 & 0 \\\\ 0 & -1\end{bmatrix} \\\\
                    &= \begin{bmatrix}1 & 0 \\\\ 0 & 0\end{bmatrix} - \begin{bmatrix}0 & 0 \\\\ 0 & 1\end{bmatrix} \\\\
                    &= \ket{0}\bra{0} - \ket{1}\bra{1} \end{align} \\]

thus

\\[ \begin{align} \bramket{\psi}{Z}{\psi} &= \bramket{\psi}{\left[\ket{0}\bra{0} - \ket{1}\bra{1}\right]}{\psi} \\\\
                                          &= \bramket{\psi}{\left[\ket{0}\bra{0}\right]}{\psi} - \bramket{\psi}{\left[\ket{1}\bra{1}\right]}{\psi} \\\\
                                          &= \bramket{\psi}{M_0}{\psi} - \bramket{\psi}{M_1}{\psi} \\\\
                                          &= \bramket{\psi}{M_0^\dagger M_0}{\psi} - \bramket{\psi}{M_1^\dagger M_1}{\psi} \\\\
                                          &= P(0) - P(1) \end{align} \\]

where $M_0$ and $M_1$ are the measurement operators for 0 and 1, respectively,
and $P(0)$ and $P(1)$ are the probabilities of measuring 0 and 1, respectively.

Now, let's suppose $\ket{\psi}$ is a two qubit state. Do we get something similar? First, let's observe something similar to the above about $Z \otimes Z$:
\\[ \begin{align} Z \otimes Z &= \begin{bmatrix}1 & 0 & 0 & 0 \\\\ 0 & -1 & 0 & 0 \\\\ 0 & 0 & -1 & 0 \\\\ 0 & 0 & 0 & 1 \end{bmatrix} \\\\
                    &= \ket{00}\bra{00} - \ket{01}\bra{01} - \ket{10}\bra{10} + \ket{11}\bra{11} \end{align} \\]

Now, we can see

\\[ \begin{align} \bramket{\psi}{Z \otimes Z}{\psi} &= \bramket{\psi}{\left[\ket{00}\bra{00} - \ket{01}\bra{01} - \ket{10}\bra{10} + \ket{11}\bra{11} \right]}{\psi} \\\\
                                          &= \bramket{\psi}{\left[\ket{00}\bra{00}\right]}{\psi} - \bramket{\psi}{\left[\ket{01}\bra{01}\right]}{\psi} \\\\ &\quad - \bramket{\psi}{\left[\ket{10}\bra{10}\right]}{\psi} + \bramket{\psi}{\left[\ket{11}\bra{11}\right]}{\psi}   \\\\
                                          &= \bramket{\psi}{M_{00}}{\psi} - \bramket{\psi}{M_{01}}{\psi} - \bramket{\psi}{M_{10}}{\psi} + \bramket{\psi}{M_{11}}{\psi} \\\\
                                          &= \bramket{\psi}{M_{00}^\dagger M_{00}}{\psi} - \bramket{\psi}{M_{01}^\dagger M_{01}}{\psi} \\\\ &\quad - \bramket{\psi}{M_{10}^\dagger M_{10}}{\psi} + \bramket{\psi}{M_{11}^\dagger M_{11}}{\psi} \\\\
                                          &= P(00) - P(01) - P(10) - P(11) \end{align} \\]

A pattern is emerging here. **In general, if $p(x)$ is the bit parity of bitstring $x$, is $\bramket{\psi}{Z}{\psi} = \sum\_{x\in\\{0,1\\}^n} (-1)^{p(x)}P(x)$?** Yes!

Proof
-----

We need to show that $\underbrace{Z \otimes Z \otimes \cdots \otimes Z}\_{n\text{ times}} = \sum\_{x\in\\{0,1\\}^n} (-1)^{p(x)} \ket{x}\bra{x}$. To help with the proof, we should also assert that this is a diagonal matrix. Let's use a proof by induction.

#### Base case

Consider $n=1$. We already showed above that $Z$ is a diagonal matrix and $Z = \ket{0}\bra{0} - \ket{1}\bra{1}$, so the base case holds.

#### Inductive step

For the inductive step, we assume that for $n-1$, the proposition holds. Thus, $Z' = \underbrace{Z \otimes Z \otimes \cdots \otimes Z}\_{n-1\text{ times}}$ is a diagonal matrix and $Z' = \sum\_{x\in\\{0,1\\}^{n-1}} (-1)^{p(x)} \ket{x}\bra{x}$. We want to show that $Z' \otimes Z = \sum\_{x\in\\{0,1\\}^n} (-1)^{p(x)} \ket{x}\bra{x}$.

In general, we can observe that for some $2^n\times2^n$ diagonal matrix $D$

\\[ D = \begin{bmatrix} d\_{00\cdots00} & & & 0 \\\\ & d\_{00\cdots01} & & \\\\ & & \ddots & \\\\ 0 & & & d\_{11\cdots11} \end{bmatrix} \\]

we have

\\[ \begin{align} D \otimes Z &= \begin{bmatrix} d\_{00\cdots00} & & & & & & 0 \\\\ & -d\_{00\cdots00} & & \\\\ & & d\_{00\cdots01} & \\\\ & & & -d\_{00\cdots01} \\\\ & & & & \ddots \\\\ & & & & & d\_{11\cdots11} \\\\ 0 & & & & & & -d\_{11\cdots11} \end{bmatrix} \\\\
                              &= \begin{bmatrix} d'\_{00\cdots000} & & & & & & 0 \\\\ & d'\_{00\cdots001} & & \\\\ & & d'\_{00\cdots010} & \\\\ & & & d'\_{00\cdots011} \\\\ & & & & \ddots \\\\ & & & & & d'\_{11\cdots110} \\\\ 0 & & & & & & d'\_{11\cdots111} \end{bmatrix} \end{align} \\]

Above, $d\_x$ denotes the diagonal entry on row/column $x$ in $D$, and $d'\_x$ denotes the diagonal entry on row/column $x$ in $D \otimes Z$. From above, we can see that we have $d'\_{xb} = (-1)^bd_x$. Henceforth, let's assume that $D = Z'$.

Consider two cases for the bit parity of $x$:

1. If $x$ has even bit parity, then $d\_{x} = 1$ by the inductive hypothesis. Thus, for $b=0$, the $d'\_{xb}$ equation above gives $1$, which aligns with our goal to show that $d'\_{xb} = 1$ since $xb$ would have even bit parity. For $b=1$, however, $xb$ would have odd bit parity; the $d'\_{xb}$ equation above gives $-1$, which matches our goal to show that $d'\_{xb} = -1$.

2. If $x$ has _odd_ bit parity, then $d\_{x} = -1$ by the inductive hypothesis. For $b=0$, $xb$ still has odd bit parity, and the $d'\_{xb}$ equation above gives $-1$, which is good because it aligns with our goal. For $b=1$, observe that $xb$ now has even bit parity! The $d'\_{xb}$ equation above yields $1$, which matches our goal to show that $d'\_y = 1$ for any $y \in \\{0,1\\}^n$ with even bit parity.

This proves that if the proposition holds for $n-1$, it holds for $n$.

#### Wrapping up
By induction, then, we've shown that $\underbrace{Z \otimes Z \otimes \cdots \otimes Z}\_{n\text{ times}} = \sum\_{x\in\\{0,1\\}^n} (-1)^{p(x)} \ket{x}\bra{x}$.

Now let's plug this in. If $\ket{\psi}$ is an $n$-qubit state, then

\\[ \begin{align} \bramket{\psi}{\underbrace{Z \otimes Z \otimes \cdots \otimes Z}\_{n\text{ times}}}{\psi} &= \bramket{\psi}{\left[\sum\_{x\in\\{0,1\\}^n} (-1)^{p(x)} \ket{x}\bra{x} \right]}{\psi} \\\\
               &= \bramket{\psi}{\left[\sum\_{x\in\\{0,1\\}^n} (-1)^{p(x)} M\_x \right]}{\psi} \\\\
               &= \sum\_{x\in\\{0,1\\}^n} (-1)^{p(x)} \bramket{\psi}{M\_x}{\psi} \\\\
               &= \sum\_{x\in\\{0,1\\}^n} (-1)^{p(x)} \bramket{\psi}{M\_x^\dagger M\_x}{\psi} \\\\
               &= \sum\_{x\in\\{0,1\\}^n} (-1)^{p(x)} P(x) \end{align} \\]

Done!

[1]: https://en.wikipedia.org/wiki/Expectation_value_(quantum_mechanics)
[2]: https://mathworld.wolfram.com/PauliMatrices.html
[3]: https://github.com/eclipse/xacc/blob/a01b704b439fb96a881d3b4f932b759d8c0620ff/quantum/plugins/qpp/accelerator/QppVisitor.cpp#L92-L114
