unit MapLoaderUnit;
      
//----------------------------------------------------------------------------//

interface

uses
  GraphUnit, Dialogs, HashUnit;

procedure LoadMapFromFile(fileName: string);

//----------------------------------------------------------------------------//

implementation

procedure LoadMapFromFile(fileName: string);
var
  f: TextFile;
  str: string;
  id, prevId: integer;
  lat, lon: real;
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
          createEdge(get(mapGraph, prevId,
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
 