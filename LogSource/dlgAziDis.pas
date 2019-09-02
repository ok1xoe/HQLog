{$include global.inc}
unit dlgAziDis;

interface

uses
   Windows, Classes, ActnList, XPStyleActnCtrls, ActnMan, StdCtrls,
   Controls, ExtCtrls, Forms, SysUtils, ComCtrls, Dialogs,
   Messages, HQLResStrings, HQLConsts, cfmGeography;

type
  TfrmAziDis = class(TForm)
    pgControl: TPageControl;
    tbShtVzdal: TTabSheet;
    grpBoxVstupAziDis: TGroupBox;
    lblLocCil: TLabel;
    lblLocVych: TLabel;
    cbBoxLoc: TComboBox;
    cbBoxLocVl: TComboBox;
    grpBoxVysledekAziDis: TGroupBox;
    lblVzdalT: TLabel;
    lblAziT: TLabel;
    lblVzdal: TLabel;
    lblAzi: TLabel;
    actManager: TActionManager;
    actVzdal: TAction;
    actZavrit: TAction;
    pgShtSourLoc: TTabSheet;
    btnVypocet: TButton;
    btnZavrit: TButton;
    pgShtLocSour: TTabSheet;
    grpBoxVstupLocSour: TGroupBox;
    lblLocN: TLabel;
    cbBoxLoc1: TComboBox;
    grpBoxVysledekLocSour: TGroupBox;
    lblDelkaN: TLabel;
    lblDelka: TLabel;
    lblSirka: TLabel;
    lblSirkaN: TLabel;
    grpBoxVstupSourLoc: TGroupBox;
    grpBoxVysledekSourLoc: TGroupBox;
    lblSirkaVstup: TLabel;
    lblDelkaVstup: TLabel;
    lblLocResN: TLabel;
    lblLocRes: TLabel;
    pnlSouradnice1: TPanel;
    edtD1: TEdit;
    edtM1: TEdit;
    edtS1: TEdit;
    edtO1: TEdit;
    pnlSouradnice2: TPanel;
    edtD2: TEdit;
    edtM2: TEdit;
    edtS2: TEdit;
    edtO2: TEdit;
    procedure FormCreate(Sender: TObject);
    procedure LocKeyPress(Sender: TObject; var Key: Char);
    procedure actVypocetExecute(Sender: TObject);
    procedure actZavritExecute(Sender: TObject);
    procedure AddLoc(Sender: TObject);
    procedure LocChange(Sender: TObject);
    procedure pgControlChange(Sender: TObject);
    procedure edtSourKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edtSourChange(Sender: TObject);
    procedure edtOKeyPress(Sender: TObject; var Key: Char);
    procedure edtDMSKeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
    procedure OnSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;
  public
    { Public declarations }
  end;

var
  frmAziDis: TfrmAziDis;

implementation

uses AziDis, Kontrola, HamLogFp, Main, HQLdMod;

{$R *.dfm}

//start
procedure TfrmAziDis.FormCreate(Sender: TObject);
begin
  //vycistit napisy
  lblAzi.Caption:='';
  lblVzdal.Caption:='';
  lblSirka.Caption:='';
  lblDelka.Caption:='';
  lblLocRes.Caption:='';
  cbBoxLocVl.Text:=dmLog.User.Loc;
  AddLoc(cbBoxLocVl);
end;

procedure TfrmAziDis.OnSysCommand(var Msg: TWMSysCommand);
begin
  if Msg.CmdType=SC_MINIMIZE then ShowWindow(Application.Handle,SW_SHOWMINNOACTIVE)
                             else inherited;
end;

