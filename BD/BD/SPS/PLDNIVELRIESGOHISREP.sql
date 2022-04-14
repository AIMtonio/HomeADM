-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDNIVELRIESGOHISREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDNIVELRIESGOHISREP`;
DELIMITER $$

CREATE PROCEDURE `PLDNIVELRIESGOHISREP`(
/* SP que genera el reporte del Historico de Nivel de Riesgo*/
	Par_FechaInicio			DATE,				-- Fecha Final del Periodo
	Par_FechaFinal			DATE,				-- Fecha Final del Periodo
	Par_Sucursal			INT(11),			-- Sucursal
	Par_ClienteID			INT(11),			-- ClienteID
	Par_TipoPersona			CHAR(1),			-- Tipo de Persona F:Fisica, M:Moral, A:Fisica con Actividad Empresaria T:Todas

	Par_TipoProceso			CHAR(1),			-- Tipo de Proceso M:Manual A:Automatizado
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

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia				CHAR(1);
	DECLARE Decimal_Cero				DECIMAL(14,2);
	DECLARE Entero_Cero					INT(1);
	DECLARE Fecha_Vacia					DATE;
	DECLARE Rep_Principal				INT(11);

	-- Asignacion de constantes
	SET Cadena_Vacia					:= '';				# Cadena vacia
	SET Decimal_Cero					:= 0;				# Decimal cero
	SET Entero_Cero						:= 0;				# Entero cero
	SET Fecha_Vacia						:= '1900-01-01';	# Fecha vacia
	SET Rep_Principal					:= 1;				# Tipo de Reporte principal
	SET Var_Sentencia					:= Cadena_Vacia;

	IF(Par_NumCon = Rep_Principal) THEN
		SET Par_FechaInicio	:= IFNULL(Par_FechaInicio,Fecha_Vacia);
		SET Par_FechaFinal	:= IFNULL(Par_FechaFinal,Fecha_Vacia);
		SET Par_Sucursal	:= IFNULL(Par_Sucursal,Entero_Cero);
		SET Par_ClienteID	:= IFNULL(Par_ClienteID,Entero_Cero);
		SET Par_TipoPersona	:= IFNULL(Par_TipoPersona,Cadena_Vacia);
		SET Par_TipoProceso	:= IFNULL(Par_TipoProceso,Cadena_Vacia);

		DROP TABLE IF EXISTS TMPPLDNRIESGOXCTE;
		SET Var_Sentencia := CONCAT(
			'CREATE TEMPORARY TABLE TMPPLDNRIESGOXCTE ',
			'SELECT ',
				'TMP.Fecha,				CONCAT(" ",TMP.Hora) AS Hora,				TMP.ClienteID,		CTE.NombreCompleto,		CTE.SucursalOrigen, ',
				'SUC.NombreSucurs,		TMP.Porc1TotalAntec,	TMP.Porc2Localidad,	TMP.Porc3ActividadEc,	TMP.Porc4TotalOriRe, ',
				'TMP.Porc5TotalDesRe,	TMP.Porc6TotalPerf,		TMP.Porc1TotalEBR,	TMP.TotalPonderado,	',
				'TMP.NivelRiesgoObt, CTE.TipoPersona, ',
				'IF(TMP.TipoProceso = "M","MANUAL","AUTOMATICO") AS TipoProceso ',
			'FROM PLDHISNIVELRIESGOXCLIENTE AS TMP ',
				'INNER JOIN CLIENTES AS CTE ON TMP.ClienteID = CTE.ClienteID ',
				'INNER JOIN SUCURSALES AS SUC ON CTE.SucursalOrigen = SUC.SucursalID ',
			'WHERE TMP.Fecha BETWEEN \'',Par_FechaInicio,'\' AND \'',Par_FechaFinal,'\'
				AND (TMP.NivelRiesgoObt !="" OR TMP.NivelRiesgoObt IS NOT NULL)');

		IF(Par_ClienteID = Entero_Cero) THEN
			IF(Par_Sucursal != Entero_Cero) THEN
				SET Var_Sentencia	:= CONCAT(Var_Sentencia,' AND CTE.SucursalOrigen = ',Par_Sucursal);
			END IF;

			IF(Par_TipoPersona	!= Cadena_Vacia AND Par_TipoPersona != 'T') THEN
				SET Var_Sentencia	:= CONCAT(Var_Sentencia, ' AND CTE.TipoPersona = \'',Par_TipoPersona,'\' ');
			END IF;

		ELSEIF(Par_ClienteID != Entero_Cero) THEN
			SET Var_Sentencia		:= CONCAT(Var_Sentencia,' AND CTE.ClienteID = ',Par_ClienteID);
		END IF;

		SET Var_Sentencia := CONCAT(Var_Sentencia, ' ORDER BY TMP.Fecha DESC, TMP.Hora DESC; ');

		SET @Sentencia := (Var_Sentencia);


		PREPARE NIVELRIESGOPLD FROM @Sentencia;
		EXECUTE NIVELRIESGOPLD;
		DEALLOCATE PREPARE NIVELRIESGOPLD;

		# SE ACTUALIZAN NIVEL OBTENIDO SI NO HUBO UN PONDERADO.
		UPDATE TMPPLDNRIESGOXCTE
		SET
			NivelRiesgoObt = ''
		WHERE TotalPonderado = 0
			OR TotalPonderado IS NULL;

		DROP TABLE IF EXISTS `TMPNIVELESRPLD`;
		CREATE TABLE `TMPNIVELESRPLD` (
			CodigoNiveles	int(11),
			NivelRiesgoID	char(1),
			TipoPersona		char(1),
			Descripcion		varchar(45),
			Minimo			tinyint(4),
			Maximo			tinyint(4),
			SeEscala		char(1),
			Estatus			char(1),
			FechaReg 		date,
			INDEX (`TipoPersona`),
			INDEX (`FechaReg`),
			INDEX (`NivelRiesgoID`)
		);
		# SE GUARDAN LOS NIVELES ACTUALES.
		INSERT INTO TMPNIVELESRPLD (
			CodigoNiveles,	NivelRiesgoID,	TipoPersona,Descripcion,	Minimo,
			Maximo,			SeEscala,		Estatus,	FechaReg)
		SELECT
			CodigoNiveles,	NivelRiesgoID,	TipoPersona,Descripcion,	Minimo,
			Maximo,			SeEscala,		Estatus,	DATE(FechaActual)
		FROM CATNIVELESRIESGO;

		# SE GUARDAN LOS NIVELES EN FECHAS FILTRADAS. (HIST).
		INSERT INTO TMPNIVELESRPLD (
			CodigoNiveles,	NivelRiesgoID,	TipoPersona,Descripcion,	Minimo,
			Maximo,			SeEscala,		Estatus,	FechaReg)
		SELECT
			CodigoNiveles,	NivelRiesgoID,	TipoPersona,Descripcion,	Minimo,
			Maximo,			SeEscala,		Estatus,	DATE(FechaActual)
		FROM HISCATNIVELESRIESGO
			WHERE DATE(FechaActual) BETWEEN Par_FechaInicio AND Par_FechaFinal;

		# SE ACTUALIZAN NIVELES DE ACUERDO AL CATÁLOGO DE NIVELES.
		UPDATE TMPPLDNRIESGOXCTE TMP
			INNER JOIN TMPNIVELESRPLD CN ON TMP.TipoPersona = CN.TipoPersona
		SET TMP.NivelRiesgoObt = CN.NivelRiesgoID
		WHERE CN.FechaReg <= TMP.Fecha
			AND TMP.TotalPonderado BETWEEN CN.Minimo AND CN.Maximo
			AND (TMP.NivelRiesgoObt = Cadena_Vacia OR TMP.NivelRiesgoObt IS NULL);

		# INFORMACIÓN FINAL DEL REPORTE.
		SELECT
			Fecha,			Hora,			ClienteID,		NombreCompleto,		SucursalOrigen,
			NombreSucurs,	Porc1TotalAntec,Porc2Localidad,	Porc3ActividadEc,	Porc4TotalOriRe,
			Porc5TotalDesRe,Porc6TotalPerf,	Porc1TotalEBR,	TotalPonderado,		TipoProceso,
			CASE NivelRiesgoObt
				WHEN "A" THEN "ALTO"
				WHEN "M" THEN "MEDIO"
				ELSE "BAJO"
			END AS NivelRiesgoObt
		FROM TMPPLDNRIESGOXCTE;
		TRUNCATE TMPPLDNRIESGOXCTE;
	END IF;
END TerminaStore$$