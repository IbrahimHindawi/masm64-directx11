@echo off

rem Set this value to the location of rc.exe under the VC directory
rem set rc_directory="C:\Program Files (x86)\Windows Kits\10\bin\x86"
rem C:\Program Files (x86)\Windows Kits\10\Lib\10.0.19041.0\um\x64 
set rc_directory="C:\Program Files (x86)\Windows Kits\10\bin\10.0.19041.0\x64

rem Set this value to the location of ml64.exe under the VC directory
rem set ml_directory="C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\x86_amd64
set ml_directory="C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\VC\Tools\MSVC\14.29.30133\bin\Hostx64\x64

rem Set this value to the location of link.exe under the VC directory
rem set link_directory="C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin"
set link_directory="C:\Program Files (x86)\Microsoft Visual Studio\2019\Professional\VC\Tools\MSVC\14.29.30133\bin\Hostx64\x64

%rc_directory%\rc.exe" resource.rc
%ml_directory%\ml64.exe" /c /Cp /Cx /Fm /FR /W2 /Zd /Zf /Zi /Ta DXSample.asm > errors.txt
%link_directory%\link.exe" DXSample.obj resource.res /debug:none /opt:ref /opt:noicf /largeaddressaware:no /def:DXSample.def /entry:Startup /machine:x64 /map /out:DXSample.exe /PDB:DXSample.pdb /subsystem:windows,6.0 "C:\Program Files (x86)\Windows Kits\10\Lib\10.0.19041.0\um\x64\kernel32.lib" "C:\Program Files (x86)\Windows Kits\10\Lib\10.0.19041.0\um\x64\user32.lib" "C:\Program Files (x86)\Microsoft DirectX SDK (June 2010)\Lib\x64\d3d11.lib" "C:\Program Files (x86)\Microsoft DirectX SDK (June 2010)\Lib\x64\d3dx11.lib" DXSampleMath.lib

type errors.txt
