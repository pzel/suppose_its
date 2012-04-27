suppose_its
===============
### A tool for testing date-related code ###

Copyright 2010-2012 by Irek Jozwiak, 2012 by [Humane Software](http://humane-software.com). All rights reserved.

Licenced under the BSD licence (see below).


What does it do?
-------------------

`suppose_its` uses a technique called **library interposing** to override calls to the `gettimeofday(2)` system function. It can be used to trick programs into thinking the system time is different then the actual time. The canonical use case is acceptance-testing date-related code. 

It runs on Linux (debian, ubuntu), FreeBSD, and OS X (Leopard and later versions), provided the system has a C compiler and a POSIX-compliant shell (sh, ksh, dash, bash) available at `/bin/sh`.

It will not work with statically compiled programs.


Basic Use
---------------

 Assuming you have placed the script in your $PATH and it is executable, you can use it as follows:

1. Place a [POSIX timestamp](https://en.wikipedia.org/wiki/Unix_time) in a file of your choosing:
        
        $ echo -n "1234567890" > test_timestamp.txt

2. Pass the program string as the third argument to `suppose_its`:
        
        $ suppose_its ./test_timestamp 'ghc -e "System.Time.getClockTime"
        Sat Feb 14 00:31:30 CET 2009
        
        $ suppose_its ./test_timestamp.txt '/usr/bin/ruby -e "puts Time.now.to_i"
        1234567890
        
        $ rm ./test_timestamp.txt
        $ ./suppose_its ./test_timestamp.txt '/usr/bin/ruby -e "puts Time.now.to_i"'
        1335544057  # Returns the actual system time if the timestamp is not found on disk.


Dynamic Use
---------------

`suppose_its` checks for the timestamp before every call to `gettimeofday(2)`. This means you can effectively "travel through time" while a program is being executed. 

        $ echo -n "1234567890" > test_timestamp.txt
        $ ./suppose_its ./test_timestamp.txt python
        Python 2.7.2+ (default, Oct  4 2011, 20:03:08) 
        
        >>> from datetime import *
        >>> datetime.today()
        datetime.datetime(2009, 2, 14, 0, 31, 30)
        >>> def given_now_is(timestamp):
        ...open('test_timestamp.txt','w').write(str(timestamp))
        ... 
        >>> given_now_is(1294599990)
        >>> datetime.today()
        datetime.datetime(2011, 1, 9, 20, 6, 30)


Bugs and Limitations
--------------------

 * Quotes in arguments for programs run with `suppose_its` need to be escaped. 
   
         $ ./suppose_its ts ghc -e "fmap show System.Time.getClockTime"
         Warning: ignoring unrecognised input `System.Time.getClockTime'
         target `show' is not a module name or a source file
         # No go. 
         
         $ ./suppose_its ts ghc -e \"fmap show System.Time.getClockTime\"
         "Thu Jan  1 01:01:40 CET 1970"
         # That worked.
        
 * Alternatively, the whole command can be single-quoted:
        
        $ ./suppose_its ts 'ghc -e "fmap show System.Time.getClockTime"'
        "Thu Jan  1 01:01:40 CET 1970"

 * Some programs do not use `gettimeofday(2)` to retrieve time data, rendering `suppose_its` useless.

        $ echo -n "100" > test_timestamp.txt
        $ ./suppose_its ./test_timestamp.txt date
        Fri Apr 27 18:41:01 CEST 2012
     
        $ ./suppose_its ./test_timestamp.txt 'csi -e "(use posix) (display (seconds->string (current-seconds))) (newline)"'
        Fri Apr 27 19:02:06 2012




Wanted:
---------------

 * Interposing for the `time(2)` function.


Licence
---------------

Redistribution and use in source and binary forms, with or without modification, are
permitted provided that the following conditions are met:

   1. Redistributions of source code must retain the above copyright notice, this list of
      conditions and the following disclaimer.

   2. Redistributions in binary form must reproduce the above copyright notice, this list
      of conditions and the following disclaimer in the documentation and/or other materials
      provided with the distribution.

THIS SOFTWARE IS PROVIDED BY IREK JOZWIAK & HUMANE SOFTWARE``AS IS'' AND ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL IREK JOZWIAK, HUMANE SOFTWARE OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF
ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

The views and conclusions contained in the software and documentation are those of the
authors and should not be interpreted as representing official policies, either expressed
or implied, of Irek Jozwiak or Humane Software.

All software brands mentioned within are property of their respective owners.
