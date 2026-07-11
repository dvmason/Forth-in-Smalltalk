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
	^ #(#(#(#RGMethodDefinition #(#Forth #immediateWords #false)) #'2026-07-11T00:20:14.910895+03:00') #(#(#RGMethodDefinition #(#Forth #runtimeWords #false)) #'2026-07-11T00:21:51.977301+03:00') )
]

{ #category : 'code-critics' }
ManifestForth class >> ruleLongMethodsRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#Forth #immediateWords #false)) #'2026-07-11T09:23:05.697211+03:00') )
]

{ #category : 'code-critics' }
ManifestForth class >> ruleReCyclomaticComplexityRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#Forth #immediateWords #false)) #'2026-07-11T00:20:27.187251+03:00') )
]
