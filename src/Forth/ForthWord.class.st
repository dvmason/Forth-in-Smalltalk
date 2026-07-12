"
I represent a Forth word.

I have a block that I execute when we are compiling and one that I execute when we're running.

I also have a back-reference to the `Forth` runtime.
"
Class {
	#name : 'ForthWord',
	#superclass : 'Object',
	#instVars : [
		'body',
		'immediate',
		'do',
		'name'
	],
	#category : 'Forth-Support',
	#package : 'Forth',
	#tag : 'Support'
}

{ #category : 'instance creation' }
ForthWord class >> newImmediate [

	^ self new setImmediate
]

{ #category : 'adding' }
ForthWord >> add: aForthWord [ 

	body add: aForthWord
]

{ #category : 'accessing' }
ForthWord >> at: index put: anObject [

	body at: index put: anObject
]

{ #category : 'defining' }
ForthWord >> do: aBlock [

	do := aBlock
]

{ #category : 'defining' }
ForthWord >> finish: aWord forRuntime: runtime [

	body add: aWord.
	body := body asArray.
	self do: [ runtime pushOnReturn: body readStream ]
]

{ #category : 'initialization' }
ForthWord >> initialize [

	super initialize.
	immediate := false.
	self do: [ self error: 'not defined' ]
]

{ #category : 'defining' }
ForthWord >> named: aString do: aBlock [

	name := aString.
	do := aBlock
]

{ #category : 'printing' }
ForthWord >> printOn: aStream [

	name ifNil: [ ^ super printOn: aStream ].
	aStream << ': ' << name
]

{ #category : 'accessing' }
ForthWord >> setImmediate [

	immediate := true
]

{ #category : 'accessing' }
ForthWord >> size [

	^ body size
]

{ #category : 'defining' }
ForthWord >> startDefinition: aString [

	name := aString.
	body := OrderedCollection new.
	self do: [ self error: 'can''t call while defining' ]
]

{ #category : 'evaluating' }
ForthWord >> value: runtime [

	"Transcript
		show: runtime position asString;
		show: ' ';
		show: name;
		cr."
	immediate ifTrue: [ ^ do value ].
	runtime isCompiling ifFalse: [ ^ do value ].
	runtime addToCompilation: self
]
