unit GraphUnit;

interface

uses
  listOfPointersUnit;

type
  TVertex = record
    latitude, longitude: real;  // широта, долгота
    edgesList: TListOfPointers;  // ребра из данной вершины
  end;
  TVertexPt = ^TVertex;
  TEdge = record
    movingType: (car, plane, foot);
    weight: real;  // вес ребра
    endPoint: TVertexPt;  // вершина, в которую ведет это ребро
  end;
  TGraphList = TListOfPointers;

implementation

end.
