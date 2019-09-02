{$include global.inc}
unit EditSelQSOs;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ActnList, XPStyleActnCtrls, ActnMan, StdCtrls, HQLResStrings,
  cfmDialogs, HQLDatabase, HQLConsts;

const
  EdtFields:Array [0..20] of Integer=(
    dfiL_Date,dfiL_Time,dfiL_Freq,dfiL_Mode,dfiL_RSTo,
    dfiL_RSTp,dfiL_LOCo,dfiL_LOCp,dfiL_Name,dfiL_QTH,
    dfiL_QSLo,dfiL_QSLp,dfiL_QSLvia,dfiL_EQSLp,dfiL_DXCC,
    dfiL_IOTA,dfiL_ITU,dfiL_WAZ,dfiL_Award,dfiL_PWR,
    dfiL_Note);

type
  TfrmEditSelQSOs = class(TForm)
    btnSave: TButton;
    btnClose: TButton;
    actManager: TActionManager;
    actSave: TAction;
    actClose: TAction;
    grpBoxData: TGroupBox;
    lblPole: TLabel;
    lblValue: TLabel;
    cbBoxField: TComboBox;
    cbBoxValue: TComboBox;
    procedure FormCreate(Sender: TObject);
    procedure actSaveExecute(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure cbBoxFieldChange(Sender: TObject);
    procedure cbBoxValueKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    procedure OnSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;
  public
    { Public declarations }
  end;

var
  frmEditSelQSOs: TfrmEditSelQSOs;

implementation

{$R *.dfm}

uses HamLogFP, Amater, Kontrola, Main, KeyFilters;

//vytvoreni
procedure TfrmEditSelQSOs.FormCreate(Sender: TObject);
var
  i:Integer;
begin
  cbBoxField.Clear;
  for i:=Low(EdtFields) to High(EdtFields) do
    cbBoxField.Items.Add(dfL_Caption[EdtFields[i]]);
  cbBoxField.ItemIndex:=0;
end;

procedure TfrmEditSelQSOs.OnSysCommand(var Msg: TWMSysCommand);
begin
  if Msg.CmdType=SC_MINIMIZE then ShowWindow(Application.Handle,SW_SHOWMINNOACTIVE)
                             else inherited;
end;

//ok
procedure TfrmEditSelQSOs.actSaveExecute(Sender: TObject);
begin
  case EdtFields[cbBoxField.ItemIndex] of
    dfiL_Freq: if not JeFrekvence(cbBoxValue.Text,cbBoxValue) then Exit;
    dfiL_LOCp: if not JeLoc(cbBoxValue.Text,cbBoxValue) then Exit;
    dfiL_IOTA: if not JeIOTA(cbBoxValue.Text,cbBoxValue) then Exit;
    dfiL_Time: if not JeCas(cbBoxValue.Text,cbBoxValue) then Exit;
    dfiL_Date: if not JeDatum(cbBoxValue.Text,cbBoxValue) then Exit;
    dfiL_PWR: if not JeVykon(cbBoxValue.Text,cbBoxValue) then Exit;
    dfiL_LOCo: begin
      if not JeLoc(cbBoxValue.Text,cbBoxValue) then Exit;
      if cbBoxValue.Text='' then
      begin
        cMessageDlg(strNoLoc,mtError,[mbOk],mrOk,0);
        cbBoxValue.SetFocus;
        Exit;
      end;
    end;
  end;
  ModalResult:=mrOk;
end;

//cancel
procedure TfrmEditSelQSOs.actCloseExecute(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

//zmena pole
procedure TfrmEditSelQSOs.cbBoxFieldChange(Sender: TObject);
begin
  case EdtFields[cbBoxField.ItemIndex] of
    dfiL_Date, dfiL_Time, dfiL_RSTo, dfiL_RSTp, dfiL_LOCo, dfiL_LOCp, dfiL_DXCC,
    dfiL_IOTA, dfiL_ITU, dfiL_WAZ, dfiL_Name, dfiL_QTH, dfiL_QSLvia, dfiL_Note,
    dfiL_Award: begin
      cbBoxValue.Style:=csSimple;
      cbBoxValue.Text:='';
    end;
    dfiL_Freq: begin
      cbBoxValue.Style:=csDropDown;
      SetCbBoxItemsF(cbBoxValue, hBandBegin, Low(hBandBegin), High(hBandBegin) - 1);
    end;
    dfiL_Mode: begin
      cbBoxValue.Style:=csDropDownList;
      SetCbBoxItems(cbBoxValue, hModeName, Low(THamMode) + 1, High(THamMode));
    end;
    dfiL_QSLo: begin
      cbBoxValue.Style:=csDropDownList;
      SetCbBoxItems(cbBoxValue,hQSLoNames);
    end;
    dfiL_QSLp: begin
      cbBoxValue.Style:=csDropDownList;
      SetCbBoxItems(cbBoxValue, hQSLpNames);
    end;
    dfiL_EQSLp: begin
      cbBoxValue.Style:=csDropDownList;
      SetCbBoxItems(cbBoxValue, hEQSLNames);
    end;
    dfiL_PWR: begin
      cbBoxValue.Style:=csDropDown;
      SetCbBoxItemsF(cbBoxValue, hPWRs);
    end;
  end;
end;

//filtr klaves
procedure TfrmEditSelQSOs.cbBoxValueKeyPress(Sender: TObject;
  var Key: Char);
var
  fText:String;
  fSelStart:Integer;
begin
  case EdtFields[cbBoxField.ItemIndex] of
    dfiL_Date: with TComboBox(Sender) do
    begin
      fText:=Text;
      fSelStart:=SelStart;
      FilterDate(Key,fText,fSelStart);
      Text:=fText;
      SelStart:=fSelStart;
    end;
    dfiL_Time: with TComboBox(Sender) do
    begin
      fText:=Text;
      fSelStart:=SelStart;
      FilterTime(Key,fText,fSelStart);
      Text:=fText;
      SelStart:=fSelStart;
    end;
    dfiL_Freq,dfiL_PWR: FilterFloat(Key);
    dfiL_RSTo,dfiL_RSTp: FilterRST(Key);
    dfiL_LOCp,dfiL_LOCo: FilterLocator(Key,TComboBox(Sender).SelStart);
    dfiL_DXCC: FilterCall(Key);
    dfiL_IOTA: FilterIOTA(Key,TComboBox(Sender).SelStart);
    dfiL_ITU,dfiL_WAZ: FilterNumber(Key);
    dfiL_Award: FilterAward(Key,[]);
    {dfiL_Name,dfiL_QTH,dfiL_QSLvia,dfiL_Note,dfiL_Award:}
  else
    if Key=#13 then Key:=#0;
  end;
end;

end.
