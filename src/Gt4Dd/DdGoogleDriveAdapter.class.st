Class {
	#name : #DdGoogleDriveAdapter,
	#superclass : #Object,
	#instVars : [
		'token',
		'folder'
	],
	#category : #Gt4Dd
}

{ #category : #'as yet unclassified' }
DdGoogleDriveAdapter >> baseUrl [
	^ 'https://www.googleapis.com/drive/v3/' asZnUrl
]

{ #category : #accessing }
DdGoogleDriveAdapter >> folder [
	^ folder
]

{ #category : #accessing }
DdGoogleDriveAdapter >> folder: anObject [
	folder := anObject
]

{ #category : #'as yet unclassified' }
DdGoogleDriveAdapter >> get: aUrl [
	^ self newClient
		url: self baseUrl / aUrl;
		get
]

{ #category : #'as yet unclassified' }
DdGoogleDriveAdapter >> get: aUrl withParams: aListOfAssocs [
	| client |
	client := self newClient url: self baseUrl / aUrl.

	aListOfAssocs do: [ :aPair | client queryAt: aPair key put: aPair value ].

	^ client get
]

{ #category : #'as yet unclassified' }
DdGoogleDriveAdapter >> listFiles [
	^ self
		get: 'files'
		withParams: {'q' -> ('''' , folder , ''' in parents')}
]

{ #category : #'as yet unclassified' }
DdGoogleDriveAdapter >> newClient [
	^ ZnClient new setBearerAuthentication: (token at: 'access_token')
]

{ #category : #'as yet unclassified' }
DdGoogleDriveAdapter >> readFile: anId withMimeType: aMimeType [
	^ self get: 'files/' , anId, '/export' withParams: {'alt' -> 'media'. 'mimeType' -> aMimeType}
]

{ #category : #'as yet unclassified' }
DdGoogleDriveAdapter >> searchFile: aQuery [
	^ nil
]

{ #category : #accessing }
DdGoogleDriveAdapter >> token [
	^ token
]

{ #category : #accessing }
DdGoogleDriveAdapter >> token: anObject [
	token := anObject
]
