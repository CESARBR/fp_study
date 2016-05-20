# Lecture 1B MIT (sicp)

## Procedures and Processes: Substitution model

Models to describe processes.

**Ex: Sum of Squares**

	> (define (SOS x y) 
		(+ (SQ x) (SQ y)))
	> (define (SQ x)
		(* x x))
	> (SOS 3 4)
	> 16
	
### Kinds of expression

How evaluate those things?

* Numbers
* Symbols
* Lambda expressions (`lambda`)
* Definitions (`define`)
* Conditions (`cond`)
* Combinations (`()`)
	
### Substitution rule

Using ?? order evaluation

	* To evaluate an application
		* Evaluate the operator to get the procedure
		* Evaluate the operands to get arguments
		* Apply the procedure to the arguments
			* Copy the body of the procedure, substituting the arguments supplied for the formal parameters of the procedure
			* Evaluate the resulting new body
			
**Ex: Using the reduction step**

		(SOS 3 4)
			|
	(+ (SQ 3) (SQ 4))
			|
	(+ (SQ 3) (* 4 4))
			|
	  (+ (SQ 3) 16)
			|
	 (+ (* 3 3) 16)
	 		|
	 	(+ 9 16)
	 		|
	 	   25

**To evaluate a Condition**
	
	(if <predicate>
		<consequent>
		<alternative>)

	*Evaluate the predicate expr
		* If it yelds TRUE
			* Evaluate the <consequent> expression
		* Otherwise
			* Evaluate the <alternative> expression
** Ex: Sum of `x` and `y` using Peano's arithmectic, incrementing and decrementing numbers.**
 
 	> (describe (+ x y)
 		if (= x 0)
 			y
 			(+ (-1+ x) (1+ y)))
 	
 	
** Reduction: from right to left**
 
 					(+ 3 4)
 						|
 		(if (= 3 0) 4 (+ (-1+ 3) (1+ 4)))
 						|
		 		(+ (-1+ 3) 5)
 						|
			 		(+ 2 5)
				 		|
 		(if (= 2 0) 5 (+ (-1+ 2) (1+ 5)))
				 		|
		 		(+ (-1+ 2) 6)
 						|
			 		(+ 1 6)
				 		|
 		(if (= 1 0) 6 (+ (-1+ 1) (1+ 6)))
				 		|
		 		(+ (-1+ 1) 7)
 						|
 					(+ 0 7)
 						|
		(if (= 0 0) 7 (+ (-1+ 0) (1+ 7)))
						|
						7



**The idea is develop some intuition about how programs evolve processes.**

Lets analize two algorithms for add rwo numbers using Peano's arithmetic.

	/* first */
	> (define (+ x y)
		if (= x 0)
			y
			(+ (-1+ x ) (1+ y)))


	/* second */
	> (define (+ x y)
		if (= x 0)
			y
			(1+ (+ (-1+ x) y)))

** Reduction steps **

		/* Reduction of the first */

 					(+ 3 4)
 					   |					
 					(+ 2 5)
 					   |
 					(+ 1 6)
 					   |
 					(+ 0 7)
 					   |
 					   7
 					
		/* Reduction of the second */
				   
 					(+ 3 4)
 					   |					
 				  (1+ (+ 2 4))
 					   |
 			   (1+ (1+ (+ 1 4)))
 					   |
 			 (1+ (1+ (1+ (+ 0 4))))
 					   |
 				(1+ (1+ (1+ 4)))
 					   |
 				  (1+ (1+ 5)) 				
 					   |
 				 	(1+ 6)
 					   |
 					   7

### Analizing the complexity in time and space

The number os steps is an approximation of the amount of time it takes. And the width of the reduction is how much it has to remember in order to continue the proccess (the space).

In the **first algorithm** the time is proporcional to the argument `x`, therefore it has time complexity equals to **`O(x)`**. The space is constant **`O(1)`** (considering that the every number has the same size). Its complexities characterize a **linear iterative process** model.

The **second algorithm** both time and space have complexity equals to **O(x)**. It characterize a **linear recursion process** model, given this is proportional to `x` in both time and space.

Both algorithms have **recursive definition**, since they have definitions that refer to the thing being defined in the definition, although they lead to different process models.

#### Bureaucracy

	   /* Iteration process */

	   PR 7 -> PR 3,4 -> PR 2,5 
		  \				 /
		  PR 0,7 <- PR 1,6
	 	 

		/* Recursion process */

	   PRA 3,4   PRB 2,4   PRC 1,4
       __>__     __>__     __>__	
	  /     \   /     \   /     \ 
	PRA    PRB 1+     PRC 1+     ...
	  \__<__/   \__<__/   \__<__/
	     7         6         5
	     

THe recursion process gets more bureaucrecy, since it keeps "more people busy". The idea here is how to think what an iteration is and the diff between an iteration and a recursion. 

But the question is how much stuff is hidden. 

In the **iteration** model, if at some point it loses the state of affairs, it could continue the computation from that point. Everithing that it needs to continue the computations is in valuables of that where defined in the **procedure** that the written program offers to you. An iteration is a system that has all of its states in explicit variables. Whereas the **recursion** is not quite the same. If you lose the right side expressions, there is not enough information to continue the process.

