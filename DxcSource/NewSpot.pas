unit NewSpot;

interface

uses
  Windows, Classes, ActnList, XPStyleActnCtrls, ActnMan, Controls, StdCtrls,
  Forms, Sysutils;

type
  TfrmDxcNewSpot = class(TForm)
    edtCall: TEdit;
    edtNote: TEdit;
    btnCancel: TButton;
    btnOk: TButton;
    lblCall: TLabel;
    lblFreq: TLabel;
    lblNote: TLabel;
    cbBoxFreq: TComboBox;
    actManager: TActionManager;
    actOk: TAction;
    actCancel: TAction;
    lblMHz: TLabel;
    procedure actOkExecute(Sender: TObject);
    procedure actCancelExecute(Sender: TObject);
    procedure cbBoxFreqKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDxcNewSpot: TfrmDxcNewSpot;

implementation

{$R *.dfm}

procedure TfrmDxcNewSpot.actOkExecute(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TfrmDxcNewSpot.actCancelExecute(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

procedure TfrmDxcNewSpot.cbBoxFreqKeyPress(Sender: TObject; var Key: Char);
begin
  if Key in ['.', ','] then
    Key:=DecimalSeparator;
end;

end.
