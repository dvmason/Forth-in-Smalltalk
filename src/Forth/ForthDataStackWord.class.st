"
I have subclasses for all the primitive words that manipulate the `dataStack`.

They all have an instance variable that refers to the `Forth` `dataStack for efficiency.
"
Class {
	#name : 'ForthDataStackWord',
	#superclass : 'ForthPrimitiveWord',
	#instVars : [
		'dataStack'
	],
	#category : 'Forth-Words',
	#package : 'Forth',
	#tag : 'Words'
}

{ #category : 'accessing' }
ForthDataStackWord class >> dataStack: aCollection [

	^ self basicNew
		  dataStack: aCollection;
		  notImmediate
]

{ #category : 'accessing' }
ForthDataStackWord >> dataStack: aCollection [ 

	dataStack := aCollection
]
