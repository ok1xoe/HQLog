unit Kontrola;
interface
uses
  Controls, HamLogFP, Dialogs, StdCtrls, SysUtils, 
  Classes,  HQLResStrings, Amater, cfmDialogs, cfmGeography, cfmDateUtils,
  cfmStrUtils;

  //
  procedure JeChyba(const Text:String; const FocusNa:TObject);
  function JeLoc(const Loc:String; const FocusNa:TObject):Boolean;
  function JeCas(const Cas:String; const FocusNa:TObject):Boolean;
  function JeDatum(const Dat:String; const FocusNa:TObject):Boolean;
  function JeZnacka(const Znacka:String; const FocusNa:TObject):Boolean;
  function JeZnacka2(const Znacka:String):Boolean;
  function JeDXCC(const Dxcc:String; const FocusNa:TObject):Boolean;
  function JeDXCC2(const Dxcc:String):Boolean;
  function JeFrekvence(const Frekvence:String; const FocusNa:TObject):Boolean;
  function JeFrekvence2(const Frekvence:String):Boolean;
  function JeVykon(const PWR:String; const FocusNa:TObject):Boolean;
  function JeIOTA(const IOTA:String; const FocusNa:TObject):Boolean;
  function JeIOTA2(const IOTA:String):Boolean;
  function JeITU(const ITU:String; const FocusNa:TObject):Boolean;
  function JeWAZ(const WAZ:String; const FocusNa:TObject):Boolean;
  function JeSouradDs(const D:String; const FocusNa:TObject):Boolean;
  function JeSouradDd(const D:String; const FocusNa:TObject):Boolean;
  function JeSouradMS(const MS:String; const FocusNa:TObject):Boolean;

implementation
const
  Num=['0'..'9'];
  Chr=['a'..'z','A'..'Z'];

procedure JeChyba(const Text: String; const FocusNa: TObject);
begin
  cMessageDlg(Text,mtError,[mbOk],mrOk,0);
  TCustomEdit(FocusNa).SetFocus;
end;

function JeLoc(const Loc: String; const FocusNa: TObject): Boolean;
begin
  Result:=IsWWL(Loc, True);
  if Result then Exit;
  cMessageDlg(Format(strLocNotValid,[Loc]),mtError,[mbOk],mrOk,0);
  TCustomEdit(FocusNa).SetFocus;
end;

function JeCas(const Cas: String; const FocusNa: TObject): Boolean;
begin
  Result:=IsTime(Cas);
  if Result then Exit;
  cMessageDlg(Format(strTimeNotValid,[Cas]),mtError,[mbOk],mrOk,0);
  TCustomEdit(FocusNa).SetFocus;
end;

function JeDatum(const Dat: String; const FocusNa: TObject): Boolean;
begin
  Result:=IsDate(Dat);
  if Result then Exit;
  cMessageDlg(Format(strDateNotValid,[Dat]),mtError,[mbOk],mrOk,0);
  TCustomEdit(FocusNa).SetFocus;
end;

function JeZnacka(const Znacka:String; const FocusNa:TObject):Boolean;
var
  p:PChar;
begin
  Result:=True;
  if Znacka='' then
  begin
    Result:=False;
    JeChyba(strNotCall,FocusNa);
    Exit;
  end;
  p:=Pointer(Znacka);
  while p^<>#0 do
  begin
    if not (p^ in (Num+Chr+['/'])) then
    begin
      Result:=False;
      cMessageDlg(Format(strCallNotValid,[Znacka]),mtError,[mbOk],mrOk,0);
      TCustomEdit(FocusNa).SetFocus;
      Exit;
    end;
    Inc(p);
  end;
end;

function JeZnacka2(const Znacka:String):Boolean;
var
  p:PChar;
begin
  Result:=True;
  if Znacka='' then
  begin
    Result:=False;
    Exit;
  end;
  p:=Pointer(Znacka);
  while p^<>#0 do
  begin
    if not (p^ in (Num+Chr+['/'])) then
    begin
      Result:=False;
      Break;
    end;
    Inc(p);
  end;
end;

function JeDXCC(const Dxcc:String; const FocusNa:TObject):Boolean;
var
  p:PChar;
begin
  Result:=True;
  p:=Pointer(Dxcc);
  if p=nil then Exit;
  while p^<>#0 do
  begin
    if not (p^ in (Num+Chr+['/'])) then
    begin
      Result:=False;
      JeChyba(strDxccNotValid,FocusNa);
      Break;
    end;
    Inc(p);
  end;
