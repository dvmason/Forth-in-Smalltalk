"
I am the primitive word that ""Ands the top two elements"" on the dataStack.
"
Class {
	#name : 'ForthWAND',
	#superclass : 'ForthDataStackWord',
	#category : 'Forth-Words',
	#package : 'Forth',
	#tag : 'Words'
}

{ #category : 'accessing' }
ForthWAND >> executeOn: _ [
    | n2 n1 |
    n2 := dataStack removeFirst asForthNumber.
    n1 := dataStack removeFirst asForthNumber.
    
    dataStack addFirst: (n1 bitAnd: n2)
]
