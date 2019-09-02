{$include global.inc}
unit Main;

interface

uses
  Windows, Menus, Dialogs, DBTables, AppEvnts, DB, ImgList, Controls,
  Classes, ActnList, XPStyleActnCtrls, ActnMan, Grids,
  DBGrids, ToolWin, ActnCtrls, ActnMenus, Forms, IniFiles,
  SysUtils, Messages, Graphics, BDE, ActnColorMaps, StdCtrls, HamLogFP,
  DBCtrls, ExtCtrls, OleServer, ShellApi, HQLResStrings,
  DateUtils, StrUtils, cfmDialogs, CfmDbGrid, cfmCharSet,
  IdSNTP, OptionsIO, HQLMessages, HQLDatabase, HQLConsts, ComCtrls,
  ActnPopupCtrl;

type
  //
  TfrmHQLog = class(TForm)
    qLog: TQuery;
    dsLog: TDataSource;
    //
    mnBarHlavni: TActionMainMenuBar;
    tlBar: TToolBar;
    pnlQSO: TPanel;
    stBarHlavni: TStatusBar;
    //
    actManager: TActionManager;
    //
    lblDXCC: TLabel;
    lblNote: TLabel;
    lblQSLMgr: TLabel;
    lblLOCo: TLabel;
    lblIOTA: TLabel;
    dbtDXCC: TDBText;
    dbtNote: TDBText;
    dbtQSLMgr: TDBText;
    dbtLOCo: TDBText;
    dbtIOTA: TDBText;
    dbgLog: TCfmDBGrid;
    Bevel1: TBevel;
    //
    tlBtnNewQSO: TToolButton;
    tlBtnShowQSO: TToolButton;
    tlBtnEditQSO: TToolButton;
    tlBtnDeleteQSO: TToolButton;
    tlBtnFindQSO: TToolButton;
    tlBtnFiltr: TToolButton;
    tlBtnSelQSO: TToolButton;
    tlBtnFirstQSO: TToolButton;
    tlBtnLastQSO: TToolButton;
    tlBtnSelectLog: TToolButton;
    tlBtnExit: TToolButton;
    tlBtnSep2: TToolButton;
    tlBtnSep4: TToolButton;
    tlBtnSep1: TToolButton;
    tlBtnSep3: TToolButton;
    tlBtnSep6: TToolButton;
    //
    actEnd: TAction;
    actNewQSO: TAction;
    actShowQSO: TAction;
    actEditQSO: TAction;
    actDeleteQSO: TAction;
    actSortByDateTime: TAction;
    actSortByCall: TAction;
    actSortByFreq: TAction;
    actSortByLOCp: TAction;
    actSortByQSLo: TAction;
    actSortByQSLp: TAction;
    actSortByQTH: TAction;
    actSortByName: TAction;
    actSortByQRB: TAction;
    actSortByMode: TAction;
    actFilter: TAction;
    actFindQSO: TAction;
    actDXCCList: TAction;
    actSelectLog: TAction;
    actOptions: TAction;
    actHelpAbout: TAction;
    actFirstQSO: TAction;
    actLastQSO: TAction;
    acBackUpLog: TAction;
    acRestoreLog: TAction;
    actImportZSV: TAction;
    actImportADIF: TAction;
    actExportAdif: TAction;
    actPrintQSL: TAction;
    actSelQSO: TAction;
    actSelAllQSO: TAction;
    actSelNoneQSO: TAction;
    actPrintLog: TAction;
    actCallBook: TAction;
    actAziDis: TAction;
    actExportCSV: TAction;
    actExportXLS: TAction;
    actHelpHistory: TAction;
    actHelp: TAction;
    actMapa: TAction;
    actIOTAList: TAction;
    actExportTXT: TAction;
    actDxCluster: TAction;
    actFindDXCC: TAction;
    actSortByBand: TAction;
    actSortByLOCo: TAction;
    actSortByQSLmgr: TAction;
    actSortByNote: TAction;
    actSortByPWR: TAction;
    actSortByDxcc: TAction;
    actSortByIOTA: TAction;
    actSortByITU: TAction;
    actSortByWAZ: TAction;
    actSortByEQSL: TAction;
    actQSLoN: TAction;
    actQSLoY: TAction;
    actQSLoR: TAction;
    actQSLoI: TAction;
    actQSLpN: TAction;
    actQSLpY: TAction;
    actEQSLN: TAction;
    actEQSLY: TAction;
    actExportADIFshort: TAction;
    actStatTab: TAction;
    actSortByAward: TAction;
    actImportHamLog: TAction;
    pmMain: TPopupActionBarEx;
    pmColumns: TPopupActionBarEx;
    pmSelectQSO: TPopupActionBarEx;
    miShowQSO: TMenuItem;
    miEditQSO: TMenuItem;
    miDeleteQSO: TMenuItem;
    N2: TMenuItem;
    miSelQSO: TMenuItem;
    miSelAllQSO: TMenuItem;
    miSelNoneQSO: TMenuItem;
    //
    procedure FormCreate(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    //
    procedure ShowHint(var HintStr: String;
      var CanShow: Boolean; var HintInfo: THintInfo);
    //DbGrid
    procedure dbgLogDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure dbgLogKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dbgLogMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure dbgLogTitleClick(Column: TColumn);
    //
    procedure stBarHlavniDrawPanel(StatusBar: TStatusBar;
      Panel: TStatusPanel; const Rect: TRect);
    procedure OnHint(Sender: TObject);
    //
    procedure pmColumnsPopup(Sender: TObject);
    procedure ShowHideColumn(Sender: TObject);
    //qLog
    procedure qLogAfterOpen(DataSet: TDataSet);
    procedure qLogAfterScroll(DataSet: TDataSet);
    //
    procedure pmMainPopup(Sender: TObject);
    //
    procedure FindDialogActivate(Sender: TObject);
    //
    procedure actEndExecute(Sender: TObject);
    procedure actSelectLogExecute(Sender: TObject);
    procedure actOptionsExecute(Sender: TObject);
    procedure actSortExecute(Sender: TObject);
    procedure actNewQSOExecute(Sender: TObject);
    procedure actShowQSOExecute(Sender: TObject);
    procedure actEditQSOExecute(Sender: TObject);
    procedure actDeleteQSOExecute(Sender: TObject);
    procedure actFindQSOExecute(Sender: TObject);
    procedure actHelpAboutExecute(Sender: TObject);
    procedure actFilterExecute(Sender: TObject);
    procedure actFirstQSOExecute(Sender: TObject);
    procedure actLastQSOExecute(Sender: TObject);
    procedure acBackUpLogExecute(Sender: TObject);
    procedure actImportExecute(Sender: TObject);
    procedure actSelQSOExecute(Sender: TObject);
    procedure actSelAllQSOExecute(Sender: TObject);
    procedure actSelNoneQSOExecute(Sender: TObject);
    procedure actPrintQSLExecute(Sender: TObject);
    procedure actPrintLogExecute(Sender: TObject);
    procedure actCallBookExecute(Sender: TObject);
    procedure actAziDisExecute(Sender: TObject);
    procedure actExportAdifExecute(Sender: TObject);
    procedure actExportADIFshortExecute(Sender: TObject);
    procedure actExportCSVExecute(Sender: TObject);
    procedure actExportTXTExecute(Sender: TObject);
    procedure actExportXLSExecute(Sender: TObject);
    procedure actHelpHistoryExecute(Sender: TObject);
    procedure actHelpExecute(Sender: TObject);
    procedure actMapaExecute(Sender: TObject);
    procedure acRestoreLogExecute(Sender: TObject);
    procedure actDxClusterExecute(Sender: TObject);
    procedure actFindDXCCExecute(Sender: TObject);
    procedure actSeznamExecute(Sender: TObject);
    procedure actSetQSLExecute(Sender: TObject);
    procedure actStatTabExecute(Sender: TObject);
    procedure actImportHamLogExecute(Sender: TObject);
    procedure actImportZSVExecute(Sender: TObject);
  private
    { Private declarations }
    fOrderBy: Integer;
    //
    procedure EditQSOs;
    procedure DeleteQSO;
    procedure ExportQSLProgress(const Progress:Integer);
    //
    procedure OnCopyData(var msg: TWMCopyData); message wm_copydata;
  public
    { Public declarations }
    SqlFiltr:TStrings;
    //
    procedure OpenLog(const Call:String);
    procedure CloseLog;
    procedure SortLog(OrderBy:Integer; const Force:Boolean);
    procedure RefreshLog(const Info: Boolean; const KeepPos: Boolean = True);
    //
    procedure SetQSL(const FieldIndex,Data:Integer);
  end;

var
  frmHQLog:TfrmHQLog;

implementation
{$R *.dfm}
uses
  Profile, Options, QSOForm, Filtr, DBList, TextDialog, CallBook, dlgAziDis,
  Kontrola, Amater, BackUp, Import, ImportOptions,
  EditSelQSOs, StatOptions, dlgComboBox, AziDis,
  About, PrintLabels, PrintLog, HQLdMod, Dxcc, Export,
  BackUpDialog, StatisticTab, Find;

//------------------------------------------------------------------------------
//frmHQLog
//------------------------------------------------------------------------------

//pri startu programu
procedure TfrmHQLog.FormCreate(Sender: TObject);
begin
  Application.OnHint:=OnHint;
  Application.OnHelp:=OnHelp;
  frmFind:=TfrmFind.Create(Self);
  frmFind.InitDialog(qLog, dbgLog,
    [dfiL_Call, dfiL_LOCp, dfiL_LOCo, dfiL_IOTA, dfiL_Date, dfiL_Name,
     dfiL_QTH, dfiL_QSLvia, dfiL_Note],
    [ftCall, ftLOC, ftLOC, ftIOTA, ftDate, ftText, ftText, ftText, ftText],
    [dfL_Caption[dfiL_Call], dfL_Caption[dfiL_LOCp], dfL_Caption[dfiL_LOCo],
     dfL_Caption[dfiL_IOTA], dfL_Caption[dfiL_Date], dfL_Caption[dfiL_Name],
     dfL_Caption[dfiL_QTH], dfL_Caption[dfiL_QSLvia], dfL_Caption[dfiL_Note]]);
  frmFind.OnActivate:=FindDialogActivate;
  //
  qLog.DatabaseName:=BDEAlias;
  //vytvoreni promenne pro filtr
  SqlFiltr:=TStringList.Create;
  //
  actDxCluster.Enabled:=FileExists(dmLog.RootDir+DxCluster_App);
  actHelp.Enabled:=FileExists(dmLog.RootDir+Help_File);
  actHelpHistory.Enabled:=actHelp.Enabled;
end;

//
procedure TfrmHQLog.FormActivate(Sender: TObject);
begin
//  actManager.State:=asNormal;
end;

//
procedure TfrmHQLog.FormDeactivate(Sender: TObject);
begin
//  actManager.State:=asSuspended;
end;

//dotaz na ukonceni
procedure TfrmHQLog.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if cMessageDlg(strExitQ, mtConfirmation, [mbYes, mbNo], mrYes, 0)=mrNo then
    CanClose:=False;
end;

//pri ukonceni programu
procedure TfrmHQLog.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  CloseLog;
end;

procedure TfrmHQLog.FormDestroy(Sender: TObject);
begin
  //zavreni databaze pro vyhledavani DXCC
  SqlFiltr.Free;
  DxccList.Free;
end;

//------------------------------------------------------------------------------

//vypis Hintu do StatusBaru
procedure TfrmHQLog.ShowHint(var HintStr: String;
  var CanShow: Boolean; var HintInfo: THintInfo);
begin
  stBarHlavni.Panels.Items[2].Text:=' '+Application.Hint;
end;

//------------------------------------------------------------------------------

//konec
procedure TfrmHQLog.actEndExecute(Sender: TObject);
begin
  Close;
end;

//------------------------------------------------------------------------------
//DbGrid
//------------------------------------------------------------------------------

//vykresleni mrizky QSO
procedure TfrmHQLog.dbgLogDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);
var
  jeCursor,jeSel:Boolean;

 procedure aTextOut(Canvas:TCanvas; Rect:TRect; Alignment:TAlignment; Text:PChar);
 begin
   Windows.FillRect(Canvas.Handle, Rect, Canvas.Brush.Handle);
   Inc(Rect.Left, 3);
   Dec(Rect.Right, 3);
   case Alignment of
     taCenter: Windows.DrawText(Canvas.Handle, Text, -1, Rect,
       DT_CENTER or DT_VCENTER or DT_NOPREFIX or DT_SINGLELINE);
     taRightJustify: Windows.DrawText(Canvas.Handle, Text, -1, Rect,
       DT_RIGHT or DT_VCENTER or DT_NOPREFIX or DT_SINGLELINE);
   else
     Windows.DrawText(Canvas.Handle, Text, -1, Rect,
       DT_LEFT or DT_VCENTER or DT_NOPREFIX or DT_SINGLELINE);
   end;
 end;

