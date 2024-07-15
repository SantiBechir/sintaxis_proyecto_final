unit lexico;

{$mode ObjFPC}{$H+}

interface

uses
   Tipo, crt, lista;
const
     FinArch = #0;
procedure instalarenTS (var TS:TablaSimbolos; var lexema:string; var complex:GramaticalSymbol);
procedure LeerCar(var Fuente:Archtexto ;var control:Longint; var car:char);
Function EsSimboloEspecial (var lexema: string; var compLex: Gramaticalsymbol; var Fuente: ArchTexto;var control: longint): boolean;
Function EsConstanteReal(var Fuente: Archtexto;var Control: longint;var Lexema: string):boolean;
Function EsIdentificador(Var Fuente:Archtexto;Var Control:Longint;Var Lexema:String):boolean;
function EsCadena(Var Fuente:Archtexto; var Control : Longint; Var Lexema:String):boolean;
Procedure ObtenerSiguienteCompLex(Var Fuente:ArchTexto;Var Control:Longint; Var CompLex:GramaticalSymbol;Var Lexema:String;Var TS:TablaSimbolos);
procedure cargarTS (var TS:TablaSimbolos);
Implementation


procedure LeerCar(var Fuente:Archtexto;var control:Longint; var car:char);
begin
  if (control< filesize(Fuente)) then
    begin
      seek(Fuente,control);
      read(Fuente,car);   //extrae el caracter del codigo fuente
    end
  else
      begin
        car:= FinArch;
      end;
end;

Procedure CargarTS (var TS:TablaSimbolos);

 var
   Palabra:TelemTS;
begin
    CrearLista(TS);
     palabra.lexema:= 'program';
     palabra.complex:= Tprogram;
     InsertarEnLista(TS,palabra);

     palabra.lexema:= 'read';
     palabra.complex:=  Tread;
     InsertarEnLista(TS,palabra);

     palabra.lexema:= 'while';
     palabra.complex:= twhile;
     InsertarEnLista(TS,palabra);

     palabra.lexema:='do';
     palabra.compLex:=tdo;
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

     palabra.lexema:='Tr';
     palabra.complex:=Ttr;
     InsertarEnLista(TS,palabra);

     palabra.lexema:='fTam';
     palabra.compLex:=TfTam;
     InsertarEnLista(TS,palabra);
     
     palabra.lexema:='SumMat';
     palabra.compLex:=TSumMat;
     InsertarEnLista(TS,palabra);

     palabra.lexema:='RestMat';
     palabra.compLex:=TRestMat;
     InsertarEnLista(TS,palabra);

     palabra.lexema:='MultMat';
     palabra.compLex:=TMultMat;
     InsertarEnLista(TS,palabra);

     palabra.lexema:='ProdEscMat';
     palabra.compLex:=TProdEscMat;
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
Function EsSimboloEspecial (var lexema: string; var compLex:GramaticalSymbol; var Fuente:Archtexto;var control: longint): boolean;
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
     LeerCar(fuente,control,car);
     if car='=' then
      begin
       inc(control);
       LeerCar(fuente,control,car);
        if car='=' then
         begin
         Lexema:=':==';
         CompLex:= tasigmatriz;
         inc(control);
         end;
        end;
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
{'&': begin
     CompLex:= tand;
     lexema:= '&';
     Essimboloespecial:=true;
     inc(control);
     end;}
'#': begin
     complex:=Tnumeral;
     lexema:='#';
     Essimboloespecial:=true;
     inc(control);
     end;
{'~': begin
     CompLex:= tnot;
     lexema:= '~';
     Essimboloespecial:=true;
     inc(control);
     end; }
{'|': begin
     CompLex:= tor;
     lexema:= '|';
     Essimboloespecial:=true;
     inc(control);
     end;}
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
'<': begin
     CompLex:= TOPR;
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
     CompLex:= TOPR;
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
           CompLex:= TOPR;
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
           CompLex:= TOPR;
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
  if car = FinArch then
     begin
      lexema:='$';
      complex:= pesos
     end
  else
      If EsIdentificador(Fuente,Control,Lexema) then
      begin
           //cargarTS(ts);
           InstalarEnTS(TS,Lexema,CompLex);
      end
         else
               If EsConstanteReal(Fuente,Control,Lexema) then
		          CompLex:=treal
                         else
                              If EsCadena(Fuente,Control,Lexema) then
		                         CompLex:=tcad
                              else   
                                   if (Not EsSimboloEspecial(Lexema,CompLex,Fuente,Control)) then
                                   begin
                                        CompLex:=LexicError;
                                        control:=control+1;
                                   end;
End;  
end.
