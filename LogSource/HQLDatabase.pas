unit HQLDatabase;

interface

uses Windows, Classes, SysUtils, DB, DBTables;

const
  BDEAlias = 'HQLog';
//----------------------------------------------------------------------------
//log
//----------------------------------------------------------------------------
  //nazvy a indexy
  dfiL_Index=0;   dfnL_Index='ID';
  dfiL_Date=1;    dfnL_Date='DAT';
  dfiL_Time=2;    dfnL_Time='UTC';
  dfiL_Call=3;    dfnL_Call='CALL';
  dfiL_Freq=4;    dfnL_Freq='FREQ';
  dfiL_Band=5;    dfnL_Band='BAND';
  dfiL_Mode=6;    dfnL_Mode='MODE';
  dfiL_RSTo=7;    dfnL_RSTo='RSTO';
  dfiL_RSTp=8;    dfnL_RSTp='RSTP';
  dfiL_Name=9;    dfnL_Name='NAME';
  dfiL_QTH=10;    dfnL_QTH='QTH';
  dfiL_LOCo=11;   dfnL_LOCo='LOCO';
  dfiL_LOCp=12;   dfnL_LOCp='LOCP';
  dfiL_QSLo=13;   dfnL_QSLo='QSLO';
  dfiL_QSLp=14;   dfnL_QSLp='QSLP';
  dfiL_QSLvia=15; dfnL_QSLvia='QSLVIA';
  dfiL_EQSLp=16;  dfnL_EQSLp='EQSLP';
  dfiL_Note=17;   dfnL_Note='NOTE';
  dfiL_PWR=18;    dfnL_PWR='PWR';
  dfiL_QRB=19;    dfnL_QRB='QRB';
  dfiL_DXCC=20;   dfnL_DXCC='DXCC';
  dfiL_IOTA=21;   dfnL_IOTA='IOTA';
  dfiL_ITU=22;    dfnL_ITU='ITU';
  dfiL_WAZ=23;    dfnL_WAZ='WAZ';
  dfiL_Award=24;  dfnL_Award='AWARD';
  dfL_Name:Array [0..24] of String=(
    dfnL_Index,dfnL_Date,dfnL_Time,dfnL_Call,dfnL_Freq,
    dfnL_Band,dfnL_Mode,dfnL_RSTo,dfnL_RSTp,dfnL_Name,
    dfnL_QTH,dfnL_LOCo,dfnL_LOCp,dfnL_QSLo,dfnL_QSLp,
    dfnL_QSLvia,dfnL_EQSLp,dfnL_Note,dfnL_PWR,dfnL_QRB,
    dfnL_DXCC,dfnL_IOTA,dfnL_ITU,dfnL_WAZ,dfnL_Award);
  //datovy typ
  dfL_Type:Array[0..24] of TFieldType=(
    ftAutoInc,ftDate,ftTime,ftString,ftFloat,
    ftSmallInt,ftSmallInt,ftString,ftString,ftString,
    ftString,ftString,ftString,ftSmallInt,ftSmallInt,
    ftString,ftSmallInt,ftString,ftFloat,ftFloat,
    ftString,ftString,ftSmallInt,ftSmallInt,ftString);
  //velikost
  dfL_Size:Array[0..24] of Integer=(
    0,0,0,15,0,
    0,0,3,3,12,
    20,6,6,0,0,
    15,0,50,0,0,
    7,5,0,0,12);
  dfL_Caption:Array [0..24] of String=(
    'ID','Datum','Èas','Znaèka','MHz',
    'Pásmo','Mód','RSTo','RSTp','Jméno',
    'QTH','LOCo','LOCp','QSLo','QSLp',
    'QSLvia','eQSL','Poznámka','PWR','QRB',
    'DXCC','IOTA','ITU','WAZ','Diplom');
  dfL_CaptionAl:Array[0..24] of TAlignment=(
    taCenter,taCenter,taCenter,taCenter,taRightJustify,
    taCenter,taCenter,taCenter,taCenter,taCenter,
    taCenter,taCenter,taCenter,taCenter,taCenter,
    taCenter,taCenter,taCenter,taCenter,taCenter,
    taCenter,taCenter,taCenter,taCenter,taCenter);
  dfL_TextAl:Array[0..24] of TAlignment=(
    taLeftJustify,taCenter,taCenter,taLeftJustify,taRightJustify,
    taRightJustify,taCenter,taCenter,taCenter,taLeftJustify,
    taLeftJustify,taCenter,taCenter,taCenter,taCenter,
    taLeftJustify,taCenter,taLeftJustify,taRightJustify,taRightJustify,
    taLeftJustify,taCenter,taCenter,taCenter,taLeftJustify);
  dfL_Width:Array[0..24,0..3] of Integer=(
    (30,30,30,30),(75,80,80,80),(40,45,45,45),(115,135,135,135),(45,50,50,50),
    (40,40,40,40),(45,50,50,60),(40,40,40,40),(40,40,40,40),(90,125,125,125),
    (90,125,125,160),(50,60,60,60),(50,60,60,60),(35,35,35,35),(35,35,35,35),
    (90,90,90,90),(35,35,35,35),(90,90,125,220),(35,35,35,35),(45,45,45,45),
    (45,45,45,45),(40,40,40,40),(30,30,30,30),(30,30,30,30),(65,70,70,70));
  dfL_Visible:Array[0..24,0..3] of Integer=(
    (0,0,0,0),(1,1,1,1),(1,1,1,1),(1,1,1,1),(1,1,1,1),
    (0,0,0,0),(1,1,1,1),(1,1,1,1),(1,1,1,1),(1,1,1,1),
    (1,1,1,1),(0,0,0,0),(1,1,1,1),(1,1,1,1),(1,1,1,1),
    (0,0,0,0),(0,0,0,0),(0,0,1,1),(0,0,0,0),(1,1,1,1),
    (0,0,0,0),(0,1,1,1),(0,1,1,1),(0,1,1,1),(0,0,0,0));
  dfL_Index:Array[0..24] of Integer=(
    0,0,1,2,3,
    4,5,6,7,8,
    9,10,11,17,18,
    19,20,21,22,12,
    13,14,15,16,23);

