unit listOfPointersUnit;

//----------------------------------------------------------------------------//

interface

type
  TEltPt = ^TElt;
  TElt = record //элемент списка
    data: Pointer;
    next: TEltPt;
  end;
  TListOfPointers = TEltPt;
  TCompare = function (a, b: Pointer): boolean;

procedure push_top(var list: TListOfPointers; data: Pointer);
procedure pop_top(var list: TListOfPointers);
function isEmpty(var list: TListOfPointers): boolean;
procedure clear(var list: TListOfPointers);
procedure push(var list: TListOfPointers; data: pointer; compare: TCompare);
procedure push_back(var list: TListOfPointers; data: pointer);

//----------------------------------------------------------------------------//

implementation

procedure push_back(var list: TListOfPointers; data: pointer);
var
  it: TEltPt;
begin
  if list = nil then
  begin
    push_top(list, data);
    exit;
  end;
  it := list;
  while it^.next <> nil do
    it := it^.next;
  push_top(it^.next, data);
end;

procedure push(var list: TListOfPointers; data: pointer; compare: TCompare);
var
  it: TEltPt;
begin
  it := list;
  if not compare(it^.data, data) then
  begin
    push_top(list, data);
    exit;
  end;
  while (it^.next <> nil) and compare(it^.next^.data, data) do
    it := it^.next;
  push_top(it^.next, data);
end;

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

procedure clear(var list: TListOfPointers);
begin
  while not isEmpty(list) do pop_top(list);
end;

//----------------------------------------------------------------------------//

end.