begin
  if qLog.ControlsDisabled then Exit;
  TDbGrid(Sender).Canvas.Lock;
  with TDbGrid(Sender),Canvas do
  try
    if Odd(qLog.RecNo) then Brush.Color:=clOfOddRow
                       else Brush.Color:=clOfEvenRow;
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
    if qLog.RecordCount=0 then FillRect(Rect) else
    case Column.Field.Index of
      dfiL_Band: aTextOut(Canvas,Rect, Column.Alignment, hBandName[Column.Field.AsInteger]);
      dfiL_Mode: aTextOut(Canvas, Rect, Column.Alignment, hModeName[Column.Field.AsInteger]);
      dfiL_QSLo: aTextOut(Canvas, Rect, Column.Alignment, hQSLo[Column.Field.AsInteger]);
      dfiL_QSLp: aTextOut(Canvas, Rect, Column.Alignment, hQSLo[Column.Field.AsInteger]);
      dfiL_EQSLp: aTextOut(Canvas, Rect,Column.Alignment, hEQSL[Column.Field.AsInteger]);
    else
      DefaultDrawColumnCell(Rect, DataCol, Column, State);
    end;
  finally
    TDbGrid(Sender).Canvas.UnLock;
  end;
end;

//dbGrid KeyDown
procedure TfrmHQLog.dbgLogKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=107 then actSelAllQSO.Execute;
  if key=109 then actSelNoneQSO.Execute;
  if Key=vk_Return then actShowQSO.Execute;
end;

//dbGrid MouseUp
procedure TfrmHQLog.dbgLogMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  case Button of
    //leve
    mbLeft: if Shift = [ssShift] then with dbgLog.SelectedRows do
      CurrentRowSelected:=not CurrentRowSelected;
    //prave
    mbRight: begin
      //oznacovani spojeni s Shiftem
      if Shift = [] then
        if dbgLog.MouseCoord(x, y).Y = 0
          then pmColumns.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y)
          else pmMain.Popup(Mouse.CursorPos.X, Mouse.CursorPos.Y);
    end;
  end;
end;

procedure TfrmHQLog.dbgLogTitleClick(Column: TColumn);
begin
  with dbgLog,dbgLog.Columns do
    if SelectedRows.Count = 0
      then SortLog(Column.Field.Index,False)
      else cMessageDlg(strCantSortSel, mtInformation, [mbOk], mrOk, 0);
end;

//------------------------------------------------------------------------------
//stBar
//------------------------------------------------------------------------------

//vykresleni panelu
procedure TfrmHQLog.stBarHlavniDrawPanel(StatusBar: TStatusBar;
  Panel: TStatusPanel; const Rect: TRect);
var
  r:TRect;
begin
  with StatusBar.Canvas do
  case Panel.Index of
    1: if qLog.Active then begin
      r:=Rect;
      Dec(r.Right, 45);
      Font.Color:=clBlack;
      TextRect(r, r.Left+2, r.Top+2, Copy(Panel.Text, 1, 8));
      r:=Rect;
      Inc(r.Left, 45);
      Font.Color:=clGreen;
      TextRect(r, r.Left+2, r.Top+2, IntToStr(dbgLog.SelectedRows.Count));
    end;
  end;
end;

procedure TfrmHQLog.OnHint(Sender: TObject);
begin
  stBarHlavni.Panels.Items[2].Text:=' '+Application.Hint;
end;

//------------------------------------------------------------------------------
//poMnColumns
//------------------------------------------------------------------------------

//vytvoreni popup menu se seznamem sloupcu
procedure TfrmHQLog.pmColumnsPopup(Sender: TObject);
var
  Item: TMenuItem;
  i: Integer;
  p: TPoint;
  c: TGridCoord;
begin
  with TPopupActionBarEx(Sender), dbgLog do
  begin
    Items.Clear;
    //
    p:=ScreenToClient(Mouse.CursorPos);
    c:=MouseCoord(p.X, p.Y);
    Item:=TMenuItem.Create(Self);
    Item.Caption:=strHideColumn;
    Item.OnClick:=ShowHideColumn;
    if c.X > 0 then
    begin
      Item.Enabled:=True;
      Item.Tag:=Columns.Items[c.X - 1].Field.Index;
    end else
      Item.Enabled:=False;
    Items.Add(Item);
    Item:=TMenuItem.Create(Self);
    Item.Caption:='-';
    Items.Add(Item);
    //
    for i:=0 to Columns.Count-1 do
    begin
      Item:=TMenuItem.Create(Self);
      Item.Caption:=Columns.Items[i].Title.Caption;
      Item.Tag:=Columns.Items[i].Field.Index;
      Item.OnClick:=ShowHideColumn;
      Item.Checked:=Columns.Items[i].Visible;
      Items.Add(Item);
    end;
  end;
