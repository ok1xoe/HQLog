object frmImportEdit: TfrmImportEdit
  Left = 482
  Top = 356
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Editace spojen'#237
  ClientHeight = 293
  ClientWidth = 474
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lblWAZ: TLabel
    Left = 352
    Top = 36
    Width = 27
    Height = 13
    Caption = 'WAZ:'
    Color = clBtnFace
    ParentColor = False
  end
  object lblTime: TLabel
    Left = 8
    Top = 36
    Width = 22
    Height = 13
    Caption = #268'as:'
    Color = clBtnFace
    ParentColor = False
  end
  object lblRSTp: TLabel
    Left = 8
    Top = 156
    Width = 29
    Height = 13
    Caption = 'RSTp:'
    Color = clBtnFace
    ParentColor = False
  end
  object lblRSTo: TLabel
    Left = 8
    Top = 132
    Width = 29
    Height = 13
    Caption = 'RSTo:'
    Color = clBtnFace
    ParentColor = False
  end
  object lblQTH: TLabel
    Left = 208
    Top = 108
    Width = 25
    Height = 13
    Caption = 'QTH:'
    Color = clBtnFace
    ParentColor = False
  end
  object lblQSLp: TLabel
    Left = 352
    Top = 156
    Width = 25
    Height = 13
    Caption = 'QSLp'
    Color = clBtnFace
    ParentColor = False
  end
  object lblQSLo: TLabel
    Left = 208
    Top = 156
    Width = 25
    Height = 13
    Caption = 'QSLo'
    Color = clBtnFace
    ParentColor = False
  end
  object lblPWR: TLabel
    Left = 208
    Top = 204
    Width = 27
    Height = 13
    Caption = 'PWR:'
    Color = clBtnFace
    ParentColor = False
  end
  object lblNote: TLabel
    Left = 8
    Top = 228
    Width = 52
    Height = 13
    Caption = 'Pozn'#225'mka:'
    Color = clBtnFace
    ParentColor = False
  end
  object lblName: TLabel
    Left = 208
    Top = 84
    Width = 35
    Height = 13
    Caption = 'Jm'#233'no:'
    Color = clBtnFace
    ParentColor = False
  end
  object lblMode: TLabel
    Left = 8
    Top = 108
    Width = 24
    Height = 13
    Caption = 'M'#243'd:'
    Color = clBtnFace
    ParentColor = False
  end
  object lblMGRmgr: TLabel
    Left = 208
    Top = 132
    Width = 40
    Height = 13
    Caption = 'QSL via:'
    Color = clBtnFace
    ParentColor = False
  end
  object lblLOCp: TLabel
    Left = 8
    Top = 204
    Width = 30
    Height = 13
    Caption = 'LOCp:'
    Color = clBtnFace
    ParentColor = False
  end
  object lblLOCo: TLabel
    Left = 8
    Top = 180
    Width = 30
    Height = 13
    Caption = 'LOCo:'
    Color = clBtnFace
    ParentColor = False
  end
  object lblITU: TLabel
    Left = 208
    Top = 36
    Width = 21
    Height = 13
    Caption = 'ITU:'
    Color = clBtnFace
    ParentColor = False
  end
  object lblIOTA: TLabel
    Left = 208
    Top = 60
    Width = 29
    Height = 13
    Caption = 'IOTA:'
    Color = clBtnFace
    ParentColor = False
  end
  object lblFreq: TLabel
    Left = 8
    Top = 84
    Width = 24
    Height = 13
    Caption = 'MHz:'
    Color = clBtnFace
    ParentColor = False
  end
  object lblEQSL: TLabel
    Left = 208
    Top = 180
    Width = 25
    Height = 13
    Caption = 'eQSL'
    Color = clBtnFace
    ParentColor = False
  end
  object lblDXCC: TLabel
    Left = 208
    Top = 12
    Width = 31
    Height = 13
    Caption = 'DXCC:'
    Color = clBtnFace
    ParentColor = False
  end
  object lblDate: TLabel
    Left = 8
    Top = 12
    Width = 35
    Height = 13
    Caption = 'Datum:'
    Color = clBtnFace
    ParentColor = False
  end
  object lblAward: TLabel
    Left = 352
    Top = 60
    Width = 35
    Height = 13
    Caption = 'Diplom:'
    Color = clBtnFace
    ParentColor = False
  end
  object lbCall: TLabel
    Left = 8
    Top = 60
    Width = 38
    Height = 13
    Caption = 'Zna'#269'ka:'
    Color = clBtnFace
    ParentColor = False
  end
  object Bevel1: TBevel
    Left = 8
    Top = 256
    Width = 457
    Height = 2
    Shape = bsTopLine
  end
  object btnSave: TButton
    Left = 296
    Top = 264
    Width = 75
    Height = 25
    Action = actSave
    TabOrder = 0
  end
  object btnClose: TButton
    Left = 392
    Top = 264
    Width = 75
    Height = 25
    Action = actClose
    TabOrder = 1
  end
  object edtWAZ: TEdit
    Tag = 12
    Left = 392
    Top = 32
    Width = 73
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 2
    TabOrder = 2
    OnKeyDown = FormKeyDown
    OnKeyPress = ITUWAZKeyPress
  end
  object edtTime: TTimeEdit
    Left = 64
    Top = 32
    Width = 121
    Height = 21
    TabOrder = 3
    OnKeyDown = FormKeyDown
  end
  object edtRSTp: TReportEdit
    Left = 64
    Top = 152
    Width = 121
    Height = 21
    MaxLength = 3
    TabOrder = 4
    OnKeyDown = FormKeyDown
  end
  object edtRSTo: TReportEdit
    Left = 64
    Top = 128
    Width = 121
    Height = 21
    MaxLength = 3
    TabOrder = 5
    OnKeyDown = FormKeyDown
  end
  object edtQTH: TEdit
    Tag = 6
    Left = 264
    Top = 104
    Width = 201
    Height = 21
    MaxLength = 20
    TabOrder = 6
    OnKeyDown = FormKeyDown
  end
  object edtQSLvia: TEdit
    Tag = 8
    Left = 264
    Top = 128
    Width = 201
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 15
    TabOrder = 7
    OnKeyDown = FormKeyDown
  end
  object edtNote: TEdit
    Tag = 9
    Left = 64
    Top = 224
    Width = 401
    Height = 21
    MaxLength = 50
    TabOrder = 8
    OnKeyDown = FormKeyDown
  end
  object edtName: TEdit
    Tag = 5
    Left = 264
    Top = 80
    Width = 201
    Height = 21
    MaxLength = 15
    TabOrder = 9
    OnKeyDown = FormKeyDown
  end
  object edtLOCp: TLocatorEdit
    Left = 64
    Top = 200
    Width = 73
    Height = 21
    TabOrder = 10
    OnKeyDown = FormKeyDown
  end
  object edtLOCo: TLocatorEdit
    Left = 64
    Top = 176
    Width = 73
    Height = 21
    TabOrder = 11
    OnKeyDown = FormKeyDown
  end
  object edtITU: TEdit
    Tag = 12
    Left = 264
    Top = 32
    Width = 73
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 2
    TabOrder = 12
    OnKeyDown = FormKeyDown
    OnKeyPress = ITUWAZKeyPress
  end
  object edtIOTA: TIOTAEdit
    Left = 264
    Top = 56
    Width = 73
    Height = 21
    TabOrder = 13
    OnKeyDown = FormKeyDown
  end
  object edtDxcc: TEdit
    Tag = 12
    Left = 264
    Top = 8
    Width = 73
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 5
    TabOrder = 14
    OnKeyDown = FormKeyDown
    OnKeyPress = DxccKeyPress
  end
  object edtDate: TDateEdit
    Left = 64
    Top = 8
    Width = 121
    Height = 21
    TabOrder = 15
    OnKeyDown = FormKeyDown
  end
  object edtCall: TEdit
    Left = 64
    Top = 56
    Width = 121
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 15
    TabOrder = 16
    OnKeyDown = FormKeyDown
    OnKeyPress = CallKeyPress
  end
  object edtAward: TEdit
    Tag = 12
    Left = 392
    Top = 56
    Width = 73
    Height = 21
    CharCase = ecUpperCase
    MaxLength = 12
    TabOrder = 17
    OnKeyDown = FormKeyDown
    OnKeyPress = edtAwardKeyPress
  end
  object cbBoxQSLp: TComboBox
    Left = 392
    Top = 152
    Width = 73
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 18
    OnKeyDown = FormKeyDown
  end
  object cbBoxQSLo: TComboBox
    Tag = 13
    Left = 264
    Top = 152
    Width = 73
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 19
    OnKeyDown = FormKeyDown
  end
  object cbBoxPWR: TComboBox
    Left = 264
    Top = 200
    Width = 73
    Height = 21
    ItemHeight = 13
    MaxLength = 5
    TabOrder = 20
    OnKeyDown = FormKeyDown
    OnKeyPress = edtFloatKeyPress
  end
  object cbBoxMode: TComboBox
    Tag = 2
    Left = 64
    Top = 104
    Width = 121
    Height = 21
    Style = csDropDownList
    CharCase = ecUpperCase
    DropDownCount = 12
    ItemHeight = 13
    MaxLength = 7
    TabOrder = 21
    OnKeyDown = FormKeyDown
  end
  object cbBoxFreq: TComboBox
    Tag = 1
    Left = 64
    Top = 80
    Width = 121
    Height = 21
    DropDownCount = 17
    ItemHeight = 13
    TabOrder = 22
    OnKeyDown = FormKeyDown
    OnKeyPress = edtFloatKeyPress
  end
  object cbBoxEQSL: TComboBox
    Tag = 13
    Left = 264
    Top = 176
    Width = 73
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 23
    OnKeyDown = FormKeyDown
  end
  object actManager: TActionManager
    Left = 8
    Top = 264
    StyleName = 'XP Style'
    object actClose: TAction
      Caption = 'Zav'#345#237't'
      ShortCut = 27
      OnExecute = actCloseExecute
    end
    object actSave: TAction
      Caption = 'Ulo'#382'it'
      ShortCut = 16397
      OnExecute = actSaveExecute
    end
  end
end
