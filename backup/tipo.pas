unit Tipo;

interface

uses
  crt;

ComponentesLexicos=(VPrograma, VDec, VVariable, VMatrizReal, VTam, VCuerpo ,VSent,
VInstruccion, VAsignacion, VEA1, VEA2 ,VEA3 , VEA4, VEM , VEM1 ,VEM2 , VEM3, VEM4,
VEMM, VLectura, VEscritura, VListaCad, VCondicional, VCiclo, VCond, VOPR, VL, VT ,
VM , VFTAM,
TllaveL, TllaveR , Tprint , TmayorR{<}, TmayorL{>} , Tigual{==} ,
TmayorIgualL{>=} , TmayorIgualR{<=} , TConstReal ,TEntera, Tid , Tcoma ,
Tdospuntos , TProgram , TWhile , Tdo , TIf , Tthen , Telse , Tread ,
TparentesisL{(} , TparentesisR{)} , TCad , Tmas ,Tsqrt, Tmenos ,Tdiv{/}, Texp{^}
, Tmult{*} , TMTr , TcorcheteL{[} , TcorcheteR{]} , Tnumeral , Tpuntocoma {;} ,
Tor , Tand, Tnot);

TipoVariable=(Vprogram..VFTAM);

TipoTerminal=(TllaveL..Tnot);


TelemTS = record
  complex: ComponentesLexicos;
  Lexema: String;
  end;

 puntero = ^nodo;

 nodo = record
      info: TelemTS;
      sig: puntero;
      end;

 TablaSimbolos = record
     cab:puntero;
     tam:integer;
    end;
implementation
end.


