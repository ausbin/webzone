+++
date = "2026-02-27T11:51:19-05:00"
draft = false
title = "Survey of Qubit Representations"
description = "An attempt a comprehensive list of ways to represent the state of quantum bits"
hasmath = true
unlisted = true
+++

<style>
    #container {
        max-width: 768px; /* 512 -> 768 */
    }

    table {
        border-collapse: collapse;
        width: 100%;
    }

    thead {
        background-color: #f0f0f0;
    }

    table, th, td {
        border: 1px solid #999;
    }

    td {
        text-align: center;
        padding: 5pt;
    }

    /* Name column */
    td:nth-child(1) {
        width: 20%;
        text-align: left;
    }

    /* Refs columns */
    td:nth-child(4) {
        width: 15%;
    }

    /* https://stackoverflow.com/a/58049221/321301 */
    #content ol {
        counter-reset: refs;
    }

    #content li {
        list-style: none;
        counter-increment: refs 1;
        position: relative;
    }

    #content li::before {
        content: "[" counter(refs) "]";
        position: absolute;
        left: -3.5em;
        text-align: right;
        width: 3em;
    }

    .strlit {
        color: blue;
    }
</style>

Because we humans are macroscopic beings who constantly interact with our
environment, reasoning about the behavior of individual particles in a closed
system --- quantum behavior --- can be difficult. Even the simplest quantum
mechanic systems around, the spin-1/2 systems that people call _quantum bits_
or _qubits_, aren't much easier. Folks have designed many ways to represent
qubit states. This post lists all the ones I have found.

# Summary


| Name                    | Example 1Q State | Example 2Q State | Refs. |
| ----------------------- | ---------------- | ---------------- | ----- |
| Bra--ket/Dirac notation | $\frac{1}{\sqrt{2}}\left(\vert 0\rangle - \vert 1\rangle \right)$ | $\frac{1}{\sqrt{2}}\left(\vert 00\rangle - \vert 11\rangle \right)$ | [\[1, Fig. 2.1\]](#ref1), [\[2, App. A\]](#ref2), [\[3, Sec. 2.2\]](#ref3)
| Matrices | $\frac{1}{\sqrt{2}}\begin{bmatrix}1 \\\\ -1\end{bmatrix}$ | $\frac{1}{\sqrt{2}}\begin{bmatrix}1 \\\\ 0 \\\\ 0 \\\\ -1\end{bmatrix}$  | [\[4, Chap. 3\]](#ref4)
| Coordinates | $\begin{aligned}a(0) &= \frac{1}{\sqrt{2}} \\\\ a(1) &= -\frac{1}{\sqrt{2}}\end{aligned}$ | $\begin{aligned}a(00) &= \frac{1}{\sqrt{2}} \\\\ a(11) &= -\frac{1}{\sqrt{2}}\end{aligned}$ | [\[5, Chap. 3\]](#ref5)
| Bloch sphere | {{<figure src="/img/blog/qubit-viz/bloch-sphere-doodle-minus.svg" width="150px" >}} | _N/A_ | [\[1, Sec. 1.2, Sec. 4.2\]](#ref1), [\[3, Sec. 2.5.2\]](#ref3), [\[4, Chap. 2\]](#ref4), [\[5, Sec. 14.4\]](#ref5) |
| 2D plane/unit circle | {{<figure src="/img/blog/qubit-viz/2d-minus.svg" width="150px" >}} | {{<figure src="/img/blog/qubit-viz/2d-bell.svg" width="150px" >}} | [\[3, Fig. 2.4, Fig. 9.2\]](#ref3), [\[1, Fig. 6.3\]](#ref1), [\[2, Fig. 4.3\]](#ref2) |
| Q is for Quantum | {{<figure src="/img/blog/qubit-viz/qi4q-minus.svg" width="150px" >}} | {{<figure src="/img/blog/qubit-viz/qi4q-bell.svg" width="150px" >}} | [\[6\]](#ref6) |
| Qwerty | <span class="strlit">`'0'`</span>`-`<span class="strlit">`'1'`</span> | <span class="strlit">`'00'`</span>`-`<span class="strlit">`'11'`</span> | [\[7\]](#ref7), [\[8\]](#ref8)|
| Knot | _N/A_ | {{<figure src="/img/blog/qubit-viz/2q-knot.svg" width="150px" >}} | [\[9\]](#ref9), [\[10\]](#ref10)|
| Circle notation | {{<figure src="/img/blog/qubit-viz/circle-notation-minus.svg" width="150px" >}} | {{<figure src="/img/blog/qubit-viz/circle-notation-bell.svg" width="150px" >}} | [\[11\]](#ref11)|

# Bibliography

1. <a id="ref1"></a>M. A. Nielsen and I. L. Chuang, [_Quantum Computation and Quantum Information: 10th Anniversary Edition_](https://amazon.com/dp/1107002176). Cambridge University Press, 2010.
2. <a id="ref2"></a>N. D. Mermin, [_Quantum Computer Science: An Introduction_](https://amazon.com/dp/0521876583). Cambridge University Press, 2007.
3. <a id="ref3"></a>E. G. Rieffel and W. H. Polak, [_Quantum Computing: A Gentle Introduction_](https://amazon.com/dp/0262526670). Cambridge, Massachusetts London, England: The MIT Press, 2014.
4. <a id="ref4"></a>B. Burd, [_Quantum Computing Algorithms: Discover how a little math goes a long way_](https://amazon.com/dp/1804617377). Birmingham: Packt Publishing, 2023.
5. <a id="ref5"></a>R. J. Lipton and K. W. Regan, [_Introduction to Quantum Algorithms via Linear Algebra_](https://amazon.com/dp/0262045257/), second edition. Cambridge, Massachusetts: The MIT Press, 2021.
6. <a id="ref6"></a>T. Rudolph, [_Q is for Quantum_](https://www.qisforquantum.org/). Wroclaw: Terence Rudolph, 2017.
7. <a id="ref7"></a>A. J. Adams et al., “[Qwerty: A Basis-Oriented Quantum Programming Language](https://doi.org/10.1109/QCE65121.2025.00093),” in Proceedings of the 2025 IEEE International Conference on Quantum Computing and Engineering (QCE '25), Aug. 2025, pp. 804–815.
8. <a id="ref8"></a>S. E. Economou, T. Rudolph, and E. Barnes, “[Teaching quantum information science to high-school and early undergraduate students](http://arxiv.org/abs/2005.07874),” Aug. 08, 2020, arXiv: arXiv:2005.07874.
9. <a id="ref9"></a>P. K. Aravind, “[Borromean Entanglement of the GHZ State](https://doi.org/10.1007/978-94-017-2732-7_4),” in _Potentiality, Entanglement and Passion-at-a-Distance: Quantum Mechanical Studies for Abner Shimony Volume Two_, R. S. Cohen, M. Horne, and J. Stachel, Eds., in Boston Studies in the Philosophy of Science. Dordrecht: Springer Netherlands, 1997, pp. 53–59.
10. <a id="ref10"></a>A. Sugita, “[Borromean Entanglement Revisited](http://arxiv.org/abs/0704.1712),” In Proceedings of International Workshop on Knot Theory for Scientic Objects, Mar. 2006, Osaka, Japan.
11. <a id="ref11"></a>E. R. Johnston, N. Harrigan, and M. Gimeno-Segovia, [_Programming Quantum Computers: Essential Algorithms and Code Samples_](https://amazon.com/dp/1492039683). O’Reilly Media, Inc., 2019.
