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
		  (#DUP -> (ForthFunction new named: #DUP do: [ data addFirst: data first ])). "Duplicates the top item"
		  (#DROP -> (ForthFunction new named: #DROP do: [ data removeFirst ])). "Discards the top item"
		  (#SWAP -> (ForthFunction new named: #SWAP do: [ data addFirst: (data removeAt: 2) ])). "Swaps the top two items"
		  (#OVER -> (ForthFunction new named: #OVER do: [ data addFirst: data second ])). "Copies the second item to the top"
		  (#ROT -> (ForthFunction new named: #ROT do: [ data addFirst: (data removeAt: 3) ])). "Rotates the third item to the top"
		  (#+ -> (ForthFunction new named: #+ do: [ data at: 1 put: data removeFirst + data first ])). "add"
		  (#- -> (ForthFunction new named: #- do: [ data at: 1 put: data removeFirst negated + data first ])). "subtract"
		  (#* -> (ForthFunction new named: #* do: [
				    | right |
				    right := data removeFirst.
				    data at: 1 put: data first * right ])). "multiply"
		  (#< -> (ForthFunction new named: #< do: [
				    | right |
				    right := data removeFirst.
				    data at: 1 put: (data first < right
						     ifTrue: [ 1 ]
						     ifFalse: [ 0 ]) ])). "less than"
		  (#LIT -> (ForthFunction new named: #LIT do: [ data addFirst: stream next ])). "push next value"
		  (#EXIT -> (ForthFunction new named: #EXIT do: [ stream := return removeFirst ])). "Exit from a word definition"
		  (#'>R' -> (ForthFunction new named: #'>R' do: [ return addFirst: data removeFirst ])).
		  (#'R>' -> (ForthFunction new named: #'R>' do: [ data addFirst: return removeFirst ])).
		  (#'R@' -> (ForthFunction new named: #'R@' do: [ data addFirst: return first ])).
		  (#I -> (ForthFunction new named: #I do: [ data addFirst: return first ])).
		  (#'?BRANCH' -> (ForthFunction new named: #'?BRANCH' do: [
				    data removeFirst = 0
					    ifTrue: [ stream position: stream next ]
					    ifFalse: [ stream next ] ])). "conditional branch if false"
		  (#BRANCH -> (ForthFunction new named: #BRANCH do: [ stream position: stream next ])). "unconditional branch"
		  (#':' -> (ForthFunction newImmediate named: #':' do: [
				    compiling ifNotNil: [ self error: 'no nested definitions' ].
				    defining := self parse.
					 compiling := ForthFunction new startDefinition: defining ])). "Define word"
		  (#'::' -> (ForthFunction newImmediate named: #'::' do: [
				    compiling ifNotNil: [ self error: 'no nested definitions' ].
				    words at: (defining := self parse) put: (compiling := ForthFunction new startDefinition: defining) ])). "Define word allowing recursive call by name"
		  (#';' -> (ForthFunction newImmediate named: #';' do: [
				    self compileOnly: ';'.
				    compiling finish: (words at: #EXIT) forRuntime: self.
				    words at: defining put: compiling.
					 defining := nil.
				    compiling := nil ])). "End define"
		  (#IF -> (ForthFunction newImmediate named: #IF do: [
				    self compileOnly: #IF.
				    compiling add: (words at: #'?BRANCH').
				    compiling add: 0.
				    data addFirst: compiling size.
				    data addFirst: #IF ])). "set up branches"
		  (#THEN -> (ForthFunction newImmediate named: #THEN do: [
				    self checkNesting: #IF.
				    compiling at: data removeFirst put: compiling size ])).
		  (#ELSE -> (ForthFunction newImmediate named: #ELSE do: [
				    self checkNesting: #IF.
				    compiling at: data removeFirst put: compiling size + 2.
				    compiling add: (words at: #BRANCH).
				    compiling add: 0.
				    data addFirst: compiling size.
				    data addFirst: #IF ])).
		  (#DO -> (ForthFunction newImmediate named: #DO do: [
				    self compileOnly: #DO.
				    compiling add: (words at: #'(DO)').
				    compiling add: 0.
				    data addFirst: compiling size.
				    data addFirst: #DO ])).
		  (#'?DO' -> ForthFunction newImmediate).
		  (#LOOP -> ForthFunction newImmediate).
		  (#'+LOOP' -> ForthFunction newImmediate).
		  (#'RECURSE' -> ForthFunction newImmediate).
		  (#'[' -> ForthFunction newImmediate). "evaluate mode within a definition"
		  (#']' -> ForthFunction newImmediate). "end evaluation mode"
		  (#'S"' -> ForthFunction newImmediate).
		  (#BEGIN -> ForthFunction newImmediate).
		  (#UNTIL -> ForthFunction newImmediate).
		  (#WHILE -> ForthFunction newImmediate).
		  (#REPEAT -> ForthFunction newImmediate).
		  (#'."' -> ForthFunction newImmediate).
		  (#'C"' -> ForthFunction newImmediate).
		  (#LITERAL -> ForthFunction newImmediate).
		  (#VARIABLE -> ForthFunction newImmediate).
		  (#'@' -> ForthFunction newImmediate).
		  (#'!' -> ForthFunction newImmediate).
		  (#POSTPONE -> ForthFunction newImmediate).
		  (#'(' -> ForthFunction newImmediate).
		  (#\ -> ForthFunction newImmediate).
		  (#'[CHAR]' -> ForthFunction newImmediate) } asDictionary
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
				 ifTrue: [ self lookup: self parse ]
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
