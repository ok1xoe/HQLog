{**************************************************************************************************}
{                                                                                                  }
{ Console Library                                                                                }
{                                                                                                  }
{**************************************************************************************************}

unit cfmConsole;

interface

uses Windows, Classes;

procedure SetConXY(X, Y: Word); overload;
procedure SetConXY(Coord: TCoord); overload;
function GetConXY: TCoord;

implementation

var
  hStdOutput: THandle;

//------------------------------------------------------------------------------
//Set Console Cursor Position
//------------------------------------------------------------------------------

procedure SetConXY(X, Y : Word);
var
  Coord: TCoord;
begin
  Coord.X:=X;
  Coord.Y:=Y;
  SetConsoleCursorPosition(hStdOutput, Coord);
end;

procedure SetConXY(Coord: TCoord);
begin
  SetConsoleCursorPosition(hStdOutput, Coord);
end;

//------------------------------------------------------------------------------
//Get Console Cursor Position
//------------------------------------------------------------------------------

function GetConXY: TCoord;
var
  bInfo: TConsoleScreenBufferInfo;
begin
  GetConsoleScreenBufferInfo(hStdOutput, bInfo);
  Result:=bInfo.dwCursorPosition;
end;

initialization
  hStdOutput:=GetStdHandle(STD_OUTPUT_HANDLE);
end.
