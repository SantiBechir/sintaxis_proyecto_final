Unit AnalizadorSintactico ;

Interface

Uses
 Crt,Tipo,Lexico,Arbol,Archivo,Lista, Pila;
Const
 Max = 15;
Type
 TProduccion= Record    //registro para producciones de la TAS
    Elem: Array [1..Max] of GramaticalSymbol;
    Cant:0..Max;
              End;

  TVariable = VPrograma..VfTam;                //filas:rango de variables
  TTerminales = TProgram..pesos;             //columnas:rango de terminales

  TTAS = Array [TVariable, TTerminales] of ^TProduccion;


 Procedure AnalizadorPredictivo(Var Fuente:t_arch; Var Raiz:TApuntNodo; Var Error:Boolean);
 Procedure TestingAnalizadorSintactico(Var FFuente:t_arch);
 procedure MOSTRAR_TAS(var TAS: TTAS);

Implementation


Procedure InicializarTAS(Var TAS: TTAS);
 Var I,J:GramaticalSymbol;
  Begin
   For I := VPrograma to VfTam do
    Begin
     For J:= TProgram to pesos do
      Begin
       TAS[I,J]:=Nil; //Completa cada celda de la TAS le asigno nil
      End;
    End;
  End;

Procedure InstalarEnTS(Lexema:String; Var TS:TablaSimbolos; Var CompLex:GramaticalSymbol );
 Var
  Reg:TelemTS;
  V:Puntero;
  Encontrado:Boolean;
 Begin
  Encontrado:=False; //inicializo con falso
  V:=TS.Cab;   //para que V APUNTE a la cabecera de la lista de palabras reservadas
   While (V<>Nil) And Not(Encontrado) do
    Begin
     If Upcase(V^.Info.Lexema)= Upcase(Lexema) then   //le aplico upcase por si hay diferencias entre minusculas y mayusculas entre el lexema que se quiere comparar y el lexema de la TS
      Encontrado:=True
     else
      V:=V^.Sig;   //para apuntar al siguiente elemento de la lista de palabras reservadas
    End;
   If encontrado then
    Complex:=V^.Info.CompLex       //si se encontro la palabra reservada se le asigna a complex
   Else
    Begin
     Reg.Lexema:=Lexema;       //si se encontro un identificador se asiga el lexema correspondiente a ese identific
     Reg.CompLex:=Tid;         //tambien se guarda el tipo de componente lexico identificador en el complex
     Complex:=Reg.CompLex;     //le asigno a complex el valor del de reg.complex el cual tiene el componente lexico identificador
     Cargar(TS,reg);
    End;
 End;

Procedure Recuperar(L:TablaSimbolos; Var E:TelemTS);
 Begin
  E:=L.Act^.Info;
 End;

