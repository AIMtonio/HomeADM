-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASMAYORCAJAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASMAYORCAJAALT`;
DELIMITER $$


CREATE PROCEDURE `CUENTASMAYORCAJAALT`(
    Par_ConceptoCajaID          int(11),
    Par_Cuenta                  varchar(12),
    Par_Nomenclatura            varchar(30),
    Par_NomenclaturaCR          varchar(30),

    Par_Salida                  char(1),
    inout Par_NumErr            int(11),
    inout Par_ErrMen            varchar(100),

    Par_EmpresaID               int(11),
    Aud_Usuario                 int,
    Aud_FechaActual             DateTime,
    Aud_DireccionIP             varchar(15),
    Aud_ProgramaID              varchar(50),
    Aud_Sucursal                int(11),
    Aud_NumTransaccion          bigint(20)
		)

TerminaStore: BEGIN


DECLARE Str_SI                  char(1);
DECLARE Cadena_Vacia            char(1);
DECLARE Entero_Cero             int;


DECLARE Var_Control             varchar(50);
DECLARE Var_ConceptoCajaID      varchar(50);


Set Str_SI          := 'S';
Set Cadena_Vacia    := '';
Set Entero_Cero     := 0;


Set Aud_FechaActual := CURRENT_TIMESTAMP();

ManejoErrores:BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        set Par_NumErr = 999;
        set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
                                 "estamos trabajando para resolverla. Disculpe las molestias que ",
                                 "esto le ocasiona. Ref: SP-CUENTASMAYORCAJAALT");
    END;

    if not exists(select ConceptoCajaID
				from CONCEPTOSCAJA
				where ConceptoCajaID = Par_ConceptoCajaID)then
		set	Par_NumErr 	:= 1;
		set	Par_ErrMen	:= concat("El Concepto Caja  ",Par_ConceptoCajaID, " no Existe");
        set Var_Control := 'tipoCaja' ;
        LEAVE ManejoErrores;
    end if;

    if exists(select ConceptoCajaID
				from CUENTASMAYORCAJA
				where ConceptoCajaID = Par_ConceptoCajaID)then
		set	Par_NumErr 	:= 2;
		set	Par_ErrMen	:= concat("El Concepto Caja  ",Par_ConceptoCajaID, " ya Existe");
        set Var_Control := 'tipoCaja' ;
        LEAVE ManejoErrores;
    end if;

if (Par_Cuenta = Cadena_Vacia)then
set	Par_NumErr 	:= 3;
			set	Par_ErrMen	:= concat("La Cuenta esta Vacia");
			set Var_Control := 'tipoCuenta' ;
			LEAVE ManejoErrores;
		   end if;

if (Par_Nomenclatura = Cadena_Vacia)then
set	Par_NumErr 	:= 4;
			set	Par_ErrMen	:= concat("La Nomenclatura esta Vacia");
			set Var_Control := 'nomenclatura' ;
			LEAVE ManejoErrores;
		   end if;

if (Par_NomenclaturaCR = Cadena_Vacia)then
set	Par_NumErr 	:= 5;
			set	Par_ErrMen	:= concat("La Nomenclatura Costos esta Vacia");
			set Var_Control := 'nomenclaturaCR' ;
			LEAVE ManejoErrores;
		   end if;

insert into CUENTASMAYORCAJA(
                ConceptoCajaID,         Cuenta,         Nomenclatura,           NomenclaturaCR,
                EmpresaID,              Usuario,        FechaActual,            DireccionIP,
                ProgramaID,             Sucursal,       NumTransaccion)

        VALUES (Par_ConceptoCajaID,     Par_Cuenta,     Par_Nomenclatura,       Par_NomenclaturaCR,
                Par_EmpresaID,          Aud_Usuario,    Aud_FechaActual,		  Aud_DireccionIP,
                Aud_ProgramaID,         Aud_Sucursal,   Aud_NumTransaccion);

       set	Par_NumErr 	:= 0;
	    set	Par_ErrMen	:= concat("Operacion realizada correctamente");

END ManejoErrores;
 if (Par_Salida = Str_SI) then
     select  convert(Par_NumErr, char(3)) as NumErr,
            Par_ErrMen as ErrMen,
            Var_Control as control,
            Entero_Cero as consecutivo;
end if;
END TerminaStore$$