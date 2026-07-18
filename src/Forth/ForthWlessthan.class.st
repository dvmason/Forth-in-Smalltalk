"
I am the primitive word that ""Compares the top 2 items on the dataStack and replaces them with a boolean"" on the `dataStack`.
"
Class {
	#name : 'ForthWlessthan',
	#superclass : 'ForthDataStackWord',
	#category : 'Forth-Words',
	#package : 'Forth',
	#tag : 'Words'
}

{ #category : 'accessing' }
ForthWlessthan >> executeOn: interpreter [

	dataStack at: 1 put: (dataStack removeFirst >= dataStack first)
]
