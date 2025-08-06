Class {
	#name : #DdRepository,
	#superclass : #Object,
	#instVars : [
		'name',
		'url',
		'staticAnalysis',
		'repository',
		'pipeline',
		'pipelineView',
		'stats'
	],
	#category : #Gt4Dd
}

{ #category : #'as yet unclassified' }
DdRepository >> computeStats [
	| files result |
	files := self repository repositoryDirectory allChildren
			reject: [ :aFile | 
				aFile isDirectory
					or: [ aFile withParents anySatisfy: [ :aParent | aParent basename = '.git' ] ] ].
	result := Dictionary new.

	files
		do: [ :aFile | 
			| key value |
			key := aFile extension ifEmpty: [ 'unknown' ].
			value := result at: key ifAbsentPut: [ DdFilesGroup new key: key ].
			value add: aFile ].

	^ result values
]

{ #category : #'as yet unclassified' }
DdRepository >> download [
	self
		repository: (GtIceRepositoryCreator
				fromUrl: self url
				to: (FileReference newTempFilePrefix: self name suffix: 'dir'))
]

{ #category : #'as yet unclassified' }
DdRepository >> githubPipeline [
	pipeline := GtGitHubImporter new
			importWorkflows: repository repositoryDirectory / '.github/workflows'.
	pipelineView := #gtWorkflowsView:
]

{ #category : #'as yet unclassified' }
DdRepository >> gitlabPipeline [
	pipeline := GtGitLabImporter new
			loadFromFile: repository repositoryDirectory / '.gitlab-ci.yml'.
	pipelineView := #gtGraphViewFor:
]

{ #category : #'as yet unclassified' }
DdRepository >> gtAnalysisFor: aView [
	<gtView>
	self staticAnalysis ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'Analysis';
		priority: 1;
		object: [ self staticAnalysis ];
		view: #gtItemsFor:
]

{ #category : #'as yet unclassified' }
DdRepository >> gtPipelineFor: aView [
	<gtView>
	pipeline ifNil: [ ^ aView empty ].

	^ aView forward
		title: 'Pipeline';
		priority: 2;
		object: [ pipeline ];
		view: self pipelineView
]

{ #category : #'as yet unclassified' }
DdRepository >> gtRepositoryDirectoryFor: aView [
	<gtView>
	^ aView forward
		title: 'Repository directory';
		priority: 5;
		object: [ self repository ];
		view: #gtRepositoryDirectoryFor:
]

{ #category : #'as yet unclassified' }
DdRepository >> gtStatsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Stats';
		priority: 3;
		items: [self stats];
		column: 'Type' text: #key;
		column: '# of files' text: #size;
		column: 'LoC' text: #linesOfCode
]

{ #category : #'as yet unclassified' }
DdRepository >> lookup [
	self repository: (IceRepository repositoryNamed: self name)
]

{ #category : #accessing }
DdRepository >> name [
	^ name
]

{ #category : #accessing }
DdRepository >> name: anObject [
	name := anObject
]

{ #category : #accessing }
DdRepository >> pipelineView [
	^ pipelineView
]

{ #category : #accessing }
DdRepository >> pipelineView: anObject [
	pipelineView := anObject
]

{ #category : #accessing }
DdRepository >> repository [
	^ repository
]

{ #category : #accessing }
DdRepository >> repository: anObject [
	repository := anObject.
	
	staticAnalysis ifNotNil: [ staticAnalysis repository: anObject repositoryDirectory ]
]

{ #category : #accessing }
DdRepository >> staticAnalysis [
	^ staticAnalysis
]

{ #category : #accessing }
DdRepository >> staticAnalysis: anObject [
	staticAnalysis := anObject.

	repository ifNotNil: [ anObject repository: repository repositoryDirectory ]
]

{ #category : #'as yet unclassified' }
DdRepository >> stats [
	^ stats ifNil: [stats := self computeStats]
]

{ #category : #accessing }
DdRepository >> url [
	^ url
]

{ #category : #accessing }
DdRepository >> url: anObject [
	url := anObject
]
