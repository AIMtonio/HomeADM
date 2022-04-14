-- EDOCTAV2CFDIDATOS099PRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAV2CFDIDATOS099PRO`;
DELIMITER $$

CREATE PROCEDURE `EDOCTAV2CFDIDATOS099PRO`(
	-- SP que recolecta informacion para generar cadenas de timbrado
	Par_Salida                   CHAR(1),		-- Parametro de salida
	INOUT Par_NumErr             INT(11),  		-- Numero de error
	INOUT Par_ErrMen             VARCHAR(400),	-- Mensaje de error

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
	DECLARE EstatusEliminado	CHAR(1);
	DECLARE ClasMovComision		INT(11);
	DECLARE ClasMovIVACom		INT(11);
	DECLARE TipoInstrumCredito	CHAR(1);
	DECLARE TipoInstrumCueAho	CHAR(1);
	DECLARE NaturalezaCargo		CHAR(1);
	DECLARE NaturalezaAbono		CHAR(1);
	DECLARE TipoInstSOFOM		INT(11);

	-- Declaracion de Variables
	DECLARE Var_TipoInstitID	INT(11);
	DECLARE Var_AnioMes			INT(11);			-- Periodo del proceso
	DECLARE Var_FecIniMes		DATE;				-- Fecha de inicio del periodo
	DECLARE Var_FecFinMes		DATE;				-- Fecha de fin de periodo
	DECLARE Var_FolioProceso	BIGINT(20);					-- Folio de procesamiento
	DECLARE MesProceso			INT;

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

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
						'esto le ocasiona. Ref: SP-EDOCTAV2CFDIDATOS099PRO');
			END;

		-- Se obtiene el periodo que se esta procesando, de la tabla de EDOCTAV2PARAMS
		SELECT
			MesProceso,		FechaInicio,	FechaFin, 		FolioProceso
		INTO
			Var_AnioMes,	Var_FecIniMes,	Var_FecFinMes,	Var_FolioProceso
		FROM EDOCTAV2PARAMS;
		SET MesProceso := IFNULL(MesProceso,Entero_Cero);

		IF(MesProceso, Entero_Cero) = Entero_Cero THEN
		SET Par_NumErr      := '1';
			SET Par_ErrMen    := 'Especifique el periodo a procesar[EDOCTAV2PARAMS-MesProceso]';

			LEAVE ManejoErrores;
		END IF;
		-- Se obtiene el tipo de institucion
		SELECT Ins.TipoInstitID INTO Var_TipoInstitID
		FROM INSTITUCIONES Ins
		JOIN PARAMETROSSIS Par ON Par.InstitucionID = Ins.InstitucionID;

		IF (Var_TipoInstitID = TipoInstSOFOM) THEN
			-- Tabla temporal para registrar los movimientos de las comisiones de los creditos registrados en tablas de  cuentas
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
			AND ClienteID <> 1
			AND TipoMovAhoID IN (	202, 203, 204, 205, 206, 207, 208, 209, 21, 22,
									210, 211, 212, 213, 214, 215, 216, 217, 218,219,
									225, 226, 402, 403, 81,  82,  83,  84,  86,  88, 510,510,512,513)
			AND Fecha >= Var_FecIniMes
			AND Fecha <= Var_FecFinMes
			AND NatMovimiento = NaturalezaCargo;

			INSERT INTO EDOCTAV2CFDIDATOS(
				AnioMes,				SucursalID,				ClienteID,			InstrumentoID,		TipoInstrumento,
				Concepto,				Monto,					ValorIVA,			EmpresaID,			Usuario,
				FechaActual,			DireccionIP,			ProgramaID,			Sucursal,			NumTransaccion)
			SELECT
				Var_AnioMes,			Con_Entero_Cero,			ClienteID,			CuentaAhoID,		TipoInstrumCueAho,
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
			PRIMARY KEY (`CreditoID`)
		) ;

		INSERT INTO TMP_EDOCTADETALLEPAGCRE
		SELECT	SAL.ClienteID
				,SAL.CreditoID
				,SUM(PagoIntOrdDia) AS MontoIntOrd
				,SUM(PagoIntAtrDia) AS MontoIntAtr
				,SUM(PagoIntVenDia) + SUM(PagoIntCalNoCon) AS MontoIntVen
				,SUM(PagoMoratorios) AS MontoIntMora
				,SUM(PagoComisiDia) AS MontoComision
				,Entero_Cero AS MontoGastoAdmon
		FROM SALDOSCREDITOS SAL
		JOIN EDOCTAV2RESUMCREDITOS CRE ON CRE.CreditoID = SAL.CreditoID
		WHERE SAL.FechaCorte >= Var_FecIniMes
		AND SAL.FechaCorte <=  Var_FecFinMes
		GROUP BY SAL.CreditoID, SAL.ClienteID;

		INSERT INTO EDOCTAV2CFDIDATOS(
				AnioMes,				SucursalID,					ClienteID,			InstrumentoID,		TipoInstrumento,
				Concepto,				Monto,						ValorIVA,			EmpresaID,			Usuario,
				FechaActual,			DireccionIP,				ProgramaID,			Sucursal,			NumTransaccion)

		SELECT	Var_AnioMes,			Con_Entero_Cero,			ClienteID,			CreditoID,			TipoInstrumCredito,
				'INTERES DE CREDITO',	ROUND(PagoIntOrdMes, 2),	Con_Moneda_Cero,	Con_Entero_Cero,	Con_Entero_Cero,
				Con_Fecha_Vacia,	Con_Cadena_Vacia,				Con_Cadena_Vacia,	Con_Entero_Cero,	Con_Entero_Cero
		FROM SALDOSCREDITOS
		WHERE FechaCorte = Var_FecFinMes;

		INSERT INTO EDOCTAV2CFDIDATOS(
				AnioMes,				SucursalID,				ClienteID,			InstrumentoID,		TipoInstrumento,
				Concepto,				Monto,					ValorIVA,			EmpresaID,			Usuario,
				FechaActual,			DireccionIP,			ProgramaID,			Sucursal,			NumTransaccion)
		SELECT	Var_AnioMes,			Con_Entero_Cero,		ClienteID,			CreditoID,			TipoInstrumCredito,
				'INTERES MORATORIO',	ROUND(PagoMoraMes, 2),	Con_Moneda_Cero,	Con_Entero_Cero,	Con_Entero_Cero,
				Con_Fecha_Vacia,		Con_Cadena_Vacia,		Con_Cadena_Vacia,	Con_Entero_Cero,	Con_Entero_Cero
		FROM SALDOSCREDITOS
		WHERE FechaCorte = Var_FecFinMes;

		INSERT INTO EDOCTAV2CFDIDATOS(
				AnioMes,				SucursalID,				ClienteID,			InstrumentoID,		TipoInstrumento,
				Concepto,				Monto,					ValorIVA,			EmpresaID,			Usuario,
				FechaActual,			DireccionIP,			ProgramaID,			Sucursal,			NumTransaccion)
		SELECT	Var_AnioMes,			Con_Entero_Cero,			ClienteID,			CreditoID,			TipoInstrumCredito,
				'COMISIONES',			ROUND(PagoComisiMes,2),	Con_Moneda_Cero,	Con_Entero_Cero,	Con_Entero_Cero,
				Con_Fecha_Vacia,		Con_Cadena_Vacia,		Con_Cadena_Vacia,	Con_Entero_Cero,	Con_Entero_Cero
		FROM SALDOSCREDITOS
		WHERE FechaCorte = Var_FecFinMes;

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
		AND Edo.Concepto = 'INTERES DE CREDITO';

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
		AND Edo.Concepto = 'INTERES MORATORIO';

		UPDATE EDOCTAV2CFDIDATOS Edo, EDOCTAV2RESUMCREDITOS Cre, PRODUCTOSCREDITO Prod, CLIENTES Cli, SUCURSALES Suc
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
			INSERT INTO EDOCTAV2CFDIDATOS(
					AnioMes,				SucursalID,				ClienteID,			InstrumentoID,		TipoInstrumento,
					Concepto,				Monto,					ValorIVA,			EmpresaID,			Usuario,
					FechaActual,			DireccionIP,			ProgramaID,			Sucursal,			NumTransaccion)
			SELECT	Var_AnioMes,			Con_Entero_Cero,			Edo.ClienteID,		Cue.CuentaAhoID,	TipoInstrumCueAho,
					'OTRAS COMISIONES DE CREDITO',
					SUM(CASE WHEN  Mov.NatMovimiento = NaturalezaCargo THEN Mov.CantidadMov ELSE Con_Moneda_Cero END)  -
					SUM(CASE WHEN Mov.NatMovimiento = NaturalezaAbono THEN Mov.CantidadMov ELSE Con_Moneda_Cero END),
					Con_Moneda_Cero,		Con_Entero_Cero,		Con_Entero_Cero,	Con_Fecha_Vacia,	Con_Cadena_Vacia,
					Con_Cadena_Vacia,		Con_Entero_Cero,		Con_Entero_Cero

			FROM EDOCTAV2RESUMCAPTA Cue
				INNER JOIN EDOCTADATOSCTE Edo ON  Cue.ClienteID = Edo.ClienteID
				INNER JOIN `HIS-CUENAHOMOV` Mov ON Mov.CuentaAhoID = Cue.InstrumentoID AND Mov.Fecha >= Var_FecIniMes AND Mov.Fecha <= Var_FecFinMes AND Mov.DescripcionMov LIKE 'COMISION%'
				INNER JOIN TIPOSMOVSAHO Tip ON Mov.TipoMovAhoID = Tip.TipoMovAhoID		AND Tip.ClasificacionMov = 2
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
			AND Edo.AnioMes = Var_AnioMes
			AND Mov.Fecha >= Var_FecIniMes AND Mov.Fecha <= Var_FecFinMes
			AND Tip.ClasificacionMov = 3
			AND (Mov.DescripcionMov LIKE 'IVA COMISION%' OR Mov.DescripcionMov LIKE 'Iva Comision%')
			GROUP BY Mov.CuentaAhoID, Edo.ClienteID;

			UPDATE	EDOCTAV2CFDIDATOS Edo,
					TMP_IVACOMISIONESCUENAHO Tmp
			SET Edo.ValorIVA = Tmp.IvaComision
			WHERE Edo.InstrumentoID = Tmp.CuentaAhoID
			AND Edo.ClienteID = Tmp.ClienteID
			AND Edo.TipoInstrumento = TipoInstrumCueAho
			AND Edo.Concepto = 'OTRAS COMISIONES DE CREDITO';
		END IF;

	END ManejoErrores;
	DROP TABLE IF EXISTS TMP_EDOCTADETALLEPAGCRE;
	DROP TEMPORARY TABLE IF EXISTS TMP_COMFALTAPAGOCREDITOS;
	DROP TEMPORARY TABLE IF EXISTS TMP_IVACOMISIONESCUENAHO;

	IF(Par_Salida = Con_SI)THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Par_ProducCreditoID AS consecutivo;
	END IF;

END TerminaStore$$
