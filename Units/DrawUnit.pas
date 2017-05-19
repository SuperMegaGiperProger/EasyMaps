unit DrawUnit;

//----------------------------------------------------------------------------//

interface                   

uses
  HashUnit, GeoUnit, MapLoaderUnit, GraphUnit, listOfPointersUnit,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ShellAPI,  Math, Gauges, ExtCtrls, StdCtrls, Buttons, ComCtrls,
  ColorGrd;

type
  TForm1 = class(TForm)
    mapImage: TImage;
    BitBtn4: TBitBtn;
    Label1: TLabel;
    Label2: TLabel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    Gauge: TGauge;
    LoadBtn: TBitBtn;
    GroupBox1: TGroupBox;
    CheckBoxStart: TCheckBox;
    CheckBoxFinish: TCheckBox;
    BitBtn2: TBitBtn;
    GroupBox2: TGroupBox;
    CheckBoxCar: TCheckBox;
    CheckBoxFoot: TCheckBox;
    Label3: TLabel;
    ComboBoxCity: TComboBox;
    BitBtn1: TBitBtn;
    BitBtn3: TBitBtn;
    LabelDist: TLabel;
    GroupBox3: TGroupBox;
    GroupBoxLoad: TGroupBox;
    CheckBoxCarLoad: TCheckBox;
    CheckBoxFootLoad: TCheckBox;
    BitBtn5: TBitBtn;
    SettingsBtn: TBitBtn;
    GroupBoxSettings: TGroupBox;
    TrackBarDrawingRadius: TTrackBar;
    BitBtn6: TBitBtn;
    Label4: TLabel;
    Label5: TLabel;
    CheckBoxFootRoad: TCheckBox;
    ColorGridRoads: TColorGrid;
    Label6: TLabel;
    Label7: TLabel;
    ColorGridWay: TColorGrid;
    ColorGridBackground: TColorGrid;
    Label8: TLabel;
    Label9: TLabel;
    ColorGridArrow: TColorGrid;
    procedure LoadBtnClick(Sender: TObject);
    procedure mapImageMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure Label2Click(Sender: TObject);
    procedure Label2MouseEnter(Sender: TObject);
    procedure Label2MouseLeave(Sender: TObject);
    procedure mapImageMouseMove(Sender: TObject; Shift: TShiftState; X,
      Y: Integer);
    procedure mapImageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
      MousePos: TPoint; var Handled: Boolean);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth,
      NewHeight: Integer; var Resize: Boolean);
    procedure FormActivate(Sender: TObject);
    procedure TrackBarDrawingRadiusChange(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn5Click(Sender: TObject);
    procedure SettingsBtnClick(Sender: TObject);
    procedure BitBtn6Click(Sender: TObject);
    procedure ColorGridRoadsChange(Sender: TObject);
    procedure ColorGridWayChange(Sender: TObject);
    procedure ColorGridBackgroundChange(Sender: TObject);
    procedure ColorGridArrowChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

const
  STANDART_WIDTH = 0.0032;
  MAX_SCALE = 0.01758;
  MIN_SCALE = 0.0005;
  MIN_DRAWING_RADIUS =  0.005;  // km

var
  Form1: TForm1;
  scale: real = 0.0058576146516;
  DRAWING_RADIUS: real = 0.274;  // km
  x0, y0: real;
  topBorder, bottomBorder, leftBorder, rightBorder: real;  // in Decart coord
  points: array of TVertexPt = nil;
  way: TListOfPointers = nil;
  MAX_DRAWING_RADIUS: real = 0.000;  // km  // depends on map


procedure drawGraph(x1, y1, x2, y2: real; clear: boolean = true);
procedure drawFullGraph;            
procedure drawRoad(edge: TEdge; direction: boolean = false);
procedure setComponentsVisible(v: boolean = true);
function findClosestVertex(X, Y: real): TVertexPt;

//----------------------------------------------------------------------------//

implementation

{$R *.dfm}

function getX(longitude: real): integer;
begin
  result := round((getXDecartCoordinates(longitude) - x0) / scale);
end;

function getY(latitude: real): integer;
begin
  result := round((y0 - getYDecartCoordinates(latitude)) / scale);
end;

///////////////////////// POINTS /////////////////////////////////
var
  pointPicture, deletePointPicture: TBitmap;
  pointAddition: boolean = true;

procedure addPoint(v: TVertexPt);
begin
  if v = nil then exit;
  SetLength(points, length(points) + 1);
  points[length(points) - 1] := v;
  way := nil;
  DrawFullGraph;
end;

procedure deletePoint(v: TVertexPt);
var
  i, n: integer;
begin
  n := length(points);
  for i := 0 to n - 1 do
    if points[i] = v then break;
  if i >= n then exit;
  for i := i + 1 to n - 1 do
    points[i - 1] := points[i];
  SetLength(points, n - 1);
  way := nil;
  DrawFullGraph;
end;

procedure drawPoint(x, y, num: integer; picture: TBitmap);
begin
  with Form1.mapImage.Canvas do
  begin
    Draw(x - picture.Width div 2, y - picture.Height, picture);
    Font.Name := 'Arial';
    Font.Style := [fsBold];
    Brush.Style := bsClear;
    TextOut(x - length(IntToStr(num)) * 3 - 1, y - 26, IntToStr(num));
  end;
end;

procedure clearPoint(x, y: integer);
begin
  with Form1.mapImage.Canvas do
  begin
    Pen.Style := psClear;
    Brush.Color := Form1.ColorGridBackground.ForegroundColor;
    Rectangle(x - pointPicture.Width div 2, y - pointPicture.Height,
      x + (pointPicture.Width + 1) div 2 + 1, y + 1);
    Pen.Style := psSolid;
    drawGraph(x0 + (x - pointPicture.Width div 2) * scale,
      y0 - y * scale, x0 + (x + (pointPicture.Width + 1) div 2 + 1) * scale,
      y0 - (y - pointPicture.Height) * scale, false);
  end;
end;

procedure drawPoints(point: array of TVertexPt);
var
  i: integer;
begin
  for i := 0 to length(point) - 1 do
    drawPoint(getX(point[i]^.longitude), getY(point[i]^.latitude), i + 1,
      pointPicture);
end;

procedure TForm1.BitBtn4Click(Sender: TObject);  // delete all
begin
  points := nil;
  way := nil;
  DrawFullGraph;
  pointAddition := true;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);  // delete
