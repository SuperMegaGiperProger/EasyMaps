object Form1: TForm1
  Left = 1031
  Top = 168
  Width = 751
  Height = 675
  Caption = 'EasyMaps'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object mapImage: TImage
    Left = 160
    Top = 104
    Width = 545
    Height = 489
    OnMouseUp = mapImageMouseUp
  end
  object Shape1: TShape
    Left = 56
    Top = 80
    Width = 1
    Height = 145
    Brush.Style = bsCross
    Pen.Style = psDot
  end
  object BitBtn1: TBitBtn
    Left = 176
    Top = 32
    Width = 75
    Height = 25
    Caption = 'BitBtn1'
    TabOrder = 0
    OnClick = BitBtn1Click
  end
  object BitBtn2: TBitBtn
    Left = 328
    Top = 48
    Width = 75
    Height = 25
    Caption = 'BitBtn2'
    TabOrder = 1
    OnClick = BitBtn2Click
  end
  object BitBtn3: TBitBtn
    Left = 456
    Top = 32
    Width = 75
    Height = 25
    Caption = 'BitBtn3'
    TabOrder = 2
    OnClick = BitBtn3Click
  end
  object BitBtn4: TBitBtn
    Left = 64
    Top = 344
    Width = 75
    Height = 25
    Caption = 'BitBtn4'
    TabOrder = 3
    OnClick = BitBtn4Click
  end
  object BitBtn5: TBitBtn
    Left = 64
    Top = 400
    Width = 75
    Height = 25
    Caption = 'BitBtn5'
    TabOrder = 4
    OnClick = BitBtn5Click
  end
end