end;

//zobrazeni/shovani sloupce - popup menu
procedure TfrmHQLog.ShowHideColumn(Sender: TObject);
var
  i:Integer;
begin
  for i:=0 to dbgLog.Columns.Count-1 do
    with dbgLog.Columns.Items[i] do
      if FieldName=dfL_Name[TMenuItem(Sender).Tag] then
      begin
        Visible:=not Visible;
        dmLog.User.SetColumnVisible(FieldName, Visible);
        Exit;
      end;
end;

//------------------------------------------------------------------------------
//qLog
//------------------------------------------------------------------------------

//po otevreni
procedure TfrmHQLog.qLogAfterOpen(DataSet: TDataSet);
var
  Enabled:Boolean;
begin
  (qLog.Fields.Fields[dfiL_Date] as TDateTimeField).DisplayFormat:=
    DateFormats[dmLog.User.Design_DateFormat];
  (qLog.Fields.Fields[dfiL_Time] as TDateTimeField).DisplayFormat:=
    TimeFormats[dmLog.User.Design_TimeFormat];
  (qLog.Fields.Fields[dfiL_Freq] as TFloatField).DisplayFormat:=
    FreqFormats[dmLog.User.Design_FreqFormat];
  (qLog.Fields.Fields[dfiL_QRB] as TFloatField).DisplayFormat:='0';
  //
  Enabled:=DataSet.RecordCount<>0;
  actShowQSO.Enabled:=Enabled;
  actEditQSO.Enabled:=Enabled;
  actDeleteQSO.Enabled:=Enabled;
  actFindQSO.Enabled:=Enabled;
  actStatTab.Enabled:=Enabled;
  actSelQSO.Enabled:=Enabled;
  actSelAllQSO.Enabled:=Enabled;
  actSelNoneQSO.Enabled:=Enabled;
  actQSLoN.Enabled:=Enabled;
  actQSLoY.Enabled:=Enabled;
  actQSLoR.Enabled:=Enabled;
  actQSLoI.Enabled:=Enabled;
  actQSLpN.Enabled:=Enabled;
  actQSLpY.Enabled:=Enabled;
  actEQSLN.Enabled:=Enabled;
  actEQSLY.Enabled:=Enabled;
  actPrintQSL.Enabled:=Enabled;
  actPrintLog.Enabled:=Enabled;
  actExportAdif.Enabled:=Enabled;
  actExportADIFshort.Enabled:=Enabled;
  actExportCSV.Enabled:=Enabled;
  actExportTXT.Enabled:=Enabled;
  actExportXLS.Enabled:=Enabled;
end;

//pri pohybu kurzoru
procedure TfrmHQLog.qLogAfterScroll(DataSet: TDataSet);
begin
  if (DataSet.ControlsDisabled) then Exit;
  actFirstQSO.Enabled:=(DataSet.RecordCount <> 0)and(DataSet.RecNo <> 1);
  actLastQSO.Enabled:=DataSet.RecNo <> DataSet.RecordCount;
  stBarHlavni.Panels.Items[0].Text:=Format(' Záznam: %0:5d z %1:5d',
    [qLog.RecNo, qLog.RecordCount]);
  stBarHlavni.Panels.Items[1].Text:='Vybráno:' + IntToStr(dbgLog.SelectedRows.Count);
  stBarHlavni.Update;
end;

//------------------------------------------------------------------------------

//hlavni popupmenu
procedure TfrmHQLog.pmMainPopup(Sender: TObject);
begin
  with miSelQSO do
  begin
    if dbgLog.SelectedRows.CurrentRowSelected then
    begin
      Caption:='Odoznaèit';
      Hint:='Odoznaèit aktuální spojení';
    end else
    begin
      Caption:='Oznaèit';
      Hint:='Oznaèit aktuální spojení';
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmHQLog.FindDialogActivate(Sender: TObject);
begin
  actManager.State:=asNormal;
end;

//------------------------------------------------------------------------------
//menu Spojeni
//------------------------------------------------------------------------------

//nove spojeni
procedure TfrmHQLog.actNewQSOExecute(Sender: TObject);
begin
  //odoznacit spojeni
  dbgLog.SelectedRows.Clear;
  //setrideni deniku
  if actFilter.Checked then
  begin
    actFilter.Checked:=False;
    SortLog(dfiL_Date,True);
  end else SortLog(dfiL_Date, False);
  qLog.Last;
  //
  frmQSO:=TfrmQSO.Create(nil, fsNewQSO);
  try
    frmQSO.ShowModal;
  finally
    frmQSO.Release;
  end;
end;

//zobrazit spojeni
procedure TfrmHQLog.actShowQSOExecute(Sender: TObject);
begin
  //neni denik nahodou prazdny???!!! + nejsou oznacena spojeni?
  if qLog.RecordCount=0 then Exit;
  frmQSO:=TfrmQSO.Create(nil, fsShowQSO);
  try
    frmQSO.ShowModal;
  finally
    frmQSO.Release;
  end;
end;

//upravit spojeni
procedure TfrmHQLog.actEditQSOExecute(Sender: TObject);
begin
  //neni denik nahodou prazdny???!!!
  if qLog.RecordCount=0 then Exit;
  if dbgLog.SelectedRows.Count=0 then
  begin
    frmQSO:=TfrmQSO.Create(nil, fsEditQSO);
    try
      frmQSO.ShowModal;
    finally
      frmQSO.Release;
    end;
  end else EditQSOs;
end;

//smazat spojeni
procedure TfrmHQLog.actDeleteQSOExecute(Sender: TObject);
begin
  //neni denik nahodou prazdny???!!!
  if qLog.RecordCount=0 then Exit;
  //
  if dbgLog.SelectedRows.Count=0 then
  begin
    if cMessageDlg(strDeleteQSOq, mtConfirmation, [mbYes, mbNo], mrNo,0)=mrNo then Exit
  end else
  begin
    if cMessageDlg(Format(strDeleteQSOSq,[dbgLog.SelectedRows.Count]),
                   mtConfirmation, [mbYes, mbNo], mrNo, 0)=mrNo then Exit;
  end;
  DeleteQSO;
end;

//------------------------------------------------------------------------------
//menu Tridit
//------------------------------------------------------------------------------

procedure TfrmHQLog.actSortExecute(Sender: TObject);
var
  FieldIndex:Integer;
begin
  if dbgLog.SelectedRows.Count<>0 then
  begin
    cMessageDlg(strCantSortSel, mtInformation, [mbOk], mrOk, 0);
    Exit;
  end;
  FieldIndex:=-1;
  if Sender=actSortByDateTime then FieldIndex:=dfiL_Date;
  if Sender=actSortByCall then FieldIndex:=dfiL_Call;
  if Sender=actSortByFreq then FieldIndex:=dfiL_Freq;
  if Sender=actSortByBand then FieldIndex:=dfiL_Band;
  if Sender=actSortByMode then FieldIndex:=dfiL_Mode;
  if Sender=actSortByName then FieldIndex:=dfiL_Name;
  if Sender=actSortByQTH then FieldIndex:=dfiL_QTH;
  if Sender=actSortByLOCp then FieldIndex:=dfiL_LOCp;
  if Sender=actSortByLOCo then FieldIndex:=dfiL_LOCo;
  if Sender=actSortByQSLo then FieldIndex:=dfiL_QSLo;
  if Sender=actSortByQSLp then FieldIndex:=dfiL_QSLp;
  if Sender=actSortByEQSL then FieldIndex:=dfiL_EQSLp;
  if Sender=actSortByQSLmgr then FieldIndex:=dfiL_QSLvia;
  if Sender=actSortByNote then FieldIndex:=dfiL_Note;
  if Sender=actSortByPWR then FieldIndex:=dfiL_PWR;
  if Sender=actSortByQRB then FieldIndex:=dfiL_QRB;
  if Sender=actSortByDXCC then FieldIndex:=dfiL_DXCC;
  if Sender=actSortByIOTA then FieldIndex:=dfiL_IOTA;
  if Sender=actSortByITU then FieldIndex:=dfiL_ITU;
  if Sender=actSortByWAZ then FieldIndex:=dfiL_WAZ;
  if Sender=actSortByAward then FieldIndex:=dfiL_Award;
  SortLog(FieldIndex,False);
end;

//------------------------------------------------------------------------------
//menu Nastroje
//------------------------------------------------------------------------------

