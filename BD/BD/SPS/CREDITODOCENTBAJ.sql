-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITODOCENTBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITODOCENTBAJ`;DELIMITER $$

CREATE PROCEDURE `CREDITODOCENTBAJ`(
    Par_Credito         BIGINT(20),
    Par_Salida          char(1),

    inout Par_NumErr    int,
    inout Par_ErrMen    varchar(400),
    Par_EmpresaID       int(11),
    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint(20)
	)
TerminaStore: BEGIN


DECLARE Con_Cadena_Vacia        char(1);
DECLARE Con_Fecha_Vacia         datetime;
DECLARE Con_Entero_Cero         int(11);
DECLARE Con_Str_SI              char(1);
DECLARE Con_Str_NO              char(1);
DECLARE Con_CreStaInactivo      char(1);
DECLARE Con_TipoMesaControl     char(1);



Set     Con_Cadena_Vacia        := '';
Set     Con_Fecha_Vacia         := '1900-01-01';
Set     Con_Entero_Cero         := 0;
Set     Con_Str_SI              := 'S';
Set     Con_Str_NO              := 'N';
Set     Con_CreStaInactivo      := 'I';
Set     Con_TipoMesaControl     := 'M';




Set     Par_NumErr  := 1;
set     Par_ErrMen  := Con_Cadena_Vacia;

if(ifnull(Par_Credito, Con_Entero_Cero))= Con_Entero_Cero then
    select  '001' as NumErr,
            'El Numero de Credito no es valido.' as ErrMen,
				'CreditoID' as control,
				Con_Entero_Cero as consecutivo;
    LEAVE TerminaStore;
end if;


if not exists( select CreditoID
               from CREDITOS
               where CreditoID = Par_Credito
                 and Estatus = Con_CreStaInactivo) then
    select  '002' as NumErr,
            concat("El Credito no tiene estatus de Inactivo o no existe: ", convert(Par_Credito, char)) as ErrMen,
				'CreditoID' as control,
				Con_Entero_Cero as consecutivo;
    LEAVE TerminaStore;
end if;


delete from CREDITODOCENT where CreditoID = Par_Credito;

set 	Par_NumErr := 0;
set	Par_ErrMen := concat("El Credito: ", convert(Par_Credito, char)," fue eliminado del checklist de Mesa de Control");

if(Par_Salida = Con_Str_SI) then
    select  '000' as NumErr,
            Par_ErrMen  as ErrMen,
            'CreditoID' as control,
            Par_Credito as consecutivo;
end if;


END TerminaStore$$