"
I am an abstract representation of a `Forth` word.

All my subclasses must implement the `value:` message.
It is passed  a back-reference to the `Forth` runtime.
"
Class {
	#name : 'ForthWord',
	#superclass : 'Object',
	#instVars : [
		'name',
		'immediate'
	],
	#category : 'Forth-Words',
	#package : 'Forth',
	#tag : 'Words'
}

{ #category : 'converting' }
ForthWord >> asAssociation [

	^ self name -> self
]

{ #category : 'accessing' }
ForthWord >> executeOn: runtime [

	^ self subclassResponsibility
]

{ #category : 'testing' }
ForthWord >> isForthWord [

	^ true
]

{ #category : 'initialization' }
ForthWord >> isImmediate [

	^ immediate
]

{ #category : 'accessing' }
ForthWord >> name [

	^ name ifNil: [ name := self className allButFirst: 6 ]
]

{ #category : 'instance creation' }
ForthWord >> named: aString [ 

	name := aString
]

{ #category : 'accessing' }
ForthWord >> notImmediate [

	immediate := false
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
