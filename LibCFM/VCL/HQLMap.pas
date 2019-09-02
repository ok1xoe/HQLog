unit HQLMap;

interface

uses DxDraws, Classes, Types, Graphics, SysUtils, Math, Windows, Controls;

type
  TMapOption=(moWWLGrid,moGeoGrid);
  TSPoint=record
    x,y:Single;
  end;
  TSRect=record
    Left,Right,Top,Bottom:Single;
  end;
  TDataRec=Single;
  THeadRec=record
    Left:Single;
    Right:Single;
    Top:Single;
    Bottom:Single;
    Color:Byte;
    ID1:String[25];
    ID2:String[4];
    DataIndex,DataSize:Cardinal;
  end;
  pDataRec=^TDataRec;
  pHeadRec=^THeadRec;
  THeadInfo=record
    Mem:pHeadRec;
    Count:Integer;
  end;
  TDataInfo=record
    Mem:pDataRec;
    Count:Integer;
  end;

  //THamMap
  THamMap = class(TCustomDxDraw)
  private
    DataEmpty:Boolean;
    DragPoint,lPoint:TPoint;
    fZoom:Single;
    fCenter:TSPoint;
    //
    fHead,fData:TMemoryStream;
    DrawBuffer:Array of TPoint;
    InfoBuffer:Array of TPoint;
    //
    fHeadInfo:THeadInfo;
    fDataInfo:TDataInfo;
    //
    fDrawList:TThreadList;
    //
    procedure SetCenter(Value:TSPoint);
    procedure BeginDraw(Drag,Delay:Boolean);
    procedure OnEndDraw(Sender: TObject);
  protected
    procedure DoInitializeSurface; override;
    procedure DoRestoreSurface; override;
    procedure MouseDown(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    procedure MouseMove(Shift: TShiftState; X, Y: Integer); override;
    procedure MouseUp(Button: TMouseButton; Shift: TShiftState;
      X, Y: Integer); override;
    function DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
      MousePos: TPoint): Boolean; override;
  public
    constructor Create(AOwner:TComponent); override;
    destructor Destroy; override;
    //
    procedure LoadFromFile(HeadFile,DataFile:String);
    //
    property Center:TSPoint read fCenter write SetCenter;
  published
    property Align;
    property Options;
    //
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    {$IFDEF DelphiX_Spt4}property OnResize;{$ENDIF}
    property OnStartDrag;
  end;

  TDrawMap = class(TThread)
  private
    fMap:THamMap;
    //
    fHeadInfo:THeadInfo;
    fDataInfo:TDataInfo;
    pBuffer:pPoint;
    //
    fCenter:TSPoint;
    fZoom:Single;
    fDrag,fDelay:Boolean;
  protected
    procedure Execute; override;
  public
    constructor Create(Map:THamMap; HeadInfo:THeadInfo; DataInfo:TDataInfo;
      Buffer:pPoint; Zoom:Single; Center:TSPoint; Drag,Delay:Boolean;
      fOnTerminate:TNotifyEvent);
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('HQLog',[THamMap]);
end;

//------------------------------------------------------------------------------

const
  MapHeadID:Array[0..4] of Byte=($07,$FE,$38,$12,$01);
  MapDataID:Array[0..4] of Byte=($07,$FE,$38,$12,$02);
  Colors:Array [1..5] of TColor=($6B7DC6,$84BEDE,$AD92AD,$73A29C,$F4F4F4);
  clBackGround=$9F9F9F;
  clOcean=$FFDFDE;
  px:Single=10; //proporce v ose X
  py:Single=12; //proporce v ose Y
  MaxZoom:Single=0.75;
  MinZoom:Single=-0.75;
  fZoomStep:Single=0.1;

//------------------------------------------------------------------------------

//souradnice -> lokator
function S2Loc(x,y:Double):String;
var
  Loc:String[6];
  sx,sy:Double;
