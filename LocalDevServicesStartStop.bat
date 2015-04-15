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
:: Instans
SET db=ADEV
:: Tjänster för tnslistener och instans
SET wsTnslistener=OracleOraDb11g_home1TNSListener
SET wsOraDB=OracleServiceADEV

TITLE Start/stop Oracle instans %db% Windows Services

:MENU
CLS
ECHO.
ECHO   1. %run1%Starta Oracle f”r instans %db%
ECHO   2. %run2%Stoppa Oracle f”r instans %db%
ECHO   3. Status Windows-tj„nst f”r instans %db%
ECHO.
ECHO   x. Avsluta
ECHO.
ECHO.

SET /P menu=V„lj alternativ: 
IF %menu%==1 GOTO ONE
IF %menu%==2 GOTO TWO
IF %menu%==3 GOTO THREE
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


:END
EXIT