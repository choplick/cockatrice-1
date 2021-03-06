!include "MUI2.nsh"
!include "FileFunc.nsh"

Name "Cockatrice"
OutFile "cockatrice_win32.exe"
SetCompressor lzma
InstallDir "$PROGRAMFILES\Cockatrice"

!define MUI_ABORTWARNING
!define MUI_WELCOMEFINISHPAGE_BITMAP "leftimage.bmp"
!define MUI_UNWELCOMEFINISHPAGE_BITMAP "leftimage.bmp"
!define MUI_HEADERIMAGE
!define MUI_HEADERIMAGE_BITMAP "headerimage.bmp"
!define MUI_HEADERIMAGE_UNBITMAP "headerimage.bmp"
!define MUI_WELCOMEPAGE_TEXT "This wizard will guide you through the installation of Cockatrice.$\r$\n$\r$\nClick Next to continue."
!define MUI_FINISHPAGE_RUN "$INSTDIR/oracle.exe"
!define MUI_FINISHPAGE_RUN_TEXT "Run card database downloader now"
!define MUI_FINISHPAGE_RUN_PARAMETERS "-dlsets"

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

!insertmacro MUI_LANGUAGE "English"

Section "Application" SecApplication
	SetOutPath "$INSTDIR"
	File ..\cockatrice\release\cockatrice.exe
	File ..\oracle\release\oracle.exe
	File data\libgcc_s_dw2-1.dll
	File data\mingwm10.dll
	File data\QtCore4.dll
	File data\QtGui4.dll
	File data\QtNetwork4.dll
	File data\QtSvg4.dll
	File data\QtXml4.dll

	SetOutPath "$INSTDIR\zonebg"
	File /r ..\zonebg\*.*
	
	SetOutPath "$INSTDIR\plugins"
	File /r data\plugins\*.*

	SetOutPath "$INSTDIR\pics"
	SetOutPath "$INSTDIR\decks"

        WriteUninstaller "$INSTDIR\uninstall.exe"
        ${GetSize} "$INSTDIR" "/S=0K" $0 $1 $2
        IntFmt $0 "0x%08X" $0
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Cockatrice" "DisplayName" "Cockatrice"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Cockatrice" "UninstallString" "$\"$INSTDIR\uninstall.exe$\""
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Cockatrice" "QuietUninstallString" "$\"$INSTDIR\uninstall.exe$\" /S"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Cockatrice" "InstallLocation" "$INSTDIR"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Cockatrice" "DisplayIcon" "$INSTDIR\cockatrice.exe"
	WriteRegDWORD HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Cockatrice" "EstimatedSize" "$0"
SectionEnd

Section "Update configuration" SecUpdateConfig
	WriteRegStr HKCU "Software\Cockatrice\Cockatrice\paths" "carddatabase" "$INSTDIR\cards.xml"
	WriteRegStr HKCU "Software\Cockatrice\Cockatrice\paths" "decks" "$INSTDIR\decks"
	WriteRegStr HKCU "Software\Cockatrice\Cockatrice\paths" "pics" "$INSTDIR\pics"
	
SectionEnd

Section "Start menu item" SecStartMenu
	createDirectory "$SMPROGRAMS\Cockatrice"
	createShortCut "$SMPROGRAMS\Cockatrice\Cockatrice.lnk" "$INSTDIR\cockatrice.exe"
	createShortCut "$SMPROGRAMS\Cockatrice\Oracle.lnk" "$INSTDIR\oracle.exe"
SectionEnd

Section Uninstall
        RMDir /r "$INSTDIR\zonebg"
        RMDir /r "$INSTDIR\plugins"
        RMDir "$INSTDIR\decks"
        RMDir /r "$INSTDIR\pics\downloadedPics"
        RMDir "$INSTDIR\pics"
        Delete "$INSTDIR\uninstall.exe"
        Delete "$INSTDIR\cockatrice.exe"
        Delete "$INSTDIR\oracle.exe"
        Delete "$INSTDIR\cards.xml"
        Delete "$INSTDIR\libgcc_s_dw2-1.dll"
        Delete "$INSTDIR\mingwm10.dll"
        Delete "$INSTDIR\QtCore4.dll"
        Delete "$INSTDIR\QtGui4.dll"
        Delete "$INSTDIR\QtNetwork4.dll"
        Delete "$INSTDIR\QtSvg4.dll"
        Delete "$INSTDIR\QtXml4.dll"
        RMDir "$INSTDIR"

	RMDir /r "$SMPROGRAMS\Cockatrice"
        
        DeleteRegKey HKCU "Software\Cockatrice"
        DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\Cockatrice"
SectionEnd

LangString DESC_SecApplication ${LANG_ENGLISH} "Cockatrice program files"
LangString DESC_SecUpdateConfig ${LANG_ENGLISH} "Update the paths in the application settings according to the installation paths."
LangString DESC_SecStartMenu ${LANG_ENGLISH} "Create start menu items for Cockatrice and Oracle."
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
        !insertmacro MUI_DESCRIPTION_TEXT ${SecApplication} $(DESC_SecApplication)
        !insertmacro MUI_DESCRIPTION_TEXT ${SecUpdateConfig} $(DESC_SecUpdateConfig)
        !insertmacro MUI_DESCRIPTION_TEXT ${SecStartMenu} $(DESC_SecStartMenu)
!insertmacro MUI_FUNCTION_DESCRIPTION_END

