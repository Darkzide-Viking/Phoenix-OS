:: XXX-Man@4pda.ru # http://4pda.ru/forum/index.php?showuser=1419506 # http://forum.xda-developers.com/member.php?u=5078631

@ECHO off
TITLE PhoenixOS ToolBox
color 17

set WORKINGDIR=""
set WORKINGDIR=%~dp0
set in=%WORKINGDIR%in\
set out=%WORKINGDIR%out\
set unpack=%WORKINGDIR%unpack\
set tools=%WORKINGDIR%tools\
set imgextractor="%WORKINGDIR%\tools\imgextractor.exe"
set system-sfs="%WORKINGDIR%\in\system.sfs"
set system-img="%WORKINGDIR%\in\system.img"

:MENU
CLS
cd %WORKINGDIR%
ECHO.=========================================
ECHO.=     PhoenixOS ToolBox by XXX-Man      =
ECHO.=             version 2.10              =
ECHO.=========================================
ECHO.=========================================
ECHO.=         1. Unpack system.sfs          =
ECHO.=         2. Unpack system.img          =
ECHO.=         3. Root system image          =
ECHO.=         4. Repack system.img          =
ECHO.=         5. Repack system.sfs          =
ECHO.=  6. Create ISO image with system.img  =
ECHO.=  7. Create ISO image with system.sfs  =
ECHO.=         8. Clear /unpack dir          =
ECHO.=           9. Clear /out dir           =
ECHO.=========================================
ECHO.=       10. Create empty data.img       =
ECHO.=       11. Resize your  data.img       =
ECHO.=========================================
ECHO.=                0. Exit                =
ECHO.=========================================
ECHO.

:CHOICE_1
set choice_1=
set /p choice_1=Your choice: 
if /i "%choice_1%"=="1" goto UNPACK-SFS
if /i "%choice_1%"=="2" goto UNPACK-IMG
if /i "%choice_1%"=="3" goto ROOT
if /i "%choice_1%"=="4" goto REPACK-IMG
if /i "%choice_1%"=="5" goto REPACK-SFS
if /i "%choice_1%"=="6" goto MAKE-ISO-IMG
if /i "%choice_1%"=="7" goto MAKE-ISO-SFS
if /i "%choice_1%"=="8" goto CLEAR-UNPACK
if /i "%choice_1%"=="9" goto CLEAR-OUT
if /i "%choice_1%"=="10" goto CREATE-DATA
if /i "%choice_1%"=="11" goto RESIZE-DATA
if /i "%choice_1%"=="0" goto EXIT
goto MENU

:UNPACK-SFS
CLS
ECHO.=========================================
ECHO.=          Unpacking system.sfs         =
ECHO.=             Please wait...            =
ECHO.=========================================
IF EXIST %system-sfs% (
"%tools%7z" e "%system-sfs%" -o%in% -r > nul
) ELSE (
  ECHO.
  ECHO.                  Error
  ECHO.Please copy system.sfs into the/in folder
goto DONE-1
)
ECHO.
ECHO.=========================================
ECHO.=Done. System.img is into the /in folder=
ECHO.=========================================
ECHO.
pause
goto MENU

:UNPACK-IMG
CLS
ECHO.=========================================
ECHO.=          Unpacking system.img         =
ECHO.=             Please wait...            =
ECHO.=========================================
cd %in%
IF EXIST %system-img% (
"%imgextractor%" system.img %unpack%\system > nul
copy %unpack%system_statfile.txt %unpack%fs_config.txt > nul
del /q %unpack%system_statfile.txt
) ELSE (
  ECHO.
  ECHO.                  Error
  ECHO.Please copy system.img into the/in folder
  goto DONE-1
)
ECHO.
ECHO.=========================================
ECHO.=    Done. Please check /unpack dir.    =
ECHO.=         Now you can modify it         =
ECHO.=========================================
ECHO.
pause
goto MENU

