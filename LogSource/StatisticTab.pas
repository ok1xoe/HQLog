{$include global.inc}
unit StatisticTab;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Grids, ComCtrls, ToolWin, ActnMan, ActnCtrls, ActnMenus,
  XPStyleActnCtrls, ActnList, StdCtrls, Amater, DBTables, DB;

type
  TBandData = record
    Count,QSL:Integer;
  end;
  TStatRec = record
    Name:String[30];
    Band:Array[Low(hBandName)..High(hBandName)] of TBandData;
  end;
  //
  TfrmStatTab = class(TForm)
    dgdStat: TDrawGrid;
    actManager: TActionManager;
    actMainMenuBar: TActionMainMenuBar;
    tlBar: TToolBar;
    actSaveAs: TAction;
    actExit: TAction;
    actFilter: TAction;
    tlBtnFilter: TToolButton;
    stBar: TStatusBar;
    actStatDXCC: TAction;
    actStatIOTA: TAction;
    actStatLOC: TAction;
    tlBtnDXCC: TToolButton;
    tlBtnIOTA: TToolButton;
    tlBtnLOC: TToolButton;
    ToolButton4: TToolButton;
    qStat: TQuery;
    qList: TQuery;
    tlBtnITU: TToolButton;
    tlBtnWAZ: TToolButton;
    actStatITU: TAction;
    actStatWAZ: TAction;
    //
    procedure FormCreate(Sender: TObject);
    //
    procedure dgdStatDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure dgdStatKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure dgdStatMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure dgdStatMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    //
    procedure actSaveAsExecute(Sender: TObject);
    procedure actExitExecute(Sender: TObject);
    //
    procedure actStatDXCCExecute(Sender: TObject);
    procedure actStatIOTAExecute(Sender: TObject);
    procedure actStatLOCExecute(Sender: TObject);
    //
    procedure actFilterExecute(Sender: TObject);
    procedure actStatITUExecute(Sender: TObject);
    procedure actStatWAZExecute(Sender: TObject);
  private
    { Private declarations }
    dFilter:String;
    StatHeader,SumHeader,SumQSOHeader:String;
    StatList:Array of TStatRec;
    StatSumList:Array[Low(hBandName)..High(hBandName)] of TBandData;
    StatSumQSOList:Array[Low(hBandName)..High(hBandName)] of TBandData;
    //
    procedure OnSysCommand(var Msg: TWMSysCommand); message WM_SYSCOMMAND;
    //
    function CreateFilter:Boolean;
    //
    procedure GetDXCC(out tQSL,tCount:Integer);
    procedure GetIOTA(out tQSL,tCount:Integer);
    procedure GetITU(out tQSL,tCount:Integer);
    procedure GetWAZ(out tQSL,tCount:Integer);
    procedure GetLOC(out tQSL,tCount:Integer);
    //
    procedure ExportCSV(const FileName:String);
  public
    { Public declarations }
  end;

var
  frmStatTab: TfrmStatTab;

implementation

uses HQLDMod, HQLResStrings, HQLDatabase, HQLConsts, TextDialog,
  StatOptions;

{$R *.dfm}

//------------------------------------------------------------------------------
//frmStat
//------------------------------------------------------------------------------

procedure TfrmStatTab.FormCreate(Sender: TObject);
begin
  //
  frmStatFilter:=TfrmStatFilter.Create(Self);
  //
  qStat.DatabaseName:=BDEAlias;
  qList.DatabaseName:=dmLog.RootDir;
  //
  dgdStat.Canvas.Font.Name:=dgdStat.Font.Name;
  dgdStat.DefaultColWidth:=68;
  dgdStat.ColWidths[0]:=245;
  dgdStat.ColCount:=Length(hBandName)+1;
  //
  dFilter:='';
  actFilter.Enabled:=False;
end;

procedure TfrmStatTab.OnSysCommand(var Msg: TWMSysCommand);
begin
  if Msg.CmdType=SC_MINIMIZE then ShowWindow(Application.Handle,SW_SHOWMINNOACTIVE)
                             else inherited;
end;

//------------------------------------------------------------------------------
//dgdStat
//------------------------------------------------------------------------------

