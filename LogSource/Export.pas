unit Export;

interface

uses DbTables, DbGrids, Windows, Classes, SysUtils, ExcelXP, Variants, HQLConsts;

  procedure ExportADIF(Query:TQuery; SelectedRows:TBookmarkList; const FileName:String;
    OnProgress:TProgressEvent);
  procedure ExportEQSL(Query:TQuery; SelectedRows:TBookmarkList;
    const QSLNote,FileName:String; OnProgress:TProgressEvent);
  procedure ExportCSV(Query:TQuery; SelectedRows:TBookmarkList; const FileName:String;
    OnProgress:TProgressEvent);
  procedure ExportTXT(Query:TQuery; SelectedRows:TBookmarkList; const FileName:String;
    OnProgress:TProgressEvent);
  procedure ExportXLS(Query:TQuery; SelectedRows:TBookmarkList;
    OnProgress:TProgressEvent);
  procedure ExportSelected(Query:TQuery; SelectedRows:TBookmarkList; const FileName:String;
    OnProgress:TProgressEvent);
  procedure SortQSL(const InputFile,OutputFile:String; OnProgress:TProgressEvent);

implementation

uses HQLDatabase, Amater;

//------------------------------------------------------------------------------
// Export do ADIFu - uplny
//------------------------------------------------------------------------------
procedure ExportADIF(Query:TQuery; SelectedRows:TBookmarkList; const FileName:String;
  OnProgress:TProgressEvent);
var
  ADIF: TFileStream;
  i, ap, lp, mp: Integer;
  fSet: TFormatSettings;
  Buffer: String;

 procedure WriteRecord(var Buffer: String);
 var
   strData: String;
 begin
   with Query.Fields do
   begin
     Buffer:='';
     //datum
     strData:=FormatDateTime('yyyyMMdd', Fields[dfiL_Date].AsDateTime);
     Buffer:=Buffer + '<QSO_DATE:8>' + strData;
     //cas
     strData:=FormatDateTime('hhNNss', Fields[dfiL_Time].AsDateTime);
     Buffer:=Buffer + '<TIME_ON:6>' + strData;
     //frekvence
     strData:=FormatFloat('0.####', Fields[dfiL_Freq].AsFloat, fSet);
     Buffer:=Buffer + '<FREQ:' + IntToStr(Length(strData)) + '>' + strData;
     //pasmo
     strData:=hBandName[Fields[dfiL_Band].AsInteger];
     Buffer:=Buffer + '<BAND:' + IntToStr(Length(strData)) + '>' + strData;
     //mod
     strData:=hModeName[Fields[dfiL_Mode].AsInteger];
     Buffer:=Buffer + '<MODE:' + IntToStr(Length(strData)) + '>' + strData;
     //znacka
     strData:=Fields[dfiL_Call].AsString;
     Buffer:=Buffer + #13#10#9 + '<CALL:' + IntToStr(Length(strData)) + '>' + strData;
     //RSTp
     strData:=Fields[dfiL_RSTp].AsString;
     Buffer:=Buffer + #13#10#9 + '<RST_RCVD:' + IntToStr(Length(strData)) + '>' + strData;
     //RSTo
     strData:=Fields[dfiL_RSTo].AsString;
     Buffer:=Buffer + '<RST_SENT:' + IntToStr(Length(strData)) + '>' + strData;
     //LOCo
     strData:=Fields[dfiL_LOCo].AsString;
     Buffer:=Buffer + #13#10#9 + '<MY_GRIDSQUARE:' + IntToStr(Length(strData)) + '>' + strData;
