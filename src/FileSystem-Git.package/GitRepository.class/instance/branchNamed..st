public-accessing-objects
branchNamed: aString
	^ self objectNamed: (self resolveRef: (self headsDir / aString) fullName)