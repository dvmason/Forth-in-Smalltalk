"
I am a selector word, so I do a perform on the appropriate values on the stack.

This is so that Forth code can inter-operate with Smalltalk and the image
"
Class {
	#name : 'ForthSelectorWord',
	#superclass : 'ForthWord',
	#instVars : [
		'selector',
		'numArgs',
		'dataStack'
	],
	#category : 'Forth-Words',
	#package : 'Forth',
	#tag : 'Words'
}

{ #category : 'initialization' }
ForthSelectorWord class >> dataStack: aCollection selector: aSymbol [

	^ self basicNew
		  dataStack: aCollection;
		  selector: aSymbol
]

{ #category : 'accessing' }
ForthSelectorWord >> dataStack: aCollection [

	dataStack := aCollection
]

{ #category : 'accessing' }
ForthSelectorWord >> executeOn: _ [
    | receiver args |
    "1. Pop the exact number of arguments this selector expects"
    args := (1 to: numArgs) collect: [ :i | dataStack removeFirst ].
    args := args reversed. "Restore correct left-to-right order"
    
    "2. Pop the receiver"
    receiver := dataStack removeFirst.
    
    "3. Fire away and push the result back to the Forth stack"
    dataStack addFirst: (receiver perform: selector withArguments: args).
]
