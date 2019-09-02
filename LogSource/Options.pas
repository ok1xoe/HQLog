{$include global.inc}
unit Options;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Spin, ExtCtrls, ComCtrls, HamLogFP,
  HQLResStrings, Amater, Grids, mxArrays, CheckLst, cfmDialogs,
  OptionsIO, HQLDatabase, HQLConsts, ActnList, XPStyleActnCtrls, ActnMan,
  HQLControls;

type
  TOptionsFormStyle=(fsNewUser,fsEditUser);
  //
  TfrmMode=(fmCreate,fmEdit);
  TfrmOptions = class(TForm)
    pgConNastav: TPageControl;
    tbSheetZaklad: TTabSheet;
    btnZrusit: TButton;
    btnOk: TButton;
    tbSheetRozs: TTabSheet;
    tbSheetVl: TTabSheet;
    lblUser: TLabel;
    bvlUser: TBevel;
    chRefreshLog: TCheckBox;
    chLookInLog: TCheckBox;
    chLookInCB: TCheckBox;
    chBackUp: TCheckBox;
    Label5: TLabel;
    cbBackUp: TComboBox;
    btnBackUpDir: TButton;
    lblNQSO: TLabel;
    bvlCara4: TBevel;
    lblZaloha: TLabel;
    bvlCara5: TBevel;
    chNameUpCase: TCheckBox;
    tbSheetFreq: TTabSheet;
    lblFreq: TLabel;
    bvlFreq: TBevel;
    dGrdFreq: TDrawGrid;
    btnFreqDown: TButton;
    btnFreqUp: TButton;
    btnFreqDef: TButton;
    btnFreqDel: TButton;
    btnFreqAdd: TButton;
    lblPreNastNQSO: TLabel;
    lblPWR: TLabel;
    cbQSLp: TComboBox;
    cbQSLo: TComboBox;
    lblQSLo: TLabel;
    lblQSLp: TLabel;
    bvlCara2: TBevel;
    bvlCara3: TBevel;
    tbSheetMode: TTabSheet;
    lblMode: TLabel;
    bvlMode: TBevel;
    dGrdMode: TDrawGrid;
    btnModeAdd: TButton;
    btnModeDel: TButton;
    btnModeDef: TButton;
    btnModeUp: TButton;
    btnModeDown: TButton;
    lblDateTime: TLabel;
    bvlDateTime: TBevel;
    chSyncTime: TCheckBox;
    cbNTPServer: TComboBox;
    lblNTPServer: TLabel;
    tbShtDXC: TTabSheet;
    lblDXC: TLabel;
    bvlCara6: TBevel;
    lblDXCWarning: TLabel;
    spEdtDXCPort: TSpinEdit;
    edtDXCHost: TEdit;
    edtDXCPwd: TEdit;
    lblDXCHost: TLabel;
    lblDXCPort: TLabel;
    lblDXCPwd: TLabel;
    tbShtDisplay: TTabSheet;
    lblPerformance: TLabel;
    bvlPerformance: TBevel;
    chExtendedFont: TCheckBox;
    lblFormat: TLabel;
    Bevel1: TBevel;
    lblDateFormat: TLabel;
    lblTimeFormat: TLabel;
    cbDateFormat: TComboBox;
    cbTimeFormat: TComboBox;
    cbFreqFormat: TComboBox;
    lblFreqFormat: TLabel;
    actManager: TActionManager;
    actHelp: TAction;
    actSave: TAction;
    actCancel: TAction;
    edtCall: TEdit;
    lblCall: TLabel;
    edtLoc: TLocatorEdit;
    lblLoc: TLabel;
    edtRSTo: TReportEdit;
    lblRSTo: TLabel;
    edtRSTp: TReportEdit;
    lblRSTp: TLabel;
    cbPWR: TFloatComboBox;
    edtBackUpPath: TEdit;
    lblBackUpPath: TLabel;
    lblDxcChange: TLabel;
    //
    constructor Create(AOwner:TComponent; OptionsFStyle:TOptionsFormStyle); reintroduce;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    //
    procedure CallKeyPress(Sender: TObject; var Key: Char);
    procedure edtDxcChange(Sender: TObject);
    procedure btnBackUpDirClick(Sender: TObject);
    procedure chSyncTimeClick(Sender: TObject);
    //
    procedure btnModeAddClick(Sender: TObject);
    procedure btnModeDelClick(Sender: TObject);
    procedure btnModeDefClick(Sender: TObject);
    procedure btnModeUpClick(Sender: TObject);
    procedure btnModeDownClick(Sender: TObject);
    procedure dGrdModeDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    //
    procedure btnFreqAddClick(Sender: TObject);
    procedure btnFreqDelClick(Sender: TObject);
    procedure btnFreqDefClick(Sender: TObject);
    procedure btnFreqUpClick(Sender: TObject);
    procedure btnFreqDownClick(Sender: TObject);
    procedure dGrdFreqDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    //
    procedure actHelpExecute(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure actCancelExecute(Sender: TObject);
    //
  private
    { Private declarations }
    fOptionsFormStyle:TOptionsFormStyle;
    User:TUserOptions;
    DxcChanged:Boolean;
    //mody
    ModeList:TBaseArray;
    ModeDefault:Integer;
    //frekvence
    FreqList:TBaseArray;
    FreqDefault:Integer;
    //
    procedure OnSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;
    procedure LoadOptions;
    procedure SaveOptions;
    procedure NewUser;
  public
    { Public declarations }
  end;

var
  frmOptions: TfrmOptions;

implementation

uses Main, Kontrola, KeyFilters, dlgComboBox, HQLdMod;
{$R *.dfm}

//------------------------------------------------------------------------------
//frmOptions
//------------------------------------------------------------------------------

constructor TfrmOptions.Create(AOwner:TComponent; OptionsFStyle:TOptionsFormStyle);
begin
  fOptionsFormStyle:=OptionsFStyle;
  inherited Create(AOwner);
end;

//------------------------------------------------------------------------------

//vytvoreni formulare
procedure TfrmOptions.FormCreate(Sender: TObject);
var
  i:Integer;
  f:Double;
  m,AddMode:THamMode;
begin
  //mody
  ModeList:=TBaseArray.Create(0,SizeOf(THamMode));
  ModeDefault:=0;
  //frekvence
  FreqList:=TBaseArray.Create(0,SizeOf(Double));
  FreqDefault:=0;
  //prednastaveni
  SetCbBoxItems(cbNTPServer,NTPServers);
  SetCbBoxItemsF(cbPWR,hPWRs);
  SetCbBoxItems(cbQSLo,hQSLoNames);
  SetCbBoxItems(cbQSLp,hQSLpNames);
  SetCbBoxItems(cbDateFormat,DateFormats);
  SetCbBoxItems(cbTimeFormat,TimeFormats);
  SetCbBoxItems(cbFreqFormat,FreqFormats);
  edtRSTo.Text:='599';
  edtRSTp.Text:='599';
  cbPWR.Text:='100';
  edtBackUpPath.Text:=dmLog.RootDir+Zal_Dir;
  edtDXCHost.Text:=DXCDefHost;
  //
  if fOptionsFormStyle=fsNewUser then
  //novy uzivatel
  begin
    User:=TUserOptions.Create;
    for i:=Low(hBandBegin) to High(hBandBegin)-1 do
    begin
      f:=hBandBegin[i];
      FreqList.Insert(FreqList.Count,f);
    end;
    for m:=Succ(Low(THamMode)) to High(THamMode) do
    begin
      AddMode:=m;
      ModeList.Insert(ModeList.Count,AddMode);
    end;
    dGrdFreq.RowCount:=FreqList.Count+1;
    dGrdMode.RowCount:=ModeList.Count+1;
    cbNTPServer.Enabled:=False;
  end else
  //editace uzivatele
  begin
    User:=dmLog.User;
    LoadOptions;
    edtCall.Enabled:=False;
  end;
  //
  DxcChanged:=False;
end;

//uvolneni formulare
procedure TfrmOptions.FormDestroy(Sender: TObject);
begin
  ModeList.Free;
  FreqList.Free;
  if fOptionsFormStyle=fsNewUser then User.Free;
end;

//
procedure TfrmOptions.OnSysCommand(var Msg: TWMSysCommand);
begin
  if Msg.CmdType=SC_MINIMIZE then ShowWindow(Application.Handle,SW_SHOWMINNOACTIVE)
                             else inherited;
end;

//------------------------------------------------------------------------------

//nacteni stavajcich nastaveni z registru
procedure TfrmOptions.LoadOptions;
begin
  with User do
  begin
    //uzivatel
    edtCall.Text:=Call;
    edtLOC.Text:=Loc;
    //datum a cas
    chSyncTime.Checked:=Time_Sync;
    cbNTPServer.Enabled:=Time_Sync;
    cbNTPServer.Text:=Time_NTPServer;
    //vzhled
    cbDateFormat.ItemIndex:=Design_DateFormat;
    cbTimeFormat.ItemIndex:=Design_TimeFormat;
    cbFreqFormat.ItemIndex:=Design_FreqFormat;
    chExtendedFont.Checked:=Design_ExtendedFont;
    //
    edtRSTo.Text:=nQSO_RSTo;
    edtRSTp.Text:=nQSO_RSTp;
    cbQSLo.ItemIndex:=nQSO_QSLo;
    cbQSLp.ItemIndex:=nQSO_QSLp;
    cbPWR.Text:=FloatToStr(nQSO_PWR);
    chLookInLog.Checked:=nQSO_LookInLog;
    chLookInCB.Checked:=nQSO_LookInCB;
    chRefreshLog.Checked:=nQSO_RefreshLog;
    chNameUpCase.Checked:=nQSO_NameUpCase;
    //mody
    ModeDefault:=nQSO_DefMode;
    nQSO_GetModes(ModeList);
    if ModeList.Count=0 then dGrdMode.RowCount:=2
                        else dGrdMode.RowCount:=ModeList.Count+1;
    //frekvence
    FreqDefault:=nQSO_DefFreq;
    nQSO_GetFreqs(FreqList);
    if FreqList.Count=0 then dGrdFreq.RowCount:=2
                        else dGrdFreq.RowCount:=FreqList.Count+1;
    //zaloha
    chBackUp.Checked:=BackUp_Enabled;
    cbBackUp.ItemIndex:=BackUp_Interval;
    edtBackUpPath.Text:=BackUp_Path;
    //dxc
    edtDXCHost.Text:=DXC_Host;
    spEdtDXCPort.Value:=DXC_Port;
    if DXC_Password='' then edtDxcPwd.Text:=''
                       else edtDxcPwd.Text:='*********';
  end;
  DxcChanged:=False;
end;

//ulozeni nastaveni
procedure TfrmOptions.SaveOptions;
begin
  with User do
  begin
    //uzivatel
    Loc:=edtLoc.Text;
    //datum a cas
    Time_Sync:=chSyncTime.Checked;
    Time_NTPServer:=cbNTPServer.Text;
    //vzhled
    Design_DateFormat:=cbDateFormat.ItemIndex;
    Design_TimeFormat:=cbTimeFormat.ItemIndex;
    Design_FreqFormat:=cbFreqFormat.ItemIndex;
    Design_ExtendedFont:=chExtendedFont.Checked;
    //prednastaveni nQSO
    nQSO_RSTo:=edtRSTo.Text;
    nQSO_RSTp:=edtRSTp.Text;
    nQSO_PWR:=StrToFloat(cbPWR.Text);
    nQSO_QSLo:=cbQSLo.ItemIndex;
    nQSO_QSLp:=cbQSLp.ItemIndex;
    //
    nQSO_RefreshLog:=chRefreshLog.Checked;
    nQSO_LookInLog:=chLookInLog.Checked;
    nQSO_LookInCB:=chLookInCB.Checked;
    nQSO_NameUpCase:=chNameUpCase.Checked;
    //frekvence
    nQSO_DefFreq:=FreqDefault;
    nQSO_SetFreqs(FreqList);
    //mody
    nQSO_DefMode:=ModeDefault;
    nQSO_SetModes(ModeList);
    //zalohovani
    BackUp_Enabled:=chBackUp.Checked;
    BackUp_Interval:=cbBackUp.ItemIndex;
    BackUp_Path:=edtBackUpPath.Text;
    //DXC
    DXC_Host:=edtDXCHost.Text;
    DXC_Port:=spEdtDXCPort.Value;
    if edtDxcPwd.Text<>'*********' then
      DXC_Password:=edtDxcPwd.Text;
    //ExtLog
{    WriteString('ExtLog','FileName',edtExtLogPath.Text);
    WriteBool('ExtLog','UpdateIm',chBoxExtLog.Checked);}
  end;
end;

procedure TfrmOptions.NewUser;
var
  i,j:Integer;
begin
  with User do
  begin
    for i:=0 to 9 do
      if dmLog.Options.User[i]='' then
      begin
        dmLog.Options.User[i]:=UpperCase(edtCall.Text);
        try
          dmLog.Options.UpdateFile;
        except
          Exit;
        end;
        Break;
      end;
    //uzivatel
    Call:=edtCall.Text;
    Loc:=edtLoc.Text;
    //datum a cas
    Time_Sync:=chSyncTime.Checked;
    Time_NTPServer:=cbNTPServer.Text;
    //vzhled
    Design_DateFormat:=cbDateFormat.ItemIndex;
    Design_TimeFormat:=cbTimeFormat.ItemIndex;
    Design_FreqFormat:=cbFreqFormat.ItemIndex;
    Design_ExtendedFont:=chExtendedFont.Checked;
    //prednastaveni nQSO
    nQSO_RSTo:=edtRSTo.Text;
    nQSO_RSTp:=edtRSTp.Text;
    nQSO_PWR:=StrToFloat(cbPWR.Text);
    nQSO_QSLo:=cbQSLo.ItemIndex;
    nQSO_QSLp:=cbQSLp.ItemIndex;
    //
    nQSO_RefreshLog:=chRefreshLog.Checked;
    nQSO_LookInLog:=chLookInLog.Checked;
    nQSO_LookInCB:=chLookInCB.Checked;
    nQSO_NameUpCase:=chNameUpCase.Checked;
    nQSO_QuickQSOs:=0;
    //frekvence
    nQSO_DefFreq:=FreqDefault;
    nQSO_SetFreqs(FreqList);
    //mody
    nQSO_DefMode:=ModeDefault;
    nQSO_SetModes(ModeList);
    //zalohovani
    BackUp_Enabled:=chBackUp.Checked;
    BackUp_Interval:=cbBackUp.ItemIndex;
    BackUp_Path:=edtBackUpPath.Text;
    BackUp_Date:=Date;
    //DXC
    DXC_Host:=edtDXCHost.Text;
    DXC_Port:=spEdtDXCPort.Value;
    if edtDxcPwd.Text='*********' then DXC_Password:=''
                                  else DXC_Password:=edtDxcPwd.Text;
    //mapa
    Map_Zoom:=0;
    Map_CenterX:=15;
    Map_CenterY:=49.8;
    Map_WWLGrid:=False;
    Map_GeoGrid:=True;
{    //ExtLog
    WriteString('ExtLog','FileName',edtExtLogPath.Text);
    WriteBool('ExtLog','UpdateIm',chBoxExtLog.Checked);}
    //sloupce
    case GetSystemMetrics(SM_CXSCREEN) of
      0..1023: j:=0;
      1024..1151: j:=1;
      1152..1279: j:=2;
    else
      j:=3;
    end;
    for i:=Low(dfL_Name)+1 to High(dfL_Name) do
    begin
      SetColumnCaption(dfL_Name[i],dfL_Caption[i]);
      SetColumnTAlignment(dfL_Name[i],dfL_CaptionAl[i]);
      SetColumnAlignment(dfL_Name[i],dfL_TextAl[i]);
      SetColumnWidth(dfL_Name[i],dfL_Width[i,j]);
      SetColumnVisible(dfL_Name[i],Boolean(dfL_Visible[i,j]));
      SetColumnIndex(dfL_Name[i],dfL_Index[i]);
    end;
    //ulozit nastaveni do souboru
    try
      SaveToFile(dmLog.DataDir+edtCall.Text+uFileExt);
    except
    end;
    //vytvorit datove soubory
    CreateLogDB(dmLog.DataDir+edtCall.Text+dFileExt);
  end;
end;

//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------

//znacka
procedure TfrmOptions.CallKeyPress(Sender: TObject; var Key: Char);
begin
  if not(Key in ['a'..'z','A'..'Z','0'..'9',#8]) then Key:=#0;
end;

//zmena nastaveni DXC
procedure TfrmOptions.edtDxcChange(Sender: TObject);
begin
  DxcChanged:=True;
end;

//vyber adresare pro zalohy
procedure TfrmOptions.btnBackUpDirClick(Sender: TObject);
var
  Cesta:String;
begin
  Cesta:='';
  if GetFolderDialog(Application.Handle,strOptionsSetBackupDir,Cesta) then
    edtBackUpPath.Text:=Cesta;
end;

//zmena NTP
procedure TfrmOptions.chSyncTimeClick(Sender: TObject);
begin
  cbNTPServer.Enabled:=TCheckBox(Sender).Checked;
end;

//------------------------------------------------------------------------------
//prednastaveni modu
//------------------------------------------------------------------------------

//pridat/vlozit mod
procedure TfrmOptions.btnModeAddClick(Sender: TObject);
var
  AddMode, m: THamMode;
  i: Integer;
begin
  frmComboBox:=TfrmComboBox.Create(nil);
  with frmComboBox do
  try
    SetCbBoxItems(ComboBox, hModeName, 1, High(THamMode));
    if ShowModal(strOptionsAddModeCaption, strMode, csDropDownList) <> mrOk then Exit;
    AddMode:=ComboBox.ItemIndex + 1;
  finally
    Release;
  end;
  //duplikaty
  for i:=0 to ModeList.Count - 1 do
  begin
    ModeList.GetItem(i, m);
    if m = AddMode then
    begin
      dGrdMode.Row:=i + 1;
      Exit;
    end;
  end;
  //pridat
  ModeList.Insert(ModeList.Count, AddMode);
  dGrdMode.RowCount:=ModeList.Count + 1;
  dGrdMode.Row:=ModeList.Count;
  dGrdMode.Refresh;
end;

//smazat mod
procedure TfrmOptions.btnModeDelClick(Sender: TObject);
var
  i:Integer;
begin
  if ModeList.Count=0 then Exit;
  i:=dGrdMode.Row-1;
  ModeList.Delete(i);
  if ModeDefault=i then ModeDefault:=0;
  if ModeDefault>i then Dec(ModeDefault);
  if ModeList.Count=0 then
  begin
    dGrdMode.RowCount:=2;
    ModeDefault:=0;
  end else dGrdMode.RowCount:=ModeList.Count+1;
  dGrdMode.Refresh;
end;

//nastavit vychozi mod
procedure TfrmOptions.btnModeDefClick(Sender: TObject);
begin
  ModeDefault:=dGrdMode.Row-1;
  dGrdMode.Refresh;
end;

//posunout mod nahoru
procedure TfrmOptions.btnModeUpClick(Sender: TObject);
var
  i:Integer;
  m,m1:THamMode;
begin
  i:=dGrdMode.Row-1;
  if (ModeList.Count in [0,1])or(i=0)  then Exit;
  ModeList.Exchange(i,i-1);
  ModeList.GetItem(i,m);
  ModeList.GetItem(i-1,m1);
  ModeList.PutItem(i,m1);
  ModeList.PutItem(i-1,m);
  dGrdMode.Row:=i;
  if ModeDefault=i then Dec(ModeDefault) else
    if ModeDefault=i-1 then Inc(ModeDefault);
  dGrdMode.Refresh;
end;

//posunout mod dolu
procedure TfrmOptions.btnModeDownClick(Sender: TObject);
var
  i:Integer;
  m,m1:THamMode;
begin
  i:=dGrdMode.Row-1;
  if ModeList.Count in [0,i+1] then Exit;
  ModeList.GetItem(i,m);
  ModeList.GetItem(i+1,m1);
  ModeList.PutItem(i,m1);
  ModeList.PutItem(i+1,m);
  dGrdMode.Row:=i+2;
  if ModeDefault=i then Inc(ModeDefault) else
    if ModeDefault=i+1 then Dec(ModeDefault);
  dGrdMode.Refresh;
end;

//vykreslit mrizku modu
procedure TfrmOptions.dGrdModeDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  m:THamMode;
begin
  with TDrawGrid(Sender).Canvas do
  begin
    if (ARow=0)and(ACol=0) then TextRect(Rect,Rect.Left+2,Rect.Top+2,strIndex);
    if (ARow=0)and(ACol=1) then TextRect(Rect,Rect.Left+2,Rect.Top+2,strMode);
    if (ACol=0)and(ARow>0) then
    begin
      TextRect(Rect,Rect.Left+20,Rect.Top+2,IntToStr(ARow));
      if ModeDefault=ARow-1 then
        dmLog.imgList.Draw(TDrawGrid(Sender).Canvas,Rect.Left+2,Rect.Top+2,10,True);
    end;
    if (ACol=1)and(ARow<>0)and(ModeList.Count<>0) then
    begin
      ModeList.GetItem(ARow-1,m);
      TextRect(Rect,Rect.Left+2,Rect.Top+2,hModeName[m]);
    end;
  end;
end;

//------------------------------------------------------------------------------
//prednastaveni frekvenci
//------------------------------------------------------------------------------

//pridat/vlozit frekvenci
procedure TfrmOptions.btnFreqAddClick(Sender: TObject);
var
  AddFreq:String;
  f,g:Double;
  i:Integer;
begin
  //maximalni pocet
  if FreqList.Count=Length(hBandName)-1 then
  begin
    cMessageDlg(Format(strOptionsFreqMaxCount,[Length(hBandName)-1]),
      mtInformation,[mbOk],mrOk,0);
    Exit;
  end;
  frmComboBox:=TfrmComboBox.Create(nil);
  with frmComboBox do
  try
    SetCbBoxItemsF(ComboBox,hBandBegin,Low(hBandBegin),High(hBandBegin)-1);
    if ShowModal(strOptionsAddFreqCaption,strFreq,csDropDown)<>mrOk then Exit;
    AddFreq:=ComboBox.Text;
  finally
    Release;
  end;
  //format
  f:=Round(StrToFloatDef(AddFreq,0)*1000)/1000;
  if f=0 then
  begin
    cMessageDlg(Format(strFreqNotValid,[AddFreq]),mtError,[mbOk],mrOk,0);
    Exit;
  end;
  //duplikaty
  for i:=0 to FreqList.Count-1 do
  begin
    FreqList.GetItem(i,g);
    if f=g then
    begin
      dGrdFreq.Row:=i+1;
      Exit;
    end;
  end;
  //pridat
  FreqList.Insert(FreqList.Count,f);
  dGrdFreq.RowCount:=FreqList.Count+1;
  dGrdFreq.Row:=FreqList.Count;
  dGrdFreq.Refresh;
end;

//smazat frekvenci
procedure TfrmOptions.btnFreqDelClick(Sender: TObject);
var
  i:Integer;
begin
  if FreqList.Count=0 then Exit;
  i:=dGrdFreq.Row-1;
  FreqList.Delete(i);
  if FreqDefault=i then FreqDefault:=0;
  if FreqDefault>i then Dec(FreqDefault);
  if FreqList.Count=0 then
  begin
    dGrdFreq.RowCount:=2;
    FreqDefault:=0;
  end else dGrdFreq.RowCount:=FreqList.Count+1;
  dGrdFreq.Refresh;
end;

//nastavit vychozi frekvenci
procedure TfrmOptions.btnFreqDefClick(Sender: TObject);
begin
  FreqDefault:=dGrdFreq.Row-1;
  dGrdFreq.Refresh;
end;

//posunout frekvenci nahoru
procedure TfrmOptions.btnFreqUpClick(Sender: TObject);
var
  i:Integer;
  f,f1:Double;
begin
  i:=dGrdFreq.Row-1;
  if (FreqList.Count in [0,1])or(i=0)  then Exit;
  FreqList.Exchange(i,i-1);
  FreqList.GetItem(i,f);
  FreqList.GetItem(i-1,f1);
  FreqList.PutItem(i,f1);
  FreqList.PutItem(i-1,f);
  dGrdFreq.Row:=i;
  if FreqDefault=i then Dec(FreqDefault) else
    if FreqDefault=i-1 then Inc(FreqDefault);
  dGrdFreq.Refresh;
end;

//posunout frekvenci dolu
procedure TfrmOptions.btnFreqDownClick(Sender: TObject);
var
  i:Integer;
  f,f1:Double;
begin
  i:=dGrdFreq.Row-1;
  if FreqList.Count in [0,i+1] then Exit;
  FreqList.GetItem(i,f);
  FreqList.GetItem(i+1,f1);
  FreqList.PutItem(i,f1);
  FreqList.PutItem(i+1,f);
  dGrdFreq.Row:=i+2;
  if FreqDefault=i then Inc(FreqDefault) else
    if FreqDefault=i+1 then Dec(FreqDefault);
  dGrdFreq.Refresh;
end;

//vykresleni mrizky frekvenci
procedure TfrmOptions.dGrdFreqDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
var
  f:Double;
begin
  with TDrawGrid(Sender).Canvas do
  begin
    if (ARow=0)and(ACol=0) then TextRect(Rect,Rect.Left+2,Rect.Top+2,strIndex);
    if (ARow=0)and(ACol=1) then TextRect(Rect,Rect.Left+2,Rect.Top+2,strFreq);
    if (ARow=0)and(ACol=2) then TextRect(Rect,Rect.Left+2,Rect.Top+2,strBand);
    if (ACol=0)and(ARow>0) then
    begin
      TextRect(Rect,Rect.Left+20,Rect.Top+2,IntToStr(ARow));
      if FreqDefault=ARow-1 then
        dmLog.imgList.Draw(TDrawGrid(Sender).Canvas,Rect.Left+2,Rect.Top+2,10,True);
    end;
    if (ACol=1)and(ARow<>0)and(FreqList.Count<>0) then
    begin
      FreqList.GetItem(ARow-1,f);
      TextRect(Rect,Rect.Left+2,Rect.Top+2,FloatToStr(f));
    end;
    if (ACol=2)and(ARow<>0)and(FreqList.Count<>0) then
    begin
      FreqList.GetItem(ARow-1,f);
      TextRect(Rect,Rect.Left+2,Rect.Top+2,hBandName[GetHamBand(f)]);
    end;
  end;
end;

//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------

//help
procedure TfrmOptions.actHelpExecute(Sender: TObject);
begin
  Application.HelpJump(Name);
end;

//ulozit
procedure TfrmOptions.actSaveExecute(Sender: TObject);
var
  i:ShortInt;
begin
  //======= kontrola udaju =======
  //Zakladni udaje
  pgConNastav.ActivePageIndex:=0;
  edtCall.Text:=UpperCase(edtCall.Text);
  if not JeZnacka(edtCall.Text,edtCall) then Exit;
  //kontrola uzivatele
  if fOptionsFormStyle=fsNewUser then with dmLog.Options do
    for i:=0 to 9 do
      if User[i]=edtCall.Text then
      begin
        edtCall.SetFocus;
        cMessageDlg(strOptionsUserExists,mtError,[mbOK],mrOk,0);
        Exit;
      end;
  if edtLoc.Text='' then
  begin
    edtLoc.SetFocus;
    cMessageDlg(strNoLoc,mtError,[mbOk],mrOk,0);
    Exit;
  end;
  if not JeLOC(edtLoc.Text,edtLoc) then Exit;
  //Spojeni
  pgConNastav.ActivePageIndex:=1;
  if not JeVykon(cbPWR.Text,cbPWR) then Exit;
  //Mody
  pgConNastav.ActivePageIndex:=2;
  if ModeList.Count=0 then
  begin
    cMessageDlg(strOptionsMinOneMode,mtError,[mbOk],mrOk,0);
    Exit;
  end;
  //Rozsirene
  pgConNastav.ActivePageIndex:=4;
  if (chBackUp.Checked)and(not DirectoryExists(edtBackUpPath.Text)) then
  begin
    if edtBackUpPath.Text=''
      then cMessageDlg(strNoDir,mtError,[mbOk],mrOk,0)
      else cMessageDlg(Format(strDirNotExists,[edtBackUpPath.Text]),mtError,[mbOk],mrOk,0);
    edtBackUpPath.SetFocus;
    Exit;
  end;
  //ulozeni do registru
  if fOptionsFormStyle=fsNewUser then NewUser
                                 else SaveOptions;
  if (DxcChanged)and(fOptionsFormStyle<>fsNewUser) then
    cMessageDlg('Zmìny v nastavení DxClusteru se projeví až po novém spuštìní.',
                mtInformation,[mbOk],mrOk,0);
  Hide;
  ModalResult:=mrOk;
end;

//zrusit
procedure TfrmOptions.actCancelExecute(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

end.
