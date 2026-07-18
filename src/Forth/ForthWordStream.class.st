"
I am a trivial subclass of `ReadStream` so that we can differentiate a word stream from a colon definition from a `String` stream.
"
Class {
	#name : 'ForthWordStream',
	#superclass : 'ReadStream',
	#category : 'Forth-Core',
	#package : 'Forth',
	#tag : 'Core'
}

{ #category : 'executing' }
ForthWordStream >> executeNextOn: aForth [

	^ aForth executeNext
]

{ #category : 'testing' }
ForthWordStream >> isForthWordStream [

	^ true
]
