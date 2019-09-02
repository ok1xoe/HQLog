{$include global.inc}
unit MapForm;

interface

uses
  Windows, Forms, ImgList, Controls, Dialogs, ExtDlgs, Classes, ActnList,
  XPStyleActnCtrls, ActnMan, ComCtrls, ToolWin, ActnCtrls, ActnMenus,
  SysUtils, Graphics, Jpeg, DXDraws, MapCore,
  DbTables, HQLDialogs, DXClass, Messages, WWLGrid, HQLDatabase, HQLConsts;

type
  TfrmMap = class(TForm)
    stBar: TStatusBar;
    actMainMenuBar: TActionMainMenuBar;
    actManager: TActionManager;
    actWWLGrid: TAction;
    actGeoGrid: TAction;
    actExport: TAction;
    actExit: TAction;
    dlgSave: TSavePictureDialog;
    tlBar: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    actZoomIn: TAction;
    actZoomOut: TAction;
    ToolButton3: TToolButton;
    actScrollLeft: TAction;
    actScrollRight: TAction;
    actScrollUp: TAction;
    actScrollDown: TAction;
    DxDrawMap: TDXDraw;
    imgList: TImageList;
    //
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure FormMouseWheel(Sender: TObject; Shift: TShiftState;
      WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    //
    procedure DxDrawMapMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure DxDrawMapMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    //
    procedure dlgSaveCanClose(Sender: TObject; var CanClose: Boolean);
    //
    procedure actExitExecute(Sender: TObject);
    procedure actExportExecute(Sender: TObject);
    procedure actZoomInExecute(Sender: TObject);
    procedure actZoomOutExecute(Sender: TObject);
    procedure actWWLGridExecute(Sender: TObject);
    procedure actGeoGridExecute(Sender: TObject);
    procedure actScrollLeftExecute(Sender: TObject);
    procedure actScrollRightExecute(Sender: TObject);
    procedure actScrollUpExecute(Sender: TObject);
    procedure actScrollDownExecute(Sender: TObject);
  private
    { Private declarations }
    fRootDir:String;
    fCall:String;
    //
    HamMap:THamMap;
    LocList:TLocList;
    fMyPosX,fMyPosY:Double;
    lx,ly:Integer;
  public
    { Public declarations }
  end;

var
  frmMap: TfrmMap;

implementation

uses Main, HQLdMod;
{$R *.dfm}

//------------------------------------------------------------------------------
//frmMap
//------------------------------------------------------------------------------

//vytvoreni formulare
procedure TfrmMap.FormCreate(Sender: TObject);
var
  Options:TMapOptions;

{ procedure GetLocList(List:pLocList);
 var
   qList:TQuery;
   i:Integer;
 begin
   qList:=TQuery.Create(nil);
   with qList do
   try
     DatabaseName:=BDEAlias;
     SQL.Clear;
     SQL.Add('SELECT DISTINCT SUBSTRING('+dfnLOCp+' FROM 1 FOR 4) TrimLoc FROM "'+fCall+'" WHERE '+dfnLOCp+'<>"" ORDER BY TrimLoc');
     Open;
     SetLength(List^,RecordCount);
     i:=0;
     while not Eof do
     begin
       List^[i]:=Fields.Fields[0].AsString;
       Next;
       Inc(i);
     end;
     Close;
   finally
     qList.Free;
   end;
 end;}

begin
  fRootDir:=dmLog.RootDir;
  //vytvorit objekty
  HamMap:=THamMap.Create;
  HamMap.DxDraw:=DxDrawMap;
  //nacist nastaveni
  HamMap.LoadFromFile(fRootDir+MapHead_File,fRootDir+MapData_File);
  with dmLog.User do
  begin
    fCall:=Call;
    Width:=Map_Width;
    Height:=Map_Height;
    if Map_Maximized then WindowState:=wsMaximized
                     else WindowState:=wsNormal;
    Loc2S(Loc,fMyPosX,fMyPosY);
    actWWLGrid.Checked:=Map_WWLGrid;
    actGeoGrid.Checked:=Map_GeoGrid;
    Options:=[];
    if Map_WWLGrid then Options:=Options+[moWWLGrid];
    if Map_GeoGrid then Options:=Options+[moGeoGrid];
    HamMap.Draw(Map_CenterX,Map_CenterY,Map_Zoom,Options,True);
  end;
end;

//uvolneni formulare
procedure TfrmMap.FormDestroy(Sender: TObject);
begin
  //ulozit nastaveni
  with dmLog.User do
  begin
    Map_WWLGrid:=actWWLGrid.Checked;
    Map_GeoGrid:=actGeoGrid.Checked;
    if WindowState=wsMaximized then Map_Maximized:=True else
    begin
      Map_Width:=Width;
      Map_Height:=Height;
      Map_Maximized:=False;
    end;
  end;
  //uvolnit objekty
  HamMap.Free;
end;

//stisk klavesy
procedure TfrmMap.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    107: HamMap.ZoomToCenter(0.125);
    109: HamMap.ZoomToCenter(-0.125);
    VK_Left: HamMap.ScrollP(-50,0);
    VK_Right: HamMap.ScrollP(50,0);
    VK_Up: HamMap.ScrollP(0,-50);
    VK_Down: HamMap.ScrollP(0,50);
  end;
end;

//kolecko mysi
procedure TfrmMap.FormMouseWheel(Sender: TObject; Shift: TShiftState;
  WheelDelta: Integer; MousePos: TPoint; var Handled: Boolean);
begin
  if WheelDelta>0 then HamMap.ZoomToPoint(MousePos.X-dxDrawMap.ClientOrigin.X,
                                          MousePos.Y-dxDrawMap.ClientOrigin.Y,
                                          0.125);
  if WheelDelta<0 then HamMap.ZoomToPoint(MousePos.X-dxDrawMap.ClientOrigin.X,
                                          MousePos.Y-dxDrawMap.ClientOrigin.Y,
                                          -0.125);
end;

procedure TfrmMap.FormResize(Sender: TObject);
begin
  HamMap.ReDraw;
end;

procedure TfrmMap.FormShow(Sender: TObject);
begin
  HamMap.ReDraw;
end;

//------------------------------------------------------------------------------
//DxDrawMap
//------------------------------------------------------------------------------

//stisk mysi
procedure TfrmMap.DxDrawMapMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
//  DxDrawMap.Cursor:=crHandDrag;
  DxDrawMap.Perform(WM_SETCURSOR, DxDrawMap.Handle, HTCLIENT);
  lx:=x;
  ly:=y;
end;

//pohyb mysi
procedure TfrmMap.DxDrawMapMouseMove(Sender: TObject; Shift: TShiftState;
  X, Y: Integer);
var
  sx,sy:Single;
  d,a:Double;
begin
  if Shift=[ssLeft] then
  begin
    HamMap.ScrollP(lx-x,ly-y);
    lx:=x;
    ly:=y;
  end else
  begin
//    DxDrawMap.Cursor:=crHand;
    HamMap.Point2XY(x,y,sx,sy);
    Distance(fMyPosX,fMyPosY,sx,sy,d);
    Azimuth(fMyPosX,fMyPosY,sx,sy,a);
    if (sx>-180)and(sx<180)and(sy>-90)and(sy<90) then
    begin
{      stBar.Panels.Items[0].Text:=' '+FormatDeg(sx,false);
      stBar.Panels.Items[1].Text:=' '+FormatDeg(sy,true);}
      stBar.Panels.Items[2].Text:=' '+S2Loc(sx,sy);
      stBar.Panels.Items[3].Text:=' '+Format('%0:1.0fkm @ %1:1.0f°',[d,a]);
      stBar.Panels.Items[4].Text:=' '+HamMap.GetPolygonInfoAtXY(x,y);
    end else
    begin
      stBar.Panels.Items[0].Text:='';
      stBar.Panels.Items[1].Text:='';
      stBar.Panels.Items[2].Text:='';
      stBar.Panels.Items[3].Text:='';
      stBar.Panels.Items[4].Text:='';
    end;
  end;
end;

//------------------------------------------------------------------------------
//OnActExecute
//------------------------------------------------------------------------------

//zavrit
procedure TfrmMap.actExitExecute(Sender: TObject);
begin
  Close;
end;

//export obrazku
procedure TfrmMap.actExportExecute(Sender: TObject);
var
  imgBMP:TBitmap;
  imgJPG:TJpegImage;
  fName:String;
begin
  if not dlgSave.Execute then Exit;
  fName:=dlgSave.FileName;
  if ExtractFileExt(fName)='' then
    case dlgSave.FilterIndex of
      1: fName:=ChangeFileExt(fName,'.jpg');
      2: fName:=ChangeFileExt(fName,'.bmp');
    end;
  imgBMP:=TBitmap.Create;
  try
    imgBMP.Width:=dxDrawMap.SurfaceWidth;
    imgBMP.Height:=dxDrawMap.SurfaceHeight;
    imgBMP.Canvas.CopyRect(dxDrawMap.ClientRect,dxDrawMap.Surface.Canvas,dxDrawMap.ClientRect);
    case dlgSave.FilterIndex of
      1: begin
        imgJPG:=TJpegImage.Create;
        try
          imgJPG.Assign(imgBMP);
          imgJPG.SaveToFile(fName);
        finally
          imgJPG.Free;
        end;
      end;
      2: imgBMP.SaveToFile(fName);
    end;
  finally
    dxDrawMap.Surface.Canvas.Release;
    imgBMP.Free;
  end;
end;
//+canclose
procedure TfrmMap.dlgSaveCanClose(Sender: TObject; var CanClose: Boolean);
var
  fName:String;
begin
{  fName:=dlgSave.FileName;
  if ExtractFileExt(fName)='' then
    case dlgSave.FilterIndex of
      1: fName:=ChangeFileExt(fName,'.jpg');
      2: fName:=ChangeFileExt(fName,'.bmp');
    end;
  if (FileExists(fName))and
     (cMessageDlg(Format(strFileOverwriteQ,[fName]),mtWarning,[mbYes,mbNo],mrNo,0)<>mrYes)
    then CanClose:=False;}
end;

//zoom +
procedure TfrmMap.actZoomInExecute(Sender: TObject);
begin
  HamMap.ZoomToCenter(0.125);
end;

//zoom -
procedure TfrmMap.actZoomOutExecute(Sender: TObject);
begin
  HamMap.ZoomToCenter(-0.125);
end;

//WWL grid
procedure TfrmMap.actWWLGridExecute(Sender: TObject);
begin
  if TAction(Sender).Checked then HamMap.Options:=HamMap.Options+[moWWLGrid]
                             else HamMap.Options:=HamMap.Options-[moWWLGrid];
end;

//geo grid
procedure TfrmMap.actGeoGridExecute(Sender: TObject);
begin
  if TAction(Sender).Checked then HamMap.Options:=HamMap.Options+[moGeoGrid]
                             else HamMap.Options:=HamMap.Options-[moGeoGrid];
end;

//------------------------------------------------------------------------------

procedure TfrmMap.actScrollLeftExecute(Sender: TObject);
begin
  HamMap.ScrollP(-50,0);
end;

procedure TfrmMap.actScrollRightExecute(Sender: TObject);
begin
  HamMap.ScrollP(50,0);
end;

procedure TfrmMap.actScrollUpExecute(Sender: TObject);
begin
  HamMap.ScrollP(0,-50);
end;

procedure TfrmMap.actScrollDownExecute(Sender: TObject);
begin
  HamMap.ScrollP(0,50);
end;

initialization
  RegisterClass(TfrmMap);
finalization
  UnRegisterClass(TfrmMap);
end.

