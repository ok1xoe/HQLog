unit KeyFilters;
interface

type
  TSetOfChars = Set of Char;

procedure FilterCall(var Key: Char; const Allow:TSetOfChars=[]);
procedure FilterFloat(var Key: Char);
procedure FilterNumber(var Key: Char);
procedure FilterRST(var Key: Char);
procedure FilterLocator(var Key: Char; const SelStart:Integer; const Allow:TSetOfChars=[]);
procedure FilterIOTA(var Key: Char; const SelStart:Integer; const Allow:TSetOfChars=[]);
procedure FilterDate(var Key:Char; var Text:String; var SelStart:Integer);
procedure FilterTime(var Key:Char; var Text:String; var SelStart:Integer);
procedure FilterAward(var Key:Char; const Allow:TSetOfChars);

implementation
const
  cCisla=['0'..'9'];
  cVPism=['A'..'Z'];
  cMPism=['a'..'z'];

//znacka
procedure FilterCall(var Key: Char; const Allow:TSetOfChars);
begin
  Key:=UpCase(Key);
  if not(Key in cVPism+cCisla+[#8,'/']+Allow) then Key:=#0;
end;

//desetinne cislo
procedure FilterFloat(var Key: Char);
begin
  if Key='.' then Key:=',';
  if not(Key in cCisla+[#8,',']) then Key:=#0;
end;

//cislo
procedure FilterNumber(var Key: Char);
begin
 if not(Key in cCisla+[#8]) then Key:=#0;
end;

//RST
procedure FilterRST(var Key: Char);
begin
  Key:=UpCase(Key);
  if not(Key in cVPism+cCisla+[#8,',']) then Key:=#0;
end;

//lokator
procedure FilterLocator(var Key: Char; const SelStart:Integer; const Allow:TSetOfChars);
begin
  Key:=UpCase(Key);
  if not(((SelStart in [0,1,4,5])and(Key in cVPism+Allow))or
         ((SelStart in [2,3])and(Key in cCisla+Allow))or
         (Key=#8)) then Key:=#0;
end;

//IOTA
procedure FilterIOTA(var Key: Char; const SelStart:Integer; const Allow:TSetOfChars);
begin
  Key:=UpCase(Key);
  if not(((SelStart in [0,1])and(Key in cVPism+Allow))or
         ((SelStart in [2,3,4])and(Key in cCisla+Allow))or
         (Key=#8)) then Key:=#0;
end;

//datum
procedure FilterDate(var Key:Char; var Text:String; var SelStart:Integer);
begin
  case Key of
    '0'..'9':
       if Length(Text) in [2,5] then
       begin
         Text:=Text+'.';
         SelStart:=Length(Text);
       end;
    '.',',',':': begin
      if Length(Text) in [1,4] then
      begin
        Insert('0',Text,Length(Text));
        Text:=Text+'.';
        SelStart:=Length(Text);
      end;
      if SelStart in [2,5] then Key:='.'
                           else Key:=#0;
    end;
    #8:;
  else
    Key:=#0;
  end;
end;

//cas
procedure FilterTime(var Key:Char; var Text:String; var SelStart:Integer);
begin
  case Key of
    '0'..'9':
       if Length(Text) in [2,5] then
       begin
         Text:=Text+':';
         SelStart:=Length(Text);
       end;
    '.',',',':': begin
      if Length(Text) in [1,4] then
      begin
        Insert('0',Text,Length(Text));
        Text:=Text+':';
        SelStart:=Length(Text);
      end;
      if SelStart in [2,5] then Key:=':'
                           else Key:=#0;
    end;
    #8:;
  else
    Key:=#0;
  end;
end;

procedure FilterAward(var Key:Char; const Allow:TSetOfChars);
begin
  Key:=UpCase(Key);
  if not(Key in cVPism+cCisla+[#8,'/','-']+Allow) then Key:=#0;
end;

end.
