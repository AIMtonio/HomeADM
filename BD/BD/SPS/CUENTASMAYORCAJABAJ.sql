-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASMAYORCAJABAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASMAYORCAJABAJ`;DELIMITER $$

CREATE PROCEDURE `CUENTASMAYORCAJABAJ`(
    Par_ConceptoCajaID          int(11),

    Par_Salida                  char(1),
    inout Par_NumErr            int,
    inout Par_ErrMen            varchar(400),

    Par_EmpresaID               int,
    Aud_Usuario                 int,
    Aud_FechaActual             DateTime,
    Aud_DireccionIP             varchar(15),
    Aud_ProgramaID              varchar(50),
    Aud_Sucursal                int,
    Aud_NumTransaccion          bigint
		)
TerminaStore: BEGIN

DECLARE Str_SI                  char(1);
DECLARE Entero_Cero             int;


DECLARE Var_Control             varchar(50);


Set Str_SI          := 'S';
Set Entero_Cero     := 0;


ManejoErrores:BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        set Par_NumErr = 999;
        set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
                                 "estamos trabajando para resolverla. Disculpe las molestias que ",
                                 "esto le ocasiona. Ref: SP-CUENTASMAYORCAJABAJ");
    END;

	DELETE
	FROM 		CUENTASMAYORCAJA
	where  ConceptoCajaID 	= Par_ConceptoCajaID;

set	Par_NumErr 	:= 0;
set	Par_ErrMen	:= concat("Cuenta Eliminada Correctamente");

END ManejoErrores;
 if (Par_Salida = Str_SI) then
     select  convert(Par_NumErr, char(3)) as NumErr,
            Par_ErrMen as ErrMen,
            Var_Control as control,
            Entero_Cero as consecutivo;
end if;

END TerminaStore$$