begin
  sx:=x+180;
  sy:=y+90;
  SetLength(Loc,6);
  Loc[1]:=Chr(Trunc(sx/20)+65); sx:=sx-Trunc(sx/20)*20;
  Loc[2]:=Chr(Trunc(sy/10)+65); sy:=sy-Trunc(sy/10)*10;
  Loc[3]:=Chr(Trunc(sx/2)+48); sx:=sx-Trunc(sx/2)*2;
  Loc[4]:=Chr(Trunc(sy)+48); sy:=sy-Trunc(sy);
  Loc[5]:=Chr(Round(Trunc(sx*12)+65+(4/24)));
  Loc[6]:=Chr(Round(Trunc(sy*24)+65+(2/24)));
  Result:=Loc;
end;

//------------------------------------------------------------------------------

constructor THamMap.Create(AOwner:TComponent);
begin
  inherited;
  fDrawList:=TThreadList.Create;
  fHead:=TMemoryStream.Create;
  fData:=TMemoryStream.Create;
  DataEmpty:=True;
  fZoom:=0;
  fCenter.x:=0;
  fCenter.y:=0;
end;

destructor THamMap.Destroy;
begin
  fDrawList.Free;
  fHead.Free;
  fData.Free;
  DrawBuffer:=nil;
  inherited;
end;

//------------------------------------------------------------------------------

procedure THamMap.SetCenter(Value:TSPoint);
begin
  if Value.x<-180 then Value.x:=-180;
  if Value.x>180 then Value.x:=180;
  if Value.y<-90 then Value.y:=-90;
  if Value.y>90 then Value.y:=90;
  fCenter:=Value;
  BeginDraw(False,False);
end;

//------------------------------------------------------------------------------

procedure THamMap.DoInitializeSurface;
begin
  inherited;
  if not CanDraw then Exit;
  BeginDraw(False,True);
end;

procedure THamMap.DoRestoreSurface;
begin
  inherited;
//  BeginDraw(False,False);
end;

