unit HQLControls;

interface

uses
  SysUtils, Classes, Controls, StdCtrls;

type
  //RST Editor
  TReportEdit = class(TCustomEdit)
  private
    { Private declarations }
  protected
    { Protected declarations }
    procedure KeyPress(var Key: Char); override;
  public
    { Public declarations }
    constructor Create(AOwner:TComponent); override;
  published
    { Published declarations }
    property Anchors;
    property AutoSelect;
    property AutoSize;
    property BevelEdges;
    property BevelInner;
    property BevelKind default bkNone;
    property BevelOuter;
    property BiDiMode;
    property BorderStyle;
    property Color;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property ImeMode;
    property ImeName;
    property MaxLength;
    property OEMConvert;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property OnChange;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
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
  end;

  //Locator Editor
  TLocatorEdit = class(TCustomEdit)
  private
    { Private declarations }
  protected
    { Protected declarations }
    procedure KeyPress(var Key: Char); override; 
    property MaxLength;
  public
    { Public declarations }
    constructor Create(AOwner:TComponent); override;
  published
    { Published declarations }
    property Anchors;
    property AutoSelect;
    property AutoSize;
    property BevelEdges;
    property BevelInner;
    property BevelKind default bkNone;
    property BevelOuter;
    property BiDiMode;
    property BorderStyle;
    property Color;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property ImeMode;
    property ImeName;
    property OEMConvert;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property OnChange;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
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
  end;

  //IOTA Editor
  TIOTAEdit = class(TCustomEdit)
  private
    { Private declarations }
  protected
    { Protected declarations }
    procedure KeyPress(var Key: Char); override;
    procedure DoExit; override;
    property MaxLength;
  public
    { Public declarations }
    constructor Create(AOwner:TComponent); override;
    procedure DoFormat;
  published
    { Published declarations }
    property Anchors;
    property AutoSelect;
    property AutoSize;
    property BevelEdges;
    property BevelInner;
    property BevelKind default bkNone;
    property BevelOuter;
    property BiDiMode;
    property BorderStyle;
    property Color;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property ImeMode;
    property ImeName;
    property OEMConvert;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property OnChange;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
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
  end;

  //Time Editor
  TTimeEdit = class(TCustomEdit)
  private
    { Private declarations }
  protected
    { Protected declarations }
    procedure KeyPress(var Key: Char); override; 
    procedure DoExit; override;
    property MaxLength;
  public
    { Public declarations }
    constructor Create(AOwner:TComponent); override;
  published
    { Published declarations }
    property Anchors;
    property AutoSelect;
    property AutoSize;
    property BevelEdges;
    property BevelInner;
    property BevelKind default bkNone;
    property BevelOuter;
    property BiDiMode;
    property BorderStyle;
    property Color;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property ImeMode;
    property ImeName;
    property OEMConvert;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property OnChange;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
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
  end;

  //Date Editor
  TDateEdit = class(TCustomEdit)
  private
    { Private declarations }
  protected
    { Protected declarations }
    procedure KeyPress(var Key: Char); override;
    procedure DoExit; override;
    property MaxLength;
  public
    { Public declarations }
    constructor Create(AOwner:TComponent); override;
  published
    { Published declarations }
    property Anchors;
    property AutoSelect;
    property AutoSize;
    property BevelEdges;
    property BevelInner;
    property BevelKind default bkNone;
    property BevelOuter;
    property BiDiMode;
    property BorderStyle;
    property Color;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property HideSelection;
    property ImeMode;
    property ImeName;
    property OEMConvert;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property OnChange;
    property OnClick;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
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
  end;

  //Float ComboBox
  TFloatComboBox = class(TCustomComboBox)
  private
    fFormat:String;
    procedure SetFormat(Value:String);
  protected
    procedure KeyPress(var Key: Char); override;
    procedure DoExit; override;
    property MaxLength;
    property CharCase;
  public
    constructor Create(AOwner:TComponent); override;
  published
    property AutoComplete default True;
    property AutoDropDown default False;
    property AutoCloseUp default False;
    property BevelEdges;
    property BevelInner;
    property BevelKind default bkNone;
    property BevelOuter;
    property Style; {Must be published before Items}
    property Anchors;
    property BiDiMode;
    property Color;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragKind;
    property DragMode;
    property DropDownCount;
    property Enabled;
    property Font;
    property Format:String read fFormat write SetFormat;
    property ImeMode;
    property ImeName;
    property ItemHeight;
    property ItemIndex default -1;
    property ParentBiDiMode;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Sorted;
    property TabOrder;
    property TabStop;
    property Text;
    property Visible;
    property OnChange;
    property OnClick;
    property OnCloseUp;
    property OnContextPopup;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnDrawItem;
    property OnDropDown;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMeasureItem;
    property OnSelect;
    property OnStartDock;
    property OnStartDrag;
    property Items; { Must be published after OnMeasureItem }
  end;

