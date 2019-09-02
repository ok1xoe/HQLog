{$include global.inc}
unit Import;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBTables, Grids, DBGrids, HQLResStrings, StdCtrls, ComCtrls,
  ToolWin, ActnList, XPStyleActnCtrls, ActnMan, StrUtils, HamLogFP,
  Math, cfmDialogs, CfmDbGrid, HQLDatabase, HQLConsts,
  ExtCtrls, cfmCharSet, cfmFileUtils, cfmCRC, uImportLog, cfmGeography,
  cfmADIF;

type
  //Import options
  TImportOptions = record
    Charset: TCharset;
    CheckDupe, ImportSTXSRX, RewriteNote: Boolean;
    //
    PWR: Double;
    LOCo, Note: String;
  end;

  //TfrmImport
  TfrmImport = class(TForm)
    dsImport: TDataSource;
    tblImport: TTable;
    tlBar: TToolBar;
    tlBtnEdit: TToolButton;
    tlBtnDelete: TToolButton;
    actManager: TActionManager;
    actEdit: TAction;
    actDelete: TAction;
    actSelect: TAction;
    lBoxErr: TListBox;
    ToolButton1: TToolButton;
    tlBtnImport: TToolButton;
    tlBtnCancel: TToolButton;
    actImport: TAction;
    actCancel: TAction;
    ToolButton4: TToolButton;
    actCharSet: TAction;
    actSelectAll: TAction;
    actSelectNone: TAction;
    dbGrid: TCfmDBGrid;
    spltDataLog: TSplitter;
    actHelp: TAction;
    qSource: TQuery;
    qLog: TQuery;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure dbGridDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure actDeleteExecute(Sender: TObject);
    procedure actEditExecute(Sender: TObject);
    procedure actSelectExecute(Sender: TObject);
    procedure lBoxErrClick(Sender: TObject);
    procedure actCancelExecute(Sender: TObject);
    procedure actCharSetExecute(Sender: TObject);
    procedure actImportExecute(Sender: TObject);
    procedure actSelectAllExecute(Sender: TObject);
    procedure actSelectNoneExecute(Sender: TObject);
    procedure dbGridKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure actHelpExecute(Sender: TObject);
  private
    { Private declarations }
    ImportLog: TImportLog;
    ErrorCnt, WarningCnt, SkippedCnt, ImportedCnt: Integer;
    //
    ImportOptions: TImportOptions;
    LogPosition: Integer;
    //
    procedure AdifOnTag(Parser: TAdifParser; Identifier: Cardinal; Data: PChar; DataLength: Integer);
    procedure AdifOnEndRecord(Parser: TAdifParser; Position, Size: Cardinal);
    procedure AdifOnBeginRecord(Parser: TAdifParser; Position, Size: Cardinal);
    //
    procedure NastavRozliseni;
    procedure OnSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;
    procedure AddError(const Text: String; Data: array of const);
    procedure AddWarning(const Text: String; Data: array of const);
    procedure ResetCounters;
    procedure AddImportResult;
  public
    { Public declarations }
    function ImportADIF(const FileName, LogName: String;
      const Options: TImportOptions): Boolean;
    function ImportZSV(const FileName, LogName: String;
      const Options: TImportOptions): Boolean;
    function ImportHamLog(const FileName: String;
      const Options: TImportOptions): Boolean;
  end;

var
  frmImport: TfrmImport;

implementation

uses Main, Amater, ImportEdit, TextDialog, Kontrola, AziDis, EditSelQSOs,
  HQLdMod, Dxcc;

{$R *.dfm}

//vykresleni mrizky spojeni
procedure TfrmImport.dbGridDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
  jeCursor,jeSel:Boolean;

 procedure CenterTextOut(Canvas: TCanvas; Rect: TRect; Text: PChar);
 const
   Options=DT_CENTER or DT_VCENTER or DT_NOPREFIX or DT_SINGLELINE;
 begin
   Windows.FillRect(Canvas.Handle, Rect, Canvas.Brush.Handle);
   Windows.DrawText(Canvas.Handle, Text, -1,Rect, Options);
 end;

begin
  if tblImport.ControlsDisabled then Exit;
  TDbGrid(Sender).Canvas.Lock;
  with TDbGrid(Sender), Canvas do
  try
    jeCursor:=gdSelected in State;
    jeSel:=SelectedRows.CurrentRowSelected;
    //cursor
    if jeCursor then
    begin
      Font.Color:=clOfOddRow;
      Brush.Color:=clOfCursor;
    end;
    //oznaceny
    if jeSel then
    begin
      Font.Color:=clOfSelText;
      Brush.Color:=clOfselRow;
    end;
    //oznaceny + cursor
    if jeSel and jeCursor then
    begin
      Font.Color:=clOfselRow;
      Brush.Color:=clOfCursor;
    end;
    //
    if tblImport.RecordCount = 0 then FillRect(Rect) else
    case Column.Field.Index of
      dfiL_Date: CenterTextOut(Canvas, Rect, PChar(FormatDateTime(DateLFormat, Column.Field.AsDateTime)));
      dfiL_Time: CenterTextOut(Canvas, Rect, PChar(FormatDateTime(TimeSFormat, Column.Field.AsDateTime)));
      dfiL_Mode: CenterTextOut(Canvas, Rect, hModeName[Column.Field.AsInteger]);
      dfiL_QSLo: CenterTextOut(Canvas, Rect, hQSLo[Column.Field.AsInteger]);
      dfiL_QSLp: CenterTextOut(Canvas, Rect, hQSLp[Column.Field.AsInteger]);
    else
      DefaultDrawColumnCell(Rect, DataCol, Column, State);
    end;
  except
  end;
  TDbGrid(Sender).Canvas.UnLock;
