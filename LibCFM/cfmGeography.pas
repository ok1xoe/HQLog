unit cfmGeography;

interface

uses SysUtils, Math;

//Formating functions
function FormatLongitude(Longitude: Double): String;
function FormatLatitude(Latitude: Double): String;

//WWL functions
procedure WWL2Coord(WWL: String; var x, y: Single);
function Coord2WWL(x, y: Single): String;
function IsWWL(const WWL: String; AllowEmpty: Boolean = False): Boolean;

//Distance
procedure Distance(x1, y1, x2, y2: Single; var D: Single); overload;
function Distance(x1, y1, x2, y2: Single): Single; overload;
procedure Distance(const WWL1, WWL2: String; var D: Single); overload;
function Distance(const WWL1, WWL2: String): Single; overload;

//Azimuth
procedure Azimuth(x1, y1, x2, y2: Single; var A: Single); overload;
function Azimuth(x1, y1, x2, y2: Single): Single; overload;
procedure Azimuth(const WWL1, WWL2: String; var A: Single); overload;
function Azimuth(const WWL1, WWL2: String): Single; overload;

implementation

//------------------------------------------------------------------------------
//Formating functions
//------------------------------------------------------------------------------

//Format Longitude
function FormatLongitude(Longitude: Double): String;
var
  West: Boolean;
  Str: String;
  aDeg: Double;
begin
  West:=Longitude < 0;
  Longitude:=Abs(Longitude);
  Result:=Format('%2.0f° %2.0f' + #39 + ' %2.0f'+#39+#39,
    [Int(Longitude), Int(Frac(Longitude)/(1/60)), Int((Frac(Frac(Longitude)/(1/60)))/(1/60))]);
  if West then
    Result:=Result + ' Z'
  else
    Result:=Result + ' V';
end;

//Format Latitude
function FormatLatitude(Latitude: Double): String;
var
  South: Boolean;
  Str: String;
  aDeg: Double;
begin
  South:=Latitude < 0;
  Latitude:=Abs(Latitude);
  Result:=Format('%2.0f° %2.0f' + #39 + ' %2.0f'+#39+#39,
    [Int(Latitude), Int(Frac(Latitude)/(1/60)), Int((Frac(Frac(Latitude)/(1/60)))/(1/60))]);
  if South then
    Result:=Result + ' J'
  else
    Result:=Result + ' S';
end;

//------------------------------------------------------------------------------
//WWL functions
//------------------------------------------------------------------------------
procedure WWL2Coord(WWL: String; var x, y: Single);
begin
  if WWL = '' then Exit;
  WWL:=UpperCase(WWL);
  x:=((Ord(WWL[1]) - 65)*20 + (Ord(WWL[3]) - 48)*2 + (Ord(WWL[5]) - 65) * (2/24) + (1/24)) - 180;
  y:=((Ord(WWL[2]) - 65)*10 + (Ord(WWL[4]) - 48)*1 + (Ord(WWL[6]) - 65) * (1/24) + (1/48)) - 90;
end;

function Coord2WWL(x, y: Single): String;
var
  Loc: String;
begin
  x:=x + 180;
  y:=y + 90;
  SetLength(Loc, 6);
  Loc[1]:=Chr(Trunc(x/20) + 65);
  x:=x - Trunc(x/20)*20;
  Loc[2]:=Chr(Trunc(y/10) + 65);
  y:=y - Trunc(y/10)*10;
  Loc[3]:=Chr(Trunc(x/2) + 48);
  x:=x - Trunc(x/2)*2;
  Loc[4]:=Chr(Trunc(y) + 48);
  y:=y-Trunc(y);
  Loc[5]:=Chr(Round(Trunc(x*12) + 65 + (4/24)));
  Loc[6]:=Chr(Round(Trunc(y*24) + 65 + (2/24)));
  Result:=Loc;
end;

function IsWWL(const WWL: String; AllowEmpty: Boolean): Boolean;
begin
  case Length(WWL) of
    0: Result:=AllowEmpty;
    6: Result:=(WWL[1] in ['a'..'r', 'A'..'R'])and
               (WWL[2] in ['a'..'r', 'A'..'R'])and
               (WWL[3] in ['0'..'9'])and
               (WWL[4] in ['0'..'9'])and
               (WWL[5] in ['a'..'x', 'A'..'X'])and
               (WWL[6] in ['a'..'x', 'A'..'X']);
  else
    Result:=False;
  end;
end;

//------------------------------------------------------------------------------
//Distance
//------------------------------------------------------------------------------
procedure Distance(x1, y1, x2, y2: Single; var D: Single);
begin
  D:=0;
  x1:=x1*(PI/180);
  y1:=y1*(PI/180);
  x2:=x2*(PI/180);
  y2:=y2*(PI/180);
  try
    D:=6371.229*ArcCos(sin(y1)*sin(y2) + cos(y1)*cos(y2)*cos(x2 - x1));
  except
  end;
end;

function Distance(x1, y1, x2, y2: Single): Single;
begin
  Distance(x1, y1, x2, y2, Result);
end;

procedure Distance(const WWL1, WWL2: String; var D: Single); overload;
var
  x1, y1, x2, y2: Single;
begin
  WWL2Coord(WWL1, x1, y1);
  WWL2Coord(WWL2, x2, y2);
  Distance(x1, y1, x2, y2, D);
end;

function Distance(const WWL1, WWL2: String): Single; overload;
var
  x1, y1, x2, y2: Single;
begin
  Distance:=0;
  WWL2Coord(WWL1, x1, y1);
  WWL2Coord(WWL2, x2, y2);
  Distance(x1, y1, x2, y2, Result);
end;

//------------------------------------------------------------------------------
//Azimuth
//------------------------------------------------------------------------------
procedure Azimuth(x1, y1, x2, y2: Single; var A: Single);
var
  ss, dx, az: Single;
begin
  A:=0;
  y1:=(y1 + 90)*(PI/180);
  x1:=(x1 + 180)*(PI/180);
  y2:=(y2 + 90)*(PI/180);
  x2:=(x2 + 180)*(PI/180);
  ss:=x1 - x2;
  try
    dx:=sin(y1)*tan(y2 - PI/2) + cos(y1)*cos(ss);
    az:=-180/pi*Arctan(sin(ss)/(dx));
    if dx < 0 then az:=az + 180;
    if az > 360 then az:=az - 360;
    if az < 0 then az:=360 + az;
    A:=az;
  except
  end;
end;

function Azimuth(x1, y1, x2, y2: Single): Single;
begin
  Azimuth(x1, y1, x2, y2, Result);
end;

procedure Azimuth(const WWL1, WWL2: String; var A: Single); overload;
var
  x1, y1, x2, y2: Single;
begin
  WWL2Coord(WWL1, x1, y1);
  WWL2Coord(WWL2, x2, y2);
  Azimuth(x1, y1, x2, y2, A);
end;

function Azimuth(const WWL1, WWL2: String): Single;
var
  x1, y1, x2, y2: Single;
begin
  WWL2Coord(WWL1, x1, y1);
  WWL2Coord(WWL2, x2, y2);
  Azimuth(x1, y1, x2, y2, Result);
end;

end.
