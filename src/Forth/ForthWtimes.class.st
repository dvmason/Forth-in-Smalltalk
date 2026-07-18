"
I am the primitive word that ""multiplies the top 2 items"" on the dataStack.
"
Class {
	#name : 'ForthWtimes',
	#superclass : 'ForthDataStackWord',
	#category : 'Forth-Words',
	#package : 'Forth',
	#tag : 'Words'
}

{ #category : 'accessing' }
ForthWtimes >> executeOn: interpreter [

	dataStack at: 1 put: dataStack removeFirst asForthNumber * dataStack first asForthNumber
]
