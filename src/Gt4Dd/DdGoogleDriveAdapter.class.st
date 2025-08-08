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
DdGoogleDriveAdapter >> accessToken [
	| client |
	client := ZnClient new url: 'https://oauth2.googleapis.com/token'.

	client
		formAt: 'client_id' put: (token at: 'client_id');
		formAt: 'client_secret' put: (token at: 'client_secret');
		formAt: 'refresh_token' put: (token at: 'refresh_token');
		formAt: 'grant_type' put: 'refresh_token'.

	^ (STONJSON fromString: client post) at: 'access_token'
]

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
DdGoogleDriveAdapter >> gtFilesFor: aView [
	<gtView>
	^ aView columnedList
		title: 'Files';
		priority: 1;
		items: [ (STONJSON fromString: self listFiles) at: 'files' ];
		column: 'Name' text: [:aDict | aDict at: 'name'];
		column: 'ID' text: [:aDict | aDict at: 'id'];
		column: 'Kind' text: [:aDict | aDict at: 'kind'] weight: 0.5;
		column: 'Mime type' text: [:aDict | aDict at: 'mimeType']
]

{ #category : #'as yet unclassified' }
DdGoogleDriveAdapter >> listFiles [
	^ self
		get: 'files'
		withParams: {'q' -> ('''' , folder , ''' in parents')}
]

{ #category : #'as yet unclassified' }
DdGoogleDriveAdapter >> newClient [
	^ ZnClient new setBearerAuthentication: self accessToken
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
