unit Evaluador;

Const

    MaxVar =   200;

    MaxReal =   200;

    MaxArreglo =   100;



Type

    TTipo =   (Treal,TMatrizReal);



    TElemEstado =   Record

        lexemaId:   string;

        ValReal:   real;

        Tipo:   TTipo;

        ValArray:   array[1..MaxArreglo] Of real;

        CantArray:   byte;       //Dimensiones



    End;

    TEstado =   Record

        elementos:   array [1..maxVar] Of TElemEstado;

        cant:   word;

    End;



    // EVALUADORES

Procedure InicializarEst(Var Estado:TEstado);

Function ValorDe(Var E:TEstado; lexemaid:String; indice:byte):   real;

Procedure agregarVar(Var E:tEstado; Var lexemaId:String; Var tipo:TTipo);

Procedure AsignarReal (Var E:TEstado; Var LexemaId:String; Valor:Real);

Procedure AsignarMatriz (Var E:TEstado; Var LexemaId:String; Valor:TMatriz);

Procedure AsignarCeldaMat (Var E:TEstado; Var LexemaId:string; Fil:Integer ;Col:Integer; Valor:Real);

//<Variable>::= "real" | <MatrizReal>
//<MatrizReal>::= "[" "constReal" "#" "constReal"  "]"          Convertir constReal en Entero; el lexema estaria en string

//<Cuerpo>::= <Sent> <Seguido>
Procedure EvalCuerpo (Var Arbol:TApuntNodo; Var Estado:TEstado);
 Begin
  EvalSent(Arbol^.Hijo[1],Estado);
  EvalSeguido(Arbol^.Hijo[2],Estado);
 End;

//<Seguido>::= <Cuerpo> | eps
Procedure EvalSeguido (Var Arbol:TApuntNodo; Var Estado:TEstado);           //Poner EN interface todas los procedure
 Begin
  If Arbol.Cant <> 0 then
   Begin
    EvalCuerpo(Arbol;Estado);
   End;
 End;

  //Case de Hijo1 -> Sent
<Sent>::= <Asignacion> ";"| <Lectura> ";"| <Escritura> ";"| <Condicional> | <Ciclo>
<Asignacion>::= "id" <OperacionAsig>
Procedure EvalAsignacion (Var Arbol:TApuntNodo;Var Estado:TEstado);
 Begin
  EvalOperacionAsig(Arbol^.Hijo[2],Estado,Arbol^.Hijo[1]^.Lexema);
 End;


//<OperacionAsig>::= "=" <EA1> | ":==" <EM> |"["<EA1> "," <EA1> "]" "=" <EA1>
Procedure EvalOperacionAsig(Var Arbol:TApuntNodo;Var Estado:TEstado; NombreVar:String);
 Var
  Resultado,ResultadoFila,ResultadoCol:Real;
  Fil,Col:Integer;
  ValMatriz:TMatriz;
 Begin
  Case Arbol^.Hijo[1]^.GramaticalSymbol do
   TAsignacion:Begin
                EvalEA1(Arbol^.Hijo[2],Estado,Resultado);
                AsignarReal(Estado, NombreVar, Resultado);
               End;
   TAsignacionMatriz:Begin
                      EvalEM(Arbol^.Hijo[2],Estado, ValMatriz);
                      AsignarMatriz(Estado, NombreVar, ValMatriz);
                     End;
   TCorcheteL:Begin
               EvalEA1(Arbol^.Hijo[2],Estado,ResultadoFila);
               EvalEA1(Arbol^.Hijo[4],Estado,ResultadoCol);
               EvalEA1(Arbol^.Hijo[7],Estado,Resultado);        //Otras Posibilidades:
               RealToInt(ResultadoFila,Fil);    //Fil:= Round(ResultadoFila);   Fil:= Trunc(ResultadoFila);
               RealToInt(ResultadoCol,Col);     //Col:= Round(ResultadoCol);   Fil:= Trunc(ResultadoCol);
               AsignarCeldaMat(Estado, NombreVar, Fil, Col, Resultado);
              End;
  End;
 End;


// LAS RAÍCES SE RESUELVEN EN FORMA DE POTENCIA.
// HACER CONSTANTES REALES SÓLO POSITIVAS.

<EA1>::= <EA2> <E1>
<E1>::= "+" <EA2> <E1> | "-" <EA2> <E1> | eps
<EA2>::= <EA3> <E2>
<E2>::= "*" <EA3> | "/" <EA3> | eps
<EA3>::= <EA4> <E3>
<E3>::= "^" <EA4> | eps
<EA4>::= "constReal" | "id" <E4> | "(" <EA1> ")" | <FTAM> | "-" <EA4>
<E4>::= eps | "[" <EA1> "," <EA1> "]"

// PUEDE CONVENIR DIFERENCIAR LOS OPERADORES ARITMETICOS DE LOS MATRICIALES.

<EM>::= <EM1> <M1>
<M1>::= "SumMat" "(" <EM> "," <EM> )" | "RestMat" "(" <EM> "," <EM> )"  | eps
<EM1>::= <EM2> <M2>
<M2>::= "MultMat" "(" <EM> "," <EM> )"  | eps
<EM2>::= "Tr" "(" <EM> ")" | <EM3>
<EM3>::= "ProdEscMat" ( <EA1> "," <EM> )  | <EMM>
<EMM>::= "id" | <constMatriz>

//A :== [[1,2,3],[4,5,6]]

<constMatriz> ::= "["<Filas>"]"
<Filas> ::= "[" <Columnas> "]" <FacFilas>
<FacFilas>::= eps | "," <Filas>

<Columnas> ::= <EA1> <FacColumnas>
<FacColumnas>::= eps | "," <Columnas>

<Lectura>::= "read" "(" "constCad" "," "id" ")"

<Escritura>::= "print" "(" <listaElementos> ")"
<listaElementos>::= <Elemento> <FacListElem>
<FacListElem>::= "," <listaElementos> | eps
<Elemento> ::= "constCad" | <EA1> | <constMatriz>

<Condicional>::= "If" <Cond> "then" "{" <Cuerpo> "}" <FacCondicional>
<FacCondicional>::= eps | "else" "{" <Cuerpo> "}"

<Ciclo>::= "While" <Cond> "do" "{" <Cuerpo> "}"

<Cond>::= <EA1> "OPR" <EA1>

<FTAM>::= "fTam" "(" "id" "," "constReal" ")"
















