-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LIMEXEFECLIMES015REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `LIMEXEFECLIMES015REP`;
DELIMITER $$


CREATE PROCEDURE `LIMEXEFECLIMES015REP`(
	Par_FechaInicio			DATE,
	Par_FechaFin			DATE,
	Par_Monto				DECIMAL(18,4),
	Par_TipoPersona			VARCHAR(2),

	Par_NumRep				TINYINT UNSIGNED,
	Par_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATE,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT

	)

TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_FecFinMes		DATE;				-- Variable Fecha Fin Mes
	DECLARE Var_FechaSis		DATE;				-- Variable Fecha Sistema
	DECLARE Var_FecIniMes		DATE;				-- Variable Fecha Inicio Mes
	DECLARE Var_LimFisica		DECIMAL(12,2);		-- Variable Limite Persona Fisica
	DECLARE Var_LimMes			DECIMAL(12,2);		-- Variable Limite Persona Fisica Moral

	DECLARE Var_LimMoral 		DECIMAL(12,2);		-- Variable Limite Persona Moral
	DECLARE Var_MonedaID		INT(11);			-- Variable Numero Moneda
	DECLARE Var_TipoCambio		DECIMAL(14,2);		-- Variable Tipo Cambio

	-- Declaracion de constantes
	DECLARE Cadena_Vacia		CHAR(1);			-- Cadena o String Vacio
	DECLARE Decimal_Cero		DECIMAL(12,2);		-- Decimal en Cero
	DECLARE DiaUnoDelMes		CHAR(2);			-- Constante 01 sirve para concatenar la fecha inicio de mes -
	DECLARE Entero_Cero			INT;				-- Entero en Cero
	DECLARE EstatusVigente		CHAR(1);			-- Estatus Vigente

	DECLARE Fecha_Vacia			DATE;				-- Fecha Vacia
	DECLARE Nat_Abono			CHAR(1);			-- Naturaleza Abono
	DECLARE Nat_Cargo			CHAR(1);			-- Naturaleza Cargo
	DECLARE Per_Fisica			CHAR(1);			-- Tipo de Persona: Fisica
    DECLARE Per_Moral			CHAR(1);			-- Tipo de Persona: Moral
    DECLARE Per_FMoral			CHAR(1);			-- Tipo de Persona: Fisica Moral

	DECLARE Pro_AgruOpEfe		INT;

	DECLARE Rep_LimExcep		INT(11);			-- Reporte de Operaciones con Limites Excedidos
	DECLARE SalidaSi			CHAR(1);			-- Salida Si


	-- Asignacion de Constantes
	SET Cadena_Vacia			:= '';				-- Cadena o String Vacio
	SET Decimal_Cero			:= 0.0;				-- Decimal en Cero
	SET DiaUnoDelMes			:= '01';			-- Constante 01 sirve para concatenar la fecha inicio de mes --
	SET Entero_Cero				:= 0;				-- Entero en Cero
	SET EstatusVigente			:= 'V';				-- Estatus Vigente

	SET Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
	SET Nat_Abono				:= 'A';				-- Naturaleza Abono
	SET Nat_Cargo				:= 'C';				-- Naturaleza Cargo
	SET Per_Fisica				:= 'F';				-- Tipo de Persona: Fisica
    SET Per_Moral				:= 'M';				-- Tipo de Persona: Moral

    SET Per_FMoral				:= 'T';				-- Tipo de Persona: Fisica Moral
	SET Pro_AgruOpEfe 			:= 504;				-- Proceso de Agrupamiento de Operaciones en Efectivo que Rebasan LImites, tabla PROCESOSBATCH
	SET Rep_LimExcep			:= 1;				-- reporte limite excepcion
	SET SalidaSi				:= 'S';				-- Salida Si

	IF(Par_NumRep = Rep_LimExcep) THEN
		SET Var_FechaSis := (SELECT FechaSistema FROM PARAMETROSSIS);

		-- Fecha de Inicio de Mes
		-- Fecha de Fin de Mes
		SET	Var_FecIniMes			:= DATE(CONCAT(CAST(EXTRACT(YEAR FROM Var_FechaSis) AS CHAR),'-',CAST(EXTRACT(MONTH FROM Var_FechaSis) AS CHAR),'-',DiaUnoDelMes ));
		SET	Var_FecFinMes			:= DATE_ADD(Var_FecIniMes,INTERVAL 1 MONTH);
		SET	Var_FecFinMes			:= DATE_ADD(Var_FecFinMes,INTERVAL -1 DAY);
		-- Obtencion de los Montos Limites Mensuales
			SELECT MontoLimEfecF,	MontoLimEfecM,	MontoLimEfecMes,	MontoLimMonedaID
				INTO Var_LimFisica, Var_LimMoral, 	Var_LimMes, 		Var_MonedaID
					FROM PARAMPLDOPEEFEC
						WHERE Estatus = EstatusVigente;

		IF(Par_FechaFin >= Var_FechaSis) THEN


			# Obtener Tipo de Cambio del Dia anterior o la ultima capturada
			SELECT ROUND(TipCamDof, 2)
				INTO Var_TipoCambio
					FROM `HIS-MONEDAS`
						WHERE MonedaID = Var_MonedaID
						ORDER BY FechaActual DESC LIMIT 1;

			# Si no hay Tipo de Cambio de dias anteriores, se obtiene el del dia actual
			IF IFNULL(Var_TipoCambio , Entero_Cero) = Entero_Cero THEN
				SELECT ROUND(TipCamDof, 2)
					INTO Var_TipoCambio
						FROM MONEDAS
							WHERE MonedaID = Var_MonedaID
							ORDER BY FechaActual DESC LIMIT 1;
			END IF;

			# Se convierten los Montos Limites de Reversa, segÃºn el tipo de Cambio de la Moneda a que pertenece
			SET Var_LimFisica := (IFNULL(Var_LimFisica,Decimal_Cero) * IFNULL(Var_TipoCambio,Decimal_Cero));
			SET Var_LimMoral := (IFNULL(Var_LimMoral,Decimal_Cero) * IFNULL(Var_TipoCambio,Decimal_Cero));
			SET Var_LimMes := (IFNULL(Var_LimMes,Decimal_Cero) * IFNULL(Var_TipoCambio,Decimal_Cero));

			-- Tabla Temporal Para Almacenar Clientes que Superan los Limites Mensuales
			-- para AGrupamiento de Operaciones
			DROP TABLE IF EXISTS LIMOPERCLI;
			CREATE TEMPORARY TABLE LIMOPERCLI(
				RegistroID BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
				ClienteID		INT(11),
                NombreCompleto	VARCHAR(200),
                CuentaAhoID		BIGINT(20),
                DescripcionMov	VARCHAR(150),
				CantidadMov		DECIMAL(12,2),
				Fecha			DATE,
				NatMovimiento	CHAR(1),
				MontoMes		DECIMAL(12,2),
				TipoPersona		CHAR(1),
				LimOrigen		DECIMAL(12,2),
                SucursalID		INT(11),
                NumTransaccion	BIGINT(20),
				INDEX(RegistroID)
			);
			IF (IFNULL(Par_TipoPersona,Cadena_Vacia) = Per_Fisica )THEN
				#Clientes FISICAS, que rebasan su limite de Operacion
				INSERT INTO	LIMOPERCLI (
						ClienteID,	NombreCompleto,	CuentaAhoID,	DescripcionMov,		CantidadMov,
						Fecha,		NatMovimiento,	MontoMes,		TipoPersona,		LimOrigen,
						SucursalID,	NumTransaccion)
				SELECT
						cli.ClienteID, cli.NombreCompleto,	mov.CuentaAhoID,	mov.DescripcionMov,		mov.CantidadMov,
						mov.Fecha,		mov.NatMovimiento,	mov.CantidadMov AS MontoMes,	cli.TipoPersona,	Var_LimFisica,
						SucursalID,		mov.NumTransaccion
				FROM CUENTASAHOMOV mov
				INNER JOIN TIPOSMOVSAHO tMov ON mov.TipoMovAhoID =  tMov.TipoMovAhoID
				INNER JOIN CUENTASAHO cta ON mov.CuentaAhoID = cta.CuentaAhoID
				INNER JOIN CLIENTES cli ON cta.ClienteID = cli.ClienteID
				WHERE tMov.EsEfectivo ='S' AND mov.Fecha BETWEEN Var_FecIniMes AND Var_FecFinMes
				AND cli.TipoPersona = Per_Fisica
				HAVING MontoMes >= Var_LimFisica;
			END IF;

            IF (IFNULL(Par_TipoPersona,Cadena_Vacia) = Per_Moral )THEN
				#Clientes MORALES, que rebasan su limite de Operacion
				INSERT INTO LIMOPERCLI (
						ClienteID,	NombreCompleto,	CuentaAhoID,	DescripcionMov,	CantidadMov,
						Fecha,		NatMovimiento,	MontoMes,		TipoPersona,	LimOrigen,
						SucursalID,NumTransaccion)
				SELECT
						cli.ClienteID,	cli.NombreCompleto,	mov.CuentaAhoID,	mov.DescripcionMov,		mov.CantidadMov,
						mov.Fecha,		mov.NatMovimiento,	CantidadMov AS MontoMes,	cli.TipoPersona,	Var_LimMoral,
						cta.SucursalID,	mov.NumTransaccion
				FROM CUENTASAHOMOV mov
				INNER JOIN TIPOSMOVSAHO tMov ON mov.TipoMovAhoID =  tMov.TipoMovAhoID
				INNER JOIN CUENTASAHO cta ON mov.CuentaAhoID = cta.CuentaAhoID
				INNER JOIN CLIENTES cli ON cta.ClienteID = cli.ClienteID
				WHERE tMov.EsEfectivo ='S' AND mov.Fecha BETWEEN Var_FecIniMes AND Var_FecFinMes
				AND cli.TipoPersona != Per_Fisica
				HAVING MontoMes >= Var_LimMoral;
			END IF;

			IF (IFNULL(Par_TipoPersona,Cadena_Vacia) = Per_FMoral )THEN
				#Clientes FISICAS MORALES, que rebasan su limite de Operacion
				INSERT INTO LIMOPERCLI (
						ClienteID,	NombreCompleto,	CuentaAhoID,	DescripcionMov,	CantidadMov,
						Fecha,		NatMovimiento,	MontoMes,		TipoPersona,	LimOrigen,
						SucursalID,NumTransaccion)
				SELECT
					cli.ClienteID,	cli.NombreCompleto,	mov.CuentaAhoID,	mov.DescripcionMov,		mov.CantidadMov,
					mov.Fecha,		mov.NatMovimiento,	mov.CantidadMov AS MontoMes,	cli.TipoPersona,	Var_LimMes,
					cta.SucursalID, mov.NumTransaccion
				FROM CUENTASAHOMOV mov
				INNER JOIN CUENTASAHO cta ON mov.CuentaAhoID = cta.CuentaAhoID
				INNER JOIN TIPOSMOVSAHO tMov ON mov.TipoMovAhoID =  tMov.TipoMovAhoID
				INNER JOIN CLIENTES cli ON cta.ClienteID = cli.ClienteID
				WHERE	tMov.EsEfectivo ='S' AND mov.Fecha BETWEEN Var_FecIniMes AND Var_FecFinMes
				HAVING MontoMes >= Var_LimMes;
			END IF;
			#Agrupamiento de Operaciones que Rebasan los Montos Limites Mensuales
			SELECT
				lim.NombreCompleto AS NombreCliente,		lim.CuentaAhoID,		lim.DescripcionMov AS DescripcionOp,	FORMAT(CASE WHEN lim.NatMovimiento = Nat_Cargo
																															THEN lim.CantidadMov
																															ELSE Decimal_Cero
																															END,2) AS Cargo,					FORMAT(CASE WHEN lim.NatMovimiento = Nat_Abono
																																								THEN lim.CantidadMov
																																								ELSE Decimal_Cero
																																								END,2)AS Abono,
				FORMAT(lim.MontoMes,2) AS SaldoMes,			SUC.NombreSucurs,		lim.Fecha,								FORMAT(lim.LimOrigen,2) AS LimOrigen,	lim.NumTransaccion
				FROM LIMOPERCLI lim
				INNER JOIN SUCURSALES AS SUC ON lim.SucursalID = SUC.SucursalID
				WHERE lim.CantidadMov > Decimal_Cero
				ORDER BY lim.ClienteID, lim.CuentaAhoID;
			DROP TABLE IF EXISTS LIMOPERCLI;
		ELSE

		SET	Var_FecIniMes			:= Par_FechaInicio;
		SET	Var_FecFinMes			:= DATE_ADD(Var_FecIniMes,INTERVAL 1 MONTH);
		SET	Var_FecFinMes			:= DATE_ADD(Var_FecFinMes,INTERVAL -1 DAY);


			# Obtener Tipo de Cambio del Dia anterior o la ultima capturada
			SELECT ROUND(TipCamDof, 2)
				INTO Var_TipoCambio
					FROM `HIS-MONEDAS` AS HIS
						WHERE MonedaID = Var_MonedaID
						AND HIS.FechaRegistro <= Par_FechaFin
						ORDER BY FechaActual DESC LIMIT 1;

			# Si no hay Tipo de Cambio de dias anteriores, se obtiene el del dia actual
			IF IFNULL(Var_TipoCambio , Entero_Cero) = Entero_Cero THEN
				SELECT ROUND(TipCamDof, 2)
					INTO Var_TipoCambio
						FROM MONEDAS
							WHERE MonedaID = Var_MonedaID
							ORDER BY FechaActual DESC LIMIT 1;
			END IF;


			# Se convierten los Montos Limites de Reversa, segÃºn el tipo de Cambio de la Moneda a que pertenece
			SET Var_LimFisica := (IFNULL(Var_LimFisica,Decimal_Cero) * IFNULL(Var_TipoCambio,Decimal_Cero));
			SET Var_LimMoral := (IFNULL(Var_LimMoral,Decimal_Cero) * IFNULL(Var_TipoCambio,Decimal_Cero));
			SET Var_LimMes := (IFNULL(Var_LimMes,Decimal_Cero) * IFNULL(Var_TipoCambio,Decimal_Cero));

			-- Tabla Temporal Para Almacenar Clientes que Superan los Limites Mensuales
			-- para AGrupamiento de Operaciones
			DROP TABLE IF EXISTS LIMOPERCLI;
			CREATE TEMPORARY TABLE LIMOPERCLI(
				RegistroID BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
				ClienteID		INT(11),
                NombreCompleto	VARCHAR(200),
                CuentaAhoID		BIGINT(20),
                DescripcionMov	VARCHAR(150),
                CantidadMov		DECIMAL(12,2),
				Fecha			DATE,
				NatMovimiento	CHAR(1),
				MontoMes		DECIMAL(12,2),
				TipoPersona		CHAR(1),
				LimOrigen		DECIMAL(12,2),
				SucursalID		INT(12),
                NumTransaccion	BIGINT(20),
				INDEX(RegistroID)
			);

			IF (IFNULL(Par_TipoPersona,Cadena_Vacia) = Per_Fisica )THEN
				#Clientes FISICAS, que rebasan su limite de Operacion
				INSERT INTO	LIMOPERCLI (
						ClienteID,	NombreCompleto,	CuentaAhoID,	DescripcionMov,	CantidadMov,
						Fecha,		NatMovimiento,	MontoMes,		TipoPersona,	LimOrigen,
						SucursalID, NumTransaccion)
					SELECT
						cli.ClienteID,	cli.NombreCompleto,	mov.CuentaAhoID,	mov.DescripcionMov,	mov.CantidadMov,
						mov.Fecha,		mov.NatMovimiento,	mov.CantidadMov AS MontoMes,	cli.TipoPersona,	Var_LimFisica,
						cta.SucursalID,mov.NumTransaccion
					FROM CUENTASAHOMOV mov
					INNER JOIN CUENTASAHO cta ON mov.CuentaAhoID = cta.CuentaAhoID
					INNER JOIN TIPOSMOVSAHO tMov ON mov.TipoMovAhoID =  tMov.TipoMovAhoID
					INNER JOIN CLIENTES cli ON cta.ClienteID = cli.ClienteID
					WHERE	tMov.EsEfectivo ='S' AND mov.Fecha BETWEEN Var_FecIniMes AND Var_FecFinMes
					AND cli.TipoPersona = Per_Fisica
					HAVING MontoMes >= Var_LimFisica;

				#Clientes FISICAS, que rebasan su limite de Operacion
				INSERT INTO LIMOPERCLI (
						ClienteID,	NombreCompleto,	CuentaAhoID,	DescripcionMov,	CantidadMov,
						Fecha,		NatMovimiento,	MontoMes,		TipoPersona,	LimOrigen,
						SucursalID, NumTransaccion)
					SELECT
						cli.ClienteID,	cli.NombreCompleto,	mov.CuentaAhoID,	mov.DescripcionMov,	mov.CantidadMov,
						mov.Fecha,		mov.NatMovimiento,	mov.CantidadMov AS MontoMes,	cli.TipoPersona,	Var_LimFisica,
						 cta.SucursalID,mov.NumTransaccion
					FROM `HIS-CUENAHOMOV` mov
					INNER JOIN CUENTASAHO cta ON mov.CuentaAhoID = cta.CuentaAhoID
					INNER JOIN TIPOSMOVSAHO tMov ON mov.TipoMovAhoID =  tMov.TipoMovAhoID
					INNER JOIN CLIENTES cli ON cta.ClienteID = cli.ClienteID
					WHERE tMov.EsEfectivo ='S' AND mov.Fecha BETWEEN Var_FecIniMes AND Var_FecFinMes
					AND cli.TipoPersona = Per_Fisica
					HAVING MontoMes >= Var_LimFisica;
			END IF;

			IF (IFNULL(Par_TipoPersona,Cadena_Vacia) = Per_Moral )THEN
				#Clientes MORALES, que rebasan su limite de Operacion
				INSERT INTO LIMOPERCLI (
						ClienteID,	NombreCompleto,	CuentaAhoID,	DescripcionMov,	CantidadMov,
						Fecha,		NatMovimiento,	MontoMes,		TipoPersona,	LimOrigen,
						SucursalID, NumTransaccion)
					SELECT
						cli.ClienteID,	cli.NombreCompleto,	mov.CuentaAhoID,	mov.DescripcionMov,	mov.CantidadMov,
						mov.Fecha,	    mov.NatMovimiento,	mov.CantidadMov AS MontoMes,	cli.TipoPersona,	Var_LimMoral,
						cta.SucursalID,	mov.NumTransaccion
					FROM CUENTASAHOMOV mov
					INNER JOIN CUENTASAHO cta ON mov.CuentaAhoID = cta.CuentaAhoID
					INNER JOIN TIPOSMOVSAHO tMov ON mov.TipoMovAhoID =  tMov.TipoMovAhoID
					INNER JOIN CLIENTES cli ON cta.ClienteID = cli.ClienteID
					WHERE tMov.EsEfectivo ='S' AND mov.Fecha BETWEEN Var_FecIniMes AND Var_FecFinMes
					AND cli.TipoPersona != Per_Fisica
					HAVING MontoMes >= Var_LimMoral;

				INSERT INTO LIMOPERCLI  (
						ClienteID,	NombreCompleto,	CuentaAhoID,	DescripcionMov,	CantidadMov,
						Fecha,		NatMovimiento,	MontoMes,		TipoPersona,	LimOrigen,
						SucursalID, NumTransaccion)
					SELECT 	cli.ClienteID,	cli.NombreCompleto,	mov.CuentaAhoID,	mov.DescripcionMov,	mov.CantidadMov,
							mov.Fecha,		mov.NatMovimiento,	mov.CantidadMov AS MontoMes,	cli.TipoPersona,	Var_LimMoral,
							cta.SucursalID,	mov.NumTransaccion
					FROM `HIS-CUENAHOMOV` mov
					INNER JOIN CUENTASAHO cta ON mov.CuentaAhoID = cta.CuentaAhoID
					INNER JOIN TIPOSMOVSAHO tMov ON mov.TipoMovAhoID =  tMov.TipoMovAhoID
					INNER JOIN CLIENTES cli ON cta.ClienteID = cli.ClienteID
					WHERE tMov.EsEfectivo ='S' AND mov.Fecha BETWEEN Var_FecIniMes AND Var_FecFinMes
					AND cli.TipoPersona != Per_Fisica
					HAVING MontoMes >= Var_LimMoral;
			END IF;

            IF (IFNULL(Par_TipoPersona,Cadena_Vacia) = Per_FMoral )THEN
				#Clientes FISICAS MORALES, que rebasan su limite de Operacion
				INSERT INTO LIMOPERCLI (
						ClienteID,	NombreCompleto,	CuentaAhoID,	DescripcionMov,	CantidadMov,
						Fecha,		NatMovimiento,	MontoMes,		TipoPersona,	LimOrigen,
						SucursalID, NumTransaccion)
					SELECT
						cli.ClienteID,	cli.NombreCompleto,	mov.CuentaAhoID,	mov.DescripcionMov,	mov.CantidadMov,
						mov.Fecha,		mov.NatMovimiento,	mov.CantidadMov AS MontoMes,	cli.TipoPersona,	Var_LimMes,
						 cta.SucursalID,mov.NumTransaccion
					FROM CUENTASAHOMOV mov
					INNER JOIN CUENTASAHO cta ON mov.CuentaAhoID = cta.CuentaAhoID
					INNER JOIN TIPOSMOVSAHO tMov ON mov.TipoMovAhoID =  tMov.TipoMovAhoID
					INNER JOIN CLIENTES cli ON cta.ClienteID = cli.ClienteID
					WHERE tMov.EsEfectivo ='S' AND mov.Fecha BETWEEN Var_FecIniMes AND Var_FecFinMes
					HAVING MontoMes >= Var_LimMes;


				INSERT INTO LIMOPERCLI (
						ClienteID,	NombreCompleto,	CuentaAhoID,	DescripcionMov,	CantidadMov,
						Fecha,		NatMovimiento,	MontoMes,		TipoPersona,	LimOrigen,
						SucursalID,	NumTransaccion)
					SELECT
						cli.ClienteID,	cli.NombreCompleto,	mov.CuentaAhoID,	mov.DescripcionMov,	mov.CantidadMov,
						mov.Fecha,		mov.NatMovimiento,	mov.CantidadMov AS MontoMes,	cli.TipoPersona,	Var_LimMes,
						 cta.SucursalID,mov.NumTransaccion
					FROM `HIS-CUENAHOMOV` mov
					INNER JOIN CUENTASAHO cta ON mov.CuentaAhoID = cta.CuentaAhoID
					INNER JOIN TIPOSMOVSAHO tMov ON mov.TipoMovAhoID =  tMov.TipoMovAhoID
					INNER JOIN CLIENTES cli ON cta.ClienteID = cli.ClienteID
					WHERE tMov.EsEfectivo ='S' AND mov.Fecha BETWEEN Var_FecIniMes AND Var_FecFinMes
					HAVING MontoMes >= Var_LimMes;
			END IF;

			#Agrupamiento de Operaciones que Rebasan los Montos Limites Mensuales
			SELECT
				lim.NombreCompleto AS NombreCliente,		lim.CuentaAhoID,		lim.DescripcionMov AS DescripcionOp,	FORMAT(CASE WHEN lim.NatMovimiento = Nat_Cargo THEN lim.CantidadMov
																																													ELSE Decimal_Cero
																																												END,2) AS Cargo,					FORMAT(CASE WHEN lim.NatMovimiento = Nat_Abono THEN lim.CantidadMov
																																													ELSE Decimal_Cero
																																												END,2)AS Abono,
				FORMAT(lim.MontoMes,2) AS SaldoMes,			SUC.NombreSucurs,		lim.Fecha,								FORMAT(lim.LimOrigen,2) AS LimOrigen,				lim.NumTransaccion,
				lim.ClienteID
				FROM LIMOPERCLI lim
				INNER JOIN SUCURSALES AS SUC ON lim.SucursalID = SUC.SucursalID
				WHERE  lim.CantidadMov > Decimal_Cero
				ORDER BY lim.ClienteID, lim.CuentaAhoID, lim.Fecha;

			DROP TABLE IF EXISTS LIMOPERCLI;

	END IF;

END IF;

END TerminaStore$$
