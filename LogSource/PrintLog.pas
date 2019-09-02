{$include global.inc}
unit PrintLog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ExtCtrls, StdCtrls, DB, DBTables, RpRave, RpBase, RpFiler,
  RpRender, RpRenderCanvas, RpRenderPrinter, RpDefine, RpCon, RpConDS, HamLogFP,
  Grids, DBGrids, HQLResStrings, cfmDialogs, HQLDatabase, HQLConsts;

type
  TfrmTiskDenik = class(TForm)
    HamLogRvDSC: TRvDataSetConnection;
    RvPrinter: TRvRenderPrinter;
    RvWriter: TRvNDRWriter;
    RvProject: TRvProject;
    qTisk: TQuery;
    btnTisk: TButton;
    btnNahled: TButton;
    btnZavrit: TButton;
    rGrpRozsah: TRadioGroup;
    cbBoxTiskarna: TComboBox;
    lblTiskarna: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure GenerujData;
    procedure cbBoxTiskarnaChange(Sender: TObject);
    procedure AbortClick(Sender: TObject);
    procedure btnTiskClick(Sender: TObject);
    procedure btnNahledClick(Sender: TObject);
    procedure rGrpRozsahClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    { Private declarations }
    Generovat:Boolean;
    //
    procedure OnSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;
  public
    { Public declarations }
  end;

var
  frmTiskDenik: TfrmTiskDenik;

implementation

uses Main, TextDialog, PrintPreview, HQLdMod;

{$R *.dfm}

//pri startu
procedure TfrmTiskDenik.FormCreate(Sender: TObject);
begin
  //
  Generovat:=True;
  //nacteni tiskaren
  cbBoxTiskarna.Items:=RvWriter.Printers;
  cbBoxTiskarna.ItemIndex:=RvWriter.PrinterIndex;
  //nastaveni cest k souborum
  RvProject.ProjectFile:=dmLog.RootDir+'Tisk.rav';
  RvWriter.FileName:=dmLog.TempDir+'Tisk.rnd';
  RvWriter.StatusLabel:=frmDialog.lblText;
  //
  RvProject.Open;
end;

//pri ukonceni
procedure TfrmTiskDenik.FormDestroy(Sender: TObject);
begin
  RvProject.Close;
  qTisk.Close;
  DeleteFile(dmLog.TempDir+'Tisk.rnd');
end;

procedure TfrmTiskDenik.OnSysCommand(var Msg: TWMSysCommand);
begin
  if Msg.CmdType=SC_MINIMIZE then ShowWindow(Application.Handle,SW_SHOWMINNOACTIVE)
                             else inherited;
end;

procedure TfrmTiskDenik.GenerujData;
var
  Data:String;
begin
  frmDialog.Zobraz(strLoadingData);
  //trideni databaze
  if rGrpRozsah.ItemIndex=0 then Data:=dmLog.DataDir+dmLog.User.Call
                            else Data:=dmLog.TempDir+TempDB_dFile;
  qTisk.SQL.Clear;
  qTisk.SQL.Add('SELECT * FROM "'+Data+'" ORDER BY '+
                dfnL_Date+','+dfnL_Time+','+dfnL_Call);
  //qTisk.Open;
  qTisk.Prepared:=True;
  try
    qTisk.Open;
  except
  end;
  //nastaveni parametru tisku
  RvProject.SetParam('Znacka',dmLog.User.Call);
  RvProject.SetParam('Verze',sVersion);
  RvProject.SelectReport('rprtDenik',false);
  RvWriter.PrinterIndex:=cbBoxTiskarna.ItemIndex;
  frmDialog.ZobrazBtn('','Zrušit',AbortClick);
  //generovat tiskovy soubor
  RvProject.Execute;
  Generovat:=False;
  frmDialog.Close;
end;

procedure TfrmTiskDenik.AbortClick(Sender: TObject);
begin
  Generovat:=True;
  RvWriter.Abort;
  frmDialog.Close;
  cMessageDlg(strPrintInterrupted,mtInformation,[mbOk],mrOk,0);
end;

procedure TfrmTiskDenik.cbBoxTiskarnaChange(Sender: TObject);
begin
  Generovat:=True;
end;

procedure TfrmTiskDenik.btnTiskClick(Sender: TObject);
begin
  if not RvProject.Active then Exit;
  if Generovat then GenerujData;
  try
    RvPrinter.Render(dmLog.TempDir+'tisk.rnd');
    if not RvWriter.Aborted then ModalResult:=mrOk;
  except
    cMessageDlg(strPrintErr,mtError,[mbOk],mrOk,0);
  end;
end;

procedure TfrmTiskDenik.btnNahledClick(Sender: TObject);
var
  FStream:TFileStream;
begin
  if not RvProject.Active then Exit;
  if Generovat then GenerujData;
  FStream:=TFileStream.Create(RvWriter.FileName,fmOpenRead);
  try
    frmNahled:=TfrmNahled.Create(nil);
    try
      frmNahled.RvPreview.Render(FStream);
      frmNahled.ShowModal;
    finally
      frmNahled.Release;
    end;
  finally
    FStream.Free;
  end;
end;

procedure TfrmTiskDenik.rGrpRozsahClick(Sender: TObject);
begin
  Generovat:=True;
  if rGrpRozsah.ItemIndex=1 then
    if frmHQLog.dbgLog.SelectedRows.Count=0 then
    begin
      cMessageDlg(strNoSelQSO,mtInformation,[mbOk],mrOk,0);
      rGrpRozsah.ItemIndex:=0;
    end;
end;

end.