procedure TfrmStatTab.dgdStatDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);

 procedure aTextOut(Handle:THandle; Rect:TRect; Alignment:TAlignment; Text:PChar);
 begin
   Inc(Rect.Left,3);
   Dec(Rect.Right,3);
   case Alignment of
     taCenter: Windows.DrawText(Handle,Text,-1,Rect,
       DT_CENTER or DT_VCENTER or DT_NOPREFIX or DT_SINGLELINE);
     taRightJustify: Windows.DrawText(Handle,Text,-1,Rect,
       DT_RIGHT or DT_VCENTER or DT_NOPREFIX or DT_SINGLELINE);
   else
     Windows.DrawText(Handle,Text,-1,Rect,
       DT_LEFT or DT_VCENTER or DT_NOPREFIX or DT_SINGLELINE);
   end;
 end;

begin
  with TDrawGrid(Sender),Canvas do
  begin
    //pozadi
    if (ARow in [0,1,2]) then Brush.Color:=$F7EFE8 else
      if not Odd(ARow) then Brush.Color:=clOfEvenRow
                   else Brush.Color:=clOfOddRow;
    FillRect(Rect);
    //vertikalni cary
    if ACol in [0,ColCount-1] then Pen.Color:=clBlack
                              else Pen.Color:=clSilver;
    MoveTo(Rect.Right-1,Rect.Top);
    LineTo(Rect.Right-1,Rect.Bottom);
    //
    Pen.Color:=clBlack;
    case ARow of
      //nadpisy/pasma
      0: begin
        Pen.Color:=clSilver;
        MoveTo(Rect.Left,Rect.Bottom-1);
        LineTo(Rect.Right,Rect.Bottom-1);
        //
        Brush.Color:=$F7EFE8;
        Font.Color:=clGreen;
        Font.Style:=[fsBold];
        if ACol=0 then aTextOut(Canvas.Handle,Rect,taLeftJustify,Pointer(StatHeader))
                  else aTextOut(Canvas.Handle,Rect,taCenter,hBandName[ACol-1]);
      end;
      //potvrzenych/celkem
      1: begin
        Brush.Color:=$F7EFE8;
        Font.Color:=clBlack;
        Font.Style:=[fsBold];
        if ACol=0
          then aTextOut(Canvas.Handle,Rect,taLeftJustify,Pointer(SumHeader))
          else aTextOut(Canvas.Handle,Rect,taCenter,
            Pointer(Format('%0:d/%1:d',[StatSumList[ACol-1].QSL,StatSumList[ACol-1].Count])));
      end;
      2:begin
        Pen.Color:=clBlack;
        MoveTo(Rect.Left,Rect.Bottom-1);
        LineTo(Rect.Right,Rect.Bottom-1);
        //
        Brush.Color:=$F7EFE8;
        Font.Color:=clBlack;
        Font.Style:=[];
        if ACol=0
          then aTextOut(Canvas.Handle,Rect,taLeftJustify,Pointer(SumQSOHeader))
          else aTextOut(Canvas.Handle,Rect,taCenter,
            Pointer(Format('%0:d/%1:d',[StatSumQSOList[ACol-1].QSL,StatSumQSOList[ACol-1].Count])));
      end;
    else
      if ARow=RowCount-1 then
      begin
        Brush.Color:=clBlack;
        MoveTo(Rect.Left,Rect.Bottom-1);
        LineTo(Rect.Right,Rect.Bottom-1);
      end;
      //
      if Length(StatList)<ARow-2 then Exit;
      //
      if not Odd(ARow) then Brush.Color:=clOfEvenRow
                       else Brush.Color:=clOfOddRow;
      Font.Color:=clBlack;
      Dec(ARow,3);
      Dec(ACol);
      if ACol=-1 then
      begin
        Font.Color:=clGreen;
        Font.Style:=[fsBold];
        aTextOut(Canvas.Handle,Rect,taLeftJustify,@StatList[ARow].Name[1])
      end else
      begin
        Font.Color:=clBlack;
        if StatList[ARow].Band[ACol].QSL=0 then Font.Style:=[]
                                           else Font.Style:=[fsBold];
        if StatList[ARow].Band[ACol].Count<>0 then
          aTextOut(Canvas.Handle,Rect,taCenter,
            Pointer(Format('%0:d/%1:d',[StatList[ARow].Band[ACol].QSL,
                                        StatList[ARow].Band[ACol].Count])));
      end;
    end;
  end;
end;

