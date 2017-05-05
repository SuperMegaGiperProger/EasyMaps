unit EdgeUnit;
 
//----------------------------------------------------------------------------//

interface

uses
  listOfPointersUnit;

type
  TRoadVertex = record
    latitude, longitude: real;
  end;
  TRoadGraph = TListOfPointers;  // list of TRoadVertex

//----------------------------------------------------------------------------//

implementation

//----------------------------------------------------------------------------//

end.
