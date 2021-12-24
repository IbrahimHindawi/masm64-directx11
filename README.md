# MASM64 + DirectX
## DirectX and Pure Assembly Language: Doing What Can't be Done
## Based on CMalcheski's tutorial up on CodeProject

- [Part I](https://github.com/IbrahimHindawi/masm64dx#part-i)
- [Part II](https://github.com/IbrahimHindawi/masm64dx#part-ii)

# Part I

## How to Create a Complete DirectX Game in Assembly Language

Are You Serious?

Yep.

The internet is overrun with all the standard arguments for and against using assembly language for creating a full-scale application (in particular, a DirectX game).  Obviously, 99.99% of those arguments are against it – because everybody else is against it.  Rather than jump into that fray, this series of articles is aimed at explaining how to do it.  It’s assumed that if you want to create an all-assembly game for Windows, you’re old enough to make that choice.  You probably have a good idea of why you would want to undertake such a task (mostly because what you create will run rings around everything else out there in any number of ways), and the reality is that deviation from “what everybody else is doing” is not going to stop your efforts.

I will mention the most common argument: it will take so long to code a complete game in assembly language that your proverbial beard will be longer than those of the guys in ZZ Top before you’re even halfway through.  This argument is programmed deep into the mushy skulls of everybody who repeats it.  Effectively none of the people touting it have ever sat down to create a full-scale game in assembly, so that ends that argument.  It’s a complete myth.  I consistently find coding in ASM considerably faster than using any other language because of its simplicity, its direct approach to everything, and the complete lack of addiction to typecasting (i.e. micromanaging the developer into oblivion). 

Your efforts will, however, be somewhat hindered at times, mostly because of the almost complete lack of online support for what you’re doing.  You’re not likely to find source code samples in assembly; you’ll have to convert them from C++ or whatever other language you prefer.  In addition, header files don’t exist for you.  You’ll have to build your own, pulling whatever information you need out of the C++ (or whatever) headers.  It can be tedious, especially when it comes to converting DirectX data structures.

On that note, the task is a nightmare.  Through experience, I’ve discovered that simply reading the types out of these structure declarations is not enough.  When is a LONG not a LONG?  All the time, in DirectX!  While I can’t remember the exact location online, I posted about this once, giving specifics: the same data type being encoded as 64 bits in one structure and 32 in another.  Worse, DirectX loves nesting structures to absolutely ridiculous levels, and manually unwinding all that information takes its toll in time and patience.  If you're serious about setting performance records for your game, be ready for it.

The good news is, it only needs to be done once for every structure.  Unless, of course, you’re given to procrastination when it comes to making backups of your work.

## Structures: Theirs to Yours

The way I convert data structures is to open a C++ app, set a pointer to every single member of a data structure, then use that pointer in a function call so that the helpful C++ compiler doesn’t erase the reference for its being unused.  When this is all complete, I have to step through (at the disassembly level) every line of that code to look at the actual pointers being placed into the CPU registers.  This tells me the actual size of every structure member.  It’s a pain, and I hate doing it.  But there is no viable option.

## Out of Time and Place

By and large, the development community always moves toward abstraction.  In the process, coding always becomes more and more bogged down in ritual and management.  This is seen as “progress,” when in reality the app becomes bigger, it runs slower, and developers become less and less productive as their learning curve continues to increase.  Lather, rinse, repeat.  Layers of pointless management on top of more layers of pointless management are the law of the land.  That's the reality we all live in.

Assembly is very, very different.  It’s extremely direct.  Data is data; there is no typecasting.  As a developer, you probably know when you want to use a value as a float or an integer, and you may become very addicted, very quickly, to finally being out from under the absolutely stifling levels of hindrance that the obsession with typecasting places you under.  A byte is a byte is a byte and that’s the extent of it.  Data is data; do what you will with it.  You are in control.

## Manufacturer Direct

A good example of the benefits of direct access to data without typecasting is flipping the sign of a float value.  If you’re using a 32-bit real (DirectX uses these across the board, even in 64-bit mode), you don’t have to load the value into a register, issue some instruction (or instructions) to flip the sign, then place the value back into memory.  Instead, you can simply treat it as an integer and flip bit 31 (0-based, bits 0 to 31):

```
  xor dword ptr Foo, 80000000h ;
```

## The float is now sign-reversed. 

Benefits like this permeate assembly language.  Most of those benefits will only become known as your own creativity kicks into gear, but they will accumulate.  Only through direct experience, through extensive use of assembly language to create a full-scale application, will you begin to build a clear, modern, accurate picture of how the task really compares to using any other language.  You won’t just be parroting what you were taught to believe.  You will have been there to know.  It’s a distinction very few others have.

## The Wretched Refuse

A final note before continuing on to specifics: using assembly language is your own private undertaking.  It will put you at odds with the development community, and you’re not likely to ever get a job doing it – unless you have the political connections required to get into some firm doing government intel or aerospace work; a job where a $25k security clearance is a must.  By undertaking a full-scale assembly language application, you will be directly contradicting what every hiring manager wants to see.  It won’t help you in your professional life.  Either you get something of your own on the market, where the end users don’t care how you created it, or you somehow got the okay to create a platform-dependent (i.e. any game console) app.  So know what you’re getting into, and don’t imagine a future that just doesn’t exist for you because of it.

Yes, there are exceptions to everything written above, but what will it cost you to become one of those exceptions?

Part II dives into the beginning of actual game development: initializing your display window and setting up DirectX.  Get ready for an entirely new landscape.

# Part II

## The Fine Print

Before diving into specifics, this article is prefaced with an important disclaimer. 

Every beginner in assembly language can teach me a thing or two.  When I run across their work, they usually do.  There are instructions in the x64 architecture that I should know, and still don’t.  After decades of assembly programming as my primary language, I tend to become set in my ways, and sometimes those ways can be limiting.  You should assume that everything presented in this series of articles can be improved on.  And it doubtless will be.  I’m not the final word on anything, and I don’t claim to be. 

Ultimately, my true value as a developer is measured by the end users I develop for – not by other developers.  You will bring your own style and flair to whatever tasks you undertake; little things that are unique to you.  They add up to a unique combination of nuances and methods.  Taken together, it’s a larger whole that we can’t exactly duplicate anywhere else.   You are all the world gets.  What you do matters, whether it’s in the workplace or on your own time.  It matters a lot.

This series of articles is a gateway, not a rigorous path.  When you find a better way of doing something (and you will!), don’t be shy about using it. 

## Waffling!

In Part I, I stated that part II would cover creation of the main window and initialization of DirectX.  These are being deferred to parts III and IV, respectively, because the highly necessary preface to engaging in those tasks ran much longer than originally thought.  Since I’m here to write articles, not War And Peace to be read in one sitting, I have to temper my efforts.  Assembly language is a different world and there’s a lot to say about it, just to cover the departure from “normal” high level languages.  So, to keep the length of each article to something sane, I’m deviating from my original plan and breaking things up more than I originally thought would be necessary. 

## Tools of the Trade

There is no shortage of assemblers out there.  I use the stock ML64.EXE from Microsoft; it ships with Visual Studio.  The differences between the various assemblers floating around is relatively minimal, so if you choose to go with something other than ML64.EXE, you’ll have to make whatever adjustments that assembler requires to the source code provided in this series.

The same holds true for the linker: LINK.EXE, shipping with Visual Studio, is what I use.

The same with the resource compiler, rc.exe.  All three files are present in the VC\bin directory (or its children) of your Visual Studio install path.

I have a single batch file that does everything – builds the resource.rc file, assembles, and links.  The contents of the batch file used to compile my edit side project (discussed shortly) is below:

```
"C:\Program Files (x86)\Windows Kits\10\bin\x86\rc.exe" resource.rc
"C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\x86_amd64\ml64.exe" /c /Cp /Cx /Fm /FR /W2 /Zd /Zf /Zi /Ta edit.xasm
"C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\link.exe" edit.obj resource.res /debug /opt:ref /opt:noicf /largeaddressaware:no /assemblydebug /def:edit.def /entry:Startup /machine:x64 /map /out:edit.exe /PDB:edit.pdb /subsystem:windows,6.0 "C:\Program Files (x86)\Windows Kits\10\Lib\10.0.10586.0\um\x64\kernel32.lib" "C:\Program Files (x86)\Windows Kits\10\Lib\10.0.10586.0\um\x64\user32.lib" "C:\Program Files (x86)\Windows Kits\10\Lib\10.0.10586.0\um\x64\gdi32.lib" "C:\Program Files (x86)\Windows Kits\10\Lib\10.0.10586.0\um\x64\ComCtl32.lib" "C:\Program Files (x86)\Windows Kits\10\Lib\10.0.10586.0\um\x64\msimg32.lib"
```

## The Almighty Text Editor

If you do a search on “assembly language IDE,” you'll be greeted with a listing of integrated development environments (IDE’s) for assembly language.  I personally have not used them, primarily because I’m very stuck on my current text editor.  I’m not going to mention the name of it because the author was outrageously abusive and even more unprofessional when I tried to upgrade a few years back (I paid the full price; he just didn’t want to provide the product).  It’s one of those things where I’ve been using that editor forever and I’m just stuck on it.  I’m currently working on my own editor as a side project; until that’s done, I’ll continue using what I’m using.  So you’ll need to either find a text editor you like, or an IDE that supports assembly language.

The one requirement for a text editor that will save you oodles of hours is that it does column blocking.  This is where you can block a column or columns of text and do things with them – cut, copy, paste, indent, etc.  Beyond that, see what’s out there and see what you like.

Choosing an editor based on what you liked for any other language will probably not make you happy if you’re working with assembly.  Experiment and see what’s out there.

If you’re new to assembly, I would strongly recommend reviewing your options for text editors frequently, at least in the early going.  As your knowledge increases, you’ll have a better and better idea of what you do and don’t like and you’ll be able to make a better selection.

My own personal recommendation: don’t skimp.  If you really like an editor but it’s $99 or $79 or something similar, just pay it and be done with it.  It isn’t worth cutting corners.

## Unlearn What You Have Learned

If you’re like most people, the first thing you’ll be driven to do is to bend over backward to make your assembly language code look as much like high level language code as possible.  The dogmatic influence of the established development community runs deep, and we’re all conditioned to feel that violating a technique or approach that’s commonly assumed to be “correct” makes us truly inferior developers.  Don’t buy into it.  Ultimately, “right” and “wrong,” as the established community defines them, aren’t really right and wrong at all.  It’s nothing more than perpetuated dogma and, ultimately, personal preference.

If you’re unwilling to bear the rejection and/or criticism of other developers, then you’ve already placed serious limits on the very reasons behind using assembly in the first place.  Forget the judgements of others.  Let them judge, scream, whine, complain, and denigrate you.  Does your game work?  If so, you’re producing work that is nearly perfect.  You’ll be working in an environment that most others will never know beyond peripherally, if at all.  You make your own rules about what is proper practice and what isn’t.

## Learn As You Go

Conceptually, there are volumes of material to cover when creating an all-assembly app for DirectX.  To cover that material without using actual code as a catalyst for learning is likely an exercise in futility.  Therefore I’ll simply begin creating the source code, explaining each step as I go.

My app will begin by declaring the required data; actual code will begin by creating a window.  This window will serve as the render target – the place where drawing is displayed.  Therefore the app’s handling of Windows messages will be absolutely minimal, since DirectX takes care of most of the window management.  Interfering with it too much can cause problems.

There is one notable exception to this general rule: the window frame.  For the sake of completeness, I’ll be customizing the frame in this project’s source code.  DirectX doesn’t concern itself with window frames, so far as I know, and any amount of customization there is fair game.  If you plan to use assembly language, then odds are good that you’re passionate enough about your project to want to pull out all the stops.  If you want to go with the stock Windows frame (many games do), then simply use DefWindowProc for handling all the messages relating to the window frame.

## Make it So, Mr. Data

First, the main module needs to be created.  I’ll call mine “game.asm” for this project.  It begins with a directive declaring the data segment. 

```
.data
```

That’s how difficult it is to declare your data segment.  Until the compiler reaches a `.code` directive, everything encountered in the source file is treated as data declarations.

Assembly language separates data and code into two distinct areas.  This is actually per the format of the Windows PE (Portable Executable) file format, and any language you use is going to compile to do the same – you just don’t see it in most other languages, which allow you to mix data and instructions as you see fit.

How your data is declared can have a huge impact on your game’s performance, so it’s critical to understand what’s happening at the CPU level when variables are declared. 

With assembly language, variables stay where you put them.  Variables – especially data structures – should always be aligned at memory addresses evenly divisible by their size.  If this is not done, the CPU executes two memory accesses (instead of one) to fully read or write the value.  Bytes can be placed anywhere; words (2-byte values) should always be placed at addresses evenly divisible by 2; doublewords (dwords) should be on 4-byte boundaries, and quadwords (qwords) should be on 8-byte boundaries.  **The compiler will not handle this alignment for you.**  While this rule places extra responsibility on the developer, it also places extra control.  For example, if you create the following C++ data structure:

```
short Foo1;
byte  Foo2;
int   Foo3;
```

then the C++ compiler will place up to 7 bytes of unused padding after **Foo2**, in order to properly align the qword (int) value **Foo3**.  The developer will never see this wasted memory but it’s firmly encoded within the final executable.  Using assembly, if you instead code the structure as:

```
align 8 ; (this directive is explained shortly)
qword Foo3
word  Foo1
byte  Foo2
```

you won’t have any alignment issues.  **Foo1**, following an 8-byte qword, will naturally fall on an 8-byte boundary, which inherently satisfies the “even multiple of two bytes” requirement for properly aligning it.  **Foo2**, being a byte, has no alignment requirements – one memory access will retrieve it under all circumstances.

In the above code, the `align` directive causes the compiler to generate between 0 and 7 padding bytes to create the desired alignment, depending on where the final compiled data would be placed if `align` were not used. 

The `align` directive accepts any alignment value up to and including 16, but must always be a power of 2. 

For single variables (not part of any structure), an optimally coded data segment would naturally begin on a 16-byte boundary, so all qword declarations would come first, followed by all dwords, with words next and bytes last.  This arrangement would eliminate the need for any align directives, thereby eliminating all wasted padding in the data segment – at least relating to single variables.

Ultimately, if you’re after performance, data alignment is critical, but a few bytes of memory wasted here and there, resulting from the use of **align** directives, isn’t going to destroy your app.  Even in the worst cases, that waste will be a drop in the bucket compared to the amount of memory you’ll be saving overall by using assembly.

Since you have to declare all data manually, you can see, easily enough, what’s going on with alignment at all times.

Regarding data structures, DirectX follows all the alignment rules within its structure declarations, so the only thing you need to be concerned with when creating structures using those definitions is the initial alignment of your structure.  This is where the **align** directive is most likely to be used. 

For your own custom data structures (which will be covered later), you’re in complete control of what is placed where, so following the general rule of maintaining data alignment, ongoing, within these structures is the best practice for ensuring maximum performance.

**Note that any values to be accessed as packed data by XMM or YMM registers must be 16-byte aligned. This is a CPU-level rule; the processor will raise an exception if this rule is not followed.**

## Stand Up and Be Counted

The `include` directive is the next line in the app’s source code, after `.data`.  It includes one source file into another, effectively embedding it for the compile process. 

```
.data
include variables.asm
include macros.asm
include structures.asm
...
```

While you can certainly place all data declarations into one source file, you’ll discover soon enough that with an application of any appreciable size, you won’t want to.  Here, your own preferences and creativity will decide how your data declarations are broken up between files.  I personally am very liberal about breaking up data declarations into separate files because it makes things very easy to find.  I use one data file for lookup lists (where variables are looked up or referenced against a list of possible values), another for structures, another for variables, and so on.

## Neither Here nor There

This is as good a time as any to cover the issue of local vs. global data.  Even (or especially) in DirectX games, developers seem to be in the habit of initializing data structures on the fly.  This is only required when a structure or value is declared locally within a function, or for fields of a structure that are unknown before runtime.  To do it at all is performance suicide.  Why?

Locally declared variables live on the stack.  The compiler assigns a location in the stack’s space for each local value, but it doesn’t assign an initial value at those locations, unless one is explicitly set in the source code.  The initial value is whatever was last placed into memory (the stack space) at the variable’s location: leftover garbage. 

Following the assignment of a specific location for a local variable, the compiler will generate the instructions required to initialize the data (if such statements are present in the code).  This by itself completely destroys the idea of saving any kind of memory by making a value local instead of global.  There are other reasons why a value would be made local; the point is that no memory is saved by doing it.  In addition to the extra bytes of code required to initialize it, immediate data (data coded directly into an instruction) is used where it can be and this further bloats the code.  All data that will eventually end up in local variables must be declared somewhere – usually within the code itself – thus increasing the memory usage by however many bytes of code are required to do the initialization.  In far too many cases, nothing is gained beyond adherence to ritual, and a good amount of performance and memory (all things being relative) are lost.  Local data, in my opinion, is drastically overused, and in the long run the practice of using it costs plenty in the arenas of both memory and performance. 

Worse, every reference to local variables requires indirect addressing.  This is where the actual location of each variable has to be calculated by the CPU on the fly, typically using relatively costly addition per access.  The CPU’s `RBP` register is used as a base; from there, some number of bytes must be added (or subtracted) to find the variable’s location.  The offset of a local variable, from a base location, is always known when the app compiles, but the value of the base – the `RBP` register – won’t be known until the application executes.  So indirect addressing is the only option for accessing local variables.  When you’re trying to maintain a good frame rate for your game, you might as well be running through quicksand.  You will see easily measurable performance gains just by cutting your use of local variables to an absolute minimum – those gains won’t translate to dozens of frames per second but they’ll definitely have an impact.

Use local data when there’s a compelling reason to use it – primarily, when multiple execution threads must access the same variable.  Otherwise, especially for a game, go global, in spite of your conditioning to do otherwise.  Globally declared variables, structures, strings, etc. reside in the data segment, affording the compiler the luxury of using hard-coded addresses to access them.  No extra calculation is required. 

(The operating system will adjust references to variable locations when the app loads; this fixup processing is handled by the OS loader and doesn’t need to be discussed here.)

## The OMG WinCall Macro

There is one core macro that I use, that you may want to copy verbatim into your code.  I call it `WinCall`, and it’s used to invoke every single Windows API call that my application makes – including DirectX methods. 

It took some time get it working just right, and its main drawback is that **you cannot use the** `RAX` **or** `R10` **registers for holding parameters when invoking it.**  There are probably a hundred thousand arguments about why this was really bad coding, and those arguments are probably all correct.  But that’s how I did it.  `R10` and `RAX` will be destroyed before the actual Win32 call is made; they’re an integral part of the process of actually setting up the call.  So attempting to use them for holding parameter values will not end well. `RAX` and `R10` could be saved and then restored within the macro, but this translates to memory access which is public enemy #1 for an app focused on performance.  

**As with all macros, the** `WinCall` **macro is merged, not called - every time you invoke it, its contents are added to your source code at the location where it was invoked.**  

Regarding `RAX` and `R10`, those with more virtue than I will probably modify the macro to eliminate this frightening display of amateur ineptitude. 

My article on the 64-bit calling convention outlines how parameters are passed to Windows functions in 64-bit mode, and this convention is what necessitates the use of the `WinCall` macro. 

```
  WinCall parameter count, parm1, parm2, …
```

The actual content of the macro follows:

```
WinCall            macro     call_dest, parm_count, fnames:vararg

                   local     jump_1, jump_2, lpointer

                   mov       rax, parm_count
                   cmp       rax, 4
                   jge       jump_1
                   mov       rax, 4
jump_1:            shl       rax, 3
                   push      r10
                   mov       holder, rsp
                   sub       rsp, rax
                   test      rsp, 0Fh
                   jz        jump_2
                   and       rsp, 0FFFFFFFFFFFFFFF0h
jump_2:            .if parm_count > 3
                     lPointer  = 4
                     for       fname, <fnames>
                       mov       r10, fname
                       mov       qword ptr [rsp+lPointer], r10
                       lPointer  = lPointer + 8
                     endm
                   .endif

                   call      call_dest
                   mov       rsp, holder
                   pop       r10
                   endm
```                   
The `WinCall` macro creates 8 bytes of stack space for each parameter, with a minimum of 32 bytes created regardless of the number of parameters. The first four parameters are passed in `RCX`, `RDX`, `R8` and `R9` respectively. Any parameters beyond the 4th are placed on the stack.

**EVERY FUNCTION THAT INVOKES THE WINCALL MACRO MUST HAVE A LOCAL VARIABLE “HOLDER” DECLARED AS A QWORD.**  It has to be local because a Win32 call can trigger messages being sent to a window callback before it returns; that callback can and most likely will execute further API calls using `WinCall`.  So `holder` must be local, defined as a qword, and it must exist in every function in your app that calls into the Win32 API. Further on in the source code, every function will contain it so you can see its formatting there.

For calling functions that are defined within my app, I just use the assembly language `call` instruction.  This will be shown when the source code for this series reaches that point.

In place of this macro, **you cannot use the ML64.EXE INVOKE directive.  It doesn’t compile in 64-bit mode.**

## Forward Declarations and Reaching Out with EXTRN

Forward declarations (of functions) don't exist in assembly language.  That they exist in any language is a curiosity to me; the linker has long been capable of processing multiple passes and this by itself should eliminate any need for forward-declaring functions.  But again, it's how things are, and somewhere down the line there were reasons for it.

Whatever the case, all external functions - including, or especially, anything living inside a Windows .DLL (the entire Windows / DirectX API) must be declared as an external so that calls to these functions will have an actual address to call.  You'll need to declare each function called in the Windows API (or any other library you link to) with the `extrn` directive.  Fortunately, this is simpler in 64-bit Windows than it was in 32-bit.  You'll be creating two-part declarations for each function: the actual `extrn` directive, and a `textequ` (text equate) statement. 

The `extrn` directive declares a function as external.  Fortunately, the name mangling that was so prevalent in 32-bit Windows has been more or less eliminated in the 64-bit flavor.  With the 64-bit calling convention, there is no `_imp__Foo@4` because no parameters are placed on the stack, which the `@4` (or whatever the parameter count was for each function) specified.  As an example, declaring the `DefWindowProc` function as external is shown below.

```
extrn __imp_DefWindowProc:qword
DefWindowProc textequ <__imp_DefWindowProc>
```

All Windows and DirectX functions called by an app are declared in this manner.  
The textequ directive is not required; it just simplifies things so that you can call DefWindowProc instead of __imp_DefWindowProc.  Note that externally declared function names, unlike most of the rest of assembly language, are case sensitive.  If you get the case wrong on even one character, the linker will go down in flames and error out.  Just about anywhere else in assembly language, there is no case sensitivity.

The "A" and "W" functions, used for handling ANSI (A) and wide (W) character strings, are also standardized using `extrn`.  For example, the `GetClassName` function is declared as follows for Unicode:

```
extrn __imp_GetClassNameW:qword
GetClassName textequ <__imp_GetClassNameW>
```

The function declared in the `extrn` statement must exactly match what the library containing the function is exporting, including case.  In most situations, if one or more parameters is a pointer to a string, the function will have an A or a W attached (pick the one you want to use).  You can drop that A or W on the left side of the `textequ` statement, so that within your app you don't need to specify it.  Obviously, you'll want to use all W or all A functions for the sake of maintaining your sanity.  You can mix and match, if you're so inclined, but you'll have to either remember which functions are A and which are W, or keep looking it up in your `extrn` directives.

Nothing more needs to be done to access DirectX, WinAPI, etc. functions.  Declare them as external, and use textequ if you choose to - and just about anybody would choose to.

**Next?**

Part III will finally dive right into declaring the main window class and creating the main window.  This will include coding the main window’s callback function.  It’s basic stuff for those with any kind of Windows development experience, but there’s plenty to talk about regarding moving it all over to assembly language.




