Unit Evaluador;

Interface

Uses
 Sysutils,Math,AnalizadorSintectico,Arbol,Tipo,Archivo;

Const
 MaxVar = 200;
 MaxReal = 200;
 MaxMatriz = 300;

Type
 TTipo = (Treal,TMatrizReal);

 VARMatriz = Record
  MatrizReal:Array[1..MaxMatriz,1..MaxMatriz] Of Real;
  Fil:Integer;
  Col:Integer;
             End;


 TElemEstado = Record
  LexemaId:String;
  Tipo:TTipo;
  ValReal:Real;
  ValMatrizReal:VARMatriz;
               End;

 TEstado = Record
  Elementos: Array [1..MaxVar] Of TElemEstado;
  Cant: Word;
           End;


Procedure InicializadorEst(Var Estado:TEstado); //Pone en 0 la cantidad de elementos del TEstado
Function ValorDeTReal(Var E:TEstado; Lexemaid:String; Indice:byte): Real;   //Devuelve el valor real de una variable identificador)?
Procedure AgregarVar(Var E:TEstado; Var LexemaId:String; Var Tipo:TTipo; Var TamFil:Integer; Var TamCol:Integer);  //Inicializa con los valores en 0
Procedure AsignarReal (Var E:TEstado; Var LexemaId:String; Valor:Real);   //Asigna un ValReal
Procedure AsignarMatriz (Var E:TEstado; Var LexemaId:String; Valor:VARMatriz);    //A un id le asigna una matriz
Procedure AsignarCeldaMat (Var E:TEstado; Var LexemaId:String; Fil,Col:Integer; Valor:Real);   //Asigna un valor a una celda de la matriz


Procedure evaluador_semantico(Var FFuente:t_arch);

//Evaluadores:
Procedure EvalProgram (Var Arbol:TApuntNodo; Var Estado:TEstado);
Procedure EvalDec (Var Arbol:TApuntNodo; Var Estado:TEstado);
Procedure EvalVariable (Var Arbol:TApuntNodo; Var Estado:TEstado; Identif:String ; Var Tipo:TTipo ;Var TamFil,TamCol: Integer);
Procedure EvalMatrizReal(Var Arbol:TApuntNodo; Var Fil,Col: Integer );
Procedure EvalCuerpo (Var Arbol:TApuntNodo; Var Estado:TEstado);
Procedure EvalSeguido (Var Arbol:TApuntNodo; Var Estado:TEstado);
Procedure EvalSent (Var Arbol:TApuntNodo; Var Estado:TEstado);
Procedure EvalAsignacion (Var Arbol:TApuntNodo;Var Estado:TEstado);
Procedure EvalOperacionAsig(Var Arbol:TApuntNodo;Var Estado:TEstado; NombreVar:String);
Procedure EvalEA1 (Var Arbol:TApuntNodo; Var Estado:TEstado;Var Res:Real);
Procedure EvalE1 (Var Arbol:TApuntNodo; Var Estado:TEstado;Var Res:Real; Var Op1:Real);
Procedure EvalEA2(Var Arbol:TApuntNodo; Var Estado:TEstado;Var Res:Real);
Procedure EvalE2 (Var Arbol:TApuntNodo; Var Estado:TEstado;Var Res:Real; Var Op1:Real);
Procedure EvalEA3(Var Arbol:TApuntNodo; Var Estado:TEstado;Var Res:Real);
Procedure EvalE3 (Var Arbol:TApuntNodo; Var Estado:TEstado;Var Res:Real;Var Base:Real);
Procedure EvalEA4 (Var Arbol:TApuntNodo; Var Estado:TEstado; Var Res:Real);
Procedure EvalE4(Var Arbol:TApuntNodo; Var Estado:TEstado; Var Res:Real);
Procedure EvalConstMatriz (Var Arbol:TApuntNodo; Var Estado:TEstado;Var ResMat:VARMatriz);
Procedure EvalFilas(Var Arbol:TApuntNodo; Var Estado:TEstado;Var ResMat:VARMatriz );
Procedure EvalFacFilas(Var Arbol:TApuntNodo; Var Estado:TEstado;Var ResMat:VARMatriz );
Procedure EvalColumnas (Var Arbol:TApuntNodo; Var Estado:TEstado;Var ResMat:VARMatriz);
Procedure EvalFacColumnas (Var Arbol:TApuntNodo; Var Estado:TEstado;Var ResMat:VARMatriz);
Procedure EvalLectura (Var Arbol:TApuntNodo; Var Estado:TEstado);
Procedure EvalEscritura(Var Arbol:TApuntNodo; Var Estado:TEstado);
Procedure EvalListaElementos (Var Arbol:TApuntNodo; Var Estado:TEstado);
Procedure EvalFacListElem (Var Arbol:TApuntNodo; Var Estado:TEstado);
Procedure EvalElemento(Var Arbol:TApuntNodo; Var Estado:TEstado);
Procedure EvalCondicional (Var Arbol:TApuntNodo; Var Estado:TEstado);
Procedure EvalFacCondicional (Var Arbol:TApuntNodo; Var Estado:TEstado);
Procedure EvalCiclo (Var Arbol:TApuntNodo; Var Estado:TEstado);
Procedure EvalCond (Var Arbol:TApuntNodo; Var Estado:TEstado);