begin
  pointAddition := False;
end;

procedure TForm1.BitBtn3Click(Sender: TObject);
begin
  pointAddition := true;
end;

///////////////////////////// WAY /////////////////////////////
procedure drawArrow(x, y: integer; angle: real = 0; length: integer = 20);
var
  stx, sty: integer;
begin
  with Form1.mapImage.Canvas do
  begin
    stx := x - round(length * cos(angle) / 1.2);
    sty := y - round(length * sin(angle) / 1.2);
    angle := angle + pi / 2;
    Brush.Color := Pen.Color;
    Polygon([Point(x, y), Point(stx - round(length * cos(angle) / 3),
      sty - round(length * sin(angle) / 3)),
      Point(stx + round(length * cos(angle) / 3),
      sty + round(length * sin(angle) / 3))]);
  end;
end;      

procedure drawWay(way: TListOfPointers; direction: boolean = false);
var
  it, it2: TEltPt;
begin
  it2 := way;
  while it2 <> nil do
  begin
    it := TEltPt(it2^.data);
    while it <> nil do
    begin
      Form1.mapImage.Canvas.Pen.Color := Form1.ColorGridWay.ForegroundColor;
      drawRoad(TEdgePt(it^.data)^, direction);
      it := it^.next;
    end;
    it2 := it2^.next;
  end;
end;

