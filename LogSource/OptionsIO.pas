unit OptionsIO;

interface

uses
  IniFiles, Kontrola, SysUtils, Math, Amater, Classes, HQLResStrings, mxarrays,
  HamLogFP, HQLConsts, cfmGeography;

type
  //
  TOptions = class(TObject)
  protected
    Ini:TMemIniFile;
  public
    constructor Create;
    destructor Destroy; override;
    //
    procedure LoadFromFile(const FileName:String); virtual;
    procedure SaveToFile(const FileName:String); virtual;
    procedure UpdateFile; virtual;
    procedure Close; virtual;
  end;
  //obecna nastaveni
  TLogOptions = class(TOptions)
  private
    function GetUser(const i:Integer):String;
    procedure SetUser(const i:Integer; const Value:String);
  public
    //
    property User[const i:Integer]:String read GetUser write SetUser;
  end;
  //uzivatelska nastaveni
  TUserOptions = class(TOptions)
  private
    fCall:String;
    //uzivatel
    procedure SetCall(const Value:String);
    function GetLoc:String;
    procedure SetLoc(const Value:String);
    //datum a cas
    function GetTime_Sync:Boolean;
    procedure SetTime_Sync(const Value:Boolean);
    function GetTime_NTP:String;
    procedure SetTime_NTP(const Value:String);
    //nove spojeni
    function GetNQSO_RSTo:String;
    procedure SetNQSO_RSTo(const Value:String);
    function GetNQSO_RSTp:String;
    procedure SetNQSO_RSTp(const Value:String);
    function GetNQSO_PWR:Double;
    procedure SetNQSO_PWR(const Value:Double);
    function GetNQSO_QSLo:Integer;
    procedure SetNQSO_QSLo(const Value:Integer);
    function GetNQSO_QSLp:Integer;
    procedure SetNQSO_QSLp(const Value:Integer);
    function GetNQSO_Refresh:Boolean;
    procedure SetNQSO_Refresh(const Value:Boolean);
    function GetNQSO_LookInLog:Boolean;
    procedure SetNQSO_LookInLog(const Value:Boolean);
    function GetNQSO_LookInCB:Boolean;
    procedure SetNQSO_LookInCB(const Value:Boolean);
    function GetNQSO_NameUpC:Boolean;
    procedure SetNQSO_NameUpC(const Value:Boolean);
    function GetNQSO_QuickQSO:Integer;
    procedure SetNQSO_QuickQSO(const Value:Integer);
    function GetNQSO_DefFreq:Integer;
    procedure SetNQSO_DefFreq(const Value:Integer);
    function GetNQSO_DefMode:Integer;
    procedure SetNQSO_DefMode(const Value:Integer);
    //Seznam
    function GetLiDxcc_Width:Integer;
    procedure SetLiDxcc_Width(const Value:Integer);
    function GetLiDxcc_Height:Integer;
    procedure SetLiDxcc_Height(const Value:Integer);
    function GetLiDxcc_Maximized:Boolean;
    procedure SetLiDxcc_Maximized(const Value:Boolean);
    function GetLiIOTA_Width:Integer;
    procedure SetLiIOTA_Width(const Value:Integer);
    function GetLiIOTA_Height:Integer;
    procedure SetLiIOTA_Height(const Value:Integer);
    function GetLiIOTA_Maximized:Boolean;
    procedure SetLiIOTA_Maximized(const Value:Boolean);
    //mapa
    function GetMap_Width:Integer;
    procedure SetMap_Width(const Value:Integer);
    function GetMap_Height:Integer;
    procedure SetMap_Height(const Value:Integer);
    function GetMap_Maximized:Boolean;
    procedure SetMap_Maximized(const Value:Boolean);
    function GetMap_CenterX:Double;
    procedure SetMap_CenterX(const Value:Double);
    function GetMap_CenterY:Double;
    procedure SetMap_CenterY(const Value:Double);
    function GetMap_Zoom:Double;
    procedure SetMap_Zoom(const Value:Double);
    function GetMap_WWLGrid:Boolean;
    procedure SetMap_WWLGrid(const Value:Boolean);
    function GetMap_GeoGrid:Boolean;
    procedure SetMap_GeoGrid(const Value:Boolean);
    //vzhled
    function GetDes_DateFormat:Integer;
    procedure SetDes_DateFormat(const Value:Integer);
    function GetDes_TimeFormat:Integer;
    procedure SetDes_TimeFormat(const Value:Integer);
    function GetDes_FreqFormat:Integer;
    procedure SetDes_FreqFormat(const Value:Integer);
    function GetDes_ExtFont:Boolean;
    procedure SetDes_ExtFont(const Value:Boolean);
    //DX Cluster
    function GetDXC_Width:Integer;
    procedure SetDXC_Width(const Value:Integer);
    function GetDXC_Height:Integer;
    procedure SetDXC_Height(const Value:Integer);
    function GetDXC_Maximized:Boolean;
    procedure SetDXC_Maximized(const Value:Boolean);
    function GetDXC_Host:String;
    procedure SetDXC_Host(const Value:String);
    function GetDXC_Port:Integer;
    procedure SetDXC_Port(const Value:Integer);
    function GetDXC_Password:String;
    procedure SetDXC_Password(const Value:String);
    //zaloha
    function GetBackUp_Enabled:Boolean;
    procedure SetBackUp_Enabled(const Value:Boolean);
    function GetBackUp_Int:Integer;
    procedure SetBackUp_Int(const Value:Integer);
    function GetBackUp_Date:TDateTime;
    procedure SetBackUp_Date(const Value:TDateTime);
    function GetBackUp_Path:String;
    procedure SetBackUp_Path(const Value:String);
  public
    procedure LoadFromFile(const FileName:String); override;
    procedure Close; override;
    //
    procedure nQSO_GetFreqs(List:TStrings); overload;
    procedure nQSO_GetFreqs(List:TBaseArray); overload;
    procedure nQSO_SetFreqs(List:TBaseArray);
    procedure nQSO_GetModes(List:TStrings); overload;
    procedure nQSO_GetModes(List:TBaseArray); overload;
    procedure nQSO_SetModes(List:TBaseArray);
    //sloupce
    function GetColumnCaption(const Column:String):String;
    procedure SetColumnCaption(const Column,Caption:String);
    function GetColumnTAlignment(const Column:String):TAlignment;
    procedure SetColumnTAlignment(const Column:String; const Align:TAlignment);
    function GetColumnAlignment(const Column:String):TAlignment;
    procedure SetColumnAlignment(const Column:String; const Align:TAlignment);
    function GetColumnWidth(const Column:String):Integer;
    procedure SetColumnWidth(const Column:String; const Width:Integer);
    function GetColumnIndex(const Column:String; const Default:Integer):Integer;
    procedure SetColumnIndex(const Column:String; const Index:Integer);
    function GetColumnVisible(const Column:String):Boolean;
    procedure SetColumnVisible(const Column:String; const Visible:Boolean);
    //uzivatel
    property Call:String read fCall write SetCall;
    property Loc:String read GetLoc write SetLoc;
    //datum a cas
    property Time_Sync:Boolean read GetTime_Sync write SetTime_Sync;
    property Time_NTPServer:String read GetTime_NTP write SetTime_NTP;
    //nove spojeni
    property nQSO_RSTo:String read GetNQSO_RSTo write SetNQSO_RSTo;
    property nQSO_RSTp:String read GetNQSO_RSTp write SetNQSO_RSTp;
    property nQSO_PWR:Double read GetNQSO_PWR write SetNQSO_PWR;
    property nQSO_QSLo:Integer read GetNQSO_QSLo write SetNQSO_QSLo;
    property nQSO_QSLp:Integer read GetNQSO_QSLp write SetNQSO_QSLp;
    property nQSO_RefreshLog:Boolean read GetNQSO_Refresh write SetNQSO_Refresh;
    property nQSO_LookInLog:Boolean read GetNQSO_LookInLog write SetNQSO_LookInLog;
    property nQSO_LookInCB:Boolean read GetNQSO_LookInCB write SetNQSO_LookInCB;
    property nQSO_NameUpCase:Boolean read GetNQSO_NameUpC write SetNQSO_NameUpC;
    property nQSO_QuickQSOs:Integer read GetNQSO_QuickQSO write SetNQSO_QuickQSO;
    property nQSO_DefFreq:Integer read GetNQSO_DefFreq write SetNQSO_DefFreq;
    property nQSO_DefMode:Integer read GetNQSO_DefMode write SetNQSO_DefMode;
    //list
    property LiDxcc_Width:Integer read GetLiDxcc_Width write SetLiDxcc_Width;
    property LiDxcc_Height:Integer read GetLiDxcc_Height write SetLiDxcc_Height;
    property LiDxcc_Maximized:Boolean read GetLiDxcc_Maximized write SetLiDxcc_Maximized;
    property LiIOTA_Width:Integer read GetLiIOTA_Width write SetLiIOTA_Width;
    property LiIOTA_Height:Integer read GetLiIOTA_Height write SetLiIOTA_Height;
    property LiIOTA_Maximized:Boolean read GetLiIOTA_Maximized write SetLiIOTA_Maximized;
    //mapa
    property Map_Width:Integer read GetMap_Width write SetMap_Width;
    property Map_Height:Integer read GetMap_Height write SetMap_Height;
    property Map_Maximized:Boolean read GetMap_Maximized write SetMap_Maximized;
    property Map_CenterX:Double read GetMap_CenterX write SetMap_CenterX;
    property Map_CenterY:Double read GetMap_CenterY write SetMap_CenterY;
    property Map_Zoom:Double read GetMap_Zoom write SetMap_Zoom;
    property Map_WWLGrid:Boolean read GetMap_WWLGrid write SetMap_WWLGrid;
    property Map_GeoGrid:Boolean read GetMap_GeoGrid write SetMap_GeoGrid;
    //vzhled
    property Design_DateFormat:Integer read GetDes_DateFormat write SetDes_DateFormat;
    property Design_TimeFormat:Integer read GetDes_TimeFormat write SetDes_TimeFormat;
    property Design_FreqFormat:Integer read GetDes_FreqFormat write SetDes_FreqFormat;
    property Design_ExtendedFont:Boolean read GetDes_ExtFont write SetDes_ExtFont;
    //DX cluster
    property DXC_Width:Integer read GetDXC_Width write SetDXC_Width;
    property DXC_Height:Integer read GetDXC_Height write SetDXC_Height;
    property DXC_Maximized:Boolean read GetDXC_Maximized write SetDXC_Maximized;
    property DXC_Host:String read GetDXC_Host write SetDXC_Host;
    property DXC_Port:Integer read GetDXC_Port write SetDXC_Port;
    property DXC_Password:String read GetDXC_Password write SetDXC_Password;
    //zaloha
    property BackUp_Enabled:Boolean read GetBackUp_Enabled write SetBackUp_Enabled;
    property BackUp_Interval:Integer read GetBackUp_Int write SetBackUp_Int;
    property BackUp_Date:TDateTime read GetBackUp_Date write SetBackUp_Date;
    property BackUp_Path:String read GetBackUp_Path write SetBackUp_Path;
  end;