//------------------------------------------------------------------------------
//DXCC
//------------------------------------------------------------------------------
  dfiD_Prefix=0;  dfnD_Prefix='PREFIX';
  dfiD_Dxcc=1;    dfnD_Dxcc='DXCC';
  dfiD_Name=2;    dfnD_Name='NAME';
  dfiD_Long=3;    dfnD_Long='LONGITUDE';
  dfiD_Lat=4;     dfnD_Lat='LATITUDE';
  dfiD_Cont=5;    dfnD_Cont='CONT';
  dfiD_TimeDif=6; dfnD_TimeDif='UTC';
  dfiD_ITU=7;     dfnD_ITU='ITU';
  dfiD_WAZ=8;     dfnD_WAZ='WAZ';
  //
  dfD_Name:Array [0..8] of String=(
    dfnD_Prefix,dfnD_Dxcc,dfnD_Name,dfnD_Long,dfnD_Lat,
    dfnD_Cont,dfnD_TimeDif,dfnD_ITU,dfnD_WAZ);
  //
  dfD_Caption:Array[0..8] of String=(
    'DXCC','Prefix','Název','Zem. délka','Zem. šíøka',
    'Kontinent','UTC','ITU','WAZ');
  //
  dfD_Width:Array[0..8] of Integer=
    (60,80,160,60,60,65,30,30,30);

//------------------------------------------------------------------------------
//IOTA
//------------------------------------------------------------------------------
  dfiI_IOTA=0;   dfnI_IOTA='IOTA';
  dfiI_Prefix=1; dfnI_Prefix='PREFIX';
  dfiI_Name=2;   dfnI_Name='NAZEV';
  //
  dfI_Name:Array [0..2] of String=(
    dfnI_IOTA,dfnI_Prefix,dfnI_Name);
  //
  dfI_Caption:Array[0..2] of String=(
    'IOTA','Prefix','Název');
  dfI_Width:Array[0..2] of Integer=(
    85,85,450);

//------------------------------------------------------------------------------

  function CheckBDE:Boolean;
  function CheckFields(DataSet: TDataSet; const Names: Array of String): Boolean;
  procedure CreateLogDB(const FileName:String); overload;
  procedure CreateLogDB(Table:TTable); overload;

//------------------------------------------------------------------------------

implementation

//kontrola pritomnosti BDE
function CheckBDE: Boolean;
const
  Key = 'SOFTWARE\BORLAND\DATABASE ENGINE';
var
  KeyHandle: HKEY;
  Index, ErrCode: Integer;
  ValueLen, DataLen, ValueType: DWORD;
  ValueName, Data: String;
begin
  Result:=False;
  if RegOpenKeyEx(HKEY_LOCAL_MACHINE, Key, 0, KEY_READ,KeyHandle) <> ERROR_SUCCESS then Exit;
  try
    Index:=0;
    repeat
      ValueLen:=256;
      DataLen:=256;
      SetLength(ValueName, ValueLen);
      SetLength(Data, DataLen);
      ErrCode:=RegEnumValue(
        KeyHandle,
        Index,
        PChar(ValueName),
        {$IFDEF DELPHI_4_OR_HIGHER}
        Cardinal(ValueLen),
        {$ELSE}
        ValueLen,
        {$ENDIF}
        nil,
        @ValueType,
        PByte(PChar(Data)),
        @DataLen);
      if ErrCode = ERROR_SUCCESS then
      begin
        SetLength(ValueName, ValueLen);
        SetLength(Data, DataLen);
        if (ValueName = 'CONFIGFILE01')and(Data <> '') then Result:=True;
        Inc(Index);
      end else
    until (ErrCode <> ERROR_SUCCESS);
  finally
    RegCloseKey(KeyHandle);
  end;
end;

//kontrola poli (podle nazvu)
function CheckFields(DataSet: TDataSet; const Names: Array of String): Boolean;
var
  i: Integer;
begin
  Result:=False;
  if DataSet.Fields.Count <> Length(Names) then Exit;
  for i:=0 to DataSet.Fields.Count-1 do
    if LowerCase(DataSet.Fields.Fields[i].FieldName) <> Names[i] then Exit;
  Result:=True;
end;

//vytvorit databazi deniku
procedure CreateLogDB(const FileName: String); overload;
var
  Table: TTable;
  i: Integer;
begin
  Table:=TTable.Create(nil);
  with Table, FieldDefs do
  try
    TableName:=FileName;
    TableType:=ttParadox;
    for i:=Low(dfL_Name) to High(dfL_Name) do
      Add(dfL_Name[i], dfL_Type[i], dfL_Size[i]);
    FieldDefs.Items[dfiL_Index].Attributes:=[faReadonly];
    CreateTable;
    AddIndex('',dfnL_Index,[ixPrimary,ixUnique]);
  finally
    Table.Free;
  end;
end;

procedure CreateLogDB(Table: TTable); overload;
var
  i:Integer;
begin
  with Table, FieldDefs do
  begin
    TableType:=ttParadox;
    for i:=Low(dfL_Name) to High(dfL_Name) do
      Add(dfL_Name[i], dfL_Type[i], dfL_Size[i]);
    FieldDefs.Items[dfiL_Index].Attributes:=[faReadonly];
    CreateTable;
    AddIndex('', dfnL_Index, [ixPrimary,ixUnique]);
  end;
end;

end.
