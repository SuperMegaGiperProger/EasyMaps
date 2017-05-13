unit MapLoaderUnit;
      
//----------------------------------------------------------------------------//

interface

uses
  GraphUnit, Dialogs, HashUnit, SysUtils, GeoUnit;

var
  topBorder, bottomBorder, leftBorder, rightBorder: real;  // in Decart coord

function LoadMapFromFile(fileName: string): boolean;

//----------------------------------------------------------------------------//

implementation

function movingType(str: string): TMovingType;
begin
  result := foot;
  if str = 'car' then result := car
  else if str = 'plane' then result := plane;
end;

function LoadMapFromFile(fileName: string): boolean;
var
  f: TextFile;
  str: string;
  id: int64;
  lat, lon: real;
  v1, v2: TVertexPt;
  rev: boolean;
  width: byte;
  mov: TMovingType;
  maxLat, minLat, maxLon, minLon: real;
begin
  maxLat := -90;
  minLat := 90;
  maxLon := -180;
  minLon := 180;
  result := true;
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
        maximize(maxLat, lat);
        minimize(minLat, lat);
        maximize(maxLon, lon);
        minimize(minLon, lon);
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
      result := false;
      //on E : Exception do
        //ShowMessage(E.ClassName+' ошибка с сообщением : '+E.Message);
    end;
  except
    ShowMessage('Ошибка чтения файла');
    result := false;
  end;
  leftBorder := getXDecartCoordinates(minLon);
  rightBorder := getXDecartCoordinates(maxLon);
  bottomBorder := getYDecartCoordinates(minLat);
  topBorder := getYDecartCoordinates(maxLat);
end;

//----------------------------------------------------------------------------//

end.
 