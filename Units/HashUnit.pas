unit HashUnit;

//----------------------------------------------------------------------------//

interface

uses
  listOfPointersUnit, SysUtils, Dialogs;

type
  THashFunc = function (key: variant; HashStruct: variant): integer;
  TCorrectFunc = function (elt: TEltPt; key: array of variant): boolean;
    // is the element has the same key
  THashList = record
    table: array of TListOfPointers;
    hashFunc: THashFunc;
    size: integer;
  end;
  THashMatrix = record
    table: array of array of TListOfPointers;
    hashFunc: THashFunc;
    height, width: integer;
    minY, minX: real;
    k: integer;  // 1 / cellCapacity
  end;

const
  STANDART_HASH_TABLE_SIZE = 1000;

function standartHashFunc(key: variant; hashListSize: variant): integer; // O(1)
function createHashList(hashFunc: THashFunc{ = STANDART_HASH_FUNC};
  size: integer = STANDART_HASH_TABLE_SIZE): THashList;
function get(hashList: THashList; key: Variant; correct: TCorrectFunc):
  TEltPt; overload;
procedure push(hashList: THashList; key: Variant; data: Pointer); overload;
procedure clear(hashList: THashList); overload;
function createHashMatrix(height, width, k: integer; minX, minY: real;
  hashFunc: THashFunc): THashMatrix;
procedure clear(hashMatrix: THashMatrix); overload;
function matrixHashFunc(key: variant; hashMatrixK: variant): integer;  // O(1)
procedure push(hashMatrix: THashMatrix; key1, key2: Variant;
  data: Pointer); overload;
//function get(hashMatrix: THashMatrix; key1, key2: Variant;
  //correct: TCorrectFunc): TEltPt; overload;

//----------------------------------------------------------------------------//

implementation

procedure push(hashMatrix: THashMatrix; key1, key2: Variant; data: Pointer);
var
  i, j: integer;
begin
  with hashMatrix do
  begin
    i := HashFunc(key1 - minY, k);
    j := HashFunc(key2 - minX, k);
    if (i >= height) or (j >= width) then exit;
    push_top(table[i][j], data);
  end;
end;

function matrixHashFunc(key: variant; hashMatrixK: variant): integer;
var
  c: real;
  k: integer;
begin
  c := key;
  k := hashMatrixK;
  result := round(c * k);
end;

procedure clear(hashMatrix: THashMatrix);
var
  i, j: integer;
begin
  with hashMatrix do
  begin
    for i := 0 to height - 1 do
    begin
      for j := 0 to width - 1 do
        clear(table[i][j]);
      SetLength(table[i], 0);
    end;
    SetLength(table, 1);
    SetLength(table[0], 1);
    height := 1;
    width := 1;
  end;
end;

function createHashMatrix(height, width, k: integer; minX, minY: real;
  hashFunc: THashFunc): THashMatrix;
var
  i: integer;
begin
  result.height := height;
  result.width := width;
  result.hashFunc := hashFunc;
  result.k := k;
  result.minX := minX;
  result.minY := minY;
  try
    SetLength(result.table, height);
    for i := 0 to height - 1 do
      SetLength(result.table[i], width);
  except
    on EOutOfMemory do
      ShowMessage('������������ ������');
    else ShowMessage('������ ����������');
  end;
end;

procedure clear(hashList: THashList);
var
  i: integer;
begin
  with hashList do
  begin
    for i := 0 to size - 1 do clear(table[i]);
    size := 1;
    SetLength(table, 1);
  end;
end;

procedure push(hashList: THashList; key: Variant; data: Pointer);
begin
  push_top(hashList.table[hashList.hashFunc(key, hashList.size)], data);
end;

function get(hashList: THashList; key: Variant; correct: TCorrectFunc): TEltPt;
var
  it: TEltPt;
begin
  with hashList do
  begin
    it := table[hashFunc(key, size)];
    while (it <> nil) and not correct(it, [key]) do
      it := it^.next;
    result := it;
  end;
end;

function createHashList(hashFunc: THashFunc{ = STANDART_HASH_FUNC};
  size: integer = STANDART_HASH_TABLE_SIZE): THashList;
begin
  result.size := size;
  SetLength(result.table, size);
  result.hashFunc := hashFunc;
end;

function standartHashFunc(key: variant; hashListSize: variant): integer;
var
  k, s: int64;
begin
  k := key;
  s := hashListSize;
  result := k mod s;
end;

//----------------------------------------------------------------------------//

end.
