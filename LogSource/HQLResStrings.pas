unit HQLResStrings;

interface

resourcestring
  //soubory
  strFileOpenErr='Soubor "%0:s" nelze otevøít!';
  strFileMissing='Chybí soubor "%0:s".';


  //
  strOpenUserErr='Soubor "%0:s" nelze otevøít!'+#13+'Program bude ukonèen!';
  strOpenOptionsErr='Nelze zajistit dostateèný pøístup k souboru "%0:s"!';
  //
  strExportFQSO='Je zapnutý filtr, bude exportováno %0:d záznamù.';
  strExportSelQSO='Bude exportováno %0:d vybraných záznamù.';
  //
  strDbOpenError='(DO-%0:d) Chyba pøi otevírání databáze!';
  strPackTblError='Chyba pøi odstraòování chybìjících indexù!';
  //
  strLogInFonts='Nastavuji fonty ...';
  strLogInSyncingTime='Synchronizuji èas ...';
  strLogInCheckingUTCOffset='Kontroluji odchylku UTC ...';
  strLogInCheckingFiles='Kontroluji soubory ...';
  strLogInOpening='Otevírám deník ... ';
  strSyncTimeError='Chyba pøi synchronizaci èasu se serverem "%0:s"';
  //
  strLoadingData = 'Naèítám data ...';
  strSelectingQSOs = 'Oznaèuji spojení...';
  //
  strTimeBias='Odchylka UTC èasu není pravdìpodobnì správnì nastavena. '+
    'Dle navrhovaných zmìn je právì %0:s UTC.'+#13+'Chcete použít nové nastavení?';
  //DXC
  strNoDXChost='Adresa DxClusteru není zadána  (Nastavení/DxCluster/Adresa).';
  strNoDXCpass='Heslo musí být zadáno (Nastavení/DxCluster/Heslo).';
  //nastaveni
  strOptionsUserExists='Uživatel již existuje!';
  strOptionsSetBackupDir='Vyberte adresáø pro zálohy';
  strOptionsAddModeCaption='Nový mód';
  strOptionsMinOneMode='Musí být zadán nejménì jeden mód!';
  strOptionsAddFreqCaption='Nová frekvence';
  strOptionsFreqMaxCount='Je povoleno maximálnì %0:d záznamù!';
  strFreq='Frekvence';
  strIndex='Index';
  strBand='Pásmo';
  strMode='Mód';
  strNoModeSel='Musí být vybrán alespoò jeden mód!';
  //tisk
  strPrintExport='Exportuji data pro tisk...';
  strPrintInterrupted='Tisk byl pøerušen uživatelem.';
  strPrintErr='Pøi tisku se vyskytla chyba.';
  //spojeni
  strQSOExitQ='Aktuální spojení nebude uloženo.'+#13+'Chcete pokraèovat?';
  strSaveQSOq='Chcete uložit zmìny?';
  strNoLoc='Lokátor musí být zadán!';
  //AziDis
  strCantCountDist='Chybí vlastní lokátor, nelze vypoèítat vzdálenost!';
  strCantCountAzi='Chybí vlastní lokátor, nelze vypoèítat azimut!';
  //CallBook
  strNoDataQ='Nejsou naètená žádná data.'+#13+'Chece je importovat?';
  strImportCBq='Opravdu chcete importovat novou databázi?'+#13+
    'Pùvodní data budou pøepsána!';
  strImportCBfq='Data mají pravdìpodobnì nesprávný formát!'+#13+'Chcete pokraèovat?';
  //filtr
  strFilterLimit='Je dovoleno zadat maximálnì 50 podmínek.';
  //nastaveni statistiky
  strNoModeSelected='Není vybrán žádný mód!';
  //
  strNoDir='Adresáø musí být zadán!';
  strDirNotExists='Adresáø "%0:s" neexistuje!';
  strFileOverwriteQ='Soubor "%0:s" již existuje!'+#13+'Chcete jej pøepsat?';
  strFileCantCreate='Soubor "%0:s" nelze vytvoøit.'+#13+
    'Cíl je chránìn proti zápisu, nebo není dostatek volného místa.';
  //
  strQSLNote='Nastavení poznámky na QSL lístek';
  strNote='Poznámka:';

