-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ORGANODESICIONBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `ORGANODESICIONBAJ`;DELIMITER $$

CREATE PROCEDURE `ORGANODESICIONBAJ`(
	Par_OrganoID 		int(11),
	Par_Descripcion  	varchar(100),

	Par_Salida          char(1),
    inout Par_NumErr   int,
    inout Par_ErrMen   varchar(400),

	Par_EmpresaID         int(11) ,
    Aud_Usuario         int(11) ,
    Aud_FechaActual     datetime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal      int(11) ,
    Aud_NumTransaccion  bigint(20)

	)
TerminaStore:BEGIN


DECLARE varControl      char(15);


DECLARE Entero_Cero		int;
DECLARE Cadena_Vacia    	char(1);
DECLARE SalidaSI			char(1);
Declare SalidaNO			char(1);


set Entero_Cero 		 := 0;
Set Cadena_Vacia    	 := '';
set SalidaSI             := 'S';
Set SalidaNO             := 'N';
set varControl			  :='organoID' ;


Set Aud_FechaActual := CURRENT_TIMESTAMP();

ManejoErrores: BEGIN
			DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					set Par_NumErr = 999;
					set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
								 "estamos trabajando para resolverla. Disculpe las molestias que ",
								 "esto le ocasiona. Ref: SP-INTEGRAGRUPOSBAJ");
				END;


if(not exists(select OrganoID
                    from ORGANODESICION
                    where OrganoID = Par_OrganoID)) then
	set Par_NumErr  := '001';
    set Par_ErrMen  := 'El Facultado de Decision no Existe';
    set varControl  := 'organoID' ;
    LEAVE ManejoErrores;

end if;


if(exists(select OrganoID
                    from ORGANOINTEGRA
                    where OrganoID = Par_OrganoID)) then
	set Par_NumErr  := '002';
    set Par_ErrMen  := concat("El Facultado '",Par_Descripcion,"' Contiene Integrantes Actualmente.");
    set varControl  := 'organoID' ;
    LEAVE ManejoErrores;

end if;

if(exists(select OrganoID
                    from ESQUEMAAUTFIRMA
                    where OrganoID = Par_OrganoID)) then
	set Par_NumErr  := '003';
    set Par_ErrMen  := concat("Existen Solicitudes de Credito autorizadas por ",Par_Descripcion);
    set varControl  := 'organoID' ;
    LEAVE ManejoErrores;

end if;


DELETE
	FROM ORGANODESICION
	WHERE Par_OrganoID=OrganoID ;

set Par_NumErr := 0;
set Par_ErrMen := concat("El Facultado: ", convert(Par_OrganoID, CHAR)," Eliminado Correctamente");

END ManejoErrores;

 if (Par_Salida = SalidaSI) then
    select  convert(Par_NumErr, char(3)) as NumErr,
            Par_ErrMen as ErrMen,
            varControl as control,
            Par_OrganoID as consecutivo;
end if;


END TerminaStore$$