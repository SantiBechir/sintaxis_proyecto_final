unit lexico;

{$mode ObjFPC}{$H+}

interface

uses
   Tipo, crt, lista;
const
     FinArch = #0;
procedure LeerCar(var Fuente:Archtexto;var control:Longint; var car:char);
Procedure CrearTS (var TS:TablaSimbolos);
Procedure ObtenerSiguienteCompLex(Var Fuente:Archtexto;Var Control:Longint; Var CompLex:componenteslexicos;Var Lexema:String;Var TS:TablaSimbolos);

Implementation

procedure LeerCar(var Fuente:Archtexto;var control:Longint; var car:char);
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
   Palabra:TelemTS;
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


  palabra.lexema:= 'print';
  palabra.complex:=  Tprint;
  InsertarEnLista(TS,palabra);
  end;
Function EsSimboloEspecial (var lexema: string; var compLex:componenteslexicos; var Fuente:Archtexto;var control: longint): boolean;
var
   car: char;
BEGIN
EsSimboloEspecial:= false;
LeerCar(fuente,control,car);
case car of
';': begin
     CompLex:= tpuntocoma;
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
     CompLex:= tparentesisL;
     lexema:= '(';
     Essimboloespecial:=true;
     inc(control);
     end;
')': begin
     CompLex:= tparentesisR;
     lexema:= ')';
     Essimboloespecial:=true;
     inc(control);
     end;
'{': begin
     CompLex:= tllaveL;
     lexema:= '{';
     Essimboloespecial:=true;
     inc(control);
     end;
'}': begin
     CompLex:= tllaveR;
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
     CompLex:= tcorcheteL;
     lexema:= '[';
     Essimboloespecial:=true;
     inc(control);
     end;
']': begin
     CompLex:= tcorcheteR;
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
     CompLex:= tmas;
     lexema:= '+';
     Essimboloespecial:=true;
     inc(control);
     end;
'-': begin
     CompLex:= tmenos;
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
Function EsIdentificador(Var Fuente:Archtexto; Var Control:Longint;Var Lexema:String):boolean;
Const
  q0=0;
  F=[2];
Type
  Q=0..3;
  Sigma=(Letra, Digito, Otro,guionBajo);
  TipoDelta=Array[Q,Sigma] of Q;
Var
  EstadoActual:Q;
  Delta:TipoDelta;
  control_aux : longint;
  car:char;
  Function CarASimb (Car:Char):Sigma;
  begin
       Case Car of
       'a'..'z', 'A'..'Z':  CarASimb:= letra;
       '0'..'9':  CarASimb:= Digito;
       '_':CarASimb:=guionBajo;
       else
       CarASimb:=Otro
       end;
  end;

BEGIN
  Delta[0,Letra]:=1;
  Delta[0,Digito]:=3;
  Delta[0,Otro]:=3;
  Delta[0,guionBajo]:=3;
  Delta[1,guionBajo]:=1;
  Delta[1,Digito]:=1;
  Delta[1,Letra]:=1;
  Delta[1,Otro]:=2;
   EstadoActual := q0;
   control_aux := control;
   lexema := '';
  while (EstadoActual <>3) and (EstadoActual <>2) do
      begin
         leercar(fuente,control_aux,car);
         EstadoActual:=Delta[EstadoActual,CarASimb(Car)];
        control_aux:=control_aux+1;
        if  EstadoActual = 1 then
        lexema:= lexema + car;
      end;
    If EstadoActual in F then
    begin
     EsIdentificador:= true;
     control:=control_aux-1
    end
    else
     EsIdentificador:= false;
END; 

Procedure ObtenerSiguienteCompLex(Var Fuente:Archtexto;Var Control:Longint; Var CompLex:componenteslexicos;Var Lexema:String;Var TS:TablaSimbolos);
var
  car: char;
Begin
  LeerCar (Fuente,control,car);
  while car in [#1..#32] do
      begin
        control:=control+1;
        LeerCar (Fuente,control,car);
        end;
  if car = FinArch then
     begin
      lexema:='$';
      complex:= pesos
     end
  else
      If EsIdentificador(Fuente,Control,Lexema) then
      begin
           //cargarts(ts);
           //InstalarEnTS(TS,Lexema,CompLex);
      end
         else
             {If EsConstanteReal(Fuente,Control,Lexema) then
		CompLex:=tconst
                    else
                        If EsCadena(Fuente,Control,Lexema) then
		            CompLex:=tstring
                        else   }
                            if (Not EsSimboloEspecial(Lexema,CompLex,Fuente,Control)) then
                            begin
                               CompLex:=LexicError;
                               control:=control+1;
                           end;
End;  
end.
