{**************************************************************************************************}
{                                                                                                  }
{ VCL Functions Library                                                                                      }
{                                                                                                  }
{**************************************************************************************************}

unit cfmVCLUtils;

interface

uses Classes, Types, ComCtrls, Menus, ActnList, StdCtrls, SysUtils;

//StatusBar
function StBarPanelAtXY(StatusBar: TStatusBar; const Point: TPoint): Integer;

//Menu
procedure MenuAddDiv(Items: TMenuItem);
procedure MenuAddItem(Items: TMenuItem; Action: TAction; Tag: Integer = 0); overload;
procedure MenuAddItem(Items: TMenuItem; const Caption: String; Checked: Boolean;
  OnClick: TNotifyEvent; Tag: Integer = 0); overload;

//
procedure SetComboBox(Box: TCustomComboBox; const Data: Array of String;
  Default: Integer = 0); overload;
procedure SetComboBox(Box: TCustomComboBox; const Data: Array of String;
  Min, Max: Integer; Default: Integer = 0); overload;
procedure SetComboBox(Box: TCustomComboBox; const Data: Array of Double;
  Default: Integer = 0); overload;
procedure SetComboBox(Box: TCustomComboBox; const Data: Array of Double;
  Min, Max: Integer; Default: Integer = 0); overload;

implementation

//Get status bar panel index at Point
function StBarPanelAtXY(StatusBar: TStatusBar; const Point: TPoint): Integer;
var
  i, pnlLeft: Integer;
begin
  Result:=-1;
  if StatusBar.Panels.Count = 0 then Exit;
  pnlLeft:=0;
  with StatusBar, StatusBar.Panels do
  for i:=0 to Count-1 do
  begin
    if (i < Count-1) and (Point.X > pnlLeft + 2) and (Point.X < pnlLeft + Items[i].Width - 1) or
       (i = Count-1) and (Point.X > pnlLeft + 2) then
    begin
      Result:=i;
      Exit;
    end;
    Inc(pnlLeft, Items[i].Width);
  end;
end;

//------------------------------------------------------------------------------

//Create menu separator
procedure MenuAddDiv(Items:TMenuItem);
var
  Item: TMenuItem;
begin
  Item:=TMenuItem.Create(Items);
  Item.Caption:='-';
  Items.Add(Item);
end;

//Create menu item with Action
procedure MenuAddItem(Items: TMenuItem; Action: TAction; Tag: Integer);
var
  Item: TMenuItem;
begin
  Item:=TMenuItem.Create(Items);
  Item.Action:=Action;
  Item.Tag:=Tag;
  Items.Add(Item);
end;

//Create menu item
procedure MenuAddItem(Items: TMenuItem; const Caption: String; Checked: Boolean;
  OnClick: TNotifyEvent; Tag: Integer);
var
  Item: TMenuItem;
begin
  Item:=TMenuItem.Create(Items);
  Item.Caption:=Caption;
  Item.Checked:=Checked;
  Item.OnClick:=OnClick;
  Item.Tag:=Tag;
  Items.Add(Item);
end;

//------------------------------------------------------------------------------
//Set ComboBox Items

procedure SetComboBox(Box: TCustomComboBox; const Data: Array of String;
  Default: Integer = 0);
var
  i: Integer;
begin
  Box.Items.Clear;
  for i:=Low(Data) to High(Data) do
    Box.Items.Add(Data[i]);
  Box.ItemIndex:=Default;
end;

procedure SetComboBox(Box: TCustomComboBox; const Data: Array of String;
  Min, Max: Integer; Default: Integer = 0);
begin
  Box.Items.Clear;
  for Min:=Min to Max do
    Box.Items.Add(Data[Min]);
  Box.ItemIndex:=Default;
end;

procedure SetComboBox(Box: TCustomComboBox; const Data: Array of Double;
  Default: Integer = 0);
var
  i:Integer;
begin
  Box.Items.Clear;
  for i:=Low(Data) to High(Data) do
    Box.Items.Add(FloatToStr(Data[i]));
  Box.ItemIndex:=Default;
end;

procedure SetComboBox(Box: TCustomComboBox; const Data: Array of Double;
  Min, Max: Integer; Default: Integer = 0);
begin
  Box.Items.Clear;
  for Min:=Min to Max do
    Box.Items.Add(FloatToStr(Data[Min]));
  Box.ItemIndex:=Default;
end;

end.
