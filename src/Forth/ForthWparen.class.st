"
I am the ""in the middle of the line"" comment.

Not currently nested, as per traditional Forth. Could easily be made nested
"
Class {
	#name : 'ForthWparen',
	#superclass : 'ForthImmediateWord',
	#category : 'Forth-Words',
	#package : 'Forth',
	#tag : 'Words'
}

{ #category : 'accessing' }
ForthWparen >> executeOn: interpreter [

	| stream |
	stream := interpreter inputStream.
	[ stream atEnd ] whileFalse: [ | c | c := stream next. $) = c ifTrue: [ ^ self ] ]
]
