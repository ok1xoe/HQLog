{$include global.inc}
unit CallBook;

interface

uses
  Windows, Menus, Dialogs, DBTables, Classes, ActnList, XPStyleActnCtrls,
  ActnMan, DB, Controls, ComCtrls, ToolWin, Grids, DBGrids, Forms, SysUtils,
  HamLogFP, Graphics, HQLResStrings, cfmDialogs, CfmDbGrid, HQLConsts,
  Find, Messages;

type
  TfrmCallBook = class(TForm)
    qCall: TQuery;
    dsCall: TDataSource;
    actManager: TActionManager;
    actNacistCSV: TAction;
    ToolBar: TToolBar;
    tlBtnHledat: TToolButton;
    ToolButton3: TToolButton;
    tlBtnPrvni: TToolButton;
    tlBtnPosledni: TToolButton;
    ToolButton4: TToolButton;
    tlBtnZavrit: TToolButton;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    actHledat: TAction;
    actPrvni: TAction;
    actPosledni: TAction;
    tlBtnTridit: TToolButton;
    poMnTridit: TPopupMenu;
    mnItmTZnacka: TMenuItem;
    mnItmTPrijmeni: TMenuItem;
    mnItmTMesto: TMenuItem;
    mnItmTEmail: TMenuItem;
    mnitmTPSC: TMenuItem;
    mnItmTLoc: TMenuItem;
    mnItmTTrida: TMenuItem;
    mnItmTPoznamka: TMenuItem;
    mnItmTUlice: TMenuItem;
    mnItmTJmeno: TMenuItem;
    actZavrit: TAction;
    dbGrdCall: TCfmDBGrid;   
    procedure NactiData;
    procedure dbGrdCallTitleClick(Column: TColumn);
    procedure actNacistCSVExecute(Sender: TObject);
    procedure actHledatExecute(Sender: TObject);
    procedure actPrvniPosledniExecute(Sender: TObject);
    procedure actZavritExecute(Sender: TObject);
    procedure ImportCSV(FileName:String);
    procedure FormCreate(Sender: TObject);
    procedure mnItmTriditClick(Sender: TObject);
    procedure tlBtnTriditClick(Sender: TObject);
    procedure actPrvniUpdate(Sender: TObject);
    procedure actPosledniUpdate(Sender: TObject);
  private
    { Private declarations }
    frmFind:TfrmFind;
    procedure OnSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;
  public
    { Public declarations }
  end;

var
  frmCallBook: TfrmCallBook;

implementation

uses TextDialog, Main, HQLdMod;

{$R *.dfm}

//pri vytvoreni
procedure TfrmCallBook.FormCreate(Sender: TObject);
begin
  //
  frmFind:=TfrmFind.Create(Self);
  frmFind.InitDialog(qCall,dbGrdCall,
    [0,2,7,10],
    [ftCall,ftText,ftText,ftText],
    ['Znaèka','Pøíjmení','Mail','Poznámka']);
  //
  qCall.DatabaseName:=dmLog.RootDir;
  if not fileExists(dmLog.RootDir+CallBook_File) then
  begin
    if (cMessageDlg(strNoDataQ,mtInformation,[mbYes,mbNo],mrYes,0)=mrYes)and
       (dmLog.dlgOpen.Execute) then
    begin
      ImportCSV(dmLog.dlgOpen.FileName);
      NactiData;
    end;
  end else NactiData;
end;

procedure TfrmCallBook.OnSysCommand(var Msg: TWMSysCommand);
begin
  if Msg.CmdType=SC_MINIMIZE then ShowWindow(Application.Handle,SW_SHOWMINNOACTIVE)
                             else inherited;
end;

//import dat z CSV
procedure TfrmCallBook.ImportCSV(FileName:String);
var
  Table:TTable;
  pole:array[1..11] of string;
  Data:TStrings;
  radek,zaznam:String;
  i,j,k,DelkaRadku:Integer;

 function CheckFormat:Boolean;
 const
   Hlavicka='VOL_ZNAK;TITUL;PRIJMENI;JMENO;ADR_ULICE;ADR_MESTO;PSC;E_MAIL;GRID;CLASS;POZN';
 begin
   if UpperCase(Data.Strings[0])=Hlavicka then Result:=True else Result:=False;
 end;

