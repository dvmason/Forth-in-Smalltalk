"
I am a Forth language runtime
"
Class {
	#name : 'Forth',
	#superclass : 'Object',
	#instVars : [
		'data',
		'words',
		'return',
		'stream',
		'compiling',
		'immediates',
		'defining',
		'smudge'
	],
	#category : 'Forth',
	#package : 'Forth'
}

{ #category : 'compiling' }
Forth >> addToCompilation: aForthWord [ 

	compiling add: aForthWord
]

{ #category : 'initialization' }
Forth >> defineWords [

	^ {
		  (#DUP -> (ForthWord new
			    runtime: self;
			    do: [ data addFirst: data first ])). "Duplicates the top item"
		  (#DROP -> (ForthWord new
			    runtime: self;
			    do: [ data removeFirst ])). "Discards the top item"
		  (#SWAP -> (ForthWord new
			    runtime: self;
			    do: [ data addFirst: (data removeAt: 2) ])). "Swaps the top two items"
		  (#OVER -> (ForthWord new
			    runtime: self;
			    do: [ data addFirst: data second ])). "Copies the second item to the top"
		  (#ROT -> (ForthWord new
			    runtime: self;
			    do: [ data addFirst: (data removeAt: 3) ])). "Rotates the third item to the top"
		  (#+ -> (ForthWord new
			    runtime: self;
			    do: [ data at: 1 put: data removeFirst + data first ])). "add"
		  (#- -> (ForthWord new
			    runtime: self;
			    do: [ data at: 1 put: data removeFirst negated + data first ])). "subtract"
		  (#LIT -> (ForthWord new
			    runtime: self;
			    do: [ data addFirst: stream next ])). "push next value"
		  (#EXIT -> (ForthWord new
			    runtime: self;
			    do: [ stream := return removeFirst ])). "Exit from a word definition"
		  (#':' -> (ForthWord new
			    runtime: self;
			    setImmediate;
			    do: [
					    compiling ifNotNil: [ self error: 'no nested definitions' ].
					    words at: (defining := self parse) put: (compiling := ForthWord new
								                  runtime: self;
								                  startDefinition) ])). "Define word"
		  (#';' -> (ForthWord new
			    runtime: self;
			    setImmediate;
			    do: [
					    compiling ifNil: [ self error: '";" only in definitions' ].
					    compiling finish: (words at: #EXIT).
					    compiling := nil ])). "End define"
		  (#IF -> (ForthWord new
			    runtime: self;
			    setImmediate)). "set up branches"
		  (#THEN -> (ForthWord new
			    runtime: self;
			    setImmediate)).
		  (#ELSE -> (ForthWord new
			    runtime: self;
			    setImmediate)).
		  (#'[' -> (ForthWord new
			    runtime: self;
			    setImmediate)). "evaluate mode within a definition"
		  (#']' -> (ForthWord new
			    runtime: self;
			    setImmediate)). "end evaluation mode"
		  (#'S"' -> (ForthWord new
			    runtime: self;
			    setImmediate)).
		  (#BEGIN -> (ForthWord new
			    runtime: self;
			    setImmediate)).
		  (#UNTIL -> (ForthWord new
			    runtime: self;
			    setImmediate)).
		  (#WHILE -> (ForthWord new
			    runtime: self;
			    setImmediate)).
		  (#REPEAT -> (ForthWord new
			    runtime: self;
			    setImmediate)).
		  (#DO -> (ForthWord new
			    runtime: self;
			    setImmediate)).
		  (#'?DO' -> (ForthWord new
			    runtime: self;
			    setImmediate)).
		  (#LOOP -> (ForthWord new
			    runtime: self;
			    setImmediate)).
		  (#'+LOOP' -> (ForthWord new
			    runtime: self;
			    setImmediate)).
		  (#'."' -> (ForthWord new
			    runtime: self;
			    setImmediate)).
		  (#'C"' -> (ForthWord new
			    runtime: self;
			    setImmediate)).
		  (#LITERAL -> (ForthWord new
			    runtime: self;
			    setImmediate)).
		  (#POSTPONE -> (ForthWord new
			    runtime: self;
			    setImmediate)).
		  (#'(' -> (ForthWord new
			    runtime: self;
			    setImmediate)).
		  (#\ -> (ForthWord new
			    runtime: self;
			    setImmediate)).
		  (#'[CHAR]' -> (ForthWord new
			    runtime: self;
			    setImmediate)) } asDictionary
]

{ #category : 'accessing' }
Forth >> definition: aString [ 

	words at: aString ifPresent: [ : word | |array|
		word value.
		array := stream contents.
		stream := return removeFirst.
		^ array
	]
]

{ #category : 'initialization' }
Forth >> evaluate: aStreamOrString [

	stream := aStreamOrString readStream skipSeparators.
	compiling := nil.
	[ stream atEnd ] whileFalse: [
			(return isEmpty
				 ifTrue: [ self lookup: self parse ]
				 ifFalse: [ stream next ]) value ]
]

{ #category : 'initialization' }
Forth >> initialize [

	super initialize.
	data := OrderedCollection new.
	words := self defineWords.
	return := OrderedCollection new
]

{ #category : 'testing' }
Forth >> isCompiling [

	^ compiling isNotNil
]

{ #category : 'initialization' }
Forth >> lookup: aString [

	^ words at: aString ifAbsent: [
			  (aString allSatisfy: #isDigit)
				  ifTrue: [
						  compiling
							  ifNotNil: [
									  [
										  compiling
											  add: (words at: #LIT);
											  add: aString asInteger ] ]
							  ifNil: [ [ data addFirst: aString asInteger ] ] ]
				  ifFalse: [ self error: 'word not found: ' , aString ] ]
]

{ #category : 'initialization' }
Forth >> parse [

	stream skipSeparators.
	^ String streamContents: [ :s | [ stream atEnd or: [ stream peek isSeparator ] ] whileFalse: [ s nextPut: stream next ] ]
]

{ #category : 'executing' }
Forth >> pushOnReturn: function [

	return addFirst: stream.
	stream := function readStream
]

{ #category : 'accessing' }
Forth >> top [

	^ data first
]
