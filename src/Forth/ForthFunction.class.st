"
I represent a `Forth` function. I am one of the possible `ForthWord` subclasses.

I have a block that I execute in response to the `value:` message.

"
Class {
	#name : 'ForthFunction',
	#superclass : 'ForthWord',
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
ForthFunction class >> newImmediate [

	^ self new setImmediate
]

{ #category : 'adding' }
ForthFunction >> add: aForthWord [ 

	body add: aForthWord
]

{ #category : 'accessing' }
ForthFunction >> at: index put: anObject [

	body at: index put: anObject
]

{ #category : 'defining' }
ForthFunction >> do: aBlock [

	do := aBlock
]

{ #category : 'defining' }
ForthFunction >> finish: aWord forRuntime: runtime [

	body add: aWord.
	body := body asArray.
	self do: [ runtime pushOnReturn: body readStream ]
]

{ #category : 'initialization' }
ForthFunction >> initialize [

	super initialize.
	immediate := false.
	self do: [ self error: 'not defined' ]
]

{ #category : 'defining' }
ForthFunction >> named: aString do: aBlock [

	name := aString.
	do := aBlock
]

{ #category : 'accessing' }
ForthFunction >> setImmediate [

	immediate := true
]

{ #category : 'accessing' }
ForthFunction >> size [

	^ body size
]

{ #category : 'defining' }
ForthFunction >> startDefinition: aString [

	name := aString.
	body := OrderedCollection new.
	self do: [ self error: 'can''t call while defining' ]
]

{ #category : 'accessing' }
ForthFunction >> value: runtime [

	runtime trace: self.
	immediate ifTrue: [ ^ do value ].
	runtime isCompiling ifFalse: [ ^ do value ].
	runtime addToCompilation: self
]
