unit GraphUnit;

interface

uses
  listOfPointersUnit;

type
  TVertex = record
    latitude, longitude: real; // ������, �������
    goList: TListOfPointers;   // �������, � ������� ���� �����
  end;
  TEdge = record
    movingType: (car, plane, foot);
    weight: real;              
  end;
  TGraphList = TListOfPointers;

implementation

end.
