
;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; RenderScene                                                                                                          -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; In:  <No Parameters>                                                                                                 -
;                                                                                                                      -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------

RenderScene                                      proc                                                                  ; Declare function

;------[Local Data]-----------------------------------------------------------------------------------------------------

                                                 local               holder:qword                                      ;

;------[Save incoming registers]----------------------------------------------------------------------------------------

                                                 Save_Registers                                                        ; Save incoming registers

                                                 ;-----[Rotate the triangle]Ä-------------------------------------------
                                                 ;
                                                 ; rotationAngle += angleIncrement

                                                 movss               xmm0, rotationAngle                               ; Get the current angle
                                                 movss               xmm1, angleIncrement                              ; Get the per-frame angle increment
                                                 addss               xmm0, xmm1                                        ; Increment the rotation angle

                                                 ;-----[Reset rotation to 0 if > 6.26 radians]--------------------------
                                                 ;
                                                 ; if ( rotationAngle > 6.26f ) rotationAngle = 0.0f;
                                                 ;
                                                 ; CMPSS mode 2 tests the current rotation angle in XMM0 vs. the
                                                 ; rotationLimit value.  If the comparison is false (greater), XMM0 is
                                                 ; reset to 0.  XMM0 slot 0 is set to all 0 if this reset is to be made.

                                                 movss               xmm1, xmm0                                        ; Copy new angle into XMM1
                                                 cmpss               xmm1, rotationLimit, 2                            ; Compare current to limit (less or equal)
                                                 vmovd               eax, xmm1                                         ; Set EAX = 0 if reset required
                                                 test                eax, eax                                          ; Reset required?
                                                 jnz                 RenderScene_00001                                 ; No -- no reset
                                                 xorps               xmm0, xmm0                                        ; Yes -- reset angle

                                                 ;-----[Rotate the triangle]Ä-------------------------------------------
                                                 ;
                                                 ; mWorld = XMMatrixRotationY( rot);
                                                 ;
                                                 ; For this call XMM0 already holds the new angle

RenderScene_00001:                               movss               rotationAngle, xmm0                               ; Store the new rotation angle
                                                 movss               xmm1, xmm0                                        ;
                                                 lea                 rcx, mWorld                                       ; Set the output pointer
                                                 WinCall             XMMatrixRotationYProxy, rcx                       ; Set the Y rotation

                                                 ;-----[Clear the background]-------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->ClearRenderTargetView(renderTargetView, bgColor);

                                                 lea                 r8, bgColor                                       ; Set ColorRGBA
                                                 mov                 rdx, renderTargetView                             ; Set *pRenderTargetView
                                                 mov                 rcx, d3d11DevCon                                  ; Get the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_ClearRenderTargetView, rcx, rdx, r8

                                                 ;-----[Clear the depth stencil view]-----------------------------------
                                                 ;
                                                 ; d3d11DevCon->ClearDepthStencilView(depthStencilView,
                                                 ;                                      D3D11_CLEAR_DEPTH | D3D11_CLEAR_STENCIL,
                                                 ;                                      1.0f, 0);

                                                 xor                 r9, r9                                            ; Zero R9
                                                 mov                 r9d, r1                                           ; Set Depth
                                                 mov                 r8, D3D11_CLEAR_DEPTH or D3D11_CLEAR_STENCIL      ; Set ClearFlags
                                                 mov                 rdx, depthStencilView                             ; Set *pDepthStencilView
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_ClearDepthStencilView, rcx, rdx, r8, r9, 0

                                                 ;-----[Set matrix mWVP = mWorld * mView]-------------------------------
                                                 ;
                                                 ; mWVP = mWorld * mView * mProj;

                                                 lea                 r8, mView                                         ; Set M2
                                                 lea                 rdx, mWorld                                       ; Set M1
                                                 lea                 rcx, mWVP                                         ; Set m
                                                 WinCall             XMMatrixMultiplyProxy, rcx, rdx, r8               ; Set mWVP = mWorld * mView

                                                 ;-----[Set matrix mWVP = mWVP * mProj]---------------------------------

                                                 lea                 r8, mProj                                         ; Set M2
                                                 lea                 rdx, mWVP                                         ; Set M1
                                                 lea                 rcx, mWVP                                         ; Set m
                                                 WinCall             XMMatrixMultiplyProxy, rcx, rdx, r8               ; Set mWVP = mWorld * mView

                                                 ;-----[Transpose result into constant buffer]--------------------------
                                                 ;
                                                 ; cbPerObj.WVP = XMMatrixTranspose(WVP);

                                                 lea                 rdx, mWVP                                         ; Set M1
                                                 lea                 rcx, cbPerObj                                     ; Set mOut
                                                 WinCall             XMMatrixTransposeProxy, rcx, rdx                  ; Transpose image to target

                                                 ;-----[Update the sub resource]----------------------------------------
                                                 ;
                                                 ; d3d11DevCon->UpdateSubresource( cbPerObjectBuffer, 0, NULL, &cbPerObj, 0, 0 );

                                                 lea                 r12, cbPerObj                                     ; Set *pSrcData
                                                 xor                 r9, r9                                            ; Set *pDstBox
                                                 xor                 r8, r8                                            ; Set DstSubresource
                                                 mov                 rdx, cbPerObjectBuffer                            ; Set *pDstResource
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_UpdateSubresource, rcx, rdx, r8, r9, r12, 0, 0

                                                 ;-----[Set the VS constant buffer]-------------------------------------
                                                 ;
                                                 ; d3d11DevCon->VSSetConstantBuffers( 0, 1, &cbPerObjectBuffer );

                                                 lea                 r9, cbPerObjectBuffer                             ; Set *ppConstantBuffers
                                                 mov                 r8, 1                                             ; Set NumBuffers
                                                 xor                 rdx, rdx                                          ; Set StartSlot
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_VSSetConstantBuffers, rcx, rdx, r8, r9, r12, 0, 0

                                                 ;-----[Draw the scene]-------------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->Draw( 3, 0 );

                                                 xor                 r8, r8                                            ; Set StartVertexLocation
                                                 mov                 rdx, 3                                            ; Set VertexCount
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_Draw, rcx, rdx, r8            ; Draw the scene

                                                 ;-----[Present the scene]----------------------------------------------
                                                 ;
                                                 ; SwapChain->Present(0, 0);

                                                 xor                 r8, r8                                            ; Set Flags
                                                 xor                 rdx, rdx                                          ; Set SyncInterval
                                                 mov                 rcx, SwapChain                                    ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             IDXGISwapChain_Present, rcx, rdx, r8              ; Present the scene

                                                 ;-----[Zero final return]----------------------------------------------

                                                 xor                 rax, rax                                          ; Zero final return

