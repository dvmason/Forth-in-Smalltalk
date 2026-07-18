Class {
	#name : 'ForthTest',
	#superclass : 'TestCase',
	#category : 'Forth-Tests-Core',
	#package : 'Forth-Tests',
	#tag : 'Core'
}

{ #category : 'tests' }
ForthTest >> testComments [

	self assert: '6 ( a comment mixed \ more comment) 7 *' asForth top equals: 42.
	self assert: '6 \ a comment
	 7 \ ( comment ) \ more
	* ( comment ) \ comment' asForth top equals: 42.

]

{ #category : 'tests' }
ForthTest >> testErrors [

	self should: [ 'fooBarBaz' asForth ] raise: Error.
	self should: [ ': foo [ foo ] ;' asForth ] raise: Error. "failing for the wrong reason until `[` and `]` are defined "
	self should: [ '[CHAR] a' asForth ] raise: Error " remove once we define `[CHAR]` "
]

{ #category : 'tests' }
ForthTest >> testFibonacci [

	| fib |
	fib := ': RECUR-FIB ( n -- fib_n )
    DUP 2 < IF 
        \ Base cases: if n is 0 or 1, just return n
    ELSE
        DUP 1 - RECURSE    \ Compute Fib(n-1)
        SWAP 2 - RECURSE  \ Compute Fib(n-2)
        +                 \ Add them together
    THEN ;' halt; asForth.
	self assert: (fib evaluate: '1 RECUR-FIB') asForth top equals: 1.
	self assert: (fib evaluate: '2 RECUR-FIB') asForth top equals: 1.
	self assert: (fib evaluate: '3 RECUR-FIB') asForth top equals: 2.
	self assert: (fib evaluate: '4 RECUR-FIB') asForth top equals: 3.
	self assert: (fib evaluate: '5 RECUR-FIB') asForth top equals: 5.
	self assert: (fib evaluate: '6 RECUR-FIB') asForth top equals: 8.
	self assert: (fib evaluate: '10 RECUR-FIB') asForth top equals: 55.
	fib := ':: RECUR-FIB ( n -- fib_n )
    DUP 2 < IF 
        \ Base cases: if n is 0 or 1, just return n
    ELSE
        DUP 1- RECUR-FIB    \ Compute Fib(n-1)
        SWAP 2 - RECUR-FIB  \ Compute Fib(n-2)
        +                 \ Add them together
    THEN ;' asForth.
	self assert: (fib evaluate: '1 RECUR-FIB') asForth top equals: 1.
	self assert: (fib evaluate: '2 RECUR-FIB') asForth top equals: 1.
	self assert: (fib evaluate: '3 RECUR-FIB') asForth top equals: 2.
	self assert: (fib evaluate: '4 RECUR-FIB') asForth top equals: 3.
	self assert: (fib evaluate: '5 RECUR-FIB') asForth top equals: 5.
	self assert: (fib evaluate: '6 RECUR-FIB') asForth top equals: 8.
	self assert: (fib evaluate: '10 RECUR-FIB') asForth top equals: 55.
	fib := ': FIB ( n -- fib_n )
    0 1             \ Initialize the first two Fibonacci numbers ( F_0 and F_1 )
    ROT 0 DO        \ Bring N to the top, loop from 0 to N-1
        OVER +      \ Compute the next Fibonacci number: F_(i+1) = F_i + F_(i-1)
        SWAP        \ Shift the numbers to keep them in order for the next loop
    LOOP 
    DROP ;          \ Discard the leftover F_(n-1) value, leaving F_n on top' asForth.
	self assert: (fib evaluate: '1 FIB') asForth top equals: 1.
	self assert: (fib evaluate: '2 FIB') asForth top equals: 1.
	self assert: (fib evaluate: '3 FIB') asForth top equals: 2.
	self assert: (fib evaluate: '4 FIB') asForth top equals: 3.
	self assert: (fib evaluate: '5 FIB') asForth top equals: 5.
	self assert: (fib evaluate: '6 FIB') asForth top equals: 8.
	self assert: (fib evaluate: '10 FIB') asForth top equals: 55
]

{ #category : 'tests' }
ForthTest >> testIF [

	| f foo |
	f := ': foo 2 < IF 3 ELSE 42 THEN ; ' asForth.
	foo := f definition: #foo.
	self assert: foo first equals: (f lookup: #LIT).
	self assert: foo second equals: 2.
	self assert: foo third equals: (f lookup: #<).
	self assert: foo fourth equals: (f lookup: #'?BRANCH').
	self assert: foo fifth equals: 9.
	self assert: foo sixth equals: (f lookup: #LIT).
	self assert: foo seventh equals: 3.
	self assert: foo eighth equals: (f lookup: #BRANCH).
	self assert: foo ninth equals: 11.
	self assert: (foo at: 10) equals: (f lookup: #LIT).
	self assert: (foo at: 11) equals: 42.
	self assert: (foo at: 12) equals: (f lookup: #EXIT).
	self assert: ': foo 2 < IF 3 ELSE 42 THEN ; 3 foo' asForth top equals: 42.
	self assert: ': foo 2 < IF 3 ELSE 1 IF 42 ELSE 17 THEN THEN ; 3 foo' asForth top equals: 42
]

{ #category : 'tests' }
ForthTest >> testLookup [

	self assert: (Forth new lookup: '42') equals: 42.
	self assert: (Forth new lookup: '16r2a') equals: 42.
	self should: [ Forth new lookup: '42foo' ] raise: Error.
	self should: [ Forth new lookup: 'wefkae323^^&' ] raise: Error.
	self assert: (Forth new lookup: 'DO') isForthWord.
	self assert: (Forth new lookup: 'DUP') isForthWord
]

{ #category : 'tests' }
ForthTest >> testSimple [

	| f |
	self assert: '2 3 +' asForth top equals: 5.
	f := ' : foo 2 + ;' asForth.
	self assert: (f definition: #foo) equals: {
			(f lookup: #LIT).
			2.
			(f lookup: #+).
			(f lookup: 'EXIT') }.
	self assert: (f evaluate: '3 foo') top equals: 5
]
