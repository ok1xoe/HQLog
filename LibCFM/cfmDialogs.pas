unit cfmDialogs;

interface
uses Classes, Consts, Forms, Dialogs, StdCtrls, Windows, ShlObj, SysUtils, ActiveX;

resourcestring
  SMsgDlgCZWarning = 'Upozornìní';
  SMsgDlgCZError = 'Chyba';
  SMsgDlgCZInformation = 'Informace';
  SMsgDlgCZConfirm = 'Potvrzení';
  SMsgDlgCZYes = '&Ano';
  SMsgDlgCZNo = '&Ne';
  SMsgDlgCZOK = '&OK';
  SMsgDlgCZCancel = 'S&torno';
  SMsgDlgCZHelp = 'Nápovìda';
  SMsgDlgCZHelpNone = 'Nápovìda není dostupná';
  SMsgDlgCZHelpHelp = 'Nápovìda';
  SMsgDlgCZAbort = '&Pøerušit';
  SMsgDlgCZRetry = 'Opakovat';
  SMsgDlgCZIgnore = '&Ignorovat';
  SMsgDlgCZAll = '&Vše';
  SMsgDlgCZNoToAll = 'N&e všem';
  SMsgDlgCZYesToAll = 'Ano vše&m';

const
  MsgDlgCaptions: Array[TMsgDlgType] of Pointer = (
    @SMsgDlgCZWarning, @SMsgDlgCZError, @SMsgDlgCZInformation, @SMsgDlgCZConfirm, nil
  );

  MsgDlgButtonCaptions: Array[TMsgDlgBtn] of Pointer = (
    @SMsgDlgCZYes, @SMsgDlgCZNo, @SMsgDlgCZOK, @SMsgDlgCZCancel,@SMsgDlgCZAbort, @SMsgDlgCZRetry,
    @SMsgDlgCZIgnore, @SMsgDlgCZAll, @SMsgDlgCZNoToAll, @SMsgDlgCZYesToAll, @SMsgDlgCZHelp
  );

function cMessageDlg(const Msg: String; dlgType: TMsgDlgType; Buttons: TMsgDlgButtons;
  DefButton: Integer; HelpCtx: LongInt): Integer; 
function SelectDirectory(const Text: String; var Directory: String): Boolean;

implementation

function cMessageDlg(const Msg: String; dlgType: TMsgDlgType; Buttons:TMsgDlgButtons;
                     DefButton:Integer; HelpCtx:LongInt):Integer;
var
  i: Integer;
  Btn: TButton;
begin
  with CreateMessageDialog(Msg, DlgType, Buttons) do
  try
    ParentWindow:=GetActiveWindow;
    HelpContext:=HelpCtx;
    for i:=0 to ComponentCount-1 do
      if Components[i] is TButton then
      begin
        Btn:=TButton(Components[i]);
        if Btn.ModalResult=DefButton then ActiveControl:=Btn;
      end;
    Result:=ShowModal;
  finally
    Free;
  end;
end;

function SelectDirCB(Wnd: HWND; uMsg: UINT; lParam, lpData: LPARAM): Integer stdcall;
begin
  if (uMsg = BFFM_INITIALIZED)and(lpData <> 0) then
    SendMessage(Wnd, BFFM_SETSELECTION, Integer(True), lpdata);
  Result:=0;
end;

//vyber adresare
function SelectDirectory(const Text: String; var Directory: String): Boolean;
var
  BrowseInfo: TBrowseInfo;
  PIDL: PItemIDList;
  DisplayName: Array[0..MAX_PATH] of Char;
begin
  if not DirectoryExists(Directory) then
    Directory := '';
  FillChar(BrowseInfo, SizeOf(BrowseInfo), #0);
  BrowseInfo.hwndOwner:=GetActiveWindow;
  BrowseInfo.pszDisplayName:=@DisplayName[0];
  BrowseInfo.lpszTitle:=PChar(Text);
  BrowseInfo.ulFlags:=BIF_RETURNONLYFSDIRS or BIF_EDITBOX or $40;
  if Directory <> '' then
  begin
    BrowseInfo.lpfn:=SelectDirCB;
    BrowseInfo.lParam:=Integer(PChar(Directory));
  end;
  CoInitialize(nil);
  PIDL:=SHBrowseForFolder(BrowseInfo);
  if (Assigned(PIDL))and(SHGetPathFromIDList(PIDL, DisplayName)) then
  begin
    Directory:=DisplayName;
    Result:=True;
  end else
    Result:=False;
end;

procedure ChangeCaptions(List: PPointerList; Last: Pointer);
var
  i, Max: Integer;
  IsFind: Boolean;
begin
  Max:=(Integer(Last) - Integer(List)) div SizeOf(Pointer);
  IsFind:=False;
  for i:=0 to Max - 2 do
    if (List[i] = @SMsgDlgWarning)and(List[i + 2] = @SMsgDlgInformation) then
    begin
      IsFind:=True;
      Break;
    end;
  if IsFind then Move(MsgDlgCaptions, List[i], SizeOf(MsgDlgCaptions));
  IsFind:=False;
  for i:=i to Max-2 do
    if (List[i] = @SMsgDlgYes) and (List[i + 2] = @SMsgDlgOK) then
    begin
      IsFind:=True;
      Break;
    end;
  if IsFind then Move(MsgDlgButtonCaptions, List[i], SizeOf(MsgDlgButtonCaptions));
end;

initialization
  ChangeCaptions(@DebugHook, @Application);
end.