//filtr
procedure TfrmHQLog.actFilterExecute(Sender: TObject);
begin
  if (not actFilter.Checked)and(dbgLog.SelectedRows.Count>0) then
  begin
    tlBtnFiltr.Down:=False;
    cMessageDlg(strCantFilterSel, mtInformation, [mbOk], mrOk, 0);
    Exit;
  end;
  frmFilter.Filtr.Assign(SqlFiltr);
  frmFilter.ShowModal;
  if (frmFilter.ModalResult=mrOk)and(frmFilter.Filtr.Count>0) then
  begin
    actFilter.Checked:=True;
    SqlFiltr.Assign(frmFilter.Filtr);
    SortLog(-1, True);
  end;
  if (frmFilter.ModalResult=mrAbort)or((frmFilter.ModalResult=mrOk)and(frmFilter.Filtr.Count=0)) then
    begin
      actFilter.Checked:=False;
      SortLog(-1, True);
    end;
  tlBtnFiltr.Down:=actFilter.Checked;
end;

//hledat
procedure TfrmHQLog.actFindQSOExecute(Sender: TObject);
begin
  if Assigned(frmFind) then frmFind.Show;
end;

//callbook
procedure TfrmHQLog.actCallBookExecute(Sender: TObject);
begin
  frmCallBook:=TfrmCallBook.Create(nil);
  try
    frmCallBook.dsCall.DataSet.Locate('Znacka',
      qLog.Fields.Fields[dfiL_Call].AsString, []);
    frmCallBook.ShowModal;
  finally
    frmCallBook.Release;
  end;
end;

//zobrazit seznam DXCC, IOTA
procedure TfrmHQLog.actSeznamExecute(Sender: TObject);
begin
  frmList:=TfrmList.Create(nil);
  try
    if Sender=actDXCCList then frmList.InitList(lmDXCC)
                          else frmList.InitList(lmIOTA);
    frmList.ShowModal;
  finally
    frmList.Release;
  end;
end;

//sestavy DXCC, IOTA, WWL
procedure TfrmHQLog.actStatTabExecute(Sender: TObject);
begin
  frmStatTab:=TfrmStatTab.Create(nil);
  try
    frmStatTab.ShowModal;
  finally
    frmStatTab.Release;
  end;
end;

//AziDis
procedure TfrmHQLog.actAziDisExecute(Sender: TObject);
begin
  frmAziDis:=TfrmAziDis.Create(nil);
  try
    frmAziDis.ShowModal;
  finally
    frmAziDis.Release;
  end;
end;

//hledat DXCC
procedure TfrmHQLog.actFindDXCCExecute(Sender: TObject);
var
  Call:String;
begin
  frmComboBox:=TfrmComboBox.Create(nil);
  try
    if frmComboBox.ShowModal(strFindDXCC, strCallPrefix, csSimple)=mrOk
      then Call:=frmComboBox.ComboBox.Text
      else Exit;
  finally
    frmComboBox.Release;
  end;
  //
  if JeZnacka2(Call) then
    if DxccList.FindDXCC(Call) then
    begin
      frmList:=TfrmList.Create(nil);
      try
        frmList.InitList(lmDXCC);
        frmList.qList.Locate('PREFIX', DxccList.Prefix, []);
        frmList.ShowModal;
      finally
        frmList.Release;
      end;
    end else cMessageDlg(strNotFound, mtInformation, [mbOk], mrOk, 0);
end;

//DXC
procedure TfrmHQLog.actDxClusterExecute(Sender: TObject);
begin
  dmLog.OpenDXC;
end;

//------------------------------------------------------------------------------
//menu Nastaveni
//------------------------------------------------------------------------------

procedure TfrmHQLog.actSelectLogExecute(Sender: TObject);
begin
  frmProfile:=TfrmProfile.Create(nil);
  try
    frmProfile.ShowModal;
    if dmLog.User.Call='' then Application.Terminate;
  finally
    frmProfile.Release;
  end;
end;

procedure TfrmHQLog.actOptionsExecute(Sender: TObject);
begin
  frmOptions:=TfrmOptions.Create(nil,fsEditUser);
  try
    if frmOptions.ShowModal=mrOk then
    begin
      //nacist nova nastaveni
      if dmLog.User.Design_ExtendedFont then dbgLog.Font.Name:='Tahoma'
                                        else dbgLog.Font.Name:='MS Sans Serif';
      (qLog.Fields.Fields[dfiL_Date] as TDateTimeField).DisplayFormat:=
        DateFormats[dmLog.User.Design_DateFormat];
      (qLog.Fields.Fields[dfiL_Time] as TDateTimeField).DisplayFormat:=
        TimeFormats[dmLog.User.Design_TimeFormat];
      (qLog.Fields.Fields[dfiL_Freq] as TFloatField).DisplayFormat:=
        FreqFormats[dmLog.User.Design_FreqFormat];
    end;
  finally
    frmOptions.Release;
  end;
end;

//------------------------------------------------------------------------------
//menu Tisk
//------------------------------------------------------------------------------

//tisk nalepek
procedure TfrmHQLog.actPrintQSLExecute(Sender: TObject);
begin
  if dbgLog.SelectedRows.Count=0 then
  begin
    cMessageDlg(strNoSelQSO,mtInformation,[mbOk],mrOk,0);
    Exit;
  end;
  try
    frmDialog.ZobrazProg(strExportSelQSOs,0,100);
    ExportSelected(qLog, dbgLog.SelectedRows, dmLog.TempDir+TempDB_dFile,
      frmDialog.OnProgress);
    frmDialog.ZobrazProg(strSortQSL, 0, 12);
    SortQSL(dmLog.TempDir+TempDB_dFile, dmLog.TempDir+QslDB_dFile, ExportQSLProgress);
    frmDialog.Close;
    //tisk
    frmTiskQSL:=TfrmTiskQSL.Create(nil);
    try
      frmTiskQSL.ShowModal;
    finally
      frmTiskQSL.Release;
    end;
  finally
    //smazat docasne soubory
    DeleteFile(dmLog.TempDir+TempDB_dFile);
    DeleteFile(dmLog.TempDir+TempDB_iFile);
    DeleteFile(dmLog.TempDir+QslDB_dFile);
    DeleteFile(dmLog.TempDir+QslDB_iFile);
    frmDialog.Close;
  end;
end;

//tisk deniku
procedure TfrmHQLog.actPrintLogExecute(Sender: TObject);
begin
  //neni denik nahodou prazdny???!!!
  if qLog.RecordCount=0 then Exit;
  if dbgLog.SelectedRows.Count<>0 then
    ExportSelected(qLog, dbgLog.SelectedRows, dmLog.TempDir+TempDB_dFile, nil);
  //tisk
  frmTiskDenik:=TfrmTiskDenik.Create(nil);
  try
    if dbgLog.SelectedRows.Count<>0 then frmTiskDenik.rGrpRozsah.ItemIndex:=1;
    frmTiskDenik.ShowModal;
  finally
    frmTiskDenik.Release;
    //smazat docasne soubory
    DeleteFile(dmLog.TempDir+TempDB_dFile);
    DeleteFile(dmLog.TempDir+TempDB_iFile);
  end;
end;

//------------------------------------------------------------------------------
//menu Napoveda
//------------------------------------------------------------------------------

//help
procedure TfrmHQLog.actHelpExecute(Sender: TObject);
begin
  Application.HelpJump('BaseInfo')
end;

//history
procedure TfrmHQLog.actHelpHistoryExecute(Sender: TObject);
begin
  Application.HelpJump('History')
end;

//about
procedure TfrmHQLog.actHelpAboutExecute(Sender: TObject);
begin
  frmAbout:=TfrmAbout.Create(nil);
  try
    frmAbout.SetText(sVersion, Copyright, eMailLink, wwwLink);
    frmAbout.ShowModal;
  finally
    frmAbout.Release;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmHQLog.actFirstQSOExecute(Sender: TObject);
begin
  qLog.First;
end;

procedure TfrmHQLog.actLastQSOExecute(Sender: TObject);
begin
  qLog.Last;
end;

//------------------------------------------------------------------------------
//menu Data
//------------------------------------------------------------------------------

//zaloha deniku
procedure TfrmHQLog.acBackUpLogExecute(Sender: TObject);
begin
  with dmLog,dlgSave do
  begin
    DefaultExt:=zFileDefExt;
    Filter:=strBackUpFilter+' (*'+zFileExt+')|*'+zFileExt;
    InitialDir:=User.BackUp_Path;
    FileName:=User.Call+' '+FormatDateTime(DateLFormat,Now)+zFileExt;
    Options:=[ofOverwritePrompt, ofHideReadOnly, ofEnableSizing, ofDontAddToRecent];
    if not Execute then Exit;
    frmDialog.Zobraz(strBackUpLog);
    try
      BackUpLog(User.Call, DataDir, FileName);
    finally
      frmDialog.Close;
    end;
  end;
