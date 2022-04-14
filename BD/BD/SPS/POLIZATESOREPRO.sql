-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- POLIZATESOREPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `POLIZATESOREPRO`;
DELIMITER $$

CREATE PROCEDURE `POLIZATESOREPRO`(
    Par_Poliza          bigint,
    Par_Empresa         int,
    Par_Fecha           date,
    Par_Instrumento     varchar(20),
    Par_SucOperacion    int,
    Par_ConceptoTeso    int,

    Par_Cargos          decimal(14,4),
    Par_Abonos          decimal(14,4),

    Par_Moneda          int,
    Par_TipoGastoID     int,
    Par_ProveedorID     int,
    Par_TipImpuestoID   int,
    Par_InstitucionID   int,
    Par_CuentaBancos    varchar(20),

    Par_Descripcion     varchar(100),
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


DECLARE	Var_Instrumento     varchar(20);
DECLARE Var_Cuenta          varchar(50);
DECLARE Var_CentroCostosID  int(11);
DECLARE Var_Nomenclatura    varchar(30);
DECLARE Var_NomenclaturaCR  varchar(3);
DECLARE Var_CuentaMayor     varchar(4);
DECLARE	Var_NomenclaturaSO  int;
DECLARE	Var_SubCuentaTM     char(3);
DECLARE	Var_SubCuentaIF     char(3);
DECLARE	Var_SubCuentaTG     char(3);
DECLARE	Var_SubCuentaTP     char(3);
DECLARE	Var_SubCuentaTI     char(3);


DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia			date;
DECLARE	Entero_Cero			int;
DECLARE	Salida_SI 			char(1);
DECLARE	Cuenta_Vacia		char(25);
DECLARE  Salida_NO  	    char(1);

DECLARE	For_CueMayor		char(3);
DECLARE	For_Instit			char(3);
DECLARE	For_Moneda			char(3);
DECLARE	For_TipGasto		char(3);
DECLARE	For_Proveedor   	char(3);
DECLARE	For_TipImpues   	char(3);
DECLARE	For_SucOrigen   	char(3);

DECLARE	Procedimiento   	varchar(20);
DECLARE TipoInstrumentoID	INT(11);
DECLARE Var_FolioUUID		varchar(100);
DECLARE Var_ProvRFC			varchar(13);
DECLARE Var_FactProv		varchar(50);
DECLARE Var_TipoPersona 	CHAR(1);
DECLARE Decimal_Cero		decimal(14,2);
DECLARE PersonaFisica		char(1);


Set Cadena_Vacia    	:= '';
Set Fecha_Vacia     	:= '1900-01-01';
Set Entero_Cero     	:= 0;
Set Salida_SI       	:= 'S';
Set Cuenta_Vacia   	 	:= '0000000000000000000000000';
Set Salida_NO       	:= 'N';

Set For_CueMayor    	:= '&CM';
Set For_Instit      	:= '&IF';
Set For_Moneda      	:= '&TM';
Set For_TipGasto    	:= '&TG';
Set For_Proveedor   	:= '&TP';
Set For_TipImpues   	:= '&TI';
Set For_SucOrigen   	:= '&SO';

set Procedimiento		:= 'POLIZATESOREPRO';
SET TipoInstrumentoID 	:= 19;


set Par_NumErr  		:= Entero_Cero;
set Par_ErrMen  		:= Cadena_Vacia;

set	Var_Cuenta			:= '0000000000000000000000000';
set Var_Instrumento 	:= Par_Instrumento;

set Var_CentroCostosID	:= Entero_Cero;
set Decimal_Cero		:= 0.00;
set PersonaFisica		:= 'F';

ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			set Par_NumErr = 999;
			set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
									 "estamos trabajando para resolverla. Disculpe las molestias que ",
									 "esto le ocasiona. Ref: SP-POLIZATESOREPRO");
		END;



    if(Par_InstitucionID != Entero_Cero and Par_CuentaBancos != Cadena_Vacia) then
		if(Par_SucOperacion > Entero_Cero) then
			select CuentaCompletaID into Var_Cuenta
				from CUENTASAHOTESO
				where InstitucionID = Par_InstitucionID
					and NumCtaInstit  = Par_CuentaBancos;

				set Var_Cuenta      := ifnull(Var_Cuenta, Cuenta_Vacia);
				set Var_CentroCostosID    := FNCENTROCOSTOS(Par_SucOperacion);
		else
			select CuentaCompletaID, CentroCostoID into Var_Cuenta, Var_CentroCostosID
				from CUENTASAHOTESO
				where InstitucionID = Par_InstitucionID
					and NumCtaInstit  = Par_CuentaBancos;

				set Var_Cuenta      := ifnull(Var_Cuenta, Cuenta_Vacia);
				set Var_CentroCostosID    := ifnull(Var_CentroCostosID, FNCENTROCOSTOS(Aud_Sucursal));
		end if;

    else

        select	Nomenclatura, Cuenta, NomenclaturaCR  into
                    Var_Nomenclatura, Var_CuentaMayor, Var_NomenclaturaCR
            from  CUENTASMAYORTESO Ctm
            where Ctm.ConceptoTesoID	= Par_ConceptoTeso;

        set Var_Nomenclatura := ifnull(Var_Nomenclatura, Cadena_Vacia);
        set Var_NomenclaturaCR := ifnull(Var_NomenclaturaCR, Cadena_Vacia);

        if(Var_Nomenclatura = Cadena_Vacia) then
            set Var_Cuenta := Cuenta_Vacia;
        else

            if LOCATE(For_SucOrigen, Var_NomenclaturaCR) > Entero_Cero then
                set Var_NomenclaturaSO := Par_SucOperacion;
                if (Var_NomenclaturaSO != Entero_Cero) then
                    set Var_CentroCostosID :=  FNCENTROCOSTOS(Var_NomenclaturaSO);
                end if;

            else
                set Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
            end if;

            set Var_Cuenta := Var_Nomenclatura;

            if LOCATE(For_CueMayor, Var_Cuenta) > Entero_Cero then
                set Var_Cuenta := REPLACE(Var_Cuenta, For_CueMayor, Var_CuentaMayor);
            end if;


            if LOCATE(For_Moneda, Var_Cuenta) > Entero_Cero then
                select	SubCuenta into Var_SubCuentaTM
                    from  SUBCTAMONEDATESO Sub
                    where Sub.MonedaID		= Par_Moneda
                      and Sub.ConceptoTesoID	= Par_ConceptoTeso;

                set Var_SubCuentaTM := ifnull(Var_SubCuentaTM, Cadena_Vacia);

                if (Var_SubCuentaTM != Cadena_Vacia) then
                    set Var_Cuenta := REPLACE(Var_Cuenta, For_Moneda, Var_SubCuentaTM);
                end if;

            end if;


            if LOCATE(For_Instit, Var_Cuenta) > Entero_Cero then
                select	SubCuenta into Var_SubCuentaIF
                    from  SUBCTAINSFINTESO Sub
                    where Sub.InstitucionID     = Par_InstitucionID
                      and Sub.ConceptoTesoID    = Par_ConceptoTeso;

                set Var_SubCuentaIF := ifnull(Var_SubCuentaIF, Cadena_Vacia);

                if (Var_SubCuentaIF != Cadena_Vacia) then
                    set Var_Cuenta := REPLACE(Var_Cuenta, For_Instit, Var_SubCuentaIF);
                end if;

            end if;


            if LOCATE(For_TipGasto, Var_Cuenta) > Entero_Cero then
                select	SubCuenta into Var_SubCuentaTG
                    from  SUBCTATIPGASTESO Sub
                    where Sub.TipoGastoID       = Par_TipoGastoID
                      and Sub.ConceptoTesoID    = Par_ConceptoTeso;

                set Var_SubCuentaTG := ifnull(Var_SubCuentaTG, Cadena_Vacia);

                if (Var_SubCuentaTG != Cadena_Vacia) then
                    set Var_Cuenta := REPLACE(Var_Cuenta, For_TipGasto, Var_SubCuentaTG);
                end if;

            end if;


            if LOCATE(For_Proveedor, Var_Cuenta) > Entero_Cero then
                select	SubCuenta into Var_SubCuentaTP
                    from  SUBCTAPROVETESO Sub
                    where Sub.ProveedorID       = Par_ProveedorID
                      and Sub.ConceptoTesoID    = Par_ConceptoTeso;

                set Var_SubCuentaTP := ifnull(Var_SubCuentaTP, Cadena_Vacia);

                if (Var_SubCuentaTP != Cadena_Vacia) then
                    set Var_Cuenta := REPLACE(Var_Cuenta, For_Proveedor, Var_SubCuentaTP);
                end if;

            end if;


            if LOCATE(For_TipImpues, Var_Cuenta) > Entero_Cero then
                select	SubCuenta into Var_SubCuentaTI
                    from  SUBCTAIMPUESTESO Sub
                    where Sub.TipImpuestoID     = Par_TipImpuestoID
                      and Sub.ConceptoTesoID    = Par_ConceptoTeso;

                set Var_SubCuentaTI := ifnull(Var_SubCuentaTI, Cadena_Vacia);

                if (Var_SubCuentaTI != Cadena_Vacia) then
                    set Var_Cuenta := REPLACE(Var_Cuenta, For_TipImpues, Var_SubCuentaTI);
                end if;

            end if;
        end if;
    end if;

	set Var_FactProv := substring(Par_Referencia,1,locate('-',Par_Referencia)-1);
    set Var_Cuenta := REPLACE(Var_Cuenta, '-', Cadena_Vacia);


