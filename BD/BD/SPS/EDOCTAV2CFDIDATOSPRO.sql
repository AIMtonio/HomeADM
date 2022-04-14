-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAV2CFDIDATOS099PRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAV2CFDIDATOSPRO`;
DELIMITER $$

CREATE PROCEDURE `EDOCTAV2CFDIDATOSPRO`(
	-- SP que recolecta informacion para generar cadenas de timbrado
	Par_Salida                CHAR(1),		-- Parametro de salida
	INOUT Par_NumErr          INT(11),  		-- Numero de error
	INOUT Par_ErrMen          VARCHAR(400),	-- Mensaje de error

	-- Parametros de Auditoria
	Par_EmpresaID				INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario					INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP				VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
	)

TerminaStore: BEGIN
	-- Declaracion de Constantes
	DECLARE Con_Cadena_Vacia		VARCHAR(1);
	DECLARE Con_Fecha_Vacia			DATE;
	DECLARE Con_Entero_Cero			INT(11);
	DECLARE Con_Moneda_Cero			DECIMAL(14,2);
	DECLARE Con_SI					CHAR(1);
	DECLARE Con_NO					CHAR(1);
	DECLARE EstatusVigente			CHAR(1);
	DECLARE EstatusVencido			CHAR(1);
	DECLARE EstatusCastigado		CHAR(1);
	DECLARE EstatusPagado			CHAR(1);
	DECLARE EstatusEliminado		CHAR(1);
	DECLARE ClasMovComision			INT(11);
	DECLARE ClasMovIVACom			INT(11);
	DECLARE TipoInstrumCredito		CHAR(1);
	DECLARE TipoInstrumCueAho		CHAR(1);
	DECLARE NaturalezaCargo			CHAR(1);
	DECLARE NaturalezaAbono			CHAR(1);
	DECLARE TipoInstSOFOM			INT(11);

	-- Declaracion de Variables
	DECLARE Var_TipoInstitID		INT(11);
	DECLARE Var_AnioMes				INT(11);			-- Periodo del proceso
	DECLARE Var_FecIniMes			DATE;				-- Fecha de inicio del periodo
	DECLARE Var_FecFinMes			DATE;				-- Fecha de fin de periodo
	DECLARE Var_FolioProceso		BIGINT(20);					-- Folio de procesamiento
	DECLARE Var_MesProceso			INT;
	-- 1=INTERES DE CREDITO, 2=IVA INTERES DE CREDITO, 3=INTERES MORATORIO, 4=IVA INTERES MORATORIO, 5= COMISIONES, 6=IVA COMISIONES, 7=OTRAS COMISIONES, 8=IVA OTRAS COMISIONES',
	DECLARE VAR_INTERESCREDITO		INT(2);
	DECLARE VAR_IVAINTERESCREDITO	INT(2);
	DECLARE VAR_INTERESMORA			INT(2);
	DECLARE VAR_IVAINTERESMORA		INT(2);
	DECLARE VAR_COMISIONES			INT(2);
	DECLARE VAR_IVACOMISIONES		INT(2);
	DECLARE VAR_OTRASCOMISI			INT(2);
	DECLARE VAR_IVAOTRASCOMISI		INT(2);

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
	SET EstatusEliminado		:= 'E';				-- Estatus Credito: ELIMINADO
	SET ClasMovComision			:= 2;				-- Clasificacion Movimiento: Comision
	SET ClasMovIVACom			:= 3;				-- Clasificacion Movimiento: IVA Comision
	SET TipoInstrumCredito		:= 'C';				-- Tipo de instrumento: Credito
	SET TipoInstrumCueAho		:= 'A';				-- Tipo de instrumento: Cuentas de Ahorro
	SET NaturalezaCargo			:= 'C';				-- Naturaleza Movimiento: Cargo
	SET NaturalezaAbono			:= 'A';				-- Naturaleza Movimiento: Abono
	SET TipoInstSOFOM			:= 4;				-- Tipo Institucion: 4 (SOFOM) TIPOSINSTITUCION
	SET VAR_INTERESCREDITO		:= 1;
	SET VAR_IVAINTERESCREDITO	:= 2;
	SET VAR_INTERESMORA			:= 3;
	SET VAR_IVAINTERESMORA		:= 4;
	SET VAR_COMISIONES			:= 5;
	SET VAR_IVACOMISIONES		:= 6;
	SET VAR_OTRASCOMISI			:= 7;
	SET VAR_IVAOTRASCOMISI		:= 8;

	ManejoErrores: BEGIN
		-- Se obtiene el periodo que se esta procesando, de la tabla de EDOCTAV2PARAMS
		SELECT
			MesProceso,		FechaInicio,	FechaFin, 		FolioProceso
		INTO
			Var_MesProceso,	Var_FecIniMes,	Var_FecFinMes,	Var_FolioProceso
		FROM EDOCTAV2PARAMS limit 1;
		SET Var_MesProceso := IFNULL(Var_MesProceso,Con_Entero_Cero);
		IF (Var_MesProceso = Con_Entero_Cero) THEN
		SET Par_NumErr      := '1';
			SET Par_ErrMen    := 'Especifique el periodo a procesar[EDOCTAV2PARAMS-MesProceso]';

			LEAVE ManejoErrores;
		END IF;
		SET Var_AnioMes = Var_MesProceso ;

		INSERT INTO EDOCTAV2TIMBRADOINGRE
		(AnioMes,			ClienteID,		SucursalID,			CadenaCFDI,			CFDIFechaEmision,
		CFDIVersion,		CFDINoCertSat,	CFDIUUID,			CFDIFechaTimbrado,	CFDISelloCFD,
		CFDISelloSAT,		CFDICadenaOrig,	DiasPeriodo,		CFDIFechaCertifica,	CFDINoCertEmision,
		CFDILugExpedicion,	CFDITotal,		EstatusTimbrado,	FolioProceso,		CodigoQR,
		EmpresaID,			Usuario,		FechaActual,		DireccionIP,		ProgramaID,
		Sucursal 			,NumTransaccion)

		SELECT
		AnioMes,			ClienteID,			SucursalID,			Con_Cadena_Vacia,	Con_Fecha_Vacia,
		Con_Cadena_Vacia,	Con_Cadena_Vacia,	Con_Cadena_Vacia,	Con_Fecha_Vacia,		Con_Cadena_Vacia,
		Con_Cadena_Vacia,	Con_Cadena_Vacia,	Con_Entero_Cero,		Con_Fecha_Vacia,		Con_Cadena_Vacia,
		Con_Cadena_Vacia,	Con_Entero_Cero,		1,					Var_FolioProceso,	Con_Cadena_Vacia,
		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
		Aud_Sucursal,		Aud_NumTransaccion
		FROM EDOCTAV2DATOSCTE
		WHERE FolioProceso	= Var_FolioProceso;

		-- Se obtiene el tipo de institucion
		SELECT Ins.TipoInstitID INTO Var_TipoInstitID
		FROM INSTITUCIONES Ins
		JOIN PARAMETROSSIS Par ON Par.InstitucionID = Ins.InstitucionID;

		-- Se obtiene la ultima fecha corte registrada en los saldos de credito en el rango de fechas de corte para cada uno de los creditos
		DROP TEMPORARY TABLE IF EXISTS TMPEDOCTAV2FECHACORTE;
		CREATE TEMPORARY TABLE TMPEDOCTAV2FECHACORTE
		SELECT	CreditoID, MAX(FechaCorte) AS FechaCorte
		FROM SALDOSCREDITOS
		WHERE FechaCorte >= Var_FecIniMes
		AND FechaCorte <= Var_FecFinMes
		GROUP BY CreditoID;

		CREATE INDEX IDX_TMPEDOCTAV2FECHACORTE_1 ON TMPEDOCTAV2FECHACORTE(CreditoID, FechaCorte);

		-- Se genera una copia de SALDOSCREDITOS solo con el ultimo registro de cada credito
		DROP TEMPORARY TABLE IF EXISTS TMPEDOCTAV2SALDOSCREDITO;

		CREATE TEMPORARY TABLE TMPEDOCTAV2SALDOSCREDITO
		SELECT Sal.*
		FROM TMPEDOCTAV2FECHACORTE Tmp
		INNER JOIN SALDOSCREDITOS Sal ON Tmp.CreditoID = Sal.CreditoID AND Tmp.FechaCorte = Sal.FechaCorte;

		CREATE INDEX IDX_TMPEDOCTAV2SALDOSCREDITO_01_Cred ON TMPEDOCTAV2SALDOSCREDITO(CreditoID);
		CREATE INDEX IDX_TMPEDOCTAV2SALDOSCREDITO_02_Cli  ON TMPEDOCTAV2SALDOSCREDITO(ClienteID);
		DROP TEMPORARY TABLE IF EXISTS TMPEDOCTAV2FECHACORTE;

		INSERT INTO EDOCTAV2CFDIDATOS(
				AnioMes,				SucursalID,					ClienteID,			InstrumentoID,		TipoInstrumento,
				Concepto,				Monto,						ValorIVA,			EmpresaID,			Usuario,
				FechaActual,			DireccionIP,				ProgramaID,			Sucursal,			NumTransaccion,
				TipoConcepto)

		SELECT	Var_AnioMes,			Con_Entero_Cero,			tmp.ClienteID,			tmp.CreditoID,			TipoInstrumCredito,
				'INTERES DE CREDITO',	ROUND(PagoIntOrdMes, 2),	Con_Moneda_Cero,	Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion,
				VAR_INTERESCREDITO
		FROM TMPEDOCTAV2SALDOSCREDITO AS tmp
		INNER JOIN EDOCTAV2RESUMCREDITOS AS edo ON tmp.CreditoID = edo.CreditoID
		WHERE EstatusCredito IN (EstatusVigente, EstatusVencido, EstatusPagado);

		INSERT INTO EDOCTAV2CFDIDATOS(
				AnioMes,					SucursalID,					ClienteID,			InstrumentoID,		TipoInstrumento,
				Concepto,					Monto,						ValorIVA,			EmpresaID,			Usuario,
				FechaActual,				DireccionIP,				ProgramaID,			Sucursal,			NumTransaccion,
				TipoConcepto)

		SELECT	Var_AnioMes,				Con_Entero_Cero,			tmp.ClienteID,			tmp.CreditoID,			TipoInstrumCredito,
				'IVA INTERES DE CREDITO',	ROUND(tmp.PagoIVAIntOrdMes, 2),	Con_Moneda_Cero,	Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,			Aud_DireccionIP,			Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion,
				VAR_IVAINTERESCREDITO
		FROM TMPEDOCTAV2SALDOSCREDITO AS tmp
		INNER JOIN EDOCTAV2RESUMCREDITOS AS edo ON tmp.CreditoID = edo.CreditoID
		WHERE EstatusCredito IN (EstatusVigente, EstatusVencido, EstatusPagado);

		INSERT INTO EDOCTAV2CFDIDATOS(
				AnioMes,				SucursalID,				ClienteID,			InstrumentoID,		TipoInstrumento,
				Concepto,				Monto,					ValorIVA,			EmpresaID,			Usuario,
				FechaActual,			DireccionIP,			ProgramaID,			Sucursal,			NumTransaccion,
				TipoConcepto)
		SELECT	Var_AnioMes,			Con_Entero_Cero,		tmp.ClienteID,			tmp.CreditoID,			TipoInstrumCredito,
				'INTERES MORATORIO',	ROUND(tmp.PagoMoraMes, 2),	Con_Moneda_Cero,	Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion,
				VAR_INTERESMORA
		FROM TMPEDOCTAV2SALDOSCREDITO AS tmp
		INNER JOIN EDOCTAV2RESUMCREDITOS AS edo ON tmp.CreditoID = edo.CreditoID
		WHERE EstatusCredito IN (EstatusVigente, EstatusVencido, EstatusPagado);

		INSERT INTO EDOCTAV2CFDIDATOS(
				AnioMes,					SucursalID,					ClienteID,			InstrumentoID,		TipoInstrumento,
				Concepto,					Monto,						ValorIVA,			EmpresaID,			Usuario,
				FechaActual,				DireccionIP,				ProgramaID,			Sucursal,			NumTransaccion,
				TipoConcepto)
		SELECT	Var_AnioMes,				Con_Entero_Cero,			tmp.ClienteID,			tmp.CreditoID,			TipoInstrumCredito,
				'IVA INTERES MORATORIO',	ROUND(PagoIVAMoraMes, 2),	Con_Moneda_Cero,	Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,			Aud_DireccionIP,			Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion,
				VAR_IVAINTERESMORA
		FROM TMPEDOCTAV2SALDOSCREDITO AS tmp
		INNER JOIN EDOCTAV2RESUMCREDITOS AS edo ON tmp.CreditoID = edo.CreditoID
		WHERE EstatusCredito IN (EstatusVigente, EstatusVencido, EstatusPagado);

		INSERT INTO EDOCTAV2CFDIDATOS(
				AnioMes,				SucursalID,				ClienteID,			InstrumentoID,		TipoInstrumento,
				Concepto,				Monto,					ValorIVA,			EmpresaID,			Usuario,
				FechaActual,			DireccionIP,			ProgramaID,			Sucursal,			NumTransaccion,
				TipoConcepto)
		SELECT	Var_AnioMes,			Con_Entero_Cero,			tmp.ClienteID,			tmp.CreditoID,			TipoInstrumCredito,
				'COMISIONES',			ROUND(tmp.PagoComisiMes,2),		Con_Moneda_Cero,	Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion,
				VAR_COMISIONES
		FROM TMPEDOCTAV2SALDOSCREDITO AS tmp
		INNER JOIN EDOCTAV2RESUMCREDITOS AS edo ON tmp.CreditoID = edo.CreditoID
		WHERE EstatusCredito IN (EstatusVigente, EstatusVencido, EstatusPagado);

		INSERT INTO EDOCTAV2CFDIDATOS(
				AnioMes,				SucursalID,					ClienteID,			InstrumentoID,		TipoInstrumento,
				Concepto,				Monto,						ValorIVA,			EmpresaID,			Usuario,
				FechaActual,			DireccionIP,				ProgramaID,			Sucursal,			NumTransaccion,
				TipoConcepto)
		SELECT	Var_AnioMes,			Con_Entero_Cero,			tmp.ClienteID,			tmp.CreditoID,			TipoInstrumCredito,
				'IVA COMISIONES',		ROUND(tmp.PagoIVAComisiMes,2),	Con_Moneda_Cero,	Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion,
				VAR_IVACOMISIONES
		FROM TMPEDOCTAV2SALDOSCREDITO AS tmp
		INNER JOIN EDOCTAV2RESUMCREDITOS AS edo ON tmp.CreditoID = edo.CreditoID
		WHERE EstatusCredito IN (EstatusVigente, EstatusVencido, EstatusPagado);

		UPDATE EDOCTAV2CFDIDATOS Edo, EDOCTAV2RESUMCREDITOS Cre, PRODUCTOSCREDITO Prod, CLIENTES Cli, SUCURSALES Suc
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
		AND Edo.TipoConcepto = VAR_INTERESCREDITO;

		UPDATE EDOCTAV2CFDIDATOS Edo, EDOCTAV2RESUMCREDITOS Cre, PRODUCTOSCREDITO Prod, CLIENTES Cli, SUCURSALES Suc
		SET Edo.ValorIVA = CASE WHEN Prod.CobraIVAInteres = Con_SI AND Cli.PagaIVA = Con_SI THEN IFNULL(Suc.IVA, Con_Moneda_Cero)
								WHEN Prod.CobraIVAInteres = Con_SI AND Cli.PagaIVA = Con_NO THEN Con_Moneda_Cero
								WHEN Prod.CobraIVAInteres = Con_NO AND Cli.PagaIVA = Con_SI THEN Con_Moneda_Cero
								WHEN Prod.CobraIVAInteres = Con_NO AND Cli.PagaIVA = Con_NO THEN Con_Moneda_Cero
																						ELSE Con_Moneda_Cero
							END,
			Edo.Monto = CASE WHEN Prod.CobraIVAInteres = Con_SI AND Cli.PagaIVA = Con_SI THEN IFNULL(Edo.Monto, Con_Moneda_Cero)
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
		AND Edo.TipoConcepto = VAR_IVAINTERESCREDITO;

		UPDATE EDOCTAV2CFDIDATOS Edo, EDOCTAV2RESUMCREDITOS Cre, PRODUCTOSCREDITO Prod, CLIENTES Cli, SUCURSALES Suc
		SET Edo.ValorIVA = CASE WHEN Prod.CobraIVAMora = Con_SI AND Cli.PagaIVA = Con_SI THEN IFNULL(Suc.IVA, Con_Moneda_Cero)
								WHEN Prod.CobraIVAMora = Con_SI AND Cli.PagaIVA = Con_NO THEN Con_Moneda_Cero
								WHEN Prod.CobraIVAMora = Con_NO AND Cli.PagaIVA = Con_SI THEN Con_Moneda_Cero
								WHEN Prod.CobraIVAMora = Con_NO AND Cli.PagaIVA = Con_NO THEN Con_Moneda_Cero
																						ELSE Con_Moneda_Cero
							END
		WHERE Edo.InstrumentoID = Cre.CreditoID
		AND Prod.ProducCreditoID = Cre.ProductoCreditoID
		AND Edo.ClienteID = Cli.ClienteID
		AND Cli.SucursalOrigen = Suc.SucursalID
		AND Edo.TipoInstrumento = TipoInstrumCredito
		AND Edo.TipoConcepto = VAR_INTERESMORA;

		UPDATE EDOCTAV2CFDIDATOS Edo, EDOCTAV2RESUMCREDITOS Cre, PRODUCTOSCREDITO Prod, CLIENTES Cli, SUCURSALES Suc
		SET Edo.ValorIVA = CASE WHEN Prod.CobraIVAMora = Con_SI AND Cli.PagaIVA = Con_SI THEN IFNULL(Suc.IVA, Con_Moneda_Cero)
								WHEN Prod.CobraIVAMora = Con_SI AND Cli.PagaIVA = Con_NO THEN Con_Moneda_Cero
								WHEN Prod.CobraIVAMora = Con_NO AND Cli.PagaIVA = Con_SI THEN Con_Moneda_Cero
								WHEN Prod.CobraIVAMora = Con_NO AND Cli.PagaIVA = Con_NO THEN Con_Moneda_Cero
																						ELSE Con_Moneda_Cero
							END,
			Edo.Monto = CASE WHEN Prod.CobraIVAMora = Con_SI AND Cli.PagaIVA = Con_SI THEN IFNULL(Edo.Monto, Con_Moneda_Cero)
								WHEN Prod.CobraIVAMora = Con_SI AND Cli.PagaIVA = Con_NO THEN Con_Moneda_Cero
								WHEN Prod.CobraIVAMora = Con_NO AND Cli.PagaIVA = Con_SI THEN Con_Moneda_Cero
								WHEN Prod.CobraIVAMora = Con_NO AND Cli.PagaIVA = Con_NO THEN Con_Moneda_Cero
																						ELSE Con_Moneda_Cero
							END
		WHERE Edo.InstrumentoID = Cre.CreditoID
		AND Prod.ProducCreditoID = Cre.ProductoCreditoID
		AND Edo.ClienteID = Cli.ClienteID
		AND Cli.SucursalOrigen = Suc.SucursalID
		AND Edo.TipoInstrumento = TipoInstrumCredito
		AND Edo.TipoConcepto = VAR_IVAINTERESMORA;

		UPDATE EDOCTAV2CFDIDATOS Edo, EDOCTAV2RESUMCREDITOS Cre, PRODUCTOSCREDITO Prod, CLIENTES Cli, SUCURSALES Suc
		SET Edo.ValorIVA = CASE WHEN Cli.PagaIVA = Con_SI THEN IFNULL(Suc.IVA, Con_Moneda_Cero)
																ELSE Con_Moneda_Cero
									END
		WHERE Edo.InstrumentoID = Cre.CreditoID
		AND Prod.ProducCreditoID = Cre.ProductoCreditoID
		AND Edo.ClienteID = Cli.ClienteID
		AND Cli.SucursalOrigen = Suc.SucursalID
		AND Edo.TipoInstrumento = TipoInstrumCredito
		AND Edo.TipoConcepto = VAR_COMISIONES;

		UPDATE EDOCTAV2CFDIDATOS Edo, EDOCTAV2RESUMCREDITOS Cre, PRODUCTOSCREDITO Prod, CLIENTES Cli, SUCURSALES Suc
		SET Edo.ValorIVA = CASE WHEN Cli.PagaIVA = Con_SI THEN IFNULL(Suc.IVA, Con_Moneda_Cero)
																ELSE Con_Moneda_Cero
									END,
			Edo.Monto = CASE WHEN Cli.PagaIVA = Con_SI THEN IFNULL(Edo.Monto, Con_Moneda_Cero)
																ELSE Con_Moneda_Cero
									END
		WHERE Edo.InstrumentoID = Cre.CreditoID
		AND Prod.ProducCreditoID = Cre.ProductoCreditoID
		AND Edo.ClienteID = Cli.ClienteID
		AND Cli.SucursalOrigen = Suc.SucursalID
		AND Edo.TipoInstrumento = TipoInstrumCredito
		AND Edo.TipoConcepto = VAR_IVACOMISIONES;

		IF (Var_TipoInstitID <> TipoInstSOFOM) THEN
			-- Se obtiene el monto de la comision realizados en el periodo
			INSERT INTO EDOCTAV2CFDIDATOS(
					AnioMes,				SucursalID,				ClienteID,			InstrumentoID,		TipoInstrumento,
					Concepto,				Monto,					ValorIVA,			EmpresaID,			Usuario,
					FechaActual,			DireccionIP,			ProgramaID,			Sucursal,			NumTransaccion,
					TipoConcepto)
			SELECT	Var_AnioMes,			Con_Entero_Cero,		Edo.ClienteID,		Cue.InstrumentoID,	TipoInstrumCueAho,
					'OTRAS COMISIONES',
					SUM(CASE WHEN  Mov.NatMovimiento = NaturalezaCargo THEN Mov.CantidadMov ELSE Con_Moneda_Cero END)  -
					SUM(CASE WHEN Mov.NatMovimiento = NaturalezaAbono THEN Mov.CantidadMov ELSE Con_Moneda_Cero END),
					Con_Moneda_Cero,		Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion, VAR_OTRASCOMISI

			FROM EDOCTAV2RESUMCAPTA Cue
				INNER JOIN EDOCTAV2DATOSCTE Edo ON  Cue.ClienteID = Edo.ClienteID
				INNER JOIN `HIS-CUENAHOMOV` Mov ON Mov.CuentaAhoID = Cue.InstrumentoID AND Mov.Fecha >= Var_FecIniMes AND Mov.Fecha <= Var_FecFinMes
				INNER JOIN TIPOSMOVSAHO Tip ON Mov.TipoMovAhoID = Tip.TipoMovAhoID
			WHERE Mov.TipoMovAhoID IN(202,204,206,208,21,210,212,214,216,218,225,236,402,510,512,81,83,86,97)
			GROUP BY Mov.CuentaAhoID, Edo.ClienteID;

			INSERT INTO EDOCTAV2CFDIDATOS(
					AnioMes,				SucursalID,				ClienteID,			InstrumentoID,		TipoInstrumento,
					Concepto,				Monto,					ValorIVA,			EmpresaID,			Usuario,
					FechaActual,			DireccionIP,			ProgramaID,			Sucursal,			NumTransaccion,
					TipoConcepto)
			SELECT	Var_AnioMes,			Con_Entero_Cero,		Edo.ClienteID,		Cue.InstrumentoID,	TipoInstrumCueAho,
					'IVA OTRAS COMISIONES',
					SUM(CASE WHEN  Mov.NatMovimiento = NaturalezaCargo THEN Mov.CantidadMov ELSE Con_Moneda_Cero END)  -
					SUM(CASE WHEN Mov.NatMovimiento = NaturalezaAbono THEN Mov.CantidadMov ELSE Con_Moneda_Cero END),
					Con_Moneda_Cero,	Par_EmpresaID,				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,				Aud_NumTransaccion, VAR_IVAOTRASCOMISI

			FROM EDOCTAV2RESUMCAPTA Cue
				INNER JOIN EDOCTAV2DATOSCTE Edo ON  Cue.ClienteID = Edo.ClienteID
				INNER JOIN `HIS-CUENAHOMOV` Mov ON Mov.CuentaAhoID = Cue.InstrumentoID AND Mov.Fecha >= Var_FecIniMes AND Mov.Fecha <= Var_FecFinMes
				INNER JOIN TIPOSMOVSAHO Tip ON Mov.TipoMovAhoID = Tip.TipoMovAhoID
			WHERE Mov.TipoMovAhoID IN(203,205,207,209,22,211,213,215,217,219,226,235,403,511,513,82,84,88,98)
			GROUP BY Mov.CuentaAhoID, Edo.ClienteID;


			UPDATE EDOCTAV2CFDIDATOS Edo, EDOCTAV2RESUMCREDITOS Cre, PRODUCTOSCREDITO Prod, CLIENTES Cli, SUCURSALES Suc
			SET Edo.ValorIVA = CASE WHEN Cli.PagaIVA = Con_SI THEN IFNULL(Suc.IVA, Con_Moneda_Cero)
																	ELSE Con_Moneda_Cero
										END,
				Edo.Monto = CASE WHEN Cli.PagaIVA = Con_SI THEN IFNULL(Edo.Monto, Con_Moneda_Cero)
																	ELSE Con_Moneda_Cero
										END
			WHERE Edo.InstrumentoID = Cre.CreditoID
			AND Prod.ProducCreditoID = Cre.ProductoCreditoID
			AND Edo.ClienteID = Cli.ClienteID
			AND Cli.SucursalOrigen = Suc.SucursalID
			AND Edo.TipoInstrumento = TipoInstrumCueAho
			AND Edo.TipoConcepto = VAR_IVAOTRASCOMISI;

		END IF;

		SET Par_ErrMen    := 'Proceso Exitoso';
		SET Par_NumErr	:= 0;
	END ManejoErrores;

	IF(Par_Salida = Con_SI)THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				0 AS consecutivo;
	END IF;

END TerminaStore$$
