unit HQLResStrings;

interface

resourcestring
  //soubory
  strFileOpenErr='Soubor "%0:s" nelze otev��t!';
  strFileMissing='Chyb� soubor "%0:s".';


  //
  strOpenUserErr='Soubor "%0:s" nelze otev��t!'+#13+'Program bude ukon�en!';
  strOpenOptionsErr='Nelze zajistit dostate�n� p��stup k souboru "%0:s"!';
  //
  strExportFQSO='Je zapnut� filtr, bude exportov�no %0:d z�znam�.';
  strExportSelQSO='Bude exportov�no %0:d vybran�ch z�znam�.';
  //
  strDbOpenError='(DO-%0:d) Chyba p�i otev�r�n� datab�ze!';
  strPackTblError='Chyba p�i odstra�ov�n� chyb�j�c�ch index�!';
  //
  strLogInFonts='Nastavuji fonty ...';
  strLogInSyncingTime='Synchronizuji �as ...';
  strLogInCheckingUTCOffset='Kontroluji odchylku UTC ...';
  strLogInCheckingFiles='Kontroluji soubory ...';
  strLogInOpening='Otev�r�m den�k ... ';
  strSyncTimeError='Chyba p�i synchronizaci �asu se serverem "%0:s"';
  //
  strLoadingData = 'Na��t�m data ...';
  strSelectingQSOs = 'Ozna�uji spojen�...';
  //
  strTimeBias='Odchylka UTC �asu nen� pravd�podobn� spr�vn� nastavena. '+
    'Dle navrhovan�ch zm�n je pr�v� %0:s UTC.'+#13+'Chcete pou��t nov� nastaven�?';
  //DXC
  strNoDXChost='Adresa DxClusteru nen� zad�na  (Nastaven�/DxCluster/Adresa).';
  strNoDXCpass='Heslo mus� b�t zad�no (Nastaven�/DxCluster/Heslo).';
  //nastaveni
  strOptionsUserExists='U�ivatel ji� existuje!';
  strOptionsSetBackupDir='Vyberte adres�� pro z�lohy';
  strOptionsAddModeCaption='Nov� m�d';
  strOptionsMinOneMode='Mus� b�t zad�n nejm�n� jeden m�d!';
  strOptionsAddFreqCaption='Nov� frekvence';
  strOptionsFreqMaxCount='Je povoleno maxim�ln� %0:d z�znam�!';
  strFreq='Frekvence';
  strIndex='Index';
  strBand='P�smo';
  strMode='M�d';
  strNoModeSel='Mus� b�t vybr�n alespo� jeden m�d!';
  //tisk
  strPrintExport='Exportuji data pro tisk...';
  strPrintInterrupted='Tisk byl p�eru�en u�ivatelem.';
  strPrintErr='P�i tisku se vyskytla chyba.';
  //spojeni
  strQSOExitQ='Aktu�ln� spojen� nebude ulo�eno.'+#13+'Chcete pokra�ovat?';
  strSaveQSOq='Chcete ulo�it zm�ny?';
  strNoLoc='Lok�tor mus� b�t zad�n!';
  //AziDis
  strCantCountDist='Chyb� vlastn� lok�tor, nelze vypo��tat vzd�lenost!';
  strCantCountAzi='Chyb� vlastn� lok�tor, nelze vypo��tat azimut!';
  //CallBook
  strNoDataQ='Nejsou na�ten� ��dn� data.'+#13+'Chece je importovat?';
  strImportCBq='Opravdu chcete importovat novou datab�zi?'+#13+
    'P�vodn� data budou p�eps�na!';
  strImportCBfq='Data maj� pravd�podobn� nespr�vn� form�t!'+#13+'Chcete pokra�ovat?';
  //filtr
  strFilterLimit='Je dovoleno zadat maxim�ln� 50 podm�nek.';
  //nastaveni statistiky
  strNoModeSelected='Nen� vybr�n ��dn� m�d!';
  //
  strNoDir='Adres�� mus� b�t zad�n!';
  strDirNotExists='Adres�� "%0:s" neexistuje!';
  strFileOverwriteQ='Soubor "%0:s" ji� existuje!'+#13+'Chcete jej p�epsat?';
  strFileCantCreate='Soubor "%0:s" nelze vytvo�it.'+#13+
    'C�l je chr�n�n proti z�pisu, nebo nen� dostatek voln�ho m�sta.';
  //
  strQSLNote='Nastaven� pozn�mky na QSL l�stek';
  strNote='Pozn�mka:';