procedure TfrmStatTab.dgdStatKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  with TDrawGrid(Sender) do
  case Key of
    vk_Down: begin
      SendMessage(Handle,WM_VSCROLL,SB_LINEDOWN,0);
      Key:=0;
    end;
    vk_Up: begin
      SendMessage(Handle,WM_VSCROLL,SB_LINEUP,0);
      Key:=0;
    end;
    vk_Home: begin
      SendMessage(Handle,WM_VSCROLL,SB_TOP,0);
      Key:=0;
    end;
    vk_End: begin
      SendMessage(Handle,WM_VSCROLL,SB_BOTTOM,0);
      Key:=0;
    end;
    vk_Left: begin
      SendMessage(Handle,WM_HSCROLL,SB_LINELEFT,0);
      Key:=0;
    end;
    vk_Right: begin
      SendMessage(Handle,WM_HSCROLL,SB_LINERIGHT,0);
      Key:=0;
    end;
  end;
end;

procedure TfrmStatTab.dgdStatMouseWheelDown(Sender: TObject;
  Shift: TShiftState; MousePos: TPoint; var Handled: Boolean);
begin
  SendMessage(TDrawGrid(Sender).Handle,WM_VSCROLL,SB_LINEDOWN,0);
  Handled:=True;
end;

procedure TfrmStatTab.dgdStatMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  SendMessage(TDrawGrid(Sender).Handle,WM_VSCROLL,SB_LINEUP,0);
  Handled:=True;
end;

//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------

function TfrmStatTab.CreateFilter:Boolean;
var
  i:Integer;
  str:String;
begin
  Result:=False;
  with frmStatFilter do
  begin
    if frmStatFilter.ShowModal<>mrOk then Exit;
    //
    str:='('+dfnL_Mode+' IN (';
    for i:=0 to chlBoxModes.Items.Count-1 do
      if chlBoxModes.Checked[i] then str:=str+IntToStr(i+1)+',';
    Delete(str,Length(str),1);
    str:=str+'))';
    //datum min
    if edtDateMin.Text<>'' then
      str:=str+'AND('+dfnL_Date+'>="'+edtDateMin.Text+'")';
    //datum max
    if edtDateMax.Text<>'' then
      str:=str+'AND('+dfnL_Date+'<="'+edtDateMax.Text+'")';
    //vykon min
    if cbBoxPWRmin.Text<>'' then
      str:=str+'AND('+dfnL_PWR+'>="'+cbBoxPWRmin.Text+'")';
    //vykon max
    if cbBoxPWRmax.Text<>'' then
      str:=str+'AND('+dfnL_PWR+'<="'+cbBoxPWRmax.Text+'")';
  end;
  dFilter:=str;
  Result:=True;
  actFilter.Enabled:=True;
end;

//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------

//dxcc
procedure TfrmStatTab.GetDXCC(out tQSL,tCount:Integer);
var
  lDxcc:String;
  i,j,rIndex,ListIndex,ap,lp:Integer;
  q:Boolean;
