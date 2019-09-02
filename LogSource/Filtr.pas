{$include global.inc}
unit Filtr;

interface

uses
  Windows, Classes, ActnList, XPStyleActnCtrls, ActnMan, Messages,
  StdCtrls, Controls, Grids, ValEdit, Forms, Dialogs, SysUtils,
  HQLResStrings, ExtCtrls, Amater, cfmDialogs, HQLDatabase, HQLConsts;

type
  TfrmFilter = class(TForm)
    vedtFiltr: TValueListEditor;
    btnPouzit: TButton;
    btnZavrit: TButton;
    grpBoxFiltr: TGroupBox;
    cbBoxPole: TComboBox;
    cbBoxOp: TComboBox;
    btnAdd: TButton;
    actManager: TActionManager;
    actSmazat: TAction;
    actZavrit: TAction;
    actPridat: TAction;
    actPouzit: TAction;
    btnVypnout: TButton;
    actVypnout: TAction;
    edtHod: TComboBox;
    lblInfo1: TLabel;
    lblInfo2: TLabel;
    btnDel: TButton;
    btnNapoveda: TButton;
    bvlCara: TBevel;
    actHelp: TAction;
    //
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    //
    procedure actHelpExecute(Sender: TObject);
    procedure actPridatExecute(Sender: TObject);
    procedure actSmazatExecute(Sender: TObject);
    procedure cbBoxPoleSelect(Sender: TObject);
    procedure actZavritExecute(Sender: TObject);
    procedure actPouzitExecute(Sender: TObject);
    procedure actVypnoutExecute(Sender: TObject);
    procedure vedtFiltrKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
    veS:TStrings;
    //
    procedure OnSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;
  public
    { Public declarations }
    Filtr:TStrings;
  end;

var
  frmFilter: TfrmFilter;

implementation

uses HamLogFP, Main, KeyFilters, HQLdMod;

{$R *.dfm}

const
  FltFields:Array[0..19] of Integer=(
    dfiL_Call,dfiL_Band,dfiL_Mode,dfiL_LOCo,dfiL_LOCp,
    dfiL_Note,dfiL_DXCC,dfiL_IOTA,dfiL_ITU,dfiL_WAZ,dfiL_Award,
    dfiL_QSLo,dfiL_QSLp,dfiL_QSLvia,dfiL_EQSLp,dfiL_Date,
    dfiL_Freq,dfiL_Name,dfiL_QTH,dfiL_PWR);

//------------------------------------------------------------------------------
//frmFilter
//------------------------------------------------------------------------------

//pri vytvoreni
procedure TfrmFilter.FormCreate(Sender: TObject);
var
  i:Integer;
begin
  Filtr:=TStringList.Create;
  cbBoxPole.Clear;
  for i:=Low(FltFields) to High(FltFields) do
    cbBoxPole.Items.Add(dfL_Caption[FltFields[i]]);
  cbBoxPole.ItemIndex:=0;
end;

//pri uvolneni z mapeti
procedure TfrmFilter.FormDestroy(Sender: TObject);
begin
  Filtr.Free;
end;

//pri otevreni
procedure TfrmFilter.FormShow(Sender: TObject);
begin
  veS:=TStringList.Create;
  veS.Assign(vedtFiltr.Strings);
end;

//pri zavreni
procedure TfrmFilter.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if ModalResult=mrCancel then
    vedtFiltr.Strings.Assign(veS);
  veS.Free;
end;

//filtr klaves
procedure TfrmFilter.FormKeyPress(Sender: TObject; var Key: Char);
var
  fText:String;
  fSelStart:Integer;
begin
  case FltFields[cbBoxPole.ItemIndex] of
    //filtr znacky,DXCC
    dfiL_Call,dfiL_DXCC: FilterCall(Key,['*']);
    //filtr frekvence, vykonu
    dfiL_Freq,dfiL_PWR: FilterFloat(Key);
    //filtr data
    dfiL_Date: with TComboBox(Sender) do
    begin
      fText:=Text;
      fSelStart:=SelStart;
      FilterDate(Key,fText,fSelStart);
      Text:=fText;
      SelStart:=fSelStart;
    end;
    //lokatory
    dfiL_LOCo,dfiL_LOCp: FilterLocator(Key,TComboBox(Sender).SelStart,['*']);
    //IOTA
    dfiL_IOTA: FilterIOTA(Key,TComboBox(Sender).SelStart,['*']);
    //ITU,WAZ
    dfiL_ITU,dfiL_WAZ: FilterNumber(Key);
    //diplom
    dfiL_Award: FilterAward(Key,['*']);
  else
    if Key=#13 then Key:=#0;
  end;
end;

//
procedure TfrmFilter.OnSysCommand(var Msg: TWMSysCommand);
begin
  if Msg.CmdType=SC_MINIMIZE then ShowWindow(Application.Handle,SW_SHOWMINNOACTIVE)
                             else inherited;
