{$include global.inc}
unit StatOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, CheckLst, HamLogFP, ExtCtrls, ActnList,
  XPStyleActnCtrls, ActnMan, HQLResStrings, cfmDialogs, HQLConsts,
  HQLControls, Menus, ActnPopupCtrl;

type
  TfrmStatFilter = class(TForm)
    btnCancel: TButton;
    btnOk: TButton;
    chlBoxModes: TCheckListBox;
    lblPWR1: TLabel;
    cbBoxPWRmin: TComboBox;
    lblPWR2: TLabel;
    Bevel1: TBevel;
    actManager: TActionManager;
    actOk: TAction;
    actCancel: TAction;
    cbBoxPWRmax: TComboBox;
    Label1: TLabel;
    Bevel2: TBevel;
    edtDateMin: TDateEdit;
    edtDateMax: TDateEdit;
    lblDate2: TLabel;
    lblDate1: TLabel;
    actModeAll: TAction;
    actModeNone: TAction;
    pmMode: TPopupActionBarEx;
    miSelectAll: TMenuItem;
    miSelectNone: TMenuItem;
    //frmStatFilter
    procedure FormCreate(Sender: TObject);
    //cbBoxPWR
    procedure cbBoxPWRKeyPress(Sender: TObject; var Key: Char);
    //akce
    procedure actOkExecute(Sender: TObject);
    procedure actCancelExecute(Sender: TObject);
    procedure actModeAllExecute(Sender: TObject);
    procedure actModeNoneExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmStatFilter: TfrmStatFilter;

implementation
{$R *.dfm}

uses Amater, Kontrola, Main, HQLdMod;

//------------------------------------------------------------------------------
//frmStatFilter
//------------------------------------------------------------------------------

//vytvoreni formulare
procedure TfrmStatFilter.FormCreate(Sender: TObject);
begin
  SetItems(chlBoxModes.Items, hModeName, Low(THamMode) + 1, High(THamMode));
  chlBoxModes.Checked[hmCW - 1]:=True;
  chlBoxModes.Checked[hmSSB - 1]:=True;
  chlBoxModes.Checked[hmAM - 1]:=True;
  chlBoxModes.Checked[hmFM - 1]:=True;
  SetCbBoxItemsF(cbBoxPWRmin, hPWRs);
  SetCbBoxItemsF(cbBoxPWRmax, hPWRs);
  cbBoxPWRmin.Text:='';
  cbBoxPWRmax.Text:='';
end;

//------------------------------------------------------------------------------
//cbBoxPWR
//------------------------------------------------------------------------------

procedure TfrmStatFilter.cbBoxPWRKeyPress(Sender: TObject;
  var Key: Char);
begin
  if Key='.' then Key:=',';
  if not(key in ['0'..'9',',',#8]) then key:=#0;
end;

//------------------------------------------------------------------------------
//akce
//------------------------------------------------------------------------------

//ok
procedure TfrmStatFilter.actOkExecute(Sender: TObject);
var
  Ok:Boolean;
  i:Integer;
begin
  //kontrola
  Ok:=False;
  for i:=0 to chlBoxModes.Count-1 do Ok:=Ok or chlBoxModes.Checked[i];
  if not Ok then
  begin
    cMessageDlg(strNoModeSelected,mtError,[mbOk],mrOk,0);
    Exit;
  end;
  if (edtDatemin.Text<>'')and(not JeDatum(edtDatemin.Text,edtDatemin)) then Exit;
  if (edtDatemax.Text<>'')and(not JeDatum(edtDatemax.Text,edtDatemax)) then Exit;
  if (cbBoxPWRmin.Text<>'')and(not JeVykon(cbBoxPWRmin.Text,cbBoxPWRmin)) then Exit;
  if (cbBoxPWRmax.Text<>'')and(not JeVykon(cbBoxPWRmax.Text,cbBoxPWRmax)) then Exit;
  ModalResult:=mrOk;
end;

//cancel
procedure TfrmStatFilter.actCancelExecute(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

procedure TfrmStatFilter.actModeAllExecute(Sender: TObject);
var
  i:Integer;
begin
  for i:=0 to chlBoxModes.Items.Count-1 do
    chlBoxModes.Checked[i]:=True;
end;

procedure TfrmStatFilter.actModeNoneExecute(Sender: TObject);
var
  i:Integer;
begin
  for i:=0 to chlBoxModes.Items.Count-1 do
    chlBoxModes.Checked[i]:=False;
end;

end.
