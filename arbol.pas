unit Arbol;

Interface

Uses
  Crt,Lista,Tipo;

Const
 Max = 10;
Type
  TApuntNodo = ^TNodoArbol;

  TipoHijos = Record
    Elem: Array[1..Max] of TApuntNodo;
    Cant:0..Max;        //cantidad de hijos.
              End;

  TNodoArbol = Record
    Simbolo:GramaticalSymbol;
    Lexema:String;
    Hijos:TipoHIjos;
               End;


Procedure CrearArbol(Var Arbol:TApuntNodo );
Procedure CrearNodo(Complex:GramaticalSymbol; Var Arbol: TApuntNodo );
Procedure AgregarHijo(Var Raiz:TApuntNodo ; Var Hijo:TApuntNodo );
Procedure GuardarArbol(RutaArbol: String; Var Arbol:TApuntNodo);
Procedure GuardarNodo(Var Archar:Text; Var Arbol: TApuntNodo ; Desplaz: String);

Implementation

Procedure CrearArbol(Var Arbol:TApuntNodo );    {crea raiz del arbol}
  Begin
   Arbol:=Nil;
  End;

Procedure CrearNodo(Complex:GramaticalSymbol; Var Arbol : TApuntNodo);{crea un nodo e inicializa todas las celdas del vector hijo mediante nil}
 Var
  I: Integer;
 Begin
  New(Arbol);
  Arbol^.Simbolo:=Complex;
  Arbol^.Lexema:= '' ;     //Epsilon
  Arbol^.Hijos.Cant:= 0;         //0 cantidad de prod
   For I:= 1 to Max do
    Begin
     Arbol^.Hijos.Elem[I]:=Nil;
    End;
 End;

Procedure AgregarHijo(Var Raiz:TApuntNodo ; Var Hijo:TApuntNodo );
 Begin
  If Raiz^.Hijos.Cant< Max then
   Begin
    Inc(Raiz^.Hijos.Cant);
    Raiz^.Hijos.Elem[Raiz^.Hijos.Cant]:= Hijo;
   End;
 End;
                                                              {sin var para pasarle siempre la cadena vacia}
Procedure GuardarNodo(Var Archar:Text; Var Arbol: TApuntNodo ; Desplaz:String);  {el desplazamiento permite q los hijos se impriman mas a la derecha q el nodo padre, para q se aprecie la estructura del arbol}
{GUARDA ARBOL EN UN ARCHIVO DE TEXTO}     //hace un recorrido del arbol y guarda en el archivo
Var
 I : Byte;                         //la construccion del arbol
Begin
 Writeln(Archar,Desplaz,Arbol^.Simbolo,'(',Arbol^.Lexema,')'); //imprimiremos la informacion q tiene ese nodo del arbol y despues
  For I:=1 to Arbol^.Hijos.Cant do
   Begin                              //recorrer la informacion que tiene cada uno de los hijos
    GuardarNodo(Archar, Arbol^.Hijos.Elem[I] ,Desplaz + '  ');            //y llamar nuevamente a guardar nodo para q se vayan imprimiendo tambien
   End;                       {le concatenos dos epacios en blanco}   // esos hijos
End;

Procedure GuardarArbol(RutaArbol:String; Var Arbol:TApuntNodo);
 Var
  Archar:Text;   //en este archivo de texto se guardara el arbol de derivacion correspondiente al programa fuente
 Begin
  Assign(Archar,RutaArbol);
  ReWrite(Archar);
  GuardarNodo(Archar,Arbol,'');//recorre el arbol y lo guarda(basicamente lo llena con sus respectivos nodos)
  Close(Archar);       //pongo un parametro de desplazamiento el cual sera igual a la cadena vacia '' (tambien podria ser un 0)
 End;


end.
