{$include global.inc}
unit TextDialog;

interface

uses
  Windows, Forms, Gauges, Controls, StdCtrls, Classes, ExtCtrls;

type
  TfrmDialog = class(TForm)
    lblText: TLabel;
    shpRamecek: TShape;
    Btn: TButton;
    pgBar: TGauge;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Zavrit(Sender:TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Zobraz(const text:String);
    procedure ZobrazProg(const text:String; const Min,Max:Integer);
    procedure ZobrazBtn(const Text,BtnCaption:String; BtnOnClick:TNotifyEvent);
    procedure SetText(const Text:String);
    procedure OnProgress(const Progress: Integer);
  end;

var
  frmDialog: TfrmDialog;

implementation

uses Main;

{$R *.dfm}

procedure TfrmDialog.Zobraz(const text:String);
begin
  btn.Visible:=false;
  pgBar.Visible:=false;
  lblText.Caption:=Text;
  Show;
  Update;
  frmHQLog.Update;
end;

procedure TfrmDialog.ZobrazProg(const text:String; const Min,Max:Integer);
begin
  btn.Visible:=false;
  pgBar.Visible:=True;
  pgBar.MinValue:=Min;
  pgBar.MaxValue:=Max;
  pgBar.Progress:=0;
  lblText.Caption:=Text;
  Show;
  Update;
  frmHQLog.Update;
end;

procedure TfrmDialog.ZobrazBtn(const Text,BtnCaption:String; BtnOnClick:TNotifyEvent);
begin
  btn.Visible:=True;
  btn.Caption:=BtnCaption;
  if Assigned(BtnOnClick) then btn.OnClick:=BtnOnClick
                          else btn.OnClick:=Zavrit;
  lblText.Caption:=Text;
  pgBar.Visible:=false;
  Show;
  Update;
  frmHQLog.Update;
end;

procedure TfrmDialog.SetText(const Text:String);
begin
  lblText.Caption:=Text;
  Update;
end;

procedure TfrmDialog.Zavrit(Sender:TObject);
begin
  Close;
end;

procedure TfrmDialog.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  btn.OnClick:=nil;
  pgBar.Visible:=false;
  btn.Visible:=false;
end;

procedure TfrmDialog.OnProgress(const Progress:Integer);
begin
  if Progress = pgBar.Progress then Exit;
  pgBar.Progress:=Progress;
  pgBar.Update;
end;

end.
