{$include global.inc}
unit Find;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ActnList, XPStyleActnCtrls, ActnMan, HQLResStrings, StrUtils,
  DB, cfmDialogs, HQLDatabase, HQLConsts, Masks, CFMDbGrid;

type
  TFindFType=(ftDate,ftCall,ftLOC,ftIOTA,ftText);
  //
  TfrmFind = class(TForm)
    cbBoxField: TComboBox;
    chBoxCase: TCheckBox;
    actManager: TActionManager;
    actFind: TAction;
    actClose: TAction;
    btnClose: TButton;
    btnFind: TButton;
    cbBoxData: TComboBox;
    lblData: TLabel;
    lblField: TLabel;
    chBoxFirst: TCheckBox;
    Label1: TLabel;
    actHelp: TAction;
    //frmFind
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    //cbBoxData
    procedure cbBoxDataChange(Sender: TObject);
    procedure cbBoxDataKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure cbBoxDataKeyPress(Sender: TObject; var Key: Char);
    //cbBoxField
    procedure cbBoxFieldChange(Sender: TObject);
    //chBoxFirst
    procedure chBoxFirstChange(Sender: TObject);
    //akce
    procedure actFindExecute(Sender: TObject);
    procedure actCloseExecute(Sender: TObject);
    procedure actHelpExecute(Sender: TObject);
  private
    { Private declarations }
    fDataSet:TDataSet;
    fDbGrid:TCfmDbGrid;
    fFieldIndex:Array of Integer;
    fFieldType:Array of TFindFType;
  public
    { Public declarations }
    procedure InitDialog(DataSet:TDataSet; DbGrid:TCfmDbGrid;
      const FieldIndex:Array of Integer; const FieldType:Array of TFindFType;
      const FieldName:Array of String);
  end;

var
  frmFind: TfrmFind;

implementation

uses HamLogFP,KeyFilters,Kontrola, HQLdMod;

{$R *.dfm}

//------------------------------------------------------------------------------
//frmFind
//------------------------------------------------------------------------------

//pri vytvoreni formulare
procedure TfrmFind.FormCreate(Sender: TObject);
begin
  chBoxFirst.Checked:=True;
end;

//pri zobrazeni
procedure TfrmFind.FormShow(Sender: TObject);
begin
  cbBoxData.SetFocus;
end;

procedure TfrmFind.InitDialog(DataSet:TDataSet; DbGrid:TCfmDbGrid;
  const FieldIndex:Array of Integer; const FieldType:Array of TFindFType;
  const FieldName:Array of String);
var
  i:Integer;
begin
  fDataSet:=DataSet;
  fDbGrid:=DbGrid;
  SetLength(fFieldIndex,Length(FieldIndex));
  Move(FieldIndex,fFieldIndex[0],SizeOf(FieldIndex));
  SetLength(fFieldType,Length(FieldType));
  Move(FieldType,fFieldType[0],SizeOf(FieldType));
  cbBoxField.Items.Clear;
  for i:=Low(FieldName) to High(FieldName) do
    cbBoxField.Items.Add(FieldName[i]);
  cbBoxField.ItemIndex:=0;
  cbBoxFieldChange(cbBoxField);
end;

//------------------------------------------------------------------------------
//cbBoxData
//------------------------------------------------------------------------------

procedure TfrmFind.cbBoxDataKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  case Key of
    vk_up: begin
      fDataSet.Prior;
      Key:=0;
    end;
    vk_down: begin
      fDataSet.Next;
      Key:=0;
    end;
  end;
end;

procedure TfrmFind.cbBoxDataKeyPress(Sender: TObject; var Key: Char);
var
  fText:String;
  fSelStart:Integer;
