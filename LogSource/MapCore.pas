unit MapCore;
interface

uses Windows, Classes, SysUtils, Graphics, Math, DXDraws, WWLgrid, Dialogs;

type
  TPoints = array[0..0] of TPoint;
  PPoints = ^TPoints;
  TMapOption=(moWWLGrid,moGeoGrid);
  TMapOptions=Set of TMapOption;
  TSPoint=record
    x,y:Single;
  end;
  TSRect=record
    Left,Right,Top,Bottom:Single;
  end;
  //
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
  TDataRec=Single;
  TLocList=Array of String;
  pHeadRec=^THeadRec;
  pDataRec=^TDataRec;
  pLocList=^TLocList;
  THeadInfo=record
    Mem:pHeadRec;
    Count:Integer;
  end;
  TDataInfo=record
    Mem:pDataRec;
    Count:Integer;
  end;
  //mapa
  THamMap = class(TObject)
  private
    fHeadFile,fDataFile:String;
    fDxDraw:TDxDraw;
    //
    fEnabled:Boolean;
    //
    fHead,fData:TMemoryStream;
    fHeadInfo:THeadInfo;
    fDataInfo:TDataInfo;
    //
    DrawBuffer:Array of TPoint;
    InfoBuffer:Array of TPoint;
    fLocList:pLocList;
    //
    fDrawThreads:TThreadList;
    //
    fCenter:TSPoint;
    fZoom:Single;
    fOptions:TMapOptions;
    //
    procedure StartDraw;
    procedure OnDrawThreadTerminate(Sender: TObject);
    procedure SetOptions(Value:TMapOptions);
  public
    //
    constructor Create;
    destructor Destroy; override;
    //
    procedure LoadFromFile(HeadFile,DataFile:String);
    procedure Draw(x,y,z:Single; Options:TMapOptions; SetOnly:Boolean);
    procedure ReDraw;
    procedure ZoomToCenter(dz:Single);
    procedure ZoomToPoint(x,y:Integer; dz:Single);
    procedure ScrollS(dx,dy:Single);
    procedure ScrollP(dx,dy:Integer);
    //
    procedure Point2XY(x,y:Integer; var sx,sy:Single);
    function GetPolygonInfoAtXY(x,y:Integer):String;
    //
    property HeadFile:String read fHeadFile;
    property DataFile:String read fDataFile;
    property LocList:pLocList read fLocList write fLocList;
    property DxDraw:TDxDraw read fDxDraw write fDxDraw;
    //
    property Center:TSPoint read fCenter;
    property Zoom:Single read fZoom;
    property Options:TMapOptions read fOptions write SetOptions;
  end;
  //vykresleni mapy
  TMapDraw = class(TThread)
  private
    fHeadInfo:THeadInfo;
    fDataInfo:TDataInfo;
    fBuffer:pPoint;

    fDxDraw:TDxDraw;
    fZoom:Single;
    fMapOptions:TMapOptions;
    fLocList:pLocList;
    pMapRect:TRect;
    sMapRect:TSRect;
  protected
    procedure Execute; override;
  public
    constructor Create(HeadInfo:THeadInfo; DataInfo:TDataInfo; Buffer:pPoint;
      LocList:pLocList; DxDraw:TDxDraw; Zoom:Single; Center:TSPoint;
      Options:TMapOptions; fOnTerminate:TNotifyEvent);
  end;

implementation

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

//------------------------------------------------------------------------------

//vytvoreni
constructor THamMap.Create;
begin
  inherited Create;
  fDrawThreads:=TThreadList.Create;
  fHead:=TMemoryStream.Create;
  fData:=TMemoryStream.Create;
  //
  fEnabled:=False;
  fCenter.x:=0;
  fCenter.y:=0;
  fZoom:=0;
end;

//uvolneni
destructor THamMap.Destroy;
begin
  fDrawThreads.Destroy;
  fHead.Free;
  fData.Free;
  inherited Destroy;
