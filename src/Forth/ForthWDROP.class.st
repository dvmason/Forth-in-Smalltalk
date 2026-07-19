"
I am the primitive word that ""Drops the top item"" from the `dataStack`.
"
Class {
	#name : 'ForthWDROP',
	#superclass : 'ForthDataStackWord',
	#category : 'Forth-Words',
	#package : 'Forth',
	#tag : 'Words'
}

{ #category : 'accessing' }
ForthWDROP >> executeOn: interpreter [

	dataStack addFirst: interpreter nextWord
]