Procedure EvalFTAM (Var Arbol:TApuntNodo; Var Estado:TEstado; Var Res:Real);
Implementation

 Procedure InicializadorEst(Var Estado:TEstado);
  Begin
   Estado.Cant:=0;
  End;

Function ValorDeTReal (Var E:TEstado; Lexemaid:String; Indice: Byte): Real;      //Lo uso solo para TREAl
 Var
  I:1..MaxVar;
 Begin
  For I:=1 to E.cant do
    Begin
     If Upcase(E.elementos[I].LexemaId)= Upcase(LexemaId) then      //busco el lexema
      Begin
       If E.elementos[I].Tipo = TReal then  //si la variable es de tipo real
          ValorDe:=E.elementos[I].ValReal;
      End;
    End;
 End;

 Procedure AgregarVar(Var E:TEstado; Var LexemaId:String; Var Tipo:TTipo;Var TamFil:Integer;Var TamCol:Integer);
  Var
   I,J:1..MaxMatriz;
  Begin
   E.Cant:= E.Cant + 1 ;      //Sumo en el contador de TEstado, para saber donde moverme
   E.Elementos[E.Cant].LexemaId := lexemaId;
   E.Elementos[E.Cant].Tipo:= Tipo;
   E.Elementos[E.Cant].Valreal:= 0;

///
   E.Elementos[E.Cant].ValMatrizReal.CantFil:=0;
   E.Elementos[E.Cant].ValMatrizReal.CantCol:=0;
   For I:= 1 to TamFil do
    Begin
     For J:= 1 to TamCol do
      E.Elementos[E.Cant].ValMatrizReal.MatrizReal[I,J]:= 0;
    End;
  End;

 Procedure AsignarReal(Var E:TEstado; Var LexemaId:String; Valor:Real);
 Var
  I :1..MaxVar;
 Begin
  For I:=1 to E.cant do
   Begin
    If Upcase(E.Elementos[I].LexemaId) = Upcase(LexemaId) then      //busco el lexema
     Begin
      If E.Elementos[I].Tipo = TReal then  //si la variable es de tipo real
       E.Elementos[i].ValReal := Valor;
     End;
   End;
 End;

Procedure AsignarMatriz (Var E:TEstado; Var LexemaId:String; Valor:VARMatriz);
 Var
  I :1..MaxVar;
 Begin
  For I:=1 to E.cant do
   Begin
    If Upcase(E.Elementos[I].LexemaId) = Upcase(LexemaId) then //Busco el lexema (El id)
     Begin
      E.Elemento[I].ValMatrizReal:= Valor;
     End;
   End;
 End;

Procedure AsignarCeldaMat (Var E:TEstado; Var LexemaId:String; Fil,Col:Integer; Valor:Real);
 Var
  I :1..MaxVar;
 Begin
  For I:=1 to E.Eant do
   Begin
    If Upcase(E.Elementos[I].LexemaId) = Upcase(LexemaId) then      //busco el lexema
     Begin
      If E.Elementos[I].Tipo = TMatrizReal then  //si la variable es de tipo MatrizReal
       E.Elementos[I].ValMatrizReal[Fil,Col] := Valor;
     End;
   End;
 End;



