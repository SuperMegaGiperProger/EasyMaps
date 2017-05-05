program EasyMaps;

uses
  Forms,
  DrawUnit in 'Units\DrawUnit.pas' {Form1},
  GraphUnit in 'Units\GraphUnit.pas',
  listOfPointersUnit in 'Units\listOfPointersUnit.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
