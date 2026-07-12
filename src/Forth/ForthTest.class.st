Class {
	#name : 'ForthTest',
	#superclass : 'TestCase',
	#category : 'Forth-Tests',
	#package : 'Forth',
	#tag : 'Tests'
}

{ #category : 'tests' }
ForthTest >> testErrors [

	self should: [ 'fooBarBaz' asForth ] raise: Error.
	self should: [ ': foo [ foo ] ;' asForth ] raise: Error. "failing for the wrong reason until `[` and `]` are defined "
	self should: [ '[CHAR] a' asForth ] raise: Error " remove once we define `[CHAR]` "
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
