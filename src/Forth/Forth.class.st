"
I am a Forth language runtime
"
Class {
	#name : 'Forth',
	#superclass : 'Object',
	#instVars : [
		'words',
		'dataStack',
		'returnStack',
		'latestWord',
		'currentStream',
		'isCompiling',
		'inputStream',
		'output'
	],
	#category : 'Forth-Core',
	#package : 'Forth',
	#tag : 'Core'
}

{ #category : 'compiling' }
Forth >> addToCompilation: aForthWord [ 

	latestWord add: aForthWord
]

{ #category : 'error testing' }
Forth >> checkNesting: aString [ 

	dataStack removeFirst = #IF ifFalse: [ self error: 'improper nesting of IF/DO' ]
]

{ #category : 'compiling' }
Forth >> compileOnly: aString [ 

	latestWord ifNil: [ self error: '"', aString, ';" only in definitions' ]
]

{ #category : 'accessing' }
Forth >> dataStack [

	^ dataStack
]

{ #category : 'initialization' }
Forth >> defineWords [

	^ {
		  (ForthWDUP dataStack: dataStack) asAssociation.
		  (ForthWDROP dataStack: dataStack) asAssociation.
		  (ForthWSWAP dataStack: dataStack) asAssociation.
		  (ForthWOVER dataStack: dataStack) asAssociation.
		  (ForthWROT dataStack: dataStack) asAssociation.
		  ((ForthWplus dataStack: dataStack) named: #+) asAssociation.
		  ((ForthWminus dataStack: dataStack) named: #-) asAssociation.
		  ((ForthWtimes dataStack: dataStack) named: #*) asAssociation.
		  ((ForthWlessthan dataStack: dataStack) named: #<) asAssociation.
		  ((ForthWequal dataStack: dataStack) named: #=) asAssociation.
		  (ForthWasBoolean dataStack: dataStack) asAssociation.
		  (ForthWAND dataStack: dataStack) asAssociation.
		  (ForthWparen new named: #'(') asAssociation.
		  (ForthWbackslash new named: #\) asAssociation.
		  (ForthWdotQuote new named: #'."') asAssociation.
		  (ForthWdoDotQuote new named: #'(.")') asAssociation.
		  ForthWMakeSelector new asAssociation.
		  (#LIT -> (ForthColonWord new named: #LIT do: [ dataStack addFirst: currentStream next ])). "push next value"
		  (#EXIT -> (ForthColonWord new named: #EXIT do: [ currentStream := returnStack removeFirst ])). "Exit from a word definition"
		  (#'>R' -> (ForthColonWord new named: #'>R' do: [ returnStack addFirst: dataStack removeFirst ])).
		  (#'R>' -> (ForthColonWord new named: #'R>' do: [ dataStack addFirst: returnStack removeFirst ])).
		  (#'R@' -> (ForthColonWord new named: #'R@' do: [ dataStack addFirst: returnStack first ])).
		  (#I -> (ForthColonWord new named: #I do: [ dataStack addFirst: returnStack first ])).
		  (#'?BRANCH' -> (ForthColonWord new named: #'?BRANCH' do: [
				    dataStack removeFirst asForthBoolean
					    ifFalse: [ currentStream position: currentStream next ]
					    ifTrue: [ currentStream next ] ])). "conditional branch if false"
		  (#BRANCH -> (ForthColonWord new named: #BRANCH do: [ currentStream position: currentStream next ])). "unconditional branch"
		  (#':' -> (ForthColonWord newImmediate named: #':' do: [
				    self isCompiling ifTrue: [ self error: 'no nested definitions' ].
				    self setCompiling.
				    latestWord := ForthColonWord new startDefinition: self parseNextToken ])). "Define word"
		  (#'::' -> (ForthColonWord newImmediate named: #'::' do: [
				    latestWord ifNotNil: [ self error: 'no nested definitions' ].
				    self setCompiling.
				    latestWord := ForthColonWord new startDefinition: self parseNextToken. "Define word"
				    words at: latestWord name put: latestWord ])). "Define word allowing recursive call by name"
		  (#';' -> (ForthColonWord newImmediate named: #';' do: [
				    self compileOnly: ';'.
				    latestWord finish: (words at: #EXIT) forRuntime: self.
				    words at: latestWord name put: latestWord.
				    self notCompiling.
				    latestWord := nil ])). "End define"
		  (#IF -> (ForthColonWord newImmediate named: #IF do: [
				    self compileOnly: #IF.
				    latestWord add: (words at: #'?BRANCH').
				    latestWord add: 0.
				    dataStack addFirst: latestWord size.
				    dataStack addFirst: #IF ])). "set up branches"
		  (#THEN -> (ForthColonWord newImmediate named: #THEN do: [
				    self checkNesting: #IF.
				    latestWord at: dataStack removeFirst put: latestWord size ])).
		  (#ELSE -> (ForthColonWord newImmediate named: #ELSE do: [
				    self checkNesting: #IF.
				    latestWord at: dataStack removeFirst put: latestWord size + 2.
				    latestWord add: (words at: #BRANCH).
				    latestWord add: 0.
				    dataStack addFirst: latestWord size.
				    dataStack addFirst: #IF ])).
		  (#DO -> (ForthColonWord newImmediate named: #DO do: [
				    self compileOnly: #DO.
				    latestWord add: (words at: #'(DO)').
				    latestWord add: 0.
				    dataStack addFirst: latestWord size.
				    dataStack addFirst: #DO ])).
		  (#'?DO' -> ForthColonWord newImmediate).
		  (#LOOP -> ForthColonWord newImmediate).
		  (#'+LOOP' -> ForthColonWord newImmediate).
		  (#RECURSE -> ForthColonWord newImmediate).
		  (#'[' -> ForthColonWord newImmediate). "evaluate mode within a definition"
		  (#']' -> ForthColonWord newImmediate). "end evaluation mode"
		  (#'S"' -> ForthColonWord newImmediate).
		  (#BEGIN -> ForthColonWord newImmediate).
		  (#UNTIL -> ForthColonWord newImmediate).
		  (#WHILE -> ForthColonWord newImmediate).
		  (#REPEAT -> ForthColonWord newImmediate).
		  (#'C"' -> ForthColonWord newImmediate).
		  (#LITERAL -> ForthColonWord newImmediate).
		  (#VARIABLE -> ForthColonWord newImmediate).
		  (#@ -> ForthColonWord newImmediate).
		  (#! -> ForthColonWord newImmediate).
		  (#POSTPONE -> ForthColonWord newImmediate).
		  (#'[CHAR]' -> ForthColonWord newImmediate) } asDictionary
]

{ #category : 'accessing' }
Forth >> definition: aString [ 

	words at: aString ifPresent: [ : word | |array|
		word executeOn: self.
		array := currentStream contents.
		currentStream := returnStack removeFirst.
		^ array
	]
]

{ #category : 'initialization' }
Forth >> evaluate: aStreamOrString [

	currentStream := aStreamOrString readStream skipSeparators.
	inputStream := currentStream.
	latestWord := nil.
	self notCompiling.
	[ currentStream atEnd ] whileFalse: [
		currentStream executeNextOn: self ]

]

{ #category : 'initialization' }
Forth >> evaluate: aStreamOrString on: aStream [

	| saveOutput |
	saveOutput := output.
	[
		output := aStream.
		self evaluate: aStreamOrString ] ensure: [ output := saveOutput ]
]

{ #category : 'executing' }
Forth >> evaluateOneWord [

	currentStream skipSeparators atEnd ifFalse: [ self evaluateOneWord: self parseNextToken ]
]

{ #category : 'initialization' }
Forth >> evaluateOneWord: aString [

	| word |
	word := self lookup: aString.
	word isForthWord ifTrue: [
			self isCompiling and: [ word isImmediate ifFalse: [ ^ latestWord add: word ] ].
			^ word executeOn: self ].
	^ self isCompiling
		  ifTrue: [
				  latestWord
					  add: (words at: #LIT);
					  add: aString asInteger ]
		  ifFalse: [ dataStack addFirst: word ]
]

{ #category : 'executing' }
Forth >> executeNext [

	^ currentStream next executeOn: self
]

{ #category : 'initialization' }
Forth >> initialize [

	super initialize.
	dataStack := OrderedCollection new.
	words := self defineWords.
	returnStack := OrderedCollection new.
	isCompiling := false.
	output := Transcript
]

{ #category : 'accessing' }
Forth >> inputStream [

	^ inputStream
]

{ #category : 'testing' }
Forth >> isCompiling [

	^ isCompiling
]

{ #category : 'initialization' }
Forth >> lookup: aString [

	| aStream possibleNumber |
	words at: aString ifPresent: [ :word | ^ word ].
	aStream := aString readStream.
	possibleNumber := Number readFrom: aStream.
	aStream atEnd ifFalse: [ self error: 'word not found: ' , aString ].
	^ possibleNumber
]

{ #category : 'accessing' }
Forth >> nextPutAll: aString [

	output nextPutAll: aString
]

{ #category : 'stream access' }
Forth >> nextWord [

	^ currentStream next
]

{ #category : 'testing' }
Forth >> notCompiling [

	isCompiling := false
]

{ #category : 'parsing' }
Forth >> parseInputUntil: aCharacter [ 

		| next |
	^ String streamContents: [ :s |
		  [ inputStream atEnd or: [ (next := inputStream next) = aCharacter ] ] whileFalse: [ s nextPut: next ] ]
]

{ #category : 'initialization' }
Forth >> parseNextToken [

	| next |
	inputStream skipSeparators.
	^ String streamContents: [ :s |
		  [ inputStream atEnd or: [ (next := inputStream next) isSeparator ] ] whileFalse: [ s nextPut: next ] ]
]

{ #category : 'accessing' }
Forth >> position [

	^ currentStream position
]

{ #category : 'executing' }
Forth >> pushOnReturn: aForthWordStream [

	returnStack addFirst: currentStream.
	currentStream := aForthWordStream
]

{ #category : 'testing' }
Forth >> setCompiling [

	isCompiling := true
]

{ #category : 'accessing' }
Forth >> top [

	^ dataStack first
]
