adding and removing
registerPackagesInStore
	| packageArtifacts |
	packageArtifacts := self baseSnapshot artifacts select: [:each | each path endsWith: '.package'].
	packageArtifacts do: [:each | | packageName |
		packageName := (each path splitBy: '/') last allButLast: '.package' size.
		store addLoadedPackageInfoNamed: packageName at: each path].