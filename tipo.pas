Unit Tipo;

Interface

Uses
  Crt;
Type  // Simbolos gramaticales
  GramaticalSymbol=(VPrograma, VDec, VVariable, VMatrizReal, VCuerpo, VSeguido,VSent,
  VAsignacion, VOperacionAsig, VEA1, VEA2 ,VEA3 , VEA4, VE1, VE2 ,VE3 , VE4, VEM,VConstMatriz, VFilas, VFacFilas, VColumnas,VFacColumnas, VLectura, VEscritura, VListaElementos, VFacListElem, VElemento,
  VCondicional, VFacCondicional, VCiclo, VCond, VFTAM,

  TProgram, TllaveL, TllaveR, Tid, Tdospuntos, Tpuntocoma {;}, TReal, TcorcheteL{[},TconstReal, TNumeral, TcorcheteR{]},
  Tasignacion{=}, TasigMatriz{:==}, TComa, {TIgual,} TMas, TMenos, TMult{*}, TDiv{/}, TExp{^}, TParentesisL{(}, TParentesisR{)},
  TSumMat, TRestMat, TMultMat , TTr, TProdEscMat, TRead, TConstCad, TPrint, TIf, TThen, TElse, TWhile , TDo , TOPR, TfTam,pesos,lexicerror);

  TipoVariable=Vprograma..VFTAM;

  TipoTerminal=TProgram..lexicerror;

  Archtexto = File of Char;


  TelemTS = Record
  complex: GramaticalSymbol;  //Simbolos gramaticales
  Lexema: String;
            End;

 Puntero = ^nodo;

 Nodo = Record
      info: TelemTS;
      sig: puntero;
        End;

 TablaSimbolos = Record
     Act,Cab:puntero;
     Tam:integer;
                 End;
Implementation
end.


