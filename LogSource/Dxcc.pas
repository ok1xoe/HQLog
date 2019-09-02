{$include global.inc}
unit Dxcc;

interface

uses
  SysUtils, Classes, DB, DBTables, StrUtils;

type
  TDxccList = class(TDataModule)
    qDxcc: TQuery;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  private
    { Private declarations }
    IndexAr:Array[1..38] of Integer;
    fActive:Boolean;
    //
    fOnChange:TNotifyEvent;
    //
    procedure SetActive(Value:Boolean);
    function GetDxcc:String;
    function GetPrefix:String;
    function GetName:String;
    function GetTimeOffset:Integer;
    function GetLatitude:Double;
    function GetLongitude:Double;
    function GetITU:Integer;
    function GetWAZ:Integer;
    function GetContinent:String;
  public
    { Public declarations }
    function GotoDXCC(DXCC:String):Boolean;
    function FindDXCC(const Call:String):Boolean;
    //
    property Active:Boolean read fActive write SetActive;
    //
    property DXCC:String read GetDxcc;
    property Prefix:String read GetPrefix;
    property Name:String read GetName;
    property TimeOffset:Integer read GetTimeOffset;
    property Latitude:Double read GetLatitude;
    property Longitude:Double read GetLongitude;
    property ITU:Integer read GetITU;
    property WAZ:Integer read GetWAZ;
    property Continent:String read GetContinent;
    //
    property OnChange:TNotifyEvent read fOnChange write fOnChange;
  end;

var
  DxccList: TDxccList;

implementation

uses HQLdMod, HQLDatabase, HQLResStrings;

{$R *.dfm}

const
  abStr='/0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';

//vytvoreni objektu
procedure TDxccList.DataModuleCreate(Sender: TObject);
var
  i:Integer;
begin
  fActive:=False;
  fOnChange:=nil;
  with qDxcc,SQL do
  begin
    Clear;
    Add(Format('SELECT * FROM "%0:s" ORDER BY %1:s',
      [dmLog.RootDir+'dxcc.db',dfnD_Prefix]));
    Open;
    for i:=Low(IndexAr) to High(IndexAr)-1 do
      if Locate(dfnD_Prefix,abStr[i],[loPartialKey]) then IndexAr[i]:=RecNo
                                                     else IndexAr[i]:=-1;
    IndexAr[High(IndexAr)]:=RecordCount+1;
  end;
end;

//ukonceni objektu
procedure TDxccList.DataModuleDestroy(Sender: TObject);
begin
  qDxcc.Close;
end;

procedure TDxccList.SetActive(Value:Boolean);
begin
  fActive:=Value;
  if Assigned(fOnChange) then fOnChange(Self);
end;

//vyhledani zeme
function TDxccList.GotoDXCC(DXCC:String):Boolean;
begin
  Result:=False;
  fActive:=False;
  qDxcc.DisableControls;
  try
    DXCC:=UpperCase(DXCC);
    if qDxcc.Locate(dfnD_Dxcc,DXCC,[]) then
    begin
      Result:=True;
      fActive:=True;
    end;
  finally
    qDxcc.EnableControls;
    if Assigned(fOnChange) then fOnChange(Self);
  end;
end;

//vyhledani zeme dle znacky
function TDxccList.FindDXCC(const Call:String):Boolean;
var
  i,j,mi,mc,sIndex,eIndex:Integer;
  fs:String;
begin
  Result:=False;
  fActive:=False;
  mi:=-1;
  qDxcc.DisableControls;
  try
    if Call='' then Exit;
    //Guantanamo/USA
    if StrLComp(PChar(Call), 'KG4', 3) = 0 then
      if Length(Call) = 5 then
      begin
        if qDxcc.Locate(dfnD_DXCC, 'KG4', []) then mi:=qDxcc.RecNo;
        Exit;
      end else
      begin
        if qDxcc.Locate(dfnD_DXCC, 'K', []) then mi:=qDxcc.RecNo;
        Exit;
      end;
    //index prvniho zaznamu
    fs:=UpperCase(Copy(Call,1,7));
    sIndex:=Pos(fs[1],abStr);
    if IndexAr[sIndex]=-1 then Exit;
    //index posledniho zaznamu
    eIndex:=sIndex+1;
    while (IndexAr[eIndex]=-1)and(eIndex<High(IndexAr)) do Inc(eIndex);
    //
    sIndex:=IndexAr[sIndex];
    eIndex:=IndexAr[eIndex]-1;
    mc:=0;
    qDxcc.RecNo:=eIndex;
    for i:=eIndex downto sIndex do
    begin
      if AnsiStartsStr(qDxcc.Fields.Fields[dfiD_Prefix].AsString,fs)
        then j:=Length(qDxcc.Fields.Fields[dfiD_Prefix].AsString)
        else j:=0;
      if j>mc then
      begin
        mi:=qDxcc.RecNo;
        mc:=j;
      end;
      qDxcc.Prior;
    end;
  finally
    if mi<>-1 then
    begin
      Result:=True;
      fActive:=True;
      qDxcc.RecNo:=mi;
    end;
    qDxcc.EnableControls;
    if Assigned(fOnChange) then fOnChange(Self);
  end;
end;

//dxcc
function TDxccList.GetDxcc:String;
begin
  if fActive then Result:=qDxcc.Fields.Fields[dfiD_Dxcc].AsString
             else Result:='';
end;

//prefix
function TDxccList.GetPrefix:String;
begin
  if fActive then Result:=qDxcc.Fields.Fields[dfiD_Prefix].AsString
             else Result:='';
end;

//nazev
function TDxccList.GetName:String;
begin
  if fActive then Result:=qDxcc.Fields.Fields[dfiD_Name].AsString
             else Result:='';
end;

//odchylka od UTC
function TDxccList.GetTimeOffset:Integer;
begin
  if fActive then Result:=qDxcc.Fields.Fields[dfiD_TimeDif].AsInteger
             else Result:=0;
end;

//zepisna souradnice
function TDxccList.GetLatitude:Double;
begin
  if fActive then Result:=qDxcc.Fields.Fields[dfiD_Lat].AsFloat
             else Result:=0;
end;

//zepisna souradnice
function TDxccList.GetLongitude:Double;
begin
  if fActive then Result:=qDxcc.Fields.Fields[dfiD_Long].AsFloat
             else Result:=0;
end;

//zona ITU
function TDxccList.GetITU:Integer;
begin
  if fActive then Result:=qDxcc.Fields.Fields[dfiD_ITU].AsInteger
             else Result:=0;
end;

//zona WAZ
function TDxccList.GetWAZ:Integer;
begin
  if fActive then Result:=qDxcc.Fields.Fields[dfiD_WAZ].AsInteger
             else Result:=0;
end;

//kontinent
function TDxccList.GetContinent:String;
var
  str:String;
begin
   Result:='';
   if Active then
   begin
     str:=qDxcc.Fields.Fields[5].AsString;
     if str='AF' then Result:=strAfrica else
     if str='AS' then Result:=strAsia else
     if str='EU' then Result:=strEurope else
     if str='NA' then Result:=strNorthAmerica else
     if str='OC' then Result:=strOceania else
     if str='SA' then Result:=strSouthAmerica;
   end;
end;

end.