//     Buffer:=Buffer + #13#10#9 + '<MY_GRIDSQUARE:6>' + Fields[dfiL_LOCo].AsString;
     //LOCp
     strData:=Fields[dfiL_LOCp].AsString;
     Buffer:=Buffer + '<GRIDSQUARE:' + IntToStr(Length(strData)) + '>' + strData;
     //QTH
     strData:=Fields[dfiL_QTH].AsString;
     Buffer:=Buffer + #13#10#9 + '<QTH:' + IntToStr(Length(strData)) + '>' + strData;
     //jmeno
     strData:=Fields[dfiL_Name].AsString;
     Buffer:=Buffer + '<NAME:' + IntToStr(Length(strData)) + '>' + strData;
     //QSLp
     if Fields[dfiL_QSLp].AsInteger = qpYes then
       Buffer:=Buffer + #13#10#9 + '<QSL_RCVD:1>Y'
     else
       Buffer:=Buffer + #13#10#9 + '<QSL_RCVD:1>N';
     //QSLo
     case Fields[dfiL_QSLo].AsInteger of
       qoYes: Buffer:=Buffer + '<QSL_SENT:1>Y';
       qoRequested: Buffer:=Buffer + '<QSL_SENT:1>R';
       qoInvalid: Buffer:=Buffer + '<QSL_SENT:1>I';
     else
       Buffer:=Buffer + '<QSL_SENT:1>N';
     end;
     //eQSL
     if Fields[dfiL_EQSLp].AsInteger = eqYes then
       Buffer:=Buffer + '<EQSL_RCVD:1>Y'
     else
       Buffer:=Buffer + '<EQSL_RCVD:1>N';
     //QSL via
     strData:=Fields[dfiL_QSLvia].AsString;
     Buffer:=Buffer + '<QSL_VIA:' + IntToStr(Length(strData)) + '>' + strData;
     //ITU
     strData:=Fields[dfiL_ITU].AsString;
     Buffer:=Buffer + #13#10#9 + '<ITUZ:' + IntToStr(Length(strData)) + '>' + strData;
     //WAZ
     strData:=Fields[dfiL_WAZ].AsString;
     Buffer:=Buffer + '<CQZ:' + IntToStr(Length(strData)) + '>' + strData;
     //DXCC
     strData:=Fields[dfiL_DXCC].AsString;
     Buffer:=Buffer + '<DXCCP:' + IntToStr(Length(strData)) + '>' + strData;
     //IOTA
     strData:=Fields[dfiL_IOTA].AsString;
     if strData <> '' then
     begin
       Insert('-', strData, 3);
       Buffer:=Buffer + '<IOTA:6>' + strData;
     end;
     //diplom
     strData:=Fields[dfiL_Award].AsString;
     if strData <> '' then
       Buffer:=Buffer + '<AWARD:' + IntToStr(Length(StrData)) + '>' + strData;
     //PWR
     strData:=FormatFloat(FreqFormat, Fields[dfiL_PWR].AsFloat, fSet);
     Buffer:=Buffer + #13#10#9 + '<TX_PWR:' + IntToStr(Length(strData)) + '>' + strData;
     //poznamka
     strData:=Fields[dfiL_Note].AsString;
     if strData <> '' then
       Buffer:=Buffer + #13#10#9 + '<COMMENT:' + IntToStr(Length(strData)) + '>' + strData;
     //
     Buffer:=Buffer + #13#10 + '<eor>' + #13#10;
     ADIF.Write(Buffer[1], Length(Buffer));
   end;
 end;

begin
  ADIF:=TFileStream.Create(FileName, fmCreate or fmShareDenyWrite);
  with Query do
  try
    DisableControls;
    First;
    GetLocaleFormatSettings(0, fSet);
    fSet.DecimalSeparator:='.';
    //zapsat hlavicku
    Buffer:=AppName + ' v' + sVersion + #13#10;
    ADIF.Write(Buffer[1], Length(Buffer));
    if SelectedRows.Count = 0 then
      Buffer:='Exported ' + IntToStr(RecordCount) + ' records'
    else
      Buffer:='Exported ' + IntToStr(SelectedRows.Count) + ' records';
    Buffer:=Buffer + #13#10'<ADIF_VER:4>1.00'#13#10'<EOH>'#13#10;
    ADIF.Write(Buffer[1], Length(Buffer));
    //export dat
    lp:=0;
    if SelectedRows.Count = 0 then
    //vsechna spojeni
    begin
      mp:=RecordCount - 1;
      while not Eof do
      begin
        WriteRecord(Buffer);
        Next;
        if Assigned(OnProgress) then
        try
          ap:=Trunc(RecNo * 100 / mp);
          if lp<>ap then
          begin
            OnProgress(ap);
            lp:=ap;
          end;
        except
        end;
      end;
    end else
    //vybrana spojeni
    begin
      mp:=SelectedRows.Count - 1;
      for i:=0 to SelectedRows.Count - 1 do
      begin
        GotoBookmark(Pointer(SelectedRows.Items[i]));
        WriteRecord(Buffer);
        if Assigned(OnProgress) then
        try
          ap:=Trunc(i * 100 / mp);
          if lp <> ap then
          begin
            OnProgress(ap);
            lp:=ap;
          end;
        except
        end;
      end;
    end;
  finally
    ADIF.Free;
    Query.EnableControls;
  end;
end;

//------------------------------------------------------------------------------
// Export do ADIFu - zkraceny
//------------------------------------------------------------------------------
procedure ExportEQSL(Query:TQuery; SelectedRows:TBookmarkList;
  const QSLNote,FileName:String; OnProgress:TProgressEvent);
