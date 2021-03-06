unit CoreAPI;

interface

uses
  TelegAPI.Base,
  CrossUrl.HttpClient,
  System.Rtti,
  System.TypInfo,
  System.SysUtils,
  System.Generics.Collections,
  CoreAPI.Parameter,
  System.Classes,
  TelegAPI.Types;

type
  ItgRequestAPI = interface
    ['{3DC5A653-F52D-4A31-87AD-0C008AFA7111}']
    // private
    function GetOnError: TProc<Exception>;
    procedure SetOnError(const Value: TProc<Exception>);
    function GetOnSend: TProc<string, string>;
    procedure SetOnSend(const Value: TProc<string, string>);
    function GetOnReceive: TProc<string>;
    procedure SetOnReceive(const Value: TProc<string>);
    function GetDataExtractor: TFunc<string, string>;
    procedure SetDataExtractor(const Value: TFunc<string, string>);
    function GetFormData: IcuMultipartFormData;
    // public
    function SetToken(const AToken: string): ItgRequestAPI;
    function SetMethod(const AMethod: string): ItgRequestAPI;
    //
    function AddParameter(const AKey: string; const AValue, ADefaultValue:
      string; const ARequired: Boolean = False): ItgRequestAPI; overload;
    function AddParameter(const AKey: string; const AValue, ADefaultValue:
      Integer; const ARequired: Boolean = False): ItgRequestAPI; overload;
    function AddParameter(const AKey: string; const AValue, ADefaultValue:
      TDateTime; const ARequired: Boolean = False): ItgRequestAPI; overload;
    function AddParameter(const AKey: string; const AValue, ADefaultValue:
      TtgFileToSend; const ARequired: Boolean = False): ItgRequestAPI; overload;
    function AddParameter(const AKey: string; const AValue, ADefaultValue:
      TtgUserLink; const ARequired: Boolean = False): ItgRequestAPI; overload;
    function AddParameter(const AKey: string; const AValue, ADefaultValue:
      TObject; const ARequired: Boolean = False): ItgRequestAPI; overload;
    function AddParameter(const AKey: string; const AValue, ADefaultValue:
      Boolean; const ARequired: Boolean = False): ItgRequestAPI; overload;
    function AddParameter(const AKey: string; const AValue, ADefaultValue:
      Single; const ARequired: Boolean = False): ItgRequestAPI; overload;
      //
    function AddRawField(const AField, AValue: string): ItgRequestAPI;
    function AddRawFile(const AFieldName, AFileName: string): ItgRequestAPI;
    function AddRawStream(const AFieldName: string; Data: TStream; const
      AFileName: string): ItgRequestAPI;

      //
    function ClearParameters: ItgRequestAPI;
    function Execute: string;
    function ExecuteAsBool: Boolean;
    function ExecuteAndReadValue: string;
    // props
    property DataExtractor: TFunc<string, string> read GetDataExtractor write
      SetDataExtractor;
    property MultipartFormData: IcuMultipartFormData read GetFormData;
    // events
    property OnError: TProc<Exception> read GetOnError write SetOnError;
    property OnSend: TProc<string, string> read GetOnSend write SetOnSend;
    property OnReceive: TProc<string> read GetOnReceive write SetOnReceive;
  end;

  TtgCoreApiBase = class(TtgAbstractComponent, ItgRequestAPI)
  protected
    const
      SERVER = 'https://api.telegram.org/bot';
  private
    FGetOnSend: TProc<string, string>;
    FDataExtractor: TFunc<string, string>;
    FOnReceive: TProc<string>;
    FLastRequestIsOk: Boolean;
    FToken: string;
    FMethod: string;
    FOnError: TProc<Exception>;
    FFormData: IcuMultipartFormData;
    FHttp: IcuHttpClient;
    FIsEmpty: Boolean;
    function GetOnError: TProc<Exception>;
    procedure SetOnError(const Value: TProc<Exception>);
    function GetOnSend: TProc<string, string>;
    procedure SetOnSend(const Value: TProc<string, string>);
    function GetOnReceive: TProc<string>;
    procedure SetOnReceive(const Value: TProc<string>);
    function GetDataExtractor: TFunc<string, string>;
    procedure SetDataExtractor(const Value: TFunc<string, string>);
    function GetUrl: string;
    function GetFormData: IcuMultipartFormData;
    procedure SetHttp(const Value: IcuHttpClient);
  protected
    procedure DoHaveException(const AException: Exception);
    function StreamToString(Stream: TStream): string;
  public
    function SetToken(const AToken: string): ItgRequestAPI;
    function SetMethod(const AMethod: string): ItgRequestAPI;
    function AddParameter(const AKey: string; const AValue, ADefaultValue:
      string; const ARequired: Boolean = False): ItgRequestAPI; overload;
    function AddParameter(const AKey: string; const AValue, ADefaultValue:
      Integer; const ARequired: Boolean = False): ItgRequestAPI; overload;
    function AddParameter(const AKey: string; const AValue, ADefaultValue:
      TDateTime; const ARequired: Boolean = False): ItgRequestAPI; overload;
    function AddParameter(const AKey: string; const AValue, ADefaultValue:
      TtgFileToSend; const ARequired: Boolean = False): ItgRequestAPI; overload;
    function AddParameter(const AKey: string; const AValue, ADefaultValue:
      TtgUserLink; const ARequired: Boolean = False): ItgRequestAPI; overload;
    function AddParameter(const AKey: string; const AValue, ADefaultValue:
      TObject; const ARequired: Boolean = False): ItgRequestAPI; overload;
    function AddParameter(const AKey: string; const AValue, ADefaultValue:
      Boolean; const ARequired: Boolean = False): ItgRequestAPI; overload;
    function AddParameter(const AKey: string; const AValue, ADefaultValue:
      Single; const ARequired: Boolean = False): ItgRequestAPI; overload;
      //
    function AddRawField(const AField, AValue: string): ItgRequestAPI;
    function AddRawFile(const AFieldName, AFileName: string): ItgRequestAPI;
    function AddRawStream(const AFieldName: string; Data: TStream; const
      AFileName: string): ItgRequestAPI;
    function IsEmpty: Boolean;
    function ClearParameters: ItgRequestAPI;
    function Execute: string; virtual; abstract;
    function ExecuteAsBool: Boolean;
    function ExecuteAndReadValue: string;
    destructor Destroy; override;
    constructor Create(AOwner: TComponent); override;

  // props
    property LastRequestIsOk: Boolean read FLastRequestIsOk write FLastRequestIsOk;
    property DataExtractor: TFunc<string, string> read GetDataExtractor write
      SetDataExtractor;
    property Url: string read GetUrl;
    property HttpCore: IcuHttpClient read FHttp write SetHttp;
  // events
    property OnError: TProc<Exception> read GetOnError write SetOnError;
    property OnSend: TProc<string, string> read GetOnSend write SetOnSend;
    property OnReceive: TProc<string> read GetOnReceive write SetOnReceive;
  end;

  TtgCoreApi = class(TtgCoreApiBase, ItgRequestAPI)
  private
  protected
    function DoPost: string;
    function DoGet: string;
  public
    function Execute: string; override;
    constructor Create;
    destructor Destroy; override;
  end;

