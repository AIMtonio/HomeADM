-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAHEADERCTA099PRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAHEADERCTA099PRO`;
DELIMITER $$


CREATE PROCEDURE `EDOCTAHEADERCTA099PRO`(

	-- SP PARA OBTENER LOS DATOS DEL CLIENTE
    Par_AnioMes    		 	 	 	 	INT(11),					-- Anio y Mes Estado Cuenta
    Par_SucursalID						INT(11),						-- Numero de Sucursal
	Par_IniMes							DATE,						-- Fecha Inicio Mes
	Par_FinMes							DATE						-- Fecha Fin Mes
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

	-- SECCION CUENTASAHORRO

		-- SE CREA TABLA TEMPORAL PARA OBTENER LOS DATOS DE LAS CUENTAS DE RESUMEN
		DROP TABLE IF EXISTS TMPEDOCTARESUMCTAAHO;
		CREATE TEMPORARY TABLE TMPEDOCTARESUMCTAAHO (
			`ClienteID`					INT(11),
			`CuentaAhoID`				BIGINT(12),
			`Clabe`						VARCHAR(18),
			`Producto`					VARCHAR(30),
			`Estatus`					VARCHAR(25),
			`SaldoMinReq`				DECIMAL(12,2)
		);
		CREATE INDEX IDX_TMPEDOCTARESUMCTAAHO_CLIENTE USING BTREE ON TMPEDOCTARESUMCTAAHO (ClienteID);


		INSERT INTO TMPEDOCTARESUMCTAAHO(
												ClienteID,		CuentaAhoID,		Clabe,				Producto,		Estatus,
												SaldoMinReq
		)SELECT									ClienteID,		CuentaAhoID,		Cadena_Vacia,		Cadena_Vacia,	Estatus,
												Moneda_Cero
			FROM `HIS-CUENTASAHO` Cta
			WHERE  Cta.Fecha >= Par_IniMes
			AND Cta.Fecha <= Par_FinMes
			AND Cta.Estatus IN (EstatusActiva,EstatusBloqueado,EstatusCancelado)
			GROUP BY	Cta.CuentaAhoID,	Cta.Estatus, Cta.ClienteID;

		-- SE COLOCA LA CLABE Y TIPO DE CADA CUENTA DE AHORRO
		UPDATE TMPEDOCTARESUMCTAAHO Edo, CUENTASAHO Cta,	TIPOSCUENTAS Tc
			SET Edo.Clabe = IFNULL(Cta.Clabe, Cadena_Vacia), Edo.Producto = IFNULL(Tc.Descripcion, Cadena_Vacia),
				Edo.SaldoMinReq = IFNULL(Tc.SaldoMinReq, Moneda_Cero)
		WHERE Edo.CuentaAhoID = Cta.CuentaAhoID AND Cta.TipoCuentaID=Tc.TipoCuentaID;




		DROP TABLE IF EXISTS TMPEDCTAHEADERCTA;
		-- SE CREA LA TABLA TEMPORAL PARA AGREGAR LOS DATOS DE EXTRACCION
		CREATE TABLE TMPEDCTAHEADERCTA (
			`AnioMes`				INT(11),
			`SucursalID`			INT(11),
			`ClienteID`				INT(11),
			`CuentaAhoID`			BIGINT(12),
			`ProductoDesc`			VARCHAR(60),				-- Listo
			`Clabe`					VARCHAR(18),				-- Listo
			`SaldoMesAnterior`		DECIMAL(14,2),				-- Listo
			`SaldoActual`			DECIMAL(14,2),				-- checar de la EXTRACCIÓN de resumcuentas
			`SaldoPromedio`			DECIMAL(14,2),				-- SaldoPromedio
			`SaldoMinimo`			DECIMAL(14,2), 				-- Saldo Minimo
			`ISRRetenido`			DECIMAL(14,2),				-- ISR
			`GatNominal`			DECIMAL(5,2),				-- Gat
			`GatReal`				DECIMAL(5,2),				-- GatReal
			`TasaBruta`				DECIMAL(5,2),				-- TasaInteres
			`InteresPerido`			DECIMAL(14,2),				-- InteresesGen
			`MontoComision`			DECIMAL(14,2),				-- Comisiones
			`IvaComision`			DECIMAL(14,2),				-- Listo
			`MonedaID`				INT(11),					-- Listo
			`MonedaDescri`			VARCHAR(45),				-- Vacio
			`Etiqueta`				VARCHAR(60),				-- quemadoi vista
			`Depositos`				DECIMAL(14,2),				-- Listo
			`Retiros`				DECIMAL(14,2),				-- Listo
			`Estatus`				VARCHAR(25) 				-- Estatus
		);

		CREATE INDEX IDX_TMPEDCTAHEADERCTA_ANIOMES USING BTREE ON TMPEDCTAHEADERCTA (AnioMes);
		CREATE INDEX IDX_TMPEDCTAHEADERCTA_CLIENTE USING BTREE ON TMPEDCTAHEADERCTA (ClienteID);
		CREATE INDEX IDX_TMPEDCTAHEADERCTA_SUCURSAL USING BTREE ON TMPEDCTAHEADERCTA (SucursalID);


		-- INSERTA LOS RESUMEN DE LA CUENTA DE CADA CLIENTE
		INSERT INTO TMPEDCTAHEADERCTA
		SELECT	Par_AnioMes,																					-- AnioMes
				Cta.SucursalID,																					-- SucursalID
				Cta.ClienteID,																					-- ClienteID
				Cta.CuentaAhoID,																				-- CuentaAhoID
				TmpEdoResum.Producto,																			-- ProductoDesc
				TmpEdoResum.Clabe,																				-- Clabe
				IFNULL(Cta.SaldoIniMes, Moneda_Cero),															-- SaldoMesAnterior
				IFNULL(Cta.SaldoIniMes, Moneda_Cero) +
				IFNULL(Cta.AbonosMes, Moneda_Cero)  -
				IFNULL(Cta.CargosMes, Moneda_Cero), 															-- SaldoActual
				IFNULL(Cta.SaldoProm, Moneda_Cero),																-- SaldoPromedio
				TmpEdoResum.SaldoMinReq,																		-- Saldo Minimo
				IFNULL(Cta.ISR, Moneda_Cero),																	-- ISRRetenido
				IFNULL(Cta.Gat, Moneda_Cero),																	-- GatNominal
				IFNULL(Cta.GatReal, Moneda_Cero),																-- GatReal
				IFNULL(Cta.TasaInteres, Moneda_Cero),															-- TasaBruta
				IFNULL(InteresesGen, Moneda_Cero),																-- InteresPerido
				IFNULL(Cta.Comisiones, Moneda_Cero),															-- MontoComision
				IFNULL(Cta.IvaComApertura, Moneda_Cero) +
				IFNULL(Cta.IvaComManejoCta, Moneda_Cero) +
				IFNULL(Cta.IvaComAniv, Moneda_Cero)  +
				IFNULL(Cta.IvaComFalsoCob, Moneda_Cero) +
				IFNULL(Cta.IvaComDispSeg, Moneda_Cero),															-- IvaComision
				Cta.MonedaID,																					-- MonedaID
				Cadena_Vacia,																					-- MonedaDescri
				Cadena_Vacia,																					-- Etiqueta
				IFNULL(Cta.AbonosMes, Moneda_Cero),																-- Depositos
				IFNULL(Cta.CargosMes, Moneda_Cero),																-- Retiros
				CASE Cta.Estatus WHEN EstatusActiva THEN 'ACTIVA'
																	WHEN EstatusBloqueado THEN 'BLOQUEADA'
																	WHEN EstatusCancelado THEN 'CANCELADA'
																	WHEN EstatusInactiva THEN 'INACTIVA'
																	WHEN EstatusRegistrada THEN 'REGISTRADA'
																		ELSE 'Estatus No Identificado'
				END
		FROM `HIS-CUENTASAHO` Cta
		INNER JOIN TMPEDOCTARESUMCTAAHO TmpEdoResum	ON Cta.ClienteID	= TmpEdoResum.ClienteID
															AND Cta.CuentaAhoID	= TmpEdoResum.CuentaAhoID
 		WHERE  Cta.Fecha >= Par_IniMes
		AND Cta.Fecha <= Par_FinMes;

		-- Se actualiza la descripcion de la moneda
		UPDATE TMPEDCTAHEADERCTA Edo, MONEDAS Mon
		SET Edo.MonedaDescri = Mon.DescriCorta
		WHERE Edo.MonedaID = Mon.MonedaId;
        
		-- INSERTAMOS EN LA TABLA FINAL
		INSERT INTO EDOCTAHEADERCTA(
									AnioMes,				SucursalID,				ClienteID,						CuentaAhoID,					ProductoDesc,
									Clabe,					SaldoMesAnterior,		SaldoActual,					SaldoPromedio,					SaldoMinimo,
									ISRRetenido,			GatNominal,				GatReal,						TasaBruta,						InteresPerido,
									MontoComision,			IvaComision,			MonedaID,						MonedaDescri,					Etiqueta,
									Depositos,				Retiros,				Estatus,						EmpresaID,						Usuario,
									FechaActual,			DireccionIP,			ProgramaID,						Sucursal,						NumTransaccion
		)SELECT
									MAX(AnioMes),			MAX(SucursalID),			MAX(ClienteID),			MAX(CuentaAhoID),			MAX(ProductoDesc),
									MAX(Clabe),				MAX(SaldoMesAnterior),		MAX(SaldoActual),		MAX(SaldoPromedio),			MAX(SaldoMinimo),
									MAX(ISRRetenido),		MAX(GatNominal),			MAX(GatReal),			MAX(TasaBruta),				MAX(InteresPerido),
									MAX(MontoComision),		MAX(IvaComision),			MAX(MonedaID),			MAX(MonedaDescri),			MAX(Etiqueta),
									MAX(Depositos),			MAX(Retiros),				MAX(Estatus),			MAX(Entero_Cero),			MAX(Entero_Cero),
									MAX(Fecha_Vacia),		MAX(Cadena_Vacia),			MAX(Cadena_Vacia),		MAX(Entero_Cero),			MAX(Entero_Cero)
			FROM TMPEDCTAHEADERCTA
			group by CuentaAhoID;



END TerminaStore$$