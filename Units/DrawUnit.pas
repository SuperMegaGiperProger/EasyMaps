unit DrawUnit;

interface                   

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GraphUnit, ExtCtrls, listOfPointersUnit, StdCtrls, Buttons, EdgeUnit;

type
  TForm1 = class(TForm)
    mapImage: TImage;
    BitBtn1: TBitBtn;
    Shape1: TShape;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

procedure drawGraph(scale: real; latitude0, longitude0: real);

implementation

{$R *.dfm}

procedure drawVertex(x, y, r: integer);
begin
  Form1.mapImage.Canvas.Brush.Color := clRed;
  Form1.mapImage.Canvas.Pen.Color := clRed;
  Form1.mapImage.Canvas.Ellipse(x - r, y - r, x + r, y + r);
end;

procedure drawRoadPart(x1, y1, x2, y2: integer);
begin
  with Form1.mapImage.Canvas do
  begin
    moveTo(x1, y1);
    lineTo(x2, y2);
  end;
end;

procedure drawRoad(list: TListOfPointers; scale: real; latitude0, longitude0: real; style: TPenStyle);
const
  STANDART_WIDTH = 0.0005;
var
  it: TEltPt;
  x, y: integer;
begin
  it := list;
  Form1.mapImage.Canvas.Pen.Width := round(STANDART_WIDTH / scale);
  Form1.mapImage.Canvas.Pen.Style := style;
  with TRoadVertexPt(it^.data)^ do
  begin
    y := round((longitude - longitude0) / scale);
    x := round((latitude - latitude0) / scale);
  end;
  Form1.mapImage.Canvas.moveTo(x, y);
  it := it^.next;
  while it <> nil do
  begin
    with TRoadVertexPt(it^.data)^ do
    begin
      y := round((longitude - longitude0) / scale);
      x := round((latitude - latitude0) / scale);
    end;
    with Form1.mapImage.Canvas do
    begin
      lineTo(x, y);
      moveTo(x, y);
    end;
    it := it^.next;
  end;
end;

procedure drawAllRoads(list: TListOfPointers; scale: real; latitude0, longitude0: real);
var
  it: TEltPt;
begin
  it := list;
  while it <> nil do
  begin
    with TEdgePt(it^.data)^ do
      case movingType of
        car: drawRoad(road, scale, latitude0, longitude0, psSolid);
        foot: drawRoad(road, scale, latitude0, longitude0, psDot);
      end;
    it := it^.next;
  end;
end;

procedure drawGraph(scale: real; latitude0, longitude0: real);  // scale = gr / px
const
  STANDART_RADIUS = 0.0005;
var
  it: TEltPt;
begin
  it := mapGraph;
  while it <> nil do
  begin
    with TVertexPt(it^.data)^ do
    begin
      drawVertex(round((latitude - latitude0) / scale), round((longitude - longitude0) / scale), round(STANDART_RADIUS / scale));
      drawAllRoads(edgesList, scale, latitude0, longitude0);
    end;
    it := it^.next;
  end;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  drawGraph(1 / 10000, 53.910, 27.58);
end;

end.
