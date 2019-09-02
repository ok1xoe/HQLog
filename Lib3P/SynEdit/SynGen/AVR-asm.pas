{-------------------------------------------------------------------------------
The contents of this file are subject to the Mozilla Public License
Version 1.1 (the "License"); you may not use this file except in compliance
with the License. You may obtain a copy of the License at
http://www.mozilla.org/MPL/

Software distributed under the License is distributed on an "AS IS" basis,
WITHOUT WARRANTY OF ANY KIND, either express or implied. See the License for
the specific language governing rights and limitations under the License.

Code template generated with SynGen.
The original code is: AVR-asm.pas, released 2005-10-02.
Description: Syntax Parser/Highlighter
The initial author of this file is Martin.
Copyright (c) 2005, all rights reserved.

Contributors to the SynEdit and mwEdit projects are listed in the
Contributors.txt file.

Alternatively, the contents of this file may be used under the terms of the
GNU General Public License Version 2 or later (the "GPL"), in which case
the provisions of the GPL are applicable instead of those above.
If you wish to allow use of your version of this file only under the terms
of the GPL and not to allow others to use your version of this file
under the MPL, indicate your decision by deleting the provisions above and
replace them with the notice and other provisions required by the GPL.
If you do not delete the provisions above, a recipient may use your version
of this file under either the MPL or the GPL.

$Id: $

You may retrieve the latest version of this file at the SynEdit home page,
located at http://SynEdit.SourceForge.net

-------------------------------------------------------------------------------}

unit AVR-asm;

{$I SynEdit.inc}

interface

uses
{$IFDEF SYN_CLX}
  QGraphics,
  QSynEditTypes,
  QSynEditHighlighter,
{$ELSE}
  Graphics,
  SynEditTypes,
  SynEditHighlighter,
{$ENDIF}
  SysUtils,
  Classes;

type
  TtkTokenKind = (
    tkComment,
    tkIdentifier,
    tkKey,
    tkNull,
    tkRegister,
    tkSpace,
    tkString,
    tkUnknown);

  TRangeState = (rsUnKnown, rsBraceComment, rsCStyleComment, rsString);

  TProcTableProc = procedure of object;

  PIdentFuncTableFunc = ^TIdentFuncTableFunc;
  TIdentFuncTableFunc = function: TtkTokenKind of object;

const
  MaxKey = 73;

