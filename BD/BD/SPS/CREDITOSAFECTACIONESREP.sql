-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOSAFECTACIONESREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOSAFECTACIONESREP`;

DELIMITER $$
CREATE PROCEDURE `CREDITOSAFECTACIONESREP`(
	-- Store Procedure para el reporte de Creditos con Afectacion de Garantia Periodico
	--  Modulo Cartera Agro --> Reportes --> Creditos con Afectacion de Garantia Periodico
	Par_FechaInicio			DATE,			-- Fecha Inicio del Reporte
	Par_FechaFin			DATE,			-- Fecha Fin del Reporte
	Par_SucursalID			INT(11),		-- ID Sucursal
	Par_ProductoCreditoID	INT(11),		-- ID Producto de Credito Agropecuario
	Par_TipoGarantiaID		INT(11),		-- ID Tipo Garantia

	Par_NumeroReporte		TINYINT UNSIGNED,-- Numero de Reporte

	-- Parametros de Auditoria
	Aud_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Sentencia		VARCHAR(5000);		-- Sentencia de Ejecucion
	DECLARE Var_FechaSistema	DATE;				-- Fecha de Sistema
	DECLARE Var_FechaCorte		DATE;				-- Fecha Corte del Credito
	DECLARE Var_FechaCorteCont	DATE;				-- Fecha Corte del Credito Contigente
	DECLARE Var_DiasCredito 	INT(11);			-- Dias del Credito

	-- Declaracion de Constantes
	DECLARE Reporte_Excel		TINYINT UNSIGNED;	-- Reporte_Excel
	DECLARE Tip_Activo			TINYINT UNSIGNED;	-- Creditos de Tipo Activo Residual
	DECLARE Tip_Contigente		TINYINT UNSIGNED;	-- Creditos de Tipo contigente
	DECLARE Cal_Capital			CHAR(1);			-- Creditos de Tipo Activo Residual
	DECLARE Cal_Interes			CHAR(1);			-- Creditos de Tipo contigente
	DECLARE Entero_Cero 		INT(11);			-- Constante Entero Cero
	DECLARE Cadena_Vacia 		CHAR(1);			-- Constante Cadena Vacia
	DECLARE Con_SI 				CHAR(1);			-- Constante SI
	DECLARE Cre_Pasivo 			CHAR(1);			-- Credito Pasivo
	DECLARE Cre_Contigente 		CHAR(1);			-- Credito Contigente
	DECLARE Est_Vigente			CHAR(1);			-- Constante Estatus Vigente
	DECLARE Cartera_Pasiva 		CHAR(1);			-- Constante Cartera Pasiva
	DECLARE Cartera_Contigente	CHAR(1);			-- Constante Cartera Contigente
	DECLARE Estatus_Castigado	CHAR(2);			-- Estatus castigado
	DECLARE Decimal_Cero		DECIMAL(16,2);		-- Constante Decimal Cero
	DECLARE Fecha_Vacia			DATE;				-- Constante Fecha Vacia

	-- Asignacion de Constantes
	SET Reporte_Excel	 		:= 1;
	SET Entero_Cero 			:= 0;
	SET Cadena_Vacia			:= '';
	SET Con_SI 					:= 'S';
	SET Tip_Activo		 		:= 1;
	SET Tip_Contigente	 		:= 2;
	SET Cal_Capital				:= 'C';
	SET Cal_Interes				:= 'I';
	SET Cre_Pasivo 				:= 'P';
	SET Cre_Contigente 			:= 'C';
	SET Est_Vigente 			:= 'V';
	SET Cartera_Pasiva 			:= 'P';
	SET Cartera_Contigente		:= 'C';
	SET Estatus_Castigado		:= 'CA';
	SET Decimal_Cero 			:= 0.00;
	SET Fecha_Vacia				:= '1900-01-01';

	-- Reporte Excel
	IF( Par_NumeroReporte = Reporte_Excel ) THEN

		SELECT FechaSistema,	DiasCredito
		INTO Var_FechaSistema,	Var_DiasCredito
		FROM PARAMETROSSIS LIMIT 1;

		SET Var_FechaCorte		:= Par_FechaFin;
		SET Var_FechaCorteCont	:= Par_FechaFin;

		-- Si la fecha de consulta es la fecha actual del sistema la fecha de consulta de los saldos es la ultima fecha corte
		IF( Var_FechaSistema = Par_FechaInicio OR Var_FechaSistema = Par_FechaFin ) THEN

			SELECT MAX(FechaCorte)
			INTO Var_FechaCorte
			FROM SALDOSCREDITOS;

			SELECT MAX(FechaCorte)
			INTO Var_FechaCorteCont
			FROM SALDOSCREDITOSCONT;

		END IF;

		DROP TABLE IF EXISTS TMP_CREDITOSAFECTACIONES;
		CREATE TEMPORARY TABLE TMP_CREDITOSAFECTACIONES(
			SucursalID 							INT(11),
			NombreSucursal 						VARCHAR(50),
			TipoCredito 						VARCHAR(50),
			CreditoActivo 						BIGINT(12),
			CreditoPasivo 						BIGINT(20),

			CreditoContigente					BIGINT(20),
			CreditoFondeador					BIGINT(20),
			CreditoPasivoContigente				BIGINT(20),
			Estatus 							VARCHAR(20),
			TipoGarantia 						VARCHAR(20),

			NombreCliente						VARCHAR(200),
			FuenteFondeoID 						INT(11),
			FuenteFondeo						VARCHAR(500),
			CausaPago							VARCHAR(500),
			CadenaProductiva					VARCHAR(500),

			MontoGarantia						DECIMAL(16,2),
			FechaGarantia						DATE,
			FechaAfectacion						VARCHAR(10),
			SaldoCapital						DECIMAL(16,2),
			SaldoInteres						DECIMAL(16,2),

			MontoTotalCapitalRecuperado			DECIMAL(16,2),
			MontoTotalInteresRecuperado			DECIMAL(16,2),
			MontoPendienteCapitalRecuperado		DECIMAL(16,2),
			MontoPendienteInteresRecuperado		DECIMAL(16,2),
			SaldoIncobrable						DECIMAL(16,2),

			TotalRecuperado						DECIMAL(16,2),
			Antiguedad							INT(11),
			ClienteID 							INT(11),
			CadenaProductivaID					INT(11),
			TipoGarantiaFIRAID 					INT(11),

			TipoCartera							CHAR(1),
			EstatusOriginal						CHAR(1),
			KEY `IDX_TMP_CREDITOSAFECTACIONES_1` (`CreditoActivo`),
			KEY `IDX_TMP_CREDITOSAFECTACIONES_2` (`ClienteID`),
			KEY `IDX_TMP_CREDITOSAFECTACIONES_3` (`SucursalID`),
			KEY `IDX_TMP_CREDITOSAFECTACIONES_4` (`CadenaProductivaID`),
			KEY `IDX_TMP_CREDITOSAFECTACIONES_5` (`TipoGarantiaFIRAID`),
			KEY `IDX_TMP_CREDITOSAFECTACIONES_6` (`FuenteFondeoID`),
			KEY `IDX_TMP_CREDITOSAFECTACIONES_7` (`EstatusOriginal`));

		DROP TABLE IF EXISTS TMP_PAGOCREDITOSAFECTACION;
		CREATE TEMPORARY TABLE TMP_PAGOCREDITOSAFECTACION(
			CreditoID 			BIGINT(12),
			FechaPago			VARCHAR(10),
			TipoCartera			CHAR(1),
			KEY `IDX_TMP_TMP_PAGOCREDITOSAFECTACION_1` (`CreditoID`,`TipoCartera`));

		DROP TABLE IF EXISTS TMP_PAGOCASTIGOCREDITOAFECTADO;
		CREATE TEMPORARY TABLE TMP_PAGOCASTIGOCREDITOAFECTADO(
			CreditoID 			BIGINT(12),
			FechaPago			DATE,
			TipoCartera			CHAR(1),
			KEY `TMP_PAGOCASTIGOCREDITOAFECTADO` (`CreditoID`,`TipoCartera`));

		SET Var_Sentencia := CONCAT('
		INSERT INTO TMP_CREDITOSAFECTACIONES(
			SucursalID,						NombreSucursal,						TipoCredito,						CreditoActivo,			CreditoPasivo,
			CreditoContigente,				CreditoFondeador,					CreditoPasivoContigente,
			Estatus,						TipoGarantia,
			NombreCliente,					FuenteFondeoID,
			FuenteFondeo,					CausaPago,							CadenaProductiva,
			MontoGarantia,
			FechaGarantia,					FechaAfectacion,					SaldoCapital,						SaldoInteres,			MontoTotalCapitalRecuperado,
			MontoTotalInteresRecuperado,	MontoPendienteCapitalRecuperado,	MontoPendienteInteresRecuperado,	SaldoIncobrable,		TotalRecuperado,
			Antiguedad, 					ClienteID,							CadenaProductivaID,					TipoGarantiaFIRAID,		TipoCartera,
			EstatusOriginal)
		SELECT ',
			'Cre.SucursalID,				"',Cadena_Vacia,'",					"ACTIVO RESIDUAL",					Cre.CreditoID,			',Entero_Cero,',
			Bita.CreditoContFondeador,		',Entero_Cero,',					Cre.CreditoID, ',
			'	CASE WHEN Cre.Estatus = "P" THEN "PA"
					 WHEN Cre.Estatus = "K" THEN "CA"
					 WHEN Cre.Estatus = "V" THEN "VI"
					 WHEN Cre.Estatus = "B" THEN "VE"
					 WHEN Cre.Estatus = "C" THEN "CL"
				END ,						"',Cadena_Vacia,'",',

			'"',Cadena_Vacia,'",			CASE WHEN Cre.TipoFondeo = "F" THEN Cre.InstitFondeoID ',
												'WHEN Cre.TipoFondeo = "P" THEN ',Entero_Cero,
											' END, ',
			'"RECURSOS PROPIOS",			UPPER(Bita.Observacion),			"',Cadena_Vacia,'",',
			'Bita.MontoGarApli,				Bita.FechaAplica,					"',Cadena_Vacia,'",',				Decimal_Cero,',	',			Decimal_Cero,', ',
			Decimal_Cero, ',',				Decimal_Cero, ',',					Decimal_Cero, ',',					Decimal_Cero, ',',			Decimal_Cero, ',',
			Decimal_Cero, ',',				'FLOOR(DATEDIFF("',Par_FechaFin,'", Bita.FechaAplica)/',Var_DiasCredito,'),			Cre.ClienteID, 			Cre.CadenaProductivaID,
		Cre.TipoGarantiaFIRAID, "P", Cre.Estatus ',
		'FROM BITACORAAPLIGAR Bita ');
		SET Var_Sentencia := CONCAT(Var_Sentencia, ' INNER JOIN CREDITOS Cre ON Cre.CreditoID = Bita.CreditoID ');

		SET Var_Sentencia := CONCAT(Var_Sentencia,'WHERE Bita.FechaAplica BETWEEN "', Par_FechaInicio ,'" AND "', Par_FechaFin, '"');
		SET Var_Sentencia := CONCAT(Var_Sentencia,'  AND Cre.EsAgropecuario = "',Con_SI ,'"');

		IF( Par_ProductoCreditoID <> Entero_Cero ) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Cre.ProductoCreditoID =',Par_ProductoCreditoID);
		END IF;

		IF( Par_SucursalID <> Entero_Cero ) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Cre.SucursalID =',Par_SucursalID);
		END IF;

		IF( Par_TipoGarantiaID <> Entero_Cero ) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Cre.TipoGarantiaFIRAID =',Par_TipoGarantiaID);
		END IF;

		SET Var_Sentencia := CONCAT(Var_Sentencia,' ORDER BY Cre.CreditoID, Cre.SucursalID, Bita.FechaAplica;');

		SET @Sentencia    = (Var_Sentencia);
		PREPARE STSALDOSCAPITALREP FROM @Sentencia;
		EXECUTE STSALDOSCAPITALREP;
		DEALLOCATE PREPARE STSALDOSCAPITALREP;


		SET Var_Sentencia := Cadena_Vacia;
		SET Var_Sentencia := CONCAT('
		INSERT INTO TMP_CREDITOSAFECTACIONES(
			SucursalID,						NombreSucursal,						TipoCredito,						CreditoActivo,			CreditoPasivo,
			CreditoContigente,				CreditoFondeador,					CreditoPasivoContigente,
			Estatus,						TipoGarantia,
			NombreCliente,					FuenteFondeoID,
			FuenteFondeo,					CausaPago,							CadenaProductiva,
			MontoGarantia,
			FechaGarantia,					FechaAfectacion,					SaldoCapital,						SaldoInteres,			MontoTotalCapitalRecuperado,
			MontoTotalInteresRecuperado,	MontoPendienteCapitalRecuperado,	MontoPendienteInteresRecuperado,	SaldoIncobrable,		TotalRecuperado,
			Antiguedad, 					ClienteID,							CadenaProductivaID,					TipoGarantiaFIRAID,		TipoCartera,
			EstatusOriginal)
		SELECT ',
			'Cred.SucursalID,				"',Cadena_Vacia,'",					"CONTIGENTE",						Cre.CreditoID,			',Entero_Cero,',
			Bita.CreditoContFondeador,		',Entero_Cero,',					Cre.CreditoID, ',
			'	CASE WHEN Cre.Estatus = "P" THEN "PA"
					 WHEN Cre.Estatus = "K" THEN "CA"
					 WHEN Cre.Estatus = "V" THEN "VI"
					 WHEN Cre.Estatus = "B" THEN "VE"
					 WHEN Cre.Estatus = "C" THEN "CL"
				END ,						"',Cadena_Vacia,'",',

			'"',Cadena_Vacia,'",			CASE WHEN Cre.TipoFondeo = "F" THEN Cre.InstitFondeoID ',
												'WHEN Cre.TipoFondeo = "P" THEN ',Entero_Cero,
											' END, ',
			'"RECURSOS PROPIOS",			UPPER(Bita.Observacion),			"',Cadena_Vacia,'",',
			'Bita.MontoGarApli,				Bita.FechaAplica,					"',Cadena_Vacia,'",',				Decimal_Cero,',	',			Decimal_Cero,', ',
			Decimal_Cero, ',',				Decimal_Cero, ',',					Decimal_Cero, ',',					Decimal_Cero, ',',			Decimal_Cero, ',',
			Decimal_Cero, ',',				'FLOOR(DATEDIFF("',Par_FechaFin,'", Bita.FechaAplica)/',Var_DiasCredito,'),				Cre.ClienteID, 			Cred.CadenaProductivaID,
		Cred.TipoGarantiaFIRAID, "C", Cre.Estatus ',
		'FROM BITACORAAPLIGAR Bita ');
		SET Var_Sentencia := CONCAT(Var_Sentencia, ' INNER JOIN CREDITOS Cred ON Cred.CreditoID = Bita.CreditoID ');
		SET Var_Sentencia := CONCAT(Var_Sentencia, ' INNER JOIN CREDITOSCONT Cre ON Cre.CreditoID = Cred.CreditoID ');

		SET Var_Sentencia := CONCAT(Var_Sentencia,'WHERE Bita.FechaAplica BETWEEN "', Par_FechaInicio ,'" AND "', Par_FechaFin, '"');
		SET Var_Sentencia := CONCAT(Var_Sentencia,'  AND Cred.EsAgropecuario = "',Con_SI ,'"');

		IF( Par_ProductoCreditoID <> Entero_Cero ) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Cre.ProductoCreditoID =',Par_ProductoCreditoID);
		END IF;

		IF( Par_SucursalID <> Entero_Cero ) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Cre.SucursalID =',Par_SucursalID);
		END IF;

		IF( Par_TipoGarantiaID <> Entero_Cero ) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Cred.TipoGarantiaFIRAID =',Par_TipoGarantiaID);
		END IF;

		SET Var_Sentencia := CONCAT(Var_Sentencia,' ORDER BY Cred.CreditoID, Cred.SucursalID, Bita.FechaAplica;');

		SET @Sentencia    = (Var_Sentencia);
		PREPARE STSALDOSCAPITALREP FROM @Sentencia;
		EXECUTE STSALDOSCAPITALREP;
		DEALLOCATE PREPARE STSALDOSCAPITALREP;

		-- Ultima Fecha de Pago del Credito Pasivo
		INSERT INTO TMP_PAGOCREDITOSAFECTACION(
				CreditoID,	FechaPago,	TipoCartera)
		SELECT 	CreditoID,	IFNULL(MAX(FechaPago) , Cadena_Vacia), Cartera_Pasiva
		FROM DETALLEPAGCRE
		WHERE CreditoID IN (SELECT CreditoActivo FROM TMP_CREDITOSAFECTACIONES WHERE TipoCartera = Cartera_Pasiva)
		GROUP BY CreditoID;

		-- Ultima Fecha de Pago del Credito Contigente
		INSERT INTO TMP_PAGOCREDITOSAFECTACION(
				CreditoID,	FechaPago,	TipoCartera)
		SELECT 	CreditoID,	IFNULL(MAX(FechaPago) , Cadena_Vacia),	Cartera_Contigente
		FROM DETALLEPAGCRECONT
		WHERE CreditoID IN (SELECT CreditoActivo FROM TMP_CREDITOSAFECTACIONES WHERE TipoCartera = Cartera_Contigente)
		GROUP BY CreditoID;

		-- Ultima Fecha de Pago del Credito Pasivo
		INSERT INTO TMP_PAGOCASTIGOCREDITOAFECTADO(
				CreditoID,	FechaPago,	TipoCartera)
		SELECT 	CreditoID,	IFNULL(MAX(Fecha) , Fecha_Vacia),	Cartera_Pasiva
		FROM CRECASTIGOSREC
		WHERE CreditoID IN (SELECT CreditoActivo FROM TMP_CREDITOSAFECTACIONES WHERE TipoCartera = Cartera_Pasiva AND Estatus = Estatus_Castigado)
		GROUP BY CreditoID;

		-- Ultima Fecha de Pago del Credito Contigente
		INSERT INTO TMP_PAGOCASTIGOCREDITOAFECTADO(
				CreditoID,	FechaPago,	TipoCartera)
		SELECT 	CreditoID,	IFNULL(MAX(Fecha) , Fecha_Vacia),	Cartera_Contigente
		FROM CRECASTIGOSRECCONT
		WHERE CreditoID IN (SELECT CreditoActivo FROM TMP_CREDITOSAFECTACIONES WHERE TipoCartera = Cartera_Contigente AND Estatus = Estatus_Castigado)
		GROUP BY CreditoID;

		-- Fecha de Ultimo Pago Cartera Pasiva
		UPDATE TMP_CREDITOSAFECTACIONES Tmp, INSTITUTFONDEO Cre SET
			Tmp.FuenteFondeo = Cre.NombreInstitFon
		WHERE Tmp.FuenteFondeoID <> Entero_Cero
		  AND Tmp.FuenteFondeoID = Cre.InstitutFondID;

		-- Fecha de Ultimo Pago Cartera Pasiva
		UPDATE TMP_CREDITOSAFECTACIONES Tmp, TMP_PAGOCREDITOSAFECTACION Cre SET
			Tmp.FechaAfectacion = Cre.FechaPago
		WHERE Tmp.CreditoActivo = Cre.CreditoID
		  AND Tmp.TipoCartera = Cre.TipoCartera;

		-- Nombre Completo de Cliente
		UPDATE TMP_CREDITOSAFECTACIONES Tmp, CLIENTES Cli SET
			Tmp.NombreCliente = Cli.NombreCompleto
		WHERE Tmp.ClienteID = Cli.ClienteID;

		-- Nombre de la Sucursal
		UPDATE TMP_CREDITOSAFECTACIONES Tmp, SUCURSALES Suc SET
			Tmp.NombreSucursal = Suc.NombreSucurs
		WHERE Tmp.SucursalID = Suc.SucursalID;

		-- Tipo de Garantia Fira
		UPDATE TMP_CREDITOSAFECTACIONES Tmp, CATTIPOGARANTIAFIRA Cat SET
			Tmp.TipoGarantia = Cat.Descripcion
		WHERE Tmp.TipoGarantiaFIRAID = Cat.TipoGarantiaID;

		-- Catalogo de Cadena Productiva
		UPDATE TMP_CREDITOSAFECTACIONES Tmp, CATCADENAPRODUCTIVA Cat SET
			Tmp.CadenaProductiva = Cat.NomCadenaProdSCIAN
		WHERE Tmp.CadenaProductivaID = Cat.CveCadena;

		-- DI Credito Pasivo
		UPDATE TMP_CREDITOSAFECTACIONES Tmp, RELCREDPASIVOAGRO Cre SET
			Tmp.CreditoPasivo = Cre.CreditoFondeoID
		WHERE Tmp.CreditoActivo =  Cre.CreditoID
		  AND Cre.EstatusRelacion = Est_Vigente;

		-- Monto Pendiente Recuperar Capital y Monto Pendiente Recuperar Interes Pasivos
		UPDATE TMP_CREDITOSAFECTACIONES Tmp, SALDOSCREDITOS Sal SET
			Tmp.SaldoCapital = (IFNULL(Sal.SalCapVigente, Entero_Cero) + IFNULL(Sal.SalCapAtrasado, Entero_Cero) +
								IFNULL(Sal.SalCapVencido, Entero_Cero) + IFNULL(Sal.SalCapVenNoExi, Entero_Cero)),
			Tmp.SaldoInteres = (IFNULL(Sal.SalIntOrdinario, Entero_Cero) + IFNULL(Sal.SalIntAtrasado, Entero_Cero) +
								IFNULL(Sal.SalIntVencido, Entero_Cero) + IFNULL(Sal.SalIntProvision, Entero_Cero) +
								IFNULL(Sal.SalIntNoConta, Entero_Cero)    + IFNULL(Sal.SalMoratorios, Entero_Cero) +
								IFNULL(Sal.SaldoMoraVencido, Entero_Cero) + IFNULL(Sal.SaldoMoraCarVen, Entero_Cero))
		WHERE Tmp.CreditoActivo =  Sal.CreditoID
		  AND Sal.FechaCorte = Var_FechaCorte
		  AND Tmp.TipoCartera = Cre_Pasivo;

		-- Monto Pendiente Recuperar Capital y Monto Pendiente Recuperar Interes Contigentes
		UPDATE TMP_CREDITOSAFECTACIONES Tmp, SALDOSCREDITOSCONT Sal SET
			Tmp.SaldoCapital = (IFNULL(Sal.SalCapVigente, Entero_Cero) + IFNULL(Sal.SalCapAtrasado, Entero_Cero) +
								IFNULL(Sal.SalCapVencido, Entero_Cero) + IFNULL(Sal.SalCapVenNoExi, Entero_Cero)),
			Tmp.SaldoInteres = (IFNULL(Sal.SalIntOrdinario, Entero_Cero) + IFNULL(Sal.SalIntAtrasado, Entero_Cero) +
								IFNULL(Sal.SalIntVencido, Entero_Cero) + IFNULL(Sal.SalIntProvision, Entero_Cero) +
								IFNULL(Sal.SalIntNoConta, Entero_Cero)  + IFNULL(Sal.SalMoratorios, Entero_Cero) +
								IFNULL(Sal.SaldoMoraVencido, Entero_Cero) + IFNULL(Sal.SaldoMoraCarVen, Entero_Cero))
		WHERE Tmp.CreditoActivo =  Sal.CreditoID
		  AND Sal.FechaCorte = Var_FechaCorteCont
		  AND Tmp.TipoCartera = Cre_Contigente;

		-- ID Credito Fondeador
		UPDATE TMP_CREDITOSAFECTACIONES Tmp, SOLICITUDCREDITO Sol SET
			Tmp.CreditoFondeador = IFNULL(Sol.CreditoIDFIRA, Entero_Cero)
		WHERE Tmp.CreditoActivo = Sol.CreditoID;

		-- Saldo Incobrable Cartera Pasiva
		UPDATE TMP_CREDITOSAFECTACIONES Tmp, CRECASTIGOS Cre SET
			Tmp.SaldoIncobrable = (Cre.SaldoCapital + Cre.SaldoInteres + Cre.SaldoMoratorio + Cre.SaldoAccesorios),
			Tmp.TotalRecuperado = Cre.TotalCastigo - (Cre.SaldoCapital + Cre.SaldoInteres + Cre.SaldoMoratorio + Cre.SaldoAccesorios),
			Tmp.MontoTotalCapitalRecuperado = (Cre.CapitalCastigado - Cre.SaldoCapital),
			Tmp.MontoTotalInteresRecuperado = (Cre.InteresCastigado +Cre.IntMoraCastigado) -
											  ( Cre.SaldoInteres + Cre.SaldoMoratorio + Cre.SaldoAccesorios)
		WHERE Tmp.CreditoActivo = Cre.CreditoID
		  AND Tmp.Estatus = Estatus_Castigado
		  AND Tmp.TipoCartera = Cre_Pasivo;

		-- Saldo Incobrable Cartera Contigente
		UPDATE TMP_CREDITOSAFECTACIONES Tmp, CRECASTIGOSCONT Cre SET
			Tmp.SaldoIncobrable = (Cre.SaldoCapital + Cre.SaldoInteres + Cre.SaldoMoratorio + Cre.SaldoAccesorios),
			Tmp.MontoTotalCapitalRecuperado = (Cre.CapitalCastigado - Cre.SaldoCapital),
			Tmp.MontoTotalInteresRecuperado = (Cre.InteresCastigado +Cre.IntMoraCastigado) -
											  (Cre.SaldoInteres + Cre.SaldoMoratorio + Cre.SaldoAccesorios)
		WHERE Tmp.CreditoActivo = Cre.CreditoID
		  AND Tmp.Estatus = Estatus_Castigado
		  AND Tmp.TipoCartera = Cre_Contigente;

		-- Saldo Capital e Interes Cartera Pasiva cuando el estatus es 'K'
		UPDATE TMP_CREDITOSAFECTACIONES Tmp, CRECASTIGOS Cre SET
			Tmp.SaldoCapital = IFNULL(Cre.SaldoCapital, Entero_Cero),
			Tmp.SaldoInteres = IFNULL(Cre.SaldoInteres, Entero_Cero)
		WHERE Tmp.CreditoActivo = Cre.CreditoID
		  AND Tmp.Estatus = Estatus_Castigado
		  AND Tmp.TipoCartera = Cre_Pasivo
		  AND Tmp.SaldoCapital = Entero_Cero
		  AND Tmp.SaldoInteres = Entero_Cero;

		-- Saldo Incobrable Cartera Contigente
		UPDATE TMP_CREDITOSAFECTACIONES Tmp, CRECASTIGOSCONT Cre SET
			Tmp.SaldoCapital = IFNULL(Cre.SaldoCapital, Entero_Cero),
			Tmp.SaldoInteres = IFNULL(Cre.SaldoInteres, Entero_Cero)
		WHERE Tmp.CreditoActivo = Cre.CreditoID
		  AND Tmp.Estatus = Estatus_Castigado
		  AND Tmp.TipoCartera = Cre_Contigente
		  AND Tmp.SaldoCapital = Entero_Cero
		  AND Tmp.SaldoInteres = Entero_Cero;

		-- Fecha de Ultimo Pago Cartera Pasiva
		UPDATE TMP_CREDITOSAFECTACIONES Tmp, TMP_PAGOCASTIGOCREDITOAFECTADO Cre SET
			Tmp.FechaAfectacion = Cre.FechaPago
		WHERE Tmp.CreditoActivo = Cre.CreditoID
		  AND Tmp.TipoCartera = Cre.TipoCartera;

		-- Actualizacion de Campos Monto pagados y recuperados
		UPDATE TMP_CREDITOSAFECTACIONES SET
			MontoPendienteCapitalRecuperado = SaldoCapital,
			MontoPendienteInteresRecuperado = SaldoInteres,
			MontoTotalCapitalRecuperado = FNCREDAFECTAGARAGRO(CreditoActivo, Par_FechaInicio, Par_FechaFin,
															  Cal_Capital, CASE WHEN TipoCartera = Cre_Pasivo THEN Tip_Activo
																				 WHEN TipoCartera = Cre_Contigente THEN Tip_Contigente END) +
										  MontoTotalCapitalRecuperado,
			MontoTotalInteresRecuperado = FNCREDAFECTAGARAGRO(CreditoActivo, Par_FechaInicio, Par_FechaFin,
															  Cal_Interes, CASE WHEN TipoCartera = Cre_Pasivo THEN Tip_Activo
																				 WHEN TipoCartera = Cre_Contigente THEN Tip_Contigente END) +
										  MontoTotalInteresRecuperado,
			TotalRecuperado = MontoTotalCapitalRecuperado +MontoTotalInteresRecuperado;

		SET @Registro := Entero_Cero;
		SELECT @Registro:=(@Registro+1) AS Consecutivo,	NombreSucursal,						TipoCredito,						CreditoActivo,		CreditoPasivo,
			CreditoContigente,							CreditoFondeador,					CreditoPasivoContigente,			Estatus,			TipoGarantia,
			NombreCliente,								FuenteFondeo,						CausaPago,							CadenaProductiva,	MontoGarantia,
			FechaGarantia,								FechaAfectacion,					SaldoCapital,						SaldoInteres,		MontoTotalCapitalRecuperado,
			MontoTotalInteresRecuperado,				MontoPendienteCapitalRecuperado,	MontoPendienteInteresRecuperado,	SaldoIncobrable,	TotalRecuperado,
			Antiguedad
		FROM TMP_CREDITOSAFECTACIONES
		ORDER BY CreditoActivo;

		DROP TABLE IF EXISTS TMP_CREDITOSAFECTACIONES;
		DROP TABLE IF EXISTS TMP_PAGOCREDITOSAFECTACION;
		DROP TABLE IF EXISTS TMP_PAGOCASTIGOCREDITOAFECTADO;
	END IF;

END TerminaStore$$