Function ConvertirEnReal(Lexema:String):Real;
 Var
  Valor: Real;
  Error:Integer;
 Begin
  Valor:=0;
  Val(Lexema,Valor,Error);  //funcion val de pascal: un tipo string en el 1ero, un tipo real en el 2do y un tipo integer en el tercero, donde el 3ero devolvera 0 si la conversion se hizo correctamente
  ConvertirEnReal:= Valor;
end;


//<Programa>::= "Program" <Dec> "{" <Cuerpo> "}"
Procedure EvalProgram (Var Arbol:TApuntNodo; Var Estado:TEstado);
 Begin
  EvalDec(Arbol^.Hijos.Elem[2],Estado);
  EvalCuerpo(Arbol^.Hijos.Elem[4],Estado);
 End;

//<Dec>::= "id" ":" <Variable> ";" <Dec> | eps
Procedure EvalDec (Var Arbol:TApuntNodo; Var Estado:TEstado);
 Var
  Tipo:TTipo;
  TamFil,TamCol:Integer;
 Begin
  If Arbol^.Hijos.Cant <> 0 then
   Begin
    EvalVariable(Arbol^.Hijos.Elem[3],Estado,Arbol^.Lexema,Tipo,TamFil,TamCol);
    AgregarVar(Estado,Arbol^.Hijos.Elem[1]^.Lexema,Tipo,TamFil,TamCol);
   End;
 End;



//<Variable>::= "real" | <MatrizReal>
Procedure EvalVariable (Var Arbol:TApuntNodo; Var Estado:TEstado; Identif:String ; Var Tipo:TTipo ;Var TamFil,TamCol: Integer);
 Begin
  If Arbol^.Simbolo = TconstReal then
   Begin
    Tipo := TReal;
    TamFil:=0;
    TamCol:=0;
   End
    Else
     Begin
       Tipo := TMatrizReal;
       EvalMatrizReal(Arbol,TamFil,TamCol);
     End;
 End;

//<MatrizReal>::= "[" "constReal" "#" "constReal"  "]"          Convertir constReal en Entero; el lexema estaria en string
Procedure EvalMatrizReal(Var Arbol:TApuntNodo; Var Fil,Col: Integer );
 Begin
  Fil:=Round(ConvertirEnReal(Arbol^.Hijos.Elem[2]^.Lexema));
  Col:=Trunc(ConvertirEnReal(Arbol^.Hijos.Elem[4]^.Lexema));
 End;

//<Cuerpo>::= <Sent> <Seguido>
Procedure EvalCuerpo (Var Arbol:TApuntNodo; Var Estado:TEstado);
 Begin
  EvalSent(Arbol^.Hijos.Elem[1],Estado);
  EvalSeguido(Arbol^.Hijos.Elem[2],Estado);
 End;

//<Seguido>::= <Cuerpo> | eps
Procedure EvalSeguido (Var Arbol:TApuntNodo; Var Estado:TEstado);
 Begin
  If Arbol^.Hijos.Cant <> 0 then
   Begin
    EvalCuerpo(Arbol^.Hijos.Elem[1],Estado);
   End;
 End;


//<Sent>::= <Asignacion> ";"| <Lectura> ";"| <Escritura> ";"| <Condicional> | <Ciclo>
 Procedure EvalSent (Var Arbol:TApuntNodo; Var Estado:TEstado);
  Begin
   Case Arbol^.Hijos.Elem[1]^.Simbolo of
    VAsignacion: EvalAsignacion(Arbol^.Hijos.Elem[1],Estado);
    VLectura: EvalLectura(Arbol^.Hijos.Elem[1],Estado);
    VEscritura: EvalEscritura(Arbol^.Hijos.Elem[1],Estado);
    VCondicional: EvalCondicional(Arbol^.Hijos.Elem[1],Estado);
    VCiclo: EvalCiclo(Arbol^.Hijos.Elem[1],Estado);
   End;
  End;



//<Asignacion>::= "id" <OperacionAsig>

Procedure EvalAsignacion (Var Arbol:TApuntNodo;Var Estado:TEstado);
 Begin
  EvalOperacionAsig(Arbol^.Hijos.Elem[2],Estado,Arbol^.Hijos.Elem[1]^.Lexema);
 End;


