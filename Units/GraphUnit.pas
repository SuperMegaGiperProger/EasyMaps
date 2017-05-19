unit GraphUnit;

//----------------------------------------------------------------------------//

interface

uses
  listOfPointersUnit, Dialogs, BinHeapUnit, hashUnit, SysUtils, Math;

type
  TVertexPt = ^TVertex;
  TVertex = record
    id: int64;
    latitude, longitude: real;  // coordinates
    edgesList: TListOfPointers;  // list of TEdge
    distation: real;  // distation to some vertex
    parent: TVertexPt;  // vertex from which we came
    used: boolean;  // flag
  end;
  TMovingType = (plane, car, foot);
  TMovingTypeSet = set of TMovingType;
  TEdge = record
    weight: real;  // in meters
    width: byte;  // only for drawing
    movingType: TMovingType;
    startPoint: TVertexPt;
    endPoint: TVertexPt;
  end;
  TEdgePt = ^TEdge;
  TGraphList = THashMatrix;  // list of TVertex

const
  INF = 1000000000;  // infinity way
var
  mapGraph: TGraphList;  // main map graph
  vertexNum: Int64 = 0;
  EdgeNum: Int64 = 0;


function createVertex(latitude, longitude: real; id: int64;
  var list: THashList): TVertexPt;
  // put vertex in list
function createEdge(a, b: TVertexPt; weight: real; width: byte;
  movingTYpe: TMovingType; reversible: boolean = false): TEdgePt;  // O(1)
function getTheShortestWay(s, f: TVertexPt; out distation: real;
  out way: TListOfPointers; movingTypeSet: TMovingTypeSet = [car, foot, plane]):
  boolean;
  // func return does way exist or not
  // O(m log n)  // because graph is rarefied
function getTheShortestWayThroughSeveralPoints(point: array of TVertexPt;
  out distation: real; out way: TListOfPointers; startB: boolean = false;
  finishB: boolean = false; movingTypeSet: TMovingTypeSet = [car, foot, plane]):
  boolean;  // startB = is point[0] must be first on way
  // finishB = is point[size - 1] must be last on way
  // func return does way exist or not
  // O(n^2 * 2^n + n^2 * O(getTheShortestWay))  // memory O(n * 2^n)
function correctVertexId(elt: TEltPt; key: array of Variant): boolean;
//function

//----------------------------------------------------------------------------//

implementation

uses
  DrawUnit;

function correctVertexId(elt: TEltPt; key: array of Variant): boolean;
begin
  result := (TVertexPt(elt^.data)^.id = key[0]);
end;

type
  TGamiltonWay = record
    i: integer;  // start position
    mask: integer;  // mask of unchecked vertices
    mask0: integer;  // way consist of this vertices
  end;
  TGamiltonWayPt = ^TGamiltonWay;

function getGamiltonWayPt(i, mask0: integer; dmask: integer = 0): TGamiltonWayPt;
begin
  new(result);
  result^.i := i;
  result^.mask0 := mask0;
  result^.mask := mask0 - dmask;
end;

function min(var a: real; b: real): boolean;  // a := min(a, b);
begin
  result := (a > b);
  if result then a := b;
end;

procedure printProgress(part, full: int64);
begin
  Form1.Gauge.Progress := trunc(part * 100.0 / full);
end;

function getTheShortestWayThroughSeveralPoints(point: array of TVertexPt;
  out distation: real; out way: TListOfPointers; startB: boolean = false;
  finishB: boolean = false; movingTypeSet: TMovingTypeSet = [car, foot, plane]):
  boolean;
  // looks through all gamilton ways and chooses the shortest
  // progress output isn't usefull, it is just to show to user, that process goes 
var
  g: array of array of real;  // adjacency matrix
  used: array of array of boolean;  // is gamilton way was used
  d: array of array of real;  // gamilton way length
  wayPart: array of array of TListOfPointers;  // way from point[i] to point[j]
  next: array of array of integer;  // next vertex
  stack: TListOfPointers;
  it: TGamiltonWayPt;
  n, i, i0, j, mask, mask00, start, finish: integer;  // n = point number
  lastStart: integer;  // last start point which func looks through
  fn: integer;  // "false" n  // fn = point number, which func looks throught
  iterationNum: int64;  // sum of cycles iterations number
  iterationCount: int64;
