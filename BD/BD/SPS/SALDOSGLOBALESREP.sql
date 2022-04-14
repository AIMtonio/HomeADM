-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SALDOSGLOBALESREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `SALDOSGLOBALESREP`;
DELIMITER $$


CREATE PROCEDURE `SALDOSGLOBALESREP`(
	-- Store PROCEDURE: layout se exportara los saldos globales tomando como base el reporte Analitico Ahorro
	-- Reportes Administracion de Riesgos

	Par_ClienteID			INT(11),			-- Numero de Cliente
	Par_TipoCuentaID		INT(11),			-- Tipo de Cuenta de Ahorro
	Par_SucursalID			INT(11),			-- Numero de Sucursal
	Par_CuentaAhoID			BIGINT(12),			-- Numero de Cuenta
	Par_MonedaID			INT(11),			-- Numero de Moneda

	Par_Promotor			INT(11),			-- Numero de Promotor asignado al cliente
	Par_Genero				CHAR(1),			-- Tipo de Sexo F: Femenimo o M: Masculino
	Par_Estado				INT(11),			-- Estado obtenido de la tabla DIRECCLIENTE
	Par_Municipio			INT(11),			-- Municipio obtenido de la tabla DIRECCLIENTE
	Par_NumReporte			TINYINT UNSIGNED,	-- Numero de Reporte

	Aud_EmpresaID			INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)

TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Sentencia			VARCHAR(4000); 		-- Sentencia de Ejecucion
	DECLARE Var_ClienteInst			INT(11); 			-- ID de Intitucion
	DECLARE Par_Fecha				DATE;
	DECLARE Var_IniMes				DATE;
	DECLARE Var_FechaCieInv			DATE;
	DECLARE Var_FechaCieCed			DATE;
	DECLARE Var_FecMesAnt			DATE;

	-- Declaracion de Constantes
	DECLARE	Entero_Cero				INT(11);			-- Constante de entero cero
	DECLARE	Decimal_Cero			DECIMAL(14,2);		-- Constante de DECIMAL cero
	DECLARE	Fecha_Vacia				DATE;				-- Constante de fecha vacia
	DECLARE	Cadena_Vacia			CHAR(1);			-- Constante cadena vacia
	DECLARE	Con_NO					CHAR(1);			-- Constante NO
	DECLARE Rep_Excel				TINYINT UNSIGNED;	-- Tipo de Reporte Excel
	DECLARE Rep_PDF					TINYINT UNSIGNED;	-- Tipo de Reporte PDF
	DECLARE	Con_Pipe				CHAR(1);			-- Constante Pipe

	-- Asignacion de Constantes
	SET Entero_Cero					:= 0;
	SET Decimal_Cero				:= 0.00;
	SET Fecha_Vacia					:= '1900-01-01';
	SET Cadena_Vacia				:= '';
	SET Con_NO						:= 'N';
	SET Rep_Excel					:= 1;

	-- Cuenta de la Institucion
	SELECT ClienteInstitucion,	FechaSistema
	INTO Var_ClienteInst,		Par_Fecha
	FROM PARAMETROSSIS;

	SET Var_IniMes 		:= DATE_ADD(Par_Fecha, INTERVAL ((DAY(Par_Fecha)*-1) + 1) DAY);
	SET Var_FechaCieInv := (SELECT MAX(FechaCorte) FROM HISINVERSIONES WHERE FechaCorte <= Par_Fecha);
	SET Var_FechaCieCed	:= (SELECT MAX(FechaCorte) FROM SALDOSCEDES WHERE FechaCorte <= Par_Fecha);
	SET Var_FecMesAnt 	:=  DATE_SUB(Var_IniMes, INTERVAL 1 DAY);

	-- Seteo de los parametros de entrada a valores vacios
	SET Par_ClienteID		:=	IFNULL(Par_ClienteID, Entero_Cero);
	SET Par_TipoCuentaID	:=	IFNULL(Par_TipoCuentaID, Entero_Cero);
	SET Par_SucursalID		:=	IFNULL(Par_SucursalID, Entero_Cero);
	SET Par_CuentaAhoID		:=	IFNULL(Par_CuentaAhoID, Entero_Cero);
	SET Par_MonedaID		:=	IFNULL(Par_MonedaID, Entero_Cero);
	SET Par_Promotor		:=	IFNULL(Par_Promotor, Entero_Cero);
	SET Par_Genero			:=	IFNULL(Par_Genero, Cadena_Vacia);
	SET Par_Estado			:=	IFNULL(Par_Estado, Entero_Cero);
	SET Par_Municipio		:=	IFNULL(Par_Municipio, Entero_Cero);

	SET Var_FechaCieInv		:= IFNULL(Var_FechaCieInv,Fecha_Vacia);
	SET Var_FechaCieCed		:= IFNULL(Var_FechaCieCed,Fecha_Vacia);

	DROP TABLE IF EXISTS TMP_SALDOSGLOBALES;
	CREATE TEMPORARY TABLE TMP_SALDOSGLOBALES(
		Instrumento			CHAR(1),
		InstrumentoID		BIGINT(20),
		ClienteID			INT(11),
		NombreCompleto		VARCHAR(200),
		RFCOficial			VARCHAR(13),
		SucursalID			INT(11),
		CuentaAhoID			BIGINT(12),
		TipoCuenta			VARCHAR(200),
		Estatus				VARCHAR(20),
		SaldoInicial 		DECIMAL(14,2),
		Cargos 				DECIMAL(14,2),
		Abonos 				DECIMAL(14,2),
		Saldo 				DECIMAL(14,2),
		SaldoDisponible 	DECIMAL(14,2),
		SaldoBloqueado 		DECIMAL(14,2),
		Hora 				TIME,
		Fecha 				DATE,
		INDEX TMP_SALDOSGLOBALES1 (Instrumento,InstrumentoID),
		INDEX TMP_SALDOSGLOBALES2 (Instrumento),
		INDEX TMP_SALDOSGLOBALES3 (InstrumentoID),
		INDEX TMP_SALDOSGLOBALES4 (ClienteID)
		);

	IF(	Rep_Excel = Par_NumReporte ) THEN

		SET Var_Sentencia := 'INSERT INTO TMP_SALDOSGLOBALES ';
		SET Var_Sentencia := CONCAT(Var_Sentencia,'SELECT	"A",	Cue.CuentaAhoID,	Cue.ClienteID, 		MAX(Cli.NombreCompleto) AS NombreCompleto, 	IFNULL(MAX(Cli.RFCOficial), "") AS RFCOficial, ');
		SET Var_Sentencia := CONCAT(Var_Sentencia,'Cue.SucursalID,		Cue.CuentaAhoID,				MAX(Tic.Descripcion) AS TipoCuenta, ');
		SET Var_Sentencia := CONCAT(Var_Sentencia,'CASE MAX(Cue.Estatus)');
		SET Var_Sentencia := CONCAT(Var_Sentencia,'		WHEN "B" THEN "BLOQUEADA" ');
		SET Var_Sentencia := CONCAT(Var_Sentencia,'		WHEN "A" THEN "ACTIVA" ');
		SET Var_Sentencia := CONCAT(Var_Sentencia,'		WHEN "I" THEN "INACTIVA" ');
		SET Var_Sentencia := CONCAT(Var_Sentencia,'		WHEN "C" THEN "CANCELADA" ');
		SET Var_Sentencia := CONCAT(Var_Sentencia,'		WHEN "R" THEN "REGISTRADA" ');
		SET Var_Sentencia := CONCAT(Var_Sentencia,'	END AS Estatus, ');
		SET Var_Sentencia := CONCAT(Var_Sentencia,' SUM(Cue.SaldoIniMes) AS SaldoInicial, SUM(Cue.CargosMes) AS Cargos, SUM(Cue.AbonosMes) AS Abonos, ');
		SET Var_Sentencia := CONCAT(Var_Sentencia,' SUM(Cue.SaldoIniMes+Cue.AbonosMes-Cue.CargosMes) AS Saldo, ');
		SET Var_Sentencia := CONCAT(Var_Sentencia,' SUM(Cue.SaldoDispon) AS SaldoDisponible, ');
		SET Var_Sentencia := CONCAT(Var_Sentencia,' SUM(Cue.SaldoBloq) AS SaldoBloqueado, ');
		SET Var_Sentencia := CONCAT(Var_Sentencia,' TIME(NOW()) AS Hora, CURRENT_DATE() AS Fecha ');
		SET Var_Sentencia := CONCAT(Var_Sentencia,' FROM  CUENTASAHO AS Cue ');
		SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN TIPOSCUENTAS AS Tic ON Cue.TipoCuentaID = Tic.TipoCuentaID ');
		SET Var_Sentencia := CONCAT(Var_Sentencia,' INNER JOIN CLIENTES  AS Cli ON Cue.ClienteID = Cli.ClienteID ');
		SET Var_Sentencia := CONCAT(Var_Sentencia,' WHERE Cli.ClienteID <> "',Var_ClienteInst,'" ');
		SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Tic.GeneraInteres = "S" ');

		-- Si hay un Numero de Cliente
		IF(Par_ClienteID != Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND Cli.ClienteID =', Par_ClienteID);
		END IF;

		-- Si hay un Tipo de Cuenta
		IF(Par_TipoCuentaID != Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND Tic.TipoCuentaID =', Par_TipoCuentaID);
		END IF;

		-- Si hay un Numero de Sucursal
		IF(Par_SucursalID != Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND Cue.SucursalID =', Par_SucursalID);
		END IF;

		-- Si hay un Numero de Cuenta de Ahorro
		IF(Par_CuentaAhoID != Entero_Cero)THEN
			SET Var_Sentencia = CONCAT(Var_sentencia,' AND Cue.CuentaAhoID =', Par_CuentaAhoID);
		END IF;

		-- Si hay un Tipo de modena
		IF(Par_MonedaID != Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND Cue.MonedaID =', Par_MonedaID);
		END IF;

		-- Si hay un Numero de Promotor
		IF(Par_Promotor != Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND Cli.PromotorActual =', Par_Promotor);
		END IF;

		-- Si hay un Numero Tipo de Genero
		IF(Par_Genero != Cadena_Vacia)THEN
			SET Var_Sentencia = CONCAT(Var_sentencia,' AND Cli.Sexo ="', Par_Genero,'"');
		END IF;

		-- Si hay un Tipo de modena
		IF(Par_Estado != Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND (SELECT Dir.EstadoID FROM DIRECCLIENTE Dir WHERE Dir.Oficial="S" AND Cli.ClienteID = Dir.ClienteID LIMIT 1) =', Par_Estado);
		END IF;

		-- Si hay un Numero de Promotor
		IF(Par_Municipio != Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND (SELECT Dir.MunicipioID FROM DIRECCLIENTE Dir WHERE Dir.Oficial="S" AND Cli.ClienteID = Dir.ClienteID LIMIT 1) =', Par_Municipio);
		END IF;

		SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' GROUP BY Cue.CuentaAhoID, Tic.TipoCuentaID, Cue.SucursalID ');
		SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' ORDER BY Cue.SucursalID, Tic.TipoCuentaID');

		SET @Sentencia	= (Var_Sentencia);
		PREPARE ANAHORROREP FROM @Sentencia;
		EXECUTE ANAHORROREP;

		DEALLOCATE PREPARE ANAHORROREP;
		SET Var_Sentencia := '';
		SET Var_Sentencia := 'INSERT INTO TMP_SALDOSGLOBALES ';
		SET Var_Sentencia := CONCAT(Var_sentencia, 'SELECT 	"I", Inv.InversionID, Inv.ClienteID, Cli.NombreCompleto, Cli.RFCOficial, Cue.SucursalID, Inv.CuentaAhoID, ');
		SET Var_Sentencia := CONCAT(Var_sentencia, ' Cat.Descripcion, CASE (Inv.Estatus) ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '						WHEN "A" THEN "REGISTRADA" ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '						WHEN "N" THEN "VIGENTE" ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '						WHEN "P" THEN "PAGADA" ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '						WHEN "C" THEN "CANCELADA" ');
		SET Var_Sentencia := CONCAT(Var_sentencia, ' END AS Estatus, ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '	CASE WHEN Inv.FechaInicio < "',Var_IniMes,'" THEN Inv.Monto ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '		 ELSE 0.00 ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '	END AS SaldoInicial, ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '	CASE WHEN Inv.Estatus IN ("P","C")  AND Inv.FechaVencimiento BETWEEN "',Var_IniMes,'" AND "',Par_Fecha,'" THEN (Inv.Monto + Inv.SaldoProvision) ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '		 ELSE 0.00  ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '	END AS Cargos, ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '	CASE WHEN  Inv.FechaInicio BETWEEN "',Var_IniMes,'" AND "',Par_Fecha,'" THEN Inv.Monto ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '		 ELSE Inv.SaldoProvision');
		SET Var_Sentencia := CONCAT(Var_sentencia, '	END AS Abonos, ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '	CASE WHEN Inv.Estatus IN ("P","C") THEN 0.00  ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '		 ELSE (Inv.Monto + Inv.SaldoProvision)  ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '	END AS SaldoFinal, ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '	CASE WHEN Inv.Estatus IN ("P","C") THEN 0.00');
		SET Var_Sentencia := CONCAT(Var_sentencia, '		 ELSE (Inv.Monto + Inv.SaldoProvision) ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '	END AS SaldoDisponible, ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '	0.00 AS SaldoBloqueado, ');
		SET Var_Sentencia := CONCAT(Var_Sentencia, ' TIME(NOW()) AS Hora, CURRENT_DATE() AS Fecha ');
		SET Var_Sentencia := CONCAT(Var_sentencia, 'FROM HISINVERSIONES Inv, ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '	 INVERSIONES Dat, ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '	 CATINVERSION Cat, ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '	 CUENTASAHO Cue, ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '	 CLIENTES Cli ');
		SET Var_Sentencia := CONCAT(Var_sentencia, 'WHERE Inv.ClienteID = Cli.ClienteID ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '  AND Inv.InversionID = Dat.InversionID ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '  AND Dat.CuentaAhoID = Cue.CuentaAhoID ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '  AND Inv.ClienteID <> "',Var_ClienteInst,'" ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '  AND Inv.FechaCorte  = "',Var_FechaCieInv,'" ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '  AND (Inv.Estatus = "N" OR ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '		( Inv.Estatus = "P" AND Inv.FechaVencimiento BETWEEN "',Var_IniMes,'" AND "',Var_FechaCieInv,'") ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '		OR ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '		( Inv.Estatus = "C" AND Inv.FechaVenAnt BETWEEN "',Var_IniMes,'" AND "',Var_FechaCieInv,'" ) ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '		) ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '  AND Inv.TipoInversionID = Cat.TipoInversionID ');

		-- Si hay un Numero de Cliente
		IF(Par_ClienteID != Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND Dat.ClienteID =', Par_ClienteID);
		END IF;

		-- Si hay un Tipo de Cuenta
		IF(Par_TipoCuentaID != Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND Cue.TipoCuentaID =', Par_TipoCuentaID);
		END IF;

		-- Si hay un Numero de Sucursal
		IF(Par_SucursalID != Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND Cue.SucursalID =', Par_SucursalID);
		END IF;

		-- Si hay un Numero de Cuenta de Ahorro
		IF(Par_CuentaAhoID != Entero_Cero)THEN
			SET Var_Sentencia = CONCAT(Var_sentencia,' AND Dat.CuentaAhoID =', Par_CuentaAhoID);
		END IF;

		-- Si hay un Tipo de modena
		IF(Par_MonedaID != Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND Cue.MonedaID =', Par_MonedaID);
		END IF;

		-- Si hay un Numero de Promotor
		IF(Par_Promotor != Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND Cli.PromotorActual =', Par_Promotor);
		END IF;

		-- Si hay un Numero Tipo de Genero
		IF(Par_Genero != Cadena_Vacia)THEN
			SET Var_Sentencia = CONCAT(Var_sentencia,' AND Cli.Sexo ="', Par_Genero,'"');
		END IF;

		-- Si hay un Tipo de modena
		IF(Par_Estado != Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND (SELECT Dir.EstadoID FROM DIRECCLIENTE Dir WHERE Dir.Oficial="S" AND Cli.ClienteID = Dir.ClienteID LIMIT 1) =', Par_Estado);
		END IF;

		-- Si hay un Numero de Promotor
		IF(Par_Municipio != Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND (SELECT Dir.MunicipioID FROM DIRECCLIENTE Dir WHERE Dir.Oficial="S" AND Cli.ClienteID = Dir.ClienteID LIMIT 1) =', Par_Municipio);
		END IF;

		SET Var_Sentencia := CONCAT(Var_sentencia, ' ORDER BY Cue.SucursalID, Cue.TipoCuentaID;');

		SET @Sentencia	= (Var_Sentencia);
		PREPARE ANAHORROREP FROM @Sentencia;
		EXECUTE ANAHORROREP;
		DEALLOCATE PREPARE ANAHORROREP;
		SET Var_Sentencia := '';

		SET Var_Sentencia := 'INSERT INTO TMP_SALDOSGLOBALES ';
		SET Var_Sentencia := CONCAT(Var_sentencia, 'SELECT 	"C", Ced.CedeID, Ced.ClienteID, Cli.NombreCompleto, Cli.RFCOficial, Cue.SucursalID, Ced.CuentaAhoID,');
		SET Var_Sentencia := CONCAT(Var_sentencia, '		Cat.Descripcion, CASE (Ced.Estatus) ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '							WHEN "A" THEN "REGISTRADA" ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '							WHEN "N" THEN "VIGENTE" ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '							WHEN "P" THEN "PAGADA" ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '							WHEN "C" THEN "CANCELADA" ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '						 END AS Estatus, ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '		CASE WHEN Ced.FechaInicio < "',Var_IniMes,'" THEN Ced.Monto ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '			 ELSE 0.00 ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '		END AS SaldoInicial, ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '		CASE WHEN Ced.Estatus IN ("P","C") AND Ced.FechaVencimiento BETWEEN "',Var_IniMes,'" AND "',Par_Fecha,'" THEN (Ced.Monto + Ced.SaldoProvision) ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '			 ELSE 0.00  ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '		END AS Cargos, ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '		0.00 AS Abonos, ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '		IFNULL(Sal.SaldoCapital, 0.00) AS SaldoFinal, ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '		IFNULL(Sal.SaldoCapital, 0.00) AS SaldoDisponible, ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '		0.00 AS SaldoBloqueado, ');
		SET Var_Sentencia := CONCAT(Var_Sentencia,' TIME(NOW()) AS Hora, CURRENT_DATE() AS Fecha ');
		SET Var_Sentencia := CONCAT(Var_sentencia, 'FROM CEDES Ced ');
		SET Var_Sentencia := CONCAT(Var_sentencia, 'LEFT OUTER JOIN SALDOSCEDES Sal ');
		SET Var_Sentencia := CONCAT(Var_sentencia, 'ON Ced.CedeID = Sal.CedeID ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '	AND Sal.FechaCorte = "',Var_FechaCieCed,'", ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '	 TIPOSCEDES Cat, ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '	 CUENTASAHO Cue, ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '     CLIENTES Cli ');
		SET Var_Sentencia := CONCAT(Var_sentencia, 'WHERE Ced.ClienteID = Cli.ClienteID ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '  AND Ced.ClienteID <> "',Var_ClienteInst,'" ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '  AND Ced.CuentaAhoID = Cue.CuentaAhoID ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '  AND ((Ced.Estatus = "N" AND FechaInicio <= "',Var_FechaCieCed,'") OR ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '		( Ced.Estatus = "P" AND Ced.FechaVencimiento >= "',Var_IniMes,'" ) ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '		OR ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '		( Ced.Estatus = "C" AND Ced.FechaVenAnt >= "',Var_IniMes,'" ) ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '		) ');
		SET Var_Sentencia := CONCAT(Var_sentencia, '  AND Ced.TipoCedeID = Cat.TipoCedeID ');

		-- Si hay un Numero de Cliente
		IF(Par_ClienteID != Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND Ced.ClienteID =', Par_ClienteID);
		END IF;

		-- Si hay un Tipo de Cuenta
		IF(Par_TipoCuentaID != Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND Cue.TipoCuentaID =', Par_TipoCuentaID);
		END IF;

		-- Si hay un Numero de Sucursal
		IF(Par_SucursalID != Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND Cue.SucursalID =', Par_SucursalID);
		END IF;

		-- Si hay un Numero de Cuenta de Ahorro
		IF(Par_CuentaAhoID != Entero_Cero)THEN
			SET Var_Sentencia = CONCAT(Var_sentencia,' AND Ced.CuentaAhoID =', Par_CuentaAhoID);
		END IF;

		-- Si hay un Tipo de modena
		IF(Par_MonedaID != Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND Cue.MonedaID =', Par_MonedaID);
		END IF;

		-- Si hay un Numero de Promotor
		IF(Par_Promotor != Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND Cli.PromotorActual =', Par_Promotor);
		END IF;

		-- Si hay un Numero Tipo de Genero
		IF(Par_Genero != Cadena_Vacia)THEN
			SET Var_Sentencia = CONCAT(Var_sentencia,' AND Cli.Sexo ="', Par_Genero,'"');
		END IF;

		-- Si hay un Tipo de modena
		IF(Par_Estado != Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND (SELECT Dir.EstadoID FROM DIRECCLIENTE Dir WHERE Dir.Oficial="S" AND Cli.ClienteID = Dir.ClienteID LIMIT 1) =', Par_Estado);
		END IF;

		-- Si hay un Numero de Promotor
		IF(Par_Municipio != Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND (SELECT Dir.MunicipioID FROM DIRECCLIENTE Dir WHERE Dir.Oficial="S" AND Cli.ClienteID = Dir.ClienteID LIMIT 1) =', Par_Municipio);
		END IF;

		SET Var_Sentencia := CONCAT(Var_sentencia, ' ORDER BY Cue.SucursalID, Cue.TipoCuentaID; ');

		SET @Sentencia	= (Var_Sentencia);
		PREPARE ANAHORROREP FROM @Sentencia;
		EXECUTE ANAHORROREP;
		DEALLOCATE PREPARE ANAHORROREP;

		DROP TABLE IF EXISTS TMP_CARGOABONOCEDE;
		CREATE TEMPORARY TABLE TMP_CARGOABONOCEDE
		SELECT CedeID,	IFNULL(SUM(CASE WHEN NatMovimiento = 'A' THEN Monto ELSE Decimal_Cero END), Decimal_Cero) AS Cargo,
						IFNULL(SUM(CASE WHEN NatMovimiento = 'C' THEN Monto ELSE Decimal_Cero END), Decimal_Cero) AS Abono
		FROM CEDESMOV
		WHERE CedeID IN ( SELECT CedeID FROM SALDOSCEDES WHERE FechaCorte = Var_FecMesAnt)
		  AND Fecha <= Var_FecMesAnt
		 GROUP BY CedeID;

		UPDATE TMP_SALDOSGLOBALES tmp, TMP_CARGOABONOCEDE Res
			SET tmp.SaldoInicial = tmp.SaldoInicial + (Res.Abono - Res.Cargo)
		WHERE tmp.Instrumento = 'C'
		  AND tmp.InstrumentoID = Res.CedeID;

		DROP TABLE IF EXISTS TMP_CARGOABONOCEDE;
		CREATE TEMPORARY TABLE TMP_CARGOABONOCEDE
		SELECT CedeID,	IFNULL(SUM(CASE WHEN NatMovimiento = 'A' THEN Monto ELSE Decimal_Cero END), Decimal_Cero) AS Cargo,
						IFNULL(SUM(CASE WHEN NatMovimiento = 'C' THEN Monto ELSE Decimal_Cero END), Decimal_Cero) AS Abono
		FROM CEDESMOV
		WHERE CedeID IN ( SELECT CedeID FROM SALDOSCEDES WHERE FechaCorte = Var_FechaCieCed)
		  AND Fecha BETWEEN Var_IniMes AND Par_Fecha
		GROUP BY CedeID;

		UPDATE TMP_SALDOSGLOBALES tmp,TMP_CARGOABONOCEDE Res
			SET tmp.Abonos = Abono,
				tmp.Cargos = Cargo,
				tmp.Saldo = tmp.SaldoInicial + (Res.Abono - Res.Cargo),
				tmp.SaldoDisponible = tmp.SaldoInicial + (Res.Abono - Res.Cargo)
		WHERE tmp.Instrumento = 'C'
		  AND tmp.InstrumentoID = Res.CedeID;

		SELECT	ClienteID,		NombreCompleto,		RFCOficial,		SucursalID,		CuentaAhoID,
				TipoCuenta,		Estatus,			SaldoInicial,	Cargos,			Abonos,
				Saldo,			SaldoDisponible,	SaldoBloqueado,	Hora,			Fecha
		FROM TMP_SALDOSGLOBALES;
	END IF;

	DROP TABLE IF EXISTS TMP_SALDOSGLOBALES;
END TerminaStore$$