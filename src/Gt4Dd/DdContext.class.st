Class {
	#name : #DdContext,
	#superclass : #Object,
	#instVars : [
		'repositories',
		'vdrAdapter',
		'hypotheses',
		'questions',
		'chat',
		'notes'
	],
	#category : #Gt4Dd
}

{ #category : #'as yet unclassified' }
DdContext class >> fromFile: aFile [
	| dict |
	dict := STONJSON fromString: aFile contents.
	^ self new
		notes: (dict at: 'notes');
		hypotheses: (dict at: 'hypotheses') asOrderedCollection;
		questions: (dict at: 'questions') asOrderedCollection;
		repositories: ((dict at: 'repositories')
				collect: [ :aPath | 
					GtIceRepositoryCreator new
						location: aPath asFileReference;
						createRepository ])
]

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
DdContext >> getHypothesesTool [
	^ GtLlmFunctionToolWithProtocol new
		name: 'getHypotheses';
		parameters: {};
		description: 'Lists all current hypotheses.';
		block: [ :functionCall | Character linefeed join: hypotheses ]
]

{ #category : #'as yet unclassified' }
DdContext >> getNotes [
	^ GtLlmFunctionToolWithProtocol new
		name: 'getNotes';
		parameters: {};
		description: 'Gets the notes.';
		block: [ :functionCall | notes ]
]

{ #category : #'as yet unclassified' }
DdContext >> getQuestionsTool [
	^ GtLlmFunctionToolWithProtocol new
		name: 'getQuestions';
		parameters: {};
		description: 'Lists all current questions.';
		block: [ :functionCall | Character linefeed join: questions ]
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
				| button |
				button := BrButton new beSmallSize
						aptitude: BrGlamorousButtonWithIconAptitude;
						icon: BrGlamorousVectorIcons remove;
						label: 'Remove';
						action: [ hypotheses remove: anItem.
							button phlow fireViewUpdateWish ] ]
			width: 60;
		actionDropdownButtonIcon: BrGlamorousVectorIcons add
			tooltip: 'Add hypothesis'
			content: [ :anElement | 
				| editor |
				BrVerticalPane new fitContent
					padding: (BlInsets all: 5);
					addChild: (editor := BrEditor new
								width: 350;
								aptitude: BrGlamorousEditorAptitude);
					addChild: (BrButton new beSmallSize
							aptitude: BrGlamorousButtonWithIconAptitude;
							icon: BrGlamorousVectorIcons accept;
							action: [ hypotheses add: editor text asString.
								anElement phlow fireViewUpdateWish.
								anElement fireEvent: BrDropdownHideWish new ]) ]
]

{ #category : #views }
DdContext >> gtNotesFor: aView [
	<gtView>
	notes ifNil: [ ^ aView empty ].
	^ aView textEditor
		title: 'Notes';
		priority: 10;
		text: [ notes ];
		actionButtonIcon: BrGlamorousVectorIcons accept
			tooltip: 'Save notes'
			action: [ :aButton :anElement | 
				anElement parent parent parent parent
					allChildrenBreadthFirstDo: [ :aChild | (aChild isKindOf: BrEditor) ifTrue: [ notes := aChild text asString ] ] ]
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
				| button |
				button := BrButton new beSmallSize
						aptitude: BrGlamorousButtonWithIconAptitude;
						icon: BrGlamorousVectorIcons remove;
						label: 'Remove';
						action: [ questions remove: anItem.
							button phlow fireViewUpdateWish ] ]
			width: 60;
		actionDropdownButtonIcon: BrGlamorousVectorIcons add
			tooltip: 'Add question'
			content: [ :anElement | 
				| editor |
				BrVerticalPane new fitContent
					padding: (BlInsets all: 5);
					addChild: (editor := BrEditor new
								width: 350;
								aptitude: BrGlamorousEditorAptitude);
					addChild: (BrButton new beSmallSize
							aptitude: BrGlamorousButtonWithIconAptitude;
							icon: BrGlamorousVectorIcons accept;
							action: [ questions add: editor text asString.
								anElement phlow fireViewUpdateWish.
								anElement fireEvent: BrDropdownHideWish new ]) ]
]

{ #category : #'as yet unclassified' }
DdContext >> gtRepositoriesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Repositories';
		priority: 5;
		items: [ self repositories associations ];
		column: 'Name' text: #key width: 150;
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
	
	notes := ''.
	hypotheses := OrderedCollection new.
	questions := OrderedCollection new.
	repositories := Dictionary new
]

{ #category : #'as yet unclassified' }
DdContext >> instructions [
	^ 'Resolve the user''s task by using your tools until you can provide a satisfying answer. Replying that the provided information is insufficient is an acceptable answer.

You are an assistant aiding the user in a technical due diligence process by compiling information, proposing hypotheses, and compiling questions to answer during the due diligence process. You may be invoked during any part of the due diligence process.

Be diligent in your research and responses. Taking a long time is expected, and being thorough is required.

- Always start your process by reviewing your notes, hypotheses and questions, then surveying the information in the virtual data room (repositories, files, etc.) Use your tools to explore that information.
- Use your tools to add questions to be answered.
- Use your tools to add hypotheses about the due diligence target, process, etc.
- Web search is allowed and encouraged to get more information about the target.
- Take notes and review your notes throughout the process. The goal is to be able to restart from the notes, hypotheses, and questions without any other context when needed.
- If files in the VDR are referenced, use their IDs as well as names in the notes, questions, and hypotheses.'
]

{ #category : #'as yet unclassified' }
DdContext >> intoFile: aFile [
	aFile writeStreamDo: [:s | s nextPutAll: self serialize]
]

{ #category : #'as yet unclassified' }
DdContext >> listFiles [
	^ GtLlmFunctionToolWithProtocol new
		name: 'listVdrFiles';
		parameters: {};
		description: 'Lists all files in the VDR.';
		block: [ :functionCall | vdrAdapter listFiles ]
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
DdContext >> notes [
	^ notes
]

{ #category : #accessing }
DdContext >> notes: anObject [
	notes := anObject
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
DdContext >> readFile [
	^ GtLlmFunctionToolWithProtocol new
		name: 'readVdrFile';
		parameters: {'identifier'.
				'mimeType'};
		description: 'Gets the contents of a file in the VDR using the provided mime type. Assume that reasonable mimetype conversions, e.g. from spreadsheet to CSV and from docx to text, are possible. For repository files, use the `readRepositoryFile` tool instead.';
		block: [ :functionCall | 
			vdrAdapter
				readFile: (functionCall arguments at: 'identifier')
				withMimeType: (functionCall arguments at: 'mimeType') ]
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

{ #category : #'as yet unclassified' }
DdContext >> removeHypothesisTool [
	^ GtLlmFunctionToolWithProtocol new
		name: 'removeHypothesis';
		parameters: {'hypothesisText'};
		description: 'Removes a hypothesis.';
		block: [ :functionCall | hypotheses remove: functionCall anyArgument ]
]

{ #category : #'as yet unclassified' }
DdContext >> removeQuestionTool [
	^ GtLlmFunctionToolWithProtocol new
		name: 'removeQuestion';
		parameters: {'questionText'};
		description: 'Removes a question.';
		block: [ :functionCall | questions remove: functionCall anyArgument ]
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
DdContext >> serialize [
	^ STONJSON
		toStringPretty: {'hypotheses' -> self hypotheses asArray.
				'questions' -> self questions asArray.
				'notes' -> self notes.
				'repositories' -> (self repositories
					collect: [ :aRepo | aRepo repositoryDirectory pathString ])} asDictionary
]

{ #category : #'as yet unclassified' }
DdContext >> setNotes [
	^ GtLlmFunctionToolWithProtocol new
		name: 'setNotes';
		parameters: {'text'};
		description: 'Updates the notes with the text provided.';
		block: [ :functionCall | notes := functionCall anyArgument ]
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
	aChat provider addTool: self removeQuestionTool.
	aChat provider addTool: self getQuestionsTool.
	aChat provider addTool: self addHypothesisTool.
	aChat provider addTool: self removeHypothesisTool.
	aChat provider addTool: self getHypothesesTool.
	aChat provider addTool: self setNotes.
	aChat provider addTool: self getNotes.
	aChat provider addTool: self listFiles.
	aChat provider addTool: self readFile.

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
