{**************************************************************************************************}
{                                                                                                  }
{ FileUtils Library                                                                                }
{                                                                                                  }
{**************************************************************************************************}

unit cfmFileUtils;

interface

uses Windows, SysUtils, Classes;

type
  // TFileMapingStream
  TFileMappingStream = class(TCustomMemoryStream)
  private
    fFileHandle: THandle;
    fMapping: THandle;
  protected
    procedure Close;
  public
    constructor Create(const FileName: String;
      Mode: Word = fmOpenRead or fmShareDenyWrite; WriteCopy: Boolean = False);
    destructor Destroy; override;
    function Write(const Buffer; Count: Longint): Longint; override;
  end;

//Get file size
function FileSize(const FileName: String): Cardinal;
//Get file date and time
function FileDateTime(const FileName: String): TDateTime;
//Delete files by mask
procedure DeleteFiles(const Path, Name: String);

implementation

//------------------------------------------------------------------------------
//TFileMappingStream
//------------------------------------------------------------------------------

constructor TFileMappingStream.Create(const FileName: String;
  Mode: Word; WriteCopy: Boolean);
var
  Protect, Access, Size: Cardinal;
  Address: Pointer;
begin
  inherited Create;
  fFileHandle:=THandle(FileOpen(FileName, Mode));
  if fFileHandle = INVALID_HANDLE_VALUE then RaiseLastOSError;
  if Mode and $0F = fmOpenReadWrite then
  begin
    if WriteCopy then
    begin
      Protect:=PAGE_WRITECOPY;
      Access:=FILE_MAP_COPY;
    end else
    begin
      Protect:=PAGE_READONLY;
      Access:=FILE_MAP_READ;
    end;
  end else
  begin
    Protect:=PAGE_READONLY;
    Access:=FILE_MAP_READ;
  end;
  fMapping:=CreateFileMapping(fFileHandle, nil, Protect, 0, 0, nil);
  if fMapping = 0 then
  begin
    Close;
    raise Exception.Create('Cant create file mapping');
  end;
  Address:=MapViewOfFile(fMapping, Access, 0, 0, 0);
  if Address = nil then
  begin
    Close;
    raise exception.Create('Cant map view of file');
  end;
  Size:=GetFileSize(fFileHandle, nil);
  if Size = DWORD(-1) then
  begin
    UnMapViewOfFile(Address);
    Close;
    raise exception.Create('Cant unmap view of file');
  end;
  SetPointer(Address, Size);
end;

destructor TFileMappingStream.Destroy;
begin
  Close;
  inherited Destroy;
end;

procedure TFileMappingStream.Close;
begin
  if Memory <> nil then
  begin
    UnMapViewOfFile(Memory);
    SetPointer(nil, 0);
  end;
  if fMapping <> 0 then
  begin
    CloseHandle(fMapping);
    fMapping := 0;
  end;
  if fFileHandle <> INVALID_HANDLE_VALUE then
  begin
    FileClose(fFileHandle);
    fFileHandle:=INVALID_HANDLE_VALUE;
  end;
end;

function TFileMappingStream.Write(const Buffer; Count: Integer): Integer;
begin
  Result:=0;
  if Size - Position >= Count then
  begin
    System.Move(Buffer, Pointer(Longint(Memory) + Longint(Position))^, Count);
    Position:=Position + Count;
    Result:=Count;
  end;
end;

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

//Get file size
function FileSize(const FileName: String): Cardinal;
var
  Handle: THandle;
begin
  Handle:=THandle(FileOpen(FileName, fmOpenRead));
  if Handle = INVALID_HANDLE_VALUE then RaiseLastOSError;
  try
    Result:=GetFileSize(Handle, nil);
  finally
    FileClose(Handle);
  end;
end;

//Get file date and time
function FileDateTime(const FileName: String): TDateTime;
var
  fHandle: Integer;
begin
  Result:=0;
  fHandle:=FileOpen(FileName, fmOpenRead);
  if fHandle <> -1 then
  try
    Result:=FileDateToDateTime(FileGetDate(fHandle));
  finally
    FileClose(fHandle);
  end;
end;

//Delete files by mask
procedure DeleteFiles(const Path, Name: String);
var
  Rec: TSearchRec;
begin
  if FindFirst(Path + Name, 0, Rec) <> 0 then Exit;
  try
    DeleteFile(Path + Rec.Name);
    while FindNext(Rec) = 0 do DeleteFile(Path + Rec.Name);
  finally
    FindClose(Rec);
  end;
end;

end.