begin
result := false;
try
  ////preparation
  Form1.Gauge.Progress := 0;
  n := length(point);
  if n <= 1 then
  begin
    result := true;
    exit;
  end;
  SetLength(g, n);
  SetLength(used, n);
  SetLength(d, n);
  SetLEngth(wayPart, n);
  SetLength(next, n);
  stack := nil;
  distation := INF;
  start := 0;
  finish := n - 1;
  if startB then lastStart := 0
  else lastStart := finish;
  if finishB then
  begin
    fn := n - 1;
    if finish - 1 < lastStart then lastStart := finish - 1;
  end else fn := n;
  iterationNum := n * round(n * edgeNum * log2(vertexNum) + (1 shl n)) + (lastStart + 1) * fn * (1 shl fn) + fn;
  iterationCount := 0;
  printProgress(iterationCount, iterationNum);
  ////creating graph
  for i := 0 to n - 1 do
  begin
    SetLength(g[i], n);
    SetLength(used[i], 1 shl n);
    SetLength(d[i], 1 shl n);
    SetLEngth(wayPart[i], n);
    SetLength(next[i], 1 shl n);
    for j := 0 to n - 1 do getTheShortestWay(point[i], point[j], g[i][j],
      wayPart[i][j], movingTypeSet);
    inc(iterationCount, round(n * edgeNum * log2(vertexNum)));
    printProgress(iterationCount, iterationNum);
    for mask := 0 to (1 shl n) - 1 do
    begin
      d[i][mask] := INF;
      used[i][mask] := false;
      next[i][mask] := -1;
    end;
    inc(iterationCount, (1 shl n));
    printProgress(iterationCount, iterationNum);
    if finishB then d[i][0] := g[i][finish]
    else d[i][0] := 0;
  end;
  ////getting the shortes way throught fn points which starts in i0
  for i0 := 0 to lastStart do
  begin
    mask00 := (1 shl fn) - 1 - (1 shl i0);
    if not used[i0][mask00] then
    begin
      clear(stack);
      push_top(stack, getGamiltonWayPt(i0, mask00));
      while not isEmpty(stack) do
      begin
        it := stack^.data;
        if used[it^.i][it^.mask0] then
        begin
          pop_top(stack);
          continue;
        end;
        for j := 0 to fn - 1 do
          if (it^.mask and (1 shl j)) <> 0 then
            if used[j][it^.mask0 - (1 shl j)] then
            begin
              if min(d[it^.i][it^.mask0], d[j][it^.mask0 - (1 shl j)]
                 + g[it^.i][j]) then
                 next[it^.i][it^.mask0] := j;
              dec(it^.mask, 1 shl j);  // because func considered j point
            end
            else
              push_top(stack, getGamiltonWayPt(j, it^.mask0 - (1 shl j)));
        if it^.mask = 0 then used[it^.i][it^.mask0] := true;
      end;
    end;
    if distation > d[i0][mask00] then
    begin
      distation := d[i0][mask00];
      start := i0;
    end;
    inc(iterationCount, fn * (1 shl fn));
    printProgress(iterationCount, iterationNum);
  end;
  clear(stack);
  result := (distation < INF);
  if not result then exit; //print 100 %
  /////getting way
  way := nil;
  i := start;
  mask := (1 shl fn) - 1 - (1 shl start);
  {while mask <> 0 do
    for j := 0 to fn - 1 do
      if ((mask and (1 shl j)) <> 0) and
        (d[i][mask] = d[j][mask - (1 shl j)] + g[i][j]) then
      begin
        push_top(way, wayPart[i][j]);
        i := j;
        dec(mask, 1 shl j);
        break;
      end;}
  for j := 0 to fn - 2 do
  begin
    if next[i][mask] = -1 then
    begin
      result := false;
      exit;
    end;
    push_top(way, wayPart[i][next[i][mask]]);
    i := next[i][mask];
    dec(mask, 1 shl i);
    inc(iterationCount);
    printProgress(iterationCount, iterationNum);
  end;
  if finishB then push_top(way, wayPart[i][finish]);
except
  on EOutOfMemory do
    ShowMessage('Недостаточно памяти, выберите меньше пунктов следования.');
  else ShowMessage('Ошибка исполнения');
end;
end;

procedure preparationForGettingTheShortestWay;
var
  it: TEltPt;
  i, j: integer;