implementation

uses
  System.DateUtils,
  System.JSON,
  REST.Json,
  TelegAPI.Exceptions,
  TelegAPI.Types.ReplyMarkups;

{ TtgCoreApiBase }

function TtgCoreApiBase.AddParameter(const AKey, AValue, ADefaultValue: string;
  const ARequired: Boolean): ItgRequestAPI;
begin
  if ARequired and (AValue.Equals(ADefaultValue) or AValue.isEmpty) then
    DoHaveException(ETelegramException.Create('Not assigned required data [TtgApiRequest.FillFormData]'));
  AddRawField(AKey, AValue);
  Result := self;
end;

function TtgCoreApiBase.AddParameter(const AKey: string; const AValue,
  ADefaultValue: Integer; const ARequired: Boolean): ItgRequestAPI;
begin
  Result := AddParameter(AKey, AValue.ToString, ADefaultValue.ToString, ARequired);
end;

function TtgCoreApiBase.AddRawField(const AField, AValue: string): ItgRequestAPI;
begin
  FFormData.AddField(AField, AValue);
  FIsEmpty := False;
  Result := Self;
end;

function TtgCoreApiBase.AddRawFile(const AFieldName, AFileName: string): ItgRequestAPI;
begin
  FFormData.AddFile(AFieldName, AFileName);
  FIsEmpty := False;
  Result := Self;
