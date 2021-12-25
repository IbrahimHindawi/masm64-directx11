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

