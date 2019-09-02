object dlgComboBox: TdlgComboBox
  Left = 535
  Top = 303
  BorderStyle = bsDialog
  Caption = 'V'#253'b'#283'r m'#243'du'
  ClientHeight = 71
  ClientWidth = 208
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object cbBoxMode: TComboBox
    Left = 8
    Top = 8
    Width = 195
    Height = 21
    Style = csDropDownList
    DropDownCount = 15
    ItemHeight = 13
    TabOrder = 0
  end
  object btnOk: TButton
    Left = 40
    Top = 40
    Width = 75
    Height = 25
    Action = actOk
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 128
    Top = 40
    Width = 75
    Height = 25
    Action = actCancel
    TabOrder = 2
  end
  object actManager: TActionManager
    Left = 8
    Top = 40
    StyleName = 'XP Style'
    object actOk: TAction
      Caption = 'Ok'
      ShortCut = 13
      OnExecute = actOkExecute
    end
    object actCancel: TAction
      Caption = 'Zru'#353'it'
      ShortCut = 27
      OnExecute = actCancelExecute
    end
  end
end
