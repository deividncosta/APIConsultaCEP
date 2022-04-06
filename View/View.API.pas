unit View.API;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls,
  Horse, Horse.Jhonson, Horse.Commons, System.JSON, Horse.HandleException, Horse.Compression, Horse.Logger, Horse.Logger.Provider.LogFile, Horse.BasicAuthentication;

type
  TfrmAPI = class(TForm)
    MemoLog: TMemo;
    btnStart: TButton;
    btnStop: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnStartClick(Sender: TObject);
    procedure btnStopClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmAPI: TfrmAPI;

implementation

{$R *.dfm}

uses Controller.Horse, Controller.Commons, Horse.GBSwagger;

procedure TfrmAPI.btnStartClick(Sender: TObject);
begin
  THorse.Listen(8000);
  SaveLog('API iniciada na porta 8000');
  btnStart.Enabled := False;
  btnStop.Enabled  := True;
end;

procedure TfrmAPI.btnStopClick(Sender: TObject);
begin
  THorse.StopListen;
  SaveLog('API finalizada');
  btnStart.Enabled := True;
  btnStop.Enabled  := False;
end;

procedure TfrmAPI.FormCreate(Sender: TObject);
begin
  MemoLog.Lines.Clear;
  THorseLoggerManager.RegisterProvider(THorseLoggerProviderLogFile.New());
  THorse.Use(HorseBasicAuthentication(function(const AUsername, APassword: string): Boolean
    begin
      Result := AUsername.Equals('deivid') and APassword.Equals('deivid');
    end));
  THorse
    .Use(Compression())
    .Use(Jhonson)
    .Use(THorseLoggerManager.HorseCallback())
    .Use(HandleException);
  Registry;
end;

end.
