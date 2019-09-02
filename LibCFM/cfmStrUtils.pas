{**************************************************************************************************}
{                                                                                                  }
{ StrUtils Library                                                                                 }
{                                                                                                  }
{**************************************************************************************************}

unit cfmStrUtils;

interface

uses SysUtils;

type
  TSetOfChar = Set of Char;

//Check string for illegal characters
function CheckString(const Text: String; const Allowed: TSetOfChar;
  Empty: Boolean = False): Boolean;

//Check string format
function IsInt(const Text: String; AllowEmpty: Boolean = False): Boolean; overload;
function IsInt(const Text: String; Min, Max: Integer;
  AllowEmpty: Boolean = False): Boolean; overload;
function IsFloat(const Text: String; AllowEmpty: Boolean = False): Boolean; overload;
function IsFloat(const Text: String; Min, Max: Extended;
  AllowEmpty: Boolean = False): Boolean; overload;
function IsDate(const Text: String; AllowEmpty: Boolean = False): Boolean;
function IsTime(const Text: String; AllowEmpty: Boolean = False): Boolean;
function IsDateTime(const Text: String; AllowEmpty: Boolean = False): Boolean;

implementation

//------------------------------------------------------------------------------
//Check string for illegal characters
//------------------------------------------------------------------------------

function CheckString(const Text: String; const Allowed: TSetOfChar;
  Empty: Boolean): Boolean;
var
  i: Integer;
begin
  Result:=False;
  if (not Empty) and (Length(Text) = 0) then Exit;
  for i:=1 to Length(Text) do
    if not(Text[i] in Allowed) then Exit;
  Result:=True;
end;

//------------------------------------------------------------------------------
//Check string format
//------------------------------------------------------------------------------

//IsInt
function IsInt(const Text: String; AllowEmpty: Boolean = False): Boolean;
var
  i, E: Integer;
begin
  if Text = '' then
    Result:=AllowEmpty
  else begin
    Val(Text, i, E);
    Result:= E = 0;
  end;
end;

function IsInt(const Text: String; Min, Max: Integer; AllowEmpty: Boolean = False): Boolean;
var
  i, E: Integer;
begin
  if Text = '' then
    Result:=AllowEmpty
  else begin
    Val(Text, i, E);
    Result:= (E = 0)and(i >= Min)and(i <= Max);
  end;
end;

//IsFloat
function IsFloat(const Text: String; AllowEmpty: Boolean = False): Boolean;
var
  f: Extended;
begin
  if Text = '' then
    Result:=AllowEmpty
  else
    Result:=TextToFloat(PChar(Text), f, fvExtended);
end;

function IsFloat(const Text: String; Min, Max: Extended; AllowEmpty: Boolean = False): Boolean;
var
  f: Extended;
begin
  if Text = '' then
    Result:=AllowEmpty
  else
    Result:=(TextToFloat(PChar(Text), f, fvExtended))and(f >= Min)and(f <= Max);
end;

//IsDate
function IsDate(const Text: String; AllowEmpty: Boolean = False): Boolean;
var
  d: TDateTime;
begin
  if Text = '' then
    Result:=AllowEmpty
  else
    Result:=TryStrToDate(Text, d);
end;

//IsTime
function IsTime(const Text: String; AllowEmpty: Boolean = False): Boolean;
var
  d: TDateTime;
begin
  if Text = '' then
    Result:=AllowEmpty
  else
    Result:=TryStrToTime(Text, d);
end;

//IsDateTime
function IsDateTime(const Text: String; AllowEmpty: Boolean = False): Boolean;
var
  d: TDateTime;
begin
  if Text = '' then
    Result:=AllowEmpty
  else
    Result:=TryStrToDateTime(Text, d);
end;

end.

