object frmDxcNewSpot: TfrmDxcNewSpot
  Left = 587
  Top = 385
  BorderStyle = bsDialog
  Caption = 'Nov'#253' spot'
  ClientHeight = 133
  ClientWidth = 344
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
  object lblCall: TLabel
    Left = 8
    Top = 12
    Width = 38
    Height = 13
    Caption = 'Zna'#269'ka:'
  end
  object lblFreq: TLabel
    Left = 8
    Top = 44
    Width = 54
    Height = 13
    Caption = 'Frekvence:'
  end
  object lblNote: TLabel
    Left = 8
    Top = 76
    Width = 52
    Height = 13
    Caption = 'Pozn'#225'mka:'
  end
  object lblMHz: TLabel
    Left = 200
    Top = 44
    Width = 20
    Height = 13
    Caption = 'MHz'
  end
  object edtCall: TEdit
    Left = 72
    Top = 8
    Width = 121
    Height = 21
    TabOrder = 0
  end
  object edtNote: TEdit
    Left = 72
    Top = 72
    Width = 265
    Height = 21
    MaxLength = 28
    TabOrder = 2
  end
  object btnCancel: TButton
    Left = 264
    Top = 104
    Width = 75
    Height = 25
    Action = actCancel
    TabOrder = 4
  end
  object btnOk: TButton
    Left = 176
    Top = 104
    Width = 75
    Height = 25
    Action = actOk
    TabOrder = 3
  end
  object cbBoxFreq: TComboBox
    Left = 72
    Top = 40
    Width = 121
    Height = 21
    ItemHeight = 13
    TabOrder = 1
    OnKeyPress = cbBoxFreqKeyPress
  end
  object actManager: TActionManager
    Left = 8
    Top = 104
    StyleName = 'XP Style'
    object actOk: TAction
      Caption = 'OK'
      ShortCut = 16397
      OnExecute = actOkExecute
    end
    object actCancel: TAction
      Caption = 'Zru'#353'it'
      ShortCut = 27
      OnExecute = actCancelExecute
    end
  end
end
