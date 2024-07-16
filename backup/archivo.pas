unit Archivo;
interface
uses
crt,SysUtils;
const
 ruta= '';

 type
   t_arch=file of char; //archivo de texo

procedure Crear (VAR arch:t_arch);
procedure recupera_arch(var pos:integer;var caracter:char);
procedure abrir_Arch(var arch:t_arch);
procedure asigna_abre_arch2(var arch2:t_arch;ruta2:string);
implementation

PROCEDURE CREAR(VAR ARCH:t_arch);
BEGIN
Assign(arch,ruta);
Rewrite(ARCH);
END;

procedure recuperar_arch(var pos:integer;var caracter:char);
   var
     arch:t_arch;
   begin
     abrir_arch(arch);                //Abre el archivo, si no es el fin de archivo
     if pos < filesize(arch) then
       begin
         seek(arch,pos);
         read(arch,caracter);       //Lee el caracter y lo asigna en caracter de la posicion
       end
     else                            //Sino, asigna #0 que es $
      begin
        caracter:=#0 ;
        write(arch,caracter);
      end;
     close(arch);
   end;

procedure abrir_arch(var arch:t_arch);
     begin
      Assign(arch,ruta);            //Revisa si esta creado, si no lo esta entonces lo crea
     if IOresult<>0 then
      begin
         Rewrite(arch);
       end;
       reset(arch);    //Abre el archivo en la posicion del controlador
      end;

procedure asigna_abre_arch2(var arch2:t_arch;ruta2:string);
     begin
      Assign(arch2,ruta2);
     if IOresult<>0 then
      begin
         Rewrite(arch2);
       end;
       reset(arch2);
      end;
end.

