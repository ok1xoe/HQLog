unit HQLMessages;

interface

uses Windows, Messages;

const
  dw_CloseDXC=10;
  dw_SetQSO=11;

type
  //zavreni DXClusteru
  pCloseDXCData = ^TCloseDXCData;
  TCloseDXCData = record
    Width,Height:Integer;
    Maximized:Boolean;
  end;
  //predani informace o spojeni
  pSetQSOData = ^TSetQSOData;
  TSetQSOData = record
    Call:String[15];
    Freq:Double;
  end;

implementation

end.
 