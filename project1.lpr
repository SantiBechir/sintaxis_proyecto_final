program project1;
uses
    Tipo,lexico, AnalizadorSintactico;
var
  fuente:Archtexto;
  control:longint;
  complex:GramaticalSymbol;
  TS:TablaSimbolos;
  lexema:string;
begin
  assign(fuente,'prueba.txt');
  reset(fuente);
  control:= 0;
  CargarTS(TS);
  ObtenerSiguienteCompLex(fuente,Control,CompLex,Lexema,TS);
  while (complex <> pesos) and (complex <> LexicError) do
  begin
    writeln(control,':',complex,' ',lexema);
    ObtenerSiguienteCompLex(fuente,Control,CompLex,Lexema,TS);
  end;
  readln();
  close(fuente);
end.

