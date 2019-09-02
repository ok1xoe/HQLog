{$include global.inc}
unit ImportEdit;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ActnList, XPStyleActnCtrls, ActnMan, HQLResStrings, cfmDialogs,
  HQLControls, HQLDatabase, ExtCtrls;

type
  TfrmImportEdit = class(TForm)
    btnSave: TButton;
    btnClose: TButton;
    actManager: TActionManager;
    actClose: TAction;
    actSave: TAction;
    lblWAZ: TLabel;
    lblTime: TLabel;
    lblRSTp: TLabel;
    lblRSTo: TLabel;
    lblQTH: TLabel;
    lblQSLp: TLabel;
    lblQSLo: TLabel;
    lblPWR: TLabel;
    lblNote: TLabel;
    lblName: TLabel;
    lblMode: TLabel;
    lblMGRmgr: TLabel;
    lblLOCp: TLabel;
    lblLOCo: TLabel;
    lblITU: TLabel;
    lblIOTA: TLabel;
    lblFreq: TLabel;
    lblEQSL: TLabel;
    lblDXCC: TLabel;
    lblDate: TLabel;
    lblAward: TLabel;
    lbCall: TLabel;
    edtWAZ: TEdit;
    edtTime: TTimeEdit;
    edtRSTp: TReportEdit;
    edtRSTo: TReportEdit;
    edtQTH: TEdit;
    edtQSLvia: TEdit;
    edtNote: TEdit;
    edtName: TEdit;
    edtLOCp: TLocatorEdit;
    edtLOCo: TLocatorEdit;
    edtITU: TEdit;
    edtIOTA: TIOTAEdit;
    edtDxcc: TEdit;
    edtDate: TDateEdit;
    edtCall: TEdit;
    edtAward: TEdit;
    cbBoxQSLp: TComboBox;
    cbBoxQSLo: TComboBox;
    cbBoxPWR: TComboBox;
    cbBoxMode: TComboBox;
    cbBoxFreq: TComboBox;
    cbBoxEQSL: TComboBox;
    Bevel1: TBevel;
    procedure FormCreate(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure LoadData;
    procedure actSaveExecute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure CallKeyPress(Sender: TObject; var Key: Char);
    procedure edtFloatKeyPress(Sender: TObject; var Key: Char);
    procedure DxccKeyPress(Sender: TObject; var Key: Char);
    procedure ITUWAZKeyPress(Sender: TObject; var Key: Char);
    procedure edtAwardKeyPress(Sender: TObject; var Key: Char);
    //OnKeyPressed
  private
    { Private declarations }
    procedure OnSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;
  public
    { Public declarations }
  end;

var
  frmImportEdit: TfrmImportEdit;

implementation

uses Main, Amater, HamLogFp, Import, Kontrola, KeyFilters;

{$R *.dfm}

procedure TfrmImportEdit.FormCreate(Sender: TObject);
begin
  //naplneni ComboBoxu
  SetCbBoxItems(cbBoxMode, hModeName, Low(THamMode) + 1, High(THamMode));
  SetCbBoxItemsF(cbBoxFreq, hBandBegin, Low(hBandBegin), High(hBandBegin) - 1);
  SetCbBoxItems(cbBoxQSLo, hQSLoNames);
  SetCbBoxItems(cbBoxQSLp, hQSLpNames);
  SetCbBoxItems(cbBoxEQSL, hEQSLNames);
  SetCbBoxItemsF(cbBoxPWR, hPWRs);
  //
  LoadData;
end;

procedure TfrmImportEdit.OnSysCommand(var Msg: TWMSysCommand);
begin
  if Msg.CmdType = SC_MINIMIZE then
    ShowWindow(Application.Handle, SW_SHOWMINNOACTIVE)
  else
    inherited;
end;

procedure TfrmImportEdit.LoadData;
begin
  with frmImport.tblImport,frmImport.tblImport.Fields do
  begin
    edtDate.Text:=Fields[dfiL_Date].AsString;
    edtTime.Text:=Fields[dfiL_Time].AsString;
    edtCall.Text:=Fields[dfiL_Call].AsString;
    cbBoxFreq.Text:=Fields[dfiL_Freq].AsString;
    cbBoxMode.ItemIndex:=cbBoxMode.Items.IndexOf(
      hModeName[Fields[dfiL_Mode].AsInteger]);
    edtRSTo.Text:=Fields[dfiL_RSTo].AsString;
    edtRSTp.Text:=Fields[dfiL_RSTp].AsString;
    edtName.Text:=Fields[dfiL_Name].AsString;
    edtQTH.Text:=Fields[dfiL_QTH].AsString;
    edtLOCo.Text:=Fields[dfiL_LOCo].AsString;
    edtLOCp.Text:=Fields[dfiL_LOCp].AsString;
    cbBoxQSLo.ItemIndex:=Fields[dfiL_QSLo].AsInteger;
    cbBoxQSLp.ItemIndex:=Fields[dfiL_QSLp].AsInteger;
    edtQSLvia.Text:=Fields[dfiL_QSLvia].AsString;
    cbBoxEQSL.ItemIndex:=Fields[dfiL_EQSLp].AsInteger;
    edtNote.Text:=Fields[dfiL_Note].AsString;
    cbBoxPWR.Text:=Fields[dfiL_PWR].AsString;
    edtDXCC.Text:=Fields[dfiL_Dxcc].AsString;
    edtIOTA.Text:=Fields[dfiL_IOTA].AsString;
    edtAward.Text:=Fields[dfiL_Award].AsString;
    edtITU.Text:=Fields[dfiL_ITU].AsString;
    edtWAZ.Text:=Fields[dfiL_WAZ].AsString;
  end;
end;

procedure TfrmImportEdit.actCloseExecute(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

procedure TfrmImportEdit.actSaveExecute(Sender: TObject);
begin
  //kontrola udaju ve formulari
  if not(JeZnacka(edtCall.Text,edtCall)and
         JeFrekvence(cbBoxFreq.Text,cbBoxFreq)and
         JeLoc(edtLOCp.Text,edtLOCp)and
         JeLoc(edtLOCo.Text,edtLOCo)and
         JeDxcc(edtDXCC.Text,edtDXCC)and
         JeITU(edtITU.Text,edtITU)and
         JeWAZ(edtWAZ.Text,edtWAZ)and
         JeIOTA(edtIOTA.Text,edtIOTA)and
         JeCas(edtTime.Text,edtTime)and
         JeDatum(edtDate.Text,edtDate)and
         JeVykon(cbBoxPWR.Text,cbBoxPWR)) then Exit;
  if edtLOCo.Text='' then
  begin
    cMessageDlg(strNoLoc,mtError,[mbOk],mrOk,0);
    edtLOCo.SetFocus;
    Exit;
  end;
  ModalResult:=mrOk;
end;

procedure TfrmImportEdit.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=vk_Up then SelectNext(TWinControl(Sender),False,True);
  if Key=vk_Down then SelectNext(TWinControl(Sender),True,True);
end;

//------------------------------------------------------------------------------
//OnKeyPressed
//------------------------------------------------------------------------------

//call
procedure TfrmImportEdit.CallKeyPress(Sender: TObject; var Key: Char);
begin
  FilterCall(Key);
end;

//frekvence,pwr
procedure TfrmImportEdit.edtFloatKeyPress(Sender: TObject; var Key: Char);
begin
  FilterFloat(Key);
end;

//DXCC
procedure TfrmImportEdit.DxccKeyPress(Sender: TObject; var Key: Char);
begin
  FilterCall(Key);
end;

//ITU, WAZ
procedure TfrmImportEdit.ITUWAZKeyPress(Sender: TObject; var Key: Char);
begin
  FilterNumber(Key);
end;

//Award
procedure TfrmImportEdit.edtAwardKeyPress(Sender: TObject; var Key: Char);
begin
  FilterAward(Key,[]);
end;

end.