type
  TSynAvrAsmSyn = class(TSynCustomHighlighter)
  private
    fLineRef: string;
    fLine: PChar;
    fLineNumber: Integer;
    fProcTable: array[#0..#255] of TProcTableProc;
    fRange: TRangeState;
    Run: LongInt;
    fStringLen: Integer;
    fToIdent: PChar;
    fTokenPos: Integer;
    fTokenID: TtkTokenKind;
    fIdentFuncTable: array[0 .. MaxKey] of TIdentFuncTableFunc;
    fCommentAttri: TSynHighlighterAttributes;
    fIdentifierAttri: TSynHighlighterAttributes;
    fKeyAttri: TSynHighlighterAttributes;
    fRegisterAttri: TSynHighlighterAttributes;
    fSpaceAttri: TSynHighlighterAttributes;
    fStringAttri: TSynHighlighterAttributes;
    function KeyHash(ToHash: PChar): Integer;
    function KeyComp(const aKey: string): Boolean;
    function Func16: TtkTokenKind;
    function Func18: TtkTokenKind;
    function Func25: TtkTokenKind;
    function Func35: TtkTokenKind;
    function Func39: TtkTokenKind;
    function Func50: TtkTokenKind;
    function Func58: TtkTokenKind;
    function Func73: TtkTokenKind;
    procedure IdentProc;
    procedure UnknownProc;
    function AltFunc: TtkTokenKind;
    procedure InitIdent;
    function IdentKind(MayBe: PChar): TtkTokenKind;
    procedure MakeMethodTables;
    procedure NullProc;
    procedure SpaceProc;
    procedure CRProc;
    procedure LFProc;
    procedure BraceCommentOpenProc;
    procedure BraceCommentProc;
    procedure CStyleCommentOpenProc;
    procedure CStyleCommentProc;
    procedure StringOpenProc;
    procedure StringProc;
  protected
    function GetIdentChars: TSynIdentChars; override;
    function GetSampleSource: string; override;
    function IsFilterStored: Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    {$IFNDEF SYN_CPPB_1} class {$ENDIF}
    function GetLanguageName: string; override;
    function GetRange: Pointer; override;
    procedure ResetRange; override;
    procedure SetRange(Value: Pointer); override;
    function GetDefaultAttribute(Index: integer): TSynHighlighterAttributes; override;
    function GetEol: Boolean; override;
    function GetKeyWords: string;
    function GetTokenID: TtkTokenKind;
    procedure SetLine(NewValue: String; LineNumber: Integer); override;
    function GetToken: String; override;
    function GetTokenAttribute: TSynHighlighterAttributes; override;
    function GetTokenKind: integer; override;
    function GetTokenPos: Integer; override;
    procedure Next; override;
  published
    property CommentAttri: TSynHighlighterAttributes read fCommentAttri write fCommentAttri;
    property IdentifierAttri: TSynHighlighterAttributes read fIdentifierAttri write fIdentifierAttri;
    property KeyAttri: TSynHighlighterAttributes read fKeyAttri write fKeyAttri;
    property RegisterAttri: TSynHighlighterAttributes read fRegisterAttri write fRegisterAttri;
    property SpaceAttri: TSynHighlighterAttributes read fSpaceAttri write fSpaceAttri;
    property StringAttri: TSynHighlighterAttributes read fStringAttri write fStringAttri;
  end;

implementation

uses
{$IFDEF SYN_CLX}
  QSynEditStrConst;
{$ELSE}
  SynEditStrConst;
{$ENDIF}

{$IFDEF SYN_COMPILER_3_UP}
resourcestring
{$ELSE}
const
{$ENDIF}
  SYNS_FilterAVRAssemblyLanguage = 'AVR Assembly Files (*.asm)|*.asm';
  SYNS_LangAVRAssemblyLanguage = 'AVR Assembly Language';

var
  Identifiers: array[#0..#255] of ByteBool;
  mHashTable : array[#0..#255] of Integer;

procedure MakeIdentTable;
var
  I, J: Char;
begin
  for I := #0 to #255 do
  begin
    case I of
      '_', 'a'..'z', 'A'..'Z': Identifiers[I] := True;
    else
      Identifiers[I] := False;
    end;
    J := UpCase(I);
    case I in ['_', 'A'..'Z', 'a'..'z'] of
      True: mHashTable[I] := Ord(J) - 64
    else
      mHashTable[I] := 0;
    end;
  end;
end;

procedure TSynAvrAsmSyn.InitIdent;
var
  I: Integer;
  pF: PIdentFuncTableFunc;
begin
  pF := PIdentFuncTableFunc(@fIdentFuncTable);
  for I := Low(fIdentFuncTable) to High(fIdentFuncTable) do
  begin
    pF^ := AltFunc;
    Inc(pF);
  end;
  fIdentFuncTable[16] := Func16;
  fIdentFuncTable[18] := Func18;
  fIdentFuncTable[25] := Func25;
  fIdentFuncTable[35] := Func35;
  fIdentFuncTable[39] := Func39;
  fIdentFuncTable[50] := Func50;
  fIdentFuncTable[58] := Func58;
  fIdentFuncTable[73] := Func73;
end;

function TSynAvrAsmSyn.KeyHash(ToHash: PChar): Integer;
begin
  Result := 0;
  while ToHash^ in ['_', 'a'..'z', 'A'..'Z'] do
  begin
    inc(Result, mHashTable[ToHash^]);
    inc(ToHash);
  end;
  fStringLen := ToHash - fToIdent;
end;

function TSynAvrAsmSyn.KeyComp(const aKey: String): Boolean;
var
  I: Integer;
  Temp: PChar;
begin
  Temp := fToIdent;
  if Length(aKey) = fStringLen then
  begin
    Result := True;
    for i := 1 to fStringLen do
    begin
      if mHashTable[Temp^] <> mHashTable[aKey[i]] then
      begin
        Result := False;
        break;
      end;
      inc(Temp);
    end;
  end
  else
    Result := False;
end;

function TSynAvrAsmSyn.Func16: TtkTokenKind;
begin
  if KeyComp('ld') then Result := tkKey else Result := tkIdentifier;
end;

function TSynAvrAsmSyn.Func18: TtkTokenKind;
begin
  if KeyComp('r19') then Result := tkRegister else
    if KeyComp('r18') then Result := tkRegister else
      if KeyComp('r21') then Result := tkRegister else
        if KeyComp('r20') then Result := tkRegister else
          if KeyComp('r17') then Result := tkRegister else
            if KeyComp('r14') then Result := tkRegister else
              if KeyComp('r13') then Result := tkRegister else
                if KeyComp('r16') then Result := tkRegister else
                  if KeyComp('r15') then Result := tkRegister else
                    if KeyComp('r22') then Result := tkRegister else
                      if KeyComp('r29') then Result := tkRegister else
                        if KeyComp('r28') then Result := tkRegister else
                          if KeyComp('r31') then Result := tkRegister else
                            if KeyComp('r30') then Result := tkRegister else
                              if KeyComp('r27') then Result := tkRegister else
                                if KeyComp('r24') then Result := tkRegister else
                                  if KeyComp('r23') then Result := tkRegister else
                                    if KeyComp('r26') then Result := tkRegister else
                                      if KeyComp('r25') then Result := tkRegister else
                                        if KeyComp('r3') then Result := tkRegister else
                                          if KeyComp('r4') then Result := tkRegister else
                                            if KeyComp('r5') then Result := tkRegister else
                                              if KeyComp('r0') then Result := tkRegister else
                                                if KeyComp('r1') then Result := tkRegister else
                                                  if KeyComp('r2') then Result := tkRegister else
                                                    if KeyComp('r6') then Result := tkRegister else
                                                      if KeyComp('r10') then Result := tkRegister else
                                                        if KeyComp('r11') then Result := tkRegister else
                                                          if KeyComp('r12') then Result := tkRegister else
                                                            if KeyComp('r7') then Result := tkRegister else
                                                              if KeyComp('r8') then Result := tkRegister else
                                                                if KeyComp('r9') then Result := tkRegister else Result := tkIdentifier;
end;

function TSynAvrAsmSyn.Func25: TtkTokenKind;
begin
  if KeyComp('ldi') then Result := tkKey else Result := tkIdentifier;
end;

function TSynAvrAsmSyn.Func35: TtkTokenKind;
begin
  if KeyComp('lds') then Result := tkKey else Result := tkIdentifier;
end;

function TSynAvrAsmSyn.Func39: TtkTokenKind;
begin
  if KeyComp('st') then Result := tkKey else Result := tkIdentifier;
end;

function TSynAvrAsmSyn.Func50: TtkTokenKind;
begin
  if KeyComp('mov') then Result := tkKey else Result := tkIdentifier;
end;

function TSynAvrAsmSyn.Func58: TtkTokenKind;
begin
  if KeyComp('sts') then Result := tkKey else Result := tkIdentifier;
end;

function TSynAvrAsmSyn.Func73: TtkTokenKind;
begin
  if KeyComp('movw') then Result := tkKey else Result := tkIdentifier;
end;

function TSynAvrAsmSyn.AltFunc: TtkTokenKind;
begin
  Result := tkIdentifier;
end;

function TSynAvrAsmSyn.IdentKind(MayBe: PChar): TtkTokenKind;
var
  HashKey: Integer;
begin
  fToIdent := MayBe;
  HashKey := KeyHash(MayBe);
  if HashKey <= MaxKey then
    Result := fIdentFuncTable[HashKey]
  else
    Result := tkIdentifier;
end;

procedure TSynAvrAsmSyn.MakeMethodTables;
var
  I: Char;
begin
  for I := #0 to #255 do
    case I of
      #0: fProcTable[I] := NullProc;
      #10: fProcTable[I] := LFProc;
      #13: fProcTable[I] := CRProc;
      '{': fProcTable[I] := BraceCommentOpenProc;
      '/': fProcTable[I] := CStyleCommentOpenProc;
      '"': fProcTable[I] := StringOpenProc;
      #1..#9,
      #11,
      #12,
      #14..#32 : fProcTable[I] := SpaceProc;
      'A'..'Z', 'a'..'z', '_': fProcTable[I] := IdentProc;
    else
      fProcTable[I] := UnknownProc;
    end;
end;

procedure TSynAvrAsmSyn.SpaceProc;
begin
  fTokenID := tkSpace;
  repeat
    inc(Run);
  until not (fLine[Run] in [#1..#32]);
end;

procedure TSynAvrAsmSyn.NullProc;
begin
  fTokenID := tkNull;
end;

procedure TSynAvrAsmSyn.CRProc;
begin
  fTokenID := tkSpace;
  inc(Run);
  if fLine[Run] = #10 then
    inc(Run);
end;

procedure TSynAvrAsmSyn.LFProc;
begin
  fTokenID := tkSpace;
  inc(Run);
end;

procedure TSynAvrAsmSyn.BraceCommentOpenProc;
begin
  Inc(Run);
  fRange := rsBraceComment;
  BraceCommentProc;
  fTokenID := tkComment;
end;

procedure TSynAvrAsmSyn.BraceCommentProc;
begin
  case fLine[Run] of
     #0: NullProc;
    #10: LFProc;
    #13: CRProc;
  else
    begin
      fTokenID := tkComment;
      repeat
        if (fLine[Run] = '}') then
        begin
          Inc(Run, 1);
          fRange := rsUnKnown;
          Break;
        end;
        if not (fLine[Run] in [#0, #10, #13]) then
          Inc(Run);
      until fLine[Run] in [#0, #10, #13];
    end;
  end;
end;

procedure TSynAvrAsmSyn.CStyleCommentOpenProc;
begin
  Inc(Run);
  if (fLine[Run] = '*') then
  begin
    fRange := rsCStyleComment;
    CStyleCommentProc;
    fTokenID := tkComment;
  end
  else
    fTokenID := tkIdentifier;
end;

procedure TSynAvrAsmSyn.CStyleCommentProc;
begin
  case fLine[Run] of
     #0: NullProc;
    #10: LFProc;
    #13: CRProc;
  else
    begin
      fTokenID := tkComment;
      repeat
        if (fLine[Run] = '*') and
           (fLine[Run + 1] = '/') then
        begin
          Inc(Run, 2);
          fRange := rsUnKnown;
          Break;
        end;
        if not (fLine[Run] in [#0, #10, #13]) then
          Inc(Run);
      until fLine[Run] in [#0, #10, #13];
    end;
  end;
end;

procedure TSynAvrAsmSyn.StringOpenProc;
begin
  Inc(Run);
  fRange := rsString;
  StringProc;
  fTokenID := tkString;
end;

procedure TSynAvrAsmSyn.StringProc;
begin
  fTokenID := tkString;
  repeat
    if (fLine[Run] = '"') then
    begin
      Inc(Run, 1);
      fRange := rsUnKnown;
      Break;
    end;
    if not (fLine[Run] in [#0, #10, #13]) then
      Inc(Run);
  until fLine[Run] in [#0, #10, #13];
end;

constructor TSynAvrAsmSyn.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  fCommentAttri := TSynHighLighterAttributes.Create(SYNS_AttrComment);
  fCommentAttri.Style := [fsItalic];
  fCommentAttri.Foreground := clNavy;
  AddAttribute(fCommentAttri);

  fIdentifierAttri := TSynHighLighterAttributes.Create(SYNS_AttrIdentifier);
  AddAttribute(fIdentifierAttri);

  fKeyAttri := TSynHighLighterAttributes.Create(SYNS_AttrReservedWord);
  fKeyAttri.Style := [fsBold];
  AddAttribute(fKeyAttri);

  fRegisterAttri := TSynHighLighterAttributes.Create(SYNS_AttrRegister);
  AddAttribute(fRegisterAttri);

  fSpaceAttri := TSynHighLighterAttributes.Create(SYNS_AttrSpace);
  AddAttribute(fSpaceAttri);

  fStringAttri := TSynHighLighterAttributes.Create(SYNS_AttrString);
  AddAttribute(fStringAttri);

  SetAttributesOnChange(DefHighlightChange);
  InitIdent;
  MakeMethodTables;
  fDefaultFilter := SYNS_FilterAVRAssemblyLanguage;
  fRange := rsUnknown;
end;

procedure TSynAvrAsmSyn.SetLine(NewValue: String; LineNumber: Integer);
begin
  fLineRef := NewValue;
  fLine := PChar(fLineRef);
  Run := 0;
  fLineNumber := LineNumber;
  Next;
end;

procedure TSynAvrAsmSyn.IdentProc;
begin
  fTokenID := IdentKind((fLine + Run));

inc(Run, fStringLen);

while Identifiers[fLine[Run]] do

Inc(Run);

end;

procedure TSynAvrAsmSyn.UnknownProc;
begin
{$IFDEF SYN_MBCSSUPPORT}
  if FLine[Run] in LeadBytes then
    Inc(Run,2)
  else
{$ENDIF}
  inc(Run);
  fTokenID := tkUnknown;
end;

procedure TSynAvrAsmSyn.Next;
begin
  fTokenPos := Run;
  case fRange of
    rsBraceComment: BraceCommentProc;
    rsCStyleComment: CStyleCommentProc;
  else
    begin
      fRange := rsUnknown;
      fProcTable[fLine[Run]];
    end;
  end;
end;

function TSynAvrAsmSyn.GetDefaultAttribute(Index: integer): TSynHighLighterAttributes;
begin
  case Index of
    SYN_ATTR_COMMENT    : Result := fCommentAttri;
    SYN_ATTR_IDENTIFIER : Result := fIdentifierAttri;
    SYN_ATTR_KEYWORD    : Result := fKeyAttri;
    SYN_ATTR_STRING     : Result := fStringAttri;
    SYN_ATTR_WHITESPACE : Result := fSpaceAttri;
  else
    Result := nil;
  end;
end;

function TSynAvrAsmSyn.GetEol: Boolean;
begin
  Result := fTokenID = tkNull;
end;

function TSynAvrAsmSyn.GetKeyWords: string;
begin
  Result := 
    'ld,ldi,lds,mov,movw,r0,r1,r10,r11,r12,r13,r14,r15,r16,r17,r18,r19,r2,' +
    'r20,r21,r22,r23,r24,r25,r26,r27,r28,r29,r3,r30,r31,r4,r5,r6,r7,r8,r9,s' +
    't,sts';
end;

function TSynAvrAsmSyn.GetToken: String;
var
  Len: LongInt;
begin
  Len := Run - fTokenPos;
  SetString(Result, (FLine + fTokenPos), Len);
end;

function TSynAvrAsmSyn.GetTokenID: TtkTokenKind;
begin
  Result := fTokenId;
end;

function TSynAvrAsmSyn.GetTokenAttribute: TSynHighLighterAttributes;
begin
  case GetTokenID of
    tkComment: Result := fCommentAttri;
    tkIdentifier: Result := fIdentifierAttri;
    tkKey: Result := fKeyAttri;
    tkRegister: Result := fRegisterAttri;
    tkSpace: Result := fSpaceAttri;
    tkString: Result := fStringAttri;
    tkUnknown: Result := fIdentifierAttri;
  else
    Result := nil;
  end;
end;

function TSynAvrAsmSyn.GetTokenKind: integer;
begin
  Result := Ord(fTokenId);
end;

function TSynAvrAsmSyn.GetTokenPos: Integer;
begin
  Result := fTokenPos;
end;

function TSynAvrAsmSyn.GetIdentChars: TSynIdentChars;
begin
  Result := ['_', 'a'..'z', 'A'..'Z'];
end;

function TSynAvrAsmSyn.GetSampleSource: string;
begin
  Result := 'Sample source for: '#13#10 +
            'Syntax Parser/Highlighter';
end;

function TSynAvrAsmSyn.IsFilterStored: Boolean;
begin
  Result := fDefaultFilter <> SYNS_FilterAVRAssemblyLanguage;
end;

{$IFNDEF SYN_CPPB_1} class {$ENDIF}
function TSynAvrAsmSyn.GetLanguageName: string;
begin
  Result := SYNS_LangAVRAssemblyLanguage;
end;

procedure TSynAvrAsmSyn.ResetRange;
begin
  fRange := rsUnknown;
end;

procedure TSynAvrAsmSyn.SetRange(Value: Pointer);
begin
  fRange := TRangeState(Value);
end;

function TSynAvrAsmSyn.GetRange: Pointer;
begin
  Result := Pointer(fRange);
end;

initialization
  MakeIdentTable;
{$IFNDEF SYN_CPPB_1}
  RegisterPlaceableHighlighter(TSynAvrAsmSyn);
{$ENDIF}
end.
