(defrel (evalo f env o)
  (conde ((fresh (x)
            (== f `(var ,x))
            (lookupo x env o)))
         ((fresh (f1 f2 o1 o2)
            (== f `(nand ,f1 ,f2))
            (nando o1 o2 o)
            (evalo f1 env o1)
            (evalo f2 env o2)))))


(defrel (nando x1 x2 o)
  (conde ((== x1 1) (== x2 1) (== o 0))
         ((=/= x1 1) (== o 1))
         ((=/= x2 1) (== o 1))))


(defrel (lookupo x l o)
  (fresh (k v d)
    (== l `((,k . ,v) . ,d))
    (conde ((==  x k) (== v o))
           ((=/= x k) (lookupo x d o)))))


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


(defrel (primeo n)
  (olego n)
  (project (n)
    (== #t (prime? (unbuild-num n)))))

(define (unbuild-num n)
  (cond ((null? n) 0)
        (else (+ (car n) (* 2 (unbuild-num (cdr n)))))))

(define (prime? n)
  (let loop ((i 2))
    (cond ((<= n 1) #f)
          ((= i n) #t)
          ((= (modulo n i) 0) #f)
          (else (loop (+ i 1))))))


(defrel (membero x l)
  (fresh (a d)
    (== l `(,a . ,d))
    (conde ((== x a))
           ((membero x d)))))


(defrel (membero/diseq x l)
  (fresh (a d)
    (== l `(,a . ,d))
    (conde ((==  x a))
           ((=/= x a) (membero x d)))))