begin
  with qStat,Fields do
  try
    lp:=0;
    frmDialog.ZobrazProg(strGenStat,0,100);
    //
    SQL.Clear;
    SQL.Add(Format('SELECT %1:s,%2:s,%3:s FROM "%0:s" WHERE %4:s ORDER BY %1:s,%2:s,%3:s',
      [dmLog.User.Call,dfnL_DXCC,dfnL_Band,dfnL_QSLp,dFilter]));
    Open;
    //
    qList.SQL.Clear;
    qList.SQL.Add(Format('SELECT DISTINCT %1:s,%2:s FROM "%0:s" ORDER BY %1:s,%2:s',
      ['dxcc.db',dfnD_Dxcc,dfnD_Name]));
    qList.Open;
    qList.First;
    //
    StatList:=nil;
    SetLength(StatList,qList.RecordCount+1);
    for i:=Low(StatSumQSOList) to High(StatSumQSOList) do
    begin
      StatSumQSOList[i].Count:=0;
      StatSumQSOList[i].QSL:=0;
    end;
    tQSL:=0;
    //
    rIndex:=-1;
    lDxcc:=#0;
    q:=False;
    for i:=0 to qStat.RecordCount-1 do
    begin
      if Fields[0].AsString<>lDXCC then
      begin
        Inc(rIndex);
        j:=Length(StatList);
        if rIndex>=j then SetLength(StatList,j+20);
        lDxcc:=Fields[0].AsString;
        q:=False;
        //
        ListIndex:=qList.RecNo;
        while (qList.Fields.Fields[0].AsString<>lDxcc)and(not qList.Eof) do qList.Next;
        if qList.Fields.Fields[0].AsString<>lDxcc then
        begin
          qList.RecNo:=ListIndex;
          StatList[rIndex].Name:=lDxcc+' - ?';
        end else StatList[rIndex].Name:=lDxcc+' - '+qList.Fields.Fields[1].AsString;
        //
      end;
      Inc(StatSumQSOList[Fields[1].AsInteger].Count);
      Inc(StatList[rIndex].Band[Fields[1].AsInteger].Count);
      if Fields[2].AsInteger=1 then
      begin
        Inc(StatSumQSOList[Fields[1].AsInteger].QSL);
        Inc(StatList[rIndex].Band[Fields[1].AsInteger].QSL);
        if not q then
        begin
          Inc(tQSL);
          q:=True;
        end;
      end;
      Next;
      try
        ap:=Trunc(RecNo*100/(RecordCount-1));
        if lp<>ap then
        begin
          frmDialog.pgBar.Progress:=ap;
          lp:=ap;
        end;
      except
      end;
    end;
    SetLength(StatList,rIndex+1);
    tCount:=rIndex+1;
    //
    for j:=Low(StatSumList) to High(StatSumList) do
    begin
      StatSumList[j].Count:=0;
      StatSumList[j].QSL:=0;
    end;
    for i:=Low(StatList) to High(StatList) do
      for j:=Low(StatSumList) to High(StatSumList) do
        if StatList[i].Band[j].Count>0 then
        begin
          Inc(StatSumList[j].Count);
          if StatList[i].Band[j].QSL>0 then Inc(StatSumList[j].QSL);
        end;
  finally
    qStat.Close;
    qList.Close;
    frmDialog.Close;
  end;
end;

//IOTA
procedure TfrmStatTab.GetIOTA(out tQSL,tCount:Integer);
var
  lIOTA:String;
  i,j,rIndex,ListIndex,ap,lp:Integer;
  q:Boolean;
begin
  with qStat,Fields do
  try
    lp:=0;
    frmDialog.ZobrazProg(strGenStat,0,100);
    //
    SQL.Clear;
    SQL.Add(Format('SELECT %1:s,%2:s,%3:s FROM "%0:s" '+
      'WHERE (%1:s<>"")AND%4:s ORDER BY %1:s,%2:s,%3:s',
      [dmLog.User.Call,dfnL_IOTA,dfnL_Band,dfnL_QSLp,dFilter]));
    Open;
    //
    qList.SQL.Clear;
    qList.SQL.Add(Format('SELECT DISTINCT %1:s,%2:s FROM "%0:s" ORDER BY %1:s',
      ['iota.db',dfnI_IOTA,dfnI_Name]));
    qList.Open;
    qList.First;
    //
    StatList:=nil;
    SetLength(StatList,qList.RecordCount+1);
    for i:=Low(StatSumQSOList) to High(StatSumQSOList) do
    begin
      StatSumQSOList[i].Count:=0;
      StatSumQSOList[i].QSL:=0;
    end;
    tQSL:=0;
    //
    rIndex:=-1;
    lIOTA:='';
    q:=False;
    for i:=0 to qStat.RecordCount-1 do
    begin
      if Fields[0].AsString<>lIOTA then
      begin
        Inc(rIndex);
        j:=Length(StatList);
        if rIndex>=j then SetLength(StatList,j+20);
        lIOTA:=Fields[0].AsString;
        q:=False;
        //
        ListIndex:=qList.RecNo;
        while (qList.Fields.Fields[0].AsString<>lIOTA)and(not qList.Eof) do qList.Next;
        if qList.Fields.Fields[0].AsString<>lIOTA then
        begin
          qList.RecNo:=ListIndex;
          StatList[rIndex].Name:=lIOTA+' - ?';
        end else StatList[rIndex].Name:=lIOTA+' - '+qList.Fields.Fields[1].AsString;
        //
      end;
      Inc(StatSumQSOList[Fields[1].AsInteger].Count);
      Inc(StatList[rIndex].Band[Fields[1].AsInteger].Count);
      if Fields[2].AsInteger=1 then
      begin
        Inc(StatSumQSOList[Fields[1].AsInteger].QSL);
        Inc(StatList[rIndex].Band[Fields[1].AsInteger].QSL);
        if not q then
        begin
          Inc(tQSL);
          q:=True;
        end;
      end;
      Next;
      try
        ap:=Trunc(RecNo*100/(RecordCount-1));
        if lp<>ap then
        begin
          frmDialog.pgBar.Progress:=ap;
          lp:=ap;
        end;
      except
      end;
    end;
    SetLength(StatList,rIndex+1);
    tCount:=rIndex+1;
    //
    for j:=Low(StatSumList) to High(StatSumList) do
    begin
      StatSumList[j].Count:=0;
      StatSumList[j].QSL:=0;
    end;
    for i:=Low(StatList) to High(StatList) do
      for j:=Low(StatSumList) to High(StatSumList) do
        if StatList[i].Band[j].Count>0 then
        begin
          Inc(StatSumList[j].Count);
          if StatList[i].Band[j].QSL>0 then Inc(StatSumList[j].QSL);
        end;
  finally
    qStat.Close;
    qList.Close;
    frmDialog.Close;
  end;