:ROOT
CLS
ECHO.=========================================
ECHO.=  Rooting system with SuperSU 2.78 Pro =
ECHO.=             Please wait...            =
ECHO.=========================================
cd %in%
IF NOT EXIST %unpack%system (
ECHO.
ECHO.                  Error
ECHO.     Please unpack system.img first
goto DONE-1
) ELSE (
	IF NOT EXIST %unpack%system\fake-libs64 (
	ECHO.
	ECHO.Android x86 detected.Rooting with x86 bin
	"%tools%7z" x "%tools%Root-x86.zip" -y -o%unpack%system -r > nul
	echo system/app/SuperSU 0 0 755>>%unpack%fs_config.txt
	echo system/app/SuperSU/SuperSU.apk 0 0 644>>%unpack%fs_config.txt
	echo system/app/SuperSUkey 0 0 755>>%unpack%fs_config.txt
	echo system/app/SuperSUkey/SuperSUkey.apk 0 0 644>>%unpack%fs_config.txt
	echo system/bin/.ext 0 0 755>>%unpack%fs_config.txt
	echo system/bin/.ext/.su 0 0 755>>%unpack%fs_config.txt
	echo system/bin/install-recovery.sh 0 0 755>>%unpack%fs_config.txt
	echo system/etc/.installed_su_daemon 0 0 644>>%unpack%fs_config.txt
	echo system/etc/install-recovery.sh 0 0 755>>%unpack%fs_config.txt
	echo system/lib/libsupol.so 0 0 644>>%unpack%fs_config.txt
	echo system/xbin/daemonsu 0 0 755>>%unpack%fs_config.txt
	echo system/xbin/su 0 0 755>>%unpack%fs_config.txt
	echo system/xbin/supolicy 0 0 755>>%unpack%fs_config.txt
	goto DONE-1
	) ELSE (
	ECHO.
	ECHO.Android x64 detected.Rooting with x64 bin
	"%tools%7z" x "%tools%Root-x64.zip" -y -o%unpack%system -r > nul
	echo system/app/SuperSU 0 0 755>>%unpack%fs_config.txt
	echo system/app/SuperSU/SuperSU.apk 0 0 644>>%unpack%fs_config.txt
	echo system/app/SuperSUkey 0 0 755>>%unpack%fs_config.txt
	echo system/app/SuperSUkey/SuperSUkey.apk 0 0 644>>%unpack%fs_config.txt
	echo system/bin/.ext 0 0 755>>%unpack%fs_config.txt
	echo system/bin/.ext/.su 0 0 755>>%unpack%fs_config.txt
	echo system/bin/install-recovery.sh 0 0 755>>%unpack%fs_config.txt
	echo system/etc/.installed_su_daemon 0 0 644>>%unpack%fs_config.txt
	echo system/etc/install-recovery.sh 0 0 755>>%unpack%fs_config.txt
	echo system/lib64/libsupol.so 0 0 644>>%unpack%fs_config.txt
	echo system/xbin/daemonsu 0 0 755>>%unpack%fs_config.txt
	echo system/xbin/su 0 0 755>>%unpack%fs_config.txt
	echo system/xbin/supolicy 0 0 755>>%unpack%fs_config.txt
	goto DONE-1
)
)

:REPACK-IMG
CLS
IF EXIST %unpack%system (
ECHO.=========================================
ECHO.=          Repacking system.img         =
ECHO.=             Please wait...            =
ECHO.=========================================
ECHO.=  Please select image size:            =
ECHO.=  1 - 1.00 Gb                          =
ECHO.=  2 - 1.25 Gb                          =
ECHO.=  3 - 1.50 Gb                          =
ECHO.=  4 - 1.75 Gb                          =
ECHO.=  5 - 2.00 Gb                          =
ECHO.=========================================
ECHO.=                0. Back                =
ECHO.=========================================
ECHO.
) ELSE (
  ECHO.=========================================
  ECHO.=          Repacking system.img         =
  ECHO.=             Please wait...            =
  ECHO.=========================================
  ECHO.
  ECHO.                  Error
  ECHO.     Please unpack system.img first
  goto DONE-1
)
:REPACK_IMG_CHOICE
set REPACK_IMG_CHOICE=
set /p REPACK_IMG_CHOICE=Your choice: 
if /i "%REPACK_IMG_CHOICE%"=="1" goto REPACK-IMG-1GB
if /i "%REPACK_IMG_CHOICE%"=="2" goto REPACK-IMG-12GB
if /i "%REPACK_IMG_CHOICE%"=="3" goto REPACK-IMG-15GB
if /i "%REPACK_IMG_CHOICE%"=="4" goto REPACK-IMG-17GB
if /i "%REPACK_IMG_CHOICE%"=="5" goto REPACK-IMG-2GB
if /i "%REPACK_IMG_CHOICE%"=="0" goto MENU
goto REPACK-IMG