//<OperacionAsig>::= "=" <EA1> | ":==" <EM> |"["<EA1> "," <EA1> "]" "=" <EA1>
Procedure EvalOperacionAsig(Var Arbol:TApuntNodo;Var Estado:TEstado; NombreVar:String);
 Var
  Resultado,ResultadoFila,ResultadoCol:Real;
  Fil,Col:Integer;
  ValMatriz:VARMatriz;
 Begin
  Case Arbol^.Hijos.Elem[1]^.Simbolo of
   TAsignacion:Begin
                EvalEA1(Arbol^.Hijos.Elem[2],Estado,Resultado);
                AsignarReal(Estado, NombreVar, Resultado);
               End;
   TAsigMatriz:Begin
                EvalEM(Arbol^.Hijos^.Elem[2],Estado, ValMatriz);  //No tengo claro como funcionaria
                AsignarMatriz(Estado, NombreVar, ValMatriz);
               End;
   TCorcheteL:Begin
               EvalEA1(Arbol^.Hijos.Elem[2],Estado,ResultadoFila);
               EvalEA1(Arbol^.Hijos.Elem[4],Estado,ResultadoCol);
               EvalEA1(Arbol^.Hijos.Elem[7],Estado,Resultado);        //Otras Posibilidades:
               Fil:=Round(ResultadoFila);    //Fil:= Round(ResultadoFila);   Fil:= Trunc(ResultadoFila);
               Col:=Round(ResultadoCol);     //Col:= Round(ResultadoCol);   Fil:= Trunc(ResultadoCol);
               AsignarCeldaMat(Estado, NombreVar, Fil, Col, Resultado);
              End;
  End;
 End;



//<EA1>::= <EA2> <E1>
Procedure EvalEA1 (Var Arbol:TApuntNodo; Var Estado:TEstado;Var Res:Real);
 Var
  Op1:Real
 Begin
  EvalEA2(Arbol^.Hijos.Elem[1],Estado,Op1);
  EvalE1(Arbol^.Hijos.Elem[1],Estado,Res,Op1);
 End;



//<E1>::= "+" <EA2> <E1> | "-" <EA2> <E1> | eps

Procedure EvalE1 (Var Arbol:TApuntNodo; Var Estado:TEstado;Var Res:Real; Var Op1:Real);
 Var
  Op2:Real;
 Begin
  If Arbol^.Hijos.Cant <> 0 then
   Begin
    Case Arbol^.Hijos.Elem[1]^.Simbolo of
    TMas:Begin
          EvalEA2(Arbol^.Hijos.Elem[2],Estado,Op2);
          Op1:=Op1+Op2;
          EvalE1(Arbol^.Hijos.Elem[2],Estado,Res,Op1);
         End;
     TMenos:Begin
          EvalEA2(Arbol^.Hijos.Elem[2],Estado,Op2);
          Op1:=Op1-Op2;
          EvalE1(Arbol^.Hijos.Elem[2],Estado,Res,Op1);
         End;
    End;
   End
    Else
     Res:=Op1;
 End;


//<EA2>::= <EA3> <E2>
Procedure EvalEA2(Var Arbol:TApuntNodo; Var Estado:TEstado;Var Res:Real);
 Begin
  EvalEA3(Arbol^.Hijos.Elem[1],Estado,Res);
  EvalE2(Arbol^.Hijos.Elem[2],Estado,Res);
 End;

//<E2>::= "*" <EA3> <E2> | "/" <EA3> <E2> | eps
Procedure EvalE2 (Var Arbol:TApuntNodo; Var Estado:TEstado;Var Res:Real; Var Op1:Real);
 Var
  Op2:Real;
 Begin
  If Arbol^.Hijos.Cant <> 0 then
   Begin
    Case Arbol^.Hijos.Elem[1]^.Simbolo of
     TMult:Begin
          EvalEA3(Arbol^.Hijos.Elem[2],Estado,Op2);
          Op1:=Op1*Op2;
          EvalE2(Arbol^.Hijos.Elem[2],Estado,Res,Op1);
         End;
     TDiv:Begin
          EvalEA2(Arbol^.Hijos.Elem[2],Estado,Op2);
          Op1:=Op1/Op2;
          EvalE2(Arbol^.Hijos.Elem[2],Estado,Res,Op1);
         End;
    End;
   End
    Else
     Res:=Op1;
 End;

