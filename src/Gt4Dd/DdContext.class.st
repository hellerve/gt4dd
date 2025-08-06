Class {
	#name : #DdContext,
	#superclass : #Object,
	#instVars : [
		'repositories',
		'vdrAdapter',
		'hypotheses',
		'questions',
		'chat'
	],
	#category : #Gt4Dd
}

{ #category : #'as yet unclassified' }
DdContext >> addHypothesisTool [
	^ GtLlmFunctionToolWithProtocol new
		name: 'addHypothesis';
		parameters: {'hypothesisText'};
		description: 'Adds a hypothesis with the provided context.';
		block: [ :functionCall | hypotheses add: functionCall anyArgument ]
]

{ #category : #'as yet unclassified' }
DdContext >> addQuestionTool [
	^ GtLlmFunctionToolWithProtocol new
		name: 'addQuestion';
		parameters: {'questionText'};
		description: 'Adds a question with the provided context.';
		block: [ :functionCall | questions add: functionCall anyArgument ]
]

{ #category : #'as yet unclassified' }
DdContext >> addRepositories: aCollection [
	aCollection do: [ :aRepo | repositories at: aRepo name put: aRepo ]
]

{ #category : #'as yet unclassified' }
DdContext >> browseTool [
	^ GtLlmTool new type: 'web_search_preview'
]

{ #category : #'as yet unclassified' }
DdContext >> chat [
	^ chat ifNil: [ chat := self setupChat ]
]

{ #category : #'as yet unclassified' }
DdContext >> gtChatFor: aView [
	<gtView>
	^ aView forward
		title: 'Chat';
		priority: 1;
		object: [ self chat ];
		view: #gtMessagesWidgetFor:
]

{ #category : #'as yet unclassified' }
DdContext >> gtHypothesesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Hypotheses';
		priority: 2;
		items: [ self hypotheses ];
		column: 'Text' text: #yourself;
		column: 'Actions'
			icon: [ :anItem | 
				BrButton new beSmallSize
					aptitude: BrGlamorousButtonWithIconAptitude;
					icon: BrGlamorousVectorIcons remove;
					label: 'Remove';
					action: [ hypotheses remove: anItem ] ]
			width: 60
]

{ #category : #'as yet unclassified' }
DdContext >> gtQuestionsFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Questions';
		priority: 3;
		items: [ self questions ];
		column: 'Text' text: #yourself;
		column: 'Actions'
			icon: [ :anItem | 
				BrButton new beSmallSize
					aptitude: BrGlamorousButtonWithIconAptitude;
					icon: BrGlamorousVectorIcons remove;
					label: 'Remove';
					action: [ questions remove: anItem ] ]
			width: 60
]

{ #category : #'as yet unclassified' }
DdContext >> gtRepositoriesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Repositories';
		priority: 5;
		items: [ self repositories associations ];
		column: 'Name' text: #key;
		column: 'URL' text: [ :aPair | aPair value url ];
		column: 'Analysis'
			icon: [ :aPair | 
				aPair value staticAnalysis
					ifNil: [ BlElement new size: 0 @ 0 ]
					ifNotNil: #statusElement ] width: 65;
		send: #value
]

{ #category : #accessing }
DdContext >> hypotheses [
	^ hypotheses
]

{ #category : #accessing }
DdContext >> hypotheses: anObject [
	hypotheses := anObject
]

{ #category : #'as yet unclassified' }
DdContext >> initialize [
	super initialize.
	
	hypotheses := OrderedCollection new.
	questions := OrderedCollection new.
	repositories := Dictionary new
]

{ #category : #'as yet unclassified' }
DdContext >> instructions [
	^ 'Resolve the user''s task by using your tools until you can provide a satisfying answer. Replying that the provided information is insufficient is an acceptable answer.

You are an assistant aiding the user in a technical due diligence process by compiling information, proposing hypotheses, and compiling questions to answer during the due diligence process. You may be invoked during any part of the due diligence process.

Be diligent in your research and responses. Taking a long time is expected, and being thorough is required.

- Always start your process by surveying the information in the virtual data room (repositories, files, etc.) Use your tools to explore that information.
- Use your tools to add questions to be answered.
- Use your tools to add hypotheses about the due diligence target, process, etc.
- Web search is allowed and encouraged to get more information about the target.'
]

{ #category : #'as yet unclassified' }
DdContext >> listRepositoriesTool [
	^ GtLlmFunctionToolWithProtocol new
		name: 'listRepositories';
		parameters: {};
		description: 'List the repositories you have access to.';
		block: [ :functionCall | repositories keys ]
]

{ #category : #'as yet unclassified' }
DdContext >> listRepositoryDirectoryFiles [
	^ GtLlmFunctionToolWithProtocol new
		name: 'listRepositoryDirectoryFiles';
		parameters: {'repository'.
				'directory'};
		description: 'List the files in the given repository under the given directory (use `.` for the main directory and do not use a leading slash).';
		block: [ :functionCall | 
			STONJSON
				toString: (((repositories at: (functionCall arguments at: 'repository'))
						repositoryDirectory / (functionCall arguments at: 'directory')) children
						collect: [ :aFile | 
							{'name' -> aFile name.
								'type'
									-> (aFile isDirectory ifTrue: [ 'directory' ] ifFalse: [ 'file' ])}
								asDictionary ]) ]
]

{ #category : #accessing }
DdContext >> questions [
	^ questions
]

{ #category : #accessing }
DdContext >> questions: anObject [
	questions := anObject
]

{ #category : #'as yet unclassified' }
DdContext >> readRepositoryFileTool [
	^ GtLlmFunctionToolWithProtocol new
		name: 'readRepositoryFile';
		parameters: {'repository'.
				'path'};
		description: 'Return the content of the file given.';
		block: [ :functionCall | 
			(repositories at: (functionCall arguments at: 'repository')) repositoryDirectory
				/ (functionCall arguments at: 'path') contents ]
]

{ #category : #accessing }
DdContext >> repositories [
	^ repositories
]

{ #category : #accessing }
DdContext >> repositories: anObject [
	repositories := anObject
]

{ #category : #'as yet unclassified' }
DdContext >> setupChat [
	| aChat |
	aChat := GtLlmChat new.

	aChat provider instructions: self instructions.

	aChat provider addTool: self browseTool.
	aChat provider addTool: self listRepositoriesTool.
	aChat provider addTool: self listRepositoryDirectoryFiles.
	aChat provider addTool: self readRepositoryFileTool.
	aChat provider addTool: self addQuestionTool.
	aChat provider addTool: self addHypothesisTool.

	^ aChat
]

{ #category : #accessing }
DdContext >> vdrAdapter [
	^ vdrAdapter
]

{ #category : #accessing }
DdContext >> vdrAdapter: anObject [
	vdrAdapter := anObject
]
