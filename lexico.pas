unit AnalizadorLexico;
{$codepage UTF-8}

INTERFACE

uses
  crt, Listas, Archivo, Tipos;

const
  maxsimb=200;
  FinArch=#0;


procedure cargarTS (var TS:TablaSimbolos);
procedure instalarenTS (var TS:TablaSimbolos; var lexema:string; var complex:GramaticalSymbol);
procedure LeerCar(var Fuente:Archtexto ;var control:Longint; var car:char);
Function EsSimboloEspecial (var lexema: string; var compLex: Gramaticalsymbol; var Fuente: ArchTexto;var control: longint): boolean;
Function EsConstanteReal(var Fuente: Archtexto;var Control: longint;var Lexema: string):boolean;
Function EsIdentificador(Var Fuente:Archtexto;Var Control:Longint;Var Lexema:String):boolean;
function EsCadena(Var Fuente:Archtexto; var Control : Longint; Var Lexema:String):boolean;
Procedure ObtenerSiguienteCompLex(Var Fuente:ArchTexto;Var Control:Longint; Var CompLex:GramaticalSymbol;Var Lexema:String;Var TS:TablaSimbolos);

IMPLEMENTATION

procedure cargarTS (var TS:TablaSimbolos);
var
   palabra:TelemTS;
BEGIN
  crearlista(TS);

  inc(TS.tam);
  palabra.lexema:= 'root';
  palabra.complex:= troot;
  InsertarEnLista(TS,palabra);

  inc(TS.tam);
  palabra.lexema:= 'var';
  palabra.complex:=  tvar;
  InsertarEnLista(TS,palabra);

  inc(TS.tam);
  palabra.lexema:= 'print';
  palabra.complex:=  tprint;
  InsertarEnLista(TS,palabra);

  inc(TS.tam);
  palabra.lexema:= 'input';
  palabra.complex:=  tinput;
  InsertarEnLista(TS,palabra);

  inc(TS.tam);
  palabra.lexema:= 'while';
  palabra.complex:= twhile;
  InsertarEnLista(TS,palabra);

  inc(TS.tam);
  palabra.lexema:= 'if';
  palabra.complex:=  tif;
  InsertarEnLista(TS,palabra);

  inc(TS.tam);
  palabra.lexema:= 'else';
  palabra.complex:=  telse;
  InsertarEnLista(TS,palabra);

  inc(TS.tam);
  palabra.lexema:= 'for';
  palabra.complex:=  tfor ;
  InsertarEnLista(TS,palabra);

  inc(TS.tam);
  palabra.lexema:= 'real';
  palabra.complex:=  treal;
  InsertarEnLista(TS,palabra);

end;

procedure instalarenTS (var TS:TablaSimbolos; var lexema:string; var complex:GramaticalSymbol);
var
   existe: boolean;
   aux: puntero;
   x: TelemTS;
BEGIN
existe := false;
aux := TS.cab;
WHILE (aux <> nil) and (not existe) DO
      BEGIN
      IF aux^.info.lexema <> Lexema THEN
         BEGIN
              aux := aux^.sig
         END
      ELSE
          IF aux^.info.lexema = Lexema THEN
          BEGIN
               existe := true;
               CompLex := aux^.info.CompLex;
          END;
       END;
IF (not existe) THEN
BEGIN
     CompLex := tid;
     x.lexema := Lexema;
     x.CompLex := tid;
     InsertarEnLista (TS,x);
END;
END;

procedure LeerCar(var Fuente:Archtexto ;var control:Longint; var car:char);
BEGIN
  if control< filesize(Fuente) then
    begin
      seek(Fuente,control);
      read(fuente,car);
    end
  else
      begin
        car:=FinArch;
      end;
END;

Function EsSimboloEspecial (var lexema: string; var compLex:GramaticalSymbol; var Fuente: Archtexto;var control: longint): boolean;
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
END;

Function EsConstanteReal(var Fuente: Archtexto;var Control: longint;var Lexema: string):boolean;
Const
  q0=0;
  F =[5];
Type
  Q=0..5;
  Sigma=(Digito, Punto, Otro);
  TipoDelta=Array[Q,Sigma] of Q;
Var
  EstadoActual:longint;
  Delta:TipoDelta;
  control_aux : longint;
  car:char;
  Function CarASimb (Car:Char):Sigma;
  begin
    Case Car of
    '0'..'9':  CarASimb:= Digito;
    '.':  CarASimb:= Punto;
    else
    CarASimb:=Otro
    end;
  end;