end;

//------------------------------------------------------------------------------
//vytvoreni formulare
procedure TfrmImport.FormCreate(Sender: TObject);
begin
  ImportLog:=TImportLog.Create;
  //
  NastavRozliseni;
  //
  qLog.DatabaseName:=BDEAlias;
  tblImport.DatabaseName:=dmLog.TempDir;
  tblImport.TableName:=TempDB_dFile;
  //vytvorit TEMPy
  CreateLogDB(tblImport);
  tblImport.Open;
end;

//uvolneni formulare
procedure TfrmImport.FormDestroy(Sender: TObject);
begin
  ImportLog.Free;
  //
  tblImport.Close;
  //smazat TEMPy
  DeleteFile(dmLog.TempDir+TempDB_dFile);
  DeleteFile(dmLog.TempDir+TempDB_iFile);
end;

procedure TfrmImport.OnSysCommand(var Msg: TWMSysCommand);
begin
  if Msg.CmdType=SC_MINIMIZE then ShowWindow(Application.Handle,SW_SHOWMINNOACTIVE)
                             else inherited;
end;

//pridat chybu
procedure TfrmImport.AddError(const Text: String; Data: Array of const);
begin
  try
    lBoxErr.Items.Append(
      '(' + IntToStr(tblImport.RecordCount+1) + ') ' + strError + ': ' +
      Format(Text, Data)
    );
    Inc(ErrorCnt);
  except
  end;
end;

//pridat varovani
procedure TfrmImport.AddWarning(const Text: String; Data: Array of const);
begin
//  try
    lBoxErr.Items.Append(
      '(' + IntToStr(tblImport.RecordCount+1) + ') ' + strWarning + ': ' +
      Format(Text, Data)
    );
    Inc(WarningCnt);
//  except
//  end;
end;


//
procedure TfrmImport.ResetCounters;
begin
  ErrorCnt:=0;
  WarningCnt:=0;
  SkippedCnt:=0;
  ImportedCnt:=0;
end;

//
procedure TfrmImport.AddImportResult;
begin
  with lBoxErr.Items do
  begin
    Insert(0, '--------------------------------------------------------------------------');
    Insert(0, Format(strImportWcount, [WarningCnt]));
    Insert(0, Format(strImportEcount, [ErrorCnt]));
    Insert(0, Format(strImportDcount, [SkippedCnt]));
    Insert(0, Format(strImportIcount, [ImportedCnt]));
  end;
end;

//------------------------------------------------------------------------------

// nastaveni rozmeru pro ruzna rozliseni
procedure TfrmImport.NastavRozliseni;
const
  w1024: Array[0..17] of Integer = (35,60,50,90,40,38,24,24,70,70,48,48,38,26,26,80,170,30);
  w1152: Array[0..17] of Integer = (35,60,50,100,40,40,25,25,90,90,48,48,40,26,26,100,220,30);
  w1280: Array[0..17] of Integer = (40,65,55,100,50,45,30,30,100,100,48,48,38,26,26,140,250,30);

 procedure SetSize(const Columns:Array of Integer);
 var
   i:Integer;
 begin
   for i:=0 to High(Columns) do dbGrid.Columns[i].Width:=Columns[i];
 end;

begin
  case GetSystemMetrics(SM_CXSCREEN) of
    1024: SetSize(w1024);
    1152: SetSize(w1152);
    1280..1600: SetSize(w1280);
  end;
end;

//------------------------------------------------------------------------------

//help
procedure TfrmImport.actHelpExecute(Sender: TObject);
begin
  Application.HelpJump(Name);
end;

//smazani spojeni
procedure TfrmImport.actDeleteExecute(Sender: TObject);
var
  i:Integer;
begin
  if tblImport.RecordCount=0 then Exit;
  if dbGrid.SelectedRows.Count=0 then
  begin
    if cMessageDlg(strDeleteQSOq,mtConfirmation,[mbYes,mbNo],mrNo,0)=mrNo then Exit;
    tblImport.Delete;
  end else
  begin
    if cMessageDlg(Format(strDeleteQSOSq,[dbGrid.SelectedRows.Count]),
                   mtConfirmation,[mbYes,mbNo],mrNo,0)=mrNo then Exit;
    for i:=0 to dbGrid.SelectedRows.Count-1 do
    begin
      tblImport.GotoBookmark(Pointer(dbGrid.SelectedRows.Items[i]));
      tblImport.Delete;
    end;
    dbGrid.SelectedRows.Clear;
  end;
end;

//editace spojeni
procedure TfrmImport.actEditExecute(Sender: TObject);
var
  i,ActRec,FieldIndex:Integer;
  Value:String;
