Class {
	#name : #DdAnalysisSuite,
	#superclass : #GtConstrainerReport,
	#instVars : [
		'repository'
	],
	#category : #Gt4Dd
}

{ #category : #'as yet unclassified' }
DdAnalysisSuite class >> forPython [
	^ self new
		tools: {{'black'.
					'--check'.
					'.'}.
				{'pytest'.
					'--cov=cvp_netbox_bridge'.
					'--cov-report=term'}}
]

{ #category : #'as yet unclassified' }
DdAnalysisSuite class >> forRust [
	^ self new
		tools: {{'cargo'.
					'fmt'.
					'--check'}.
				{'cargo'.
					'test'}}
]

{ #category : #'as yet unclassified' }
DdAnalysisSuite >> build: aComposite [
	aComposite name: 'Analysis Suite'
]

{ #category : #'as yet unclassified' }
DdAnalysisSuite >> initialize [
	super initialize.
	
	tools := OrderedCollection new
]

{ #category : #accessing }
DdAnalysisSuite >> repository [
	^ repository
]

{ #category : #accessing }
DdAnalysisSuite >> repository: anObject [
	repository := anObject.

	self constraints do: [ :aConstraint | aConstraint repository: anObject ]
]

{ #category : #'as yet unclassified' }
DdAnalysisSuite >> tools: aListOfTools [
	aListOfTools
		do: [ :aTool | 
			self
				addConstraint: (GtAnalysisTool new
						tool: aTool;
						repository: self repository) ]
]
