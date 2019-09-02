{**************************************************************************************************}
{                                                                                                  }
{ CharSet Library                                                                                  }
{                                                                                                  }
{**************************************************************************************************}

unit cfmCharSet;

interface

type
  TCharSet = (cp1250, cp895, cp852, iso8859_2);

const
  CHARSET_NAME: Array[cp1250..iso8859_2] of String =
  (
    'CP1250 (Windows)', 'CP895 (Kamenických)', 'CP852 (Latin II)', 'ISO8859-2'
  );
  CharSetNames: Array[cp1250..iso8859_2] of PChar = (
    'CP1250 (Windows)', 'CP895 (Kamenických)', 'CP852 (Latin II)', 'ISO8859-2'
  );

procedure CharsetConvert(Text: PChar; FromCharset: TCharSet);

implementation

type
  TCharsetTab = Array[#128..#255] of Byte;

const
  ctab_cp895_cp1250: TCharsetTab = (
    $C8 ,$FC, $E9, $EF, $E4, $CF, $8D, $E8,
    $EC, $CC, $C5, $CD, $BE, $E5, $C4, $C1,
    $C9, $9E, $8E, $F4, $F6, $D3, $F9, $DA,
    $FD, $D6, $DC, $8A, $BC, $DD, $D8, $9D,
    $E1, $ED, $F3, $FA, $F2, $D2, $D9, $D4,
    $9A, $F8, $E0, $C0, $5F, $A7, $AB, $BB,
    $5F, $5F, $5F, $5F, $5F, $5F, $5F, $5F,
    $5F, $5F, $5F, $5F, $5F, $5F, $5F, $5F,
    $5F, $5F, $5F, $5F, $5F, $5F, $5F, $5F,
    $5F, $5F, $5F, $5F, $5F, $5F, $5F, $5F,
    $5F, $5F, $5F, $5F, $5F, $5F, $5F, $5F,
    $5F, $5F, $5F, $5F, $5F, $5F, $5F, $5F,
    $5F, $5F, $5F, $5F, $5F, $5F, $5F, $5F,
    $5F, $5F, $5F, $5F, $5F, $5F, $5F, $5F, 
    $5F, $B1, $5F, $5F, $5F, $5F, $F7, $5F,
    $5F, $B7, $5F, $5F, $5F, $5F, $5F, $A0
  );

  ctab_cp852_cp1250: TCharsetTab = (
    $C7, $FC, $E9, $E2, $E4, $F9, $E6, $E7,
    $B3, $EB, $D5, $F5, $EE, $8F, $C4, $C6,
    $C9, $C5, $E5, $F4, $F6, $BC, $BE, $8C,
    $9C, $D6, $DC, $8D, $9D, $A3, $D7, $E8,
    $E1, $ED, $F3, $FA, $A5, $B9, $8E, $9E,
    $CA, $EA, $AC, $9F, $C8, $BA, $AB, $BB,
    $5F, $5F, $5F, $5F, $5F, $C1, $C2, $CC,
    $AA, $5F, $5F, $5F, $5F, $AF, $BF, $5F,
    $5F, $5F, $5F, $5F, $5F, $5F, $C3, $E3,
    $5F, $5F, $5F, $5F, $5F, $5F, $5F, $A4,
    $F0, $D0, $CF, $CB, $EF, $D2, $CD, $CE,
    $EC, $5F, $5F, $5F, $5F, $DE, $D9, $5F,
    $D3, $DF, $D4, $D1, $F1, $F2, $8A, $9A,
    $C0, $DA, $E0, $DB, $FD, $DD, $FE, $B4,
    $AD, $BD, $B2, $A1, $A2, $A7, $F7, $B8,
    $B0, $A8, $FF, $FB, $D8, $F8, $5F, $A0
  );

  ctab_iso8859_2_cp1250: TCharsetTab = (
    $5F, $5F, $5F, $5F, $5F, $5F, $5F, $5F,
    $5F, $5F, $5F, $5F, $5F, $5F, $5F, $5F,
    $5F, $5F, $5F, $5F, $5F, $5F, $5F, $5F,
    $5F, $5F, $5F, $5F, $5F, $5F, $5F, $5F,
    $A0, $A5, $A2, $A3, $A4, $BC, $8C, $A7,
    $A8, $8A, $AA, $8D, $8F, $AD, $8E, $AF,
    $B0, $B9, $B2, $B3, $B4, $BE, $9C, $A1,
    $B8, $9A, $BA, $9D, $9F, $BD, $9E, $BF,
    $C0, $C1, $C2, $C3, $C4, $C5, $C6, $C7,
    $C8, $C9, $CA, $CB, $CC, $CD, $CE, $CF,
    $D0, $D1, $D2, $D3, $D4, $D5, $D6, $D7,
    $D8, $D9, $DA, $DB, $DC, $DD, $DE, $DF,
    $E0, $E1, $E2, $E3, $E4, $E5, $E6, $E7,
    $E8, $E9, $EA, $EB, $EC, $ED, $EE, $EF,
    $F0, $F1, $F2, $F3, $F4, $F5, $F6, $F7,
    $F8, $F9, $FA, $FB, $FC, $FD, $FE, $FF
  );


procedure CharsetConvert(Text: PChar; FromCharset: TCharSet);
var
  cTab: ^TCharsetTab;
begin
  if Text = nil then Exit;
  case FromCharset of
    cp895: cTab:=@ctab_cp895_cp1250;
    cp852: cTab:=@ctab_cp852_cp1250;
    iso8859_2: cTab:=@ctab_iso8859_2_cp1250;
  else
    Exit;
  end;
  while Text^ <> #0 do
  begin
    if Text^ in [#128..#255] then
      Text^:=Char(cTab^[Text^]);
    Inc(Text);
  end;
end;

end.