end;

//obnova deniku
procedure TfrmHQLog.acRestoreLogExecute(Sender: TObject);
var
  Call:String;
  DateTime:TDateTime;
begin
  with dmLog,dlgOpen do
  begin
    DefaultExt:=zFileDefExt;
    Filter:=strBackUpFilter+' (*'+zFileExt+')|*'+zFileExt;
    InitialDir:=User.BackUp_Path;
    Options:=[ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing, ofDontAddToRecent];
    if not Execute then Exit;
    //kontrola znacky
    GetBackUpInfo(FileName, Call, DateTime);
    frmBackUpDlg:=TfrmBackUpDlg.Create(nil);
    with frmBackUpDlg do
    try
      lblFile.Caption:=FileName;
      lblCall.Caption:=Call;
      lblDate.Caption:=FormatDateTime(DateLFormat, DateTime);
      lblTime.Caption:=FormatDateTime(TimeSFormat, DateTime);
      if ShowModal<>mrOk then Exit;
    finally
      Free;
    end;
    //
    frmDialog.Zobraz(strRestoreLog);
    qLog.Close;
    qLog.DisableControls;
    try
      dbgLog.SelectedRows.Clear;
      actFilter.Checked:=False;
      RestoreLog(User.Call, DataDir, TempDir, FileName);
    finally
      qLog.EnableControls;
      OpenLog(dmLog.User.Call);
    end;
  end;
end;

//import ADIF
procedure TfrmHQLog.actImportExecute(Sender: TObject);
var
  Import: Boolean;
  Options: TImportOptions;
begin
  //filtr
  with dmLog.dlgOpen do
  begin
    DefaultExt:='';
    Filter:=strImportADIFFilter;
    Options:=[ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing, ofDontAddToRecent];
    if not Execute then Exit;
  end;
  //nastaveni
  frmImportOptions:=TfrmImportOptions.Create(nil);
  try
    Options.LOCo:=dmLog.User.Loc;
    Options.Note:='';
    Options.PWR:=dmLog.User.nQSO_PWR;
    Options.CheckDupe:=True;
    Options.ImportSTXSRX:=False;
    Options.RewriteNote:=False;
    Options.CharSet:=cp1250;
    Import:=frmImportOptions.Execute(Options);
  finally
    frmImportOptions.Release;
  end;
  if not Import then Exit;
  //import
  frmImport:=TfrmImport.Create(nil);
  try
    if frmImport.ImportADIF(dmLog.dlgOpen.FileName, dmLog.User.Call, Options) then
      RefreshLog(True);
  finally
    frmImport.Release;
  end;
end;

{procedure TfrmHQLog.actImportExecute(Sender: TObject);
var
  LocVl, Note:String;
  Pwr:Double;
  Import, RewriteNote, CheckDupe, ImportSTXSRX:Boolean;
  CharSet:TCharSet;
begin
  //filtr
  with dmLog.dlgOpen do
  begin
    DefaultExt:='';
    if Sender=actImportZSV then Filter:=strImportZSVFilter;
    if Sender=actImportADIF then Filter:=strImportADIFFilter;
    Options:=[ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing, ofDontAddToRecent];
    if not Execute then Exit;
  end;
  Import:=False;
  LocVl:='';
  Note:='';
  Pwr:=100;
  ImportSTXSRX:=False;
  RewriteNote:=False;
  CheckDupe:=False;
  CharSet:=cp1250;
  frmImportOptions:=TfrmImportOptions.Create(nil);
  with frmImportOptions do
  try
    //
    if Sender=actImportZSV then
    begin
      chImportSTXSRX.Enabled:=False;
      chDupe.Enabled:=False;
      cbCharSet.ItemIndex:=1;
    end else cbCharSet.ItemIndex:=0;
    //
    if ShowModal=mrOk then
    begin
      Import:=True;
      LocVl:=edtLoc.Text;
      Note:=edtNote.Text;
      Pwr:=StrToFloat(cbPWR.Text);
      ImportSTXSRX:=chImportSTXSRX.Checked;
      RewriteNote:=chReplaceNote.Checked;
      CheckDupe:=chDupe.Checked;
      CharSet:=TCharSet(cbCharSet.ItemIndex);
    end;
  finally
    frmImportOptions.Release;
  end;
  if not Import then Exit;
  frmImport:=TfrmImport.Create(nil);
  try
    frmImport.ImportADIF1(dmLog.dlgOpen.FileName, LocVl, Note, Pwr, ImportSTXSRX,
      RewriteNote, CheckDupe, CharSet);
    if frmImport.ModalResult=mrOk then RefreshLog(True);
  finally
    frmImport.Release;
  end;
end;}

//import ZSV
procedure TfrmHQLog.actImportZSVExecute(Sender: TObject);
var
  Import: Boolean;
  Options: TImportOptions;
begin
  //filtr
  with dmLog.dlgOpen do
  begin
    DefaultExt:='';
    Filter:=strImportZSVFilter;
    Options:=[ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing, ofDontAddToRecent];
    if not Execute then Exit;
  end;
  //nastaveni
  frmImportOptions:=TfrmImportOptions.Create(nil);
  try
    Options.LOCo:=dmLog.User.Loc;
    Options.Note:='';
    Options.PWR:=dmLog.User.nQSO_PWR;
    Options.CheckDupe:=False;
    Options.ImportSTXSRX:=False;
    Options.RewriteNote:=False;
    Options.CharSet:=cp852;
    Import:=frmImportOptions.Execute(Options, [idoSTXSRX, idoDupe]);
  finally
    frmImportOptions.Release;
  end;
  if not Import then Exit;
  //import
  frmImport:=TfrmImport.Create(nil);
  try
    if frmImport.ImportZSV(dmLog.dlgOpen.FileName, dmLog.User.Call, Options) then
      RefreshLog(True);
  finally
    frmImport.Release;
  end;
end;

//import HamLog
procedure TfrmHQLog.actImportHamLogExecute(Sender: TObject);
var
  Import: Boolean;
  Options: TImportOptions;
begin
  //filtr
  with dmLog.dlgOpen do
  begin
    DefaultExt:='';
    Filter:=strImportHamLogFilter;
    Options:=[ofHideReadOnly, ofPathMustExist, ofFileMustExist, ofEnableSizing, ofDontAddToRecent];
    if not Execute then Exit;
  end;
  //nastaveni
  frmImportOptions:=TfrmImportOptions.Create(nil);
  try
    Options.LOCo:=dmLog.User.Loc;
    Options.Note:='';
    Options.PWR:=dmLog.User.nQSO_PWR;
    Options.CheckDupe:=False;
    Options.ImportSTXSRX:=False;
    Options.RewriteNote:=False;
    Options.CharSet:=cp852;
    frmImportOptions.chImportSTXSRX.Enabled:=False;
    Import:=frmImportOptions.Execute(Options, [idoSTXSRX, idoDupe, idoCharset]);
  finally
    frmImportOptions.Release;
  end;
  if not Import then Exit;
  //
  frmImport:=TfrmImport.Create(nil);
  try
    if frmImport.ImportHamLog(dmLog.dlgOpen.FileName, Options) then
      RefreshLog(True);
  finally
    frmImport.Release;
  end;
end;

//export ADIF
procedure TfrmHQLog.actExportAdifExecute(Sender: TObject);
begin
  if qLog.RecordCount=0 then Exit;
  with dmLog.dlgSave do
  begin
    FileName:=dmLog.User.Call;
    Options:=[ofOverwritePrompt, ofHideReadOnly, ofEnableSizing, ofDontAddToRecent];
    DefaultExt:=AdifFileDefExt;
    Filter:=strExportADIFFilter+' (*'+AdifFileExt+')|*'+AdifFileExt;
    if not Execute then Exit;
    if dbgLog.SelectedRows.Count=0
      then frmDialog.ZobrazProg(strExportingAdif, 0, 100)
      else frmDialog.ZobrazProg(strExportingAdif, 0, 100);
    try
      ExportADIF(qLog, dbgLog.SelectedRows, FileName, frmDialog.OnProgress);
    finally
      frmDialog.Close;
    end;
  end;
end;

//export ADIF pro eQSL
procedure TfrmHQLog.actExportADIFshortExecute(Sender: TObject);
var
  Note:String;