end;

//ITU
procedure TfrmStatTab.GetITU(out tQSL,tCount:Integer);
var
  i,j,lITU,rIndex,ap,lp:Integer;
  q:Boolean;
begin
  with qStat,Fields do
  try
    lp:=0;
    frmDialog.ZobrazProg(strGenStat,0,100);
    //
    SQL.Clear;
    SQL.Add(Format('SELECT %1:s,%2:s,%3:s FROM "%0:s" WHERE %4:s ORDER BY %1:s,%2:s,%3:s',
      [dmLog.User.Call,dfnL_ITU,dfnL_Band,dfnL_QSLp,dFilter]));
    Open;
    //
    StatList:=nil;
    SetLength(StatList,100);
    for i:=Low(StatSumQSOList) to High(StatSumQSOList) do
    begin
      StatSumQSOList[i].Count:=0;
      StatSumQSOList[i].QSL:=0;
    end;
    tQSL:=0;
    //
    rIndex:=-1;
    lITU:=-1;
    q:=False;
    for i:=0 to qStat.RecordCount-1 do
    begin
      if Fields[0].AsInteger<>lITU then
      begin
        Inc(rIndex);
        j:=Length(StatList);
        if rIndex>=j then SetLength(StatList,j+100);
        lITU:=Fields[0].AsInteger;
        q:=False;
        //
        StatList[rIndex].Name:='ITU-'+IntToStr(lITU);
      end;
      Inc(StatSumQSOList[Fields[1].AsInteger].Count);
      Inc(StatList[rIndex].Band[Fields[1].AsInteger].Count);
      if Fields[2].AsInteger=1 then
      begin
        Inc(StatSumQSOList[Fields[1].AsInteger].QSL);
        Inc(StatList[rIndex].Band[Fields[1].AsInteger].QSL);
        if not q then
        begin
          Inc(tQSL);
          q:=True;
        end;
      end;
      Next;
      try
        ap:=Trunc(RecNo*100/(RecordCount-1));
        if lp<>ap then
        begin
          frmDialog.pgBar.Progress:=ap;
          lp:=ap;
        end;
      except
      end;
    end;
    SetLength(StatList,rIndex+1);
    tCount:=rIndex+1;
    //
    for j:=Low(StatSumList) to High(StatSumList) do
    begin
      StatSumList[j].Count:=0;
      StatSumList[j].QSL:=0;
    end;
    for i:=Low(StatList) to High(StatList) do
      for j:=Low(StatSumList) to High(StatSumList) do
        if StatList[i].Band[j].Count>0 then
        begin
          Inc(StatSumList[j].Count);
          if StatList[i].Band[j].QSL>0 then Inc(StatSumList[j].QSL);
        end;
  finally
    qStat.Close;
    frmDialog.Close;
  end;
end;

//WAZ
procedure TfrmStatTab.GetWAZ(out tQSL,tCount:Integer);
var
  i,j,lWAZ,rIndex,ap,lp:Integer;
  q:Boolean;