//------------------------------------------------------------------------------
//obecne
//------------------------------------------------------------------------------
  strExitQ='Opravdu chcete ukon�it program?';
  strNotFound='Nenalezeno ...';

//------------------------------------------------------------------------------
//soubory
//------------------------------------------------------------------------------
  strFileFormatErr='Neplatn� form�t souboru!';
  strFileVersionErr='Nezn�m� verze souboru!';
  strFileCRCErr='Neplatn� kontroln� sou�et - soubor je po�kozen!';

//------------------------------------------------------------------------------
//databaze
//------------------------------------------------------------------------------
  strNoBDE='Je pot�eba nainstalovat Borland Database Engine.'+#13+
           'Instalace je k dispozici na m�ch str�nk�ch v sekci DOWNLOAD.'+#13+
           'http://home.tiscali.cz/ok2cfm'+#13+
           'Program bude ukon�en.';
  strMissingDB='Chyb� datov� soubor datab�ze - bude vytvo�en nov�!';
  strMissingIndex='Chyb� index datab�ze!';

//------------------------------------------------------------------------------
//frmHQLog
//------------------------------------------------------------------------------
  strCantSortSel='Jsou-li v den�ku ozna�ena spojen�, nelze t��dit data.';
  strCantFilterSel='Jsou-li v den�ku ozna�ena spojen�, nelze filtrovat data.';
  strCantUseIfSel='Tuto volbu nelze pou��t, jsou-li v den�ku ozna�en� spojen�.';
  strDeleteQSOq='Opravdu chcete smazat vybran� spojen�?';
  strDeleteQSOSq='Opravdu chcete smazat %0:d spojen�?';
  strNoSelQSO='Nejsou vybr�na ��dn� spojen�!';
  //
  strHideColumn='Skr�t sloupec';
  //
  strFindDXCC='Vyhled�n� zem� DXCC';
  strCallPrefix='Zna�ka (Prefix):';
  //zaloha
  strBackUpFilter='Z�loha den�ku';
  strBackUpLog='Z�lohuji den�k ...';
  strRestoreLog='Obnovuji den�k ze z�lohy';
  //import
  strImportZSVFilter='Datab�ze den�ku ZSV (denik.dbf)|denik.dbf';
  strImportADIFFilter='ADIF (*.adi;*.adf)|*.adi;*.adf|V�echny soubory (*.*)|*.*';
  strImportHamLogFilter='Datab�ze den�ku HamLog (*.db)|*.db';
  //export
  strExportADIFFilter='Form�t ADIF ';
  strExportingAdif='Exportuji do form�tu ADIF ...';
  strExportCSVFilter='Text odd�len� st�edn�ky';
  strExportingCSV='Exportuji do form�tu CSV ...';
  strExportTXTFilter='Text odd�len� mezerami';
  strExportingTXT='Export do form�tu TXT ...';
  strExportingXLS='Odes�l�m aplikaci MS Excel ...';
  strExportXLSerr='Je mo�n� exportovat maxim�ln� 65535 z�znam�!';
  strExportSelQSOs='Exportuji vybran� spojen� ...';
  //QSL
  strSortQSL='T��d�m QSL ...';
  strSortQSL1='Dvoup�smenn� OK zna�ky';
  strSortQSL2='T��p�smenn� OK zna�ky';
  strSortQSL3='Ostatn� OK zna�ky';
  strSortQSL4='USA zna�ky 1';
  strSortQSL5='USA zna�ky 2';
  strSortQSL6='Ostatn� zna�ky';

//------------------------------------------------------------------------------
//frmProfile
//------------------------------------------------------------------------------
  strUsersLimit='Maxim�ln� po�et u�ivatel� je 10!';
  strDeleteUserQ='Opravdu chcete smazat den�k "%0:s"?'#13+
    'V�echna spojen� a nastaven� budou vymaz�na!!!';
  strDeleteUserQ2='V�echna SPOJEN� BUDOU NEN�VRATN� SMAZ�NA!!! Opravdu chcete pokra�ovat?';

