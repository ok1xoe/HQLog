program Dxc;

uses
  FastMM4,
  Forms,
  SysUtils,
  NewSpot in 'NewSpot.pas' {frmDxcNewSpot},
  Main in 'Main.pas' {frmDxCluster},
  DxcResStrings in 'DxcResStrings.pas',
  DxcConsts in 'DxcConsts.pas',
  SetOnOff in 'SetOnOff.pas' {frmOnOff};

{$E dll}

{$R *.res}

begin
  if ParamCount<>7 then Exit;
  Application.Initialize;
  Application.Title := 'DxCluster';
  Application.CreateForm(TfrmDxCluster, frmDxCluster);
  frmDxCluster.SetOptions(ParamStr(1),ParamStr(2),ParamStr(3),
    StrToIntDef(ParamStr(4),41112),
    StrToBoolDef(ParamStr(5),True),
    StrToIntDef(ParamStr(6),640),
    StrToIntDef(ParamStr(7),480));
  Application.Run;
end.
