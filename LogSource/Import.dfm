object frmImport: TfrmImport
  Left = 333
  Top = 177
  Width = 800
  Height = 600
  Caption = 'Import'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object spltDataLog: TSplitter
    Left = 0
    Top = 413
    Width = 792
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ResizeStyle = rsUpdate
  end
  object lBoxErr: TListBox
    Left = 0
    Top = 416
    Width = 792
    Height = 157
    Align = alBottom
    Constraints.MinHeight = 50
    ItemHeight = 13
    TabOrder = 0
    OnClick = lBoxErrClick
  end
  object dbGrid: TCfmDBGrid
    Left = 0
    Top = 40
    Width = 792
    Height = 373
    Align = alClient
    DataSource = dsImport
    DefaultDrawing = False
    Options = [dgTitles, dgIndicator, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
    Row = 1
    RowCount = 2
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnDrawColumnCell = dbGridDrawColumnCell
    OnDblClick = actEditExecute
    OnKeyDown = dbGridKeyDown
    Columns = <
      item
        Expanded = False
        FieldName = 'ID'
        Title.Caption = 'Index'
        Width = 30
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'DAT'
        Title.Caption = 'Datum'
        Width = 60
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'UTC'
        Width = 47
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'CALL'
        Title.Caption = 'Zna'#269'ka'
        Width = 90
        Visible = True
      end
      item
        Alignment = taRightJustify
        Expanded = False
        FieldName = 'FREQ'
        Title.Alignment = taRightJustify
        Title.Caption = 'MHz'
        Width = 40
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'MODE'
        Title.Caption = 'M'#243'd'
        Width = 38
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'RSTO'
        Title.Alignment = taCenter
        Title.Caption = 'R-O'
        Width = 24
        Visible = True
      end
      item
        Alignment = taCenter
        Expanded = False
        FieldName = 'RSTP'
        Title.Alignment = taCenter
        Title.Caption = 'R-P'
        Width = 24
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NAME'
        Title.Caption = 'Jm'#233'no'
        Width = 70
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'QTH'
        Width = 70
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'LOCO'
        Title.Caption = 'LOCo'
        Width = 48
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'LOCP'
        Title.Caption = 'LOCp'
        Width = 48
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'IOTA'
        Width = 38
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'QSLO'
        Title.Caption = 'Q-O'
        Width = 26
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'QSLP'
        Title.Caption = 'Q-P'
        Width = 26
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'QSLVIA'
        Title.Caption = 'QSL via'
        Width = 56
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'NOTE'
        Title.Caption = 'Pozn'#225'mka'
        Width = 100
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'PWR'
        Width = 30
        Visible = True
      end>
  end
  object tlBar: TToolBar
    Left = 0
    Top = 0
    Width = 792
    Height = 40
    AutoSize = True
    ButtonHeight = 36
    ButtonWidth = 61
    Caption = 'tlBar'
    EdgeBorders = [ebLeft, ebTop, ebRight, ebBottom]
    Flat = True
    Images = dmLog.imgList
    ParentShowHint = False
    ShowCaptions = True
    ShowHint = True
    TabOrder = 2
    object tlBtnEdit: TToolButton
      Left = 0
      Top = 0
      Action = actEdit
    end
    object tlBtnDelete: TToolButton
      Left = 61
      Top = 0
      Action = actDelete
    end
    object ToolButton1: TToolButton
      Left = 122
      Top = 0
      Width = 8
      Caption = 'ToolButton1'
      ImageIndex = 6
      Style = tbsSeparator
    end
    object tlBtnImport: TToolButton
      Left = 130
      Top = 0
      Action = actImport
    end
    object tlBtnCancel: TToolButton
      Left = 191
      Top = 0
      Action = actCancel
    end
    object ToolButton4: TToolButton
      Left = 252
      Top = 0
      Width = 8
      Caption = 'ToolButton4'
      ImageIndex = 4
      Style = tbsSeparator
    end
  end
  object dsImport: TDataSource
    DataSet = tblImport
    Left = 80
    Top = 128
  end
  object tblImport: TTable
    SessionName = 'Default'
    Left = 40
    Top = 128
  end
  object actManager: TActionManager
    Images = dmLog.imgList
    Left = 40
    Top = 88
    StyleName = 'XP Style'
    object actEdit: TAction
      Caption = 'Upravit'
      Hint = 'Upravit spojen'#237
      ImageIndex = 2
      ShortCut = 115
      OnExecute = actEditExecute
    end
    object actDelete: TAction
      Caption = 'Smazat'
      Hint = 'Smazat spojen'#237
      ImageIndex = 3
      ShortCut = 8238
      OnExecute = actDeleteExecute
    end
    object actSelect: TAction
      Caption = 'Ozna'#269'it'
      ImageIndex = 22
      ShortCut = 45
      OnExecute = actSelectExecute
    end
    object actImport: TAction
      Caption = 'Importovat'
      Hint = 'Dokon'#269'it import'
      ImageIndex = 30
      OnExecute = actImportExecute
    end
    object actCancel: TAction
      Caption = 'Zru'#353'it'
      Hint = 'Zru'#353'it import'
      ImageIndex = 31
      OnExecute = actCancelExecute
    end
    object actCharSet: TAction
      Caption = 'K'#243'dov'#225'n'#237
      ImageIndex = 38
      OnExecute = actCharSetExecute
    end
    object actSelectAll: TAction
      Caption = 'Ozna'#269'it v'#353'e'
      OnExecute = actSelectAllExecute
    end
    object actSelectNone: TAction
      Caption = 'Odoza'#269'it'
      OnExecute = actSelectNoneExecute
    end
    object actHelp: TAction
      Caption = 'N'#225'pov'#283'da'
      ShortCut = 112
      OnExecute = actHelpExecute
    end
  end
  object qSource: TQuery
    SessionName = 'Default'
    Left = 40
    Top = 168
  end
  object qLog: TQuery
    SessionName = 'Default'
    Left = 40
    Top = 208
  end
end
