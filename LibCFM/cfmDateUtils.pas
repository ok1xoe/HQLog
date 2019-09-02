{**************************************************************************************************}
{                                                                                                  }
{ DateUtils Library                                                                                }
{                                                                                                  }
{**************************************************************************************************}

unit cfmDateUtils;

interface

uses Windows, SysUtils;

function DateUTC: TDateTime;
function TimeUTC: TDateTime;
function NowUTC: TDateTime;

implementation

function DateUTC: TDateTime;
var
  SystemTime: TSystemTime;
begin
  GetSystemTime(SystemTime);
  with SystemTime do
    Result:=EncodeDate(wYear, wMonth, wDay);
end;

function TimeUTC: TDateTime;
var
  SystemTime: TSystemTime;
begin
  GetSystemTime(SystemTime);
  with SystemTime do
    Result:=EncodeTime(wHour, wMinute, wSecond, wMilliSeconds);
end;

function NowUTC: TDateTime;
var
  SystemTime: TSystemTime;
begin
  GetSystemTime(SystemTime);
  with SystemTime do
    Result:=EncodeDate(wYear, wMonth, wDay) +
            EncodeTime(wHour, wMinute, wSecond, wMilliseconds);
end;

end.
