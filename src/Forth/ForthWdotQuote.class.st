"
I ouput a string (or compile code to do that).
"
Class {
	#name : 'ForthWdotQuote',
	#superclass : 'ForthImmediateWord',
	#category : 'Forth-Words',
	#package : 'Forth',
	#tag : 'Words'
}

{ #category : 'accessing' }
ForthWdotQuote >> executeOn: interpreter [
    | scannedString |
    "1. Both modes start by parsing up to the trailing double quote"
    scannedString := interpreter parseInputUntil: $".
    
    interpreter isCompiling
        ifTrue: [
            "COMPILE MODE: Bake the behavior into the word under construction"
            | runTimePrimitive |
            "Get the hidden runtime printing primitive"
            runTimePrimitive := interpreter lookup: '(.")'. 
            
            "Append the printer primitive, then the literal string object"
            interpreter addToCompilation: runTimePrimitive.
            interpreter addToCompilation: scannedString.
        ]
        ifFalse: [
            "INTERPRET MODE: Print it right now!"
            interpreter nextPutAll: scannedString.
        ].
]