end;

//------------------------------------------------------------------------------

//help
procedure TfrmFilter.actHelpExecute(Sender: TObject);
begin
  Application.HelpJump(Name);
end;

//pridat filtr
procedure TfrmFilter.actPridatExecute(Sender: TObject);
var
  i:Integer;

 //kam vlozit?
 function GetKeyIndex(Key,Operator:String):Integer;
 var
   i:Integer;
   StejnyO:Boolean;
   Op:String;
 begin
   Result:=-1;
   if vedtFiltr.Strings.Count=0 then Exit;
   StejnyO:=False;
   for i:=0 to vedtFiltr.Strings.Count-1 do
     if (Pos(Key,vedtFiltr.Cells[0,i+1])<>0) then
     begin
       Op:=Copy(vEdtFiltr.Cells[1,i+1],1,Pos('"',vEdtFiltr.Cells[1,i+1])-2);
       if not((Op<>Operator)and(StejnyO)) then Result:=i+1;
       if Op=Operator then StejnyO:=True;
     end;
 end;

begin
  //
  if Filtr.Count=50 then
  begin
    cMessageDlg(strFilterLimit,mtInformation,[mbOk],mrOk,0);
    Exit;
  end;
  if fltFields[cbBoxPole.ItemIndex]=dfiL_Date then
    try
      edtHod.Text:=FormatDateTime(DateLFormat,StrToDate(edtHod.Text));
    except
      cMessageDlg('Chybné datum!',mtError,[mbOk],mrOk,0);
      edtHod.SetFocus;
      Exit;
    end;
  //vyhledat podobnou podminku
  i:=GetKeyIndex(cbBoxPole.Text,cbBoxOp.Text);
  if i=-1 then
  begin
    vEdtFiltr.InsertRow(cbBoxPole.Text,cbBoxOp.Text+' "'+edtHod.Text+'"',True);
    vEdtFiltr.Row:=vEdtFiltr.RowCount-1;
  end else
  begin
    if i+1=vEdtFiltr.RowCount then vEdtFiltr.Row:=i else vEdtFiltr.Row:=i+1;
    vEdtFiltr.InsertRow(cbBoxPole.Text,cbBoxOp.Text+' "'+edtHod.Text+'"',
                        (vEdtFiltr.Row=vEdtFiltr.RowCount-1)and(i=vEdtFiltr.RowCount-1));
    vEdtFiltr.Row:=i+1;
  end;
  edtHod.Text:='';
  edtHod.SetFocus;
end;

//smazat filtr
procedure TfrmFilter.actSmazatExecute(Sender: TObject);
var
  row:Integer;
begin
  if vEdtFiltr.Strings.Count=0 then Exit;
  row:=vedtFiltr.Row;
  vedtFiltr.DeleteRow(Row);
end;

//pri zmene vyberu pole
procedure TfrmFilter.cbBoxPoleSelect(Sender: TObject);
begin
  edtHod.Clear;
  with cbBoxOp, cbBoxOp.Items do
    case FltFields[cbBoxPole.ItemIndex] of
      dfiL_Call, dfiL_LOCo, dfiL_LOCp, dfiL_Note, dfiL_DXCC, dfiL_IOTA, dfiL_ITU, dfiL_WAZ,
      dfiL_Name, dfiL_QTH, dfiL_QSLvia, dfiL_Award: begin
        SetCbBoxItems(cbBoxOp, ['=', '<>']);
        SetCbBoxItems(edtHod, []);
        edtHod.Style:=csSimple;
      end;
      dfiL_Band:begin
        SetCbBoxItems(cbBoxOp, ['=', '<>', '>', '>=', '<', '<=']);
        SetCbBoxItems(edtHod, hBandName, Low(THamMode),  High(THamMode) - 1);
        edtHod.Style:=csDropDownList;
      end;
      dfiL_Freq: begin
        SetCbBoxItems(cbBoxOp, ['=', '<>', '>', '>=', '<', '<=']);
        SetCbBoxItemsF(edtHod, hBandBegin, Low(hBandBegin), High(hBandBegin)-1);
        edtHod.Style:=csDropDown;
      end;
      dfiL_PWR,dfiL_Date: begin
        SetCbBoxItems(cbBoxOp, ['=','<>','>','>=','<','<=']);
        SetCbBoxItems(edtHod, []);
        edtHod.Style:=csSimple;
      end;
      dfiL_Mode: begin
        SetCbBoxItems(cbBoxOp, ['=', '<>']);
        SetCbBoxItems(edtHod, hModeName, Low(hModeName) + 1, High(hModeName));
        edtHod.Style:=csDropDownList;
      end;
      dfiL_QSLo: begin
        SetCbBoxItems(cbBoxOp,['=', '<>']);
        SetCbBoxItems(edtHod,hQSLoNames);
        edtHod.Style:=csDropDownList;
      end;
      dfiL_QSLp: begin
        SetCbBoxItems(cbBoxOp, ['=', '<>']);
        SetCbBoxItems(edtHod,hQSLpNames);
        edtHod.Style:=csDropDownList;
      end;
      dfiL_EQSLp: begin
        SetCbBoxItems(cbBoxOp, ['=', '<>']);
        SetCbBoxItems(edtHod,hEQSLNames);
        edtHod.Style:=csDropDownList;
      end;
    end;
