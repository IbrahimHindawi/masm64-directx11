
;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; Data structure declarations.                                                                                         -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------

;-----[A]---------------------------------------------------------------------------------------------------------------

;-----[B]---------------------------------------------------------------------------------------------------------------

bgColor                                          real4               4 dup ( 0.0 )                                     ; Background clear color: black

;-----[C]---------------------------------------------------------------------------------------------------------------

                                                 align               16                                                ; Set xmm word alignment
camPosition                                      real4               0.0, 0.0, -1.5, 0.0                               ; Eye
camTarget                                        real4               0.0, 0.0,  0.0, 0.0                               ; LookAt
camUp                                            real4               0.0, 1.0,  0.0, 0.0                               ; Up

cbPerObj                                         real4               16 dup ( 0.0 )                                    ; Constant buffer

cbbd                                             label               d3d11_buffer_desc                                 ; Declare structure label
                                                ;-----------------------------------------------------------------------
                                                 dword               sizeof ( XMMatrix )                               ; ByteWidth
                                                 dword               D3D11_USAGE_DEFAULT                               ; Usage
                                                 dword               D3D11_BIND_CONSTANT_BUFFER                        ; BindFlags
                                                 dword               0                                                 ; CPUAccessFlags
                                                 dword               0                                                 ; MiscFlags
                                                 dword               0                                                 ; StructureByteStride                                                           <----- source has this @ 0

client_rect                                      rect                <>                                                ; Main window client area

;-----[D]---------------------------------------------------------------------------------------------------------------

depthStencilDesc                                 label               d3d11_texture2d_desc                              ; Declare structure label
                                                ;-----------------------------------------------------------------------
                                                 dword               ?                                                 ; _Width
                                                 dword               ?                                                 ; _Height
                                                 dword               1                                                 ; MipLevels
                                                 dword               1                                                 ; ArraySize
                                                 dword               DXGI_FORMAT_D24_UNORM_S8_UINT                     ; Format
                                                 dword               1                                                 ; SampleDesc.count
                                                 dword               0                                                 ; SampleDesc.quality
                                                 dword               D3D11_USAGE_DEFAULT                               ; Usage
                                                 dword               D3D11_BIND_DEPTH_STENCIL                          ; BindFlags
                                                 dword               0                                                 ; CPUAccessFlags
                                                 dword               0                                                 ; MiscFlags

;-----[E]---------------------------------------------------------------------------------------------------------------

;-----[F]---------------------------------------------------------------------------------------------------------------

;-----[G]---------------------------------------------------------------------------------------------------------------

;-----[H]---------------------------------------------------------------------------------------------------------------

;-----[I]---------------------------------------------------------------------------------------------------------------

;-----[J]---------------------------------------------------------------------------------------------------------------

;-----[K]---------------------------------------------------------------------------------------------------------------

;-----[L]---------------------------------------------------------------------------------------------------------------

layout                                           label               d3d11_input_element_desc                          ;
                                                ;-----------------------------------------------------------------------
                                                 qword               position_string                                   ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               DXGI_FORMAT_R32G32B32_FLOAT                       ; Format
                                                 dword               0                                                 ; InputSlot
                                                 dword               0                                                 ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_VERTEX_DATA                       ; InputSlotClass
                                                 dword               0                                                 ; InstanceDataStepRate
                                                ;-----------------------------------------------------------------------
                                                 qword               color_string                                      ; SemanticName
                                                 dword               0                                                 ; SemanticIndex
                                                 dword               DXGI_FORMAT_R32G32B32A32_FLOAT                    ; Format
                                                 dword               0                                                 ; InputSlot
                                                 dword               12                                                ; AlignedByteOffset
                                                 dword               D3D11_INPUT_PER_VERTEX_DATA                       ; InputSlotClass
                                                 dword               0                                                 ; InstanceDataStepRate
                                                ;-----------------------------------------------------------------------
layout_E                                         label               byte                                              ; End of array marker

;-----[M]---------------------------------------------------------------------------------------------------------------

                                                 align               16                                                ; Set xmm word alignment
mProj                                            real4               16 dup ( 0.0 )                                    ; Projection matrix
mView                                            real4               16 dup ( 0.0 )                                    ; View matrix

mWorld                                           real4               1.0, 0.0, 0.0, 0.0                                ; World matrix row 1
                                                 real4               0.0, 1.0, 0.0, 0.0                                ; World matrix row 2
                                                 real4               0.0, 0.0, 1.0, 0.0                                ; World matrix row 3
                                                 real4               0.0, 0.0, 0.0, 1.0                                ; World matrix row 4

mWVP                                             real4               16 dup ( 0.0 )                                    ; World * view * projection

;-----[N]---------------------------------------------------------------------------------------------------------------

;-----[O]---------------------------------------------------------------------------------------------------------------

;-----[P]---------------------------------------------------------------------------------------------------------------

;-----[Q]---------------------------------------------------------------------------------------------------------------

;-----[R]---------------------------------------------------------------------------------------------------------------

rasterizerDesc                                   label               D3D11_RASTERIZER_DESC                             ; Declare structure label
                                                ;-----------------------------------------------------------------------
                                                 dword               D3D11_FILL_SOLID                                  ; FillMode
                                                 dword               D3D11_CULL_NONE                                   ; CullMode
                                                 dword               0                                                 ; FrontCounterClockwise
                                                 real4               0.0                                               ; DepthBiasClamp
                                                 real4               0.0                                               ; SlopeScaledDepthBias
                                                 dword               1                                                 ; DepthClipEnable
                                                 dword               0                                                 ; ScissorEnable
                                                 dword               0                                                 ; MultisampleEnable
                                                 dword               0                                                 ; AntialiasedLineEnable

