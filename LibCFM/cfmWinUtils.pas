{**************************************************************************************************}
{                                                                                                  }
{ WinUtils Library                                                                                 }
{                                                                                                  }
{**************************************************************************************************}

unit cfmWinUtils;

interface

uses Windows, Messages, Classes, SysUtils;

procedure GetFontList(List: TStrings; CharSet: Byte);
function ForceForeground(AppHandle: HWND): Boolean;
function WinExecCaptureOut(Command, WorkDir: String; AStrings: TStrings): LongWord;

implementation

//------------------------------------------------------------------------------
//GetFontList

function EnumFontsProc(var Font: TLogFont; var Metric: TTextMetric;
  FontType: Integer; Data: Pointer): Integer; stdcall;
var
  List: TStringList;
  Name: String;
begin
  List:=TStringList(Data);
  Name:=Font.lfFaceName;
  if (List.Count = 0) or (Name <> List.Strings[List.Count-1]) then
    List.Add(Name);
  Result:=1;
end;

procedure GetFontList(List: TStrings; CharSet: Byte);
var
  DC: HDC;
  Font: TLogFont;
  Data: TStringList;
begin
  List.Clear;
  DC:=GetDC(0);
  try
    Data:=TStringList.Create;
    try
      if Lo(GetVersion) >= 4 then
      begin
        FillChar(Font, SizeOf(Font), 0);
        Font.lfCharset:=CharSet;
        EnumFontFamiliesEx(DC, Font, @EnumFontsProc, LongInt(Data), 0);
      end else
        EnumFonts(DC, nil, @EnumFontsProc, Pointer(Data));
      Data.Sorted:=True;
      List.Assign(Data);
    finally
      Data.Free;
    end;
  finally
    ReleaseDC(0, DC);
  end;
end;

//------------------------------------------------------------------------------

function ForceForeground(AppHandle: HWND):Boolean;
const
  SPI_GETFOREGROUNDLOCKTIMEOUT = $2000;
  SPI_SETFOREGROUNDLOCKTIMEOUT = $2001;
var
  ForegroundThreadID, ThisThreadID, TimeOut: DWORD;
  OSVersionInfo: TOSVersionInfo;
  Win32Platform: Integer;
begin
  if IsIconic(AppHandle) then SendMessage(AppHandle, WM_SYSCOMMAND, SC_RESTORE, 0);
  if GetForegroundWindow = AppHandle then Result:=True else
  begin
    Win32Platform:=0;
    OSVersionInfo.dwOSVersionInfoSize:=SizeOf(OSVersionInfo);
    if GetVersionEx(OSVersionInfo) then Win32Platform:=OSVersionInfo.dwPlatformId;
    if ((Win32Platform = VER_PLATFORM_WIN32_NT)and(OSVersionInfo.dwMajorVersion > 4))or
       ((Win32Platform = VER_PLATFORM_WIN32_WINDOWS)and(OSVersionInfo.dwMajorVersion > 4)or
       ((OSVersionInfo.dwMajorVersion = 4)and(OSVersionInfo.dwMinorVersion > 0))) then
    begin
      Result:=False;
      ForegroundThreadID:=GetWindowThreadProcessID(GetForegroundWindow, nil);
      ThisThreadID:=GetWindowThreadPRocessId(AppHandle, nil);
      if AttachThreadInput(ThisThreadID,ForegroundThreadID, True) then
      begin
        BringWindowToTop(AppHandle);
        SetForegroundWindow(AppHandle);
        AttachThreadInput(ThisThreadID, ForegroundThreadID, False);
        Result:=GetForegroundWindow=AppHandle;
      end;
      if not Result then
      begin
        SystemParametersInfo(SPI_GETFOREGROUNDLOCKTIMEOUT, 0, @TimeOut, 0);
        SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(0), SPIF_SENDCHANGE);
        BringWindowToTop(AppHandle);
        SetForegroundWindow(AppHandle);
        SystemParametersInfo(SPI_SETFOREGROUNDLOCKTIMEOUT, 0, TObject(TimeOut), SPIF_SENDCHANGE);
        Result:=GetForegroundWindow = AppHandle;
        if not Result then
        begin
          ShowWindow(AppHandle, SW_HIDE);
          ShowWindow(AppHandle, SW_SHOWMINIMIZED);
          ShowWindow(AppHandle, SW_SHOWNORMAL);
          BringWindowToTop(AppHandle);
          SetForegroundWindow(AppHandle);
        end;
      end;
    end else
    begin
      BringWindowToTop(AppHandle);
      SetForegroundWindow(AppHandle);
    end;
    Result:=GetForegroundWindow = AppHandle;
  end;
end;

//------------------------------------------------------------------------------

function WinExecCaptureOut(Command, WorkDir: String; AStrings: TStrings): LongWord;
type
  TCharBuffer = array[0..MaxInt - 1] of Char;
const
  MaxBufSize = 1024;
  TimeOut_Begin = 12000; //2 min
  TimeOut_Output = 2000; //20s
