unit DrawUnit;

interface                   

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, GraphUnit, ExtCtrls, listOfPointersUnit, StdCtrls, Buttons;

type
  TForm1 = class(TForm)
    mapImage: TImage;
    BitBtn1: TBitBtn;
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure drawVertex(x, y, r: integer);
begin
  Form1.mapImage.Canvas.Brush.Color := clRed;
  Form1.mapImage.Canvas.Pen.Color := clRed;
  Form1.mapImage.Canvas.Ellipse(x - r, y - r, x + r, y + r);
end;

procedure drawRoad(x1, y1, x2, y2: integer; w: integer);
begin
  with Form1.mapImage.Canvas do
  begin
    pen.Width := w;
    moveTo(x1, y1);
    lineTo(x2, y2);
  end;
end;

procedure drawGraph(scale: real; latitude0, longitude0: real);  // scale = gr / px
const
  STANDART_RADIUS = 1;
var
  it: TEltPt;
begin
  it := mapGraph;
  while it <> nil do
  begin
    with TVertexPt(it)^ do
    begin
      drawVertex(round((longitude - longitude0) / scale), round((latitude - latitude0) / scale), round(STANDART_RADIUS / scale));
    end;
    it := it^.next;
  end;
end;

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  drawGraph(1 / 10, 50.910, 20.58);
end;

end.