;-----[S]---------------------------------------------------------------------------------------------------------------

swapChainDesc                                    label               dxgi_swap_chain_desc                              ; Declare structure label
                                                ;-----------------------------------------------------------------------
                                                 dword               ?                                                 ; dxgi_swap_chain_desc.BufferDesc._Width
                                                 dword               ?                                                 ; dxgi_swap_chain_desc.BufferDesc._Height
                                                 dword               60                                                ; dxgi_swap_chain_desc.BufferDesc.RefreshRate.numerator
                                                 dword               1                                                 ; dxgi_swap_chain_desc.BufferDesc.RefreshRate.denominator
                                                 dword               DXGI_FORMAT_R8G8B8A8_UNORM                        ; dxgi_swap_chain_desc.BufferDesc.Format
                                                 dword               DXGI_MODE_SCANLINE_ORDER_UNSPECIFIED              ; dxgi_swap_chain_desc.BufferDesc.ScanlineOrdering
                                                 dword               DXGI_MODE_SCALING_UNSPECIFIED                     ; dxgi_swap_chain_desc.BufferDesc.Scaling
                                                 dword               1                                                 ; dxgi_swap_chain_desc.SampleDesc.Count
                                                 dword               0                                                 ; dxgi_swap_chain_desc.SampleDesc.Quality
                                                 dword               DXGI_USAGE_RENDER_TARGET_OUTPUT                   ; dxgi_swap_chain_desc.BufferUsage
                                                 qword               1                                                 ; dxgi_swap_chain_desc.BufferCount
                                                 qword               ?                                                 ; dxgi_swap_chain_desc.OutputWindow
                                                 dword               1                                                 ; dxgi_swap_chain_desc.Windowed
                                                 dword               DXGI_SWAP_EFFECT_DISCARD                          ; dxgi_swap_chain_desc.SwapEffect
                                                 qword               0                                                 ; dxgi_swap_chain_desc.Flags

;-----[T]---------------------------------------------------------------------------------------------------------------

;-----[U]---------------------------------------------------------------------------------------------------------------

;-----[V]---------------------------------------------------------------------------------------------------------------

v                                                vertex              <  0.0,  0.5, 0.0, 1.0, 0.0, 0.0, 1.0 >           ;
                                                 vertex              <  0.5, -0.5, 0.0, 0.0, 1.0, 0.0, 1.0 >           ;
                                                 vertex              < -0.5, -0.5, 0.0, 0.0, 0.0, 1.0, 1.0 >           ;

vertexBufferData                                 label               d3d11_subresource_data                            ; Declare structure label
                                                ;-----------------------------------------------------------------------
                                                 qword               v                                                 ; pSysMem
                                                 dword               ?                                                 ; SysMemPitch
                                                 dword               ?                                                 ; SysMemSlicePitch
                                                ;-----------------------------------------------------------------------
vertexBufferDataE                                label               byte                                              ; End marker

vertexBufferDesc                                 label               d3d11_buffer_desc                                 ; Declare structure label
                                                ;-----------------------------------------------------------------------
                                                 dword               sizeof ( vertex ) * 3                             ; ByteWidth
                                                 dword               D3D11_USAGE_DEFAULT                               ; Usage
                                                 dword               D3D11_BIND_VERTEX_BUFFER                          ; BindFlags
                                                 dword               0                                                 ; CPUAccessFlags
                                                 dword               0                                                 ; MiscFlags
                                                 dword           0 ; sizeof ( vertex )                                 ; StructureByteStride                                                           <----- source has this @ 0

viewport                                         label               d3d11_viewport                                    ; Declare structure label
                                                ;-----------------------------------------------------------------------
                                                 real4               0.0                                               ; TopLeftX
                                                 real4               0.0                                               ; TopLeftY
                                                 real4               0.0                                               ; _Width
                                                 real4               0.0                                               ; _Height
                                                 real4               0.0                                               ; MinDepth
                                                 real4               0.0                                               ; MaxDepth


;-----[W]---------------------------------------------------------------------------------------------------------------

window_rect                                      rect                <>                                                ;

wnd                                              label               wndclassex                                        ; Declare structure label
                                                ;-----------------------------------------------------------------------
                                                 dword               sizeof ( wndclassex )                             ; cbSize
                                                 dword               classStyle                                        ; dwStyle
                                                 qword               Main_CB                                           ; lpfnCallback
                                                 dword               0                                                 ; cbClsExtra
                                                 dword               0                                                 ; cbWndExtra
wnd_hinst                                        qword               ?                                                 ; hInst
                                                 qword               0                                                 ; hIcon
wnd_hCursor                                      qword               ?                                                 ; hCursor
                                                 qword               0                                                 ; hbrBackground
                                                 qword               0                                                 ; lpszMenuName
                                                 qword               main_classname                                    ; lpszClassName
wnd_hIconSmall                                   qword               ?                                                 ; hIconSm

work_rect                                        rect                <>                                                ; General work rectangle

;-----[X]---------------------------------------------------------------------------------------------------------------

;-----[Y]---------------------------------------------------------------------------------------------------------------

;-----[Z]---------------------------------------------------------------------------------------------------------------
