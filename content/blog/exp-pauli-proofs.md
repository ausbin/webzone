+++
date = "2025-02-03T12:06:55-05:00"
draft = true
title = "Proofs about Exponentials of Pauli Strings"
description = "I outline proofs of some Pauli string identities due to Litinski (2019)"
hasmath = true
+++

The paper ["A Game of Surface Codes: Large-Scale Quantum Computing with Lattice
Surgery"][1] is a beautiful introduction to surface codes by Daniel Litinski.
Figure 4 of the paper presents the following identities for exponentials of
Pauli strings:

\\[ \begin{alignat}{3}
    &(1)&\quad e^{-i\varphi P'} e^{-i(\pi/4)P} &= e^{-i(\pi/4)P} e^{-i\varphi P'} &\quad\text{if } PP' &= P'P \\\\
    &(2)&\quad e^{-i\varphi P'} e^{-i(\pi/4)P} &= e^{-i(\pi/4)P} e^{-i\varphi (iPP')} &\quad\text{if } PP' &= -P'P \\\\
    &(3)&\quad P_\lambda' e^{-i(\pi/4) P} &= e^{i\theta}P_\lambda' &\quad\text{if } PP' &= P'P \\\\
    &(4)&\quad P_\lambda' e^{-i(\pi/4) P} &= e^{i\theta}(iPP')_\lambda &\quad\text{if } PP' &= -P'P \\\\
    &(5)&\quad (e^{-i\phi P'} \otimes I^{\otimes d}) C(P_1,P_2) &= C(P_1, P_2) (e^{-i\phi P'} \otimes I^{\otimes d}) &\quad\text{if } P_1P' &= P'P_1 \\\\
    &(6)&\quad (e^{-i\phi P'} \otimes I^{\otimes d}) C(P_1,P_2) &= C(P_1, P_2) e^{-i\phi(P' \otimes P_2)} &\quad\text{if } P_1P' &= -P'P_1 \\\\
    &(7)&\quad (I^{\otimes d} \otimes e^{-i\phi P'}) C(P_1,P_2) &= C(P_1, P_2) (I^{\otimes d} \otimes e^{-i\phi P'})  &\quad\text{if } P_2P' &= P'P_2 \\\\
    &(8)&\quad (I^{\otimes d} \otimes e^{-i\phi P'}) C(P_1,P_2) &= C(P_1, P_2) e^{-i\phi(P_1 \otimes P')} &\quad\text{if } P_2P' &= -P'P_2
    \end{alignat} \\]

Litinski does not state Identities (5) and (7) explicitly but he strongly
implies them. In hopes it will help someone someday, I will prove all 8
identities in this post.

