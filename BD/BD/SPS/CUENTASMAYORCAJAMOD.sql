-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASMAYORCAJAMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASMAYORCAJAMOD`;
DELIMITER $$


CREATE PROCEDURE `CUENTASMAYORCAJAMOD`(
    Par_ConceptoCajaID          int(11),
    Par_Cuenta                  varchar(12),
    Par_Nomenclatura            varchar(30),
    Par_NomenclaturaCR          varchar(30),

    Par_Salida                  char(1),
    inout Par_NumErr            int,
    inout Par_ErrMen            varchar(400),

    Par_EmpresaID               int(11),
    Aud_Usuario                 int,
    Aud_FechaActual             DateTime,
    Aud_DireccionIP             varchar(15),
    Aud_ProgramaID              varchar(50),
    Aud_Sucursal                int,
    Aud_NumTransaccion          bigint
	)

TerminaStore: BEGIN

DECLARE Str_SI                  char(1);
DECLARE Cadena_Vacia            char(1);
DECLARE Entero_Cero             int;


DECLARE Var_Control             varchar(50);


Set Str_SI          := 'S';
Set Cadena_Vacia    := '';
Set Entero_Cero     := 0;


ManejoErrores:BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        set Par_NumErr = 999;
        set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
                                 "estamos trabajando para resolverla. Disculpe las molestias que ",
                                 "esto le ocasiona. Ref: SP-CUENTASMAYORCAJAMOD");
    END;

if (Par_Cuenta = Cadena_Vacia)then
set	Par_NumErr 	:= 1;
			set	Par_ErrMen	:= concat("La Cuenta esta Vacia");
			set Var_Control := 'tipoCuenta' ;
			LEAVE ManejoErrores;
		   end if;

if (Par_Nomenclatura = Cadena_Vacia)then
set	Par_NumErr 	:= 2;
			set	Par_ErrMen	:= concat("La Nomenclatura esta Vacia");
			set Var_Control := 'nomenclatura' ;
			LEAVE ManejoErrores;
		   end if;

if (Par_NomenclaturaCR = Cadena_Vacia)then
set	Par_NumErr 	:= 3;
			set	Par_ErrMen	:= concat("La Nomenclatura Costos esta Vacia");
			set Var_Control := 'nomenclaturaCR' ;
			LEAVE ManejoErrores;
		   end if;


Set Aud_FechaActual := CURRENT_TIMESTAMP();

    update CUENTASMAYORCAJA set
        ConceptoCajaID  = Par_ConceptoCajaID,
        Cuenta          = Par_Cuenta,
        Nomenclatura    = Par_Nomenclatura,
        NomenclaturaCR  = Par_NomenclaturaCR,

        EmpresaID       = Par_EmpresaID,
        Usuario         = Aud_Usuario,
        FechaActual     = Aud_FechaActual,
        DireccionIP     = Aud_DireccionIP,
        ProgramaID      = Aud_ProgramaID,
        Sucursal        = Aud_Sucursal,
        NumTransaccion  = Aud_NumTransaccion

	where ConceptoCajaID 	= Par_ConceptoCajaID;

 set	Par_NumErr 	:= 0;
 set	Par_ErrMen	:= concat("Información Modificada Correctamente");
    set Var_Control := 'nomenclaturaCR' ;
END ManejoErrores;
 if (Par_Salida = Str_SI) then
     select  convert(Par_NumErr, char(3)) as NumErr,
            Par_ErrMen as ErrMen,
            Var_Control as control,
            Entero_Cero as consecutivo;
end if;
END TerminaStore$$