begin
  case fFieldType[cbBoxField.ItemIndex] of
    ftCall: FilterCall(Key,['*','?']);
    ftLOC: FilterLocator(Key,TComboBox(Sender).SelStart,['*','?']);
    ftIOTA: FilterIOTA(Key,TComboBox(Sender).SelStart,['*','?']);
    ftDate:  with TComboBox(Sender) do
      if (SelLength=Length(Text))and(Key<>#13) then Clear else
      begin
        fText:=Text;
        fSelStart:=SelStart;
        FilterDate(Key,fText,fSelStart);
        Text:=fText;
        SelStart:=fSelStart;
      end
  else
    if Key=#13 then actFind.Execute;
  end;
end;

procedure TfrmFind.cbBoxDataChange(Sender: TObject);
begin
  chBoxFirst.Checked:=True;
end;

//------------------------------------------------------------------------------
//cbBoxField
//------------------------------------------------------------------------------

procedure TfrmFind.cbBoxFieldChange(Sender: TObject);
begin
  chBoxCase.Enabled:=fFieldType[cbBoxField.ItemIndex]=ftText;
end;

//------------------------------------------------------------------------------
//chBoxFirst
//------------------------------------------------------------------------------

procedure TfrmFind.chBoxFirstChange(Sender: TObject);
begin
  if TCheckBox(Sender).Checked then actFind.Caption:='Hledat'
                               else actFind.Caption:='Další';
end;

//------------------------------------------------------------------------------
//akce
//------------------------------------------------------------------------------

//help
procedure TfrmFind.actHelpExecute(Sender: TObject);
begin
  Application.HelpJump(Name);
end;

//hledat
procedure TfrmFind.actFindExecute(Sender: TObject);
var
  ActRec,ActRow:Integer;
  Result:Boolean;

 procedure FindDate(var Result:Boolean; const FieldIndex:Integer);
 var
   sDate:String;
   fDate:TDateTime;
 begin
   sDate:=Trim(cbBoxData.Text);
   if not TryStrToDate(sDate,fDate) then
   begin
     Result:=False;
     Exit;
   end;
   //
   fDate:=StrToDate(sDate);
   if chBoxFirst.Checked then fDataSet.First
                         else fDataSet.Next;
   while (fDataSet.Fields.Fields[FieldIndex].AsDateTime<>fDate)and
         (not fDataSet.Eof) do fDataSet.Next;
   Result:=fDataSet.Fields.Fields[FieldIndex].AsDateTime=fDate;
 end;

 procedure FindFixText(var Result:Boolean; const FieldIndex:Integer);
 var
   Mask:TMask;
 begin
   Mask:=TMask.Create(UpperCase(Trim(cbBoxData.Text)));
   try
     if chBoxFirst.Checked then fDataSet.First
                           else fDataSet.Next;
     while (not Mask.Matches(fDataSet.Fields.Fields[FieldIndex].AsString))and
           (not fDataSet.Eof) do fDataSet.Next;
     Result:=Mask.Matches(fDataSet.Fields.Fields[FieldIndex].AsString);
   finally
     Mask.Free;
   end;
 end;

 procedure FindOther(var Result:Boolean; const FieldIndex:Integer);
 var
   Mask:TMask;
 begin
   if chBoxCase.Checked then Mask:=TMask.Create(Trim(cbBoxData.Text))
                        else Mask:=TMask.Create(AnsiUpperCase(Trim(cbBoxData.Text)));
   try
     if chBoxFirst.Checked then fDataSet.First
                           else fDataSet.Next;
     if chBoxCase.Checked
       then while (not Mask.Matches(fDataSet.Fields.Fields[FieldIndex].AsString))and
                  (not fDataSet.Eof) do fDataSet.Next
       else while (not Mask.Matches(AnsiUpperCase(fDataSet.Fields.Fields[FieldIndex].AsString)))and
                  (not fDataSet.Eof) do fDataSet.Next;
     Result:=Mask.Matches(fDataSet.Fields.Fields[FieldIndex].AsString);
   finally
     Mask.Free;
   end;
 end;

begin
  fDataSet.DisableControls;
  try
    Result:=False;
    //ulozit pozici
    ActRow:=fDbGrid.Row;
    if fDataSet.RecordCount<>0 then ActRec:=fDataSet.RecNo
                               else ActRec:=-1;
    //
    case fFieldType[cbBoxField.ItemIndex] of
      ftDate: FindDate(Result,fFieldIndex[cbBoxField.ItemIndex]);
      ftCall,ftLOC,ftIOTA: FindFixText(Result,fFieldIndex[cbBoxField.ItemIndex]);
    else
      FindOther(Result,fFieldIndex[cbBoxField.ItemIndex]);
    end;
    //vyhledat puvodni kdyz nenasli
    if not Result then
    begin
      if (ActRec<>-1)and(Result=False) then
      begin
        fDataSet.RecNo:=ActRec;
        if ActRow>fDbGrid.RowCount div 2 then
        begin
          fDataSet.MoveBy(1-ActRow);
          fDataSet.MoveBy(ActRow-1);
        end else
        begin
          fDataSet.MoveBy(fDbGrid.RowCount-ActRow-1);
          fDataSet.MoveBy(ActRow-fDbGrid.RowCount+1);
        end;
      end;
      cMessageDlg(strNotFound,mtInformation,[mbOk],mrOk,0);
    end else
    begin
      if ((fDataSet.RecNo - ActRec < 0)or
          (fDataSet.RecNo - ActRec > fDbGrid.RowCount - ActRow - 1)) then
      begin
        fDataSet.MoveBy(fDbGrid.RowCount);
        fDataSet.MoveBy(-fDbGrid.RowCount);
      end;
    end;
    chBoxFirst.Checked:=not Result;
    cbBoxData.SelectAll;
    cbBoxData.SetFocus;
  finally
    fDataSet.EnableControls;
  end;
end;

//zavrit
procedure TfrmFind.actCloseExecute(Sender: TObject);
begin
  Close;
end;

end.
