unit MapLoaderUnit;
      
//----------------------------------------------------------------------------//

interface

uses
  GraphUnit, Dialogs, HashUnit, SysUtils, RoadUnit, GeoUnit;

procedure LoadMapFromFile(fileName: string);

//----------------------------------------------------------------------------//

implementation

procedure LoadMapFromFile(fileName: string);
var
  f: TextFile;
  str: string;
  id, prevId: integer;
  lat, lon: real;
  v1, v2: TVertexPt;
begin
  try
    Assign(f, fileName);
    Reset(f);
    try
      repeat
        readln(f, str);
      until str = 'vertices';
      while not eof(f) do
      begin
        readln(f, str);
        if str = '' then break;
        id := StrToInt(str);
        readln(f, lat);
        readln(f, lon);
        createVertex(lat, lon, id);
      end;
      repeat
        readln(f, str);
      until str = 'edges';
      while not eof(f) do
      begin
        readln(f, prevId);
        while not eof(f) do
        begin
          readln(f, str);
          if str = '' then break;
          id := StrToInt(str);
          v1 := TVertexPt(get(mapGraph, prevId, correctVertex)^.data);
          v2 := TVertexPt(get(mapGraph, id, correctVertex)^.data);
          createRoadVertex(createEdge(v1, v2, distation(v1, v2), foot, nil, true)^.road^,
            v2^.latitude, v2^.longitude);
          prevId := id;
        end;
      end;
    except
      ShowMessage('Некорректный файл');
    end;
  except
    ShowMessage('Ошибка чтения файла');
  end;
end;

//----------------------------------------------------------------------------//

end.
 