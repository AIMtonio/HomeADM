-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOCIODEMOGRALBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOCIODEMOGRALBAJ`;DELIMITER $$

CREATE PROCEDURE `SOCIODEMOGRALBAJ`(
	Par_ProspectoID			int(11),
	Par_ClienteID			int(11),
	Par_TipoBaja          int(11),

	Par_Salida              char(1),
    inout Par_NumErr        int,
    inout Par_ErrMen        varchar(400),

    Aud_Empresa             int,
    Aud_Usuario             int,
    Aud_FechaActual         DateTime,
    Aud_DireccionIP         varchar(15),
    Aud_ProgramaID          varchar(50),
    Aud_Sucursal            int,
    Aud_NumTransaccion      bigint
	)
TerminaStore: BEGIN


DECLARE Var_DescriProd  char(150);
DECLARE Var_DescriPues  char(150);
DECLARE Var_ProspectoID int(11);
DECLARE Var_ClienteID	 int(11);


DECLARE Cadena_Vacia        char(1);
DECLARE Entero_Cero         int;
DECLARE SalidaNO            char(1);
DECLARE SalidaSI            char(1);
DECLARE Tipo_BajaCliPro     Int(11);



Set Cadena_Vacia            := '';
Set Entero_Cero             := 0;
Set SalidaNO                :='N';
Set SalidaSI                :='S';
Set Tipo_BajaCliPro         := 1;


Set Aud_FechaActual         := CURRENT_TIMESTAMP();


Set Par_NumErr              := 1;
set Par_ErrMen              := Cadena_Vacia;

if(ifnull(Par_ProspectoID, Entero_Cero)) = Entero_Cero then
	Set Par_ProspectoID := Entero_Cero;
end if;


if(ifnull(Par_ClienteID, Entero_Cero)) = Entero_Cero then
	Set Par_ClienteID := Entero_Cero;
end if;


if (Par_ProspectoID = Entero_Cero and Par_ClienteID = Entero_Cero) then
    Set Par_ErrMen  = 'Debe seleccionar un Cliente o Prospecto.';
    if(Par_Salida = SalidaSI) then
			select '001' as NumErr,
				Par_ErrMenas ErrMen,
				'clienteID' as control,
             Entero_Cero as consecutivo;
    end if;
    LEAVE TerminaStore;
end if;



if Par_TipoBaja = Tipo_BajaCliPro then
    if Par_ClienteID > Entero_Cero then
        Delete from SOCIODEMOGRAL where	ClienteID	= Par_ClienteID;
    else
        Delete from SOCIODEMOGRAL where 	ProspectoID = Par_ProspectoID;
    end if;

    Set Par_NumErr  := Entero_Cero;
    Set Par_ErrMen  := 'Datos Sociodemograficos Eliminados con Exito.';

    if(Par_Salida = SalidaSI) then
        select '000' as NumErr,
                Par_ErrMen as ErrMen,
                'clienteID' as control,
                Entero_Cero as consecutivo;
    end if;
    LEAVE TerminaStore;
end if;



END TerminaStore$$