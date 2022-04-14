-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGUROCLIMOVALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGUROCLIMOVALT`;DELIMITER $$

CREATE PROCEDURE `SEGUROCLIMOVALT`(
	Par_SeguroClienteID		int(11),
	Par_ClienteID           int(11),
    Par_Monto               decimal(14,2),
    Par_Tipo                char(1),
    Par_SucursalID          int(11),
    Par_CajaID              int(11),
    Par_Fecha               date,
    Par_UsuarioID           int(11),
    Par_DescripcionMov      varchar(150),
    Par_NumMovimiento       bigint(20),
    Par_MonedaID            int(11),

    Par_Salida              char(1),
    inout Par_NumErr        int,
    inout Par_ErrMen        varchar(400),

    Par_EmpresaID           int(11),
    Aud_Usuario             int,
    Aud_FechaActual         DateTime,
    Aud_DireccionIP         varchar(15),
    Aud_ProgramaID          varchar(50),
    Aud_Sucursal            int,
    Aud_NumTransaccion      bigint

	)
TerminaStore:BEGIN

DECLARE Var_Control  		varchar(100);
DECLARE Var_SeguroCliMovID	int;

DECLARE Entero_Cero		int;
DECLARE SalidaSI		char(1);


Set Entero_Cero         := 0;
Set SalidaSI			:='S';
Set Aud_FechaActual		:=now();

 ManejoErrores: BEGIN
			DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					set Par_NumErr = 999;
					set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
								 "estamos trabajando para resolverla. Disculpe las molestias que ",
								 "esto le ocasiona. Ref: SP-APORTASOCIOMOVALT");
				END;

if not exists(select ClienteID
				from CLIENTES
				where ClienteID=Par_ClienteID)then
		set	Par_NumErr 	:= 1;
		set	Par_ErrMen	:= concat("El Cliente ",Par_ClienteID,  "no Existe");
        set Var_Control := 'tipoOperacion' ;
        LEAVE ManejoErrores;
    end if;

   if not exists(select SucursalID
				from SUCURSALES
				where SucursalID=Par_SucursalID)then
		set	Par_NumErr 	:= 2;
		set	Par_ErrMen	:= concat("La Sucursal",Par_SucursalID,"Indicada no Existe");
        set Var_Control := 'tipoOperacion' ;
        LEAVE ManejoErrores;
    end if;


 call FOLIOSAPLICAACT('SEGUROCLIMOV', Var_SeguroCliMovID);
    INSERT INTO SEGUROCLIMOV (
                   SeguroCliMovID,	SeguroClienteID,	ClienteID,          Monto,              Tipo,
					SucursalID,		CajaID,				Fecha,              UsuarioID,          DescripcionMov,
					NumMovimiento,	MonedaID,			EmpresaID,          Usuario,            FechaActual,
					DireccionIP,    ProgramaID,         Sucursal,           NumTransaccion)
            VALUES  (
                    Var_SeguroCliMovID,	Par_SeguroClienteID,	Par_ClienteID,		Par_Monto,          Par_Tipo,
					Par_SucursalID,     Par_CajaID, 			Par_Fecha,          Par_UsuarioID,  	Par_DescripcionMov,
					Par_NumMovimiento,  Par_MonedaID,			Par_EmpresaID,      Aud_Usuario,		Aud_FechaActual,
					Aud_DireccionIP,    Aud_ProgramaID,			Aud_Sucursal,       Aud_NumTransaccion);
		set Par_NumErr  := 0;
        set Par_ErrMen  := 'Operacion realizada correctamente';
        set Var_Control  := 'cajaID' ;
END ManejoErrores;
if (Par_Salida = SalidaSI) then
     select  Par_NumErr as NumErr,
            Par_ErrMen as ErrMen,
            Var_Control as control,
            Entero_Cero as consecutivo;
end if;

END TerminaStore$$