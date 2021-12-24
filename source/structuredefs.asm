
;-----------------------------------------------------------------------------------------------------------------------
;                                                                                                                      -
; Structure definitions.                                                                                               -
;                                                                                                                      -
;-----------------------------------------------------------------------------------------------------------------------

point                                            struct                                                                ; Declare structure
                                                ;-----------------------------------------------------------------------
x                                                dword               ?                                                 ;
y                                                dword               ?                                                 ;
                                                ;-----------------------------------------------------------------------
point                                            ends                                                                  ; End structure declaration

;-----[A]---------------------------------------------------------------------------------------------------------------

;-----[B]---------------------------------------------------------------------------------------------------------------

;-----[C]---------------------------------------------------------------------------------------------------------------

;-----[D]---------------------------------------------------------------------------------------------------------------

dxgi_sample_desc                                 struct                                                                ; Declare structure
                                                ;-----------------------------------------------------------------------
count                                            dword               ?                                                 ;
quality                                          dword               ?                                                 ;
                                                ;-----------------------------------------------------------------------
dxgi_sample_desc                                 ends                                                                  ; End structure declaration

d3d11_buffer_desc                                struct                                                                ; Declare structure
                                                ;-----------------------------------------------------------------------
ByteWidth                                        dword               ?                                                 ;
Usage                                            dword               ?                                                 ;
BindFlags                                        dword               ?                                                 ;
CPUAccessFlags                                   dword               ?                                                 ;
MiscFlags                                        dword               ?                                                 ;
StructureByteStride                              dword               ?                                                 ;
                                                ;-----------------------------------------------------------------------
d3d11_buffer_desc                                ends                                                                  ; End structure declaration

d3d11_input_element_desc                         struct                                                                ; Declare structure
                                                ;-----------------------------------------------------------------------
SemanticName                                     qword               ?                                                 ;
SemanticIndex                                    dword               ?                                                 ;
Format                                           dword               ?                                                 ;
InputSlot                                        dword               ?                                                 ;
AlignedByteOffset                                dword               ?                                                 ;
InputSlotClass                                   dword               ?                                                 ;
InstanceDataStepRate                             dword               ?                                                 ;
                                                ;-----------------------------------------------------------------------
d3d11_input_element_desc                         ends                                                                  ; End structure declaration

d3d11_rasterizer_desc                            struct                                                                ; Declare structure
                                                ;-----------------------------------------------------------------------
FillMode                                         dword               ?                                                 ;
CullMode                                         dword               ?                                                 ;
FrontCounterClockwise                            dword               ?                                                 ;
DepthBias                                        dword               ?                                                 ;
DepthBiasClamp                                   real4               0.0                                               ;
SlopeScaledDepthBias                             real4               0.0                                               ;
DepthClipEnable                                  dword               ?                                                 ;
ScissorEnable                                    dword               ?                                                 ;
MultisampleEnable                                dword               ?                                                 ;
AntialiasedLineEnable                            dword               ?                                                 ;
                                                ;-----------------------------------------------------------------------
d3d11_rasterizer_desc                            ends                                                                  ; End structure declaration

d3d11_subresource_data                           struct                                                                ; Declare structure
                                                ;-----------------------------------------------------------------------
pSysMem                                          qword               ?                                                 ;
SysMemPitch                                      dword               ?                                                 ;
SysMemSlicePitch                                 dword               ?                                                 ;
                                                ;-----------------------------------------------------------------------
d3d11_subresource_data                           ends                                                                  ; End structure declaration

d3d11_texture2d_desc                             struct                                                                ;
                                                ;-----------------------------------------------------------------------
_Width                                           dword               ?                                                 ;
_Height                                          dword               ?                                                 ;
MipLevels                                        dword               ?                                                 ;
ArraySize                                        dword               ?                                                 ;
Format                                           dword               ?                                                 ;
SampleDesc                                       dxgi_sample_desc    <>                                                ;
Usage                                            dword               ?                                                 ;
BindFlags                                        dword               ?                                                 ;
CPUAccessFlags                                   dword               ?                                                 ;
MiscFlags                                        dword               ?                                                 ;
                                                ;-----------------------------------------------------------------------
d3d11_texture2d_desc                             ends                                                                  ;


d3d11_viewport                                   struct                                                                ;
                                                ;-----------------------------------------------------------------------
TopLeftX                                         real4               0.0                                               ;
TopLeftY                                         real4               0.0                                               ;
_Width                                           real4               0.0                                               ;
_Height                                          real4               0.0                                               ;
MinDepth                                         real4               0.0                                               ;
MaxDepth                                         real4               0.0                                               ;
                                                ;-----------------------------------------------------------------------
d3d11_viewport                                   ends                                                                  ;

dxgi_rational                                    struct                                                                ; Declare structure
                                                ;-----------------------------------------------------------------------
numerator                                        dword               ?                                                 ;
denominator                                      dword               ?                                                 ;
                                                ;-----------------------------------------------------------------------
dxgi_rational                                    ends                                                                  ; End structure declaration

dxgi_mode_desc                                   struct                                                                ; Declare structure
                                                ;-----------------------------------------------------------------------
