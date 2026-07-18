"
I am the primitive word that ""subtracts the top 2 elements"" on the dataStack.
"
Class {
	#name : 'ForthWminus',
	#superclass : 'ForthDataStackWord',
	#category : 'Forth-Words',
	#package : 'Forth',
	#tag : 'Words'
}

{ #category : 'accessing' }
ForthWminus >> executeOn: interpreter [

	dataStack at: 1 put: dataStack removeFirst asForthNumber negated + dataStack first asForthNumber
]
