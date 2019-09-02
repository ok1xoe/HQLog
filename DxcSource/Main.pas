unit Main;

interface

uses
  Windows, Menus, IdBaseComponent, IdComponent, IdTCPConnection, Clipbrd,
  IdTCPClient, IdTelnet, ImgList, Controls, Classes, ActnList, SysUtils,
  XPStyleActnCtrls, ActnMan, SynEdit, StdCtrls, ExtCtrls, ComCtrls, Dialogs,
  ToolWin, ActnCtrls, ActnMenus, Forms, Graphics, Messages, StrUtils,
  cfmDialogs, HQLConsts, HQLMessages, DxcResStrings, DxcConsts,
  SynEditHighlighter, SynHighlighterGeneral, cfmStrUtils;

type
  TDxcFlag = (dxfDisconnect,dxfQuit);
  TDxcFlags = set of TDxcFlag;
  TDxcType = (dxSpider,dxCLX);
  //
  TfrmDxCluster = class(TForm)
    actMainMenuBar: TActionMainMenuBar;
    actManager: TActionManager;
    actExit: TAction;
    actConnect: TAction;
    actDisConnect: TAction;
    tlBar: TToolBar;
    tlBtnCD: TToolButton;
    imgList: TImageList;
    ToolButton1: TToolButton;
    stBar: TStatusBar;
    tlBtnShowDX: TToolButton;
    actShowDx: TAction;
    pnlTx: TPanel;
    cbTerminal: TComboBox;
    actNewSpot: TAction;
    actShowQSL: TAction;
    actShowQRZ: TAction;
    IdTelnet: TIdTelnet;
    seTerminal: TSynEdit;
    pmTerminal: TPopupMenu;
    mitClearTerminal: TMenuItem;
    actClearTerminal: TAction;
    actShowSettings: TAction;
    actSetLoc: TAction;
    actSetName: TAction;
    actSetQTH: TAction;
    actShowWWV: TAction;
    actCopyToLog: TAction;
    actScrollLock: TAction;
    tlBtnScrollLock: TToolButton;
    ToolButton3: TToolButton;
    mitCopyTerminal: TMenuItem;
    N1: TMenuItem;
    actCopy: TAction;
    actPaste: TAction;
    actCut: TAction;
    actSetDxGrid: TAction;
    actSetWWV: TAction;
    actSetWX: TAction;
    actSetWCY: TAction;
    actSetAnnounce: TAction;
    sGeneralSyn: TSynGeneralSyn;
    pmShowDx: TPopupMenu;
    N2: TMenuItem;
    actSearchQRZ: TAction;
    miSearchQRZ: TMenuItem;
    //
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure OnHint(Sender: TObject);
    //
    procedure IdTelnetDataAvailable(Sender: TIdTelnet;
      const Buffer: String);
    procedure IdTelnetStatus(ASender: TObject; const AStatus: TIdStatus;
      const AStatusText: String);
    //
    procedure seTerminalSpecialLineColors(Sender: TObject; Line: Integer;
      var Special: Boolean; var FG, BG: TColor);
    //
    procedure edtTxKeyPress(Sender: TObject; var Key: Char);
    //
    procedure actConnectExecute(Sender: TObject);
    procedure actDisConnectExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    //
    procedure actShowDxExecute(Sender: TObject);
    procedure mnItmShowDxClick(Sender: TObject);
    //
    procedure actNewSpotExecute(Sender: TObject);
    procedure actShowQSLExecute(Sender: TObject);
    procedure actShowQRZExecute(Sender: TObject);
    procedure actClearTerminalExecute(Sender: TObject);
    procedure actShowSettingsExecute(Sender: TObject);
    procedure actSetNameExecute(Sender: TObject);
    procedure actSetQTHExecute(Sender: TObject);
    procedure actSetLocExecute(Sender: TObject);
    procedure actSetAnnounceExecute(Sender: TObject);
    procedure actSetWCYExecute(Sender: TObject);
    procedure actSetWWVExecute(Sender: TObject);
    procedure actSetWXExecute(Sender: TObject);
    procedure actShowWWVExecute(Sender: TObject);
    procedure actCopyToLogExecute(Sender: TObject);
    procedure actScrollLockExecute(Sender: TObject);
    procedure actCopyToLogUpdate(Sender: TObject);
    procedure actCopyExecute(Sender: TObject);
    procedure actCopyUpdate(Sender: TObject);
    procedure actCutExecute(Sender: TObject);
    procedure actCutUpdate(Sender: TObject);
    procedure actPasteExecute(Sender: TObject);
    procedure actPasteUpdate(Sender: TObject);
    procedure actSetDxGridExecute(Sender: TObject);
    procedure actUpdateIfLoggin(Sender: TObject);
    procedure actSearchQRZExecute(Sender: TObject);
    procedure actSearchQRZUpdate(Sender: TObject);
    //
  private
    { Private declarations }
    DxcType: TDxcType;
    Flags: TDxcFlags;
    Login: Boolean;
    fCall, fPassword, RxBuffer: String;
    DxcFormat: TFormatSettings;
    //
    procedure Command(const Cmd:String);
    procedure OutText(const Line:String);
  public
    { Public declarations }
    procedure SetOptions(const Call,Password,Host:String;
      const Port:Integer; const fMaximized:Boolean; const fWidth,fHeight:Integer);
  end;

