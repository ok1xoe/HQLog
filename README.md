# HQLog

How to build the log from source codes:

Delphi 7

1) Install Action Bands Patch
1.1) Fllow instructions in "Lib3P\ActionBandsPatch\readme.htm"

2) Install SynEdit component (Needed to build DX Cluster plugin)
2.1) Open "Lib3P\SynEdit\Packages\SynEdit_R7.dpk"
2.2) Compile
2.3) Open "Lib3P\SynEdit\Packages\SynEdit_D7.dpk"
2.4) Compile
2.5) Install
2.6) Menu Tools -> Enviroment Options -> Library -> Library path -> Add full path of "Lib3P\SynEdit\Source\"

3) Install visual components
3.1) Open "LibCFM\VCL\HQLogVCL.dpk"
3.2) Compile
3.3) Install
3.4) Menu Tools -> Enviroment Options -> Library -> Library path -> Add full path of "LibCFM\VCL\"

2) Open "HQLog.bpg"
2.1) Menu Project -> Build All Projects

