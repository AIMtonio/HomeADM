
-- REVERSAPAGOFONCRWPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `REVERSAPAGOFONCRWPRO`;
DELIMITER $$


CREATE PROCEDURE `REVERSAPAGOFONCRWPRO`(
	Par_CreditoID 		BIGINT(12),
	Par_TranRespaldo	BIGINT(20),

	Par_Salida			CHAR(1),
	INOUT Par_NumErr    INT(11),
	INOUT Par_ErrMen    VARCHAR(400),

	Par_EmpresaID       INT(11),
	Aud_Usuario         INT(11),
	Aud_FechaActual     DATETIME,
	Aud_DireccionIP     VARCHAR(15),
	Aud_ProgramaID      VARCHAR(50),
	Aud_Sucursal        INT(11),
	Aud_NumTransaccion  BIGINT(20)
 )
TerminaStore:BEGIN

-- Declaracion de Variables
DECLARE Var_Abonos			DECIMAL(14,2);
DECLARE Var_Cargos			DECIMAL(14,2);
DECLARE Var_CuentaAhoID		BIGINT(12);
DECLARE Var_Contador		INT(11);
DECLARE Var_TotalReg		INT(11);
DECLARE Var_SolFondeoID		BIGINT(20);
DECLARE Var_NumTransaccion	BIGINT(20);
DECLARE Var_Control			VARCHAR(45);

-- Declaracion de Constantes
DECLARE Nat_Abonos				CHAR(1);
DECLARE Nat_Cargos				CHAR(1);
DECLARE Str_SI					CHAR(1);
DECLARE Str_NO					CHAR(1);
DECLARE Entero_Cero				INT;

