{$include global.inc}
unit DBList;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DB, DBTables, Grids, DBGrids, ComCtrls, ImgList, ToolWin, Menus,
  ActnList, XPStyleActnCtrls, ActnMan, HQLResStrings, CfmDbGrid,
  StdCtrls, HQLConsts, Find, ActnPopupCtrl;

type
  //
  TListMode=(lmDXCC,lmIOTA);
  //
  TfrmList = class(TForm)
    qList: TQuery;
    dsList: TDataSource;
    //
    actManager: TActionManager;
    actFind: TAction;
    actFirs: TAction;
    actLast: TAction;
    actClose: TAction;
    actSort: TAction;
    dbgList: TCfmDBGrid;
    ToolBar: TToolBar;
    tlBtnFind: TToolButton;
    tlBtnSort: TToolButton;
    tlBtnSep1: TToolButton;
    tlBtnFirst: TToolButton;
    tlBtnLast: TToolButton;
    tlBtnSep2: TToolButton;
    tlBtnClose: TToolButton;
    actHelp: TAction;
    pmSort: TPopupActionBarEx;
    //
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormResize(Sender: TObject);
    //
    procedure dbgListTitleClick(Column: TColumn);
    procedure mnItmTriditClick(Sender: TObject);
    //
    procedure actHelpExecute(Sender: TObject);
    procedure actSortExecute(Sender: TObject);
    procedure actFindExecute(Sender: TObject);
    procedure actFirsExecute(Sender: TObject);
    procedure actLastExecute(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure actFirsUpdate(Sender: TObject);
    procedure actLastUpdate(Sender: TObject);
  private
    { Private declarations }
    frmFind:TfrmFind;
    fListMode:TListMode;
    Data:String;
    //
    procedure OnSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;
    //
    procedure NactiData(const Tridit:String);
  public
    { Public declarations }
    procedure InitList(const ListMode:TListMode);
  end;

var
  frmList: TfrmList;

implementation

uses Main, HQLdMod, HQLDatabase;

{$R *.dfm}

//------------------------------------------------------------------------------
//frmList
//------------------------------------------------------------------------------

//pri vytvoreni formulare
procedure TfrmList.FormCreate(Sender: TObject);
begin
  qList.DatabaseName:=dmLog.RootDir;
  fListMode:=lmDXCC;
end;

//pri odstraneni formulare
procedure TfrmList.FormDestroy(Sender: TObject);
begin
  case fListMode of
    lmDxcc: begin
      dmLog.User.LiDxcc_Maximized:=WindowState=wsMaximized;
      if WindowState=wsNormal then
      begin
        dmLog.User.LiDxcc_Width:=Width;
        dmLog.User.LiDxcc_Height:=Height;
      end;
    end;
    lmIOTA: begin
      dmLog.User.LiIOTA_Maximized:=WindowState=wsMaximized;
      if WindowState=wsNormal then
      begin
        dmLog.User.LiIOTA_Width:=Width;
        dmLog.User.LiIOTA_Height:=Height;
      end;
    end;
  end;
end;

//zmena velikosti
procedure TfrmList.FormResize(Sender: TObject);
var
  i,w:Integer;
begin
  with dbgList,Columns do
  begin
    w:=0;
    for i:=0 to Count-2 do w:=w+Items[i].Width;
    Items[Count-1].Width:=ClientWidth-w-22;
  end;
end;

procedure TfrmList.OnSysCommand(var Msg: TWMSysCommand);
begin
  if Msg.CmdType=SC_MINIMIZE then ShowWindow(Application.Handle,SW_SHOWMINNOACTIVE)
                             else inherited;
end;

//------------------------------------------------------------------------------

procedure TfrmList.InitList(const ListMode:TListMode);

 procedure SetDbGrid(fColumns:TDbGridColumns; Captions,Names:Array of String; Widths:Array of Integer);
 var
   i:Integer;
 begin
   fColumns.Clear;
   for i:=0 to High(Captions) do with fColumns.Add do
   begin
     Width:=Widths[i];
     FieldName:=Names[i];
     Title.Caption:=Captions[i];
   end;
 end;

 procedure SetSortMenuItems(fItems:TMenuItem; Captions,Names:Array of String);
 var
   i:Integer;
   Item:TMenuItem;
 begin
   fItems.Clear;
   for i:=0 to High(Captions) do with Item do
   begin
     Item:=TMenuItem.Create(nil);
     Caption:=Captions[i];
     Hint:=Names[i];
     GroupIndex:=11;
     RadioItem:=True;
     OnClick:=mnItmTriditClick;
     fItems.Add(Item);
   end;
 end;

begin
  fListMode:=ListMode;
  case ListMode of
    lmDXCC: begin
      Width:=dmLog.User.LiDxcc_Width;
      Height:=dmLog.User.LiDxcc_Height;
      if dmLog.User.LiDxcc_Maximized then WindowState:=wsMaximized;
      //
      frmFind:=TfrmFind.Create(Self);
      frmFind.InitDialog(qList,dbgList,
        [dfiD_Prefix,dfiD_Name,dfiD_Dxcc],
        [ftCall,ftText,ftCall],
        [dfD_Caption[dfiD_Prefix],dfD_Caption[dfiD_Name],dfD_Caption[dfiD_Dxcc]]);
      Data:='dxcc.db';
      Caption:=strDxccList;
      SetDbGrid(dbgList.Columns,dfD_Caption,dfD_Name,dfD_Width);
      SetSortMenuItems(pmSort.Items, dfD_Caption, dfD_Name);
      NactiData(dfnD_Name);
    end;
    lmIOTA: begin
      Width:=dmLog.User.LiIOTA_Width;
      Height:=dmLog.User.LiIOTA_Height;
      if dmLog.User.LiIOTA_Maximized then WindowState:=wsMaximized;
      //
      frmFind:=TfrmFind.Create(Self);
      frmFind.InitDialog(qList,dbgList,
        [dfiI_IOTA,dfiI_Name,dfiI_Prefix],
        [ftIOTA,ftText,ftCall],
        [dfI_Caption[dfiI_IOTA],dfI_Caption[dfiI_Name],dfI_Caption[dfiI_Prefix]]);
      Data:='iota.db';
      Caption:=strIOTAList;
      SetDbGrid(dbgList.Columns,dfI_Caption,dfI_Name,dfI_Width);
      SetSortMenuItems(pmSort.Items, dfI_Caption, dfI_Name);
      NactiData(dfnI_IOTA);
    end;
  end;
end;

//otevreni databaze
procedure TfrmList.NactiData(const Tridit:String);
var
  i:Integer;
begin
  //zahlavni
  for i:=0 to dbgList.Columns.Count-1 do
    if dbgList.Columns[i].FieldName=Tridit then
    begin
      dbgList.Columns[i].Title.Color:=clOfactTitle;
      pmSort.Items.Items[i].Checked:=true;
    end;
  with qList do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM "'+Data+'" ORDER BY '+Tridit);
    Open;
  end;
end;

//------------------------------------------------------------------------------
//dbgList
//------------------------------------------------------------------------------

//tridit zahlavni
procedure TfrmList.dbgListTitleClick(Column: TColumn);
var
  i:Integer;
  ActKey:String;
begin
  //netridit 2x
  if Column.Title.Color=clOfactTitle then Exit;
  //zahlavni
  for i:=0 to dbgList.Columns.Count-1 do
    dbgList.Columns[i].Title.Color:=clBtnFace;
  Column.Title.Color:=clOfactTitle;
  //menu
  for i:=0 to pmSort.Items.Count-1 do
    if pmSort.Items.Items[i].Hint=Column.FieldName then
      pmSort.Items.Items[i].Checked:=true;
  //tridit
  with qList do
  begin
    ActKey:=Fields.Fields[0].AsString;
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM "'+Data+'" ORDER BY '+Column.FieldName);
    Open;
    Locate(Fields.Fields[0].FieldName,ActKey,[]);
  end;
end;

//tridit menu
procedure TfrmList.mnItmTriditClick(Sender: TObject);
var
  i:Integer;
  ActKey:String;
  Tridit:String;
begin
  Tridit:=TmenuItem(Sender).Hint;
  //menu
  TMenuItem(Sender).Checked:=True;
  //netridit 2x
  if not qList.Active then Exit;
  //zahlavi
  for i:=0 to dbgList.Columns.Count-1 do with dbgList.Columns[i] do
  begin
    if (FieldName=Tridit)and(Title.Color=clOfactTitle) then Exit;
    if FieldName=Tridit then Title.Color:=clOfactTitle
                        else Title.Color:=clBtnFace;
  end;
  //tridit
  with qList do
  begin
    ActKey:=Fields.Fields[0].AsString;
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM "'+Data+'" ORDER BY '+Tridit);
    Open;
    Locate(Fields.Fields[0].FieldName,ActKey,[]);
  end;
end;

//------------------------------------------------------------------------------

//help
procedure TfrmList.actHelpExecute(Sender: TObject);
begin
  Application.HelpJump(Name);
end;

//najit
procedure TfrmList.actFindExecute(Sender: TObject);
begin
  if Assigned(frmFind) then frmFind.Show;
end;

//
procedure TfrmList.actFirsExecute(Sender: TObject);
begin
  qList.First;
end;

procedure TfrmList.actFirsUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled:=(qList.RecordCount<>0)and(qList.RecNo<>1);
end;

//
procedure TfrmList.actLastExecute(Sender: TObject);
begin
  qList.Last;
end;

procedure TfrmList.actLastUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled:=(qList.RecordCount<>0)and(qList.RecNo<>qList.RecordCount);
end;

//tridit
procedure TfrmList.actSortExecute(Sender: TObject);
begin
  tlBtnSort.CheckMenuDropdown;
end;

//zavrit
procedure TfrmList.actCloseExecute(Sender: TObject);
begin
  ModalResult:=mrOk;
end;


end.

