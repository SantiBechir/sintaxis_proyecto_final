Unit AnalizadorSintectico ;

Uses
 Crt,Lista,Lexico,Arbol,Archivo,Lista;
Const
 Max = 15;
Type
 TProduccion= Record    //registro para producciones de la TAS
    Elem: Array [1..Max] of GramaticalSymbol;
    Cant:0..Max;
              End;

  TVariable = VProgram..VfTam;                //filas:rango de variables
  TTerminales = TPrograma..pesos;             //columnas:rango de terminales

  TTAS = Array [TVariable, TTerminales] of ^TProduccion;


  {Definicion de la Pila}
  TElemPila = Record
    Simbolo:GramaticalSymbol;
    NodoArbol:TApuntNodo; //arbol de derivacion
              End;

  TPila = Record
    Elem: Array[1..200]of TElemPila;
    Tope:0..200;
          End;

Interface



Implementation


Procedure InicializarTAS(Var TAS: TTAS);
 Var I,J:GramaticalSymbol;
  Begin
   For I := VProgram to VfTam do
    Begin
     For J:= TPrograma to pesos do
      Begin
       TAS[I,J]:=Nil; //Completa cada celda de la TAS le asigno nil
      End;
    End;
  End;


Procedure CargarTAS(Var TAS:TTAS);
 Var I,J:GramaticalSymbol;          //todos los elementos de la tas son punteros a registros y esos registros conforman una lista
  Begin

  // Vprogram -->  “Program” <Dec> “{” <Cuerpo> "}" (ES UNA MATRIZ DE PUNTEROS A LISTAS)

   New(TAS[Vprogram,Tprograma ]);
   TAS[Vprogram,Tprograma]^.Elem[1]:= Tprograma; //en la primer posicion del arreglo guardare el primer simbolo de la parte derecha de la produccion  en este caso el primer elemento es program
   TAS[Vprogram,Tprograma]^.Elem[2]:= VDec;
   TAS[Vprogram,Tprograma]^.Elem[3]:= TLlaveL;
   TAS[Vprogram,Tprograma]^.Elem[4]:= VCuerpo;
   TAS[Vprogram,Tprograma]^.Elem[5]:= TLlaveR;
   TAS[Vprogram,Tprograma]^.Cant:= 5;

  //Dec ->  "id" ":" <Variable> ";" <Dec>
   New(TAS[VDec ,Tid]);
   TAS[VDec ,Tid]^.Elem[1]:= Tid;
   TAS[VDec ,Tid]^.Elem[2]:= TDosPuntos;
   TAS[VDec ,Tid]^.Elem[3]:= VVaraible;
   TAS[VDec ,Tid]^.Elem[4]:= TPuntoComa;
   TAS[VDec ,Tid]^.Cant:= 4;

   //Dec -> Epsilon
   New(TAS[VDec,TLlaveL]);
   TAS[VDec,TLlaveL]^.Cant:=0;

   //Variable -> "Real"
   New(TAS[VVariable, TReal]);
   TAS[VVariable, TReal]^.Elem[1]:= TReal;
   TAS[VVariable, TReal]^.Cant:= 1;

   //Variable -> <MatrizReal>
   New(TAS[VVariable,TCorcheteL]);
   TAS[VVariable,TCorcheteL]^.Elem[1]:= VMatrizReal;
   TAS[VVariable,TCorcheteL]^.Cant:=1;

   //Cuerpo -> <Sent> <Seguido>
   New(TAS[VCuerpo,Tid]);
   TAS[VCuerpo,Tid]^.Elem[1]:= VSent;
   TAS[VCuerpo,Tid]^.Elem[2]:= VSeguido;
   TAS[VCuerpo,Tid]^.Cant:=2;

   //Cuerpo -> <Sent> <Seguido>
   New(TAS[VCuerpo,TRead]);
   TAS[VCuerpo,TRead]^.Elem[1]:= VSent;
   TAS[VCuerpo,TRead]^.Elem[2]:= VSeguido;
   TAS[VCuerpo,TRead]^.Cant:=2;

   //Cuerpo -> <Sent> <Seguido>
   New(TAS[VCuerpo,TPrint]);
   TAS[VCuerpo,TPrint]^.Elem[1]:= VSent;
   TAS[VCuerpo,TPrint]^.Elem[2]:= VSeguido;
   TAS[VCuerpo,TPrint]^.Cant:=2;

   //Cuerpo -> <Sent> <Seguido>
   New(TAS[VCuerpo,TIf]);
   TAS[VCuerpo,TIf]^.Elem[1]:= VSent;
   TAS[VCuerpo,TIf]^.Elem[2]:= VSeguido;
   TAS[VCuerpo,TIf]^.Cant:=2;

   //Cuerpo -> <Sent> <Seguido>
   New(TAS[VCuerpo,TWhile]);
   TAS[VCuerpo,TWhile]^.Elem[1]:= VSent;
   TAS[VCuerpo,TWhile]^.Elem[2]:= VSeguido;
   TAS[VCuerpo,TWhile]^.Cant:=2;

   //Seguido -> <Cuerpo>
   New(TAS[VSeguido,Tid]);
   TAS[VSeguido,Tid]^.Elem[1]:= VCuerpo;
   TAS[VSeguido,Tid]^.Cant:=1;

   //Seguido -> <Cuerpo>
   New(TAS[VSeguido,TRead]);
   TAS[VSeguido,TRead]^.Elem[1]:= VCuerpo;
   TAS[VSeguido,TRead]^.Cant:=1;

   //Seguido -> <Cuerpo>
   New(TAS[VSeguido,TPrint]);
   TAS[VSeguido,TPrint]^.Elem[1]:= VCuerpo;
   TAS[VSeguido,TPrint]^.Cant:=1;

   //Seguido -> <Cuerpo>
   New(TAS[VSeguido,TIf]);
   TAS[VSeguido,TIf]^.Elem[1]:= VCuerpo;
   TAS[VSeguido,TIf]^.Cant:=1;

   //Seguido -> <Cuerpo>
   New(TAS[VSeguido,TWhile]);
   TAS[VSeguido,TWhile]^.Elem[1]:= VCuerpo;
   TAS[VSeguido,TWhile]^.Cant:=1;

   //Seguido -> Epsilon
   New(TAS[VSeguido,]);            ///NO SE QUE PONER ACA
   TAS[VSeguido,]^.Cant:=0;

   //Sent -> <Asignacion> ";"
   New(TAS[VSent,Tid]);
   TAS[VSent,Tid]^.Elem[1]:= VAsignacion;
   TAS[VSent,Tid]^.Elem[2]:= TPuntoComa;
   TAS[VSent,Tid]^.Cant:=2;

   //Sent -> <Lectura> ";"
   New(TAS[VSent,TRead]);
   TAS[VSent,TRead]^.Elem[1]:= VLectura;
   TAS[VSent,TRead]^.Elem[2]:= TPuntoComa;
   TAS[VSent,TRead]^.Cant:=2;

   //Sent -> <Escritura> ";"
   New(TAS[VSent,TPrint]);
   TAS[VSent,TPrint]^.Elem[1]:= VEscritura;
   TAS[VSent,TPrint]^.Elem[2]:= TPuntoComa;
   TAS[VSent,TPrint]^.Cant:=2;

   //Sent -> <Condicional>
   New(TAS[VCondicional,TIf]);
   TAS[VSent,TIf]^.Elem[1]:= VCondicional;
   TAS[VSent,TIf]^.Cant:=1;

   //Sent -> <Ciclo>
   New(TAS[VSent,TWhile]);
   TAS[VSent,TWhile]^.Elem[1]:= VCiclo;
   TAS[VSent,TWhile]^.Cant:=1;

   //Asignacion -> "id" <OperacionAsig>
   New(TAS[VAsignacion,Tid]);
   TAS[VAsignacion,Tid]^.Elem[1]:= Tid;
   TAS[VAsignacion,Tid]^.Elem[2]:= VOperacionAsig;
   TAS[VAsignacion,Tid]^.Cant:=2;

   //OperacionAsig -> "=" <EA1>
   New(TAS[VOperacionAsig,TAsignacion]);
   TAS[VOperacionAsig,TAsignacion]^.Elem[1]:=TAsignacion;
   TAS[VOperacionAsig,TAsignacion]^.Elem[2]:=VEA1;
   TAS[VOperacionAsig,TAsignacion]^.Cant:=2;

   //OperacionAsig -> ":==" <EM>
   New(TAS[VOperacionAsig,TAsigMatriz]);
   TAS[VOperacionAsig,TAsignacion]^.Elem[1]:=TAsigMatriz;
   TAS[VOperacionAsig,TAsignacion]^.Elem[2]:=VEM;
   TAS[VOperacionAsig,TAsignacion]^.Cant:=2;

   //OperacionAsig -> "["<EA1> "," <EA1> "]" "=" <EA1>
   New(TAS[VOperacionAsig,TCorcheteL]);
   TAS[VOperacionAsig,TCorcheteL]^.Elem[1]:=TCorcheteL;
   TAS[VOperacionAsig,TCorcheteL]^.Elem[2]:=VEA1;
   TAS[VOperacionAsig,TcorcheteL]^.Elem[3]:=TComa;
   TAS[VOperacionAsig,TCorcheteL]^.Elem[4]:=VEA1;
   TAS[VOperacionAsig,TCorcheteL]^.Elem[5]:=TCorcheteR;
   TAS[VOperacionAsig,TCorcheteL]^.Elem[6]:=TAsignacion;
   TAS[VOperacionAsig,TCorcheteL]^.Elem[7]:=VEA1;
   TAS[VOperacionAsig,TAsignacion]^.Cant:=7;

   //EA1 -> <EA2> <E1>
   New(TAS[VEA1,TconstReal]);
   TAS[VEA1,TConstReal]^.Elem[1]:= VEA2;
   TAS[VEA1,TConstReal]^.Elem[2]:= VE1;
   TAS[VEA1,TConstReal]^.Cant:= 2;

   //EA1 -> <EA2> <E1>
   New(TAS[VEA1,Tid]);
   TAS[VEA1,Tid]^.Elem[1]:= VEA2;
   TAS[VEA1,Tid]^.Elem[2]:= VE1;
   TAS[VEA1,Tid]^.Cant:= 2;

   //EA1 -> <EA2> <E1>
   New(TAS[VEA1,TParentesisL]);
   TAS[VEA1,TParentesisL]^.Elem[1]:= VEA2;
   TAS[VEA1,TParentesisL]^.Elem[2]:= VE1;
   TAS[VEA1,TParentesisL]^.Cant:= 2;

   //EA1 -> <EA2> <E1>
   New(TAS[VEA1,TfTam]);
   TAS[VEA1,TfTam]^.Elem[1]:= VEA2;
   TAS[VEA1,TfTam]^.Elem[2]:= VE1;
   TAS[VEA1,TfTam]^.Cant:= 2;

   //EA1 -> <EA2> <E1>
   New(TAS[VEA1,TMenos]);
   TAS[VEA1,TMenos]^.Elem[1]:= VEA2;
   TAS[VEA1,TMenos]^.Elem[2]:= VE1;
   TAS[VEA1,TMenos]^.Cant:= 2;

   //E1 -> "+" <EA2> <E1>
   New(TAS[VE1,TMas]);
   TAS[VE1,TMas]^.Elem[1]:= TMas;
   TAS[VE1,TMas]^.Elem[2]:= VEA2;
   TAS[VE1,TMas]^.Elem[3]:= VE1;
   TAS[VE1,TMas]^.Cant:= 3;

   //E1 -> "-" <EA2> <E1>
   New(TAS[VE1,TMenos]);
   TAS[VE1,TMenos]^.Elem[1]:= TMenos;
   TAS[VE1,TMenos]^.Elem[2]:= VEA2;
   TAS[VE1,TMenos]^.Elem[3]:= VE1;
   TAS[VE1,TMenos]^.Cant:= 3;

   //E1 -> Epsilon
   New(TAS[VE1,]);            ///NO SE QUE PONER
   TAS[VE1,]^.Cant:=0;

   //EA2 -> <EA3> <E2>
   New(TAS[VEA2,TconstReal]);
   TAS[VEA2,TConstReal]^.Elem[1]:= VEA3;
   TAS[VEA2,TConstReal]^.Elem[2]:= VE2;
   TAS[VEA2,TConstReal]^.Cant:= 2;

   //EA2 -> <EA3> <E2>
   New(TAS[VEA2,Tid]);
   TAS[VEA2,Tid]^.Elem[1]:= VEA3;
   TAS[VEA2,Tid]^.Elem[2]:= VE2;
   TAS[VEA2,Tid]^.Cant:= 2;

   //EA2 -> <EA3> <E2>
   New(TAS[VEA2,TParentesisL]);
   TAS[VEA2,TParentesisL]^.Elem[1]:= VEA3;
   TAS[VEA2,TParentesisL]^.Elem[2]:= VE2;
   TAS[VEA2,TParentesisL]^.Cant:= 2;

   //EA2 -> <EA3> <E2>
   New(TAS[VEA2,TfTam]);
   TAS[VEA2,TfTam]^.Elem[1]:= VEA3;
   TAS[VEA2,TfTam]^.Elem[2]:= VE2;
   TAS[VEA2,TfTam]^.Cant:= 2;

   //EA2 -> <EA3> <E2>
   New(TAS[VEA2,TMenos]);
   TAS[VEA2,TMenos]^.Elem[1]:= VEA3;
   TAS[VEA2,TMenos]^.Elem[2]:= VE2;
   TAS[VEA2,TMenos]^.Cant:= 2;

   //E2 -> "*" <EA3>
   New(TAS[VE2,TMult]);
   TAS[VE2,TMult]^.Elem[1]:= TMult;
   TAS[VE2,TMult]^.Elem[2]:= VEA3;
   TAS[VE2,TMult]^.Cant:= 2;

   //E2 -> "/" <EA3>
   New(TAS[VE2,TDiv]);
   TAS[VE2,TDiv]^.Elem[1]:= TDiv;
   TAS[VE2,TDiv]^.Elem[2]:= VEA3;
   TAS[VE2,TDiv]^.Cant:= 2;

   //E2 -> Epsilon
   New(TAS[VE2,]);            ///NO SE QUE PONER
   TAS[VE2,]^.Cant:=0;










  End;
End.

