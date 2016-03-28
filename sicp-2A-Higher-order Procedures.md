# Lecture 2A MIT (sicp)

## Higher Order Procedures


**Example: Calculate the sum of integers, f(a,b) = a1 + a2 + a3 + ... + an a1 = a, ai = ai-1+1, an=b **

	> (define (SUM-INT A B)
		(if (> A B)
			0
			(+ A (SUM-INT (1+ A) B))))
			
Undertanding by substitution model

	> (SUM-INT 3 5)
	> (+ 3 (SUM-INT 4 5))
	> (+ 3 (+ 4 (SUM-INT 5 5)))
	> (+ 3 (+ 4 (+ 5 (SUM-INT 6 5))))
	> (+ 3 (+ 4 (+ 5 0)))
	> 12
	

**Example: Calculate the sum of the square of integers, f(a,b) = a1^2 + a2^2 + a3^2 + ... + an^2 a1 = a, ai = ai-1+1, an=b **

	> (define (SUM-SQ A B)
		(if (> A B)
			0
			(+ (SQ A) (SUM-SQ (1+ A) B))))


**Example: Leibniz formula to find pi over 8**

	> (define (PI-SUM A B)
		(if (> A B)
			0
			(+ (/ 1 (* A (+ A 2)))
				(PI-SUM (+ A 4) B))))

Analyzing the pattern

	> (define (<NAME> A B)
		(if (> A B)
			0
			(+ (<TERM> A)
				(<NAME> (<NEXT> A) B))))

###Sigma notation: Expression that produces a anonym procedure

	> (define (SUM TERM A NEXT B)
		(if (> A B)
			0
			(+ (TERM A)
				(SUM TERM (NEXT A) NEXT B))))
	
Writing down the previous programs as instances of `SUM`


**`SUM-INT`**

	> (define (SUM-INT A B)
		(define (IDENTITY A) A)
		(SUM IDENTITY A 1+ B))
		
**`SUM-SQ`**

	> (define (SUM-SQ A B)
		(SUM SQUARE A 1+ B))
		
**`PI-SUM`**

	> (define (PI-SUM A B)
		(SUM (lambda (I) (/ 1 (* (I (+ I 2))))) 
			A 
			(lambda (J) (+ J 4)) 
			B))
			

###Iterative implementation of `SUM`

 	
 	> (define (SUM TERM A NEXT B)
 		(define (ITER J ANS)
 			(if (> J B)
 				ANS
 				(ITER (NEXT J) (+ (TERM J) ANS))))
 		(ITER A 0))
 		
 Undertanding by substitution model
 
 	> (SUM-INT 3 5)
 	> (SUM IDENTITY 3 1+ 5)
	> (ITER 3 0)
	> (ITER (1+ 3) (+ 3 0))
	> (ITER 4 3)
	> (ITER (1+ 4) (+ 4 3))
	> (ITER 5 7)
	> (ITER (1+ 5) (+ 5 7))
	> (ITER 6 12)
	> 12
	

**Example: Haron's Algorithm to find the square root of `X` `Y |F--> (Y+X/Y)/2`**

Tip: look for a Fixed point of `F`: Place which has the property that if you put into the function, you get the same value out.

	> (define (sqrt x)
		(FIXED-POINT (lambda (y) (AVERAGE (/ x y) y)) 1))
		
**`FIXED-POINT`**

	> (define (FIXED-POINT F START)
		(define (ITER OLD NEW)
			(if (CLOSE-ENOUGH? OLD NEW)
				NEW
				(ITER NEW (F NEW))))
		(define (CLOSE-ENOUGH? A B)
			(< (ABS (- A B)) TOLERANCE))
		(define TOLERANCE 0.00001)
		(ITER START (F START)))
		
	
	> (define (SQRT X)
		(FIXED-POINT (AVERAGE-DAMP (lambda (y) (/ x y))) 1))
		
	> (define AVERAGE-DAMP
		(lambda (F)
				(lambda (Y) (AVERAGE (F Y) Y))))
				
A procedure that takes a procedure as its argument and produces a procedure as its (return)value.

**Example: Newton's Method to find the roots of a function `F`**

To find a `Y` such that `F(Y) = 0`, starting with a `guess = Yo`,` Yn = Yn - F(Yn) / (dF/dY|Y=Yn)` (The derivative of `F` with respect to `Y`, is a function - multiple derivatives).
Sometime it converges and very fast, and sometimes doesn't converge so it should be handled.

**Implementation of Square Root by Newton's method**

Again, by *wishful thinking*, we will apply the newton's method, assuming the we knew how to do it, (really we don't know how to do it yet).

	> (define (SQRT X)
		(NEWTON (lambda (Y) (- X (SQUARE Y)))
				1))
				
It's the Newton's method applied to a procedure which will represent that function of `Y`. If we had a value of `Y` for which this function was zero, then `Y` would be the square root of `X`.

How we are going to compute Newton's method?

Find the values of `Y` such that `Yn = Yn+1` (in a ceratain degree of accuracy). 


	> (define (NEWTON F GUESS)
		(define DF (DERIV F))
		(FIXED-POINT 
			(lambda (X) (- X (/ (F X) (DF X))))
			GUESS))


We also need a procedure which computes the derivative of the function computed by the given procedure `F`.


	> (define DERIV		
		(lambda (F)
			(lambda (X) 
					(/ (- (F (+ X DX))
						  (F X))
						DX))))
						
	> (define DX 0.00001) //Only for the sake of understanding
	
			
**TIP:** `(DF X)` is the same of `((DERIV F) X)`, since any time we take the signature of something, we can put the thing it's defined to be in place where the signature is (the calling). 

**Example**

 	> (define F (lambda (X) (X)))
 	> (define B (lambda (F) (lambda (X) (F X))))
 	> (define A (B F))
 	
 	> A 3 // >3
 	> B F 3 // > 3
	
####Functions/Procedures like first-class citiziens


	The Rights and privilegies of first-class citiziens:
	
		* to be named like a variable;
		* to be passed as arguments to procedures;
		* to be returned as values of procedures;
		* to be incorporated into data structures.
		
Having functions as first-class citiziens, allows we to make any abstractions we like, it is really powerful!
		
	