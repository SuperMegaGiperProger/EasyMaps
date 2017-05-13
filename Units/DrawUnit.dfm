object Form1: TForm1
  Left = 1161
  Top = 248
  Width = 679
  Height = 604
  AlphaBlendValue = 10
  Caption = 'EasyMaps'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnMouseWheelDown = FormMouseWheelDown
  OnMouseWheelUp = FormMouseWheelUp
  PixelsPerInch = 96
  TextHeight = 13
  object mapImage: TImage
    Left = 104
    Top = 72
    Width = 545
    Height = 489
    OnMouseDown = mapImageMouseDown
    OnMouseMove = mapImageMouseMove
    OnMouseUp = mapImageMouseUp
  end
  object Shape1: TShape
    Left = 0
    Top = 48
    Width = 1
    Height = 145
    Brush.Style = bsCross
    Pen.Style = psDot
  end
  object Label1: TLabel
    Left = 448
    Top = 544
    Width = 201
    Height = 17
    AutoSize = False
    Caption = #1043#1077#1086#1076#1072#1085#1085#1099#1077' '#1074#1079#1103#1090#1099' '#1089
    Color = clWhite
    ParentColor = False
    Transparent = False
  end
  object Label2: TLabel
    Left = 552
    Top = 544
    Width = 93
    Height = 13
    Caption = 'OpenStreetMap.org'
    Color = clWhite
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clBlue
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentColor = False
    ParentFont = False
    Transparent = True
    OnClick = Label2Click
    OnMouseEnter = Label2MouseEnter
    OnMouseLeave = Label2MouseLeave
  end
  object BitBtn1: TBitBtn
    Left = 120
    Top = 16
    Width = 75
    Height = 25
    Caption = 'BitBtn1'
    TabOrder = 0
    OnClick = BitBtn1Click
  end
  object BitBtn2: TBitBtn
    Left = 272
    Top = 16
    Width = 75
    Height = 25
    Caption = 'BitBtn2'
    TabOrder = 1
    OnClick = BitBtn2Click
  end
  object BitBtn3: TBitBtn
    Left = 392
    Top = 16
    Width = 75
    Height = 25
    Caption = 'BitBtn3'
    TabOrder = 2
    OnClick = BitBtn3Click
  end
  object BitBtn4: TBitBtn
    Left = 8
    Top = 312
    Width = 75
    Height = 25
    Caption = 'BitBtn4'
    TabOrder = 3
    OnClick = BitBtn4Click
  end
  object BitBtn5: TBitBtn
    Left = 8
    Top = 368
    Width = 75
    Height = 25
    Caption = 'BitBtn5'
    TabOrder = 4
    OnClick = BitBtn5Click
  end
  object BitBtn6: TBitBtn
    Left = 8
    Top = 416
    Width = 75
    Height = 25
    Caption = 'BitBtn6'
    TabOrder = 5
    OnClick = BitBtn6Click
  end
  object BitBtn7: TBitBtn
    Left = 8
    Top = 464
    Width = 75
    Height = 25
    Caption = 'BitBtn7'
    TabOrder = 6
    OnClick = BitBtn7Click
  end
  object BitBtn8: TBitBtn
    Left = 8
    Top = 504
    Width = 75
    Height = 25
    Caption = 'BitBtn8'
    TabOrder = 7
    OnClick = BitBtn8Click
  end
  object BitBtn9: TBitBtn
    Left = 8
    Top = 56
    Width = 75
    Height = 25
    Caption = 'Load'
    TabOrder = 8
    OnClick = BitBtn9Click
  end
end
