Class {
	#name : #DdAnalysisSuite,
	#superclass : #GtConstrainerReport,
	#instVars : [
		'repository',
		'importerStencil',
		'model',
		'importer'
	],
	#category : #Gt4Dd
}

{ #category : #'as yet unclassified' }
DdAnalysisSuite class >> forDjango [
	^ self new
		importerStencil: [ :aRepository | 
			GtDjangoImporter new
				importDirectory: aRepository;
				finishImport ];
		tools: {{'black'.
					'--check'.
					'.'}.
				{'pytest'.
					'--cov=cvp_netbox_bridge'.
					'--cov-report=term'}}
]

{ #category : #'as yet unclassified' }
DdAnalysisSuite class >> forGo [
	^ self new
		tools: {{'go'.
					'vet'.
					'./...'}}
]

{ #category : #'as yet unclassified' }
DdAnalysisSuite class >> forJs [
	^ self new
		importerStencil: [ :aRepository | 
			GtJSImporter new
				rootFolder: aRepository;
				importDirectory: aRepository;
				finishImport ]
]

{ #category : #'as yet unclassified' }
DdAnalysisSuite class >> forPython [
	^ self new
		importerStencil: [ :aRepository | 
			GtPythonImporter new
				importDirectory: aRepository;
				finishImport ];
		tools: {{'black'.
					'--check'.
					'.'}.
				{'pytest'.
					'--cov=cvp_netbox_bridge'.
					'--cov-report=term'}}
]

{ #category : #'as yet unclassified' }
DdAnalysisSuite class >> forReact [
	^ self new
		importerStencil: [ :aRepository | 
			GtReactImporter new
				parserClass: JSXParser;
				importDirectory: aRepository;
				finishImport ];
		tools: {{'prettier'.
					'.'.
					'--check'}}
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
DdAnalysisSuite >> + anotherSuite [
	^ self class new
		constraints: constraints , anotherSuite constraints;
		importerStencil: [ :aRepository | 
			self importerStencil
				ifNil: [ anotherSuite importerStencil value: aRepository ]
				ifNotNil: [ :ourStencil | 
					anotherSuite importerStencil
						ifNil: [ ourStencil value: aRepository ]
						ifNotNil: [ :theirStencil | 
							DdMultiImporter new
								importers: {ourStencil value: aRepository.
										theirStencil value: aRepository} ] ] ];
		repository: self repository
]

{ #category : #'as yet unclassified' }
DdAnalysisSuite >> build: aComposite [
	aComposite name: 'Analysis Suite'
]

{ #category : #'as yet unclassified' }
DdAnalysisSuite >> gtModelFor: aView [
	<gtView>
	model ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'Model';
		priority: 5;
		object: [ model ];
		view: #gtNavigationFor:;
		actionButtonLabel: 'Browse model'
			tooltip: 'Browse model'
			action: [ :aButton | aButton phlow spawnObject: model ];
		actionButtonLabel: 'Browse importer'
			tooltip: 'Browse importer'
			action: [ :aButton | aButton phlow spawnObject: importer ]
]

{ #category : #accessing }
DdAnalysisSuite >> importer [
	^ importer
]

{ #category : #accessing }
DdAnalysisSuite >> importer: anObject [
	importer := anObject
]

{ #category : #accessing }
DdAnalysisSuite >> importerStencil [
	^ importerStencil
]

{ #category : #accessing }
DdAnalysisSuite >> importerStencil: anObject [
	importerStencil := anObject
]

{ #category : #'as yet unclassified' }
DdAnalysisSuite >> initialize [
	super initialize.

	status := GtDynamicConstraintStatus new
]

{ #category : #accessing }
DdAnalysisSuite >> model [
	^ model
]

{ #category : #accessing }
DdAnalysisSuite >> model: anObject [
	model := anObject
]

{ #category : #accessing }
DdAnalysisSuite >> repository [
	^ repository
]

{ #category : #accessing }
DdAnalysisSuite >> repository: anObject [
	anObject ifNil: [ ^ self ].
	repository := anObject.

	self constraints do: [ :aConstraint | aConstraint repository: anObject ].

	self importerStencil
		ifNotNil: [ self importer: (self importerStencil value: anObject).
			self model: self importer model ]
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
