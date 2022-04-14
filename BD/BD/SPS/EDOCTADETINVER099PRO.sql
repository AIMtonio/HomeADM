-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTADETINVER099PRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTADETINVER099PRO`;DELIMITER $$

CREATE PROCEDURE `EDOCTADETINVER099PRO`(

	-- SP PARA OBTENER LOS DATOS DE LAS INVERSIONES DEL CLIENTE
    Par_AnioMes    		 	 	 	 	INT(11),					-- Anio y Mes Estado Cuenta
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


	DECLARE Con_StaVigente				CHAR(1);					-- Estatus de la inversion: VIGENTE
	DECLARE Con_StaVencido				CHAR(1);					-- Estatus de la inversion: VENCIDO
	DECLARE Con_StaPagado				CHAR(1);					-- Estatus de la inversion: PAGADO
	DECLARE Con_StaCancelado			CHAR(1);					-- Estatus de la inversion: CANCELADO

	DECLARE EtiqueHeaderProd			VARCHAR(30);				-- Etiqueta de la cebecera del producto
	DECLARE MovimientoCargo				CHAR(1);					-- Movimiento de cargo
	DECLARE MovimientoAbono				CHAR(1);					-- Movimiento de abono

	DECLARE Orden_Uno					INT(1);						-- Orden uno movimiento de apertura de la cuenta
	DECLARE Orden_Dos					INT(1);						-- Orden dos interes generado del mes anterior
	DECLARE Orden_Tres					INT(1);						-- Orden tres interes normal generado en el mes actual
	DECLARE Orden_Cuatro				INT(1);						-- Orden cuatro pago de interes del periodo
	DECLARE Orden_Cinco					INT(1);						-- Orden cinco pago de capital cuando vencio la inversion

	DECLARE Orden_Seis					INT(1);						-- Orden cinco pago de capital cuando vencio la inversion

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

	SET EtiqueHeaderProd				:= 'INVERSION PLAZO FIJO';	-- Etiqueta de la cebecera del producto
	SET MovimientoCargo					:= 'C';						-- Movimiento de cargo
	SET MovimientoAbono					:= 'A';						-- Movimiento de abono

	SET Orden_Uno						:= 1;						-- Asignacion de constante Orden uno movimiento de apertura de la cuenta
	SET Orden_Dos						:= 2;						-- Asignacion de constante Orden dos interes generado del mes anterior
	SET Orden_Tres						:= 3;						-- Asignacion de constante Orden tres interes normal generado en el mes actual
	SET Orden_Cuatro					:= 4;						-- Asignacion de constante Orden cuatro pago de interes del periodo
	SET Orden_Cinco						:= 5;						-- Asignacion de constante Orden cinco pago de capital cuando vencio la inversion

	SET Orden_Seis						:= 6;						--

	-- SECCION CUENTASAHORRO

		-- SE CREA TABLA TEMPORAL PARA OBTENER LOS DATOS DE LAS CUENTAS DE INVERSIONES
		DROP TABLE IF EXISTS TMPEDOCTAHEADERINVER;

		CREATE TEMPORARY TABLE TMPEDOCTAHEADERINVER (
			`ClienteID`					INT,
			`InversionID`				INT
		);
		CREATE INDEX IDX_TMPEDOCTAHEADERINVER_CLIENTE USING BTREE ON TMPEDOCTAHEADERINVER (ClienteID);
		CREATE INDEX IDX_TMPEDOCTAHEADERINVER_INVERSION USING BTREE ON TMPEDOCTAHEADERINVER (ClienteID);

		INSERT INTO TMPEDOCTAHEADERINVER(
												ClienteID,		InversionID
		)	SELECT								ClienteID,		InversionID
			FROM	EDOCTAHEADER099INV;




		DROP TABLE IF EXISTS TMPEDOCTADETINVER;
		CREATE TABLE TMPEDOCTADETINVER(
			`AnioMes`			INT(11)				NOT NULL,
			`SucursalID`		INT(11)				NOT NULL,
			`ClienteID`			INT(11)				NOT NULL,
			`InversionID`		BIGINT(20)			NOT NULL,
			`Descripcion`		VARCHAR(100)		NOT NULL,
			`FechanMov`			DATE				NOT NULL,
			`Cargo`				DECIMAL(14,2)		NOT NULL,
			`Abono`				DECIMAL(14,2)		NOT NULL,
			`Orden`				INT(11)				NOT NULL,
			`Referencia`		BIGINT(20)			NOT NULL
		);

		CREATE INDEX IDX_TMPEDOCTADETINVER_ANIOMES USING BTREE ON TMPEDOCTADETINVER (AnioMes);
		CREATE INDEX IDX_TMPEDOCTADETINVER_CLIENTE USING BTREE ON TMPEDOCTADETINVER (ClienteID);
		CREATE INDEX IDX_TMPEDOCTADETINVER_SUCURSAL USING BTREE ON TMPEDOCTADETINVER (SucursalID);



		-- Saldo inicial del mes
		INSERT INTO TMPEDOCTADETINVER(
											AnioMes,			SucursalID,			ClienteID,				InversionID,		Descripcion,
											FechanMov,			Cargo,				Abono,					Orden,				Referencia
		)SELECT
											Par_AnioMes,		Entero_Cero,		TmpEdoInv.ClienteID, 	Inv.InversionID,	'SALDO INICIAL',
											Par_IniMes,			Moneda_Cero,		Moneda_Cero,			Orden_Uno,			Entero_Cero
		FROM TMPEDOCTAHEADERINVER TmpEdoInv INNER JOIN INVERSIONES Inv ON TmpEdoInv.InversionID = Inv.InversionID
																	   AND TmpEdoInv.ClienteID = Inv.ClienteID;


		UPDATE TMPEDOCTADETINVER TmpEdoDetInv INNER JOIN INVERSIONES Inv ON TmpEdoDetInv.InversionID =  Inv.InversionID
			SET TmpEdoDetInv.Abono = IF(Inv.FechaInicio >= Par_IniMes AND Inv.FechaInicio <= Par_FinMes, Moneda_Cero,
											Inv.Monto
										)
		WHERE TmpEdoDetInv.Orden = Orden_Uno;


		-- Inversiones aperturadas durante el mes en curso
		INSERT INTO TMPEDOCTADETINVER(
											AnioMes,			SucursalID,			ClienteID,				InversionID,		Descripcion,
											FechanMov,			Cargo,				Abono,					Orden,				Referencia
		)SELECT
											Par_AnioMes,		Entero_Cero,		TmpEdoInv.ClienteID, 	Inv.InversionID,	'APERTURA DE INVERSION',
											Inv.FechaInicio,	Moneda_Cero,		Inv.Monto,				Orden_Dos,			Entero_Cero
		FROM TMPEDOCTAHEADERINVER TmpEdoInv INNER JOIN INVERSIONES Inv ON TmpEdoInv.InversionID = Inv.InversionID
																	   AND TmpEdoInv.ClienteID = Inv.ClienteID
		WHERE Inv.FechaInicio >= Par_IniMes;


		-- PREGUNTAR CON QUE FECHA SE REFELA INTRES GENERADO MES ANTERIOR
		-- Inversiones aperturadas durante el mes en curso
		INSERT INTO TMPEDOCTADETINVER(
											AnioMes,			SucursalID,			ClienteID,				InversionID,		Descripcion,
											FechanMov,			Cargo,				Abono,					Orden,				Referencia
		)SELECT
											Par_AnioMes,		Entero_Cero,		TmpEdoInv.ClienteID,	Inv.InversionID,	'INTERES GENERADO MES ANTERIOR',
											Par_IniMes,			Moneda_Cero,		Moneda_Cero,			Orden_Tres,			Entero_Cero
		FROM TMPEDOCTAHEADERINVER TmpEdoInv INNER JOIN INVERSIONES Inv ON TmpEdoInv.InversionID = Inv.InversionID
																	   AND TmpEdoInv.ClienteID = Inv.ClienteID
		WHERE Inv.FechaInicio < Par_IniMes;


		UPDATE TMPEDOCTADETINVER TmpEdoDetInv INNER JOIN INVERSIONES Inv ON TmpEdoDetInv.InversionID =  Inv.InversionID
											  INNER JOIN INVERSIONESMOV InvMov ON Inv.InversionID = InvMov.InversionID

			SET TmpEdoDetInv.Abono = IFNULL( (SELECT SUM(InvMov.Monto) FROM INVERSIONESMOV InvMov
												WHERE InvMov.InversionID = TmpEdoDetInv.InversionID
												AND InvMov.NatMovimiento = MovimientoCargo
												AND InvMov.Fecha >= Inv.FechaInicio
												AND InvMov.Fecha < Par_IniMes), Moneda_Cero)
		WHERE TmpEdoDetInv.Orden = Orden_Tres;



		INSERT INTO TMPEDOCTADETINVER(
											AnioMes,			SucursalID,			ClienteID,				InversionID,		Descripcion,
											FechanMov,			Cargo,				Abono,					Orden,				Referencia
		)SELECT
											Par_AnioMes,		Entero_Cero,		TmpEdoHeader.ClienteID,	Inv.InversionID,	Inv.Referencia,
											Inv.Fecha,			Moneda_Cero,		Inv.Monto,				Orden_Cuatro,		Inv.NumeroMovimiento
		FROM INVERSIONESMOV Inv INNER JOIN TMPEDOCTAHEADERINVER TmpEdoHeader ON Inv.InversionID = TmpEdoHeader.InversionID
		WHERE Inv.Fecha >= Par_IniMes
		  AND Inv.Fecha <= Par_FinMes
		  AND Inv.NatMovimiento = MovimientoCargo;



		-- Inversiones pago de interes mes cierre
		INSERT INTO TMPEDOCTADETINVER(
											AnioMes,					SucursalID,			ClienteID,				InversionID,		Descripcion,
											FechanMov,					Cargo,				Abono,					Orden,				Referencia
		)SELECT
											Par_AnioMes,				Entero_Cero,		TmpEdoInv.ClienteID,	Inv.InversionID,	'PAGO DE INTERES',
											Inv.FechaVencimiento,		Moneda_Cero,		Moneda_Cero,			Orden_Cinco,		Entero_Cero
		FROM TMPEDOCTAHEADERINVER TmpEdoInv INNER JOIN INVERSIONES Inv ON TmpEdoInv.InversionID = Inv.InversionID
																	   AND TmpEdoInv.ClienteID = Inv.ClienteID
		WHERE Inv.FechaVencimiento <= Par_FinMes AND
			  Inv.FechaVencimiento >= Par_IniMes;

		UPDATE TMPEDOCTADETINVER TmpEdoDetInv INNER JOIN INVERSIONES Inv ON TmpEdoDetInv.InversionID =  Inv.InversionID
											  INNER JOIN INVERSIONESMOV InvMov ON Inv.InversionID = InvMov.InversionID
				SET TmpEdoDetInv.Cargo	=	IFNULL( (SELECT InvMov.Monto FROM INVERSIONESMOV InvMov
												WHERE InvMov.InversionID = TmpEdoDetInv.InversionID
												AND InvMov.NatMovimiento = MovimientoAbono
												AND InvMov.Fecha = Inv.FechaVencimiento), Moneda_Cero )
		WHERE TmpEdoDetInv.Orden = Orden_Cinco;

		-- Inversiones pago del capital mes cierre ---------
		INSERT INTO TMPEDOCTADETINVER(
											AnioMes,				SucursalID,			ClienteID,				InversionID,		Descripcion,
											FechanMov,				Cargo,				Abono,					Orden,				Referencia
		)SELECT
											Par_AnioMes,			Entero_Cero,		TmpEdoInv.ClienteID,	Inv.InversionID,		'PAGO DE CAPITAL',
											Inv.FechaVencimiento,	Inv.Monto,			Moneda_Cero,			Orden_Seis,			Entero_Cero
		FROM TMPEDOCTAHEADERINVER TmpEdoInv INNER JOIN INVERSIONES Inv ON TmpEdoInv.InversionID = Inv.InversionID
																	   AND TmpEdoInv.ClienteID = Inv.ClienteID
		WHERE Inv.FechaVencimiento <= Par_FinMes AND
			  Inv.FechaVencimiento >= Par_IniMes;

		UPDATE TMPEDOCTADETINVER Edo, CLIENTES Cli
		SET Edo.SucursalID = Cli.SucursalOrigen
		WHERE Edo.ClienteID = Cli.ClienteID;


		INSERT INTO EDOCTADETINVER(
									AnioMes,			SucursalID,						ClienteID,			InversionID,		Descripcion,
									FechanMov,			Cargo,							Abono,				Orden,				Referencia,
									EmpresaID,			Usuario,						FechaActual,		DireccionIP,		ProgramaID,
									Sucursal,			NumTransaccion

		)SELECT
									AnioMes,			SucursalID,						ClienteID,			InversionID,		Descripcion,
									FechanMov,			Cargo,							Abono,				Orden,				Referencia,
									Entero_Cero,		Entero_Cero,					Fecha_Vacia,		Cadena_Vacia,		Cadena_Vacia,
									Entero_Cero,		Entero_Cero
		FROM TMPEDOCTADETINVER;

END TerminaStore$$