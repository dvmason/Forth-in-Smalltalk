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
		'defining'
	],
	#category : 'Forth-Main',
	#package : 'Forth',
	#tag : 'Main'
}

{ #category : 'compiling' }
Forth >> addToCompilation: aForthWord [ 

	compiling add: aForthWord
]

{ #category : 'compiling' }
Forth >> compileOnly: aString [ 

	compiling ifNil: [ self error: '"', aString, ';" only in definitions' ]
]

{ #category : 'initialization' }
Forth >> defineWords [

	^ {
		  (#DUP -> (ForthWord new do: [ data addFirst: data first ])). "Duplicates the top item"
		  (#DROP -> (ForthWord new do: [ data removeFirst ])). "Discards the top item"
		  (#SWAP -> (ForthWord new do: [ data addFirst: (data removeAt: 2) ])). "Swaps the top two items"
		  (#OVER -> (ForthWord new do: [ data addFirst: data second ])). "Copies the second item to the top"
		  (#ROT -> (ForthWord new do: [ data addFirst: (data removeAt: 3) ])). "Rotates the third item to the top"
		  (#+ -> (ForthWord new do: [ data at: 1 put: data removeFirst + data first ])). "add"
		  (#- -> (ForthWord new do: [ data at: 1 put: data removeFirst negated + data first ])). "subtract"
		  (#* -> (ForthWord new do: [
				    | right |
				    right := data removeFirst.
				    data at: 1 put: data first * right ])). "subtract"
		  (#LIT -> (ForthWord new do: [ data addFirst: stream next ])). "push next value"
		  (#EXIT -> (ForthWord new do: [ stream := return removeFirst ])). "Exit from a word definition"
		  (#'?BRANCH' -> (ForthWord new do: [ stream position: stream next ])). "Exit from a word definition"
		  (#':' -> (ForthWord newImmediate do: [
				    compiling ifNotNil: [ self error: 'no nested definitions' ].
				    words at: (defining := self parse) put: (compiling := ForthWord new startDefinition) ])). "Define word"
		  (#';' -> (ForthWord newImmediate do: [
				    self compileOnly: ';'.
				    compiling finish: (words at: #EXIT) forRuntime: self.
				    compiling := nil ])). "End define"
		  (#IF -> (ForthWord newImmediate do: [
				    self compileOnly: 'IF'.
				    compiling add: (words at: #'?BRANCH').
				    data addFirst: compiling size.
				    compiling add: 0.
				    data addFirst: #IF ])). "set up branches"
		  (#THEN -> ForthWord newImmediate).
		  (#ELSE -> ForthWord newImmediate).
		  (#'[' -> ForthWord newImmediate). "evaluate mode within a definition"
		  (#']' -> ForthWord newImmediate). "end evaluation mode"
		  (#'S"' -> ForthWord newImmediate).
		  (#BEGIN -> ForthWord newImmediate).
		  (#UNTIL -> ForthWord newImmediate).
		  (#WHILE -> ForthWord newImmediate).
		  (#REPEAT -> ForthWord newImmediate).
		  (#DO -> ForthWord newImmediate).
		  (#'?DO' -> ForthWord newImmediate).
		  (#LOOP -> ForthWord newImmediate).
		  (#'+LOOP' -> ForthWord newImmediate).
		  (#'."' -> ForthWord newImmediate).
		  (#'C"' -> ForthWord newImmediate).
		  (#LITERAL -> ForthWord newImmediate).
		  (#POSTPONE -> ForthWord newImmediate).
		  (#'(' -> ForthWord newImmediate).
		  (#\ -> ForthWord newImmediate).
		  (#'[CHAR]' -> ForthWord newImmediate) } asDictionary
]

{ #category : 'accessing' }
Forth >> definition: aString [ 

	words at: aString ifPresent: [ : word | |array|
		word value: self.
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
				ifTrue: [ (self lookup: self parse) ]
				ifFalse: [ stream next ]) value: self ]
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
									  [ : _ |
										  compiling
											  add: (words at: #LIT);
											  add: aString asInteger ] ]
							  ifNil: [ [ : _ | data addFirst: aString asInteger ] ] ]
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
