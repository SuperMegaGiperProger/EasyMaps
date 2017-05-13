unit MapLoaderUnit;
      
//----------------------------------------------------------------------------//

interface

uses
  GraphUnit, Dialogs, HashUnit, SysUtils, GeoUnit;

procedure LoadMapFromFile(fileName: string);

//----------------------------------------------------------------------------//

implementation

function movingType(str: string): TMovingType;
begin
  result := foot;
  if str = 'car' then result := car
  else if str = 'plane' then result := plane;
end;

procedure LoadMapFromFile(fileName: string);
var
  f: TextFile;
  str: string;
  id: int64;
  lat, lon: real;
  v1, v2: TVertexPt;
  rev: boolean;
  width: byte;
  mov: TMovingType;
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
        id := StrToInt64(str);
        readln(f, lat);
        readln(f, lon);
        createVertex(lat, lon, id);
      end;
      if eof(f) then showMessage('endoffile');
      repeat
        readln(f, str);
      until str = 'edges';
      {# movingType(car, foot, plane)
      # weight(lanes number)(if foot then weight = 1)
      # reversed(oneway=no)
      # links
      # \n                                             }
      while not eof(f) do
      begin
        readln(f, str);
        if str = '' then continue;
        mov := movingType(str);
        readln(f, width);
        readln(f, str);
        rev := (str = 'True');
        readln(f, id);
        v1 := TVertexPt(get(mapGraph, id, correctVertex)^.data);
        while not eof(f) do
        begin
          readln(f, str);
          if str = '' then break;
          id := StrToInt64(str);
          v2 := TVertexPt(get(mapGraph, id, correctVertex)^.data);
          createEdge(v1, v2, distation(v1, v2), width, mov, rev);
          v1 := v2;
        end;
      end;
    except
      ShowMessage('Некорректный файл');
      //on E : Exception do
        //ShowMessage(E.ClassName+' ошибка с сообщением : '+E.Message);
    end;
  except
    ShowMessage('Ошибка чтения файла');
  end;
end;

//----------------------------------------------------------------------------//

end.
 