var
  ADIF: TFileStream;
  i, ap, lp, mp: Integer;
  fSet: TFormatSettings;
  Buffer: String;

 procedure WriteRecord(var Buffer: String);
 var
   strData: String;
 begin
   with Query.Fields do
   begin
     Buffer:='';
     //znacka
     strData:=Fields[dfiL_Call].AsString;
     Buffer:=Buffer + '<CALL:' + IntToStr(Length(strData)) + '>' + strData;
     //datum
     strData:=FormatDateTime('yyyyMMdd', Fields[dfiL_Date].AsDateTime);
     Buffer:=Buffer + '<QSO_DATE:8>' + strData;
     //cas
     strData:=FormatDateTime('hhNNss', Fields[dfiL_Time].AsDateTime);
     Buffer:=Buffer + '<TIME_ON:6>' + strData;
     //frekvence
     strData:=FormatFloat('0.####', Fields[dfiL_Freq].AsFloat, fSet);
     Buffer:=Buffer + '<FREQ:' + IntToStr(Length(strData)) + '>' + strData;
     //pasmo
     strData:=hBandName[Fields[dfiL_Band].AsInteger];
     Buffer:=Buffer + '<BAND:' + IntToStr(Length(strData)) + '>' + strData;
     //mod
     strData:=hModeName[Fields[dfiL_Mode].AsInteger];
     Buffer:=Buffer + '<MODE:' + IntToStr(Length(strData)) + '>' + strData;
     //RSTo
     strData:=Fields[dfiL_RSTo].AsString;
     Buffer:=Buffer + '<RST_SENT:' + IntToStr(Length(strData)) + '>' + strData;
     //RSTo
     strData:=Fields[dfiL_RSTp].AsString;
     Buffer:=Buffer + '<RST_RCVD:' + IntToStr(Length(strData)) + '>' + strData;
     //LOCo
     Buffer:=Buffer + '<MY_GRIDSQUARE:6>' + Fields[dfiL_LOCo].AsString;
     //QSLp
     if Fields[dfiL_QSLp].AsInteger = qpYes then
       Buffer:=Buffer + '<QSL_RCVD:1>Y'
     else
       Buffer:=Buffer + '<QSL_RCVD:1>N';
     //poznamka na QSL
     Buffer:=Buffer + '<QSLMSG:' + IntToStr(Length(QSLNote)) + '>' + QSLNote;
     //
     Buffer:=Buffer + '<eor>' + #13#10;
     ADIF.Write(Buffer[1], Length(Buffer));
   end;
 end;

begin
  ADIF:=TFileStream.Create(FileName, fmCreate or fmShareDenyWrite);
  with Query do
  try
    DisableControls;
    First;
    GetLocaleFormatSettings(0, fSet);
    fSet.DecimalSeparator:='.';
    //zapsat hlavicku
    Buffer:=AppName + ' v' + sVersion + #13#10;
    ADIF.Write(Buffer[1], Length(Buffer));
    if SelectedRows.Count = 0 then
      Buffer:='Exported ' + IntToStr(RecordCount) + ' records'
    else
      Buffer:='Exported ' + IntToStr(SelectedRows.Count) + ' records';
    Buffer:=Buffer + #13#10'<ADIF_VER:4>1.00'#13#10'<EOH>'#13#10;
    ADIF.Write(Buffer[1], Length(Buffer));
    //export dat
    lp:=0;
    if SelectedRows.Count = 0 then
    //vsechna spojeni
    begin
      mp:=RecordCount - 1;
      while not Eof do
      begin
        WriteRecord(Buffer);
        Next;
        if Assigned(OnProgress) then
        try
          ap:=Trunc(RecNo * 100 / mp);
          if lp <> ap then
          begin
            OnProgress(ap);
            lp:=ap;
          end;
        except
        end;
      end;
    end else
    //vybrana spojeni
    begin
      mp:=SelectedRows.Count - 1;
      for i:=0 to SelectedRows.Count - 1 do
      begin
        GotoBookmark(Pointer(SelectedRows.Items[i]));
        WriteRecord(Buffer);
        if Assigned(OnProgress) then
        try
          ap:=Trunc(i * 100 / mp);
          if lp <> ap then
          begin
            OnProgress(ap);
            lp:=ap;
          end;
        except
        end;
      end;
    end;
  finally
    ADIF.Free;
    Query.EnableControls;
  end;
end;

//------------------------------------------------------------------------------
// export do CSV
//------------------------------------------------------------------------------
procedure ExportCSV(Query: TQuery; SelectedRows: TBookmarkList; const FileName: String;
  OnProgress: TProgressEvent);
