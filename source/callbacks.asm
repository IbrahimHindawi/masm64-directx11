
;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; Main_CB                                                                                                              -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; In:  rcx = hWnd                                                                                                      -
;      rdx = uMsg                                                                                                      -
;      r8  = wParam                                                                                                    -
;      r9  = lParam                                                                                                    -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------

Main_CB                                          proc                                                                  ; Declare function

;-----[Local Data]-----------------------------------------------------------------------------------------------------

                                                 local               holder:qword                                      ;
                                                 local               hWnd:qword                                        ;
                                                 local               lParam:qword                                      ;
                                                 local               message:qword                                     ;
                                                 local               wParam:qword                                      ;

;-----[Save incoming registers]----------------------------------------------------------------------------------------

                                                 Save_Registers                                                        ; Save incoming registers

                                                 ;-----[Set incoming values]-------------------------------------------

                                                 mov                 hWnd, rcx                                         ; Set the incoming handle
                                                 mov                 message, rdx                                      ; Set the incoming message
                                                 mov                 wParam, r8                                        ; Set the incoming wParam value
                                                 mov                 lParam, r9                                        ; Set the incoming lParam value

                                                 ;-----[Branch if overriding local callouts]---------------------------

                                                 cmp                 in_shutdown, 0                                    ; In shutdown process?
                                                 jnz                 Main_CB_00001                                     ; Yes -- default handling only

                                                 ;-----[Lookup incoming message]---------------------------------------

                                                 mov                 rcx, rdx                                          ; Set message
                                                 lea                 rdx, Main_CB_Lookup                               ; Set lpLookupList
                                                 LocalCall           Common_Lookup                                     ; Route for incoming message

                                                 ;-----[Branch if message lookup hit]-----------------------------------
                                                 ;
                                                 ; If the incoming uMsg value is present in the Main_CB_Lookup list, the
                                                 ; return value for RAX will contain the 0-based qword index of the list
                                                 ; item matched.  If no match, -1 is returned.

                                                 cmp                 rax, -1                                           ; Message lookup hit?
                                                 jnz                 Main_CB_00002                                     ; Yes -- route for message

                                                 ;-----[Execute default handler]---------------------------------------

Main_CB_00001:                                   mov                 rcx, hwnd                                         ; Reset RCX
                                                 mov                 rdx, message                                      ; Reset RDX
                                                 mov                 r8, wParam                                        ; Reset R8
                                                 mov                 r9, lParam                                        ; Reset R9
                                                 WinCall             DefWindowProc, rcx, rdx, r8, r9                   ; Execute call
                                                 jmp                 Main_CB_Exit                                      ; Exit procedure

                                                 ;-----[Route for target message]--------------------------------------

Main_CB_00002:                                   shl                 rax, 3                                            ; Scale to * 8 for byte offset
                                                 LocalCall           Main_CB_Rte [ rax ]                               ; Execute target callout

;-----[Restore incoming registers]-------------------------------------------------------------------------------------

                                                 align               qword                                             ; Set qword alignment
Main_CB_Exit:                                    Restore_Registers                                                     ; Restore incoming registers

;-----[Return to caller]-----------------------------------------------------------------------------------------------

                                                 ret                                                                   ; Return to caller

;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; Handler: WM_EraseBkgnd message.                                                                                      -
;                                                                                                                      -
;          Since DirectX handles drawing, this handler does nothing but return TRUE to say "processed."                -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------

                                                 align               qword                                             ; Set qword alignment
Main_CB_EraseBkgnd                               label               qword                                             ; Declare label

                                                 ;-----[Set TRUE return]-----------------------------------------------

                                                 mov                 rax, 1                                            ; Set TRUE return

                                                 ;-----[Return to caller]-----------------------------------------------

                                                 byte                0C3h                                              ; Encoded RET statement

;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; Handler: WM_Paint message.                                                                                           -
;                                                                                                                      -
;          Since DirectX handles drawing, this handler only validates the invalid client area to prevent WM_Paint      -
;          from being sent over and over.                                                                              -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------

                                                 align               qword                                             ; Set qword alignment
Main_CB_Paint                                    label               qword                                             ; Declare label

                                                 ;-----[Validate the invalid rectangle]--------------------------------

                                                 mov                 rcx, hwnd                                         ; Set hWnd
                                                 xor                 rdx, rdx                                          ; Set lprc
                                                 WinCall             ValidateRect, rcx, rdx                            ; Execute call

                                                 ;-----[Set ZERO return]------------------------------------------------

                                                 xor                 rax, rax                                          ; Set ZERO return

                                                 ;-----[Return to caller]-----------------------------------------------

                                                 byte                0C3h                                              ; Encoded RET statement

;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; Handler: WM_Close message.                                                                                           -
;                                                                                                                      -
;          Execute DirectX shutdowns and destroy main window.                                                          -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------

                                                 align               qword                                             ; Set qword alignment
Main_CB_Close                                    label               qword                                             ; Declare label

                                                 ;-----[Do DirectX cleanups]--------------------------------------------

                                                 LocalCall           Shutdown                                          ; Shut down DirectX

                                                 ;-----[Destroy the main window]----------------------------------------

                                                 mov                 rcx, Main_Handle                                  ; Set hWnd
                                                 WinCall             DestroyWindow, rcx                                ; Execute call

                                                 ;-----[Set ZERO return]------------------------------------------------

                                                 xor                 rax, rax                                          ; Set ZERO return

                                                 ;-----[Return to caller]-----------------------------------------------

                                                 byte                0C3h                                              ; Encoded RET statement

;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; Handler: WM_Destroy message.                                                                                         -
;                                                                                                                      -
;          Post WM_Quit.                                                                                               -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------

                                                 align               qword                                             ; Set qword alignment
Main_CB_Destroy                                  label               qword                                             ; Declare label

                                                 ;-----[Post the quit message]------------------------------------------

                                                 xor                 rax, rax                                          ; Set nExitCode
                                                 WinCall             PostQuitMessage, rcx                              ; Post the quit message

                                                 ;-----[Set ZERO return]------------------------------------------------

                                                 xor                 rax, rax                                          ; Set ZERO return

                                                 ;-----[Return to caller]-----------------------------------------------

                                                 byte                0C3h                                              ; Encoded RET statement

Main_CB                                          endp                                                                  ; End function
