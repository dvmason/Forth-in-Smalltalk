"
I am an `OrderedCollection` that can be offset into.

This allows doing Forth pointer arithmetic, but **safely**.
"
Class {
	#name : 'ForthCollection',
	#superclass : 'OrderedCollection',
	#instVars : [
		'offset'
	],
	#category : 'Forth-Core',
	#package : 'Forth',
	#tag : 'Core'
}

{ #category : 'instance creation' }
ForthCollection class >> new [

	^ super new initialize
]

{ #category : 'instance creation' }
ForthCollection class >> new: anInteger [

	^ (super new: anInteger) initialize
]

{ #category : 'converting' }
ForthCollection >> asArray [
	"Convert a ForthCollection into an Array."

	"Replace our array with the new Array so that if this happens repeatedly it is low cost."

	"(ForthCollection new add: 42; add: 43; yourself) asArray >>> #(42 43)"

	self capacity = self size ifTrue: [ ^ array ].
	^ array := super asArray
]

{ #category : 'accessing' }
ForthCollection >> at [

	^ super at: offset
]

{ #category : 'arithmetic' }
ForthCollection >> delta: anInteger [

	^ self shallowCopy offset: offset + anInteger
]

{ #category : 'initialization' }
ForthCollection >> initialize [

	super initialize.
	offset := 1
]

{ #category : 'accessing' }
ForthCollection >> offset: anInteger [ 
	offset := anInteger
]

{ #category : 'accessing' }
ForthCollection >> put: anObject [

	^ super at: offset put: anObject
]