//<EA3>::= <EA4> <E3>
Procedure EvalEA3(Var Arbol:TApuntNodo; Var Estado:TEstado;Var Res:Real);
 Var
  Op1:Real;
 Begin
  EvalEA4(Arbol^.Hijos.Elem[1],Estado,Op1);
  EvalE3(Arbol^.Hijos.Elem[2],Estado,Res,Op1);
 End;

//<E3>::= "^" <EA4> <E3> | eps
Procedure EvalE3 (Var Arbol:TApuntNodo; Var Estado:TEstado;Var Res:Real;Var Base:Real);
 Var
  Exp:Real;
 Begin
  If Arbol^.Hijos.Cant <> 0 then
   Begin
    EvalEA4(Arbol^.Hijos.Elem[2],Estado,Exp);
    Base:=Power(Base,Exp);
    EvalE3(Arbol^.Hijos.Elem[3],Estado,Res,Base);
   End
    Else
     Res:=Base;
 End;


//<EA4>::= "constReal" | "id" <E4> | "(" <EA1> ")" | <FTAM> | "-" <EA4>
 Procedure EvalEA4 (Var Arbol:TApuntNodo; Var Estado:TEstado; Var Res:Real);
  Begin
   Case Arbol^.Hijos.Elem[1]^.Simbolo of
    TConstReal:Begin
                Res:=Trunc(ConvertirEnReal(Arbol^.Hijos.Elem[1]^.Lexema));
               End;
    Tid:Begin
         EvalE4(Arbol^.Hijos.Elem[2],Estado,Res);
        End;
    TParentesisL:Begin
                  EvalEA1(Arbol^.Hijos.Elem[2],Estado,Res);
                 End;
    VFTAM:Begin
           EvalFTAM(Arbol^.Hijos^.Elem[1],Estado,Res);
          End;
    TMenos:Begin
            EvalEA4(Arbol^.Hijos.Elem[1],Estado,Res);
           End;
   End;
  End;


//<E4>::= eps | "[" <EA1> "," <EA1> "]"
 Procedure EvalE4(Var Arbol:TApuntNodo; Var Estado:TEstado; Var Res:Real);
  Begin
   If Arbol^.Hijos.Cant <> 0 then
    Begin
     EvalEA1(Arbol^.Hijos.Elem[2],Estado,Res);
     EvalEA1(Arbol^.Hijos.Elem[4],Estado,Res);
    End;
  End;


 //<EM>::= "SumMat" "(" <EM> "," <EM> )" | "RestMat" "(" <EM> "," <EM> )"  | "MultMat" "(" <EM> "," <EM> )" | "Tr" "(" <EM> ")" | "ProdEscMat" ( <EA1> "," <EM> ) | "id" | <constMatriz>

Procedure EvalEM (Var Arbol:TApuntNodo; Var Estado:TEstado; Var ResMat:VARMatriz);
 Var
  Op1,Op2:VARMatriz;
  F,C:1..MaxMatriz;
 Begin
  Case Arbol^.Hijos.Elem[1]^.Simbolo of
   TSumMat:Begin
            EvalEM(Arbol^.Hijos.Elem[3],Estado,Op1);
            EvalEM(Arbol^.Hijos.Elem[5],Estado,Op2);
             If (Op1.Fil = Op2.Fil) and (Op1.Col = Op2.Col) then
              Begin
               For F:= 1 to Op1.Fil do
                Begin
                 For C:= 1 to Op1.Col do
                  ResMat^.MatrizReal[F,C]:= Op1.MatrizReal[F,C] + Op2.MatrizReal[F,C];
                End;
              End;
           End;
   TRestMat:Begin
             EvalEM(Arbol^.Hijos.Elem[3],Estado,Op1);
             EvalEM(Arbol^.Hijos.Elem[5],Estado,Op2);
              If (Op1.Fil = Op2.Fil) and (Op1.Col = Op2.Col) then
               Begin
                For F:= 1 to Op1.Fil do
                 Begin
                  For C:= 1 to Op1.Col do
                   ResMat^.MatrizReal[F,C]:= Op1.MatrizReal[F,C] - Op2.MatrizReal[F,C];
                 End;
               End
              Else
               WriteLn('Tamaño de matrices incomaptibles');
            End;
   TMultMat:Begin
             EvalEM(Arbol^.Hijos.Elem[3],Estado,Op1);
             EvalEM(Arbol^.Hijos.Elem[5],Estado,Op2);
              If Op1.Col <> Op2.Fil then
               WriteLn('Col de Matriz 1 no coinciden con Fil Matriz 2 ')
              Else
               Begin
                For F:=1 to Op1.Fil do
                 Begin
                  For C:=1 to Op2.Col do
                   Begin
                    For K := 1 to Op1.Col do
                     ResMat.MatrizReal[F,C]:=Op1.MatrizReal[F,K]*Op2.MatrizReal[K,C];
                   End;
                 End;
               End;
            End;
   TTr:Begin
        EvalEM(Arbol^.Hijos.Elem[3],Estado,Op1);
         For F:= 1 to Op1.Fil do
          Begin
           For C:= 1 to Op1.Col do
                  ResMat^.MatrizReal[C,F]:= Op1.MatrizReal[F,C]
                End;
              End;
           End;
   TProdEscMat:
   Tid:
   VConstMatriz:EvalConstMatriz(Arbol^.Hijos.Elem[1],Estado,ResMat);

  End;
 End;
  //Case Hijo 1
  //Segun este EvalEM
  //Op1 y Op2
  //llamar proced que sume y reste.... probablemente con dimensiones


