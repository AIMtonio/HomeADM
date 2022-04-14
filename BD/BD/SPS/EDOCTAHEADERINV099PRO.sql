-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAHEADERINV099PRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAHEADERINV099PRO`;
DELIMITER $$


CREATE PROCEDURE `EDOCTAHEADERINV099PRO`(

	-- SP PARA OBTENER LOS DATOS DE LAS INVERSIONES DEL CLIENTE
    Par_AnioMes    		 	 	 	 	INT(11),					-- Anio y Mes Estado Cuenta
	Par_IniMes							DATE,						-- Fecha Inicio Mes
	Par_FinMes							DATE						-- Fecha Fin Mes
)

TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
	DECLARE Var_TipMovISRCTA			INT(11);					-- Tipo de movimiento RETENCION ISR CTA
	DECLARE Var_TipMovISRInv			INT(11);					-- Tipo de movimiento RETENCION ISR INVERSION
	DECLARE Var_TipMovISRIIN			INT(11);					-- Tipo de movimiento RETENCION ISR INTERES INVERSION
	DECLARE Var_TipMovISRMoI			INT(11);					-- Tipo de movimiento RETENCION ISR MORATORIOS INVERSION
	DECLARE Var_TipMovISRCIN			INT(11);					-- Tipo de movimiento RETENCION ISR COMISION INVERSION
	DECLARE Var_TipMovISRIIE			INT(11);					-- Tipo de movimiento RETENCION ISR INTERES INVERSION EXTRANJERO

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
	DECLARE Con_StaVigente				CHAR(1);					-- Estatus de la inversion: VIGENTE
	DECLARE Con_StaVencido				CHAR(1);					-- Estatus de la inversion: VENCIDO
	DECLARE Con_StaPagado				CHAR(1);					-- Estatus de la inversion: PAGADO
	DECLARE Con_StaCancelado			CHAR(1);					-- Estatus de la inversion: CANCELADO

	-- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia					:= '';						-- Cadena Vacia
	SET Fecha_Vacia						:= '1900-01-01';			-- Fecha Vacia
	SET Entero_Cero						:= 0;						-- Entero Cero
	SET Moneda_Cero						:= 0.00;					-- Decimal Cero
	SET NoEsInversion					:= 'N';						-- No es cuenta de inversion

	SET EsInversion						:= 'S';						-- Es una cuenta de inversion
	SET EstatusActiva					:= 'A';						-- Estatus de la cuenta: ACTIVA
	SET EstatusCancelado				:= 'C';						-- Estatus de la cuenta: CANCELADA
	SET EstatusBloqueado				:= 'B';						-- Estatus de la cuenta: BLOQUEADA
	SET EstatusInactiva					:= 'I';						-- Estatus de la cuenta: INACTIVA

	SET EstatusRegistrada				:= 'R';						-- Estatus de la cuenta: REGISTRADA
	SET Con_StaVigente					:= 'N';						-- Estatus de la inversion: VIGENTE
	SET Con_StaVencido    				:= 'V';						-- Estatus de la inversion: VENCIDO
	SET Con_StaPagado					:= 'P';						-- Estatus de la inversion: PAGADO
	SET Con_StaCancelado				:= 'C';						-- Estatus de la inversion: CANCELADO

	-- ASIGNACION DE VARIABLES
	SET Var_TipMovISRCTA				:= 220;						-- Tipo de movimiento RETENCION ISR CTA
	SET Var_TipMovISRInv				:= 64;						-- Tipo de movimiento RETENCION ISR INVERSION
	SET Var_TipMovISRIIN				:= 76;						-- Tipo de movimiento RETENCION ISR INTERES INVERSION
	SET Var_TipMovISRMoI				:= 77;						-- Tipo de movimiento RETENCION ISR MORATORIOS INVERSION
	SET Var_TipMovISRCIN				:= 78;						-- Tipo de movimiento RETENCION ISR COMISION INVERSION
	SET Var_TipMovISRIIE				:= 79;						-- Tipo de movimiento RETENCION ISR INTERES INVERSION EXTRANJERO

		DROP TABLE IF EXISTS TMPEDOCTAHEADER099INV;
		CREATE TABLE TMPEDOCTAHEADER099INV (
			AnioMes					INT(11),
			SucursalID				INT(11),
			ClienteID				INT(11),
			CuentaAhoID				BIGINT(12),
			NombreProducto			VARCHAR(100),
			GatReal					DECIMAL(14,2),
			TotalComisionesCobradas	DECIMAL(14,2),
			IvaComision				DECIMAL(14,2),
			ISRretenido				DECIMAL(14,2),
			InversionID				BIGINT(11),
			TipoCuenta				VARCHAR(150),
			InvCapital				DECIMAL(18,2),
			FechaInicio				DATE,
			FechaVence				DATE,
			TasaBruta				DECIMAL(18,2),
			Plazo					INT(11),
			Estatus					CHAR(1),
			Gat						DECIMAL(14,2),
			SucursalOrigen			INT(11)
		);

		CREATE INDEX IDX_TMPEDOCTAHEADER099INV_ANIOMES USING BTREE ON TMPEDOCTAHEADER099INV (AnioMes);
		CREATE INDEX IDX_TMPEDOCTAHEADER099INV_CLIENTE USING BTREE ON TMPEDOCTAHEADER099INV (ClienteID);
		CREATE INDEX IDX_TMPEDOCTAHEADER099INV_SUCURSAL USING BTREE ON TMPEDOCTAHEADER099INV (SucursalID);

		INSERT INTO TMPEDOCTAHEADER099INV
		SELECT
				Par_AnioMes,								-- AnioMes
				Entero_Cero,								-- SucursalID
				Inv.ClienteID,								-- ClienteID
				Inv.CuentaAhoID,							-- CuentaAhoID
				Cadena_Vacia,								-- NombreProducto
				IFNULL(ValorGatReal, Moneda_Cero),			-- GatReal
				Moneda_Cero,								-- TotalComisionesCobradas
				Moneda_Cero,								-- IvaComision
				Moneda_Cero,								-- ISRretenido
				Inv.InversionID,							-- InversionID
				Cadena_Vacia,								-- TipoCuenta
				Inv.Monto,									-- InvCapital
				Inv.FechaInicio,							-- FechaInicio
				Inv.FechaVencimiento,						-- FechaVence
				Inv.Tasa,									-- TasaBruta
				Inv.Plazo,									-- Plazo
				Inv.Estatus,								-- Estatus
				IFNULL(Inv.ValorGat, Moneda_Cero),			-- Gat
				Inv.SucursalOrigen							-- SucursalOrigen
		FROM	INVERSIONES Inv
		WHERE (Inv.Estatus IN(Con_StaVigente)  OR (Inv.Estatus = Con_StaPagado AND Inv.FechaVencimiento >= Par_IniMes
                              AND Inv.FechaVencimiento <= Par_FinMes));

		UPDATE TMPEDOCTAHEADER099INV Edo, CLIENTES Cli
		SET Edo.SucursalID = Cli.SucursalOrigen
		WHERE Edo.ClienteID = Cli.ClienteID;

		-- Se actualiza el tipo de inversion
		UPDATE TMPEDOCTAHEADER099INV Edo,		INVERSIONES Inv,		CATINVERSION Cat
		SET Edo.NombreProducto = IFNULL(Cat.Descripcion, Cadena_Vacia)
		WHERE Edo.InversionID = Inv.InversionID AND Inv.TipoInversionID = Cat.TipoInversionID;

		-- Proceso para extraer el ISR de la inversion ya pagada
		DROP TABLE IF EXISTS TMPEDOCTAHEADER099INVISR;
		CREATE TABLE TMPEDOCTAHEADER099INVISR (
			ClienteID				INT(11),
			CuentaAhoID				BIGINT(12),
			ISRretenido				DECIMAL(14,2),
			InversionID				INT(11)
		);
		CREATE INDEX IDX_TMPEDOCTAHEADER099INVISR_CLIENTE USING BTREE ON TMPEDOCTAHEADER099INVISR (ClienteID);
		CREATE INDEX IDX_TMPEDOCTAHEADER099INVISR_CUENTAAHO USING BTREE ON TMPEDOCTAHEADER099INVISR (CuentaAhoID);
		CREATE INDEX IDX_TMPEDOCTAHEADER099INVISR_INVERSION USING BTREE ON TMPEDOCTAHEADER099INVISR (InversionID);

		INSERT INTO TMPEDOCTAHEADER099INVISR(
												ClienteID,			CuentaAhoID,			ISRretenido,			InversionID
		)SELECT
												ClienteID,			CuentaAhoID,			ISRretenido,			InversionID
		FROM TMPEDOCTAHEADER099INV;

		-- RETENCION ISR CTA
		UPDATE TMPEDOCTAHEADER099INVISR TmpInvISR INNER JOIN CUENTASAHOMOV CueAho	ON TmpInvISR.CuentaAhoID = CueAho.CuentaAhoID
		SET			TmpInvISR.ISRretenido = CueAho.CantidadMov
		WHERE CueAho.TipoMovAhoID = Var_TipMovISRCTA
			AND CueAho.Fecha BETWEEN Par_IniMes AND Par_FinMes
			AND CueAho.ReferenciaMov = CAST(TmpInvISR.InversionID AS CHAR);

		UPDATE TMPEDOCTAHEADER099INVISR TmpInvISR INNER JOIN `HIS-CUENAHOMOV` CueAhoHis	ON TmpInvISR.CuentaAhoID = CueAhoHis.CuentaAhoID
		SET	  TmpInvISR.ISRretenido = CueAhoHis.CantidadMov
		WHERE CueAhoHis.TipoMovAhoID = Var_TipMovISRCTA
		  AND CueAhoHis.Fecha BETWEEN Par_IniMes AND Par_FinMes
		  AND CueAhoHis.ReferenciaMov = CAST(TmpInvISR.InversionID AS CHAR);

		-- RETENCION ISR INVERSION
		UPDATE TMPEDOCTAHEADER099INVISR TmpInvISR INNER JOIN CUENTASAHOMOV CueAho	ON TmpInvISR.CuentaAhoID = CueAho.CuentaAhoID
		SET			TmpInvISR.ISRretenido = CueAho.CantidadMov
		WHERE CueAho.TipoMovAhoID = Var_TipMovISRInv
			AND CueAho.Fecha BETWEEN Par_IniMes AND Par_FinMes
			AND CueAho.ReferenciaMov = CAST(TmpInvISR.InversionID AS CHAR);

		UPDATE TMPEDOCTAHEADER099INVISR TmpInvISR INNER JOIN `HIS-CUENAHOMOV` CueAhoHis	ON TmpInvISR.CuentaAhoID = CueAhoHis.CuentaAhoID
		SET	  TmpInvISR.ISRretenido = CueAhoHis.CantidadMov
		WHERE CueAhoHis.TipoMovAhoID = Var_TipMovISRInv
		  AND CueAhoHis.Fecha BETWEEN Par_IniMes AND Par_FinMes
		  AND CueAhoHis.ReferenciaMov = CAST(TmpInvISR.InversionID AS CHAR);

		-- RETENCION ISR INTERES INVERSION
		UPDATE TMPEDOCTAHEADER099INVISR TmpInvISR INNER JOIN CUENTASAHOMOV CueAho	ON TmpInvISR.CuentaAhoID = CueAho.CuentaAhoID
		SET			TmpInvISR.ISRretenido = CueAho.CantidadMov
		WHERE CueAho.TipoMovAhoID = Var_TipMovISRIIN
			AND CueAho.Fecha BETWEEN Par_IniMes AND Par_FinMes
			AND CueAho.ReferenciaMov = CAST(TmpInvISR.InversionID AS CHAR);

		UPDATE TMPEDOCTAHEADER099INVISR TmpInvISR INNER JOIN `HIS-CUENAHOMOV` CueAhoHis	ON TmpInvISR.CuentaAhoID = CueAhoHis.CuentaAhoID
		SET	  TmpInvISR.ISRretenido = CueAhoHis.CantidadMov
		WHERE CueAhoHis.TipoMovAhoID = Var_TipMovISRIIN
		  AND CueAhoHis.Fecha BETWEEN Par_IniMes AND Par_FinMes
		  AND CueAhoHis.ReferenciaMov = CAST(TmpInvISR.InversionID AS CHAR);

		-- RETENCION ISR MORATORIOS INVERSION
		UPDATE TMPEDOCTAHEADER099INVISR TmpInvISR INNER JOIN CUENTASAHOMOV CueAho	ON TmpInvISR.CuentaAhoID = CueAho.CuentaAhoID
		SET			TmpInvISR.ISRretenido = CueAho.CantidadMov
		WHERE CueAho.TipoMovAhoID = Var_TipMovISRMoI
			AND CueAho.Fecha BETWEEN Par_IniMes AND Par_FinMes
			AND CueAho.ReferenciaMov = CAST(TmpInvISR.InversionID AS CHAR);

		UPDATE TMPEDOCTAHEADER099INVISR TmpInvISR INNER JOIN `HIS-CUENAHOMOV` CueAhoHis	ON TmpInvISR.CuentaAhoID = CueAhoHis.CuentaAhoID
		SET	  TmpInvISR.ISRretenido = CueAhoHis.CantidadMov
		WHERE CueAhoHis.TipoMovAhoID = Var_TipMovISRMoI
		  AND CueAhoHis.Fecha BETWEEN Par_IniMes AND Par_FinMes
		  AND CueAhoHis.ReferenciaMov = CAST(TmpInvISR.InversionID AS CHAR);

		-- RETENCION ISR COMISION INVERSION
		UPDATE TMPEDOCTAHEADER099INVISR TmpInvISR INNER JOIN CUENTASAHOMOV CueAho	ON TmpInvISR.CuentaAhoID = CueAho.CuentaAhoID
		SET			TmpInvISR.ISRretenido = CueAho.CantidadMov
		WHERE CueAho.TipoMovAhoID = Var_TipMovISRCIN
			AND CueAho.Fecha BETWEEN Par_IniMes AND Par_FinMes
			AND CueAho.ReferenciaMov = CAST(TmpInvISR.InversionID AS CHAR);

		UPDATE TMPEDOCTAHEADER099INVISR TmpInvISR INNER JOIN `HIS-CUENAHOMOV` CueAhoHis	ON TmpInvISR.CuentaAhoID = CueAhoHis.CuentaAhoID
		SET	  TmpInvISR.ISRretenido = CueAhoHis.CantidadMov
		WHERE CueAhoHis.TipoMovAhoID = Var_TipMovISRCIN
		  AND CueAhoHis.Fecha BETWEEN Par_IniMes AND Par_FinMes
		  AND CueAhoHis.ReferenciaMov = CAST(TmpInvISR.InversionID AS CHAR);

		-- RETENCION ISR INTERES INVERSION EXTRANJERO
		UPDATE TMPEDOCTAHEADER099INVISR TmpInvISR INNER JOIN CUENTASAHOMOV CueAho	ON TmpInvISR.CuentaAhoID = CueAho.CuentaAhoID
		SET			TmpInvISR.ISRretenido = CueAho.CantidadMov
		WHERE CueAho.TipoMovAhoID = Var_TipMovISRIIE
			AND CueAho.Fecha BETWEEN Par_IniMes AND Par_FinMes
			AND CueAho.ReferenciaMov = CAST(TmpInvISR.InversionID AS CHAR);

		UPDATE TMPEDOCTAHEADER099INVISR TmpInvISR INNER JOIN `HIS-CUENAHOMOV` CueAhoHis	ON TmpInvISR.CuentaAhoID = CueAhoHis.CuentaAhoID
		SET	  TmpInvISR.ISRretenido = CueAhoHis.CantidadMov
		WHERE CueAhoHis.TipoMovAhoID = Var_TipMovISRIIE
		  AND CueAhoHis.Fecha BETWEEN Par_IniMes AND Par_FinMes
		  AND CueAhoHis.ReferenciaMov = CAST(TmpInvISR.InversionID AS CHAR);

		UPDATE TMPEDOCTAHEADER099INV TmpEdoResum INNER JOIN TMPEDOCTAHEADER099INVISR TmpInvISR ON TmpEdoResum.CuentaAhoID = TmpInvISR.CuentaAhoID
																								AND TmpEdoResum.ClienteID = TmpInvISR.ClienteID
																								AND TmpEdoResum.InversionID = TmpInvISR.InversionID
		SET TmpEdoResum.ISRretenido = TmpInvISR.ISRretenido;


		INSERT INTO EDOCTAHEADER099INV(
									AnioMes,			SucursalID,						ClienteID,		CuentaAhoID,		NombreProducto,
									GatReal,			TotalComisionesCobradas,		IvaComision,	ISRretenido,		InversionID,
									TipoCuenta,			InvCapital,						FechaInicio,	FechaVence,			TasaBruta,
									Plazo,				Estatus,						Gat,			SucursalOrigen,		EmpresaID,
									Usuario,			FechaActual,					DireccionIP,	ProgramaID,			Sucursal,
									NumTransaccion

		)SELECT
									AnioMes,			SucursalID,						ClienteID,		CuentaAhoID,		NombreProducto,
									GatReal,			TotalComisionesCobradas,		IvaComision,	ISRretenido,		InversionID,
									TipoCuenta,			InvCapital,						FechaInicio,	FechaVence,			TasaBruta,
									Plazo,				Estatus,						IFNULL(Gat, Moneda_Cero),			SucursalOrigen,		Entero_Cero,
									Entero_Cero,		Fecha_Vacia,					Cadena_Vacia,	Cadena_Vacia,		Entero_Cero,
									Entero_Cero
		FROM TMPEDOCTAHEADER099INV;



END TerminaStore$$