begin
  if tblImport.RecordCount=0 then Exit;
  if dbGrid.SelectedRows.Count=0 then
  begin
    frmImportEdit:=TfrmImportEdit.Create(nil);
    with frmImportEdit,tblImport,tblImport.Fields do
    try
      ShowModal;
      if ModalResult=mrOk then
      try
        DxccList.FindDxcc(edtDxcc.Text);
        Edit;
        Fields[dfiL_Date].AsString:=edtDate.Text;
        Fields[dfiL_Time].AsString:=edtTime.Text;
        Fields[dfiL_Call].AsString:=edtCall.Text;
        Fields[dfiL_Freq].AsString:=cbBoxFreq.Text;
        Fields[dfiL_Band].AsInteger:=GetHamBand(StrToFloat(cbBoxFreq.Text));
        Fields[dfiL_Mode].AsInteger:=GetHamMode(cbBoxMode.Text);
        Fields[dfiL_RSTo].AsString:=edtRSTo.Text;
        Fields[dfiL_RSTp].AsString:=edtRSTp.Text;
        Fields[dfiL_Name].AsString:=edtName.Text;
        Fields[dfiL_QTH].AsString:=edtQTH.Text;
        Fields[dfiL_LOCo].AsString:=edtLOCo.Text;
        Fields[dfiL_LOCp].AsString:=edtLOCp.Text;
        Fields[dfiL_QSLo].AsInteger:=cbBoxQSLo.ItemIndex;
        Fields[dfiL_QSLp].AsInteger:=cbBoxQSLp.ItemIndex;
        Fields[dfiL_QSLvia].AsString:=edtQSLvia.Text;
        Fields[dfiL_EQSLp].AsInteger:=cbBoxEQSL.ItemIndex;
        Fields[dfiL_Note].AsString:=edtNote.Text;
        Fields[dfiL_PWR].AsString:=cbBoxPWR.Text;
        Fields[dfiL_QRB].AsInteger:=GetDistance(edtLOCo.Text,edtLOCp.Text,
                                                DxccList.Longitude,
                                                DxccList.Latitude);
        Fields[dfiL_DXCC].AsString:=edtDXCC.Text;
        Fields[dfiL_IOTA].AsString:=edtIOTA.Text;
        Fields[dfiL_Award].AsString:=edtAward.Text;
        Fields[dfiL_ITU].AsString:=edtITU.Text;
        Fields[dfiL_WAZ].AsString:=edtWAZ.Text;
        Post;
      except
      end;
    finally
      frmImportEdit.Release;
    end;
  end else
  begin
    frmEditSelQSOs:=TfrmEditSelQSOs.Create(nil);
    tblImport.DisableControls;
    ActRec:=tblImport.RecNo;
    with frmEditSelQSOs,tblImport,tblImport.Fields do
    try
      ShowModal;
      if ModalResult=mrOk then
      begin
        FieldIndex:=EdtFields[cbBoxField.ItemIndex];
        Value:=cbBoxValue.Text;
        case FieldIndex of
          dfiL_LOCp,dfiL_LOCo,dfiL_DXCC,dfiL_IOTA,dfiL_Award: Value:=UpperCase(Value);
          dfiL_Mode,dfiL_QSLo,dfiL_QSLp: Value:=IntToStr(cbBoxValue.ItemIndex);
        end;
        for i:=0 to dbGrid.SelectedRows.Count-1 do
        begin
          GotoBookmark(Pointer(dbGrid.SelectedRows.Items[i]));
          Edit;
          Fields[FieldIndex].AsString:=Value;
          if FieldIndex=dfiL_Freq then
            Fields[dfiL_Band].AsInteger:=GetHamBand(Fields[FieldIndex].AsFloat);
          Post;
        end;
      end
    finally
      frmEditSelQSOs.Release;
      tblImport.RecNo:=ActRec;
      tblImport.EnableControls;
    end;
  end;
end;

procedure TfrmImport.actCharSetExecute(Sender: TObject);
begin
  if tblImport.RecordCount=0 then Exit;
  tblImport.DisableControls;
  with tblImport,tblImport.Fields do
  try
    First;
    while not Eof do
    begin
      Edit;
      Post;
      Next;
    end;
  finally
    tblImport.EnableControls;
  end;
end;

//oznaceni spojeni
procedure TfrmImport.actSelectExecute(Sender: TObject);
begin
  with dbGrid.SelectedRows do CurrentRowSelected:=not CurrentRowSelected;
  tblImport.Next;
end;

//oznaceni vsech spojeni
procedure TfrmImport.actSelectAllExecute(Sender: TObject);
var
  ActRec:Integer;
begin
  if tblImport.RecordCount=0 then Exit;
  tblImport.DisableControls;
  ActRec:=tblImport.RecNo;
  try
    tblImport.First;
    while not tblImport.Eof do
    begin
      dbGrid.SelectedRows.CurrentRowSelected:=True;
      tblImport.Next;
    end;
  finally
    tblImport.RecNo:=ActRec;
    tblImport.EnableControls;
  end;
end;

//odoznaceni spojeni
procedure TfrmImport.actSelectNoneExecute(Sender: TObject);
begin
  dbGrid.SelectedRows.Clear;
end;

