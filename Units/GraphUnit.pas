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
  TGraphList = TListOfPointers;  // list of TVertex

procedure createVertex(latitude, longitude: real; edgesList: TListOfPointers);
function

//----------------------------------------------------------------------------//

implementation

//----------------------------------------------------------------------------//

end.
