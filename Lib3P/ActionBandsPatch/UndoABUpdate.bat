@echo off
rem  Written Oct 30 2003
rem
rem  This batch file is intended to restore all ActionBand related
rem  files from an original Delphi 7.0 CDROM.  
rem
if "%1" == "" goto usage
if %2.== . goto usage
if "%3" == "" goto continueinstall
echo.
echo ERROR: delphi_install_directory parameter must be quoted
echo.
goto end

:continueinstall
echo.
echo This batch file will restore the files updated by the ActionBand
echo update to the original files as shipped with Delphi 7.0
echo.
echo Please close Delphi if it is currently running
echo.
Pause
set ABUpdatePath=%2
if not exist "%1\Install\program files\Borland\Delphi7\lib\dclact.dcp" h%\bin\dclstd70.bpl goto InvalidCD
if not exist %ABUpdatePath%\bin\dclstd70.bpl goto InvalidDelphiPath

echo Restoring ActionBand design-time package... 
copy "%1\Install\program files\Borland\Delphi7\bin\dclact70.bpl" %ABUpdatePath%\bin

echo Restoring Delphi ActionBand Lib directory files...
copy "%1\Install\program files\Borland\Delphi7\lib\dclact.dcp" %ABUpdatePath%\lib /y
copy "%1\Install\program files\Borland\Delphi7\lib\ActnCtrls.dcu" %ABUpdatePath%\lib /y
copy "%1\Install\program files\Borland\Delphi7\lib\Actnman.dcu" %ABUpdatePath%\lib /y 
copy "%1\Install\program files\Borland\Delphi7\lib\ActnMenus.dcu" %ABUpdatePath%\lib /y 
copy "%1\Install\program files\Borland\Delphi7\lib\StdActnMenus.dcu" %ABUpdatePath%\lib /y
copy "%1\Install\program files\Borland\Delphi7\lib\BandActn.dcu" %ABUpdatePath%\lib /y
copy "%1\Install\program files\Borland\Delphi7\lib\CustomizeDlg.dcu" %ABUpdatePath%\lib 
copy "%1\Install\program files\Borland\Delphi7\lib\XPActnCtrls.dcu" %ABUpdatePath%\lib /y
copy "%1\Install\program files\Borland\Delphi7\lib\XPStyleActnCtrls.dcu" %ABUpdatePath%\lib /y
copy "%1\Install\program files\Borland\Delphi7\lib\StdStyleActnCtrls.dcu" %ABUpdatePath%\lib /y
copy "%1\Install\program files\Borland\Delphi7\lib\ActnColorMaps.dcu" %ABUpdatePath%\lib /y
copy "%1\Install\program files\Borland\Delphi7\lib\vclActnBand.dcp" %ABUpdatePath%\lib /y

echo Restoring Delphi ActionBand Lib\Debug directory files...
copy "%1\Install\program files\Borland\Delphi7\lib\debug\ActnCtrls.dcu" %ABUpdatePath%\lib\debug /y
copy "%1\Install\program files\Borland\Delphi7\lib\debug\Actnman.dcu" %ABUpdatePath%\lib\debug /y 
copy "%1\Install\program files\Borland\Delphi7\lib\debug\ActnMenus.dcu" %ABUpdatePath%\lib\debug /y
copy "%1\Install\program files\Borland\Delphi7\lib\debug\StdActnMenus.dcu" %ABUpdatePath%\lib\debug /y
copy "%1\Install\program files\Borland\Delphi7\lib\debug\BandActn.dcu" %ABUpdatePath%\lib\debug /y
copy "%1\Install\program files\Borland\Delphi7\lib\debug\CustomizeDlg.dcu" %ABUpdatePath%\lib\debug /y
copy "%1\Install\program files\Borland\Delphi7\lib\debug\XPActnCtrls.dcu" %ABUpdatePath%\lib\debug /y
copy "%1\Install\program files\Borland\Delphi7\lib\debug\XPStyleActnCtrls.dcu" %ABUpdatePath%\lib\debug /y
copy "%1\Install\program files\Borland\Delphi7\lib\debug\StdStyleActnCtrls.dcu" %ABUpdatePath%\lib\debug /y
copy "%1\Install\program files\Borland\Delphi7\lib\debug\ActnColorMaps.dcu" %ABUpdatePath%\lib\debug /y

