unit Tipo;

interface

uses
  crt;
type  // Simbolos gramaticales
ComponentesLexicos=(VPrograma, VDec, VVariable, VMatrizReal, VTam, VCuerpo ,VSent,
VInstruccion, VAsignacion, VEA1, VEA2 ,VEA3 , VEA4, VEM , VEM1 ,VEM2 , VEM3, VEM4,
VEMM, VLectura, VEscritura, VListaCad, VCondicional, VCiclo, VCond, VOPR, VL, VT ,
VM , VFTAM,
TllaveL, TllaveR , Tprint , Toprel , TReal ,TEntera, Tid , Tcoma ,
Tdospuntos , TProgram , TWhile , Tdo , TIf , Tthen , Telse , Tread ,
TparentesisL{(} , TparentesisR{)} , TCad , Tvar , Tmas ,Tsqrt, Tmenos ,Tdiv{/}, Texp{^}
, Tmult{*} , TMTr , TcorcheteL{[} , TcorcheteR{]} , Tnumeral , Tpuntocoma {;} ,
Tor , Tand,Tasignacion, Tnot);

TipoVariable=Vprograma..VFTAM;

TipoTerminal=TllaveL..Tnot;

Archtexto = file of char;


TelemTS = record
  complex: ComponentesLexicos;  //Simbolos gramaticales
  Lexema: String;
  end;

 puntero = ^nodo;

 nodo = record
      info: TelemTS;
      sig: puntero;
      end;

 TablaSimbolos = record
     act,cab:puntero;
     tam:integer;
    end;
implementation
end.


