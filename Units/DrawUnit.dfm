object Form1: TForm1
  Left = 232
  Top = 160
  Width = 1305
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
    Width = 1025
    Height = 489
    OnMouseUp = mapImageMouseUp
  end
  object Shape1: TShape
    Left = 56
    Top = 80
    Width = 41
    Height = 145
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
end