:REPACK-IMG-1GB
CLS
ECHO.=========================================
ECHO.= Repacking system.img with 1.0 Gb size =
ECHO.=             Please wait...            =
ECHO.=========================================
ECHO.
cd %unpack%
IF EXIST %unpack%system\fake-libs64 (
ECHO.Android x64 detected...
ECHO. 
%tools%make_ext4fs -l 1073741824 -b 4096 -S "%tools%file_contexts_7" -C "fs_config.txt" -a /system %out%system.img system
) ELSE (
  ECHO.Android x86 detected...
ECHO. 
  %tools%make_ext4fs -l 1073741824 -b 4096 -S "%tools%file_contexts_5" -C "fs_config.txt" -a /system %out%system.img system
)
goto DONE
:REPACK-IMG-12GB
CLS
ECHO.=========================================
ECHO.= Repacking system.img with 1.2 Gb size =
ECHO.=             Please wait...            =
ECHO.=========================================
ECHO.
cd %unpack%
IF EXIST %unpack%system\fake-libs64 (
ECHO.Android x64 detected...
ECHO. 
%tools%make_ext4fs -l 1342177280 -b 4096 -S "%tools%file_contexts_7" -C "fs_config.txt" -a /system %out%system.img system
) ELSE (
  ECHO.Android x86 detected...
  ECHO. 
  %tools%make_ext4fs -l 1342177280 -b 4096 -S "%tools%file_contexts_5" -C "fs_config.txt" -a /system %out%system.img system
)
goto DONE
:REPACK-IMG-15GB
CLS
ECHO.=========================================
ECHO.= Repacking system.img with 1.5 Gb size =
ECHO.=             Please wait...            =
ECHO.=========================================
ECHO.
cd %unpack%
IF EXIST %unpack%system\fake-libs64 (
ECHO.Android x64 detected...
ECHO. 
%tools%make_ext4fs -l 1610612736 -b 4096 -S "%tools%file_contexts_7" -C "fs_config.txt" -a /system %out%system.img system
) ELSE (
  ECHO.Android x86 detected...
  ECHO. 
  %tools%make_ext4fs -l 1610612736 -b 4096 -S "%tools%file_contexts_5" -C "fs_config.txt" -a /system %out%system.img system
)
goto DONE
:REPACK-IMG-17GB
CLS
ECHO.=========================================
ECHO.= Repacking system.img with 1.7 Gb size =
ECHO.=             Please wait...            =
ECHO.=========================================
ECHO.
cd %unpack%
IF EXIST %unpack%system\fake-libs64 (
ECHO.Android x64 detected...
ECHO. 
%tools%make_ext4fs -l 1879048192 -b 4096 -S "%tools%file_contexts_7" -C "fs_config.txt" -a /system %out%system.img system
) ELSE (
  ECHO.Android x86 detected...
  ECHO. 
  %tools%make_ext4fs -l 1879048192 -b 4096 -S "%tools%file_contexts_5" -C "fs_config.txt" -a /system %out%system.img system
)
goto DONE
:REPACK-IMG-2GB
CLS
ECHO.=========================================
ECHO.= Repacking system.img with 2.0 Gb size =
ECHO.=             Please wait...            =
ECHO.=========================================
ECHO.
cd %unpack%
IF EXIST %unpack%system\fake-libs64 (
ECHO.Android x64 detected...
ECHO. 
%tools%make_ext4fs -l 2147483648 -b 4096 -S "%tools%file_contexts_7" -C "fs_config.txt" -a /system %out%system.img system
) ELSE (
  ECHO.Android x86 detected...
  ECHO. 
  %tools%make_ext4fs -l 2147483648 -b 4096 -S "%tools%file_contexts_5" -C "fs_config.txt" -a /system %out%system.img system
)
goto DONE

:REPACK-SFS
CLS
ECHO.=========================================
ECHO.=          Repacking system.sfs         =
ECHO.=             Please wait...            =
ECHO.=========================================
cd %out%
IF EXIST %out%system.sfs (
del /q system.sfs > nul
)
IF EXIST %out%system.img (
"%tools%mksquashfs" system.img system.sfs > nul
) ELSE (
  ECHO.
  ECHO.                  Error
  ECHO.      Please make system.img before
  goto DONE-1
)
goto DONE