procedure THamMap.MouseDown(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  DragPoint.X:=X;
  DragPoint.Y:=Y;
  lPoint:=DragPoint;
  inherited;
end;

procedure THamMap.MouseMove(Shift: TShiftState; X, Y: Integer);
var
 sx,sy:Single;
begin
  if ssLeft in Shift then
  begin
    sx:=0.5*(2*Power(10,-fZoom)*(lPoint.X-x))/px;
    sy:=-0.5*(2*Power(10,-fZoom)*(lPoint.Y-y))/py;
    fCenter.x:=fCenter.x+sx;
    fCenter.y:=fCenter.y+sy;
    BeginDraw(True,False);
    lPoint.X:=X;
    lPoint.Y:=Y;
  end else
  begin
  end;
  inherited;
end;

procedure THamMap.MouseUp(Button: TMouseButton; Shift: TShiftState;
  X, Y: Integer);
begin
  if (DragPoint.X<>X)or(DragPoint.Y<>Y) then BeginDraw(False,False);
  inherited;
end;

function THamMap.DoMouseWheel(Shift: TShiftState; WheelDelta: Integer;
  MousePos: TPoint): Boolean;
var
  dz:Single;
  x,y:Integer;
begin
  Result:=True;
  x:=MousePos.X-ClientOrigin.X;
  y:=MousePos.Y-ClientOrigin.Y;
  dz:=0;
  if WheelDelta>0 then dz:=fZoomStep;
  if WheelDelta<0 then dz:=-fZoomStep;
  if (fZoom+dz<MinZoom)or(fZoom+dz>MaxZoom)or
     (x<0)or(x>SurfaceWidth)or
     (y<0)or(y>SurfaceHeight) then Exit;
  fCenter.x:=fCenter.x+0.5*(2*Power(10,-fZoom)*x-Power(10,-fZoom)*SurfaceWidth-2*Power(10,-dz-fZoom)*x+Power(10,-dz-fZoom)*SurfaceWidth)/px;
  fCenter.y:=fCenter.y+0.5*(2*Power(10,-fZoom-dz)*y-Power(10,-fZoom-dz)*SurfaceHeight-2*Power(10,-fZoom)*y+Power(10,-fZoom)*SurfaceHeight)/py;
  if fCenter.x<-180 then fCenter.x:=-180;
  if fCenter.x>180 then fCenter.x:=180;
  if fCenter.y<-90 then fCenter.y:=-90;
  if fCenter.y>90 then fCenter.y:=90;
  fZoom:=fZoom+dz;
  BeginDraw(False,True);
end;

//------------------------------------------------------------------------------

//nacteni dat ze souboru
procedure THamMap.LoadFromFile(HeadFile,DataFile:String);
var
  hCount,BufferSize:Cardinal;
  ph:pHeadRec;
begin
  try
    fHead.LoadFromFile(HeadFile);
    fData.LoadFromFile(DataFile);
    //kontrola ID
    if not((fHead.Size>=SizeOf(MapHeadID))and
           (CompareMem(fHead.Memory,@MapHeadID,SizeOf(MapHeadID)))) then
      Exception.Create('Neplatný formát souboru');
    if not((fData.Size>=SizeOf(MapDataID))and
           (CompareMem(fData.Memory,@MapDataID,SizeOf(MapDataID)))) then
      Exception.Create('Neplatný formát souboru');
    //kontrola velikosti
    fHead.Position:=SizeOf(MapHeadID);
    fHead.Read(hCount,SizeOf(hCount));
    if hCount*SizeOf(THeadRec)<>fHead.Size-SizeOf(MapHeadID)-SizeOf(hCount) then
      Exception.Create('Neplatný formát souboru');
    if ((fData.Size-SizeOf(MapDataID)) mod SizeOf(TDataRec))<>0 then
      Exception.Create('Neplatný formát souboru');
    //
    fHeadInfo.Mem:=Pointer(Cardinal(fHead.Memory)+SizeOf(MapHeadID)+SizeOf(hCount));
    fHeadInfo.Count:=hCount;
    fDataInfo.Mem:=Pointer(Cardinal(fData.Memory)+SizeOf(MapDataID));
    fDataInfo.Count:=fData.Size-SizeOf(MapDataID) div SizeOf(TDataRec);
    //velikost bufferu
    ph:=fHeadInfo.Mem;
    BufferSize:=0;
    while hCount<>0 do
    begin
      if ph^.DataSize>BufferSize then BufferSize:=ph^.DataSize;
      Inc(ph);
      Dec(hCount);
    end;
    SetLength(DrawBuffer,BufferSize);
    SetLength(InfoBuffer,BufferSize);
    //
    DataEmpty:=False;
  except
    fHead.Clear;
    fData.Clear;
    fHeadInfo.Mem:=nil;
    fHeadInfo.Count:=0;
    fDataInfo.Mem:=nil;
    fDataInfo.Count:=0;
    DrawBuffer:=nil;
    InfoBuffer:=nil;
    DataEmpty:=True;
  end;
end;

//vykresleni
procedure THamMap.BeginDraw(Drag,Delay:Boolean);
var
  i:Integer;
begin
  with fDrawList.LockList do
  try
    for i:=0 to Count-1 do
      TThread(Items[i]).Terminate;
    fDrawList.Add(TDrawMap.Create(
      Self,
      fHeadInfo,fDataInfo,@DrawBuffer[0],
      fZoom,fCenter,Drag,Delay,
      OnEndDraw));
  finally
    fDrawList.UnlockList;
  end;
end;

procedure THamMap.OnEndDraw(Sender: TObject);
var
  i:Integer;
begin
  with fDrawList.LockList do
  try
    for i:=0 to Count-1 do
      if Sender=Items[i] then
      begin
        Delete(i);
        Exit;
      end;
  finally
    fDrawList.UnlockList;
  end;
end;

//------------------------------------------------------------------------------

//vytvoreni
constructor TDrawMap.Create(Map:THamMap; HeadInfo:THeadInfo; DataInfo:TDataInfo;
  Buffer:pPoint; Zoom:Single; Center:TSPoint; Drag,Delay:Boolean;
  fOnTerminate:TNotifyEvent);

begin
  inherited Create(True);
  FreeOnTerminate:=True;
  Priority:=tpHighest;
  OnTerminate:=fOnTerminate;
  //
  fMap:=Map;
  fHeadInfo:=HeadInfo;
  fDataInfo:=DataInfo;
  pBuffer:=Buffer;
  fZoom:=Zoom;
  fCenter:=Center;
  fDrag:=Drag;
  fDelay:=Delay;
  //
  Resume;
end;

//vykresleni
procedure TDrawMap.Execute;
var
  Head:pHeadRec;
  Data:pDataRec;
  hCount,dCount:Cardinal;
  i:Integer;
  zx,zy:Single;
  pRect,DrawRect,SegmentRect:TRect;
  aPoint,lPoint:TPoint;
  Polygon:pPoint;
  sRect:TSRect;

 //ramecek kolem mapy
 procedure DrawFrame;
 var
   cHandle:THandle;
 begin
   with fMap.Surface,Canvas do
   try
     Pen.Width:=2;
     Pen.Style:=psSolid;
     Pen.Color:=clBlack;
     cHandle:=Handle;
     if pRect.Left>0 then
     begin
       Windows.MoveToEx(cHandle,pRect.Left,pRect.Top,nil);
       Windows.LineTo(cHandle,pRect.Left,pRect.Bottom);
     end;
     if pRect.Right<Width then
     begin
       Windows.MoveToEx(cHandle,pRect.Right,pRect.Top,nil);
       Windows.LineTo(cHandle,pRect.Right,pRect.Bottom);
     end;
     if pRect.Top>0 then
     begin
       Windows.MoveToEx(cHandle,pRect.Left,pRect.Top-1,nil);
       Windows.LineTo(cHandle,pRect.Right,pRect.Top-1);
     end;
     if pRect.Bottom<Height then
     begin
       Windows.MoveToEx(cHandle,pRect.Left,pRect.Bottom,nil);
       Windows.LineTo(cHandle,pRect.Right,pRect.Bottom);
     end;
   finally
     Release;
   end;
 end;


 //vykreslit zemepisne souradnice
 procedure gGrid(zx,zy:Single);
 var
   sx,sy:Single;
   x1,x2,y1,y2,i:Integer;
   cHandle:THandle;

 begin
   with fMap.Surface,Canvas do
   try
     Pen.Width:=1;
     Brush.Style:=bsClear;
     Pen.Color:=clBlack;
     Pen.Style:=psDot;
     cHandle:=Handle;
     //x
     y1:=pRect.Top;
     y2:=pRect.Bottom;
     if sRect.Left<-180 then sx:=-180 else sx:=sRect.Left;
     sx:=Ceil(sx/20)*20;
     if sRect.Right>180 then sy:=180 else sy:=sRect.Right;
     i:=Trunc((sy-sx)/20)+1;
     while (not Terminated)and(i>0) do
     begin
       x1:=Round(zx*(sx-sRect.Left));
       Windows.MoveToEx(cHandle,x1,y1,nil);
       Windows.LineTo(cHandle,x1,y2);
       sx:=sx+20;
       Dec(i);
     end;
     //y
     x1:=pRect.Left;
     x2:=pRect.Right;
     if sRect.Bottom<-90 then sy:=-90 else sy:=sRect.Bottom;
     sy:=Ceil(sy/10)*10;
     if sRect.Top>90 then sx:=90 else sx:=sRect.Top;
     i:=Trunc((sx-sy)/10)+1;
     while (not Terminated)and(i>0) do
     begin
       y1:=Round(zy*(sRect.Top-sy));
       Windows.MoveToEx(cHandle,x1,y1,nil);
       Windows.LineTo(cHandle,x2,y1);
       sy:=sy+10;
       Dec(i);
     end;
     //
     Pen.Style:=psDashDot;
     x1:=pRect.Left;
     x2:=pRect.Right;
     cHandle:=Handle;
     //obratnik raka
     if (23.45<=sRect.Top)and(23.45>=sRect.Bottom) then
     begin
       y1:=Round(zy*(sRect.Top-23.45));
       Windows.MoveToEx(cHandle,x1,y1,nil);
       Windows.LineTo(cHandle,x2,y1);
     end;
     //obratnik kozoroha
     if (-23.45<=sRect.Top)and(-23.45>=sRect.Bottom) then
     begin
       y1:=Round(zy*(sRect.Top+23.45));
       Windows.MoveToEx(cHandle,x1,y1,nil);
       Windows.LineTo(cHandle,x2,y1);
     end;
     //
     Pen.Style:=psSolid;
     //rovnik
     if (0<=sRect.Top)and(0>=sRect.Bottom) then
     begin
       y1:=Round(zy*sRect.Top);
       Windows.MoveToEx(cHandle,x1,y1,nil);
       Windows.LineTo(cHandle,x2,y1);
     end;
     //0 polednik
     if (0<=sRect.Right)and(0>=sRect.Left) then
     begin
       x1:=Round(-zx*sRect.Left);
       y1:=pRect.Top;
       y2:=pRect.Bottom;
       Windows.MoveToEx(cHandle,x1,y1,nil);
       Windows.LineTo(cHandle,x1,y2);
     end;
   finally
     Release;
   end;
 end;

 //vykreslit lokatorovou mrizku
 procedure lGrid(zx,zy:Single);
 const
   tOptions=DT_CENTER or DT_VCENTER or DT_NOPREFIX or DT_SINGLELINE or DT_NOCLIP;
 var
   sx,sy,s:Single;
   x1,x2,y1,y2,i,j,w,h:Integer;
   Loc:String;
   cHandle:THandle;
   TxtRect:TRect;

  function IsLocSel(Loc:PChar):Boolean;
  var
    i:Integer;
//    List:PLocList;
  begin
    Result:=False;
{    List:=fLocList;
    for i:=0 to Length(List^)-1 do
      if StrComp(PChar(List^[i]),Loc)=0 then
      begin
        Result:=True;
        Exit;
      end; }
  end;

 begin
   with fMap.Surface,Canvas do
   try
     Brush.Style:=bsClear;
     //**** male ctverce ****
     if fZoom>=0.25 then
     begin
       Pen.Width:=1;
       Pen.Style:=psDot;
       Pen.Color:=clGray;
       cHandle:=Handle;
       //x
       y1:=pRect.Top;
       y2:=pRect.Bottom;
       if sRect.Left<-180 then sx:=-180 else sx:=sRect.Left;
       sx:=Ceil(sx/2)*2;
       if sRect.Right>180 then s:=180 else s:=sRect.Right;
       i:=Trunc((s-sx)/2)+1;
       while (not Terminated)and(i>0) do
       begin
         x1:=Round(zx*(sx-sRect.Left));
         Windows.MoveToEx(cHandle,x1,y1,nil);
         Windows.LineTo(cHandle,x1,y2);
         sx:=sx+2;
         Dec(i);
       end;
       //y
       x1:=pRect.Left;
       x2:=pRect.Right;
       if sRect.Bottom<-90 then sy:=-90 else sy:=sRect.Bottom;
       sy:=Ceil(sy);
       if sRect.Top>90 then s:=90 else s:=sRect.Top;
       j:=Trunc(s-sy)+1;
       while (not Terminated)and(j>0) do
       begin
         y1:=Round(zy*(sRect.Top-sy));
         Windows.MoveToEx(cHandle,x1,y1,nil);
         Windows.LineTo(cHandle,x2,y1);
         sy:=sy+1;
         Dec(j);
       end;
     end;
     //**** velke ctverce ****
     Pen.Width:=1;
     if fZoom>=0.25 then Pen.Style:=psSolid
                    else Pen.Style:=psDot;
     Pen.Color:=clGray;
     cHandle:=Handle;
     //x
     y1:=pRect.Top;
     y2:=pRect.Bottom;
     if sRect.Left<-180 then sx:=-180 else sx:=sRect.Left;
     sx:=Ceil(sx/20)*20;
     if sRect.Right>180 then s:=180 else s:=sRect.Right;
     i:=Trunc((s-sx)/20)+1;
     while (not Terminated)and(i>0) do
     begin
       x1:=Round(zx*(sx-sRect.Left));
       Windows.MoveToEx(cHandle,x1,y1,nil);
       Windows.LineTo(cHandle,x1,y2);
       sx:=sx+20;
       Dec(i);
     end;
     //y
     x1:=pRect.Left;
     x2:=pRect.Right;
     if sRect.Bottom<-90 then sy:=-90 else sy:=sRect.Bottom;
     sy:=Ceil(sy/10)*10;
     if sRect.Top>90 then s:=90 else s:=sRect.Top;
     j:=Trunc((s-sy)/10)+1;
     while (not Terminated)and(j>0) do
     begin
       y1:=Round(zy*(sRect.Top-sy));
       Windows.MoveToEx(cHandle,x1,y1,nil);
       Windows.LineTo(cHandle,x2,y1);
       sy:=sy+10;
       Dec(j);
     end;
     //**** velke napisy ****
     Font.Name:='Arial';
     Font.Height:=Round(50*Power(10,fZoom));
     Font.Color:=clSilver;
     w:=Round(zx*20);
     h:=Round(zy*10);
     cHandle:=Handle;
     //y
     if sRect.Bottom<-90 then sy:=-90 else sy:=sRect.Bottom;
     sy:=Ceil(sy/10)*10-10;
     if sy<-90 then sy:=-90;
     if sRect.Top>90 then s:=90 else s:=sRect.Top;
     j:=Trunc((s-sy)/10)+1;
     if sy+10*j>90 then Dec(j);
     while (not Terminated)and(j>0) do
     begin
       //x
       if sRect.Left<-180 then sx:=-180 else sx:=sRect.Left;
       sx:=Ceil(sx/20)*20-20;
       if sx<-180 then sx:=-180;
       if sRect.Right>180 then s:=180 else s:=sRect.Right;
       i:=Trunc((s-sx)/20)+1;
       if sx+20*i>180 then Dec(i);
       TxtRect.Top:=Round(zy*(sRect.Top-sy-10));
       TxtRect.Bottom:=TxtRect.Top+h;
       while (i>0) do
       begin
         Loc:=Copy(S2Loc(sx+10,sy+5),1,2);
         TxtRect.Left:=Round(zx*(sx-sRect.Left));
         TxtRect.Right:=TxtRect.Left+w;
         Windows.DrawText(cHandle,PChar(Loc),-1,TxtRect,tOptions);
         sx:=sx+20;
         Dec(i);
       end;
       sy:=sy+10;
       Dec(j);
     end;
     if fZoom>=0.25 then
     begin
       //**** male napisy ****
       Font.Name:='Arial Narrow';
       Font.Height:=Round(10*Power(10,fZoom));
       Font.Color:=clGray;

       w:=Round(zx*2);
       h:=Round(zy*1);
       //y
       if sRect.Bottom<-90 then sy:=-90 else sy:=sRect.Bottom;
       sy:=Ceil(sy)-1;
       if sy<-90 then sy:=-90;
       if sRect.Top>90 then s:=90 else s:=sRect.Top;
       j:=Trunc(s-sy)+1;
       if sy+1*j>90 then Dec(j);
       while (not Terminated)and(j>0) do
       begin
         //x
         if sRect.Left<-180 then sx:=-180 else sx:=sRect.Left;
         sx:=Ceil(sx/2)*2-2;
         if sx<-180 then sx:=-180;
         if sRect.Right>180 then s:=180 else s:=sRect.Right;
         i:=Trunc((s-sx)/2)+1;
         if sx+2*i>180 then Dec(i);
         TxtRect.Top:=Round(zy*(sRect.Top-sy-1));
         TxtRect.Bottom:=TxtRect.Top+h;
         while (not Terminated)and(i>0) do
         begin
           Loc:=Copy(S2Loc(sx+1,sy+0.5),1,4);
           if IsLocSel(PChar(Loc)) then
           begin
//             Font.Color:=clBlue;
//             Font.Style:=[fsBold];
           end else
           begin
//             Font.Color:=clGray;
//             Font.Style:=[];
           end;
           Delete(Loc,1,2);
           TxtRect.Left:=Round(zx*(sx-sRect.Left));
           TxtRect.Right:=TxtRect.Left+w;
           Windows.DrawText(Handle,PChar(Loc),-1,TxtRect,tOptions);
           sx:=sx+2;
           Dec(i);
         end;
         sy:=sy+1;
         Dec(j);
       end;
     end;
   finally
     Release;
   end;
 end;

begin
  if (Terminated)or(not fMap.CanDraw) then Exit;
  //
  zx:=Power(10,fZoom)*px;
  zy:=Power(10,fZoom)*py;
  DrawRect:=fMap.Surface.ClientRect;
  //
  with sRect,fMap.Surface do
  begin
    Left:=fCenter.x-Width/(zx*2);
    Top:=fCenter.y+Height/(zy*2);
    Right:=fCenter.x+Width/(zx*2);
    Bottom:=fCenter.y-Height/(zy*2);
  end;
  //
  with pRect,fMap.Surface do
  begin
    Left:=Round(zx*(-180-sRect.Left));
    Top:=Round(zy*(sRect.Top-90));
    Right:=Round(zx*(180-sRect.Left));
    Bottom:=Round(zy*(sRect.Top+90));
    if Left<0 then Left:=0;
    if Top<0 then Top:=0;
    if Right>Width then Right:=Width;
    if Bottom>Height then Bottom:=Height;
  end;
  //
  fMap.Surface.Canvas.Lock;
  try
    with fMap.Surface.Canvas do
    begin
      //vyplnit cele platno
      Brush.Style:=bsSolid;
      Brush.Color:=clBackGround;
      FillRect(DrawRect);
      //ocean
      Brush.Color:=clOcean;
      FillRect(pRect);
      //
      Pen.Style:=psSolid;
      Pen.Width:=1;
      Pen.Color:=clBlack;
    end;
    //**************************************************************************
    //vykreslit polygony
    hCount:=fHeadInfo.Count;
    Head:=fHeadInfo.Mem;
    try
      while (not Terminated)and(hCount<>0) do
      begin
        //nacist hlavicku polygonu
        SegmentRect.Left:=Round(zx*(Head^.Left-sRect.Left));
        SegmentRect.Right:=Round(zx*(Head^.Right-sRect.Left));
        SegmentRect.Top:=Round(zy*(sRect.Top-Head^.Top));
        SegmentRect.Bottom:=Round(zy*(sRect.Top-Head^.Bottom));
        //neni mimo obraz?
        if not((SegmentRect.Left>DrawRect.Right)or(SegmentRect.Right<DrawRect.Left)or
               (SegmentRect.Top>DrawRect.Bottom)or(SegmentRect.Bottom<DrawRect.Top)) then
        begin
          i:=0;
          lPoint:=Point(0,0);
          Data:=Pointer(Cardinal(fDataInfo.Mem)+Head^.DataIndex);
          dCount:=Head^.DataSize;
          Polygon:=pBuffer;
          while (not Terminated)and(dCount<>0) do
          begin
            aPoint.X:=Round(zx*(Data^-sRect.Left));
            Inc(Data);
            aPoint.Y:=Round(zy*(sRect.Top-Data^));
            Inc(Data);
            if not((abs(aPoint.X-lPoint.X)<2)and(abs(aPoint.Y-lPoint.Y)<2)) then
            begin
              Polygon^:=aPoint;
              lPoint:=aPoint;
              Inc(Polygon);
              Inc(i);
            end;
            Dec(dCount,SizeOf(TDataRec)*2);
          end;
          //
          fMap.Surface.Canvas.Brush.Color:=Colors[Head^.Color];
          if not Terminated then Windows.Polygon(fMap.Surface.Canvas.Handle,pBuffer^,i);
        end;
        Inc(Head);
        Dec(hCount);
      end;
    finally
      fMap.Surface.Canvas.Release;
    end;
    if not Terminated then fMap.Flip;
    //
    if (not Terminated) then DrawFrame;
    if fDelay then
    begin
      i:=20;
      while (not terminated)and(i<>0) do
      begin
        sleep(1);
        dec(i);
      end;
    end;
    if (not Terminated)and(not fDrag){and(moWWLGrid in fMapOptions)} then lGrid(zx,zy);
    if (not Terminated)and(not fDrag){and(moGeoGrid in fMapOptions)} then gGrid(zx,zy);
    if (not Terminated) then DrawFrame;
    sleep(1);
    if not Terminated then fMap.Flip;
  finally
    fMap.Surface.Canvas.UnLock;
  end;
end;

end.
