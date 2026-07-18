"
I represent a `Forth` function. I am one of the possible `ForthWord` subclasses.

I have a block that I execute in response to the `value:` message.

"
Class {
	#name : 'ForthColonWord',
	#superclass : 'ForthWord',
	#instVars : [
		'body',
		'do'
	],
	#category : 'Forth-Words',
	#package : 'Forth',
	#tag : 'Words'
}

{ #category : 'instance creation' }
ForthColonWord class >> newImmediate [

	^ self new setImmediate
]

{ #category : 'adding' }
ForthColonWord >> add: aForthWord [ 

	body add: aForthWord
]

{ #category : 'accessing' }
ForthColonWord >> at: index put: anObject [

	body at: index put: anObject
]

{ #category : 'defining' }
ForthColonWord >> do: aBlock [

	do := aBlock
]

{ #category : 'accessing' }
ForthColonWord >> executeOn: runtime [

	runtime trace: self.
	^ do value
]

{ #category : 'defining' }
ForthColonWord >> finish: aWord forRuntime: runtime [

	body add: aWord.
	body := body asArray.
	self do: [ runtime pushOnReturn: (ForthWordStream on: body) ]
]

{ #category : 'initialization' }
ForthColonWord >> initialize [

	super initialize.
	immediate := false.
	self do: [ self error: 'not defined' ]
]

{ #category : 'defining' }
ForthColonWord >> named: aString do: aBlock [

	name := aString.
	do := aBlock
]

{ #category : 'accessing' }
ForthColonWord >> size [

	^ body size
]

{ #category : 'defining' }
ForthColonWord >> startDefinition: aString [

	name := aString.
	body := OrderedCollection new.
	self do: [ self error: 'can''t call while defining' ]
]
