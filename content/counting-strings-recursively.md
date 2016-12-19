+++
type = "post"
date = "2016-12-19T08:42:58-05:00"
draft = false
title = "Counting Strings Recursively in Combinatorics"
description = "How I solve recursive string-counting problems in combinatorics"
unlisted = true
hasmath = true
+++

In my combinatorics class, we covered many neat subjects, some easier
and some harder. But one topic performed a near 180° in difficulty once
I understood the process: writing recursive functions to count strings
meeting certain criteria.

Simple Example
--------------

As an easy example, consider counting nonempty binary strings. Imagine
such a string of length $n \in \mathbb{Z}$. We have two possibilities: it ends with
$1$, preceded by a binary string of length $n - 1$; or it ends with $0$,
preceded by another binary string of length $n - 1$. Thus, if $p(n)$
denotes the number of nonempty binary strings of length $n$, by the
addition rule,

\\[ \begin{split} p(n) &= p(n - 1) + p(n - 1) \\\\ &= 2p(n - 1) \end{split} \\]

Now, we should define our base cases. Recall that our string is
nonempty, so the smallest length to consider is $1$. Since only two
one-length binary strings exist,

\\[ p(1) = 2 \\]

This is also the last base case we need, since our recursive definition
of $p(n)$ reaches backwards only one 'deep.' So we should specify that
$n > 1$ in our solution:

**Base cases**    
$p(1) = 2$

**Recursion**    
$p(n) = 2p(n - 1),\ n > 1$

Approaching Harder Problems
---------------------------

Next, let's use the approach described above to solve a tougher problem:

> Give a recursion for the number $g(n)$ of ternary strings of length n
> that do not contain $102$ as a substring.

(This is problem 3 in Section 3.11 of *Applied Combinatorics* by Keller
and Trotter. The book is free as in freedom — you can [browse it
here][1]!)

As before, to find a recursion, imagine a valid string of length $n$
and consider the three cases of the final character:

   * Case 0: The last character is a $0$. The string of length $n - 1$
     preceding this character can be anything, so we have $g(n - 1)$
     possible strings in this case.
   * Case 1: The last character is a $1$. Just like in case 0, we can
     produce a valid $n$-length string by appending a $1$ to any
     valid string of length $n - 1$, so we have $g(n - 1)$
     possibilities for this case too.
   * Case 2: The last character is a $2$. Since we assumed our string
     complies with our requirements, we know our ending $2$ cannot be
     preceded by $10$. Otherwise, we'd have a string ending with $102$,
     violating the assumption that our string is valid.

     So our answer for this case is the number of strings of length $n -
     1$ not terminated by $10$. We can use the [inclusion-exclusion
     principle][2] to find this number: first calculate the number of
     valid strings of length $n - 1$, and then subtract the number of
     valid strings of length $n - 1$ ending in $10$. The former is
     $g(n-1)$. The latter is $g(n - 1 - 2)$, since we fix $10$ as the
     end of our $n - 1$-length string. Then we have $g(n - 1) - g(n -
     3)$ as our solution.

Now, using the addition rule, we find

\\[ \begin{split} g(n) &= g(n - 1) + g(n - 1) + (g(n - 1) - g(n - 3))
\\\\ &= 3g(n - 1) - g(n - 3) \end{split} \\]

Since our recursive definition invokes $g(n - 3)$ at the deepest, we
need to provide a base case for $n = 1,2,3$. $g(1) = 3^1$ and $g(2) =
3^2$ since neither one- nor two-length ternary strings are long enough
to contain the forbidden substring. $g(3) = 3^3 - 1$ because one of the
strings is illegal.

Hence, our answer is:

**Base cases**    
$g(1) = 3$    
$g(2) = 9$    
$g(3) = 26$

**Recursion**    
$g(n) = 3g(n - 1) - g(n - 3),\ n > 3$

<!-- TODO: Do question #5 -->

[1]: http://rellek.net/book/app-comb.html
[2]: https://en.wikipedia.org/wiki/Inclusion%E2%80%93exclusion_principle