////////////////////////////// ROADS /////////////////////////////////
procedure setStyle(edge: TEdge);
begin
  with Form1.mapImage.Canvas do
  begin
    case edge.movingType of
      car: Pen.width := round(edge.width * STANDART_WIDTH / scale);
      foot: Pen.width := round(edge.width * STANDART_WIDTH / scale);
    end;
  end;
end;

procedure drawRoad(edge: TEdge; direction: boolean = false);
var
  x1, x2, y1, y2, len: integer;
  angle: real;
begin
  setStyle(edge);
  if Form1.mapImage.Canvas.Pen.Width <= 0 then exit;
  x1 := getX(edge.startPoint^.longitude);
  y1 := getY(edge.startPoint^.latitude);
  x2 := getX(edge.endPoint^.longitude);
  y2 := getY(edge.endPoint^.latitude);
  if direction then
  begin
    len := 10;
    if sqrt((x1 - x2) * (x1 - x2) + (y1 - y2) * (y1 - y2)) < len + 20 then exit;
    if x1 = x2 then angle := pi / 2
    else angle := arctan((y2 - y1) * 1.0 / ((x2 - x1) * 1.0));
    if x2 - x1 < 0 then angle := angle + pi;
    Form1.mapImage.Canvas.Pen.Color := Form1.ColorGridArrow.ForegroundColor;
    Form1.mapImage.Canvas.Pen.Width := 2;
    drawArrow(x2 - (x2 - x1) div 2 + round((len + 15) * cos(angle) / 2),
      y2 - (y2 - y1) div 2 + round((len + 15) * sin(angle) / 2), angle, len);
    exit;
  end;
  with Form1.mapImage.Canvas do
  begin
    moveTo(x1, y1);
    lineTo(x2, y2);
  end;
end;

procedure drawAllRoads(v: TVertex);
var
  it: TEltPt;
  x, y: integer;
begin
  with Form1.mapImage.Canvas do
  begin
    x := getX(v.longitude);
    y := getY(v.latitude);
    it := v.edgesList;
    while it <> nil do
    begin
      setStyle(TEdgePt(it^.data)^);
      if Pen.Width > 0 then
        with TEdgePt(it^.data)^ do
        begin
          moveTo(x, y);
          lineTo(getX(endPoint.longitude), getY(endPoint.latitude));
        end;
      it := it^.next;
    end;
  end;
end;

/////////////////////////// GRAPH ///////////////////////////////
function findClosestVertex(X, Y: real): TVertexPt;
const
  SEARCHING_RADIUS = 20;  // px
var
  d, i, j: integer;
  closestVert: TVertexPt;
  it: TEltPt;
  mouseV, v: TVertex;
  l, r, t, b: integer;
begin
  result := nil;
  y := -y * scale + y0;
  x := x * scale + x0;
  mouseV.latitude := getLatitude(y);
  mouseV.longitude := getLongitude(x);
  with mapGraph do
  begin
    d := round(SEARCHING_RADIUS * scale * k);
    i := hashFunc(y - minY, k);
    j := hashFunc(x - minX, k);
    if (i >= height) or (j >= width) then exit;
    b := max(i - d, 0);
    t := min(i + d, height - 1);
    l := max(j - d, 0);
    r := min(j + d, width - 1);
    for i := b to t do
      for j := l to r do
      begin
        it := mapGraph.table[i][j];
        if it = nil then continue;
        closestVert := TVertexPt(it^.data);
        while it <> nil do
        begin
          v := TVertexPt(it^.data)^;
          if Distation(@v, @mouseV) < Distation(closestVert, @mouseV) then
            closestVert := it^.data;
          it := it^.next;
        end;
        if result = nil then result := closestVert
        else
          if Distation(closestVert, @mouseV) < Distation(result, @mouseV) then
            result := closestVert;
      end;
  end;
end;

function min(a, b: integer): integer;
begin
  if a < b then result := a
  else result := b;
end;

function max(a, b: integer): integer;
begin
  if a > b then result := a
  else result := b;
