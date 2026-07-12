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
		'do'
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

{ #category : 'defining' }
ForthWord >> do: aBlock [

	do := aBlock
]

{ #category : 'evaluating' }
ForthWord >> executeFor: runtime [

	immediate ifTrue: [ ^ do value ].
	runtime isCompiling ifFalse: [ ^ do value ].
	runtime addToCompilation: self
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

{ #category : 'accessing' }
ForthWord >> setImmediate [

	immediate := true
]

{ #category : 'defining' }
ForthWord >> startDefinition [

	body := OrderedCollection new.
	self do: [ self error: 'can''t call while defining' ]
]

{ #category : 'evaluating' }
ForthWord >> value: runtime [

	immediate ifTrue: [ ^ do value ].
	runtime isCompiling ifFalse: [ ^ do value ].
	runtime addToCompilation: self
]
