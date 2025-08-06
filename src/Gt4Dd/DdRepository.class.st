Class {
	#name : #DdRepository,
	#superclass : #Object,
	#instVars : [
		'name',
		'url',
		'staticAnalysis',
		'repository',
		'pipeline',
		'pipelineView'
	],
	#category : #Gt4Dd
}

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
	^ aView forward title: 'Pipeline'; priority: 2;
	object: [ pipeline];
	view: self pipelineView
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

{ #category : #accessing }
DdRepository >> url [
	^ url
]

{ #category : #accessing }
DdRepository >> url: anObject [
	url := anObject
]
