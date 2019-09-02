unit DxcConsts;

interface

uses Graphics;

const
  DxcCaption='DxCluster';
  //
  clOfOutText=clBlack;
  clOfInText=clBlue;
  clOfInfoText=clPurple;
  clOfDxText=clMaroon;
  clOfAllText=clGreen;
  //
  TxHistory=50;
  //
  DXCBandTab:Array[0..19,0..2] of String=(
    ('136khz','137','137kHz'),
    ('160m','160','160m (1.8MHz)'),
    ('80m','80','80m (3.5MHz)'),
    ('40m','40','40m (7MHz)'),
    ('30m','30','30m (10MHz)'),
    ('20m','20','20m (14MHz)'),
    ('17m','17','17m (18MHz)'),
    ('15m','15','15m (21MHz)'),
    ('12m','12','12m (24MHz)'),
    ('10m','10','10m (28MHz)'),
    ('6m','6','6m (50MHz)'),
    ('2m','2','2m (144MHz)'),
    ('70cm','70cm','70cm (430MHz)'),
    ('23cm','23cm','23cm (1.2GHz)'),
    ('13cm','13cm','13cm (2.3GHz)'),
    ('9cm','9cm','9cm (3.4GHz)'),
    ('6cm','5cm','5cm (5.6GHz)'),
    ('3cm','3cm','3cm (10GHz)'),
    ('12mm','24GHz','12mm (24GHz)'),
    ('6mm','47GHz','6mm (47GHz)')
  );

implementation

end.