//------------------------------------------------------------------------------
//frmStatTab
//------------------------------------------------------------------------------
  strStatQSOSumHeader='Spojen�: QSL/celkem';
  strStatDXCCTitle='Statistika - DXCC';
  strStatDXCCHeader='Prefix-Zem�/P�smo';
  strStatDXCCSumHeader='Zem�: QSL/celkem';
  strStatIOTATitle='Statistika - IOTA';
  strStatIOTAHeader='K�d-N�zev/P�smo';
  strStatIOTASumHeader='IOTA: QSL/celkem';
  strStatITUTitle='Statistika - ITU';
  strStatITUHeader='Region/P�smo';
  strStatITUSumHeader='Region�: QSL/celkem';
  strStatWAZTitle='Statistika - WAZ';
  strStatWAZHeader='Region/P�smo';
  strStatWAZSumHeader='Region�: QSL/celkem';
  strStatLOCTitle='Statistika - Lok�tory';
  strStatLOCHeader='Lok�tor/P�smo';
  strStatLOCSumHeader='�tverc�: QSL/celkem';
  strTotalQSL='Celkem potvrzen�ch: %0:d';
  strTotalCount='Celkem: %0:d';
  strGenStat='Generuji sestavu ...';

//------------------------------------------------------------------------------
//frmList
//------------------------------------------------------------------------------
  strDxccList='Seznam zem� DXCC';
  strIOTAList='Seznam ostrov� IOTA';

//------------------------------------------------------------------------------
//frmImport
//------------------------------------------------------------------------------
  //import ADIF
  strImportingAdif = 'Importuji z form�tu ADIF ...';
  strImportADIFres = 'Import z ADIFu';
  //import ZSV
  strImportingZSV = 'Importuji z Den�ku OK1ZSV ...';
  strImportZSVres = 'Import z Den�ku OK1ZSV';
  strImportZSVformatErr = 'Soubor nem� spr�vn� form�t!';
  //import HamLog
  strImportingHamLog = 'Importuji z HamLogu ...';


  strImportOpenDbErr = 'Datab�zi nelze otev��t, nebo m� neplatn� form�t.';
  strImportInvalidFormat = 'Neplatn� form�t!';

  //import
  strError = 'Chyba';
  strWarning = 'Varov�n�';
  strImportIcount = 'Importovan�ch QSO: %0:d';
  strImportDcount = 'Vynechan�ch QSO: %0:d';
  strImportEcount = 'Po�et chyb: %0:d';
  strImportWcount = 'Po�et varov�n�: %0:d';

//------------------------------------------------------------------------------
//DxccList
//------------------------------------------------------------------------------
  strAfrica='Afrika';
  strAsia='Asie';
  strEurope='Evropa';
  strNorthAmerica='S. Amerika';
  strSouthAmerica='J. Amerika';
  strOceania='Oce�nie';

//------------------------------------------------------------------------------
//data
//------------------------------------------------------------------------------

  strNotDate='Datum mus� b�t zad�no!';
  strDateNotValid='Neplatn� datum "%0:s"!';
  strNotTime='�as mus� b�t zad�n!';
  strTimeNotValid='Neplatn� �as "%0:s"!';
  strNotCall='Zna�ka mus� b�t zad�na!';
  strCallNotValid='Neplatn� zna�ka "%0:s" (m��e obsahovat jen znaky "A-Z, 0-9, /")!';
  strNotFreq='Frekvence mus� b�t zad�na!';
  strFreqNotValid='Neplatn� frekvence "0:s"!';
  strNotHamBand='Frekvence %0:f je mimo rozsah radioamat�rsk�ch p�sem!';
  strNotMode='M�d mus� b�t zad�n!';
  strModeNotValid='Neplatn� m�d "%0:s"!';
  strNotRSTo='Chyb� RSTo - dopl�uji defaultn� hodnotu %0:s';
  strNotRSTp='Chyb� RSTp - dopl�uji defaultn� hodnotu %0:s';
  strLocNotValid='Neplatn� lok�tor "%0:s"!';
  strMyLocNotValid='Neplatn� vlastn� lok�tor "%0:s"!';
  strDxccNotValid='Neplatn� k�d DXCC "%0:s"!';
  strNotDxcc='K�d DXCC mus� b�t zad�n!';
  strIotaNotValid='Neplatn� form�t IOTA!';
  strITUNotValid='Neplatn� k�d ITU "0:s" (jsou povoleny hodnoty 1 a� 90)!';
  strWAZNotValid='Neplatn� k�d WAZ "0:s" (jsou povoleny hodnoty 1 a� 40)!';
  strNotPWR='V�kon mus� b�t zad�n!';
  strPWRNotValid='Neplatn� v�kon!';
  strMRefDSLimit='Jsou povoleny jen hodnoty 0..89';
  strMRefDDLimit='Jsou povoleny jen hodnoty 0..179';
  strMRefMSLimit='Jsou povoleny jen hodnoty 0..59';
  strMRefNotValid='Neplatn� sou�adnice';


implementation

end.
