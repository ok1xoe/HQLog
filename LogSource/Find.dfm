object frmFind: TfrmFind
  Left = 658
  Top = 548
  ActiveControl = cbBoxData
  BorderStyle = bsDialog
  Caption = 'Vyhledat'
  ClientHeight = 151
  ClientWidth = 320
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object lblData: TLabel
    Left = 16
    Top = 12
    Width = 35
    Height = 13
    Caption = 'Hledat:'
  end
  object lblField: TLabel
    Left = 16
    Top = 44
    Width = 29
    Height = 13
    Caption = 'V poli:'
  end
  object Label1: TLabel
    Left = 16
    Top = 72
    Width = 96
    Height = 13
    Caption = 'Z'#225'stupn'#233' znaky * ? '
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = [fsItalic]
    ParentFont = False
  end
  object cbBoxField: TComboBox
    Left = 64
    Top = 40
    Width = 153
    Height = 21
    Style = csDropDownList
    DropDownCount = 10
    ItemHeight = 13
    TabOrder = 1
    OnChange = cbBoxFieldChange
  end
  object chBoxCase: TCheckBox
    Left = 16
    Top = 120
    Width = 185
    Height = 17
    TabStop = False
    Caption = 'Rozli'#353'ovat velk'#225' a mal'#225' p'#237'smena'
    TabOrder = 2
  end
  object btnClose: TButton
    Left = 232
    Top = 118
    Width = 75
    Height = 25
    Action = actClose
    TabOrder = 4
  end
  object btnFind: TButton
    Left = 232
    Top = 80
    Width = 75
    Height = 25
    Action = actFind
    TabOrder = 3
  end
  object cbBoxData: TComboBox
    Left = 64
    Top = 8
    Width = 241
    Height = 21
    ItemHeight = 13
    TabOrder = 0
    OnChange = cbBoxDataChange
    OnKeyDown = cbBoxDataKeyDown
    OnKeyPress = cbBoxDataKeyPress
  end
  object chBoxFirst: TCheckBox
    Left = 16
    Top = 96
    Width = 113
    Height = 17
    TabStop = False
    Caption = 'Hledat od za'#269#225'tku'
    TabOrder = 5
    OnClick = chBoxFirstChange
  end
  object actManager: TActionManager
    Left = 192
    Top = 112
    StyleName = 'XP Style'
    object actFind: TAction
      Caption = '&Hledat'
      Hint = 'Vyhledat zadan'#253' '#250'daj'
      ShortCut = 13
      OnExecute = actFindExecute
    end
    object actClose: TAction
      Caption = '&Zav'#345#237't'
      Hint = 'Zav'#345#237't formul'#225#345
      ShortCut = 27
      OnExecute = actCloseExecute
    end
    object actHelp: TAction
      Caption = 'N'#225'pov'#283'da'
      ShortCut = 112
      OnExecute = actHelpExecute
    end
  end
end
