; defining mdc?
(define (mdc x y)
	(cond 
		((= x 0) y)
		((= y 0) x)
		(else 
			(mdc (remainder (max x y) (min x y)) (min x y)))))

; defining coprimo?
(define (coprimo? x y)
	(and (not (= x 1)) (not (= y 1)) (= (mdc x y) 1)))

; defining primo?
(define (primo? n)
	(define divide? (lambda (a b) (if (= (remainder a b) 0) #t #f)))
	(define (pickA guess) 
		(cond 
			((coprimo? guess n) guess)
			(else (pickA (random n)))))
	(define a (pickA 1))
	(define fermat-test (divide? (- (expt a (- n 1)) 1) n))
	(define (by-fermat k)
		(if (< n 3)
			#t
			(if (< k 2) fermat-test
				(and fermat-test (by-fermat (- k 1))))))
	(by-fermat 3))