resourcestring
  errIndexOutOfRange='Index mimo rozsah!';

implementation

//------------------------------------------------------------------------------
//TOptions
//------------------------------------------------------------------------------

constructor TOptions.Create;
begin
  inherited Create;
  Ini:=TMemIniFile.Create('');
end;

destructor TOptions.Destroy;
begin
  Ini.Free;
  inherited Destroy;
end;

//------------------------------------------------------------------------------

procedure TOptions.LoadFromFile(const FileName:String);
begin
  Ini.Rename(FileName,True);
end;

procedure TOptions.SaveToFile(const FileName:String);
begin
  Ini.Rename(FileName,False);
  Ini.UpdateFile;
end;

procedure TOptions.UpdateFile;
begin
  Ini.UpdateFile;
end;

procedure TOptions.Close;
begin
  Ini.Clear;
end;

//------------------------------------------------------------------------------
//TLogOptions
//------------------------------------------------------------------------------

const
  sUsers='Users';

//uzivatel
function TLogOptions.GetUser(const i:Integer):String;
begin
  if (i<0)or(i>9) then raise Exception.Create(errIndexOutOfRange);
  Result:=Ini.ReadString(sUsers,IntToStr(i),'');
end;
procedure TLogOptions.SetUser(const i:Integer; const Value:String);
begin
  if (i<0)or(i>9) then raise Exception.Create(errIndexOutOfRange);
  Ini.WriteString(sUsers,IntToStr(i),Value);
