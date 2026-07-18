"
I am the ""'til end of line"" comment
"
Class {
	#name : 'ForthWbackslash',
	#superclass : 'ForthImmediateWord',
	#category : 'Forth-Words',
	#package : 'Forth',
	#tag : 'Words'
}

{ #category : 'accessing' }
ForthWbackslash >> executeOn: interpreter [

	| stream |
	stream := interpreter inputStream.
	[ stream atEnd ] whileFalse: [
			| c |
			c := stream next.
			(Character cr = c or: [ Character lf = c ]) ifTrue: [ ^ self ] ]
]
