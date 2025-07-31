Class {
	#name : #BaselineOfGt4Dd,
	#superclass : #BaselineOf,
	#category : #BaselineOfGt4Dd
}

{ #category : #loading }
BaselineOfGt4Dd class >> loadLepiter [
	IceRepository registry  
		detect: [ :aRepository |
			aRepository name = 'gt4dd' ]
		ifFound: [ :aRepository | 
			| defaultDatabase currentProperties |
			defaultDatabase := LeDatabasesRegistry defaultLogicalDatabase.
			currentProperties := defaultDatabase properties.
			currentProperties addRegisteredDirectory: aRepository repositoryDirectory / 'lepiter'.
			defaultDatabase reload ]
		ifNone: [
			self inform: 'Repository not found.' ]
]

{ #category : #baseline }
BaselineOfGt4Dd >> baseline: spec [
	<baseline>
		^ spec for: #common do: [
			spec package: 'Gt4Dd'
		]
]
