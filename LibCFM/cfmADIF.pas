{**************************************************************************************************}
{                                                                                                  }
{ ADIF Library                                                                                     }
{                                                                                                  }
{**************************************************************************************************}

unit cfmADIF;

interface

uses Classes, SysUtils;

const
  //CRC32 hash
  adiOEH = $86F60C51;
  adiEOR = $7B94F52B;
  adiQSO_DATE = $17913A6A;
  adiTIME_ON = $EF6D2B59;
  adiCALL = $FA1BC28A;
  adiMODE = $A15FAA1F;
  adiFREQ = $6161F801;
  adiBAND = $7E4A4F5F;
  adiRST_SENT = $E055D202;
  adiRST_RCVD = $C3C841E8;
  adiSTX = $2ADC086D;
  adiSRX = $7C86AFEB;
  adiNAME = $68B693B2;
  adiQTH = $34EFCC67;
  adiMY_GRIDSQUARE = $95CC0D21;
  adiGRIDSQUARE = $C9079B7F;
  adiWWL_RCVD = $90E2EB69;
  adiQSL_VIA = $D4E83AD0;
  adiQSL_SENT = $815F5517;
  adiQSL_RCVD = $A2C2C6FD;
  adiEQSL_RCVD = $B5EC4B72;
  adiTX_PWR = $A1F3A547;
  adiCOMMENT = $AB31AC76;
  adiNOTES = $F64F643C;
  adiIOTA = $6392EB00;
  adiITUZ = $E09F5F3C;
  adiCQZ = $A5833E74;
  adiDXCCP = $A70B5072;
  adiAWARD = $7D0FEC57;

type
  //Forward Declarations
  TAdifParser = class;

  //Parser Events
  TAdifDataEvent = procedure(Parser: TAdifParser; Identifier: Cardinal; Data: PChar; DataLength: Integer) of Object;
  TAdifNotifyEvent = procedure(Parser: TAdifParser; Position, Size: Cardinal) of Object;

  //Error Classes
  EAdifParser = class(Exception);

  //TAdifParser
  TAdifParser = class
  protected
    DataBufferSize: Integer;
    DataBuffer: PChar;
    fOnTagFound: TAdifDataEvent;
    fOnOpenFile, fOnBeginOfRecord, fOnEndOfRecord: TAdifNotifyEvent;
    //
    procedure GrowBuffer(Size: Integer);
  public
    constructor Create;
    destructor Destroy; override;
    //
    procedure ParseFile(const FileName: String);
    //
    property OnOpenFile: TAdifNotifyEvent read fOnOpenFile write fOnOpenFile;
    property OnBeginOfRecord: TAdifNotifyEvent read fOnBeginOfRecord write fOnBeginOfRecord;
    property OnTagFound: TADIFDataEvent read fOnTagFound write fOnTagFound;
    property OnEndOfRecord: TAdifNotifyEvent read fOnEndOfRecord write fOnEndOfRecord;
  end;

//Public Functions
function TryAdifToDate(const S: PChar; out Date: TDateTime): Boolean;
function TryAdifToTime(const S: PChar; out Time: TDateTime): Boolean;

implementation

uses cfmCRC, cfmFileUtils;

//------------------------------------------------------------------------------
//Public Functions
//------------------------------------------------------------------------------

//ADIF Date To TDateTime
function TryAdifToDate(const S: PChar; out Date: TDateTime): Boolean;
var
  Y, M, D: Word;
begin
  Result:=
    (StrLen(S) = 8) and
    (S[0] in ['1'..'2']) and (S[1] in ['0'..'9']) and
    (S[2] in ['0'..'9']) and (S[3] in ['0'..'9']) and
    (S[4] in ['0'..'1']) and (S[5] in ['0'..'9']) and
    (S[6] in ['0'..'3']) and (S[7] in ['0'..'9']);
  if not Result then Exit;
  Y:=1000 * (Byte(S[0]) - 48) + 100 * (Byte(S[1]) - 48) +
     10 * (Byte(S[2]) - 48) + (Byte(S[3]) - 48);
  M:=10 * (Byte(S[4]) - 48) + (Byte(S[5]) - 48);
  D:=10 * (Byte(S[6]) - 48) + (Byte(S[7]) - 48);
  Result:=TryEncodeDate(Y, M, D, Date);