end;

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
    fEnabled:=True;
  except
    fHead.Clear;
    fData.Clear;
    fHeadInfo.Mem:=nil;
    fHeadInfo.Count:=0;
    fDataInfo.Mem:=nil;
    fDataInfo.Count:=0;
    DrawBuffer:=nil;
    InfoBuffer:=nil;
    fEnabled:=False;
  end;
end;

//
procedure THamMap.Draw(x,y,z:Single; Options:TMapOptions; SetOnly:Boolean);
begin
  if x<-180 then x:=-180;
  if x>180 then x:=180;
  if y<-90 then y:=-90;
  if y>90 then y:=90;
  if z<MinZoom then z:=MinZoom;
  if z>MaxZoom then z:=MaxZoom;
  fCenter.x:=x;
  fCenter.y:=y;
  fZoom:=z;
  fOptions:=Options;
  if not SetOnly then StartDraw;
end;

procedure THamMap.ReDraw;
begin
  StartDraw;
end;

//zoom na stred
procedure THamMap.ZoomToCenter(dz:Single);
begin
  if (fZoom+dz<MinZoom)or(fZoom+dz>MaxZoom) then Exit;
  fZoom:=fZoom+dz;
  StartDraw;
end;

//zoom na stred
procedure THamMap.ZoomToPoint(x,y:Integer; dz:Single);
begin
  if (fZoom+dz<MinZoom)or(fZoom+dz>MaxZoom)or
     (x<0)or(x>fDxDraw.SurfaceWidth)or
     (y<0)or(y>fDxDraw.SurfaceHeight) then Exit;
  fCenter.x:=fCenter.x+0.5*(2*Power(10,-fZoom)*x-Power(10,-fZoom)*fDxDraw.SurfaceWidth-2*Power(10,-dz-fZoom)*x+Power(10,-dz-fZoom)*fDxDraw.SurfaceWidth)/px;
  fCenter.y:=fCenter.y+0.5*(2*Power(10,-fZoom-dz)*y-Power(10,-fZoom-dz)*fDxDraw.SurfaceHeight-2*Power(10,-fZoom)*y+Power(10,-fZoom)*fDxDraw.SurfaceHeight)/py;
  if fCenter.x<-180 then fCenter.x:=-180;
  if fCenter.x>180 then fCenter.x:=180;
  if fCenter.y<-90 then fCenter.y:=-90;
  if fCenter.y>90 then fCenter.y:=90;
  fZoom:=fZoom+dz;
  StartDraw;
end;

//posun
procedure THamMap.ScrollS(dx,dy:Single);
begin
  if (fCenter.x+dx<-180)or(fCenter.x+dx>180)or
     (fCenter.y+dy<-90)or(fCenter.y+dy>90) then Exit;
  fCenter.x:=fCenter.x+dx;
  fCenter.y:=fCenter.y+dy;
  StartDraw;
end;

procedure THamMap.ScrollP(dx,dy:Integer);
var
 sx,sy:Single;
begin
  sx:=0.5*(2*Power(10,-fZoom)*dx)/px;
  sy:=-0.5*(2*Power(10,-fZoom)*dy)/py;
  if (fCenter.x+sx<-180)or(fCenter.x+sx>180)or
     (fCenter.y+sy<-90)or(fCenter.y+sy>90) then Exit;
  fCenter.x:=fCenter.x+sx;
  fCenter.y:=fCenter.y+sy;
  StartDraw;
end;

//
procedure THamMap.Point2XY(x,y:Integer; var sx,sy:Single);
begin
  sx:=0.5*(2*Power(10,-fZoom)*x+2*px*fCenter.x-Power(10,-fZoom)*fDxDraw.SurfaceWidth)/px;
  sy:=-0.5*(2*Power(10,-fZoom)*y-2*py*fCenter.y-Power(10,-fZoom)*fDxDraw.SurfaceHeight)/py;
