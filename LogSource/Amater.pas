unit Amater;
interface
uses SysUtils, StrUtils, Math;

  //----------------------------------------------------------------------------
  //mody
  //----------------------------------------------------------------------------
  type
    THamMode = 0..27;
  const
    hmNone = 0;
    hmCW = 1;
    hmSSB = 2;
    hmAM = 3;
    hmFM = 4;
    hmPSK = 5;
    hmPSK31 = 6;
    hmPSK63 = 7;
    hmFSK = 8;
    hmRTTY = 9;
    hmPACKET = 10;
    hmPACTOR = 11;
    hmAMTOR = 12;
    hmMFSK = 13;
    hmTHROB = 14;
    hmMT63 = 15;
    hmHELL = 16;
    hmFAX = 17;
    hmSSTV = 18;
    hmATV = 19;
    hmOLIVIA = 20;
    hmJT64 = 21;
    hmJT65 = 22;
    hmJT6M = 23;
    hmDOMINO = 24;
    hmCHIP64 = 25;
    hmCHIP128 = 26;
    hmCLOVER = 27;
    hModeName: Array[THamMode] of PChar = (
      '',
      'CW', 'SSB', 'AM', 'FM',
      'PSK', 'PSK31', 'PSK63',
      'FSK',
      'RTTY',
      'PACKET', 'PACTOR', 'AMTOR',
      'MFSK',
      'THROB',
      'MT63',
      'HELL',
      'FAX', 'SSTV', 'ATV',
      'OLIVIA',
      'JT64', 'JT65', 'JT6M',
      'DOMINO',
      'CHIP64', 'CHIP128',
      'CLOVER');
    hModesAlias: Array[THamMode] of PChar = (
      '',
      ';CW;A1;', ';SSB;LSB;USB;PHONE;A3J;J3E;', ';AM;', ';FM;',
      ';PSK;PSK63F;PSK125;PSK125F;PSK10;PSKFEC31;PSKAM10;PSKAM31;PSKAM50;',
      ';PSK31;BPSK;QPSK;BPSK31;QPSK31;PSK3;FSK31;', ';PSK63;BPSK63;QPSK63;PSK62;BPSK62;QPSK62;',
      ';FSK;FSK-W;',
      ';RTTY;TTY;TY;MRTTY;RTTYM;',
      ';PACKET;PKT;', ';PACTOR;PAC;PACTOR II;', ';AMTOR;TOR;',
      ';MFSK;MFSK16;MFSK8;',
      ';THROB;THRB;THORBX;',
      ';MT63;',
      ';HELL;FELDHELL;FM-HELL;PSKHELL;FSKHELL;C/MTHELL;DUPLOHELL;',
      ';FAX;', ';SSTV;SST;IMAGE;', ';ATV;',
      ';OLIVIA;CONTESTIA;',
      ';JT44;',
      ';JT65;',
      ';JT6M;',
      ';DOMINO;',
      ';CHIP64;',
      ';CHIP128;',
      ';Clover;CLO;');
    hCwModes = [hmCW];
    hFoneModes = [hmSSB..hmFM];
    hDigiModes = [hmPSK..High(THamMode)];
  //----------------------------------------------------------------------------
  //pasma
  //----------------------------------------------------------------------------
    hBandName: Array[0..28] of PChar = (
      '2190m', '160m', '80m', '60m', '40m', '30m', '20m', '17m', '15m', '12m', '10m',
      '6m', '4m', '2m', '1.25m', '70cm', '33cm', '23cm', '13cm', '9cm', '6cm', '3cm',
      '1.25cm', '6mm', '4mm', '2.5mm', '2mm', '1mm', 'Mimo!');
    //rozsahy pasem
    hBandBegin: Array[0..28] of Double = (
      0.135, 1.8, 3.5, 5.2, 7, 10, 14, 18, 21, 24, 28,
      50, 70, 144, 222, 420, 902 , 1240, 2300, 3300, 5650, 10000, 24000, 47000, 75500,
      119980, 134000, 241000, 0);
    hBandEnd: Array[0..28] of Double = (
      0.138, 2, 4, 5.5, 7.3, 10.15, 14.35, 18.2, 21.45, 25, 29.7,
      54, 71, 148, 225, 450, 928, 1300, 2450, 3500, 5925, 10500, 24250, 47200, 81500,
      123000, 149000, 250000, 1.7e+308);
  //----------------------------------------------------------------------------
  //vykony
  //----------------------------------------------------------------------------
    hPWRs: Array[0..11] of Double = (0.1, 0.25, 0.5, 1, 5, 10, 25, 50, 100, 250, 500, 1000);

  //----------------------------------------------------------------------------
  //QSL
  //----------------------------------------------------------------------------
  type
    TQSLo = 0..3;
    TQSLp = 0..1;
    TEQSL = 0..1;
  const
    //QSLo
    qoNo = 0;
    qoYes = 1;
    qoRequested = 2;
    qoInvalid = 3;
    hQSLo: Array[TQSLo] of PChar = ('-', 'Y', 'R', 'I');
    hQSLoNames: Array[TQSLo] of PChar = ('Ne', 'Ano', 'Požadován', 'Neplatný');  //stare Ne, Ano, Pozadovan, Direct, Neplatny
    //QSLp
    qpNo = 0;
    qpYes = 1;
    hQSLp: Array[TQSLp] of PChar = ('-', 'Y');
    hQSLpNames: Array[TQSLp] of PChar = ('Ne', 'Ano');
    //eQSL
    eqNo = 0;
    eqYes = 1;
    hEQSL: Array[TEQSL] of PChar = ('-', 'Y');
    hEQSLNames: Array[TEQSL] of PChar = ('Ne', 'Ano');

  //
  function ExtractHamCall(const Call: String): String;
  function GetHamMode(const Mode: String; const DefMode: THamMode): THamMode; overload;
  function GetHamMode(const Mode: String): THamMode; overload;
  function GetHamBand(const Freq: Double): Integer;
  //
  function StrToITU(const ITU: String): Integer;
  function StrToWAZ(const WAZ: String): Integer;

