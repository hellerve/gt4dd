Class {
	#name : #DdFilesGroup,
	#superclass : #Object,
	#traits : 'TGtGroupWithItems',
	#classTraits : 'TGtGroupWithItems classTrait',
	#instVars : [
		'key'
	],
	#category : #Gt4Dd
}

{ #category : #'as yet unclassified' }
DdFilesGroup >> gtItemsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Items';
		priority: 1;
		items: [ self items ];
		column: 'Name' text: #basename;
		column: 'LoC' text: [ :aFile | aFile contents lines size ]
]

{ #category : #accessing }
DdFilesGroup >> key [
	^ key
]

{ #category : #accessing }
DdFilesGroup >> key: anObject [
	key := anObject
]

{ #category : #'as yet unclassified' }
DdFilesGroup >> linesOfCode [
	^ (self collect: [ :aFile | [ aFile contents lines size ] on: Error do: [ 0 ] ])
		sum
]
