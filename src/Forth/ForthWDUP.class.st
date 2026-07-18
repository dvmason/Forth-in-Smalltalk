"
I am the primitive word that ""Duplicates the top item"" on the `dataStack`.
"
Class {
	#name : 'ForthWDUP',
	#superclass : 'ForthDataStackWord',
	#category : 'Forth-Words',
	#package : 'Forth',
	#tag : 'Words'
}

{ #category : 'accessing' }
ForthWDUP >> executeOn: _ [
	"Duplicates the top item"

	dataStack addFirst: dataStack first
]
