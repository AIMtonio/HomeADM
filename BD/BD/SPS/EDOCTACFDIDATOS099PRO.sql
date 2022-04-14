-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTACFDIDATOS099PRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTACFDIDATOS099PRO`;
DELIMITER $$


CREATE PROCEDURE `EDOCTACFDIDATOS099PRO`(
	-- SP que recolecta informacion para generar cadenas de timbrado
	Par_AnioMes					INT(11),			-- Periodo del proceso
	Par_SucursalID 				INT(11),			-- Identificador de la sucursal
	Par_FecIniMes				DATE,				-- Fecha de inicio del periodo
	Par_FecFinMes				DATE,				-- Fecha de fin de periodo
	Par_ClienteInstitu			INT(11)				-- Cliente Institucion
	)

TerminaStore: BEGIN
	-- Declaracion de Constantes
	DECLARE Con_Cadena_Vacia	VARCHAR(1);
	DECLARE Con_Fecha_Vacia		DATE;
	DECLARE Con_Entero_Cero		INT(11);
	DECLARE Con_Moneda_Cero		DECIMAL(14,2);
	DECLARE Con_SI				CHAR(1);

	DECLARE Con_NO				CHAR(1);
	DECLARE EstatusVigente		CHAR(1);
	DECLARE EstatusVencido		CHAR(1);
	DECLARE EstatusCastigado	CHAR(1);
	DECLARE EstatusPagado		CHAR(1);

	DECLARE ClasMovComision		INT(11);
	DECLARE ClasMovIVACom		INT(11);
	DECLARE TipoInstrumCredito	CHAR(1);
	DECLARE TipoInstrumCueAho	CHAR(1);
	DECLARE NaturalezaCargo		CHAR(1);

	DECLARE NaturalezaAbono		CHAR(1);
	DECLARE TipoInstSOFOM		INT(11);

	-- Declaracion de Variables
	DECLARE Var_TipoInstitID	INT(11);

	-- Asignacion de Constantes
	SET Con_Cadena_Vacia		:= '';				-- Cadena vacia
	SET Con_Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia
	SET Con_Entero_Cero			:= 0;				-- Entero cero
	SET Con_Moneda_Cero			:= 0.00;			-- Moneda cero
	SET Con_SI					:= 'S';				-- Constante: SI

	SET Con_NO					:= 'N';				-- Constante: NO
	SET EstatusVigente			:= 'V';				-- Estatus Credito: VIGENTE
	SET EstatusVencido			:= 'B';				-- Estatus Credito: VENCIDO
	SET EstatusCastigado 		:= 'K';				-- Estatus Credito: CASTIGADO
	SET EstatusPagado 			:= 'P';				-- Estatus Credito: PAGADO

	SET ClasMovComision			:= 2;				-- Clasificacion Movimiento: Comision
	SET ClasMovIVACom			:= 3;				-- Clasificacion Movimiento: IVA Comision
	SET TipoInstrumCredito		:= 'C';				-- Tipo de instrumento: Credito
	SET TipoInstrumCueAho		:= 'A';				-- Tipo de instrumento: Cuentas de Ahorro
	SET NaturalezaCargo			:= 'C';				-- Naturaleza Movimiento: Cargo

	SET NaturalezaAbono			:= 'A';				-- Naturaleza Movimiento: Abono
	SET TipoInstSOFOM			:= 4;				-- Tipo Institucion: 4 (SOFOM) TIPOSINSTITUCION

	-- Se obtiene el tipo de institucion
	SELECT Ins.TipoInstitID INTO Var_TipoInstitID
	FROM INSTITUCIONES Ins
	JOIN PARAMETROSSIS Par ON Par.InstitucionID = Ins.InstitucionID;

	IF (Var_TipoInstitID = TipoInstSOFOM) THEN
		-- Tabla temporal para registrar los movimientos de las comisiones de las cuentas
		DROP TEMPORARY TABLE IF EXISTS TMP_COMFALTAPAGOCREDITOS;
		CREATE TEMPORARY TABLE TMP_COMFALTAPAGOCREDITOS(
			ClienteID		INT(11),
			CuentaAhoID		BIGINT(12),
			Movs_Comision	DECIMAL(14,2),
			INDEX INDEX_TMP_COMFALTAPAGOCREDITOS_1 (CuentaAhoID));

		-- Se obtiene los movimientos de las comisiones de las cuentas
		INSERT INTO TMP_COMFALTAPAGOCREDITOS(
				ClienteID,			CuentaAhoID,		Movs_Comision)
		SELECT	CUE.ClienteID,		HIS.CuentaAhoID,	HIS.CantidadMov
		FROM `HIS-CUENAHOMOV` HIS
		INNER JOIN CUENTASAHO CUE
		WHERE HIS.CuentaAhoID = CUE.CuentaAhoID
		  AND ClienteID <> Par_ClienteInstitu
		  AND TipoMovAhoID IN (	202, 203, 204, 205, 206, 207, 208, 209, 21, 22,
								210, 211, 212, 213, 214,215,216,217,218,219,
								220, 221, 225, 226, 402, 403,81,82,83,84,86,88)
		  AND Fecha >= Par_FecIniMes
		  AND Fecha <= Par_FecFinMes
		  AND NatMovimiento = NaturalezaCargo;

		INSERT INTO EDOCTACFDIDATOS(
			AnioMes,				SucursalID,				ClienteID,			InstrumentoID,		TipoInstrumento,
			Concepto,				Monto,					ValorIVA,			EmpresaID,			Usuario,
			FechaActual,			DireccionIP,			ProgramaID,			Sucursal,			NumTransaccion)
		SELECT
			Par_AnioMes,			Par_SucursalID,			ClienteID,			CuentaAhoID,		TipoInstrumCueAho,
			'MOVIMIENTOS DE COMISIONES',
			IFNULL(SUM(Movs_Comision), Con_Moneda_Cero),
			Con_Moneda_Cero,		Con_Entero_Cero,		Con_Entero_Cero,	Con_Fecha_Vacia,	Con_Cadena_Vacia,
			Con_Cadena_Vacia,		Con_Entero_Cero,		Con_Entero_Cero
		FROM TMP_COMFALTAPAGOCREDITOS
		GROUP BY ClienteID, CuentaAhoID;
	END IF;

	DROP TABLE IF EXISTS TMP_EDOCTADETALLEPAGCRE;
	CREATE TABLE `TMP_EDOCTADETALLEPAGCRE` (
		`ClienteID`			INT(11)				NOT NULL		COMMENT 'Id del Credito',
		`CreditoID`			BIGINT(12)			NOT NULL		COMMENT 'Id del Credito',
		`MontoIntOrd`		DECIMAL(18,2)		DEFAULT NULL	COMMENT 'Monto Aplicado Interes Ordinario',
		`MontoIntAtr`		DECIMAL(18,2)		DEFAULT NULL	COMMENT 'Monto Aplicado Interes Atrasado',
		`MontoIntVen`		DECIMAL(18,2)		DEFAULT NULL	COMMENT 'Monto Aplicado Interes Vencido',

		`MontoIntMora`		DECIMAL(18,2)		DEFAULT NULL	COMMENT 'Monto Aplicado Interes Mora',
		`MontoComision`		DECIMAL(18,2)		DEFAULT NULL	COMMENT 'Monto Aplicado Comisiones',
		`MontoGastoAdmon`	DECIMAL(18,2)		DEFAULT NULL	COMMENT 'Monto Aplicado Gastos Administrativos',
		`MontoNotasCargo`	DECIMAL(14,2)		DEFAULT 0.00	COMMENT 'Monto pagado por Notas de Cargo',
		`MontoIVANotasCargo` DECIMAL(14,2)		DEFAULT 0.00	COMMENT 'Monto de IVA pagado por Notas de Cargo',
		PRIMARY KEY (`CreditoID`)
	) ;

	INSERT INTO TMP_EDOCTADETALLEPAGCRE
	SELECT	DET.ClienteID
			,DET.CreditoID
			,SUM(MontoIntOrd) AS MontoIntOrd
			,SUM(MontoIntAtr) AS MontoIntAtr
			,SUM(MontoIntVen) AS MontoIntVen
			,SUM(MontoIntMora) AS MontoIntMora
			,SUM(MontoComision) AS MontoComision
			,SUM(MontoGastoAdmon) AS MontoGastoAdmon,
			SUM(MontoNotasCargo) AS MontoNotasCargo,
			SUM(MontoIVANotasCargo) AS MontoIVANotasCargo
	FROM DETALLEPAGCRE DET
    JOIN CREDITOS CRE ON CRE.CreditoID = DET.CreditoID
	WHERE DET.FechaPago >= Par_FecIniMes
	AND DET.FechaPago <=  Par_FecFinMes
    AND (Estatus IN (EstatusVigente, EstatusVencido, EstatusCastigado)
	   OR (Estatus = EstatusPagado
			AND  FechTerminacion >= Par_FecIniMes
			AND  FechTerminacion <= Par_FecFinMes))
	GROUP BY DET.CreditoID, DET.ClienteID;

	INSERT INTO EDOCTACFDIDATOS(
			AnioMes,				SucursalID,				ClienteID,			InstrumentoID,		TipoInstrumento,
			Concepto,				Monto,					ValorIVA,			EmpresaID,			Usuario,
			FechaActual,			DireccionIP,			ProgramaID,			Sucursal,			NumTransaccion)
	SELECT	Par_AnioMes,			Par_SucursalID,			ClienteID,			CreditoID,			TipoInstrumCredito,
			'INTERES DE CREDITO',
			ROUND((MontoIntOrd + MontoIntAtr + MontoIntVen), 2),
			Con_Moneda_Cero,		Con_Entero_Cero,		Con_Entero_Cero,	Con_Fecha_Vacia,	Con_Cadena_Vacia,
			Con_Cadena_Vacia,		Con_Entero_Cero,		Con_Entero_Cero
	FROM TMP_EDOCTADETALLEPAGCRE;

	INSERT INTO EDOCTACFDIDATOS(
			AnioMes,				SucursalID,				ClienteID,			InstrumentoID,		TipoInstrumento,
			Concepto,				Monto,					ValorIVA,			EmpresaID,			Usuario,
			FechaActual,			DireccionIP,			ProgramaID,			Sucursal,			NumTransaccion)
	SELECT	Par_AnioMes,			Par_SucursalID,			ClienteID,			CreditoID,			TipoInstrumCredito,
			'INTERES MORATORIO',
			ROUND(MontoIntMora, 2),
			Con_Moneda_Cero,		Con_Entero_Cero,		Con_Entero_Cero,	Con_Fecha_Vacia,	Con_Cadena_Vacia,
			Con_Cadena_Vacia,		Con_Entero_Cero,		Con_Entero_Cero
	FROM TMP_EDOCTADETALLEPAGCRE;

	-- Tabla temporal para registrar las Comisiones por Falta de Pago efectuados por el cliente
	DROP TEMPORARY TABLE IF EXISTS TMP_COMFALTAPAGOCREDITOS;
	CREATE TEMPORARY TABLE TMP_COMFALTAPAGOCREDITOS(
		ClienteID		INT(11),
		CreditoID		BIGINT(12),
		Comisiones		DECIMAL(14,2),
		PRIMARY KEY (CreditoID));

	INSERT INTO TMP_COMFALTAPAGOCREDITOS(
			ClienteID,				CreditoID,				Comisiones)
	SELECT	Cre.ClienteID,			Mov.CreditoID,			ROUND(SUM(Cantidad), 2)
	FROM CREDITOSMOVS Mov
	INNER JOIN CREDITOS Cre ON Cre.CreditoID = Mov.CreditoID
	WHERE FechaOperacion >= Par_FecIniMes
	  AND FechaOperacion <= Par_FecFinMes
	  AND TipoMovCreID IN  (40)
	  AND NatMovimiento = NaturalezaAbono
	  AND (Descripcion = 'PAGO DE CREDITO' OR Descripcion = 'BONIFICACION' OR Descripcion LIKE '%CONDONACION%')
	GROUP BY Mov.CreditoID, Cre.ClienteID;

	INSERT INTO EDOCTACFDIDATOS(
			AnioMes,				SucursalID,				ClienteID,			InstrumentoID,		TipoInstrumento,
			Concepto,				Monto,					ValorIVA,			EmpresaID,			Usuario,
			FechaActual,			DireccionIP,			ProgramaID,			Sucursal,			NumTransaccion)
	SELECT	Par_AnioMes,			Par_SucursalID,			ClienteID,			CreditoID,			TipoInstrumCredito,
			'COMISION FALTA DE PAGO',
			ROUND((Comisiones), 2),
			Con_Moneda_Cero,		Con_Entero_Cero,		Con_Entero_Cero,	Con_Fecha_Vacia,	Con_Cadena_Vacia,
			Con_Cadena_Vacia,		Con_Entero_Cero,		Con_Entero_Cero
	FROM TMP_COMFALTAPAGOCREDITOS;

	INSERT INTO EDOCTACFDIDATOS(
			AnioMes,				SucursalID,				ClienteID,			InstrumentoID,		TipoInstrumento,
			Concepto,				Monto,					ValorIVA,			EmpresaID,			Usuario,
			FechaActual,			DireccionIP,			ProgramaID,			Sucursal,			NumTransaccion)
	SELECT	Par_AnioMes,			Par_SucursalID,			ClienteID,			CreditoID,			TipoInstrumCredito,
			'OTRAS COMISIONES DE CREDITO',
			ROUND((MontoComision+MontoGastoAdmon+MontoNotasCargo), 2),
			Con_Moneda_Cero,		Con_Entero_Cero,		Con_Entero_Cero,	Con_Fecha_Vacia,	Con_Cadena_Vacia,
			Con_Cadena_Vacia,		Con_Entero_Cero,		Con_Entero_Cero
	FROM TMP_EDOCTADETALLEPAGCRE;

	UPDATE	EDOCTACFDIDATOS Edo,
			TMP_COMFALTAPAGOCREDITOS Tmp
	SET Edo.Monto = Edo.Monto-Tmp.Comisiones
	WHERE Edo.InstrumentoID = Tmp.CreditoID
	  AND Edo.ClienteID = Tmp.ClienteID
	  AND Edo.TipoInstrumento = TipoInstrumCredito
	  AND Edo.Concepto = 'OTRAS COMISIONES DE CREDITO';

	UPDATE EDOCTACFDIDATOS Edo, CREDITOS Cre, PRODUCTOSCREDITO Prod, CLIENTES Cli, SUCURSALES Suc
	SET Edo.ValorIVA = CASE WHEN Prod.CobraIVAInteres = Con_SI AND Cli.PagaIVA = Con_SI THEN IFNULL(Suc.IVA, Con_Moneda_Cero)
							   WHEN Prod.CobraIVAInteres = Con_SI AND Cli.PagaIVA = Con_NO THEN Con_Moneda_Cero
							   WHEN Prod.CobraIVAInteres = Con_NO AND Cli.PagaIVA = Con_SI THEN Con_Moneda_Cero
							   WHEN Prod.CobraIVAInteres = Con_NO AND Cli.PagaIVA = Con_NO THEN Con_Moneda_Cero
																					 ELSE Con_Moneda_Cero
						   END
	WHERE Edo.InstrumentoID = Cre.CreditoID
	  AND Prod.ProducCreditoID = Cre.ProductoCreditoID
	  AND Edo.ClienteID = Cli.ClienteID
	  AND Cli.SucursalOrigen = Suc.SucursalID
	  AND Edo.TipoInstrumento = TipoInstrumCredito
	  AND Edo.Concepto = 'INTERES DE CREDITO';

	UPDATE EDOCTACFDIDATOS Edo, CREDITOS Cre, PRODUCTOSCREDITO Prod, CLIENTES Cli, SUCURSALES Suc
	SET Edo.ValorIVA = CASE WHEN Prod.CobraIVAInteres = Con_SI AND Cli.PagaIVA = Con_SI THEN IFNULL(Suc.IVA, Con_Moneda_Cero)
							   WHEN Prod.CobraIVAInteres = Con_SI AND Cli.PagaIVA = Con_NO THEN Con_Moneda_Cero
							   WHEN Prod.CobraIVAInteres = Con_NO AND Cli.PagaIVA = Con_SI THEN Con_Moneda_Cero
							   WHEN Prod.CobraIVAInteres = Con_NO AND Cli.PagaIVA = Con_NO THEN Con_Moneda_Cero
																					 ELSE Con_Moneda_Cero
						   END
	WHERE Edo.InstrumentoID = Cre.CreditoID
	  AND Prod.ProducCreditoID = Cre.ProductoCreditoID
	  AND Edo.ClienteID = Cli.ClienteID
	  AND Cli.SucursalOrigen = Suc.SucursalID
	  AND Edo.TipoInstrumento = TipoInstrumCredito
	  AND Edo.Concepto = 'INTERES MORATORIO';

	UPDATE EDOCTACFDIDATOS Edo, CREDITOS Cre, PRODUCTOSCREDITO Prod, CLIENTES Cli, SUCURSALES Suc
	SET Edo.ValorIVA = CASE WHEN Cli.PagaIVA = Con_SI THEN IFNULL(Suc.IVA, Con_Moneda_Cero)
															 ELSE Con_Moneda_Cero
								 END
	WHERE Edo.InstrumentoID = Cre.CreditoID
	  AND Prod.ProducCreditoID = Cre.ProductoCreditoID
	  AND Edo.ClienteID = Cli.ClienteID
	  AND Cli.SucursalOrigen = Suc.SucursalID
	  AND Edo.TipoInstrumento = TipoInstrumCredito
	  AND Edo.Concepto = 'COMISION FALTA DE PAGO';

	IF (Var_TipoInstitID <> TipoInstSOFOM) THEN
		-- Se obtiene el monto de la comision realizados en el periodo
		INSERT INTO EDOCTACFDIDATOS(
				AnioMes,				SucursalID,				ClienteID,			InstrumentoID,		TipoInstrumento,
				Concepto,				Monto,					ValorIVA,			EmpresaID,			Usuario,
				FechaActual,			DireccionIP,			ProgramaID,			Sucursal,			NumTransaccion)
		SELECT	Par_AnioMes,			Par_SucursalID,			Edo.ClienteID,		Cue.CuentaAhoID,	TipoInstrumCueAho,
				'OTRAS COMISIONES DE CREDITO',
				SUM(CASE WHEN  Mov.NatMovimiento = NaturalezaCargo THEN Mov.CantidadMov ELSE Con_Moneda_Cero END)  -
				SUM(CASE WHEN Mov.NatMovimiento = NaturalezaAbono THEN Mov.CantidadMov ELSE Con_Moneda_Cero END),
				Con_Moneda_Cero,		Con_Entero_Cero,		Con_Entero_Cero,	Con_Fecha_Vacia,	Con_Cadena_Vacia,
				Con_Cadena_Vacia,		Con_Entero_Cero,		Con_Entero_Cero
		FROM `HIS-CUENAHOMOV` Mov, CUENTASAHO Cue, TIPOSMOVSAHO Tip, EDOCTADATOSCTE Edo
		WHERE Mov.CuentaAhoID = Cue.CuentaAhoID
		  AND Mov.TipoMovAhoID = Tip.TipoMovAhoID
		  AND Cue.ClienteID = Edo.ClienteID
		  AND Edo.AnioMes = Par_AnioMes
		  AND Mov.Fecha >= Par_FecIniMes AND Mov.Fecha <= Par_FecFinMes
		  AND Tip.ClasificacionMov = 2
		  AND Mov.DescripcionMov LIKE 'COMISION%'
		GROUP BY Mov.CuentaAhoID, Edo.ClienteID;

		-- Se obtiene el monto del iva de la comision realizados en el periodo
		-- Tabla temporal para registrar el iva de la comision realizados en el periodo
		DROP TEMPORARY TABLE IF EXISTS TMP_IVACOMISIONESCUENAHO;
		CREATE TEMPORARY TABLE TMP_IVACOMISIONESCUENAHO(
			ClienteID		INT(11),
			CuentaAhoID		BIGINT(12),
			IvaComision		DECIMAL(14,2),
			PRIMARY KEY (CuentaAhoID));

		INSERT INTO TMP_IVACOMISIONESCUENAHO(ClienteID, CuentaAhoID, IvaComision)
		SELECT	Edo.ClienteID,			Mov.CuentaAhoID,
				SUM(CASE WHEN  Mov.NatMovimiento = NaturalezaCargo THEN Mov.CantidadMov ELSE Con_Moneda_Cero END)  -
				SUM(CASE WHEN Mov.NatMovimiento = NaturalezaAbono THEN Mov.CantidadMov ELSE Con_Moneda_Cero END)
		FROM `HIS-CUENAHOMOV` Mov, CUENTASAHO Cue, TIPOSMOVSAHO Tip, EDOCTADATOSCTE Edo
		WHERE Mov.CuentaAhoID = Cue.CuentaAhoID
		  AND Mov.TipoMovAhoID = Tip.TipoMovAhoID
		  AND Cue.ClienteID = Edo.ClienteID
		  AND Edo.AnioMes = Par_AnioMes
		  AND Mov.Fecha >= Par_FecIniMes AND Mov.Fecha <= Par_FecFinMes
		  AND Tip.ClasificacionMov = 3
		  AND (Mov.DescripcionMov LIKE 'IVA COMISION%' OR Mov.DescripcionMov LIKE 'Iva Comision%')
		GROUP BY Mov.CuentaAhoID, Edo.ClienteID;

		UPDATE	EDOCTACFDIDATOS Edo,
				TMP_IVACOMISIONESCUENAHO Tmp
		SET Edo.ValorIVA = Tmp.IvaComision
		WHERE Edo.InstrumentoID = Tmp.CuentaAhoID
		  AND Edo.ClienteID = Tmp.ClienteID
		  AND Edo.TipoInstrumento = TipoInstrumCueAho
		  AND Edo.Concepto = 'OTRAS COMISIONES DE CREDITO';
	END IF;

	-- Se obtiene el Monto del ISR de las Cuentas e Inversiones periodo
	INSERT INTO EDOCTACFDIDATOS(
			AnioMes,				SucursalID,				ClienteID,			InstrumentoID,		TipoInstrumento,
			Concepto,				Monto,					ValorIVA,			EmpresaID,			Usuario,
			FechaActual,			DireccionIP,			ProgramaID,			Sucursal,			NumTransaccion)
	SELECT	Par_AnioMes,			Par_SucursalID,			Edo.ClienteID,		Cue.CuentaAhoID,	TipoInstrumCueAho,
			'IMPUESTO ISR',
			SUM(CASE WHEN  Mov.NatMovimiento = NaturalezaCargo THEN Mov.CantidadMov ELSE Con_Moneda_Cero END),
			Con_Moneda_Cero,		Con_Entero_Cero,		Con_Entero_Cero,	Con_Fecha_Vacia,	Con_Cadena_Vacia,
			Con_Cadena_Vacia,		Con_Entero_Cero,		Con_Entero_Cero
	FROM `HIS-CUENAHOMOV` Mov, CUENTASAHO Cue, TIPOSMOVSAHO Tip, EDOCTADATOSCTE Edo
	WHERE Mov.CuentaAhoID = Cue.CuentaAhoID
	  AND Mov.TipoMovAhoID = Tip.TipoMovAhoID
	  AND Cue.ClienteID = Edo.ClienteID
	  AND Edo.AnioMes = Par_AnioMes
	  AND Mov.Fecha >= Par_FecIniMes AND Mov.Fecha <= Par_FecFinMes
	  AND Tip.Descripcion LIKE 'RETENCION ISR%'
	GROUP BY Mov.CuentaAhoID, Edo.ClienteID;

	INSERT INTO EDOCTACFDIDATOS(
			AnioMes,				SucursalID,				ClienteID,			InstrumentoID,		TipoInstrumento,
			Concepto,				Monto,					ValorIVA,			EmpresaID,			Usuario,
			FechaActual,			DireccionIP,			ProgramaID,			Sucursal,			NumTransaccion)
	SELECT	Par_AnioMes,			Par_SucursalID,			Edo.ClienteID,		Cue.CuentaAhoID,	TipoInstrumCueAho,
			'INVERSIONES',
			SUM(CASE WHEN Mov.NatMovimiento = NaturalezaAbono THEN Mov.CantidadMov ELSE Con_Moneda_Cero END),
			Con_Moneda_Cero,		Con_Entero_Cero,		Con_Entero_Cero,	Con_Fecha_Vacia,	Con_Cadena_Vacia,
			Con_Cadena_Vacia,		Con_Entero_Cero,		Con_Entero_Cero
	FROM `HIS-CUENAHOMOV` Mov, CUENTASAHO Cue, TIPOSMOVSAHO Tip, EDOCTADATOSCTE Edo
	WHERE Mov.CuentaAhoID = Cue.CuentaAhoID
	  AND Mov.TipoMovAhoID = Tip.TipoMovAhoID
	  AND Cue.ClienteID = Edo.ClienteID
	  AND Edo.AnioMes = Par_AnioMes
	  AND Mov.Fecha >= Par_FecIniMes AND Mov.Fecha <= Par_FecFinMes
	  AND Mov.TipoMovAhoID IN (62,63,200,201)
	GROUP BY Mov.CuentaAhoID, Edo.ClienteID;

	DROP TABLE IF EXISTS TMP_EDOCTADETALLEPAGCRE;
	DROP TEMPORARY TABLE IF EXISTS TMP_COMFALTAPAGOCREDITOS;
	DROP TEMPORARY TABLE IF EXISTS TMP_IVACOMISIONESCUENAHO;
END TerminaStore$$
