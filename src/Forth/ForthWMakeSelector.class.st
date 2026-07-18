"
I make a selector out of the next word so we can inter-operate with Smalltalk
"
Class {
	#name : 'ForthWMakeSelector',
	#superclass : 'ForthImmediateWord',
	#category : 'Forth-Words',
	#package : 'Forth',
	#tag : 'Words'
}

{ #category : 'accessing' }
ForthWMakeSelector >> executeOn: interpreter [
	"Inside the PrimitiveWord for 'MakeSelector'"

	| wordName newWord |
	wordName := interpreter parseNextToken. "e.g., '->' or 'at:put:'"

	newWord := ForthSelectorWord new dataStack: interpreter dataStack selector: wordName asSymbol.

	interpreter addToCompilation: newWord
]
