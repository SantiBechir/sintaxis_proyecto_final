Unit Lexico;

Interface

Uses
   Tipo, Crt, Lista;
Const
     FinArch = #0;
Procedure InstalarenTS (Var TS:TablaSimbolos; Var Lexema:String; Var complex:GramaticalSymbol);
procedure LeerCar(Var Fuente:Archtexto ;Var Control:Longint; Var Car:char);
Function EsSimboloEspecial (Var Lexema: String; Var compLex: Gramaticalsymbol; Var Fuente: ArchTexto;Var Control: longint): Boolean;
Function EsConstanteReal(Var Fuente: Archtexto;Var Control:longint; Var Lexema: String):Boolean;
Function EsIdentificador(Var Fuente:Archtexto;Var Control:Longint;Var Lexema:String):Boolean;
Function EsCadena(Var Fuente:Archtexto; Var Control : Longint; Var Lexema:String):Boolean;
Procedure ObtenerSiguienteCompLex(Var Fuente:ArchTexto;Var Control:Longint; Var CompLex:GramaticalSymbol;Var Lexema:String;Var TS:TablaSimbolos);
Procedure CargarTS (Var TS:TablaSimbolos);

Implementation


Procedure LeerCar(Var Fuente:Archtexto;Var Control:Longint; Var Car:char);
Begin
  if (Control< filesize(Fuente)) then
    Begin
      seek(Fuente,Control);
      read(Fuente,Car);   //extrae el caracter del codigo fuente
    End
  Else
      Begin
        Car:= FinArch;
      End;
End;

Procedure CargarTS (Var TS:TablaSimbolos);

 Var
   Palabra:TelemTS;
Begin
    CrearLista(TS);
     palabra.Lexema:= 'program';
     palabra.complex:= Tprogram;
     InsertarEnLista(TS,palabra);

     palabra.Lexema:= 'read';
     palabra.complex:=  Tread;
     InsertarEnLista(TS,palabra);

     palabra.Lexema:= 'while';
     palabra.complex:= twhile;
     InsertarEnLista(TS,palabra);

     palabra.Lexema:='do';
     palabra.compLex:=tdo;
     InsertarEnLista(TS,palabra);

     palabra.Lexema:= 'if';
     palabra.complex:=  tif;
     InsertarEnLista(TS,palabra);

     palabra.Lexema:= 'Else';
     palabra.complex:=  telse;
     InsertarEnLista(TS,palabra);

     palabra.Lexema:= 'print';
     palabra.complex:=  Tprint;
     InsertarEnLista(TS,palabra);

     palabra.Lexema:='Tr';
     palabra.complex:=Ttr;
     InsertarEnLista(TS,palabra);

     palabra.Lexema:='fTam';
     palabra.compLex:=TfTam;
     InsertarEnLista(TS,palabra);
     
     palabra.Lexema:='SumMat';
     palabra.compLex:=TSumMat;
     InsertarEnLista(TS,palabra);

     palabra.Lexema:='RestMat';
     palabra.compLex:=TRestMat;
     InsertarEnLista(TS,palabra);

     palabra.Lexema:='MultMat';
     palabra.compLex:=TMultMat;
     InsertarEnLista(TS,palabra);

     palabra.Lexema:='ProdEscMat';
     palabra.compLex:=TProdEscMat;
     InsertarEnLista(TS,palabra);
  End;

Procedure InstalarenTS (Var TS:TablaSimbolos; Var Lexema:String; Var complex:GramaticalSymbol);
Var
   existe: Boolean;
   aux: puntero;
   x: TelemTS;
Begin
existe := false;
aux := TS.cab;
While (aux <> nil) and (not existe) DO
      Begin
      If aux^.info.Lexema <> Lexema Then
         Begin
              aux := aux^.sig
         End
      Else
          If aux^.info.Lexema = Lexema Then
          Begin
               existe := true;
               CompLex := aux^.info.CompLex;
          End;
       End;
If (not existe) Then
Begin
     CompLex := tid;
     x.Lexema := Lexema;
     x.CompLex := tid;
     InsertarEnLista (TS,x);
End;
End;  
Function EsSimboloEspecial (Var Lexema: String; Var compLex:GramaticalSymbol; Var Fuente:Archtexto;Var Control: longint): Boolean;
Var
   Car: char;
