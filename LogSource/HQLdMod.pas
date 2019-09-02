{$include global.inc}
unit HQLdMod;

interface

uses
  Windows, SysUtils, Classes, ImgList, Controls, Dialogs, DB, DBTables, StrUtils,
  HQLConsts, HQLDatabase, ActnMan, ActnColorMaps, OptionsIO, AppEvnts, Forms,
  Messages, cfmFileUtils, HQLMessages, ExtCtrls, DateUtils, cfmDialogs, HQLResStrings;

type
  TdmLog = class(TDataModule)
    imgList: TImageList;
    dlgSave: TSaveDialog;
    dlgOpen: TOpenDialog;
    dbLog: TDatabase;
    clMap: TXPColorMap;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    fRootDir,fTempDir,fDataDir:String;
    fOptions:TLogOptions;
    fUser:TUserOptions;
  public
    { Public declarations }
    //DxCluster
    procedure OpenDXC;
    procedure CloseDXC;
    //cesty
    property RootDir:String read fRootDir;
    property TempDir:String read fTempDir;
    property DataDir:String read fDataDir;
    //nastaveni
    property Options:TLogOptions read fOptions;
    property User:TUserOptions read fUser;
  end;

var
  dmLog: TdmLog;

implementation

uses QSOForm;

{$R *.dfm}

//------------------------------------------------------------------------------

procedure TdmLog.DataModuleCreate(Sender: TObject);
begin
  //cesty
  fRootDir:=ExtractFilePath(ParamStr(0));
  fDataDir:=fRootDir+Data_Dir;
  fTempDir:=GetEnvironmentVariable('TEMP')+'\';
  CreateDir(fTempDir+Temp_Dir);
  if DirectoryExists(fTempDir+Temp_Dir) then fTempDir:=fTempDir+Temp_Dir;
  //objekty
  fOptions:=TLogOptions.Create;
  try
    fOptions.LoadFromFile(fRootDir+Options_File);
  except
  end;
  fUser:=TUserOptions.Create;
  //databaze
  Session.PrivateDir:=fTempDir;
  dbLog.Params.Add('PATH='+fDataDir);
  dbLog.DatabaseName:=BDEAlias;
  dbLog.Open;
{  Screen.Cursors[crHand]:=LoadCursor(,'cHand');
  Screen.Cursors[crHandDrag]:=LoadCursor(,'cHandDrag');}
end;

procedure TdmLog.DataModuleDestroy(Sender: TObject);
begin
  //objekty
  fOptions.Free;
  fUser.Free;
  //databaze
  dbLog.Close;
  //vymazani docasnych souboru
  if fTempDir=GetEnvironmentVariable('TEMP')+'\'+Temp_Dir then
  begin
    DeleteFiles(fTempDir,'_*.db');
    DeleteFiles(fTempDir,'_*.px');
    RemoveDir(fTempDir);
  end;
end;

//------------------------------------------------------------------------------

//DxCluster
procedure TdmLog.OpenDXC;
var
  hWnd:THandle;
begin
  if User.DXC_Host='' then
  begin
    cMessageDlg(strNoDXChost,mtError,[mbOk],mrOk,0);
    Exit;
  end;
  if User.DXC_Password='' then
  begin
    cMessageDlg(strNoDXCpass,mtError,[mbOk],mrOk,0);
    Exit;
  end;
  hWnd:=FindWindow(DxcMainClassName,nil);
  with User do
    if hWnd=0 then WinExec(PChar(
      '"'+RootDir+DxCluster_App+'" '+Call+' '+
      DXC_Password+' '+DXC_Host+' '+IntToStr(DXC_Port)+' '+
      BoolToStr(DXC_Maximized)+' '+IntToStr(DXC_Width)+' '+IntToStr(DXC_Height)),
      SW_SHOW);
end;

procedure TdmLog.CloseDXC;
var
  hWnd:THandle;
begin
  hWnd:=FindWindow(DxcMainClassName,nil);
  if hWnd<>0 then PostMessage(hWnd,WM_QUIT,0,0);
end;

end.
