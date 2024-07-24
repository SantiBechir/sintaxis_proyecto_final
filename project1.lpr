program project1;
uses
    Crt,Tipo,lexico, AnalizadorSintactico;
var
  fuente:Archtexto;
  control:longint;
  complex:GramaticalSymbol;
  TS:TablaSimbolos;
  lexema:string;
  TAS:TTAS;
begin
  //assign(fuente,'mult_matriz.txt');
  {reset(fuente);
  control:= 0;
  CargarTS(TS);
  ObtenerSiguienteCompLex(fuente,Control,CompLex,Lexema,TS);
  while (complex <> pesos) and (complex <> LexicError) do
  begin
    writeln(control,':',complex,' ',lexema);
    readln();
    ObtenerSiguienteCompLex(fuente,Control,CompLex,Lexema,TS);
  end;
  writeln(control,':',complex,' ',lexema);}
  //MOSTRAR_TAS(TAS);
  TestingAnalizadorSintactico(fuente);
  readln();
end.

