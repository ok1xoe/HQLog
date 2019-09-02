{$include global.inc}
unit About;

interface

uses
  Windows, Gauges, ExtCtrls, StdCtrls, Classes, Controls, Forms, SysUtils,
  Graphics, ShellApi, jpeg;

type
  TfrmAbout = class(TForm)
    lblVersionTT: TLabel;
    lblCopyright: TLabel;
    ImgLogo: TImage;
    lblEMailT: TLabel;
    lblEMail: TLabel;
    lblWWWT: TLabel;
    lblWWW: TLabel;
    pgBar: TGauge;
    Bevel1: TBevel;
    Label1: TLabel;
    lblVersion: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure lblLinkClick(Sender: TObject);
    procedure lblLinkMouseEnter(Sender: TObject);
    procedure lblLinkMouseLeave(Sender: TObject);
    procedure MouseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    procedure Open(Enabled,Modal:Boolean);
    procedure SetText(Version,Copyright,eMail,www:String);
    procedure SetProgressBar(Min,Max:Integer; Visible:Boolean);
    procedure SetProgress(Value:Integer);
  end;

var
  frmAbout: TfrmAbout;

implementation
{$R *.dfm}

//start
procedure TfrmAbout.FormCreate(Sender: TObject);
begin
  pgBar.Hide;
end;

procedure TfrmAbout.Open(Enabled,Modal:Boolean);
begin
  frmAbout.Enabled:=Enabled;
  if Modal then ShowModal else
  begin
    Show;
    Refresh;
  end;
end;

procedure TfrmAbout.SetText(Version,Copyright,eMail,www:String);
begin
  lblVersion.Caption:=Version;
  lblCopyright.Caption:=Copyright;
  lblEMail.Caption:=eMail;
  lblEMail.Hint:='mailto:'+eMail;
  lblWWW.Caption:=www;
  lblWWW.Hint:=www;
end;

procedure TfrmAbout.SetProgressBar(Min,Max:Integer; Visible:Boolean);
begin
  pgBar.MinValue:=Min;
  pgBar.MaxValue:=Max;
  pgBar.Progress:=Min;
  pgBar.Visible:=Visible;
end;

procedure TfrmAbout.SetProgress(Value:Integer);
begin
  pgBar.Progress:=Value;
  Update;
end;

procedure TfrmAbout.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:=caFree;
end;

procedure TfrmAbout.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  ModalResult:=mrOk;
end;

procedure TfrmAbout.lblLinkClick(Sender: TObject);
begin
  ShellExecute(0, 'open', Pchar(TLabel(Sender).Hint), nil, nil, Sw_ShowNormal);
end;

procedure TfrmAbout.lblLinkMouseEnter(Sender: TObject);
begin
  TLabel(Sender).Font.Style:=[fsUnderline];
  TLabel(Sender).Font.Color:=clBlue;
end;

procedure TfrmAbout.lblLinkMouseLeave(Sender: TObject);
begin
  TLabel(Sender).Font.Style:=[];
  TLabel(Sender).Font.Color:=$B30C24;
end;

procedure TfrmAbout.MouseClick(Sender: TObject);
begin
  ModalResult:=mrOk;
end;

end.
