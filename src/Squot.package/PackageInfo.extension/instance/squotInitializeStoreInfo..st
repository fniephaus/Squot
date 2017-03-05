*squot
squotInitializeStoreInfo: aDictionary
	| monticelloPackage |
	super squotInitializeStoreInfo: aDictionary.
	(monticelloPackage := self mcPackage) hasWorkingCopy
		ifTrue: [aDictionary at: #environment
				put: (monticelloPackage workingCopy environment)]
		ifFalse: [ | newWorkingCopy |
			newWorkingCopy := monticelloPackage workingCopy.
			newWorkingCopy environment: Environment current.
			aDictionary at: #environment put: newWorkingCopy environment].