end;

//------------------------------------------------------------------------------
//TUserOptions
//------------------------------------------------------------------------------

const
  sUser='User';
  sDateTime='DateTime';
  sNQSO='nQSO';
  sLiDxcc='ListDxcc';
  sLiIOTA='ListIOTA';
  sMap='Map';
  sDesign='Design';
  sColumns='Columns';
  sDXC='DXC';
  sBackUp='BackUp';

//------------------------------------------------------------------------------

procedure TUserOptions.LoadFromFile(const FileName:String);
begin
  inherited;
  fCall:=UpperCase(Ini.ReadString(sUser,'Call',''));
end;

procedure TUserOptions.Close;
begin
  inherited;
  fCall:='';
end;

//------------------------------------------------------------------------------
//uzivatel

//znacka
procedure TUserOptions.SetCall(const Value:String);
begin
  fCall:=UpperCase(Value);
  Ini.WriteString(sUser,'Call',fCall);
end;

//lokator
function TUserOptions.GetLoc:String;
var
  str:String;
begin
  str:=Ini.ReadString(sUser,'Loc','');
  if IsWWL(str, True) then Result:=str
                      else Result:='';
end;
procedure TUserOptions.SetLoc(const Value:String);
begin
  Ini.WriteString(sUser,'Loc',UpperCase(Value));
