unit ComboBoxDlg;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, HamLogFP, Amater, ActnList, XPStyleActnCtrls, ActnMan;

type
  TdlgComboBox = class(TForm)
    cbBoxMode: TComboBox;
    btnOk: TButton;
    btnCancel: TButton;
    actManager: TActionManager;
    actOk: TAction;
    actCancel: TAction;
    procedure actOkExecute(Sender: TObject);
    procedure actCancelExecute(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  dlgComboBox: TdlgComboBox;

implementation

{$R *.dfm}

procedure TdlgComboBox.actOkExecute(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TdlgComboBox.actCancelExecute(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

end.
