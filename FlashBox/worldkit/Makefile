all:
	mtasc -keep -version 8  -cp .  -swf worldkit.swf -main com/brainoff/worldkitMain.main com/brainoff/worldkitMain.as

debug:
	mtasc -keep -version 8  -cp . -trace org.osflash.thunderbolt.Logger.trace  -swf worldkit.swf -main com/brainoff/worldkitMain.main com/brainoff/worldkitMain.as org/osflash/thunderbolt/Logger

toolbar:
	mtasc -swf toolbar.swf -version 8  -cp . -trace org.osflash.thunderbolt.Logger.trace  -header 800:400:20:FFFFFF  -main com/brainoff/worldkitMain.main com/brainoff/worldkitMain.as org/osflash/thunderbolt/Logger

verbose:
	mtasc -v -version 8 -cp . -header 800:800:20:FFFFFF -swf worldkit.swf -main com/brainoff/worldkitMain com/brainoff/worldkitMain.as
verbose:
	mtasc -v -version 8 -cp . -header 800:800:20:FFFFFF -swf worldkit.swf -main com/brainoff/worldkitMain com/brainoff/worldkitMain.as

clean:
	rm worldkit.swf