end;

//------------------------------------------------------------------------------
//datum a cas

//synchronizace casu
function TUserOptions.GetTime_Sync:Boolean;
begin
  Result:=Ini.ReadBool(sDateTime,'NTPSync',False);
end;
procedure TUserOptions.SetTime_Sync(const Value:Boolean);
begin
  Ini.WriteBool(sDateTime,'NTPSync',Value);
end;

//NTP server
function TUserOptions.GetTime_NTP:String;
begin
  Result:=Ini.ReadString(sDateTime,'NTPServer','');
end;
procedure TUserOptions.SetTime_NTP(const Value:String);
begin
  Ini.WriteString(sDateTime,'NTPServer',Value);
end;

//------------------------------------------------------------------------------
//nove spojeni

//RSTo
function TUserOptions.GetNQSO_RSTo:String;
begin
  Result:=Copy(Ini.ReadString(sNQSO,'RSTo','599'),1,3);
end;
procedure TUserOptions.SetNQSO_RSTo(const Value:String);
begin
  Ini.WriteString(sNQSO,'RSTo',Value);
end;

//RSTp
function TUserOptions.GetNQSO_RSTp:String;
begin
  Result:=Copy(Ini.ReadString(sNQSO,'RSTp','599'),1,3);
end;
procedure TUserOptions.SetNQSO_RSTp(const Value:String);
begin
  Ini.WriteString(sNQSO,'RSTp',Value);
end;

//PWR
function TUserOptions.GetNQSO_PWR:Double;
var
  n:Double;
begin
  n:=RoundTo(Ini.ReadFloat(sNQSO,'PWR',100),-3);
  if (n>=0)and(n<1000000) then Result:=n
                          else Result:=100;
end;
procedure TUserOptions.SetNQSO_PWR(const Value:Double);
begin
  Ini.WriteFloat(sNQSO,'PWR',Value);
end;

//QSLo
function TUserOptions.GetNQSO_QSLo:Integer;
var
  i:Integer;
begin
  i:=Ini.ReadInteger(sNQSO,'QSLo',Low(hQSLo));
  if (i>=Low(hQSLo))and(i<=High(hQSLo)) then Result:=i
                                        else Result:=Low(hQSLo);
end;
procedure TUserOptions.SetNQSO_QSLo(const Value:Integer);
begin
  Ini.WriteInteger(sNQSO,'QSLo',Value);
end;

//QSLp
function TUserOptions.GetNQSO_QSLp:Integer;
var
  i:Integer;
begin
  i:=Ini.ReadInteger(sNQSO,'QSLp',Low(hQSLp));
  if (i>=Low(hQSLp))and(i<=High(hQSLp)) then Result:=i
                                        else Result:=Low(hQSLp);
end;
procedure TUserOptions.SetNQSO_QSLp(const Value:Integer);
begin
  Ini.WriteInteger(sNQSO,'QSLp',Value);
end;

//obnoveni LOGu
function TUserOptions.GetNQSO_Refresh:Boolean;
begin
  Result:=Ini.ReadBool(sNQSO,'RefreshLog',True);
end;
procedure TUserOptions.SetNQSO_Refresh(const Value:Boolean);
begin
  Ini.WriteBool(sNQSO,'RefreshLog',Value);
end;

//hledani udaju v LOGu
function TUserOptions.GetNQSO_LookInLog:Boolean;
begin
  Result:=Ini.ReadBool(sNQSO,'LookInLog',True);
