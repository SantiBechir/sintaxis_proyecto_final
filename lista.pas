unit Lista;


interface

uses
  Classes, SysUtils;

Procedure CrearLista(VAR TS:TablaSimbolos);
Procedure InsertarEnLista (var TS:TablaSimbolos; palabra:TelemTS);

implementation
Procedure CrearLista(VAR TS:TablaSimbolos);
begin
    TS.tam:= 0;
    TS.cab:= NIL;
end;

Procedure InsertarEnLista (var TS:TablaSimbolos; palabra:TelemTS);
var
    dir, ant, act: puntero;
BEGIN
    new (dir);
    dir^.info:= palabra;
     IF (TS.cab = nil) OR (TS.cab^.info.lexema > palabra.lexema) THEN
     BEGIN
         dir^.sig := TS.cab;
         TS.cab := dir;
     END
     ELSE
         BEGIN
         ant := TS.cab;
         act := TS.cab^.sig;
         WHILE (act <> nil) AND (act^.info.lexema < palabra.lexema) DO
               BEGIN
             ant:= act;
             act:= act^.sig
             END;
         dir^.sig:= act;
         ant^.sig:= dir;
         END;
     inc(TS.tam);
 END;
end.