:MAKE-ISO-IMG
CLS
ECHO.=========================================
ECHO.=      Making ISO with system.img       =
ECHO.=             Please wait...            =
ECHO.=========================================
cd %out%
IF EXIST %out%system.img (
"%tools%7z" x "%tools%iso.zip" -y -o%out% -r > nul
copy system.img iso\system.img > nul
"%tools%mkisofs" -R -b grldr -V "Phoenix OS LiveCD" -sysid LINUX -allow-lowercase -no-emul-boot -J -boot-load-size 4 -quiet -o PhoenixOS-IMG.iso %out%iso
rd /s/q "%out%iso"
) ELSE (
  ECHO.
  ECHO.                  Error
  ECHO.Please make system.img before making ISO
  goto DONE-1
)
goto DONE

:MAKE-ISO-SFS
CLS
ECHO.=========================================
ECHO.=      Making ISO with system.sfs       =
ECHO.=             Please wait...            =
ECHO.=========================================
cd %out%
IF EXIST %out%system.sfs (
"%tools%7z" x "%tools%iso.zip" -y -o%out% -r > nul
copy system.sfs iso\system.sfs > nul
"%tools%mkisofs" -R -b grldr -V "Phoenix OS LiveCD" -sysid LINUX -allow-lowercase -no-emul-boot -J -boot-load-size 4 -quiet -o PhoenixOS-SFS.iso %out%iso
rd /s/q "%out%iso"
) ELSE (
  ECHO.
  ECHO.                  Error
  ECHO.Please make system.sfs before making ISO
  goto DONE-1
)
goto DONE

:CLEAR-UNPACK
CLS
ECHO.=========================================
ECHO.=        Cleaning /unpack folder        =
ECHO.=             Please wait...            =
ECHO.=========================================
rd /s/q "%unpack%"
md "%unpack%"
goto DONE-1

:CLEAR-OUT
CLS
ECHO.=========================================
ECHO.=         Cleaning /out folder          =
ECHO.=             Please wait...            =
ECHO.=========================================
rd /s/q "%out%"
md "%out%"
goto DONE-1

:CREATE-DATA
CLS
ECHO.=========================================
ECHO.=        Creating empty data.img        =
ECHO.=========================================
echo.       2 = 2.0 Gb     8  = 8.0  Gb
echo.       4 = 4.0 Gb     10 = 10.0 Gb
echo.       6 = 6.0 Gb     16 = 16.0 Gb
echo.=========================================
ECHO.=                0. Back                =
ECHO.=========================================
echo.
set /p size=Please enter preffered size: 
echo. 
echo.            Please wait...
echo. 
set /a size=size*1024
IF %size% EQU 0 (
goto MENU
) ELSE (
cd %tools%
%tools%tfile "%out%data.img" %size% > nul
%tools%mke2fs -j -F -t ext4 "%out%data.img" > nul
)
goto DONE

:RESIZE-DATA
CLS
ECHO.=========================================
ECHO.=         Resizing your data.img        =
ECHO.=========================================
cd %in%
IF NOT EXIST %in%data.img (
ECHO.
ECHO.                  Error
ECHO.   Please copy data.img into /in first   
goto DONE-1
) ELSE (
echo.       2 = 2.0 Gb     8  = 8.0  Gb
echo.       4 = 4.0 Gb     10 = 10.0 Gb
echo.       6 = 6.0 Gb     16 = 16.0 Gb
echo.=========================================
ECHO.=                0. Back                =
ECHO.=========================================
ECHO.
set /P resize=Please enter preffered size: 
echo. 
echo.Please wait...
echo. 
%tools%e2fsck.exe -fy "%top%data.img" > nul
%tools%resize2fs.exe "%top%data.img" %resize%G > nul
)
goto DONE-1

:DONE
ECHO.
ECHO.=========================================
ECHO.=        Done. Check /out folder        =
ECHO.=========================================
ECHO.
pause
goto MENU

:DONE-1
ECHO.
ECHO.=========================================
ECHO.=                 Done                  =
ECHO.=========================================
ECHO.
pause
goto MENU

:EXIT
cls
ECHO.=========================================
ECHO.=   Thanks for using PhoenixOS ToolBox  =
ECHO.=               Good bye                =
ECHO.=========================================
echo.
pause
exit