end;
procedure TUserOptions.SetNQSO_LookInLog(const Value:Boolean);
begin
  Ini.WriteBool(sNQSO,'LookInLog',Value);
end;

//hledani udaju v CallBooku
function TUserOptions.GetNQSO_LookInCB:Boolean;
begin
  Result:=Ini.ReadBool(sNQSO,'LookInCB',True);
end;
procedure TUserOptions.SetNQSO_LookInCB(const Value:Boolean);
begin
  Ini.WriteBool(sNQSO,'LookInCB',Value);
end;

//zvetseni pocatecnich pismen u jmena a QTH
function TUserOptions.GetNQSO_NameUpC:Boolean;
begin
  Result:=Ini.ReadBool(sNQSO,'NameUpCase',True);
end;
procedure TUserOptions.SetNQSO_NameUpC(const Value:Boolean);
begin
  Ini.WriteBool(sNQSO,'NameUpCase',Value);
end;

//nastaveni rychleho zadavani
function TUserOptions.GetNQSO_QuickQSO:Integer;
begin
  Result:=Ini.ReadInteger(sNQSO,'QuickQSOs',0);
end;
procedure TUserOptions.SetNQSO_QuickQSO(const Value:Integer);
begin
  Ini.WriteInteger(sNQSO,'QuickQSOs',Value);
end;

//preddefinovane frekvence
procedure TUserOptions.nQSO_GetFreqs(List:TStrings);
var
  i:Integer;
  Freqs,str:String;
  f:Double;
begin
  Freqs:=Ini.ReadString(sNQSO,'Freqs','');
  List.Clear;
  for i:=1 to Length(Freqs) do
  case Freqs[i] of
    '0'..'9',',': str:=str+Freqs[i];
    ';': begin
      try
        f:=StrToFloat(str);
        List.Add(FormatFloat(FreqFormat,f));
      except
      end;
      str:='';
    end;
  end;
end;
procedure TUserOptions.nQSO_GetFreqs(List:TBaseArray);
var
  i:Integer;
  Freqs,str:String;
  f:Double;
begin
  Freqs:=Ini.ReadString(sNQSO,'Freqs','');
  for i:=1 to Length(Freqs) do
  case Freqs[i] of
    '0'..'9',',': str:=str+Freqs[i];
    ';': begin
      try
        f:=StrToFloat(str);
        List.Insert(List.Count,f);
      except
      end;
      str:='';
    end;
  end;
end;
procedure TUserOptions.nQSO_SetFreqs(List:TBaseArray);
var
  i:Integer;
  str:String;
  f:Double;
begin
  for i:=0 to List.Count-1 do
  begin
    List.GetItem(i,f);
    str:=str+FormatFloat(FreqFormat,f)+';';
  end;
  Ini.WriteString(sNQSO,'Freqs',str);
end;

//vychozi frekvence (index)
function TUserOptions.GetNQSO_DefFreq:Integer;
begin
  Result:=Ini.ReadInteger(sNQSO,'Freq',0);
end;
procedure TUserOptions.SetNQSO_DefFreq(const Value:Integer);
begin
  Ini.WriteInteger(sNQSO,'Freq',Value);
end;

//preddefinovane mody
procedure TUserOptions.nQSO_GetModes(List: TStrings);
var
  i: Integer;
  m: THamMode;
  Modes, str: String;
begin
  Modes:=Ini.ReadString(sNQSO, 'Modes', DefaultModesStr);
  List.Clear;
  for i:=1 to Length(Modes) do
  case Modes[i] of
    '0'..'9': str:=str + Modes[i];
    ';': begin
      try
        m:=StrToInt(str);
        List.Add(hModeName[m]);
      except
      end;
      str:='';
    end;
  end;
end;
procedure TUserOptions.nQSO_GetModes(List: TBaseArray);
var
  i: Integer;
  m: THamMode;
  Modes, str: String;
begin
  Modes:=Ini.ReadString(sNQSO, 'Modes', DefaultModesStr);
  List.Clear;
  for i:=1 to Length(Modes) do
  case Modes[i] of
    '0'..'9': str:=str + Modes[i];
    ';': begin
      try
        m:=StrToInt(str);
        List.InsertAt(List.Count, m);
      except
      end;
      str:='';
    end;
  end;