end;

function TtgCoreApiBase.AddRawStream(const AFieldName: string; Data: TStream;
  const AFileName: string): ItgRequestAPI;
begin
  FFormData.AddStream(AFieldName, Data, AFileName);
  FIsEmpty := False;
  Result := Self;
end;

function TtgCoreApiBase.ClearParameters: ItgRequestAPI;
begin
  FFormData := nil;
  FIsEmpty := True;
  FFormData := httpCore.CreateMultipartFormData;
  Result := Self;
end;

constructor TtgCoreApiBase.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FIsEmpty := True;
end;

destructor TtgCoreApiBase.Destroy;
begin

  inherited;
end;

procedure TtgCoreApiBase.DoHaveException(const AException: Exception);
begin
  if Assigned(OnError) then
    OnError(AException)
  else
    raise AException;
end;

function TtgCoreApiBase.ExecuteAndReadValue: string;
var
  LJson: TJSONValue;
begin
  LJson := TJSONObject.ParseJSONValue(Execute);
  try
    Result := LJson.Value;
  finally
    LJson.Free;
  end;
end;

function TtgCoreApiBase.ExecuteAsBool: Boolean;
var
  LJson: TJSONValue;
begin
  LJson := TJSONObject.ParseJSONValue(Execute);
  try
    Result := LJson is TJSONTrue;
  finally
    LJson.Free;
  end;
end;

function TtgCoreApiBase.GetDataExtractor: TFunc<string, string>;
begin
  Result := FDataExtractor;
end;

function TtgCoreApiBase.GetFormData: IcuMultipartFormData;
begin
  Result := FFormData;
end;

function TtgCoreApiBase.GetOnError: TProc<Exception>;
begin
  Result := FOnError;
end;

function TtgCoreApiBase.GetOnReceive: TProc<string>;
begin
  Result := FOnReceive;
end;

function TtgCoreApiBase.GetOnSend: TProc<string, string>;
begin
  Result := FGetOnSend;
end;

function TtgCoreApiBase.GetUrl: string;
begin
  Result := SERVER + FToken + '/' + FMethod;
end;

function TtgCoreApiBase.IsEmpty: Boolean;
begin
  Result := FIsEmpty;
end;

procedure TtgCoreApiBase.SetDataExtractor(const Value: TFunc<string, string>);
begin
  FDataExtractor := Value;
end;

procedure TtgCoreApiBase.SetHttp(const Value: IcuHttpClient);
begin
  FHttp := Value;
  FFormData := FHttp.CreateMultipartFormData;
end;

function TtgCoreApiBase.SetMethod(const AMethod: string): ItgRequestAPI;
begin
  FMethod := AMethod;
  Result := Self;
end;

procedure TtgCoreApiBase.SetOnError(const Value: TProc<Exception>);
begin
  FOnError := Value;
end;

procedure TtgCoreApiBase.SetOnReceive(const Value: TProc<string>);
begin
  FOnReceive := Value;
end;

procedure TtgCoreApiBase.SetOnSend(const Value: TProc<string, string>);
begin
  FGetOnSend := Value;
end;