//zavrit
procedure TfrmAziDis.actZavritExecute(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

//vypocet
procedure TfrmAziDis.actVypocetExecute(Sender: TObject);
var
  x, y: Single;
begin
  case pgControl.ActivePageIndex of
    //vzdalenost, azimut
    0:
    begin
      if (IsWWL(cbBoxLocVl.Text))and(IsWWL(cbBoxLoc.Text)) then
      begin
        with cbBoxLoc do
          if Items.IndexOf(Text)=-1 then Items.Append(Text);
        lblVzdal.Caption:=Format('%d km',[GetDistance(cbBoxLocVl.Text,cbBoxLoc.Text,0,0)]);
        lblAzi.Caption:=Format('%d°',[GetAzimuth(cbBoxLocVl.Text,cbBoxLoc.Text,0,0)]);
        cbBoxLoc.SetFocus;
        cbBoxLoc.SelectAll;
      end else
      begin
        //vycistit napisy
        lblAzi.Caption:='';
        lblVzdal.Caption:='';
      end;
    end;
    //souradnice -> LOC
    1:
    begin
      if (JeSouradDs(edtD1.Text,edtD1))and(JeSouradMS(edtM1.Text,edtM1))and
         (JeSouradMS(edtS1.Text,edtS1))and
         (JeSouradDd(edtD2.Text,edtD2))and(JeSouradMS(edtM2.Text,edtM2))and
         (JeSouradMS(edtS2.Text,edtS2)) then
      begin
        y:=StrToInt(edtD1.Text)+StrToInt(edtM1.Text)/60+StrToInt(edtS1.Text)/3600;
        x:=StrToInt(edtD2.Text)+StrToInt(edtM2.Text)/60+StrToInt(edtS2.Text)/3600;
        if edtO1.Text='J' then y:=-1*y;
        if edtO2.Text='Z' then x:=-1*x;
        lblLocRes.Caption:=Coord2WWL(x, y);
        edtD1.SetFocus;
        edtD1.SelectAll;
      end else lblLocRes.Caption:='';
    end;
    //LOC -> souradnice
    2:
    begin
      if IsWWL(cbBoxLoc1.Text) then
      begin
        WWL2Coord(cbBoxLoc1.Text, x, y);
        lblDelka.Caption:=FormatDeg(x,False);
        lblSirka.Caption:=FormatDeg(y,True);
        AddLoc(cbBoxLoc1);
        cbBoxLoc1.SetFocus;
        cbBoxLoc1.SelectAll;
      end else lblLocRes.Caption:='';
    end;
  end;
end;

//filtr lokatoru
procedure TfrmAziDis.LocKeyPress(Sender: TObject; var Key: Char);
const
  Cisla=['0'..'9'];
  Pismena=['a'..'z','A'..'Z'];
begin
  with TComboBox(sender) do
  begin
    if Key=' ' then DroppedDown:=not DroppedDown
               else DroppedDown:=False;
    if not(((SelStart in [0,1,4,5])and(Key in Pismena))or
           ((SelStart in [2,3])and(Key in Cisla))or
            (Key in [#8,#13])) then Key:=#0;
    if Key=#13 then actVypocetExecute(Sender);
  end;
end;

//pridani lokatoru do seznamu
procedure TfrmAziDis.AddLoc(Sender: TObject);
begin
  with TComboBox(Sender) do
    if (IsWWL(Text))and(Items.IndexOf(Text) = -1) then
      Items.Append(Text);
end;

//pri zmene lokatoru
procedure TfrmAziDis.LocChange(Sender: TObject);
begin
  if lblVzdal.Caption='' then Exit;
  //vycistit napisy
  lblAzi.Caption:='';
  lblVzdal.Caption:='';
end;

//nastaveni aktivniho prvku
procedure TfrmAziDis.pgControlChange(Sender: TObject);
begin
  case pgControl.ActivePageIndex of
    0: cbBoxLoc.SetFocus;
    1: edtD1.SetFocus;
    2: cbBoxLoc1.SetFocus;
  end;
end;

//pohyb v souradnicich
procedure TfrmAziDis.edtSourKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key=vk_Right)and(TEdit(Sender).SelLength<>0) then
  begin
    TEdit(Sender).SelStart:=0;
    Key:=0;
  end;
  if (Key=vk_Right)and(TEdit(Sender).SelStart=Length(TEdit(Sender).Text))or
     (Key=vk_Return)and(TEdit(Sender).Text<>'') then
       SelectNext(TWinControl(Sender),True,True);
  if (Key=vk_Left)and(TEdit(Sender).SelStart=0)and(Sender<>edtD1) then
       SelectNext(TWinControl(Sender),False,True);
end;

procedure TfrmAziDis.edtSourChange(Sender: TObject);
begin
  if Length(TEdit(Sender).Text)=TEdit(Sender).MaxLength then
    SelectNext(TWinControl(Sender),True,True);
end;

//filtr pro souradnice
procedure TfrmAziDis.edtOKeyPress(Sender: TObject; var Key: Char);
begin
  if (Sender=edtO1)and(not(Key in ['s','j','S','J',#8])) then Key:=#0;
  if (Sender=edtO2)and(not(Key in ['v','z','V','Z',#8])) then Key:=#0;
end;

procedure TfrmAziDis.edtDMSKeyPress(Sender: TObject; var Key: Char);
begin
  if not(Key in ['0'..'9',#8]) then Key:=#0;
end;

end.
