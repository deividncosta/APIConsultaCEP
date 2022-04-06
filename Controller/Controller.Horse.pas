unit Controller.Horse;

interface

uses
  Horse, Horse.GBSwagger, System.JSON;

procedure Registry;

implementation

uses UCEP, Controller.Commons;

procedure GetCEP(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  CEP: TCEP;
begin
  CEP := TCEP.Create;
  CEP.LoadCEP(Req.Query.Items['cep']);
  if CEP.JSON.Count > 0 then
  begin
    Res.Send<TJSONObject>(CEP.JSON).Status(THTTPStatus.OK);
    SaveLog('Consultado CEP ' + Req.Query.Items['cep']);
  end
  else
  begin
    Res.Send('CEP não encontrado').Status(THTTPStatus.NotFound);
    SaveLog('CEP ' + Req.Query.Items['cep'] + ' não encontrado');
  end;
end;

procedure Registry;
begin
  THorse.Get('/cep', GetCEP);
  THorse.Use(HorseSwagger);
  Swagger
    .Info
      .Title('Consulta de CEP')
      .Description('API para consultar detalhes de um CEP')
      .Contact
        .Name('Deivid Nascimento Costa')
        .Email('davis_43102@hotmail.com')
        .URL('https://github.com/deividncosta')
      .&End
    .&End
    .Path('cep')
      .Tag('CEP')
      .GET('Consultar CEP')
        .AddParamQuery('cep','CEP').&End
        .AddResponse(200)
        .IsArray(False).&End
        .AddResponse(400).&End
        .AddResponse(500).&End
      .&End
    .&End
  .&End;
end;

end.
