"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : 'ManifestForth',
	#superclass : 'PackageManifest',
	#category : 'Forth-Manifest',
	#package : 'Forth',
	#tag : 'Manifest'
}

{ #category : 'code-critics' }
ManifestForth class >> ruleCodeCruftLeftInMethodsRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#Forth #immediateWords #false)) #'2026-07-11T00:20:14.910895+03:00') #(#(#RGMethodDefinition #(#Forth #runtimeWords #false)) #'2026-07-11T00:21:51.977301+03:00') #(#(#RGMethodDefinition #(#Forth #defineWords #false)) #'2026-07-12T08:19:44.595021-04:00') )
]

{ #category : 'code-critics' }
ManifestForth class >> ruleLongMethodsRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#Forth #immediateWords #false)) #'2026-07-11T09:23:05.697211+03:00') #(#(#RGMethodDefinition #(#Forth #defineWords #false)) #'2026-07-12T08:19:48.761545-04:00') )
]

{ #category : 'code-critics' }
ManifestForth class >> ruleReCyclomaticComplexityRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#Forth #immediateWords #false)) #'2026-07-11T00:20:27.187251+03:00') #(#(#RGMethodDefinition #(#Forth #defineWords #false)) #'2026-07-12T08:19:39.492399-04:00') )
]

{ #category : 'code-critics' }
ManifestForth class >> ruleSendsDifferentSuperRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#ForthCollection #at #false)) #'2026-07-15T22:39:41.436604-04:00') #(#(#RGMethodDefinition #(#ForthCollection #put: #false)) #'2026-07-15T23:05:31.440084-04:00') )
]

{ #category : 'code-critics' }
ManifestForth class >> ruleSuperSendsNewRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#'ForthCollection class' #new #true)) #'2026-07-15T22:53:24.377414-04:00') #(#(#RGMethodDefinition #(#'ForthCollection class' #new: #true)) #'2026-07-15T22:56:13.89563-04:00') )
]

{ #category : 'code-critics' }
ManifestForth class >> ruleUnaryAccessingMethodWithoutReturnRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#ForthColonWord #makeImmediate #false)) #'2026-07-12T08:04:21.058931-04:00') #(#(#RGMethodDefinition #(#ForthColonWord #setImmediate #false)) #'2026-07-12T08:05:22.507415-04:00') #(#(#RGMethodDefinition #(#ForthPrimitiveWord #setImmediate #false)) #'2026-07-18T10:17:45.75162-04:00') #(#(#RGMethodDefinition #(#ForthPrimitiveWord #notImmediate #false)) #'2026-07-18T10:18:44.624073-04:00') #(#(#RGMethodDefinition #(#ForthWord #notImmediate #false)) #'2026-07-18T11:49:01.105183-04:00') #(#(#RGMethodDefinition #(#ForthWord #setImmediate #false)) #'2026-07-18T11:49:09.279759-04:00') )
]

{ #category : 'code-critics' }
ManifestForth class >> ruleUsesAddRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#Forth #evaluateOneWord: #false)) #'2026-07-18T09:29:27.259964-04:00') )
]