{//<EM>::= <EM1> <M1>
Procedure EvalEM (Var Arbol:TApuntNodo; Var Estado:TEstado; Var ResMat:VARMatriz);
 Var
  Op1:VARMatriz;
 Begin
  EvalEM1(Arbol^.Hijos.Elem[1],Estado,Op1);
  EvalM1(Arbol^.Hijos.Elem[1],Estado,ResMat,Op1);
 End;


//<M1>::= "SumMat" "(" <EM> "," <EM> )" | "RestMat" "(" <EM> "," <EM> )"  | eps
Procedure EvalM1 (Var Arbol:TApuntNodo; Var Estado:TEstado; Var ResMat,Op1:VARMatriz);
 Begin
  If Arbol^.Hijos.Cant <> 0 then
   Begin
    Case Arbol^.Hijos.Elem[1]^.Simbolo of
     TSumMat:Begin
              EvalEM(Arbol^.Hijos.Elem[3],Estado,ResMat);
              EvalEM(Arbol^.Hijos.Elem[5],Estado,ResMat);
             End;
     TRestMat:Begin
              EvalEM(Arbol^.Hijos.Elem[3],Estado,ResMat);
              EvalEM(Arbol^.Hijos.Elem[5],Estado,ResMat);
             End;
    End;
   End

 End;


//<EM1>::= <EM2> <M2>
Procedure EvalEM1 (Var Arbol:TApuntNodo; Var Estado:TEstado; Var ResMat:NOTENGOCLARO);
 Begin
  EvalEM2(Arbol^.Hijos.Elem[1],Estado,RestMat);
  EvalM(Arbol^.Hijos.Elem[2],Estado,RestMat);
 End;


//<M2>::= "MultMat" "(" <EM> "," <EM> )"  | eps
Procedure EvalM2(Var Arbol:TApuntNodo; Var Estado:TEstado; Var ResMat:NOTENGOCLARO);
 Begin
  If Arbol^.Hijos.Cant <> 0 then
   Begin
    EvalEM(Arbol^.Hijos.Elem[3],Estado,ResMat);
    EvalEM(Arbol^.Hijos.Elem[5],Estado,ResMat);
   End;
 End;


//<EM2>::= "Tr" "(" <EM> ")" | <EM3>
Procedure EvalEM2 (Var Arbol:TApuntNodo; Var Estado:TEstado; Var ResMat:NOTENGOCLARO);
 Begin
  If Arbol^.Hijos.Elem[1].Simbolo = VEM3 then
   Begin
    EvalEM3(Arbol^.Hijos.Elem[1],Estado,ResMat);
   End
    Else
     Begin
      EvalEM(Arbol^.Hijos.Elem[3],Estado,ResMat);
     End;
 End;


//<EM3>::= "ProdEscMat" ( <EA1> "," <EM> )  | <EMM>
Procedure EvalEM3 (Var Arbol:TApuntNodo; Var Estado:TEstado; Var ResMat:NOTENGOCLARO);
 Begin
  If Arbol^.Hijos.Elem[1].Simbolo = VEMM then
   Begin
    EvalEMM(Arbol^.Hijos.Elem[1],Estado,ResMat);
   End
    Else
     Begin
      EvalEA1(Arbol^.Hijos.Elem[3],Estado,ResMat);
      EvalEM(Arbol^.Hijos.Elem[5],Estado,ResMat);
     End;
 End;

//<EMM>::= "id" | <constMatriz>
Procedure EvalEMM(Var Arbol:TApuntNodo; Var Estado:TEstado; Var ResMat:NOTENGOCLARO);
 Begin
  If Arbol^.Hijos.Elem[1].Simbolo = Tid then
   Begin
    /////Tendria que sacar el valor de la matriz de la variable id asociada?
   End
    Else
     Begin
      EvalConstMatriz(Arbol^.Hijos.Elem[1],Estado,ResMat);
     End;
 End; }

