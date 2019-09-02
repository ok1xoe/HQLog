{$include global.inc}
unit dlgComboBox;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, HamLogFP, Amater, ActnList, XPStyleActnCtrls, ActnMan;

type
  TfrmComboBox = class(TForm)
    ComboBox: TComboBox;
    btnOk: TButton;
    btnCancel: TButton;
    actManager: TActionManager;
    actOk: TAction;
    actCancel: TAction;
    lblText: TLabel;
    procedure actOkExecute(Sender: TObject);
    procedure actCancelExecute(Sender: TObject);
    function ShowModal(const Title,Text:String;
      const Style:TComboBoxStyle):TModalResult; reintroduce; overload;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmComboBox: TfrmComboBox;

implementation

{$R *.dfm}

procedure TfrmComboBox.actOkExecute(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TfrmComboBox.actCancelExecute(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

function TfrmComboBox.ShowModal(const Title,Text:String;
  const Style:TComboBoxStyle):TModalResult;
begin
  Caption:=Title;
  lblText.Caption:=Text;
  ComboBox.Style:=Style;
  Result:=inherited ShowModal;
end;

end.
