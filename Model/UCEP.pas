unit UCEP;

interface

uses
  JSON, REST.Types, REST.Client, Data.Bind.Components, Data.Bind.ObjectScope, System.SysUtils, System.Generics.Collections;

type
  TAPI = (apViaCEP, apAPICEP,apAwesomeAPI);
  TCEP = class
  private
    FAPI: TAPI;
    FCEP: String;
    FLogradouro: String;
    FComplemento: String;
    FCidade: String;
    FUF: String;
    FBairro: String;
    FStatus: Integer;
    FJSON: TJSONObject;
    procedure setJSON;
  public
    RESTClient: TRESTClient;
    RESTRequest: TRESTRequest;
    RESTResponse: TRESTResponse;
    property API: TAPI read FAPI write FAPI;
    property CEP: String read FCEP write FCEP;
    property Logradouro: String read FLogradouro write FLogradouro;
    property Complemento: String read FComplemento write FComplemento;
    property Cidade: String read FCidade write FCidade;
    property UF: String read FUF write FUF;
    property Bairro: String read FBairro write FBairro;
    property Status: Integer read FStatus write FStatus;
    property JSON: TJSONObject read FJSON write FJSON;
    constructor Create;
    destructor Destroy; override;
    procedure LoadCEP(const ACEP: String);
  end;

implementation

{ TCEP }

const
  VIACEP:  String = 'https://viacep.com.br/ws/%s/json/';
  APICEP:  String = 'https://ws.apicep.com/cep/%s.json';
  AWESOME: String = 'https://cep.awesomeapi.com.br/json/%s';

constructor TCEP.Create;
begin
  RESTClient   := TRESTClient.Create(nil);
  RESTRequest  := TRESTRequest.Create(nil);
  RESTResponse := TRESTResponse.Create(nil);
  RESTRequest.Response := RESTResponse;
  RESTRequest.Client   := RESTClient;
  JSON := TJSONObject.Create();
end;

destructor TCEP.Destroy;
begin
  RESTClient.DisposeOf;
  RESTRequest.DisposeOf;
  RESTResponse.DisposeOf;
  JSON.DisposeOf;
  inherited;
end;

procedure TCEP.LoadCEP(const ACEP: String);
var
  JSONObject: TJSONObject;
  JSubPar: TJSONPair;
  I: Integer;
begin
  RESTClient.BaseURL := Format(VIACEP, [ACEP]);
  RESTRequest.Execute;
  Status := RESTRequest.Response.StatusCode;
  {$REGION 'Consulta API ViaCEP'}
  if RESTRequest.Response.StatusCode = 200 then
  begin
    API := apViaCEP;
    CEP := ACEP;
    JSONObject := TJSONObject.Create;
    try
      JSONObject := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(RESTRequest.Response.JSONText),0) as TJSONObject;
      for I := 0 to JSONObject.Count - 1 do  begin
        jSubPar := JSONObject.Pairs[I];
        if AnsiUpperCase(Trim(jSubPar.JsonString.Value)) = 'LOGRADOURO' then
          Logradouro := jSubPar.JsonValue.Value;
        if AnsiUpperCase(Trim(jSubPar.JsonString.Value)) = 'COMPLEMENTO' then
          Complemento := jSubPar.JsonValue.Value;
        if AnsiUpperCase(Trim(jSubPar.JsonString.Value)) = 'LOCALIDADE' then
          Cidade := jSubPar.JsonValue.Value;
        if AnsiUpperCase(Trim(jSubPar.JsonString.Value)) = 'UF' then
          UF := jSubPar.JsonValue.Value;
        if AnsiUpperCase(Trim(jSubPar.JsonString.Value)) = 'BAIRRO' then
          Bairro := jSubPar.JsonValue.Value;
      end;
    finally
      JSONObject.Free;
    end;
    setJSON;
    Exit;
  end;
  {$ENDREGION}
  {$REGION 'Consulta API APICEP'}
  RESTClient.BaseURL := Format(APICEP, [ACEP]);
  RESTRequest.Execute;
  Status := RESTRequest.Response.StatusCode;
  if RESTRequest.Response.StatusCode = 200 then
  begin
    API := apAPICEP;
    CEP := ACEP;
    JSONObject := TJSONObject.Create;
    try
      JSONObject := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(RESTRequest.Response.JSONText),0) as TJSONObject;
      for I := 0 to JSONObject.Count - 1 do  begin
        jSubPar := JSONObject.Pairs[I];
        if AnsiUpperCase(Trim(jSubPar.JsonString.Value)) = 'ADDRESS' then
          Logradouro := jSubPar.JsonValue.Value;
        if AnsiUpperCase(Trim(jSubPar.JsonString.Value)) = 'CITY' then
          Cidade := jSubPar.JsonValue.Value;
        if AnsiUpperCase(Trim(jSubPar.JsonString.Value)) = 'STATE' then
          UF := jSubPar.JsonValue.Value;
        if AnsiUpperCase(Trim(jSubPar.JsonString.Value)) = 'DISTRICT' then
          Bairro := jSubPar.JsonValue.Value;
      end;
    finally
      JSONObject.Free;
    end;
    setJSON;
    Exit;
  end;
  {$ENDREGION}
  {$REGION 'Consulta API AwesomeAPI'}
  RESTClient.BaseURL := Format(AWESOME, [ACEP]);
  RESTRequest.Execute;
  Status := RESTRequest.Response.StatusCode;
  if RESTRequest.Response.StatusCode = 200 then
  begin
    API := apAwesomeAPI;
    CEP := ACEP;
    JSONObject := TJSONObject.Create;
    try
      JSONObject := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(RESTRequest.Response.JSONText),0) as TJSONObject;
      for I := 0 to JSONObject.Count - 1 do  begin
        jSubPar := JSONObject.Pairs[I];
        if AnsiUpperCase(Trim(jSubPar.JsonString.Value)) = 'ADDRESS' then
          Logradouro := jSubPar.JsonValue.Value;
        if AnsiUpperCase(Trim(jSubPar.JsonString.Value)) = 'CITY' then
          Cidade := jSubPar.JsonValue.Value;
        if AnsiUpperCase(Trim(jSubPar.JsonString.Value)) = 'STATE' then
          UF := jSubPar.JsonValue.Value;
        if AnsiUpperCase(Trim(jSubPar.JsonString.Value)) = 'DISTRICT' then
          Bairro := jSubPar.JsonValue.Value;
      end;
    finally
      JSONObject.Free;
    end;
    setJSON;
  end;
  {$ENDREGION}
end;

procedure TCEP.setJSON;
begin
  JSON.AddPair(TJsonPair.Create('cep', CEP));
  JSON.AddPair(TJsonPair.Create('logradouro', Logradouro));
  JSON.AddPair(TJsonPair.Create('complemento', Complemento));
  JSON.AddPair(TJsonPair.Create('cidade', Cidade));
  JSON.AddPair(TJsonPair.Create('uf', UF));
  JSON.AddPair(TJsonPair.Create('bairro', Bairro));
end;

end.
