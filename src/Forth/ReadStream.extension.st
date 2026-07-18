Extension { #name : 'ReadStream' }

{ #category : '*Forth' }
ReadStream >> executeNextOn: aForth [

	^ aForth evaluateOneWord
]
