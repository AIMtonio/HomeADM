-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTARESUMCTA099PRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTARESUMCTA099PRO`;
DELIMITER $$


CREATE PROCEDURE `EDOCTARESUMCTA099PRO`(

	-- SP PARA OBTENER LOS DATOS DE LAS CUENTAS DE AHORRO DEL CLIENTE EN LOS ESTADOS DE CUENTA DE LOS CLIENTES NUEVOS EN TRONCO PRINCIPAL
	Par_AnioMes				INT(11),		-- Año y Mes Estado Cuenta
	Par_SucursalID			INT(11),		-- Numero de Sucursal
	Par_IniMes				DATE,			-- Fecha Inicio Mes
	Par_FinMes				DATE,			-- Fecha Fin Mes
	Par_ClienteInstitu		INT(11)			-- Cliente Institucion
)

TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
	DECLARE	Var_NombreInstit			VARCHAR(150);		-- Almacena el nombre de la institucion
	DECLARE	Var_DireccionInstit			VARCHAR(200);		-- Almacena la direccion de la institucion
	DECLARE	Var_NumInstitucion			INT(11);			-- Almacena el numero de la institucion
	DECLARE Var_FechaFin				DATE;				-- Varible de la fecha fin

	-- DECLARACION DE CONSTANTES
	DECLARE	Cadena_Vacia				VARCHAR(1);			-- Cadena Vacia
	DECLARE	Fecha_Vacia					DATE;				-- Fecha Vacia
	DECLARE	Entero_Cero					INT(11);			-- Entero Cero
	DECLARE	Moneda_Cero					INT(11);			-- Decimal Cero
	DECLARE NoProcesado					INT(11);			-- Numero Proceso: 1

	DECLARE NoEsMenorEdad   			CHAR(1);			-- Cliente Menor Edad: NO
	DECLARE EstatusActivo				CHAR(1);			-- Estatus Cliente: ACTIVO
	DECLARE EstatusInactivo				CHAR(1);			-- Estatus Cliente: INACTIVO
	DECLARE PersonaFisica				CHAR(1);			-- Tipo Persona: FISICA
	DECLARE PersonaMoral				CHAR(1);			-- Tipo Persona: MORAL

	DECLARE PerActivEmp					CHAR(1);			-- Tipo Persona: FISICA CON ACTIVIDAD EMPRESARIAL
	DECLARE EsRegHacienda				CHAR(1);			-- Registro Hacienda: SI
	DECLARE EsFiscal					CHAR(1);			-- Direccion Fiscal: SI
	DECLARE EsOficial					CHAR(1);			-- Direccion Oficial: SI

	DECLARE NoEsInversion				CHAR(1);			-- Cuenta no es inversion: N
	DECLARE EsInversionS				CHAR(1);			-- Cuenta es inversion: S
	DECLARE EstatusActiva				CHAR(1);			-- Estatus de la cuenta: ACTIVA
	DECLARE EstatusCancelado			CHAR(1);			-- Estatus de la cuenta: CANCELADA
	DECLARE EstatusBloqueado			CHAR(1);			-- Estatus de la cuenta: BLOQUEADA
	DECLARE EstatusInactiva				CHAR(1);			-- Estatus de la cuenta: INACTIVA
	DECLARE EstatusRegistrada			CHAR(1);			-- Estatus de la cuenta: REGISTRADA


	DECLARE Con_StaVigente				CHAR(1);			-- Estatus de la inversion: VIGENTE
	DECLARE Con_StaVencido				CHAR(1);			-- Estatus de la inversion: VENCIDO
	DECLARE Con_StaPagado				CHAR(1);			-- Estatus de la inversion: PAGADO
	DECLARE Con_StaCancelado			CHAR(1);			-- Estatus de la inversion: CANCELADO

	DECLARE Entero_Uno					INT(11);			-- Entero uno

	-- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia					:= '';				-- Cadena Vacia
	SET Fecha_Vacia						:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero						:= 0;				-- Entero Cero
	SET Moneda_Cero						:= 0.00;			-- Decimal Cero
	SET NoProcesado						:= 1; 				-- Numero Proceso: 1

	SET NoEsMenorEdad					:= 'N';				-- Cliente Menor Edad: NO
	SET EstatusActivo					:= 'A';				-- Estatus Cliente: ACTIVO
	SET EstatusInactivo					:= 'I';				-- Estatus Cliente: INACTIVO
	SET PersonaFisica					:= 'F';				-- Tipo Persona: FISICA
	SET PersonaMoral					:= 'M';				-- Tipo Persona: MORAL
	SET PerActivEmp						:= 'A';				-- Tipo Persona: FISICA CON ACTIVIDAD EMPRESARIAL

	SET EsRegHacienda					:= 'S';				-- Registro Hacienda: SI
	SET EsFiscal						:= 'S';				-- Direccion Fiscal: SI
	SET EsOficial						:= 'S';				-- Direccion Oficial: SI

	SET NoEsInversion					:= 'N';				-- No es cuenta de inversion
	SET EsInversionS					:= 'S';				-- Es una cuenta de inversion
	SET EstatusActiva					:= 'A';				-- Estatus de la cuenta: ACTIVA
	SET EstatusCancelado				:= 'C';				-- Estatus de la cuenta: CANCELADA
	SET EstatusBloqueado				:= 'B';				-- Estatus de la cuenta: BLOQUEADA
	SET EstatusInactiva					:= 'I';				-- Estatus de la cuenta: INACTIVA
	SET EstatusRegistrada				:= 'R';				-- Estatus de la cuenta: REGISTRADA

	SET Con_StaVigente					:= 'N';				-- Estatus de la inversion: VIGENTE
	SET Con_StaVencido    				:= 'V';				-- Estatus de la inversion: VENCIDO
	SET Con_StaPagado					:= 'P';				-- Estatus de la inversion: PAGADO
	SET Con_StaCancelado				:= 'C';				-- Estatus de la inversion: CANCELADO

	SET Entero_Uno						:= 1;				-- Asignacion de numero uno

	-- SECCION CUENTASAHORRO

		-- SE CREA TABLA TEMPORAL PARA OBTENER LOS DATOS DEL CLIENTE
		DROP TABLE IF EXISTS TMPEDOCTARESUMCTA;

		CREATE TEMPORARY TABLE TMPEDOCTARESUMCTA (
			`AnioMes`					INT(11),
			`SucursalID`				INT(11),
			`ClienteID`					DECIMAL(15,0),
			`CuentaAhoID`				DECIMAL(15,0),
			`MonedaID`					INT(11),
			`MonedaDescri`				VARCHAR(45),
			`Etiqueta`					VARCHAR(60),
			`SaldoActual`				DECIMAL(14,2),
			`SaldoMesAnterior`			DECIMAL(14,2),
			`SaldoPromedio`				DECIMAL(14,2),
			`Estatus`					VARCHAR(25),
			`EsInversion`				CHAR(1),
			`GeneraInteres`				CHAR(1)
		);

		CREATE INDEX IDX_TMPEDOCTARESUMCTA_ANIOMES USING BTREE ON TMPEDOCTARESUMCTA (AnioMes);
		CREATE INDEX IDX_TMPEDOCTARESUMCTA_CLIENTE USING BTREE ON TMPEDOCTARESUMCTA (ClienteID);
		CREATE INDEX IDX_TMPEDOCTARESUMCTA_SUCURSAL USING BTREE ON TMPEDOCTARESUMCTA (SucursalID);


		-- INSERTA LOS RESUMEN DE LA CUENTA DE CADA CLIENTE
		INSERT INTO TMPEDOCTARESUMCTA
		SELECT	Par_AnioMes,																								-- AnioMes
				Cta.SucursalID,																								-- SucursalID
				Cta.ClienteID,																								-- ClienteID
				Cta.CuentaAhoID,																							-- CuentaAhoID
				Cta.MonedaID,																								-- MonedaID
				Cadena_Vacia,																								-- MonedaDescri
				Cadena_Vacia,																							-- Etiqueta
				IFNULL(Cta.SaldoIniMes, Moneda_Cero) +
				IFNULL(Cta.AbonosMes, Moneda_Cero) -
				IFNULL(Cta.CargosMes, Moneda_Cero),																			-- SaldoActual
				IFNULL(Cta.SaldoIniMes, Moneda_Cero),																		-- SaldoMesAnterior
				IFNULL(Cta.SaldoProm, Moneda_Cero),																			-- SaldoPromedio
				case Cta.Estatus WHEN EstatusActiva THEN 'ACTIVA'
																	WHEN EstatusBloqueado THEN 'BLOQUEADA'
																	WHEN EstatusCancelado THEN 'CANCELADA'
																	WHEN EstatusInactiva THEN 'INACTIVA'
																	WHEN EstatusRegistrada THEN 'REGISTRADA'
																		ELSE 'Estatus No Identificado'						-- Estatus
				END,
				NoEsInversion,																								-- EsInversion
				Tc.GeneraInteres
		FROM `HIS-CUENTASAHO` Cta
		INNER JOIN CLIENTES Cli ON Cta.ClienteID	= Cli.ClienteID AND Cli.ClienteID!=Par_ClienteInstitu
		INNER JOIN TIPOSCUENTAS Tc ON Cta.TipoCuentaID	= Tc.TipoCuentaID
		WHERE  Cta.Fecha >= Par_IniMes
		AND Cta.Fecha <= Par_FinMes
		AND Cta.Estatus IN (EstatusActiva,EstatusBloqueado,EstatusCancelado)
		GROUP BY	Cta.CuentaAhoID,	Cli.ClienteID,    	Cta.MonedaID,  		Cta.AbonosMes,			Cta.CargosMes,
					Cta.SaldoIniMes,	Cta.AbonosMes,		Cta.CargosMes,		Cta.SaldoIniMes,  		Cta.SaldoProm,
					Cta.Estatus, 		Tc.TipoCuentaID,	Cta.SucursalID;

		-- Se actualiza la descripcion de la moneda
		UPDATE TMPEDOCTARESUMCTA Edo, MONEDAS Mon
		SET Edo.MonedaDescri = Mon.DescriCorta
		WHERE Edo.MonedaID = Mon.MonedaId;

		-- Se actualiza el tipo de la cuenta de ahorro
		UPDATE TMPEDOCTARESUMCTA Edo,		CUENTASAHO Cta,		TIPOSCUENTAS Tc
		SET Edo.Etiqueta = IFNULL(Tc.Descripcion, Cadena_Vacia)
		WHERE Edo.CuentaAhoID = Cta.CuentaAhoID AND Cta.TipoCuentaID=Tc.TipoCuentaID;

	-- SECCION DE INVERSIONES
		INSERT INTO TMPEDOCTARESUMCTA
		SELECT	Par_AnioMes,
				Entero_Cero,
				Inv.ClienteID,
				Inv.InversionID,
				Inv.MonedaID,
				Cadena_Vacia,
				Cadena_Vacia,
				Moneda_Cero,
				Moneda_Cero,
				Moneda_Cero,
				CASE Inv.Estatus	WHEN Con_StaVigente		THEN 'VIGENTE'
									WHEN Con_StaVencido		THEN 'VENCIDA'
									WHEN Con_StaPagado		THEN 'PAGADA'
									WHEN Con_StaCancelado	THEN 'CANCELADA'
									ELSE 'Estatus No Identificado'
				END,
				EsInversionS,
				'N'
		FROM INVERSIONES Inv
		WHERE  (Inv.Estatus IN(Con_StaVigente)  OR (Inv.Estatus = Con_StaPagado AND Inv.FechaVencimiento >= Par_IniMes
							AND Inv.FechaVencimiento <= Par_FinMes))
		ORDER BY Inv.ClienteID, Inv.InversionID;

		UPDATE TMPEDOCTARESUMCTA Edo, CLIENTES Cli
		SET Edo.SucursalID = Cli.SucursalOrigen
		WHERE Edo.ClienteID = Cli.ClienteID;


		-- Se actualiza el tipo de inversion
		UPDATE TMPEDOCTARESUMCTA Edo,		INVERSIONES Inv,		CATINVERSION Cat
		SET Edo.Etiqueta = IFNULL(Cat.Descripcion, Cadena_Vacia)
		WHERE Edo.CuentaAhoID = Inv.InversionID AND Inv.TipoInversionID = Cat.TipoInversionID;


		SET Var_FechaFin := LAST_DAY(Par_IniMes);

		DROP TABLE IF EXISTS TMPEDOCTARESUM;

		CREATE TEMPORARY TABLE TMPEDOCTARESUM (
			`ClienteID`					INT(11),
			`InversionID`				INT(11),
			`SaldoActual`				DECIMAL(14,2),
			`SaldoMesAnterior`			DECIMAL(14,2),
			`SaldoPromedio`				DECIMAL(14,2)
		);

		INSERT INTO TMPEDOCTARESUM(
									ClienteID,				InversionID,				SaldoActual,				SaldoMesAnterior,					SaldoPromedio
		)
		SELECT 						tmpEdoResumS.ClienteID, tmpEdoResumS.CuentaAhoID,	tmpEdoResumS.SaldoActual,	tmpEdoResumS.SaldoMesAnterior,		tmpEdoResumS.SaldoPromedio
		FROM					TMPEDOCTARESUMCTA tmpEdoResumS
		WHERE EsInversion = EsInversionS;


		UPDATE TMPEDOCTARESUM tmpEdoResum INNER JOIN INVERSIONES Inv ON tmpEdoResum.InversionID = Inv.InversionID
		SET 	tmpEdoResum.SaldoActual = IF(Inv.Estatus != Con_StaPagado,
														IF(Inv.FechaInicio > Par_FinMes AND Inv.FechaVencimiento > Par_FinMes, Moneda_Cero ,
															IF(Inv.FechaInicio < Par_IniMes AND Inv.FechaVencimiento < Par_IniMes, Moneda_Cero ,
																IFNULL(Inv.Monto, Moneda_Cero)
															)
														)
														,

														Moneda_Cero)


		,
				tmpEdoResum.SaldoMesAnterior = 		IF (Inv.FechaInicio >= Par_IniMes AND Inv.FechaVencimiento >= Par_FinMes AND Inv.Estatus != Con_StaPagado,
														Moneda_Cero,
														IF(Inv.FechaInicio >= Par_IniMes AND Inv.FechaVencimiento <= Par_FinMes AND Inv.Estatus = Con_StaPagado,
															Moneda_Cero,
																IF(Inv.FechaInicio >= Par_IniMes AND Inv.FechaVencimiento >= Par_FinMes AND Inv.Estatus = Con_StaPagado,
																	Moneda_Cero,
																	IF(Inv.FechaInicio >= Par_IniMes AND Inv.FechaVencimiento <= Par_FinMes AND Inv.Estatus != Con_StaPagado,
																		Moneda_Cero,
																		IF(Inv.FechaInicio <= Par_IniMes AND Inv.FechaVencimiento >= Par_FinMes AND  Inv.Estatus != Con_StaPagado ,
																			Inv.Monto,
																			IF(Inv.FechaInicio <= Par_IniMes AND Inv.FechaVencimiento  <= Par_FinMes AND  Inv.Estatus = Con_StaPagado,
																				Inv.Monto,
																					IF(Inv.FechaInicio <= Par_IniMes AND Inv.FechaVencimiento  <= Par_FinMes AND  Inv.Estatus != Con_StaPagado,
																						Moneda_Cero,
																						Moneda_Cero
																					)
																				)
																			)
																		)
																)
															)
														),


				tmpEdoResum.SaldoPromedio =			IF(Inv.FechaInicio >= Par_IniMes AND Inv.FechaInicio < Par_FinMes  AND Inv.FechaVencimiento >= Par_FinMes,
															((TIMESTAMPDIFF(DAY,Par_IniMes , Inv.FechaInicio) * Entero_Cero) + ((TIMESTAMPDIFF(DAY,Inv.FechaInicio ,  Par_FinMes) + Entero_Uno) * Inv.Monto) ) /  (TIMESTAMPDIFF(DAY,Par_IniMes ,  Par_FinMes) + Entero_Uno)
														,
															IF(Inv.FechaInicio < Par_IniMes AND Inv.FechaVencimiento >= Par_FinMes,
																( (TIMESTAMPDIFF(DAY,Par_IniMes ,  Par_FinMes) + Entero_Uno) * Inv.Monto) / (TIMESTAMPDIFF(DAY,Par_IniMes ,  Par_FinMes) + Entero_Uno)
																,
																	IF(Inv.FechaInicio < Par_IniMes AND Inv.FechaVencimiento <= Par_FinMes AND Inv.FechaVencimiento <Par_IniMes,
																		Moneda_Cero,
																			IF(Inv.FechaInicio < Par_IniMes AND Inv.FechaVencimiento <= Par_FinMes,
																			 (((TIMESTAMPDIFF(DAY, Par_IniMes,  Inv.FechaVencimiento) + Entero_Uno) * Inv.Monto) + (TIMESTAMPDIFF(DAY,Inv.FechaVencimiento , Par_FinMes) * Entero_Cero)) / (TIMESTAMPDIFF(DAY,Par_IniMes ,  Par_FinMes) + Entero_Uno)
																				,
																					IF(Inv.FechaInicio >= Par_IniMes AND Inv.FechaVencimiento <= Par_FinMes,

																					( (TIMESTAMPDIFF(DAY,Par_IniMes ,   Inv.FechaInicio) * Entero_Cero) + ((TIMESTAMPDIFF(DAY,Inv.FechaInicio,   Inv.FechaVencimiento) + Entero_Uno) *  Inv.Monto) + (TIMESTAMPDIFF(DAY,Inv.FechaVencimiento,  Par_FinMes) * Entero_Cero) ) /   (TIMESTAMPDIFF(DAY,Par_IniMes ,  Par_FinMes) + Entero_Uno)
																						,
																						Moneda_Cero
																					)
																			)
																	)

															)
													);





		UPDATE TMPEDOCTARESUMCTA tmpEdoCta, TMPEDOCTARESUM tmpEdoResum
		SET tmpEdoCta.SaldoActual = tmpEdoResum.SaldoActual,
			tmpEdoCta.SaldoMesAnterior =tmpEdoResum.SaldoMesAnterior,
			tmpEdoCta.SaldoPromedio = tmpEdoResum.SaldoPromedio
		WHERE tmpEdoCta.CuentaAhoID = tmpEdoResum.InversionID
		AND tmpEdoCta.ClienteID = tmpEdoResum.ClienteID;

		INSERT INTO EDOCTARESUMCTA(
											AnioMes,				SucursalID,						ClienteID,				CuentaAhoID,						MonedaID,
											MonedaDescri,			Etiqueta,						Depositos,				Retiros,							Interes,
											ISR,					SaldoActual,					SaldoMesAnterior,		SaldoPromedio,						TasaBruta,
											Estatus,				GAT,							CLABE,					TipoCuentaID,						SaldoMInReq,
											Comisiones,				GatInformativo,					ParteSocial,			GeneraInteres
		)SELECT
											AnioMes,				SucursalID,						ClienteID,				CuentaAhoID,						MonedaID,
											MonedaDescri,			Etiqueta,						Moneda_Cero,			Moneda_Cero,						Moneda_Cero,
											Moneda_Cero,			SaldoActual,					SaldoMesAnterior,		SaldoPromedio,						Moneda_Cero,
											Estatus,				Moneda_Cero,					Cadena_Vacia,			Entero_Cero,						Moneda_Cero,
											Moneda_Cero,			Moneda_Cero,					Moneda_Cero,			GeneraInteres
		FROM TMPEDOCTARESUMCTA;

END TerminaStore$$