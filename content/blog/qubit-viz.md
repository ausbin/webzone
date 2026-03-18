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

    /* Phase column */
    td:nth-child(4) {
        width: 7%;
    }

    /* Refs column */
    td:nth-child(5) {
        width: 12%;
    }

    /* https://stackoverflow.com/a/58049221/321301 */
    #content ol {
        counter-reset: refs;
    }

    #content ol li {
        list-style: none;
        counter-increment: refs 1;
        position: relative;
    }

    #content ol li::before {
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
mechanical systems around, the spin-1/2 systems that people call _quantum bits_
or _qubits_, aren't much easier. Folks have designed many ways to represent
qubit states. This post lists all the ones I have found.

# Summary


| Name                    | Example 1Q State | Example 2Q State | Phase | Refs. |
| ----------------------- | ---------------- | ---------------- | ----- | ----- |
| Bra--ket/Dirac notation | $\frac{1}{\sqrt{2}}\left(\vert 0\rangle - \vert 1\rangle \right)$ | $\frac{1}{\sqrt{2}}\left(\vert 00\rangle - \vert 11\rangle \right)$ | $\theta$ | [\[1, Fig. 2.1\]](#ref1), [\[2, App. A\]](#ref2), [\[3, Sec. 2.2\]](#ref3)
| Matrices | $\frac{1}{\sqrt{2}}\begin{bmatrix}1 \\\\ -1\end{bmatrix}$ | $\frac{1}{\sqrt{2}}\begin{bmatrix}1 \\\\ 0 \\\\ 0 \\\\ -1\end{bmatrix}$ | $\theta$ | [\[4, Chap. 3\]](#ref4)
| Coordinates | $\begin{aligned}a(0) &= \frac{1}{\sqrt{2}} \\\\ a(1) &= -\frac{1}{\sqrt{2}}\end{aligned}$ | $\begin{aligned}a(00) &= \frac{1}{\sqrt{2}} \\\\ a(11) &= -\frac{1}{\sqrt{2}}\end{aligned}$ | $\theta$ | [\[5, Chap. 3\]](#ref5)
| Bloch sphere | {{<figure src="/img/blog/qubit-viz/bloch-sphere-doodle-minus.svg" width="150px" >}} | _N/A_ | $\theta$ | [\[1, Sec. 1.2, Sec. 4.2\]](#ref1), [\[3, Sec. 2.5.2\]](#ref3), [\[4, Chap. 2\]](#ref4), [\[5, Sec. 14.4\]](#ref5) |
| 2D plane/unit circle | {{<figure src="/img/blog/qubit-viz/2d-minus.svg" width="150px" >}} | {{<figure src="/img/blog/qubit-viz/2d-bell.svg" width="150px" >}} | $\pm$ | [\[3, Fig. 2.4, Fig. 9.2\]](#ref3), [\[1, Fig. 6.3\]](#ref1), [\[2, Fig. 4.3\]](#ref2) |
| Q is for Quantum | {{<figure src="/img/blog/qubit-viz/qi4q-minus.svg" width="150px" >}} | {{<figure src="/img/blog/qubit-viz/qi4q-bell.svg" width="150px" >}} | $\pm$ | [\[6\]](#ref6), [\[7\]](#ref7) |
| Qwerty | <span class="strlit">`'0'`</span>`-`<span class="strlit">`'1'`</span> | <span class="strlit">`'00'`</span>`-`<span class="strlit">`'11'`</span> | $\theta$ | [\[8\]](#ref8) |
| Knot | _N/A_ | {{<figure src="/img/blog/qubit-viz/2q-knot.svg" width="150px" >}} | ❌| [\[9\]](#ref9), [\[10\]](#ref10)|
| Circle notation | {{<figure src="/img/blog/qubit-viz/circle-notation-minus.svg" width="150px" >}} | {{<figure src="/img/blog/qubit-viz/circle-notation-bell.svg" width="200px" >}} | $\theta$ | [\[11\]](#ref11)
| Square notation | {{<figure src="/img/blog/qubit-viz/square-notation-minus.svg" width="150px" >}} | {{<figure src="/img/blog/qubit-viz/square-notation-bell.svg" width="150px" >}} | $\color{green}\theta$ | [\[12\]](#ref12)|
| Dimensional circle notation | {{<figure src="/img/blog/qubit-viz/circle-square-notation-minus.svg" width="150px" >}} | {{<figure src="/img/blog/qubit-viz/circle-square-notation-bell.svg" width="150px" >}} | $\theta$ | [\[13\]](#ref13)
| Pie chart | {{<figure src="/img/blog/qubit-viz/kitty-pie-minus.svg" width="150px" >}} | {{<figure src="/img/blog/qubit-viz/kitty-pie-bell.svg" width="150px" >}} | ❌| [\[14\]](#ref14)|
| State-o-gram | {{<figure src="/img/blog/qubit-viz/state-o-gram-minus.svg" width="175px" >}} | {{<figure src="/img/blog/qubit-viz/state-o-gram-bell.svg" width="175px" >}} | $\theta$| [\[15\]](#ref15)|
| Q-sphere | {{<figure src="/img/blog/qubit-viz/q-sphere-minus.svg" width="175px" >}} | {{<figure src="/img/blog/qubit-viz/q-sphere-bell.svg" width="175px" >}} | $\color{green}\theta$ | [\[16\]](#ref16)|
| BEADS | {{<figure src="/img/blog/qubit-viz/qubeads-minus.svg" width="175px" >}} | {{<figure src="/img/blog/qubit-viz/qubeads-bell.svg" width="250px" >}} | $\theta$ | [\[16\]](#ref16)|

Phase column key:
* ❌: Phase not represented
* $\pm$: Only phases of $\pm 1$ represented
* $\color{green}\theta$: All phases $e^{i\theta}$ represented using color
* $\theta$: All phases $e^{i\theta}$ represented

# Bibliography

1. <a id="ref1"></a>M. A. Nielsen and I. L. Chuang, [_Quantum Computation and Quantum Information: 10th Anniversary Edition_](https://amazon.com/dp/1107002176). Cambridge University Press, 2010.
2. <a id="ref2"></a>N. D. Mermin, [_Quantum Computer Science: An Introduction_](https://amazon.com/dp/0521876583). Cambridge University Press, 2007.
3. <a id="ref3"></a>E. G. Rieffel and W. H. Polak, [_Quantum Computing: A Gentle Introduction_](https://amazon.com/dp/0262526670). Cambridge, Massachusetts London, England: The MIT Press, 2014.
4. <a id="ref4"></a>B. Burd, [_Quantum Computing Algorithms: Discover how a little math goes a long way_](https://amazon.com/dp/1804617377). Birmingham: Packt Publishing, 2023.
5. <a id="ref5"></a>R. J. Lipton and K. W. Regan, [_Introduction to Quantum Algorithms via Linear Algebra_](https://amazon.com/dp/0262045257/), second edition. Cambridge, Massachusetts: The MIT Press, 2021.
6. <a id="ref6"></a>T. Rudolph, [_Q is for Quantum_](https://www.qisforquantum.org/). Wroclaw: Terence Rudolph, 2017.
7. <a id="ref7"></a>S. E. Economou, T. Rudolph, and E. Barnes, “[Teaching quantum information science to high-school and early undergraduate students](http://arxiv.org/abs/2005.07874),” Aug. 08, 2020, arXiv: arXiv:2005.07874.
8. <a id="ref8"></a>A. J. Adams et al., “[Qwerty: A Basis-Oriented Quantum Programming Language](https://doi.org/10.1109/QCE65121.2025.00093),” in Proceedings of the 2025 IEEE International Conference on Quantum Computing and Engineering (QCE '25), Aug. 2025, pp. 804–815.
9. <a id="ref9"></a>P. K. Aravind, “[Borromean Entanglement of the GHZ State](https://doi.org/10.1007/978-94-017-2732-7_4),” in _Potentiality, Entanglement and Passion-at-a-Distance: Quantum Mechanical Studies for Abner Shimony Volume Two_, R. S. Cohen, M. Horne, and J. Stachel, Eds., in Boston Studies in the Philosophy of Science. Dordrecht: Springer Netherlands, 1997, pp. 53–59.
10. <a id="ref10"></a>A. Sugita, “[Borromean Entanglement Revisited](http://arxiv.org/abs/0704.1712),” In Proceedings of International Workshop on Knot Theory for Scientic Objects, Mar. 2006, Osaka, Japan.
11. <a id="ref11"></a>E. R. Johnston, N. Harrigan, and M. Gimeno-Segovia, [_Programming Quantum Computers: Essential Algorithms and Code Samples_](https://amazon.com/dp/1492039683). O’Reilly Media, Inc., 2019.
12. <a id="ref12"></a>B. Just, [_Quantum Computing Compact: Spooky Action at a Distance and Teleportation Easy to Understand_](https://link.springer.com/book/10.1007/978-3-662-65008-0). Berlin, Heidelberg: Springer, 2022.
13. <a id="ref13"></a>J. Bley et al., “[Visualizing entanglement in multiqubit systems](https://doi.org/10.1103/PhysRevResearch.6.023077),” Phys. Rev. Res., vol. 6, no. 2, p. 023077, Apr. 2024.
14. <a id="ref14"></a>K. Yeung, [_Quantum Computing & Some Physics: The Quantum Computing Comics Notebook_](https://amazon.com/dp/B08HGLPZXP). 2020.
15. <a id="ref15"></a>F. Schinkel, “[state-o-gram -- A Novel 2D Visualization for Quantum States](http://arxiv.org/abs/2508.18390),” Aug. 25, 2025, arXiv: arXiv:2508.18390.
16. <a id="ref16"></a>[IBM Quantum Composer](https://quantum.cloud.ibm.com/composer). 2025.
