Class {
	#name : 'ForthTest',
	#superclass : 'TestCase',
	#category : 'Forth-Tests',
	#package : 'Forth',
	#tag : 'Tests'
}

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
