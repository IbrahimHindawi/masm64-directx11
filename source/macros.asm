
;***** AInclude ********************************************************************************************************

                                                 ;***** [Declare macro] ************************************************

AInclude                                         macro               filename                                          ; Declare macro

                                                 ;***** [Process] ******************************************************

                                                 align               qword                                             ; Set qword alignment
                                                 include             filename                                          ; Restore entry RBX

                                                 ;***** [End macro] ****************************************************

                                                 endm                                                                  ; End macro declaration

;***** LocalCall *******************************************************************************************************
;
; This macro is not necessary; it's provided for clarity in distinguishing between a local call (calls to functions
; within this app) vs. calls to Windows functions.

                                                 ;***** [Declare macro] ************************************************

LocalCall                                        macro               destination                                       ; Declare macro

                                                 ;***** [Process] ******************************************************

                                                 call                destination                                       ; Restore entry RBX

                                                 ;***** [End macro] ****************************************************

                                                 endm                                                                  ; End macro declaration

;***** LoopN ***********************************************************************************************************

                                                 ;***** [Declare macro] ************************************************

LoopN                                            macro               destination                                       ; Declare macro

                                                 ;***** [Process] ******************************************************

                                                 dec                 rcx                                               ; Decrement the loop counter
                                                 jnz                 destination                                       ; Return to top of loop

                                                 ;***** [End macro] ****************************************************

                                                 endm                                                                  ; End macro declaration

;***** Restore_Registers ***********************************************************************************************

                                                 ;***** [Declare macro] ************************************************

Restore_Registers                                macro                                                                 ; Declare macro

                                                 ;***** [Process] ******************************************************

                                                 pop                 r15                                               ; Restore entry R15
                                                 pop                 r14                                               ; Restore entry R14
                                                 pop                 r13                                               ; Restore entry R13
                                                 pop                 r12                                               ; Restore entry R12
                                                 pop                 r11                                               ; Restore entry R11
                                                 pop                 r10                                               ; Restore entry R10
                                                 pop                 r9                                                ; Restore entry R9
                                                 pop                 r8                                                ; Restore entry R8
                                                 pop                 rdi                                               ; Restore entry RDI
                                                 pop                 rsi                                               ; Restore entry RSI
                                                 pop                 rdx                                               ; Restore entry RDX
                                                 pop                 rcx                                               ; Restore entry RCX
                                                 pop                 rbx                                               ; Restore entry RBX

                                                 ;***** [End macro] ****************************************************

                                                 endm                                                                  ; End macro declaration

;***** Save_Registers **************************************************************************************************

                                                 ;***** [Declare macro] ************************************************

Save_Registers                                   macro                                                                 ; Declare macro

                                                 ;***** [Process] ******************************************************

                                                 push                rbx                                               ; Save entry RBX
                                                 push                rcx                                               ; Save entry RCX
                                                 push                rdx                                               ; Save entry RDX
                                                 push                rsi                                               ; Save entry RSI
                                                 push                rdi                                               ; Save entry RDI
                                                 push                r8                                                ; Save entry r8
                                                 push                r9                                                ; Save entry r9
                                                 push                r10                                               ; Save entry r10
                                                 push                r11                                               ; Save entry r11
                                                 push                r12                                               ; Save entry r12
                                                 push                r13                                               ; Save entry r13
                                                 push                r14                                               ; Save entry r14
                                                 push                r15                                               ; Save entry r15

                                                 ;***** [End macro] ****************************************************

                                                 endm                                                                  ; End macro declaration

;***** WinCall *********************************************************************************************************
;
; Every function invoking this macro MUST have a local "holder" variable declared.

                                                 ;***** [Declare macro] ************************************************

WinCall                                          macro               call_dest:req, argnames:vararg                    ; Declare macro

                                                 local               jump_1, lpointer, numArgs                         ; Declare local labels

                                                 ;***** [Process] ******************************************************

                                                 numArgs             = 0                                               ; Initialize # arguments passed

                                                 for                 argname, <argnames>                               ; Loop through each argument passed
                                                   numArgs           = numArgs + 1                                     ; Increment local # arguments count
                                                 endm                                                                  ; End of FOR looop

                                                 if numArgs lt 4                                                       ; If # arguments passed < 4
                                                   numArgs = 4                                                         ; Set count to 4
                                                 endif                                                                 ; End IF

                                                 mov                 holder, rsp                                       ; Save the entry RSP value

                                                 sub                 rsp, numArgs * 8                                  ; Back up RSP 1 qword for each parameter passed

                                                 test                rsp, 0Fh                                          ;
                                                 jz                  jump_1                                            ;
                                                 and                 rsp, 0FFFFFFFFFFFFFFF0h                           ; Clear low 4 bits for para alignment
jump_1:
                                                 lPointer            = 0                                               ; Initialize shadow area @ RSP + 0

                                                 for                 argname, <argnames>                               ; Loop through arguments
                                                   if                lPointer gt 24                                    ; If not on argument 0, 1, 2, 3
                                                     mov             rax, argname                                      ; Move argument into RAX
                                                     mov             [ rsp + lPointer ], rax                           ; Shadow the next parameter on the stack
                                                   elseif            lPointer eq 0                                     ; If on argument 0
                                                     mov             rcx, argname                                      ; Argument 0 -> RCX
                                                   elseif            lPointer eq 8                                     ; If on argument 1
                                                     mov             rdx, argname                                      ; Argument 1 -> RDX
                                                   elseif            lPointer eq 16                                    ; If on argument 2
                                                     mov             r8, argname                                       ; Argument 2 -> R8
                                                   elseif            lPointer eq 24                                    ; If on argument 3
                                                     mov             r9, argname                                       ; Argument 3 -> R9
                                                   endif                                                               ; End IF
                                                   lPointer          = lPointer + 8                                    ; Advance the local pointer by 1 qword
                                                 endm                                                                  ; End FOR looop

                                                 call                call_dest                                         ; Execute call to destination function

                                                 mov                 rsp, holder                                       ; Reset the entry RSP value

                                                 ;***** [End macro] ****************************************************

                                                 endm                                                                  ; End macro declaration
