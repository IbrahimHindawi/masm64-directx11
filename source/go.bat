@echo off

rem Set this value to the location of rc.exe under the VC directory
set rc_directory="C:\Program Files (x86)\Windows Kits\10\bin\x86

rem Set this value to the location of ml64.exe under the VC directory
set ml_directory="C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin\x86_amd64

rem Set this value to the location of link.exe under the VC directory
set link_directory="C:\Program Files (x86)\Microsoft Visual Studio 14.0\VC\bin

%rc_directory%\rc.exe" resource.rc
%ml_directory%\ml64.exe" /c /Cp /Cx /Fm /FR /W2 /Zd /Zf /Zi /Ta DXSample.asm > errors.txt
%link_directory%\link.exe" DXSample.obj resource.res /debug:none /opt:ref /opt:noicf /largeaddressaware:no /def:DXSample.def /entry:Startup /machine:x64 /map /out:DXSample.exe /PDB:DXSample.pdb /subsystem:windows,6.0 "C:\Program Files (x86)\Windows Kits\10\Lib\10.0.10586.0\um\x64\kernel32.lib" "C:\Program Files (x86)\Windows Kits\10\Lib\10.0.10586.0\um\x64\user32.lib" "C:\Program Files (x86)\Microsoft DirectX SDK (August 2009)\Lib\x64\d3d11.lib" "C:\Program Files (x86)\Microsoft DirectX SDK (August 2009)\Lib\x64\d3dx11.lib" DXSampleMath.lib

type errors.txt
