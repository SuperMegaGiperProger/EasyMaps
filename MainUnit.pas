unit MainUnit;

interface

uses
  GraphUnit, DrawUnit, EdgeUnit;

procedure main;

implementation

procedure main;
var
  a: array[0..5] of TVertexPt;
  e: array[0..100] of TEdgePt;
begin
  a[0] := createVertex(53.910859, 27.595669);
  a[1] := createVertex(53.913288, 27.600737);
  a[2] := createVertex(53.919622, 27.593140);
  a[3] := createVertex(53.916783, 27.586027);
  a[4] := createVertex(53.916236, 27.584918);
  a[5] := createVertex(53.914751, 27.588748);

  e[1] := createEdge(a[0]^.edgesList, 450, car, a[1]);
  createRoadVertex(e[1]^.road, 53.910859, 27.595669);
  createRoadVertex(e[1]^.road, 53.9101274, 27.596225);
  createRoadVertex(e[1]^.road, 53.913288, 27.600737);

  //drawGraph(1 / 10000, 53.910, 27.58);
  //createVertex();
end;

end.
