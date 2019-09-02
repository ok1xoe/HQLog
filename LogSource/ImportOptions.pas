{$include global.inc}
unit ImportOptions;

interface

uses
  Windows, HQLControls, Classes, ActnList, XPStyleActnCtrls, ActnMan,
  StdCtrls, ExtCtrls, Controls, Forms, Messages, SysUtils, cfmDialogs,
  Dialogs, HamLogFP, Amater, cfmCharSet, HQLResStrings, Import;

type
  TImportDlgOpt = (idoSTXSRX, idoCharset, idoDupe);
  TImportDlgOpts = set of TImportDlgOpt;
  //
  TfrmImportOptions = class(TForm)
    btnNext: TButton;
    btnCancel: TButton;
    chReplaceNote: TCheckBox;
    cbCharSet: TComboBox;
    lblKodovani: TLabel;
    chDupe: TCheckBox;
    lblPWR: TLabel;
    actManager: TActionManager;
    actNext: TAction;
    actCancel: TAction;
    Bevel1: TBevel;
    edtLoc: TLocatorEdit;
    lblLoc: TLabel;
    cbPWR: TFloatComboBox;
    lblNote: TLabel;
    edtNote: TEdit;
    actHelp: TAction;
    chImportSTXSRX: TCheckBox;
    //
    procedure FormCreate(Sender: TObject);
    //
    procedure chReplaceNoteClick(Sender: TObject);
    //
    procedure actNextExecute(Sender: TObject);
    procedure actCancelExecute(Sender: TObject);
    procedure actHelpExecute(Sender: TObject);
  private
    { Private declarations }
    procedure OnSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;
  public
    { Public declarations }
    function Execute(var Data: TImportOptions;
      const Options: TImportDlgOpts = []): Boolean;
  end;

var
  frmImportOptions: TfrmImportOptions;

implementation

uses Main, Kontrola, HQLdMod, HQLConsts;

{$R *.dfm}

//------------------------------------------------------------------------------
//frmImportOptions
//------------------------------------------------------------------------------

//vytvoreni formulare
procedure TfrmImportOptions.FormCreate(Sender: TObject);
begin
  SetCbBoxItemsF(cbPWR, hPWRs);
  SetCbBoxItems(cbCharSet, CharSetNames);
end;

procedure TfrmImportOptions.OnSysCommand(var Msg: TWMSysCommand);
begin
  if Msg.CmdType=SC_MINIMIZE then ShowWindow(Application.Handle,SW_SHOWMINNOACTIVE)
                             else inherited;
end;

//
function TfrmImportOptions.Execute(var Data: TImportOptions;
  const Options: TImportDlgOpts = []): Boolean;
begin
  //nastavit formular
  chDupe.Enabled:=not(idoDupe in Options);
  chImportSTXSRX.Enabled:=not(idoSTXSRX in Options);
  cbCharSet.Enabled:=not(idoCharset in Options);
  //prednastavit data
  edtLoc.Text:=Data.LOCo;
  edtNote.Text:=Data.Note;
  cbPWR.Text:=FormatFloat(FreqFormat, Data.PWR);
  chDupe.Checked:=Data.CheckDupe;
  chImportSTXSRX.Checked:=Data.ImportSTXSRX;
  chReplaceNote.Checked:=Data.RewriteNote;
  cbCharSet.ItemIndex:=Integer(Data.CharSet);
  //zobrazit
  Result:=ShowModal = mrOk;
  //vratit data
  Data.LOCo:=edtLoc.Text;
  Data.Note:=edtNote.Text;
  Data.PWR:=StrToFloat(cbPWR.Text);
  Data.CheckDupe:=chDupe.Checked;
  Data.ImportSTXSRX:=chImportSTXSRX.Checked;
  Data.RewriteNote:=chReplaceNote.Checked;
  Data.CharSet:=TCharSet(cbCharSet.ItemIndex);
end;

//------------------------------------------------------------------------------

procedure TfrmImportOptions.chReplaceNoteClick(Sender: TObject);
begin
  edtNote.Enabled:=chReplaceNote.Checked;
  lblNote.Enabled:=chReplaceNote.Checked;
  if chReplaceNote.Checked then edtNote.SetFocus;
end;

//------------------------------------------------------------------------------

//help
procedure TfrmImportOptions.actHelpExecute(Sender: TObject);
begin
  Application.HelpJump(Name);
end;

//ok
procedure TfrmImportOptions.actNextExecute(Sender: TObject);
begin
  if edtLoc.Text='' then
  begin
    cMessageDlg(strNoLoc,mtError,[mbOk],mrOk,0);
    edtLoc.SetFocus;
    Exit;
  end;
  if not JeLOC(edtLoc.Text,edtLoc) then Exit;
  if not JeVykon(cbPWR.Text,cbPWR) then Exit;
  ModalResult:=mrOk;
end;

//cancel
procedure TfrmImportOptions.actCancelExecute(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

end.
