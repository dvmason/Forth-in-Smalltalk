"
A ForthCollectionTest is a test class for testing the behavior of ForthCollection
"
Class {
	#name : 'ForthCollectionTest',
	#superclass : 'TestCase',
	#category : 'Forth-Tests-Core',
	#package : 'Forth-Tests',
	#tag : 'Core'
}

{ #category : 'tests' }
ForthCollectionTest >> testError [

	| x |
	x := ForthCollection new: 1.
	x add: 0.
	self assert: x at equals: 0.
	self should: [ (x + 1) at ] raise: SubscriptOutOfBounds
]

{ #category : 'tests' }
ForthCollectionTest >> testSimple [

	| x y |
	x := ForthCollection with: 7 with: 19.
	self assert: x at equals: 7.
	y := x + 2 - 1.
	y put: 42.
	self assert: (x + 1) at equals: 42
]