implementation

//ziskat znacku bez /p /9 /mm ...
function ExtractHamCall(const Call: String): String;
var
  i, CallLen, SlashCnt, S1Index, S2Index: Integer;
begin
  Result:=UpperCase(Call);
  //
  CallLen:=Length(Result);
  SlashCnt:=0;
  S1Index:=0;
  S2Index:=0;
  for i:=1 to CallLen do
    if Result[i] = '/' then
    begin
      Inc(SlashCnt);
      case SlashCnt of
        1: S1Index:=i;
        2: S2Index:=i;
      end;
    end;
  //
  case SlashCnt of
    //1 lomitko
    1: //kdyz je cast za lomitkem kratsi nez cast pred lomitkem
       if (S1Index - 1) >= (CallLen - S1Index) then
         Delete(Result, S1Index, CallLen - S1Index + 1)
       else
         Delete(Result, 1, S1Index);
    //2 lomitka
    2: Result:=Copy(Result, S1Index + 1, S2Index - S1Index - 1);
  end;
end;

{function ExtractHamCall(const Call: String): String;
const
  Smaz: Array[0..14] of String=
    ('/P', '/M', '/MM', '/AM', '/QRP',
     '/0', '/1', '/2', '/3', '/4', '/5', '/6', '/7', '/8', '/9');
var
  i, in1, in2, Pocet: Integer;
  p: PChar;
begin
  Result:=UpperCase(Call);
  p:=Pointer(Result);
  if p = nil then Exit;
  //
  i:=1;in1:=0;in2:=0;Pocet:=0;
  while p^ <> #0 do
  begin
    if p^ = '/' then
    begin
      Inc(Pocet);
      if (in1 <> 0)and(in2 = 0) then in2:=i;
      if in1 = 0 then in1:=i;
    end;
    Inc(i);
    Inc(p);
  end;
  case Pocet of
    //zadne lomitko
    0: Exit;
    //1 lomitko
    1: begin
      //smazat konec?
      for i:=0 to High(smaz) do
        if AnsiEndsStr(Smaz[i], Result) then
        begin
          Delete(Result, in1, Length(Smaz[i]));
          Exit;
        end;
      //smazat zacatek?
      i:=Length(Result);
      // jen kdyz je cast pred lomitkem < nez cast za lomitkem
      if (in1 - 1) < (i - in1) then
      begin
        Delete(Result, 1, in1);
        Exit;
      end;
    end;
    //2 lomitka
    2: Result:=Copy(Result, in1 + 1, in2 - in1 - 1);
  end;
end;}

//index modu
function GetHamMode(const Mode: String; const DefMode: THamMode): THamMode;
var
  m: THamMode;
  str: PChar;
begin
  Result:=DefMode;
  if Mode = '' then Exit;
  str:=PChar(';' + UpperCase(Mode) + ';');
  for m:=Low(THamMode) to High(THamMode) do
    if StrPos(hModesAlias[m], str) <> nil then
    begin
      Result:=m;
      Exit;
    end;
end;

function GetHamMode(const Mode: String): THamMode;
var
  m: THamMode;
  str: PChar;
begin
  Result:=Low(THamMode);
  if Mode = '' then Exit;
  str:=PChar(';' + UpperCase(Mode) + ';');
  for m:=Low(THamMode) to High(THamMode) do
    if StrPos(hModesAlias[m], str) <> nil then
    begin
      Result:=m;
      Exit;
    end;
end;

//index pasma
function GetHamBand(const Freq: Double): Integer;
var
  i: Integer;
begin
  Result:=0;
  for i:=0 to High(hBandBegin) do
    if (CompareValue(Freq, hBandBegin[i]) <> -1)and
       (CompareValue(Freq, hBandEnd[i]) <> 1) then
    begin
      Result:=i;
      Exit;
    end;
end;

//
function StrToITU(const ITU: String): Integer;
var
  E: Integer;
begin
  Val(ITU, Result, E);
  if (E <> 0)or(Result < 0)or(Result > 90) then Result:=-1;
end;

//
function StrToWAZ(const WAZ: String): Integer;
var
  E: Integer;
begin
  Val(WAZ, Result, E);
  if (E <> 0)or(Result < 0)or(Result > 40) then Result:=-1;
end;

end.
