"
I am the runtime version of '.""' - see `ForthWdotQuote`
"
Class {
	#name : 'ForthWdoDotQuote',
	#superclass : 'ForthPrimitiveWord',
	#category : 'Forth-Words',
	#package : 'Forth',
	#tag : 'Words'
}

{ #category : 'accessing' }
ForthWdoDotQuote >> executeOn: interpreter [

	interpreter nextPutAll: interpreter nextWord
]
