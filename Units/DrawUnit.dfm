object Form1: TForm1
  Left = 359
  Top = 41
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  AlphaBlendValue = 10
  AutoScroll = False
  Caption = 'EasyMaps'
  ClientHeight = 993
  ClientWidth = 1433
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCanResize = FormCanResize
  OnMouseWheelDown = FormMouseWheelDown
  OnMouseWheelUp = FormMouseWheelUp
  PixelsPerInch = 96
  TextHeight = 13
  object mapImage: TImage
    Left = 0
    Top = 0
    Width = 1433
    Height = 993
    OnMouseDown = mapImageMouseDown
    OnMouseMove = mapImageMouseMove
    OnMouseUp = mapImageMouseUp
  end
  object Label1: TLabel
    Left = 1232
    Top = 976
    Width = 201
    Height = 17
    AutoSize = False
    Caption = #1043#1077#1086#1076#1072#1085#1085#1099#1077' '#1074#1079#1103#1090#1099' '#1089
    Color = clWhite
    ParentColor = False
    Transparent = False
  end
  object Label2: TLabel
    Left = 1336
    Top = 976
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
  object SpeedButton1: TSpeedButton
    Left = 1400
    Top = 880
    Width = 23
    Height = 22
    Caption = '+'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -16
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 1400
    Top = 904
    Width = 23
    Height = 22
    Caption = '-'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -19
    Font.Name = 'Arial'
    Font.Style = [fsBold]
    ParentFont = False
    OnClick = SpeedButton2Click
  end
  object Gauge: TGauge
    Left = 120
    Top = 48
    Width = 273
    Height = 17
    ForeColor = clGreen
    Progress = 0
  end
  object BitBtn2: TBitBtn
    Left = 88
    Top = 8
    Width = 75
    Height = 25
    Caption = 'BitBtn2'
    TabOrder = 0
    OnClick = BitBtn2Click
  end
  object BitBtn3: TBitBtn
    Left = 160
    Top = 8
    Width = 75
    Height = 25
    Caption = 'BitBtn3'
    TabOrder = 1
    OnClick = BitBtn3Click
  end
  object BitBtn4: TBitBtn
    Left = 8
    Top = 312
    Width = 75
    Height = 25
    Caption = 'BitBtn4'
    TabOrder = 2
    OnClick = BitBtn4Click
  end
  object BitBtn5: TBitBtn
    Left = 8
    Top = 368
    Width = 75
    Height = 25
    Caption = 'BitBtn5'
    TabOrder = 3
    OnClick = BitBtn5Click
  end
  object BitBtn6: TBitBtn
    Left = 8
    Top = 416
    Width = 75
    Height = 25
    Caption = 'BitBtn6'
    TabOrder = 4
    OnClick = BitBtn6Click
  end
  object BitBtn7: TBitBtn
    Left = 8
    Top = 464
    Width = 75
    Height = 25
    Caption = 'BitBtn7'
    TabOrder = 5
    OnClick = BitBtn7Click
  end
  object BitBtn8: TBitBtn
    Left = 8
    Top = 504
    Width = 75
    Height = 25
    Caption = 'BitBtn8'
    TabOrder = 6
    OnClick = BitBtn8Click
  end
  object BitBtn9: TBitBtn
    Left = 24
    Top = 40
    Width = 75
    Height = 25
    Caption = 'Load'
    TabOrder = 7
    OnClick = BitBtn9Click
  end
  object BitBtn10: TBitBtn
    Left = 576
    Top = 32
    Width = 75
    Height = 25
    Caption = 'BitBtn10'
    TabOrder = 8
  end
  object OpenDialog1: TOpenDialog
    FileName = 
      'Z:\mnt\4CC4F1C5C4F1B176\Projects\Delphi '#1054#1040#1080#1055' 2\CourseWork_2sem\M' +
      'ap\map.txt'
    Left = 48
    Top = 8
  end
end
