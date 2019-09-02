{$include global.inc}
unit Profile;

interface

uses
  Windows, Forms, Menus, Classes, ActnList, XPStyleActnCtrls, ActnMan,
  Controls, ComCtrls, StdCtrls, Dialogs, SysUtils,
  HQLConsts, cfmDialogs, HQLResStrings, Messages, ActnPopupCtrl;

type
  TfrmProfile = class(TForm)
    btnSelect: TButton;
    btnDelete: TButton;
    btnNew: TButton;
    btnCancel: TButton;
    actManager: TActionManager;
    actSelect: TAction;
    actNew: TAction;
    actDelete: TAction;
    actClose: TAction;
    lViewUser: TListView;
    actExit: TAction;
    actHelp: TAction;
    pmProfile: TPopupActionBarEx;
    miSelect: TMenuItem;
    miNew: TMenuItem;
    N2: TMenuItem;
    miDelete: TMenuItem;
    //
    procedure FormCreate(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    //
    procedure actHelpExecute(Sender: TObject);
    procedure actSelectExecute(Sender: TObject);
    procedure actNewExecute(Sender: TObject);
    procedure actDeleteExecute(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure actUserDepUpdate(Sender: TObject);
  private
    { Private declarations }
    procedure OnSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;
    procedure GetUserList;
  public
    { Public declarations }
  end;

var
  frmProfile: TfrmProfile;

implementation

uses Main, HQLdMod, Options;
{$R *.dfm}

//------------------------------------------------------------------------------
//frmProfile
//------------------------------------------------------------------------------

//start
procedure TfrmProfile.FormCreate(Sender: TObject);
begin
  GetUserList;
end;

//je mozno zavrit?
procedure TfrmProfile.FormCloseQuery(Sender: TObject;
  var CanClose: Boolean);
begin
  CanClose:=True;
  if (btnCancel.Action=actExit)and(ModalResult<>mrOk) then
    if cMessageDlg(strExitQ, mtConfirmation, [mbYes, mbNo], mrYes, 0)=mrNo then
      CanClose:=False;
end;

procedure TfrmProfile.OnSysCommand(var Msg: TWMSysCommand);
begin
  if Msg.CmdType=SC_MINIMIZE then ShowWindow(Application.Handle,SW_SHOWMINNOACTIVE)
                             else inherited;
end;

//------------------------------------------------------------------------------

//nacist seznam uzivatelu
procedure TfrmProfile.GetUserList;
var
  i:Integer;
  ListItem:TListItem;
  UserName:String;
begin
  // nacteni uzivatelu do ListBoxu
  lViewUser.Items.Clear;
  for i:=0 to 9 do
  begin
    UserName:=dmLog.Options.User[i];
    if UserName<>'' then
    begin
      ListItem:=lViewUser.Items.Add;
      Listitem.Caption:=UserName;
      if UserName=dmLog.User.Call then ListItem.ImageIndex:=10
                                  else ListItem.ImageIndex:=-1;
    end;
  end;
  if dmLog.User.Call<>''
    then lViewUser.FindCaption(0, dmLog.User.Call, False, True, False).Selected:=True
    else if lViewUser.Items.Count<>0 then lViewUser.ItemIndex:=0;
end;

//------------------------------------------------------------------------------

//help
procedure TfrmProfile.actHelpExecute(Sender: TObject);
begin
  Application.HelpJump(Name);
end;

//vybrat uzivatele
procedure TfrmProfile.actSelectExecute(Sender: TObject);
begin
  if lViewUser.Selected=nil then Exit;
  //je to ten stejny?
  if dmLog.User.Call<>lViewUser.Selected.Caption then
  begin
    frmHQLog.CloseLog;
    frmHQLog.OpenLog(lViewUser.Selected.Caption);
  end;
  ModalResult:=mrOk;
end;

//novy uzivatel
procedure TfrmProfile.actNewExecute(Sender: TObject);
begin
  if lViewUser.Items.Count<=9 then
  begin
    frmOptions:=TfrmOptions.Create(nil, fsNewUser);
    try
      frmOptions.ShowModal;
    finally
      frmOptions.Release;
      GetUserList;
    end;
  end else cMessageDlg(strUsersLimit, mtInformation, [mbOK], mrOk, 0);
end;

//smazat uzivatele
procedure TfrmProfile.actDeleteExecute(Sender: TObject);
var
  Call:String;
  i:Integer;
begin
  Call:=lViewUser.Selected.Caption;
  if Call='' then Exit;
  if cMessageDlg(Format(strDeleteUserQ, [Call]),
                 mtConfirmation, [mbYes, mbNo], mrNo, 0)=mrNo then Exit;
  if cMessageDlg(strDeleteUserQ2,
                 mtWarning, [mbYes, mbNo], mrNo, 0)=mrNo then Exit;
  //smazat aktualniho uzivatele?
  if Call=dmLog.User.Call then
  begin
    frmHQLog.CloseLog;
    btnCancel.Action:=actExit;
  end;
  DeleteFile(dmLog.DataDir+Call+dFileExt); //databaze
  DeleteFile(dmLog.DataDir+Call+iFileExt); //index
  DeleteFile(dmLog.DataDir+Call+uFileExt); //nastaveni
  for i:=0 to 9 do
    if dmLog.Options.User[i]=Call then dmLog.Options.User[i]:='';
  try
    dmLog.Options.UpdateFile;
  except
  end;
  GetUserList;
end;

//zpet/zavrit
procedure TfrmProfile.actCloseExecute(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

//
procedure TfrmProfile.actUserDepUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled:=lViewUser.Selected<>nil;
end;

end.