begin
  with qStat,Fields do
  try
    lp:=0;
    frmDialog.ZobrazProg(strGenStat,0,100);
    //
    SQL.Clear;
    SQL.Add(Format('SELECT %1:s,%2:s,%3:s FROM "%0:s" WHERE %4:s ORDER BY %1:s,%2:s,%3:s',
      [dmLog.User.Call,dfnL_WAZ,dfnL_Band,dfnL_QSLp,dFilter]));
    Open;
    //
    StatList:=nil;
    SetLength(StatList,100);
    for i:=Low(StatSumQSOList) to High(StatSumQSOList) do
    begin
      StatSumQSOList[i].Count:=0;
      StatSumQSOList[i].QSL:=0;
    end;
    tQSL:=0;
    //
    rIndex:=-1;
    lWAZ:=-1;
    q:=False;
    for i:=0 to qStat.RecordCount-1 do
    begin
      if Fields[0].AsInteger<>lWAZ then
      begin
        Inc(rIndex);
        j:=Length(StatList);
        if rIndex>=j then SetLength(StatList,j+100);
        lWAZ:=Fields[0].AsInteger;
        q:=False;
        //
        StatList[rIndex].Name:='WAZ-'+IntToStr(lWAZ);
      end;
      Inc(StatSumQSOList[Fields[1].AsInteger].Count);
      Inc(StatList[rIndex].Band[Fields[1].AsInteger].Count);
      if Fields[2].AsInteger=1 then
      begin
        Inc(StatSumQSOList[Fields[1].AsInteger].QSL);
        Inc(StatList[rIndex].Band[Fields[1].AsInteger].QSL);
        if not q then
        begin
          Inc(tQSL);
          q:=True;
        end;
      end;
      Next;
      try
        ap:=Trunc(RecNo*100/(RecordCount-1));
        if lp<>ap then
        begin
          frmDialog.pgBar.Progress:=ap;
          lp:=ap;
        end;
      except
      end;
    end;
    SetLength(StatList,rIndex+1);
    tCount:=rIndex+1;
    //
    for j:=Low(StatSumList) to High(StatSumList) do
    begin
      StatSumList[j].Count:=0;
      StatSumList[j].QSL:=0;
    end;
    for i:=Low(StatList) to High(StatList) do
      for j:=Low(StatSumList) to High(StatSumList) do
        if StatList[i].Band[j].Count>0 then
        begin
          Inc(StatSumList[j].Count);
          if StatList[i].Band[j].QSL>0 then Inc(StatSumList[j].QSL);
        end;
  finally
    qStat.Close;
    frmDialog.Close;
  end;
end;

//LOC
procedure TfrmStatTab.GetLOC(out tQSL,tCount:Integer);
var
  lLoc:String;
  i,j,rIndex,ap,lp:Integer;
  q:Boolean;
begin
  with qStat,Fields do
  try
    lp:=0;
    frmDialog.ZobrazProg(strGenStat,0,100);
    //
    SQL.Clear;
    SQL.Add(Format('SELECT SUBSTRING(%1:s FROM 1 FOR 4) TrimLoc,%2:s,%3:s FROM "%0:s" '+
      'WHERE (%1:s<>"")AND%4:s ORDER BY TrimLoc,%2:s,%3:s',
      [dmLog.User.Call,dfnL_LOCp,dfnL_Band,dfnL_QSLp,dFilter]));
    Open;
    //
    StatList:=nil;
    SetLength(StatList,100);
    for i:=Low(StatSumQSOList) to High(StatSumQSOList) do
    begin
      StatSumQSOList[i].Count:=0;
      StatSumQSOList[i].QSL:=0;
    end;
    tQSL:=0;
    //
    rIndex:=-1;
    lLoc:='';
    q:=False;
    for i:=0 to qStat.RecordCount-1 do
    begin
      if Fields[0].AsString<>lLoc then
      begin
        Inc(rIndex);
        j:=Length(StatList);
        if rIndex>=j then SetLength(StatList,j+100);
        lLoc:=Fields[0].AsString;
        q:=False;
        //
        StatList[rIndex].Name:=lLoc;
      end;
      Inc(StatSumQSOList[Fields[1].AsInteger].Count);
      Inc(StatList[rIndex].Band[Fields[1].AsInteger].Count);
      if Fields[2].AsInteger=1 then
      begin
        Inc(StatSumQSOList[Fields[1].AsInteger].QSL);
        Inc(StatList[rIndex].Band[Fields[1].AsInteger].QSL);
        if not q then
        begin
          Inc(tQSL);
          q:=True;
        end;
      end;
      Next;
      try
        ap:=Trunc(RecNo*100/(RecordCount-1));
        if lp<>ap then
        begin
          frmDialog.pgBar.Progress:=ap;
          lp:=ap;
        end;
      except
      end;
    end;
    SetLength(StatList,rIndex+1);
    tCount:=rIndex+1;
    //
    for j:=Low(StatSumList) to High(StatSumList) do
    begin
      StatSumList[j].Count:=0;
      StatSumList[j].QSL:=0;
    end;
    for i:=Low(StatList) to High(StatList) do
      for j:=Low(StatSumList) to High(StatSumList) do
        if StatList[i].Band[j].Count>0 then
        begin
          Inc(StatSumList[j].Count);
          if StatList[i].Band[j].QSL>0 then Inc(StatSumList[j].QSL);
        end;
  finally
    qStat.Close;
    frmDialog.Close;
  end;