BEGIN
  Delta[0,Digito]:=1;
  Delta[0,Punto]:=4;
  Delta[0,Otro]:=4;
  Delta[1,Digito]:=1;
  Delta[1,Punto]:=3;
  Delta[1,Otro]:=5;
  Delta[2,Digito]:=2;
  Delta[2,Punto]:=5;
  Delta[2,Otro]:=5;
  Delta[3,Digito]:=2;
  Delta[3,Punto]:=4;
  Delta[3,Otro]:=4;
  EstadoActual := q0;
  control_aux := control;
  lexema := '';
  EstadoActual:=q0;
  While (EstadoActual <> 5) and (EstadoActual <> 4)do
  begin
         leercar(fuente,control_aux,car);
         EstadoActual:=Delta[EstadoActual,CarASimb(Car)];
        control_aux:=control_aux+1;
        if  (EstadoActual = 1) or (EstadoActual = 2) or (EstadoActual = 3) then
        lexema:= lexema + car;
      end;
    If EstadoActual in F then
       begin
       EsConstanteReal:= true;
       control:=control_aux-1
       end
    else
         EsConstanteReal:= false;
END;

Function EsIdentificador(Var Fuente:Archtexto; Var Control:Longint;Var Lexema:String):boolean;
Const
  q0=0;
  F=[3];
Type
  Q=0..3;
  Sigma=(Letra, Digito, Otro);
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
       else
       CarASimb:=Otro
       end;
  end;

BEGIN
  Delta[0,Letra]:=1;
  Delta[0,Digito]:=2;
  Delta[0,Otro]:=2;
  Delta[1,Digito]:=1;
  Delta[1,Letra]:=1;
  Delta[1,Otro]:=3;
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

function EsCadena(Var Fuente:Archtexto; var Control : Longint; Var Lexema:String):boolean;
Const
  q0=0;
  F=[4];
Type
  Q=0..4;
  Sigma=(Letra, Digito, Comilla, Otro);
  TipoDelta=Array[Q,Sigma] of Q;
Var
  EstadoActual:Q;
  Delta:TipoDelta;
  control_aux : longint;
   car:char;
   tam:integer;
Function CarASimb (Car:Char):Sigma;
begin
  Case Car of
  'a'..'z', 'A'..'Z':  CarASimb:= letra;
  '0'..'9':  CarASimb:= Digito;
  '"': CarASimb:= Comilla;
  else
  CarASimb:=Otro
  end;
end;

Begin
  Delta[0,Comilla]:=1;
  Delta[0,Digito]:=2;
  Delta[0,Letra]:=2;
  Delta[0,Otro]:=2;
  Delta[1,Comilla]:=3;
  Delta[1,Digito]:=1;
  Delta[1,Letra]:=1;
  Delta[1,Otro]:=1;
  Delta[3,Comilla]:=4;
  Delta[3,Digito]:=4;
  Delta[3,Letra]:=4;
  Delta[3,Otro]:=4;
  EstadoActual := q0;
  control_aux := control;
  lexema := '';
  while (EstadoActual <>4) and (EstadoActual <>2) do
      begin
         leercar(fuente,control_aux,car);
         EstadoActual:=Delta[EstadoActual,CarASimb(Car)];
        control_aux:=control_aux+1;
        if  (EstadoActual = 1) or (EstadoActual = 3) then
        lexema:= lexema + car;
      end;
    delete(lexema,1,1);
    tam:=length(lexema);
    delete(lexema,tam,1);
    If EstadoActual in F then
    begin
     EsCadena:= true;
     control:=control_aux-1;

    end
    else
     EsCadena:= false;
end;

Procedure ObtenerSiguienteCompLex(Var Fuente:Archtexto;Var Control:Longint; Var CompLex:GramaticalSymbol;Var Lexema:String;Var TS:TablaSimbolos);
var
  car: char;
Begin
  LeerCar (Fuente,control,car);
  while car in [#1..#32] do
      begin
        control:=control+1;
        LeerCar (Fuente,control,car);
        end;
  if car = #0 then
     begin
      lexema:='$';
      complex:= pesos
     end
  else
      If EsIdentificador(Fuente,Control,Lexema) then
      begin
           cargarts(ts);
           InstalarEnTS(TS,Lexema,CompLex);
      end
         else
             If EsConstanteReal(Fuente,Control,Lexema) then
		CompLex:=tconst
                    else
                        If EsCadena(Fuente,Control,Lexema) then
		            CompLex:=tstring
                        else
                            if (Not EsSimboloEspecial(Lexema,CompLex,Fuente,Control)) then
                            begin
                               CompLex:=LexicError;
                               control:=control+1;
                           end;
End;


end.