;------[Restore incoming registers]-------------------------------------------------------------------------------------

                                                 align               qword                                             ; Set qword alignment
RenderScene_Exit:                                Restore_Registers                                                     ; Restore incoming registers

;------[Return to caller]-----------------------------------------------------------------------------------------------

                                                 ret                                                                   ; Return to caller

RenderScene                                      endp                                                                  ; End function



;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; RunMessageLoop                                                                                                       -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; In:  <No Parameters>                                                                                                 -
;                                                                                                                      -
; This function registers the window class MainWindowClass, creates the main window as a top level window of that      -
; class, and returns the new window handle in RAX.  RAX is returned as -1 if the function fails.                       -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------

RunMessageLoop                                   proc                                                                  ; Declare function

;------[Local Data]-----------------------------------------------------------------------------------------------------

                                                 local               holder:qword                                      ;
                                                 local               msg_data:msg                                      ;

;------[Save incoming registers]----------------------------------------------------------------------------------------

                                                 Save_Registers                                                        ; Save incoming registers

                                                 ;-----[Get the next message]-------------------------------------------

RunMessageLoop_00001:                            xor                 r9, r9                                            ; Set wMsgFilterMax
                                                 xor                 r8, r8                                            ; Set wMsgFilterMin
                                                 xor                 rdx, rdx                                          ; Set hWnd
                                                 lea                 rcx, msg_data                                     ; Set lpMsg
                                                 WinCall             PeekMessage, rcx, rdx, r8, r9, pm_remove          ; Peek for next message

                                                 ;-----[Branch if no messages]------------------------------------------

                                                 test                rax, rax                                          ; Anything available?
                                                 jz                  RunMessageLoop_00003                              ; No - render scene

                                                 ;-----[Branch if not WM_Quit]------------------------------------------

                                                 cmp                 msg_data.message, wm_quit                         ; WM_Quit?
                                                 jnz                 RunMessageLoop_00002                              ; No - continue process

                                                 ;-----[Send the message manually]--------------------------------------

                                                 xor                 r9, r9                                            ; Set lParam
                                                 xor                 r8, r8                                            ; Set wParam
                                                 mov                 rdx, wm_quit                                      ; Set uMsg
                                                 mov                 rcx, Main_Handle                                  ; Set hWnd
                                                 WinCall             SendMessage, rcx, rdx, r8, r9                     ; Execute call

                                                 ;-----[Exit the function]----------------------------------------------

                                                 xor                 rax, rax                                          ; Zero final return
                                                 jmp                 RunMessageLoop_Exit                               ; Exit function

                                                 ;-----[Translate the message]------------------------------------------

RunMessageLoop_00002:                            lea                 rcx, msg_data                                     ; Set lpMsg
                                                 WinCall             TranslateMessage, rcx                             ; Execute call

                                                 ;-----[Dispatch the message]-------------------------------------------

                                                 lea                 rcx, msg_data                                     ; Set lpMsg
                                                 WinCall             DispatchMessage, rcx                              ; Execute call

                                                 ;-----[Check for next message]-----------------------------------------

                                                 jmp                 RunMessageLoop_00001                              ; Reloop for next check

                                                 ;-----[Update the scene]-----------------------------------------------

RunMessageLoop_00003:                            LocalCall           UpdateScene                                       ; Execute call

                                                 ;-----[Render the scene]-----------------------------------------------

                                                 LocalCall           RenderScene                                       ; Render the scene

                                                 ;-----[Check for next message]-----------------------------------------

                                                 jmp                 RunMessageLoop_00001                              ; Reloop for next check

;------[Restore incoming registers]-------------------------------------------------------------------------------------

                                                 align               qword                                             ; Set qword alignment
RunMessageLoop_Exit:                             Restore_Registers                                                     ; Restore incoming registers

;------[Return to caller]-----------------------------------------------------------------------------------------------

                                                 ret                                                                   ; Return to caller

RunMessageLoop                                   endp                                                                  ; End function



;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; SetupDirectX                                                                                                         -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; In:  <No Parameters>                                                                                                 -
;                                                                                                                      -
; This function registers the window class MainWindowClass, creates the main window as a top level window of that      -
; class, and returns the new window handle in RAX.  RAX is returned as -1 if the function fails.                       -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------

SetupDirectX                                     proc                                                                  ; Declare function

;------[Local Data]-----------------------------------------------------------------------------------------------------

                                                 local               holder:qword                                      ;

