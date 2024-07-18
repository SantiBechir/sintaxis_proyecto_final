program project1;
uses
    Crt,Tipo,lexico, AnalizadorSintectico;
var
  fuente:Archtexto;
  control:longint;
  complex:GramaticalSymbol;
  TS:TablaSimbolos;
  lexema:string;
  TAS:TTAS;
begin
  {assign(fuente,'prueba.txt');
  reset(fuente);
  control:= 0;
  CargarTS(TS);
  ObtenerSiguienteCompLex(fuente,Control,CompLex,Lexema,TS);
  while (complex <> pesos) and (complex <> LexicError) do
  begin
    writeln(control,':',complex,' ',lexema);
    ObtenerSiguienteCompLex(fuente,Control,CompLex,Lexema,TS);
  end;
  //MOSTRAR_TAS(TAS);}
  TestingAnalizadorSintactico(fuente);
  Readkey;
  readln();
  close(fuente);
end.

