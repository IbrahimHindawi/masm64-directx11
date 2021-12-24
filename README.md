# MASM64 + DirectX
##DirectX and Pure Assembly Language: Doing What Can't be Done
##Based on CMalcheski's tutorial up on CodeProject

#Part I

##How to Create a Complete DirectX Game in Assembly Language

Are You Serious?

Yep.

The internet is overrun with all the standard arguments for and against using assembly language for creating a full-scale application (in particular, a DirectX game).  Obviously, 99.99% of those arguments are against it – because everybody else is against it.  Rather than jump into that fray, this series of articles is aimed at explaining how to do it.  It’s assumed that if you want to create an all-assembly game for Windows, you’re old enough to make that choice.  You probably have a good idea of why you would want to undertake such a task (mostly because what you create will run rings around everything else out there in any number of ways), and the reality is that deviation from “what everybody else is doing” is not going to stop your efforts.

I will mention the most common argument: it will take so long to code a complete game in assembly language that your proverbial beard will be longer than those of the guys in ZZ Top before you’re even halfway through.  This argument is programmed deep into the mushy skulls of everybody who repeats it.  Effectively none of the people touting it have ever sat down to create a full-scale game in assembly, so that ends that argument.  It’s a complete myth.  I consistently find coding in ASM considerably faster than using any other language because of its simplicity, its direct approach to everything, and the complete lack of addiction to typecasting (i.e. micromanaging the developer into oblivion). 

Your efforts will, however, be somewhat hindered at times, mostly because of the almost complete lack of online support for what you’re doing.  You’re not likely to find source code samples in assembly; you’ll have to convert them from C++ or whatever other language you prefer.  In addition, header files don’t exist for you.  You’ll have to build your own, pulling whatever information you need out of the C++ (or whatever) headers.  It can be tedious, especially when it comes to converting DirectX data structures.

On that note, the task is a nightmare.  Through experience, I’ve discovered that simply reading the types out of these structure declarations is not enough.  When is a LONG not a LONG?  All the time, in DirectX!  While I can’t remember the exact location online, I posted about this once, giving specifics: the same data type being encoded as 64 bits in one structure and 32 in another.  Worse, DirectX loves nesting structures to absolutely ridiculous levels, and manually unwinding all that information takes its toll in time and patience.  If you're serious about setting performance records for your game, be ready for it.

The good news is, it only needs to be done once for every structure.  Unless, of course, you’re given to procrastination when it comes to making backups of your work.

##Structures: Theirs to Yours

The way I convert data structures is to open a C++ app, set a pointer to every single member of a data structure, then use that pointer in a function call so that the helpful C++ compiler doesn’t erase the reference for its being unused.  When this is all complete, I have to step through (at the disassembly level) every line of that code to look at the actual pointers being placed into the CPU registers.  This tells me the actual size of every structure member.  It’s a pain, and I hate doing it.  But there is no viable option.

Out of Time and Place

By and large, the development community always moves toward abstraction.  In the process, coding always becomes more and more bogged down in ritual and management.  This is seen as “progress,” when in reality the app becomes bigger, it runs slower, and developers become less and less productive as their learning curve continues to increase.  Lather, rinse, repeat.  Layers of pointless management on top of more layers of pointless management are the law of the land.  That's the reality we all live in.

Assembly is very, very different.  It’s extremely direct.  Data is data; there is no typecasting.  As a developer, you probably know when you want to use a value as a float or an integer, and you may become very addicted, very quickly, to finally being out from under the absolutely stifling levels of hindrance that the obsession with typecasting places you under.  A byte is a byte is a byte and that’s the extent of it.  Data is data; do what you will with it.  You are in control.

##Manufacturer Direct

A good example of the benefits of direct access to data without typecasting is flipping the sign of a float value.  If you’re using a 32-bit real (DirectX uses these across the board, even in 64-bit mode), you don’t have to load the value into a register, issue some instruction (or instructions) to flip the sign, then place the value back into memory.  Instead, you can simply treat it as an integer and flip bit 31 (0-based, bits 0 to 31):

                xor dword ptr Foo, 80000000h ;

##The float is now sign-reversed. 

Benefits like this permeate assembly language.  Most of those benefits will only become known as your own creativity kicks into gear, but they will accumulate.  Only through direct experience, through extensive use of assembly language to create a full-scale application, will you begin to build a clear, modern, accurate picture of how the task really compares to using any other language.  You won’t just be parroting what you were taught to believe.  You will have been there to know.  It’s a distinction very few others have.

##The Wretched Refuse

A final note before continuing on to specifics: using assembly language is your own private undertaking.  It will put you at odds with the development community, and you’re not likely to ever get a job doing it – unless you have the political connections required to get into some firm doing government intel or aerospace work; a job where a $25k security clearance is a must.  By undertaking a full-scale assembly language application, you will be directly contradicting what every hiring manager wants to see.  It won’t help you in your professional life.  Either you get something of your own on the market, where the end users don’t care how you created it, or you somehow got the okay to create a platform-dependent (i.e. any game console) app.  So know what you’re getting into, and don’t imagine a future that just doesn’t exist for you because of it.

Yes, there are exceptions to everything written above, but what will it cost you to become one of those exceptions?

Part II dives into the beginning of actual game development: initializing your display window and setting up DirectX.  Get ready for an entirely new landscape.
