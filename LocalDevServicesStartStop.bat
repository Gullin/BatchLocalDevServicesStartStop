@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION
CLS
:: Sparas och k”rs i code page 437 (dos)
CHCP 437

:: Exempel p† iterering
::SET variabel=(value1 value2 value3 value4)
::FOR %%i IN %variabel% DO ECHO Val: %1%

:: K„lla f”r snippets: http://www.dostips.com/, str„nghantering "DOS - String Operations", ":trimSpaces", ":trimSpaces2", "Split String"


:: Wish List
::  * 


:: Starta och stoppa Windows tj„nster f”r Oracle-instans,
:: MapGuide Open Source och PostgreSQL.
:: Metadata
SET v=1.5 [2019-11-28]
::  Tagit bort Oracle Web Console
::  Anpassat fr†n version 2.5 till 3.1 f”r MapGuide Open Source
::  Anpassat fr†n version 11 till 12 f”r Oracle
::  Adderat Windows tj„nst f”r PostgreSQL
::SET v=1.4 [2013-11-03]
::  Flervals-alternativ av menyvalen
::SET v=1.3.2 [2013-10-03]
::  Indikering av aktiv windows-tj„nster p† huvudmeny
::  Menyval f”r status av windows-tj„nster
::SET v=1.3 [2013-10-02]
::SET v=1.2 [2013-04-08]
::SET v=1.1 [2013-03-29]
:: Indikerar menyalternativ som „r aktivt
SET ON=[*] 
SET OFF=    
:: Instans
SET db=ADEV
:: Tj„nster som hanteras
SET wsTnslistener=OracleOraDB12Home1TNSListener
SET wsOraDB=OracleServiceADEV
SET wsPostgreSQL=postgresql-x64-12
SET wsMapGuide=MapGuide Server 3.1
SET statusFlagOn=Status: k”r
SET statusFlagOff=Status: k”r ej
SET statusFlagRunStarts=startas
SET statusFlagRunStarted=„r startad
SET statusFlagRunStops=stoppas
SET statusFlagRunStoped=„r stoppad

TITLE Start/stop Developing Windows Services (v %v%)


:: Kontrollerar om batch-filen k”rs som administrat”r. Ett krav d† funktionerna annars inte fungerar.
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
ECHO.
ECHO    ”vriga
ECHO      * %wsPostgreSQL%
ECHO      * %wsMapGuide%
ECHO.
ECHO  F”r att forts„tta
ECHO.
PAUSE

:: Kontrollera status f”r Windows-tj„nsterna och s„tter menymarkering
:MENU
SET caller=STARTSTATUSTNS
GOTO STATUSTNS
:STARTSTATUSTNS
SET INFO=

SET caller=STARTSTATUSPSQL
GOTO STATUSPSQL
:STARTSTATUSPSQL
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
ECHO   3. %run3%Starta PostgreSQL
ECHO   4. %run4%Stoppa PostgreSQL
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
ECHO (flerval genom avgr„nsad lista av mellanslag)
ECHO.

SET /P menu=V„lj alternativ: 

CALL :parse "%menu%"
GOTO :eos
:parse
SET list=%1
SET list=%list:"=%
FOR /f "tokens=1* delims= " %%a IN ("%list%") DO (
    SET func=
    IF "%%a"=="1" SET func=ONE
    IF "%%a"=="2" SET func=TWO
    IF "%%a"=="3" SET func=THREE
    IF "%%a"=="4" SET func=FOUR
    IF "%%a"=="5" SET func=FIVE
    IF "%%a"=="6" SET func=SIX
    IF "%%a"=="7" SET func=MENUSTATUS
    IF "%%a"=="q" SET func=SQL
    IF "%%a"=="m" SET func=MENU
    IF "%%a"=="x" SET func=END
    IF NOT "%%a" == "" CALL :!func! %%a
    IF NOT "%%b" == "" CALL :parse "%%b"
)
GOTO :MENU


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
ECHO   3. %wsPostgreSQL%
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
IF %menustatus%==3 GOTO STATUSPSQL
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
	  SET INFO=%wsTnslistener%    %statusFlagOn%
	  SET run1=%ON%
	  SET run2=%OFF%
   )
   IF %ERRORLEVEL% == 1 (
	  SET INFO=%wsTnslistener%    %statusFlagOff%
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
	  SET INFO=%wsOraDB%    %statusFlagOn%
	  SET run1=%ON%
	  SET run2=%OFF%
   )
   IF %ERRORLEVEL% == 1 (
	  SET INFO=%wsOraDB%    %statusFlagOff%
	  SET run1=%OFF%
	  SET run2=%ON%
   )
ECHO.
GOTO %caller%


