"
I am the primitive word that ""Exchanges the top 2 items"" on the `dataStack`.
"
Class {
	#name : 'ForthWSWAP',
	#superclass : 'ForthDataStackWord',
	#category : 'Forth-Words',
	#package : 'Forth',
	#tag : 'Words'
}

{ #category : 'accessing' }
ForthWSWAP >> executeOn: _ [

	| first second |
	first := dataStack removeFirst.
	second := dataStack removeFirst.
	dataStack
		  addFirst: first;
		  addFirst: second
]