end;             

//vytvoreni kresliciho threadu
procedure THamMap.StartDraw;
var
  i:Integer;
begin
  if not fEnabled then raise Exception.Create('Vstupní data nejsou inicializována!');
  with fDrawThreads.LockList do
  try
    for i:=0 to Count-1 do TThread(Items[i]).Terminate;
    fDrawThreads.Add(TMapDraw.Create(
      fHeadInfo,fDataInfo,@DrawBuffer[0],fLocList,
      fDxDraw,fZoom,fCenter,fOptions,OnDrawThreadTerminate));
  finally
    fDrawThreads.UnlockList;
  end;
end;

//odstraneni ukonceneho threadu ze seznamu
procedure THamMap.OnDrawThreadTerminate(Sender: TObject);
var
  i:Integer;
begin
  with fDrawThreads.LockList do
  try
    for i:=0 to Count-1 do
      if Sender=Items[i] then
      begin
        Delete(i);
        Exit;
      end;
  finally
    fDrawThreads.UnlockList;
  end;
end;

//
procedure THamMap.SetOptions(Value:TMapOptions);
begin
  fOptions:=Value;
  StartDraw;
end;

//
function THamMap.GetPolygonInfoAtXY(x,y:Integer):String;
var
  Head:pHeadRec;
  Data:pDataRec;
  hCount,dCount:Cardinal;
  i:Integer;
  zx,zy:Single;
  SegmentRect:TRect;
  aPoint,lPoint:TPoint;
  Polygon:pPoint;
  Origin:TSPoint;

 //je bod soucasti polygonu?
 function PointInPolygon(Polygon:PPoints; Count:Integer; p:TPoint):Boolean;
 var
   j,k:Integer;
 begin
   Result:=False;
   j:=Count;
   for k:=1 to j do
   begin
     if ((Polygon^[k].Y<=p.Y)and(p.Y<Polygon^[j].Y)) or
        ((Polygon^[j].Y<=p.Y)and(p.Y<Polygon^[k].Y)) then
       if (p.x<(Polygon^[j].X-Polygon^[k].X)*(p.y-Polygon^[k].Y)/
          (Polygon^[j].Y-Polygon^[k].Y)+Polygon^[k].X) then Result:=not Result;
     j:=k;
   end;
 end;

begin
  Result:='';
  zx:=Power(10,Zoom)*px;
  zy:=Power(10,Zoom)*py;
  Origin.x:=0.5*(2*px*fCenter.x-Power(10,-fZoom)*fDxDraw.SurfaceWidth)/px;
  Origin.y:=-0.5*(-2*py*fCenter.y-Power(10,-fZoom)*fDxDraw.SurfaceHeight)/py;
  //
  hCount:=fHeadInfo.Count;
  Head:=fHeadInfo.Mem;
  while hCount<>0 do
  begin
    //nacist hlavicku polygonu
    SegmentRect.Left:=Round(zx*(Head^.Left-Origin.x));
    SegmentRect.Right:=Round(zx*(Head^.Right-Origin.x));
    SegmentRect.Top:=Round(zy*(Origin.y-Head^.Top));
    SegmentRect.Bottom:=Round(zy*(Origin.y-Head^.Bottom));
    //
    if PtInRect(SegmentRect,Point(x,y)) then
    begin
      i:=0;
      lPoint:=Point(0,0);
      Data:=Pointer(Cardinal(fDataInfo.Mem)+Head^.DataIndex);
      dCount:=Head^.DataSize;
      Polygon:=@InfoBuffer[0];
      while dCount<>0 do
      begin
        aPoint.X:=Round(zx*(Data^-Origin.x));
        Inc(Data);
        aPoint.Y:=Round(zy*(Origin.y-Data^));
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
      if PointInPolygon(@InfoBuffer[0],i,Point(x,y)) then
      begin
        Result:=Head^.ID1+' ('+Head^.ID2+')';
        Exit;
      end;
    end;
    Inc(Head);
    Dec(hCount);
  end;
