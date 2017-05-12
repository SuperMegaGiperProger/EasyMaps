program EasyMaps;

uses
  Forms,
  DrawUnit in 'Units\DrawUnit.pas' {Form1},
  GraphUnit in 'Units\GraphUnit.pas',
  listOfPointersUnit in 'Units\listOfPointersUnit.pas',
  MainUnit in 'MainUnit.pas',
  BinHeapUnit in 'Units\BinHeapUnit.pas',
  HashUnit in 'Units\HashUnit.pas',
  GeoUnit in 'Units\GeoUnit.pas',
  MapLoaderUnit in 'Units\MapLoaderUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  main;
  Application.Run;
end.