//uzavreni formulare
procedure TfrmImport.actCancelExecute(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

//importovani spojeni
procedure TfrmImport.actImportExecute(Sender: TObject);
var
  tblDenik:TTable;
begin
  if (not tblImport.Active)or(tblImport.RecordCount=0) then
  begin
    ModalResult:=mrCancel;
    Exit;
  end;
  frmDialog.Zobraz(strImportingAdif);
  tblDenik:=TTable.Create(nil);
  try
    tblImport.DisableControls;
    try
      tblDenik.DatabaseName:=BDEAlias;
      tblDenik.TableName:=dmLog.User.Call;
      tblDenik.Open;
      tblDenik.BatchMove(tblImport,batAppend);
    finally
      tblImport.EnableControls;
    end;
  finally
    tblDenik.Close;
    tblDenik.Free;
    ModalResult:=mrOk;
    frmDialog.Close;
  end;
end;

//------------------------------------------------------------------------------
//klavesa
procedure TfrmImport.dbGridKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=107 then actSelectAllExecute(actSelectAll);
  if Key=109 then actSelectNoneExecute(actSelectAll);
end;

//------------------------------------------------------------------------------
//klik na Log
procedure TfrmImport.lBoxErrClick(Sender: TObject);
var
  str:String;
  RecNo:Integer;
begin
  str:=lBoxErr.Items.Strings[lBoxErr.ItemIndex];
  if (str<>'')and(str[1]='(') then
  begin
    RecNo:=PosEx(')',str,2);
    if RecNo=0 then Exit;
    try
      RecNo:=StrToInt(Copy(str,2,RecNo-2));
      tblImport.FindKey([RecNo]);
    except
    end;
  end;
end;

//------------------------------------------------------------------------------
//import z ADIF
//------------------------------------------------------------------------------

function TfrmImport.ImportADIF(const FileName, LogName: String;
  const Options: TImportOptions): Boolean;
var
//  t: Cardinal;
  ADIF: TAdifParser;
begin
  ImportOptions:=Options;
  LogPosition:=0;
  frmDialog.ZobrazProg(strImportingADIF, 0, 100);
  try
    ResetCounters;
    //otevrit vstupni soubor
    ADIF:=TAdifParser.Create;
    try
      ADIF.OnBeginOfRecord:=AdifOnBeginRecord;
      ADIF.OnEndOfRecord:=AdifOnEndRecord;
      ADIF.OnTagFound:=AdifOnTag;
      //otevrit denik pro hledani duplikatu
      qLog.SQL.Text:=Format('SELECT %s, %s, %s, %s, %s FROM "%s"',
        [dfnL_Date, dfnL_Time, dfnL_Freq, dfnL_Mode, dfnL_Call, LogName]);
      if Options.CheckDupe then qLog.Open;
      //import dat
      tblImport.DisableControls;
      try
//        t:=GetTickCount;
        ADIF.ParseFile(FileName);
//        showmessage(inttostr(GetTickCount-t));
      finally
        tblImport.EnableControls;
      end;
    finally
      ADIF.Free;
    end;
    //zobrazit okno importu
    AddImportResult;
    Result:=ShowModal = mrOk;
  finally
    qLog.Close;
    qSource.Close;
    frmDialog.Close;
  end;
end;

procedure TfrmImport.AdifOnBeginRecord(Parser: TAdifParser; Position, Size: Cardinal);
begin
  tblImport.Insert;
end;

procedure TfrmImport.AdifOnTag(Parser: TAdifParser; Identifier: Cardinal; Data: PChar; DataLength: Integer);
var
  tmp: PChar;
  i: Integer;
  f: Extended;
  d: Double;
  DateTime: TDateTime;
  Mode: THamMode;
begin
  if Data = '' then Exit;
  //odstranit prebytecne mezery (zacatek, konec)
  i:=Length(Data);
  tmp:=@Data[i];
  while (Data < tmp)and(Data[0] = ' ') do Inc(Data);
  i:=Length(Data) - 1;
  while (i > 0)and(Data[i] = ' ') do Dec(i);
  Data[i + 1]:=#0;
  //
  with tblImport.Fields do
  case Identifier of
    //datum
    adiQSO_DATE:
      if TryADIFToDate(Data, DateTime) then
        Fields[dfiL_Date].AsDateTime:=DateTime
      else
        AddError(strDateNotValid, [Data]);
    //cas
    adiTIME_ON:
      if TryADIFToTime(Data, DateTime) then
        Fields[dfiL_Time].AsDateTime:=DateTime
      else
        AddError(strTimeNotValid, [Data]);
    //znacka
    adiCALL: begin
      StrUpper(Data);
      if JeZnacka2(Data) then
        Fields[dfiL_Call].AsString:=Data
      else
        AddError(strCallNotValid, [Data]);
    end;
    //mod
    adiMODE: begin
      StrUpper(Data);
      Mode:=GetHamMode(Data, hmNone);
      if Mode <> hmNone then
        Fields[dfiL_Mode].AsInteger:=Integer(Mode)
      else
        AddError(strModeNotValid, [Data]);
    end;
    //frekvence
    adiFREQ:
    try
      tmp:=StrScan(Data, '.');
      if tmp <> nil then tmp^:=DecimalSeparator;
       d:=StrToFloat(Data);
//       d:=RoundTo(StrToFloat(Data), -4);
      if d = 0 then Exit;
      Fields[dfiL_Freq].AsFloat:=d;
      if GetHamBand(d) = High(hBandName) then
        AddWarning(strNotHamBand, [d]);
    except
       AddError(strFreqNotValid, [Data]);
    end;
    //band
    adiBAND: begin
      StrLower(Data);
      for i:=Low(hBandName) to High(hBandName)-1 do
         if StrComp(Data, hBandName[i]) = 0 then
        begin
          Fields[dfiL_Band].AsInteger:=i;
          Break;
        end;
    end;
    //RSTo
     adiRST_SENT: Fields[dfiL_RSTo].AsString:=Copy(Data, 1, 3);
    //RSTp
    adiRST_RCVD: Fields[dfiL_RSTp].AsString:=Copy(Data, 1, 3);
    //STX
    adiSTX:
      if ImportOptions.ImportSTXSRX then Fields[dfiL_Name].AsString:=Data;
    //SRX
    adiSRX:
      if ImportOptions.ImportSTXSRX then Fields[dfiL_QTH].AsString:=Data;
    //jmeno
    adiNAME:
      if not ImportOptions.ImportSTXSRX then
      begin
         CharsetConvert(Data, ImportOptions.CharSet);
        Fields[dfiL_Name].AsString:=Data;
      end;
    //qth
    adiQTH:
      if not ImportOptions.ImportSTXSRX then
      begin
        CharsetConvert(Data, ImportOptions.CharSet);
        Fields[dfiL_QTH].AsString:=Data;
      end;
    //LOCo
    adiMY_GRIDSQUARE: begin
      StrUpper(Data);
      if IsWWL(Data) then
        Fields[dfiL_LOCo].AsString:=Data
      else
        AddError(strMyLocNotValid, [Data]);
    end;
    //LOCp
    adiGRIDSQUARE, adiWWL_RCVD: begin
      StrUpper(Data);
      if StrLen(Data) = 4 then Data:=PChar(Data + 'MM');
      if IsWWL(Data, True) then
        Fields[dfiL_LOCp].AsString:=Data
      else
        AddError(strLocNotValid, [Data]);
    end;
    //qsl via
    adiQSL_VIA: Fields[dfiL_QSLvia].AsString:=Data;
    //QSLo
    adiQSL_SENT: begin
      StrUpper(Data);
      if Data <> '' then
        case Data[0] of
          'Y': Fields[dfiL_QSLo].AsInteger:=qoYes;
          'N': Fields[dfiL_QSLo].AsInteger:=qoNo;
          'R': Fields[dfiL_QSLo].AsInteger:=qoRequested;
         'I': Fields[dfiL_QSLo].AsInteger:=qoInvalid;
        end;
    end;
    //QSLp
    adiQSL_RCVD: begin
      StrUpper(Data);
      if Data <> '' then
        case Data[0] of
          'Y': Fields[dfiL_QSLp].AsInteger:=qpYes;
          'N', 'R', 'I': Fields[dfiL_QSLp].AsInteger:=qpNo;
        end;
    end;
   //eQSL
    adiEQSL_RCVD: begin
      StrUpper(Data);
      if (Data <> '')and(Data[0] = 'Y') then Fields[dfiL_EQSLp].AsInteger:=1;
    end;
    //vykon
    adiTX_PWR: begin
      tmp:=StrScan(Data, '.');
      if tmp <> nil then tmp^:=DecimalSeparator;
      if TextToFloat(Data, f, fvExtended) then
        Fields[dfiL_PWR].AsFloat:=f
      else
       Fields[dfiL_PWR].AsFloat:=ImportOptions.PWR;
    end;
    //poznamka
    adiCOMMENT, adiNOTES:
      if not ImportOptions.RewriteNote then
      begin
        CharsetConvert(Data, ImportOptions.CharSet);
        Fields[dfiL_Note].AsString:=Data;
     end;
    //IOTA
    adiIOTA: begin
      StrUpper(Data);
      tmp:=StrScan(Data, '-');
      if tmp <> nil then
        while tmp^ <> #0 do
        begin
          tmp^:=tmp[1];
          Inc(tmp);
        end;
      if JeIOTA2(Data) then
        Fields[dfiL_IOTA].AsString:=Data
      else
        AddError(strIOTANotValid, [Data]);
    end;
    //ITU
    adiITUZ: begin
      i:=StrToITU(Data);
      if i <> -1 then
        Fields[dfiL_ITU].AsInteger:=i
      else
        AddError(strITUNotValid, [Data]);
    end;
    //WAZ
    adiCQZ: begin
      i:=StrToWAZ(Data);
      Fields[dfiL_WAZ].AsInteger:=i;
      if i = -1 then AddError(strWAZNotValid, [Data]);
    end;
    //DXCC
    adiDXCCP: begin
      StrUpper(Data);
      if JeZnacka2(Data) then
        Fields[dfiL_DXCC].AsString:=Data
      else
        AddError(strDxccNotValid, [Data]);
    end;
    //award
    adiAWARD: begin
      StrUpper(Data);
      Fields[dfiL_Award].AsString:=Data;
    end;
  end;
end;

procedure TfrmImport.AdifOnEndRecord(Parser: TAdifParser; Position, Size: Cardinal);
begin
   with tblImport.Fields do
   begin
     //kontrola -> vynadat -> doplnit
     //datum
     if Fields[dfiL_Date].IsNull then AddError(strNotDate, []);
     //cas
     if Fields[dfiL_Time].IsNull then AddError(strNotTime, []);
     //znacka
     if Fields[dfiL_Call].IsNull then AddError(strNotCall, []);
     //doplnit frekvenci/pasmo
     if (not Fields[dfiL_Freq].IsNull)and(Fields[dfiL_Band].IsNull) then
       Fields[dfiL_Band].AsInteger:=GetHamBand(Fields[dfiL_Freq].AsFloat) else
     if (not Fields[dfiL_Band].IsNull)and(Fields[dfiL_Freq].IsNull) then
       Fields[dfiL_Freq].AsFloat:=hBandBegin[Fields[dfiL_Band].AsInteger];
     //frekvence
     if Fields[dfiL_Freq].IsNull then
     begin
       Fields[dfiL_Freq].AsFloat:=0;
       AddError(strNotFreq, []);
     end;
     //pasmo
     if Fields[dfiL_Band].IsNull then
       Fields[dfiL_Band].AsInteger:=High(hBandName);
     //mod
     if Fields[dfiL_Mode].IsNull then
     begin
       Fields[dfiL_Mode].AsInteger:=Integer(hmNone);
       AddError(strNotMode, []);
     end;
     //RSTo
     if Fields[dfiL_RSTo].IsNull then
     begin
       if Fields[dfiL_Mode].AsInteger in hFoneModes then
         Fields[dfiL_RSTo].AsString:='59'
       else
         Fields[dfiL_RSTo].AsString:='599';
       AddWarning(strNotRSTo, [Fields[dfiL_RSTo].AsString]);
     end;
     //RSTp
     if Fields[dfiL_RSTp].IsNull then
     begin
       if Fields[dfiL_Mode].AsInteger in hFoneModes then
         Fields[dfiL_RSTp].AsString:='59'
       else
         Fields[dfiL_RSTp].AsString:='599';
       AddWarning(strNotRSTp, [Fields[dfiL_RSTp].AsString]);
     end;
     //LOCo
     if Fields[dfiL_LOCo].IsNull then Fields[dfiL_LOCo].AsString:=ImportOptions.LOCo;
     //OSLo
     if Fields[dfiL_QSLo].IsNull then Fields[dfiL_QSLo].AsInteger:=qoNo;
     //QSLp
     if Fields[dfiL_QSLp].IsNull then Fields[dfiL_QSLp].AsInteger:=qpNo;
     //eQSL
     if Fields[dfiL_EQSLp].IsNull then Fields[dfiL_EQSLp].AsInteger:=eqNo;
     //PWR
     if Fields[dfiL_PWR].IsNull then  Fields[dfiL_PWR].AsFloat:=ImportOptions.PWR;
     //DXCC
     if Fields[dfiL_DXCC].IsNull then
     begin
       DxccList.FindDXCC(Fields[dfiL_Call].AsString);
       Fields[dfiL_DXCC].AsString:=DxccList.DXCC;
     end else
       DxccList.GotoDXCC(Fields[dfiL_Dxcc].AsString);
     //QRB
     Fields[dfiL_QRB].AsFloat:=GetDistance(
       Fields[dfiL_LOCo].AsString,
       Fields[dfiL_LOCp].AsString,
       DxccList.Longitude,
       DxccList.Latitude);
     //ITU
     if Fields[dfiL_ITU].IsNull then Fields[dfiL_ITU].AsInteger:=DxccList.ITU;
     //WAZ
     if Fields[dfiL_WAZ].IsNull then Fields[dfiL_WAZ].AsInteger:=DxccList.WAZ;
     //poznamka
     if ImportOptions.RewriteNote then
       Fields[dfiL_Note].AsString:=ImportOptions.Note;
     //ulozit zaznam, kdyz neni duplicitni
     if (not ImportOptions.CheckDupe)or
        (not qLog.Locate(
       dfnL_Date+ ';' + dfnL_Time + ';' + dfnL_Freq + ';' + dfnL_Mode + ';' + dfnL_Call,
       VarArrayOf([Fields[dfiL_Date].AsDateTime, Fields[dfiL_Time].AsDateTime,
                   Fields[dfiL_Freq].AsFloat, Fields[dfiL_Mode].AsInteger,
                   Fields[dfiL_Call].AsString]),
       [])) then
     begin
       tblImport.Post;
       Inc(ImportedCnt);
       LogPosition:=lBoxErr.Items.Count;
     end else
     begin
       tblImport.Cancel;
       Inc(SkippedCnt);
       //vymazat zaznamy v logu pro preskoceny zaznam
       while lBoxErr.Items.Count > LogPosition do
         lBoxErr.Items.Delete(lBoxErr.Items.Count - 1);
     end;
     //zacit dalsi zaznam
     tblImport.Insert;
   end;
   //
   frmDialog.OnProgress(Round(100*(Position/Size)));
end;

//------------------------------------------------------------------------------
//import z deniku ZSV
//------------------------------------------------------------------------------

function TfrmImport.ImportZSV(const FileName, LogName: String;
  const Options: TImportOptions): Boolean;
const
  FieldNames: Array[0..20] of String = (
    'datum', 'cas1', 'cas2', 'znacka', 'pomzn', 'jmeno', 'mesto',
    'reporto', 'reportp', 'kmitocet', 'mod', 'vykon', 'qslo', 'qslp',
    'poznamka', 'lokator', 'lokator_vl', 'vzdalenost', 'idx_datum',
    'idx_znac', 'qsl_via');

 //presun dat
 procedure CopyData;
 var
   i: Integer;
   str: PChar;
 begin
   frmDialog.ZobrazProg(strImportingHamLog, 0, qSource.RecordCount-1);
   //
   with qSource, qSource.Fields do
   while not Eof do
   begin
     tblImport.Insert;
     //
     //datum
     try
       tblImport.Fields.Fields[dfiL_Date]:=Fields[0];
     except
       tblImport.Fields.Fields[dfiL_Date].AsDateTime:=0;
       AddError(strDateNotValid, [Fields[0].AsString]);
     end;
     //cas
     try
       tblImport.Fields.Fields[dfiL_Time]:=Fields[1];
     except
       tblImport.Fields.Fields[dfiL_Time].AsDateTime:=0;
       AddError(strTimeNotValid, [Fields[1].AsString]);
     end;
     //znacka
     if JeZnacka2(Fields[3].AsString) then tblImport.Fields.Fields[dfiL_Call]:=Fields[3] else
     begin
       tblImport.Fields.Fields[dfiL_Call].AsString:='';
       AddError(strCallNotValid, [Fields[3].AsString]);
     end;
     DxccList.FindDxcc(tblImport.Fields.Fields[dfiL_Call].AsString);
     //frekvence+pasmo
     try
       tblImport.Fields.Fields[dfiL_Freq]:=Fields[9];
       i:=GetHamBand(Fields[9].AsFloat);
       tblImport.Fields.Fields[dfiL_Band].AsInteger:=i;
       if i = High(hBandName) then
         AddWarning(strNotHamBand, [Fields[9].AsString]);
     except
       tblImport.Fields.Fields[dfiL_Freq].AsFloat:=0;
       tblImport.Fields.Fields[dfiL_Band].AsInteger:=High(hBandName);
       AddError(strFreqNotValid, [Fields[4].AsString]);
     end;
     //mod
     i:=GetHamMode(Fields[10].AsString, hmNone);
     if i <> hmNone then
       tblImport.Fields.Fields[dfiL_Mode].AsInteger:=GetHamMode(Fields[10].AsString, hmCW)
     else begin
       tblImport.Fields.Fields[dfiL_Mode].AsInteger:=0;
       AddError(strModeNotValid, [Fields[10].AsString]);
     end;
     //RSTo
     tblImport.Fields.Fields[dfiL_RSTo].AsString:=Fields[7].AsString;
     //RSTp
     tblImport.Fields.Fields[dfiL_RSTp].AsString:=Fields[8].AsString;
     //jmeno
     str:=PChar(Fields[5].AsString);
     CharsetConvert(str, Options.Charset);
     tblImport.Fields.Fields[dfiL_Name].AsString:=str;
     //qth
     str:=PChar(Fields[6].AsString);
     CharsetConvert(str, Options.Charset);
     tblImport.Fields.Fields[dfiL_QTH].AsString:=str;
     //LOCo
     if IsWWL(Fields[16].AsString) then
       tblImport.Fields.Fields[dfiL_LOCo].AsString:=Fields[16].AsString
     else begin
       tblImport.Fields.Fields[dfiL_LOCo].AsString:=Options.LOCo;
       AddError(strLocNotValid, [Fields[16].AsString]);
     end;
     //LOCp
     if IsWWL(Fields[15].AsString, True) then
       tblImport.Fields.Fields[dfiL_LOCp].AsString:=Fields[15].AsString
     else
       AddError(strLocNotValid, [Fields[15].AsString]);
     //QSLo
     if Fields[12].AsBoolean then
       tblImport.Fields.Fields[dfiL_QSLo].AsInteger:=qoYes
     else
       tblImport.Fields.Fields[dfiL_QSLo].AsInteger:=qoNo;
     //QSLp
     if Fields[13].AsBoolean then
       tblImport.Fields.Fields[dfiL_QSLp].AsInteger:=qpYes
     else
       tblImport.Fields.Fields[dfiL_QSLp].AsInteger:=qpNo;
     //QSLvia
     tblImport.Fields.Fields[dfiL_QSLvia].AsString:=Fields[20].AsString;
     //EQSL
     tblImport.Fields.Fields[dfiL_EQSLp].AsInteger:=eqNo;
     //note
     str:=PChar(Fields[14].AsString);
     CharsetConvert(str, Options.Charset);
     if Options.RewriteNote then
       tblImport.Fields.Fields[dfiL_Note].AsString:=Options.Note
     else
       tblImport.Fields.Fields[dfiL_Note].AsString:=str;
     //PWR
     try
       tblImport.Fields.Fields[dfiL_PWR].AsFloat:=Fields[11].AsFloat;
     except
       tblImport.Fields.Fields[dfiL_PWR].AsFloat:=Options.PWR;
       AddError(strPwrNotValid, [Fields[17].AsString]);
     end;
     //QRB
     tblImport.Fields.Fields[dfiL_QRB].AsFloat:=GetDistance(
       tblImport.Fields.Fields[dfiL_LOCo].AsString,
       tblImport.Fields.Fields[dfiL_LOCp].AsString,
       DxccList.Longitude,
       DxccList.Latitude);
     //DXCC
     tblImport.Fields.Fields[dfiL_DXCC].AsString:=DxccList.DXCC;
     //IOTA
     tblImport.Fields.Fields[dfiL_IOTA].AsString:='';
     //ITU
     tblImport.Fields.Fields[dfiL_ITU].AsInteger:=DxccList.ITU;
     //WAZ
     tblImport.Fields.Fields[dfiL_WAZ].AsInteger:=DxccList.WAZ;
     //
     tblImport.Post;
     Next;
     Inc(ImportedCnt);
     frmDialog.OnProgress(RecNo);
   end;
 end;

begin
  Result:=False;
  frmDialog.Zobraz(strImportingHamLog);
  try
    ResetCounters;
    //otevrit vstupni databazi
    qSource.DatabaseName:=ExtractFilePath(FileName);
    qSource.SQL.Text:=Format('SELECT * FROM "%s" ORDER BY datum, cas1',
      [ExtractFileName(FileName)]);
    try
      qSource.Open;
    except
      cMessageDlg(strImportOpenDbErr, mtError, [mbOk], mrOk, 0);
      Exit;
    end;
    //kontrola formatu
    if not CheckFields(qSource, FieldNames) then
    begin
      cMessageDlg(strImportInvalidFormat, mtError, [mbOk], mrOk, 0);
      Exit;
    end;
    //import dat
    tblImport.DisableControls;
    try
      CopyData;
    finally
      tblImport.EnableControls;
    end;
    //zobrazit okno importu
    AddImportResult;
    Result:=ShowModal = mrOk;
  finally
    qSource.Close;
    frmDialog.Close;
  end;
end;

//------------------------------------------------------------------------------
//import z HamLogu
//------------------------------------------------------------------------------

function TfrmImport.ImportHamLog(const FileName: String;
  const Options: TImportOptions): Boolean;
const
  FieldNames: Array[0..18] of String = (
    'cislo', 'datum', 'utc', 'call', 'mhz', 'mod', 'rst_o', 'rst_p', 'jmeno',
    'qth', 'loc', 'loc_vl', 'qsl_mgr', 'qsl_o', 'qsl_p', 'poznamka', 'pwr',
    'vzdal', 'dxcc');

 //presun dat
 procedure CopyData;
 var
   i: Integer;
   Mode: THamMode;
 begin
   if qSource.RecordCount = 0 then Exit;
   frmDialog.ZobrazProg(strImportingHamLog, 0, qSource.RecordCount-1);
   //
   with qSource, qSource.Fields do
   while not Eof do
   begin
     tblImport.Insert;
     //datum
     tblImport.Fields.Fields[dfiL_Date]:=Fields[1];
     //cas
     tblImport.Fields.Fields[dfiL_Time]:=Fields[2];
     //znacka
     tblImport.Fields.Fields[dfiL_Call]:=Fields[3];
     //frekvence + pasmo
     tblImport.Fields.Fields[dfiL_Freq]:=Fields[4];
     i:=GetHamBand(Fields[4].AsFloat);
     tblImport.Fields.Fields[dfiL_Band].AsInteger:=i;
     if i = High(hBandName) then AddWarning(strNotHamBand, [Fields[4].AsFloat]);
     //mod
     Mode:=GetHamMode(Fields[5].AsString, hmNone);
     tblImport.Fields.Fields[dfiL_Mode].AsInteger:=Integer(Mode);
     if Mode = hmNone then AddError(strModeNotValid, [Fields[5].AsString]);
     //RSTo
     tblImport.Fields.Fields[dfiL_RSTo].AsString:=Fields[6].AsString;
     //RSTp
     tblImport.Fields.Fields[dfiL_RSTp].AsString:=Fields[7].AsString;
     //jmeno
     tblImport.Fields.Fields[dfiL_Name].AsString:=Fields[8].AsString;
     //qth
     tblImport.Fields.Fields[dfiL_QTH].AsString:=Fields[9].AsString;
     //LOCo
     if Fields[11].AsString <> '' then
       tblImport.Fields.Fields[dfiL_LOCo].AsString:=Fields[11].AsString
     else
       tblImport.Fields.Fields[dfiL_LOCo].AsString:=Options.LOCo;
     //LOCp
     tblImport.Fields.Fields[dfiL_LOCp].AsString:=Fields[10].AsString;
     //QSLo
     if Fields[13].AsBoolean then
       tblImport.Fields.Fields[dfiL_QSLo].AsInteger:=1
     else
       tblImport.Fields.Fields[dfiL_QSLo].AsInteger:=0;
     //QSLp
     if Fields[14].AsBoolean then
       tblImport.Fields.Fields[dfiL_QSLp].AsInteger:=1
     else
       tblImport.Fields.Fields[dfiL_QSLp].AsInteger:=0;
     //QSLvia
     tblImport.Fields.Fields[dfiL_QSLvia].AsString:=Fields[12].AsString;
     //EQSL
     tblImport.Fields.Fields[dfiL_EQSLp].AsInteger:=0;
     //note
     if Options.RewriteNote then
       tblImport.Fields.Fields[dfiL_Note].AsString:=Options.Note
     else
       tblImport.Fields.Fields[dfiL_Note].AsString:=Fields[15].AsString;
     //PWR
     tblImport.Fields.Fields[dfiL_PWR].AsFloat:=Fields[16].AsFloat;
     //QRB
     tblImport.Fields.Fields[dfiL_QRB].AsFloat:=Fields[17].AsFloat;
     //DXCC
     tblImport.Fields.Fields[dfiL_DXCC].AsString:=Fields[18].AsString;
     DxccList.GotoDXCC(Fields[18].AsString);
     //IOTA
     tblImport.Fields.Fields[dfiL_IOTA].AsString:='';
     //ITU
     tblImport.Fields.Fields[dfiL_ITU].AsInteger:=DxccList.ITU;
     //WAZ
     tblImport.Fields.Fields[dfiL_WAZ].AsInteger:=DxccList.WAZ;
     //
     tblImport.Post;
     Next;
     Inc(ImportedCnt);
     frmDialog.OnProgress(RecNo);
   end;
 end;

begin
  Result:=False;
  frmDialog.Zobraz(strImportingHamLog);
  try
    ResetCounters;
    //otevrit vstupni databazi
    qSource.DatabaseName:=ExtractFilePath(FileName);
    qSource.SQL.Text:=Format('SELECT * FROM "%s" ORDER BY datum, utc, cislo',
      [ExtractFileName(FileName)]);
    try
      qSource.Open;
    except
      cMessageDlg(strImportOpenDbErr, mtError, [mbOk], mrOk, 0);
      Exit;
    end;
    //kontrola formatu
    if not CheckFields(qSource, FieldNames) then
    begin
      cMessageDlg(strImportInvalidFormat, mtError, [mbOk], mrOk, 0);
      Exit;
    end;
    //import dat
    tblImport.DisableControls;
    try
      CopyData;
    finally
      tblImport.EnableControls;
    end;
    //zobrazit okno importu
    AddImportResult;
    Result:=ShowModal = mrOk;
  finally
    qSource.Close;
    frmDialog.Close;
  end;
end;

end.