end;

//------------------------------------------------------------------------------

//je obdelnik soucasti obdelniku?
function pRectInRect(sr,mr:TRect):Boolean;
begin
  Result:=not((sr.Left>mr.Right)or(sr.Right<mr.Left)or
              (sr.Top>mr.Bottom)or(sr.Bottom<mr.Top));
end;

//------------------------------------------------------------------------------

//vytvoreni
constructor TMapDraw.Create(HeadInfo:THeadInfo; DataInfo:TDataInfo; Buffer:pPoint;
  LocList:pLocList; DxDraw:TDxDraw; Zoom:Single; Center:TSPoint;
  Options:TMapOptions; fOnTerminate:TNotifyEvent);

begin
  inherited Create(True);
  FreeOnTerminate:=True;
  Priority:=tpHighest;
//  Priority:=tpHigher;
  OnTerminate:=fOnTerminate;
  //
  fHeadInfo:=HeadInfo;
  fDataInfo:=DataInfo;
  fBuffer:=Buffer;
  fLocList:=LocList;
  //
  fZoom:=Zoom;
  fDxDraw:=DxDraw;
  fMapOptions:=Options;
  //
  with sMapRect do
  begin
    Left:=Center.x-fDxDraw.SurfaceWidth/(Power(10,fZoom)*px*2);
    Top:=Center.y+fDxDraw.SurfaceHeight/(Power(10,fZoom)*py*2);
    Right:=Center.x+fDxDraw.SurfaceWidth/(Power(10,fZoom)*px*2);
    Bottom:=Center.y-fDxDraw.SurfaceHeight/(Power(10,fZoom)*py*2);
  end;
  //
  with pMapRect do
  begin
    Left:=Round(Power(10,fZoom)*px*(-180-sMapRect.Left));
    Top:=Round(Power(10,fZoom)*py*(sMapRect.Top-90));
    Right:=Round(Power(10,fZoom)*px*(180-sMapRect.Left));
    Bottom:=Round(Power(10,fZoom)*py*(sMapRect.Top+90));
    if Left<0 then Left:=0;
    if Top<0 then Top:=0;
    if Right>fDxDraw.SurfaceWidth then Right:=fDxDraw.SurfaceWidth;
    if Bottom>fDxDraw.SurfaceHeight then Bottom:=fDxDraw.SurfaceHeight;
  end;
  //
  Resume;
end;