begin
  if qLog.RecordCount=0 then Exit;
  with dmLog.dlgSave do
  begin
    FileName:=dmLog.User.Call;
    Options:=[ofOverwritePrompt, ofHideReadOnly, ofEnableSizing, ofDontAddToRecent];
    DefaultExt:=AdifFileDefExt;
    Filter:=strExportADIFFilter+' (*'+AdifFileExt+')|*'+AdifFileExt;
    if not Execute then Exit;
    //
    frmComboBox:=TfrmComboBox.Create(nil);
    try
      Filter:=strExportADIFFilter+' (*'+AdifFileExt+')|*'+AdifFileExt;
      if frmComboBox.ShowModal(strQSLNote, strNote, csSimple)<>mrOk then Exit;
      Note:=frmComboBox.ComboBox.Text
    finally
      frmComboBox.Release;
    end;
    //
    frmDialog.ZobrazProg(strExportingAdif,0,100);
    try
      ExportEQSL(qLog, dbgLog.SelectedRows, Note, FileName, frmDialog.OnProgress);
    finally
      frmDialog.Close;
    end;
  end
end;

//export CSV
procedure TfrmHQLog.actExportCSVExecute(Sender: TObject);
begin
  if qLog.RecordCount=0 then Exit;
  with dmLog.dlgSave do
  begin
    FileName:=dmLog.User.Call;
    Options:=[ofOverwritePrompt, ofHideReadOnly, ofEnableSizing, ofDontAddToRecent];
    DefaultExt:=CsvFileDefExt;
    Filter:=strExportCSVFilter+' (*'+CsvFileExt+')|*'+CsvFileExt;
    if not Execute then Exit;
    //
    frmDialog.ZobrazProg(strExportingCSV, 0, 100);
    try
      ExportCSV(qLog, dbgLog.SelectedRows, FileName, frmDialog.OnProgress);
    finally
      frmDialog.Close;
    end;
  end;
end;

//export TXT
procedure TfrmHQLog.actExportTXTExecute(Sender: TObject);
begin
  if qLog.RecordCount=0 then Exit;
  with dmLog.dlgSave do
  begin
    FileName:=dmLog.User.Call;
    Options:=[ofOverwritePrompt, ofHideReadOnly, ofEnableSizing, ofDontAddToRecent];
    DefaultExt:=TxtFileDefExt;
    Filter:=strExportTXTFilter+' (*'+TxtFileExt+')|*'+TxtFileExt;
    if not Execute then Exit;
    //
    frmDialog.ZobrazProg(strExportingTXT,0,100);
    try
      ExportTXT(qLog, dbgLog.SelectedRows, FileName, frmDialog.OnProgress);
    finally
      frmDialog.Close;
    end;
  end;
end;

//excel export
procedure TfrmHQLog.actExportXLSExecute(Sender: TObject);
begin
  //neni denik nahodou prazdny???!!!
  if qLog.RecordCount=0 then Exit;
  if ((dbgLog.SelectedRows.Count=0)and(qLog.RecordCount>65535))or
     (dbgLog.SelectedRows.Count>65535) then
  begin
    cMessageDlg(strExportXLSerr, mtInformation, [mbOk], mrOk, 0);
    Exit;
  end;
  //
  frmDialog.ZobrazProg(strExportingXLS,0,100);
  try
    ExportXLS(qLog, dbgLog.SelectedRows, frmDialog.OnProgress);
  finally
    frmDialog.Close;
  end;
end;


//oznacit spojeni
procedure TfrmHQLog.actSelQSOExecute(Sender: TObject);
begin
  with dbgLog.SelectedRows do CurrentRowSelected:=not CurrentRowSelected;
  qLog.Next;
end;

//oznacit vsechna spojeni
procedure TfrmHQLog.actSelAllQSOExecute(Sender: TObject);
var
  i,ActRec:Integer;
begin
  //neprovadet 2x
  if qLog.RecordCount=dbgLog.SelectedRows.Count then Exit;
  //vybrat
  frmDialog.ZobrazProg(strSelectingQSOs, 0, qLog.RecordCount);
  ActRec:=qLog.RecNo;
  qLog.DisableControls;
  qLog.First;
  for i:=1 to qLog.RecordCount do
  begin
    dbgLog.SelectedRows.CurrentRowSelected:=true;
    qLog.Next;
    frmDialog.pgBar.Progress:=qLog.RecNo;
  end;
  qLog.RecNo:=ActRec;
  qLog.EnableControls;
  qLogAfterScroll(qLog);
  frmDialog.Close;
end;

//odoznacit vsechna spojeni
procedure TfrmHQLog.actSelNoneQSOExecute(Sender: TObject);
begin
  dbgLog.SelectedRows.Clear;
  qLogAfterScroll(qLog);
end;

//mapa lokatoru
procedure TfrmHQLog.actMapaExecute(Sender: TObject);
begin
{  frmMap:=TfrmMap.Create(nil);
  try
    frmMap.ShowModal;
  finally
    frmMap.Release;
  end;}
end;

procedure TfrmHQLog.actSetQSLExecute(Sender: TObject);
begin
  if Sender = actQSLoN then SetQSL(dfiL_QSLo, qoNo) else
  if Sender = actQSLoY then SetQSL(dfiL_QSLo, qoYes) else
  if Sender = actQSLoR then SetQSL(dfiL_QSLo, qoRequested) else
  if Sender = actQSLoI then SetQSL(dfiL_QSLo, qoInvalid) else
  if Sender = actQSLpN then SetQSL(dfiL_QSLp, qpNo) else
  if Sender = actQSLpY then SetQSL(dfiL_QSLp, qpYes) else
  if Sender = actEQSLN then SetQSL(dfiL_EQSLp, eqNo) else
  if Sender = actEQSLY then SetQSL(dfiL_EQSLp, eqYes);
end;

//------------------------------------------------------------------------------

