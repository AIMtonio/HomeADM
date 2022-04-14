-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ORGANOAUTORIZAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ORGANOAUTORIZAALT`;DELIMITER $$

CREATE PROCEDURE `ORGANOAUTORIZAALT`(
    Par_Esquema         int(11),
    Par_NumFirma        int(11),
    Par_Organo          int(11),

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
TerminaStore:BEGIN


DECLARE varControl      char(15);


DECLARE Cadena_Vacia        char(1);
DECLARE Fecha_Vacia         datetime;
DECLARE Entero_Cero         int(11);
DECLARE Str_SI              char(1);
DECLARE Str_NO              char(1);



Set Cadena_Vacia        := '';
Set Fecha_Vacia         := '1900-01-01';
Set Entero_Cero         := 0;
Set Str_SI              := 'S';
Set Str_NO              := 'N';



Set Aud_FechaActual         := CURRENT_TIMESTAMP();


Set     Par_NumErr  := 1;
set     Par_ErrMen  := Cadena_Vacia;


ManejoErrores: BEGIN
			DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					set Par_NumErr = 999;
					set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
								 "estamos trabajando para resolverla. Disculpe las molestias que ",
								 "esto le ocasiona. Ref: SP-ORGANOAUTORIZAALT");
				END;
    if not exists(select EsquemaID
                        from ESQUEMAAUTORIZA
                        where EsquemaID = Par_Esquema) then
        set Par_NumErr  := 1;
        set Par_ErrMen  := 'El Esquema de Autorizacion no existe';
        set varControl  := 'esquemaID' ;
        LEAVE ManejoErrores;
    end if;

    if not exists(select OrganoID
                        from ORGANODESICION
                        where OrganoID = Par_Organo) then
        set Par_NumErr  := 2;
        set Par_ErrMen  := 'El Organo de Desicion no existe';
        set varControl  := 'organoID' ;
        LEAVE ManejoErrores;
    end if;

    if ifnull(Par_NumFirma, Entero_Cero) <= Entero_Cero then
        set Par_NumErr  := 3;
        set Par_ErrMen  := 'El Numero de Firma no es valido.';
        set varControl  := 'organoID' ;
        LEAVE ManejoErrores;
    end if;

    if exists(select EsquemaID
                        from ORGANOAUTORIZA
                        where   EsquemaID   = Par_Esquema
                          and   NumFirma    = Par_NumFirma
                          and   OrganoID    = Par_Organo) then
        set Par_NumErr  := 4;
        set Par_ErrMen  := 'Ya existe la combinacion de Esquema, Num. de Firma y Organo ';
        set varControl  := 'organoID' ;
        LEAVE ManejoErrores;
    end if;

    INSERT INTO ORGANOAUTORIZA(
        EsquemaID,          NumFirma,           OrganoID,           EmpresaID,          Usuario,
        FechaActual,        DireccionIP,        ProgramaID,         Sucursal,           NumTransaccion)

        VALUES(
        Par_Esquema,        Par_NumFirma,       Par_Organo,         Aud_Empresa,        Aud_Usuario,
        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_SucursalID,     Aud_NumTransaccion);


    set Par_NumErr := 0;
    set Par_ErrMen := "Firma de Autorizacion Agregada con Exito";

END ManejoErrores;

 if (Par_Salida = Str_SI) then
     select  convert(Par_NumErr, char(3)) as NumErr,
            Par_ErrMen as ErrMen,
            varControl as control,
            Entero_Cero as consecutivo;
end if;

END TerminaStore$$