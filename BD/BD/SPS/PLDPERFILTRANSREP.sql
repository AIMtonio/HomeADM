-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDPERFILTRANSREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDPERFILTRANSREP`;
DELIMITER $$

CREATE PROCEDURE `PLDPERFILTRANSREP`(
/* SP que genera el reporte del Perfil Transaccional*/
	Par_FechaInicio			DATE,				-- Fecha Final del Periodo
	Par_FechaFinal			DATE,				-- Fecha Final del Periodo
	Par_Sucursal			INT(11),			-- Sucursal
	Par_ClienteID			INT(11),			-- ClienteID
	Par_TipoPersona			CHAR(1),			-- Tipo de Persona F:Fisica, M:Moral, A:Fisica con Actividad Empresaria T:Todas
	Par_Estatus				CHAR(1),			-- Estatus A:Autorizado R:Rechazado P:Pendiente
	Par_TipoProceso			CHAR(1),			-- Tipo de Proceso M:Manual A:Automatizado
	Par_Operaciones			CHAR(1),			-- Operaciones de: C = CLIENTES, U = USUARIOS DE SERVICIOS, "" = TODOS
	Par_NumCon				INT(11),			-- No. de Lista

	/* Parametros de Auditoria */
	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),

	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_Sentencia				VARCHAR(6000);			# Sentencia SQL
	DECLARE Var_Filtro					VARCHAR(6000);			# Sentencia SQL
	DECLARE Var_TipoDocumento			INT(11);
	DECLARE Var_FechaSiste				DATE;
	DECLARE Var_Anio					INT(11);
	DECLARE Var_AnioFin					INT(11);
	DECLARE Var_Mes						INT(11);
	DECLARE Var_MesFin					INT(11);

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia				CHAR(1);				# Constante cadena vacia ''
	DECLARE Decimal_Cero				DECIMAL(14,2);			# DECIMAL cero
	DECLARE Entero_Cero					INT(1);					# Constante Entero cero 0
	DECLARE Estatus_Todas				CHAR(1);
	DECLARE Fecha_Vacia					DATE;					# Constante Fecha vacia 1900-01-01
	DECLARE Rep_Principal				INT(11);				# Tipo de Reporte principal
	DECLARE Rep_AutPerfilTransac		INT(11);				# Tipo de Reporte generado desde pantalla Autorizacion Perfil Transaccional


	-- Asignacion de constantes
	SET Cadena_Vacia					:= '';
	SET Decimal_Cero					:= 0;
	SET Entero_Cero						:= 0;
	SET Estatus_Todas					:= 'T';
	SET Fecha_Vacia						:= '1900-01-01';
	SET Rep_Principal					:= 1;
    SET Rep_AutPerfilTransac			:= 2;
	SET Var_Filtro						:= Cadena_Vacia;

	IF(Par_NumCon = Rep_Principal) THEN
		DROP TABLE IF EXISTS TMPPLDPERFILTRANSREP;
		SET Var_Sentencia := CONCAT(
		"CREATE TEMPORARY TABLE TMPPLDPERFILTRANSREP
		SELECT
		PLD.NumTransaccion,			IFNULL(PLD.Fecha,'1900-01-01') AS Fecha,				PLD.Hora,
		PLD.FechaInicio,			PLD.FechaFin,
		PLD.ClienteID,
		PLD.AntDepositosMax,		PLD.DepositosMax,		FNPORCENTAJE(AntDepositosMax,(PLD.DepositosMax-AntDepositosMax),3) AS PorcExcDepo,
		PLD.AntRetirosMax,			PLD.RetirosMax,			FNPORCENTAJE(AntRetirosMax,(PLD.RetirosMax-AntRetirosMax),3) AS RetirosExc,
		PLD.AntNumDepositos,		PLD.NumDepositos,		FNPORCENTAJE(AntNumDepositos,(PLD.NumDepositos-AntNumDepositos),3) AS NumDepEx,
		PLD.AntNumRetiros,			PLD.NumRetiros,			FNPORCENTAJE(AntNumRetiros,(PLD.NumRetiros-AntNumRetiros),3) AS NumRetEx,
		PLD.NivelRiesgo,			'A' AS TipoProceso,		PLD.Estatus,
		CASE PLD.TipoEval WHEN 'P' THEN 'PERIODICA' ELSE 'MASIVA' END AS TipoEvaluacion
		FROM PLDHISPERFILTRANSREAL AS PLD
		INNER JOIN CLIENTES AS CTE ON PLD.ClienteID = CTE.ClienteID
		WHERE
		PLD.Fecha BETWEEN '",Par_FechaInicio,"' AND '",Par_FechaFinal,"'");

		IF(Par_Sucursal>Entero_Cero) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia," AND CTE.SucursalOrigen=",Par_Sucursal);
			# Tipo Persona
			IF(Par_TipoPersona IN("F","M","A")) THEN
				SET Var_Sentencia := CONCAT(Var_Sentencia," AND CTE.TipoPersona='",Par_TipoPersona,"' ");
			END IF;
		ELSEIF(Par_ClienteID>Entero_Cero) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia," AND PLD.ClienteID=",Par_ClienteID);
		END IF;


		SET Var_Sentencia := CONCAT(Var_Sentencia, "	AND PLD.Estatus!='R'
		UNION
		SELECT
		PLD.NumTransaccion,			IFNULL(PLD.Fecha,'1900-01-01') AS Fecha,
		PLD.FechaInicio,			PLD.FechaFin,			PLD.Hora,
		PLD.ClienteID,
		PLD.AntDepositosMax,		PLD.DepositosMax,		FNPORCENTAJE(AntDepositosMax,(PLD.DepositosMax-AntDepositosMax),3) AS PorcExcDepo,
		PLD.AntRetirosMax,			PLD.RetirosMax,			FNPORCENTAJE(AntRetirosMax,(PLD.RetirosMax-AntRetirosMax),3) AS RetirosExc,
		PLD.AntNumDepositos,		PLD.NumDepositos,		FNPORCENTAJE(AntNumDepositos,(PLD.NumDepositos-AntNumDepositos),3) AS NumDepEx,
		PLD.AntNumRetiros,			PLD.NumRetiros,			FNPORCENTAJE(AntNumRetiros,(PLD.NumRetiros-AntNumRetiros),3) AS NumRetEx,
		PLD.NivelRiesgo,			'M' AS TipoProceso,		'C' AS Estatus,
		CASE PLD.TipoEval WHEN 'P' THEN 'PERIODICA' ELSE 'MASIVA' END AS TipoEvaluacion
		FROM PLDPERFILTRANSREAL AS PLD
		INNER JOIN CLIENTES AS CTE ON PLD.ClienteID = CTE.ClienteID
		WHERE
		PLD.Fecha BETWEEN '",Par_FechaInicio,"' AND '",Par_FechaFinal,"'");

		IF(Par_Sucursal>Entero_Cero) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia," AND CTE.SucursalOrigen=",Par_Sucursal);
			# Tipo Persona
			IF(Par_TipoPersona IN("F","M","A")) THEN
				SET Var_Sentencia := CONCAT(Var_Sentencia," AND CTE.TipoPersona='",Par_TipoPersona,"' ");
			END IF;
		ELSEIF(Par_ClienteID>Entero_Cero) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia," AND PLD.ClienteID=",Par_ClienteID);
		END IF;

		SET @Sentencia	= (Var_Sentencia);

		PREPARE STRPLDPERFILTRANSREP FROM @Sentencia;
		EXECUTE STRPLDPERFILTRANSREP;
		DEALLOCATE PREPARE STRPLDPERFILTRANSREP;

		SELECT
			PLD.NumTransaccion,			PLD.Fecha,					PLD.FechaInicio,
			PLD.FechaFin,				PLD.Hora,
		PLD.ClienteID,				PLD.AntDepositosMax,		PLD.DepositosMax,
		PLD.PorcExcDepo,			PLD.AntRetirosMax,			PLD.RetirosMax,
		PLD.RetirosExc,				PLD.AntNumDepositos,		PLD.NumDepositos,
		PLD.NumDepEx,				PLD.AntNumRetiros,			PLD.NumRetiros,
		PLD.NumRetEx,				CTE.NombreCompleto,			SUC.NombreSucurs,
		CTE.SucursalOrigen,
		CASE PLD.NivelRiesgo WHEN "A" THEN "ALTO"
		WHEN "M" THEN "MEDIO"
		ELSE "BAJO" END AS NivelRiesgo,
		CASE PLD.TipoProceso WHEN "M" THEN "MANUAL"
		ELSE "AUTOMATICO" END AS TipoProceso,
		CASE PLD.Estatus WHEN "R" THEN "RECHAZADO"
			WHEN "A" THEN "AUTORIZADO" ELSE "CAPTURADO" END AS Estatus,
			TipoEvaluacion
		FROM TMPPLDPERFILTRANSREP AS PLD
		INNER JOIN CLIENTES AS CTE ON PLD.ClienteID = CTE.ClienteID
		INNER JOIN SUCURSALES AS SUC ON CTE.SucursalOrigen = SUC.SucursalID
		WHERE CTE.Estatus = 'A'
				AND (PLD.PorcExcDepo>0 OR PLD.RetirosExc>0 OR PLD.NumDepEx>0 OR PLD.NumRetEx>0)
		ORDER BY PLD.Fecha, PLD.Hora,PLD.ClienteID;
	END IF;

	IF(Par_NumCon = Rep_AutPerfilTransac) THEN

		SET Var_Sentencia := CONCAT('SELECT
			PLD.TransaccionID,						PLD.Fecha,			PLD.ClienteID,			CTE.NombreCompleto,			CTE.SucursalOrigen,
			SUC.NombreSucurs AS NombreSucursal,		IFNULL(PLD.DepositosMax, 0) AS DepositosMax,	IFNULL(PLD.RetirosMax, 0) AS RetirosMax,			IFNULL(PLD.NumDepositos, 0) AS NumDepositos,
			IFNULL(PLD.NumRetiros, 0) AS NumRetiros
			FROM PLDPERFILTRANSREAL AS PLD INNER JOIN
				CLIENTES AS CTE ON PLD.ClienteID = CTE.ClienteID INNER JOIN
				SUCURSALES AS SUC ON CTE.SucursalOrigen = SUC.SucursalID
			WHERE (IFNULL(PLD.DepositosMax, 0)>PLD.AntDepositosMax OR
					IFNULL(PLD.RetirosMax, 0)>PLD.AntRetirosMax OR
					IFNULL(PLD.NumRetiros, 0)>PLD.AntNumRetiros OR
					IFNULL(PLD.NumDepositos, 0)>PLD.AntNumDepositos) ');
		IF(IFNULL(Par_ClienteID,Entero_Cero)>Entero_Cero) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia,' AND PLD.ClienteID = ',Par_ClienteID);
			IF(IFNULL(Par_FechaInicio,Fecha_Vacia)!=Fecha_Vacia AND IFNULL(Par_FechaFinal,Fecha_Vacia)!=Fecha_Vacia) THEN
				SET Var_Sentencia := CONCAT(Var_Sentencia,' AND PLD.Fecha BETWEEN \'',Par_FechaInicio,'\' AND \'', Par_FechaFinal,'\'');
			END IF;
		ELSEIF(IFNULL(Par_Sucursal,Entero_Cero)>Entero_Cero) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia,' AND SUC.SucursalID = ',Par_Sucursal);

			IF(IFNULL(Par_FechaInicio,Fecha_Vacia)!=Fecha_Vacia AND IFNULL(Par_FechaFinal,Fecha_Vacia)!=Fecha_Vacia) THEN
				SET Var_Sentencia := CONCAT(Var_Sentencia,' AND PLD.Fecha BETWEEN \'',Par_FechaInicio,'\' AND \'', Par_FechaFinal,'\'');
			END IF;
		ELSE
			IF(IFNULL(Par_FechaInicio,Fecha_Vacia)!=Fecha_Vacia AND IFNULL(Par_FechaFinal,Fecha_Vacia)!=Fecha_Vacia) THEN
				SET Var_Sentencia := CONCAT(Var_Sentencia,' AND PLD.Fecha BETWEEN \'',Par_FechaInicio,'\' AND \'', Par_FechaFinal,'\'');
			END IF;
		END IF;

		SET Var_Sentencia := CONCAT(Var_Sentencia,';');
		SET @Sentencia	:= CONCAT(Var_Sentencia);
		PREPARE PLDLISTA FROM @Sentencia;
		EXECUTE PLDLISTA;
		DEALLOCATE PREPARE PLDLISTA;

	END IF;
END TerminaStore$$