end;

//------------------------------------------------------------------------------

procedure TfrmStatTab.ExportCSV(const FileName:String);
var
  Data:TFileStream;
  Line:String;
  i,j:Integer;
begin
  Data:=TFileStream.Create(FileName,fmCreate);
  try
    //pasma
    Line:=StatHeader+';';
    for i:=Low(hBandName) to High(hBandName) do
      Line:=Line+hBandName[i]+';;';
    Line:=Line+#13#10;
    Data.Write(Line[1],Length(Line));
    //qsl/celkem
    Line:=';';
    for i:=Low(hBandName) to High(hBandName) do
      Line:=Line+'QSL;QSO;';
    Line:=Line+#13#10;
    Data.Write(Line[1],Length(Line));
    //stat
    Line:=SumHeader+';';
    for i:=Low(hBandName) to High(hBandName) do
      Line:=Line+IntToStr(StatSumList[i].QSL)+';'+IntToStr(StatSumList[i].Count)+';';
    Line:=Line+#13#10;
    Data.Write(Line[1],Length(Line));
    //qso
    Line:=SumQSOHeader+';';
    for i:=Low(hBandName) to High(hBandName) do
      Line:=Line+IntToStr(StatSumQSOList[i].QSL)+';'+IntToStr(StatSumQSOList[i].Count)+';';
    Line:=Line+#13#10;
    Data.Write(Line[1],Length(Line));
    //
    for i:=0 to High(StatList) do
    begin
      Line:=StatList[i].Name+';';
      for j:=Low(hBandName) to High(hBandName) do
        Line:=Line+IntToStr(StatList[i].Band[j].QSL)+';'+IntToStr(StatList[i].Band[j].Count)+';';
      Line:=Line+#13#10;
      Data.Write(Line[1],Length(Line));
    end;
  finally
    Data.Free;
  end;
end;

//------------------------------------------------------------------------------
//menu Soubor
//------------------------------------------------------------------------------

procedure TfrmStatTab.actSaveAsExecute(Sender: TObject);
begin
  with dmLog,dlgSave do
  begin
    FileName:=User.Call;
    Options:=[ofOverwritePrompt,ofHideReadOnly,ofEnableSizing,ofDontAddToRecent];
    DefaultExt:=CsvFileDefExt;
    Filter:=strExportCsvFilter+' (*'+CsvFileExt+')|*'+CsvFileExt;
    if not Execute then Exit;
    ExportCSV(FileName);
  end;
end;

procedure TfrmStatTab.actExitExecute(Sender: TObject);
begin
  Close;
end;

//------------------------------------------------------------------------------
//menu Statistika
//------------------------------------------------------------------------------

procedure TfrmStatTab.actStatDXCCExecute(Sender: TObject);
var
  q,c:Integer;
begin
  TAction(Sender).Checked:=False;
  if dFilter='' then
    if not CreateFilter then Exit;
  TAction(Sender).Checked:=True;
  tlBtnDXCC.Down:=True;
  Caption:=strStatDXCCTitle;
  StatHeader:=strStatDXCCHeader;
  SumHeader:=strStatDXCCSumHeader;
  SumQSOHeader:=strStatQSOSumHeader;
  GetDXCC(q,c);
  stBar.Panels.Items[0].Text:=' '+Format(strTotalQSL,[q]);
  stBar.Panels.Items[1].Text:=' '+Format(strTotalCount,[c]);
  if c=0 then dgdStat.RowCount:=4
         else dgdStat.RowCount:=c+3;
  dgdStat.ColWidths[0]:=245;
  dgdStat.TopRow:=3;
  dgdStat.LeftCol:=1;
  dgdStat.Refresh;
end;

procedure TfrmStatTab.actStatIOTAExecute(Sender: TObject);
var
  q,c:Integer;
