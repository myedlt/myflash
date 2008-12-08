mtasc is a _fast_ open source actionscript < 9.0 compiler. the default
usage is from the command line, but can be called from .bat files.

== Compiling with mtasc ==

1. install mtasc from http://mtasc.org/ 

2. Follow the tutorial (http://www.mtasc.org/#tutorial) to make sure you can compile a simple .swf

3. example usage from this directory:
    mtasc -version 8  -cp . -header 800:400:20:FFFFFF -swf worldkit.swf -main com/brainoff/worldkitMain.main com/brainoff/worldkitMain.as

    this tells mtasc that:
      # -cp .
      + the class path is here   

      # -header 800:400:20:FFFFFF
      + to generate a movie of 800 width, 400 height, a framerate of 20, and a background color of white
        these can all be overridden by the values in the html

      # -swf worldkit.swf
      + make a swf file named worldkit.swf

      # -main com/brainoff/worldkitMain.main
      + the main() function is in that path

      # com/brainoff/worldkitMain.as
      + the file to compile -- since this file imports all other files, these will get compiled too.
 

4. this command:
        mtasc.exe -version 8  -cp . -header 800:400:20:FFFFFF -swf worldkit.swf -main com/brainoff/worldkitMain.main com/brainoff/worldkitMain.as
   can likely be placed directly in a .bat file and clicked to compile
   windows users may need to replace "-cp ." with -cp "C:\full\path\to\here"
   and like was for the -main path...