if exist "%ABUpdatePath%\lib\StdDropBtn.dcu" del %ABUpdatePath%\lib\StdDropBtn.dcu
if exist "%ABUpdatePath%\lib\debug\StdDropBtn.dcu" del %ABUpdatePath%\lib\debug\StdDropBtn.dcu
if exist "%ABUpdatePath%\source\vcl\StdDropBtn.pas" del %ABUpdatePath%\source\vcl\StdDropBtn.pas

if exist "%ABUpdatePath%\lib\ActnPopupCtrl.dcu" del %ABUpdatePath%\lib\ActnPopupCtrl.dcu
if exist "%ABUpdatePath%\lib\debug\ActnPopupCtrl.dcu" del %ABUpdatePath%\lib\debug\ActnPopupCtrl.dcu
if exist "%ABUpdatePath%\source\vcl\ActnPopupCtrl.pas" del %ABUpdatePath%\source\vcl\ActnPopupCtrl.pas

echo Restoring Delphi ActionBand Source VCL files...
copy "%1\Install\program files\Borland\Delphi7\source\vcl\ActnCtrls.pas" %ABUpdatePath%\source\vcl
copy "%1\Install\program files\Borland\Delphi7\source\vcl\Actnman.pas" %ABUpdatePath%\source\vcl
copy "%1\Install\program files\Borland\Delphi7\source\vcl\ActnMenus.pas" %ABUpdatePath%\source\vcl
copy "%1\Install\program files\Borland\Delphi7\source\vcl\StdActnMenus.pas" %ABUpdatePath%\source\vcl
copy "%1\Install\program files\Borland\Delphi7\source\vcl\BandActn.pas" %ABUpdatePath%\source\vcl
copy "%1\Install\program files\Borland\Delphi7\source\vcl\CustomizeDlg.pas" %ABUpdatePath%\source\vcl
copy "%1\Install\program files\Borland\Delphi7\source\vcl\XPActnCtrls.pas" %ABUpdatePath%\source\vcl
copy "%1\Install\program files\Borland\Delphi7\source\vcl\XPStyleActnCtrls.pas" %ABUpdatePath%\source\vcl
copy "%1\Install\program files\Borland\Delphi7\source\vcl\StdStyleActnCtrls.pas" %ABUpdatePath%\source\vcl
copy "%1\Install\program files\Borland\Delphi7\source\vcl\ActnColorMaps.pas" %ABUpdatePath%\source\vcl

if exist "%ABUpdatePath%\lib\debug\StdDropBtn.dcu" del %ABUpdatePath%\lib\debug\StdDropBtn.dcu

echo Restoring VCL ActionBand runtime package...

if "%OS%" == "Windows_NT" goto winnt
copy "%1\Install\System32\vclactnband70.bpl" "%windir%\system" /y 
if errorlevel 1 echo Error copying vclactnband70.bpl you will need to manually copy this file

:winnt
copy "%1\Install\System32\vclactnband70.bpl" "%windir%\system32" /y
if errorlevel 1 echo Error copying vclactnband70.bpl you will need to manually copy this file

goto success

:InvalidCD
echo.
echo ERROR: File ("%1\Install\program files\Borland\Delphi7\lib\dclact.dcp")
echo        was not found on the CD in drive (%1).
echo.
echo Please make sure you have your original Delphi 7.0 CD in the drive.

:InvalidDelphiPath
echo.
echo ERROR: The path (%2) does not point to a valid Delphi 7.0 
echo        install directory.  Please check this parameter and 
echo        try again.
echo.
goto end

:usage
echo Usage:
echo.
echo UndoABUpdate.bat cd-rom_drive_letter delphi_install_directory
echo.
echo cd-rom_drive_letter      - The drive letter of the CD-ROM drive
echo                            that contains your Delphi 7.0 CD.
echo delphi_install_directory - The full path to your Delphi 7.0 
echo                            installation directory.
echo.
echo In order to use this batch file you must insert your original
echo Delphi 7.0 CD into your CD-ROM drive and supply a command line 
echo parameter that indicates your CD-ROM drive letter and Delphi 7.0
echo installation directory.
echo.
echo If your Delphi 7.0 installation directory contains spaces then
echo the path *must* be quoted.
echo.
echo For example:
echo.
echo UndoABUpdate d: "c:\Program Files\Borland\Delphi7"

goto end
:success
set ABUpdatePath=
echo.
echo Successfully restored the original ActionBand files.
:end
