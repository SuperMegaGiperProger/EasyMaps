unit MainUnit;

interface

uses
  GraphUnit, DrawUnit, EdgeUnit;

procedure main;

implementation

procedure main;
var
  a: array[0..100] of TVertexPt;
  e: array[0..100] of TEdgePt;
begin
  a[0] := createVertex(53.910859, 27.595669); //4
  a[1] := createVertex(53.913288, 27.600737); //dion
  a[2] := createVertex(53.919622, 27.593140); //2
  a[3] := createVertex(53.916783, 27.586027); //cym
  a[4] := createVertex(53.916209, 27.584859); //M
  a[5] := createVertex(53.914977, 27.589140); //copir

  e[1] := createEdge(a[0], a[1], 443, car, nil, true);
  //createEdge(a[0], a[1], 443, foot, e[1]^.road, true);
  createRoadVertex(e[1]^.road^, 53.910859, 27.595669);
  createRoadVertex(e[1]^.road^, 53.911624, 27.596930);
  createRoadVertex(e[1]^.road^, 53.913288, 27.600737);

  e[2] := createEdge(a[2], a[1], 863, car);
  //createEdge(a[2], a[1], 863, foot, e[2]^.road, true);
  createRoadVertex(e[2]^.road^, 53.913288, 27.600737);
  createRoadVertex(e[2]^.road^, 53.919622, 27.593140);

  e[3] := createEdge(a[2], a[3], 560, car, nil, true);
  //createEdge(a[2], a[3], 560, foot, e[3]^.road, true);
  createRoadVertex(e[3]^.road^, 53.919622, 27.593140);
  createRoadVertex(e[3]^.road^, 53.916783, 27.586027);

  e[4] := createEdge(a[5], a[3], 295, car);
  //createEdge(a[5], a[3], 295, foot, e[4]^.road, true);
  createRoadVertex(e[4]^.road^, 53.916783, 27.586027);
  createRoadVertex(e[4]^.road^, 53.914977, 27.589140);

  e[5] := createEdge(a[3], a[4], 105, car, nil, true);
  //createEdge(a[3], a[4], 105, foot, e[5]^.road, true);
  createRoadVertex(e[5]^.road^, 53.916783, 27.586027);
  createRoadVertex(e[5]^.road^, 53.916565, 27.585428);
  createRoadVertex(e[5]^.road^, 53.916209, 27.584859);

  e[6] := createEdge(a[0], a[5], 630, car);
  //createEdge(a[0], a[5], 630, foot, e[6]^.road, true);
  createRoadVertex(e[6]^.road^, 53.914977, 27.589140);
  createRoadVertex(e[6]^.road^, 53.910859, 27.595669);

  e[7] := createEdge(a[4], a[5], 336, foot, nil, true);
  createRoadVertex(e[7]^.road^, 53.916209, 27.584859);
  createRoadVertex(e[7]^.road^, 53.916172, 27.585170);
  createRoadVertex(e[7]^.road^, 53.915526, 27.586458);
  createRoadVertex(e[7]^.road^, 53.915323, 27.587917);
  createRoadVertex(e[7]^.road^, 53.914753, 27.588861);
  createRoadVertex(e[7]^.road^, 53.914977, 27.589140);

  scale := 0.00005;
  //drawGraph(1 / 10000, 53.910, 27.58);
  //createVertex();
end;

end.
