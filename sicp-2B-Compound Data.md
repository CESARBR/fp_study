# Lecture 2B MIT (sicp)

## Compound Data

The crucial idea is that when we're building, we divorce the task of building a thing of the task of implementing the parts. And in a large system we have abstraction barriers like this at lots and lots and lots of levels. Now what we're going to do is look at the same issues for **data**.

### Representing a Rational Number (Fractions)

Representing a Rational Number (Fractions), using the design strategy of Wishiful Thinking

**SUM (+)**: `N1/D1 + N2/D2 = (N1 * D1 + N2 * D2) / D1 * D2`

**MULTIPLICATION (*)**: `N1/D1 * N2/D2 = (N1 * N2) / (D1 * D2)`


	; Data Constructor -> (MAKE-RAT N D)
	
	; Data Selectors -> (NUMER (MAKE-RAT N D)) and (DENOM (MAKE-RAT N D))

`SUM (+)`

	> (define (+RAT X Y)
		(MAKE-RAT
			(+ (* (NUMER X) (DENOM Y)
			   (* (NUMER Y) (DENOM Y)))
			(* (DENOM X) (DENOM Y))))
	
`MULTIPLICATION (*)`	

	> (define (*RAT X Y)
		(MAKE-RAT 
			(* (NUMER X) (NUMER Y))
			(* (DENOM X) (DENOM Y))))
			
			
	;(X + Y) * (S + T)
	> (*RAT (+RAT X Y) (+RAT S T))

How can we go and package together a numerator and a denominator and actually make one of these entities? We need a kind of glue for data objects.

### List Structure
Is a way of gluig things together, and more precisely, Lisp provides a way of contructing things called ***pairs***.

**The primitive operator `cons`**

	> (cons X Y) ; Constructs a pairs whose first part is X and second is Y.
	
**The primitive operator `car`**

	> (car X Y) ; Selects the first part of the pair P.

**The primitive operator `cdr`**
	
	> (cdr X Y) ; Selects the second part of the pair P.
	
This is a conventional way of writing the Plato's idea of two - draw a diagram to represent cons of two and three

	> (cons 2 3)
  	
  	; Box and pointer notation
  
  	If we have any X and Y
  		For any X and Y
  			(car (cons X Y))   ; Is X
	  		(cdr (cons X Y))   ; Is Y
	  		
	
**Defining MAKE-RAT, NUMER and DENOM**

`MAKE-RAT`
	
	> (define (MAKE-RAT N D)
		(cons N D))


`NUMER`
	
	> (define (NUMER X)
		(car X))

`MAKE-RAT`
	
	> (define (DENOM X)
		(cdr X))

Executing 1/2 + 1/4

	> (define A (MAKE-RAT 1 2))
	> (define B (MAKE-RAT 1 4))
	> (define ANS (+RAT A B))
	> (NUMER ANS) ; -> 6
	> 6
	> (DENOM ANS) ; -> 8
	> 8
	
A better implementation of MAKE-RAT

	> (define (MAKE-RAT N D)
		(let ((G (gdc N D)))
			(cons (/ N G)
				  (/ D G))))
				  
The important thing to notice here is that there's a abstraction layer between the way that a rational number is constructed and the operations over these rational number.

**Abstraction Layers**

	+RAT / *RAT / -RAT ... ; -> Use 
	
	↕
	
	MAKE-RAT / NUMER / DENOM ; -> Abstraction Layer(Constructors and selectors) 
	
	↕
	
	cons car cdr	; -> Representation Layer 


I.e. we're separating the way something is used (the use of data objects) from the representation of data objects. The name of this methodology is ***data abstraction***, i.e. is a sort of programming methodology of setting up data objects by postulating **constructors** and **selectors** to isolate use from representation.

Defining +RAT without data abstraction
	
	> (define (+RAT X Y)
		(cons (+ (* (car X) (cdr Y))
			  	 (* (car Y) (cdr X)))
			  (* (cdr X) (cdr Y))))

One of the advantages of data abstraction is that we can have any representation of data objects (another way of contruct and select)
	
**For instance, we can have another ways of contruct and select:**
*TODO*

Which one is better? Depends on, if you I'm making a system where I'm mostly constructing rational numbers and hardly ever looking at them, then it's probably better not to do that `gdc` computation when I construct them. If I'm doing a system where I look at things a lot more then I construct them, then is probably better to do the work when I construct them.

What that was doing is giving a name to the decicion of how I'm going to do it, and then continuing as if we made the decision. And then eventually, when we really wanted it to work coming back and facing what we we really had to do. And in fact, we'll see a couple of times from now, that you may never have to choose any particular representation, ever, ever. Anyway, thats a very powerful design technique its the key reason people use data abstraction.


### Representing geometric entities in the plane

**Representing points/vectors**

	> (define (MAKE-VECTOR X Y) (cons X Y)) ; Constructor -> (X, Y)
	> (define (XCOR P) (car P))		; Selector for X cordinate 
	> (define (YCOR P) (cdr P))		; Selector for Y cordinate 

**Representing line segments**

	> (define (MAKE-SEGMENT P Q) (cons P Q))
	> (define (SEG-START S) (car S))
	> (define (SEG-END S) (cdr S))
	
**Defining operations over segments**	

	> (define (MID-POINT S)
		(let ((A (SEG-START S))
			  (B (SEG-END S)))
			 (MAKE-VECTOR
				(average (XCOR A) (XCOR B))
				(average (YCOR A) (YCOR B)))))

**Defining the length of the segment**	

	> (define (LENGTH S)
		(let ((DX (- (XCOR (SEG-START S	) (XCOR (SEG-END S))))
			  (DY (- (YCOR (SEG-START S	) (YCOR (SEG-END S)))))
			 (sqrt (+ (square DX) (square DY)))))

**Abstraction Layers**


	Segments
	
	↕
	
	MAKE-SEG / SEG-START / SEG-END
	
	↕
	
	Vectors
	
	↕
	
	MAKE-VECTOR / XCOR / YCOR

	↕

 	Pairs

One of your tests of quality for a means of combination that someone shows you is: **are things closed under the means of combinations?**

**Redefining length**

	> (define (LENGTH S)
		(let ((DX (- (car (car S) (car (cdr S))))
			  (DY (- (cdr (car S) (cdr (cdr S)))))
			 (sqrt (+ (square DX) (square DY)))))
			 

This isn't a good implementation of `LENGTH` because if for any reason the way `S` is represented changes, this `LENGTH` will need to be rewritten. This wouldn't happen in the previous implementation, as long as the selectors were reimplemented to mirror `S` changes.

###Using axioms to define data

**Axiom for a rational number**

	If X is (MAKE-RAT N D)
		then (NUMER X)/(DENOM X) is N/D
		
The basis for a rational number representation doesn't care about the *how to*, it is below the layer of abstraction.

**Axiom for a pairs**
	
	For any X and Y
		(car (cons X Y)) is X
		(cdr (cons X Y)) is Y

One possible definition of `cons`, `car` and `cdr`

`cons`

	> (define (cons a b)
		(lambda (pick)
			(cond ((= pick 1) a)
				  ((= pick 2) b))))

`car`
			  
	> (define (car x) (x 1))
	
	
`cdr`
			  
	> (define (cdr x) (x 2))
	
These implementations show how we can build data representations out of functions. Below there is an example of the reduction of `car`:

	> (car (cons 37 49))
	> (car (lambda (pick)
			(cond ((= pick 1) 37)
				  ((= pick 2) 49))))
	> ((lambda (pick)
			(cond ((= pick 1) 37)
				  ((= pick 2) 49)))
	   1)
	> (cond	((= 1 1) 37)
			((= 1 2) 49))
	> 37

