object Form1: TForm1
  Left = 236
  Top = 41
  HorzScrollBar.Visible = False
  VertScrollBar.Visible = False
  AlphaBlendValue = 10
  AutoScroll = False
  Caption = 'EasyMaps'
  ClientHeight = 994
  ClientWidth = 1433
  Color = clGradientInactiveCaption
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnActivate = FormActivate
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
    Left = 1384
    Top = 880
    Width = 25
    Height = 25
    Caption = '+'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -19
    Font.Name = 'FreeMono'
    Font.Style = [fsBold]
    Margin = 4
    ParentFont = False
    OnClick = SpeedButton1Click
  end
  object SpeedButton2: TSpeedButton
    Left = 1384
    Top = 904
    Width = 25
    Height = 25
    Caption = '-'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -19
    Font.Name = 'FreeMono'
    Font.Style = [fsBold]
    Margin = 4
    ParentFont = False
    OnClick = SpeedButton2Click
  end
  object Gauge: TGauge
    Left = 160
    Top = 488
    Width = 1129
    Height = 33
    ForeColor = clGreen
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    Progress = 0
    Visible = False
  end
  object Label3: TLabel
    Left = 592
    Top = 448
    Width = 255
    Height = 36
    Caption = #1047#1072#1075#1088#1091#1079#1082#1072' '#1082#1072#1088#1090#1099'..'
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clBlack
    Font.Height = -32
    Font.Name = 'Arial'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
  end
  object BitBtn4: TBitBtn
    Left = 16
    Top = 240
    Width = 25
    Height = 25
    Hint = #1059#1076#1072#1083#1080#1090#1100' '#1074#1089#1077' '#1087#1091#1085#1082#1090#1099' '#1089#1083#1077#1076#1086#1074#1072#1085#1080#1103
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
    WordWrap = True
    OnClick = BitBtn4Click
    Glyph.Data = {
      DE010000424DDE01000000000000760000002800000024000000120000000100
      0400000000006801000000000000000000001000000000000000000000000000
      80000080000000808000800000008000800080800000C0C0C000808080000000
      FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
      333333333333333333333333000033338833333333333333333F333333333333
      0000333911833333983333333388F333333F3333000033391118333911833333
      38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
      911118111118333338F3338F833338F3000033333911111111833333338F3338
      3333F8330000333333911111183333333338F333333F83330000333333311111
      8333333333338F3333383333000033333339111183333333333338F333833333
      00003333339111118333333333333833338F3333000033333911181118333333
      33338333338F333300003333911183911183333333383338F338F33300003333
      9118333911183333338F33838F338F33000033333913333391113333338FF833
      38F338F300003333333333333919333333388333338FFF830000333333333333
      3333333333333333333888330000333333333333333333333333333333333333
      0000}
    NumGlyphs = 2
  end
  object LoadBtn: TBitBtn
    Left = 642
    Top = 460
    Width = 145
    Height = 25
    Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1082#1072#1088#1090#1091
    TabOrder = 1
    OnClick = LoadBtnClick
  end
  object GroupBox1: TGroupBox
    Left = 16
    Top = 272
    Width = 97
    Height = 57
    Hint = 
      #1042#1099#1073#1086#1088': '#1085#1072#1095#1072#1083#1086' '#1080#1083#1080' '#1082#1086#1085#1077#1094' '#1087#1091#1090#1080' '#1091#1082#1072#1079#1099#1074#1072#1077#1090' '#1087#1086#1083#1100#1079#1086#1074#1072#1090#1077#1083#1100', '#1080#1083#1080' '#1087#1088#1086#1075#1088#1072#1084 +
      #1084#1072' '#1074#1099#1073#1080#1088#1072#1077#1090' '#1086#1087#1090#1080#1084#1072#1083#1100#1085#1091#1102' '#1090#1086#1095#1082#1091' '#1089#1090#1072#1088#1090#1072' '#1080#1083#1080' '#1092#1080#1085#1080#1096#1072
    Caption = #1047#1072#1092#1080#1082#1089#1080#1088#1086#1074#1072#1090#1100
    Color = clGradientInactiveCaption
    ParentColor = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 2
    object CheckBoxStart: TCheckBox
      Left = 8
      Top = 16
      Width = 81
      Height = 17
      Hint = #1055#1077#1088#1074#1099#1081' '#1087#1091#1085#1082#1090' '#1089#1083#1077#1076#1086#1074#1072#1085#1080#1103
      Caption = #1057#1090#1072#1088#1090
      Checked = True
      ParentShowHint = False
      ShowHint = True
      State = cbChecked
      TabOrder = 0
    end
    object CheckBoxFinish: TCheckBox
      Left = 8
      Top = 32
      Width = 81
      Height = 17
      Hint = #1055#1086#1089#1083#1077#1076#1085#1080#1081' '#1087#1091#1085#1082#1090' '#1089#1083#1077#1076#1086#1074#1072#1085#1080#1103
      Caption = #1060#1080#1085#1080#1096
      Checked = True
      ParentShowHint = False
      ShowHint = True
      State = cbChecked
      TabOrder = 1
    end
  end
  object BitBtn2: TBitBtn
    Left = 16
    Top = 336
    Width = 97
    Height = 25
    Hint = #1055#1088#1086#1083#1086#1078#1080#1090#1100' '#1082#1088#1072#1090#1095#1072#1081#1096#1080#1081' '#1087#1091#1090#1100
    Caption = #1053#1072#1081#1090#1080' '#1087#1091#1090#1100
    ParentShowHint = False
    ShowHint = True
    TabOrder = 3
    OnClick = BitBtn2Click
    Kind = bkRetry
  end
  object GroupBox2: TGroupBox
    Left = 16
    Top = 368
    Width = 97
    Height = 57
    Hint = #1058#1080#1087' '#1087#1077#1088#1077#1076#1074#1080#1078#1077#1085#1080#1103
    Caption = #1055#1077#1088#1077#1076#1074#1080#1078#1077#1085#1080#1077
    Color = clGradientInactiveCaption
    ParentColor = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 4
    object CheckBoxCar: TCheckBox
      Left = 8
      Top = 16
      Width = 81
      Height = 17
      Caption = #1053#1072' '#1084#1072#1096#1080#1085#1077
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object CheckBoxFoot: TCheckBox
      Left = 8
      Top = 32
      Width = 73
      Height = 17
      Caption = #1055#1077#1096#1082#1086#1084
      TabOrder = 1
    end
  end
  object ComboBoxCity: TComboBox
    Left = 643
    Top = 496
    Width = 145
    Height = 21
    ItemHeight = 13
    Sorted = True
    TabOrder = 5
    Text = #1042#1099#1073#1077#1088#1080#1090#1077' '#1075#1086#1088#1086#1076
    Items.Strings = (
      #1057#1080#1085#1075#1072#1087#1091#1088
      #1056#1080#1075#1072
      #1052#1080#1085#1089#1082
      #1051#1072#1089'-'#1042#1077#1075#1072#1089
      #1050#1080#1077#1074
      #1043#1083#1072#1079#1075#1086)
  end
end
