Class {
	#name : #DdQuestionBuilder,
	#superclass : #Object,
	#instVars : [
		'context',
		'dropdown',
		'question'
	],
	#category : #Gt4Dd
}

{ #category : #'as yet unclassified' }
DdQuestionBuilder >> answer [
	^ self question answer
]

{ #category : #'as yet unclassified' }
DdQuestionBuilder >> answer: anAnswer [
	^ self question answer: anAnswer
]

{ #category : #'as yet unclassified' }
DdQuestionBuilder >> answerDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Answer';
		priority: 2;
		accessor: #answer
]

{ #category : #accessing }
DdQuestionBuilder >> context [
	^ context
]

{ #category : #accessing }
DdQuestionBuilder >> context: anObject [
	context := anObject
]

{ #category : #accessing }
DdQuestionBuilder >> dropdown [
	^ dropdown
]

{ #category : #accessing }
DdQuestionBuilder >> dropdown: anObject [
	dropdown := anObject
]

{ #category : #'as yet unclassified' }
DdQuestionBuilder >> initialize [
	question := DdQuestion new
]

{ #category : #'as yet unclassified' }
DdQuestionBuilder >> magritteAcceptAction [
	<magritteActionDescription>
	^ super magritteAcceptAction
		label: 'Copy';
		onSuccessCallback: (GtMagritteCallback new
				action: [ :aModel :aButton :aMemento :aDescription | 
					context questions add: self question.
					dropdown fireEvent: BrDropdownHideWish new.
					dropdown phlow fireViewUpdateWish ])
]

{ #category : #'as yet unclassified' }
DdQuestionBuilder >> priority [
	^ self question priority
]

{ #category : #'as yet unclassified' }
DdQuestionBuilder >> priority: aPriority [
	^ self question priority: aPriority
]

{ #category : #'as yet unclassified' }
DdQuestionBuilder >> priorityDescription [
	<magritteDescription>
	^ MASingleOptionDescription new
		label: 'Priority';
		priority: 3;
		accessor: #priority;
		options: {'Low'.
				'Medium'.
				'High'}
]

{ #category : #accessing }
DdQuestionBuilder >> question [
	^ question
]

{ #category : #accessing }
DdQuestionBuilder >> question: anObject [
	question := anObject
]

{ #category : #'as yet unclassified' }
DdQuestionBuilder >> text [
	^ self question text
]

{ #category : #'as yet unclassified' }
DdQuestionBuilder >> text: aText [
	^ self question text: aText
]

{ #category : #'as yet unclassified' }
DdQuestionBuilder >> textDescription [
	<magritteDescription>
	^ MAStringDescription new
		label: 'Question';
		beRequired;
		priority: 1;
		accessor: #text
]
