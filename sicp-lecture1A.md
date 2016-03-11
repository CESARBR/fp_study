# Lecture 1A MIT - Structure and implementation of Computer Programs (sicp)

Computer science deals with idealized componentes, we know as much as we want about these little program and the data pieces that we're fitting things together. We don't have to worry about tolerance. And that means that, in building a large program, there's not all that much difference between what I can build and what I can imagine, because the parts are these abstract entities that I know as much as I want. I know about them as precisely as I'd like. So as opposed to other kinds of engineering where the contraints are the constraints of the physics systems. The constraints imposed in buildind large softwares system are the limitations of own our minds!

## Understanding the imperative knowledge


Understand functions like black boxes that hide the details of the `howt to's`.

* Example: Compute sqrt(x)
	
	* Find a fixed ponit y
	* F(y) = y
	* increment y -> Average(y, x/y)

*

	36 ->|Fixed point| -> |To find `SQRT` of `x`| -> 6
*

## Black-box abstration
Defining the contents of a black-box

* Primitive objects
	* Primitive procedures
	* Primitive data
* Means of combination
	* Procedure composition
	* Construction of compounding data
* Means of abstraction
	* Procedure definition
	* Simple data abstraction
* Capturing common patterns
    * High Order procedures
    * Data as procedures
* Conventional interfaces
	* Generic Operations
	* Large-scale structure and modularity
	* Object Oriented Programming
	
## Basic technique for controlling complexity is making new languages

The purpose of the new design language will be to highlight different aspects of the system

* It will suppress some kinds of details and emphasize other kind of details;
* Evaluate the Lisp language;
* Metalinguistic abstraction: abstracting by talking about how you contruct new languages and the process of interpretation;
* Interpretation: Apply and Eval orders;
* Example: Logic programming and register machines;

## Introdution to Lisp (part2 - text section 1.1)
	
	* What are the Primitive elements?
	* What are the Means of combination of Lisp, to put things together?
	* What are the Means of abstraction? 
	* How do we take those complicated things and draw the boxes around it?
	
### Primitive data and procedures
Has lisp primitive data and procedures?

**Implementation**

	> (+ 3 17.4 5) -> 25.4 // '+' is the operator, 3, 17.4 and 5 are the operands and '()' make combinations
	
	> (+ 3 (* 5 6) 8 2) //Prefixed notation
	> 43
	> (+ 12 (* 4 3)
			(+ 2 
			   43
			   (* 3 40))
			50)
			
	>
	
	> (+ (* 3 5)
		 (* 47
		 	(- 20 6.8))
		 12)
	
	> 647.4
	> (define A (* 5 5))
	> (* A A)
	> (define B (+ A (* 5 A)))
	> B
	> 150
	> (+ A (/ B 5))
	> 55

### With Parameters

**Implementation**

	> (define (SQUARE x) (* x x))
	> (SQUARE 10)
	> 100
	> (define SQUARE (lambda (x) (* x x))) //Defining a symbol -> lambda makes a procedure
	> (define (AVERAGE x y) (/ (+ x y) 2))
	> (define (MEAN-SQUARE x y)
		(AVERAGE (SQUARE x)
	             (SQUARE y)))
	> (MEAN-SQUARE 2 3)
	> 6.5
	
There is no difference between things that are built in and things that are `compound`. Because the things that are compound heve an abstraction wrapped around them.

### Making Case Analysis

Example: Calculate the absolute value of x

	Mathematical definition:
	
		|x| = -x 	if x < 0
		|x| = 0  	if x = 0
		|x| = x  	if x > 0
			
**Implementation**

	> (define (ABS X)
              (cond ((< x 0) (-x))
                    ((= x 0) 0)
                    ((> x 0) x))

### Eval and Apply

Square root algorithm (of Heron of Alexandria)


  * To find a approximation to `SQRT(x)`
  	* Make a guess `guess`
  	* Improve that guess by averaging `guess` and `x/guess`
  	* Keep improving that guess until it is good enough
  	* Use 1 as initial guess
  
**Implementation**

	> (define (SQRT x) (TRY 1 x))
	> (define (TRY guess x)
		(if (GOOD-ENOUGH? guess x)
			(guess)
			(TRY (IMPROVE guess x) x)))
	> (define (GOOD-ENOUGH? guess x)
		(< (ABS (- (SQUARE guess) x)))
		   0.001))
	> (define (IMPROVE guess x)
		(AVERAGE guess (/ x guess)))
	
**Evaluation tree (TODO)** 

				SQRT
				 |
				TRY 
	           /  \
	  GOOD-ENOUGH?	 IMPROVE	   		
      /         \      \       
    ABS       SQUARE  AVERAGE


### Recursive definition

The ability to make recursive definitions is a source of incredible power!

			    (SQRT 2)
				    |
			    (TRY 1 2)
	           /
	 (GOOD-ENOUGH? 1 2)	 	   		
              \
      (TRY (IMPROVE 1 2) 2)
     			 \
     		(TRY (AVERAGE 1 (/ 2 1)) 2)
					\
     		     (TRY 1.5 2)
     		          \
     		  (TRY (AVERAGE 1.5 (/ 2 1.5)) 2)
     		            \
            		  (TRY 1.33 2)
            		  		
            		        .
            		        .
            		        .
            		        
            		   1.414211568

### Defining the square root box

* Block Structure
Particular way of packaging internals inside of a definition

|  *  | **Procedures** | **Data**|
|:------------:|:-------------: |:------------:|
|Primitive Elements  | `+`, `*`, `<`, `=`   | `23`, `1.735`|
|Means of Compination  | `()`, `cond`, `diff`  | ??? |
|Means of Abstraction  | `define`   | ??? |


**How to create conventional methods of doing things?**

	> (define (SQRT x) 
		(TRY 1 x)	
		(define TRY guess
			(if (GOOD-ENOUGH? guess)
				(guess)
				(TRY (IMPROVE guess))))
		(define (IMPROVE guess)
			(AVERAGE guess (/ x guess)))
		(define (GOOD-ENOUGH? guess)
			(< (ABS (- x (SQUARE guess)))))
		(define (SQUARE guess)
			(* guess guess)))
	
