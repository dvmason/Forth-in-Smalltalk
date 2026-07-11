Extension { #name : 'ByteString' }

{ #category : '*Forth' }
ByteString >> asForth [
	^ Forth new evaluate: self
]