Procedure CargarTAS(Var TAS:TTAS);
 Var I,J:GramaticalSymbol;          //todos los elementos de la tas son punteros a registros y esos registros conforman una lista
  Begin

  // Vprogram -->  “Program” <Dec> “{” <Cuerpo> "}" (ES UNA MATRIZ DE PUNTEROS A LISTAS)

   New(TAS[Vprograma,Tprogram ]);
   TAS[Vprograma,Tprogram]^.Elem[1]:= Tprogram; //en la primer posicion del arreglo guardare el primer simbolo de la parte derecha de la produccion  en este caso el primer elemento es program
   TAS[Vprograma,Tprogram]^.Elem[2]:= VDec;
   TAS[Vprograma,Tprogram]^.Elem[3]:= TLlaveL;
   TAS[Vprograma,Tprogram]^.Elem[4]:= VCuerpo;
   TAS[Vprograma,Tprogram]^.Elem[5]:= TLlaveR;
   TAS[Vprograma,Tprogram]^.Cant:= 5;

  //Dec ->  "id" ":" <Variable> ";" <Dec>
   New(TAS[VDec ,Tid]);
   TAS[VDec ,Tid]^.Elem[1]:= Tid;
   TAS[VDec ,Tid]^.Elem[2]:= TDosPuntos;
   TAS[VDec ,Tid]^.Elem[3]:= VVariable;
   TAS[VDec ,Tid]^.Elem[4]:= TPuntoComa;
   TAS[VDec, Tid]^.Elem[5]:= VDec;
   TAS[VDec ,Tid]^.Cant:= 5;

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

   //MatrizReal -> "[" "constReal" "#" "constReal"  "]"
   New(TAS[VMatrizReal,TCorcheteL]);
   TAS[VMatrizReal,TCorcheteL]^.Elem[1]:= TCorcheteL;
   TAS[VMatrizReal,TCorcheteL]^.Elem[2]:= TconstReal;
   TAS[VMatrizReal,TCorcheteL]^.Elem[3]:= TNumeral;
   TAS[VMatrizReal,TCorcheteL]^.Elem[4]:= TconstReal;
   TAS[VMatrizReal,TCorcheteL]^.Elem[5]:= TCorcheteR;
   TAS[VMatrizReal,TCorcheteL]^.Cant:=5;

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

   //-Seguido -> <Cuerpo>
   New(TAS[VSeguido,Tid]);
   TAS[VSeguido,Tid]^.Elem[1]:= VCuerpo;
   TAS[VSeguido,Tid]^.Cant:=1;

   //-Seguido -> <Cuerpo>
   New(TAS[VSeguido,TRead]);
   TAS[VSeguido,TRead]^.Elem[1]:= VCuerpo;
   TAS[VSeguido,TRead]^.Cant:=1;

   //-Seguido -> <Cuerpo>
   New(TAS[VSeguido,TPrint]);
   TAS[VSeguido,TPrint]^.Elem[1]:= VCuerpo;
   TAS[VSeguido,TPrint]^.Cant:=1;

   //-Seguido -> <Cuerpo>
   New(TAS[VSeguido,TIf]);
   TAS[VSeguido,TIf]^.Elem[1]:= VCuerpo;
   TAS[VSeguido,TIf]^.Cant:=1;

   //-Seguido -> <Cuerpo>
   New(TAS[VSeguido,TWhile]);
   TAS[VSeguido,TWhile]^.Elem[1]:= VCuerpo;
   TAS[VSeguido,TWhile]^.Cant:=1;


   //-Seguido -> Eps
   New(TAS[VSeguido,TllaveR]);                 ///--------EPS--------
   TAS[VSeguido,TllaveR]^.Cant:=0;


   //-Sent -> <Asignacion> ";"
   New(TAS[VSent,Tid]);
   TAS[VSent,Tid]^.Elem[1]:= VAsignacion;
   TAS[VSent,Tid]^.Elem[2]:= TPuntoComa;
   TAS[VSent,Tid]^.Cant:=2;

   //-Sent -> <Lectura> ";"
   New(TAS[VSent,TRead]);
   TAS[VSent,TRead]^.Elem[1]:= VLectura;
   TAS[VSent,TRead]^.Elem[2]:= TPuntoComa;
   TAS[VSent,TRead]^.Cant:=2;

   //-Sent -> <Escritura> ";"
   New(TAS[VSent,TPrint]);
   TAS[VSent,TPrint]^.Elem[1]:= VEscritura;
   TAS[VSent,TPrint]^.Elem[2]:= TPuntoComa;
   TAS[VSent,TPrint]^.Cant:=2;

   //-Sent -> <Condicional>
   New(TAS[VSent,TIf]);
   TAS[VSent,TIf]^.Elem[1]:= VCondicional;
   TAS[VSent,TIf]^.Cant:=1;

   //-Sent -> <Ciclo>
   New(TAS[VSent,TWhile]);
   TAS[VSent,TWhile]^.Elem[1]:= VCiclo;
   TAS[VSent,TWhile]^.Cant:=1;

   //-Asignacion -> "id" <OperacionAsig>
   New(TAS[VAsignacion,Tid]);
   TAS[VAsignacion,Tid]^.Elem[1]:= Tid;
   TAS[VAsignacion,Tid]^.Elem[2]:= VOperacionAsig;
   TAS[VAsignacion,Tid]^.Cant:=2;

   //-OperacionAsig -> "=" <EA1>
   New(TAS[VOperacionAsig,TAsignacion]);
   TAS[VOperacionAsig,TAsignacion]^.Elem[1]:=TAsignacion;
   TAS[VOperacionAsig,TAsignacion]^.Elem[2]:=VEA1;
   TAS[VOperacionAsig,TAsignacion]^.Cant:=2;

   //--OperacionAsig -> ":==" <EM>                                    --- ERROR ----
   New(TAS[VOperacionAsig,TasigMatriz]);
   TAS[VOperacionAsig,TasigMatriz]^.Elem[1]:=TAsigMatriz;
   TAS[VOperacionAsig,TasigMatriz]^.Elem[2]:=VEM;
   TAS[VOperacionAsig,TasigMatriz]^.Cant:=2;

   //-OperacionAsig -> "["<EA1> "," <EA1> "]" "=" <EA1>
   New(TAS[VOperacionAsig,TCorcheteL]);
   TAS[VOperacionAsig,TCorcheteL]^.Elem[1]:=TCorcheteL;
   TAS[VOperacionAsig,TCorcheteL]^.Elem[2]:=VEA1;
   TAS[VOperacionAsig,TcorcheteL]^.Elem[3]:=TComa;
   TAS[VOperacionAsig,TCorcheteL]^.Elem[4]:=VEA1;
   TAS[VOperacionAsig,TCorcheteL]^.Elem[5]:=TCorcheteR;
   TAS[VOperacionAsig,TCorcheteL]^.Elem[6]:=TAsignacion;
   TAS[VOperacionAsig,TCorcheteL]^.Elem[7]:=VEA1;
   TAS[VOperacionAsig,TAsignacion]^.Cant:=7;

   //-EA1 -> <EA2> <E1>
   New(TAS[VEA1,TconstReal]);
   TAS[VEA1,TConstReal]^.Elem[1]:= VEA2;
   TAS[VEA1,TConstReal]^.Elem[2]:= VE1;
   TAS[VEA1,TConstReal]^.Cant:= 2;

   //-EA1 -> <EA2> <E1>
   New(TAS[VEA1,Tid]);
   TAS[VEA1,Tid]^.Elem[1]:= VEA2;
   TAS[VEA1,Tid]^.Elem[2]:= VE1;
   TAS[VEA1,Tid]^.Cant:= 2;

   //-EA1 -> <EA2> <E1>
   New(TAS[VEA1,TParentesisL]);
   TAS[VEA1,TParentesisL]^.Elem[1]:= VEA2;
   TAS[VEA1,TParentesisL]^.Elem[2]:= VE1;
   TAS[VEA1,TParentesisL]^.Cant:= 2;

   //-EA1 -> <EA2> <E1>
   New(TAS[VEA1,TfTam]);
   TAS[VEA1,TfTam]^.Elem[1]:= VEA2;
   TAS[VEA1,TfTam]^.Elem[2]:= VE1;
   TAS[VEA1,TfTam]^.Cant:= 2;

   //-EA1 -> <EA2> <E1>
   New(TAS[VEA1,TMenos]);
   TAS[VEA1,TMenos]^.Elem[1]:= VEA2;
   TAS[VEA1,TMenos]^.Elem[2]:= VE1;
   TAS[VEA1,TMenos]^.Cant:= 2;

   ///

   //-E1 -> "+" <EA2> <E1>
   New(TAS[VE1,TMas]);
   TAS[VE1,TMas]^.Elem[1]:= TMas;
   TAS[VE1,TMas]^.Elem[2]:= VEA2;
   TAS[VE1,TMas]^.Elem[3]:= VE1;
   TAS[VE1,TMas]^.Cant:= 3;

   //-E1 -> "-" <EA2> <E1>
   New(TAS[VE1,TMenos]);
   TAS[VE1,TMenos]^.Elem[1]:= TMenos;
   TAS[VE1,TMenos]^.Elem[2]:= VEA2;
   TAS[VE1,TMenos]^.Elem[3]:= VE1;
   TAS[VE1,TMenos]^.Cant:= 3;


   //-E1 -> Epsilon
   New(TAS[VE1,TOPR]);                     ///--------EPS--------
   TAS[VE1,TOPR]^.Cant:=0;

   //-E1 -> Epsilon
   New(TAS[VE1,TComa]);
   TAS[VE1,TComa]^.Cant:=0;

   //-E1 -> Epsilon
   New(TAS[VE1,TcorcheteR]);
   TAS[VE1,TcorcheteR]^.Cant:=0;

   //-E1 -> Epsilon
   New(TAS[VE1,TParentesisR]);
   TAS[VE1,TParentesisR]^.Cant:=0;

   //-E1 -> Epsilon
   New(TAS[VE1,Tpuntocoma]);
   TAS[VE1,Tpuntocoma]^.Cant:=0;

   //-E1 -> Epsilon
   New(TAS[VE1,TThen]);
   TAS[VE1,TThen]^.Cant:=0;

   //-E1 -> Epsilon
   New(TAS[VE1,TDo]);
   TAS[VE1,TDo]^.Cant:=0;


   //-EA2 -> <EA3> <E2>
   New(TAS[VEA2,TconstReal]);
   TAS[VEA2,TConstReal]^.Elem[1]:= VEA3;
   TAS[VEA2,TConstReal]^.Elem[2]:= VE2;
   TAS[VEA2,TConstReal]^.Cant:= 2;

   //-EA2 -> <EA3> <E2>
   New(TAS[VEA2,Tid]);
   TAS[VEA2,Tid]^.Elem[1]:= VEA3;
   TAS[VEA2,Tid]^.Elem[2]:= VE2;
   TAS[VEA2,Tid]^.Cant:= 2;

   //-EA2 -> <EA3> <E2>
   New(TAS[VEA2,TParentesisL]);
   TAS[VEA2,TParentesisL]^.Elem[1]:= VEA3;
   TAS[VEA2,TParentesisL]^.Elem[2]:= VE2;
   TAS[VEA2,TParentesisL]^.Cant:= 2;

   //-EA2 -> <EA3> <E2>
   New(TAS[VEA2,TfTam]);
   TAS[VEA2,TfTam]^.Elem[1]:= VEA3;
   TAS[VEA2,TfTam]^.Elem[2]:= VE2;
   TAS[VEA2,TfTam]^.Cant:= 2;

   //-EA2 -> <EA3> <E2>
   New(TAS[VEA2,TMenos]);
   TAS[VEA2,TMenos]^.Elem[1]:= VEA3;
   TAS[VEA2,TMenos]^.Elem[2]:= VE2;
   TAS[VEA2,TMenos]^.Cant:= 2;

   //-E2 -> "*" <EA3>
   New(TAS[VE2,TMult]);
   TAS[VE2,TMult]^.Elem[1]:= TMult;
   TAS[VE2,TMult]^.Elem[2]:= VEA3;
   TAS[VE2,TMult]^.Cant:= 2;

   //-E2 -> "/" <EA3>
   New(TAS[VE2,TDiv]);
   TAS[VE2,TDiv]^.Elem[1]:= TDiv;
   TAS[VE2,TDiv]^.Elem[2]:= VEA3;
   TAS[VE2,TDiv]^.Cant:= 2;

   //E2 -> Epsilon
   //
   New(TAS[VE2,TMas]);
   TAS[VE2,TMas]^.Cant:=0;

   //
   New(TAS[VE2,TMenos]);
   TAS[VE2,TMenos]^.Cant:=0;

   //
   New(TAS[VE2,TOPR]);
   TAS[VE2,TOPR]^.Cant:=0;

   //
   New(TAS[VE2,TComa]);
   TAS[VE2,TComa]^.Cant:=0;

   //
   New(TAS[VE2,TcorcheteR]);
   TAS[VE2,TcorcheteR]^.Cant:=0;

   //
   New(TAS[VE2,TParentesisR]);
   TAS[VE2,TParentesisR]^.Cant:=0;

   //
   New(TAS[VE2,Tpuntocoma]);
   TAS[VE2,Tpuntocoma]^.Cant:=0;

   //
   New(TAS[VE2,TThen]);
   TAS[VE2,TThen]^.Cant:=0;

   //
   New(TAS[VE2,TDo]);
   TAS[VE2,TDo]^.Cant:=0;

   ///

   //-EA3 -> <EA4> <E3>
   New(TAS[VEA3,TconstReal]);
   TAS[VEA3,TconstReal]^.Elem[1]:= VEA4;
   TAS[VEA3,TconstReal]^.Elem[2]:= VE3;
   TAS[VEA3,TconstReal]^.Cant:= 2;

   //-EA3 -> <EA4> <E3>
   New(TAS[VEA3,Tid]);
   TAS[VEA3,Tid]^.Elem[1]:= VEA4;
   TAS[VEA3,Tid]^.Elem[2]:= VE3;
   TAS[VEA3,Tid]^.Cant:= 2;

   //-EA3 -> <EA4> <E3>
   New(TAS[VEA3,TParentesisL]);
   TAS[VEA3,TParentesisL]^.Elem[1]:= VEA4;
   TAS[VEA3,TParentesisL]^.Elem[2]:= VE3;
   TAS[VEA3,TParentesisL]^.Cant:= 2;

   //-EA3 -> <EA4> <E3>
   New(TAS[VEA3,TfTam]);
   TAS[VEA3,TfTam]^.Elem[1]:= VEA4;
   TAS[VEA3,TfTam]^.Elem[2]:= VE3;
   TAS[VEA3,TfTam]^.Cant:= 2;

   //-EA3 -> <EA4> <E3>
   New(TAS[VEA3,TMenos]);
   TAS[VEA3,TMenos]^.Elem[1]:= VEA4;
   TAS[VEA3,TMenos]^.Elem[2]:= VE3;
   TAS[VEA3,TMenos]^.Cant:= 2;

   //-E3 -> "^" <EA4>
   New(TAS[VE3,TExp]);
   TAS[VE3,TExp]^.Elem[1]:= TExp;
   TAS[VE3,TExp]^.Elem[2]:= VEA4;
   TAS[VE3,TExp]^.Cant:= 2;

   //E3 -> eps
   //
   New(TAS[VE3,TMult]);
   TAS[VE3,TMult]^.Cant:= 0;

   //
   New(TAS[VE3,TDiv]);
   TAS[VE3,TDiv]^.Cant:= 0;

   //
   New(TAS[VE3,TMenos]);
   TAS[VE3,TMenos]^.Cant:= 0;

   //
   New(TAS[VE3,TMas]);
   TAS[VE3,TMas]^.Cant:= 0;

   //
   New(TAS[VE3,TOPR]);
   TAS[VE3,TOPR]^.Cant:= 0;

   //
   New(TAS[VE3,TComa]);
   TAS[VE3,TComa]^.Cant:= 0;

   //
   New(TAS[VE3,TcorcheteR]);
   TAS[VE3,TcorcheteR]^.Cant:= 0;

   //
    New(TAS[VE3,TParentesisR]);
   TAS[VE3,TParentesisR]^.Cant:= 0;

   //
   New(TAS[VE3,Tpuntocoma]);
   TAS[VE3,Tpuntocoma]^.Cant:= 0;

   //
   New(TAS[VE3,TThen]);
   TAS[VE3,TThen]^.Cant:= 0;

   //
   New(TAS[VE3,TDo]);
   TAS[VE3,TDo]^.Cant:= 0;


   ///

   //-EA4 -> "constReal"
   New(TAS[VEA4,TconstReal]);
   TAS[VEA4,TconstReal]^.Elem[1]:= TconstReal;
   TAS[VEA4,TconstReal]^.Cant:= 1;

   //-EA4 -> "id" <E4>
   New(TAS[VEA4,Tid]);
   TAS[VEA4,Tid]^.Elem[1]:= Tid;
   TAS[VEA4,Tid]^.Elem[2]:= VE4;
   TAS[VEA4,Tid]^.Cant:= 2;

   //-EA4 -> "(" <EA1> ")"
   New(TAS[VEA4,TParentesisL]);
   TAS[VEA4,TParentesisL]^.Elem[1]:= TParentesisL;
   TAS[VEA4,TParentesisL]^.Elem[2]:= VEA1;
   TAS[VEA4,TParentesisL]^.Elem[3]:= TParentesisR;
   TAS[VEA4,TParentesisL]^.Cant:= 3;

   //-EA4 -> <FTAM>
   New(TAS[VEA4,TfTam]);
   TAS[VEA4,TfTam]^.Elem[1]:= VFTAM;
   TAS[VEA4,TfTam]^.Cant:= 1;

   //-EA4 -> "-" <EA4>
   New(TAS[VEA4,TMenos]);
   TAS[VEA4,TMenos]^.Elem[1]:= TMenos;
   TAS[VEA4,TMenos]^.Elem[2]:= VEA4;
   TAS[VEA4,TMenos]^.Cant:= 2;

   //E4 -> eps

   //
   New(TAS[VE4,TExp]);
   TAS[VE4,TExp]^.Cant:= 0;

   //
   New(TAS[VE4,TMult]);
   TAS[VE4,TMult]^.Cant:= 0;

   //
   New(TAS[VE4,TDiv]);
   TAS[VE4,TDiv]^.Cant:= 0;

   //
   New(TAS[VE4,TMenos]);
   TAS[VE4,TMenos]^.Cant:= 0;

   //
   New(TAS[VE4,TMas]);
   TAS[VE4,TMas]^.Cant:= 0;

   //
   New(TAS[VE4,TOPR]);
   TAS[VE4,TOPR]^.Cant:= 0;

   //
   New(TAS[VE4,TComa]);
   TAS[VE4,TComa]^.Cant:= 0;

   //
   New(TAS[VE4,TcorcheteR]);
   TAS[VE4,TcorcheteR]^.Cant:= 0;

   //
   New(TAS[VE4,TParentesisR]);
   TAS[VE4,TParentesisR]^.Cant:= 0;

   //
   New(TAS[VE4,Tpuntocoma]);
   TAS[VE4,Tpuntocoma]^.Cant:= 0;

   //
   New(TAS[VE4,TThen]);
   TAS[VE4,TThen]^.Cant:= 0;

   //
   New(TAS[VE4,TDo]);
   TAS[VE4,TDo]^.Cant:= 0;

   //-E4 -> "[" <EA1> "," <EA1> "]"
   New(TAS[VE4,TcorcheteL]);
   TAS[VE4,TcorcheteL]^.Elem[1]:= TcorcheteL;
   TAS[VE4,TcorcheteL]^.Elem[2]:= VEA1;
   TAS[VE4,TcorcheteL]^.Elem[3]:= TComa;
   TAS[VE4,TcorcheteL]^.Elem[4]:= VEA1;
   TAS[VE4,TcorcheteL]^.Elem[5]:= TcorcheteR;
   TAS[VE4,TcorcheteL]^.Cant:= 5;

   //-EM -> <EM1> <M1>
   New(TAS[VEM,TTr]);
   TAS[VEM,TTr]^.Elem[1]:= VEM1;
   TAS[VEM,TTr]^.Elem[2]:= VM1;
   TAS[VEM,TTr]^.Cant:= 2;

   //-EM -> <EM1> <M1>
   New(TAS[VEM,TProdEscMat]);
   TAS[VEM,TProdEscMat]^.Elem[1]:= VEM1;
   TAS[VEM,TProdEscMat]^.Elem[2]:= VM1;
   TAS[VEM,TProdEscMat]^.Cant:= 2;

   //-EM -> <EM1> <M1>
   New(TAS[VEM,Tid]);
   TAS[VEM,Tid]^.Elem[1]:= VEM1;
   TAS[VEM,Tid]^.Elem[2]:= VM1;
   TAS[VEM,Tid]^.Cant:= 2;

   //-EM -> <EM1> <M1>
   New(TAS[VEM,TcorcheteL]);
   TAS[VEM,TcorcheteL]^.Elem[1]:= VEM1;
   TAS[VEM,TcorcheteL]^.Elem[2]:= VM1;
   TAS[VEM,TcorcheteL]^.Cant:= 2;

   //-M1 -> "SumMat" "(" <EM> "," <EM> ")"
   New(TAS[VM1,TSumMat]);
   TAS[VM1,TSumMat]^.Elem[1]:= TSumMat;
   TAS[VM1,TSumMat]^.Elem[2]:= TParentesisL;
   TAS[VM1,TSumMat]^.Elem[3]:= VEM;
   TAS[VM1,TSumMat]^.Elem[4]:= TComa;
   TAS[VM1,TSumMat]^.Elem[5]:= VEM;
   TAS[VM1,TSumMat]^.Elem[6]:= TParentesisR;
   TAS[VM1,TSumMat]^.Cant:= 6;

   //-M1 -> "RestMat" "(" <EM> "," <EM> ")"
   New(TAS[VM1,TRestMat]);
   TAS[VM1,TRestMat]^.Elem[1]:= TRestMat;
   TAS[VM1,TRestMat]^.Elem[2]:= TParentesisL;
   TAS[VM1,TRestMat]^.Elem[3]:= VEM;
   TAS[VM1,TRestMat]^.Elem[4]:= TComa;
   TAS[VM1,TRestMat]^.Elem[5]:= VEM;
   TAS[VM1,TRestMat]^.Elem[6]:= TParentesisR;
   TAS[VM1,TRestMat]^.Cant:= 6;

   //M1 -> eps

   //
   New(TAS[VM1,TParentesisR]);
   TAS[VM1,TParentesisR]^.Cant:=0;

   //
   New(TAS[VM1,TComa]);
   TAS[VM1,TComa]^.Cant:=0;

   //
   New(TAS[VM1,Tpuntocoma]);
   TAS[VM1,Tpuntocoma]^.Cant:=0;


   //-EM1 -> <EM2> <M2>
   New(TAS[VEM1,TTr]);
   TAS[VEM1,TTr]^.Elem[1]:= VEM2;
   TAS[VEM1,TTr]^.Elem[2]:= VM2;
   TAS[VEM1,TTr]^.Cant:= 2;

   //-EM1 -> <EM2> <M2>
   New(TAS[VEM1,TProdEscMat]);
   TAS[VEM1,TProdEscMat]^.Elem[1]:= VEM2;
   TAS[VEM1,TProdEscMat]^.Elem[2]:= VM2;
   TAS[VEM1,TProdEscMat]^.Cant:= 2;

   //-EM1 -> <EM2> <M2>
   New(TAS[VEM1,Tid]);
   TAS[VEM1,Tid]^.Elem[1]:= VEM2;
   TAS[VEM1,Tid]^.Elem[2]:= VM2;
   TAS[VEM1,Tid]^.Cant:= 2;

   //-EM1 -> <EM2> <M2>
   New(TAS[VEM1,TcorcheteL]);
   TAS[VEM1,TcorcheteL]^.Elem[1]:= VEM2;
   TAS[VEM1,TcorcheteL]^.Elem[2]:= VM2;
   TAS[VEM1,TcorcheteL]^.Cant:= 2;

   //-M2 -> "MultMat" "(" <EM> "," <EM> )"
   New(TAS[VM2,TMultMat]);
   TAS[VM2,TMultMat]^.Elem[1]:= TMultMat;
   TAS[VM2,TMultMat]^.Elem[2]:= TParentesisL;
   TAS[VM2,TMultMat]^.Elem[3]:= VEM;
   TAS[VM2,TMultMat]^.Elem[4]:= TComa;
   TAS[VM2,TMultMat]^.Elem[5]:= VEM;
   TAS[VM2,TMultMat]^.Elem[6]:= TParentesisR;
   TAS[VM2,TMultMat]^.Cant:= 6;

   //M2 -> eps

   //
   New(TAS[VM2,TSumMat]);
   TAS[VM2,TSumMat]^.Cant:= 0;

   //
   New(TAS[VM2,TRestMat]);
   TAS[VM2,TRestMat]^.Cant:= 0;

   //
   New(TAS[VM2,Tpuntocoma]);
   TAS[VM2,Tpuntocoma]^.Cant:= 0;

   //
   New(TAS[VM2,TComa]);
   TAS[VM2,TComa]^.Cant:= 0;

   //
   New(TAS[VM2,TParentesisR]);
   TAS[VM2,TParentesisR]^.Cant:= 0;

   ///

   //-EM2 -> "Tr" "(" <EM> ")"
   New(TAS[VEM2,TTr]);
   TAS[VEM2,TTr]^.Elem[1]:= TTr;
   TAS[VEM2,TTr]^.Elem[2]:= TParentesisL;
   TAS[VEM2,TTr]^.Elem[3]:= VEM;
   TAS[VEM2,TTr]^.Elem[4]:= TParentesisR;
   TAS[VEM2,TTr]^.Cant:= 4;

   //-EM2 -> <EM3>
   New(TAS[VEM2,TProdEscMat]);
   TAS[VEM2,TProdEscMat]^.Elem[1]:= VEM3;
   TAS[VEM2,TProdEscMat]^.Cant:= 1;

   //-EM2 -> <EM3>
   New(TAS[VEM2,Tid]);
   TAS[VEM2,Tid]^.Elem[1]:= VEM3;
   TAS[VEM2,Tid]^.Cant:= 1;

   {//EM2 -> <EM3>
   New(TAS[VEM2,TcorcheteL]);                      --- ERROR ---
   TAS[VEM2,TcorcheteL]^.Elem[1]:= VEM3;
   TAS[VEM2,TcorcheteL]^.Cant:= 1;  }

   //-EM3 -> "ProdEscMat" ( <EA1> "," <EM> )
   New(TAS[VEM3,TProdEscMat]);
   TAS[VEM3,TProdEscMat]^.Elem[1]:= TProdEscMat;
   TAS[VEM3,TProdEscMat]^.Elem[2]:= TParentesisL;
   TAS[VEM3,TProdEscMat]^.Elem[3]:= VEA1;
   TAS[VEM3,TProdEscMat]^.Elem[4]:= TComa;
   TAS[VEM3,TProdEscMat]^.Elem[5]:= VEM;
   TAS[VEM3,TProdEscMat]^.Elem[6]:= TParentesisR;
   TAS[VEM3,TProdEscMat]^.Cant:= 6;

   //-EM3 -> <EMM>
   New(TAS[VEM3,Tid]);
   TAS[VEM3,Tid]^.Elem[1]:= VEMM;
   TAS[VEM3,Tid]^.Cant:= 1;

   //-EM3 -> <EMM>
   New(TAS[VEM3,TcorcheteL]);
   TAS[VEM3,TcorcheteL]^.Elem[1]:= VEMM;
   TAS[VEM3,TcorcheteL]^.Cant:= 1;

   //-EMM -> "id"
   New(TAS[VEMM,Tid]);
   TAS[VEMM,Tid]^.Elem[1]:= Tid;
   TAS[VEMM,Tid]^.Cant:= 1;

   //-EMM -> <constMatriz>
   New(TAS[VEMM,TcorcheteL]);
   TAS[VEMM,TcorcheteL]^.Elem[1]:= VConstMatriz;
   TAS[VEMM,TcorcheteL]^.Cant:= 1;

   //-constMatriz -> "["<Filas>"]"
   New(TAS[VConstMatriz,TcorcheteL]);
   TAS[VConstMatriz,TcorcheteL]^.Elem[1]:= TcorcheteL;
   TAS[VConstMatriz,TcorcheteL]^.Elem[2]:= VFilas;
   TAS[VConstMatriz,TcorcheteL]^.Elem[3]:= TcorcheteR;
   TAS[VConstMatriz,TcorcheteL]^.Cant:= 3;

   //-Filas-> "[" <Columnas> "]" <FacFilas>
   New(TAS[VFilas,TcorcheteL]);
   TAS[VFilas,TcorcheteL]^.Elem[1]:= TcorcheteL;
   TAS[VFilas,TcorcheteL]^.Elem[2]:= VColumnas;
   TAS[VFilas,TcorcheteL]^.Elem[3]:= TcorcheteR;
   TAS[VFilas,TcorcheteL]^.Elem[4]:= VFacFilas;
   TAS[VFilas,TcorcheteL]^.Cant:= 4;

   //-FacFilas -> eps
   New(TAS[VFacFilas,TcorcheteR]);
   TAS[VFacFilas,TcorcheteR]^.Cant:= 0;

   //-FacFilas -> "," <Filas>                             --- ERROR ---
   New(TAS[VFacFilas,TComa]);
   TAS[VFacFilas,TComa]^.Elem[1]:= TComa;
   TAS[VFacFilas,TComa]^.Elem[2]:= VFilas;
   TAS[VFacFilas,TComa]^.Cant:= 2;

   //Columnas -> <EA1> <FacColumnas>
   //
   New(TAS[VColumnas,TconstReal]);
   TAS[VColumnas,TconstReal]^.Elem[1]:= VEA1;
   TAS[VColumnas,TconstReal]^.Elem[2]:= VFacColumnas;
   TAS[VColumnas,TconstReal]^.Cant:= 2;

   //
   New(TAS[VColumnas,Tid]);
   TAS[VColumnas,Tid]^.Elem[1]:= VEA1;
   TAS[VColumnas,Tid]^.Elem[2]:= VFacColumnas;
   TAS[VColumnas,Tid]^.Cant:= 2;

   //
   New(TAS[VColumnas,TParentesisL]);
   TAS[VColumnas,TParentesisL]^.Elem[1]:= VEA1;
   TAS[VColumnas,TParentesisL]^.Elem[2]:= VFacColumnas;
   TAS[VColumnas,TParentesisL]^.Cant:= 2;

   //
   New(TAS[VColumnas,TfTam]);
   TAS[VColumnas,TfTam]^.Elem[1]:= VEA1;
   TAS[VColumnas,TfTam]^.Elem[2]:= VFacColumnas;
   TAS[VColumnas,TfTam]^.Cant:= 2;

   //
   New(TAS[VColumnas,TMenos]);
   TAS[VColumnas,TMenos]^.Elem[1]:= VEA1;
   TAS[VColumnas,TMenos]^.Elem[2]:= VFacColumnas;
   TAS[VColumnas,TMenos]^.Cant:= 2;

   //-FacColumnas -> eps

   New(TAS[VFacColumnas,TcorcheteR]);
   TAS[VFacColumnas,TcorcheteR]^.Cant:= 0;

   //-FacColumnas -> "," <Columnas>

   New(TAS[VFacColumnas,TComa]);
   TAS[VFacColumnas,TComa]^.Elem[1]:= TComa;
   TAS[VFacColumnas,TComa]^.Elem[2]:= VColumnas;
   TAS[VFacColumnas,TComa]^.Cant:= 2;

   //-Lectura -> "read" "(" "constCad" "," "id" ")"
   New(TAS[VLectura,TRead]);
   TAS[VLectura,TRead]^.Elem[1]:= TRead;
   TAS[VLectura,TRead]^.Elem[2]:= TParentesisL;
   TAS[VLectura,TRead]^.Elem[3]:= TconstReal;
   TAS[VLectura,TRead]^.Elem[4]:= TComa;
   TAS[VLectura,TRead]^.Elem[5]:= Tid;
   TAS[VLectura,TRead]^.Elem[6]:= TParentesisR;
   TAS[VLectura,TRead]^.Cant:= 6;

   //-Escritura -> "print" "(" <listaElementos> ")"
   New(TAS[VEscritura,TPrint]);
   TAS[VEscritura,TPrint]^.Elem[1]:= TPrint;
   TAS[VEscritura,TPrint]^.Elem[2]:= TParentesisL;
   TAS[VEscritura,TPrint]^.Elem[3]:= VListaElementos;
   TAS[VEscritura,TPrint]^.Elem[4]:= TParentesisR;
   TAS[VEscritura,TPrint]^.Cant:= 4;

   //listaElementos -> <Elemento> <FacListElem>
   //
   New(TAS[VListaElementos,TConstCad]);
   TAS[VListaElementos,TConstCad]^.Elem[1]:= VElemento;
   TAS[VListaElementos,TConstCad]^.Elem[2]:= VFacListElem;
   TAS[VListaElementos,TConstCad]^.Cant:= 2;

   //
   New(TAS[VListaElementos,Tid]);
   TAS[VListaElementos,Tid]^.Elem[1]:= VElemento;
   TAS[VListaElementos,Tid]^.Elem[2]:= VFacListElem;
   TAS[VListaElementos,Tid]^.Cant:= 2;

   //
   New(TAS[VListaElementos,TconstReal]);
   TAS[VListaElementos,TconstReal]^.Elem[1]:= VElemento;
   TAS[VListaElementos,TconstReal]^.Elem[2]:= VFacListElem;
   TAS[VListaElementos,TconstReal]^.Cant:= 2

   //
   New(TAS[VListaElementos,TParentesisL]);
   TAS[VListaElementos,TParentesisL]^.Elem[1]:= VElemento;
   TAS[VListaElementos,TParentesisL]^.Elem[2]:= VFacListElem;
   TAS[VListaElementos,TParentesisL]^.Cant:= 2;

   //
   New(TAS[VListaElementos,TfTam]);
   TAS[VListaElementos,TfTam]^.Elem[1]:= VElemento;
   TAS[VListaElementos,TfTam]^.Elem[2]:= VFacListElem;
   TAS[VListaElementos,TfTam]^.Cant:= 2;

   //
   New(TAS[VListaElementos,TMenos]);
   TAS[VListaElementos,TMenos]^.Elem[1]:= VElemento;
   TAS[VListaElementos,TMenos]^.Elem[2]:= VFacListElem;
   TAS[VListaElementos,TMenos]^.Cant:= 2;

   //
   New(TAS[VListaElementos,TcorcheteL]);
   TAS[VListaElementos,TcorcheteL]^.Elem[1]:= VElemento;
   TAS[VListaElementos,TcorcheteL]^.Elem[2]:= VFacListElem;
   TAS[VListaElementos,TcorcheteL]^.Cant:= 2;

   //-FacListElem -> "," <listaElementos>
   New(TAS[VFacListElem,TComa]);
   TAS[VFacListElem,TComa]^.Elem[1]:= TComa;
   TAS[VFacListElem,TComa]^.Elem[2]:= VListaElementos;
   TAS[VFacListElem,TComa]^.Cant:= 2;

   //-FacListElem -> eps

   New(TAS[VFacListElem,TParentesisR]);
   TAS[VFacListElem,TParentesisR]^.Cant:= 0;

   //-Elemento -> "constCad"

   New(TAS[VElemento,TConstCad]);
   TAS[VElemento,TConstCad]^.Elem[1]:= TConstCad;
   TAS[VElemento,TConstCad]^.Cant:= 1;

   //Elemento -> <EA1>

   //
   New(TAS[VElemento,TConstReal]);
   TAS[VElemento,TConstReal]^.Elem[1]:= VEA1;
   TAS[VElemento,TConstReal]^.Cant:= 1;

   //
   New(TAS[VElemento,Tid]);
   TAS[VElemento,Tid]^.Elem[1]:= VEA1;
   TAS[VElemento,Tid]^.Cant:= 1;

   //
   New(TAS[VElemento,TParentesisL]);
   TAS[VElemento,TParentesisL]^.Elem[1]:= VEA1;
   TAS[VElemento,TParentesisL]^.Cant:= 1;

   //
   New(TAS[VElemento,TfTam]);
   TAS[VElemento,TfTam]^.Elem[1]:= VEA1;
   TAS[VElemento,TfTam]^.Cant:= 1;

   //
   New(TAS[VElemento,TMenos]);
   TAS[VElemento,TMenos]^.Elem[1]:= VEA1;
   TAS[VElemento,TMenos]^.Cant:= 1;

   //-Elemento -> <constMatriz>

   New(TAS[VElemento,TcorcheteL]);
   TAS[VElemento,TcorcheteL]^.Elem[1]:= VConstMatriz;
   TAS[VElemento,TcorcheteL]^.Cant:= 1;


   //-Condicional -> "If" <Cond> "then" "{" <Cuerpo> "}" <FacCondicional>

   New(TAS[VCondicional,TIf]);
   TAS[VCondicional,TIf]^.Elem[1]:= TIf;
   TAS[VCondicional,TIf]^.Elem[2]:= VCond;
   TAS[VCondicional,TIf]^.Elem[3]:= TThen;
   TAS[VCondicional,TIf]^.Elem[4]:= TllaveL;
   TAS[VCondicional,TIf]^.Elem[5]:= VCuerpo;
   TAS[VCondicional,TIf]^.Elem[6]:= TllaveR;
   TAS[VCondicional,TIf]^.Elem[7]:= VFacCondicional;
   TAS[VCondicional,TIf]^.Cant:= 7;

   //-FacCondicional -> "else" "{" <Cuerpo> "}"

   New(TAS[VFacCondicional,TElse]);
   TAS[VFacCondicional,TElse]^.Elem[1]:= TElse;
   TAS[VFacCondicional,TElse]^.Elem[2]:= TllaveL;
   TAS[VFacCondicional,TElse]^.Elem[3]:= VCuerpo;
   TAS[VFacCondicional,TElse]^.Elem[4]:= TllaveR;
   TAS[VFacCondicional,TElse]^.Cant:= 4;

   // FacCondicional -> eps

   //
   New(TAS[VFacCondicional,Tid]);
   TAS[VFacCondicional,Tid]^.Cant:= 0;

   //
   New(TAS[VFacCondicional,TRead]);
   TAS[VFacCondicional,TRead]^.Cant:= 0;

   //
   New(TAS[VFacCondicional,TPrint]);
   TAS[VFacCondicional,TPrint]^.Cant:= 0;

   //
   New(TAS[VFacCondicional,TIf]);
   TAS[VFacCondicional,TIf]^.Cant:= 0;

   //
   New(TAS[VFacCondicional,TWhile]);
   TAS[VFacCondicional,TWhile]^.Cant:= 0;

   //
   New(TAS[VFacCondicional,TllaveR]);
   TAS[VFacCondicional,TllaveR]^.Cant:= 0;

   //-Ciclo -> "While" <Cond> "do" "{" <Cuerpo> "}"

   New(TAS[VCiclo,TWhile]);
   TAS[VCiclo,TWhile]^.Elem[1]:= TWhile;
   TAS[VCiclo,TWhile]^.Elem[2]:= VCond;
   TAS[VCiclo,TWhile]^.Elem[3]:= TDo;
   TAS[VCiclo,TWhile]^.Elem[4]:= TllaveL;
   TAS[VCiclo,TWhile]^.Elem[5]:= VCuerpo;
   TAS[VCiclo,TWhile]^.Elem[6]:= TllaveR;
   TAS[VCiclo,TWhile]^.Cant:= 6;

   // Cond -> <EA1> "OPR" <EA1>

   //
   New(TAS[VCond,TconstReal]);
   TAS[VCond,TconstReal]^.Elem[1]:= VEA1;
   TAS[VCond,TconstReal]^.Elem[2]:= TOPR;
   TAS[VCond,TconstReal]^.Elem[3]:= VEA1;
   TAS[VCond,TconstReal]^.Cant:= 3;

   //
   New(TAS[VCond,Tid]);
   TAS[VCond,Tid]^.Elem[1]:= VEA1;
   TAS[VCond,Tid]^.Elem[2]:= TOPR;
   TAS[VCond,Tid]^.Elem[3]:= VEA1;
   TAS[VCond,Tid]^.Cant:= 3;

   //
   New(TAS[VCond,TParentesisL]);
   TAS[VCond,TParentesisL]^.Elem[1]:= VEA1;
   TAS[VCond,TParentesisL]^.Elem[2]:= TOPR;
   TAS[VCond,TParentesisL]^.Elem[3]:= VEA1;
   TAS[VCond,TParentesisL]^.Cant:= 3;

   //
   New(TAS[VCond,TfTam]);
   TAS[VCond,TfTam]^.Elem[1]:= VEA1;
   TAS[VCond,TfTam]^.Elem[2]:= TOPR;
   TAS[VCond,TfTam]^.Elem[3]:= VEA1;
   TAS[VCond,TfTam]^.Cant:= 3;

   //
   New(TAS[VCond,TMenos]);
   TAS[VCond,TMenos]^.Elem[1]:= VEA1;
   TAS[VCond,TMenos]^.Elem[2]:= TOPR;
   TAS[VCond,TMenos]^.Elem[3]:= VEA1;
   TAS[VCond,TMenos]^.Cant:= 3;  0

   // FTAM -> "fTam" "(" "id" "," "constReal" ")"
   New(TAS[VFTAM,TFTAM]);
   TAS[VFTAM,TFTAM]^.Elem[1]:= TfTam;
   TAS[VFTAM,TFTAM]^.Elem[2]:= TParentesisL;
   TAS[VFTAM,TFTAM]^.Elem[3]:= Tid;
   TAS[VFTAM,TFTAM]^.Elem[4]:= TComa;
   TAS[VFTAM,TFTAM]^.Elem[5]:= TconstReal;
   TAS[VFTAM,TFTAM]^.Elem[6]:= TParentesisR;
   TAS[VFTAM,TFTAM]^.Cant:= 6;

  End;