procedure Register;

implementation

const
  sNumbers=['0'..'9'];
  sLowerCase=['a'..'z'];
  sUpperCase=['A'..'Z'];
  sLetters=sLowerCase+sUpperCase;

procedure Register;
begin
  RegisterComponents('HQLog',
    [TReportEdit,TLocatorEdit,TIOTAEdit,TTimeEdit,TDateEdit,
     TFloatComboBox]);
end;

//------------------------------------------------------------------------------
//TReportEdit
//------------------------------------------------------------------------------

constructor TReportEdit.Create(AOwner:TComponent);
begin
  inherited;
  MaxLength:=3;
end;

procedure TReportEdit.KeyPress(var Key: Char);
begin
  inherited;
  Key:=UpCase(Key);
  if not(Key in sNumbers+sUpperCase+[#8]) then Key:=#0;
end;

//------------------------------------------------------------------------------
//TLocatorEdit
//------------------------------------------------------------------------------

constructor TLocatorEdit.Create(AOwner:TComponent);
begin
  inherited;
  MaxLength:=6;
end;

procedure TLocatorEdit.KeyPress(var Key: Char);
begin
  inherited;
  Key:=UpCase(Key);
  case SelStart of
    0,1: if not(Key in ['A'..'R',#8]) then Key:=#0;
    2,3: if not(Key in ['0'..'9',#8]) then Key:=#0;
    4,5: if not(Key in ['A'..'X',#8]) then Key:=#0;
    6: if Key<>#8 then Key:=#0;
  else
    Key:=#0;
  end;
end;

//------------------------------------------------------------------------------
//TIOTAEdit
//------------------------------------------------------------------------------

constructor TIOTAEdit.Create(AOwner:TComponent);
begin
  inherited;
  MaxLength:=5;
end;

procedure TIOTAEdit.DoFormat;
var
  str:String;
begin
  str:=Text;
  case Length(str) of
    3: Insert('00',str,3);
    4: Insert('0',str,3);
  end;
  Text:=str;
end;

procedure TIOTAEdit.KeyPress(var Key: Char);
begin
  inherited;
  Key:=UpCase(Key);
  case SelStart of
    0,1: if not(Key in sUpperCase+[#8]) then Key:=#0;
    2,3,4: if not(Key in sNumbers+[#8]) then Key:=#0;
    5: if Key<>#8 then Key:=#0;
  else
    Key:=#0;
  end;
end;

procedure TIOTAEdit.DoExit;
begin
  DoFormat;
  inherited;
end;

//------------------------------------------------------------------------------
//TTimeEdit
//------------------------------------------------------------------------------

constructor TTimeEdit.Create(AOwner:TComponent);
begin
  inherited;
  MaxLength:=8;
end;

procedure TTimeEdit.KeyPress(var Key: Char);
var
  fText:String;
  fSelStart:Integer;
begin
  inherited;
  if (SelLength=Length(Text))and(Key in sNumbers+[#8]) then Clear else
  begin
    fText:=Text;
    fSelStart:=SelStart;
    case Key of
      '0'..'9':
         if Length(fText) in [2,5] then
         begin
           fText:=fText+':';
           fSelStart:=Length(fText);
         end;
      '.',',',':': begin
        if Length(fText) in [1,4] then
        begin
          Insert('0',fText,Length(fText));
          fText:=fText+':';
          fSelStart:=Length(fText);
        end;
        if fSelStart in [2,5] then Key:=':'
                              else Key:=#0;
      end;
      #8:;
    else
      Key:=#0;
    end;
    Text:=fText;
    SelStart:=fSelStart;
  end
end;

procedure TTimeEdit.DoExit;
var
  t:TDateTime;
begin
  t:=StrToTimeDef(Text,-1);
  if t<>-1 then Text:=FormatDateTime('hh:nn:ss',t);
  inherited;
end;

//------------------------------------------------------------------------------
//TTimeEdit
//------------------------------------------------------------------------------

constructor TDateEdit.Create(AOwner:TComponent);
begin
  inherited;
  MaxLength:=10;
end;

procedure TDateEdit.KeyPress(var Key: Char);
var
  fText:String;
  fSelStart:Integer;
begin
  inherited;
  if (SelLength=Length(Text))and(Key in sNumbers+[#8]) then Clear else
  begin
    fText:=Text;
    fSelStart:=SelStart;
    case Key of
      '0'..'9':
         if Length(fText) in [2,5] then
         begin
           fText:=Text+'.';
           fSelStart:=Length(fText);
         end;
      '.',',',':': begin
        if Length(fText) in [1,4] then
        begin
          Insert('0',fText,Length(fText));
          fText:=fText+'.';
          fSelStart:=Length(fText);
        end;
        if fSelStart in [2,5] then Key:='.'
                              else Key:=#0;
      end;
      #8:;
    else
      Key:=#0;
    end;
    Text:=fText;
    SelStart:=fSelStart;
  end
end;

procedure TDateEdit.DoExit;
var
  d:TDateTime;
begin
  d:=StrToDateDef(Text,-1);
  if d<>-1 then Text:=FormatDateTime('dd.mm.yyyy',d);
  inherited;
end;

//------------------------------------------------------------------------------
//TFloatComboBox
//------------------------------------------------------------------------------

constructor TFloatComboBox.Create(AOwner:TComponent);
begin
  inherited;
  fFormat:='0.###';
end;

procedure TFloatComboBox.KeyPress(var Key: Char);
var
  fText:String;
  fSelStart,i:Integer;
begin
  inherited;
  case Key of
    '0'..'9',#8:;
    '.',',': begin
      Key:=#0;
      fText:=Text;
      fSelStart:=SelStart+1;
      if fSelStart=1 then
      begin
        fText:='0'+fText;
        Inc(fSelStart);
      end;
      Insert(DecimalSeparator,fText,fSelStart);
      for i:=1 to Length(fText) do
        if (fText[i]=DecimalSeparator)and(i<>fSelStart) then
        begin
          Delete(fText,i,1);
          if i<fSelStart then Dec(fSelStart);
        end;
      Text:=fText;
      SelStart:=fSelStart;
    end;
  else
    Key:=#0;
  end;
end;

procedure TFloatComboBox.DoExit;
begin
  try
    Text:=FormatFloat(fFormat,StrToFloat(Text));
  except
  end;
  inherited;
end;

procedure TFloatComboBox.SetFormat(Value:String);
var
  i:Integer;
begin
  i:=1;
  while i<=Length(Value) do
  begin
    if not(Value[i] in ['0','#','.'])
      then Delete(Value,i,1)
      else Inc(i);
  end;
  fFormat:=Value;
end;

end.