var
  CSV: TFileStream;
  Buffer: String;
  i, ap, lp, mp: Integer;

 procedure WriteRecord(var Buffer:String);
 begin
   with Query.Fields do
     Buffer:=
       Fields[dfiL_Date].AsString+';'+
       Fields[dfiL_Time].AsString+';'+
       Fields[dfiL_Call].AsString+';'+
       ExtractHamCall(Fields[dfiL_Call].AsString)+';'+
       Fields[dfiL_Freq].AsString+';'+
       hBandName[Fields[dfiL_Band].AsInteger]+';'+
       hModeName[Fields[dfiL_Mode].AsInteger]+';'+
       Fields[dfiL_RSTo].AsString+';'+
       Fields[dfiL_RSTp].AsString+';'+
       Fields[dfiL_Name].AsString+';'+
       Fields[dfiL_QTH].AsString+';'+
       Fields[dfiL_LOCo].AsString+';'+
       Fields[dfiL_LOCp].AsString+';'+
       hQSLo[Fields[dfiL_QSLo].AsInteger]+';'+
       hQSLp[Fields[dfiL_QSLp].AsInteger]+';'+
       hEQSL[Fields[dfiL_EQSLp].AsInteger]+';'+
       Fields[dfiL_QSLvia].AsString+';'+
       Fields[dfiL_QRB].AsString+';'+
       Fields[dfiL_PWR].AsString+';'+
       Fields[dfiL_Note].AsString+';'+
       Fields[dfiL_DXCC].AsString+';'+
       Fields[dfiL_IOTA].AsString+';'+
       Fields[dfiL_Award].AsString+';'+
       Fields[dfiL_ITU].AsString+';'+
       Fields[dfiL_WAZ].AsString+';'+#13#10;
   CSV.Write(Buffer[1],Length(Buffer));
 end;

begin
  CSV:=TFileStream.Create(FileName,fmCreate or fmShareDenyWrite);
  with Query do
  try
    DisableControls;
    First;
    //zapsani hlavicky
    Buffer:=
      dfL_Caption[dfiL_Date]+';'+
      dfL_Caption[dfiL_Time]+';'+
      dfL_Caption[dfiL_Call]+';'+
      'MCALL;'+
      dfL_Caption[dfiL_Freq]+';'+
      dfL_Caption[dfiL_Band]+';'+
      dfL_Caption[dfiL_Mode]+';'+
      dfL_Caption[dfiL_RSTo]+';'+
      dfL_Caption[dfiL_RSTp]+';'+
      dfL_Caption[dfiL_Name]+';'+
      dfL_Caption[dfiL_QTH]+';'+
      dfL_Caption[dfiL_LOCo]+';'+
      dfL_Caption[dfiL_LOCp]+';'+
      dfL_Caption[dfiL_QSLo]+';'+
      dfL_Caption[dfiL_QSLp]+';'+
      dfL_Caption[dfiL_EQSLp]+';'+
      dfL_Caption[dfiL_QSLvia]+';'+
      dfL_Caption[dfiL_QRB]+';'+
      dfL_Caption[dfiL_PWR]+';'+
      dfL_Caption[dfiL_Note]+';'+
      dfL_Caption[dfiL_DXCC]+';'+
      dfL_Caption[dfiL_IOTA]+';'+
      dfL_Caption[dfiL_Award]+';'+
      dfL_Caption[dfiL_ITU]+';'+
      dfL_Caption[dfiL_WAZ]+';'+#13#10;
    CSV.Write(Buffer[1],Length(Buffer));
    //
    lp:=0;
    if SelectedRows.Count=0 then
    //vsechna spojeni
    begin
      mp:=RecordCount-1;
      while not Eof do
      begin
        WriteRecord(Buffer);
        Next;
        if Assigned(OnProgress) then
        try
          ap:=Trunc(RecNo*100/mp);
          if lp<>ap then
          begin
            OnProgress(ap);
            lp:=ap;
          end;
        except
        end;
      end;
    end else
    //vybrana spojeni
    begin
      mp:=SelectedRows.Count-1;
      for i:=0 to SelectedRows.Count-1 do
      begin
        GotoBookmark(Pointer(SelectedRows.Items[i]));
        WriteRecord(Buffer);
        if Assigned(OnProgress) then
        try
          ap:=Trunc(i*100/mp);
          if lp<>ap then
          begin
            OnProgress(ap);
            lp:=ap;
          end;
        except
        end;
      end;
    end;
  finally
    CSV.Free;
    Query.EnableControls;
  end;
end;

//------------------------------------------------------------------------------
// export do TXT
//------------------------------------------------------------------------------
procedure ExportTXT(Query:TQuery; SelectedRows:TBookmarkList; const FileName:String;
  OnProgress:TProgressEvent);