//------------------------------------------------------------------------------
//vykresleni
procedure TMapDraw.Execute;
var
  Head:pHeadRec;
  Data:pDataRec;
  hCount,dCount:Cardinal;
  i:Integer;
  zx,zy:Single;
  DrawRect,SegmentRect:TRect;
  aPoint,lPoint:TPoint;
  Polygon:pPoint;

 //ramecek kolem mapy
 procedure DrawFrame;
 var
   cHandle:THandle;
 begin
   with fDxDraw,Surface.Canvas do
   begin
     Pen.Width:=2;
     Pen.Style:=psSolid;
     Pen.Color:=clBlack;
     cHandle:=Handle;
     if pMapRect.Left>0 then
     begin
       Windows.MoveToEx(cHandle,pMapRect.Left,pMapRect.Top,nil);
       Windows.LineTo(cHandle,pMapRect.Left,pMapRect.Bottom);
     end;
     if pMapRect.Right<SurfaceWidth then
     begin
       Windows.MoveToEx(cHandle,pMapRect.Right,pMapRect.Top,nil);
       Windows.LineTo(cHandle,pMapRect.Right,pMapRect.Bottom);
     end;
     if pMapRect.Top>0 then
     begin
       Windows.MoveToEx(cHandle,pMapRect.Left,pMapRect.Top,nil);
       Windows.LineTo(cHandle,pMapRect.Right,pMapRect.Top);
     end;
     if pMapRect.Bottom<SurfaceHeight then
     begin
       Windows.MoveToEx(cHandle,pMapRect.Left,pMapRect.Bottom,nil);
       Windows.LineTo(cHandle,pMapRect.Right,pMapRect.Bottom);
     end;
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
   with fDxDraw,Surface.Canvas do
   begin
     Pen.Width:=1;
     Brush.Style:=bsClear;
     Pen.Color:=clBlack;
     Pen.Style:=psDot;
     cHandle:=Handle;
     //x
     y1:=pMapRect.Top;
     y2:=pMapRect.Bottom;
     if sMapRect.Left<-180 then sx:=-180 else sx:=sMapRect.Left;
     sx:=Ceil(sx/20)*20;
     if sMapRect.Right>180 then sy:=180 else sy:=sMapRect.Right;
     i:=Trunc((sy-sx)/20)+1;
     while (not Terminated)and(i>0) do
     begin
       x1:=Round(zx*(sx-sMapRect.Left));
       Windows.MoveToEx(cHandle,x1,y1,nil);
       Windows.LineTo(cHandle,x1,y2);
       sx:=sx+20;
       Dec(i);
     end;
     //y
     x1:=pMapRect.Left;
     x2:=pMapRect.Right;
     if sMapRect.Bottom<-90 then sy:=-90 else sy:=sMapRect.Bottom;
     sy:=Ceil(sy/10)*10;
     if sMapRect.Top>90 then sx:=90 else sx:=sMapRect.Top;
     i:=Trunc((sx-sy)/10)+1;
     while (not Terminated)and(i>0) do
     begin
       y1:=Round(zy*(sMapRect.Top-sy));
       Windows.MoveToEx(cHandle,x1,y1,nil);
       Windows.LineTo(cHandle,x2,y1);
       sy:=sy+10;
       Dec(i);
     end;
     //
     Pen.Style:=psDashDot;
     x1:=pMapRect.Left;
     x2:=pMapRect.Right;
     cHandle:=Handle;
     //obratnik raka
     if (23.45<=sMapRect.Top)and(23.45>=sMapRect.Bottom) then
     begin
       y1:=Round(zy*(sMapRect.Top-23.45));
       Windows.MoveToEx(cHandle,x1,y1,nil);
       Windows.LineTo(cHandle,x2,y1);
     end;
     //obratnik kozoroha
     if (-23.45<=sMapRect.Top)and(-23.45>=sMapRect.Bottom) then
     begin
       y1:=Round(zy*(sMapRect.Top+23.45));
       Windows.MoveToEx(cHandle,x1,y1,nil);
       Windows.LineTo(cHandle,x2,y1);
     end;
     //
     Pen.Style:=psSolid;
     //rovnik
     if (0<=sMapRect.Top)and(0>=sMapRect.Bottom) then
     begin
       y1:=Round(zy*sMapRect.Top);
       Windows.MoveToEx(cHandle,x1,y1,nil);
       Windows.LineTo(cHandle,x2,y1);
     end;
     //0 polednik
     if (0<=sMapRect.Right)and(0>=sMapRect.Left) then
     begin
       x1:=Round(-zx*sMapRect.Left);
       y1:=pMapRect.Top;
       y2:=pMapRect.Bottom;
       Windows.MoveToEx(cHandle,x1,y1,nil);
       Windows.LineTo(cHandle,x1,y2);
     end;
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
    List:PLocList;
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
   with fDxDraw,Surface.Canvas do
   begin
     Brush.Style:=bsClear;
     //**** male ctverce ****
     if fZoom>=0.25 then
     begin
       Pen.Width:=1;
       Pen.Style:=psDot;
       Pen.Color:=clGray;
       cHandle:=Handle;
       //x
       y1:=pMapRect.Top;
       y2:=pMapRect.Bottom;
       if sMapRect.Left<-180 then sx:=-180 else sx:=sMapRect.Left;
       sx:=Ceil(sx/2)*2;
       if sMapRect.Right>180 then s:=180 else s:=sMapRect.Right;
       i:=Trunc((s-sx)/2)+1;
       while (not Terminated)and(i>0) do
       begin
         x1:=Round(zx*(sx-sMapRect.Left));
         Windows.MoveToEx(cHandle,x1,y1,nil);
         Windows.LineTo(cHandle,x1,y2);
         sx:=sx+2;
         Dec(i);
       end;
       //y
       x1:=pMapRect.Left;
       x2:=pMapRect.Right;
       if sMapRect.Bottom<-90 then sy:=-90 else sy:=sMapRect.Bottom;
       sy:=Ceil(sy);
       if sMapRect.Top>90 then s:=90 else s:=sMapRect.Top;
       j:=Trunc(s-sy)+1;
       while (not Terminated)and(j>0) do
       begin
         y1:=Round(zy*(sMapRect.Top-sy));
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
     y1:=pMapRect.Top;
     y2:=pMapRect.Bottom;
     if sMapRect.Left<-180 then sx:=-180 else sx:=sMapRect.Left;
     sx:=Ceil(sx/20)*20;
     if sMapRect.Right>180 then s:=180 else s:=sMapRect.Right;
     i:=Trunc((s-sx)/20)+1;
     while (not Terminated)and(i>0) do
     begin
       x1:=Round(zx*(sx-sMapRect.Left));
       Windows.MoveToEx(cHandle,x1,y1,nil);
       Windows.LineTo(cHandle,x1,y2);
       sx:=sx+20;
       Dec(i);
     end;
     //y
     x1:=pMapRect.Left;
     x2:=pMapRect.Right;
     if sMapRect.Bottom<-90 then sy:=-90 else sy:=sMapRect.Bottom;
     sy:=Ceil(sy/10)*10;
     if sMapRect.Top>90 then s:=90 else s:=sMapRect.Top;
     j:=Trunc((s-sy)/10)+1;
     while (not Terminated)and(j>0) do
     begin
       y1:=Round(zy*(sMapRect.Top-sy));
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
     if sMapRect.Bottom<-90 then sy:=-90 else sy:=sMapRect.Bottom;
     sy:=Ceil(sy/10)*10-10;
     if sy<-90 then sy:=-90;
     if sMapRect.Top>90 then s:=90 else s:=sMapRect.Top;
     j:=Trunc((s-sy)/10)+1;
     if sy+10*j>90 then Dec(j);
     while (not Terminated)and(j>0) do
     begin
       //x
       if sMapRect.Left<-180 then sx:=-180 else sx:=sMapRect.Left;
       sx:=Ceil(sx/20)*20-20;
       if sx<-180 then sx:=-180;
       if sMapRect.Right>180 then s:=180 else s:=sMapRect.Right;
       i:=Trunc((s-sx)/20)+1;
       if sx+20*i>180 then Dec(i);
       TxtRect.Top:=Round(zy*(sMapRect.Top-sy-10));
       TxtRect.Bottom:=TxtRect.Top+h;
       while (not Terminated)and(i>0) do
       begin
         Loc:=Copy(S2Loc(sx+10,sy+5),1,2);
         TxtRect.Left:=Round(zx*(sx-sMapRect.Left));
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
       if sMapRect.Bottom<-90 then sy:=-90 else sy:=sMapRect.Bottom;
       sy:=Ceil(sy)-1;
       if sy<-90 then sy:=-90;
       if sMapRect.Top>90 then s:=90 else s:=sMapRect.Top;
       j:=Trunc(s-sy)+1;
       if sy+1*j>90 then Dec(j);
       while (not Terminated)and(j>0) do
       begin
         //x
         if sMapRect.Left<-180 then sx:=-180 else sx:=sMapRect.Left;
         sx:=Ceil(sx/2)*2-2;
         if sx<-180 then sx:=-180;
         if sMapRect.Right>180 then s:=180 else s:=sMapRect.Right;
         i:=Trunc((s-sx)/2)+1;
         if sx+2*i>180 then Dec(i);
         TxtRect.Top:=Round(zy*(sMapRect.Top-sy-1));
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
           TxtRect.Left:=Round(zx*(sx-sMapRect.Left));
           TxtRect.Right:=TxtRect.Left+w;
           Windows.DrawText(Handle,PChar(Loc),-1,TxtRect,tOptions);
           sx:=sx+2;
           Dec(i);
         end;
         sy:=sy+1;
         Dec(j);
       end;
     end;
     Release;
   end;
 end;