begin
  for i := 0 to mapGraph.height - 1 do
    for j := 0 to mapGraph.width - 1 do
    begin
      it := mapGraph.table[i][j];
      while it <> nil do
      begin
        with TVertexPt(it^.data)^ do
       begin
          parent := nil;
          used := false;
          distation := INF;
        end;
        it := it^.next;
      end;
    end;
end;

type
  TWayVertex = record
    distation: real;
    vertPt: TVertexPt;
  end;
  TWayVertexPt = ^TWayVertex;

function compVerticesByDist(a, b: Pointer): boolean;
begin
  result := (TWayVertexPt(a)^.distation < TWayVertexPt(b)^.distation);
end;

function create(v: TVertexPt; d: real): TWayVertexPt;
begin
  new(result);
  with result^ do
  begin
    vertPt := v;
    distation := d;
  end;
end;

function getTheShortestWay(s, f: TVertexPt; out distation: real;
  out way: TListOfPointers; movingTypeSet: TMovingTypeSet = [car, foot, plane]):
  boolean;
var
  itV2, edgeIt: TEltPt;
  itV: TVertexPt;
  minV: TVertexPt;  // vertex with min distation
  heap: TBinHeap;
begin
  if Form1.CheckBoxFootRoad.Checked and (foot in movingTypeSet) then
    include(movingtypeset, car);
  preparationForGettingTheShortestWay;
  result := false;
  way := nil;
  s^.distation := 0;
  heap := createBinHeap(compVerticesByDist, 1000);
  push(heap, create(s, 0));
  ////searching the shortest way
  while not isEmpty(heap) do
  begin
    minV := TWayVertexPt(pop_top(heap))^.vertPt;
    if minV^.distation >= INF then exit;
    if minV^.used then continue;
    if minV = f then
    begin
      result := true;
      break;
    end;
    minV^.used := true;
    edgeIt := minV^.edgesList;
    while edgeIt <> nil do
    begin
      with TEdgePt(edgeIt^.data)^ do  // relaxation
        if (movingType in movingTypeSet)
          and (endPoint^.distation > minV^.distation + weight) then
        begin
          endPoint^.distation := minV^.distation + weight;
          endPoint^.parent := minV;
          push(heap, create(endPoint, endPoint^.distation), true);
        end;
      edgeIt := edgeIt^.next;
    end;
  end;
  clear(heap, true);
  distation := f^.distation;
  if not result then exit;
  ////restoring way
  itV := f;
  while itV^.parent <> nil do
  begin
    itV2 := itV^.parent^.edgesList;
    while (itV2 <> nil) and ((TEdgePt(itV2^.data)^.endPoint <> itV) or
      not (TEdgePt(itV2^.data)^.movingType in movingTypeSet)) do
      itV2 := itV2^.next;
    if (itV2 = nil) or (TEdgePt(itV2^.data)^.endPoint <> itV) then
    begin
      showMessage('Output error');
      exit;
    end;
    push_top(way, itV2^.data);
    itV := itV^.parent;
  end;
end;

function createEdge(a, b: TVertexPt; weight: real; width: byte;
  movingTYpe: TMovingType; reversible: boolean = false): TEdgePt;
var
  newE: TEdgePt;
begin
  new(newE);
  newE^.weight := weight;
  newE^.width := width;
  newE^.movingType := movingType;
  newE^.startPoint := a;
  newE^.endPoint := b;
  push_top(a^.edgesList, newE);
  result := newE;
  if reversible then
    createEdge(b, a, weight, width, movingType);
  inc(EdgeNum);
  //if movingType = car then createEdge(a, b, weight, 1, foot, true);
end;

function compareVertices(a, b: Pointer): boolean;
begin
  if TVertexPt(a)^.latitude = TVertexPt(b)^.latitude then
    result := (TVertexPt(a)^.longitude < TVertexPt(b)^.longitude)
  else
    result := (TVertexPt(a)^.latitude < TVertexPt(b)^.latitude);
end;

function createVertex(latitude, longitude: real; id: int64;
  var list: THashList): TVertexPt;
var
  newV: TVertexPt;
begin
  new(newV);
  newV^.latitude := latitude;
  newV^.longitude := longitude;
  newV^.id := id;
  newV^.used := false;
  with newV^ do
  begin
    edgesList := nil;
    parent := nil;
    used := false;
    distation := INF;
  end;
  push(list, newV^.id, newV);
  result := newV;
  inc(vertexNum);
  //push(mapGraph, newV, compareVertices);
end;

//----------------------------------------------------------------------------//

end.