:: STATUS PostgreSQL
:STATUSPSQL
CLS
ECHO.
NET START | FINDSTR /C:"%wsPostgreSQL%" > nul
   IF NOT %ERRORLEVEL% == 1 (
	  SET INFO=%wsPostgreSQL%    %statusFlagOn%
	  SET run3=%ON%
	  SET run4=%OFF%
   )
   IF %ERRORLEVEL% == 1 (
	  SET INFO=%wsPostgreSQL%    %statusFlagOff%
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
	  SET INFO=%wsMapGuide%    %statusFlagOn%
	  SET run5=%ON%
	  SET run6=%OFF%
   )
   IF %ERRORLEVEL% == 1 (
	  SET INFO=%wsMapGuide%    %statusFlagOff%
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
   IF NOT %ERRORLEVEL% == 1 ECHO  %wsTnslistener%    %statusFlagOn%
   IF %ERRORLEVEL% == 1 ECHO  %wsTnslistener%    %statusFlagOff%
NET START | FINDSTR /C:"%wsOraDB%" > nul
   IF NOT %ERRORLEVEL% == 1 ECHO  %wsOraDB%                  %statusFlagOn%
   IF %ERRORLEVEL% == 1 ECHO  %wsOraDB%                  %statusFlagOff%
NET START | FINDSTR /C:"%wsPostgreSQL%" > nul
   IF NOT %ERRORLEVEL% == 1 ECHO  %wsPostgreSQL%                %statusFlagOn%
   IF %ERRORLEVEL% == 1 ECHO  %wsPostgreSQL%                %statusFlagOff%
NET START | FINDSTR /C:"%wsMapGuide%" > nul
   IF NOT %ERRORLEVEL% == 1 ECHO  %wsMapGuide%                %statusFlagOn%
   IF %ERRORLEVEL% == 1 ECHO  %wsMapGuide%                %statusFlagOff%
ECHO.
PAUSE
GOTO %caller%


:: NET START
:ONE
CLS
ECHO.
ECHO %DATE% %TIME%
ECHO           %wsTnslistener% %statusFlagRunStarts%
NET START "%wsTnslistener%"
ECHO %DATE% %TIME%
ECHO           %wsTnslistener% %statusFlagRunStarted%
ECHO.
ECHO.
ECHO %DATE% %TIME%
ECHO           %wsOraDB% %statusFlagRunStarts%
NET START "%wsOraDB%"
ECHO %DATE% %TIME%
ECHO           %wsOraDB% %statusFlagRunStarted%
ECHO.
ECHO.
ECHO.
PAUSE
SET run1=%ON%
SET run2=%OFF%
::GOTO MENU
GOTO :EOF


:: NET STOP
:TWO
CLS
ECHO.
ECHO %DATE% %TIME%
ECHO           %wsOraDB% %statusFlagRunStops%
NET STOP "%wsOraDB%"
ECHO %DATE% %TIME%
ECHO           %wsOraDB% %statusFlagRunStoped%
ECHO.
ECHO.
ECHO %DATE% %TIME%
ECHO           %wsTnslistener% %statusFlagRunStops%
NET STOP "%wsTnslistener%"
ECHO %DATE% %TIME%
ECHO           %wsTnslistener% %statusFlagRunStoped%
ECHO.
ECHO.
ECHO.
PAUSE
SET run1=%OFF%
SET run2=%ON%
::GOTO MENU
GOTO :EOF


:THREE
CLS
ECHO.
ECHO %DATE% %TIME%
ECHO           %wsPostgreSQL% %statusFlagRunStarts%
NET START "%wsPostgreSQL%"
ECHO %DATE% %TIME%
ECHO           %wsPostgreSQL% %statusFlagRunStarted%
ECHO.
PAUSE
SET run3=%ON%
SET run4=%OFF%
::GOTO MENU
GOTO :EOF


:FOUR
CLS
ECHO.
ECHO %DATE% %TIME%
ECHO           %wsPostgreSQL% %statusFlagRunStops%
NET STOP "%wsPostgreSQL%"
ECHO %DATE% %TIME%
ECHO           %wsPostgreSQL% %statusFlagRunStoped%
ECHO.
PAUSE
SET run3=%OFF%
SET run4=%ON%
::GOTO MENU
GOTO :EOF


:FIVE
CLS
ECHO.
ECHO %DATE% %TIME%
ECHO           %wsMapGuide% %statusFlagRunStarts%
NET START "%wsMapGuide%"
ECHO %DATE% %TIME%
ECHO           %wsMapGuide% %statusFlagRunStarted%
ECHO.
PAUSE
SET run5=%ON%
SET run6=%OFF%
::GOTO MENU
GOTO :EOF


:SIX
CLS
ECHO.
ECHO %DATE% %TIME%
ECHO           %wsMapGuide% %statusFlagRunStops%
NET STOP "%wsMapGuide%"
ECHO %DATE% %TIME%
ECHO           %wsMapGuide% %statusFlagRunStoped%
ECHO.
PAUSE
SET run5=%OFF%
SET run6=%ON%
::GOTO MENU
GOTO :EOF


:SQL
CLS
ECHO.
SET /P sqluser=Anv„ndare: 
SET /P sqlpass=L”sen: 
CALL sqlplus %sqluser%/%sqlpass%
ECHO %ERRORLEVEL%
ECHO.
PAUSE
::GOTO MENU
GOTO :EOF


:END
ENDLOCAL
EXIT


:EOF