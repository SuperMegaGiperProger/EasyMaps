unit EdgeUnit;
 
//----------------------------------------------------------------------------//

interface

uses
  listOfPointersUnit;

type
  TRoadVertex = record
    latitude, longitude: real;
  end;
  TRoadVertexPt = ^TRoadVertex;
  TRoadGraph = TListOfPointers;  // list of TRoadVertex

procedure createRoadVertex(var list: TListOfPointers; latitude, longitude: real);

//----------------------------------------------------------------------------//

implementation

procedure createRoadVertex(var list: TListOfPointers; latitude, longitude: real);
var
  newV: TRoadVertexPt;
begin
  new(newV);
  newV^.latitude := latitude;
  newV^.longitude := longitude;
  push_top(list, newV);
end;

//----------------------------------------------------------------------------//

end.
