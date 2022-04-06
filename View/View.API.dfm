object frmAPI: TfrmAPI
  Left = 0
  Top = 0
  Width = 583
  Height = 456
  BorderStyle = bsSingle
  Caption = 'API Consulta de CEP - Deivid Nascimento Costa'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  TextHeight = 15
  object MemoLog: TMemo
    Left = 0
    Top = 56
    Width = 567
    Height = 361
    Align = alBottom
    Lines.Strings = (
      'MemoLog')
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object btnStart: TButton
    Left = 8
    Top = 14
    Width = 120
    Height = 25
    Caption = 'Start'
    TabOrder = 1
    OnClick = btnStartClick
  end
  object btnStop: TButton
    Left = 133
    Top = 14
    Width = 120
    Height = 25
    Caption = 'Stop'
    Enabled = False
    TabOrder = 2
    OnClick = btnStopClick
  end
end