_Width                                           dword               ?                                                 ;
_Height                                          dword               ?                                                 ;
RefreshRate                                      dxgi_rational       <>                                                ;
Format                                           dword               ?                                                 ;
ScanlineOrdering                                 dword               ?                                                 ;
Scaling                                          dword               ?                                                 ;
                                                ;-----------------------------------------------------------------------
dxgi_mode_desc                                   ends                                                                  ; End structure declaration

dxgi_swap_chain_desc                             struct                                                                ; Declare structure
                                                ;-----------------------------------------------------------------------
BufferDesc                                       dxgi_mode_desc      <>                                                ;
SampleDesc                                       dxgi_sample_desc    <>                                                ;
BufferUsage                                      dword               ?                                                 ;
BufferCount                                      qword               ?                                                 ;
OutputWindow                                     qword               ?                                                 ;
Windowed                                         dword               ?                                                 ;
SwapEffect                                       dword               ?                                                 ;
Flags                                            qword               ?                                                 ;
                                                ;-----------------------------------------------------------------------
dxgi_swap_chain_desc                             ends                                                                  ; End structure declaration

;-----[E]---------------------------------------------------------------------------------------------------------------

;-----[F]---------------------------------------------------------------------------------------------------------------

;-----[G]---------------------------------------------------------------------------------------------------------------

;-----[H]---------------------------------------------------------------------------------------------------------------

;-----[I]---------------------------------------------------------------------------------------------------------------

;-----[J]---------------------------------------------------------------------------------------------------------------

;-----[K]---------------------------------------------------------------------------------------------------------------

;-----[L]---------------------------------------------------------------------------------------------------------------

;-----[M]---------------------------------------------------------------------------------------------------------------

msg                                              struct                                                                ; Declare structure
                                                ;-----------------------------------------------------------------------
hwnd                                             qword               ?                                                 ;
message                                          dword               ?                                                 ;
wparamx                                          qword               ?                                                 ;
lparam                                           qword               ?                                                 ;
time                                             qword               ?                                                 ;
pt                                               point               <>                                                ;
extra                                            qword               ?                                                 ;
                                                ;-----------------------------------------------------------------------
msg                                              ends                                                                  ; End structure declaration

;-----[N]---------------------------------------------------------------------------------------------------------------

;-----[O]---------------------------------------------------------------------------------------------------------------

;-----[P]---------------------------------------------------------------------------------------------------------------

;-----[Q]---------------------------------------------------------------------------------------------------------------

;-----[R]---------------------------------------------------------------------------------------------------------------

rect                                             struct                                                                ; Declare structure
                                                ;-----------------------------------------------------------------------
left                                             dword               ?                                                 ; Left edge
top                                              dword               ?                                                 ; Top edge
right                                            dword               ?                                                 ; Right edge
bottom                                           dword               ?                                                 ; Bottom edge
                                                ;-----------------------------------------------------------------------
rect                                             ends                                                                  ; End structure declaration

;-----[S]---------------------------------------------------------------------------------------------------------------

;-----[T]---------------------------------------------------------------------------------------------------------------

;-----[U]---------------------------------------------------------------------------------------------------------------

;-----[V]---------------------------------------------------------------------------------------------------------------

vertex                                           struct                                                                ; Declare structure
                                                ;-----------------------------------------------------------------------
x                                                real4               0.0                                               ;
y                                                real4               0.0                                               ;
z                                                real4               0.0                                               ;
cr                                               real4               0.0                                               ;
cg                                               real4               0.0                                               ;
cb                                               real4               0.0                                               ;
ca                                               real4               0.0                                               ;
                                                ;-----------------------------------------------------------------------
vertex                                           ends                                                                  ; End structure declaration

;-----[W]---------------------------------------------------------------------------------------------------------------

WndClassEx                                       struct                                                                ; Declare structure
                                                ;-----------------------------------------------------------------------
cbSize                                           dword               sizeof ( wndclassex )                             ; Size of this structure
dwStyle                                          dword               ?                                                 ; Style dword
lpfnCallback                                     qword               ?                                                 ; Window procedure pointer
cbClsExtra                                       dword               ?                                                 ; Extra class bytes
cbWndExtra                                       dword               ?                                                 ; Extra window bytes
hInst                                            qword               ?                                                 ; Instance handle
hIconx                                           qword               ?                                                 ; Icon handle
hCursorx                                         qword               ?                                                 ; Cursor handle
hbrBackground                                    qword               ?                                                 ; Background brush handle
lpszMenuName                                     qword               ?                                                 ; Menu name pointer
lpszClassName                                    qword               ?                                                 ; Class name pointer
hIconSm                                          qword               ?                                                 ; Small icon handle
                                                ;-----------------------------------------------------------------------
WndClassEx                                       ends                                                                  ; End structure declaration

;-----[X]---------------------------------------------------------------------------------------------------------------

XMMatrix                                         struct                                                                ; Declare structure
                                                ;-----------------------------------------------------------------------
                                                 real4               16 dup ( 0.0 )                                    ; XMMatrix
                                                ;-----------------------------------------------------------------------
XMMatrix                                         ends                                                                  ; End structure declaration

;-----[Y]---------------------------------------------------------------------------------------------------------------

;-----[Z]---------------------------------------------------------------------------------------------------------------