var
  TXT:TFileStream;
  Buffer:String;
  i,ap,lp,mp:Integer;

 procedure WriteRecord(var Buffer:String);
 begin
   with Query.Fields do
   begin
     Buffer:=Format(
       '%10s %8s %-15s %-15s %10s %-6s %-6s %-4s %-4s %-12s '+
       '%-20s %-6s %-6s %-4s %-4s %-4s %-15s %5s %7s %-50s %-7s %-7s %-10s %-4s %-4s',
       [FormatDateTime(DateLFormat,Fields[dfiL_Date].AsDateTime), //datum
        FormatDateTime(TimeLFormat,Fields[dfiL_Time].AsDateTime), //cas
        Fields[dfiL_Call].AsString, //znacka
        ExtractHamCall(Fields[dfiL_Call].AsString), //mznacka
        FormatFloat('0.000',Fields[dfiL_Freq].AsFloat), //frekvence
        hBandName[Fields[dfiL_Band].AsInteger], //pasmo
        hModeName[Fields[dfiL_Mode].AsInteger], //mod
        Fields[dfiL_RSTo].AsString, //RSTo
        Fields[dfiL_RSTp].AsString, //RSTp
        Fields[dfiL_Name].AsString, //jmeno
        Fields[dfiL_QTH].AsString, //qth
        Fields[dfiL_LOCo].AsString, //locvl
        Fields[dfiL_LOCp].AsString, //loc
        hQSLo[Fields[dfiL_QSLo].AsInteger], //qslo
        hQSLp[Fields[dfiL_QSLp].AsInteger], //qslp
        hEQSL[Fields[dfiL_eQSLp].AsInteger], //eqsl
        Fields[dfiL_QSLvia].AsString, //qslmgr
        FormatFloat('0',Fields[dfiL_QRB].AsFloat), //dist
        FormatFloat('0.###',Fields[dfiL_PWR].AsFloat), //pwr
        Fields[dfiL_Note].AsString, //poznamka
        Fields[dfiL_Dxcc].AsString, //dxcc
        Fields[dfiL_IOTA].AsString, //IOTA
        Fields[dfiL_Award].AsString, //diplom
        Fields[dfiL_ITU].AsString, //ITU
        Fields[dfiL_WAZ].AsString //WAZ
       ])+#13+#10;
     TXT.Write(Buffer[1],Length(Buffer));
   end;
 end;

begin
  TXT:=TFileStream.Create(FileName,fmCreate or fmShareDenyWrite);
  with Query do
  try
    DisableControls;
    First;
    //zapsani hlavicky
    Buffer:=Format(
      '%-10s %-8s %-15s %-15s %10s %-6s %-6s %-4s %-4s %-12s '+
      '%-20s %-6s %-6s %4s %4s %4s %-15s %5s %7s %-50s %-7s %-7s %-10s %-4s %-4s',
      [dfL_Caption[dfiL_Date],dfL_Caption[dfiL_Time],dfL_Caption[dfiL_Call],'MCALL',
       dfL_Caption[dfiL_Freq],dfL_Caption[dfiL_Band],dfL_Caption[dfiL_Mode],
       dfL_Caption[dfiL_RSTo],dfL_Caption[dfiL_RSTp],dfL_Caption[dfiL_Name],
       dfL_Caption[dfiL_QTH],dfL_Caption[dfiL_LOCo],dfL_Caption[dfiL_LOCp],
       dfL_Caption[dfiL_QSLo],dfL_Caption[dfiL_QSLp],dfL_Caption[dfiL_EQSLp],
       dfL_Caption[dfiL_QSLvia],dfL_Caption[dfiL_QRB],dfL_Caption[dfiL_PWR],
       dfL_Caption[dfiL_Note],dfL_Caption[dfiL_DXCC],dfL_Caption[dfiL_IOTA],
       dfL_Caption[dfiL_Award],dfL_Caption[dfiL_ITU],dfL_Caption[dfiL_WAZ]])+#13#10;
    TXT.Write(Buffer[1],Length(Buffer));
    SetLength(Buffer,272);
    for i:=1 to 270 do Buffer[i]:='-';
    Buffer[271]:=#13; Buffer[272]:=#10;
    TXT.Write(Buffer[1],Length(Buffer));
    //zapsani dat
    lp:=0;
    if SelectedRows.Count=0 then
    //vsechna spojeni
    begin
      mp:=RecordCount-1;
      while not Eof do
      begin
        WriteRecord(Buffer);
        Next;
        if Assigned(OnProgress) then
        try
          ap:=Trunc(RecNo*100/mp);
          if lp<>ap then
          begin
            OnProgress(ap);
            lp:=ap;
          end;
        except
        end;
      end;
    end else
    //vybrana spojeni
    begin
      mp:=SelectedRows.Count-1;
      for i:=0 to SelectedRows.Count-1 do
      begin
        GotoBookmark(Pointer(SelectedRows.Items[i]));
        WriteRecord(Buffer);
        if Assigned(OnProgress) then
        try
          ap:=Trunc(i*100/mp);
          if lp<>ap then
          begin
            OnProgress(ap);
            lp:=ap;
          end;
        except
        end;
      end;
    end;
  finally
    TXT.Free;
    Query.EnableControls;
  end;
end;

//------------------------------------------------------------------------------
//export Excel
//------------------------------------------------------------------------------
procedure ExportXLS(Query:TQuery; SelectedRows:TBookmarkList;
  OnProgress:TProgressEvent);
