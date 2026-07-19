"
I compare the top two items on the stack for equality.
"
Class {
	#name : 'ForthWequal',
	#superclass : 'ForthDataStackWord',
	#category : 'Forth-Words',
	#package : 'Forth',
	#tag : 'Words'
}

{ #category : 'accessing' }
ForthWequal >> executeOn: _ [

	dataStack at: 1 put: dataStack removeFirst = dataStack first
]
