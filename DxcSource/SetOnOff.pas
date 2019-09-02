unit SetOnOff;

interface

uses
  Windows, Classes, ActnList, XPStyleActnCtrls, ActnMan, StdCtrls,
  Controls, ExtCtrls, Forms;

type
  TfrmOnOff = class(TForm)
    rbOn: TRadioButton;
    rbOff: TRadioButton;
    lblText: TLabel;
    btnOk: TButton;
    btnCancel: TButton;
    actManager: TActionManager;
    actCancel: TAction;
    actOk: TAction;
    Bevel1: TBevel;
    procedure actOkExecute(Sender: TObject);
    procedure actCancelExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmOnOff: TfrmOnOff;

implementation

{$R *.dfm}

procedure TfrmOnOff.actOkExecute(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TfrmOnOff.actCancelExecute(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

end.
