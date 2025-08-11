Class {
	#name : #DdMultiImporter,
	#superclass : #Object,
	#instVars : [
		'importers'
	],
	#category : #Gt4Dd
}

{ #category : #'as yet unclassified' }
DdMultiImporter >> gtImportersFor: aView [
	<gtView>
	^ aView list
		title: 'Importers';
		priority: 1;
		items: [ importers ]
]

{ #category : #accessing }
DdMultiImporter >> importers [
	^ importers
]

{ #category : #accessing }
DdMultiImporter >> importers: anObject [
	importers := anObject
]

{ #category : #'as yet unclassified' }
DdMultiImporter >> model [
	^ importers allButFirst
		inject: importers first model
		into: [ :model :anImporter | model | anImporter model ]
]