var
  pBuf: ^TCharBuffer;
  iBufSize: Cardinal;
  app_spawn: PChar;
  cur_dir: PChar;
  si: STARTUPINFO;
  sa: PSECURITYATTRIBUTES;
  sd: PSECURITY_DESCRIPTOR;
  pi: PROCESS_INFORMATION;
  newstdin, newstdout, read_stdout, write_stdin: THandle;
  Exit_Code, bread, avail, bleft, i: LongWord;
  Str, Last: string;
  LineBeginned: Boolean;
  tOutBegin, tOutOutput: Integer;
begin
  GetMem(sa,sizeof(SECURITY_ATTRIBUTES));
  if Win32Platform = VER_PLATFORM_WIN32_NT then
  begin
    GetMem(sd,sizeof(SECURITY_DESCRIPTOR));
    InitializeSecurityDescriptor(sd,SECURITY_DESCRIPTOR_REVISION);
    SetSecurityDescriptorDacl(sd,true,nil,false);
    sa.lpSecurityDescriptor:=sd;
  end else
  begin
    sa.lpSecurityDescriptor:=nil;
    sd:=nil;
  end;
  sa.nLength:=sizeof(SECURITY_ATTRIBUTES);
  sa.bInheritHandle:=true;
  //
  Result:=0;
  if not CreatePipe(newstdin,write_stdin,sa,0) then Exit;
  if not CreatePipe(read_stdout,newstdout,sa,0) then Exit;
  //
  GetStartupInfo(si);
  si.dwFlags:=STARTF_USESTDHANDLES or STARTF_USESHOWWINDOW;
  si.wShowWindow:=SW_HIDE;
  si.hStdOutput:=newstdout;
  si.hStdError:=newstdout;
  si.hStdInput:=newstdin;
  app_spawn:=PChar(Command);
  cur_dir:=PChar(WorkDir);
  //start process
  if not CreateProcess(nil,app_spawn,nil,nil,
    TRUE,CREATE_NEW_CONSOLE or NORMAL_PRIORITY_CLASS,nil,cur_dir,si,pi) then
  begin
    CloseHandle(newstdin);
    CloseHandle(newstdout);
    CloseHandle(read_stdout);
    CloseHandle(write_stdin);
    Exit;
  end;
  tOutBegin:=0;
  tOutOutput:=0;
  Last:=''; // Buffer to save last output without finished with CRLF
  LineBeginned:=False;
  iBufSize:=MaxBufSize;
  pBuf:=AllocMem(iBufSize); // Reserve and init Buffer
  try
    repeat //main program loop
      GetExitCodeProcess(pi.hProcess,Exit_Code); //while the process is running
      PeekNamedPipe(read_stdout,pBuf,iBufSize,@bread,@avail,@bleft);
      //check to see if there is any data to read from stdout
      if bread<>0 then
      begin
        if iBufSize<avail then
        begin // If BufferSize too small then rezize
          iBufSize:=avail;
          ReallocMem(pBuf,iBufSize);
        end;
        FillChar(pBuf^,iBufSize,#0); //empty the buffer
        ReadFile(read_stdout,pBuf^,iBufSize,bread,nil); //read the stdout pipe
        if not LineBeginned then
        begin
          Str:= '';
          Last:='';
        end else Str:=Last; //take the begin of the line (if exists)
        i:=0;
        while i<bread do
        begin
          case pBuf^[i] of
            #0,#8: Inc(i);
            #10,#13: begin
              tOutOutput:=0; //reset
              Inc(i);
              {$R-}
              if ((i<bread)and(pBuf^[i]=#13)and(pBuf^[i+1]=#10))or
                 ((i>0)and(pBuf^[i-1]=#13)and(pBuf^[i]=#10)) then
              {$R+}
                Inc(i); //so we don't test the #10 on the next step of the loop
              if LineBeginned then
              begin
                AStrings[AStrings.Count - 1] := Str;
                LineBeginned := False;
              end else AStrings.Add(Str);
              Str := '';
            end;
          else
            begin
              {$R-}
              if pBuf^[i+1]<>#8 then
                Str:=Str+pBuf^[i]; //add a character
              {$R+}
              Inc(i);
            end;
          end;
        end;
        Last:=Str; // no CRLF found in the rest, maybe in the next output
        if Last<>'' then
        begin
          if LineBeginned then AStrings[AStrings.Count - 1] := Last
                          else AStrings.Add(Last);
          LineBeginned := True;
        end;
      end;
      Sleep(1); // Give other processes a chance
      Inc(tOutBegin);
      Inc(tOutOutput);
      if (tOutBegin=TimeOut_Begin)or(tOutOutput=TimeOut_Output) then
      begin
        TerminateProcess(pi.hProcess,Exit_Code);
        Break;
      end;
    until Exit_Code<>STILL_ACTIVE; //time out
  finally
    FreeMem(pBuf);
  end;
  FreeMem(sd);
  FreeMem(sa);
  CloseHandle(pi.hThread);
  CloseHandle(pi.hProcess);
  CloseHandle(newstdin); //clean stuff up
  CloseHandle(newstdout);
  CloseHandle(read_stdout);
  CloseHandle(write_stdin);
  Result:=Exit_Code;
end;

end.
