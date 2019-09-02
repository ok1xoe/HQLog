unit uImportLog;

interface

uses Classes, Contnrs, SysUtils;

type
  TImportMsgType = (imError, imWarning, imErrorRec, imWarningRec, imInfo, imText);

type
  {TImportMsg}
  TImportMsg = class(TObject)
  private
    fMessageType: TImportMsgType;
    fText: String;
    fRecKey: Integer;
  public
    constructor Create(AMsgType: TImportMsgType;
      const AText: String; ARecKey: Integer);
    procedure GetMessage(var Buffer: String);
    //
    property Text: String read fText;
    property RecKey: Integer read fRecKey;
    property MessageType: TImportMsgType read fMessageType;
  end;

  {TImportLog}
  TImportLog = class(TObjectList)
  private
    fErrorCount, fWarningCount: Integer;
  protected
    function GetItems(Index: Integer): TImportMsg;
    procedure SetItems(Index: Integer; AMessage: TImportMsg);
    procedure HandleFreeNotify(Sender: TObject; AMessage: TImportMsg);
  public
    function Add(AMessage: TImportMsg): Integer; overload;
    function Add(AMsgType: TImportMsgType;
      const AText: String; ARecKey: Integer): Integer; overload;
    procedure Assign(ListA: TList; AOperator: TListAssignOp = laCopy; ListB: TList = nil);
    procedure Clear; override;
    procedure Delete(Index: Integer);
    function Extract(Item: TImportMsg): TImportMsg;
    function Remove(AMessage: TImportMsg): Integer;
    function IndexOf(AMessage: TImportMsg): Integer;
    function First: TImportMsg;
    function Last: TImportMsg;
    procedure Insert(Index: Integer; AMessage: TImportMsg);
    //
    property Items[Index: Integer]: TImportMsg read GetItems write SetItems; default;
    property ErrorCount: Integer read fErrorCount;
    property WarningCount: Integer read fWarningCount;
  end;

implementation

//------------------------------------------------------------------------------
// TImportMsg
//------------------------------------------------------------------------------

constructor TImportMsg.Create(AMsgType: TImportMsgType;
  const AText: String; ARecKey: Integer);
begin
  fMessageType:=AMsgType;
  fText:=AText;
  fRecKey:=ARecKey;
end;

procedure TImportMsg.GetMessage(var Buffer: String);
begin
  case fMessageType of
    imError: Buffer:=Format('[Error]: %s', [fText]);
    imWarning: Buffer:=Format('[Warning]: %s', [fText]);
    imErrorRec: Buffer:=Format('[Error] %d: %s', [fRecKey, fText]);
    imWarningRec: Buffer:=Format('[Warning] %d: %s', [fRecKey, fText]);
    imInfo: Buffer:=Format('[Info]: %s', [fText]);
  else
    Buffer:=fText;
  end;
end;

//------------------------------------------------------------------------------
// TCompilerMsgList
//------------------------------------------------------------------------------

function TImportLog.Add(AMessage: TImportMsg): Integer;
begin
  case AMessage.MessageType of
    imError, imErrorRec: Inc(fErrorCount);
    imWarning, imWarningRec: Inc(fWarningCount);
  end;
  Result := inherited Add(AMessage);
end;

function TImportLog.Add(AMsgType: TImportMsgType;
  const AText: String; ARecKey: Integer): Integer;
var
  AMessage: TImportMsg;
begin
  AMessage:=TImportMsg.Create(AMsgType, AText, ARecKey);
  case AMsgType of
    imError, imErrorRec: Inc(fErrorCount);
    imWarning, imWarningRec: Inc(fWarningCount);
  end;
  Result := inherited Add(AMessage);
end;

procedure TImportLog.Assign(ListA: TList; AOperator: TListAssignOp; ListB: TList);
var
  i: Integer;
begin
  inherited Assign(ListA, AOperator, ListB);
  fErrorCount:=0;
  fWarningCount:=0;
  for i:=0 to Count-1 do
  case Items[i].MessageType of
    imError, imErrorRec: Inc(fErrorCount);
    imWarning, imWarningRec: Inc(fWarningCount);
  end;
end;

procedure TImportLog.Clear;
begin
  fErrorCount:=0;
  fWarningCount:=0;
  inherited Clear;
end;

procedure TImportLog.Delete(Index: Integer);
begin
  case Items[Index].MessageType of
    imError, imErrorRec: Dec(fErrorCount);
    imWarning, imWarningRec: Dec(fWarningCount);
  end;
  inherited Delete(Index);
end;

function TImportLog.Extract(Item: TImportMsg): TImportMsg;
begin
  case Item.MessageType of
    imError, imErrorRec: Dec(fErrorCount);
    imWarning, imWarningRec: Dec(fWarningCount);
  end;
  Result := TImportMsg(inherited Extract(Item));
end;

function TImportLog.First: TImportMsg;
begin
  Result := TImportMsg(inherited First);
end;

function TImportLog.GetItems(Index: Integer): TImportMsg;
begin
  Result := TImportMsg(inherited Items[Index]);
end;

procedure TImportLog.HandleFreeNotify(Sender: TObject; AMessage: TImportMsg);
begin
  case AMessage.MessageType of
    imError, imErrorRec: Dec(fErrorCount);
    imWarning, imWarningRec: Dec(fWarningCount);
  end;
  Extract(AMessage);
end;

function TImportLog.IndexOf(AMessage: TImportMsg): Integer;
begin
  Result := inherited IndexOf(AMessage);
end;

procedure TImportLog.Insert(Index: Integer; AMessage: TImportMsg);
begin
  case AMessage.MessageType of
    imError, imErrorRec: Inc(fErrorCount);
    imWarning, imWarningRec: Inc(fWarningCount);
  end;
  inherited Insert(Index, AMessage);
end;

function TImportLog.Last: TImportMsg;
begin
  Result := TImportMsg(inherited Last);
end;

function TImportLog.Remove(AMessage: TImportMsg): Integer;
begin
  case AMessage.MessageType of
    imError, imErrorRec: Dec(fErrorCount);
    imWarning, imWarningRec: Dec(fWarningCount);
  end;
  Result := inherited Remove(AMessage);
end;

procedure TImportLog.SetItems(Index: Integer; AMessage: TImportMsg);
begin
  case Items[Index].MessageType of
    imError, imErrorRec: Dec(fErrorCount);
    imWarning, imWarningRec: Dec(fWarningCount);
  end;
  case AMessage.MessageType of
    imError, imErrorRec: Inc(fErrorCount);
    imWarning, imWarningRec: Inc(fWarningCount);
  end;
  inherited Items[Index] := AMessage;
end;


end.
 