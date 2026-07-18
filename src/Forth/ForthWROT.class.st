"
I am the primitive word that ""Rotates the top 3 elements"" on the `dataStack`.
"
Class {
	#name : 'ForthWROT',
	#superclass : 'ForthDataStackWord',
	#category : 'Forth-Words',
	#package : 'Forth',
	#tag : 'Words'
}

{ #category : 'accessing' }
ForthWROT >> executeOn: runtime [

	dataStack addFirst: (dataStack removeAt: 3)
]