end;
procedure TUserOptions.nQSO_SetModes(List: TBaseArray);
var
  i: Integer;
  m: THamMode;
  str: String;
begin
  for i:=0 to List.Count - 1 do
  begin
    List.GetItem(i, m);
    str:=str + IntToStr(m) + ';';
  end;
  Ini.WriteString(sNQSO, 'Modes', str);
end;

//vychozi mod (index)
function TUserOptions.GetNQSO_DefMode:Integer;
begin
  Result:=Ini.ReadInteger(sNQSO, 'Mode', 0);
end;
procedure TUserOptions.SetNQSO_DefMode(const Value: Integer);
begin
  Ini.WriteInteger(sNQSO, 'Mode', Value);
end;

//------------------------------------------------------------------------------
//seznam

function TUserOptions.GetLiDxcc_Width:Integer;
begin
  Result:=Ini.ReadInteger(sLiDxcc,'Width',700);
end;
procedure TUserOptions.SetLiDxcc_Width(const Value:Integer);
begin
  Ini.WriteInteger(sLiDxcc,'Width',Value);
end;

function TUserOptions.GetLiDxcc_Height:Integer;
begin
  Result:=Ini.ReadInteger(sLiDxcc,'Height',500);
end;
procedure TUserOptions.SetLiDxcc_Height(const Value:Integer);
begin
  Ini.WriteInteger(sLiDxcc,'Height',Value);
end;

function TUserOptions.GetLiDxcc_Maximized:Boolean;
begin
  Result:=Ini.ReadBool(sLiDxcc,'Maximized',True);
end;
procedure TUserOptions.SetLiDxcc_Maximized(const Value:Boolean);
begin
  Ini.WriteBool(sLiDxcc,'Maximized',Value);
end;

function TUserOptions.GetLiIOTA_Width:Integer;
begin
  Result:=Ini.ReadInteger(sLiIOTA,'Width',700);
end;
procedure TUserOptions.SetLiIOTA_Width(const Value:Integer);
begin
  Ini.WriteInteger(sLiIOTA,'Width',Value);
end;

function TUserOptions.GetLiIOTA_Height:Integer;
begin
  Result:=Ini.ReadInteger(sLiIOTA,'Height',500);
end;
procedure TUserOptions.SetLiIOTA_Height(const Value:Integer);
begin
  Ini.WriteInteger(sLiIOTA,'Height',Value);
end;

function TUserOptions.GetLiIOTA_Maximized:Boolean;
begin
  Result:=Ini.ReadBool(sLiIOTA,'Maximized',True);
end;
procedure TUserOptions.SetLiIOTA_Maximized(const Value:Boolean);
begin
  Ini.WriteBool(sLiIOTA,'Maximized',Value);
end;

//------------------------------------------------------------------------------
//mapa

//sirka
function TUserOptions.GetMap_Width:Integer;
begin
  Result:=Ini.ReadInteger(sMap,'Width',640);
end;
procedure TUserOptions.SetMap_Width(const Value:Integer);
begin
  Ini.WriteInteger(sMap,'Width',Value);
end;

//vyska
function TUserOptions.GetMap_Height:Integer;
begin
  Result:=Ini.ReadInteger(sMap,'Height',480);
end;
procedure TUserOptions.SetMap_Height(const Value:Integer);
begin
  Ini.WriteInteger(sMap,'Height',Value);
end;

//maximized
function TUserOptions.GetMap_Maximized:Boolean;
begin
  Result:=Ini.ReadBool(sMap,'Maximized',True);
end;
procedure TUserOptions.SetMap_Maximized(const Value:Boolean);
begin
  Ini.WriteBool(sMap,'Maximized',Value);
end;

//stred x
function TUserOptions.GetMap_CenterX:Double;
begin
  Result:=Ini.ReadFloat(sMap,'CenterX',15);
end;
procedure TUserOptions.SetMap_CenterX(const Value:Double);
begin
  Ini.WriteString(sMap,'CenterX',FormatFloat('0.000',Value));
end;

//stred y
function TUserOptions.GetMap_CenterY:Double;
begin
  Result:=Ini.ReadFloat(sMap,'CenterY',49.8);
end;
procedure TUserOptions.SetMap_CenterY(const Value:Double);
begin
  Ini.WriteString(sMap,'CenterY',FormatFloat('0.000',Value));
end;

