unit BackUp;
interface

uses
  Windows, SysUtils, Classes, Zlib, cfmFileUtils, cfmCRC;

type
  //tabuka souboru
  pBackUpFATRec = ^TBackUpFATRec;
  TBackUpFATRec = packed record
    Size: Cardinal;
    Name: String[32];
    Reserved: Array[0..23] of Byte;
  end;
  TBackUpFAT = Array of TBackUpFATRec;
  //zahlavi zalohy
  TBackUpHeader = packed record
    Version: Integer;
    Call: String[16];
    DateTime: TDateTime;
    FATRecCount: Integer;
    Reserved: Array[0..215] of Byte;
  end;
  //kompletni hlavicka souboru
  pBackUpFileHeader = ^TBackUpFileHeader;
  TBackUpFileHeader = packed record
    ID: Int64;
    CRC: Cardinal;
    Header: TBackUpHeader;
  end;

procedure BackUpLog(const Call, DataDir, FileName: String);
procedure RestoreLog(const Call, DataDir, TempDir,FileName: String);
procedure GetBackUpInfo(const FileName: String; out Call: String; out DateTime: TDateTime);

implementation

uses HQLResStrings, HQLConsts;

const
  BackUpID: Int64 = $A159F616B184AD43;
  BackUpFile = 'BackUp';

//zaloha deniku
procedure BackUpLog(const Call, DataDir, FileName: String);
var
  CRC: Cardinal;
  Head: TBackUpHeader;
  FAT: TBackUpFAT;
  BackUp: TFileStream;

 procedure AddFile(Stream: TStream; const FileName: String);
 var
   Data: TFileStream;
   cs: TCompressionStream;
 begin
   Data:=TFileStream.Create(FileName, fmOpenRead);
   try
     cs:=TCompressionStream.Create(clDefault, Stream);
     try
       cs.CopyFrom(Data, Data.Size);
     finally
       cs.Free;
     end;
   finally
     Data.Free;
   end;
 end;

begin
  BackUp:=TFileStream.Create(FileName, fmCreate or fmOpenReadWrite or fmShareExclusive);
  try
    //naplnit hlavicku
    Head.Version:=iVersion;
    Head.Call:=Call;
    Head.DateTime:=Now;
    Head.FATRecCount:=3;
    FillChar(Head.Reserved[0], SizeOf(Head.Reserved), 0);
    //naplnit FAT
    SetLength(FAT, Head.FATRecCount);
    FAT[0].Name:=BackUpFile + dFileExt;
    FAT[0].Size:=FileSize(DataDir + Call + dFileExt);
    FAT[1].Name:=BackUpFile + iFileExt;
    FAT[1].Size:=FileSize(DataDir + Call + iFileExt);
    FAT[2].Name:=BackUpFile + uFileExt;
    FAT[2].Size:=FileSize(DataDir + Call + uFileExt);
    //zapsat ID, prazdny CRC, hlavicku, FAT
    BackUp.Write(BackUpID, SizeOf(BackUpID));
    BackUp.Write(CRC, SizeOf(CRC));
    BackUp.Write(Head, SizeOf(Head));
    BackUp.Write(FAT[0], Head.FATRecCount * SizeOf(TBackUpFATRec));
    //zapsat soubory
    AddFile(BackUp, DataDir + Call + dFileExt);
    AddFile(BackUp, DataDir + Call + iFileExt);
    AddFile(BackUp, DataDir + Call + uFileExt);
    //vypocitat CRC
    BackUp.Seek(SizeOf(BackUpID) + SizeOf(CRC), soFromBeginning);
    CRC:=CRC32(BackUp);
    //zapsat CRC
    BackUp.Seek(SizeOf(BackUpID), soFromBeginning);
    BackUp.Write(CRC, SizeOf(CRC));
  finally
    BackUp.Free;
  end;
end;

//obnova deniku
procedure RestoreLog(const Call, DataDir, TempDir, FileName: String);
var
  BackUp: TFileMappingStream;
  BackUpHeader: pBackUpFileHeader;
  FileInfo: pBackUpFATRec;
  i: Integer;

 //dekomprese souboru
 procedure GetFile(Stream: TStream; Size: Cardinal; const FileName: String);
 var
   Data: TFileStream;
   cs: TDecompressionStream;
 begin
   Data:=TFileStream.Create(FileName, fmCreate);
   try
     cs:=TDecompressionStream.Create(Stream);
     try
       Data.CopyFrom(cs, Size);
     finally
       cs.Free;
     end;
   finally
     Data.Free;
   end;
 end;

 //verze 1
 procedure RestoreFrom_ActualVer;
 begin
   CopyFile(PChar(TempDir + BackUpFile + dFileExt), PChar(DataDir + Call + dFileExt), False);
   CopyFile(PChar(TempDir + BackUpFile + iFileExt), PChar(DataDir + Call + iFileExt), False);
 end;

begin
  BackUp:=TFileMappingStream.Create(FileName);
  try
    //"nacist" hlavicku
    BackUpHeader:=BackUp.Memory;
    //zkontrolovat velikost a ID
    if (BackUp.Size < SizeOf(TBackUpFileHeader)) or (BackUpHeader^.ID <> BackUpID) then
      raise Exception.Create(strFileFormatErr);
    //zkontrolovat CRC
    if BackUpHeader^.CRC <> CRC32(
        Pointer(Cardinal(BackUp.Memory) + SizeOf(BackUpID) + SizeOf(BackUpHeader^.CRC)),
        BackUp.Size - SizeOf(BackUpID) - SizeOf(BackUpHeader^.CRC)) then
      raise Exception.Create(strFileCRCErr);
    //rozbalit soubory
    try
      FileInfo:=Pointer(Cardinal(BackUp.Memory) + SizeOf(TBackUpFileHeader));
      BackUp.Seek(SizeOf(TBackUpFileHeader) +
        BackUpHeader^.Header.FATRecCount * SizeOf(TBackUpFATRec), soFromBeginning);
      //
      i:=BackUpHeader^.Header.FATRecCount;
      while i > 0 do
      begin
        GetFile(BackUp, FileInfo.Size, TempDir + FileInfo.Name);
        Inc(FileInfo);
        Dec(i);
      end;
      //ktera verze?
      case BackUpHeader^.Header.Version of
        iVersion: RestoreFrom_ActualVer;
      else
        raise Exception.Create(strFileVersionErr);
      end;
    finally
      //vymazat docasne soubory
      FileInfo:=Pointer(Cardinal(BackUp.Memory) + SizeOf(TBackUpFileHeader));
      i:=BackUpHeader^.Header.FATRecCount;
      while i > 0 do
      begin
        SysUtils.DeleteFile(TempDir + FileInfo.Name);
        Inc(FileInfo);
        Dec(i);
      end;
    end;
  finally
    BackUp.Free;
  end;
end;

//informace o zaloze
procedure GetBackUpInfo(const FileName: String; out Call: String; out DateTime: TDateTime);
var
  BackUp: TFileMappingStream;
  BackUpHeader: pBackUpFileHeader;
begin
  BackUp:=TFileMappingStream.Create(FileName);
  try
    //"nacist" hlavicku
    BackUpHeader:=BackUp.Memory;
    //zkontrolovat velikost a ID
    if (BackUp.Size < SizeOf(TBackUpFileHeader)) or (BackUpHeader^.ID <> BackUpID) then
      raise Exception.Create(strFileFormatErr);
    //
    Call:=BackUpHeader.Header.Call;
    DateTime:=BackUpHeader.Header.DateTime;
  finally
    BackUp.Free;
  end;
end;

end.
