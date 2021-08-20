program jsontest01;

{$mode objfpc}{$H+}

uses
  fpjson,
  jsonparser,
  fphttpclient,
  opensslsockets,
  SysUtils;

const
  EVENT_LIST_URL =
    'https://raw.githubusercontent.com/pascal-id/Public-Data/master/data/events.json';

var
  rawData: ansistring;
  rawDataAsJson: TJSONData;
  events: TJSONArray;
  eventEnum: TJSONEnum;
  event: TJSONObject;

begin
  // Baca data json
  try
    rawData := TFPHTTPClient.SimpleGet(EVENT_LIST_URL);
  except
    on E: Exception do
    begin
      WriteLn('Gagal membaca sumber data: ' + E.Message);
      Exit;
    end;
  end;

  // Konversi data string menjadi object json
  try
    rawDataAsJson := GetJSON(rawData);
  except
    on E: Exception do
    begin
      WriteLn('Informasi tidak valid: ' + E.Message);
      Exit;
    end;
  end;

  // Tampilkan nama event, tanggal dan pemateri
  WriteLn('Daftar Event Pascal Indonesia');
  events := TJSONArray(rawDataAsJson.FindPath('data'));
  for eventEnum in events do
  begin
    event := TJSONObject(eventEnum.Value);
    WriteLn('- ' + event.Strings['name']);
    WriteLn('  Tanggal: ' + event.Strings['date']);
    WriteLn('  Pembicara: ' + event.FindPath('speaker[0].name').AsString);
  end;

end.
