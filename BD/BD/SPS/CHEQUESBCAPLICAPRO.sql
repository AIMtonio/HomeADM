-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CHEQUESBCAPLICAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CHEQUESBCAPLICAPRO`;
DELIMITER $$

CREATE PROCEDURE `CHEQUESBCAPLICAPRO`(

	Par_ChequeSBCID			INT(11),
	Par_CuentaAhoID			BIGINT(12),
	Par_ClienteID			INT(11),
	Par_Monto				DECIMAL(14,2),
	Par_NumCheque			INT(10),

	Par_SucursalID			INT(11),
	Par_CajaID				INT(11),
	Par_MonedaID			INT(11),
	Par_AltaEncPoliza		CHAR(1),
	INOUT Par_Poliza		BIGINT,

	Par_AltaDetPol			CHAR(1),
	Par_Salida				CHAR(1),
	INOUT	Par_NumErr 		INT,
	INOUT	Par_ErrMen  	VARCHAR(350),

	Par_EmpresaID			INT,
	Aud_Usuario         	INT,
	Aud_FechaActual     	DATETIME,
	Aud_DireccionIP     	VARCHAR(15),
	Aud_ProgramaID      	VARCHAR(50),
	Aud_Sucursal        	INT(11),
	Aud_NumTransaccion  	BIGINT(20)
	)
TerminaStore:BEGIN


DECLARE Var_FechaOper			DATE;
DECLARE Var_FechaApl			DATE;
DECLARE Var_EsHabil				CHAR(1);
DECLARE Var_SucCliente			INT(11);
DECLARE Var_CtaContaDocSBCD		VARCHAR(25);
DECLARE Var_CtaContaDocSBCA		VARCHAR(25);
DECLARE Var_MonedaBaseID		INT(11);
DECLARE Var_AfectaContaRecSBC	CHAR(1);
DECLARE Var_CentroCostos		VARCHAR(30);


DECLARE SalidaNO			CHAR(1);
DECLARE SalidaSI			CHAR(1);
DECLARE Entero_Cero			INT;
DECLARE Abono				CHAR(1);
DECLARE DescripcionMov		VARCHAR(100);
DECLARE concepContaDepVent	INT;
DECLARE tipoMovAbonoCuenta	INT;
DECLARE conceptoAhorro		INT;
DECLARE Est_Aplicado		CHAR(1);
DECLARE Act_AplicaCheque	INT;
DECLARE Cadena_Vacia		CHAR;
DECLARE FormaAplicacion		CHAR(1);
DECLARE Est_Activa			CHAR(1);
DECLARE DescripconCargo		VARCHAR(100);
DECLARE DescripconAbono		VARCHAR(100);
DECLARE Procedimiento		VARCHAR(100);
DECLARE SI					CHAR(1);
DECLARE TipoInstrumentoID	INT(11);
DECLARE For_SucOrigen		CHAR(3);
DECLARE For_SucCliente		CHAR(3);
DECLARE Decimal_Cero		DECIMAL(12,2);
DECLARE Var_CentroCostosID	INT(11);


SET SalidaNO			:='N';
SET SalidaSI			:='S';
SET Entero_Cero			:=0;
SET Abono				:='A';
SET DescripcionMov		:='ABONO DE EFECTIVO CHEQUE SBC';
SET concepContaDepVent	:=30;
SET tipoMovAbonoCuenta	:=23;
SET conceptoAhorro 		:=1;
SET Est_Aplicado		:='A';
SET Act_AplicaCheque	:=1;
SET Cadena_Vacia		:='';
SET FormaAplicacion		:='E';
SET Est_Activa			:='A';
SET DescripconCargo		:='DCTOS  DE COBRO INMEDIATO SALVO BUEN COBRO COD';
SET DescripconAbono		:='DCTOS  DE COBRO INMEDIATO SALVO BUEN COBRO COA';
SET Procedimiento		:='CHEQUESBCAPLICAPRO';
SET SI					:='S';
SET TipoInstrumentoID	:=9;
SET For_SucCliente		:='&SC';
SET For_SucOrigen		:='&SO';
SET Decimal_Cero		:=0.0;
SET Var_CentroCostosID	:=0;

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CHEQUESBCAPLICAPRO');
			END;

	SET Par_NumErr  := Entero_Cero;
	SET Par_ErrMen  := Cadena_Vacia;
	SET Aud_FechaActual := NOW();
	SET Var_FechaOper   := (SELECT FechaSistema
                            FROM PARAMETROSSIS);
	CALL DIASFESTIVOSCAL(
			Var_FechaOper,		Entero_Cero,		 Var_FechaApl,		Var_EsHabil,		Par_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

	SELECT  Cli.SucursalOrigen INTO Var_SucCliente
		FROM  CLIENTES Cli
		WHERE Cli.ClienteID   = Par_ClienteID;

	IF EXISTS(SELECT ChequeSBCID
					FROM ABONOCHEQUESBC
					WHERE ChequeSBCID=Par_ChequeSBCID
						AND Estatus=Est_Aplicado)THEN
			SET Par_NumErr :=1;
			SET Par_ErrMen := CONCAT('El Cheque ',Par_NumCheque,' fue depositado en una operacion anterior ');
			LEAVE ManejoErrores;
	END IF;

	IF EXISTS(SELECT Estatus
					FROM CUENTASAHO
						WHERE Estatus != Est_Activa
							AND CuentaAhoID=Par_CuentaAhoID)THEN
					SET Par_NumErr :=2;
					SET Par_ErrMen := CONCAT('La cuenta ',Par_CuentaAhoID, ' no se encuentra activa');
					LEAVE ManejoErrores;
			END IF;

	CALL ABONOCHEQUESBCACT(
					Par_ChequeSBCID,	Var_FechaOper,	Entero_Cero,	FormaAplicacion,	Entero_Cero,
					Act_AplicaCheque,	SalidaNO,		Par_NumErr,		Par_ErrMen,		Par_EmpresaID,
					Aud_Usuario,		Aud_FechaActual,Aud_DireccionIP,Aud_ProgramaID,	Aud_Sucursal,
					Aud_NumTransaccion);



	UPDATE CUENTASAHO SET
			SaldoSBC = SaldoSBC - Par_Monto,

			Usuario         = Aud_Usuario,
			FechaActual     = Aud_FechaActual,
			DireccionIP     = Aud_DireccionIP,
			ProgramaID      = Aud_ProgramaID,
			Sucursal        = Aud_Sucursal,
			NumTransaccion  = Aud_NumTransaccion

			WHERE CuentaAhoID=Par_CuentaAhoID;




	CALL CONTAAHORROPRO(Par_CuentaAhoID,		Par_ClienteID,		Aud_NumTransaccion,		Var_FechaOper,		Var_FechaApl,
						Abono,					Par_Monto,			DescripcionMov,			Par_CuentaAhoID,	tipoMovAbonoCuenta,
						Par_MonedaID,			Var_SucCliente,		Par_AltaEncPoliza, 		concepContaDepVent,	Par_Poliza,
						Par_AltaDetPol, 		conceptoAhorro,		Abono,					Par_NumErr,			Par_ErrMen,
						Entero_Cero,			Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
						Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);


	SELECT CtaContaDocSBCD, CtaContaDocSBCA, MonedaBaseID , AfectaContaRecSBC
				INTO Var_CtaContaDocSBCD, Var_CtaContaDocSBCA, Var_MonedaBaseID, Var_AfectaContaRecSBC
			FROM PARAMETROSSIS
				WHERE EmpresaID =Par_EmpresaID
				LIMIT 1;

	SET Var_CtaContaDocSBCD 	:= IFNULL(Var_CtaContaDocSBCD, Cadena_Vacia);
		SET Var_CtaContaDocSBCA		:=IFNULL(Var_CtaContaDocSBCA,Cadena_Vacia );
		SET Var_MonedaBaseID		:=IFNULL(Var_MonedaBaseID,Entero_Cero );
		SET Var_AfectaContaRecSBC	:= IFNULL(Var_AfectaContaRecSBC, Cadena_Vacia);



	SELECT CenCostosChequeSBC
				INTO Var_CentroCostos
				FROM PARAMETROSSIS
				WHERE EmpresaID= Par_EmpresaID
				LIMIT 1;

	SELECT SucursalOrigen
		INTO Var_SucCliente
		FROM CLIENTES
		WHERE ClienteID = Par_ClienteID
		LIMIT 1;


	IF LOCATE(For_SucOrigen, Var_CentroCostos) > Entero_Cero THEN
				SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
			ELSE
				IF LOCATE(For_SucCliente, Var_CentroCostos) > Entero_Cero THEN
						IF (Var_SucCliente > Entero_Cero) THEN
							SET Var_CentroCostosID := FNCENTROCOSTOS(Var_SucCliente);
						ELSE
							SET Var_CentroCostosID := FNCENTROCOSTOS(Aud_Sucursal);
						END IF;
			END IF;
	END IF;


	SET Par_CajaID	:= CONVERT(Par_CajaID, CHAR);
	IF(Var_AfectaContaRecSBC = SI)THEN

			CALL DETALLEPOLIZAALT (
				Par_EmpresaID,		Par_Poliza,			Var_FechaOper,		Var_CentroCostosID,	Var_CtaContaDocSBCD,
				Par_NumCheque,		Var_MonedaBaseID,	Entero_Cero,		Par_Monto,			DescripconCargo,
				Par_CajaID, 		Procedimiento,		TipoInstrumentoID,	Cadena_Vacia,		Decimal_Cero,
				Cadena_Vacia,		SalidaNO,			Par_NumErr,			Par_ErrMen,			Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
			);

			CALL DETALLEPOLIZAALT (
				Par_EmpresaID,		Par_Poliza,			Var_FechaOper,		Var_CentroCostosID,	Var_CtaContaDocSBCA,
				Par_NumCheque,		Var_MonedaBaseID,	Par_Monto,			Entero_Cero,		DescripconAbono,
				Par_CajaID, 		Procedimiento,		TipoInstrumentoID,	Cadena_Vacia,		Decimal_Cero,
				Cadena_Vacia,		SalidaNO,			Par_NumErr,			Par_ErrMen,			Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
			);

	END IF;

	SET Par_NumErr := Entero_Cero;
	SET Par_ErrMen := "Cheque Abonado Correctamente.";

END ManejoErrores;
IF (Par_Salida = SalidaSI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen AS ErrMen,
            'tipoOperacion' AS control,
            Par_Poliza AS consecutivo;
END IF;
END TerminaStore$$