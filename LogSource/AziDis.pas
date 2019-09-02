unit AziDis;

interface

uses
  HQLResStrings, Kontrola, Dialogs, cfmDialogs, cfmGeography, Controls;

  function GetDistance(const MyLoc, Loc: String; const x, y: Single): Integer;
  function GetAzimuth(const MyLoc, Loc: String; const x, y: Single): Integer;

implementation

//vzdalenost
function GetDistance(const MyLoc, Loc: String; const x, y: Single): Integer;
var
  sx1, sy1, sx2, sy2, d: Single;
begin
  Result:=0;
  if not IsWWL(MyLoc) then
  begin
    cMessageDlg(strCantCountDist, mtWarning, [mbOK], mrYes, 0);
    Exit;
  end;
  WWL2Coord(MyLoc, sx1, sy1);
  if not IsWWL(Loc) then
  begin
    sx2:=x;
    sy2:=y;
  end else
    WWL2Coord(Loc, sx2, sy2);
  Distance(sx1, sy1, sx2, sy2, d);
  Result:=Round(d);
end;

//azimut
function GetAzimuth(const MyLoc, Loc: String; const x, y: Single): Integer;
var
  sx1, sy1, sx2, sy2, a: Single;
begin
  Result:=0;
  if not IsWWL(MyLoc) then
  begin
    cMessageDlg(strCantCountAzi, mtWarning, [mbOK], mrYes, 0);
    Exit;
  end;
  WWL2Coord(MyLoc, sx1, sy1);
  if IsWWL(Loc) then
  begin
    sx2:=x;
    sy2:=y;
  end else
    WWL2Coord(Loc, sx2, sy2);
  Azimuth(sx1, sy1, sx2, sy2, a);
  Result:=Round(a);
end;

end.
