unit HQLConsts;

interface

uses
  Graphics, Messages;

const
  //info
  AppName='HQLog';
  iVersion = 2;
  sVersion = '1.0.2';
{  sVersions: Array[0..1] of String = (
    'Neznámá verze', '1.0.1');}
  Copyright = '©2006-2008 Martin Vágner (OK2CFM)';
  eMailLink = 'ok2cfm@tiscali.cz';
  wwwLink = 'http://home.tiscali.cz/ok2cfm';

  //
  LogMainClassName='TfrmHQLog';
  LogQSOClassName='TfrmQSO';
  DXCMainClassName='TfrmDxCluster';

  //adresare
  Data_Dir='Data\';
  Exp_Dir='Export\';
  Map_Dir='Mapa\';
  Zal_Dir='Zaloha\';
  Temp_Dir=AppName+'_Temp\';
  //soubory
  DxCluster_App='dxc.dll';
  TempDB_dFile='_Temp.db';
  TempDB_iFile='_Temp.px';
  QslDB_dFile='_QSL.db';
  QslDB_iFile='_QSL.px';
  MapHead_File='Map.mh';
  MapData_File='Map.md';
  Options_File='HqLog.ini';
  Help_File='Help\HQLog.chm';
  CallBook_File='CallBook.db';
  //
  dFileExt='.db';
  iFileExt='.px';
  uFileExt='.uf';
  zFileExt='.z';
  zFileDefExt='z';
  AdifFileExt='.adi';
  AdifFileDefExt='adi';
  CsvFileExt='.csv';
  CsvFileDefExt='csv';
  TxtFileExt='.txt';
  TxtFileDefExt='txt';

  //
  NTPServers:Array[0..1] of PChar=(
    'europe.pool.ntp.org','pool.ntp.org');
  //barvy
  clOfactTitle=$00EFD3C6;
  clOfOddRow=clWhite;
  clOfEvenRow=$f8f8f8;
  clOfselRow=clYellow;
  clOfText=clBlack;
  clOfSelText=clBlack;
  clOfCursor=$6A240A;
  //
  crHand=1;
  crHandDrag=2;
  //
  DefaultFreqsStr='3,5;7;10;14;18;21;24;28;50;144;';
  DefaultModesStr='1;2;3;4;5;6;7;8;9;10;11;12;13;14;15;16;17;18;19;20;21;22;23;24;25;26;27;28;29;';
  //
  DateSFormat='dd.mm.yy';
  DateLFormat='dd.mm.yyyy';
  DateFormats:Array[0..5] of PChar=(
    'dd.mm.yyyy','dd.mm.yy','d.m.yyyy','dd-mm-yyyy','dd-mm-yy','d-m-yyyy');
  TimeSFormat='hh:nn';
  TimeLFormat='hh:nn:ss';
  TimeFormats:Array[0..3] of PChar=(
    'hh:nn','hh:nn:ss','h:nn','h:nn:ss');
  FreqFormat='0.####';
  FreqFormats:Array[0..6] of PChar=(
    '0.###','0.##','0.#','0.000','0.00','0.0','0');
  //
  DXCDefHost='ok0dxi.nagano.cz';

type
  //
  TProgressEvent = procedure(const Progress:Integer) of Object;

implementation

end.
