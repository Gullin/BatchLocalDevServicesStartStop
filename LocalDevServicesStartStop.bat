@ECHO OFF
CLS

:: (c) = ¸
:: å = †
:: ä = „
:: ö = ”
:: Å = 
:: Ä = Ž
:: Ö = ™

:: Starta och stoppa Windows tjänster för Oracle-instans
:: Metadata
SET v=1.2 [2013-04-08]
::SET v=1.1 [2013-03-29]
:: Instans
SET db=ADEV
:: Tjänster för tnslistener och instans
SET wsTnslistener=OracleOraDb11g_home1TNSListener
SET wsOraDB=OracleServiceADEV

TITLE Start/stop Oracle instans %db% Windows Services (v %v%)


:: Kontrollerar om batch-filen körs som administratör. Ett krav då funktionerna annars inte fungerar.
:CHECK_PERMISSIONS
ECHO.
ECHO Administrat”rsr„ttigheter beh”vs. Kontrollerar r„ttigheter...
NET SESSION >NUL 2>&1
    IF %ERRORLEVEL% == 0 (
        GOTO MENU
    ) ELSE (
        ECHO.
        ECHO Fel: Aktuella beh”righeter otillr„cklig.
        ECHO      Batch-filen beh”ver k”ras som administrat”r.
    )

    pause >NUL
    GOTO END

    
:MENU
CLS
ECHO.
ECHO   1. %run1%Starta Oracle f”r instans %db%
ECHO   2. %run2%Stoppa Oracle f”r instans %db%
ECHO   3. Status Windows-tj„nst f”r instans %db%
ECHO.
ECHO   q. SQL Plus
ECHO.
ECHO   x. Avsluta
ECHO.
ECHO.

SET /P menu=V„lj alternativ: 
IF %menu%==1 GOTO ONE
IF %menu%==2 GOTO TWO
IF %menu%==3 GOTO THREE
IF %menu%==q GOTO SQL
IF %menu%==x GOTO END


:: NET START
:ONE
CLS
ECHO.
ECHO %DATE% %TIME%
ECHO           %wsTnslistener% startas
NET START %wsTnslistener%
ECHO %DATE% %TIME%
ECHO           %wsTnslistener% „r startad
ECHO.
ECHO.
ECHO %DATE% %TIME%
ECHO           %wsOraDB% startas
NET START %wsOraDB%
ECHO %DATE% %TIME%
ECHO           %wsOraDB% „r startad
ECHO.
ECHO.
ECHO.
PAUSE
SET run1=* 
SET run2=
GOTO MENU


:: NET STOP
:TWO
CLS
ECHO.
ECHO %DATE% %TIME%
ECHO           %wsOraDB% stoppas
NET STOP %wsOraDB%
ECHO %DATE% %TIME%
ECHO           %wsOraDB% „r stoppad
ECHO.
ECHO.
ECHO %DATE% %TIME%
ECHO           %wsTnslistener% stoppas
NET STOP %wsTnslistener%
ECHO %DATE% %TIME%
ECHO           %wsTnslistener% „r stoppad
ECHO.
ECHO.
ECHO.
PAUSE
SET run1=
SET run2=* 
GOTO MENU


:THREE
CLS
ECHO.
NET START | FINDSTR %wsTnslistener% > nul
   IF NOT %ERRORLEVEL% == 1 ECHO %wsTnslistener%    Status: k”r
   IF %ERRORLEVEL% == 1 ECHO %wsTnslistener%    Status: k”r ej
NET START | FINDSTR %wsOraDB% > nul
   IF NOT %ERRORLEVEL% == 1 ECHO %wsOraDB%                  Status: k”r
   IF %ERRORLEVEL% == 1 ECHO %wsOraDB%                  Status: k”r ej
ECHO.
PAUSE
GOTO MENU


:SQL
CLS
ECHO.
SET /P sqluser=Anv„ndare: 
SET /P sqlpass=L”sen: 
CALL sqlplus %sqluser%/%sqlpass%
ECHO %ERRORLEVEL%
ECHO.
PAUSE
GOTO MENU


:END
EXIT