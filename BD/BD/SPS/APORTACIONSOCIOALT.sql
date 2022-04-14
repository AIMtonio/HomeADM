-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTACIONSOCIOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTACIONSOCIOALT`;DELIMITER $$

CREATE PROCEDURE `APORTACIONSOCIOALT`(
    Par_ClienteID       int(11),
    Par_Saldo           decimal(14,2),
    Par_SucursalID      int(11),
    Par_FechaRegistro   date,
    Par_UsuarioID       int(11),

	 Par_Salida          char(1),
    inout Par_NumErr    int,
    inout Par_ErrMen    varchar(400),

    Par_EmpresaID       int(11),
    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint

	)
Terminastore: BEGIN


DECLARE Var_AporatcionID    int;
DECLARE Var_ClienteID    	int;
DECLARE Var_SucursalID      int;
DECLARE Var_Control			varchar(50);
DECLARE Var_Aporta          varchar(50);
DECLARE Var_EstatusCli		char(1);



DECLARE Cadena_Vacia        char(1);
DECLARE Fecha_Vacia         date;
DECLARE Entero_Cero         int;
DECLARE Salida_SI           char(1);
DECLARE Inactivo			char(1);
DECLARE ConsecAportaSocio  	int;

Set Cadena_Vacia            := '';
Set Fecha_Vacia             := '1900-01-01';
Set Entero_Cero             := 0;
Set Aud_FechaActual         := now();
Set Salida_SI               := 'S';
Set Inactivo				:='I';
Set ConsecAportaSocio       := 0;

ManejoErrores:BEGIN


DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        set Par_NumErr = 999;
        set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistemafgdfg, " ,
                                 "estamos trabajando para resolverla. Disculpe las molestias que ",
                                 "esto le ocasiona. Ref: SP-APORTACIONSOCIOALT");
    END;

if not exists(select ClienteID
				from CLIENTES
				where ClienteID=Par_ClienteID)then
		set	Par_NumErr 	:= 1;
		set	Par_ErrMen	:= concat("El cliente ",Par_ClienteID,  "no Existe");
        set Var_Control := 'tipoOperacion' ;
        LEAVE ManejoErrores;
end if;

if not exists(select SucursalID
				from SUCURSALES
				where SucursalID=Par_SucursalID)then
		set	Par_NumErr 	:= 2;
		set	Par_ErrMen	:= concat("La sucursal indicada no Existe");
        set Var_Control := 'tipoOperacion' ;
        LEAVE ManejoErrores;

end if;

	if(ifnull(Par_Saldo, Entero_Cero)) = Entero_Cero then
		set	Par_NumErr 	:= 3;
		set	Par_ErrMen	:= concat("El saldo  esta vacio");
        set Var_Control := 'tipoOperacion' ;
		LEAVE TerminaStore;
	end if;

select Estatus into Var_EstatusCli
	from CLIENTES
		where ClienteID=Par_ClienteID;
if (Var_EstatusCli = Inactivo)then
	set Par_NumErr := 1;
	set Par_ErrMen := 'El Cliente indicado se encuentra Inactivo';
	LEAVE ManejoErrores;
end if;

set ConsecAportaSocio:= (select ifnull(Max(AportaSocio),Entero_Cero) + 1
from APORTACIONSOCIO);


 insert into APORTACIONSOCIO(
        AportaSocio,		ClienteID,      	Saldo,          	SucursalID,			FechaRegistro,
		UsuarioID,          FechaCertificado,	EmpresaID,			Usuario,			FechaActual,
		DireccionIP,        ProgramaID,         Sucursal,       	NumTransaccion)
    values(
        ConsecAportaSocio,	Par_ClienteID,  	Par_Saldo,        	Par_SucursalID,		Par_FechaRegistro,
		Par_UsuarioID,	    Fecha_Vacia,		Par_EmpresaID,  	Aud_Usuario,     	Aud_FechaActual,
		Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,		Aud_NumTransaccion);

       set	Par_NumErr 	:= 0;
	    set	Par_ErrMen	:= concat("Operacion realizada correctamente");

END ManejoErrores;
if (Par_Salida = Salida_SI) then
	select  convert(Par_NumErr, char(10)) as NumErr,
			Par_ErrMen as ErrMen,
			'numero' as control,
			Entero_Cero as consecutivo;
end if;
END TerminaStore$$