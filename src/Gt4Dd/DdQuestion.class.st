Class {
	#name : #DdQuestion,
	#superclass : #Object,
	#instVars : [
		'text',
		'priority',
		'answer'
	],
	#category : #Gt4Dd
}

{ #category : #accessing }
DdQuestion >> answer [
	^ answer
]

{ #category : #accessing }
DdQuestion >> answer: anObject [
	answer := anObject
]

{ #category : #'as yet unclassified' }
DdQuestion >> answerDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Answer';
		priority: 2;
		accessor: #answer
]

{ #category : #accessing }
DdQuestion >> context [
	^ context
]

{ #category : #accessing }
DdQuestion >> context: anObject [
	context := anObject
]

{ #category : #accessing }
DdQuestion >> dropdown [
	^ dropdown
]

{ #category : #accessing }
DdQuestion >> dropdown: anObject [
	dropdown := anObject
]

{ #category : #'as yet unclassified' }
DdQuestion >> initialize [
	super initialize.
	
	text := ''.
	answer := ''.
	priority := 'Medium'
]

{ #category : #accessing }
DdQuestion >> priority [
	^ priority
]

{ #category : #accessing }
DdQuestion >> priority: anObject [
	priority := anObject
]

{ #category : #'as yet unclassified' }
DdQuestion >> priorityClor [
	^ {'Low' -> BrGlamorousColors successBackgroundColor.
		'Medium' -> BrGlamorousColors failureBackgroundColor.
		'High' -> BrGlamorousColors errorBackgroundColor} asDictionary
		at: self priority
		ifAbsent: [ Color black ]
]

{ #category : #'as yet unclassified' }
DdQuestion >> priorityColored [
	^ priority asRopedText
		attributes: {BlTextForegroundAttribute new paint: self priorityClor}
]

{ #category : #'as yet unclassified' }
DdQuestion >> priorityDescription [
	<magritteDescription>
	^ MASingleOptionDescription new
		label: 'Priority';
		priority: 3;
		accessor: #priority;
		options: {'Low'.
				'Medium'.
				'High'}
]

{ #category : #'as yet unclassified' }
DdQuestion >> serialize [
	^ {
		'text' -> text.
		'priority' -> priority.
		'answer' -> answer
	} asDictionary
]

{ #category : #accessing }
DdQuestion >> text [
	^ text
]

{ #category : #accessing }
DdQuestion >> text: anObject [
	text := anObject
]

{ #category : #'as yet unclassified' }
DdQuestion >> textDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Question';
		beRequired;
		priority: 1;
		accessor: #text
]
