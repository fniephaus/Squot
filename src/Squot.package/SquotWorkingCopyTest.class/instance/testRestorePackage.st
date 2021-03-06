tests
testRestorePackage
	| sampleClass sampleClassName firstMethod packageInfo anotherClass anotherClassName addedMethod firstVersion latestVersion |
	changeLogSuppressor suppressChangeNotificationsDuring: [
		sampleClass := classFactory newClass.
		sampleClass compile: 'firstMethod ^ self' classified: 'methods of first version'].
	sampleClassName := sampleClass name. "when unloaded, the class is renamed"
	firstMethod := sampleClass >> #firstMethod.
	packageInfo := sampleClass package.
	workingCopy add: packageInfo at: 'src'.
	workingCopy saveNewVersionMessage: 'first version' interactive: false.
	firstVersion := workingCopy baseVersion.
	changeLogSuppressor suppressChangeNotificationsDuring: [
		anotherClass := classFactory newClassInCategory: sampleClass category.
		sampleClass compile: 'addedMethod ^ self' classified: 'methods of second version'].
	anotherClassName := anotherClass name. "when unloaded, the class is renamed"
	addedMethod := sampleClass >> #addedMethod.
	workingCopy saveNewVersionMessage: 'second version' interactive: false.
	latestVersion := workingCopy baseVersion.
	
	changeLogSuppressor suppressChangeNotificationsDuring: [
		workingCopy loadVersion: firstVersion interactive: false].
	self deny: (packageInfo includesClassNamed: anotherClassName) description: 'unregister new class'.
	self assert: anotherClass isObsolete description: 'unloaded new class'.
	self assert: (packageInfo includesClass: sampleClass) description: 'keep first class'.
	self deny: sampleClass isObsolete.
	self assert: firstMethod isInstalled description: 'keep firstMethod'.
	self deny: addedMethod isInstalled description: 'remove addedMethod'.
	
	changeLogSuppressor suppressChangeNotificationsDuring: [
		workingCopy loadVersion: latestVersion interactive: false].
	self assert: (packageInfo includesClassNamed: anotherClassName) description: 'restore new class'.
	self assert: ((anotherClass := store environment at: anotherClassName) isKindOf: Class).
	self deny: anotherClass isObsolete.
	self assert: addedMethod equals: sampleClass >> addedMethod selector description: 'restore addedMethod'.