var
  frmDxCluster: TfrmDxCluster;

implementation

uses NewSpot, SetOnOff;

{$R *.dfm}

//------------------------------------------------------------------------------
//frmDxCluster
//------------------------------------------------------------------------------

//Create
procedure TfrmDxCluster.FormCreate(Sender: TObject);
var
  i:Integer;
  m:TMenuItem;
begin
  Application.OnHint:=OnHint;
  actDisconnect.Enabled:=False;
  Caption:=DxcCaption;
  for i:=Low(DXCBandTab) to High(DXCBandTab) do
  begin
    m:=TMenuItem.Create(pmShowDx);
    m.Caption:=DXCBandTab[i,2];
    m.Tag:=i;
    m.OnClick:=mnItmShowDxClick;
    pmShowDx.Items.Add(m);
  end;
  stBar.Panels.Items[0].Text:=strDisconnected;
  RxBuffer:='';
  Flags:=[];
  Login:=True;
  DxcType:=dxSpider;
  //
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, DxcFormat);
  DxcFormat.DecimalSeparator:='.';
end;

//Destroy
procedure TfrmDxCluster.FormDestroy(Sender: TObject);
begin
//
end;

//CloseQuery
procedure TfrmDxCluster.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose:=True;
  if idTelnet.Connected then
    if not(dxfDisconnect in Flags) then
    begin
      CanClose:=False;
      Flags:=Flags+[dxfDisconnect,dxfQuit];
      idTelnet.WriteLn('b');
      OutText('#'+strDisConnecting);
    end else idTelnet.Disconnect;

end;

//Close
procedure TfrmDxCluster.FormClose(Sender: TObject;
  var Action: TCloseAction);
var
  CopyMsg:TCopyDataStruct;
  Data:TCloseDXCData;
begin
  Data.Width:=Width;
  Data.Height:=Height;
  Data.Maximized:=WindowState=wsMaximized;
  CopyMsg.lpData:=@Data;
  CopyMsg.cbData:=SizeOf(Data);
  CopyMsg.dwData:=dw_CloseDXC;
  SendMessage(FindWindow(LogMainClassName,nil),wm_CopyData,0,Integer(@CopyMsg));
end;

//Resize
procedure TfrmDxCluster.FormResize(Sender: TObject);
begin
  cbTerminal.Width:=seTerminal.Width;
end;

//Hint
procedure TfrmDxCluster.OnHint(Sender: TObject);
begin
  stBar.Panels.Items[1].Text:=' '+Application.Hint;
end;

//------------------------------------------------------------------------------

//odeslat prikaz
procedure TfrmDxCluster.Command(const Cmd:String);
begin
  if not IdTelnet.Connected then Exit;
  idTelnet.WriteLn(Cmd);
  OutText('$'+Cmd);