select FolioUUID into Var_FolioUUID
	from FACTURAPROV
	where NoFactura =Var_FactProv and ProveedorID = Par_ProveedorID
	limit 1;


	set Var_FolioUUID = ifnull(Var_FolioUUID,Cadena_Vacia);
    set Var_TipoPersona := (select TipoPersona from PROVEEDORES where ProveedorID=Par_ProveedorID);

    if(Var_TipoPersona = PersonaFisica) then
		set Var_ProvRFC := (select RFC from PROVEEDORES where ProveedorID = Par_ProveedorID);

	else
		set Var_ProvRFC := (select RFCpm from PROVEEDORES where ProveedorID = Par_ProveedorID);

    end if;


    CALL DETALLEPOLIZAALT(
        Par_Empresa,		Par_Poliza,			Par_Fecha, 			Var_CentroCostosID,	Var_Cuenta,
        Var_Instrumento,	Par_Moneda,			Par_Cargos,			Par_Abonos,			Par_Descripcion,
        Par_Referencia,		Procedimiento,		TipoInstrumentoID,	Var_ProvRFC,		Decimal_Cero,
		Var_FolioUUID,		Salida_NO,			Par_NumErr,			Par_ErrMen,			Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

    set	Par_NumErr := 0;
    set	Par_ErrMen := 'Poliza Tesoreria Aplicada.';



END ManejoErrores;

if (Par_Salida = Salida_SI) then
    select  convert(Par_NumErr, char(10)) as NumErr,
            Par_ErrMen as ErrMen;
end if;


END TerminaStore$$