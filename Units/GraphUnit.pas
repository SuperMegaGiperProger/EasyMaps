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
  TEdge = record
    road: TRoadGraph;
    weight: real;
    endPoint: TVertexPt;
  end;
  TGraphList = TListOfPointers;  // list of TVertex

var
  mapGraph: TGraphList = nil;

procedure createVertex(latitude, longitude: real);

//----------------------------------------------------------------------------//

implementation

function compareVertices(a, b: Pointer): boolean;
begin
  if TVertexPt(a)^.latitude = TVertexPt(b)^.latitude then
    result := (TVertexPt(a)^.longitude < TVertexPt(b)^.longitude)
  else
    result := (TVertexPt(a)^.latitude < TVertexPt(b)^.latitude);
end;

procedure createVertex(latitude, longitude: real);
var
  newV: TVertexPt;
begin
  new(newV);
  newV.latitude := latitude;
  newV.longitude := longitude;
  newV.edgesList := nil;
  push_top(mapGraph, newV);
  //push(mapGraph, compareVerticies);
end;

//----------------------------------------------------------------------------//

end.
