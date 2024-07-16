Unit Lista;


Interface

Uses
  Classes, SysUtils, Tipo;

Procedure CrearLista(Var TS:TablaSimbolos);
Procedure Cargar (Var L:TablaSimbolos; E:TElemTS);
Procedure InsertarEnLista(Var TS:TablaSimbolos; Palabra:TelemTS);

Implementation

Procedure CrearLista(VAR TS:TablaSimbolos);
 Begin
  TS.tam:= 0;
  TS.cab:= NIL;
 End;

Procedure Cargar(Var L:TablaSimbolos; E:TElemTS);
 Var
  Dir,Ant:TablaSimbolos;
 Begin
  New(Dir);
  Dir^.Info:=E;
   If (L.Cab=NIL) then
    Begin
     Dir^.Sig:=L.cab;
     L.Cab:=Dir;
    End
     Else
      Begin
       Ant:=L.Cab;
       L.Act:=L.Cab^.Sig;
        While (L.Act<>NIL) do
         Begin
          Ant:=L.Act;
          L.Act:=L.Act^.Sig;
         End;
        Ant^.Sig:=Dir;
        Dir^.Sig:=L.Act;
      End;
      Inc(L.tam);
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