//<constMatriz> ::= "[" <Filas> "]"
Procedure EvalConstMatriz (Var Arbol:TApuntNodo; Var Estado:TEstado;Var ResMat:VARMatriz);
 Begin
  ResMat.Fil:=0;
  EvalFilas(Arbol^.Hijos.Elem[2],Estado,ResMat);
 End;

//<Filas> ::= "[" <Columnas> "]" <FacFilas>
Procedure EvalFilas(Var Arbol:TApuntNodo; Var Estado:TEstado;Var ResMat:VARMatriz );
 Begin
  ResMat.Fil:= ResMat.Fil + 1;
  EvalColumnas(Arbol^.Hijos.Elem[2],Estado,ResMat);
  EvalFacFilas(Arbol^.Hijos.Elem[4],Estado,ResMat);
 End;

//<FacFilas>::= eps | "," <Filas>
Procedure EvalFacFilas(Var Arbol:TApuntNodo; Var Estado:TEstado;Var ResMat:VARMatriz );
 Begin
  If Arbol^.Hijos.Cant <> 0 then
   Begin
    ResMat.Col:=0;
    ResMat.Fil:= ResMat.Fil + 1;
    EvalFilas(Arbol^.Hijos.Elem[2],Estado,ResMat);
   End;
 End;

//<Columnas> ::= <EA1> <FacColumnas>
Procedure EvalColumnas (Var Arbol:TApuntNodo; Var Estado:TEstado;Var ResMat:VARMatriz);
 Var
  Resultado:Real;
 Begin
  ResMat.Col:= ResMat.Col + 1;
  EvalEA1(Arbol^.Hijos.Elem[1],Estado,Resultado);
  ResMat.MatrizReal[ResMat.Fil,ResMat.Col]:=Resultado;
  EvalFacColumnas(Arbol^.Hijos.Elem[2],Estado,ResMat);
 End;

//<FacColumnas>::= eps | "," <Columnas>
Procedure EvalFacColumnas (Var Arbol:TApuntNodo; Var Estado:TEstado;Var ResMat:VARMatriz);
 Begin
  If Arbol^.Hijos.Cant <> 0 then
   Begin
    ResMat.Col:= ResMat.Col + 1;
    EvalColumnas(Arbol^.Hijos.Elem[2],Estado,ResMat);
   End;
 End;

//<Lectura>::= "read" "(" "constCad" "," "id" ")"
Procedure EvalLectura (Var Arbol:TApuntNodo; Var Estado:TEstado);
 Var
  ValEscribir:Real;
 Begin
  Write(Arbol^.Hijos.Elem[3]^.Lexema);
  Readln(ValEscribir);
  AsignarReal(Estado,Arbol^.Hijos.Elem[5]^.Lexema,ValEscribir);
 End;

//<Escritura>::= "print" "(" <ListaElementos> ")"
Procedure EvalEscritura(Var Arbol:TApuntNodo; Var Estado:TEstado);
 Begin
  EvalListaElementos(Arbol^.Hijos.Elem[2],Estado);
 End;

//<listaElementos>::= <Elemento> <FacListElem>
Procedure EvalListaElementos (Var Arbol:TApuntNodo; Var Estado:TEstado);
 Begin
  EvalElemento(Arbol^.Hijos.Elem[1], Estado);
  EvalFacListElem(Arbol^.Hijos.Elem[1], Estado);
 End;

