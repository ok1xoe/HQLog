unit BackUpDialog;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls, ActnList, XPStyleActnCtrls, ActnMan;

type
  TfrmBackUpDlg = class(TForm)
    pnlTitle: TPanel;
    bvlTop: TBevel;
    lblCallT: TLabel;
    lblDateT: TLabel;
    lblTimeT: TLabel;
    Label4: TLabel;
    lblFileT: TLabel;
    lblFile: TLabel;
    lblCall: TLabel;
    lblDate: TLabel;
    lblTime: TLabel;
    Button1: TButton;
    Button2: TButton;
    bvlBottom: TBevel;
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
  frmBackUpDlg: TfrmBackUpDlg;

implementation

{$R *.dfm}

procedure TfrmBackUpDlg.actOkExecute(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

procedure TfrmBackUpDlg.actCancelExecute(Sender: TObject);
begin
  Close;
end;

end.
