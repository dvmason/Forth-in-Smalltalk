Extension { #name : 'Number' }

{ #category : '*Forth' }
Number >> asForthBoolean [

	^ self ~= 0
]

{ #category : '*Forth' }
Number >> asForthNumber [

	^ self
]
