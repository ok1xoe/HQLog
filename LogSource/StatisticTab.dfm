object frmStatTab: TfrmStatTab
  Left = 333
  Top = 202
  Width = 751
  Height = 640
  Caption = 'Statistika'
  Color = clBtnFace
  Constraints.MinHeight = 480
  Constraints.MinWidth = 640
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  WindowState = wsMaximized
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object dgdStat: TDrawGrid
    Left = 0
    Top = 62
    Width = 743
    Height = 530
    Align = alClient
    ColCount = 3
    DefaultDrawing = False
    RowCount = 4
    FixedRows = 3
    Options = [goThumbTracking]
    TabOrder = 0
    OnDrawCell = dgdStatDrawCell
    OnKeyDown = dgdStatKeyDown
    OnMouseWheelDown = dgdStatMouseWheelDown
    OnMouseWheelUp = dgdStatMouseWheelUp
  end
  object actMainMenuBar: TActionMainMenuBar
    Left = 0
    Top = 0
    Width = 743
    Height = 24
    UseSystemFont = False
    ActionManager = actManager
    Caption = 'actMainMenuBar'
    ColorMap.HighlightColor = 14410210
    ColorMap.BtnSelectedColor = clBtnFace
    ColorMap.UnusedColor = 14410210
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Tahoma'
    Font.Style = []
    Spacing = 0
  end
  object tlBar: TToolBar
    Left = 0
    Top = 24
    Width = 743
    Height = 38
    AutoSize = True
    ButtonHeight = 36
    ButtonWidth = 49
    Caption = 'tlBar'
    Flat = True
    Images = dmLog.imgList
    ShowCaptions = True
    TabOrder = 2
    object tlBtnDXCC: TToolButton
      Left = 0
      Top = 0
      Action = actStatDXCC
    end
    object tlBtnIOTA: TToolButton
      Left = 49
      Top = 0
      Action = actStatIOTA
    end
    object tlBtnITU: TToolButton
      Left = 98
      Top = 0
      Action = actStatITU
    end
    object tlBtnWAZ: TToolButton
      Left = 147
      Top = 0
      Action = actStatWAZ
    end
    object tlBtnLOC: TToolButton
      Left = 196
      Top = 0
      Action = actStatLOC
    end
    object ToolButton4: TToolButton
      Left = 245
      Top = 0
      Width = 8
      Caption = 'ToolButton4'
      ImageIndex = 8
      Style = tbsSeparator
    end
    object tlBtnFilter: TToolButton
      Left = 253
      Top = 0
      Action = actFilter
    end
  end
  object stBar: TStatusBar
    Left = 0
    Top = 592
    Width = 743
    Height = 21
    Panels = <
      item
        Width = 150
      end
      item
        Width = 150
      end
      item
        Width = 50
      end>
  end
  object actManager: TActionManager
    ActionBars = <
      item
        Items = <
          item
            Items = <
              item
                Action = actSaveAs
                Caption = '&Ulo'#382'it jako ...'
                ImageIndex = 17
              end
              item
                Caption = '-'
              end
              item
                Action = actExit
                Caption = '&Konec'
              end>
            Caption = '&Soubor'
          end
          item
            Items = <
              item
                Action = actStatDXCC
                Caption = '&DXCC'
                ImageIndex = 29
              end
              item
                Action = actStatIOTA
                Caption = '&IOTA'
                ImageIndex = 26
              end
              item
                Action = actStatITU
                Caption = 'I&TU'
                ImageIndex = 44
              end
              item
                Action = actStatWAZ
                Caption = '&WAZ'
                ImageIndex = 45
              end
              item
                Action = actStatLOC
                Caption = '&Lok'#225'tory'
                ImageIndex = 43
              end>
            Caption = 'S&tatistika'
          end
          item
            Items = <
              item
                Action = actFilter
                Caption = '&Filtr'
                ImageIndex = 7
              end>
            Caption = 'N'#225'st&roje'
          end>
        ActionBar = actMainMenuBar
      end>
    Images = dmLog.imgList
    Left = 40
    Top = 160
    StyleName = 'XP Style'
    object actSaveAs: TAction
      Category = 'Soubor'
      Caption = 'Ulo'#382'it jako ...'
      ImageIndex = 17
      OnExecute = actSaveAsExecute
    end
    object actExit: TAction
      Category = 'Soubor'
      Caption = 'Konec'
      OnExecute = actExitExecute
    end
    object actFilter: TAction
      Category = 'N'#225'stroje'
      Caption = 'Filtr'
      ImageIndex = 7
      OnExecute = actFilterExecute
    end
    object actStatDXCC: TAction
      Category = 'Statistika'
      Caption = 'DXCC'
      GroupIndex = 10
      ImageIndex = 46
      OnExecute = actStatDXCCExecute
    end
    object actStatIOTA: TAction
      Category = 'Statistika'
      Caption = 'IOTA'
      GroupIndex = 10
      ImageIndex = 26
      OnExecute = actStatIOTAExecute
    end
    object actStatITU: TAction
      Category = 'Statistika'
      Caption = 'ITU'
      GroupIndex = 10
      ImageIndex = 44
      OnExecute = actStatITUExecute
    end
    object actStatWAZ: TAction
      Category = 'Statistika'
      Caption = 'WAZ'
      GroupIndex = 10
      ImageIndex = 45
      OnExecute = actStatWAZExecute
    end
    object actStatLOC: TAction
      Category = 'Statistika'
      Caption = 'Lok'#225'tory'
      GroupIndex = 10
      ImageIndex = 43
      OnExecute = actStatLOCExecute
    end
  end
  object qStat: TQuery
    Left = 80
    Top = 160
  end
  object qList: TQuery
    Left = 120
    Top = 160
  end
end