//zoom
function TUserOptions.GetMap_Zoom:Double;
begin
  Result:=Ini.ReadFloat(sMap,'Zoom',0.25);
end;
procedure TUserOptions.SetMap_Zoom(const Value:Double);
begin
  Ini.WriteString(sMap,'Zoom',FormatFloat('0.000',Value));
end;

//WWL grid
function TUserOptions.GetMap_WWLGrid:Boolean;
begin
  Result:=Ini.ReadBool(sMap,'WWLGrid',False);
end;
procedure TUserOptions.SetMap_WWLGrid(const Value:Boolean);
begin
  Ini.WriteBool(sMap,'WWLGrid',Value);
end;

//geo grid
function TUserOptions.GetMap_GeoGrid:Boolean;
begin
  Result:=Ini.ReadBool(sMap,'GeoGrid',True);
end;
procedure TUserOptions.SetMap_GeoGrid(const Value:Boolean);
begin
  Ini.WriteBool(sMap,'GeoGrid',Value);
end;

//------------------------------------------------------------------------------
//vzhled

//format data
function TUserOptions.GetDes_DateFormat:Integer;
begin
  Result:=Ini.ReadInteger(sDesign,'DateFormat',0);
  if Result>High(DateFormats) then Result:=0;
end;
procedure TUserOptions.SetDes_DateFormat(const Value:Integer);
begin
  Ini.WriteInteger(sDesign,'DateFormat',Value);
end;

//fomat casu
function TUserOptions.GetDes_TimeFormat:Integer;
begin
  Result:=Ini.ReadInteger(sDesign,'TimeFormat',0);
  if Result>High(TimeFormats) then Result:=0;
end;
procedure TUserOptions.SetDes_TimeFormat(const Value:Integer);
begin
  Ini.WriteInteger(sDesign,'TimeFormat',Value);
end;

//fomat frekvence
function TUserOptions.GetDes_FreqFormat:Integer;
begin
  Result:=Ini.ReadInteger(sDesign,'FreqFormat',0);
  if Result>High(FreqFormats) then Result:=0;
end;
procedure TUserOptions.SetDes_FreqFormat(const Value:Integer);
begin
  Ini.WriteInteger(sDesign,'FreqFormat',Value);
end;

//hladky font
function TUserOptions.GetDes_ExtFont:Boolean;
begin
  Result:=Ini.ReadBool(sDesign,'ExtendedFont',True);
end;
procedure TUserOptions.SetDes_ExtFont(const Value:Boolean);
begin
  Ini.WriteBool(sDesign,'ExtendedFont',Value);
end;

//------------------------------------------------------------------------------
//nastaveni sloupcu

//nadpis
function TUserOptions.GetColumnCaption(const Column:String):String;
begin
  Result:=Ini.ReadString(sColumns,Column+'_Caption',Column)
end;
procedure TUserOptions.SetColumnCaption(const Column,Caption:String);
begin
  Ini.WriteString(sColumns,Column+'_Caption',Caption);
end;

//zarovnani nadpisu
function TUserOptions.GetColumnTAlignment(const Column:String):TAlignment;
var
  i:Integer;
begin
  i:=Ini.ReadInteger(sColumns,Column+'_CaptionAlignment',0);
  if (i<Ord(Low(TAlignment)))and(i>Ord(High(TAlignment))) then i:=0;
  Result:=TAlignment(i);
end;
procedure TUserOptions.SetColumnTAlignment(const Column:String; const Align:TAlignment);
begin
  Ini.WriteInteger(sColumns,Column+'_CaptionAlignment',Ord(Align));
end;

//zarovnani sloupcu
function TUserOptions.GetColumnAlignment(const Column:String):TAlignment;
var
  i:Integer;
begin
  i:=Ini.ReadInteger(sColumns,Column+'_Alignment',0);
  if (i<Ord(Low(TAlignment)))and(i>Ord(High(TAlignment))) then i:=0;
  Result:=TAlignment(i);
end;
procedure TUserOptions.SetColumnAlignment(const Column:String; const Align:TAlignment);
begin
  Ini.WriteInteger(sColumns,Column+'_Alignment',Ord(Align));
end;

//sirka
function TUserOptions.GetColumnWidth(const Column:String):Integer;
begin
  Result:=Ini.ReadInteger(sColumns,Column+'_Width',30);
end;
procedure TUserOptions.SetColumnWidth(const Column:String; const Width:Integer);
begin
  Ini.WriteInteger(sColumns,Column+'_Width',Width);
