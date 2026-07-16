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

{ #category : 'arithmetic' }
ForthCollection >> + anInteger [

	^ self shallowCopy offset: offset + anInteger
]

{ #category : 'arithmetic' }
ForthCollection >> - anInteger [

	^ self shallowCopy offset: offset - anInteger
]

{ #category : 'accessing' }
ForthCollection >> at [

	^ super at: offset
]

{ #category : 'accessing' }
ForthCollection >> at: anInteger [

	^ self shouldNotImplement
]

{ #category : 'accessing' }
ForthCollection >> at: _unused put: _also [

	^ self shouldNotImplement
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