end;

function JeDXCC2(const Dxcc:String):Boolean;
var
  p:PChar;
begin
  Result:=True;
  p:=Pointer(Dxcc);
  if p=nil then Exit;
  while p^<>#0 do
  begin
    if not (p^ in (Num+Chr+['/'])) then
    begin
      Result:=False;
      Break;
    end;
    Inc(p);
  end;
end;

function JeFrekvence(const Frekvence:String; const FocusNa:TObject):Boolean;
var
  n:Double;
begin
  Result:=False;
  if Frekvence='' then
  begin
    JeChyba(strNotFreq,FocusNa);
    Exit;
  end;
  Result:=TryStrToFloat(Frekvence,n);
  if not Result then
  begin
    cMessageDlg(Format(strFreqNotValid,[Frekvence]),mtError,[mbOk],mrOk,0);
    TCustomEdit(FocusNa).SetFocus;
  end;
end;

function JeFrekvence2(const Frekvence:String):Boolean;
var
  n:Double;
begin
  Result:=TryStrToFloat(Frekvence,n);
end;

function JeVykon(const PWR:String; const FocusNa:TObject):Boolean;
var
  n:Double;
begin
  if PWR='' then
  begin
    Result:=False;
    JeChyba(strNotPWR,FocusNa);
    Exit;
  end;
  Result:=TryStrToFloat(PWR,n);
  if not Result then JeChyba(strPWRNotValid,FocusNa);
end;

function JeIOTA(const IOTA:String; const FocusNa:TObject):Boolean;
begin
  Result:=True;
  if IOTA='' then Exit;
  if not((IOTA[1] in Chr)and(IOTA[2] in Chr)and
         (IOTA[3] in Num)and(IOTA[4] in Num)and(IOTA[5] in Num)) then
  begin
    Result:=False;
    cMessageDlg(Format(strIOTANotValid,[IOTA]),mtError,[mbOk],mrOk,0);
    TCustomEdit(FocusNa).SetFocus;
  end;
end;

function JeIOTA2(const IOTA:String):Boolean;
begin
  Result:=True;
  if IOTA='' then Exit;
  if not((IOTA[1] in Chr)and(IOTA[2] in Chr)and
         (IOTA[3] in Num)and(IOTA[4] in Num)and(IOTA[5] in Num)) then Result:=False;
end;

function JeITU(const ITU:String; const FocusNa:TObject):Boolean;
var
  i:Integer;
begin
  Result:=TryStrToInt(ITU,i)and(i>=0)or(i<=90);
  if not Result then
  begin
    cMessageDlg(Format(strITUNotValid,[ITU]),mtError,[mbOk],mrOk,0);
    TCustomEdit(FocusNa).SetFocus;
  end;
end;

function JeWAZ(const WAZ:String; const FocusNa:TObject):Boolean;
var
  i:Integer;
begin
  Result:=TryStrToInt(WAZ,i)and(i>=0)or(i<=40);
  if not Result then
  begin
    cMessageDlg(Format(strWAZNotValid,[WAZ]),mtError,[mbOk],mrOk,0);
    TCustomEdit(FocusNa).SetFocus;
  end;
end;

function JeSouradDs(const D:String; const FocusNa:TObject):Boolean;
var
  i:Integer;
begin
  Result:=TryStrToInt(D,i);
  if not Result then
  begin
    JeChyba(strMRefNotValid,FocusNa);
    Exit;
  end;
  if not(i in [0..89]) then
  begin
    Result:=False;
    JeChyba(strMRefDSLimit,FocusNa);
  end;
end;

function JeSouradDd(const D:String; const FocusNa:TObject):Boolean;
var
  i:Integer;
begin
  Result:=TryStrToInt(D,i);
  if not Result then
  begin
    JeChyba(strMRefNotValid,FocusNa);
    Exit;
  end;
  if not(i in [0..179]) then
  begin
    Result:=False;
    JeChyba(strMRefDDLimit,FocusNa);
  end;
end;

function JeSouradMS(const MS:String; const FocusNa:TObject):Boolean;
var
  i:Integer;
begin
  Result:=TryStrToInt(MS,i);
  if not Result then
  begin
    JeChyba(strMRefNotValid,FocusNa);
    Exit;
  end;
  if not(i in [0..59]) then
  begin
    Result:=False;
    JeChyba(strMRefMSLimit,FocusNa);
  end;
end;

end.
