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
	#category : 'Forth-Core',
	#package : 'Forth',
	#tag : 'Core'
}

{ #category : 'compiling' }
Forth >> addToCompilation: aForthWord [ 

	compiling add: aForthWord
]

{ #category : 'error testing' }
Forth >> checkNesting: aString [ 

	data removeFirst = #IF ifFalse: [ self error: 'improper nesting of IF/DO' ]
]

{ #category : 'compiling' }
Forth >> compileOnly: aString [ 

	compiling ifNil: [ self error: '"', aString, ';" only in definitions' ]
]

{ #category : 'initialization' }
Forth >> defineWords [

	^ {
		  (#DUP -> (ForthColonWord new named: #DUP do: [ data addFirst: data first ])). "Duplicates the top item"
		  (#DROP -> (ForthColonWord new named: #DROP do: [ data removeFirst ])). "Discards the top item"
		  (#SWAP -> (ForthColonWord new named: #SWAP do: [ data addFirst: (data removeAt: 2) ])). "Swaps the top two items"
		  (#OVER -> (ForthColonWord new named: #OVER do: [ data addFirst: data second ])). "Copies the second item to the top"
		  (#ROT -> (ForthColonWord new named: #ROT do: [ data addFirst: (data removeAt: 3) ])). "Rotates the third item to the top"
		  (#+ -> (ForthColonWord new named: #+ do: [ data at: 1 put: data removeFirst + data first ])). "add"
		  (#- -> (ForthColonWord new named: #- do: [ data at: 1 put: data removeFirst negated + data first ])). "subtract"
		  (#* -> (ForthColonWord new named: #* do: [
				    | right |
				    right := data removeFirst.
				    data at: 1 put: data first * right ])). "multiply"
		  (#< -> (ForthColonWord new named: #< do: [
				    | right |
				    right := data removeFirst.
				    data at: 1 put: (data first < right
						     ifTrue: [ 1 ]
						     ifFalse: [ 0 ]) ])). "less than"
		  (#LIT -> (ForthColonWord new named: #LIT do: [ data addFirst: stream next ])). "push next value"
		  (#EXIT -> (ForthColonWord new named: #EXIT do: [ stream := return removeFirst ])). "Exit from a word definition"
		  (#'>R' -> (ForthColonWord new named: #'>R' do: [ return addFirst: data removeFirst ])).
		  (#'R>' -> (ForthColonWord new named: #'R>' do: [ data addFirst: return removeFirst ])).
		  (#'R@' -> (ForthColonWord new named: #'R@' do: [ data addFirst: return first ])).
		  (#I -> (ForthColonWord new named: #I do: [ data addFirst: return first ])).
		  (#'?BRANCH' -> (ForthColonWord new named: #'?BRANCH' do: [
				    data removeFirst = 0
					    ifTrue: [ stream position: stream next ]
					    ifFalse: [ stream next ] ])). "conditional branch if false"
		  (#BRANCH -> (ForthColonWord new named: #BRANCH do: [ stream position: stream next ])). "unconditional branch"
		  (#':' -> (ForthColonWord newImmediate named: #':' do: [
				    compiling ifNotNil: [ self error: 'no nested definitions' ].
				    defining := self parse.
					 compiling := ForthColonWord new startDefinition: defining ])). "Define word"
		  (#'::' -> (ForthColonWord newImmediate named: #'::' do: [
				    compiling ifNotNil: [ self error: 'no nested definitions' ].
				    words at: (defining := self parse) put: (compiling := ForthColonWord new startDefinition: defining) ])). "Define word allowing recursive call by name"
		  (#';' -> (ForthColonWord newImmediate named: #';' do: [
				    self compileOnly: ';'.
				    compiling finish: (words at: #EXIT) forRuntime: self.
				    words at: defining put: compiling.
					 defining := nil.
				    compiling := nil ])). "End define"
		  (#IF -> (ForthColonWord newImmediate named: #IF do: [
				    self compileOnly: #IF.
				    compiling add: (words at: #'?BRANCH').
				    compiling add: 0.
				    data addFirst: compiling size.
				    data addFirst: #IF ])). "set up branches"
		  (#THEN -> (ForthColonWord newImmediate named: #THEN do: [
				    self checkNesting: #IF.
				    compiling at: data removeFirst put: compiling size ])).
		  (#ELSE -> (ForthColonWord newImmediate named: #ELSE do: [
				    self checkNesting: #IF.
				    compiling at: data removeFirst put: compiling size + 2.
				    compiling add: (words at: #BRANCH).
				    compiling add: 0.
				    data addFirst: compiling size.
				    data addFirst: #IF ])).
		  (#DO -> (ForthColonWord newImmediate named: #DO do: [
				    self compileOnly: #DO.
				    compiling add: (words at: #'(DO)').
				    compiling add: 0.
				    data addFirst: compiling size.
				    data addFirst: #DO ])).
		  (#'?DO' -> ForthColonWord newImmediate).
		  (#LOOP -> ForthColonWord newImmediate).
		  (#'+LOOP' -> ForthColonWord newImmediate).
		  (#'RECURSE' -> ForthColonWord newImmediate).
		  (#'[' -> ForthColonWord newImmediate). "evaluate mode within a definition"
		  (#']' -> ForthColonWord newImmediate). "end evaluation mode"
		  (#'S"' -> ForthColonWord newImmediate).
		  (#BEGIN -> ForthColonWord newImmediate).
		  (#UNTIL -> ForthColonWord newImmediate).
		  (#WHILE -> ForthColonWord newImmediate).
		  (#REPEAT -> ForthColonWord newImmediate).
		  (#'."' -> ForthColonWord newImmediate).
		  (#'C"' -> ForthColonWord newImmediate).
		  (#LITERAL -> ForthColonWord newImmediate).
		  (#VARIABLE -> ForthColonWord newImmediate).
		  (#'@' -> ForthColonWord newImmediate).
		  (#'!' -> ForthColonWord newImmediate).
		  (#POSTPONE -> ForthColonWord newImmediate).
		  (#'(' -> ForthColonWord newImmediate).
		  (#\ -> ForthColonWord newImmediate).
		  (#'[CHAR]' -> ForthColonWord newImmediate) } asDictionary
]

{ #category : 'accessing' }
Forth >> definition: aString [ 

	words at: aString ifPresent: [ : word | |array|
		word executeOn: self.
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
				 ifFalse: [ stream next ]) executeOn: self ]
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

{ #category : 'accessing' }
Forth >> position [

	^ stream position
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
