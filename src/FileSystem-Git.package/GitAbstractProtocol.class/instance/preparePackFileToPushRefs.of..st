private
preparePackFileToPushRefs: updateAssociations of: aRepository 
	| creator packFile visitor remoteRefs |
	packFile := GitPackFile new repository: aRepository; yourself.
	creator := GitPackFileCreator on: packFile.
	visitor := GitRevisionListVisitor new.
	remoteRefs := refs copy. remoteRefs removeKey: #capabilities. self flag: #hack.
	visitor sinkCommits: (remoteRefs values collect: [:each | aRepository objectNamed: each ifAbsent: []]).
	visitor visitingCommitsFrom: (updateAssociations collect: [:each | each value])
		do: [:each | creator addObject: each. creator visit: each tree].
	creator writePackFile.
	^ packFile
	