end;

procedure drawGraph(x1, y1, x2, y2: real; clear: boolean = true);
var
  it: TEltPt;
  v: TVertex;
  i, j: integer;
begin
  if clear then
  begin
    with Form1.mapImage do
    begin
      Canvas.Brush.Color := Form1.ColorGridBackground.ForegroundColor;
      Canvas.FillRect(Rect(0, 0, Width, Height));
    end;
  end;
  Form1.mapImage.Canvas.Pen.Color := Form1.ColorGridRoads.ForegroundColor;
  with mapGraph do
  begin
    for i := max(hashFunc(y1 - minY - DRAWING_RADIUS, k), 0) to
      min(hashFunc(y2 - minY + DRAWING_RADIUS, k), height - 1) do
    begin
      for j := max(hashFunc(x1 - minX - DRAWING_RADIUS, k), 0) to
        min(hashFunc(x2 - minX + DRAWING_RADIUS, k), width - 1) do
      begin
        it := mapGraph.table[i][j];
        while it <> nil do
        begin
          v := TVertexPt(it^.data)^;
          drawAllRoads(v);
          it := it^.next;
        end;
      end;
    end;
  end;
  drawWay(way);  // for first draw way
  drawWay(way, true);  // for second - direction, because way can be drew over
  drawPoints(points);
end;

procedure drawFullGraph;
begin
  drawGraph(x0, y0 - Form1.mapImage.Height * scale,
    x0 + Form1.mapImage.Width * scale, y0);
end;

procedure drawTheShortestWayTroughSeveralPoints(point: array of TVertexPt;
  start: boolean = false; finish: boolean = false;
  movingTypeSet: TMovingTypeSet = [car, foot, plane]);
var
  dist: real;
  exist: boolean;
begin
  Form1.Gauge.Visible := true;
  exist := getTheShortestWayThroughSeveralPoints(point, dist, way, start, finish, movingTypeSet);
  Form1.Gauge.Visible := false;
  if not exist then
  begin
    Form1.LabelDist.Caption := 'INF';
    ShowMessage('Путь не найден');
    exit;
  end;
  Form1.LabelDist.Caption := IntToStr(round(dist * 1000));
  drawFullgraph;
end;

///////////////////////////// MAP ////////////////////////////////////
var
  move, itWasMoving: boolean;
  xm, ym: integer;
  lastPointV: TVertexPt = nil;

procedure TForm1.mapImageMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
var
  prevX0, prevY0: real;
