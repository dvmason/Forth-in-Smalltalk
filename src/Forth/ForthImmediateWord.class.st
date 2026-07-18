"
I am the superclass for immediate primitive words
"
Class {
	#name : 'ForthImmediateWord',
	#superclass : 'ForthPrimitiveWord',
	#category : 'Forth-Words',
	#package : 'Forth',
	#tag : 'Words'
}

{ #category : 'initialization' }
ForthImmediateWord >> isImmediate [

	^ true
]
