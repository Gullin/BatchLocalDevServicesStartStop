@ECHO OFF
CLS

:: (c) = ¸
:: å = †
:: ä = „
:: ö = ”
:: Å = 
:: Ä = Ž
:: Ö = ™

:: Starta och stoppa Windows tjänster för Oracle-instans,
:: webb-konsollen och MapGuide Open Source.
:: Metadata
SET v=1.3.2 [2013-10-03]
::SET v=1.3 [2013-10-02]
::SET v=1.2 [2013-04-08]
::SET v=1.1 [2013-03-29]
:: Indikerar menyalternativ som är aktivt
SET ON=[*] 
SET OFF=    
:: Instans
SET db=ADEV
:: Tjänster som hanteras
SET wsTnslistener=OracleOraDb11g_home1TNSListener
SET wsOraDB=OracleServiceADEV
SET wsOraWebConsole=OracleDBConsoleadev
SET wsMapGuide=MapGuide Server 2.5

TITLE Start/stop Developing Windows Services (v %v%)


:: Kontrollerar om batch-filen körs som administratör. Ett krav då funktionerna annars inte fungerar.
:CHECK_PERMISSIONS
ECHO.
ECHO Administrat”rsr„ttigheter beh”vs. Kontrollerar r„ttigheter...
NET SESSION >NUL 2>&1
    IF %ERRORLEVEL% == 0 (
        GOTO START
    ) ELSE (
        ECHO.
        ECHO Fel: Aktuella beh”righeter otillr„cklig.
        ECHO      Batch-filen beh”ver k”ras som administrat”r.
    )

    pause >NUL
    GOTO END

:START
CLS
ECHO.
ECHO  F”ljande tj„nster hanteras:
ECHO    f”r Oracle-instans %db%
ECHO      * %wsTnslistener%
ECHO      * %wsOraDB%
ECHO      * %wsOraWebConsole%
ECHO.
ECHO    ”vriga
ECHO      * %wsMapGuide%
ECHO.
ECHO  F”r att forts„tta
ECHO.
PAUSE

:: Kontrollera status för Windows-tjänsterna och sätt menymarkering
:MENU
SET caller=STARTSTATUSTNS
GOTO STATUSTNS
:STARTSTATUSTNS
SET INFO=

SET caller=STARTSTATUSCONSOLE
GOTO STATUSCONSOLE
:STARTSTATUSCONSOLE
SET INFO=

SET caller=STARTSTATUSMGOS
GOTO STATUSMGOS
:STARTSTATUSMGOS
SET INFO=
    
CLS
ECHO.
ECHO   1. %run1%Starta Oracle f”r instans %db%
ECHO   2. %run2%Stoppa Oracle f”r instans %db%
ECHO.
ECHO   3. %run3%Starta Oracle's webbaserad kontrollpanel%consoleUrl%
ECHO   4. %run4%Stoppa Oracle's webbaserad kontrollpanel
ECHO.
ECHO   5. %run5%Starta MapGuide Open Source
ECHO   6. %run6%Stoppa MapGuide Open Source
ECHO.
ECHO.
ECHO   7. Status Windows-tj„nster...
ECHO.
ECHO.
ECHO   q. SQL Plus
ECHO.
ECHO.
ECHO   x. Avsluta
ECHO.
ECHO.
ECHO [*] = aktivt alternativ

SET /P menu=V„lj alternativ: 
IF %menu%==1 GOTO ONE
IF %menu%==2 GOTO TWO
IF %menu%==3 GOTO THREE
IF %menu%==4 GOTO FOUR
IF %menu%==5 GOTO FIVE
IF %menu%==6 GOTO SIX
IF %menu%==7 GOTO MENUSTATUS
IF %menu%==q GOTO SQL
IF %menu%==m GOTO MENU
IF %menu%==x GOTO END


:MENUSTATUS
CLS
IF "%INFO%" NEQ "" (
   ECHO.
   ECHO  %INFO%
   ECHO.
   PAUSE
)
SET INFO=
CLS
ECHO.
ECHO  Status
ECHO.
ECHO   1. %wsTnslistener%
ECHO   2. %wsOraDB%
ECHO   3. %wsOraWebConsole%
ECHO   4. %wsMapGuide%
ECHO.
ECHO   5. Alla, statusalternativ 1 - 4
ECHO.
ECHO   m. Huvudmeny
ECHO.
ECHO   x. Avsluta
ECHO.
ECHO.

SET /P menustatus=V„lj alternativ: 
SET caller=MENUSTATUS
IF %menustatus%==1 GOTO STATUSTNS
IF %menustatus%==2 GOTO STATUSDB
IF %menustatus%==3 GOTO STATUSCONSOLE
IF %menustatus%==4 GOTO STATUSMGOS
IF %menustatus%==5 GOTO STATUSALLA
IF %menustatus%==m GOTO MENU
IF %menustatus%==x GOTO END


:: STATUS TNS
:STATUSTNS
CLS
ECHO.
NET START | FINDSTR /C:"%wsTnslistener%" > nul
   IF NOT %ERRORLEVEL% == 1 (
	  SET INFO=%wsTnslistener%    Status: k”r
	  SET run1=%ON%
	  SET run2=%OFF%
   )
   IF %ERRORLEVEL% == 1 (
	  SET INFO=%wsTnslistener%    Status: k”r ej
	  SET run1=%OFF%
	  SET run2=%ON%
   )
ECHO.
GOTO %caller%


