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


