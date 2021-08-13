The binaries of mame on 32 bit OSes don't output all systems due to a virtual memory error .

This problem started with mame0228 .

Possibly due to a fact that 32 bit OSes can't give enough virtual memory to mame .

But it can also be an issue, I added the issue here : 

https://github.com/mamedev/mame/issues/8274

This is why we now extract all the data in a different way and use these files, here, for the scripts .

So I downloaded the 64bit zipped binaries from https://www.mamedev.org/oldrel.html and extracted them in separate directories .

Then I extracted the data on a 64 bit Windows10 with next command (for other versions they are similar) :

C:\Users\pi\Downloads\MAME\mame0234>mame -listdevices | findstr /B Driver > mame0234_systems



