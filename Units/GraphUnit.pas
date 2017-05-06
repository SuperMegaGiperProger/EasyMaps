unit GraphUnit;

//----------------------------------------------------------------------------//

interface

uses
  listOfPointersUnit, EdgeUnit;

type
  TVertexPt = ^TVertex;
  TVertex = record
    latitude, longitude: real;  // coordinates
    edgesList: TListOfPointers;  // list of TEdge
    distation: real;  // distation to some vertex
    parent: TVertexPt;  // vertex from which we came
    used: boolean;  // flag
  end;
  TMovingType = (plane, car, foot);
  TMovingTypeSet = set of TMovingType;
  TEdge = record
    road: TRoadGraph;
    weight: real;  // in meters
    movingType: TMovingType;
    endPoint: TVertexPt;  // end of the edge
  end;
  TEdgePt = ^TEdge;
  TGraphList = TListOfPointers;  // list of TVertex

const
  INF = 1000000000;  // infinity way
var
  mapGraph: TGraphList = nil;

function createVertex(latitude, longitude: real): TVertexPt;
function createEdge(var list: TListOfPointers; weight: real;
  movingTYpe: TMovingType; endPoint: TVertexPt): TEdgePt;
function psevdoDistation(a, b: TVertex): real;  // "distation" in degrees
function getTheShortiestWay(s, f: TVertexPt;
  movingTypeSet: TMovingTypeSet = [car, foot, plane]): boolean;
  // return does way exist or not


//----------------------------------------------------------------------------//

implementation

procedure minDistationVertex(var a: TVertexPt; b: TVertexPt); // a := min(a, b);
begin
  if not b^.used and (a^.distation > b^.distation) then a := b;
end;

procedure relax(a, b: TVertexPt; weight: real);
begin
  if a^.distation > b^.distation + weight then
  begin
    a^.distation := b^.distation + weight;
    a^.parent := b;
  end;
end;

procedure preparation;
var
  it: TEltPt;
begin
  it := mapGraph;
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

function getTheShortiestWay(s, f: TVertexPt;
  movingTypeSet: TMovingTypeSet = [car, foot, plane]): boolean;
var
  it, edgeIt: TEltPt;
  minV: TVertexPt;  // vertex with min distation
  infV: TVertex;
begin
  preparation;
  result := false;
  s^.distation := 0;
  infV.distation := INF;
  infV.used := true;
  while not f^.used do
  begin
    it := mapGraph;
    minV := @infV;
    while it <> nil do
    begin
      minDistationVertex(minV, it^.data);
      it := it^.next;
    end;
    if minV^.used or (minV^.distation >= INF) then exit;
    if minV = f then
    begin
      result := true;
      exit;
    end;
    minV^.used := true;
    edgeIt := minV^.edgesList;
    while edgeIt <> nil do
    begin
      with TEdgePt(edgeIt^.data)^ do
        if (movingType in movingTypeSet) and not endPoint^.used then
          relax(endPoint, minV, weight);
      edgeIt := edgeIt^.next;
    end;
  end;
end;

function psevdoDistation(a, b: TVertex): real;
begin
  result := sqrt((a.latitude - b.latitude) * (a.latitude - b.latitude) +
    (a.longitude - b.longitude) * (a.longitude - b.longitude));
end;

function createEdge(var list: TListOfPointers; weight: real;
  movingTYpe: TMovingType; endPoint: TVertexPt): TEdgePt;
var
  newE: TEdgePt;
begin
  new(newE);
  newE^.weight := weight;
  newE^.movingType := movingType;
  newE^.endPoint := endPoint;
  push_top(list, newE);
  result := newE;
end;

function compareVertices(a, b: Pointer): boolean;
begin
  if TVertexPt(a)^.latitude = TVertexPt(b)^.latitude then
    result := (TVertexPt(a)^.longitude < TVertexPt(b)^.longitude)
  else
    result := (TVertexPt(a)^.latitude < TVertexPt(b)^.latitude);
end;

function createVertex(latitude, longitude: real): TVertexPt;
var
  newV: TVertexPt;
begin
  new(newV);
  newV^.latitude := latitude;
  newV^.longitude := longitude;
  with newV^ do
  begin
    edgesList := nil;
    parent := nil;
    used := false;
    distation := INF;
  end;
  push_top(mapGraph, newV);
  result := newV;
  //push(mapGraph, newV, compareVertices);
end;

//----------------------------------------------------------------------------//

end.
