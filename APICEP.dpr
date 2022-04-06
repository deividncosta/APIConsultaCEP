program APICEP;

uses
  Vcl.Forms,
  View.API in 'View\View.API.pas' {frmAPI},
  UCEP in 'Model\UCEP.pas',
  Controller.Horse in 'Controller\Controller.Horse.pas',
  Controller.Commons in 'Controller\Controller.Commons.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmAPI, frmAPI);
  Application.Run;
end.
