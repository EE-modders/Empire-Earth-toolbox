# About IMG2EE

IMG2EE is a utility for converting topographical data gathered from the 
Mars Orbiter Laser Altimeter to an elevation data file format readable by
the Empire Earth Scenario Editor. 

It is written in PERL and so the computer it runs on needs a PERL interpreter.
The ActivePerl version of PERL: http://www.activestate.com 

If you have CYGWIN installed you can also use the PERL interpreter from CYGWIN. Please visit http://www.cygwin.com for more info.

If you don't have the space for ActiveState PERL or for CYGWIN PERL there is also a program called perl2exe available at http://www.perl2exe.com. It 
converts a PERL script into a Windows executable and seems to work fine on 
IMG2EE. You can use it for a 30 day trial period but after that you must pay
the $49 license fee.

You can get the mars topographical data (.IMG) files from 
http://wufs.wustl.edu/missions/mgs/mola/egdr.html

Make sure that the file is a topography file and not any of the other types. 
Obviously the higher resolution files (which can be quite large) will produce
maps with finer detail. The 1/8 degree/pixel file which is 8.1Mb in size is a
good file to start with. 

To find out about all the command line options available just type this at the
command prompt:

**perl IMG2EE.pl - help**

## Credits

I encourage you to play around with the script and see what you can create. I
would also like to thank the folks at Stainless Steel Studios Inc. for their
great game... Empire Earth.

**P.S.** To wet your appetites I have included some screen shots that show Mars in several states (baren and terraformed). All of these shots were done using the huge 1/32 degree/pixel map which is 90.5 Mb compressed. I have also included a sample elevation file that you can load into the Scenario Editor and play with before you commit to downloading any PERL interpreter or Mars data.






