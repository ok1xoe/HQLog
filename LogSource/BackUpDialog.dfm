object frmBackUpDlg: TfrmBackUpDlg
  Left = 447
  Top = 437
  BorderStyle = bsDialog
  Caption = 'Obnova den'#237'ku'
  ClientHeight = 166
  ClientWidth = 402
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object bvlTop: TBevel
    Left = 0
    Top = 33
    Width = 402
    Height = 2
    Align = alTop
    Shape = bsTopLine
  end
  object lblCallT: TLabel
    Left = 8
    Top = 64
    Width = 38
    Height = 13
    Caption = 'Zna'#269'ka:'
  end
  object lblDateT: TLabel
    Left = 8
    Top = 80
    Width = 35
    Height = 13
    Caption = 'Datum:'
  end
  object lblTimeT: TLabel
    Left = 8
    Top = 96
    Width = 22
    Height = 13
    Caption = #268'as:'
  end
  object lblFileT: TLabel
    Left = 8
    Top = 48
    Width = 38
    Height = 13
    Caption = 'Soubor:'
  end
  object lblFile: TLabel
    Left = 64
    Top = 48
    Width = 329
    Height = 13
    AutoSize = False
    Caption = 'C:\HQLog\OK2CFM 12.01.2006.z'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lblCall: TLabel
    Left = 64
    Top = 64
    Width = 105
    Height = 13
    AutoSize = False
    Caption = 'OK2CFM'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lblDate: TLabel
    Left = 64
    Top = 80
    Width = 105
    Height = 13
    AutoSize = False
    Caption = '12.01.2006'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object lblTime: TLabel
    Left = 64
    Top = 96
    Width = 105
    Height = 13
    AutoSize = False
    Caption = '16:45'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clMaroon
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
  end
  object bvlBottom: TBevel
    Left = 0
    Top = 123
    Width = 402
    Height = 2
    Shape = bsTopLine
  end
  object pnlTitle: TPanel
    Left = 0
    Top = 0
    Width = 402
    Height = 33
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    TabOrder = 0
    object Label4: TLabel
      Left = 8
      Top = 8
      Width = 346
      Height = 13
      Caption = 'V'#353'echna data v den'#237'ku budou p'#345'eps'#225'na!!  Chcete pokra'#269'ovat?'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Tahoma'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object Button1: TButton
    Left = 320
    Top = 136
    Width = 75
    Height = 25
    Action = actCancel
    TabOrder = 1
  end
  object Button2: TButton
    Left = 224
    Top = 136
    Width = 75
    Height = 25
    Action = actOk
    TabOrder = 2
  end
  object actManager: TActionManager
    Left = 8
    Top = 136
    StyleName = 'XP Style'
    object actOk: TAction
      Caption = 'Pokra'#269'ovat'
      OnExecute = actOkExecute
    end
    object actCancel: TAction
      Caption = 'Zru'#353'it'
      ShortCut = 27
      OnExecute = actCancelExecute
    end
  end
end
