object Form1: TForm1
  Left = 496
  Top = 315
  Width = 641
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
    Width = 433
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
end