begin
  TAction(Sender).Checked:=False;
  if dFilter='' then
    if not CreateFilter then Exit;
  TAction(Sender).Checked:=True;
  tlBtnIOTA.Down:=True;
  Caption:=strStatIOTATitle;
  StatHeader:=strStatIOTAHeader;
  SumHeader:=strStatIOTASumHeader;
  SumQSOHeader:=strStatQSOSumHeader;
  GetIOTA(q,c);
  stBar.Panels.Items[0].Text:=' '+Format(strTotalQSL,[q]);
  stBar.Panels.Items[1].Text:=' '+Format(strTotalCount,[c]);
  if c=0 then dgdStat.RowCount:=4
         else dgdStat.RowCount:=c+3;
  dgdStat.ColWidths[0]:=245;
  dgdStat.TopRow:=3;
  dgdStat.LeftCol:=1;
  dgdStat.Refresh;
end;

procedure TfrmStatTab.actStatITUExecute(Sender: TObject);
var
  q,c:Integer;
begin
  TAction(Sender).Checked:=False;
  if dFilter='' then
    if not CreateFilter then Exit;
  TAction(Sender).Checked:=True;
  tlBtnITU.Down:=True;
  Caption:=strStatITUTitle;
  StatHeader:=strStatITUHeader;
  SumHeader:=strStatITUSumHeader;
  SumQSOHeader:=strStatQSOSumHeader;
  GetITU(q,c);
  stBar.Panels.Items[0].Text:=' '+Format(strTotalQSL,[q]);
  stBar.Panels.Items[1].Text:=' '+Format(strTotalCount,[c]);
  if c=0 then dgdStat.RowCount:=4
         else dgdStat.RowCount:=c+3;
  dgdStat.ColWidths[0]:=130;
  dgdStat.TopRow:=3;
  dgdStat.LeftCol:=1;
  dgdStat.Refresh;
end;

procedure TfrmStatTab.actStatWAZExecute(Sender: TObject);
var
  q,c:Integer;
begin
  TAction(Sender).Checked:=False;
  if dFilter='' then
    if not CreateFilter then Exit;
  TAction(Sender).Checked:=True;
  tlBtnWAZ.Down:=True;
  Caption:=strStatWAZTitle;
  StatHeader:=strStatWAZHeader;
  SumHeader:=strStatWAZSumHeader;
  SumQSOHeader:=strStatQSOSumHeader;
  GetWAZ(q,c);
  stBar.Panels.Items[0].Text:=' '+Format(strTotalQSL,[q]);
  stBar.Panels.Items[1].Text:=' '+Format(strTotalCount,[c]);
  if c=0 then dgdStat.RowCount:=4
         else dgdStat.RowCount:=c+3;
  dgdStat.ColWidths[0]:=130;
  dgdStat.TopRow:=3;
  dgdStat.LeftCol:=1;
  dgdStat.Refresh;
end;

procedure TfrmStatTab.actStatLOCExecute(Sender: TObject);
var
  q,c:Integer;
begin
  TAction(Sender).Checked:=False;
  if dFilter='' then
    if not CreateFilter then Exit;
  TAction(Sender).Checked:=True;
  tlBtnLOC.Down:=True;
  Caption:=strStatLOCTitle;
  StatHeader:=strStatLOCHeader;
  SumHeader:=strStatLOCSumHeader;
  SumQSOHeader:=strStatQSOSumHeader;
  GetLOC(q,c);
  stBar.Panels.Items[0].Text:=' '+Format(strTotalQSL,[q]);
  stBar.Panels.Items[1].Text:=' '+Format(strTotalCount,[c]);
  if c=0 then dgdStat.RowCount:=4
         else dgdStat.RowCount:=c+3;
  dgdStat.ColWidths[0]:=130;
  dgdStat.TopRow:=3;
  SendMessage(dgdStat.Handle,WM_HSCROLL,SB_RIGHT,0);
  if dgdStat.LeftCol>12 then dgdStat.LeftCol:=12;
  dgdStat.Refresh;
end;

//------------------------------------------------------------------------------
//menu Nastroje
//------------------------------------------------------------------------------

procedure TfrmStatTab.actFilterExecute(Sender: TObject);
begin
  if not CreateFilter then Exit;
  if actStatDXCC.Checked then actStatDXCC.Execute;
  if actStatIOTA.Checked then actStatIOTA.Execute;
  if actStatITU.Checked then actStatITU.Execute;
  if actStatWAZ.Checked then actStatWAZ.Execute;
  if actStatLOC.Checked then actStatLOC.Execute;
end;

end.
