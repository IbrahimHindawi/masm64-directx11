# MASM64 + DirectX
## DirectX and Pure Assembly Language: Doing What Can't be Done
## Based on CMalcheski's tutorial up on CodeProject

- [Part I](https://github.com/IbrahimHindawi/masm64dx#part-i)
- [Part II](https://github.com/IbrahimHindawi/masm64dx#part-ii)
- [Part III](https://github.com/IbrahimHindawi/masm64dx#part-iii)
- [Part IVa](https://github.com/IbrahimHindawi/masm64dx#part-iv-a)
- [Part IVb](https://github.com/IbrahimHindawi/masm64dx#part-iv-b)

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

# Part III

Apologies for the misformatted code snippets that appear sporadically in this article.  I've been over these, deleted then retyped them, redone the formatting, all to no avail.  As near as I can tell, this appears to be a bug in the CodeProject HTML - if not, I'm just not seeing what the issue is.  The line breaks are not present when I submit the article.  They show up afterward; horizontal scrolling in the snippets turns off and the line breaks appear out of nowhere.

The source code for this article can be downloaded from http://www.starjourneygames.com/demo part 3.zip

## Beginning the Main Module

Unlike 32-bit assembly, relevant directives (such as .686P) are few and far between.  I have not yet had occasion to use one.  With this being the case, the main module begins with the following:

```
include     constants.asm                           ;
include     externals.asm                           ;
include     macros.asm                              ;
include     structuredefs.asm                       ;
include     wincons.asm                             ;

.data                                               ;

include     lookups.asm                             ;
include     riid.asm                                ;
include     routers.asm                             ;
include     strings.asm                             ;
include     structures.asm                          ;
include     variables.asm                           ;

.code                                               ;
```

With this, an adjustment is made to the main source file’s beginning so that utility files, such as typedefs, structure declarations, and macros, come before the `.data` directive.  The files that contain no code or data (those appearing before the `.data` directive) define macros, structures, etc. for the compiler.  They generate no actual output, so these can be placed before the `.data` directive, where the compiler doesn't yet have any idea where to place generated output and thus would reject actual code or data.  

The linker will set the entry point (discussed next) at the start of the `.code` section, so the ordering of the code and data sections is irrelevant.  This app places data first.  

Each of the include files listed above is self-explanatory as to its content.  The accompanying source code contains the complete files.

## The Windows Entry Point

An application’s `WinMain` function isn’t really its entry point.  When an assembly language application declares its code segment with

```
.code
```
the first executable instruction after `.code` becomes the app’s true entry point.  `WinMain` is purely superfluous and is not actually required at all.  I don’t use it; in an assembly language application it provides no benefit over creating the app without it.  While one could argue that the parameters passed to `WinMain` might be critical to initializing an application, that argument is zero sum when it comes to an assembly app because you, the developer, need to set up that call to `WinMain` if you’re going to use it.  If you have to retrieve all the information typically sent to `WinMain` before calling it, why use the function at all? 

That said, there is certainly no measurable harm in including `WinMain` if you want to do it.  You may have sound reasons for wanting to include it, so add it if you feel it’s necessary.  Just be aware that your own startup code – which begins execution immediately after the `.code` statement – must manually set up the `WinMain` call. 

To call `WinMain`, the nCmdShow parameter is retrieved from the `wShowWindow` field of the `STARTUPINFO` structure, which is passed to `GetStartupInfo`.

`GetCommandLine` returns the lpCmdLine parameter; pass that value as-is to `WinMain`.

`hPrevInstance` is always null, per MSDN documentation for `WinMain`.

`hInstance` is retrieved by calling `GetModuleHandle(0)`. 

Below is the complete initialization source for calling `WinMain`.  **Note that even if you're not going to include `WinMain`, you may still need some or all of the parameters that are passed to it.  The discussion that follows covers retrieval of this information, with or without implementation of `WinMain`.**

Declare the `STARTUPINFO` structure in structuredefs.asm (or wherever you prefer to put it):

```
STARTUPINFO         struct
cb                  qword     sizeof ( STARTUPINFO )         
lpReserved          qword     ?         
lpDesktop           qword     ?         
lpTitle             qword     ?         
dwX                 dword     ?         
dwY                 dword     ?         
dwXSize             dword     ?         
dwYSize             dword     ?         
dwXCountChars       dword     ?         
dwYCountChars       dword     ?         
dwFillAttribute     dword     ?         
dwFlags             dword     ?         
wShowWindow         word      ?         
cbReserved2         word      3 dup ( ? )
lpReserved2         qword     ?         
hStdInput           qword     ?         
hStdOutput          qword     ?         
hStdError           qword     ?         
STARTUPINFO         ends
```

In the externals.asm file, declare the functions to be called for initialization:

```
extrn              __imp_GetCommandLineA:qword
GetCommandLine     textequ     <__imp_GetCommandLineA>

extrn              __imp_GetModuleHandleA:qword
GetModuleHandle    textequ     <__imp_GetModuleHandleA>

extrn              __imp_GetStartupInfoA:qword
GetStartupInfo     textequ     <__imp_GetStartupInfoA>
```
If you’re using Unicode, you should declare `GetCommandLineW`, `GetModuleHandleW`, and `GetStartupInfoW` instead of the “A” functions shown above.

With the required functions now a known quantity to the compiler, variables need to be declared for holding the parameters to pass to `WinMain` – these are placed in the file variables.asm:
```
hInstance          qword     ?
lpCmdLine          qword     ?
```
In the file structures.asm, declare the `STARTUPINFO` structure:
```
startup_info STARTUPINFO <> ; cbSize is already set in the structure declaration
```
The entry point to the application can then be coded as follows (`Startup` can be renamed to anything you like - if you're going to call it `WinMain`, be aware that it doesn't inherently conform to the documentation for `WinMain`):
```
.code

align          qword
Startup        proc                          ; Declare the startup function; this is declared as /entry in the linker command line

local          holder:qword                  ; Required for the WinCall macro

xor            rcx, rcx                      ; The first parameter (NULL) always goes into RCX
WinCall        GetModuleHandle, 1, rcx       ; 1 parameter is passed to this function
mov            hInstance, rax                ; RAX always holds the return value when calling Win32 functions

WinCall        GetCommandLine, 0             ; No parameters on this call
mov            lpCmdLine, rax                ; Save the command line string pointer

lea            rcx, startup_info             ; Set lpStartupInfo
WinCall        GetStartupInfo, 1, rcx        ; Get the startup info
xor            rax, rax                      ; Zero all bits of RAX
mov            ax, startup_info.wShowWindow  ; Get the incoming nCmdShow

; Since this is the last "setup" call, there is no reason to place nCmdShow into a memory variable then
; pull it right back out again to pass in a register.  Register-to-register moves are exponentially
; faster than memory access, so all that needs to be done is to move RAX into R9 for the call to WinMain.

mov            r9, rax                       ; Set nCmdShow
mov            r8, lpCmdLine                 ; Set lpCmdLine
xor            rdx, rdx                      ; Zero RDX for hPrevInst
mov            rcx, hInstance                ; Set hInstance
call           WinMain                       ; Execute call to WinMain

xor            rax, rax                      ; Zero final return – or use the return from WinMain
ret                                          ; Return to caller

Startup        endp                          ; End of startup procedure
```
**NOTE:** If you’re strictly adhering to 64-bit calling convention, then the startup code’s call to `WinMain` should use the `WinCall` macro and not a direct `call` instruction. I don’t do this in my apps, and I won’t be doing it in this sample code. Stack usage means memory usage, and my first rule of programming is to avoid memory hits. When accessing the shadow area on the stack for RCX, RDX, R8, and R9 during a call, indirect addressing must be used, which further slows the app. As mentioned earlier, the in trepidation over violating the 64-bit calling convention may be strong. However it will still be unfounded as far as necessity is concerned. I simply see no benefit to using that convention within my app’s local functions – it requires a relatively large amount of setup code, which, across an entire app, takes too much time to execute; it costs memory, and it adds to development time.  Any function declared within my app (including this one) does not use the 64-bit calling convention directly – parameters are still passed in RCX, RDX, R8, and R9 for the first four, but space for shadowing them is not reserved on the stack. For additional parameters, I simply use other registers. The stack is not used for any parameter data.  Some will call this reckless, but “reckless” would only be relative to the standard being compared to.

Further, in my own apps, calls to local functions use a single pointer (in RCX) pointing to a structure that holds all the parameters to be passed to that function.  Doing things any other way, the first thing most local functions would need to do would be to save the incoming parameters in local variables for later access; from the CPU’s perspective this is little different from using the 64-bit convention as it was created.  I’m not doing that here; individual registers carry the parameters into local functions as they’re called.  The reason for this is that from a tutorial standpoint it’s much more confusing to work with a pointer to an array of parameters for every function, many of which will be pointers to other things.  When is enough, enough?  So it is again reiterated: modify the code as required to suit your own preferences.

## The Almighty RAX

Born in the earliest recorded incarnations of Intel CPU design, the RAX register (building on EAX, which built on AX) always holds the return value from a function.  I have not seen an exception to this rule in any WinAPI function or method, no matter what it is.  Even drivers use it across the board.  All functions within any application I write do the same, so it will apply here: no matter what you call, when you call it, or where you call it from, RAX holds the return value. 

## Registering the Window Class

To create the app’s main window, its window class has to be registered.  This necessitates declaring the `WNDCLASSEX` structure, which in this sample code will be done in a separate file called structuredefs.asm.  As always, you’re free to move things around and rename files as you see fit.  However, at this point an adjustment is being made to the main source file’s beginning so that utility files, such as typedefs, structure declarations, and macros, come before the .data directive.

The following is placed in the structuredefs.asm file:
```
WNDCLASSEX        struct
cbSize            dword     ?
dwStyle           dword     ?                   
lpfnCallback      qword     ?                    
cbClsExtra        dword     ?
cbWndExtra        dword     ?
hInst             qword     ?
hIcon             qword     ?
hCursor           qword     ?
hbrBackground     qword     ?
lpszMenuName      qword     ?
lpszClassName     qword     ?
hIconSm           qword     ?
WNDCLASSEX        ends
```
Nesting structures will be covered when the subject of DirectX structures is delved into – when there are actual examples to work with.

Mind your D’s and Q’s – be careful when copying code to accurately type `dword` and `qword` declarations.  One typo here could (and probably would) crash the app.

Strictly for the sake of keeping the source readable, I use a single constant to represent long chains of flags that are logically OR’d together.  In this app, `WNDCLASSEX.dwStyle` will equate to:
```
classStyle equ CS_VREDRAW OR CS_HREDRAW OR CS_DBLCLKS OR CS_OWNDC OR CS_PARENTDC
```
(The CS_xxx constants come from the Windows header files; they're declared in wincons.asm in the source code attached to this article.)

The `OR` directive is reserved by the assembler; it functions the same as the | character in most other languages.  I add the above line to my constants.asm file; you can place it (if you use it at all) wherever you like.

With this done, the actual `WNDCLASSEX` structure, which will be used to create the main window, can now be declared.  In this sample code, it’s done in the structures.asm file.  This is where all fixed data that can be is placed directly into the structure fields.  There’s no reason to move data around any more than is required, so on-the-fly initialization where it isn’t required makes no sense at all.  With `WNDCLASSEX`, the `hInst`, `hIcon`, `hbrBackground`, and `hIconSm` fields won’t be known until runtime, so they’re initialized at zero. 

There are several options when declaring the actual data for the `WNDCLASSEX` structure (which will be named wcl).  The most traditional form can be used:

```
wcl WNDCLASSEX <sizeof (WNDCLASSEX), [. . .]>
```
Using the format above, all fields must be accounted for if any are declared (however this will vary depending on the actual assembler being used). 

The way data is declared in assembly language allows for some flexibility in declaring structures, and at least for me, this comes in handy.  Declaring `wcl` as a label of type `WNDCLASSEX` allows me to list each field separately, while still having the debugger recognize the structure as `WNDCLASSEX`.  In the source code, I prefer having access to the individual fields per-line; it keeps the source cleaner and makes things easier to read and update.  Of course, doing things this way also opens the door to errors; if the field-by-field declaration doesn’t exactly match the `WNDCLASSEX` definition, there are going to be problems.  So using this method may not be for everybody.  If you don’t like it, just use the first form shown above.

```
wcl     label     WNDCLASSEX
        dword     sizeof ( WNDCLASSEX )  ; cbSize
        dword     classStyle             ; dwStyle
        qword     mainCallback           ; lpfnCallback
        dword     0                      ; cbClsExtra
        dword     0                      ; cbWndExtra
        qword     ?                      ; hInst
        qword     ?                      ; hIcon
        qword     ?                      ; hCursor
        qword     ?                      ; hbrBackground
        qword     mainName               ; lpszMenuName
        qword     mainClass              ; lpszClassName
        qword     ?                      ; hIconSm
```

The function `mainCallback` is the callback function for the window class; it will be discussed next.  The variable `mainClass` is the class name string, which I define in the strings.asm file, along with the main window name (window text), as:

```
mainClass     byte     ‘DemoMainClass’, 0  ; Main window class name
mainName      byte     ‘Demo Window’, 0    ; Main window title bar text
```

Note that the terminating 0 **must** be declared at the end of the string.  The assembler doesn’t automatically place it. 

From this point forward, assume that any constant used in Win32 calls must be declared somewhere in your source.  I put my Win32 constants in the file wincons.asm, and constants that are unique to my app in the file constants.asm. 

To fill in `hCursor`, `LoadImage` is called as follows.  In constants.asm, declare:

```
lr_cur equ LR_SHARED OR LR_VGACOLOR OR LR_DEFAULTSIZE
```

This is an optional step. If you prefer to use the values directly, simply replace `lr_cur` below with `LR_SHARED` OR `LR_VGACOLOR` OR `LR_DEFAULTSIZE`.

```
xor                 r11, r11                                ; Set cyDesired; uses default if zero: XOR R11 with itself zeroes the register
     xor                 r9, r9                                  ; Set cxDesired; uses default if zero: XOR R9 with itself zeroes the register
     mov                 r8, image_cursor                        ; Set uType
     mov                 rdx, ocr_normal                         ; Set lpszName
     xor                 rcx, rcx                                ; Set hInstance to 0 for a global Windows cursor
     WinCall         LoadImage, 6, rcx, rdx, r8, r9, r11, lr_cur ; Load the standard cursor
     mov                 wcl.hCursor, rax                        ; Set wcl.hCursor
```
**NOTE:** many data structures requiring runtime initialization will be of `dword`, or smaller, size.  You must pay close attention to this, as assembly will not stop you from writing a `qword` into a `dword` location.  It’ll simply overwrite the next four bytes after the `dword` when that isn’t what you want to do.  If `wcl.hCursor` were a `dword`, then the 32-bit EAX, not the 64-bit RAX, would be written there.  If it were a 2-byte word, then the 16-bit AX would be written, and if it were a single 8-bit byte, then AL would be written.

There are countless references to Intel architecture registers online.  Use them as needed.  The hardware designers, as a predominant rule, are very consistent in their naming of things, so it won’t take long to memorize how the registers work.  Just keep using them; the information will stick.

`hInstance` is assigned when the app starts up; anybody with any appreciable WinAPI experience knows that it’s used a lot.  It’ll be required when initializing DirectX, among other things.  It isn't used when loading the standard cursor because it's a stock object provided by Windows.  If hInstance is specified, Windows will search the calling application for the resource.  It won't find it, and the call will fail. 

In the call above, the `WinCall` macro is invoked.  `LoadImage` takes six parameters, so six parameters are specified.  64-bit calling convention requires that RCX, RDX, R8, and R9 hold the first four parameters, meaning these cannot be altered – other registers cannot be used in their place.  R11 is arbitrary; any open register except RAX or R10 (which the WinCall macro uses internally) can be used to store the `cyDesired` parameter because it’s not one of the first four parameters.  The `WinCall` macro will properly set up the stack for the call to `LoadImage`, caring nothing for which registers are used to carry values on entry into the macro. **Just remember `R10` is used by the macro itself as a taxi service so don't use it, or `RAX`, to give your parameters a sendoff into `WinCall`.**

For setting the hIcon and `hIconSm` fields, `LoadImage` is used the same as shown above; just change the cxDesired and cyDesired parameters to the appropriate dimensions of the icon; uType is set to `image_icon`, and of course `lpszName` is set to the name of the resource as it’s declared in your resource file.  `hInstance` must be set to the application's `hInstance`, since these resources are part of the application - they are not Windows-global.  The resource file is compiled by RC.EXE so nothing changes from its format in any C++ application (or any other language that handles resource files the same as C++).  The resource file lines for the icons are shown below:

```
LARGE_ICON   ICON   DISCARDABLE   "LargeIcon.ico"
SMALL_ICON   ICON   DISCARDABLE   "SmallIcon.ico"
```
In the assembly source, declare the names of the resources (I place these in the strings.asm file):

```
LargeIconResource     byte     ‘LARGE_ICON’, 0 ;
SmallIconResource     byte     ‘SMALL_ICON’, 0 ;
```
Pointers to the variables `LargeIconResource` and `SmallIconResource` are passed in turn to each of the two `LoadImage` calls that load the icons.  The results are placed into `wcl.hIcon` and `wcl.hIconSm` respectively.  These are qword fields so `RAX`, on return from `LoadImage`,  is assigned to each.  To actually load the pointers to the strings, use the assembly `lea` instruction.  This is “load effective address;” it was designed to perform on-the-fly calculation of memory address, and it will be used to its full potential later in the app.  For now, it simply loads the pointer with no calculation:
```
lea rdx, LargeIconResource ;
```
The reason this is necessary is that ML64.EXE eliminated the `offset` directive that used to be a part of Microsoft's assembly language.  Had they not retired it, the line could simply be encoded as “mov rdx, offset LargeIconResource.”  I have no idea why they did it; it’s another step backward in the eternal march toward abstraction de-evolution.

With all the above handled, the window class can now be declared:

```
lea     rcx, wcl                    ; Set lpWndClass
winCall RegisterWindowClass, 1, rcx ; Register the window class
```
The return value is not used by this app.

Registering the window class finally allows creation of the window that will serve as the DirectX render target.  Win32 is Win32 (64 bits or otherwise) so logically the window creation process continues the same as it would in a C++ application. 

The complete startup code is in the attached source for this article.

## Your Window to the Future

This section will focus primarily on the callback function for the main window.  The main difference between this app and the average C++ application is that here, the switch statement will not be used.  I have always disliked that statement, finding it clunky, primitive, and quite inefficient (given that I look at everything from the viewpoint of what is actually executing on the CPU). 

In place of switch, the CPU’s group of scan instructions is used.  These are CPU-level instructions that scan a given array of bytes (, `word`s, `dword`s, `qword`s) in memory until a match is found (or not).  The value to scan for is always contained in RAX for qwords, EAX for dwords, AX for words and AL for bytes.  RCX holds the number of qwords, etc. to scan, and RDI points to the location in memory to begin scanning.

One of the very convenient uses for the scan instructions is sizing a string.  The following code performs this task:

```
mov rdi, <location to scan>    ; Set the location to begin scanning
mov rcx, -1                    ; Set the max unsigned value for the # of bytes to scan
xor al, al                     ; Zero AL as the value to scan for
repnz scasb                    ; Stop scanning when a match is encountered or the RCX counter reaches zero
not rcx                        ; Apply a logical NOT to the negative RCX count
dec rcx                        ; Adjust for overshot (the actual match of 0 is counted and needs to be undone)
```

Whatever is encountered in memory that stops the scan (if `repnz` is used, for “repeat while not zero \[repeat while the CPU’s zero flag is clear\]”), RDI will point at the next `byte`, `word`, `dword`, or `qword` after that value. In the sample code above, when the scan completes, `RDI` will point at the byte immediately after the string’s terminating zero. For Unicode strings, the code would look like this:

```
mov rdi, <location to scan>   ; Set the location to begin scanning
mov rcx, -1                   ; Set the max unsigned value for the # of bytes to scan
xor ax, ax                    ; Wide strings use a 16-bit word as a terminator
repnz scasw                   ; Scan words, not bytes
not rcx                       ; Apply a logical NOT to the negative RCX count
dec rcx                       ; Adjust for overshot
```

`RCX` then holds the length of the string.  However, all good things come with a down side; if you forget to add the terminating 0 after a string (whether that string is wide or ANSI), the wrong size will be returned as the scan will continue until either `RCX` reaches 0 (that’s potentially a whole lot of bytes to scan), or the next 0 value is encountered somewhere in memory after the scan start position.  Still, in such a situation, forgetting the terminating 0 is not going to end well regardless of the approach used to sizing the string.

In my apps, I typically precede all strings with a size qword so that I can simply lodsq that size qword into `RAX`, leaving `RSI` pointing at the string start.  (All the lods? Instructions move data into `RAX`, `EAX`, `AX`, or `AL`.)  If a string is static and isn’t going to change (i.e. the window class name), there is no point in sizing it at all at runtime, let alone multiple times, when the correct size can be set during compile.

You won’t always want to use this approach.  If you have a limited size buffer and want to be sure you don’t scan beyond it, then you’ll have to set `RCX` to the buffer size.  However doing this will force you to calculate the string size by either subtracting the ending count in `RCX` from the starting count, or by subtracting the ending pointer (plus one) from the starting pointer after the scan.

## Call Me Right Back, K?

Regarding the window callback, a lookup table contains all the messages handled by the callback. This table always begins with a qword that holds the entry count. The offset into the table is then calculated, and the same offset into a corresponding router table holds the location of the code for handling that message.

```
mov                 rax, rdx                                ; Set the value to scan (incoming message)
lea                 rdi, message_table                      ; Point RSI @ the table start (entry count qword)
mov                 rcx, [ rdi ]                            ; Load the entry count
scasq                                                       ; Skip over the entry count qword
mov                 rsi, rdi                                ; Save pointer @ table start
repnz               scasq                                   ; Scan until match found or counter reaches 0
jnz                 call_default                            ; No match; use DefWindowProc
sub                 rdi, rsi                                ; Get the offset from the first entry of the table (not including entry count qword)
lea                 rax, message_router                     ; Point RAX at the base of the router table
call                qword ptr [ rax + rdi - 8 ]             ; Call the handler
```
For this app, only four messages will be initially handled: `WM_ERASEBKGND`, `WM_PAINT`, `WM_CLOSE`, and `WM_DESTROY`.

The handler for `WM_ERASEBKGND` does nothing but return `TRUE (1)` in `RAX`.  Returning `TRUE` for this message tells Windows that all handling for the message is complete and nothing more needs to be done.  (Relative to all Windows messages a callback might process, the value that your app must return is `FALSE (0)` far more often than not, but it’s never safe to assume – always check the documentation for each message handled; some require a very different and specific return value depending on how you handled the message.  This is especially true in dialog boxes, in particular with `NM_` notifications sent through `WM_NOTIFY`.) 

There are cases where an application engaging in complex drawing operations may want to know when the background is being erased, but even these odd men out may no longer exist.  The `WM_ERASEBKGND` message itself is an ancient artefact of a bygone era.  In the earliest days of Windows, just drawing a stock window with a frame could seriously tax the graphics adapter.  As such, a slew of tricks and compensations had to be employed to speed up the process when and where that could be done.  One of these innovations was the idea of identifying the exact portion of a window’s client area that actually needed to be redrawn.  This “update region” often does not include the entire client area, and any time a few CPU cycles could be saved, it was worth doing. 

So the concept of “update areas” or “update regions” (a region is a collection of rectangles) was created.  Within the client area, a region was declared as “invalid,” meaning it had to redrawn.  In modern times, the code required to process update regions is arguably slower and bulkier than simply redrawing the entire client area off screen then drawing it in one shot onto the window itself.  DirectX employs this “double buffering” technique extensively to avoid flicker, which comes from “erase then redraw” on-screen.  Still, even in Windows 10, the remnants of the old window painting system remain; the handler for the `WM_PAINT` message must explicitly “validate” the update area.  If it doesn’t, `WM_PAINT` messages will repeat forever, flowing into a window’s callback function fast and furious, dragging down the performance of the entire application.  This sample code’s `WM_PAINT` handler uses the Win32 `ValidateRect` function as its only task, since DirectX takes over all drawing in the window client area.  

## A Volatile Situation

Note that per MSDN, the following registers are considered nonvolatile – any function called will preserve their values across its entire execution:

`R12`, `R13`, `R14`, `R15`; `RDI`, `RSI`, `RBX`, `RBP`, `RSP` 

These must be saved then restored if they’re altered in the window callback (or any other) function.  For this application, all of the nonvolatile registers are saved regardless of the message being handled - saving is done before the incoming message is even looked at.  You may or may not want to alter this behavior in your own application’s internal functions, but when you call any Windows function, you have to be aware that the contents of volatile registers can never be relied on to persist across the call.  One function or another may indeed leave a volatile register unchanged on its return, but specs are specs and that behavior could easily change at any time, especially given the any-time-is-a-good-time update policy for Windows 10.

The complete function for the window callback is shown below, noting that the assembler will handle saving and restoring `RBP` and `RSP` for each function declared:

```
mainCallback       proc                                                        ;

                   local               holder:qword, hwnd:qword, message:qword, wParam:qword, lParam:qword

                   ; Save nonvolatile registers

                   push                rbx                                     ;
                   push                rsi                                     ;
                   push                rdi                                     ;
                   push                r12                                     ;
                   push                r13                                     ;
                   push                r14                                     ;
                   push                r15                                     ;

                   ; Save the incoming parameters

                   mov                 hwnd, rcx                               ;
                   mov                 message, rdx                            ;
                   mov                 wParam, r8                              ;
                   mov                 lParam, r9                              ;

                   ; Look up the incoming message

                   mov                 rax, rdx                                ; Set the value to scan (incoming message)
                   lea                 rdi, message_table                      ; Point RSI @ the table start (entry count qword)
                   mov                 rcx, [ rdi ]                            ; Load the entry count
                   scasq                                                       ; Skip over the entry count qword
                   mov                 rsi, rdi                                ; Save pointer @ table start
                   repnz               scasq                                   ; Scan until match found or counter reaches 0
                   jnz                 call_default                            ; No match; use DefWindowProc
                   sub                 rdi, rsi                                ; Get the offset from the first entry of the table (not including entry count qword)
                   lea                 rax, message_router                     ; Point RAX at the base of the router table
                   call                qword ptr [ rax + rdi - 8 ]             ; Call the handler
                   jmp                 callback_done                           ; Skip default handler

call_default:                                                                  ; The only changed register holding incoming parameters is RCX so only reset that
                   mov                 rcx, hWnd                               ; Set hWnd
                   WinCall             DefWindowProc, 4, rcx, rdx, r8, r9      ; Call the default handler

callback_done:     pop                 r15                                     ;
                   pop                 r14                                     ;
                   pop                 r13                                     ;
                   pop                 r12                                     ;
                   pop                 rdi                                     ;
                   pop                 rsi                                     ;
                   pop                 rbx                                     ;

                   ret                                                         ; Return to caller

mainCallback       ends                                                        ; End procedure declaration
```

When popping registers, they must be popped in the exact reverse order from how they were saved (pushed).  Intel architecture uses a LIFO stack model – last in, first out.  Each push instruction (assuming a `qword` is pushed) stores that `qword` in memory at the location pointed to by RSP; RSP is then backed up (moves toward 0) by 8 bytes.  The “lowest” address on the stack is the “top” of the stack.  Entry into this callback will place items on the stack in the order they’re pushed – the lowest (closest to 0) address holds `R15`; the highest holds RBX (referencing the code above). 

One of the most common bugs in an assembly language application is forgetting to pop an item that was pushed onto the stack.  You’re not in Kansas anymore, Toto, so you have to do these things manually.  Extra power carries extra responsibility.  When this occurs, the return from the function (the ret instruction) will itself pop the `qword` off the top of the stack and jump to whatever address it holds.  So inadvertently leaving even one `qword` on the stack will completely demolish the return from the function and typically send the app careening down to Mother Earth in flames.   

The code above represents the entirety of the callback function (minus the individual message handlers) for the main window.  Each handler can be thought of as a “subroutine” in the original BASIC language, for those who can remember that far back.  The handler code for each message is actually part of the `mainCallback` function – it lives inside the function itself.  Since all the handlers are coded after the ret instruction, they will never execute unless explicitly called.

Within the handlers, the only oddity is the use of the ret instruction to return from the handler into the main code of the function.  From the assembler’s viewpoint, you can’t do this.  The assembler sees ret and it assumes you’re returning from the function itself.  As such, it will insert code that attempts to restore `RBP` and `RSP`, doing so at a location where you most definitely don’t want that happening.  This is where I employ a semi-unorthodox method: I directly encode the ret statement as:

```
byte     0C3h     ; Return to caller
```

Alternatively, you could use a textequ statement to change that to something more palatable, like:

```
HandlerReturn     textequ     <byte 0C3h> ;
```

Text equates evaporate beyond the source code level; the assembler will simply replace all occurrences of `HandlerReturn` with `byte 0C3h`.  You just won’t have to look at it in your source code.

At the CPU level, the call instruction doesn’t do anything with `RBP` or `RSP` directly.  The instruction itself  simply `push`es the address of the next instruction after call, then jumps to wherever you’re calling. Correspondingly, `ret` doesn’t do anything except `pop` whatever value is waiting at the top of the stack and jump to that value, as an address.  (The code to restore `RBP`, reset `RSP` \[from its setup for local variable usage], and return is generated by the assembler.)  The CPU has no concept of what a function is; the assembler gives all of that meaning completely separately from the CPU.  So hard-coding 0C3h as the `ret` statement prevents the compiler from trying to helpfully crash your program by resetting `RBP` and `RSP` in preparation for a return from the function.  “But wait, I’m still on the potty!”  Encoding the byte directly in the code stream is just another benefit of the flexibility afforded by the very direct assembly language data model (which is “no model at all”).

If you don’t like this method, you’ll have to encode a separate function for each message you actually process.  Then you can simply call as required, but you’ll have to reload the parameters coming into the `mainCallback` function before doing so (to the extent that each handler needs the information).  This, however, carries the extra overhead of setting up and tearing down a function (saving registers, etc.) as well as placing `mainCallback`'s incoming parameters back into the required registers for passing to each message handling function.  It all adds up to a lot of extra overhead just for the sake of ritual. It's hardly worth it.  Avoiding this extra overhead is the reason for using “in-function handlers” for message processing.  Each handler has direct access to the `mainCallback` local variables (which hold the incoming parameters) because, from the compiler's viewpoint, each handler is still part of `mainCallback`.

Accessing local variables – in particular, the incoming parameters to `mainCallback` – is no problem at all.  Within each handler, you’re still in the “space” of the `mainCallback` function, therefore all its local variables are fully intact and accessible.

The lookup table message_table is shown below:

```
message_table            qword       (message_table_end – message_table_start ) / 8
message_table_start      qword       WM_ERASEBKGND
                         qword       WM_PAINT
                         qword       WM_CLOSE
                         qword       WM_DESTROY
message_table_end        label       byte ; Any size declaration will work; byte is used as the smallest choice
```
The router list for the callback function is:

```
message_router     qword     main_wm_erasebkgnd
                   qword     main_wm_paint
                   qword     main_wm_close
                   qword     main_wm_destroy
```

The `WM_ERASEBKGND` handler is shown below:

```
align               qword                                   ;
main_wm_erasebkgnd label               near                                    ;

                   mov                 rax, 1                                  ; Set TRUE return
                   byte                0C3h                                    ; Return to caller
```

`WM_PAINT`: with DirectX handling all of the drawing for the main client area, the only thing the `WM_PAINT` handler needs to do is to validate the invalid client area. 

First, ensure the ValidateRect function is declared in the externals.asm file:

```
extrn            _imp__ValidateRect:qword
ValidateRect     textequ     <_imp__ValidateRect>
```

The `WM_PAINT` handler consists of a single call to `ValidateRect`:
```
align               qword                                   ;
main_wm_paint      label               near                                    ;

                   xor                 rdx, rdx                                ; Zero LPRC for entire update area
                   mov                 rcx, hwnd                               ; Set window handle
                   WinCall             ValidateRect, 2, rcx, rdx               ; Validate the invalid area

                   xor                 rax, rax                                ; Set FALSE return
                   byte                0C3h                                    ; Return to caller
```

Failure to validate the update area will cause a torrent of `WM_PAINT` messages to flow into the window’s callback function; Windows will continue sending them forever, thinking there’s an update area still needing to be redrawn.

The `WM_CLOSE` handler destroys the window.  The DestroyWindow function needs to be declared in the externals.asm file, or wherever you’re keeping your externals:

```
extrn             __imp_DestroyWindow:qword
DestroyWindow     textequ     <__imp_DestroyWindow>
```

The `WM_CLOSE` handler follows:
```
align               qword                                   ;
main_wm_close      label               near                                    ;

                   mov                 rcx, hwnd                               ; Set the window handle
                   WinCall             DestroyWindow, 1, rcx                   ; Destroy the main window

                   ; Here it's assumed that the call succeeded.  If it failed,
                   ; RAX will be 0 and GetLastError will need a call to figure
                   ; out what's blocking the window from being destroyed.

                   xor                 rax, rax                                ; DestroyWindow leaves RAX at TRUE if it succeeds so it needs to be zeroed here
                   byte                0C3h                                    ; Return to caller
```

The handler for `WM_DESTROY` is a notification, sent after the window has been removed from the screen.  This is where the DirectX closeouts occur.  The local `ShutdownDirectX` function will be covered in Part IV, which discusses DirectX initialization and shutdown:

```
align               qword                                   ;
main_wm_destroy    label               near                                    ;

                 ; The DirectX shutdown function is commented out below; it
                 ; has not been covered yet as of part III of the series.  It
                 ; will be uncommented and coded in the source for part IV.

                 ; call                ShutdownDirectX                         ; Calling a local function does not require the WinCall macro

                   xor                 rax, rax                                ; Return 0 from this message
                   byte                0C3h                                    ; Return to caller
```

The callback function is closed out with a single line:

```
main_callback endp
```

The only task remaining, to make the code presented so far a complete application, is the actual startup code.  `WinMain` is not used, so the startup code moves directly into creating the main window, then enters the message loop.  The entire block of entry code is shown below:

```
;*******************************************************************************
;
; DEMO - Stage 1 of DirectX assembly app: create main window
;
; Chris Malcheski 07/10/2017

                   include             constants.asm                           ;
                   include             externals.asm                           ;
                   include             macros.asm                              ;
                   include             structuredefs.asm                       ;
                   include             wincons.asm                             ;

                   .data                                                       ;

                   include             lookups.asm                             ;
                   include             riid.asm                                ;
                   include             routers.asm                             ;
                   include             strings.asm                             ;
                   include             structures.asm                          ;
                   include             variables.asm                           ;

                   .code                                                       ;

Startup            proc                                                        ; Declare the startup function; this is declared as /entry in the linker command line

                   local               holder:qword                            ; Required for the WinCall macro

                   xor                 rcx, rcx                                ; The first parameter (NULL) always goes into RCX
                   WinCall             GetModuleHandle, 1, rcx                 ; 1 parameter is passed to this function
                   mov                 hInstance, rax                          ; RAX always holds the return value when calling Win32 functions

                   WinCall             GetCommandLine, 0                       ; No parameters on this call
                   mov                 r8, rax                                 ; Save the command line string pointer

                   lea                 rcx, startup_info                       ; Set lpStartupInfo
                   WinCall             GetStartupInfo, 1, rcx                  ; Get the startup info
                   xor                 r9, r9                                  ; Zero all bits of RAX
                   mov                 r9w, startup_info.wShowWindow           ; Get the incoming nCmdShow
                   xor                 rdx, rdx                                ; Zero RDX for hPrevInst
                   mov                 rcx, hInstance                          ; Set hInstance

; RCX, RDX, R8, and R9 are now set exactly as they would be on entry to the WinMain function.  WinMain is not
; used, so the code after this point proceeds exactly as it would inside WinMain.

; Load the cursor image

                   xor                 r11, r11                                ; Set cyDesired; uses default if zero: XOR R11 with itself zeroes the register
                   xor                 r9, r9                                  ; Set cxDesired; uses default if zero: XOR R9 with itself zeroes the register
                   mov                 r8, image_cursor                        ; Set uType
                   mov                 rdx, ocr_normal                         ; Set lpszName
                   xor                 rcx, rcx                                ; Set hInstance
                   WinCall         LoadImage, 6, rcx, rdx, r8, r9, r11, lr_cur ; Load the standard cursor
                   mov                 wcl.hCursor, rax                        ; Set wcl.hCursor

; Load the large icon

                   mov                 r11, 32                                 ; Set cyDesited
                   mov                 r9, 32                                  ; Set cxDesired
                   mov                 r8, image_icon                          ; Set uType
                   lea                 rdx, LargeIconResource                  ; Set lpszName
                   mov                 rcx, hInstance                          ; Set hInstance
                   WinCall         LoadImage, 6, rcx, rdx, r8, r9, r11, lr_cur ; Load the large icon
                   mov                 wcl.hIcon, rax                          ; Set wcl.hIcon

; Load the small icon

                   mov                 r11, 32                                 ; Set cyDesited
                   mov                 r9, 32                                  ; Set cxDesired
                   mov                 r8, image_icon                          ; Set uType
                   lea                 rdx, SmallIconResource                  ; Set lpszName
                   mov                 rcx, hInstance                          ; Set hInstance
                   WinCall         LoadImage, 6, rcx, rdx, r8, r9, r11, lr_cur ; Load the large icon
                   mov                 wcl.hIconSm, rax                        ; Set wcl.hIcon

; Register the window class

                   lea                 rcx, wcl                                ; Set lpWndClass
                   winCall             RegisterClassEx, 1, rcx                 ; Register the window class

; Create the main window

                   xor                 r15, r15                                ; Set hWndParent
                   mov                 r14, 450                                ; Set nHeight
                   mov                 r13, 800                                ; Set nWidth
                   mov                 r12, 100                                ; Set y
                   mov                 r11, 100                                ; Set x
                   mov                 r9, mw_style                            ; Set dwStyle
                   lea                 r8, mainName                            ; Set lpWindowName
                   lea                 rdx, mainClass                          ; Set lpClassName
                   xor                 rcx, rcx                                ; Set dwExStyle
                   WinCall             CreateWindowEx, 12, rcx, rdx, r8, r9, r11, r12, r13, r14, r15, 0, hInstance, 0
                   mov                 main_handle, rax                        ; Save the main window handle

; Ensure main window displayed and updated

                   mov                 rdx, sw_show                            ; Set nCmdShow
                   mov                 rcx, rax                                ; Set hWnd
                   WinCall             ShowWindow, 2, rcx, rdx                 ; Display the window

                   mov                 rcx, main_handle                        ; Set hWnd
                   WinCall             UpdateWindow, 1, rcx                    ; Ensure window updated

; Execute the message loop

wait_msg:          xor                 r9, r9                                  ; Set wMsgFilterMax
                   xor                 r8, r8                                  ; Set wMsgFilterMin
                   xor                 rdx, rdx                                ; Set hWnd
                   lea                 rcx, mmsg                               ; Set lpMessage
                   WinCall             PeekMessage, 4, rcx, rdx, r8, r9, pm_remove

                   test                rax, rax                                ; Anything waiting?
                   jnz                 proc_msg                                ; Yes -- process the message

                 ; call                RenderScene                             ; <--- Placeholder; will uncomment and implement in Part IV article

proc_msg:          lea                 rcx, mmsg                               ; Set lpMessage
                   WinCall             TranslateMessage, 1, rcx                ; Translate the message

                   lea                 rcx, mmsg                               ; Set lpMessage
                   WinCall             DispatchMessage, 1, rcx                 ; Dispatch the message

                   jmp                 wait_msg                                ; Reloop for next message

breakout:          xor                 rax, rax                                ; Zero final return – or use the return from WinMain

                   ret                                                         ; Return to caller

Startup            endp                                                        ; End of startup procedure

                   include             callbacks.asm                           ;

                   end                                                         ; Declare end of module
```

As a skeleton program, the demo application is now complete.  

As stated in the README.TXT file (in the accompanying .ZIP file), many improvements will be made to the source code for this specific article, so don't spend too much time modifying this code.  Not yet.  This code was intended to relate concepts and act as a tutorial; as such, its focus was not on efficiency.  This will change in Part IV, which will cover initializing DirectX.  

In addition, several handlers will be added to the callback function, to create a custom window frame.  

Note that DirectX goes absolutely bonkers with constant declarations and nested structures.  (DirectX 11 is used, because DirectX 12 only runs on Windows 10.)  Because of the sheer volume of typing to move those declarations and definitions over to assembly, they will no longer be detailed in subsequent articles after this one.  It's presumed that by now, you get the point and understand the basics of declaring structures, constants, etc. in assembly - with the exception of nesting structures, which will be covered in the next article.

An assembly language app is much like screen printing: MOST of the time involved is in the initial setup - getting your externals declared, your structures defined, etc.  All of this is one-time work and can be used for an infinite number of applications without having to be repeated.  As this series continues, the accompanying source code will do much of that work for you.  Feel free to copy and paste the nasty declarations and definitions as desired so you don't have to research and type them all manually.

The pace will pick up in Part IV, where DirectX will be initialized, shut down when the main window is destroyed, and the message loop will only render a blank scene with no vertices.

# Part IV a

## Overview

This article will clean up the inefficiencies of previous articles in this series. The Part IV application (which will be attached, for download, to the next installment, Part IV(b)) will initialize DirectX, implement the app’s message loop, and render a blank scene to the screen. It’s presented in parts, because there’s a lot to cover. As with anything, the more you work with it, the more it becomes second nature. The most difficulty lies in making the initial switch from high level language thinking to mentally working in the arena of assembly language.

## First Things First: Calling Out

The first order of business is to clean up the outrageously inefficient `WinCall` macro presented in the first 3 articles of this series. With (hopefully) sufficient groundwork laid for achieving a basic understanding of the assembly language/Windows universe, the new and improved `WinCall` macro can now be presented:

```
WinCall       macro               call_dest:req, parms:vararg ;

              local               jump_1, lpointer, numArgs   ;

              numArgs             = 0                         ;

              for                 parm, <parms>               ;
                numArgs           = numArgs + 1               ;
              endm                                            ;

              if numArgs lt 4                                 ;
                numArgs = 4                                   ;
              endif                                           ;

              mov                 holder, rsp                 ;
              sub                 rsp, numArgs * 8            ;
              and                 rsp, 0FFFFFFFFFFFFFFF0h     ;

              lPointer            = 0                         ;
              for                 parm, <parms>               ;
                if                lPointer gt 24              ;
                  mov             rax, parm                   ;
                  mov             [ rsp + lPointer ], rax     ;
                elseif            lPointer eq 0               ;
                  mov             rcx, fname                  ;
                elseif            lPointer eq 8               ;
                  mov             rdx, fname                  ;
                elseif            lPointer eq 16              ;
                  mov             r8, fname                   ;
                elseif            lPointer eq 24              ;
                  mov             r9, fname                   ;
                endif                                         ;
                lPointer          = lPointer + 8              ;
              endm                                            ;

              call                call_dest                   ;

              mov                 rsp, holder                 ;

              endm                                            ;
```

Remember that the `holder` `qword` variable is a local variable that must be declared in every function using the `WinCall` macro. The compile will fail if this is not done.

The modified `WinCall` macro is far more efficient than its for-education-only predecessor. There’s no longer any requirement to pass a parameter count, and most of the work is done during compile, not at runtime.

The macro assembler includes an operator to return the number of parameters passed to the macro, but at least in the `ML64.EXE` build I was using, it didn’t want to cooperate. So the count had to be calculated in a manual loop, but that work is still done at compile time.

In the first line of the macro, `:req` means “required.” The parameter must be passed – it’s the target function to call. The parameter `parms` is a variable argument count (`:vararg`) and passing zero parameters is just as acceptable as passing a thousand: whatever the function requires. (If the function you're calling actually requires a thousand parameters, check the documentation as something may be off in your understanding of it.)

Let the macro place the values into the required registers, as well as onto the stack. `RAX` will be loaded with each passed parameter; if required, the contents of `RAX` will then be placed into the appropriate location on the stack. So passing the macro, as a parameter, any reference that will legally load into a general-purpose register is acceptable. You can use variables, offsets, or anything else that can be placed directly into a register. The function calls in the Part IV sample code will demonstrate the full range of what is legal.

Since `RSP` is decreasing for the call to the target function, clearing the low 4 bits ensures it’s 16-byte aligned – this is a requirement for placing float values, accessed by `XMM` registers, onto the stack. And there will be plenty of that in the course of the sample app. `RSP` is reset after the target function returns, so how much `RSP` is adjusted (within reason) is effectively irrelevant. If the low four bits of `RSP` are already clear, they’re unchanged. Otherwise, they’re cleared. So any kind of testing for those bits being set is a waste of time and there’s no reason to do it.

## DirectX Structures

If every DirectX structure used by the sample code were listed in this article, you’d have a jillion pages to wade through. The structures used by the attached source code are all defined within that source code – in the file `structuredefs.asm`.

As mentioned previously, DirectX loves to nest structures, and it’s not shy about doing it. When it comes to data structures, the main difference between assembly and other languages is that unnamed, nested unions and structures are not allowed. Everything needs a name. Here and there, this will impact reference to deeply-nested structure fields so it must be kept in mind.

## Prepackaging Values

The concept has been covered before, but it’s being reiterated here: especially with performance-intensive DirectX apps, assigning constants or otherwise known values at runtime is a big no-no. It may make the code look pretty in other languages, but in assembly language, it’s exceedingly simple to initialize structure fields to their startup values as hardcoded data within their declarations. Assigning the values any other way, at run time, is going to require the value to be present within the source code bytes anyway, in addition to all the bytes of code needed to move it around. Worse, the destination for those moves – the structure fields themselves, within memory – are already sitting as reserved space, where storing 0 is no different from storing the initial value required.

The general rule of thumb is that if a field’s value cannot be determined until the app executes, then it must be assigned at runtime. Otherwise, preset the values. This will be demonstrated in part IV(b).

## Assembly Language and COM

DirectX is COM (Component Object Model) based. The basic operation of COM has a table of pointers to functions called methods; the table is called a `virtual method table` or `vTable`. An interface pointer points to another pointer which points to the vTable, as shown in the image below:

\[The referenced image displays fine in the CodeProject editor, however in preview mode, it displays as a broken link, and when the final article is viewed, you don't even get that - it's just blank space. Nobody knows why. So the URL for the image is http://www.starjourneygames.com/com_vtable.jpg.]

## The Almighty RIID

The riid parameter is used often in COM dealings. Riid is short for `reference interface identifier`; it’s essentially an alias for `universally unique identifier`, or `UUID`, or `Globally Unique Identifier`, or `GUID`.

Riid: every COM interface has one. It’s the value that uniquely identifies the interface as a whole unit. When you’re using any COM subsystem in assembly language, you have to track down the exact value for that interface’s riid. Sometimes they’re found by globally searching all the header files in the Windows SDK Include directory for `IID_<interface name>`. Sometimes they’re declared externally, and you have to actually use the value in Visual Studio to find out what it is. Sometimes you can find the needed value online. Whatever the case, when the riid value is needed, it has to be found somewhere, then declared in your data segment.

From the viewpoint of the CPU, riid’s are stored as a byte string. For whatever conformity can be had in declaring them as data, the format I typically use is dword, word, word, then 8 bytes. In the MSDN header files, riid’s are most often listed in this format:

```
db6f6ddb-ac77-4e88-8253-819df9bbf140
```

Converting this to the required assembly language declaration, the following results:

```
IID_ID3D11Device     	dword      0DB6F6DDBh
			            word       0AC77h
			            word       04E88h
			            byte       082h
			            byte       053h
			            byte       081h
			            byte       09Dh
			            byte       0F9h
			            byte       0BBh
			            byte       0F1h
			            byte       040h
```

Every now and then, DirectX header files will randomly store an riid in the following format:

0xDB, 0x6D, 0x6F, 0xDB, 0x77, 0xAC, 0x88, 0x4E, 0x82, 0x53, 0x81, 0x9D, 0xF9, 0xBB, 0xF1, 0x40

When this is the case, adjustments must be made for Intel’s little-endian memory format – unless you’re going to declare the entire riid as a string of bytes, in which case you can use the data you're working from as-is. If you’re going to use the `dword`/`word`/`word`/`bytes` format, then the first four bytes must be reversed to declare them as a `dword`:

```
0xDB, 0x6D, 0x6F, 0xDB is declared as a dword of value 0DB6F6DDBh.
```
The next two words must be reversed, with 0x77, 0xAC and 0x88, 0x4E being declared as:

```
word            0AC77h
word            04E88h
```
Riid values comprise one of those cases where you just can’t escape the pain of using them in assembly language apps. My personal policy is that once I look up an riid value, I keep it – completely formatted as a data declaration – in a special file devoted only to holding riid values. That way I have to look up each value I use once and only once.

The riid values used in the attached source code are all defined within those source files.

## Calling Methods

Text equates, or textequ declarations, are the closest you can come to the “native” format for referencing COM methods in assembly. You can’t use the double colon (::) with text equates; I use an underscore instead. The important thing is that the methods can be called by name this way.

Each method is pointed to by a given location within its interface’s vTable. In 64-bit Windows, each entry in the vTable is, of course, 8 bytes long, holding a 64-bit pointer to the method code.

Building the list of text equates is another (and the final) piece of potentially hard work in setting up to use COM from assembly language. For example, the `IUnknown` interface, which begins nearly every COM vTable, is defined as follows:

```
vTable [ 0 ] ->  IUnknown::QueryInterface
vTable [ 8 ] ->  IUnknown::AddRef
vTable [ 16 ] -> IUnknown::Release
```
In the attached source code, `IUnknown` would be defined as:
```
IUnknown_QueryInterface           textequ     <qword ptr [rbx]>
IUnknown_AddRef                   textequ     <qword ptr [rbx+8]>
IUnknown_Release                  textequ     <qword ptr [rbx+16]>
```
Remembering always that the RBX register holds the vTable pointer, a sample call to the COM method `IUnknown::QueryInterface` would look like the following:

```
lea     r8,  INewInterface
lea     rdx, IID_INewInterface
mov     rcx, IUnknown
mov     rbx, [rcx]
WinCall IUnknown_QueryInterface, rcx, rdx, r8
```
In the above sample, `INewInterface` is an imaginary interface pointer. `QueryInterface` will set it with a pointer to the requested interface, specified by `IID_INewInterface`. **For every COM method called, RCX must hold the interface pointer**. This is not explicitly documented anywhere, since all other languages utilizing COM are designed to have the compiler insert that code and never require the developer to worry about it. In assembly language, it’s not the case: **RCX must hold the interface pointer**. `RCX`, as the interface pointer, points to a pointer to the vTable. In the above sample, RBX is loaded with the pointer to the vTable. Subsequently, the text equate for  `IUnknown_QueryInterface` is <qword ptr [rbx]>, so the first method in the vTable will be called.

If you’re working with COM in assembly language, it won’t take long before all this becomes second nature. In the attached source code, RCX (as it must) always holds the interface pointer, and RBX is used app-wide to point to the vTable for all methods being called.

If you need to build your own list of text equates, **you must do so in vTable order**. Within its online documentation, MSDN (almost) always lists methods for an interface in alphabetical order. This makes it much easier to find the documentation on a given method, but for the purposes of building text equates to represent access to a vTable, it must be remembered that the methods in the actual vTable will almost never be alphabetical. Once again, the header files must be consulted for the proper vTable order. Intellisense, within Visual Studio, will list the methods alphabetically as well. That won’t work either for building your text equates.

Typically, within the header files, searching for `IID_<interface name>` within the file will land you on something like the following:
```
EXTERN_C const IID IID_ID3D11Device;

#if defined(__cplusplus) && !defined(CINTERFACE)
    MIDL_INTERFACE("db6f6ddb-ac77-4e88-8253-819df9bbf140")
    ID3D11Device : public IUnknown
    {
    public:
        virtual HRESULT STDMETHODCALLTYPE CreateBuffer(
. . .
```
Following this will be the entire vTable – or the extension of it. In this case, note the line

```
ID3D11Device : public IUnknown
```

This means that the entire `IUnknown` interface begins the vTable. Following these declarations can easily send you into a very long search, looking for interface A which is begun with interface B, etc. Many interfaces, for example, begin with IDispatch, which in turn begins with IUnknown.

To avoid this kind of searching, when you find content like what’s shown above, move down to the end of the vTable declarations. There you’ll nearly always find the “C-Style Interface” declarations, which forego all the nesting and simply declare every method in the interface. This is what I build my lists off of.

```
#else      /* C style interface */

    typedef struct ID3D11DeviceVtbl
    {
        BEGIN_INTERFACE
        HRESULT ( STDMETHODCALLTYPE *QueryInterface )(
. . .
```
## COM: Class Dismissed

Overall, COM is a behemoth. What’s been discussed in this article is only the basic information required to get DirectX up and running. As with everything Microsoft does, other COM interfaces may change the rules, bend the rules, or break the rules. So what works for DirectX is not universal, if you end up delving into other arenas such as `IWebBrowser`. In all my work with DirectX, I have not seen any such violations; the use of COM has been 100% consistent with the information presented in this article.

For as far as this series of articles goes, you won’t need to do any of this research to build the required data, declarations, and structures. It’ll all be present in the attached source code.

Next…

The next installment, Part IV(b), dives straight into initializing DirectX – starting with the `D3DCreateDeviceAndSwapChain` function call.

# Part IV b

## Overview

Several thousand years after posting part IV(a), I finally got up the motivation to create the full DirectX app – small though it may be from a functional standpoint (it spins a triangle).  The main issue for me is that creating the source code for this sample required manual retyping of every single byte of source code involved.  Since this required well over 40 hours of work, motivational resources were limited. 

Most of what’s in my own personal apps is custom formatted for a specific editor I use and will not properly display in any other editor.  (I’m not going to name the editor I use because I found the company/people publishing it to be evil and obnoxious and I don’t care to give them any free publicity.)  Further, if I’m going to publish a full app, I’m going to do it right – which includes going through every byte of source code and making sure everything is accurate.  Moving to all assembly for a DirectX app is a huge step and there is effectively zero support in the world for doing it.  The last thing readers need is hastily scribbled-out source that creates more problems than it solves.  ASM is a taboo subject for most, and a lot of disinformation has to be dispelled to even begin down that path.  The material leading developers there has to be of the best possible quality.

## Compiling the App

Create a new directory for the project and unzip the project’s .zip file there.  There will be two subdirectories: `Triangle`, and `DXSampleMath`.  The latter is covered later in this article, under "The Dreaded Math Library" header.

The file `go.bat` in the `Triangle` subdirectory is provided for compiling the project.  It references ml64.exe and link.exe as residing in their default VS17 C++ directories.  If these are different on your system, you must change the string assignments at the top of the batch file. 

The unaltered contents of `go.bat` are shown below.  Note that opening quotes without closing quotes are used by design.
```
@echo off

rem Set this value to the location of rc.exe under the VC directory
set rc_directory="C:\Program Files (x86)\Windows Kits\10\bin\x86

rem Set this value to the location of ml64.exe under the VC directory
set ml_directory="C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\x86_amd64

rem Set this value to the location of link.exe under the VC directory
set link_directory="C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin

%rc_directory%\rc.exe" resource.rc
%ml_directory%\ml64.exe" /c /Cp /Cx /Fm /FR /W2 /Zd /Zf /Zi /Ta DXSample.xasm > errors.txt
%link_directory%\link.exe" DXSample.obj resource.res /debug:none /opt:ref /opt:noicf /largeaddressaware:no /def:DXSample.def /entry:Startup /machine:x64 /map /out:DXSample.exe /PDB:DXSample.pdb /subsystem:windows,6.0 "C:\Program Files (x86)\Windows Kits\10\Lib\10.0.10586.0\um\x64\kernel32.lib" "C:\Program Files (x86)\Windows Kits\10\Lib\10.0.10586.0\um\x64\user32.lib" "C:\Program Files (x86)\Microsoft DirectX SDK (August 2009)\Lib\x64\d3d11.lib" "C:\Program Files (x86)\Microsoft DirectX SDK (August 2009)\Lib\x64\d3dx11.lib" DXSampleMath.lib
type errors.txt
```
## A Minor Repair

If you don’t use WinDbg for debugging, you can comment out the first call of the `DXSample.asm` file; the call to `FixWinDbg`.  I use this call in every app I write to counter a decade-plus old bug in `WinDbg`, where every time it’s executed, the window layouts shift with each window shrinking every edge by a few pixels.  Windows become smaller and smaller with each new execution until they’re eventually at minimum size.  The `FixWinDbg` function resets the window positions and sizes within `WinDbg` to counter this failure.  Microsoft has been contacted about the issue multiple times.  They have elected not to address it, so developers must if they want it fixed.

**Note: that the** `win_ids` **string in the** `strings.asm` **file is hard coded for** `WinDbg` **version 10.0.17134.12**.  If you want to use `FixWinDbg` and you’re running any other version of it, you must change the version number in this string to match the WinDbg version you’re running.  If this isn’t done, the WinDbg windows won’t be properly identified.

If you’re not modifying the app, you won’t need a debugger unless you want to trace through the code’s execution.

## The App Entry Point

`WinMain` isn't really an app’s entry point.  The actual entry point is declared in the linker command line and can be anything.  This app uses `Startup` as the main function; it serves as the app’s entry point. `Startup` could set up the parameters for, and call, `WinMain` if it were desired to create one, but there is no perceptible benefit for doing so.  The app would only end up calling the required WinAPI functions to retrieve the information that would have been passed as parameters to WinMain.

## Defining and Declaring Structures

The file `structuredefs.asm` holds the definitions for all data structures used by the app.  Structures can be nested, but any structure must be defined before it’s referenced, even within another structure.  Within the `structuredefs.asm` file, data structures are generally defined alphabetically, however when a structure such as `DXGI_SAMPLE_DESC` is referenced by another such as `D3D11_TEXTURE2D_DESC`, the `DXGI_SAMPLE_DESC` structure must be defined before being referenced.  Therefore its definition appears in the file above the definition for `D3D11_TEXTURE2D_DESC`. 

There are several options for declaring an initialized data structure.  The first is probably the most commonly used, but isn’t my favorite because it appears messy and it’s difficult to immediately associate a value with a given field.  **Note that the only case sensitive values in the entire app are in the external definitions file.  External functions must be declared using exactly the case used to export them from their resident libraries**.  The first method for declaring a structure is shown below:

```
sampleDesc   dxgi_sample_desc   <1, 0>
```
The method employed by the app is shown below:
```
swapChainDesc    label   dxgi_swap_chain_desc                   ; Declare structure label
                ;------------------------------------------------
                 dword   ?                                      ; dxgi_swap_chain_desc.BufferDesc._Width
                 dword   ?                                      ; dxgi_swap_chain_desc.BufferDesc._Height
                 dword   60                                     ; dxgi_swap_chain_desc.BufferDesc.RefreshRate.numerator
                 dword   1                                      ; dxgi_swap_chain_desc.BufferDesc.RefreshRate.denominator
                 dword   DXGI_FORMAT_R8G8B8A8_UNORM             ; dxgi_swap_chain_desc.BufferDesc.Format
                 dword   DXGI_MODE_SCANLINE_ORDER_UNSPECIFIED   ; dxgi_swap_chain_desc.BufferDesc.ScanlineOrdering
                 dword   DXGI_MODE_SCALING_UNSPECIFIED          ; dxgi_swap_chain_desc.BufferDesc.Scaling
                 dword   1                                      ; dxgi_swap_chain_desc.SampleDesc.Count
                 dword   0                                      ; dxgi_swap_chain_desc.SampleDesc.Quality
                 dword   DXGI_USAGE_RENDER_TARGET_OUTPUT        ; dxgi_swap_chain_desc.BufferUsage
                 qword   1                                      ; dxgi_swap_chain_desc.BufferCount
                 qword   ?                                      ; dxgi_swap_chain_desc.OutputWindow
                 dword   1                                      ; dxgi_swap_chain_desc.Windowed
                 dword   DXGI_SWAP_EFFECT_DISCARD               ; dxgi_swap_chain_desc.SwapEffect
                 qword   0                                      ; dxgi_swap_chain_desc.Flags
```
This method allows easy reference of per-field values in the source code.  The compiled output is unchanged between either of the methods.

## Checkpoint

By now, it should be becoming apparent that assembly offers a lot of flexibility for cleaning up source code and easily locating whatever needs to be found.  The lack of management overhead within the source code alone is extreme when compared with C++, and the developer is able to enjoy a much more direct, hands-on level of control over the compiled output.  Further, the lack of any typecasting, in my view, is the greatest benefit of all.  Any time you try to save the developer from his or her own ineptitude, a language rapidly becomes a monstrous juggernaut of micromanagement.  The “save the developer from idiocy” approach makes it extremely difficult to find the code that actually does useful work, which, in this day and age, is deep in the minority anyway.  There is so much explicit instruction to give to the compiler, via menus as well as source statements, that one might as well simply write the app in assembly and save a whole lot of time.

Better still, data is simply data.  There are no presumptions made about what you’re going to do with it, which eliminates typecasting completely. For example, if you wanted to flip the sign of a floating point value, there’s no need to load that value into a register, apply some SSE instruction, and write it back to memory.  Instead, you can simply toggle bit 7 (with xor byte ptr [location], 80h) of whatever byte holds the most significant bit of the floating point value. 

Say goodbye to the sloppy double underscores, double asterisks, double colons, etc. that make source code look like an explosion in a spaghetti factory.

## The Switch from Switch

In the file callbacks.asm, there is a notable lack of any switch statements (none exists in ASM).  Instead, an infinitely more direct and sensible method is applied for routing the processing of incoming Windows messages: index the incoming message on a lookup table, and jump to the same index on a router table.  The CPU provides the repnz scasq instruction which makes such lookups extremely fast compared to brute-force value-by-value comparisons.  A value placed in the RAX register is repeatedly scanned against RCX qwords at location RDI.  When a match is found, the scan stops. 

Memory locations are frequently used directly as jump targets, the same as the contents of a register can serve that purpose.  In the attached source, the lookup table Main_CB_Lookup (in the file lookups.asm) is paired with Main_CB_Rte (in the file routers.asm).   Entry 0 on the lookup table is processed at the location pointed to by entry 0 on the router table. 

## Returning from a Call

The Main_CB function – the callback function for the main window – contains a workaround for what amounts to the only real issue to be found in ASM: the RET or return statement.  It’s the only location where the compiler becomes “helpful” and takes over what it thinks you mean when it encounters a RET statement: it wants to reset RBP and destroy the stack frame created when the function was entered.  In this app, handlers are used within the framework of the function.  One handler per message is employed.  These are called as a function would be, so they must be returned from.  However the return from these handlers should simply POP the return address off the stack and jump there.  Because of the automatic handling of framing out a function in ASM, every RET statement encountered is viewed as “return from function,” and the function’s stack frame is destroyed when it should not be.

To overcome this, simply declare a byte value of 0C3h directly inline in the source, as you would declare data.  This will execute as a RET statement without messing up the function’s stack frame and all is well.

Note that all of the message handlers are placed after the function’s action RET statement so that they are guaranteed not to execute unless explicitly called.

## WinCall and LocalCall

The LocalCall macro simply generates a CALL instruction.  It exists only to clarify that a call destination is found within the app and is not part of the Windows API.  WinCall, conversely, handles all the particulars of the 64-bit calling convention.  The first four parameters for a call destination should always be present in RCX, RDX, R8, and R9, in that order.  Any parameters beyond the fourth are placed into their appropriate locations on the stack by the WinCall macro.  Constants, direct memory references, and general registers can be used to hold any parameters beyond the fourth.  Since, internally, RAX is used to shuttle these values onto the stack, any value that can be placed into RAX can be passed as a parameter to WinCall after RCX, RDX, R8, and R9 (those registers are used directly).

As a side note, I always avoid using R10 and R11 for parameter passing.  These registers are defined by the 64-bit convention as volatile.  As such, their values on return from a call are never guaranteed and I avoid using them just as a safety measure.

## COM and ASM

A COM interface pointer is actually a pointer to a location in memory.  At that location is a pointer to the vTable for the interface.  The RCX register must contain the interface pointer on all COM calls.  While this can be figured out by studying the C++ header files, it’s an inconvenient truth to have to learn the hard way.  All documented DirectX methods should assume an undocumented parameter this as the first parameter: the interface pointer itself must be present in RCX. 

Within the app, all DirectX calls are made following the logic outlined below:

	1.Move the interface pointer into RCX.
	2.Move the value pointed to by RCX into RBX.  I.e. mov rbx, [rcx].  This moves the vTable pointer into the RBX register.  Within this app, all COM methods are defined relative to the RBX register.  It was an arbitrary decision; RBX wasn’t really used for much of anything else so it was selected.  All vTables (defined in vTables.asm) reference offsets from RBX, i.e.

```
ID3D11DeviceContext_DrawIndexed textequ <qword ptr [rbx+96]>
```
Using the above example, the call is made to ID3D11DeviceContext_DrawIndexed, not to the local variable D3D11DevCon->DrawIndexed.  The -> won’t be interpreted as ASM does not inherently understand COM.

## The Dreaded Math Library

In a perfect world, I would have custom-coded all of the math library functions used by this app.  I did not.  In this case, I elected to use the included C++ solution DXSampleMath instead.  This is a sample app, designed as an introduction to creating DirectX applications in ASM, and the time available to devote to it was quite limited. 

`DXSampleMath` contains functions that in turn call their sometimes-inline counterparts.  For example, the `DXSampleMath` .DLL module exports `XMMatrixMultiplyProxy`.  That function has a single statement: it passes its parameters to `XMMatrixMultiply`.  The wrappers were necessary because many of the math library functions are generated as inline code within the wrapper function.

The entire .DLL project in VS2017 C++ is contained in the `DXSampleMath` directory immediately under the directory you created for the .zip file.

## Conclusion

This article is only a quick overview of how the app is put together.  If you intend to expand on this app, or to write your own, you won’t be able to escape the need for perusing the attendant source code.

The one suggestion I will place above all others is this: don’t be an apologist for using ASM.  Your goal is to serve the end user, not to make your peers happy, gain their approval, or avoid making them feel small.  Make the best use of ASM according to your own quirks and your own preferences.  You are not doing things “properly” by bending over backward trying to make your ASM code resemble a high level language as closely as possible.  You are under no obligation to follow the rules that apply to high level languages in corporate work environments, and attempting to do so will rapidly destroy everything you moved to ASM to achieve.  What’s “proper” over there is not proper over here.  What’s correct there isn’t correct here.  Do what works for you.  Unleash your abilities.  Take off the shackles.  If you like using globals, use them; if you don’t use them, be aware of the cost of your choice: for every 20 bytes saved by declaring a data structure or a string dynamically, you may use 60+ bytes of extra code to manage it.  That is not intelligent programming.  Know what you’re generating.  No other language makes it as easy as ASM to keep close tabs on what is actually executing.

Most of your data should be initialized as hard-coded static variables.  The amount of code used to manage dynamically allocated structures almost always results in a net loss of memory over what static values would require.  When you hard code static values, initialization is already done at compile time, with even more code bytes and execution time being saved by not having to initialize the data at runtime.  Worse, all accesses to local variables must be indirect – the CPU must execute an outrageously slow subtraction instruction for every single access.  MOV RAX, [RBP-38h], for example, requires RBP-38h to calculate on the fly.  It takes more extra bytes of code to encode that instruction over a fixed memory location, in addition to the huge slowdown in executing it.  This slowdown will apply to every single dynamically allocated and/or local variable in your app, every single time it’s accessed.  The app attached to this article uses one single local variable: holder, which is required for the WinCall macro in every function that uses it.  All other data is static and all but a few values are initialized at compile time.

The swapChainDesc structure declaration in the structures.asm file demonstrates this process.  The only variables not hard coded are the ones that are unknown until runtime: the main window's handle, and its window width/height. 

I've been developing in assembly language full time and almost exclusively since 1984.  In that time, I've learned one thing that stands head and shoulders above all other lessons: you always stand to learn something valuable from everybody using the language – especially beginners, who are seeking, who have open minds, who have not yet been indoctrinated into the bureaucracy that oversees the development community.  I can guarantee you that every college student dabbling into ASM because an instructor made them do it could teach me something I didn’t know about using the language.  That is unlikely to ever change.

Your biggest speed improvement, by far, will come from reworking the math library.  It is a monster, but hardly an impressive one.  Internally it reflects a level of shoddy disorganization seldom seen in the software world.  It uses memory freely and recklessly when CPU registers are widely available; that switch alone could exponentially speed up execution.  As with all high level languages, the DirectX math collection has a love of calling, calling, calling, many levels deep.  Each call, each return, costs execution time that could be improving gameplay (or whatever your DirectX task is). It is not uncommon to see C++ utilize ten or fifteen CPU instructions to manage calling a function that executes two or three.  These types of cases can easily be overridden by an ASM developer, simply placing the two or three instructions inline in a function rather than calling them in a function.

Since your most potent weapon against performance hinderance is the math library, it stands to reason that reworking it will be your biggest challenge.  It will not be easy.  But each function reworked will only need to be done once, and you will have the benefit of chipping away at the task one function at a time. 

The real sticking point in reworking the math library is in deciding where to place the cutoff along the path of SSE evolution.  Today’s AVX-512 instructions are geared heavily toward vector math, providing huge performance benefits.  But Gary Gamer in Gametown, Georgia may have an older system that doesn’t support AVX-512.  What then?  You have to figure it out.  I would create a distinct library for every cutoff point along the evolutionary chain, and load the appropriate library at app startup time based on detected hardware.  Then my app isn’t being drug down by redundantly checking for the CPU version on every single call to the math library.  It would be an enormous undertaking, but that’s my way – do what works for you.

With this article and its attendant app, you have a very lightweight starting point.  If you’re serious about blazing new trails, about producing 3D products nobody thought possible on standard hardware, you’ll have to get used to reigning in impatience and sometimes embarking on long, tedious information and development tangents.  If you’re using ASM, the world is not your friend.  There are precious few resources for helping you along; most of your forward progress will have to be made on your own.  And the payoff for all that effort is that you’ll be the only kid on your block with a Lamborghini while everybody else is driving a Ford Focus.

Push the envelope, get back to basics, and take control of your creations.  Show the world what you’re capable of inventing.  Most people; most companies, won’t.  They’ll continue acting as mere brokers, hiring 491 outsourced companies, who in turn hire 491 outsourced companies each, avoiding work and preferring to brokers deals instead.  They will avoid work as their main goal in life – it’s money for nothing.  That’s their prerogative; one that makes it quite easy to leave them far behind in the dust with your own creations.  If their approach was your orientation, you probably wouldn’t be reading this article at all.  It’s likely that for you, the envelope must be pushed or you won’t be happy.  You want more than you have.  You are the type that will evolve the industry – not the brokers.  Apply what’s given here, learn it, work with it, expand on it, and you’ll move right out of the pack and onto the bleeding edge.  Go forth and multiply … divide … add … subtract … create!

With the material presented here as a launch pad, you have a wide open portal to absolutely unheard of new vistas in 3D gaming.  All you have to do is walk through it.  And don’t be afraid to work hard.

What will you create?  That’s your call.  Why don’t you show us? 

Game on!
