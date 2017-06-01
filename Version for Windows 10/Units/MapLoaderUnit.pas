unit MapLoaderUnit;
      
//----------------------------------------------------------------------------//

interface

const
  MIN_CELL_CAPARCITY = 0.100;  // km  // cell in hash matrix

var
  memorySize: integer = 100 * 1024 * 1024;  // to store graph

function LoadMapFromFile(fileName: string; carLoad: boolean = true;
  footLoad: boolean = false): boolean;

//----------------------------------------------------------------------------//

implementation

uses
  GraphUnit, Dialogs, HashUnit, SysUtils, GeoUnit, ListOfPointersUnit, DrawUnit;

function min(a, b: real): real;
begin
  if a < b then result := a
  else result := b;
end;

function movingType(str: string): TMovingType;
begin
  result := foot;
  if str = 'car' then result := car
  else if str = 'plane' then result := plane;
end;

procedure printProgress(var f: textFile);
begin
  Form1.Gauge.Progress := trunc(FilePos(f) * 100.0 / FileSize(f));
end;

function LoadMapFromFile(fileName: string; carLoad: boolean = true;
  footLoad: boolean = false): boolean;
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
  vertList: THashList;
  k, h, w: real;
  i: integer;
  it: TEltPt;
  v: TVertexPt;
  //cnt, j: integer;
begin
  Form1.Gauge.Progress := 0;
  Form1.Gauge.Visible := true;
  Form1.Label3.Visible := true;
  maxLat := -90;
  minLat := 90;
  maxLon := -180;
  minLon := 180;
  result := true;
  try
    vertList := createHashList(standartHashFunc);
    Assign(f, fileName);
    Reset(f);
    try
      repeat
        readln(f, str);
        printProgress(f);
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
        createVertex(lat, lon, id, vertList);
        printProgress(f);
      end;
      //if eof(f) then showMessage('endoffile');
      repeat
        readln(f, str);
        printProgress(f);
      until str = 'edges';
      {# movingType(car, foot, plane)
      # weight(lanes number)(if foot then weight = 1)
      # reversed(oneway=no)
      # links
      # \n                                           }
      while not eof(f) do
      begin
        readln(f, str);
        if str = '' then continue;
        mov := movingType(str);
        readln(f, width);
        readln(f, str);
        rev := (str = 'True');
        readln(f, id);
        v1 := TVertexPt(get(vertList, id, correctVertexId)^.data);
        while not eof(f) do
        begin
          readln(f, str);
          printProgress(f);
          if str = '' then break;
          if (mov = car) and not carLoad then continue;
          if (mov = foot) and not footLoad then continue;
          id := StrToInt64(str);
          v2 := TVertexPt(get(vertList, id, correctVertexId)^.data);
          createEdge(v1, v2, distation(v1, v2), width, mov, rev);
          maximize(MAX_DRAWING_RADIUS, distation(v1, v2));
          v1^.used := true;
          v2^.used := true;
          v1 := v2;
        end;
      end;
      CloseFile(f);
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
  //// creating hash matrix
  Form1.Gauge.Progress := 0;
  leftBorder := getXDecartCoordinates(minLon);
  rightBorder := getXDecartCoordinates(maxLon);
  bottomBorder := getYDecartCoordinates(minLat);
  topBorder := getYDecartCoordinates(maxLat);
  h := topBorder - bottomBorder;  // height = max(cy) - min(cy)
  w := rightBorder - leftBorder;  // width = max(cx) - min(cx)
  k := trunc(sqrt((memorySize div SizeOf(TListOfPointers)) / (h * w)));
    // k = trunc(mem / S)  // S = height * width  // k = 1 / cell capacity
  minimize(k, 1 / MIN_CELL_CAPARCITY);
  w := w * k;
  h := h * k;
  mapGraph := CreateHashMatrix(trunc(h) + 1, trunc(w) + 2, trunc(k),
    leftBorder, bottomBorder, matrixHashFunc);
  //// filling in matrix
  for i := 0 to vertList.size - 1 do
  begin
    it := vertList.table[i];
    while it <> nil do
    begin
      v := TVertexPt(it^.data);
      it := it^.next;
      if not v^.used then continue;
      push(mapGraph, getYDecartCoordinates(v^.latitude),
        getXDecartCoordinates(v^.longitude), v);
    end;
    Form1.Gauge.Progress := trunc((i + 1) * 100.0 / vertList.size);
  end;
  clear(vertList);
  Form1.Gauge.Visible := false;
  ///// recommended drawing radius
  Form1.TrackBarDrawingRadius.SelEnd := round(50 / (MAX_DRAWING_RADIUS -
    MIN_DRAWING_RADIUS));
  Form1.TrackBarDrawingRadius.SelStart := round(10 / (MAX_DRAWING_RADIUS -
    MIN_DRAWING_RADIUS));
  DRAWING_RADIUS := min(0.274, MAX_DRAWING_RADIUS);
  Form1.TrackBarDrawingRadius.Position := round(100.0 * DRAWING_RADIUS /
    (MAX_DRAWING_RADIUS - MIN_DRAWING_RADIUS));
  ///// center of map
  x0 := (rightBorder + leftBorder) / 2.0 - Form1.mapImage.Width * scale / 2.0;
  y0 := (topBorder + bottomBorder) / 2.0 + Form1.mapImage.Height * scale / 2.0;
  {cnt := 0;
  for i := 0 to mapGraph.height - 1 do
    for j := 0 to mapGraph.width - 1 do
      if mapGraph.table[i][j] <> nil then inc(cnt);
  ShowMessage(FloatToStr(cnt * 100.0 / (mapGraph.height * mapGraph.width)) + ' %');}
end;

//----------------------------------------------------------------------------//

end.
