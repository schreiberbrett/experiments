https://schreiberbrett.github.io/experiments/


```scheme trs2e faster-minikanren base
(defrel (poso x)
  (fresh (a d) (== x `(,a . ,d))))
```


And:

```scheme trs2e faster-minikanren
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
```
