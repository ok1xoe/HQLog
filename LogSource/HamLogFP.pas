unit HamLogFP;
interface
uses
  Dialogs, StdCtrls, Windows, SysUtils, Controls, ShlObj, StrUtils, HQLResStrings, Classes;

  function FormatDeg(const Deg:Double; const Sirka:Boolean):String;
  procedure PwdCode(const nPwd:String; var sKod,sPwd:String);
  function PwdDecode(const sKod,sPwd:String):String;
  function GetFolderDialog(Handle: Integer; const Caption:string; var strFolder: string): Boolean;
  //
  procedure SetCbBoxItems(Box:TCustomComboBox; const Data:Array of PChar); overload;
  procedure SetCbBoxItemsF(Box:TCustomComboBox; const Data:Array of Double); overload;
  procedure SetCbBoxItems(Box:TCustomComboBox; const Data:Array of PChar;
    const Min,Max:Integer); overload;
  procedure SetCbBoxItemsF(Box:TCustomComboBox; const Data:Array of Double;
    const Min,Max:Integer); overload;
  procedure SetItems(Items:TStrings; const Data:Array of PChar); overload;
  procedure SetItems(Items:TStrings; const Data:Array of PChar;
    const Min,Max:Integer); overload;

implementation


//formauje stupne
function FormatDeg(const Deg:Double; const Sirka:Boolean):String;
var
  Str:String;
  aDeg:Double;
begin
  aDeg:=Abs(Deg);
  Str:=Format('%2.0f° %2.0f'+#39+' %2.0f'+#39+#39,
    [Int(aDeg),Int(Frac(aDeg)/(1/60)),Int((Frac(Frac(aDeg)/(1/60)))/(1/60))]);
  if Sirka then if Deg<0 then Str:=Str+' J'
                         else Str:=Str+' S';
  if not Sirka then if Deg<0 then Str:=Str+' Z'
                             else Str:=Str+' V';
  Result:=Str;
end;

//kodovani
procedure PwdCode(const nPwd:String; var sKod,sPwd:String);
type
  Tpwd=array[1..15] of byte;
var
  i:Integer;
  pwd,kod:Tpwd;
begin
  skod:='';spwd:='';
  randomize;
  for i:=1 to Length(nPwd) do
  begin
    kod[i]:=random(256);
    pwd[i]:=Ord(nPwd[i]) xor kod[i];

    if kod[i]<10 then skod:=skod+'00'+intToStr(kod[i]);
    if (kod[i]>9)and(kod[i]<100) then skod:=skod+'0'+intToStr(kod[i]);
    if kod[i]>99 then skod:=skod+intToStr(kod[i]);

    if pwd[i]<10 then spwd:=spwd+'00'+intToStr(pwd[i]);
    if (pwd[i]>9)and(pwd[i]<100) then spwd:=spwd+'0'+intToStr(pwd[i]);
    if pwd[i]>99 then spwd:=spwd+intToStr(pwd[i]);
  end;
end;

//dekodovani
function PwdDecode(const sKod,sPwd:String):String;
var
  pwd,k3,p3:String;
  i,j:Integer;
begin
  pwd:='';
  for i:=1 to (Length(spwd) div 3) do
  begin
    k3:='';p3:='';
    for j:=1 to 3 do
    begin
      k3:=k3+skod[(i-1)*3+j];
      p3:=p3+spwd[(i-1)*3+j];
    end;
    pwd:=pwd+Chr(StrToInt(p3) xor StrToInt(k3));
  end;
  result:=pwd;
end;

//
function BrowseCallbackProc(hwnd: HWND; uMsg: UINT; lParam: LPARAM; lpData: LPARAM): Integer; stdcall;
begin
  if (uMsg = BFFM_INITIALIZED) then
    SendMessage(hwnd, BFFM_SETSELECTION, 1, lpData);
  BrowseCallbackProc := 0;
end;

//dialog vyberu adresare
function GetFolderDialog(Handle: Integer; const Caption:string; var strFolder: string): Boolean;
const
  BIF_STATUSTEXT           = $0004;
  BIF_NEWDIALOGSTYLE       = $0040;
  BIF_RETURNONLYFSDIRS     = $0080;
  BIF_SHAREABLE            = $0100;
  BIF_USENEWUI             = BIF_EDITBOX or BIF_NEWDIALOGSTYLE;

var
  BrowseInfo: TBrowseInfo;
  ItemIDList: PItemIDList;
  JtemIDList: PItemIDList;
  Path: PAnsiChar;
begin
  Result := False;
  Path := StrAlloc(MAX_PATH);
  SHGetSpecialFolderLocation(Handle, CSIDL_DRIVES, JtemIDList);
  with BrowseInfo do
  begin
    hwndOwner := GetActiveWindow;
    pidlRoot := JtemIDList;
    SHGetSpecialFolderLocation(hwndOwner, CSIDL_DRIVES, JtemIDList);
    { return display name of item selected }
    pszDisplayName := StrAlloc(MAX_PATH);
    { set the title of dialog }
    lpszTitle := PChar(Caption);//'Select the folder';
    { flags that control the return stuff }
    lpfn := @BrowseCallbackProc;
    { extra info that's passed back in callbacks }
    lParam := LongInt(PChar(strFolder));
  end;
  ItemIDList := SHBrowseForFolder(BrowseInfo);
  if (ItemIDList <> nil) then
    if SHGetPathFromIDList(ItemIDList, Path) then
    begin
      strFolder := Path;
      Result := True
    end;
end;

//nastaveni obsahu comboboxu
procedure SetCbBoxItems(Box:TCustomComboBox; const Data:Array of PChar); overload;
var
  i:Integer;
begin
  Box.Items.Clear;
  if High(Data)=-1 then Exit;
  for i:=Low(Data) to High(Data) do Box.Items.Add(Data[i]);
  Box.ItemIndex:=0;
end;

procedure SetCbBoxItemsF(Box:TCustomComboBox; const Data:Array of Double); overload;
var
  i:Integer;
begin
  Box.Items.Clear;
  if High(Data)=-1 then Exit;
  for i:=Low(Data) to High(Data) do Box.Items.Add(FloatToStr(Data[i]));
  Box.ItemIndex:=0;
end;

procedure SetCbBoxItems(Box:TCustomComboBox; const Data:Array of PChar;
  const Min,Max:Integer); overload;
var
  i:Integer;
begin
  Box.Items.Clear;
  if High(Data)=-1 then Exit;
  for i:=Min to Max do Box.Items.Add(Data[i]);
  Box.ItemIndex:=0;
end;

procedure SetCbBoxItemsF(Box:TCustomComboBox; const Data:Array of Double;
  const Min,Max:Integer); overload;
var
  i:Integer;
begin
  Box.Items.Clear;
  if High(Data)=-1 then Exit;
  for i:=Min to Max do Box.Items.Add(FloatToStr(Data[i]));
  Box.ItemIndex:=0;
end;

//nastaveni obsahu listu
procedure SetItems(Items:TStrings; const Data:Array of PChar); overload;
var
  i:Integer;
begin
  Items.Clear;
  if High(Data)=-1 then Exit;
  for i:=Low(Data) to High(Data) do Items.Add(Data[i]);
end;

procedure SetItems(Items:TStrings; const Data:Array of PChar;
  const Min,Max:Integer); overload;
var
  i:Integer;
begin
  Items.Clear;
  for i:=Min to Max do Items.Add(Data[i]);
end;

end.
