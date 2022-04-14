-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ORGANOAUTORIZABAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `ORGANOAUTORIZABAJ`;DELIMITER $$

CREATE PROCEDURE `ORGANOAUTORIZABAJ`(
    Par_Esquema         int(11),
    Par_NumFirma        int(11),
    Par_Organo          int(11),
    Par_Producto        INT(11),
    Par_TipoBaja        INT(11),

    Par_Salida          char(1),
    inout Par_NumErr    int,
    inout Par_ErrMen    varchar(400),

    Aud_Empresa         int(11) ,
    Aud_Usuario         int(11) ,
    Aud_FechaActual     datetime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_SucursalID      int(11) ,
    Aud_NumTransaccion  bigint(20)
	)
TerminaStore: BEGIN



DECLARE Var_Control          char(15);


DECLARE Cadena_Vacia        char(1);
DECLARE Fecha_Vacia         datetime;
DECLARE Entero_Cero         int(11);
DECLARE Str_SI              char(1);
DECLARE Str_NO              char(1);
DECLARE Baja_Principal      INT(11);




Set Cadena_Vacia        := '';
Set Fecha_Vacia         := '1900-01-01';
Set Entero_Cero         := 0;
Set Str_SI              := 'S';
Set Str_NO              := 'N';
Set Baja_Principal      := 1;




Set Aud_FechaActual         := CURRENT_TIMESTAMP();


Set     Par_NumErr  := 1;
set     Par_ErrMen  := Cadena_Vacia;


ManejoErrores: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            set Par_NumErr = 999;
            set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
                         "estamos trabajando para resolverla. Disculpe las molestias que ",
                         "esto le ocasiona. Ref: SP-ORGANOAUTORIZABAJ");
        END;


    if( Par_TipoBaja = Baja_Principal) then

        if not exists(select EsquemaID
                        from ORGANOAUTORIZA
                        where EsquemaID = Par_Esquema
                          and NumFirma  = Par_NumFirma
                          and OrganoID  = Par_Organo) then

            set Par_ErrMen  := 'La Firma y Organo que Intenta Eliminar no Existe.';
            if(Par_Salida = Str_SI) then
                select '001' as NumErr,
                        Par_ErrMen  as ErrMen,
                        'organoID' as control,
                        Par_Producto as consecutivo;
            end if;
            LEAVE ManejoErrores;
        end if;


        delete from ORGANOAUTORIZA
                where EsquemaID = Par_Esquema
                  and NumFirma  = Par_NumFirma
                  and OrganoID  = Par_Organo;


        set Par_NumErr := Entero_Cero;
        set Par_ErrMen := concat("Firma Eliminada con exito.");

        if(Par_Salida = Str_SI) then
            select '000' as NumErr,
                    Par_ErrMen  as ErrMen,
                    'producCreditoID' as control,
                    Par_Producto as consecutivo;
        end if;
    end if;


END ManejoErrores;



END TerminaStore$$