begin
  if not move then
  begin
    if lastPointV <> nil then clearPoint(getX(lastPointV^.longitude),
      getY(lastPointV^.latitude));
    lastPointV := findClosestVertex(x, y);
    if lastPointV <> nil then
      if pointAddition then
        drawPoint(getX(lastPointV^.longitude), getY(lastPointV^.latitude),
          length(points) + 1, pointPicture)
      else
        drawPoint(getX(lastPointV^.longitude), getY(lastPointV^.latitude),
          0, deletePointPicture);
    exit;
  end;
  prevX0 := x0;
  prevY0 := y0;
  with Form1.mapImage do
  begin
    //if not ((x0 > rightBorder - Width) or (x0 < leftBorder)) then
    x0 := x0 + (xm - x) * scale;
    minimize(x0, rightBorder - Width * scale);
    maximize(x0, leftBorder);
    //if not ((y0 > topBorder) or (y0 < bottomBorder + Height)) then
    y0 := y0 - (ym - y) * scale;
    minimize(y0, topBorder);
    maximize(y0, bottomBorder + Height * scale);
  end;
  //drawFullGraph;
  with Form1.mapImage do
  begin
    Canvas.CopyRect(Rect(round((prevX0 - x0) / scale), 0 - round((prevY0 - y0) / scale),
      Width + round((prevX0 - x0) / scale),
      Height - round((prevY0 - y0) / scale)), Canvas, Rect(0, 0, Width, Height));
    if x - xm > 0 then  // ->
    begin
      Canvas.Brush.Color := Form1.ColorGridBackground.ForegroundColor;
      Canvas.Pen.Style := psClear;
      Canvas.Rectangle(0, 0, x - xm + 1, Height);
      Canvas.Brush.Color := Form1.ColorGridRoads.ForegroundColor;
      Canvas.Pen.Style := psSolid;
      drawGraph(x0, y0 - Height * scale, x0 + (x - xm) * scale, y0, false);
    end
    else  // <-
    begin
      Canvas.Brush.Color := Form1.ColorGridBackground.ForegroundColor;
      Canvas.Pen.Style := psClear;
      Canvas.Rectangle(width + x - xm - 1, 0, width, Height);
      Canvas.Brush.Color := Form1.ColorGridRoads.ForegroundColor;
      Canvas.Pen.Style := psSolid;
      drawGraph(x0 + (width + x - xm) * scale, y0 - Height * scale,
        x0 + width * scale, y0, false);
    end;
    if y - ym > 0 then  // \/
    begin
      Canvas.Brush.Color := Form1.ColorGridBackground.ForegroundColor;
      Canvas.Pen.Style := psClear;
      Canvas.Rectangle(0, 0, width, y - ym + 1);
      Canvas.Brush.Color := Form1.ColorGridRoads.ForegroundColor;
      Canvas.Pen.Style := psSolid;
      drawGraph(x0, y0 - (y - ym) * scale, x0 + width * scale, y0, false);
    end
    else  // ^
    begin
      Canvas.Brush.Color := Form1.ColorGridBackground.ForegroundColor;
      Canvas.Pen.Style := psClear;
      Canvas.Rectangle(0, height + y - ym - 1, width, Height);
      Canvas.Brush.Color := Form1.ColorGridRoads.ForegroundColor;
      Canvas.Pen.Style := psSolid;
      drawGraph(x0, y0 - Height * scale, x0 + width * scale,
        y0 - (Height + y - ym) * scale, false);
    end;
  end;
  xm := x;
  ym := y;
  itWasMoving := true;
end;

procedure TForm1.mapImageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  xm := x;
  ym := y;
  move := true;
  itWasMoving := false;
end;

procedure TForm1.mapImageMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  move := false;
  if not itWasMoving then
    if pointAddition then addPoint(lastPointV)
    else deletePoint(lastPointV);
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
var
  movSet: TMovingTypeSet;
begin
  way := nil;
  movSet := [];
  if CheckBoxFoot.Checked then Include(movSet, foot);
  if CheckBoxCar.Checked then Include(movSet, car);
  drawTheShortestWayTroughSeveralPoints(points, CheckBoxStart.Checked,
    CheckBoxFinish.Checked, movSet);
end;

//////////////////////// SCALE ////////////////////////////
function onMap(MousePos: TPoint): boolean;
begin
  with form1 do
    with MousePos do
      result := not ((X < Left + mapImage.Left) or
        (X > Left + mapImage.Left + width) or
        (Y < top + mapImage.Top) or (Y > top + mapImage.Top + height));
end;

procedure ScaleChanging(MousePos: TPoint; d: ShortInt);  // d = -1, +1
const
  scaleIncrease = 0.15;  // percents
var
  distX, distY: real;  // dist to x0, y0
begin
  distX := (MousePos.X - Form1.Left - Form1.mapImage.Left) * scale;
  distY := (MousePos.Y - Form1.Top - Form1.mapImage.Top) * scale;
  scale := scale * (1 + d * scaleIncrease);
  x0 := x0 + (distX - (MousePos.X - Form1.Left - Form1.mapImage.Left) * scale);
  y0 := y0 - (distY - (MousePos.Y - Form1.Top - Form1.mapImage.Top) * scale);
end;