end;

//vypsat text do terminalu
procedure TfrmDxCluster.OutText(const Line:String);
var
  sStart,sLength,tLine:Integer;
begin
  with seTerminal do
  begin
    sStart:=SelStart;
    sLength:=SelLength;
    tLine:=TopLine;
    Text:=Text+Line+#13#10#13#10;
    if isScrolling then TopLine:=tLine else
    if (sLength=0)and(not actScrollLock.Checked) then TopLine:=Lines.Count-LinesInWindow+2 else
    begin
      SelStart:=sStart;
      SelLength:=sLength;
      TopLine:=tLine;
    end;
  end;
end;

//------------------------------------------------------------------------------

//nastaveni
procedure TfrmDxCluster.SetOptions(const Call,Password,Host:String;
  const Port:Integer; const fMaximized:Boolean; const fWidth,fHeight:Integer);
begin
  Width:=fWidth;
  Height:=fHeight;
  if fMaximized then WindowState:=wsMaximized;
  fCall:=LowerCase(Call);
  fPassword:=Password;
  idTelnet.Host:=Host;
  idTelnet.Port:=Port;
  Caption:=DxcCaption+' - '+Host;
end;

//------------------------------------------------------------------------------
//idTelnet
//------------------------------------------------------------------------------

//OnDataAviable
procedure TfrmDxCluster.IdTelnetDataAvailable(Sender: TIdTelnet;
  const Buffer: String);