:: STATUS DB
:STATUSDB
CLS
ECHO.
NET START | FINDSTR /C:"%wsOraDB%" > nul
   IF NOT %ERRORLEVEL% == 1 (
	  SET INFO=%wsOraDB%    Status: k”r
	  SET run1=%ON%
	  SET run2=%OFF%
   )
   IF %ERRORLEVEL% == 1 (
	  SET INFO=%wsOraDB%    Status: k”r ej
	  SET run1=%OFF%
	  SET run2=%ON%
   )
ECHO.
GOTO %caller%


:: STATUS CONSOLE
:STATUSCONSOLE
CLS
ECHO.
NET START | FINDSTR /C:"%wsOraWebConsole%" > nul
   IF NOT %ERRORLEVEL% == 1 (
	  SET INFO=%wsOraWebConsole%    Status: k”r
	  SET run3=%ON%
	  SET run4=%OFF%
   )
   IF %ERRORLEVEL% == 1 (
	  SET INFO=%wsOraWebConsole%    Status: k”r ej
	  SET run3=%OFF%
	  SET run4=%ON%
   )
ECHO.
GOTO %caller%


:: STATUS MGOS
:STATUSMGOS
CLS
ECHO.
NET START | FINDSTR /C:"%wsMapGuide%" > nul
   IF NOT %ERRORLEVEL% == 1 (
	  SET INFO=%wsMapGuide%    Status: k”r
	  SET run5=%ON%
	  SET run6=%OFF%
   )
   IF %ERRORLEVEL% == 1 (
	  SET INFO=%wsMapGuide%    Status: k”r ej
	  SET run5=%OFF%
	  SET run6=%ON%
   )
ECHO.
GOTO %caller%


:: STATUS ALLA
:STATUSALLA
CLS
ECHO.
NET START | FINDSTR /C:"%wsTnslistener%" > nul
   IF NOT %ERRORLEVEL% == 1 ECHO  %wsTnslistener%    Status: k”r
   IF %ERRORLEVEL% == 1 ECHO  %wsTnslistener%    Status: k”r ej
NET START | FINDSTR /C:"%wsOraDB%" > nul
   IF NOT %ERRORLEVEL% == 1 ECHO  %wsOraDB%                  Status: k”r
   IF %ERRORLEVEL% == 1 ECHO  %wsOraDB%                  Status: k”r ej
NET START | FINDSTR /C:"%wsOraWebConsole%" > nul
   IF NOT %ERRORLEVEL% == 1 ECHO  %wsOraWebConsole%                Status: k”r
   IF %ERRORLEVEL% == 1 ECHO  %wsOraWebConsole%                Status: k”r ej
NET START | FINDSTR /C:"%wsMapGuide%" > nul
   IF NOT %ERRORLEVEL% == 1 ECHO  %wsMapGuide%                Status: k”r
   IF %ERRORLEVEL% == 1 ECHO  %wsMapGuide%                Status: k”r ej
ECHO.
PAUSE
GOTO %caller%


:: NET START
:ONE
CLS
ECHO.
ECHO %DATE% %TIME%
ECHO           %wsTnslistener% startas
NET START "%wsTnslistener%"
ECHO %DATE% %TIME%
ECHO           %wsTnslistener% „r startad
ECHO.
ECHO.
ECHO %DATE% %TIME%
ECHO           %wsOraDB% startas
NET START "%wsOraDB%"
ECHO %DATE% %TIME%
ECHO           %wsOraDB% „r startad
ECHO.
ECHO.
ECHO.
PAUSE
SET run1=%ON%
SET run2=%OFF%
GOTO MENU


:: NET STOP
:TWO
CLS
ECHO.
ECHO %DATE% %TIME%
ECHO           %wsOraDB% stoppas
NET STOP "%wsOraDB%"
ECHO %DATE% %TIME%
ECHO           %wsOraDB% „r stoppad
ECHO.
ECHO.
ECHO %DATE% %TIME%
ECHO           %wsTnslistener% stoppas
NET STOP "%wsTnslistener%"
ECHO %DATE% %TIME%
ECHO           %wsTnslistener% „r stoppad
ECHO.
ECHO.
ECHO.
PAUSE
SET run1=%OFF%
SET run2=%ON%
GOTO MENU


:THREE
CLS
ECHO.
ECHO %DATE% %TIME%
ECHO           %wsOraWebConsole% startas
NET START "%wsOraWebConsole%"
ECHO %DATE% %TIME%
ECHO           %wsOraWebConsole% „r startad
ECHO.
PAUSE
SET run3=%ON%
SET consoleUrl= (https://localhost:1158/em)
SET run4=%OFF%
GOTO MENU


:FOUR
CLS
ECHO.
ECHO %DATE% %TIME%
ECHO           %wsOraWebConsole% stoppas
NET STOP "%wsOraWebConsole%"
ECHO %DATE% %TIME%
ECHO           %wsOraWebConsole% „r stoppad
ECHO.
PAUSE
SET run3=%OFF%
SET consoleUrl=
SET run4=%ON%
GOTO MENU


:FIVE
CLS
ECHO.
ECHO %DATE% %TIME%
ECHO           %wsMapGuide% startas
NET START "%wsMapGuide%"
ECHO %DATE% %TIME%
ECHO           %wsMapGuide% „r startad
ECHO.
PAUSE
SET run5=%ON%
SET run6=%OFF%
GOTO MENU


:SIX
CLS
ECHO.
ECHO %DATE% %TIME%
ECHO           %wsMapGuide% stoppas
NET STOP "%wsMapGuide%"
ECHO %DATE% %TIME%
ECHO           %wsMapGuide% „r stoppad
ECHO.
PAUSE
SET run5=%OFF%
SET run6=%ON%
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