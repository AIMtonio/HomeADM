-- EDOCTAV2HEADERCTAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAV2HEADERCTAPRO`;
DELIMITER $$

CREATE PROCEDURE `EDOCTAV2HEADERCTAPRO`(
	Par_Salida			CHAR(1),			-- Parametro que indica si el procedimiento devuelve una salida
	INOUT Par_NumErr	INT(11),
	INOUT Par_ErrMen	VARCHAR(400),

    -- Parametros de Auditoria
	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)

TerminaStore: BEGIN

	-- DECLARACION DE CONSTANTES
	DECLARE	Cadena_Vacia				VARCHAR(1);					-- Cadena Vacia
	DECLARE	Fecha_Vacia					DATE;						-- Fecha Vacia
	DECLARE	Entero_Cero					INT(11);					-- Entero Cero
	DECLARE	Moneda_Cero					INT(11);					-- Decimal Cero
	DECLARE NoEsInversion				CHAR(1);					-- Cuenta no es inversion: N
	DECLARE EsInversion					CHAR(1);					-- Cuenta es inversion: S
	DECLARE EstatusActiva				CHAR(1);					-- Estatus de la cuenta: ACTIVA
	DECLARE EstatusCancelado			CHAR(1);					-- Estatus de la cuenta: CANCELADA
	DECLARE EstatusBloqueado			CHAR(1);					-- Estatus de la cuenta: BLOQUEADA
	DECLARE EstatusInactiva				CHAR(1);					-- Estatus de la cuenta: INACTIVA
	DECLARE EstatusRegistrada			CHAR(1);					-- Estatus de la cuenta: REGISTRADA
	DECLARE TipoProdAhorro				INT(11);

	-- VARIABLES
	DECLARE Var_IniMes					DATE;						-- Fecha Inicio Mes
	DECLARE Var_FinMes					DATE;						-- Fecha Fin Mes
	DECLARE Var_FecCorte				DATE;						-- Fecha corte de la tabla historico de cuentas
	DECLARE Var_AnioMes    	 	 	 	INT(11);					-- Anio y Mes Estado Cuenta
	DECLARE Var_FolioProceso			BIGINT(20);
	DECLARE Constante_Si				CHAR(1);
	DECLARE Var_Control					VARCHAR(25);

	-- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia					:= '';						-- Cadena Vacia
	SET Fecha_Vacia						:= '1900-01-01';			-- Fecha Vacia
	SET Entero_Cero						:= 0;						-- Entero Cero
	SET Moneda_Cero						:= 0.00;					-- Decimal Cero
	SET NoEsInversion					:= 'N';						-- No es cuenta de inversion
	SET TipoProdAhorro					:= 1;						-- 1= Ahorro   2 = Cede.   3 = Inversion   4 = Credito
	SET EsInversion						:= 'S';						-- Es una cuenta de inversion
	SET EstatusActiva					:= 'A';						-- Estatus de la cuenta: ACTIVA
	SET EstatusCancelado				:= 'C';						-- Estatus de la cuenta: CANCELADA
	SET EstatusBloqueado				:= 'B';						-- Estatus de la cuenta: BLOQUEADA
	SET EstatusInactiva					:= 'I';						-- Estatus de la cuenta: INACTIVA
	SET EstatusRegistrada				:= 'R';						-- Estatus de la cuenta: REGISTRADA
	SET Constante_Si					:= 'S';
	
	ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-EDOCTAV2HEADERCTAPRO');
			SET Var_Control	= 'sqlException';
		END;

		SELECT MesProceso,FolioProceso,FechaInicio,FechaFin
		INTO Var_AnioMes,Var_FolioProceso,Var_IniMes,Var_FinMes
		FROM EDOCTAV2PARAMS LIMIT 1;

		-- Se obtiene la Fecha Corte del historico de acuerdo al periodo
		SELECT MAX(Fecha)
		INTO Var_FecCorte
		FROM `HIS-CUENTASAHO`
		WHERE Fecha <= Var_FinMes;

		DELETE FROM EDOCTAV2HEADERCTA
		WHERE FolioProceso = Var_FolioProceso;

INSERT INTO EDOCTAV2HEADERCTA(	AnioMes,			ClienteID,			SucursalID,			CuentaAhoID,		TipoCuentaID,
								ProductoDesc,
								SaldoMesAnterior,	SaldoActual,		SaldoPromedio,
								Clabe,				SaldoMinimo,		ISRRetenido,
								GatNominal,
								GatReal,
								TasaBruta,
								InteresPerido,
								MontoComision,
								IvaComision,
								MonedaID,			MonedaDescri,		DepositosMes,		RetirosMes,			Estatus,
								FolioProceso,		EmpresaID,			Usuario,			FechaActual,		DireccionIP,
								ProgramaID,			Sucursal,			NumTransaccion)
			SELECT				Var_AnioMes,		Cli.ClienteID,		Cta.SucursalID,		Cta.CuentaAhoID,	Cta.TipoCuentaID,
								Tc.Descripcion,
								Cta.SaldoIniMes,	Cta.Saldo,			Cta.SaldoProm,
								Cta.Clabe,			Tc.SaldoMInReq,		Cta.ISR,
								IFNULL(Cta.Gat, Moneda_Cero),
								IFNULL(Cta.GatReal, Moneda_Cero),
								IFNULL(Cta.TasaInteres, Moneda_Cero),
								IFNULL(Cta.InteresesGen, Moneda_Cero),
								IFNULL(Cta.ComApertura, Moneda_Cero) +
								IFNULL(Cta.ComAniversario, Moneda_Cero) + IFNULL(Cta.ComFalsoCobro, Moneda_Cero) + IFNULL(Cta.ComDispSeg, Moneda_Cero),
								IFNULL(Cta.IvaComApertura, Moneda_Cero) +	IFNULL(Cta.IvaComAniv, Moneda_Cero)  +
																			IFNULL(Cta.IvaComFalsoCob, Moneda_Cero) +	IFNULL(Cta.IvaComDispSeg, Moneda_Cero),
								Cta.MonedaID,		Cadena_Vacia,		Cta.AbonosMes,		Cta.CargosMes,		CASE Cta.Estatus 	WHEN EstatusActiva THEN 'ACTIVA'
																																	WHEN EstatusBloqueado THEN 'BLOQUEADA'
																																	WHEN EstatusCancelado THEN 'CANCELADA'
																																	WHEN EstatusInactiva THEN 'INACTIVA'
																																	WHEN EstatusRegistrada THEN 'REGISTRADA'
																																	ELSE 'Estatus No Identificado'
																											END,
								Var_FolioProceso,	Par_EmpresaID,		Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,
								Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
			FROM EDOCTAV2DATOSCTE Cli
			INNER JOIN `HIS-CUENTASAHO` Cta ON Cli.ClienteID = Cta.ClienteID AND Cta.Fecha = Var_FecCorte
																			 AND Cta.Estatus IN (EstatusActiva,EstatusBloqueado,EstatusCancelado)
			INNER JOIN TIPOSCUENTAS Tc ON Cta.TipoCuentaID = Tc.TipoCuentaID
			INNER JOIN EDOCTAV2PRODUCTOS PROD ON Cta.TipoCuentaID = PROD.ProductoID AND PROD.TipoProducto = TipoProdAhorro
			WHERE  Cli.FolioProceso = Var_FolioProceso ;

		-- Se actualiza la descripcion de la moneda
		UPDATE EDOCTAV2HEADERCTA Edo
			INNER JOIN MONEDAS Mon ON Edo.MonedaID = Mon.MonedaId
		SET Edo.MonedaDescri = Mon.DescriCorta;

		DROP TEMPORARY TABLE IF EXISTS TMP_CTACOMMANEJOCTA;
		CREATE TEMPORARY TABLE TMP_CTACOMMANEJOCTA
		SELECT CuentaAhoID,
			SUM(CASE WHEN TipoMovAhoID = 202 THEN CantidadMov ELSE Entero_Cero END) AS ComManejoCta,
			SUM(CASE WHEN TipoMovAhoID = 203 THEN CantidadMov ELSE Entero_Cero END) AS IVAComManejoCta
			FROM `HIS-CUENAHOMOV`
			WHERE Fecha >= Var_IniMes
			AND Fecha >= Var_FinMes
			GROUP BY CuentaAhoID;

		CREATE INDEX IDX_TMP_CTACOMMANEJOCTA_01 ON TMP_CTACOMMANEJOCTA(CuentaAhoID);


		-- Se actualiza la El monto de Comsion por Manejo de Cuenta, debido a que se detecto que la tabla de
		-- Ahorro no tiene actualizada de manera correcta se manejo de esta manera, en cuanto se corrija se debe eliminar este Query
		-- Y Tomarlo directo de la tabla de HIS-CUENTASAHO
		UPDATE EDOCTAV2HEADERCTA Edo
			INNER JOIN TMP_CTACOMMANEJOCTA Com ON Edo.CuentaAhoID = Com.CuentaAhoID
			SET Edo.MontoComision = IFNULL(Edo.MontoComision, Entero_Cero) + IFNULL(Com.ComManejoCta, Entero_Cero),
				Edo.IvaComision = IFNULL(Edo.IvaComision, Entero_Cero) + IFNULL(Com.IvaComManejoCta, Entero_Cero);

		SET Par_NumErr	:= Entero_Cero;
			SET Par_ErrMen	:= CONCAT('Generacion de los Header de Ahorro con Exito, con Folio: ', CAST(Var_FolioProceso AS CHAR));
			SET Var_Control	:= 'FolioEDOCTA';

END ManejoErrores;

	IF (Par_Salida = Constante_Si) THEN
		SELECT	Par_NumErr			AS NumErr,
				Par_ErrMen			AS ErrMen,
				Var_FolioProceso	AS control;
	END IF;

END TerminaStore$$
