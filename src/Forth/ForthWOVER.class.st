"
I am the primitive word that ""Copies the second element on the stack"" onto the `dataStack`.
"
Class {
	#name : 'ForthWOVER',
	#superclass : 'ForthDataStackWord',
	#category : 'Forth-Words',
	#package : 'Forth',
	#tag : 'Words'
}

{ #category : 'accessing' }
ForthWOVER >> executeOn: _ [

	dataStack addFirst: dataStack second
]
