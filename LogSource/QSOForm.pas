{$include global.inc}
unit QSOForm;

interface

uses
  Windows, DB, DBTables, Classes, ActnList, StdCtrls, ExtCtrls, Grids,
  DBGrids, Controls, DBCtrls, Forms, SysUtils, XPStyleActnCtrls,
  ActnMan, Dialogs, HamLogFP, Menus, Variants, HQLResStrings, Amater,
  StrUtils, Graphics, cfmDialogs, CfmDbGrid, HQLControls, HQLDatabase, HQLConsts,
  StdActns, Messages, HQLMessages, cfmWinUtils, cfmDateUtils, ActnPopupCtrl,
  cfmGeography;

type
  //
  TQSOFormStyle = (fsNewQSO,fsShowQSO,fsEditQSO);
  //
  TfrmQSO = class(TForm)
    grpBoxInfo: TGroupBox;
    lblDXCC1: TLabel;
    lblDXCCName1: TLabel;
    grpBoxZemInf: TGroupBox;
    lblDxccLatitude1: TLabel;
    lblDxccLongitude1: TLabel;
    lblDistance1: TLabel;
    lblAzimuth1: TLabel;
    lblDxccTime1: TLabel;
    lblDxccCont1: TLabel;
    lblDistance: TLabel;
    lblDxccTime: TLabel;
    grpBoxUTC: TGroupBox;
    lblClockTime: TLabel;
    grpBoxSpojeni: TGroupBox;
    lblCall: TLabel;
    lblFreq: TLabel;
    lblMode: TLabel;
    lblRSTo: TLabel;
    lblRSTp: TLabel;
    lblName: TLabel;
    lblQTH: TLabel;
    lblLOC: TLabel;
    lbQSLmgr: TLabel;
    lblNote: TLabel;
    lblDAT: TLabel;
    lblCAS: TLabel;
    edtCall: TEdit;
    edtName: TEdit;
    edtQTH: TEdit;
    edtQSLmgr: TEdit;
    cbMode: TComboBox;
    edtNote: TEdit;
    grpBoxVlastni: TGroupBox;
    lblPWR: TLabel;
    lblLocVl: TLabel;
    qPred: TQuery;
    dsPredchozi: TDataSource;
    grpBoxPredQSO: TGroupBox;
    grpBoxVolby: TGroupBox;
    lblAzimuth: TLabel;
    chQuickQSO: TCheckBox;
    actManager: TActionManager;
    actClearForm: TAction;
    actInsertDateTime: TAction;
    actClose: TAction;
    actSave: TAction;
    actPasmoUp: TAction;
    actPasmoDown: TAction;
    actModUp: TAction;
    actModDown: TAction;
    lblClockDate: TLabel;
    bvlLine1: TBevel;
    actSkipQuickQSO: TAction;
    chLockNote: TCheckBox;
    actCallBook: TAction;
    lblDxccLatitude: TLabel;
    lblDxccLongitude: TLabel;
    lblDxccCont: TLabel;
    qCallBook: TQuery;
    chOffline: TCheckBox;
    cbQSLo: TComboBox;
    cbQSLp: TComboBox;
    lblIOTA: TLabel;
    lblQSLo: TLabel;
    lblQSLp: TLabel;
    lblBand: TLabel;
    lblDXCC: TLabel;
    edtDXCC: TEdit;
    lblITU: TLabel;
    edtITU: TEdit;
    lblWAZ: TLabel;
    edtWAZ: TEdit;
    btnSave: TButton;
    btnZavrit: TButton;
    bvlLine2: TBevel;
    bvlLine3: TBevel;
    lblPseQsl: TLabel;
    lblNovaZeme: TLabel;
    lblDxccDXCC: TLabel;
    lblDxccName: TLabel;
    dbgLastQSO: TCfmDBGrid;
    cbEQSL: TComboBox;
    lblEQSL: TLabel;
    edtRSTo: TReportEdit;
    edtRSTp: TReportEdit;
    edtLOCo: TLocatorEdit;
    edtLOCp: TLocatorEdit;
    edtTime: TTimeEdit;
    edtDate: TDateEdit;
    edtIOTA: TIOTAEdit;
    cbFreq: TFloatComboBox;
    cbPWR: TFloatComboBox;
    actCopy: TEditCopy;
    actPaste: TEditPaste;
    edtAward: TEdit;
    lblAward: TLabel;
    actDxccList: TAction;
    actIOTAList: TAction;
    actHelp: TAction;
    tmClock: TTimer;
    pmQSO: TPopupActionBarEx;
    miCopy: TMenuItem;
    miPaste: TMenuItem;
    N3: TMenuItem;
    pmCallBook: TMenuItem;
    miDxccList: TMenuItem;
    miIOTAList: TMenuItem;
    N4: TMenuItem;
    miSkipQuickQSO: TMenuItem;
    //frmSpojeni
    constructor Create(AOwner:TComponent; QSOFormStyle:TQSOFormStyle); reintroduce;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    //dbgLastQSO
    procedure dbgLastQSODrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    //poMnSpojeni
    procedure pmQSOPopup(Sender: TObject);
    //cbBoxQuickQSO
    procedure chQuickQSOClick(Sender: TObject);
    //cbBoxLockNote
    procedure chLockNoteClick(Sender: TObject);
    //cbBoxOffline
    procedure chOfflineClick(Sender: TObject);
    //edtCall
    procedure CallExit(Sender: TObject);
    procedure CallDxccKeyPress(Sender: TObject; var Key: Char);
    //cbBoxFreq
    procedure FreqExit(Sender: TObject);
    //cbBoxMode
    procedure ModeExit(Sender: TObject);
    //edtName
    procedure NameExit(Sender: TObject);
    //edtQTH
    procedure QTHExit(Sender: TObject);
    //edtDXCC
    procedure DXCCExit(Sender: TObject);
    //edtITU, edtWAZ
    procedure ITUWAZKeyPress(Sender: TObject; var Key: Char);
    //edtAward
    procedure edtAwardKeyPress(Sender: TObject; var Key: Char);
    //edtDate, edtTime
    procedure edtDateTimeEnter(Sender: TObject);
    //edtLOCo, edtLOCp
    procedure LocExit(Sender: TObject);
    //btnSave
    procedure btnSaveKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    //spolecne
    procedure FormExit(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure OnFormDataChange(Sender: TObject);
    procedure OnDateTimeChange(Sender: TObject);
    procedure OnDxccChange(Sender: TObject);
    procedure lblLinkMouseEnter(Sender: TObject);
    procedure lblLinkMouseLeave(Sender: TObject);
    //act
    procedure actHelpExecute(Sender: TObject);
    procedure actClearFormExecute(Sender: TObject);
    procedure actInsertDateTimeExecute(Sender: TObject);
    procedure actComboBoxUpDownExecute(Sender: TObject);
    procedure actCallBookExecute(Sender: TObject);
    procedure actDxccListExecute(Sender: TObject);
    procedure actIOTAListExecute(Sender: TObject);
    procedure actSkipQuickQSOExecute(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
  private
    { Private declarations }
    fQSOFormStyle: TQSOFormStyle;
    //
    nDxcc: TStrings;
    LastControl: TObject;
    fReadOnly, fQuickQSO, fOffline, LockNote: Boolean; //funkce
    fLookInLog, fLookInCB, fRefreshLog, fNameUpCase: Boolean; //prednastaveni
    DataChanged: Boolean; //pridano (upraveno) QSO
    FormChanged: Boolean; //upravena data ve formulari
    lCall, lDxcc: String;
    QuickQSOs: LongWord; //pole pro rychle zadavani
    //
    procedure OnSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;
    procedure OnCopyData(var msg: TWMCopyData); message wm_copydata;
    //
    procedure SetReadOnly(const ReadOnly: Boolean);
    procedure SetQuickQSO(const Value: Boolean);
    procedure SetOffline(const Value: Boolean);
    //
    procedure LoadRecord;
    //
    procedure ClearForm;
    procedure InsertDateTime;
    //
    procedure GetLastQSOs;
    procedure LookInLog(const Znacka: String);
    procedure LookInCB(const Znacka: String);
    procedure CheckQSL;
    procedure CheckNewDXCC;
    //
    procedure VypoctiVzdalAzi;
    function VypoctiVzdalenost: Integer;
    function VypoctiAzimut: Integer;
    //
    property FormReadOnly: Boolean read fReadOnly write SetReadOnly;
    property QuickQSO: Boolean read fQuickQSO write SetQuickQSO;
    property Offline: Boolean read fOffline write SetOffline;
  public
    { Public declarations }
  end;

var
  frmQSO: TfrmQSO;

implementation

uses Main, AziDis, Kontrola, CallBook, KeyFilters, HQLdMod, Dxcc, DBList;

{$R *.dfm}

//------------------------------------------------------------------------------
//frmSpojeni
//------------------------------------------------------------------------------

constructor TfrmQSO.Create(AOwner:TComponent; QSOFormStyle:TQSOFormStyle);
begin
  fQSOFormStyle:=QSOFormStyle;
  inherited Create(AOwner);
end;

//vytvoreni formulare
procedure TfrmQSO.FormCreate(Sender: TObject);
begin
  //======= vytvoreni objektu =======
  //zasobnik novych zemi dxcc
  nDxcc:=TStringList.Create;
  //
  qPred.DatabaseName:=BDEAlias;
  //======= prednastaveni formulare =======
  with dmLog.User do
  begin
    //
    if Design_ExtendedFont then dbgLastQSO.Font.Name:='Tahoma'
                           else dbgLastQSO.Font.Name:='MS Sans Serif';
    //
    fLookInLog:=nQSO_LookInLog;
    fLookInCB:=nQSO_LookInCB;
    fRefreshLog:=nQSO_RefreshLog;
    fNameUpCase:=nQSO_NameUpCase;
    QuickQSOs:=nQSO_QuickQSOs;
    //
    nQSO_GetFreqs(cbFreq.Items);
    cbFreq.ItemIndex:=nQSO_DefFreq;
    cbFreq.Format:=FreqFormat;
    try
      lblBand.Caption:=strBand+': '+hBandName[GetHamBand(StrToFloat(cbFreq.Text))];
    except
    end;
    nQSO_GetModes(cbMode.Items);
    cbMode.ItemIndex:=nQSO_DefMode;
    edtRSTo.Text:=nQSO_RSTo;
    edtRSTp.Text:=nQSO_RSTp;
    SetCbBoxItems(cbQSLo,hQSLoNames);
    cbQSLo.ItemIndex:=nQSO_QSLo;
    SetCbBoxItems(cbQSLp,hQSLpNames);
    cbQSLp.ItemIndex:=nQSO_QSLp;
    SetCbBoxItems(cbEQSL,hEQSLNames);
    edtLOCo.Text:=Loc;
    SetCbBoxItemsF(cbPWR,hPWRs);
    cbPWR.Text:=FloatToStr(nQSO_PWR);
    cbPWR.Format:=FreqFormat;
  end;
  //vyprazdneni formulare
  ClearForm;
  //reset databaze DXCC
  DxccList.OnChange:=OnDxccChange;
  DxccList.Active:=False;
  //======= nastaveni pro nove/zobrazeni/editaci QSO =======
  case fQSOFormStyle of
    //nove QSO
    fsNewQSO: begin
      //otevreni CallBooku
      if fLookInCB then
        with qCallBook,qCallBook.SQL do
        begin
          DatabaseName:=dmLog.RootDir;
          Clear;
          Add('SELECT znacka,jmeno,mesto,loc FROM "'+CallBook_File+'" ORDER BY znacka');
          Open;
        end;
      //
      lCall:='-';
      lDxcc:='-';
      FormReadOnly:=False;
    end;
    //zobrazeni QSO
    fsShowQSO: begin
      LoadRecord;
      DxccList.GotoDXCC(edtDxcc.Text);
      GetLastQSOs;
      VypoctiVzdalAzi;
      FormReadOnly:=True;
    end;
    //editace QSO
    fsEditQSO: begin
      LoadRecord;
      DxccList.GotoDXCC(edtDxcc.Text);
      GetLastQSOs;
      VypoctiVzdalAzi;
      FormReadOnly:=False;
    end;
  end;
  nDxcc.Clear;
  FormChanged:=False;
  DataChanged:=False;
  tmClock.OnTimer(tmClock);
  tmClock.Enabled:=True;
end;

//pri uvolneni formulare
procedure TfrmQSO.FormDestroy(Sender: TObject);
begin
  //zavreni CallBooku
  qCallBook.Close;
  //dxcc
  DxccList.OnChange:=nil;
  //obnoveni dat v deniku
  if DataChanged then
    frmHQLog.RefreshLog(True, fQSOFormStyle = fsEditQSO);
  //ulozeni nastaveni
  dmLog.User.nQSO_QuickQSOs:=QuickQSOs;
  //
  nDxcc.Free;
end;

//pri zobrazeni formulare
procedure TfrmQSO.FormShow(Sender: TObject);
begin
  //nastaveni focusu
  if fQSOFormStyle=fsNewQSO then
  begin
    edtCall.SetFocus;
    LastControl:=edtCall;
  end else
  begin
    btnZavrit.SetFocus;
    LastControl:=btnZavrit;
  end;
end;

//pred zavrenim formulare
procedure TfrmQSO.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  if not FormChanged then Exit;
  case fQSOFormStyle of
    fsNewQSO:
      case cMessageDlg(strQSOExitQ,mtConfirmation,[mbYes,mbNo],mrNo,0) of
        mrYes: CanClose:=True;
        mrNo: CanClose:=False;
      end;
    fsEditQSO:
      case cMessageDlg(strSaveQSOq,mtConfirmation,[mbYes,mbNo,mbCancel],mrYes,0) of
        mrYes: begin
          actSaveExecute(nil);
          CanClose:=True;
        end;
        mrNo: CanClose:=True;
        mrCancel: CanClose:=False;
      end;
  end;
end;

//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------

procedure TfrmQSO.OnSysCommand(var Msg: TWMSysCommand);
begin
  if Msg.CmdType=SC_MINIMIZE then ShowWindow(Application.Handle,SW_SHOWMINNOACTIVE)
                             else inherited;
end;

procedure TfrmQSO.OnCopyData(var msg: TWMCopyData);
var
  CopyMsg:TCopyDataStruct;
  Data:pSetQSOData;
begin
  CopyMsg:=msg.CopyDataStruct^;
  case CopyMsg.dwData of
    dw_CloseDXC: if fQSOFormStyle=fsNewQSO then
    begin
      Data:=CopyMsg.lpData;
      edtCall.Text:=UpperCase(Data^.Call);
      cbFreq.Text:=FormatFloat(FreqFormat,Data^.Freq);
      ForceForeground(Application.Handle);
    end;
  end;
end;

//------------------------------------------------------------------------------
//dbgLastQSO
//------------------------------------------------------------------------------

procedure TfrmQSO.dbgLastQSODrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn;
  State: TGridDrawState);

 procedure CenterTextOut(Canvas:TCanvas; Rect:TRect; Text:PChar);
 const
   Options=DT_CENTER or DT_VCENTER or DT_NOPREFIX or DT_SINGLELINE;
 begin
   Windows.FillRect(Canvas.Handle,Rect,Canvas.Brush.Handle);
   Windows.DrawText(Canvas.Handle,Text,-1,Rect,Options);
 end;

begin
  with TDbGrid(Sender) do
  begin
    if DataSource.DataSet.RecordCount=0 then Canvas.FillRect(Rect) else
    case Column.Field.Index of
      dfiL_Date: CenterTextOut(Canvas,Rect,PChar(FormatDateTime(DateSFormat,Column.Field.AsDateTime)));
      dfiL_Time: CenterTextOut(Canvas,Rect,PChar(FormatDateTime(TimeSFormat,Column.Field.AsDateTime)));
      dfiL_Mode: CenterTextOut(Canvas,Rect,hModeName[Column.Field.AsInteger]);
      dfiL_QSLo: CenterTextOut(Canvas,Rect,hQSLo[Column.Field.AsInteger]);
      dfiL_QSLp: CenterTextOut(Canvas,Rect,hQSLo[Column.Field.AsInteger]);
    else
      DefaultDrawColumnCell(Rect,DataCol,Column,State);
    end;
  end;
end;

//------------------------------------------------------------------------------
//poMnSpojeni
//------------------------------------------------------------------------------

procedure TfrmQSO.pmQSOPopup(Sender: TObject);
begin
  if pmQSO.PopupComponent=nil then Exit;
  if pmQSO.PopupComponent=edtCall then actSkipQuickQSO.Enabled:=False
                                  else actSkipQuickQSO.Enabled:=True;
  if pmQSO.PopupComponent.Tag=1 then
    actSkipQuickQSO.Checked:=(QuickQSOs and (1 shl (TWinControl(pmQSO.PopupComponent).TabOrder)))=0;
end;

//------------------------------------------------------------------------------
//chQuickQSO
//------------------------------------------------------------------------------

procedure TfrmQSO.chQuickQSOClick(Sender: TObject);
begin
  if Sender=chQuickQSO then
    QuickQSO:=chQuickQSO.Checked;
  if (not FormReadOnly)and(frmQSO.Visible) then
    TWinControl(LastControl).SetFocus;
end;

//------------------------------------------------------------------------------
//chLockNote
//------------------------------------------------------------------------------

procedure TfrmQSO.chLockNoteClick(Sender: TObject);
begin
  LockNote:=TCheckBox(Sender).Checked;
  if (not FormReadOnly)and(frmQSO.Visible) then
    TWinControl(LastControl).SetFocus;
end;

//------------------------------------------------------------------------------
//chOffline
//------------------------------------------------------------------------------

procedure TfrmQSO.chOfflineClick(Sender: TObject);
begin
  Offline:=chOffline.Checked;
  if (not FormReadOnly)and(frmQSO.Visible) then
    TWinControl(LastControl).SetFocus;
end;

//------------------------------------------------------------------------------
//edtCall
//------------------------------------------------------------------------------

procedure TfrmQSO.CallExit(Sender: TObject);
begin
  LastControl:=Sender;
  if (edtCall.Text='')or(edtCall.Text=lCall) then Exit;
  lCall:=edtCall.Text;
  //automaticke vlozeni data a casu
  if (fQSOFormStyle=fsNewQSO)and(not Offline) then InsertDateTime;
  //vyhledani zeme DXCC
  if DxccList.FindDXCC(edtCall.Text) then
  begin
    edtDxcc.Text:=DxccList.DXCC;
    edtITU.Text:=IntToStr(DxccList.ITU);
    edtWAZ.Text:=IntToStr(DxccList.WAZ);
  end;
  lDxcc:=edtDxcc.Text;
  //vyhledani predchozich spojeni
  GetLastQSOs;
  //vyhledani udaju o stanici
  if (fQSOFormStyle=fsNewQSO)and(fLookInLog) then LookInLog(edtCall.Text);
  if (fQSOFormStyle=fsNewQSO)and(fLookInCB) then LookInCB(edtCall.Text);
  if (edtDxcc.Text<>'')and(edtDxcc.Text<>lDxcc) then
  begin
    DxccList.FindDXCC(edtDxcc.Text);
    lDxcc:=edtDxcc.Text;
  end;
  //vypocitat vzdalenost
  VypoctiVzdalAzi;
  //nova zeme?
  CheckNewDXCC;
  //pozadovat QSL?
  CheckQSL;
end;

//znacka, DXCC
procedure TfrmQSO.CallDxccKeyPress(Sender: TObject; var Key: Char);
begin
  FilterCall(Key);
end;

//------------------------------------------------------------------------------
//cbFreq
//------------------------------------------------------------------------------

procedure TfrmQSO.FreqExit(Sender: TObject);
begin
  LastControl:=Sender;
  CheckQSL; //pozadovat QSL?
  CheckNewDXCC; //nova zeme?
  try
    lblBand.Caption:=strBand+': '+hBandName[GetHamBand(StrToFloat(cbFreq.Text))];
  except
  end;
end;

//------------------------------------------------------------------------------
//cbMode
//------------------------------------------------------------------------------

procedure TfrmQSO.ModeExit(Sender: TObject);
var
  t:String;
begin
  LastControl:=Sender;
  t:=UpperCase(cbMode.Text);
  if (t='CW')or(t='SSTV')or(t='PSK') then
  begin
    if Length(edtRSTo.Text)=2 then edtRSTo.Text:=edtRSTo.Text+'9';
    if Length(edtRSTp.Text)=2 then edtRSTp.Text:=edtRSTp.Text+'9';
  end else
  begin
    t:=edtRSTo.Text;
    if Length(t)=3 then
    begin
      Delete(t,Length(t),1);
      edtRSTo.Text:=t;
    end;
    t:=edtRSTp.Text;
    if Length(t)=3 then
    begin
      if Length(t)=3 then Delete(t,Length(t),1);
      edtRSTp.Text:=t;
    end;
  end;
  //pozadovat QSL?
  CheckQSL;
end;

//------------------------------------------------------------------------------
//edtName
//------------------------------------------------------------------------------

procedure TfrmQSO.NameExit(Sender: TObject);
var
  str:String;
begin
  LastControl:=Sender;
  if (not fNameUpCase)or(Length(TEdit(Sender).Text)=0) then Exit;
  str:=TEdit(Sender).Text;
  str[1]:=AnsiUpperCase(str[1])[1];
  TEdit(Sender).Text:=str;
end;

//------------------------------------------------------------------------------
//edtQTH
//------------------------------------------------------------------------------

procedure TfrmQSO.QTHExit(Sender: TObject);
var
  str:String;
begin
  LastControl:=Sender;
  if (not fNameUpCase)or(Length(TEdit(Sender).Text)=0) then Exit;
  str:=TEdit(Sender).Text;
  if (AnsiStartsText('nr.',str))and(Length(str)>4) then str[5]:=AnsiUpperCase(str[5])[1] else
  if (AnsiStartsText('nr ',str))and(Length(str)>3) then str[4]:=AnsiUpperCase(str[4])[1] else
    str[1]:=AnsiUpperCase(str[1])[1];
  TEdit(Sender).Text:=str;
end;

//------------------------------------------------------------------------------
//edtDXCC
//------------------------------------------------------------------------------

procedure TfrmQSO.DXCCExit(Sender: TObject);
var
  res:Boolean;
begin
  LastControl:=Sender;
  if (edtDxcc.Text=lDxcc)or((edtCall.Text='')and(edtDxcc.Text='')) then Exit;
  lDxcc:=edtDxcc.Text;
  if edtDxcc.Text='' then res:=DxccList.FindDXCC(edtCall.Text)
                     else res:=DxccList.GotoDXCC(edtDxcc.Text);
  if Res then
  begin
    edtITU.Text:=IntToStr(DxccList.ITU);
    edtWAZ.Text:=IntToStr(DxccList.WAZ);
  end;
end;

//------------------------------------------------------------------------------
//edtITU, edtWAZ
//------------------------------------------------------------------------------

procedure TfrmQSO.ITUWAZKeyPress(Sender: TObject; var Key: Char);
begin
  FilterNumber(Key);
end;

//------------------------------------------------------------------------------
//edtAward
//------------------------------------------------------------------------------

procedure TfrmQSO.edtAwardKeyPress(Sender: TObject; var Key: Char);
begin
  FilterAward(Key,[]);
end;

//------------------------------------------------------------------------------
//edtDate, edtTime
//------------------------------------------------------------------------------

procedure TfrmQSO.edtDateTimeEnter(Sender: TObject);
begin
  TEdit(Sender).SelectAll;
end;

//------------------------------------------------------------------------------
//edtLOCo, edtLOCp
//------------------------------------------------------------------------------

procedure TfrmQSO.LocExit(Sender: TObject);
begin
  LastControl:=Sender;
  if Length(TEdit(Sender).Text)=4 then
    TEdit(Sender).Text:=TEdit(Sender).Text+'MM';
  VypoctiVzdalAzi;
end;

//------------------------------------------------------------------------------
//btnSave
//------------------------------------------------------------------------------

procedure TfrmQSO.btnSaveKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=vk_space then Key:=0;
end;

//------------------------------------------------------------------------------
//spolecne
//------------------------------------------------------------------------------

//
procedure TfrmQSO.FormExit(Sender: TObject);
begin
  LastControl:=Sender;
end;

//stisk klavesy ve formulari
procedure TfrmQSO.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  //vyrolovani ComboBoxu
  if (Key=vk_Space)and
     ((Sender.ClassType=TComboBox)or(Sender.ClassType=TFloatComboBox)) then
    TCustomComboBox(Sender).DroppedDown:=not TCustomComboBox(Sender).DroppedDown;
  //skok na dalsi pole
  if Key=vk_Return then
  begin
    if (Sender.ClassType=TComboBox)or(Sender.ClassType=TFloatComboBox) then
      TCustomComboBox(Sender).DroppedDown:=False;
    if not((Sender=edtCall)and(edtCall.Text='')) then
      SelectNext(TWinControl(Sender),True,True);
  end;
  if Key=vk_Down then
    if (Sender.ClassType=TComboBox)or(Sender.ClassType=TFloatComboBox) then
    begin
      if not TCustomComboBox(Sender).DroppedDown then
        SelectNext(TWinControl(Sender),True,True);
    end else
      if (Sender<>edtCall)or((Sender=edtCall)and(edtCall.Text<>'')) then
        SelectNext(TWinControl(Sender),True,True);
  //skok na predchozi pole
  if Key=vk_Up then
    if (Sender.ClassType=TComboBox)or(Sender.ClassType=TFloatComboBox) then
    begin
      if not TCustomComboBox(Sender).DroppedDown then
         SelectNext(TWinControl(Sender),False,True);
    end else
      SelectNext(TWinControl(Sender),False,True);
  if (Key in [vk_Up,vk_Down])and
     ((Sender.ClassType=TComboBox)or(Sender.ClassType=TFloatComboBox)) then
    if not TCustomComboBox(Sender).DroppedDown then Key:=0;
end;

procedure TfrmQSO.FormKeyPress(Sender: TObject; var Key: Char);
begin
  if Key=#13 then Key:=#0;
end;

//zmena dat ve formulari
procedure TfrmQSO.OnFormDataChange(Sender: TObject);
begin
  if not FormReadOnly then FormChanged:=True;
end;

//zmena data a casu
procedure TfrmQSO.OnDateTimeChange(Sender: TObject);
begin
  lblClockTime.Caption:=FormatDateTime(TimeLFormat,TimeUTC);
  lblClockDate.Caption:=FormatDateTime(DateLFormat,DateUTC);
  if DxccList.Active
    then lblDxccTime.Caption:=FormatDateTime(
      TimeLFormat, TimeUTC - DxccList.TimeOffset / 24)
    else lblDxccTime.Caption:='';
end;

//pri zmene DXCC informaci
procedure TfrmQSO.OnDxccChange(Sender: TObject);
begin
  with TDxccList(Sender) do
    if Active then
    begin
      lblDxccDXCC.Caption:=DXCC;
      lblDxccName.Caption:=Name;
      lblDxccLatitude.Caption:=FormatDeg(Latitude,True);
      lblDxccLongitude.Caption:=FormatDeg(Longitude,False);
      lblDxccCont.Caption:=Continent;
    end else
    begin
      lblDxccDXCC.Caption:='';
      lblDxccName.Caption:='';
      lblDxccLatitude.Caption:='';
      lblDxccLongitude.Caption:='';
      lblDxccCont.Caption:='';
    end;
end;

//odkaz
procedure TfrmQSO.lblLinkMouseEnter(Sender: TObject);
begin
  TLabel(Sender).Font.Color:=clBlue;
  TLabel(Sender).Font.Style:=[fsBold,fsUnderline];
end;

procedure TfrmQSO.lblLinkMouseLeave(Sender: TObject);
begin
  TLabel(Sender).Font.Color:=clNavy;
  TLabel(Sender).Font.Style:=[fsBold];
end;

//------------------------------------------------------------------------------
//akce
//------------------------------------------------------------------------------

//help
procedure TfrmQSO.actHelpExecute(Sender: TObject);
begin
  Application.HelpJump(Name);
end;

//vymazat formular a presunout kurzor na pole znacka
procedure TfrmQSO.actClearFormExecute(Sender: TObject);
begin
  ClearForm;
  edtCall.SetFocus;
end;

//vlozeni aktualniho casu a data
procedure TfrmQSO.actInsertDateTimeExecute(Sender: TObject);
begin
  if edtCall.Text<>'' then InsertDateTime;
end;

//dalsi/oredchozi polozka v ComboBoxu
procedure TfrmQSO.actComboBoxUpDownExecute(Sender: TObject);
var
  ComboBox:TCustomComboBox;
  Smer:Boolean;
begin
  ComboBox:=nil;
  if (Sender=actPasmoUp)or(Sender=actPasmoDown) then ComboBox:=cbFreq;
  if (Sender=actModUp)or(Sender=actModDown) then ComboBox:=cbMode;
  if (Sender=actModDown)or(Sender=actPasmoDown) then Smer:=True
                                                else Smer:=False;
  with ComboBox do
  begin
    if Smer then
    begin
      if ItemIndex-1=-1 then ItemIndex:=Items.Count-1
                        else ItemIndex:=ItemIndex-1;
    end else
    begin
      if ItemIndex+1=Items.Count then ItemIndex:=0
                                 else ItemIndex:=ItemIndex+1;
    end;
  end;
end;

//otevreni callbooku
procedure TfrmQSO.actCallBookExecute(Sender: TObject);
begin
  frmCallBook:=TfrmCallBook.Create(nil);
  try
    frmCallBook.dsCall.DataSet.Locate('Znacka',edtCall.Text,[]);
    frmCallBook.ShowModal;
  finally
    frmCallBook.Release;
  end;
end;

//otevreni seznamu DXCC
procedure TfrmQSO.actDxccListExecute(Sender: TObject);
begin
  frmList:=TfrmList.Create(nil);
  try
    frmList.InitList(lmDXCC);
    frmList.qList.Locate(dfnD_Dxcc,edtDXCC.Text,[]);
    frmList.ShowModal;
  finally
    frmList.Release;
  end;
end;

//otevreni seznamu IOTA
procedure TfrmQSO.actIOTAListExecute(Sender: TObject);
begin
  edtIOTA.DoFormat;
  frmList:=TfrmList.Create(nil);
  try
    frmList.InitList(lmIOTA);
    frmList.qList.Locate(dfnI_IOTA,edtIOTA.Text,[]);
    frmList.ShowModal;
  finally
    frmList.Release;
  end;
end;

//nastaveni statusu pole pro zrychlene zadavani
procedure TfrmQSO.actSkipQuickQSOExecute(Sender: TObject);
begin
  QuickQSOs:=QuickQSOs xor (1 shl (TWinControl(pmQSO.PopupComponent).TabOrder));
  QuickQSO:=chQuickQSO.Checked;
end;

//ulozit
procedure TfrmQSO.actSaveExecute(Sender: TObject);

 procedure WriteQSO;
 var
   Table:TTable;
 begin
   Table:=TTable.Create(nil);
   with frmHQLog,Table,Fields do
   try
     DatabaseName:=BDEAlias;
     TableName:=dmLog.User.Call;
     //
     Open;
     if fQSOFormStyle=fsEditQSO then
     begin
       FindKey([qLog.Fields.Fields[dfiL_Index]]);
       Edit;
     end else Insert;
     //
     Fields[dfiL_Date].AsString:=edtDate.Text;
     Fields[dfiL_Time].AsString:=edtTime.Text;
     Fields[dfiL_Call].AsString:=edtCall.Text;
     Fields[dfiL_Freq].AsString:=cbFreq.Text;
     Fields[dfiL_Band].AsInteger:=GetHamBand(StrToFloat(cbFreq.Text));
     Fields[dfiL_Mode].AsInteger:=GetHamMode(cbMode.Text);
     Fields[dfiL_RSTo].AsString:=edtRSTo.Text;
     Fields[dfiL_RSTp].AsString:=edtRSTp.Text;
     Fields[dfiL_Name].AsString:=edtName.Text;
     Fields[dfiL_QTH].AsString:=edtQTH.Text;
     Fields[dfiL_LOCo].AsString:=edtLOCo.Text;
     Fields[dfiL_LOCp].AsString:=edtLOCp.Text;
     Fields[dfiL_QSLo].AsInteger:=cbQSLo.ItemIndex;
     Fields[dfiL_QSLp].AsInteger:=cbQSLp.ItemIndex;
     Fields[dfiL_QSLvia].AsString:=edtQSLmgr.Text;
     Fields[dfiL_EQSLp].AsInteger:=cbEQSL.ItemIndex;
     Fields[dfiL_Note].AsString:=edtNote.Text;
     Fields[dfiL_PWR].AsString:=cbPWR.Text;
     Fields[dfiL_QRB].AsInteger:=VypoctiVzdalenost;
     Fields[dfiL_DXCC].AsString:=edtDXCC.Text;
     Fields[dfiL_IOTA].AsString:=edtIOTA.Text;
     Fields[dfiL_Award].AsString:=edtAward.Text;
     Fields[dfiL_ITU].AsString:=edtITU.Text;
     Fields[dfiL_WAZ].AsString:=edtWAZ.Text;
     //
     Post;
     Close;
   finally
     Table.Free;
   end;
 end;

begin
  btnSave.SetFocus;
  //kontrola udaju ve formulari
  if not(JeZnacka(edtCall.Text,edtCall)and
         JeFrekvence(cbFreq.Text,cbFreq)and
         JeLoc(edtLOCp.Text,edtLOCp)and
         JeDXCC(edtDxcc.Text,edtDxcc)and
         JeITU(edtITU.Text,edtITU)and
         JeWAZ(edtWAZ.Text,edtWAZ)and
         JeIOTA(edtIOTA.Text,edtIOTA)and
         JeCas(edtTime.Text,edtTime)and
         JeDatum(edtDate.Text,edtDate)and
         JeVykon(cbPWR.Text,cbPWR)and
         JeLoc(edtLOCo.Text,edtLOCo)) then Exit;
  if (cbMode.ItemIndex < Low(THamMode))or
     (cbMode.ItemIndex > High(THamMode)) then
  begin
    cMessageDlg(Format(strModeNotValid,['']),mtError,[mbOk],mrOk,0);
    Exit;
  end;
  if edtLOCo.Text='' then
  begin
    cMessageDlg(strNoLoc,mtError,[mbOk],mrOk,0);
    edtLOCo.SetFocus;
    Exit;
  end;
  DataChanged:=True;
  //pridani zeme DXCC do docasneho zasobniku
  if DxccList.Active then
    nDxcc.Append(DxccList.DXCC+';'+
                 IntToStr(GetHamBand(StrToFloat(cbFreq.Text))));
  WriteQSO;
  if fQSOFormStyle=fsEditQSO then
  begin
    FormChanged:=False;
    Close;
  end else
  begin
    if fRefreshLog then
    begin
      frmHQLog.RefreshLog(False, False);// RefreshLog;
      DataChanged:=False;
    end;
    ClearForm;
    edtCall.SetFocus;
  end;
end;

//zavrit formular
procedure TfrmQSO.actCloseExecute(Sender: TObject);
begin
  Close;
end;


//nastaveni jen pro cteni
procedure TfrmQSO.SetReadOnly(const ReadOnly:Boolean);
var
  i:Integer;
begin
  grpBoxSpojeni.Enabled:=not ReadOnly;
  grpBoxVlastni.Enabled:=not ReadOnly;
  grpBoxVolby.Enabled:=not ReadOnly;
  for i:=0 to actManager.ActionCount-1 do
    if actManager.Actions[i].Category='Upravy' then
      TAction(actManager.Actions[i]).Enabled:=not ReadOnly;
end;

//nastaveni rychleho zadavani
procedure TfrmQSO.SetQuickQSO(const Value:Boolean);
const
  cSel=$CCFFFF;
  cNSel=$FFFFFF;

begin
  fQuickQSO:=Value;
  if Value then
  begin
    //TabStop
    cbFreq.TabStop:=(QuickQSOs and (1 shl cbFreq.TabOrder))<>0;
    cbMode.TabStop:=(QuickQSOs and (1 shl cbMode.TabOrder))<>0;
    edtRSTo.TabStop:=(QuickQSOs and (1 shl edtRSTo.TabOrder))<>0;
    edtRSTp.TabStop:=(QuickQSOs and (1 shl edtRSTp.TabOrder))<>0;
    edtName.TabStop:=(QuickQSOs and (1 shl edtName.TabOrder))<>0;
    edtQTH.TabStop:=(QuickQSOs and (1 shl edtQTH.TabOrder))<>0;
    edtLOCp.TabStop:=(QuickQSOs and (1 shl edtLOCp.TabOrder))<>0;
    edtDxcc.TabStop:=(QuickQSOs and (1 shl edtDxcc.TabOrder))<>0;
    edtITU.TabStop:=(QuickQSOs and (1 shl edtITU.TabOrder))<>0;
    edtWAZ.TabStop:=(QuickQSOs and (1 shl edtWAZ.TabOrder))<>0;
    edtIOTA.TabStop:=(QuickQSOs and (1 shl edtIOTA.TabOrder))<>0;
    edtAward.TabStop:=(QuickQSOs and (1 shl edtAward.TabOrder))<>0;
    edtQSLmgr.TabStop:=(QuickQSOs and (1 shl edtQSLmgr.TabOrder))<>0;
    cbQSLo.TabStop:=(QuickQSOs and (1 shl cbQSLo.TabOrder))<>0;
    edtNote.TabStop:=(QuickQSOs and (1 shl edtNote.TabOrder))<>0;
    edtTime.TabStop:=(QuickQSOs and (1 shl edtTime.TabOrder))<>0;
    edtDate.TabStop:=(QuickQSOs and (1 shl edtDate.TabOrder))<>0;
    //barva
    edtCall.Color:=cSel;
    if (QuickQSOs and (1 shl cbFreq.TabOrder))<>0 then cbFreq.Color:=cSel else cbFreq.Color:=cNSel;
    if (QuickQSOs and (1 shl cbMode.TabOrder))<>0 then cbMode.Color:=cSel else cbMode.Color:=cNSel;
    if (QuickQSOs and (1 shl edtRSTo.TabOrder))<>0 then edtRSTo.Color:=cSel else edtRSTo.Color:=cNSel;
    if (QuickQSOs and (1 shl edtRSTp.TabOrder))<>0 then edtRSTp.Color:=cSel else edtRSTp.Color:=cNSel;
    if (QuickQSOs and (1 shl edtName.TabOrder))<>0 then edtName.Color:=cSel else edtName.Color:=cNSel;
    if (QuickQSOs and (1 shl edtQTH.TabOrder))<>0 then edtQTH.Color:=cSel else edtQTH.Color:=cNSel;
    if (QuickQSOs and (1 shl edtLOCp.TabOrder))<>0 then edtLOCp.Color:=cSel else edtLOCp.Color:=cNSel;
    if (QuickQSOs and (1 shl edtDxcc.TabOrder))<>0 then edtDxcc.Color:=cSel else edtDxcc.Color:=cNSel;
    if (QuickQSOs and (1 shl edtITU.TabOrder))<>0 then edtITU.Color:=cSel else edtITU.Color:=cNSel;
    if (QuickQSOs and (1 shl edtWAZ.TabOrder))<>0 then edtWAZ.Color:=cSel else edtWAZ.Color:=cNSel;
    if (QuickQSOs and (1 shl edtIOTA.TabOrder))<>0 then edtIOTA.Color:=cSel else edtIOTA.Color:=cNSel;
    if (QuickQSOs and (1 shl edtAward.TabOrder))<>0 then edtAward.Color:=cSel else edtAward.Color:=cNSel;
    if (QuickQSOs and (1 shl edtQSLmgr.TabOrder))<>0 then edtQSLmgr.Color:=cSel else edtQSLmgr.Color:=cNSel;
    if (QuickQSOs and (1 shl cbQSLo.TabOrder))<>0 then cbQSLo.Color:=cSel else cbQSLo.Color:=cNSel;
    if (QuickQSOs and (1 shl edtNote.TabOrder))<>0 then edtNote.Color:=cSel else edtNote.Color:=cNSel;
    if (QuickQSOs and (1 shl edtTime.TabOrder))<>0 then edtTime.Color:=cSel else edtTime.Color:=cNSel;
    if (QuickQSOs and (1 shl edtDate.TabOrder))<>0 then edtDate.Color:=cSel else edtDate.Color:=cNSel;
  end else
  begin
    //TabStop
    cbFreq.TabStop:=True;
    cbMode.TabStop:=True;
    edtRSTo.TabStop:=True;
    edtRSTp.TabStop:=True;
    edtName.TabStop:=True;
    edtQTH.TabStop:=True;
    edtLOCp.TabStop:=True;
    edtDxcc.TabStop:=True;
    edtITU.TabStop:=True;
    edtWAZ.TabStop:=True;
    edtIOTA.TabStop:=True;
    edtAward.TabStop:=True;
    edtQSLmgr.TabStop:=True;
    cbQSLo.TabStop:=True;
    edtNote.TabStop:=True;
    edtTime.TabStop:=True;
    edtDate.TabStop:=True;
    //barva
    edtCall.Color:=cNSel;
    cbFreq.Color:=cNSel;
    cbMode.Color:=cNSel;
    edtRSTo.Color:=cNSel;
    edtRSTp.Color:=cNSel;
    edtName.Color:=cNSel;
    edtQTH.Color:=cNSel;
    edtLOCp.Color:=cNSel;
    edtDxcc.Color:=cNSel;
    edtITU.Color:=cNSel;
    edtWAZ.Color:=cNSel;
    edtIOTA.Color:=cNSel;
    edtAward.Color:=cNSel;
    edtQSLmgr.Color:=cNSel;
    cbQSLo.Color:=cNSel;
    edtNote.Color:=cNSel;
    edtTime.Color:=cNSel;
    edtDate.Color:=cNSel;
  end;
  cbFreq.SelLength:=0;
end;

//nastaveni Offline casu
procedure TfrmQSO.SetOffline(const Value:Boolean);
begin
  fOffline:=Value;
  chOffline.Checked:=Value;
end;

//------------------------------------------------------------------------------
//nacist, nove, upravit QSO

//nacteni QSO z deniku pro editace/zobrazeni
procedure TfrmQSO.LoadRecord;
var
  i:Integer;
  m:THamMode;
begin
  with frmHQLog.qLog.Fields do
  begin
    edtCall.Text:=Fields[dfiL_Call].AsString;
    cbFreq.Text:=FormatFloat(FreqFormat,Fields[dfiL_Freq].AsFloat);
    m:=Fields[dfiL_Mode].AsInteger;
    i:=cbMode.Items.IndexOf(hModeName[m]);
    if i=-1 then
    begin
      cbMode.Items.Add(hModeName[m]);
      cbMode.ItemIndex:=cbMode.Items.Count-1;
    end else cbMode.ItemIndex:=i;
    edtRSTo.Text:=Fields[dfiL_RSTo].AsString;
    edtRSTp.Text:=Fields[dfiL_RSTp].AsString;
    edtName.Text:=Fields[dfiL_Name].AsString;
    edtQTH.Text:=Fields[dfiL_QTH].AsString;
    edtLOCp.Text:=Fields[dfiL_LOCp].AsString;
    edtIOTA.Text:=Fields[dfiL_IOTA].AsString;
    edtAward.Text:=Fields[dfiL_Award].AsString;
    edtQSLmgr.Text:=Fields[dfiL_QSLvia].AsString;
    cbQSLo.ItemIndex:=Fields[dfiL_QSLo].AsInteger;
    cbQSLp.ItemIndex:=Fields[dfiL_QSLp].AsInteger;
    cbEQSL.ItemIndex:=Fields[dfiL_EQSLp].AsInteger;
    edtNote.Text:=Fields[dfiL_Note].AsString;
    edtTime.Text:=FormatDateTime(TimeLFormat,Fields[dfiL_Time].AsDateTime);
    edtDate.Text:=FormatDateTime(DateLFormat,Fields[dfiL_Date].AsDateTime);
    cbPWR.Text:=Fields[dfiL_PWR].AsString;
    edtLOCo.Text:=Fields[dfiL_LOCo].AsString;
    edtDXCC.Text:=Fields[dfiL_DXCC].AsString;
    edtITU.Text:=Fields[dfiL_ITU].AsString;
    edtWAZ.Text:=Fields[dfiL_WAZ].AsString;
  end;
  lCall:=edtCall.Text;
  lDxcc:=edtDXCC.Text;
  try
    lblBand.Caption:=strBand+': '+hBandName[GetHamBand(StrToFloat(cbFreq.Text))];
  except
  end;
end;

//------------------------------------------------------------------------------
//funkce vymazat, vlozit datum a cas
//------------------------------------------------------------------------------

//vymazat formular
procedure TfrmQSO.ClearForm;
begin
  //vstupni pole
  edtCall.Clear;
  edtName.Clear;
  edtQTH.Clear;
  edtLOCp.Clear;
  edtDXCC.Clear;
  edtITU.Clear;
  edtWAZ.Clear;
  edtIOTA.Clear;
  edtAward.Clear;
  edtQSLmgr.Clear;
  if not LockNote then edtNote.Clear;
  if not Offline then
  begin
    edtTime.Clear;
    edtDate.Clear;
  end;
  //informacni napisy
  lblNovaZeme.Enabled:=False;
  lblPseQsl.Enabled:=False;
  //zavrit DXCC
  DxccList.Active:=False;
  //vymazat vzdalenost, azimut, lokalni cas
  lblDistance.Caption:='';
  lblAzimuth.Caption:='';
  lblDXCCTime.Caption:='';
  //zavrit predchozi spojeni
  if qPred.Active then qPred.Close;
  //vymazat indikaci zmeny dat
  if fQSOFormStyle=fsNewQSO then FormChanged:=False;
  lCall:='-';
  lDxcc:='-';
end;

//vlozeni aktualniho casu a data
procedure TfrmQSO.InsertDateTime;
begin
  edtTime.Text:=FormatDateTime(TimeLFormat, TimeUTC);
  edtDate.Text:=FormatDateTime(DateLFormat, DateUTC);
end;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

//vyhledani predchozich spojeni
procedure TfrmQSO.GetLastQSOs;
var
  Znacka:String;
begin
  //filtrovat databazi
  Znacka:=ExtractHamCall(edtCall.Text);
  qPred.SQL.Clear;
  if fQSOFormStyle=fsNewQSO
    then qPred.SQL.Add(Format(
      'SELECT * FROM "%0:s" WHERE '+
      '(%1:s LIKE "%2:s")OR(%1:s LIKE "%2:s/%%")OR'+
      '(%1:s LIKE "%%/%2:s")OR(%1:s LIKE "%%/%2:s/%%") '+
      'ORDER BY %3:s',
      [dmLog.User.Call,dfnL_Call,Znacka,dfnL_Date+','+dfnL_Time]))
    else qPred.SQL.Add(Format(
      'SELECT * FROM "%0:s" WHERE '+
      '(%1:s<>"%2:s")AND'+
      '((%3:s LIKE "%4:s")OR(%3:s LIKE "%4:s/%%")OR'+
       '(%3:s LIKE "%%/%4:s")OR(%3:s LIKE "%%/%4:s/%%")) '+
      'ORDER BY %5:s',
      [dmLog.User.Call,
       dfnL_Index,frmHQLog.qLog.Fields.Fields[dfiL_Index].AsString,
       dfnL_Call,Znacka,dfnL_Date+','+dfnL_Time]));
  qPred.Open;
  qPred.Last;
end;

//vyhledani informaci o stanici v predchozich spojenich
procedure TfrmQSO.LookInLog(const Znacka: String);
var
  OnlyExact, lName, lQTH, lQSL, lLOC, lIOTA, lAward: Boolean;
begin
  if not qPred.Active then Exit;
  //doplnit
  with qPred, qPred.Fields do
  begin
    DisableControls;
    First;
    OnlyExact:=False;
    //vybrat pole pro doplneni (prazdna)
    lName:=edtName.Text = '';
    lQTH:=edtQTH.Text = '';
    lQSL:=edtQSLmgr.Text = '';
    lLOC:=edtLOCp.Text = '';
    lIOTA:=edtIOTA.Text = '';
    lAward:=edtAward.Text = '';
    while not Eof do
    begin
      //priorita
      if (not OnlyExact) or (OnlyExact and (Znacka = Fields[dfiL_Call].AsString)) then
      begin
        if lName and (Fields[dfiL_Name].AsString <> '') then
          edtName.Text:=Fields[dfiL_Name].AsString;
        if Znacka = Fields[dfiL_Call].AsString then
        begin
          OnlyExact:=True;
          if lQTH and (Fields[dfiL_QTH].AsString <> '') then
            edtQth.Text:=Fields[dfiL_QTH].AsString;
          if lQSL and (Fields[dfiL_QSLvia].AsString <> '') then
            edtQSLmgr.Text:=Fields[dfiL_QSLvia].AsString;
          if lLOC and (IsWWL(Fields[dfiL_LOCp].AsString)) then
            edtLOCp.Text:=Fields[dfiL_LOCp].AsString;
          if lAward and (JeIOTA2(Fields[dfiL_IOTA].AsString)) then
            edtIOTA.Text:=Fields[dfiL_IOTA].AsString;
          if lIOTA and (Fields[dfiL_Award].AsString <> '') then
            edtAward.Text:=Fields[dfiL_Award].AsString;
          if (JeZnacka2(Fields[dfiL_DXCC].AsString)) then
            edtDXCC.Text:=Fields[dfiL_DXCC].AsString;
          edtITU.Text:=Fields[dfiL_ITU].AsString;
          edtWAZ.Text:=Fields[dfiL_WAZ].AsString;
        end;

      end;
      Next;
    end;
    Last;
    EnableControls;
  end;
end;

//vyhledani informaci o stanici v CallBooku
procedure TfrmQSO.LookInCB(const Znacka:String);
var
  d1,d2,d3:Boolean;
begin
  //je databaze otevrena a je znacka OK/OL ???
  if (not qCallBook.Active)or
     ((Copy(Znacka,1,2)<>'OK')and(Copy(Znacka,1,2)<>'OL')) then Exit;
  if not qCallBook.Locate('ZNACKA',Znacka,[loCaseInsensitive]) then Exit;
  //vybrat pole pro doplneni (prazdna)
  d1:=edtName.Text='';
  d2:=edtQTH.Text='';
  d3:=edtLOCp.Text='';
  with qCallBook.Fields do
  begin
    if (d1)and(Fields[1].AsString<>'') then edtName.Text:=Fields[1].AsString;
    if (d2)and(Fields[2].AsString<>'') then edtQth.Text:=Fields[2].AsString;
    if (d3)and(IsWWL(Fields[3].AsString, True)) then edtLOCp.Text:=Fields[3].AsString;
  end;
end;

//nova zeme DXCC?
procedure TfrmQSO.CheckNewDXCC;
var
  rNo:Integer;
begin
  with frmHQLog.qLog,frmHQLog.qLog.Fields do
  begin
    if ((fQSOFormStyle=fsNewQSO)or
        ((fQSOFormStyle<>fsNewQSO)and(edtCall.Text<>Fields[dfiL_Call].AsString)))and
       (DxccList.Active) then
    begin
      rNo:=RecNo;
      DisableControls;
      try
        lblNovaZeme.Enabled:=(DxccList.Active)and
          (not Locate(dfnL_DXCC+';'+dfnL_Band,VarArrayOf([edtDXCC.Text,
            GetHamBand(StrToFloat(cbFreq.Text))]),[]))and
          (nDXCC.IndexOf(DxccList.DXCC+';'+
            IntToStr(GetHamBand(StrToFloat(cbFreq.Text))))=-1);

      finally
        RecNo:=rNo;
        EnableControls;
      end;
    end;
  end;
end;

//pozadovat QSL?
procedure TfrmQSO.CheckQSL;
var
  rNo:Integer;
begin
  if not((fQSOFormStyle<>fsNewQSO)or(not qPred.Active)) then
    if qPred.RecordCount=0 then lblPseQsl.Enabled:=True else
    begin
      rNo:=qPred.RecNo;
      qPred.DisableControls;
      try
        try
          if qPred.Locate(dfnL_Mode+';'+dfnL_Band+';'+dfnL_QSLp,
            VarArrayOf([GetHamMode(cbMode.Text),
                        GetHamBand(StrToFloat(cbFreq.Text)),1]),[])
            then lblPseQsl.Enabled:=False
            else lblPseQsl.Enabled:=True;
        except
        end;
      finally
        qPred.RecNo:=rNo;
        qPred.EnableControls;
      end;
    end else lblPseQsl.Enabled:=False;
end;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

//vypocteni vzdalenosti
function TfrmQSO.VypoctiVzdalenost:Integer;
begin
  if IsWWL(edtLOCp.Text) then
    Result:=GetDistance(edtLOCo.Text, edtLOCp.Text, 0, 0)
  else if DxccList.Active then
    Result:=GetDistance(edtLOCo.Text, edtLOCp.Text, DxccList.Longitude, DxccList.Latitude)
  else
    Result:=0;
end;

//vypocteni azimutu
function TfrmQSO.VypoctiAzimut:Integer;
begin
  if IsWWL(edtLOCp.Text) then
    Result:=GetAzimuth(edtLOCo.Text, edtLOCp.Text, 0, 0)
  else if DxccList.Active then
    Result:=GetAzimuth(edtLOCo.Text, edtLOCp.Text, DxccList.Longitude, DxccList.Latitude)
  else
    Result:=0;
end;

//vypocteni vzdalenosti a azimutu + zobrazeni
procedure TfrmQSO.VypoctiVzdalAzi;
var
  vz, az: Integer;
begin
  vz:=VypoctiVzdalenost;
  az:=VypoctiAzimut;
  if vz>-1 then
  begin
    lblDistance.Caption:=IntToStr(vz)+'km';
    lblDistance.Visible:=True;
  end else lblDistance.Visible:=False;
  if az>-1 then
  begin
    lblAzimuth.Caption:=IntToStr(az)+'°';
    lblAzimuth.Visible:=True;
  end else lblAzimuth.Visible:=False;
end;

end.
