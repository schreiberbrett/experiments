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