const
  BufferSize=1000;
var
  XLApp:TExcelApplication;
  WorkBk:_WorkBook;
  WorkSheet:_WorkSheet;
  Buffer:Variant;
  i,Count,Index,ap,lp,mp:Integer;

 procedure AddRecord(Row:Integer);
 begin
   with Query.Fields do
   begin
     Buffer[Row,0]:=FormatDateTime(DateLFormat, Fields[dfiL_Date].AsDateTime);
     Buffer[Row,1]:=Fields[dfiL_Time].AsDateTime;
     Buffer[Row,2]:=Fields[dfiL_Call].AsString;
     Buffer[Row,3]:=ExtractHamCall(Fields[dfiL_Call].AsString);
     Buffer[Row,4]:=Fields[dfiL_Freq].AsFloat;
     Buffer[Row,5]:=String(hBandName[Fields[dfiL_Band].AsInteger]);
     Buffer[Row,6]:=String(hModeName[Fields[dfiL_Mode].AsInteger]);
     Buffer[Row,7]:=Fields[dfiL_RSTo].AsString;
     Buffer[Row,8]:=Fields[dfiL_RSTp].AsString;
     Buffer[Row,9]:=Fields[dfiL_Name].AsString;
     Buffer[Row,10]:=Fields[dfiL_QTH].AsString;
     Buffer[Row,11]:=Fields[dfiL_LOCp].AsString;
     Buffer[Row,12]:=Fields[dfiL_LOCo].AsString;
     Buffer[Row,13]:=String(hQSLoNames[Fields[dfiL_QSLo].AsInteger]);
     Buffer[Row,14]:=String(hQSLpNames[Fields[dfiL_QSLp].AsInteger]);
     Buffer[Row,15]:=String(hEQSLNames[Fields[dfiL_EQSLp].AsInteger]);
     Buffer[Row,16]:=String(Fields[dfiL_QSLvia].AsString);
     Buffer[Row,17]:=Fields[dfiL_Note].AsString;
     Buffer[Row,18]:=Fields[dfiL_PWR].AsFloat;
     Buffer[Row,19]:=Fields[dfiL_DXCC].AsString;
     Buffer[Row,20]:=Fields[dfiL_ITU].AsInteger;
     Buffer[Row,21]:=Fields[dfiL_WAZ].AsInteger;
     Buffer[Row,22]:=Fields[dfiL_IOTA].AsString;
     Buffer[Row,23]:=Fields[dfiL_Award].AsString;
   end;
   Inc(Count);
 end;

begin
  XLApp:=TExcelApplication.Create(nil);
  with Query do
  try
    DisableControls;
    First;
    XLApp.Connect;
    WorkBk:=XLApp.WorkBooks.Add(xlWBatWorkSheet,0);
    WorkSheet:=WorkBk.WorkSheets.Get_Item(1) as _WorkSheet;
    WorkSheet.Name:='Tab';
    //hlavicka
    WorkSheet.Range['A1','X1'].Value2:=VarArrayOf([
      dfL_Caption[dfiL_Date],dfL_Caption[dfiL_Time],dfL_Caption[dfiL_Call],
      'MCALL',dfL_Caption[dfiL_Freq],dfL_Caption[dfiL_Band],
      dfL_Caption[dfiL_Mode],dfL_Caption[dfiL_RSTo],dfL_Caption[dfiL_RSTp],
      dfL_Caption[dfiL_Name],dfL_Caption[dfiL_QTH],dfL_Caption[dfiL_LOCp],
      dfL_Caption[dfiL_LOCo],dfL_Caption[dfiL_QSLo],dfL_Caption[dfiL_QSLp],
      dfL_Caption[dfiL_EQSLp],dfL_Caption[dfiL_QSLvia],dfL_Caption[dfiL_Note],
      dfL_Caption[dfiL_PWR],dfL_Caption[dfiL_DXCC],dfL_Caption[dfiL_ITU],
      dfL_Caption[dfiL_WAZ],dfL_Caption[dfiL_IOTA],dfL_Caption[dfiL_Award]]);
    WorkSheet.Range['A1','X1'].Font.Bold:=1;
    //
    Buffer:=VarArrayCreate([0,BufferSize-1,0,23],varVariant);
    lp:=0;
    if SelectedRows.Count=0 then
    //vsechna spojeni
    begin
      mp:=RecordCount;
      if mp>65534 then mp:=65534;
      Count:=0;
      Index:=2;
      while RecNo<mp do
      begin
        AddRecord(Count);
        if Count=BufferSize then
        begin
          WorkSheet.Range[WorkSheet.Cells.Item[Index,1],
                          WorkSheet.Cells.Item[Index+Count-1,24]].Value2:=Buffer;
          Index:=Index+Count;
          Count:=0;
        end;
        Next;
        if Assigned(OnProgress) then
        try
          ap:=Trunc(RecNo*100/mp);
          if lp<>ap then
          begin
            OnProgress(ap);
            lp:=ap;
          end;
        except
        end;
      end;
      AddRecord(Count);
      WorkSheet.Range[WorkSheet.Cells.Item[Index,1],
                      WorkSheet.Cells.Item[Index+Count-1,24]].Value2:=Buffer;
