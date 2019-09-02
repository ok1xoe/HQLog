unit CfmDbGrid;

interface
uses DbGrids, Classes, Windows, Db, StdCtrls, Messages;

type
  TCfmDBGrid = class(TCustomDBGrid)
  private
    procedure WMVScroll(var Msg: TWMVScroll); message WM_VSCROLL;
  protected
    function DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean; override;
    function DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean; override;
  public
    property Canvas;
    property SelectedRows;
  published
    property Align;
    property Anchors;
    property BiDiMode;
    property BorderStyle;
    property Color;
    property Columns stored False; //StoreColumns;
    property Constraints;
    property Ctl3D;
    property DataSource;
    property DefaultDrawing;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property FixedColor;
    property Font;
    property ImeMode;
    property ImeName;
    property Options;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property Row;
    property RowCount;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property TitleFont;
    property Visible;
    property OnCellClick;
    property OnColEnter;
    property OnColExit;
    property OnColumnMoved;
    property OnDrawDataCell;  { obsolete }
    property OnDrawColumnCell;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEditButtonClick;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDock;
    property OnStartDrag;
    property OnTitleClick;
    property VisibleRowCount;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('HQLog', [TCfmDBGrid]);
end;

function TCfmDBGrid.DoMouseWheelDown(Shift: TShiftState; MousePos: TPoint): Boolean;
begin
//  if Assigned(DataSource)and(DataSource.State in [dsBrowse]) then
    DataSource.DataSet.Next;
  Result := True;
end;

function TCfmDBGrid.DoMouseWheelUp(Shift: TShiftState; MousePos: TPoint): Boolean;
begin
//  if Assigned(DataSource)and(DataSource.State in [dsBrowse]) then
    DataSource.DataSet.Prior;
  Result := True;
end;

procedure TCfmDBGrid.WMVScroll(var Msg: TWMVScroll);
begin
 if (Msg.ScrollCode=SB_THUMBTRACK)and(DataSource.DataSet.RecordCount<65535)
   then DataSource.DataSet.RecNo:=Word(msg.Pos)
   else inherited;
end;

end.