//------------------------------------------------------------------------------
//obecne
//------------------------------------------------------------------------------
  strExitQ='Opravdu chcete ukonèit program?';
  strNotFound='Nenalezeno ...';

//------------------------------------------------------------------------------
//soubory
//------------------------------------------------------------------------------
  strFileFormatErr='Neplatný formát souboru!';
  strFileVersionErr='Neznámá verze souboru!';
  strFileCRCErr='Neplatný kontrolní souèet - soubor je poškozen!';

//------------------------------------------------------------------------------
//databaze
//------------------------------------------------------------------------------
  strNoBDE='Je potøeba nainstalovat Borland Database Engine.'+#13+
           'Instalace je k dispozici na mých stránkách v sekci DOWNLOAD.'+#13+
           'http://home.tiscali.cz/ok2cfm'+#13+
           'Program bude ukonèen.';
  strMissingDB='Chybí datový soubor databáze - bude vytvoøen nový!';
  strMissingIndex='Chybí index databáze!';

//------------------------------------------------------------------------------
//frmHQLog
//------------------------------------------------------------------------------
  strCantSortSel='Jsou-li v deníku oznaèena spojení, nelze tøídit data.';
  strCantFilterSel='Jsou-li v deníku oznaèena spojení, nelze filtrovat data.';
  strCantUseIfSel='Tuto volbu nelze použít, jsou-li v deníku oznaèená spojení.';
  strDeleteQSOq='Opravdu chcete smazat vybrané spojení?';
  strDeleteQSOSq='Opravdu chcete smazat %0:d spojení?';
  strNoSelQSO='Nejsou vybrána žádná spojení!';
  //
  strHideColumn='Skrýt sloupec';
  //
  strFindDXCC='Vyhledání zemì DXCC';
  strCallPrefix='Znaèka (Prefix):';
  //zaloha
  strBackUpFilter='Záloha deníku';
  strBackUpLog='Zálohuji deník ...';
  strRestoreLog='Obnovuji deník ze zálohy';
  //import
  strImportZSVFilter='Databáze deníku ZSV (denik.dbf)|denik.dbf';
  strImportADIFFilter='ADIF (*.adi;*.adf)|*.adi;*.adf|Všechny soubory (*.*)|*.*';
  strImportHamLogFilter='Databáze deníku HamLog (*.db)|*.db';
  //export
  strExportADIFFilter='Formát ADIF ';
  strExportingAdif='Exportuji do formátu ADIF ...';
  strExportCSVFilter='Text oddìlený støedníky';
  strExportingCSV='Exportuji do formátu CSV ...';
  strExportTXTFilter='Text oddìlený mezerami';
  strExportingTXT='Export do formátu TXT ...';
  strExportingXLS='Odesílám aplikaci MS Excel ...';
  strExportXLSerr='Je možné exportovat maximálnì 65535 záznamù!';
  strExportSelQSOs='Exportuji vybraná spojení ...';
  //QSL
  strSortQSL='Tøídím QSL ...';
  strSortQSL1='Dvoupísmenné OK znaèky';
  strSortQSL2='Tøípísmenné OK znaèky';
  strSortQSL3='Ostatní OK znaèky';
  strSortQSL4='USA znaèky 1';
  strSortQSL5='USA znaèky 2';
  strSortQSL6='Ostatní znaèky';

//------------------------------------------------------------------------------
//frmProfile
//------------------------------------------------------------------------------
  strUsersLimit='Maximální poèet uživatelù je 10!';
  strDeleteUserQ='Opravdu chcete smazat deník "%0:s"?'#13+
    'Všechna spojení a nastavení budou vymazána!!!';
  strDeleteUserQ2='Všechna SPOJENÍ BUDOU NENÁVRATNÌ SMAZÁNA!!! Opravdu chcete pokraèovat?';

