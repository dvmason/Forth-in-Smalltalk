"
I am an abstract class for all the primitive words
"
Class {
	#name : 'ForthPrimitiveWord',
	#superclass : 'ForthWord',
	#category : 'Forth-Words',
	#package : 'Forth',
	#tag : 'Words'
}

{ #category : 'instance creation' }
ForthPrimitiveWord class >> newImmediate [

	^ self new setImmediate
]
