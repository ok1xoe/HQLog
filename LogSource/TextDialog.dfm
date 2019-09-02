object frmDialog: TfrmDialog
  Left = 315
  Top = 254
  BorderStyle = bsNone
  ClientHeight = 98
  ClientWidth = 250
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object shpRamecek: TShape
    Left = 0
    Top = 0
    Width = 250
    Height = 98
    Align = alClient
    Brush.Color = 15717318
    Pen.Width = 3
  end
  object lblText: TLabel
    Left = 16
    Top = 16
    Width = 217
    Height = 41
    Alignment = taCenter
    AutoSize = False
    Transparent = True
    Layout = tlCenter
    WordWrap = True
  end
  object pgBar: TGauge
    Left = 16
    Top = 65
    Width = 217
    Height = 17
    ForeColor = clNavy
    Progress = 0
  end
  object Btn: TButton
    Left = 88
    Top = 60
    Width = 75
    Height = 25
    Caption = 'OK'
    TabOrder = 0
  end
end
