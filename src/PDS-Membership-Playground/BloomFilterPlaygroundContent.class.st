Class {
	#name : #BloomFilterPlaygroundContent,
	#superclass : #ComposablePresenter,
	#instVars : [
		'addAction',
		'testAction',
		'bloomInspector',
		'viewer'
	],
	#category : #'PDS-Membership-Playground'
}

{ #category : #specs }
BloomFilterPlaygroundContent class >> defaultSpec [
	^ SpecColumnLayout composed
		newRow: [ :row | 
			row
				newColumn: [ :column | 
					column
						add: #addAction;
						add: #testAction ];
				add: #bloomInspector ]
			height: 2 * (self labelHeight * 4 + self buttonHeight);
		newRow: [ :row | row add: #viewer ];
		yourself
]

{ #category : #accessing }
BloomFilterPlaygroundContent >> addAction [
	^ addAction
]

{ #category : #api }
BloomFilterPlaygroundContent >> bloom: aBloom [
	self addAction bloom: aBloom.
	self testAction bloom: aBloom.
	bloomInspector := GlamourPresentationPresenter new
		presentationClass: GTInspector
		startOn: aBloom.
	self viewer bloom: aBloom.
	self needRebuild: false.
	self buildWithSpecLayout: self class defaultSpec
]

{ #category : #accessing }
BloomFilterPlaygroundContent >> bloomInspector [
	^ bloomInspector
]

{ #category : #initialization }
BloomFilterPlaygroundContent >> extent [
^ 800 @ 600
]

{ #category : #initialization }
BloomFilterPlaygroundContent >> initializePresenter [
	addAction
		whenActionChangedDo: [ :filter :element | 
			filter add: element asByteArray.
			self viewer refresh.
			element asString , ' added to filter!' ].
	testAction
		whenActionChangedDo: [ :filter :element | 
			| isContained |
			isContained := filter contains: element asByteArray.
			isContained
				ifTrue: [ element asString , ' maybe contained with FPP = '
						, ((filter fpp * 100) round: 5) asString , '%' ]
				ifFalse: [ element asString , ' is not in the filter.' ] ]
]

{ #category : #initialization }
BloomFilterPlaygroundContent >> initializeWidgets [
	addAction := self instantiate: BloomFilterActionForm.
	testAction := self instantiate: BloomFilterActionForm.
	bloomInspector := self newLabel.
	viewer := self instantiate: BloomFilterViewer.
	addAction
		header: 'Add elements';
		description: 'Write the text you want to add to the filter.';
		ghostText: 'e.g. Madrid';
		buttonLabel: 'Add';
		resultLabel: ''.
	testAction
		header: 'Membership test';
		description: 'Check if a given text is a member of the filter.';
		ghostText: 'E.g. London';
		buttonLabel: 'Test';
		resultLabel: ''.
	self focusOrder
		add: addAction;
		add: testAction;
		add: bloomInspector;
		add: viewer
]

{ #category : #accessing }
BloomFilterPlaygroundContent >> testAction [
	^ testAction
]

{ #category : #initialization }
BloomFilterPlaygroundContent >> title [
^ 'BloomFilter Playground Content'
]

{ #category : #accessing }
BloomFilterPlaygroundContent >> viewer [
	^ viewer
]