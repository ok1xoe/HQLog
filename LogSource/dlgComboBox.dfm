object frmComboBox: TfrmComboBox
  Left = 535
  Top = 303
  BorderStyle = bsDialog
  Caption = 'V'#253'b'#283'r'
  ClientHeight = 86
  ClientWidth = 248
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
  object lblText: TLabel
    Left = 8
    Top = 8
    Width = 32
    Height = 13
    Caption = 'lblText'
  end
  object ComboBox: TComboBox
    Left = 8
    Top = 24
    Width = 235
    Height = 21
    Style = csDropDownList
    DropDownCount = 15
    ItemHeight = 13
    TabOrder = 0
  end
  object btnOk: TButton
    Left = 80
    Top = 56
    Width = 75
    Height = 25
    Action = actOk
    TabOrder = 1
  end
  object btnCancel: TButton
    Left = 168
    Top = 56
    Width = 75
    Height = 25
    Action = actCancel
    TabOrder = 2
  end
  object actManager: TActionManager
    Left = 8
    Top = 56
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
