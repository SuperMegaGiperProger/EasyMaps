unit listOfPointers;

//----------------------------------------------------------------------------//

interface

type
  TEltPt = ^TElt;
  TElt = record //элемент списка
    data: Pointer;
    next: TEltPt;
  end;
  TListOfPointers = TEltPt;

procedure push_top(var list: TListOfPointers; data: Pointer);
procedure pop_top(var list: TListOfPointers);
function isEmpty(var list: TListOfPointers): boolean;

//----------------------------------------------------------------------------//

implementation

procedure push_top(var list: TListOfPointers; data: Pointer);
var
  newEltPt: TEltPt;
begin
  new(newEltPt);
  newEltPt^.data := data;
  newEltPt^.next := list;
  list := newEltPt;
end;

procedure pop_top(var list: TListOfPointers);
var
  delEltPt: TEltPt;
begin
  if isEmpty(list) then exit;
  delEltPt := list;
  list := list^.next;
  Dispose(delEltPt);
end;

function isEmpty(var list: TListOfPointers): boolean;
begin
  isEmpty := (list = nil);
end;

end.
