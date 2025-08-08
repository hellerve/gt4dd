Class {
	#name : #GtAnalysisTool,
	#superclass : #GtLeafConstraint,
	#instVars : [
		'tool',
		'repository',
		'output'
	],
	#category : #Gt4Dd
}

{ #category : #'as yet unclassified' }
GtAnalysisTool >> description [
	^ self name
]

{ #category : #'as yet unclassified' }
GtAnalysisTool >> gtOutputFor: aView [
	<gtView>
	output ifNil: [ ^ aView empty ].

	^ aView textEditor
		title: 'Output';
		priority: 5;
		text: [ output ]
]

{ #category : #'as yet unclassified' }
GtAnalysisTool >> issues [
	| process |
	process := GtSubprocessWithInMemoryOutput new
			workingDirectory: repository;
			command: tool first;
			arguments: tool allButFirst;
			runAndWait.

	output := process stdout , process stderr.

	^ process exitCode = 0 ifTrue: [ {} ] ifFalse: [ {output} ]
]

{ #category : #'as yet unclassified' }
GtAnalysisTool >> name [
	^ 'Tool: ' , (' ' join: self tool)
]

{ #category : #accessing }
GtAnalysisTool >> repository [
	^ repository
]

{ #category : #accessing }
GtAnalysisTool >> repository: anObject [
	repository := anObject
]

{ #category : #accessing }
GtAnalysisTool >> tool [
	^ tool
]

{ #category : #accessing }
GtAnalysisTool >> tool: anObject [
	tool := anObject
]
