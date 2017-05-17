program EasyMaps;

uses
  Forms,
  MainUnit in 'MainUnit.pas',
  listOfPointersUnit in 'Units\listOfPointersUnit.pas',
  BinHeapUnit in 'Units\BinHeapUnit.pas',
  HashUnit in 'Units\HashUnit.pas',
  GeoUnit in 'Units\GeoUnit.pas',
  GraphUnit in 'Units\GraphUnit.pas',
  MapLoaderUnit in 'Units\MapLoaderUnit.pas',
  DrawUnit in 'Units\DrawUnit.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