Begin
EsSimboloEspecial:= false;
LeerCar(fuente,Control,Car);
case Car of
';': Begin
     CompLex:= tpuntocoma;
     Lexema:= ';';
     Essimboloespecial:=true;
     inc(Control);
     End;
',': Begin
     CompLex:= tcoma;
     Lexema:= ',';
     Essimboloespecial:=true;
     inc(Control);
     End;
'(': Begin
     CompLex:= tparentesisL;
     Lexema:= '(';
     Essimboloespecial:=true;
     inc(Control);
     End;
')': Begin
     CompLex:= tparentesisR;
     Lexema:= ')';
     Essimboloespecial:=true;
     inc(Control);
     End;
'{': Begin
     CompLex:= tllaveL;
     Lexema:= '{';
     Essimboloespecial:=true;
     inc(Control);
     End;
'}': Begin
     CompLex:= tllaveR;
     Lexema:= '}';
     Essimboloespecial:=true;
     inc(Control);
     End;
':': Begin
     CompLex:= tdospuntos;
     Lexema:= ':';
     Essimboloespecial:=true;
     inc(Control);
     LeerCar(fuente,Control,Car);
     if Car='=' then
      Begin
       inc(Control);
       LeerCar(fuente,Control,Car);
        if Car='=' then
         Begin
         Lexema:=':==';
         CompLex:= tasigmatriz;
         inc(Control);
         End;
        End;
     End;
'[': Begin
     CompLex:= tcorcheteL;
     Lexema:= '[';
     Essimboloespecial:=true;
     inc(Control);
     End;
']': Begin
     CompLex:= tcorcheteR;
     Lexema:= ']';
     Essimboloespecial:=true;
     inc(Control);
     End;
{'&': Begin
     CompLex:= tand;
     Lexema:= '&';
     Essimboloespecial:=true;
     inc(Control);
     End;}
'#': Begin
     complex:=Tnumeral;
     Lexema:='#';
     Essimboloespecial:=true;
     inc(Control);
     End;
{'~': Begin
     CompLex:= tnot;
     Lexema:= '~';
     Essimboloespecial:=true;
     inc(Control);
     End; }
{'|': Begin
     CompLex:= tor;
     Lexema:= '|';
     Essimboloespecial:=true;
     inc(Control);
     End;}
'+': Begin
     CompLex:= tmas;
     Lexema:= '+';
     Essimboloespecial:=true;
     inc(Control);
     End;
'-': Begin
     CompLex:= tmenos;
     Lexema:= '-';
     Essimboloespecial:=true;
     inc(Control);
     End;
'*': Begin
     CompLex:= tmult;
     Lexema:= '*';
     Essimboloespecial:=true;
     inc(Control);
     End;
'/': Begin
     CompLex:= tdiv;
     Lexema:= '/';
     Essimboloespecial:=true;
     inc(Control);
     End;
'^': Begin
     CompLex:= texp;
     Lexema:= '^';
     Essimboloespecial:=true;
     inc(Control);
     End;
'<': Begin
     CompLex:= TOPR;
     Lexema:='<';
     essimboloespecial:=true;
     inc(Control);
     LeerCar(fuente,Control,Car);
     if Car='=' then
        Begin
        Lexema:='<=';
        inc(Control);
        End
     End;
'>': Begin
     CompLex:= TOPR;
     Lexema:='>';
     essimboloespecial:=true;
     inc(Control);
     LeerCar(fuente,Control,Car);
     if Car='=' then
        Begin
        Lexema:='>=';
        inc(Control);
        End
     End;
'!': Begin
      inc(Control);
      LeerCar(fuente,Control,Car);
      if Car = '=' then
         Begin
           essimboloespecial:=true;
           Lexema:='!=';
           CompLex:= TOPR;
           inc(Control);
           End
      End;
'=': Begin
      essimboloespecial:=true;
      CompLex:= tasignacion;
      Lexema:='=';
      inc(Control);
      LeerCar(fuente,Control,Car);
      if Car = '=' then
      Begin
           Lexema:='==';
           CompLex:= TOPR;
            inc(Control);
           End
      End;
End;
End;
Function EsIdentificador(Var Fuente:Archtexto; Var Control:Longint;Var Lexema:String):Boolean;
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
  Car:char;
  Function CarASimb (Car:Char):Sigma;
  Begin
       Case Car of
       'a'..'z', 'A'..'Z':  CarASimb:= letra;
       '0'..'9':  CarASimb:= Digito;
       '_':CarASimb:=guionBajo;
       Else
       CarASimb:=Otro
       End;
  End;

