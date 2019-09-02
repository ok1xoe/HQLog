{$include global.inc}
program HQLog;

{%ToDo 'HQLog.todo'}

uses
  FastMM4,
  DecisionCubeBugFix,
  Windows,
  Forms,
  Controls,
  SysUtils,
  Classes,
  Dialogs,
  cfmDialogs,
  HQLConsts,
  StoHtmlHelp,
  cfmWinUtils,
  Main in 'Main.pas' {frmHQLog},
  Profile in 'Profile.pas' {frmProfile},
  Options in 'Options.pas' {frmOptions},
  QSOForm in 'QSOForm.pas' {frmQSO},
  AziDis in 'AziDis.pas',
  Filtr in 'Filtr.pas' {frmFilter},
  ImportOptions in 'ImportOptions.pas' {frmImportOptions},
  DBList in 'DBList.pas' {frmList},
  TextDialog in 'TextDialog.pas' {frmDialog},
  CallBook in 'CallBook.pas' {frmCallBook},
  dlgAziDis in 'dlgAziDis.pas' {frmAziDis},
  Kontrola in 'Kontrola.pas',
  HamLogFP in 'HamLogFP.pas',
  Amater in 'Amater.pas',
  BackUp in 'BackUp.pas',
  Import in 'Import.pas' {frmImport},
  EditSelQSOs in 'EditSelQSOs.pas' {frmEditSelQSOs},
  StatOptions in 'StatOptions.pas' {frmStatFilter},
  KeyFilters in 'KeyFilters.pas',
  ImportEdit in 'ImportEdit.pas' {frmImportEdit},
  Find in 'Find.pas' {frmFind},
  dlgComboBox in 'dlgComboBox.pas' {frmComboBox},
  OptionsIO in 'OptionsIO.pas',
  About in 'About.pas' {frmAbout},
  PrintPreview in 'PrintPreview.pas' {frmNahled},
  PrintLabels in 'PrintLabels.pas' {frmTiskQSL},
  PrintLog in 'PrintLog.pas' {frmTiskDenik},
  HQLDatabase in 'HQLDatabase.pas',
  HQLdMod in 'HQLdMod.pas' {dmLog: TDataModule},
  Dxcc in 'Dxcc.pas' {DxccList: TDataModule},
  Export in 'Export.pas',
  BackUpDialog in 'BackUpDialog.pas' {frmBackUpDlg},
  StatisticTab in 'StatisticTab.pas' {frmStatTab},
  HQLResStrings in 'HQLResStrings.pas',
  uImportLog in 'uImportLog.pas';

{$R *.res}

var
  Mutex: THandle;
  i, n: Integer;
  Call: String;
begin
  //neni uz pusteny?
  Mutex:=CreateMutex(nil, True, AppName);
  if (Mutex = 0)or(GetLastError = ERROR_ALREADY_EXISTS) then
  begin
    if Mutex <> 0 then CloseHandle(Mutex);
    ForceForeground(FindWindow(LogMainClassName, nil));
    Exit;
  end;
  try
    //overeni pritomnosti BDE v systemu
    if not CheckBDE then
    begin
      cMessageDlg(strNoBDE, mtError, [mbOk], mrOk, 0);
      Exit;
    end;
    //konfiguracni soubor / existuje? /jde otevrit pro cteni i zapis?
    try
      with TFileStream.Create(ExtractFilePath(ParamStr(0)) + Options_File,
        fmOpenReadWrite) do Free;
    except
      cMessageDlg(Format(strOpenOptionsErr, [ExtractFilePath(ParamStr(0)) + Options_File]),
        mtError, [mbOk], mrOk,0);
      Exit;
    end;
    //international settings
    DecimalSeparator := ',';
    DateSeparator := '.';
    TimeSeparator := ':';
    ShortDateFormat := 'd.M.yyyy';
    LongDateFormat := 'd. MMMM yyyy';
    ShortTimeFormat := 'h:mm';
    LongTimeFormat := 'h:mm:ss';
    //inicializace
    with Application do
    begin
      ShowMainForm:=False;
      Title:=AppName;
      HelpFile:=ExtractFilePath(ParamStr(0)) + Help_File;
    end;
    StoHelpViewer.HtmlExt := '.html';
    Application.Initialize;
    //vytvoreni formularu
    frmAbout:=TfrmAbout.Create(nil);
    try
      frmAbout.SetText(sVersion, Copyright, eMailLink, wwwLink);
      frmAbout.SetProgressBar(0, 5, True);
      frmAbout.Open(False,False);
      //vytvoreni formularu
      Application.CreateForm(TdmLog, dmLog);
      frmAbout.SetProgress(1);
      Application.CreateForm(TDxccList, DxccList);
      frmAbout.SetProgress(2);
      Application.CreateForm(TfrmHQLog, frmHQLog);
      frmAbout.SetProgress(3);
      Application.CreateForm(TfrmDialog, frmDialog);
      frmAbout.SetProgress(4);
      Application.CreateForm(TfrmFilter, frmFilter);
      frmAbout.SetProgress(5);
      frmAbout.Hide;
      frmHQLog.Show;
      //
      {$ifdef TestVersion}
      cMessageDlg('Pouze zkušební verze!!', mtInformation, [mbOk], mrOk, 0);
      {$endif}
      //vyber uzivatele
      n:=0;
      for i:=0 to 9 do
        if dmLog.Options.User[i] <> '' then
        begin
          Inc(n);
          Call:=dmLog.Options.User[i];
        end;
      if n = 1 then frmHQLog.OpenLog(Call) else
      if ParamStr(1) <> '' then
      begin
        Call:=UpperCase(ParamStr(1));
        for i:=0 to 9 do
          if dmLog.Options.User[i] = Call then frmHQLog.OpenLog(Call);
      end;
      if dmLog.User.Call = '' then
      begin
        frmProfile:=TfrmProfile.Create(nil);
        try
          frmProfile.btnCancel.Action:=frmProfile.actExit;
          if frmProfile.ShowModal <> mrOk then Exit;
        finally
          frmProfile.Release;
        end;
      end;
    finally
      frmAbout.Release;
    end;
    Application.Run;
  finally
    Call:='';
    ReleaseMutex(Mutex);
    CloseHandle(Mutex);
  end;
end.