Procedure CrearTAS(Var TAS: TTAS);
 Begin
  InicializarTAS(TAS);
  CargarTAS(TAS);
 End;

Procedure TestingAnalizadorSintactico(Var FFuente:t_arch);
Const
 RutaArbol= 'C:\Users\Nicol\OneDrive\Escritorio\Proyecto Final SSL\sintaxis_proyecto_final\Arbol.txt';
Var
 Arbol:TApuntNodo;
 Error:Boolean;
Begin
 AnalizadorPredictivo(FFuente, Arbol,Error);
  If Error = False then   { not(FALSE) =TRUE --> es cierto q no hubo error }
   Begin
    GuardarArbol(RutaArbol,Arbol);
    WriteLn('El lenguaje fue reconocido con exito');
   End;
  Readkey;
End;

Procedure ApilarSimbolos(Var Celda:Tproduccion; Var Padre:TApuntNodo; Var Pila: TPila);//LA PILA ES DE E/S YA QUE SE MODIFICARA AL APILARLE ELEMENTOS
 Var
 I:0..Max;                                                              //LOS CUALES SON LOS SIMBOLOS DE LA PRODUCCION An,...,A1
 ElementoPila: TElemPila;
 Begin
  For I:= Celda.Cant Downto 1 do  ///va desde la cantidad de elementos q tiene la celda hasta 1
   Begin
    ElementoPila.Simbolo := Celda.Elem[I];       //elem: es parte del registro de la TAS
    ElementoPila.NodoArbol := Padre^.Hijos.Elem[I];  // Hijos.elem: es parte del registro de un arbol
    Apilar(Pila,ElementoPila);
   End;
 End;

