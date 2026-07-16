"
I am an abstract representation of a `Forth` word.

All my subclasses must implement the `value:` message.
It is passed  a back-reference to the `Forth` runtime.
"
Class {
	#name : 'ForthWord',
	#superclass : 'Object',
	#instVars : [
		'name'
	],
	#category : 'Forth-Support',
	#package : 'Forth',
	#tag : 'Support'
}

{ #category : 'printing' }
ForthWord >> printOn: aStream [

	name ifNil: [ ^ super printOn: aStream ].
	aStream << ': ' << name
]

{ #category : 'accessing' }
ForthWord >> value: runtime [

	^ self subclassResponsibility
]
