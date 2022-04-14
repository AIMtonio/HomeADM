-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LIMEXCUENTASALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `LIMEXCUENTASALT`;DELIMITER $$

CREATE PROCEDURE `LIMEXCUENTASALT`(
    Par_CuentaAhoID			bigint(20),
	Par_ClienteID			int(11),
    Par_SucursalID	        int(11),
    Par_Fecha	            date,
	Par_Motivo             	int(2),
    Par_Descripcion        	varchar(300),
    Par_Canal	            char(1),

    Par_Salida    			char(1),
    inout Par_NumErr 		int,
	inout Par_ErrMen  	    varchar(350),

	Par_EmpresaID			int(11),
	Aud_Usuario				int(11),
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(50),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int(11),
	Aud_NumTransaccion		bigint(20)

	)
TerminaStore: BEGIN



DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia			date;
DECLARE	Entero_Cero			int;
DECLARE	Salida_SI 	   		char(1);
DECLARE	Salida_NO 	   		char(1);
DECLARE consecutivo			int;
DECLARE NumCuentaAhoID		char(11);


Set	Cadena_Vacia 			:= '';
Set	Fecha_Vacia				:= '1900-01-01';
Set	Entero_Cero				:=  0;
Set	Salida_SI 	   			:= 'S';
Set	Salida_NO 	   			:= 'N';
Set	consecutivo			    :=  0;
Set	NumCuentaAhoID		    :=  0;

Set Aud_FechaActual	:=	CURRENT_TIMESTAMP();

ManejoErrores:BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        set Par_NumErr = 999;
        set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
                                 "estamos trabajando para resolverla. Disculpe las molestias que ",
                                 "esto le ocasiona. Ref: SP-LIMEXCUENTASALT");
    END;


select ClienteID
       into Par_ClienteID
from CUENTASAHO
where CuentaAhoID=Par_CuentaAhoID;


if(ifnull(Par_CuentaAhoID,Entero_Cero)= Entero_Cero) then
				set Par_NumErr  := 001;
				set Par_ErrMen  := 'El numero de cuenta esta Vacio.';
				leave ManejoErrores;
			end if;

	if(ifnull(Par_ClienteID,Entero_Cero)= Entero_Cero) then
				set Par_NumErr  := 002;
				set Par_ErrMen  := 'El numero ID del cliente esta Vacio.';
				leave ManejoErrores;
			end if;

if(ifnull(Par_SucursalID,Entero_Cero)= Entero_Cero) then
				set Par_NumErr  := 003;
				set Par_ErrMen  := 'El numero de Sucursal esta Vacio.';
				leave ManejoErrores;
			end if;

 if(ifnull(Par_Fecha, Cadena_Vacia) = Cadena_Vacia) then
	            set Par_NumErr  := 004;
				set Par_ErrMen  := 'Se requiere la fecha.';
			leave Terminastore;
        end if;

 if(ifnull(Par_Motivo, Entero_Cero)= Entero_Cero) then
	            set Par_NumErr  := 005;
				set Par_ErrMen  := 'Se requiere el motivo.';
			leave Terminastore;
        end if;

 if(ifnull(Par_Descripcion, Cadena_Vacia) = Cadena_Vacia) then
	            set Par_NumErr  := 006;
				set Par_ErrMen  := 'Se requiere la Descripcion.';
			leave Terminastore;
        end if;

 if(ifnull(Par_Canal, Cadena_Vacia) = Cadena_Vacia) then
	            set Par_NumErr  := 007;
				set Par_ErrMen  := 'Se requiere el canal.';
			leave Terminastore;
        end if;


insert into LIMEXCUENTAS ( CuentaAhoID,  ClienteID,	    SucursalID,     Fecha,     Motivo,
                           Descripcion,  Canal,         EmpresaID,	    Usuario,   FechaActual,
                           DireccionIP,	 ProgramaID,	Sucursal,       NumTransaccion)

	values ( Par_CuentaAhoID,  Par_ClienteID,     Par_SucursalID,        Par_Fecha,   Par_Motivo,
			 Par_Descripcion,  Par_Canal,         Par_EmpresaID,         Aud_Usuario, Aud_FechaActual,
			 Aud_DireccionIP,  Aud_ProgramaID,	  Aud_Sucursal,	         Aud_NumTransaccion);


END ManejoErrores;

if(Par_Salida = Salida_SI)then
	select '000' as NumErr,
	  concat("Registro agregado: ", convert(NumCuentaAhoID, CHAR))  as ErrMen,
		 'cuentaAhoID' as control, NumCuentaAhoID as consecutivo;

end if;

END TerminaStore$$