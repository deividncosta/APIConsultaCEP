unit Controller.Commons;

interface

procedure SaveLog(MSG: String);

implementation

uses View.API, System.SysUtils;

procedure SaveLog(MSG: String);
begin
  frmAPI.MemoLog.Lines.Add(FormatDateTime('DD/MM/YYYY HH:MM:SS', Now()) + ' - ' + MSG);
end;

end.
