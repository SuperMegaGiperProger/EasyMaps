unit GraphUnit;

//----------------------------------------------------------------------------//

interface

uses
  listOfPointersUnit, EdgeUnit;

type
  TVertex = record
    latitude, longitude: real;
    edgesList: TListOfPointers;  // list of TEdge
    distation: real;  // distation to some vertex
  end;
  TVertexPt = ^TVertex;
  TMovingType = (plane, car, foot);
  TEdge = record
    road: TRoadGraph;
    weight: real;
    movingType: TMovingType;
    endPoint: TVertexPt;
  end;
  TEdgePt = ^TEdge;
  TGraphList = TListOfPointers;  // list of TVertex

var
  mapGraph: TGraphList = nil;

function createVertex(latitude, longitude: real): TVertexPt;
function createEdge(var list: TListOfPointers; weight: real; movingTYpe: TMovingType; endPoint: TVertexPt): TEdgePt;

//----------------------------------------------------------------------------//

implementation


function createEdge(var list: TListOfPointers; weight: real; movingTYpe: TMovingType; endPoint: TVertexPt): TEdgePt;
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
  newV^.edgesList := nil;
  push_top(mapGraph, newV);
  result := newV;
  //push(mapGraph, newV, compareVertices);
end;

//----------------------------------------------------------------------------//

end.
