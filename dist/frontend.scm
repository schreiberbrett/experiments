(defrel (evalo f env o)
  (conde ((fresh (x)
            (== f `(var ,x))
            (lookupo x env o)))
         ((fresh (f1 f2 o1 o2)
            (== f `(nand ,f1 ,f2))
            (nando o1 o2 o)
            (evalo f1 env o1)
            (evalo f2 env o2)))))


(defrel (synthesizeo ckt)
  (evalo ckt '((a . 0) (b . 0)) 1)
  (evalo ckt '((a . 0) (b . 1)) 1)
  (evalo ckt '((a . 1) (b . 0)) 1)
  (evalo ckt '((a . 1) (b . 1)) 0))


(defrel (poso x)
  (fresh (a d) (== x `(,a . ,d))))


(defrel (olego n)
  (conde ((== n '()))
         ((fresh (a d)
            (== n `(,a . ,d))
            (conde ((== a 0) (poso d))
                   ((== a 1)))
            (olego d)))))


(defrel (membero x l)
  (fresh (a d)
    (== l `(,a . ,d))
    (conde ((== x a))
           ((membero x d)))))