end;

//zavrit
procedure TfrmFilter.actZavritExecute(Sender: TObject);
begin
  ModalResult:=mrCancel;
end;

//ok
procedure TfrmFilter.actPouzitExecute(Sender: TObject);
var
  i:Integer;
  f,Str,Key,sKey,Op,sOp:String;

 function GetArrayIndex(Text:String; Data:Array of PChar):Byte;
 var
   i:Integer;
 begin
   Result:=0;
   for i:=Low(Data) to High(Data) do
     if '"'+Data[i]+'"'=Text then
     begin
       Result:=i;
       Exit;
     end;
 end;

 //uprava dat
 function GetData(const Index:Byte;var Key,Op:String):String;
 var
   i,iPole:Integer;
   Pole,Operator,Hodnota:String;
 begin
   iPole:=FltFields[cbBoxPole.Items.IndexOf(vEdtFiltr.Cells[0,Index+1])];
   Pole:=dfL_Name[iPole];
   i:=Pos('"',vEdtFiltr.Cells[1,Index+1]);
   Operator:=Copy(vEdtFiltr.Cells[1,Index+1],1,i-2);
   Hodnota:=Copy(vEdtFiltr.Cells[1,Index+1],i,Length(vEdtFiltr.Cells[1,Index+1])-i+1);
   //nahradit * za %
   for i:=1 to Length(Hodnota) do
     if Hodnota[i]='*' then Hodnota[i]:='%';
   if iPole=dfiL_Band then
     Hodnota:=IntToStr(GetArrayIndex(Hodnota,hBandName));
   if iPole=dfiL_Mode then
     Hodnota:=IntToStr(GetArrayIndex(Hodnota,hModeName));
   if iPole=dfiL_QSLo then
     Hodnota:=IntToStr(GetArrayIndex(Hodnota,hQSLoNames));
   if iPole=dfiL_QSLp then
     Hodnota:=IntToStr(GetArrayIndex(Hodnota,hQSLpNames));
   if iPole=dfiL_EQSLp then
     Hodnota:=IntToStr(GetArrayIndex(Hodnota,hEQSLNames));
   //nahradit = a <> za LIKE a NOT LIKE
   if (iPole in [dfiL_Call,dfiL_LOCo,dfiL_LOCp,dfiL_QSLvia,dfiL_Note,dfiL_DXCC,
                 dfiL_IOTA,dfiL_Name,dfiL_QTH,dfiL_Award])and(Hodnota <> '""') then
     if Operator='=' then Operator:='LIKE' else Operator:='NOT LIKE';
   //case sensitive
   if not(iPole in [dfiL_Band,dfiL_Mode,dfiL_QSLo,dfiL_QSLp,dfiL_EQSLp,dfiL_Freq,
                    dfiL_Date,dfiL_PWR,dfiL_ITU,dfiL_WAZ])
     then Result:='(UPPER('+Pole+') '+Operator+' '+UpperCase(Hodnota)+')'
     else Result:='('+Pole+' '+Operator+' '+Hodnota+')';
   Key:=Pole;
   Op:=Operator;
 end;

begin
  //
  Filtr.Clear;
  if vEdtFiltr.Strings.Count=0 then
  begin
    ModalResult:=mrAbort;
    Exit;
  end;
  //vygenerovat filtr
  i:=0;
  f:='('+GetData(i,sKey,sOp);
  if vEdtFiltr.Strings.Count>1 then
    for i:=1 to vEdtFiltr.Strings.Count-1 do
    begin
      Str:=GetData(i,Key,Op);
      if (Key=sKey)and(Op=sOp)and(Op='LIKE') then f:=f+'OR'+str else
      begin
        f:=f+')';
        Filtr.Add(f);
        f:='AND('+Str;
        sKey:=Key;sOp:=Op
      end;
    end;
  f:=f+')';
  Filtr.Add(f);
  ModalResult:=mrOk;
end;

//vypnout
procedure TfrmFilter.actVypnoutExecute(Sender: TObject);
begin
  ModalResult:=mrAbort;
end;

procedure TfrmFilter.vedtFiltrKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key=vk_delete then actSmazatExecute(actSmazat);
end;

end.
