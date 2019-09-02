object frmOnOff: TfrmOnOff
  Left = 354
  Top = 297
  BorderStyle = bsDialog
  Caption = 'Nastaven'#237
  ClientHeight = 95
  ClientWidth = 257
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
    Width = 241
    Height = 13
    AutoSize = False
    Caption = 'lblText'
  end
  object Bevel1: TBevel
    Left = 8
    Top = 56
    Width = 241
    Height = 2
    Shape = bsTopLine
  end
  object rbOn: TRadioButton
    Left = 8
    Top = 32
    Width = 73
    Height = 17
    Caption = 'Zapnout'
    Checked = True
    TabOrder = 0
    TabStop = True
  end
  object rbOff: TRadioButton
    Left = 88
    Top = 32
    Width = 65
    Height = 17
    Caption = 'Vypnout'
    TabOrder = 1
  end
  object btnOk: TButton
    Left = 80
    Top = 64
    Width = 75
    Height = 25
    Action = actOk
    TabOrder = 2
  end
  object btnCancel: TButton
    Left = 176
    Top = 64
    Width = 75
    Height = 25
    Action = actCancel
    TabOrder = 3
  end
  object actManager: TActionManager
    Left = 224
    Top = 24
    StyleName = 'XP Style'
    object actCancel: TAction
      Caption = 'Zru'#353'it'
      ShortCut = 27
      OnExecute = actCancelExecute
    end
    object actOk: TAction
      Caption = 'Nastavit'
      OnExecute = actOkExecute
    end
  end
end
