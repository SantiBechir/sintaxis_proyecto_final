Unit Pila;

Interface

Uses
  Crt,Tipo,Arbol;

Type
{Definicion de la Pila}
 TElemPila = Record
   Simbolo:GramaticalSymbol;
   NodoArbol:TApuntNodo; //arbol de derivacion
             End;

 TPila = Record
   Elem: Array[1..200]of TElemPila;
   Tope:0..200;
         End;


  Procedure CrearPila (Var P:TPila);
  Procedure Apilar (Var P:TPila; X:TElemPila);
  Procedure Desapilar (Var P:TPila; Var X:TElemPila);

implementation
 Procedure CrearPila(Var P:TPila);
  Begin
   P.Tope:=0;
  End;

 Procedure Apilar (Var P:TPila; X:TElemPila);
  Begin
   P.Tope:=P.Tope+1;
   P.Elem[P.Tope]:=X;
  End;

 Procedure Desapilar (Var P:TPila;Var X:TElemPila);
  Begin
   X:= P.Elem[P.Tope];
   P.Tope:=P.Tope-1;
  End;
End.