function TtgCoreApiBase.SetToken(const AToken: string): ItgRequestAPI;
begin
  FToken := AToken;
  Result := Self;
end;

function TtgCoreApiBase.StreamToString(Stream: TStream): string;
var
  LStrings: TStringList;
begin
  LStrings := TStringList.Create;
  try
    Stream.Position := 0;
    LStrings.LoadFromStream(Stream);
    Result := LStrings.Text;
  finally
    LStrings.Free;
  end;
end;

{ TtgCoreApiSysNet }

constructor TtgCoreApi.Create;
begin
  inherited Create(nil);
end;

destructor TtgCoreApi.Destroy;
begin
  inherited;
end;

function TtgCoreApi.DoGet: string;
begin
  try
    Result := FHttp.Get(Url).ContentAsString;
    if Assigned(OnSend) then
      OnSend(Url, '');
  except
    on E: Exception do
    begin
      Result := '';
      DoHaveException(E);
    end;
  end;
end;

function TtgCoreApi.DoPost: string;
begin
  try
    Result := FHttp.Post(Url, FFormData).ContentAsString;
    if Assigned(OnSend) then
      OnSend(Url, StreamToString(FFormData.Stream));
  except
    on E: Exception do
    begin
      Result := '';
      DoHaveException(E);
    end;
  end;

end;

function TtgCoreApi.Execute: string;
begin
  if IsEmpty then
  begin
    Result := DoGet;
  end
  else
  begin
    Result := DoPost;
    ClearParameters;
  end;
  if Result = '' then
    Exit;
  LastRequestIsOk := True;
  if Assigned(OnReceive) then
    OnReceive(Result);
  if Assigned(DataExtractor) then
    Result := DataExtractor(Result);
end;

function TtgCoreApiBase.AddParameter(const AKey: string; const AValue,
  ADefaultValue: TDateTime; const ARequired: Boolean): ItgRequestAPI;
begin
  Result := AddParameter(AKey, DateTimeToUnix(AValue, False).ToString,
    DateTimeToUnix(ADefaultValue, False).ToString, ARequired);
end;

function TtgCoreApiBase.AddParameter(const AKey: string; const AValue,
  ADefaultValue: TtgFileToSend; const ARequired: Boolean): ItgRequestAPI;
begin
  case AValue.Tag of
    TtgFileToSendTag.FromStream:
      AddRawStream(AKey, AValue.Content, AValue.Data);
    TtgFileToSendTag.FromFile:
      AddRawFile(AKey, AValue.Data);
    TtgFileToSendTag.ID, TtgFileToSendTag.FromURL:
      AddRawField(AKey, AValue.Data);
  else
    raise Exception.Create('Cant convert TTgFileToSend: Unknown prototype tag');
  end;
end;

function TtgCoreApiBase.AddParameter(const AKey: string; const AValue,
  ADefaultValue: TtgUserLink; const ARequired: Boolean): ItgRequestAPI;
begin
  Result := AddParameter(AKey, AValue.ToString, ADefaultValue.ToString, ARequired);
end;

function TtgCoreApiBase.AddParameter(const AKey: string; const AValue,
  ADefaultValue: TObject; const ARequired: Boolean): ItgRequestAPI;
begin
  Result := AddParameter(AKey, TJson.ObjectToJsonString(AValue), //
    TJson.ObjectToJsonString(ADefaultValue), ARequired);
end;

function TtgCoreApiBase.AddParameter(const AKey: string; const AValue,
  ADefaultValue, ARequired: Boolean): ItgRequestAPI;
begin
  Result := AddParameter(AKey, AValue.ToString, ADefaultValue.ToString, ARequired);
end;

function TtgCoreApiBase.AddParameter(const AKey: string; const AValue,
  ADefaultValue: Single; const ARequired: Boolean): ItgRequestAPI;
begin
  Result := AddParameter(AKey, AValue.ToString, ADefaultValue.ToString, ARequired);
end;

end.