procedure TForm1.FormMouseWheelDown(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if scale >= MAX_SCALE then exit;
  if not onMap(MousePos) then exit;
  ScaleChanging(MousePos, +1);
  drawFullGraph;
end;

procedure TForm1.FormMouseWheelUp(Sender: TObject; Shift: TShiftState;
  MousePos: TPoint; var Handled: Boolean);
begin
  if scale <= MIN_SCALE then exit;
  if not onMap(MousePos) then exit;
  ScaleChanging(MousePos, -1);
  drawFullGraph;
end;

const
  dScale = 0.0001;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  if scale <= MIN_SCALE then exit;
  scale := scale - dScale;
  drawFullGraph;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
  if scale >= MAX_SCALE then exit;
  scale := scale + dScale;
  drawFullGraph;
end;

//////////////////////// SETTINGS /////////////////////////
procedure TForm1.SettingsBtnClick(Sender: TObject);
begin
  GroupBoxSettings.Left := (Form1.Width - GroupBoxSettings.Width) div 2;
  GroupBoxSettings.Top := (Form1.Height - GroupBoxSettings.Height) div 2;
  GroupBoxSettings.Visible := true;
end;

procedure TForm1.BitBtn6Click(Sender: TObject);
begin
  GroupBoxSettings.Visible := false;
end;

procedure TForm1.TrackBarDrawingRadiusChange(Sender: TObject);
begin
  DRAWING_RADIUS := MIN_DRAWING_RADIUS + (MAX_DRAWING_RADIUS -
    MIN_DRAWING_RADIUS) * TrackBarDrawingRadius.Position / 100.0;
end;
                        
procedure TForm1.ColorGridRoadsChange(Sender: TObject);
begin
  drawFullGraph;
end;

procedure TForm1.ColorGridWayChange(Sender: TObject);
begin
  drawWay(way);
  drawWay(way, true);
end;

procedure TForm1.ColorGridBackgroundChange(Sender: TObject);
begin
  drawFullGraph;
end;

procedure TForm1.ColorGridArrowChange(Sender: TObject);
begin
  drawWay(way, true);
end;

/////////////////////// START PAGE ///////////////////////

procedure makeStartPage;
begin
  with Form1 do
  begin
    setComponentsVisible(false);
    //mapImage.Visible := true;
    //mapImage.Picture.LoadFromFile('Images\backgroundMap.bmp');
    LoadBtn.Visible := true;
    MapImage.Visible := false;
    ComboBoxCity.Visible := true;
    GroupBoxLoad.Visible := true;
  end;
end;

procedure TForm1.BitBtn5Click(Sender: TObject);
begin
  makeStartPage;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  makeStartPage;
end;

procedure TForm1.LoadBtnClick(Sender: TObject);
var
  filename: string;
begin
  if not (CheckBoxCarLoad.Checked or CheckBoxFootLoad.Checked) then
  begin
    ShowMessage('Выберите хотя бы один тип дорог');
    exit;
  end;
  case ComboBoxCity.ItemIndex of
    2: filename := 'minsk';
    5: filename := 'glasgow_scotland';
    4: filename := 'kyiv_ukraine';
    3: filename := 'las-vegas_nevada';
    1: filename := 'riga_latvia';
    0: filename := 'singapore';
    6: filename := 'map';
    else
      begin
        ShowMessage('Выберите город');
        exit;
      end;
  end;
  LoadBtn.Visible := false;
  GroupBoxLoad.Visible := false;
  Form1.Label3.Visible := true;
  ComboBoxCity.Visible := false;
  Form1.Repaint;
  LoadMapFromFile('Map\' + filename + '.txt', CheckBoxCarLoad.Checked,
    CheckBoxFootLoad.Checked);
  DrawFullGraph;
  setComponentsVisible;
  LoadBtn.Visible := false;
  GroupBoxLoad.Visible := false;
  MapImage.Visible := true;
  Label3.Visible := False;
  ComboBoxCity.Visible := false;
  GroupBoxSettings.Visible := false;
end;

///////////////////////// FORM /////////////////////////////
procedure setComponentsVisible(v: boolean = true);
var
  i: integer;
begin
  with Form1 do
    for i := 0 to ComponentCount - 1 do
    begin
      if Components[i] is TBitBtn then
        (Components[i] as TBitBtn).Visible := v;
      if Components[i] is TSpeedButton then
        (Components[i] as TSpeedButton).Visible := v;
      if Components[i] is TLabel then
        (Components[i] as TLabel).Visible := v;
      if Components[i] is TGroupBox then
        (Components[i] as TGroupBox).Visible := v;
      if Components[i] is TComboBox then
        (Components[i] as TComboBox).Visible := v;
      if Components[i] is TTrackBar then
        (Components[i] as TTrackBar).Visible := v;
    end;
end;

procedure TForm1.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
var
  x, xm, y, ym: integer;
begin
  xm := mapImage.Width;    //                                     /\
  x := NewWidth;           //  copying from mousemove procedure   |
  ym := mapImage.Height;   //
  y := NewHeight;          //
  mapImage.Height := NewHeight;
  mapImage.Width := NewWidth;
  mapImage.Picture.Bitmap.Height := NewHeight;
  mapImage.Picture.Bitmap.Width := Width;
  with Form1.mapImage do
  begin
    if x - xm > 0 then  // ->
    begin
      Canvas.Brush.Color := clWhite;
      Canvas.Pen.Style := psClear;
      Canvas.Rectangle(xm - 1, 0, width, Height);
      Canvas.Brush.Color := clRed;
      Canvas.Pen.Style := psSolid;
      drawGraph(x0 + xm * scale, y0 - Height * scale,
        x0 + width * scale, y0, false);
    end;
    if y - ym > 0 then  // \/
    begin
      Canvas.Brush.Color := clWhite;
      Canvas.Pen.Style := psClear;
      Canvas.Rectangle(0, ym - 1, width, Height);
      Canvas.Brush.Color := clRed;
      Canvas.Pen.Style := psSolid;
      drawGraph(x0, y0 - Height * scale, x0 + width * scale,
        y0 - ym * scale, false);
    end;
  end;
  Label1.Left := NewWidth - Label1.Width - 8;  // right
  Label1.Top := NewHeight - Label1.Height - 26;  // bottom
  Label2.Left := NewWidth - Label2.Width - 13;  // right
  Label2.Top := Label1.Top;  // bottom
  Gauge.Width := round(NewWidth * 0.8);
  Gauge.Left := (NewWidth - Gauge.Width) div 2;  // center
  Gauge.Top := (NewHeight - Gauge.Height) div 2;  // center
  SpeedButton1.Left := NewWidth - 60;
  SpeedButton1.Top := NewHeight - 140;
  SpeedButton2.Left := NewWidth - 60;
  SpeedButton2.Top := NewHeight - 140 + SpeedButton1.Height;
end;

///////////////////////// SOURCE LINK /////////////////////////////////
procedure TForm1.Label2Click(Sender: TObject);
begin
  ShellExecute(Application.Handle, nil, 'http://www.openstreetmap.org/',
    nil, nil,SW_SHOWNOACTIVATE);
end;

procedure TForm1.Label2MouseEnter(Sender: TObject);
begin
  Label2.Font.Style := [fsUnderline];
end;

procedure TForm1.Label2MouseLeave(Sender: TObject);
begin
  Label2.Font.Style := [];
end;

//----------------------------------------------------------------------------//

initialization
begin
  pointPicture := TBitmap.Create;
  pointPicture.LoadFromFile('Images\point.bmp');
  pointPicture.Transparent := true;
  deletePointPicture := TBitmap.Create;
  deletePointPicture.LoadFromFile('Images\deletePoint.bmp');
  deletePointPicture.Transparent := true;

  mapGraph.hashFunc := matrixHashFunc;
  mapGraph.height := 0;
  mapGraph.width := 0;

end;

//----------------------------------------------------------------------------//

end.
