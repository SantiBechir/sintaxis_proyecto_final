unit lexico;

{$mode ObjFPC}{$H+}

interface

uses
   Tipo, crt, lista, Archivo;
procedure LeerCar(var Fuente:t_arch;var control:Longint; var car:char);
Procedure LeerCar (var fuente:t_arch )
Procedure CrearTS (var TS:TablaSimbolos);


Implementation

procedure LeerCar(var Fuente:t_arch;var control:Longint; var car:char);
begin
  if (control< filesize(Fuente)) then
    begin
      seek(Fuente,control);
      read(Fuente,car);   //extrae el caracter del codigo fuebte
    end
  else
      begin
        car:= FinArch;
      end;
end;


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


  palabra.lexema:= 'print';
  palabra.complex:=  Tprint;
  InsertarEnLista(TS,palabra);
  end;
Function EsSimboloEspecial (var lexema: string; var compLex:GramaticalSymbol; var Fuente: T_Arch;var control: longint): boolean;
var
   car: char;
BEGIN
EsSimboloEspecial:= false;
LeerCar(fuente,control,car);
case car of
';': begin
     CompLex:= tpuntocom;
     lexema:= ';';
     Essimboloespecial:=true;
     inc(control);
     end;
',': begin
     CompLex:= tcoma;
     lexema:= ',';
     Essimboloespecial:=true;
     inc(control);
     end;
'(': begin
     CompLex:= tparentesisA;
     lexema:= '(';
     Essimboloespecial:=true;
     inc(control);
     end;
')': begin
     CompLex:= tparentesisC;
     lexema:= ')';
     Essimboloespecial:=true;
     inc(control);
     end;
'{': begin
     CompLex:= tllaveA;
     lexema:= '{';
     Essimboloespecial:=true;
     inc(control);
     end;
'}': begin
     CompLex:= tllaveC;
     lexema:= '}';
     Essimboloespecial:=true;
     inc(control);
     end;
':': begin
     CompLex:= tdospuntos;
     lexema:= ':';
     Essimboloespecial:=true;
     inc(control);
     end;
'[': begin
     CompLex:= tcorcheteA;
     lexema:= '[';
     Essimboloespecial:=true;
     inc(control);
     end;
']': begin
     CompLex:= tcorcheteC;
     lexema:= ']';
     Essimboloespecial:=true;
     inc(control);
     end;
'&': begin
     CompLex:= tand;
     lexema:= '&';
     Essimboloespecial:=true;
     inc(control);
     end;
'~': begin
     CompLex:= tnot;
     lexema:= '~';
     Essimboloespecial:=true;
     inc(control);
     end;
'|': begin
     CompLex:= tor;
     lexema:= '|';
     Essimboloespecial:=true;
     inc(control);
     end;
'+': begin
     CompLex:= tsuma;
     lexema:= '+';
     Essimboloespecial:=true;
     inc(control);
     end;
'-': begin
     CompLex:= tresta;
     lexema:= '-';
     Essimboloespecial:=true;
     inc(control);
     end;
'*': begin
     CompLex:= tmult;
     lexema:= '*';
     Essimboloespecial:=true;
     inc(control);
     end;
'/': begin
     CompLex:= tdiv;
     lexema:= '/';
     Essimboloespecial:=true;
     inc(control);
     end;
'^': begin
     CompLex:= texp;
     lexema:= '^';
     Essimboloespecial:=true;
     inc(control);
     end;
//'"': CompLex:= tcomilla;                    consultar(comillas no es terminsl)
'r': begin
     inc(control);
     LeerCar(fuente,control,car);
     if car='o' then
        begin
        inc(control);
        LeerCar(fuente,control,car);
        if car='o' then
           begin
           inc(control);
           LeerCar(fuente,control,car);
           if car='t' then
              begin
              complex:= troot;
              lexema:='root';
              essimboloespecial:=true;
              inc(control);
              end;
           end;
        end;
     end;
'<': begin
     CompLex:= toprel;
     lexema:='<';
     essimboloespecial:=true;
     inc(control);
     LeerCar(fuente,control,car);
     if car='=' then
        begin
        Lexema:='<=';
        inc(control);
        end
     end;
'>': begin
     CompLex:= toprel;
     lexema:='>';
     essimboloespecial:=true;
     inc(control);
     LeerCar(fuente,control,car);
     if car='=' then
        begin
        Lexema:='>=';
        inc(control);
        end
     end;
'!': begin
      inc(control);
      LeerCar(fuente,control,car);
      if car = '=' then
         begin
           essimboloespecial:=true;
           Lexema:='!=';
           CompLex:= toprel;
           inc(control);
           end
      end;
'=': begin
      essimboloespecial:=true;
      CompLex:= tasignacion;
      lexema:='=';
      inc(control);
      LeerCar(fuente,control,car);
      if car = '=' then
      begin
           Lexema:='==';
           CompLex:= toprel;
            inc(control);
           end
      end;
end;
end;
end.
