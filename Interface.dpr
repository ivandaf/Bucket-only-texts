program Project1;

{%ToDo 'Interface.todo'}

uses
  Forms,
  sqlGenerate in 'sqlGenerate.pas' {Form1},
  abramov in 'abramov.pas',
  dumin in 'dumin.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