//      WorkSheet.Range['A2','A'+IntToStr(Query.RecordCount+1)].NumberFormat:='dd.mm.rrrr';
      WorkSheet.Range['B2','B'+IntToStr(RecordCount+1)].NumberFormat:='hh:mm:ss';
      WorkSheet.Range['D2','D'+IntToStr(RecordCount+1)].NumberFormat:='0,0000';
      WorkSheet.Range['G2','H'+IntToStr(RecordCount+1)].NumberFormat:='@';
    end else
    begin
      mp:=SelectedRows.Count-1;
      if mp>65535 then mp:=65535;
      Count:=0;
      Index:=2;
      for i:=0 to mp do
      begin
        GotoBookmark(Pointer(SelectedRows.Items[i]));
        AddRecord(Count);
        if (i=mp)or(Count=BufferSize) then
        begin
          WorkSheet.Range[WorkSheet.Cells.Item[Index,1],
                          WorkSheet.Cells.Item[Index+Count-1,24]].Value2:=Buffer;
          Index:=Index+Count;
          Count:=0;
        end;
        if Assigned(OnProgress) then
        try
          ap:=Trunc(RecNo*100/mp);
          if lp<>ap then
          begin
            OnProgress(ap);
            lp:=ap;
          end;
        except
        end;
      end;
//      WorkSheet.Range['A2','A'+IntToStr(SelectedRows.Count+1)].NumberFormat:='mm.dd.rrrr';
      WorkSheet.Range['B2','B'+IntToStr(SelectedRows.Count+1)].NumberFormat:='hh:mm:ss';
      WorkSheet.Range['D2','D'+IntToStr(SelectedRows.Count+1)].NumberFormat:='0,0000';
      WorkSheet.Range['G2','H'+IntToStr(SelectedRows.Count+1)].NumberFormat:='@';
    end;
    WorkSheet.Columns.AutoFit;
  finally
    XLApp.Visible[0]:=True;
    XLApp.Disconnect;
    XLApp.Free;
    Query.EnableControls;
  end;
end;

//------------------------------------------------------------------------------
//export vybranych QSO
//------------------------------------------------------------------------------
procedure ExportSelected(Query:TQuery; SelectedRows:TBookmarkList; const FileName:String;
  OnProgress:TProgressEvent);
var
  Table:TTable;
  i,j,ap,lp,mp:Integer;
begin
  Table:=TTable.Create(nil);
  try
    Query.DisableControls;
    Table.TableName:=FileName;
    CreateLogDB(Table);
    Table.Open;
    //
    mp:=SelectedRows.Count-1;
    lp:=0;
    for i:=0 to mp do
    begin
      Query.GotoBookmark(Pointer(SelectedRows.Items[i]));
      Table.Append;
      for j:=1 to Table.Fields.Count-1 do
        Table.Fields.Fields[j]:=Query.Fields.Fields[j];
      Table.Post;
      if Assigned(OnProgress) then
      try
        ap:=Trunc(i*100/mp);
        if lp<>ap then
        begin
          OnProgress(ap);
          lp:=ap;
        end;
      except
      end;
    end;
    Table.Close;
  finally
    Table.Free;
    Query.EnableControls;
  end;
end;

//------------------------------------------------------------------------------
//trideni QSL pro QSL sluzbu
//------------------------------------------------------------------------------
procedure SortQSL(const InputFile,OutputFile:String; OnProgress:TProgressEvent);
const
  dOrder=dfnL_Call+','+dfnL_Date+','+dfnL_Time;
var
  Query:TQuery;
  Table:TTable;
  i:Integer;
  dFields:String;