var
  i,n,sStart,sLength,tLine:Integer;
  dStart,s,d:PChar;

 //prihlaseni k DxSpider
 procedure DxSpiderLogin(const Buffer: String);
 begin
   if PosEx(#13#10'login: ',Buffer,1)<>0 then idTelnet.WriteLn(fCall) else
   if PosEx(#13#10'Password: ',Buffer,1)<>0 then
   begin
     idTelnet.WriteLn(fPassword);
     Login:=False;
   end;
 end;

begin
  //prihlaseni
  if Login then
  begin
    case DxcType of
      dxSpider: DxSpiderLogin(Buffer);
    end;
  end else
  //data
  begin
    //doplnit prijata data do RxBuffer bez netisknutelnych znaku
    i:=Length(RxBuffer);
    n:=i+Length(Buffer);
    SetLength(RxBuffer,n);
    s:=Pointer(Buffer);
    d:=Pointer(RxBuffer);
    Inc(d,i);
    dStart:=d;
    while s^<>#0 do
    begin
      if not(s^ in [#0..#9,#11,#12,#14..#31]) then
      begin
        d^:=s^;
        Inc(d);
      end else Dec(n);
      Inc(s);
    end;
    SetLength(RxBuffer,n);
    //pridat data do terminaloveho okna
    with seTerminal do
    begin
      sStart:=SelStart;
      sLength:=SelLength;
      tLine:=TopLine;
      //zalomeni posledniho radku se musi zdvojit!!!
      n:=StrLen(dStart);
      if (n>=2)and(dStart[n-2]=#13)and(dStart[n-1]=#10)
        then Text:=Text+dStart+#13#10
        else Text:=Text+dStart;
      //
      if isScrolling then TopLine:=tLine else
      if (sLength=0)and(not actScrollLock.Checked) then TopLine:=Lines.Count-LinesInWindow+2 else
      begin
        SelStart:=sStart;
        SelLength:=sLength;
        TopLine:=tLine;
      end;
    end;
    //zpracovat data radek po radku
    //odmazat buffer
    RxBuffer:='';
  end;
end;

//OnStatus
procedure TfrmDxCluster.IdTelnetStatus(ASender: TObject;
  const AStatus: TIdStatus; const AStatusText: String);
begin
  case AStatus of
    hsConnecting:
    begin
      OutText('');
      OutText('#'+Format(strConnectingTo,[idTelnet.Host,idTelnet.Port]));
      stBar.Panels.Items[0].Text:=strConnecting;
    end;
    hsConnected:
    begin
      OutText('#'+Format(strConnectedTo,[TimeToStr(Time),DateToStr(Date)]));
      tlBtnCD.Action:=actDisConnect;
      stBar.Panels.Items[0].Text:=strConnected;
      actConnect.Enabled:=False;
      actDisconnect.Enabled:=True;
    end;
    hsDisconnected:
    begin
      OutText('#'+Format(strDisConnectedAt,[TimeToStr(Time),DateToStr(Date)]));
      tlBtnCD.Action:=actConnect;
      stBar.Panels.Items[0].Text:=strDisConnected;
      actConnect.Enabled:=True;
      actDisConnect.Enabled:=False;
      Flags:=Flags-[dxfDisconnect];
      Login:=True;
      if dxfQuit in Flags then PostMessage(Handle,wm_close,0,0);
    end;
  end;
end;

//------------------------------------------------------------------------------
//seTerminal
//------------------------------------------------------------------------------

//OnSpecialColors
procedure TfrmDxCluster.seTerminalSpecialLineColors(Sender: TObject;
  Line: Integer; var Special: Boolean; var FG, BG: TColor);
var
  p:PChar;
begin
  Special:=True;
  p:=@TSynEdit(Sender).Lines.Strings[Line-1][1];
  if p=nil then Exit;
  case p^ of
    '$': begin
      FG:=clOfInText;
      BG:=clOfEvenRow;
    end;
    '#': begin
      FG:=clOfInfoText;
      BG:=clCream;
    end;
  else
    if StrLComp(p,'DX de ',6)=0 then FG:=clOfDxText else
    if StrLComp(p,'To ALL de ',10)=0 then FG:=clOfAllText else
    if (StrLen(p)>5)and((StrComp(StrEnd(p)-6,' clx >')=0))or
       (StrLen(p)>12)and((StrComp(StrEnd(p)-11,' dxspider >')=0)) then BG:=clOfEvenRow else
      Special:=False;
  end;
end;

//------------------------------------------------------------------------------
//cbTerminal
//------------------------------------------------------------------------------

procedure TfrmDxCluster.edtTxKeyPress(Sender: TObject; var Key: Char);
begin
  if (Key<>#13)or(not idTelnet.Connected) then Exit;
  Key:=#0;
  //odeslat prikaz
  if cbTerminal.Text<>'' then
  begin
    Command(cbTerminal.Text);
    cbTerminal.Items.Insert(0,cbTerminal.Text);
    if cbTerminal.Items.Count>TxHistory then cbTerminal.Items.Delete(TxHistory);
    cbTerminal.Text:='';
  end;
end;

//------------------------------------------------------------------------------
//soubor
//------------------------------------------------------------------------------

procedure TfrmDxCluster.actConnectExecute(Sender: TObject);
begin
  try
    idTelnet.Connect();
  except
    cMessageDlg(strConnectErr,mtError,[mbOk],mrOk,0);
  end;
end;

procedure TfrmDxCluster.actDisConnectExecute(Sender: TObject);
begin
  if dxfDisconnect in Flags then IdTelnet.Disconnect else
  begin
    Flags:=Flags+[dxfDisconnect];
    idTelnet.WriteLn('b');
    OutText('#'+strDisConnecting);
  end;
end;

procedure TfrmDxCluster.actExitExecute(Sender: TObject);
begin
  Close;
end;

//------------------------------------------------------------------------------
//Pøíkaz
//------------------------------------------------------------------------------

//zobrazit DXy
procedure TfrmDxCluster.actShowDxExecute(Sender: TObject);
begin
  Command('Show/DX');
end;

//ShowDx/xxx
procedure TfrmDxCluster.mnItmShowDxClick(Sender: TObject);
begin
  case DxcType of
    dxSpider: Command('Show/DX on '+DXCBandTab[TMenuItem(Sender).Tag,0]);
    dxCLX: Command('Show/DX '+DXCBandTab[TMenuItem(Sender).Tag,1]);
  end;
end;

//hledat QSL
procedure TfrmDxCluster.actShowQSLExecute(Sender: TObject);
var
  str:String;
begin
  str:=LowerCase(InputBox(strQSLInfo,strCall,''));
  if str<>'' then Command('Show/QSL '+str);
end;

//hledat pomoci QRZ
procedure TfrmDxCluster.actShowQRZExecute(Sender: TObject);
var
  str:String;
begin
  str:=LowerCase(InputBox(strQRZInfo,strCall,''));
  if str<>'' then Command('Show/QRZ '+str);
end;

//
procedure TfrmDxCluster.actShowWWVExecute(Sender: TObject);
begin
  Command('Show/WWV');
end;

//novy spot
procedure TfrmDxCluster.actNewSpotExecute(Sender: TObject);
begin
  frmDxcNewSpot:=TfrmDxcNewSpot.Create(nil);
  with frmDxcNewSpot do
  try
    if ShowModal = mrOk then
      Command('DX ' +
              edtCall.Text + ' ' +
              FloatToStr(StrToFloat(cbBoxFreq.Text) * 1000, DxcFormat) + ' ' +
              edtNote.Text);
  finally
    frmDxcNewSpot.Release;
  end;
end;

//------------------------------------------------------------------------------
//Osobni nastaveni
//------------------------------------------------------------------------------

//zobrazit
procedure TfrmDxCluster.actShowSettingsExecute(Sender: TObject);
begin
  Command('Show/station ' + fCall);
end;

//jmeno
procedure TfrmDxCluster.actSetNameExecute(Sender: TObject);
var
  Text:String;
begin
  if InputQuery(strSetName,strName,Text) then Command('Set/Name ' + Text);
end;

//QTH
procedure TfrmDxCluster.actSetQTHExecute(Sender: TObject);
var
  Text:String;
begin
  if InputQuery(strSetQTH,strQTH,Text) then Command('Set/QTH ' + Text);
end;

//Locator
procedure TfrmDxCluster.actSetLocExecute(Sender: TObject);
var
  Text:String;
begin
  if InputQuery(strSetLoc,strLoc,Text) then
    case DxcType of
      dxSpider: Command('Set/QRA ' + Text);
      dxCLX: Command('Set/Loc ' + Text);
    end;
end;

//Set/DxGrid
procedure TfrmDxCluster.actSetDxGridExecute(Sender: TObject);
begin
  frmOnOff:=TfrmOnOff.Create(nil);
  try
    frmOnOff.lblText.Caption:=strSetDxGrid;
    if frmOnOff.ShowModal = mrOk then
      if frmOnOff.rbOn.Checked then
        Command('Set/DxGrid')
      else
        Command('UnSet/DxGrid');
  finally
    frmOnOff.Release;
  end;
end;

//Set/Announce
procedure TfrmDxCluster.actSetAnnounceExecute(Sender: TObject);
begin
  frmOnOff:=TfrmOnOff.Create(nil);
  try
    frmOnOff.lblText.Caption:=strSetAnnounce;
    if frmOnOff.ShowModal = mrOk then
      if frmOnOff.rbOn.Checked then
        Command('Set/Announce')
      else
        Command('UnSet/Announce');
  finally
    frmOnOff.Release;
  end;
end;

//Set/WCY
procedure TfrmDxCluster.actSetWCYExecute(Sender: TObject);
begin
  frmOnOff:=TfrmOnOff.Create(nil);
  try
    frmOnOff.lblText.Caption:=strSetWCY;
    if frmOnOff.ShowModal = mrOk then
      if frmOnOff.rbOn.Checked then
        Command('Set/WCY')
      else
        Command('UnSet/WCY');
  finally
    frmOnOff.Release;
  end;
end;

//Set/WWV
procedure TfrmDxCluster.actSetWWVExecute(Sender: TObject);
begin
  frmOnOff:=TfrmOnOff.Create(nil);
  try
    frmOnOff.lblText.Caption:=strSetWWV;
    if frmOnOff.ShowModal = mrOk then
      if frmOnOff.rbOn.Checked then
        Command('Set/WWV')
      else
        Command('UnSet/WWV');
  finally
    frmOnOff.Release;
  end;
end;

//Set/WX
procedure TfrmDxCluster.actSetWXExecute(Sender: TObject);
begin
  frmOnOff:=TfrmOnOff.Create(nil);
  try
    frmOnOff.lblText.Caption:=strSetWX;
    if frmOnOff.ShowModal = mrOk then
      if frmOnOff.rbOn.Checked then
        Command('Set/WX')
      else
        Command('UnSet/WX');
  finally
    frmOnOff.Release;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmDxCluster.actUpdateIfLoggin(Sender: TObject);
begin
  TAction(Sender).Enabled:=not Login;
end;

//------------------------------------------------------------------------------
//Ruzne
//------------------------------------------------------------------------------

//hledat vybranou znacku pres www.qrz.com
procedure TfrmDxCluster.actSearchQRZExecute(Sender: TObject);
begin
  Command('Show/QRZ ' + UpperCase(seTerminal.SelText));
end;
procedure TfrmDxCluster.actSearchQRZUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled:=
    (not Login)and(seTerminal.SelLength in [3..15])and
    (CheckString(seTerminal.SelText, ['0'..'9', '/', 'A'..'Z', 'a'..'z']));
end;

//------------------------------------------------------------------------------
//Editace
//------------------------------------------------------------------------------

//kopirovat
procedure TfrmDxCluster.actCopyExecute(Sender: TObject);
begin
  PostMessage(ActiveControl.Handle, wm_copy, 0, 0);
end;
procedure TfrmDxCluster.actCopyUpdate(Sender: TObject);
begin
  if ActiveControl is TComboBox then
    TAction(Sender).Enabled:=TComboBox(ActiveControl).SelLength <> 0
  else if ActiveControl is TSynEdit then
    TAction(Sender).Enabled:=TSynEdit(ActiveControl).SelLength <> 0
  else
    TAction(Sender).Enabled:=False;
end;

//vlozit
procedure TfrmDxCluster.actPasteExecute(Sender: TObject);
begin
  if ActiveControl is TComboBox then PostMessage(ActiveControl.Handle,wm_paste,0,0);
end;
procedure TfrmDxCluster.actPasteUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled:=(Clipboard.HasFormat(CF_TEXT))and(ActiveControl is TComboBox);
end;

//vyjmout
procedure TfrmDxCluster.actCutExecute(Sender: TObject);
begin
  if ActiveControl is TComboBox then PostMessage(ActiveControl.Handle,wm_cut,0,0);
end;
procedure TfrmDxCluster.actCutUpdate(Sender: TObject);
begin
  if ActiveControl is TComboBox then TAction(Sender).Enabled:=TComboBox(ActiveControl).SelLength<>0 else
    TAction(Sender).Enabled:=False;
end;

//vymazat
procedure TfrmDxCluster.actClearTerminalExecute(Sender: TObject);
begin
  seTerminal.ClearAll;
end;

procedure TfrmDxCluster.actCopyToLogExecute(Sender: TObject);
{var
  CopyMsg:TCopyDataStruct;
  Data:TSetQSOData;
  h:THandle;}
begin
{  if SpotList.Count=0 then Exit;
  h:=FindWindow(LogQSOClassName,nil);
  if h<>0 then
  begin
    Data.Call:=SpotList.GetStation(dgSpot.Row);
    Data.Freq:=SpotList.GetFreq(dgSpot.Row);
    CopyMsg.lpData:=@Data;
    CopyMsg.cbData:=SizeOf(Data);
    CopyMsg.dwData:=dw_CloseDXC;
    SendMessage(h,wm_CopyData,0,Integer(@CopyMsg));
  end else cMessageDlg(strQSOFormNoFound,mtError,[mbOk],mrOk,0);}
end;

procedure TfrmDxCluster.actCopyToLogUpdate(Sender: TObject);
begin
//  TAction(Sender).Enabled:=(SpotList.Count<>0)and(FindWindow(LogQSOClassName,nil)<>0);
end;

procedure TfrmDxCluster.actScrollLockExecute(Sender: TObject);
begin
  //
end;

end.