Procedure AnalizadorPredictivo(Var Fuente:t_arch; Var Raiz:TApuntNodo; Var Error:Boolean);
 Var
  Estado:(Exito,ErrorSintactico,EnProceso);
  TAS:TTAS;
  Pila:TPila;
  ElementoPila:TElemPila;
  //Fuente:t_arch;
  Control:Longint;
  Lexema:String;
  Complex:GramaticalSymbol;
  I:0..Max;
  Hijo:TApuntNodo;       //hijos q voy agregar al arbol
  Aux:GramaticalSymbol;
  TS:TablaSimbolos;  //tabla de simbolos
 Begin
  abrir_arch(Fuente);     //realizo asignacion del archivo fuente y lo abro
  CargarTS(TS);          ///cargo palabras reservadas de la tabla de simbolos  //////////////////////////
  CrearTAS(TAS);     //inicializa y carga tas
  CrearPila(Pila);
  ElementoPila.Simbolo:=pesos;  //Cuando voy apilar el simbolo pesos el nodo del arbol debe apuntar a nil
  ElementoPila.NodoArbol:= Nil;
  Apilar(Pila,ElementoPila);
  CrearNodo(Vprograma,Raiz); //Creo nodo raiz= Vprograma
  ElementoPila.Simbolo:=Vprograma;   //Cuando voy apilar el simbolo Vprograma el nodo del arbol debe apuntar a la raiz
  ElementoPila.NodoArbol:=Raiz;
  Apilar(Pila,ElementoPila);
  Control:=0;
  Estado:=EnProceso;
  ObtenerSiguienteCompLex(Fuente,Control,Complex,Lexema,TS);
   While Estado=EnProceso do    // while estado <> exito or estado <> errorsintactico do
    Begin
     Desapilar(Pila,ElementoPila);      //Desapilar X
      If ElementoPila.Simbolo In [Tprogram..TfTam] Then   //Si X es terminal
       Begin
        If  ElementoPila.Simbolo=Complex then        //Si X=a
         Begin
          ElementoPila.NodoArbol^.Lexema:=Lexema;///<---------salta error          //cuando encontramos el terminal del tope de la pila es igual al term de enetrada aqui controlamos q el terminal se haya derivado bien
          ObtenerSiguienteCompLex(Fuente,Control,Complex,Lexema,TS);                //y tenemos el lexema correspondiente a ese terminal y ese lexema lo cargamos como nodo del arbol
         end
        Else                           //Sino, Error
         Begin
          Estado:=ErrorSintactico;
          WriteLn('Error Sintactico: se esperaba ', Complex, ' y se encontro ', ElementoPila.Simbolo );
          WriteLn(Control);
         End
       end
        Else
         If ElementoPila.Simbolo In [Vprograma..VFTAM] then      //Si X es Variable
          Begin
           If TAS[ElementoPila.Simbolo,Complex] = Nil then   //si la tas apunta a una celda vacia
            Begin
             Estado:=ErrorSintactico;
             WriteLn('Error Sintactico: desde la variable ', ElementoPila.Simbolo, ' no se puede llegar a ', CompLex);
             WriteLn(Control);
            End
             Else
              Begin                     //realizo derivacion a esa variable para hallar el complex(terminal)
               For I:=1 To TAS[ElementoPila.Simbolo,Complex]^.Cant do //el ciclo esta dado x la cantidad de elementos q tiene esa produccion
                Begin
                 Aux:=TAS[ElementoPila.Simbolo,Complex]^.Elem[I]; //guardo el elemento q esta en determinada pos de la produccion en aux
                 CrearNodo(Aux,Hijo);        //añado el elemento anterior en un nodo y lo agrego al arbol como hijo
                 AgregarHijo(ElementoPila.NodoArbol,Hijo);      //los nodos se van agregando desde A1,A2...An
                End;
                                         //Apilo los simbolos alreves desde An..,A2,A1  con un downto
                ApilarSimbolos(TAS[ElementoPila.Simbolo,Complex]^ , ElementoPila.NodoArbol , Pila);//le paso como parametro el puntero nodo arbol para saber
              End;       //de esta forma se pasa como parametro una produccion ya q la TAS       //en que puntero esta cada uno de los elementos de la pila
          End                //esta implementada sobre memoria dinamica
       Else
        //Si X=a=$, Éxito
        If (Complex = pesos ) and ( ElementoPila.Simbolo = pesos ) then //si el terminal de la cadena de entrada es igual a pesos
         Begin                                                           //y el ultimo elemento de la pila desapilado es igual a pesos
          Estado:=Exito;                                                 //entonces se reconocio la cadena
          writeln('El lenguaje ha sido reconocido');
        End;
    End;

 //writeln(estado);
 //readkey;
  Close(Fuente);

  If Estado = Exito then   //verificar si hubo error para posteriormente guardar el arbol de derivacion o no
   Begin
    Error:=False;
   End
    Else
     Error:=True;
    End;


procedure MOSTRAR_TAS(var TAS: TTAS);  //procedure para ver TAS como testeo para ver la matriz de la TAS aunque no logre arreglarlo
VAR i,j:GramaticalSymbol;
 k:integer;
begin
 CrearTAS(TAS);
 for i:= VPrograma to VFTAM do
   begin
    for j:= TProgram to pesos do
       begin
        if  NOT (TAS[i,j]=NIL) THEN
          BEGIN
            if TAS[i,j]^.cant=0 then
              begin
               writeln('TAS[',i,',',j,'] := Epsilon');
              end
              else
              begin
               write('TAS[',i,',',j,'] := ');
               for k:=1 to TAS[i,j]^.cant do
               begin
               write(TAS[i,j]^.elem[k],'  ' );
               end;
                writeln();
              end;
        //  readkey;
         end;
        END;

   end;
end;



End.