**Example:** Physical analogies - Plotting a circle given the equation

* `X' = X - Y * dt`

* `Y' = Y + X * dt`

**Implementation**

	> (define (CIRCLE x y)
		(PLOT x y)
		(CIRCLE (- x (* y dt)))
		(CIRCLE (+ y (* x dt))))

The purpose is feeling out how the program represents itself as the rule for the evaluation of a process.

**Example:** Fibonacci numbers - Recurrence relation

	> (define (FIB n)
		(if (< n 2)
			n
			(+ (FIB (- n 1)) (FIB (- n 2)))))
			

**Reduction**

	> (FIB 4)
	> (+ (FIB 3) (FIB 2))
	> (+ (+ (FIB 2) (FIB 1)) (+ (FIB 1) (FIB 0)))
	> (+ (+ (+ (FIB 1) (FIB 0)) 1) (+ 1 0))
	> (+ (+ (+ 1 0) 1) (+ 1 0))
	> (+ (+ 1 1) 1)
	> (+ 2 1)
	> 3

**Evaluation tree**	

					   (FIB 4)
				  	  /       \
				 	 /         \
				(FIB 3)        (FIB 2)
				/     \        /     \
	  	  (FIB 2)  (FIB 1)  (FIB 1) (FIB 0)
    	  /    \      |	       |      |
	 (FIB 1) (FIB 0)  1        1      0

					

**Complexity**

* The process time grows exactly at fibonacci numbers, so the time complexity is order of `O(fib(n))`. The reason why the time has to grow that way is because it is presumming in the model (the substitution model), i.e. presumming that everything is done sequentially. That every node in the tree has to be examined. And so, since the number of nodes in the tree grows exponentially, because it adds a proportion of the existing nodes to other nodes, for example imagine the processes to calculate the `FIB(5)`, then you should notice that there is an **exponential explosion** for this procedure.

**Result:** This is a prescription for a process that's exponential in time.


* The amount of space that takes up is the longest path of the tree(the heigh), so is order of `O(n)`. i.e. It needs to remember in every level of the tree.

**Iteractive implementation**

*TODO*

### Towers of Hanoi
 
The way in which you would construct a recursive process is by a free **wishful thinking**.

	> (define (MOVE N FROM TO SPARE)
		(cond ((= N 0) "")
			  (else 
			  (MOVE (-1+ N) FROM SPARE TO)
			  (PRINT-MOVE FROM TO)
			  (MOVE (-1+ N) SPARE TO FROM)))

N is the height of the tower


**Reduction**

	> (MOVE 3 1 2 3)
	> ((MOVE 2 1 3 2) (PRINT-MOVE 1 2) (MOVE 2 3 2 1))
	> (((MOVE 1 1 2 3) (PRINT-MOVE 1 3) (MOVE 1 2 3 1)) (PRINT-MOVE 1 2) ((MOVE 1 3 1 2) (PRINT-MOVE 3 2) (MOVE 1 1 2 3)))
	> ((((MOVE 0 1 3 2) (PRINT-MOVE 1 2) (MOVE 0 3 2 1)) (PRINT-MOVE 1 3) ((MOVE 0 2 1 3) (PRINT-MOVE 2 3) (MOVE 0 1 3 2))) (PRINT-MOVE 1 2) (((MOVE 0 3 2 1) (PRINT-MOVE 3 1) (MOVE 0 2 1 3)) (PRINT-MOVE 3 2) ((MOVE 0 1 3 2) (PRINT-MOVE 1 2) (MOVE 0 3 2 1))))
	> ((("" "1->2" "") "1->3" ("" "2->3" "")) "1->2" (("" "3->1" "") "3->2" ("" "1->2" "")))
	> "1->2, 1->3, 2->3, 1->2, 3->1, 3->2, 1->2"

**Evaluation tree**	

																						(MOVE 3 1 2 3)
																								|
																		((MOVE 2 1 3 2) (PRINT-MOVE 1 2) (MOVE 2 3 2 1))
																		/						|						\
										((MOVE 1 1 2 3) (PRINT-MOVE 1 3) (MOVE 1 2 3 1))      "1->2"	((MOVE 1 3 1 2) (PRINT-MOVE 3 2) (MOVE 1 1 2 3))
										/						|				|								|				|						\
		((MOVE 0 1 3 2) (PRINT-MOVE 1 2) (MOVE 0 3 2 1))      "1->3"			|								|		      "3->2"	((MOVE 0 1 3 2) (PRINT-MOVE 1 2) (MOVE 0 3 2 1))
				|				|				|								|								|								|				|				|
				""			  "1->2"			""		((MOVE 0 2 1 3) (PRINT-MOVE 2 3) (MOVE 0 1 3 2))		|								""		      "1->2"			""
																|				|				|				|
																""		      "2->3"			""				|
																												|
																						((MOVE 0 3 2 1) (PRINT-MOVE 3 1) (MOVE 0 2 1 3))
																								|				|				|
																								""		      "3->1"			""


**Complexity**

*TODO*

**Iteractive implementation**

*TODO*
