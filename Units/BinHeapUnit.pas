unit BinHeapUnit;

//----------------------------------------------------------------------------//

interface

type
  TCompare = function (a, b: Pointer): boolean;
  TBinHeap = record
    arr: array of Pointer;
    size, memSize, dMemory: integer;
    compare: TCompare;
  end;
  TBinHeapPt = ^TBinHeap;

function createBinHeap(compare: TCompare; dMemory: integer = 20): TBinHeap;
procedure push(var heap: TBinHeap; data: Pointer; disposeMem: boolean = false); overload;
function pop_top(var heap: TBinHeap): Pointer; overload;
function top(heap: TBinHeap): Pointer; overload;
function isEmpty(heap: TBinHeap): boolean; overload;
procedure clear(var heap: TBinHeap); overload;
procedure siftUp(var heap: TBinHeap; i: integer);
procedure siftDown(var heap: TBinHeap; i: integer = 0);

//----------------------------------------------------------------------------//

implementation

function createBinHeap(compare: TCompare; dMemory: integer = 20): TBinHeap;
begin
  result.dMemory := dMemory;
  result.compare := compare;
  with result do
  begin
    SetLength(arr, dMemory);
    memSize := dMemory;
    size := 0;
  end;
end;

procedure swap(var a, b: Pointer);
var
  t: Pointer;
begin
  t := a;
  a := b;
  b := t;
end;

procedure siftUp(var heap: TBinHeap; i: integer);
begin
  with heap do
  begin
    while (i > 0) and compare(arr[i], arr[(i - 1) div 2]) do
    begin
      swap(arr[i], arr[(i - 1) div 2]);
      i := (i - 1) div 2;
    end;
  end;
end;

procedure siftDown(var heap: TBinHeap; i: integer = 0);
var
  l, r, j: integer;
begin
  with heap do
  begin
    while i * 2 + 1 < size do
    begin
      l := i * 2 + 1;
      r := i * 2 + 2;
      j := l;
      if (r < size) and compare(arr[r], arr[l]) then j := r;
      if not compare(arr[j], arr[i]) then break;
      swap(arr[i], arr[j]);
      i := j;
    end;
  end;
end;

procedure push(var heap: TBinHeap; data: Pointer; disposeMem: boolean = false);
begin
  with heap do
  begin
    inc(size);
    if memSize < size then
    begin
      inc(memSize, dMemory);
      SetLength(arr, memSize);
    end;
    if disposeMem and (arr[size - 1] <> nil) then Dispose(arr[size - 1]);
    arr[size - 1] := data;
  end;
  siftUp(heap, heap.size - 1);
end;

function pop_top(var heap: TBinHeap): Pointer;
begin
  if isEmpty(heap) then exit;
  with heap do
  begin
    result := arr[0];
    swap(arr[0], arr[size - 1]);
    dec(size);
    siftDown(heap);
  end;
end;

function top(heap: TBinHeap): Pointer;
begin
  result := heap.arr[0];
end;

function isEmpty(heap: TBinHeap): boolean;
begin
  result := (heap.size <= 0);
end;

procedure clear(var heap: TBinHeap);
var
  i: integer;
begin
  with heap do
  begin
    for i := 0 to size - 1 do
      if arr[i] <> nil then Dispose(arr[i]);
    SetLength(arr, 0);
    size := 0;
    memSize := 0;
  end;
end;

//----------------------------------------------------------------------------//

end.
