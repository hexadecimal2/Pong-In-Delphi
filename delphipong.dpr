program delphipong;

//change apptype directive from console to GUI to remove the pesky cmd window

{$APPTYPE GUI}

{$R *.res}

uses
  System.SysUtils,
  delphipong_u in 'delphipong_u.pas';

begin
  try
    main();
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