end;

//ADIF Time To TDateTime
function TryAdifToTime(const S: PChar; out Time: TDateTime): Boolean;
var
  Hour, Min, Sec: Word;
begin
  Result:=False;
  case StrLen(s) of
    4: begin
      if not((S[0] in ['0'..'2']) and (S[1] in ['0'..'9']) and
             (S[2] in ['0'..'5']) and (S[3] in ['0'..'9'])) then Exit;
      Hour:=10 * (Byte(S[0]) - 48) + (Byte(S[1]) - 48);
      Min:=10 * (Byte(S[2]) - 48) + (Byte(S[3]) - 48);
      Sec:=0;
    end;
    6: begin
      if not((S[0] in ['0'..'2']) and (S[1] in ['0'..'9']) and
             (S[2] in ['0'..'5']) and (S[3] in ['0'..'9']) and
             (S[4] in ['0'..'5']) and (S[5] in ['0'..'9'])) then Exit;
      Hour:=10 * (Byte(S[0]) - 48) + (Byte(S[1]) - 48);
      Min:=10 * (Byte(S[2]) - 48) + (Byte(S[3]) - 48);
      Sec:=10 * (Byte(S[4]) - 48) + (Byte(S[5]) - 48);
    end;
  else
    Exit;
  end;
  Result:=TryEncodeTime(Hour, Min, Sec, 0, Time);
end;

//------------------------------------------------------------------------------
//TAdifParser
//------------------------------------------------------------------------------

//Constructor
constructor TAdifParser.Create;
begin
  inherited Create;
  DataBufferSize:=1024;
  GetMem(DataBuffer, DataBufferSize);
end;

//Destructor
destructor TAdifParser.Destroy;
begin
  FreeMem(DataBuffer);
  inherited Destroy;
end;

//Grow Data Buffer if Needed
procedure TAdifParser.GrowBuffer(Size: Integer);
begin
  if Size >= DataBufferSize then
  try
    FreeMem(DataBuffer);
    DataBufferSize:=Round(Size * 1.5);
    GetMem(DataBuffer, DataBufferSize);
  except
    raise EAdifParser.Create('Can''t Grow Data Buffer');
  end;
end;

procedure TAdifParser.ParseFile(const FileName: String);
const
  BUFFER_SIZE = 64;
var
  //Input Data
  DataFile: TFileMappingStream;
  DataSize, DataCount, DataPosition: Cardinal;
  InputChar: PChar;
  //Parser State Variables
  Section: (adiHeader, adiBody);
  ParserState: (adiNoData, adiTagID, adiDataLength, adiDataType, adiData);
  NewRecord: Boolean;
  //Tag Information
  TagIDHash: Cardinal;
  DataType: Char;
  DataLength: Cardinal;
  //
  pDataLen, pData: PChar;
  sDataLen: Array[0..BUFFER_SIZE-1] of Char;
  sDataLen_Length: Integer;
  RemainingData: Cardinal;