end;

//index
function TUserOptions.GetColumnIndex(const Column:String; const Default:Integer):Integer;
begin
  Result:=Ini.ReadInteger(sColumns,Column+'_Index',Default);
end;
procedure TUserOptions.SetColumnIndex(const Column:String; const Index:Integer);
begin
  Ini.WriteInteger(sColumns,Column+'_Index',Index);
end;

//index
function TUserOptions.GetColumnVisible(const Column:String):Boolean;
begin
  Result:=Ini.ReadBool(sColumns,Column+'_Visible',True);
end;
procedure TUserOptions.SetColumnVisible(const Column:String; const Visible:Boolean);
begin
  Ini.WriteBool(sColumns,Column+'_Visible',Visible);
end;

//------------------------------------------------------------------------------
//DX Cluster

//sirka
function TUserOptions.GetDXC_Width:Integer;
begin
  Result:=Ini.ReadInteger(sDXC,'Width',640);
end;
procedure TUserOptions.SetDXC_Width(const Value:Integer);
begin
  Ini.WriteInteger(sDXC,'Width',Value);
end;

//vyska
function TUserOptions.GetDXC_Height:Integer;
begin
  Result:=Ini.ReadInteger(sDXC,'Height',480);
end;
procedure TUserOptions.SetDXC_Height(const Value:Integer);
begin
  Ini.WriteInteger(sDXC,'Height',Value);
end;

//maximized
function TUserOptions.GetDXC_Maximized:Boolean;
begin
  Result:=Ini.ReadBool(sDXC,'Maximized',True);
end;
procedure TUserOptions.SetDXC_Maximized(const Value:Boolean);
begin
  Ini.WriteBool(sDXC,'Maximized',Value);
end;

//host
function TUserOptions.GetDXC_Host:String;
begin
  Result:=Ini.ReadString(sDXC,'Host','ok0dxi.nagano.cz');
end;
procedure TUserOptions.SetDXC_Host(const Value:String);
begin
  Ini.WriteString(sDXC,'Host',Value);
end;

//port
function TUserOptions.GetDXC_Port:Integer;
begin
  Result:=Ini.ReadInteger(sDXC,'Port',41112);
  if (Result<1)or(Result>65535) then Result:=41112;
end;
procedure TUserOptions.SetDXC_Port(const Value:Integer);
begin
  Ini.WriteInteger(sDXC,'Port',Value);
end;

//s1
function TUserOptions.GetDXC_Password:String;
var
  s1,s2:String;
begin
  s1:=Ini.ReadString(sDXC,'S1','');
  s2:=Ini.ReadString(sDXC,'S2','');
  if (s1='')or(s2='') then Result:=''
                      else Result:=PwdDecode(s1,s2);
end;
procedure TUserOptions.SetDXC_Password(const Value:String);
var
  s1,s2:String;
begin
  PwdCode(Value,s1,s2);
  Ini.WriteString(sDXC,'S1',s1);
  Ini.WriteString(sDXC,'S2',s2);
end;

//------------------------------------------------------------------------------
//zaloha

//enabled
function TUserOptions.GetBackUp_Enabled:Boolean;
begin
  Result:=Ini.ReadBool(sBackUp,'Enabled',False);
end;
procedure TUserOptions.SetBackUp_Enabled(const Value:Boolean);
begin
  Ini.WriteBool(sBackUp,'Enabled',Value);
end;

//interval
function TUserOptions.GetBackUp_Int:Integer;
begin
  Result:=Ini.ReadInteger(sBackUp,'Interval',0);
end;
procedure TUserOptions.SetBackUp_int(const Value:Integer);
begin
  Ini.WriteInteger(sBackUp,'Interval',Value);
end;

//cas
function TUserOptions.GetBackUp_Date:TDateTime;
begin
  Result:=Ini.ReadDate(sBackUp,'Last',Date);
end;
procedure TUserOptions.SetBackUp_Date(const Value:TDateTime);
begin
  Ini.WriteDate(sBackUp,'Last',Value);
end;

//cesta
function TUserOptions.GetBackUp_Path:String;
begin
  Result:=Ini.ReadString(sBackUp,'Path','');
end;
procedure TUserOptions.SetBackUp_Path(const Value:String);
begin
  Ini.WriteString(sBackUp,'Path',Value);
end;

end.