//------------------------------------------------------------------------------
//frmStatTab
//------------------------------------------------------------------------------
  strStatQSOSumHeader='Spojení: QSL/celkem';
  strStatDXCCTitle='Statistika - DXCC';
  strStatDXCCHeader='Prefix-Zemì/Pásmo';
  strStatDXCCSumHeader='Zemí: QSL/celkem';
  strStatIOTATitle='Statistika - IOTA';
  strStatIOTAHeader='Kód-Název/Pásmo';
  strStatIOTASumHeader='IOTA: QSL/celkem';
  strStatITUTitle='Statistika - ITU';
  strStatITUHeader='Region/Pásmo';
  strStatITUSumHeader='Regionù: QSL/celkem';
  strStatWAZTitle='Statistika - WAZ';
  strStatWAZHeader='Region/Pásmo';
  strStatWAZSumHeader='Regionù: QSL/celkem';
  strStatLOCTitle='Statistika - Lokátory';
  strStatLOCHeader='Lokátor/Pásmo';
  strStatLOCSumHeader='Ètvercù: QSL/celkem';
  strTotalQSL='Celkem potvrzených: %0:d';
  strTotalCount='Celkem: %0:d';
  strGenStat='Generuji sestavu ...';

//------------------------------------------------------------------------------
//frmList
//------------------------------------------------------------------------------
  strDxccList='Seznam zemí DXCC';
  strIOTAList='Seznam ostrovù IOTA';

//------------------------------------------------------------------------------
//frmImport
//------------------------------------------------------------------------------
  //import ADIF
  strImportingAdif = 'Importuji z formátu ADIF ...';
  strImportADIFres = 'Import z ADIFu';
  //import ZSV
  strImportingZSV = 'Importuji z Deníku OK1ZSV ...';
  strImportZSVres = 'Import z Deníku OK1ZSV';
  strImportZSVformatErr = 'Soubor nemá správný formát!';
  //import HamLog
  strImportingHamLog = 'Importuji z HamLogu ...';


  strImportOpenDbErr = 'Databázi nelze otevøít, nebo má neplatný formát.';
  strImportInvalidFormat = 'Neplatný formát!';

  //import
  strError = 'Chyba';
  strWarning = 'Varování';
  strImportIcount = 'Importovaných QSO: %0:d';
  strImportDcount = 'Vynechaných QSO: %0:d';
  strImportEcount = 'Poèet chyb: %0:d';
  strImportWcount = 'Poèet varování: %0:d';

//------------------------------------------------------------------------------
//DxccList
//------------------------------------------------------------------------------
  strAfrica='Afrika';
  strAsia='Asie';
  strEurope='Evropa';
  strNorthAmerica='S. Amerika';
  strSouthAmerica='J. Amerika';
  strOceania='Oceánie';

//------------------------------------------------------------------------------
//data
//------------------------------------------------------------------------------

  strNotDate='Datum musí být zadáno!';
  strDateNotValid='Neplatné datum "%0:s"!';
  strNotTime='Èas musí být zadán!';
  strTimeNotValid='Neplatný èas "%0:s"!';
  strNotCall='Znaèka musí být zadána!';
  strCallNotValid='Neplatná znaèka "%0:s" (mùže obsahovat jen znaky "A-Z, 0-9, /")!';
  strNotFreq='Frekvence musí být zadána!';
  strFreqNotValid='Neplatná frekvence "0:s"!';
  strNotHamBand='Frekvence %0:f je mimo rozsah radioamatérských pásem!';
  strNotMode='Mód musí být zadán!';
  strModeNotValid='Neplatný mód "%0:s"!';
  strNotRSTo='Chybí RSTo - doplòuji defaultní hodnotu %0:s';
  strNotRSTp='Chybí RSTp - doplòuji defaultní hodnotu %0:s';
  strLocNotValid='Neplatný lokátor "%0:s"!';
  strMyLocNotValid='Neplatný vlastní lokátor "%0:s"!';
  strDxccNotValid='Neplatný kód DXCC "%0:s"!';
  strNotDxcc='Kód DXCC musí být zadán!';
  strIotaNotValid='Neplatný formát IOTA!';
  strITUNotValid='Neplatný kód ITU "0:s" (jsou povoleny hodnoty 1 až 90)!';
  strWAZNotValid='Neplatný kód WAZ "0:s" (jsou povoleny hodnoty 1 až 40)!';
  strNotPWR='Výkon musí být zadán!';
  strPWRNotValid='Neplatný výkon!';
  strMRefDSLimit='Jsou povoleny jen hodnoty 0..89';
  strMRefDDLimit='Jsou povoleny jen hodnoty 0..179';
  strMRefMSLimit='Jsou povoleny jen hodnoty 0..59';
  strMRefNotValid='Neplatná souøadnice';


implementation

end.
