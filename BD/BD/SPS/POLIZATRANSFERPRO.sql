-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- POLIZATRANSFERPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `POLIZATRANSFERPRO`;
DELIMITER $$

CREATE PROCEDURE `POLIZATRANSFERPRO`(
    Par_Poliza          bigint,
    Par_Empresa         int,
    Par_Fecha           date,
    Par_Instrumento     varchar(20),
    Par_SucOperacion    int,

    Par_Cargos          decimal(14,4),
    Par_Abonos          decimal(14,4),

    Par_Moneda          int,

    Par_Descripcion     varchar(150),
    Par_Referencia      varchar(50),

    Par_Salida          char(1),
out Par_NumErr          int,
out Par_ErrMen          varchar(400),
out Par_Consecutivo     bigint,

    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint
)
TerminaStore: BEGIN


DECLARE Var_Cuenta          varchar(50);
DECLARE Var_CentroCostosID  int(11);
DECLARE Var_ClabeInst		varchar(18);


DECLARE	Cadena_Vacia		char(1);
DECLARE	Entero_Cero			int;
DECLARE	Salida_SI 			char(1);
DECLARE	Cuenta_Vacia		char(25);
DECLARE Salida_NO  	        char(1);
DECLARE	Procedimiento   	varchar(20);
DECLARE TipoInstrumentoID	int(11);
DECLARE Decimal_Cero		decimal(14,2);


Set Cadena_Vacia    	:= '';
Set Entero_Cero     	:= 0;
Set Salida_SI       	:= 'S';
Set Cuenta_Vacia   	 	:= '0000000000000000000000000';
Set Salida_NO       	:= 'N';
set Procedimiento		:= 'POLIZATRANSFERPRO';
set TipoInstrumentoID 	:= 2;
set Decimal_Cero		:= 0.00;


set Par_NumErr  		:= Entero_Cero;
set Par_ErrMen  		:= Cadena_Vacia;
set	Var_Cuenta			:= '0000000000000000000000000';
set Var_CentroCostosID	:= Entero_Cero;
set	Var_ClabeInst		:= Cadena_Vacia;


ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			set Par_NumErr := 999;
			set Par_ErrMen := concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
									 "estamos trabajando para resolverla. Disculpe las molestias que ",
									 "esto le ocasiona. Ref: SP-POLIZATRANSFERPRO");
		END;



select CtaDDIETrans into Var_Cuenta
	from PARAMETROSSPEIIE
	where	EmpresaID = Par_Empresa;


set Var_Cuenta      := ifnull(Var_Cuenta, Cuenta_Vacia);
set Var_CentroCostosID    := FNCENTROCOSTOS(Par_SucOperacion);

set Aud_FechaActual := CURRENT_TIMESTAMP();

CALL DETALLEPOLIZAALT(
	Par_Empresa,		Par_Poliza,			Par_Fecha, 			Var_CentroCostosID,		Var_Cuenta,
	Par_Instrumento,	Par_Moneda,			Par_Cargos,			Par_Abonos,			Par_Descripcion,
	Par_Referencia,		Procedimiento,		TipoInstrumentoID,	Cadena_Vacia,		Decimal_Cero,
	Cadena_Vacia,		Salida_NO,			Par_NumErr,			Par_ErrMen,			Aud_Usuario,
	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

if(Par_NumErr != Entero_Cero)then
	   select  convert(Par_NumErr, char(10)) as NumErr,
				Par_ErrMen as ErrMen,
				'Poliza' as control,
				Par_Poliza as consecutivo;
	 LEAVE ManejoErrores;
end if;

END ManejoErrores;

if (Par_Salida = Salida_SI) then
    select  convert(Par_NumErr, char(10)) as NumErr,
            Par_ErrMen as ErrMen;
end if;


END TerminaStore$$