-- Asignacion de Constantes
SET Nat_Abonos		:= 'A';				-- Abonos
SET Nat_Cargos		:= 'C';				-- Cargos
SET Str_SI			:= 'S';				-- Constante SI
SET Str_NO			:= 'N';				-- Constante NO
SET Entero_Cero		:= 0;				-- Entero Cero.

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := '999';
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-REVERSAPAGOFONCRWPRO');
			SET Var_Control := 'SQLEXCEPTION' ;
		END;
	/* Actualizamos la tabla de CRWFONDEO con ayuda de la tabla de CRWRESFONDEO*/
	UPDATE CRWFONDEO fon
		INNER JOIN CRWRESFONDEO rfon ON fon.SolFondeoID = rfon.SolFondeoID
	SET
		fon.ClienteID			= rfon.ClienteID,
		fon.CreditoID			= rfon.CreditoID,
		fon.CuentaAhoID			= rfon.CuentaAhoID,
		fon.SolicitudCreditoID	= rfon.SolicitudCreditoID,
		fon.Consecutivo			= rfon.Consecutivo,

		fon.Folio				= rfon.Folio,
		fon.CalcInteresID		= rfon.CalcInteresID,
		fon.TasaBaseID			= rfon.TasaBaseID,
		fon.SobreTasa			= rfon.SobreTasa,
		fon.TasaFija			= rfon.TasaFija,

		fon.PisoTasa			= rfon.PisoTasa,
		fon.TechoTasa			= rfon.TechoTasa,
		fon.MontoFondeo			= rfon.MontoFondeo,
		fon.PorcentajeFondeo	= rfon.PorcentajeFondeo,
		fon.MonedaID			= rfon.MonedaID,

		fon.FechaInicio			= rfon.FechaInicio,
		fon.FechaVencimiento	= rfon.FechaVencimiento,
		fon.TipoFondeo			= rfon.TipoFondeo,
		fon.NumCuotas			= rfon.NumCuotas,
		fon.NumRetirosMes		= rfon.NumRetirosMes,

		fon.PorcentajeMora		= rfon.PorcentajeMora,
		fon.PorcentajeComisi	= rfon.PorcentajeComisi,
		fon.Estatus				= rfon.Estatus,
		fon.SaldoCapVigente		= rfon.SaldoCapVigente,
		fon.SaldoCapExigible	= rfon.SaldoCapExigible,

		fon.SaldoInteres		= rfon.SaldoInteres,
		fon.SaldoIntMoratorio	= rfon.SaldoIntMoratorio,
		fon.ProvisionAcum		= rfon.ProvisionAcum,
		fon.MoratorioPagado		= rfon.MoratorioPagado,
		fon.ComFalPagPagada		= rfon.ComFalPagPagada,

		fon.IntOrdRetenido		= rfon.IntOrdRetenido,
		fon.IntMorRetenido		= rfon.IntMorRetenido,
		fon.ComFalPagRetenido	= rfon.ComFalPagRetenido,
		fon.Gat					= rfon.Gat,
		fon.SaldoCapCtaOrden	= rfon.CapitalCtaOrden,

		fon.SaldoIntCtaOrden	= rfon.InteresCtaOrden,
		fon.EmpresaID			= rfon.EmpresaID,
		fon.Usuario				= rfon.Usuario,
		fon.FechaActual			= rfon.FechaActual,
		fon.DireccionIP			= rfon.DireccionIP,

		fon.ProgramaID			= rfon.ProgramaID,
		fon.Sucursal			= rfon.Sucursal,
		fon.NumTransaccion		= rfon.NumTransaccion
	WHERE rfon.TranRespaldo = Par_TranRespaldo;

	DELETE FROM TMPREVCRWRESFONDEO WHERE NumTransaccion = Aud_NumTransaccion;

	INSERT INTO TMPREVCRWRESFONDEO (
		SolFondeoID,	TranRespaldo,	CuentaAhoID,	NumTransaccion)
	SELECT
		SolFondeoID,	TranRespaldo,	CuentaAhoID,	Aud_NumTransaccion
		FROM CRWRESFONDEO
		WHERE TranRespaldo = Par_TranRespaldo;

	SET Var_Contador := 1;
	SET Var_TotalReg := (SELECT COUNT(*) FROM TMPREVCRWRESFONDEO WHERE NumTransaccion = Aud_NumTransaccion);
	SET Var_TotalReg := IFNULL(Var_TotalReg, Entero_Cero);

	WHILE(Var_Contador <= Var_TotalReg)DO
		SELECT
			SolFondeoID,		TranRespaldo,		CuentaAhoID
		INTO
			Var_SolFondeoID,	Var_NumTransaccion,	Var_CuentaAhoID
		FROM TMPREVCRWRESFONDEO
		WHERE TmpID = Var_Contador
			AND NumTransaccion = Aud_NumTransaccion;

		DELETE FROM AMORTICRWFONDEO WHERE SolFondeoID = Var_SolFondeoID;

		SET Var_Cargos	:=	Entero_Cero;
		SET Var_Abonos	:=	Entero_Cero;

		-- Actualizamos Saldos de la cuenta de Ahorro del Fondeador, los mov fueron borrados en REVERSAPAGCREPRO
		SET Var_Abonos :=	(SELECT SUM(Cantidad)
							FROM 	CRWFONDEOMOVS
							WHERE 	NatMovimiento = Nat_Abonos
								AND SolFondeoID = Var_SolFondeoID
								AND Transaccion = Var_NumTransaccion);

		SET Var_Cargos := (SELECT 	SUM(Cantidad)
							FROM 	CRWFONDEOMOVS
							WHERE 	NatMovimiento = Nat_Cargos
								AND SolFondeoID = Var_SolFondeoID
								AND Transaccion = Var_NumTransaccion);

		SET Var_Abonos := IFNULL(Var_Abonos,Entero_Cero); -- ok
		SET Var_Cargos := IFNULL(Var_Cargos,Entero_Cero);

		UPDATE CUENTASAHO
		SET
			Saldo 		= 	(Saldo + Var_Cargos - Var_Abonos),
			SaldoDispon	=	(SaldoDispon + Var_Cargos - Var_Abonos),
			CargosMes	=	(CargosMes - Var_Cargos),
			CargosDia	=	(CargosDia - Var_Cargos),
			AbonosDia	=	(AbonosDia - Var_Abonos),
			AbonosMes	=	(AbonosMes - Var_Abonos)
		WHERE CuentaAhoID = Var_CuentaAhoID;

		DELETE FROM CRWFONDEOMOVS
			WHERE SolFondeoID = Var_SolFondeoID
				AND NumTransaccion = Par_TranRespaldo;

		SET Var_Contador := (Var_Contador +1);
	END WHILE;

	INSERT INTO AMORTICRWFONDEO (
			SolFondeoID,			AmortizacionID,			FechaInicio,			FechaVencimiento,
			FechaExigible,			Capital,				InteresGenerado,		InteresRetener,		PorcentajeInteres,
			PorcentajeCapital,		Estatus,				SaldoCapVigente,		SaldoCapExigible,	SaldoInteres,
			SaldoIntMoratorio,		ProvisionAcum,			RetencionIntAcum,		MoratorioPagado,	ComFalPagPagada,
			IntOrdRetenido,			IntMorRetenido,			ComFalPagRetenido,		FechaLiquida,		SaldoCapCtaOrden,
			SaldoIntCtaOrden,		EmpresaID,				Usuario,				FechaActual,		DireccionIP,
			ProgramaID,				Sucursal,				NumTransaccion	)
	SELECT 	amo.SolFondeoID,		amo.AmortizacionID,		amo.FechaInicio,		amo.FechaVencimiento,
			amo.FechaExigible,		amo.Capital,			amo.InteresGenerado,	amo.InteresRetener,		amo.PorcentajeInteres,
			amo.PorcentajeCapital,	amo.Estatus,			amo.SaldoCapVigente,	amo.SaldoCapExigible,	amo.SaldoInteres,
			amo. SaldoIntMoratorio,	amo.ProvisionAcum,		amo.RetencionIntAcum,	amo.MoratorioPagado,	amo.ComFalPagPagada,
			amo.IntOrdRetenido,		amo.IntMorRetenido,		amo.ComFalPagRetenido,	amo.FechaLiquida,		amo.CapitalCtaOrden,
			amo.InteresCtaOrden,	amo.EmpresaID,			amo.Usuario,			amo.FechaActual,		amo.DireccionIP,
			amo.ProgramaID,			amo.Sucursal,			amo.NumTransaccion
		FROM RESAMORTICRWFONDEO amo
		WHERE amo.TranRespaldo = Par_TranRespaldo;

	-- Se eliminan los datos de la tabla RESAMORTICRWFONDEO --
	DELETE FROM RESAMORTICRWFONDEO
		WHERE TranRespaldo = Par_TranRespaldo;

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := 'Reversa Grabada Exitosamente.';
	SET Var_Control:= 'tranRespaldo' ;

END ManejoErrores;

IF (Par_Salida = Str_SI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Par_PaisID AS Consecutivo;
END IF;

END TerminaStore$$