begin
  i:=1000;
  while (not fDxDraw.CanDraw)and(not Terminated)and(i<>0) do
  begin
    Sleep(1);
    Dec(i);
  end;
  if (Terminated)or(not fDxDraw.CanDraw) then Exit;
  //
  zx:=Power(10,fZoom)*px;
  zy:=Power(10,fZoom)*py;
  //
  fDxDraw.Surface.Canvas.Lock;
  try
    //inicializace promennych
    DrawRect:=fDxDraw.ClientRect;
    //
    with fDxDraw.Surface.Canvas do
    begin
      //vyplnit cele platno
      Brush.Style:=bsSolid;
      Brush.Color:=clBackGround;
      FillRect(DrawRect);
      //ocean
      Brush.Color:=clOcean;
      FillRect(Rect(pMapRect.Left,pMapRect.Top,pMapRect.Right,pMapRect.Bottom));
      //
      Pen.Style:=psSolid;
      Pen.Width:=1;
      Pen.Color:=clBlack;
    end;
    //**************************************************************************
    //vykreslit polygony
    hCount:=fHeadInfo.Count;
    Head:=fHeadInfo.Mem;
    while (not Terminated)and(hCount<>0) do
    begin
      //nacist hlavicku polygonu
      SegmentRect.Left:=Round(zx*(Head^.Left-sMapRect.Left));
      SegmentRect.Right:=Round(zx*(Head^.Right-sMapRect.Left));
      SegmentRect.Top:=Round(zy*(sMapRect.Top-Head^.Top));
      SegmentRect.Bottom:=Round(zy*(sMapRect.Top-Head^.Bottom));
      //neni mimo obraz?
      if not((SegmentRect.Left>DrawRect.Right)or(SegmentRect.Right<DrawRect.Left)or
             (SegmentRect.Top>DrawRect.Bottom)or(SegmentRect.Bottom<DrawRect.Top)) then
      begin
        i:=0;
        lPoint:=Point(0,0);
        Data:=Pointer(Cardinal(fDataInfo.Mem)+Head^.DataIndex);
        dCount:=Head^.DataSize;
        Polygon:=fBuffer;
        while (not Terminated)and(dCount<>0) do
        begin
          aPoint.X:=Round(zx*(Data^-sMapRect.Left));
          Inc(Data);
          aPoint.Y:=Round(zy*(sMapRect.Top-Data^));
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
        fDxDraw.Surface.Canvas.Brush.Color:=Colors[Head^.Color];
        if not Terminated then
          Windows.Polygon(fDxDraw.Surface.Canvas.Handle,fBuffer^,i);
      end;
      Inc(Head);
      Dec(hCount);
    end;
    fDxDraw.Surface.Canvas.Release;
    //
    if (not Terminated)and(moWWLGrid in fMapOptions) then lGrid(zx,zy);
    if (not Terminated)and(moGeoGrid in fMapOptions) then gGrid(zx,zy);
    if (not Terminated) then DrawFrame;
  finally
    if not Terminated then fDxDraw.Flip; {nastavi kreslenou plochu jako viditelnou}
    fDxDraw.Surface.Canvas.UnLock;
  end;
end;

end.