begin
  data:=TStringList.Create;
  Table:=TTable.Create(nil);
  try
    Data.LoadFromFile(FileName);
    if not CheckFormat then
      if cMessageDlg(strImportCBfq,mtError,[mbYes,mbNo],mrNo,0)<>mrYes then Exit;
    CopyFile(PChar(dmLog.RootDir+'Clbp.db'),PChar(dmLog.RootDir+CallBook_File),False);
    //
    Table.DatabaseName:=dmLog.RootDir;
    Table.TableName:=CallBook_File;
    Table.Open;
    //
    frmDialog.ZobrazProg(strLoadingData,0,Data.Count-1);
    for i:=1 to Data.Count-1 do
    begin
      radek:=Data.Strings[i];
      DelkaRadku:=Length(radek);
      k:=1;zaznam:='';
      for j:=1 to DelkaRadku do
      begin
        if (radek[j]=';')or(j=DelkaRadku) then
        begin
          if (j=DelkaRadku)and(radek[j]<>';') then zaznam:=zaznam+radek[j];
          if k<=11 then pole[k]:=zaznam;
          zaznam:='';
          Inc(k);
        end else zaznam:=zaznam+radek[j];
      end;
      if k<12 then for j:=k to 11 do pole[j]:='';
      Table.InsertRecord([pole[1],pole[2],pole[3],pole[4],pole[5],pole[6],
                          pole[7],pole[8],pole[9],pole[10],pole[11]]);
      frmDialog.pgBar.Progress:=i;
    end;
    Table.Close;
  finally
    Table.Free;
    Data.Free;
    frmDialog.Close;
    NactiData;
  end;
end;

//znovunacteni dat
procedure TfrmCallBook.NactiData;
var i:Integer;
begin
  for i:=0 to DbGrdCall.Columns.Count-1 do
    DbGrdCall.Columns[i].Title.Color:=clBtnFace;
  DbGrdCall.Columns[0].Title.Color:=clOfactTitle;
  mnItmTZnacka.Checked:=True;
  with qCall do
  begin
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM "'+CallBook_File+'" ORDER BY Znacka');
    try
      Open;
    except
    end;
  end;
end;

//zmena trideni zahlavi
procedure TfrmCallBook.dbGrdCallTitleClick(Column: TColumn);
var
  i:Integer;
  ActKey:String;
begin
  //netridit 2x
  if not qCall.Active then Exit;
  if Column.Title.Color=clOfactTitle then Exit;
  //zahlavi
  for i:=0 to DbGrdCall.Columns.Count-1 do
    DbGrdCall.Columns[i].Title.Color:=clBtnFace;
  Column.Title.Color:=clOfactTitle;
  //menu
  for i:=0 to poMnTridit.Items.Count-1 do
    if poMnTridit.Items.Items[i].Hint=Column.FieldName then
      poMnTridit.Items.Items[i].Checked:=true;
  //tridit
  with qCall do
  begin
    ActKey:=Fields.Fields[0].AsString;
    Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM "'+CallBook_File+'" ORDER BY '+Column.FieldName);
    try
      Open;
      Locate('ZNACKA',ActKey,[]);
    except
    end;
  end;
end;

//zmena trideni v menu
procedure TfrmCallBook.mnItmTriditClick(Sender: TObject);
var
  i:Integer;
  ActKey:String;
  Tridit:String;
begin
  Tridit:=UpperCase(TmenuItem(Sender).Hint);
  //menu
  TMenuItem(Sender).Checked:=True;
  //netridit 2x
  if not qCall.Active then Exit;
  //zahlavi
  for i:=0 to DbGrdCall.Columns.Count-1 do with DbGrdCall.Columns[i] do
  begin
    if (FieldName=Tridit)and(Title.Color=clOfactTitle) then Exit;
    if FieldName=Tridit then Title.Color:=clOfactTitle
                        else Title.Color:=clBtnFace;
  end;
  //tridit
  with qCall do
  begin
    ActKey:=Fields.Fields[0].AsString;
   Close;
    SQL.Clear;
    SQL.Add('SELECT * FROM "'+CallBook_File+'" ORDER BY '+Tridit);
    try
      Open;
      Locate('ZNACKA',ActKey,[]);
    except
    end;
  end;
end;

//akce nacist CSV
procedure TfrmCallBook.actNacistCSVExecute(Sender: TObject);
begin
  if cMessageDlg(strImportCBq,mtConfirmation,[mbYes,mbNo],mrNo,0)<>mrYes then Exit;
  with dmLog.dlgOpen do
  begin
    Options:=[ofHideReadOnly,ofFileMustExist,ofEnableSizing];
    Filter:='CSV (*.csv)|*.csv';
    if not Execute then Exit;
    ImportCSV(FileName);
  end;
end;

//hledat
procedure TfrmCallBook.actHledatExecute(Sender: TObject);
begin
  if not qCall.Active then Exit;
  if Assigned(frmFind) then frmFind.Show;
end;

//prvni posledni
procedure TfrmCallBook.actPrvniPosledniExecute(Sender: TObject);
begin
  if not qCall.Active then Exit;
  if sender=actPrvni then qCall.First;
  if sender=actPosledni then qCall.Last;
end;

//zavrit
procedure TfrmCallBook.actZavritExecute(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TfrmCallBook.tlBtnTriditClick(Sender: TObject);
begin
  TToolButton(Sender).CheckMenuDropdown;
end;

procedure TfrmCallBook.actPrvniUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled:=(qCall.RecordCount<>0)and(qCall.RecNo<>1);
end;

procedure TfrmCallBook.actPosledniUpdate(Sender: TObject);
begin
  TAction(Sender).Enabled:=(qCall.RecordCount<>0)and(qCall.RecNo<>qCall.RecordCount);
end;

end.