Begin
  Delta[0,Letra]:=1;
  Delta[0,Digito]:=3;
  Delta[0,Otro]:=3;
  Delta[0,guionBajo]:=3;
  Delta[1,guionBajo]:=1;
  Delta[1,Digito]:=1;
  Delta[1,Letra]:=1;
  Delta[1,Otro]:=2;
   EstadoActual := q0;
   control_aux := Control;
   Lexema := '';
  while (EstadoActual <>3) and (EstadoActual <>2) do
      Begin
         leercar(fuente,control_aux,Car);
         EstadoActual:=Delta[EstadoActual,CarASimb(Car)];
        control_aux:=control_aux+1;
        if  EstadoActual = 1 then
        Lexema:= Lexema + Car;
      End;
    If EstadoActual in F then
    Begin
     EsIdentificador:= true;
     Control:=control_aux-1
    End
    Else
     EsIdentificador:= false;
End; 

Function EsConstanteReal(Var Fuente: Archtexto;Var Control: longint;Var Lexema: String):Boolean;
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
  Car:char;
  Function CarASimb (Car:Char):Sigma;
  Begin
    Case Car of
    '0'..'9':  CarASimb:= Digito;
    '.':  CarASimb:= Punto;
    Else
    CarASimb:=Otro
    End;
  End;

Begin
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
  control_aux := Control;
  Lexema := '';
  EstadoActual:=q0;
  While (EstadoActual <> 5) and (EstadoActual <> 4)do
  Begin
         leercar(fuente,control_aux,Car);
         EstadoActual:=Delta[EstadoActual,CarASimb(Car)];
        control_aux:=control_aux+1;
        if  (EstadoActual = 1) or (EstadoActual = 2) or (EstadoActual = 3) then
        Lexema:= Lexema + Car;
      End;
    If EstadoActual in F then
       Begin
       EsConstanteReal:= true;
       Control:=control_aux-1
       End
    Else
         EsConstanteReal:= false;
End;   

Function EsCadena(Var Fuente:Archtexto; Var Control : Longint; Var Lexema:String):Boolean;
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
   Car:char;
   tam:integer;
Function CarASimb (Car:Char):Sigma;
Begin
  Case Car of
  'a'..'z', 'A'..'Z':  CarASimb:= letra;
  '0'..'9':  CarASimb:= Digito;
  '"': CarASimb:= Comilla;
  Else
  CarASimb:=Otro
  End;
End;

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
  control_aux := Control;
  Lexema := '';
  While (EstadoActual <>4) and (EstadoActual <>2) do
      Begin
         leercar(fuente,control_aux,Car);
         EstadoActual:=Delta[EstadoActual,CarASimb(Car)];
        control_aux:=control_aux+1;
        if  (EstadoActual = 1) or (EstadoActual = 3) then
        Lexema:= Lexema + Car;
      End;
    delete(Lexema,1,1);
    tam:=length(Lexema);
    delete(Lexema,tam,1);
    If EstadoActual in F then
    Begin
     EsCadena:= true;
     Control:=control_aux-1;

    End
    Else
     EsCadena:= false;
End;

Procedure ObtenerSiguienteCompLex(Var Fuente:Archtexto;Var Control:Longint; Var CompLex:GramaticalSymbol;Var Lexema:String;Var TS:TablaSimbolos);
Var
  Car: char;
Begin
  LeerCar (Fuente,Control,Car);
  While Car in [#1..#32] do
      Begin
        Control:=Control+1;
        LeerCar (Fuente,Control,Car);
        End;
  If Car = FinArch then
     Begin
      Lexema:='$';
      complex:= pesos
     End
  Else
      If EsIdentificador(Fuente,Control,Lexema) then
      Begin
           //cargarTS(ts);
           InstalarEnTS(TS,Lexema,CompLex);
      End
         Else
               If EsConstanteReal(Fuente,Control,Lexema) then
		          CompLex:=treal
                         Else
                              If EsCadena(Fuente,Control,Lexema) then
		                         CompLex:=tcad
                              Else   
                                   if (Not EsSimboloEspecial(Lexema,CompLex,Fuente,Control)) then
                                   Begin
                                        CompLex:=LexicError;
                                        Control:=Control+1;
                                   End;
End;  
End.