;------[Save incoming registers]----------------------------------------------------------------------------------------

                                                 Save_Registers                                                        ; Save incoming registers

                                                 ;-----[Get the client area]--------------------------------------------

                                                 lea                 rdx, client_rect                                  ; Set lprc
                                                 mov                 rcx, Main_Handle                                  ; Set hWnd
                                                 WinCall             GetClientRect, rcx, rdx                           ; Get the client area

                                                 ;-----[Set values that are unknown before runtime]---------------------
                                                 ;
                                                 ; C++ code below - for reference only
                                                 ;
                                                 ; DXGI_MODE_DESC bufferDesc;
                                                 ;
                                                 ; ZeroMemory(&bufferDesc, sizeof(DXGI_MODE_DESC));
                                                 ;
                                                 ; bufferDesc.Width = Width;
                                                 ; bufferDesc.Height = Height;
                                                 ; bufferDesc.RefreshRate.Numerator = 60;
                                                 ; bufferDesc.RefreshRate.Denominator = 1;
                                                 ; bufferDesc.Format = DXGI_FORMAT_R8G8B8A8_UNORM;
                                                 ; bufferDesc.ScanlineOrdering = DXGI_MODE_SCANLINE_ORDER_UNSPECIFIED;
                                                 ; bufferDesc.Scaling = DXGI_MODE_SCALING_UNSPECIFIED;
                                                 ;
                                                 ; //Describe our SwapChain
                                                 ; DXGI_SWAP_CHAIN_DESC swapChainDesc;
                                                 ;
                                                 ; ZeroMemory(&swapChainDesc, sizeof(DXGI_SWAP_CHAIN_DESC));
                                                 ;
                                                 ; swapChainDesc.BufferDesc = bufferDesc;
                                                 ; swapChainDesc.SampleDesc.Count = 1;
                                                 ; swapChainDesc.SampleDesc.Quality = 0;
                                                 ; swapChainDesc.BufferUsage = DXGI_USAGE_RENDER_TARGET_OUTPUT;
                                                 ; swapChainDesc.BufferCount = 1;
                                                 ; swapChainDesc.OutputWindow = hwnd;
                                                 ; swapChainDesc.Windowed = TRUE;
                                                 ; swapChainDesc.SwapEffect = DXGI_SWAP_EFFECT_DISCARD;

                                                 ;----- Note that all the above is relatively standard for DirectX handling and is mostly a waste
                                                 ;      of resources, both CPU and memory.  Our handling of the same structures holding the same
                                                 ;      startup data only dynamically sets the data that is unknown until runtime.  The unnecessary
                                                 ;      statements required to move data needlessly take up memory for the code and waste CPU time
                                                 ;      executing.
                                                 ;
                                                 ;      Even more ludicrous is wasting the memory for the bufferDesc structure, then using code
                                                 ;      bytes to manually fill it with data that's all static except for the client width and heigth,
                                                 ;      and the window handle, then moving it all into swapChainDesc.BufferDesc.  What a massive waste!

                                                 xor                 rax, rax                                          ; Zero RAX
                                                 mov                 eax, client_rect.right                            ; Get the client area width
                                                 mov                 swapChainDesc.BufferDesc._Width, eax              ; Store the buffer width

                                                 mov                 eax, client_rect.bottom                           ; Get the client area height
                                                 mov                 swapChainDesc.BufferDesc._Height, eax             ; Store the buffer height

                                                 mov                 rax, Main_Handle                                  ; Get the window handle
                                                 mov                 swapChainDesc.OutputWindow, rax                   ; Set the output window handle

                                                 ;----- That's it.  7 ASM instructions and the dxgi_swap_chain_desc structure is fully loaded and ready
                                                 ;      to pass.

                                                 ;----- [Create the device and swap chain]------------------------------
                                                 ;
                                                 ; hr = D3D11CreateDeviceAndSwapChain(NULL, D3D_DRIVER_TYPE_HARDWARE,
                                                 ;                                     NULL, NULL, NULL, NULL,
                                                 ;                                     D3D11_SDK_VERSION, &swapChainDesc,
                                                 ;                                     &SwapChain, &d3d11Device, NULL, &
                                                 ;                                     d3d11DevCon);

                                                 lea                 r15, d3d11DevCon                                  ; Set **ppImmediateContext
                                                 lea                 r14, d3d11Device                                  ; Set **ppDevice
                                                 lea                 r13, swapChain                                    ; Set **ppSwapChain
                                                 lea                 r12, swapChainDesc                                ; Set pSwapChainDesc
                                                 mov                 r9, 0 ; d3d11_create_device_debug                 ; Set flags : use debug flag for debug mode
                                                 xor                 r8, r8                                            ; Set Software
                                                 mov                 rdx, D3D_DRIVER_TYPE_HARDWARE                     ; Set DriverType
                                                 xor                 rcx, rcx                                          ; Set *pAdapter
                                                 WinCall             D3D11CreateDeviceAndSwapChain, rcx, rdx, r8, r9, 0, 0, D3D11_SDK_VERSION, r12, r13, r14, 0, r15

                                                 ;----------------------------------------------------------------------

                                                 ;-----> Error if RAX != 0

                                                 ;-----[Create our back buffer]-----------------------------------------
                                                 ;
                                                 ; Note: ASM doesn't know or care about typecasting.  This is enormously
                                                 ;       powerful as well as time saving.  Data is data; the only thing
                                                 ;       the instructions care about is the size of each access in bytes.
                                                 ;       Since all pointers are 64 bits, BackBuffer is simply a qword.
                                                 ;       Don't use it where it shouldn't be used and you won't have any
                                                 ;       problems.  The amount of coding that is saved becomes stag-
                                                 ;       gering across an entire app from this aspect alone
                                                 ;
                                                 ; ID3D11Texture2D* BackBuffer;
                                                 ;
                                                 ; hr = SwapChain->GetBuffer( 0, __uuidof( ID3D11Texture2D ),
                                                 ;                              (void--)&BackBuffer );

                                                 lea                 r9, BackBuffer                                    ; Set **ppSurface
                                                 lea                 r8, IID_ID3D11Texture2D                           ; Set riid
                                                 xor                 rdx, rdx                                          ; Set Buffer
                                                 mov                 rcx, SwapChain                                    ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             IDXGISwapChain_GetBuffer                          ; Get the buffer pointer

                                                 ;-----[----------------------------------------------------------------

                                                 ;-----> Error if RAX != 0

                                                 ;-----[Create our render target]---------------------------------------
                                                 ;
                                                 ; hr = d3d11Device->CreateRenderTargetView( BackBuffer, NULL, &renderTargetView );

                                                 lea                 r9, renderTargetView                              ; Set **ppRTView
                                                 xor                 r8, r8                                            ; Set *pDesc
                                                 mov                 rdx, BackBuffer                                   ; Set *pResource
                                                 mov                 rcx, d3d11Device                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11Device_CreateRenderTargetView, rcx, rdx, r8, r9

                                                 ;-----[Release the back buffer]----------------------------------------
                                                 ;
                                                 ; BackBuffer->Release();

                                                 mov                 rcx, BackBuffer                                   ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set vTable pointer
                                                 WinCall             ID3D11Texture2D_Release, rcx                      ; Execute call

                                                 ;-----[Release the back buffer]----------------------------------------

                                                 mov                 eax, client_rect.right                            ; Get the client width
                                                 mov                 depthStencilDesc._Width, eax                      ; Set width
                                                 mov                 eax, client_rect.bottom                           ; Get the client height
                                                 mov                 depthStencilDesc._Height, eax                     ; Set height

                                                 ;-----[Create the depth stencil buffer]--------------------------------
                                                 ;
                                                 ; d3d11Device->CreateTexture2D(&depthStencilDesc, NULL, &depthStencilBuffer);

                                                 lea                 r9, depthStencilBuffer                            ; Set
                                                 xor                 r8, r8                                            ; Set
                                                 lea                 rdx, depthStencilDesc                             ; Set
                                                 mov                 rcx, d3d11Device                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11Device_CreateTexture2D, rcx, rdx, r8, r9    ; Create the depth stencil buffer

                                                 ;-----[Create the depth stencil view]----------------------------------
                                                 ;
                                                 ; d3d11Device->CreateDepthStencilView(depthStencilBuffer, NULL, &depthStencilView);

                                                 lea                 r9, depthStencilView                              ; Set
                                                 xor                 r8, r8                                            ; Set
                                                 mov                 rdx, depthStencilBuffer                           ; set
                                                 mov                 rcx, d3d11Device                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11Device_CreateDepthStencilView, rcx, rdx, r8, r9

                                                 ;-----[Set the render target]------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->OMSetRenderTargets( 1, &renderTargetView, NULL );

                                                 xor                 r9, r9                                            ; Set *pDepthStencilView
                                                 lea                 r8, renderTargetView                              ; Set *ppRenderTargetViews
                                                 mov                 rdx, 1                                            ; Set NumViews
                                                 mov                 rcx, d3d11DevCon                                  ; Set interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_OMSetRenderTargets            ; Execute call

                                                 ;-----[Compile the vertex shader]--------------------------------------
                                                 ;
                                                 ; hr = D3DX11CompileFromFile(L"Effects.fx", 0, 0, "VS", "vs_4_0", 0, 0,
                                                 ;                              0, &VS_Buffer, 0, 0);

                                                 lea                 r13, VS_Buffer                                    ; Set **ppShader
                                                 lea                 r12, vs_profile                                   ; Set pProfile
                                                 lea                 r9, vs_Function                                   ; Set pFunctionName
                                                 xor                 r8, r8                                            ; Set pInclude
                                                 xor                 rdx, rdx                                          ; Set *pDefines
                                                 lea                 rcx, effect_file                                  ; Set pSrcFile
                                                 WinCall             D3DX11CompileFromFile, rcx, rdx, r8, r9, r12, 0, 0, 0, r13, 0, 0

                                                 ;-----[----------------------------------------------------------------

                                                 ;-----> Error if RAX != 0

                                                 ;-----[Compile the pixel shader]---------------------------------------

                                                 lea                 r13, PS_Buffer                                    ; Set **ppShader
                                                 lea                 r12, ps_profile                                   ; Set pProfile
                                                 lea                 r9, ps_Function                                   ; Set pFunctionName
                                                 xor                 r8, r8                                            ; Set pInclude
                                                 xor                 rdx, rdx                                          ; Set *pDefines
                                                 lea                 rcx, effect_file                                  ; Set pSrcFile
                                                 WinCall             D3DX11CompileFromFile, rcx, rdx, r8, r9, r12, 0, 0, 0, r13, 0, 0

                                                 ;-----[----------------------------------------------------------------

                                                 ;-----> Error if RAX != 0

                                                 ;-----[Create the vertex shader object]--------------------------------
                                                 ;
                                                 ; hr = d3d11Device->CreateVertexShader(VS_Buffer->GetBufferPointer(),
                                                 ;                                        VS_Buffer->GetBufferSize(),
                                                 ;                                        NULL, &VS);

                                                 mov                 rcx, VS_Buffer                                    ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the interface pointer
                                                 WinCall             ID3D10Blob_GetBufferPointer                       ; Get the buffer pointer
                                                 push                rax                                               ; Save the buffer pointer
                                                 mov                 vBufferPtr, rax                                   ; Save value for IASetInputLayout use

                                                 mov                 rcx, VS_Buffer                                    ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the interface pointer
                                                 WinCall             ID3D10Blob_GetBufferSize                          ; Get the buffer size
                                                 mov                 vBufferSize, rax                                  ; Save value for IASetInputLayout use

                                                 lea                 r12, vs                                           ; Set **ppVertexShader
                                                 xor                 r9, r9                                            ; Set *pClassLinkage
                                                 mov                 r8, rax                                           ; Set BytecodeLength
                                                 pop                 rdx                                               ; Set *pShaderBytecode
                                                 mov                 rcx, d3d11Device                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11Device_CreateVertexShader, rcx, rdx, r8, r9, r12

                                                 ;-----[----------------------------------------------------------------

                                                 ;-----> Error if RAX != 0

                                                 ;-----[Create the pixel shader object]---------------------------------
                                                 ;
                                                 ; hr = d3d11Device->CreatePixelShader(PS_Buffer->GetBufferPointer(), PS_Buffer->GetBufferSize(), NULL, &PS);

                                                 mov                 rcx, PS_Buffer                                    ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the interface pointer
                                                 WinCall             ID3D10Blob_GetBufferPointer                       ; Get the buffer pointer
                                                 push                rax                                               ; Save the buffer pointer

                                                 mov                 rcx, PS_Buffer                                    ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the interface pointer
                                                 WinCall             ID3D10Blob_GetBufferSize                          ; Get the buffer size

                                                 lea                 r12, ps                                           ; Set **ppVertexShader
                                                 xor                 r9, r9                                            ; Set *pClassLinkage
                                                 mov                 r8, rax                                           ; Set BytecodeLength
                                                 pop                 rdx                                               ; Set *pShaderBytecode
                                                 mov                 rcx, d3d11Device                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11Device_CreatePixelShader, rcx, rdx, r8, r9, r12

                                                 ;-----[----------------------------------------------------------------

                                                 ;-----> Error if RAX != 0

                                                 ;-----[Set the vertex shader]------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->VSSetShader(VS, 0, 0);

                                                 xor                 r9, r9                                            ; Set NumClassInstances
                                                 xor                 r8, r8                                            ; Set *ppClassInstances
                                                 mov                 rdx, VS                                           ; Set *pVertexShader
                                                 mov                 rcx, d3d11DevCon                                  ; Set interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_VSSetShader                   ; Execute call

                                                 ;-----[Set the pixel shader]-------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->PSSetShader(PS, 0, 0);

                                                 xor                 r9, r9                                            ; Set NumClassInstances
                                                 xor                 r8, r8                                            ; Set *ppClassInstances
                                                 mov                 rdx, PS                                           ; Set *pPixelShader
                                                 mov                 rcx, d3d11DevCon                                  ; Set interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_PSSetShader                   ; Execute call

                                                 ;-----[Create the vertex buffer object]--------------------------------
                                                 ;
                                                 ; D3D11_BUFFER_DESC vertexBufferDesc;
                                                 ; ZeroMemory( &vertexBufferDesc, sizeof(vertexBufferDesc) );
                                                 ;
                                                 ; vertexBufferDesc.Usage = D3D11_USAGE_DEFAULT;
                                                 ; vertexBufferDesc.ByteWidth = sizeof( Vertex ) * 3;
                                                 ; vertexBufferDesc.BindFlags = D3D11_BIND_VERTEX_BUFFER;
                                                 ; vertexBufferDesc.CPUAccessFlags = 0;
                                                 ; vertexBufferDesc.MiscFlags = 0;
                                                 ;
                                                 ; D3D11_SUBRESOURCE_DATA vertexBufferData;
                                                 ;
                                                 ; ZeroMemory( &vertexBufferData, sizeof(vertexBufferData) );
                                                 ; vertexBufferData.pSysMem = v;
                                                 ;
                                                 ; hr = d3d11Device->CreateBuffer( &vertexBufferDesc, &vertexBufferData,
                                                 ;                                   &triangleVertBuffer);

                                                 lea                 r9, triangleVertexBuffer                          ; Set **ppBuffer
                                                 lea                 r8, vertexBufferData                              ; Set *pInitialData
                                                 lea                 rdx, vertexBufferDesc                             ; Set *pDesc
                                                 mov                 rcx, d3d11Device                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11Device_CreateBuffer, rcx, rdx, r8, r9       ; Create the vertex buffer

                                                 ;-----[Set the vertex buffer]------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->IASetVertexBuffers( 0, 1, &triangleVertBuffer, &stride,
                                                 ;                                    &offset );

                                                 lea                 r13, offset_                                      ; Set *pOffsets
                                                 lea                 r12, stride                                       ; Set *pStrides
                                                 lea                 r9, triangleVertexBuffer                          ; Set *ppVertexBuffers
                                                 mov                 r8, 1                                             ; Set NumBuffers
                                                 xor                 rdx, rdx                                          ; Set StartSlot
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_IASetVertexBuffers, rcx, rdx, r8, r9, r12, r13

                                                 ;-----[Create the input layout]----------------------------------------
                                                 ;
                                                 ; hr = d3d11Device->CreateInputLayout( layout, numElements,
                                                 ;                                        VS_Buffer->GetBufferPointer(),
                                                 ;                                        VS_Buffer->GetBufferSize(),
                                                 ;                                        &vertLayout );

                                                 lea                 r13, vertLayout                                   ; Set **ppInputLayout
                                                 mov                 r12, vBufferSize                                  ; set BytecodeLength
                                                 mov                 r9, vBufferPtr                                    ; Set *pShaderBytecode
                                                 mov                 r8, numElements                                   ; Set Set numElements
                                                 lea                 rdx, layout                                       ; Set *pInputElementDescs
                                                 mov                 rcx, d3d11Device                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11Device_CreateInputLayout, rcx, rdx, r8, r9, r12, r13

                                                 ;-----[Set the input layout]-------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->IASetInputLayout( vertLayout );

                                                 mov                 rdx, vertLayout                                   ; Set *pInputLayout
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_IASetInputLayout, rcx, rdx    ; Set the input layout

                                                 ;-----[Set primitive topology]-----------------------------------------
                                                 ;
                                                 ; d3d11DevCon->IASetPrimitiveTopology( D3D11_PRIMITIVE_TOPOLOGY_TRIANGLELIST );

                                                 mov                 rdx, D3D11_PRIMITIVE_TOPOLOGY_TRIANGLELIST        ; Set Topology
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_IASetPrimitiveTopology, rcx, rdx

                                                 ;-----[Set the viewport structure]-------------------------------------
                                                 ;
                                                 ; XMM registers are used to convert integer values to floats.

                                                 vmovd               xmm0, dword ptr client_rect.right                 ; Load the client width
                                                 cvtdq2ps            xmm0, xmm0                                        ; Convert to floating point
                                                 movss               dword ptr viewport._Width, xmm0                   ; Store the viewport width

                                                 vmovd               xmm0, dword ptr client_rect.bottom                ; Load the client height
                                                 cvtdq2ps            xmm0, xmm0                                        ; Convert to floating point
                                                 movss               dword ptr viewport._Height, xmm0                  ; Store the viewport height

                                                 ;-----[Set the viewport]-----------------------------------------------
                                                 ;
                                                 ; d3d11DevCon->RSSetViewports(1, &viewport);

                                                 lea                 r8, viewport                                      ; Set *pViewPorts
                                                 mov                 rdx, 1                                            ; Set NumViewports
                                                 mov                 rcx, d3d11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_RSSetViewports, rcx, rdx, r8  ; Set the viewport

                                                 ;-----[Create the constant buffer]-------------------------------------
                                                 ;
                                                 ; hr = d3d11Device->CreateBuffer(&cbbd, NULL, &cbPerObjectBuffer);

                                                 lea                 r9, cbPerObjectBuffer                             ; Set **ppBuffer
                                                 xor                 r8, r8                                            ; Set *pInitialData
                                                 lea                 rdx, cbbd                                         ; Set *pDesc
                                                 mov                 rcx, d3d11Device                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11Device_CreateBuffer, rcx, rdx, r8, r9       ; Create the vertex buffer

                                                 ;-----[Set the view matrix]--------------------------------------------
                                                 ;
                                                 ; camView = XMMatrixLookAtLH( camPosition, camTarget, camUp );

                                                 lea                 r9, camUp                                         ; Set vUp
                                                 lea                 r8, camTarget                                     ; set vTarget
                                                 lea                 rdx, camPosition                                  ; Set vPosition
                                                 lea                 rcx, mView                                        ; Set undocumented mOut
                                                 WinCall             XMMatrixLookAtLHProxy, rcx, rdx, r8               ; Set the view matrix

                                                 ;-----[Set the projection matrix]--------------------------------------
                                                 ;
                                                 ; mProj = XMMatrixPerspectiveFovLH( 0.4f*3.14f, Width/Height, 1.0f, 1000.0f);

                                                 movss               xmm0, client_rect.right                           ; Get the client area width
                                                 cvtdq2ps            xmm0, xmm0                                        ; Convert value to float
                                                 movss               xmm1, client_rect.bottom                          ; Get the client area height
                                                 cvtdq2ps            xmm1, xmm1                                        ; Convert value to float
                                                 divps               xmm0, xmm1                                        ; Set width / height
                                                 movss               aspect_ratio, xmm0                                ; Store width / height

                                                 xor                 r12, r12                                          ; Zero R12
                                                 mov                 r12d, r1000                                       ; Set FarZ
                                                 movss               xmm3, r1                                          ; Set NearZ
                                                 movss               xmm2, aspect_ratio                                ; Set AspectRatio
                                                 movss               xmm1, p4pi                                        ; Set FovAngleY
                                                 lea                 rcx, mProj                                        ; Set undocumented mOut
                                                 WinCall             XMMatrixPerspectiveFovLHProxy, rcx, rdx, r8, r9, r12

                                                 ;-----[Create the rasterizer state]------------------------------------
                                                 ;
                                                 ; d3d11Device->CreateRasterizerState(&rasterizerDesc, &rasterizerState);

                                                 lea                 r8, rasterizerState                               ; Set *pRasterizerState
                                                 lea                 rdx, rasterizerDesc                               ; Set *pRasterizerDesc
                                                 mov                 rcx, D3D11Device                                  ; Get the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the interface pointer
                                                 WinCall             ID3D11Device_CreateRasterizerState, rcx, rdx, r8  ; Create the rasterizer state

                                                 ;-----[Disable backface culling]---------------------------------------
                                                 ;
                                                 ; d3d11DevCon->RSSetState(rasterizerState);

                                                 mov                 rdx, rasterizerState                              ; Set *pRasterizerState
                                                 mov                 rcx, D3D11DevCon                                  ; Set the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_RSSetState, rcx, rdx          ; Set the rasterizer state

;------[Restore incoming registers]-------------------------------------------------------------------------------------

                                                 align               qword                                             ; Set qword alignment
SetupDirectX_Exit:                               Restore_Registers                                                     ; Restore incoming registers

;------[Return to caller]-----------------------------------------------------------------------------------------------

                                                 ret                                                                   ; Return to caller

SetupDirectX                                     endp                                                                  ; End function



;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; SetupMainWindow                                                                                                      -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; In:  <No Parameters>                                                                                                 -
;                                                                                                                      -
; This function registers the window class MainWindowClass, creates the main window as a top level window of that      -
; class, and returns the new window handle in RAX.  RAX is returned as -1 if the function fails.                       -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------

SetupMainWindow                                  proc                                                                  ; Declare function

;------[Local Data]-----------------------------------------------------------------------------------------------------

                                                 local               holder:qword                                      ;

;------[Save incoming registers]----------------------------------------------------------------------------------------

                                                 Save_Registers                                                        ; Save incoming registers

                                                 ;-----[Register the window class]--------------------------------------
                                                 ;
                                                 ; The industry has fallen into a pattern of assigning values to the
                                                 ; WndClassEx structure dynamically through code.  This is a complete
                                                 ; waste when it comes to any value that is known at runtime.  In this
                                                 ; app that amounts to all values except 3.  Only those are assigned
                                                 ; here; the rest are hard-coded in the structures.asm file.

                                                 ;-----[Get the hInstance value for this app

                                                 xor                 rcx, rcx                                          ; Set lpModuleName
                                                 WinCall             GetModuleHandle, rcx                              ; Get this module handle in RAX
                                                 mov                 wnd_hInst, rax                                    ; Set the hInstance value

                                                 ;-----[Get the standard cursor handle]---------------------------------

                                                 xor                 r9, r9                                            ; Zero cxDesired
                                                 mov                 r8, image_cursor                                  ; Set uType
                                                 mov                 rdx, ocr_normal                                   ; Set lpszName
                                                 xor                 rcx, rcx                                          ; Zero hInstance
                                                 WinCall             LoadImage, rcx, rdx, r8, r9, 0, fu_load           ; Load the standard cursor handle
                                                 mov                 wnd_hCursor, rax                                  ; Set the cursor handle

                                                 ;-----[Get the small icon handle for this app]-------------------------

                                                 mov                 r9, 16                                            ; Set cxDesired
                                                 mov                 r8, image_icon                                    ; Set uType
                                                 lea                 rdx, i16_name                                     ; Set lpszName
                                                 mov                 rcx, wnd_hInst                                    ; Set hInstance

                                                 WinCall             LoadImage, rcx, rdx, r8, r9, 16, 0                ; Load the small icon handle
                                                 mov                 wnd_hIconSmall, rax                               ; Save the small icon handle

                                                 ;-----[Register the window class]--------------------------------------

                                                 lea                 rcx, wnd                                          ; Set lpwcx
                                                 WinCall             RegisterClassEx, rcx                              ; Register the window class

                                                 ;-----[Setup initial adjust rectangle]---------------------------------
                                                 ;
                                                 ; A 300 x 300 client area is going to be created.  The window has to be
                                                 ; properly sized such that a 300 x 300 client area is created with the
                                                 ; passed window size.  window_rect is initialized to 0, 0, 300, 300 and
                                                 ; passed to AdjustWindowRect, which adjusts the RECT structure to the
                                                 ; overall window size.  Since they both start at 0, .left and .top will
                                                 ; be negative after this call.  Subtracting .left from .right and set-
                                                 ; ting .left to 0 maintains the proper width but sets .left to 0.  Do
                                                 ; the same for height and window_rect is at 0, 0 for the proper width
                                                 ; and height, allowing the .right and .bottom fields to be used
                                                 ; directly as the final window width and height.

                                                 mov                 window_rect.right, client_width                   ; Set the initial right edge
                                                 mov                 window_rect.bottom, client_height                 ; Set the initial bottom edge

                                                 ;-----[Get window rect for 300 x 300 client]---------------------------

                                                 xor                 r8, r8                                            ; Set bMenu
                                                 mov                 rdx, main_style                                   ; Set dwStyle
                                                 lea                 rcx, window_rect                                  ; Set lprc
                                                 WinCall             AdjustWindowRect, rcx, rdx, r8                    ; Execute call

                                                 ;-----[Zero base the window rectangle]---------------------------------
                                                 ;
                                                 ; This allows .right and .bottom to be used directly as width and
                                                 ; height.

                                                 mov                 eax, window_rect.left                             ; Get the left edge
                                                 sub                 window_rect.right, eax                            ; Adjust the right edge
                                                 mov                 window_rect.left, 0                               ; Zero the left edge
                                                 mov                 eax, window_rect.top                              ; Get the top edge
                                                 sub                 window_rect.bottom, eax                           ; Adjust the bottom edge
                                                 mov                 window_rect.top, 0                                ; Zero the top edge

                                                 ;-----[Create the main window]-----------------------------------------

                                                 mov                 r14, wnd_hInst                                    ; Set hInstance

                                                 xor                 r9, r9                                            ; Set fWinIni
                                                 lea                 r8, work_rect                                     ; Set pvParam
                                                 xor                 rdx, rdx                                          ; Set uiParam
                                                 mov                 rcx, spi_getworkarea                              ; Set uiAction
                                                 WinCall             SystemParametersInfo, rcx, rdx, r8, r9            ; Get the monitor work area

                                                 xor                 r13, r13                                          ; Zero R13
                                                 mov                 r13d, window_rect.bottom                          ; Get the window height

                                                 xor                 r12, r12                                          ; Zero R12
                                                 mov                 r12d, window_rect.right                           ; Get the window width

                                                 xor                 rbx, rbx                                          ; Zero RBX
                                                 mov                 ebx, work_rect.right                              ; Get the work area width
                                                 sub                 ebx, window_rect.right                            ; Subtract the window width
                                                 shr                 rbx, 1                                            ; Cut in half for x = center

                                                 xor                 r15, r15                                          ; Zero R15
                                                 mov                 r15d, work_rect.bottom                            ; Get the work area height
                                                 sub                 r15d, window_rect.bottom                          ; Subtract the window height
                                                 shr                 r15, 1                                            ; Cut in half for y = center

                                                 mov                 r9, main_style
                                                 lea                 r8, main_winname                                  ; Set lpWindowName
                                                 lea                 rdx, main_classname                               ; Set lpClassName
                                                 xor                 rcx, rcx                                          ; Set dwExStyle
                                                 WinCall             CreateWindowEx, rcx, rdx, r8, r9, rbx, r15, r12, r13, 0, 0, r14, 0

                                                 ;-----[Display the window]---------------------------------------------

                                                 mov                 r15, rax                                          ; Sae the return value
                                                 mov                 rdx, sw_show                                      ; Set nCmdShow
                                                 mov                 rcx, rax                                          ; Set hWnd
                                                 WinCall             ShowWindow, rcx, rdx                              ; Display the window
                                                 mov                 rax, r15                                          ; Reset the return value

;------[Restore incoming registers]-------------------------------------------------------------------------------------

                                                 align               qword                                             ; Set qword alignment
SetupMainWindow_Exit:                            Restore_Registers                                                     ; Restore incoming registers

;------[Return to caller]-----------------------------------------------------------------------------------------------

                                                 ret                                                                   ; Return to caller

SetupMainWindow                                  endp                                                                  ; End function



;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; Shutdown                                                                                                             -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; In:  <No Parameters>                                                                                                 -
;                                                                                                                      -
; This function closes out everything that was opened including DirectX, Windows stuff, all of it.                     -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------

Shutdown                                         proc                                                                  ; Declare function

;------[Local Data]-----------------------------------------------------------------------------------------------------

                                                 local               holder:qword                                      ;

;------[Save incoming registers]----------------------------------------------------------------------------------------

                                                 Save_Registers                                                        ; Save incoming registers

                                                 ;------[Release the swap chain]----------------------------------------
                                                 ;
                                                 ; SwapChain->Release();

                                                 mov                 rcx, swapChain                                    ; Get the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             IDXGISwapChain_Release                            ; Execute call

                                                 ;------[Release the device]--------------------------------------------
                                                 ;
                                                 ; d3d11Device->Release();

                                                 mov                 rcx, d3d11Device                                  ; Get the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11Device_Release                              ; Execute call

                                                 ;------[Release the device context]------------------------------------
                                                 ;
                                                 ; d3d11DevCon->Release();

                                                 mov                 rcx, d3d11DevCon                                  ; Get the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DeviceContext_Release                       ; Execute call

                                                 ;------[Release the render target view]--------------------------------
                                                 ;
                                                 ; renderTargetView->Release();

                                                 mov                 rcx, renderTargetView                             ; Get the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11RenderTargetView_Release                    ; Execute call

                                                 ;------[Release the vertex buffer]-------------------------------------
                                                 ;
                                                 ; TriangleVertexBuffer->Release();

                                                 mov                 rcx, TriangleVertexBuffer                         ; Get the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11Buffer_Release                              ; Execute call

                                                 ;------[Release the vertex shader]-------------------------------------
                                                 ;
                                                 ; VS->Release();

                                                 mov                 rcx, VS                                           ; Get the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11VertexShader_Release                        ; Execute call

                                                 ;------[Release the pixel shader]--------------------------------------
                                                 ;
                                                 ; PS->Release();

                                                 mov                 rcx, PS                                           ; Get the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11PixelShader_Release                         ; Execute call

                                                 ;------[Release the vertex shader buffer]------------------------------
                                                 ;
                                                 ; VS_Buffer->Release();

                                                 mov                 rcx, VS_Buffer                                    ; Get the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11Buffer_Release                              ; Execute call

                                                 ;------[Release the pixel shader buffer]-------------------------------
                                                 ;
                                                 ; PS_Buffer->Release();

                                                 mov                 rcx, PS_Buffer                                    ; Get the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11Buffer_Release                              ; Execute call

                                                 ;------[Release the layout]--------------------------------------------
                                                 ;
                                                 ; vertLayout->Release();

                                                 mov                 rcx, vertLayout                                   ; Get the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11InputLayout_Release                         ; Execute call

                                                 ;------[Release the depth stencil view]--------------------------------
                                                 ;
                                                 ; depthStencilView->Release();

                                                 mov                 rcx, depthStencilView                             ; Get the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11DepthStencilView_Release                    ; Execute call

                                                 ;------[Release the depth stencil buffer]------------------------------
                                                 ;
                                                 ; depthStencilBuffer->Release();

                                                 mov                 rcx, depthStencilBuffer                           ; Get the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11Buffer_Release                              ; Execute call

                                                 ;------[Release the constant buffer]-----------------------------------
                                                 ;
                                                 ; cbPerObjectBuffer->Release();

                                                 mov                 rcx, cbPerObjectBuffer                            ; Get the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11Buffer_Release                              ; Execute call

                                                 ;------[Release the rasterizer state]----------------------------------
                                                 ;
                                                 ; rasterizerState->Release();

                                                 mov                 rcx, rasterizerState                              ; Get the interface pointer
                                                 mov                 rbx, [ rcx ]                                      ; Set the vTable pointer
                                                 WinCall             ID3D11RasterizerState_Release                     ; Execute call

                                                 ;------[Unregister the main window class]------------------------------

                                                 mov                 rdx, wnd_hInst                                    ; Set hInstance
                                                 lea                 rcx, main_classname                               ; Set lpClassName
                                                 WinCall             UnregisterClass, rcx, rdx                         ; Execute call

;------[Restore incoming registers]-------------------------------------------------------------------------------------

                                                 align               qword                                             ; Set qword alignment
Shutdown_Exit:                                   Restore_Registers                                                     ; Restore incoming registers

;------[Return to caller]-----------------------------------------------------------------------------------------------

                                                 ret                                                                   ; Return to caller

Shutdown                                         endp                                                                  ; End function



;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; UpdateScene                                                                                                          -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; In:  <No Parameters>                                                                                                 -
;                                                                                                                      -
; This function updates the scene geometry and performes any other per-render updates required.                        -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------

UpdateScene                                      proc                                                                  ; Declare function

;------[Local Data]-----------------------------------------------------------------------------------------------------

                                                 local               holder:qword                                      ;

;------[Save incoming registers]----------------------------------------------------------------------------------------

                                                 Save_Registers                                                        ; Save incoming registers

                                                 ;------[---------------------------------------------------------------
                                                 ;------[---------------------------------------------------------------
                                                 ;------[---------------------------------------------------------------
                                                 ;------[---------------------------------------------------------------
                                                 ;------[---------------------------------------------------------------
                                                 ;------[---------------------------------------------------------------
                                                 ;------[---------------------------------------------------------------
                                                 ;------[---------------------------------------------------------------
                                                 ;------[---------------------------------------------------------------
                                                 ;------[---------------------------------------------------------------
                                                 ;------[---------------------------------------------------------------
                                                 ;------[---------------------------------------------------------------

;------[Restore incoming registers]-------------------------------------------------------------------------------------

                                                 align               qword                                             ; Set qword alignment
UpdateScene_Exit:                                Restore_Registers                                                     ; Restore incoming registers

;------[Return to caller]-----------------------------------------------------------------------------------------------

                                                 ret                                                                   ; Return to caller

UpdateScene                                      endp                                                                  ; End function