//<FacListElem>::= "," <listaElementos> | eps
Procedure EvalFacListElem (Var Arbol:TApuntNodo; Var Estado:TEstado);
 Begin
  If Arbol^.Hijos.Cant <> 0 then
   Begin
    EvalListaElementos(Arbol^.Hijos.Elem[2],Estado);
   End;
 End;

//<Elemento> ::= "constCad" | <EA1> | <constMatriz>
Procedure EvalElemento(Var Arbol:TApuntNodo; Var Estado:TEstado);
 Var
  Res:Real;
  Matriz:VARMatriz;
  F,C:1..MaxMatriz;
 Begin
  Case Arbol^.Hijos.Elem[1]^.Simbolo of
   TConstCad:Begin
              WriteLn(Arbol^.Hijos.Elem[1]^.Lexema);
             End;
   VEA1:Begin
         EvalEA1(Arbol^.Hijos.Elem[1],Estado,Res)
         WriteLn(Res:15:3);
        End;
   VConstMatriz:Begin
                 EvalConstMatriz(Arbol^.Hijos^.Elem[1],Estado,Matriz);
                 WriteLn('[');
                  For F := 1 to Fil do
                   Begin
                    WriteLn('[');
                    For C := 1 to Col do
                     Write(Matriz.MatrizReal[F,C]:10:3, '  ');
                     WriteLn(']');
                   End;
                    WriteLn(']');
                End;
  End;
 End;

//<Condicional>::= "If" <Cond> "then" "{" <Cuerpo> "}" <FacCondicional>
Procedure EvalCondicional (Var Arbol:TApuntNodo; Var Estado:TEstado);
 Begin
  EvalCond(Arbol^.Hijos.Elem[2],Estado);
  EvalCuerpo(Arbol^.Hijos.Elem[5],Estado);
  EvalFacCondicional(Arbol^.Hijos.Elem[7],Estado);
 End;

//<FacCondicional>::= eps | "else" "{" <Cuerpo> "}"
Procedure EvalFacCondicional (Var Arbol:TApuntNodo; Var Estado:TEstado);
 Begin
  If Arbol^.Hijos.Cant <> 0 then
   Begin
    EvalCuerpo(Arbol^.Hijos.Elem[3],Estado);
   End;
 End;


//<Ciclo>::= "While" <Cond> "do" "{" <Cuerpo> "}"
Procedure EvalCiclo (Var Arbol:TApuntNodo; Var Estado:TEstado);
 Begin
  EvalCond(Arbol^.Hijos.Elem[2],Estado);
  EvalCuerpo(Arbol^.Hijos.Elem[5],Estado);
 End;

//<Cond>::= <EA1> "OPR" <EA1>
Procedure EvalCond (Var Arbol:TApuntNodo; Var Estado:TEstado);
 Var
  Res1,Res2:Real;
 Begin
  EvalEA1(Arbol^.Hijos.Elem[1],Estado,Res1);
  EvalEA1(Arbol^.Hijos.Elem[3],Estado,Res2);
 End;
                                  // 1,2
//<FTAM>::= "fTam" "(" "id" "," "constReal" ")"
Procedure EvalFTAM (Var Arbol:TApuntNodo; Var Estado:TEstado; Var Res:Real);
 Var
  Matriz:VARMatriz;
  FoC:Real;
 Begin
  ValorDeMatriz(Arbol^.Hijos.Elem[3]^.Lexema,Estado,Matriz);
  FoC:=ConvertirEnReal(Arbol^.Hijos.Elem[5]^.Lexema,);
   IF FoC =1 then
    Res:=Matriz.Fil
   Else
    Res:=Matriz.Col;
 End;


 Procedure evaluador_semantico(Var FFuente:t_arch);
const rutaarbol= 'C:\Users\Nicol\OneDrive\Escritorio\Proyecto Final SSL\sintaxis_proyecto_final\Arbol.txt';
var
Arbol:TApuntNodo;
error:boolean;
estado:TEstado;
  begin
        AnalizadorPredictivo(FFuente, Arbol,Error);

        If not(error) = true then   //not(FALSE) =TRUE --> si es cierto q no hubo error llamare al arbol y luego al evaluador pasandole el arbol creado
         begin
         guardarArbol(rutaarbol,arbol);
          InicializadorEst(Estado);
         evalprogram(arbol,estado);
         end;


        readln;
  end;

End.