**Notation:**
1. A Pauli string $P$ is defined as $P = \pm \bigotimes^d_{i=1} P_i$ where $P_i \in \\{I, X, Y, Z\\}$. (The optional leading minus sign will come in useful later.)
2. $P_\lambda$ means a projector onto the eigenspace of $P$ corresponding to eigenvalue $\lambda$
3. As defined by Litinski, $C(P_1, P_2) = e^{-i(\pi/4)(P_1 \otimes P_2)}e^{i(\pi/4)(I \otimes P_2)}e^{i(\pi/4)(P_1 \otimes I)}$
3. Throughout this post, $\theta,\phi \in \mathbb{R}$.
$
\newcommand{bra}\[1\]{\langle #1 |}
\newcommand{ket}\[1\]{| #1 \rangle}
\newcommand{ketbra}\[2\]{\ket{#1}\\!\bra{#2}}
\newcommand{braket}\[2\]{\langle #1 | #2 \rangle}
\newcommand{bramket}\[3\]{\langle #1 | #2 | #3 \rangle}
$

Proof of Identity (1)
---------------------

If $P$ and $P'$ commute, then they can both be diagonalized with the same basis[^^1].
That is,
\\[ \begin{align}
    P &= \sum_i \lambda_i \ketbra{\lambda_i}{\lambda_i} \\\\
    P' &= \sum_i \lambda_i' \ketbra{\lambda_i}{\lambda_i}
    \end{align} \\]
Notice here that the eigenstates $\ket{\lambda_i}$ are the same but the
eignvalues $\lambda_i$ and $\lambda_i'$ may differ. If you exponentiate both
$P$ and $P'$, you get[^^2]
\\[ \begin{align}
    e^{-i\theta P} &= \sum_i e^{-i\theta \lambda_i} \ketbra{\lambda_i}{\lambda_i} \\\\
    e^{-i\phi P'} &= \sum_i e^{-i\phi \lambda_i'} \ketbra{\lambda_i}{\lambda_i}
    \end{align} \\]
These two operators are simultaneously diagonalizable, so they commute. That
is, $e^{-i\theta P}e^{-i\phi P'} = e^{-i\phi P'}e^{-i\theta P}$. This result is
stronger than Identity (1). $\square$

Proof of Identity (2)
---------------------

----

**Lemma 2a:** The identity $e^{i\theta P} = \cos(\theta)I^{\otimes d} +
i\sin(\theta)P$ will be useful below[^^3]. Proof:

\\[ \begin{align}
    e^{i\theta P} &= \sum^{\infty}\_{k=0} \frac{1}{k!} (i\theta P)^k \\\\
                &= \sum^{\infty}\_{k=0} \frac{1}{k!} i^k (\theta P)^k \\\\
                &= \underbrace{\sum^{\infty}\_{m=0} \frac{1}{(2m)!} i^{2m} (\theta P)^{2m}}\_{\text{even $k$}} + \underbrace{\sum^{\infty}\_{n=0} \frac{1}{(2n+1)!} i^{2n+1} (\theta P)^{2n+1}}\_{\text{odd $k$}} \\\\
                &= \sum^{\infty}\_{m=0} \frac{(-1)^m}{(2m)!} (\theta P)^{2m} + i\sum^{\infty}\_{n=0} \frac{(-1)^n}{(2n+1)!} (\theta P)^{2n+1} \\\\
                &= \left(\sum^{\infty}\_{m=0} \frac{(-1)^m}{(2m)!} \theta^{2m}\right)I^{\otimes d} + i\left(\sum^{\infty}\_{n=0} \frac{(-1)^n}{(2n+1)!} \theta^{2n+1}\right)P \qquad (\ast) \\\\
                &= \cos(\theta)I^{\otimes d} + i\sin(\theta)P
    \end{align} \\]

The step $(\ast)$ holds because[^^4] $P^2 = I^{\otimes d}$. $\square$

----

**Corollary 2b:** $e^{-i\phi P} = \cos(\phi)I^{\otimes d} - i\sin(\phi)P$.

Proof: Set $\theta = -\phi$ in Lemma 2a. $\square$

----

**Lemma 3c:** $PP' = -P'P$ if and only if there are an odd number of _mismatched positions_ $i$ such that $\\{P_i,P_i'\\} \in \\{\\{X,Y\\},\\{Y,Z\\},\\{X,Z\\}\\}$, and $PP' = P'P$ if and only if there are an even number of mismatched positions.

Proof (Induction on $d$): First, prove the base case $d=1$ exhaustively: $XZ = -ZX$, $YZ = -ZY$, $XY = -YX$, $II = II$, $XX = XX$, $YY = YY$, $ZZ = ZZ$, $IZ = ZI$, $IY = YI$, and $IX = XI$.

Inductive step: Suppose inductive hypothesis holds for $d = k$. Then let $P_{k+1} = P_k \otimes P_1$ and $P_{k+1}' = P_k' \otimes P_1'$. Consider two cases: (1) $P_k$ and $P_k'$ commute, and (2) $P_k$ and $P_k'$ anti-commute.

> Case (1): By I.H., there are an even number of mismatched positions in $P_k$ and $P_k'$. Consider two subcases: $P_1$ and $P_1'$ commute (1a), or they do not (1b).

> > Case (1a): The number of mismatched positions across $P_{k+1}$ and $P_{k+1}'$ remains even, and $P_{k+1}$ and $P_{k+1}'$ still commute.

> > Case (1b): The number of mismatched positions across $P_{k+1}$ and $P_{k+1}'$ is now odd, and $P_{k+1}$ and $P_{k+1}'$ now anti-commute.

> Case (2): By I.H., there are an odd number of mismatched positions in $P_k$ and $P_k'$. Consider two subcases: $P_1$ and $P_1'$ commute (2a), or they do not (2b).

> > Case (2a): The number of mismatched positions across $P_{k+1}$ and $P_{k+1}'$ remains odd, and $P_{k+1}$ and $P_{k+1}'$ still anti-commute.

> > Case (2b): The number of mismatched positions across $P_{k+1}$ and $P_{k+1}'$ is now even, and $P_{k+1}$ and $P_{k+1}'$ now commute. This is because the negative signs cancel out.

This completes the proof. $\square$

----

**Lemma 3d:** If $PP' = -P'P$, then $iPP'$ is another Pauli string $P''$.

Proof: By Lemma 3c, there is an odd number $2k+1$ of mismatched positions between $P$ and $P'$. Thus, $PP' = (\pm i)^{2k+1}P'' = iP'''$ for some Pauli strings $P''$ and $P'''$. Finally, $i(iP''') = -P'''$ which is a valid Pauli string per our definition above. $\square$

----

### Proof

Suppose that $P$ and $P'$ anti-commute, i.e., $PP' = -P'P$.

\\[ \begin{align}
    e^{-i\phi P'} e^{-i(\pi/4)P} &= \left(\cos(\phi)I^{\otimes d} - i\sin(\phi)P'\right)\left(\cos(\pi/4)I^{\otimes d} - i\sin(\pi/4)P\right) \\\\
    &= \left(\cos(\phi)I^{\otimes d} - i\sin(\phi)P'\right)\left(\frac{1}{\sqrt{2}}I^{\otimes d} - \frac{i}{\sqrt{2}}P\right) \\\\
    &= \frac{\cos(\phi)}{\sqrt{2}}I^{\otimes d} - \frac{i\cos(\phi)}{\sqrt{2}}P - \frac{i\sin(\phi)}{\sqrt{2}}P' - \frac{\sin(\phi)}{\sqrt{2}}P'P \\\\
    &= \frac{\cos(\phi)}{\sqrt{2}}I^{\otimes d} - \frac{i\cos(\phi)}{\sqrt{2}}P - \frac{i\sin(\phi)}{\sqrt{2}}P' + \frac{\sin(\phi)}{\sqrt{2}}PP' \qquad(\ast) \\\\
    &= \frac{\cos(\phi)}{\sqrt{2}}I^{\otimes d} + \frac{\sin(\phi)}{\sqrt{2}}PP' - \frac{i\cos(\phi)}{\sqrt{2}}P - \frac{i\sin(\phi)}{\sqrt{2}}P' \\\\
    &= \frac{\cos(\phi)}{\sqrt{2}}I^{\otimes d} - \frac{i\sin(\phi)}{\sqrt{2}}(iPP') - \frac{i\cos(\phi)}{\sqrt{2}}P - \frac{i\sin(\phi)}{\sqrt{2}}PPP' \quad(\ast\ast) \\\\
    &= \left(\frac{1}{\sqrt{2}}I^{\otimes d} - \frac{i}{\sqrt{2}}P\right)\left(\cos(\phi)I^{\otimes d} - i\sin(\phi)(iPP')\right) \\\\
    &= \left(\cos(\pi/4)I^{\otimes d} - i\sin(\pi/4)P\right)\left(\cos(\phi)I^{\otimes d} - i\sin(\phi)(iPP')\right) \\\\
    &=  e^{-i(\pi/4)P} e^{-i\phi (iPP')} \qquad(\ast\\!\ast\\!\ast)
    \end{align} \\]

Step $(\ast)$ follows because $P$ and $P'$ anti-commute. The property $P^2 =
I^{\otimes d}$ implies Step $(\ast\ast)$. Corollary 2b may be used in the final
step $(\ast\\!\ast\\!\ast)$ because Lemma 3d implies that $iPP'$ is indeed a
Pauli string. This proves Identity (2). $\square$

Proof of Identity (3)
---------------------

Proof of Identity (4)
---------------------

Proof of Identity (5)
---------------------

Proof of Identity (6)
---------------------

Proof of Identity (7)
---------------------

Proof of Identity (8)
---------------------

Concluding Notes
----------------

Our allowance of a negative sign in front of a Pauli string is a hack. But
realistically, it is easy to deal with: in a rotation $e^{-i\phi P}$, it simply
means flipping the sign of $\phi$. In measurements, it will not impact
measurement results, so it can be ignored.

[1]: https://quantum-journal.org/papers/q-2019-03-05-128/
[2]: https://linear.axler.net/
[3]: https://mathworld.wolfram.com/MatrixExponential.html
[4]: https://amazon.com/dp/1107002176
[5]: https://mathworld.wolfram.com/MaclaurinSeries.html

[^^1]: This follows from Propositions 5.55 and 5.76 of [Axler 4th ed][2].
[^^2]: See the [MathWorld article][3] for an explanation of why exponentiating
       a diagonal matrix is equivalent to exponentiating each entry on the
       diagonal.
[^^3]: This is a generalized version of Exercise 4.2 of [Nielsen and Chuang][4]
[^^4]: This is true because Paulis are Hermitian. See Exercise 2.19 of [Nielsen and Chuang][4]
