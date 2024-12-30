The circuit value problem is difficult to model in miniKanren. The *formula* value problem is easier. Only NAND gates are considered.

```scheme
(defrel (evalo f env o)
  (conde ((fresh (x)
            (== f `(var ,x))
            (lookupo x env o)))
         ((fresh (f1 f2 o1 o2)
            (== f `(nand ,f1 ,f2))
            (nando o1 o2 o)
            (evalo f1 env o1)
            (evalo f2 env o2)))))
```

```scheme
(defrel (nando x1 x2 o)
  (conde ((== x1 1) (== x2 1) (== o 0))
         ((=/= x1 1) (== o 1))
         ((=/= x2 1) (== o 1))))
```


```scheme
(defrel (lookupo x l o)
  (fresh (k v d)
    (== l `((,k . ,v) . ,d))
    (conde ((==  x k) (== v o))
           ((=/= x k) (lookupo x d o)))))
```

Circuit synthesis:

```scheme
(defrel (synthesizeo ckt)
  (evalo ckt '((a . 0) (b . 0)) 1)
  (evalo ckt '((a . 0) (b . 1)) 1)
  (evalo ckt '((a . 1) (b . 0)) 1)
  (evalo ckt '((a . 1) (b . 1)) 0))
```
