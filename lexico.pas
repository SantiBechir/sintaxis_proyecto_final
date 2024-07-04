unit lexico;

{$mode ObjFPC}{$H+}

interface

uses
   Tipo, crt, lista;

Procedure CrearTS (var TS:TablaSimbolos);


Implementation

Procedure CrearTS (var TS:TablaSimbolos);

 var
   Palabra:TelemTS
begin
    CrearLista(TS);
    palabra.lexema:= 'program';
    palabra.complex:= Tprogram;
    InsertarEnLista(TS,palabra);


  palabra.lexema:= 'var';
  palabra.complex:=  Tvar;
  InsertarEnLista(TS,palabra);


  palabra.lexema:= 'read';
  palabra.complex:=  Tread;
  InsertarEnLista(TS,palabra);


  palabra.lexema:= 'while';
  palabra.complex:= twhile;
  InsertarEnLista(TS,palabra);


  palabra.lexema:= 'if';
  palabra.complex:=  tif;
  InsertarEnLista(TS,palabra);


  palabra.lexema:= 'else';
  palabra.complex:=  telse;
  InsertarEnLista(TS,palabra);


  palabra.lexema:= 'for';
  palabra.complex:=  tfor ;
  InsertarEnLista(TS,palabra);


  palabra.lexema:= 'Print';
  palabra.complex:=  Tprint;
  InsertarEnLista(TS,palabra);
  end;
end.