begin
  Query:=TQuery.Create(nil);
  Table:=TTable.Create(nil);
  try
    //vytvorit a otevrit tabulku
    Table.TableName:=OutputFile;
    CreateLogDB(Table);
    Table.Open;
    //
    dFields:=dfL_Name[Low(dfL_Name)];
    for i:=Low(dfL_Name)+1 to High(dfL_Name) do dFields:=dFields+','+dfL_Name[i];
    with Query,Query.SQL do
    begin
      //OK 2 pismenne znacky
      if Assigned(OnProgress) then OnProgress(0);
      Clear;
      Add('SELECT '+dFields+',SUBSTRING ('+dfnL_Call+' FROM 4) AS Sufix,'+dfnL_Index);
      Add('FROM "'+InputFile+'"');
      Add('WHERE  (SUBSTRING ('+dfnL_Call+' FROM 6 FOR 1) NOT IN');
      Add('("A","B","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R",');
      Add('"S","T","U","V","W","X","Y","Z")) and');
      Add('(SUBSTRING ('+dfnL_Call+' FROM 1 FOR 3) IN ("OK0","OK1","OK2","OK3","OK4","OK6","OK7","OK9"))');
      Add('ORDER BY Sufix,'+dOrder);
      Open;
      if Assigned(OnProgress) then OnProgress(1);
      Table.BatchMove(Query,batAppend);
      //OK 3 pismenne znacky
      if Assigned(OnProgress) then OnProgress(2);
      Clear;
      Add('SELECT '+dFields+',SUBSTRING ('+dfnL_Call+' FROM 4) AS Sufix,'+dfnL_Index);
      Add('FROM "'+InputFile+'"');
      Add('WHERE  (SUBSTRING ('+dfnL_Call+' FROM 6 FOR 1) IN');
      Add('("A","B","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R",');
      Add('"S","T","U","V","W","X","Y","Z")) and');
      Add('(SUBSTRING ('+dfnL_Call+' FROM 1 FOR 3) IN ("OK0","OK1","OK2","OK3","OK4","OK6","OK7","OK9"))');
      Add('ORDER BY Sufix,'+dOrder);
      Open;
      if Assigned(OnProgress) then OnProgress(3);
      Table.BatchMove(Query,batAppend);
      //OK ostatni
      if Assigned(OnProgress) then OnProgress(4);
      Clear;
      Add('SELECT '+dFields+',SUBSTRING ('+dfnL_Call+' FROM 4) AS Sufix,'+dfnL_Index);
      Add('FROM "'+InputFile+'"');
      Add('WHERE ('+dfnL_DXCC+'="OK") AND');
      Add('(SUBSTRING ('+dfnL_Call+' FROM 1 FOR 3) NOT IN ("OK0","OK1","OK2","OK3","OK4","OK6","OK7","OK9"))');
      Add('ORDER BY '+dOrder);
      Open;
      if Assigned(OnProgress) then OnProgress(5);
      Table.BatchMove(Query,batAppend);
      //USA
      if Assigned(OnProgress) then OnProgress(6);
      Clear;
      Add('SELECT '+dFields+',SUBSTRING ('+dfnL_Call+' FROM 2 FOR 1) AS pID,'+dfnL_Index);
      Add('FROM "'+InputFile+'"');
      Add('WHERE ('+dfnL_DXCC+'="K") AND');
      Add('(SUBSTRING ('+dfnL_Call+' FROM 2 FOR 1) IN ("0","1","2","3","4","5","6","7","8","9"))');
      Add('UNION');
      Add('SELECT '+dFields+',SUBSTRING ('+dfnL_Call+' FROM 3 FOR 1) AS pID,'+dfnL_Index);
      Add('FROM "'+InputFile+'"');
      Add('WHERE ('+dfnL_DXCC+'="K") AND');
      Add('(SUBSTRING ('+dfnL_Call+' FROM 3 FOR 1) IN ("0","1","2","3","4","5","6","7","8","9"))');
      Add('ORDER BY pID,'+dOrder);
      Open;
      if Assigned(OnProgress) then OnProgress(7);
      Table.BatchMove(Query,batAppend);
      if Assigned(OnProgress) then OnProgress(8);
      Clear;
      Add('SELECT '+dFields+','+dfnL_Index);
      Add('FROM "'+InputFile+'"');
      Add('WHERE ('+dfnL_DXCC+'="K") AND');
      Add('(SUBSTRING ('+dfnL_Call+' FROM 2 FOR 1) NOT IN ("0","1","2","3","4","5","6","7","8","9")) AND');
      Add('(SUBSTRING ('+dfnL_Call+' FROM 3 FOR 1) NOT IN ("0","1","2","3","4","5","6","7","8","9"))');
      Add('ORDER BY '+dOrder);
      Open;
      if Assigned(OnProgress) then OnProgress(9);
      Table.BatchMove(Query,batAppend);
      //zbytek sveta ...
      if Assigned(OnProgress) then OnProgress(10);
      Clear;
      Add('SELECT '+dFields+','+dfnL_Index);
      Add('FROM "'+InputFile+'"');
      Add('WHERE ('+dfnL_DXCC+' NOT IN ("K","OK"))');
      Add('ORDER BY '+dOrder);
      Open;
      if Assigned(OnProgress) then OnProgress(11);
      Table.BatchMove(Query,batAppend);
      if Assigned(OnProgress) then OnProgress(12);
      Close;
    end;
    Table.Close;
  finally
    Query.Free;
    Table.Free;
  end;
end;

end.