{//kontrola neni-li denik nahodou prazdny
function TfrmHQLog.NejsouData(const msg:String):Boolean;
begin
  if qLog.RecordCount=0 then
  begin
    cMessageDlg(msg+#13+strNoQSO,mtInformation,[mbOk],mrOk,0);
    Result:=True;
  end else Result:=False;
end;}

//editovat vice spojeni
procedure TfrmHQLog.EditQSOs;
var
  i, ActRec:Integer;
  tblDenik:TTable;
  FieldIndex:Integer;
  Value:String;
begin
  frmEditSelQSOs:=TfrmEditSelQSOs.Create(nil);
  with frmEditSelQSOs, tblDenik do
  try
    if frmEditSelQSOs.ShowModal<>mrOk then Exit;
    //
    FieldIndex:=EdtFields[cbBoxField.ItemIndex];
    Value:=cbBoxValue.Text;
    case FieldIndex of
      dfiL_Mode, dfiL_QSLo, dfiL_QSLp, dfiL_EQSLp: Value:=IntToStr(cbBoxValue.ItemIndex);
      dfiL_LOCo, dfiL_LOCp, dfiL_DXCC, dfiL_IOTA, dfiL_Award: Value:=UpperCase(Value);
    end;
    //
    ActRec:=qLog.RecNo;
    qLog.DisableControls;
    tblDenik:=TTable.Create(nil);
    try
      DatabaseName:=BDEAlias;
      TableName:=dmLog.User.Call+dFileExt;
      Open;
      for i:=0 to dbgLog.SelectedRows.Count-1 do
      begin
        qLog.GotoBookmark(Pointer(dbgLog.SelectedRows.Items[i]));
        if FindKey([qLog.Fields.Fields[dfiL_Index]]) then
        begin
          Edit;
          Fields[FieldIndex].AsString:=Value;
          case FieldIndex of
            dfiL_Freq: Fields[dfiL_Band].AsInteger:=GetHamBand(Fields[FieldIndex].AsFloat);
            dfiL_LOCo: begin
              DxccList.GotoDXCC(Fields[dfiL_DXCC].AsString);
              Fields[dfiL_QRB].AsInteger:=GetDistance(Value,
                Fields[dfiL_LOCp].AsString, DxccList.Longitude, DxccList.Latitude);
            end;
            dfiL_LOCp: begin
              DxccList.GotoDXCC(Fields[dfiL_DXCC].AsString);
              Fields[dfiL_QRB].AsInteger:=GetDistance(Fields[dfiL_LOCo].AsString,
                Value, DxccList.Longitude, DxccList.Latitude);
            end;
            dfiL_DXCC: begin
              DxccList.GotoDXCC(Value);
              Fields[dfiL_QRB].AsInteger:=GetDistance(Fields[dfiL_LOCo].AsString,
                Fields[dfiL_LOCp].AsString, DxccList.Longitude, DxccList.Latitude);
            end;
          end;
          Post;
        end;
      end;
      tblDenik.Close;
      if actFilter.Checked then dbgLog.SelectedRows.Clear;
      //obnovit
      Screen.Cursor:=crHourGlass;
      qLog.Close;
      qLog.Open;
      qLog.Last;
    finally
      tblDenik.Free;
      if ActRec<qLog.RecordCount-1 then qLog.RecNo:=ActRec;
      qLog.EnableControls;
      qLogAfterScroll(qLog);
      frmDialog.Close;
      Screen.Cursor:=crDefault;
    end;
  finally
    frmEditSelQSOs.Release;
  end;
end;

//vymazat QSO
procedure TfrmHQLog.DeleteQSO;
var
  i,ActRec:Integer;
  tblDenik:TTable;
begin
  //neni denik nahodou prazdny???!!!
  if qLog.RecordCount=0 then Exit;
  //
  tblDenik:=TTable.Create(nil);
  ActRec:=qLog.RecNo;
  qLog.DisableControls;
  Screen.Cursor:=crHourGlass;
  with tblDenik do
  try
    DatabaseName:=BDEAlias;
    TableName:=dmLog.User.Call;
    Open;
    //1 spojeni
    if dbgLog.SelectedRows.Count=0 then
    begin
      if FindKey([qLog.Fields.Fields[dfiL_Index]]) then Delete;
    end else
    //oznacena spojeni
    begin
      for i:=0 to dbgLog.SelectedRows.Count-1 do
      begin
        qLog.GotoBookmark(pointer(dbgLog.SelectedRows.Items[i]));
        if FindKey([qLog.Fields.Fields[dfiL_Index]]) then Delete;
      end;
    end;
    tblDenik.Close;
    dbgLog.SelectedRows.Clear;
    //obnovit
    qLog.Close;
    qLog.Open;
    qLog.Last;
  finally
    tblDenik.Free;
    if ActRec<qLog.RecordCount-1 then qLog.RecNo:=ActRec;
    qLog.EnableControls;
    qLogAfterScroll(qLog);
    dbgLog.Invalidate;
    frmDialog.Close;
    Screen.Cursor:=crDefault;
  end;
end;

//nastaveni QSL
procedure TfrmHQLog.SetQSL(const FieldIndex,Data:Integer);
var
  tblTemp: TTable;
  i: Integer;
begin
  //neni denik nahodou prazdny???!!!
  if qLog.RecordCount=0 then Exit;
//  if qLog.Fields.Fields[FieldIndex].AsInteger=Data then Exit;
  //
  tblTemp:=TTable.Create(nil);
  qLog.DisableControls;
  Screen.Cursor:=crHourGlass;
  with tblTemp,tblTemp.Fields do
  try
    DatabaseName:=BDEAlias;
    TableName:=dmLog.User.Call+dFileExt;
    Open;
    //jedno spojeni
    if dbgLog.SelectedRows.Count=0 then
    begin
      FindKey([qLog.Fields.Fields[dfiL_Index]]);
      Edit;
      if Fields[FieldIndex].AsInteger=Data
        then Fields[FieldIndex].AsInteger:=0
        else Fields[FieldIndex].AsInteger:=Data;
      Post;
    end else
    //vybrana spojeni
    for i:=0 to dbgLog.SelectedRows.Count-1 do
    begin
      qLog.GotoBookmark(pointer(dbgLog.SelectedRows.Items[i]));
      if FindKey([qLog.Fields.Fields[dfiL_Index]]) then
      begin
        Edit;
        Fields[FieldIndex].AsInteger:=Data;
        Post;
      end;
    end;
    tblTemp.Close;
  finally
    tblTemp.Free;
    qLog.EnableControls;
    Screen.Cursor:=crDefault;
    SortLog(-1,True);
  end;
  if Assigned(frmFind)and(frmFind.Visible) then frmFind.SetFocus;
end;

//------------------------------------------------------------------------------

//nacteni uzivatele
procedure TfrmHQLog.OpenLog(const Call:String);
var
  i:Integer;

  //nastaveni vzhledu
  procedure LoadDesign;
  var
    i:Integer;

   procedure SetCI(FieldName:String; Index:Integer);
   var
     i:Integer;
   begin
     with dbgLog.Columns do
       for i:=0 to Count-1 do
         if Items[i].FieldName=FieldName then
         begin
           Items[i].Index:=Index;
           Exit;
         end;
   end;

  begin
    //sloupce dbGridu
    dbgLog.Columns.Clear;
    for i:=Low(dfL_Name)+1 to High(dfL_Name) do
      with dbgLog.Columns.Add,dmLog.User do
      begin
        FieldName:=dfL_Name[i];
        Title.Caption:=GetColumnCaption(dfL_Name[i]);
        Title.Alignment:=GetColumnTAlignment(dfL_Name[i]);
        Alignment:=GetColumnAlignment(dfL_Name[i]);
        Width:=GetColumnWidth(dfL_Name[i]);
        Visible:=GetColumnVisible(dfL_Name[i]);
      end;
    with dbgLog.Columns,dmLog.User do
      for i:=Low(dfL_Name)+1 to High(dfL_Name) do
        SetCI(dfL_Name[i], dmLog.User.GetColumnIndex(dfL_Name[i], Count-1));
  end;

  //synchronizace casu
  procedure SyncTime;
  var
    IdSNTP:TIdSNTP;
  begin
    IdSNTP:=TIdSNTP.Create(nil);
    try
      IdSNTP.ReceiveTimeout:=4000;
      IdSNTP.Host:=dmLog.User.Time_NTPServer;
      try
        if not IdSNTP.SyncTime then
          cMessageDlg(Format(strSyncTimeError, [IdSNTP.Host]), mtError, [mbOk], mrOk, 0);
      except
        cMessageDlg(Format(strSyncTimeError, [IdSNTP.Host]), mtError, [mbOk], mrOk, 0);
      end;
    finally
      IdSNTP.Free;
    end;
  end;

begin
  //zavrit databazi
  qLog.Close;
  //otevrit soubor s nastavenimi
  try
    dmLog.User.LoadFromFile(dmLog.DataDir+Call+uFileExt);
  except
    cMessageDlg(Format(strOpenUserErr, [dmLog.DataDir+Call+uFileExt]),
      mtError, [mbOk], mrOk, 0);
    Application.Terminate;
    Exit;
  end;
  //dialog
  frmDialog.ZobrazProg(strLogInFonts, 0, 7);
  try
    Caption:=AppName+' "'+dmLog.User.Call+'"';
    LoadDesign;
    //nacist prednastaveni
    if dmLog.User.Design_ExtendedFont then dbgLog.Font.Name:='Tahoma'
                                      else dbgLog.Font.Name:='MS Sans Serif';
    //synchronizace casu
    frmDialog.pgBar.Progress:=1;
    frmDialog.SetText(strLogInSyncingTime);
    if dmLog.User.Time_Sync then SyncTime;
    //kontrola odchylky UTC
    frmDialog.pgBar.Progress:=2;
    frmDialog.SetText(strLogInCheckingUTCOffset);
    //nastavit uzivatele
    frmDialog.pgBar.Progress:=3;
    frmDialog.SetText(strLogInCheckingFiles);
    //kontrola datoveho souboru
    if not FileExists(dmLog.DataDir+dmLog.User.Call+dFileExt) then
    begin
      frmDialog.Hide;
      cMessageDlg(strMissingDB, mtError, [mbOk], mrOk, 0);
      CreateLogDB(dmLog.DataDir+dmLog.User.Call+dFileExt);
      frmDialog.Show;
    end;
    //kontrola indexu
    if not FileExists(dmLog.DataDir+dmLog.User.Call+iFileExt) then
    begin
      frmDialog.Hide;
      cMessageDlg(strMissingIndex, mtError, [mbOk], mrOk, 0);
      frmDialog.Show;
    end;
    frmDialog.pgBar.Progress:=4;
    frmDialog.SetText(strLogInOpening);
    //otevrit databazi
    fOrderBy:=dfiL_Date;
    qLog.SQL.Text:='SELECT * FROM "'+dmLog.User.Call+'" ORDER BY '+dfnL_Date+','+dfnL_Time;
    qLog.DisableControls;
    try
      qLog.Open;
      qLog.Last;
    finally
      qLog.EnableControls;
    end;
    if qLog.Active then qLogAfterScroll(qLog);
    //
    actSortByDateTime.Checked:=True;
    with dbgLog.Columns do
      for i:=0 to Count-1 do
        if Items[i].Field.Index in [dfiL_Date, dfiL_Time]
          then Items[i].Title.Color:=clOfactTitle
          else Items[i].Title.Color:=clBtnFace;
    frmDialog.pgBar.Progress:=7;
  finally
    frmDialog.Close;
  end;
end;

//odhlaseni uzivatele
procedure TfrmHQLog.CloseLog;
var
  i,j:Integer;

 procedure AutoZaloha;
 var
   Soubor:String;
 begin
   if dmLog.User.BackUp_Enabled then
   begin
     if ((dmLog.User.BackUp_Interval=0)and
         (WeekOfTheYear(Date)<>WeekOfTheYear(dmLog.User.BackUp_Date)))or
        ((dmLog.User.BackUp_Interval=1)and
         (MonthOfTheYear(Date)<>MonthOfTheYear(dmLog.User.BackUp_Date))) then
     begin
       dmLog.User.BackUp_Date:=Date;
       Soubor:=dmLog.User.BackUp_Path;
       if not DirectoryExists(Soubor) then Soubor:=dmLog.RootDir+Zal_Dir;
       if Soubor[Length(Soubor)]<>'\' then Soubor:=Soubor+'\';
       Soubor:=Soubor+dmLog.User.Call+' '+DateToStr(Date)+zFileExt;
       BackUpLog(dmLog.User.Call, dmLog.DataDir, Soubor);
     end;
   end;
 end;

begin
  //ulozit sirky sloupcu v DbGridu
  with dbgLog.Columns do
    for i:=Low(dfL_Name)+1 to High(dfL_Name) do
    begin
      j:=0;
      while (j<Count)and(Items[j].FieldName<>dfL_Name[i]) do Inc(j);
      if (j<Count) then
      begin
        dmLog.User.SetColumnIndex(dfL_Name[i], Items[j].Index);
        if Items[j].Visible then
          dmLog.User.SetColumnWidth(dfL_Name[i], Items[j].Width);
      end;
    end;
  //
  dmLog.CloseDXC;
  //
  if dmLog.User.Call<>'' then
  begin
    AutoZaloha;
    try
      dmLog.User.UpdateFile;
    except
    end;
  end;
  dmLog.User.Close;
  qLog.Close;
  dbgLog.Columns.Clear;
  Caption:=AppName;
  actFilter.Checked:=False;
  frmFilter.vedtFiltr.Strings.Clear;
end;

// nastaveni trideni
procedure TfrmHQLog.SortLog(OrderBy:Integer; const Force:Boolean);
var
  i,ActKey,ActRow:Integer;
  Order:String;
begin
  if (not qLog.Active)or((dbgLog.SelectedRows.Count<>0)and(OrderBy<>-1)) then Exit;
  if OrderBy=-1 then OrderBy:=fOrderBy;
  //nastavit akci v menu
  case OrderBy of
    dfiL_Date: actSortByDateTime.Checked:=True;
    dfiL_Time: begin
      actSortByDateTime.Checked:=True;
      OrderBy:=dfiL_Date;
    end;
    dfiL_Call: actSortByCall.Checked:=True;
    dfiL_Freq: actSortByFreq.Checked:=True;
    dfiL_Band: actSortByBand.Checked:=True;
    dfiL_Mode: actSortByMode.Checked:=True;
    dfiL_Name: actSortByName.Checked:=True;
    dfiL_QTH: actSortByQTH.Checked:=True;
    dfiL_LOCp: actSortByLOCp.Checked:=True;
    dfiL_LOCo: actSortByLOCo.Checked:=True;
    dfiL_QSLvia: actSortByQSLmgr.Checked:=True;
    dfiL_QSLo: actSortByQSLo.Checked:=True;
    dfiL_QSLp: actSortByQSLp.Checked:=True;
    dfiL_EQSLp: actSortByEQSL.Checked:=True;
    dfiL_Note: actSortByNote.Checked:=True;
    dfiL_PWR: actSortByPWR.Checked:=True;
    dfiL_QRB: actSortByQRB.Checked:=True;
    dfiL_DXCC: actSortByDXCC.Checked:=True;
    dfiL_IOTA: actSortByIOTA.Checked:=True;
    dfiL_ITU: actSortByITU.Checked:=True;
    dfiL_WAZ: actSortByWAZ.Checked:=True;
    dfiL_Award: actSortByAward.Checked:=True;
  else
    Exit;
  end;
  //nastavit bravu zahlavi
  with dbgLog.Columns do
    for i:=0 to Count-1 do
      if Items[i].Field.Index=OrderBy then Items[i].Title.Color:=clOfactTitle
                                      else Items[i].Title.Color:=clBtnFace;
  if OrderBy=dfiL_Date then
    with dbgLog.Columns do
      for i:=0 to Count-1 do
        if Items[i].Field.Index=dfiL_Time then Items[i].Title.Color:=clOfactTitle;
  //
  if (fOrderBy=OrderBy)and(not Force) then Exit;
  fOrderBy:=OrderBy;
  //
  Screen.Cursor:=crHourGlass;
  qLog.DisableControls;
  with qLog,Fields do
  try
    //nastaveni filtru
    ActRow:=dbgLog.Row;
    if RecordCount<>0 then ActKey:=Fields[dfiL_Index].AsInteger
                      else ActKey:=-1;
    Order:=Fields[OrderBy].FieldName+',';
    if OrderBy=dfiL_Date then Order:=Order+Fields[dfiL_Time].FieldName
                         else Order:=Order+Fields[dfiL_Date].FieldName+','+
                                           Fields[dfiL_Time].FieldName;
    //
    Close;
    SQL.Clear;
    SQL.Add('SELECT *');
    SQL.Add('FROM "'+dmLog.User.Call+'"');
    if (actFilter.Checked)and(Length(SqlFiltr.Text)<>0) then
    begin
      SQL.Add('WHERE');
      SQL.AddStrings(SqlFiltr);
    end;
    SQL.Add('ORDER BY '+Order);
    //
    try
//      showmessage(sql.Text);
      Open;
    except
      cMessageDlg(Format(strDBOpenError, [2]), mtError, [mbOk], mrOk, 0);
    end;
    //vyhledat puvodni zaznam
    if ActKey<>-1 then
    begin
      Locate(dfnL_Index,ActKey, []);
      if ActRow>dbgLog.RowCount div 2 then
      begin
        MoveBy(1-ActRow);
        MoveBy(ActRow-1);
      end else
      begin
        MoveBy(dbgLog.RowCount-ActRow-1);
        MoveBy(ActRow-dbgLog.RowCount+1);
      end;
     end;
  finally
    Screen.Cursor:=crDefault;
    qLog.EnableControls;
  end;
  qLogAfterScroll(qLog);
end;

//obnoveni dat v mrizce
procedure TfrmHQLog.RefreshLog(const Info: Boolean; const KeepPos: Boolean);
var
  rNo: Integer;
begin
  if Info then frmDialog.Zobraz(strLoadingData);
  rNo:=qLog.RecNo;
  qLog.DisableControls;
  try
    try
      qLog.Close;
      qLog.Open;
    except
      cMessageDlg(Format(strDBOpenError, [3]), mtError, [mbOk], mrOk, 0);
    end;
    if KeepPos then
      qLog.RecNo:=rNo
    else
      qLog.Last;
  finally
    qLog.EnableControls;
    qLog.AfterScroll(qLog);
    if Info then frmDialog.Close;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmHQLog.ExportQSLProgress(const Progress:Integer);
begin
  with frmDialog do
  case Progress of
    0,1: begin
      lblText.Caption:=strSortQSL+#13#10+strSortQSL1;
      lblText.Update;
      pgBar.Progress:=Progress;
    end;
    2,3: begin
      lblText.Caption:=strSortQSL+#13#10+strSortQSL2;
      lblText.Update;
      pgBar.Progress:=Progress;
    end;
    4,5: begin
      lblText.Caption:=strSortQSL+#13#10+strSortQSL3;
      lblText.Update;
      pgBar.Progress:=Progress;
    end;
    6,7: begin
      lblText.Caption:=strSortQSL+#13#10+strSortQSL4;
      lblText.Update;
      pgBar.Progress:=Progress;
    end;
    8,9: begin
      lblText.Caption:=strSortQSL+#13#10+strSortQSL5;
      lblText.Update;
      pgBar.Progress:=Progress;
    end;
    10,11,12: begin
      lblText.Caption:=strSortQSL+#13#10+strSortQSL6;
      lblText.Update;
      pgBar.Progress:=Progress;
    end;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmHQLog.OnCopyData(var msg: TWMCopyData);
var
  CopyMsg:TCopyDataStruct;

 procedure OnCloseDXC(const Data:TCloseDXCData);
 begin
   if Data.Maximized then dmLog.User.DXC_Maximized:=True else
   begin
     dmLog.User.DXC_Maximized:=False;
     dmLog.User.DXC_Width:=Data.Width;
     dmLog.User.DXC_Height:=Data.Height;
   end;
 end;

begin
  CopyMsg:=msg.CopyDataStruct^;
  case CopyMsg.dwData of
    dw_CloseDXC: OnCloseDXC(pCloseDXCData(CopyMsg.lpData)^);
  end;
end;

end.