begin
  DataFile:=TFileMappingStream.Create(FileName);
  try
    if DataFile.Size > High(Cardinal) then
      raise EAdifParser.Create('Maximum File Size is 4294967295 B');
    //
    DataSize:=DataFile.Size;
    DataCount:=DataSize;
    DataPosition:=0;
    InputChar:=DataFile.Memory;
    //
    Section:=adiHeader;
    ParserState:=adiNoData;
    NewRecord:=True;
    //
    DataType:='S';
    DataLength:=0;
    //
    pDataLen:=nil;
    pData:=nil;
    sDataLen_Length:=0;
    RemainingData:=0;
    //
    if Assigned(fOnOpenFile) then fOnOpenFile(Self, 0, DataSize);
    //
    while DataCount > 0 do
    begin
      case ParserState of
        //----------------------------------------------------------------------
        //No Data State
        //----------------------------------------------------------------------
        adiNoData:
          //Look for Tag Begin -> Tag Identifier State
          if InputChar^ = '<' then
          begin
            //Initiate Variables
            CRC32_AddBegin(TagIDHash);
            sDataLen_Length:=0;
            sDataLen:='';
            pDataLen:=sDataLen;
            DataType:='S';
            //
            ParserState:=adiTagID;
          end;
        //----------------------------------------------------------------------
        //Tag Identifier State
        //----------------------------------------------------------------------
        adiTagID:
          case InputChar^ of
            //Hash Tag Identifier
            'A'..'Z', '0'..'9', '_':
              CRC32_Add(TagIDHash, Byte(InputChar^));
            'a'..'z':
            CRC32_Add(TagIDHash, Byte(InputChar^) - 32);
            //Look for Data Length Separator -> Data Length State
            ':': begin
              CRC32_AddEnd(TagIDHash);
              ParserState:=adiDataLength;
            end;
            //Look for End of Tag -> End of Record
            '>': begin
              CRC32_AddEnd(TagIDHash);
              //End of Record, End of Header?
              case TagIDHash of
                adiOEH: Section:=adiBody;
                adiEOR: begin
                  NewRecord:=True;
                  if Assigned(fOnEndOfRecord) then
                    fOnEndOfRecord(Self, DataPosition, DataSize);
                end;
              else
                //invalid tag?
              end;
              ParserState:=adiNoData;
            end;
          end;
        //----------------------------------------------------------------------
        //Data Length State
        //----------------------------------------------------------------------
        adiDataLength:
          case InputChar^ of
            '0'..'9':
              if sDataLen_Length < BUFFER_SIZE-1 then
              begin
                pDataLen^:=InputChar^;
                Inc(pDataLen);
                Inc(sDataLen_Length);
              end;
            //konec delky dat -> typ dat
            ':': begin
              pDataLen^:=#0;
              DataLength:=StrToInt(sDataLen);
              RemainingData:=DataLength;
              GrowBuffer(DataLength);
              pData:=DataBuffer;
              //
              ParserState:=adiDataType;
            end;
            //konec tagu -> data
            '>': begin
              pDataLen^:=#0;
              DataLength:=StrToInt(sDataLen);
              RemainingData:=DataLength;
              GrowBuffer(DataLength);
              pData:=DataBuffer;
              //
              ParserState:=adiData;
            end;
          end;
        //----------------------------------------------------------------------
        //Data Type State
        //----------------------------------------------------------------------
        adiDataType:
          case InputChar^ of
            'A'..'Z': DataType:=InputChar^;
            'a'..'z': DataType:=Char(Byte(InputChar^) - 32);
            //End of Tag -> Data State
            '>': ParserState:=adiData;
          end;
        //----------------------------------------------------------------------
        //Data State
        //----------------------------------------------------------------------
        adiData:
          //If Data Length is 0 -> No Data State
          if DataLength = 0 then
          begin
            ParserState:=adiNoData;
            Continue;
          end else
          begin
            //Discard CR, LF in non memo data
            if (not(InputChar^ in [#13, #10]))or
               (DataType = 'M')or
               (TagIDHash = adiNOTES) then
            begin
              pData^:=InputChar^;
              Inc(pData);
            end else
              Dec(DataLength);
            //
            Dec(RemainingData);
            //Done?
            if RemainingData = 0 then
            begin
              ParserState:=adiNoData;
              pData^:=#0;
              if Section = adiHeader then
              begin
                if Assigned(fOnTagFound) then
                  fOnTagFound(Self, TagIDHash, DataBuffer, DataLength);
              end else
              begin
                if NewRecord then
                begin
                  NewRecord:=False;
                  if Assigned(fOnBeginOfRecord) then
                    fOnBeginOfRecord(Self, DataSize, DataPosition);
                end;
                if Assigned(fOnTagFound) then
                  fOnTagFound(Self, TagIDHash, DataBuffer, DataLength);
              end;
            end;
          end;
      else
        raise EAdifParser.Create('Invalid Parser State!');
      end;
      //Next Character
      Inc(InputChar);
      Inc(DataPosition);
      Dec(DataCount);
    end;
  finally
    DataFile.Free;
  end;
end;

end.
