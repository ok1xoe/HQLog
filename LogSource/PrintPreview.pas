{$include global.inc}
unit PrintPreview;

interface

uses
  Windows, Controls, ComCtrls, Classes, ActnList, Messages,
  XPStyleActnCtrls, ActnMan, RpDefine, RpRender, RpRenderCanvas,
  RpRenderPreview, Forms, ToolWin, SysUtils, HQLResStrings, HQLConsts;

type
  TfrmNahled = class(TForm)
    ScrollBox: TScrollBox;
    RvPreview: TRvRenderPreview;
    ActionManager: TActionManager;
    actPrior: TAction;
    actNext: TAction;
    actZoomIn: TAction;
    actZoomOut: TAction;
    actZavrit: TAction;
    StatusBar: TStatusBar;
    actFirst: TAction;
    actLast: TAction;
    tlBar: TToolBar;
    tlBtnFirst: TToolButton;
    tlBtnPrior: TToolButton;
    tlBtnNext: TToolButton;
    tlBtnLast: TToolButton;
    ToolButton5: TToolButton;
    tlBtnZoomIn: TToolButton;
    tlBtnZoomOut: TToolButton;
    ToolButton8: TToolButton;
    tlBtnClose: TToolButton;
    procedure actStranaExecute(Sender: TObject);
    procedure actZoomExecute(Sender: TObject);
    procedure RvPreviewPageChange(Sender: TObject);
    procedure actZavritExecute(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure OnSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;
  public
    { Public declarations }
  end;

var
  frmNahled: TfrmNahled;

implementation

uses Main, HQLdMod;

{$R *.dfm}

//vytvoreni formulare
procedure TfrmNahled.FormCreate(Sender: TObject);
begin
  ScrollBox.DoubleBuffered:=True;
end;

procedure TfrmNahled.OnSysCommand(var Msg: TWMSysCommand);
begin
  if Msg.CmdType=SC_MINIMIZE then ShowWindow(Application.Handle,SW_SHOWMINNOACTIVE)
                             else inherited;
end;

//
procedure TfrmNahled.actStranaExecute(Sender: TObject);
begin
  if Sender=actFirst then
  begin
    RvPreview.CurrentPage:=1;
    RvPreview.RedrawPage;
  end;
  if Sender=actPrior then RvPreview.PrevPage;
  if Sender=actNext then RvPreview.NextPage;
  if Sender=actLast then
  begin
    RvPreview.CurrentPage:=RvPreview.Pages;
    RvPreview.RedrawPage;
  end;
end;

//
procedure TfrmNahled.actZoomExecute(Sender: TObject);
begin
  if Sender=actZoomIn then RvPreview.ZoomIn;
  if Sender=actZoomOut then RvPreview.ZoomOut;
end;

//
procedure TfrmNahled.RvPreviewPageChange(Sender: TObject);
begin
  StatusBar.Panels[0].Text:=Format('Strana %-3d z %3d',[RvPreview.CurrentPage,RvPreview.Pages]);
  if RvPreview.CurrentPage=1 then
  begin
    actPrior.Enabled:=False;
    actFirst.Enabled:=False;
  end else
  begin
    actPrior.Enabled:=True;
    actFirst.Enabled:=True;
  end;
  if RvPreview.CurrentPage=RvPreview.Pages then
  begin
    actNext.Enabled:=False;
    actLast.Enabled:=False;
  end else
  begin
    actNext.Enabled:=True;
    actLast.Enabled:=True;
  end;
end;

//
procedure TfrmNahled.actZavritExecute(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

//
procedure TfrmNahled.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (RvPreview.CurrentPage<>1)and(Key=vk_Up) then RvPreview.PrevPage;
  if (RvPreview.CurrentPage<>RvPreview.Pages)and(Key=vk_Down) then RvPreview.NextPage;
end;

end.
