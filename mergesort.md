# Merge sort
Merge sorting a list of Peano numbers is a rare practical algorithm that is not quadratic and also does not require random access. This is great for miniKanren when terms are trees and symbols.

## Comparisons
Comparing two Peano numbers is a straightforward operation that can be broken into 4 cases: 3 non-recursive, and 1 recursive.
```scheme
(defrel (cmpo n m o)
  (fresh (n-1 m-1)
    (conde ((== n '()) (== m '()) (== o 'eq))
           ((== n `(s . ,n-1)) (== m '()) (== o 'gt))
           ((== n '()) (== m `(s . ,m-1)) (== o 'lt))
           ((== n `(s . ,n-1)) (== m `(s . ,m-1)) (cmpo n-1 m-1 o)))))
```

But this fully grounds Peano numbers `n` and `m`.

Here's a version which leaves `n` and `m` partially fresh by using unification to decide when `n` and `m` are `'eq`. To avoid overlapping `conde` clauses, all other cases must be preceded by the assertion that `n` is disequal from `m`.

```scheme
(defrel (cmpo/diseq n m o)
  (conde ((==  n m) (== o 'eq))
         ((=/= n m)
          (fresh (n-1 m-1)
            (conde ((== n `(s . ,n-1)) (== m '()) (== o 'gt))
                   ((== n '()) (== m `(s . ,m-1)) (== o 'lt))
                   ((== n `(s . ,n-1)) (== m `(s . ,m-1))
                    (cmpo/diseq n-1 m-1 o)))))))
```

## Splitting a list in two

```scheme
(defrel (interleaveo l1 l2 l1<>l2)
  (fresh (a1 a2 d1 d2 d1<>d2)
    (conde ((== l1 '()) (== l2 '()) (== l1<>l2 '()))
           ((== l1 '()) (== l2 `(,a2)) (== l1<>l2 `(,a2)))
           ((== l1 `(,a1 . ,d1)) (== l2 `(,a2 . ,d2))
            (== l1<>l2 `(,a1 ,a2 . ,d1<>d2))
            (interleaveo d1 d2 d1<>d2)))))
```

```
> (run* (a b) (interleaveo a b '(1 2 3 4 5 6 7)))
(((1 3 5) (2 4 6 7)))
```

## Merging
Similar to interleaving, merging is the process of merging two sorted lists. Should the "input" lists be enforced to be sorted?

```scheme
(defrel (mergeo l1 l2 l1--l2)
  (fresh (a1 d1 a2 d2 d1--d2 l1--d2 d1--l2 o)
    (conde ((== l1 '())  (== l2 '()) (== l1--l2 '()))
           ((== l1 `(,a1 . ,d1)) (== l2 '()) (== l1--l2 l1))
           ((== l1 '()) (== l2 `(,a2 . ,d2)) (== l1--l2 l2))
           ((== l1 `(,a1 . ,d1)) (== l2 `(,a2 . ,d2))
            (cmpo/diseq a1 a2 o)
            (conde ((== o 'eq))
                   ((== o 'lt))
                   ((== o 'gt))))))) ;; TODO 
```

## Doing the sorting

```scheme
(defrel (mergesorto i o)
  (conde ((== i '()) (== o '()))
         ((fresh (x) (== i `(,x)) (== o `(,x))))
         ((fresh (l r)
            (interleaveo l r i)
            (mergeo l r o)
            (mergesorto l sort-l)
            (mergesorto r sort-r)))))
```
