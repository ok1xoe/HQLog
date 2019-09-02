{$include global.inc}
unit PrintLabels;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Controls, Forms,
  RpRender, RpRenderCanvas, RpRenderPrinter, RpCon, Dialogs,
  RpConBDE, RpBase, RpFiler, RpDefine, RpRave, StdCtrls, DB,
  HamLogFP, DBTables, RpConDS, ExtCtrls, RpRenderPreview,
  HQLResStrings, cfmDialogs, HQLDatabase, HQLConsts;

type
  TfrmTiskQSL = class(TForm)
    btnPrint: TButton;
    btnClose: TButton;
    qPrint: TQuery;
    RvProject: TRvProject;
    HamLogRvDSC: TRvDataSetConnection;
    RvWriter: TRvNDRWriter;
    RvPrinter: TRvRenderPrinter;
    GroupBox2: TGroupBox;
    chbQSLo: TCheckBox;
    grpSortBy: TGroupBox;
    rBtnDate: TRadioButton;
    rBtnDXCC: TRadioButton;
    cbStyle: TComboBox;
    lblStyle: TLabel;
    btnPreview: TButton;
    rBtnBureau: TRadioButton;
    rBtnCall: TRadioButton;
    cbPrinter: TComboBox;
    lblPrinter: TLabel;
    cbQSLo: TComboBox;
    edtNote: TEdit;
    lblNote: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure GenerujData;
    procedure AbortClick(Sender: TObject);
    procedure btnPreviewClick(Sender: TObject);
    procedure btnPrintClick(Sender: TObject);
    procedure DataChange(Sender: TObject);
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
  frmTiskQSL: TfrmTiskQSL;

implementation

uses Main, TextDialog, PrintPreview, HQLdMod, Amater;

{$R *.dfm}

//pri startu
procedure TfrmTiskQSL.FormCreate(Sender: TObject);
begin
  Generovat:=True;
  //
  SetCbBoxItems(cbQSLo,hQSLoNames);
  cbQSLo.ItemIndex:=1;
  //nacteni tiskaren
  cbPrinter.Items:=RvWriter.Printers;
  cbPrinter.ItemIndex:=RvWriter.PrinterIndex;
  //nastaveni cest k souborum
  RvProject.ProjectFile:=dmLog.RootDir+'Tisk.rav';
  RvWriter.FileName:=dmLog.TempDir+'Tisk.rnd';
  RvWriter.StatusLabel:=frmDialog.lblText;
  //
  RvProject.Open;
  RvProject.GetReportCategoryList(cbStyle.Items,'Nalepky;',True);
  cbStyle.ItemIndex:=0;
end;

//pri ukonceni
procedure TfrmTiskQSL.FormDestroy(Sender: TObject);
begin
  qPrint.Close;
  RvProject.Close;
  DeleteFile(dmLog.TempDir+'Tisk.rnd');
end;

procedure TfrmTiskQSL.OnSysCommand(var Msg: TWMSysCommand);
begin
  if Msg.CmdType=SC_MINIMIZE then ShowWindow(Application.Handle,SW_SHOWMINNOACTIVE)
                             else inherited;
end;

procedure TfrmTiskQSL.GenerujData;
var
  Tridit:String;
begin
  frmDialog.Zobraz(strLoadingData);
  if rBtnBureau.Checked then Tridit:=dfnL_Index;
  if rBtnCall.Checked then Tridit:=dfnL_Call+','+dfnL_Date+','+dfnL_Time;
  if rBtnDate.Checked then Tridit:=dfnL_Date+','+dfnL_Time+','+dfnL_Call;
  if rBtnDXCC.Checked then Tridit:=dfnL_DXCC+','+dfnL_Call+','+dfnL_Date+','+dfnL_Time;
  //trideni databaze
  qPrint.SQL.Text:='SELECT * FROM "'+dmLog.TempDir+QslDB_dFile+'" ORDER BY '+Tridit;
  try
    qPrint.Open;
  except
  end;
  //nastaveni parametru tisku
  RvProject.SetParam('Znacka',dmLog.User.Call);
  RvProject.SetParam('Poznamka',edtNote.Text);
  RvProject.SelectReport(cbStyle.Text,True);
  RvWriter.PrinterIndex:=cbPrinter.ItemIndex;
  frmDialog.ZobrazBtn('','Zrušit',AbortClick);
  //generovat tiskovy soubor
  RvProject.Execute;
  frmDialog.Close;
  Generovat:=False;
end;

procedure TfrmTiskQSL.AbortClick(Sender: TObject);
begin
  Generovat:=True;
  RvWriter.Abort;
  frmDialog.Close;
  cMessageDlg(strPrintInterrupted,mtInformation,[mbOk],mrOk,0);
end;

procedure TfrmTiskQSL.btnPreviewClick(Sender: TObject);
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

procedure TfrmTiskQSL.btnPrintClick(Sender: TObject);
begin
  if not RvProject.Active then Exit;
  if Generovat then GenerujData;
  try
    RvPrinter.Render(dmLog.TempDir+'tisk.rnd');
    if not RvWriter.Aborted then
    begin
      if chbQSLo.Checked then frmHQLog.SetQSL(dfiL_QSLo, cbQSLo.ItemIndex);
      ModalResult:=mrOk;
    end;
  except
    cMessageDlg(strPrintErr,mtError,[mbOk],mrOk,0);
  end;
end;

procedure TfrmTiskQSL.DataChange(Sender: TObject);
begin
  Generovat:=True;
end;

end.
