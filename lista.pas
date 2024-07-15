Unit Lista;


Interface

Uses
  Classes, SysUtils,tipo;

Procedure CrearLista(VAR TS:TablaSimbolos);
Procedure InsertarEnLista (var TS:TablaSimbolos; palabra:TelemTS);

Implementation

Procedure CrearLista(VAR TS:TablaSimbolos);
 Begin
  TS.tam:= 0;
  TS.cab:= NIL;
 End;

Procedure InsertarEnLista (var TS:TablaSimbolos; Palabra:TelemTS);
  Var
    Dir, Ant, Act: Puntero;
   BEGIN
    New (dir);
    Dir^.info:= palabra;
    IF (TS.cab = nil) OR (TS.cab^.info.lexema > palabra.lexema) THEN
     BEGIN
      Dir^.sig := TS.cab;
      TS.cab := Dir;
     END
      ELSE
       BEGIN
        Ant := TS.cab;
        Act := TS.cab^.sig;
        WHILE (Act <> Nil) AND (Act^.info.lexema < palabra.lexema) DO
         BEGIN
          Ant:= Act;
          Act:= Act^.sig
         END;
        Dir^.sig:= Act;
        Ant^.sig:= Dir;
       END;
    Inc(TS.tam);
END;
end.

