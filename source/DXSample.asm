
;-----------------------------------------------------------------------------------------------------------------------
;
; DXSample
;
; Sample DirectX app - spins a basic triangle.

;----- [Declare data segment] ------------------------------------------------------------------------------------------

                                                 .data                                                                 ; Declare data segment

;----- [Data file includes] --------------------------------------------------------------------------------------------

                                                  include            macros.asm                                        ; Macros first for subsequent ainclude defs

                                                 ;----- The ainclude macro is simply an 'align qword' statement
                                                 ;      followed by 'include.'  It's a redundant precaution in most
                                                 ;      cases, ensuring that qword alignment persists as much as
                                                 ;      possible within static data.

                                                 ainclude            wincons.asm                                       ; Windows constants
                                                 ainclude            constants.asm                                     ; App-local constants
                                                 ainclude            structuredefs.asm                                 ; Structure definitions

                                                 ainclude            buffers.asm                                       ; String buffers
                                                 ainclude            lookups.asm                                       ; Lookup lists
                                                 ainclude            riid.asm                                          ; RIID values
                                                 ainclude            routers.asm                                       ; Router lists
                                                 ainclude            strings.asm                                       ; Constant strings
                                                 ainclude            structures.asm                                    ; Data structures
                                                 ainclude            variables.asm                                     ; Data variables
                                                 ainclude            vtables.asm                                       ; COM vTable declarations

;----- [Declare code segment] ------------------------------------------------------------------------------------------

                                                 .code                                                                 ; Declare code segment

;----- [Code file includes] --------------------------------------------------------------------------------------------

                                                 ainclude            externals.asm                                     ; External function declarations

                                                 ainclude            callbacks.asm                                     ; Callback functions
                                                 ainclude            common.asm                                        ; Common functions
                                                 ainclude            diagnostics.asm                                   ; Diagnostic functions
                                                 ainclude            general.asm                                       ; General

;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; Windows entry point                                                                                                  -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------

Startup                                          proc                                                                  ; Declare function

;----- [Fix the WinDbg bug] --------------------------------------------------------------------------------------------

                                                 LocalCall           FixWinDbg                                         ; Execute call

                                                 ;-----[Setup the main window]------------------------------------------

                                                 LocalCall           SetupMainWindow                                   ; Setup the main window
                                                 mov                 Main_Handle, rax                                  ; Save the main window handle

                                                 ;-----[Setup DirectX]--------------------------------------------------

                                                 LocalCall           SetupDirectX                                      ; Setup DirectX

                                                 ;-----[Run the message loopo]------------------------------------------

                                                 LocalCall           RunMessageLoop                                    ; Run the message loop

                                                 ;-----[Terminate the application]--------------------------------------

                                                 xor                 rcx, rcx                                          ; Set final return code
                                                 call                ExitProcess                                       ; Exit this process

Startup                                          endp                                                                  ; End startup function

                                                 end                                                                   ; End module
