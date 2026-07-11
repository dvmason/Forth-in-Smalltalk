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

{ #category : 'initialization' }
Forth >> compiling: aString [

	compiling ifNil: [ ^ nil ].
	immediates at: aString ifPresent: [ :word | ^ word ].
	words at: aString ifPresent: [ :word | ^ [ compiling add: word ] ].
	^ (aString allSatisfy: #isDigit)
		  ifTrue: [ [ compiling add: (words at: #LIT); add: aString asInteger ] ]
		  ifFalse: [ self wordNotFound: aString ]
]

{ #category : 'initialization' }
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

	stream := aStreamOrString readStream.
	compiling := nil.
	[ stream atEnd ] whileFalse: [
		(return isEmpty ifTrue: [ self lookup: self parse ] ifFalse: [ stream next ] ) value ]
]

{ #category : 'initialization' }
Forth >> execute: aBlock [

	^ aBlock value
]

{ #category : 'initialization' }
Forth >> ifCompiling: aBlock [ 

	compiling ifNotNil: [ aBlock value ]
]

{ #category : 'initialization' }
Forth >> immediateWords [

	^ {
		  (#':' -> [ "Define word"
			   self ifCompiling: [ self error: 'no nested definitions' ].
			   words at: (defining := self parse) put: self smudge.
			   compiling := OrderedCollection new ]).
		  (#';' -> [ "End define"
			   self onlyCompiling: [
					   | function |
						compiling add: (words at: #EXIT).
					   function := compiling asArray.
					   compiling := nil.
					   words at: defining put: [
							   return addFirst: stream.
							   stream := function readStream ] ] ]).
		  (#IF -> [ "set up branches" self halt ]).
		  (#'[' -> [ "evaluate mode within a definition" self halt ]).
		  (#']' -> [ "end evaluation mode" self halt ]).
		  (#THEN -> [ "" self halt ]).
		  (#ELSE -> [ "" self halt ]).
		  (#'S"' -> [ "" self halt ]).
		  (#BEGIN -> [ "" self halt ]).
		  (#UNTIL -> [ "" self halt ]).
		  (#WHILE -> [ "" self halt ]).
		  (#REPEAT -> [ "" self halt ]).
		  (#DO -> [ "" self halt ]).
		  (#'?DO' -> [ "" self halt ]).
		  (#LOOP -> [ "" self halt ]).
		  (#'+LOOP' -> [ "" self halt ]).
		  (#'."' -> [ "" self halt ]).
		  (#'C"' -> [ "" self halt ]).
		  (#LITERAL -> [ "" self halt ]).
		  (#'[CHAR]' -> [ "" self halt ]).
		  (#POSTPONE -> [ "" self halt ]).
		  (#'(' -> [ "" self halt ]).
		  (#\ -> [ "" self halt ]) } asDictionary
]

{ #category : 'initialization' }
Forth >> initialize [

	data := OrderedCollection new.
	words := self runtimeWords.
	immediates := self immediateWords.
	return := OrderedCollection new
]

{ #category : 'initialization' }
Forth >> lookup: aString [

	^ (self compiling: aString) ifNil: [ self running: aString ]
]

{ #category : 'initialization' }
Forth >> onlyCompiling: aBlock [ 

	compiling ifNil: [ ^ self error: 'Only in compiling mode' ].
	^ aBlock value
]

{ #category : 'initialization' }
Forth >> parse [

	[ stream peek isSeparator ] whileTrue: [ stream next ].
	^ String streamContents: [ : s | [ stream atEnd or: [stream peek isSeparator ] ] whileFalse: [ s nextPut: stream next ]]
]

{ #category : 'initialization' }
Forth >> running: aString [

	immediates at: aString ifPresent: [ : word | ^ word].
	words at: aString ifPresent: [ : word | ^ word ].
	^ (aString allSatisfy: #isDigit)
		ifTrue: [ [ data addFirst: aString asInteger ] ]
		ifFalse: [ self wordNotFound: aString ]
]

{ #category : 'initialization' }
Forth >> runtimeWords [

	^ {
		  (#DUP -> [ "Duplicates the top item" data addFirst: data first ]).
		  (#DROP -> [ "Discards the top item" data removeFirst ]).
		  (#SWAP -> [ "Swaps the top two items" data addFirst: (data removeAt: 2) ]).
		  (#OVER -> [ "Copies the second item to the top" data addFirst: data second ]).
		  (#ROT -> [ "Rotates the third item to the top" data addFirst: (data removeAt: 3) ]).
		  (#+ -> [ "add" data at: 1 put: data removeFirst + data first ]).
		  (#- -> [ "subtract" data at: 1 put: data removeFirst negated + data first ]).
		  (#LIT -> [ "push next value" data addFirst: stream next ]).
		  (#EXIT -> [ "Exit from a word definition" stream := return removeFirst ]) } asDictionary
]

{ #category : 'initialization' }
Forth >> smudge [

	^ smudge ifNil: [ smudge := #smudge ]
]

{ #category : 'initialization' }
Forth >> top [

	^ data first
]
