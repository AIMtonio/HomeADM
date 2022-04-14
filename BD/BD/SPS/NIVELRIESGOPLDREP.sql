-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- NIVELRIESGOPLDREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `NIVELRIESGOPLDREP`;DELIMITER $$

CREATE PROCEDURE `NIVELRIESGOPLDREP`(
-- Store para reporte de riesgos LD del cliente
	Par_ClienteID			BIGINT(11), 		-- Cliente ID
	Par_NumCon				INT(11),			-- No. de Consulta
	Par_FechaInicio			DATE,				-- Para consulta historico op. riegosas
	Par_FechaFin			DATE,				-- Para consulta historico op. riegosas
	Par_ProcesoEscID		VARCHAR(16),		-- No. Proceso de Escalamiento (Evaluación)

	/* Parametros de Auditoria */
	Par_EmpresaID       	INT(11),
	Aud_Usuario         	INT(11),
	Aud_FechaActual     	DATETIME,
	Aud_DireccionIP     	VARCHAR(15),
	Aud_ProgramaID      	VARCHAR(50),

	Aud_Sucursal        	INT(11),
	Aud_NumTransaccion  	BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia					CHAR(1);
	DECLARE SalidaNO						CHAR(1);
	DECLARE Entero_Cero						INT(1);
	DECLARE Espacio_Vacio					CHAR(1);
	DECLARE Simbolo_Porcentaje				CHAR(1);

	DECLARE Limite_ConceptosMatriz			INT;
	DECLARE TotalPonderadoID				INT;
	DECLARE TotalPuntajeID					INT;
	DECLARE TotalPorcentajeID				INT;
	DECLARE TotalNivelRiesgoID				INT;

	DECLARE Con_Encabezado				 	INT(1);
	DECLARE Con_RiesgoActualCliente			INT(1);
	DECLARE Con_OperacionesRiesgosasCliente INT(1);
	DECLARE Con_BitacoraHist				INT(1);
	DECLARE EvaluacionPeriodica				VARCHAR(16);

	-- Declaracion de variables
	DECLARE Var_TotalPuntaje				INT;
	DECLARE Var_PuntajeObtenido				INT;
	DECLARE Var_PorcentajeObtenido			DECIMAL(5,2);
	DECLARE Var_NivelRiesgo 				VARCHAR(50);
	DECLARE Var_NumErr						INT(11);
	DECLARE Var_Errm						VARCHAR(400);
	DECLARE Var_Sentencia					VARCHAR(20000);

	-- Asignacion de constantes
	SET Cadena_Vacia						:='';			-- Cadena vacia
	SET SalidaNO							:='N';			-- No Salida
	SET Entero_Cero							:= 0;			-- Entero Cero
	SET Espacio_Vacio						:=' ';
	SET Simbolo_Porcentaje					:='%';

	SET Limite_ConceptosMatriz				:= 900;
	SET TotalPonderadoID					:= 901;			-- Titulo columna totales
	SET TotalPuntajeID						:= 902;			-- Titulo columna totales
	SET TotalPorcentajeID					:= 903;			-- Titulo columna totales
	SET TotalNivelRiesgoID					:= 904; 		-- Titulo columna totales

	SET Con_Encabezado						:= 1; 			-- Consulta los datos del cliente
	SET Con_RiesgoActualCliente				:= 2; 			-- Consulta el riesgo actual del cliente
	SET Con_OperacionesRiesgosasCliente		:= 3;			-- Consulta historico de operaciones riesgosas del cliente
	SET Con_BitacoraHist					:= 4;			-- Consulta bitacora de ejecución
	SET EvaluacionPeriodica					:= 'EVALPERIODO';-- Tipo de Procedimiento: Evaluacion Periodica ID de PROCESCALINTPLD

	IF(Par_NumCon=Con_Encabezado) THEN
		SELECT ClienteID,NombreCompleto FROM CLIENTES WHERE ClienteID=Par_ClienteID;
	END IF;


	IF(Par_NumCon=Con_RiesgoActualCliente) THEN

		CALL RIESGOPLDCTEPRO(Par_ClienteID, SalidaNO,Var_NumErr,Var_Errm,Par_EmpresaID,Aud_Usuario,Aud_FechaActual, Aud_DireccionIP,Aud_ProgramaID,	Aud_Sucursal,Aud_NumTransaccion);

		SELECT PuntajeObtenido INTO Var_TotalPuntaje FROM TMPPLDNIVELRIESGO WHERE ConceptoMatrizID=TotalPonderadoID AND NumTransaccion = Aud_NumTransaccion;
		SELECT PuntajeObtenido INTO Var_PuntajeObtenido FROM TMPPLDNIVELRIESGO WHERE ConceptoMatrizID=TotalPuntajeID AND NumTransaccion = Aud_NumTransaccion;
		SELECT PuntajeObtenido INTO Var_PorcentajeObtenido FROM TMPPLDNIVELRIESGO WHERE ConceptoMatrizID=TotalPorcentajeID AND NumTransaccion = Aud_NumTransaccion;
		SELECT PuntajeObtenido INTO Var_NivelRiesgo FROM TMPPLDNIVELRIESGO WHERE ConceptoMatrizID=TotalNivelRiesgoID AND NumTransaccion = Aud_NumTransaccion;

		SELECT
			CASE
				WHEN   ConceptoMatrizID = 10 THEN 6
				WHEN   ConceptoMatrizID = 11 THEN 7
				WHEN   ConceptoMatrizID > 5 AND ConceptoMatrizID < 15 THEN ConceptoMatrizID +2
				ELSE ConceptoMatrizID
			END ConceptoMatrizID, Concepto,
			CASE
				WHEN Limite != Entero_Cero THEN CONCAT(Descripcion,' ',Limite)
				ELSE Descripcion
			END AS Descripcion,
			FORMAT(PonderadoMatriz, Entero_Cero) AS PonderadoMatriz,
			FORMAT(Limite, Entero_Cero) AS Limite,
			CumpleCriterio,PuntajeObtenido, Var_TotalPuntaje,Var_PuntajeObtenido,
			CONCAT(Var_PorcentajeObtenido,Simbolo_Porcentaje) AS Var_PorcentajeObtenido,
			Var_NivelRiesgo
		  FROM TMPPLDNIVELRIESGO
			WHERE ConceptoMatrizID < Limite_ConceptosMatriz
				AND NumTransaccion = Aud_NumTransaccion
			ORDER BY ConceptoMatrizID;
	END IF;

	IF(Par_NumCon=Con_OperacionesRiesgosasCliente)THEN
		SET Var_Sentencia := CONCAT(
			'SELECT cli.ClienteID, cli.NombreCompleto, ',
    			   'OperProcID, enc.TipoProceso, pro.Descripcion AS Proceso, PuntajeTotal, PuntajeObtenido, ',
				   'CONCAT(IF(enc.TipoProceso!=\'',EvaluacionPeriodica,'\',enc.Porcentaje, ',
				   		'IFNULL(enc.PorcentajeAnterior, ',Entero_Cero,')), \'',Simbolo_Porcentaje,'\') as PorcentajeAnterior, ',
				   'CONCAT(Porcentaje,\'',Simbolo_Porcentaje,'\') AS Porcentaje, ',
				   'CASE IF(enc.TipoProceso =\'',EvaluacionPeriodica,'\',enc.NivelRiesgoAnterior,enc.NivelRiesgo) ',
				   		'WHEN \'A\' THEN \'ALTO\' ',
				   		'WHEN \'M\' THEN \'MEDIO\' ',
				   		'ELSE \'BAJO\' ',
				   		'END AS NivelAnterior, ',
				   'CASE enc.NivelRiesgo ',
						'WHEN \'A\' THEN \'ALTO\' ',
						'WHEN \'M\' THEN \'MEDIO\' ',
				   		'ELSE \'BAJO\' ',
						'END AS NivelRiesgo, ',
					'DATE(FechaEvaluacion) AS FechaEvaluacion ',

			'FROM CLIENTES AS cli INNER JOIN PLDEVALUAPROCESOENC AS enc ON(cli.ClienteID = enc.ClienteID) ',
    			'INNER JOIN PROCESCALINTPLD AS pro ON(enc.TipoProceso = pro.ProcesoEscID) ',

					'WHERE FechaEvaluacion >= \'',Par_FechaInicio,'\' ',
						'AND FechaEvaluacion <= \'',Par_FechaFin,'\' ');

		IF(IFNULL(Par_ClienteID, Entero_Cero) != Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, 'AND cli.ClienteID = ',Par_ClienteID,' ');
		END IF;

		IF(IFNULL(Par_ProcesoEscID, Entero_Cero) != Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, 'AND pro.ProcesoEscID = \'',Par_ProcesoEscID,'\' ');
		END IF;

		SET Var_Sentencia := CONCAT(Var_Sentencia, 'ORDER BY cli.ClienteID, OperProcID, pro.Orden, FechaEvaluacion; ');
		SET @Sentencia := (Var_Sentencia);

		PREPARE REPORTEOPRIESGOSAS FROM @Sentencia;
		EXECUTE REPORTEOPRIESGOSAS;
		DEALLOCATE PREPARE REPORTEOPRIESGOSAS;

	END IF;

	IF(Par_NumCon=Con_BitacoraHist) THEN
		DROP TABLE IF EXISTS TMPBITACORAEVALPLD;
		CREATE TABLE IF NOT EXISTS TMPBITACORAEVALPLD(
			FechaEvaluacion		DATE,
			TotalRegistros		BIGINT(11),
			TotalCambios		BIGINT(11),
			INDEX(FechaEvaluacion)
		);

		DROP TABLE IF EXISTS TMPBITACORAMODIF;
		CREATE TABLE IF NOT EXISTS TMPBITACORAMODIF(
			FechaEvaluacion		DATE,
			TotalCambios		BIGINT(11),
			INDEX(FechaEvaluacion)
		);

		-- SE GUARDA EL TOTAL DE REGISTROS POR FECHA DE EVALUACIÓN.
		INSERT INTO TMPBITACORAEVALPLD (FechaEvaluacion, TotalRegistros, TotalCambios)
		SELECT DATE(FechaEvaluacionMatriz), COUNT(*), Entero_Cero
			FROM EVALUACIONCTEMATRIZ
		GROUP BY FechaEvaluacionMatriz;

		-- SE ACTUALIZA EL TOTAL DE REGISTROS DE CLIENTES QUE CAMBIARON DE NIVEL EN LA ULTIMA EVALUACIÓN.
		INSERT INTO TMPBITACORAMODIF (FechaEvaluacion, TotalCambios)
		SELECT DATE(FechaEvaluacionMatriz), COUNT(*)
			FROM EVALUACIONCTEMATRIZ
		WHERE NivelRiesgo != NivelRiesgoAnterior
		GROUP BY FechaEvaluacionMatriz;

		-- SE GUARDA EL TOTAL DE REGISTROS POR FECHA DE EVALUACIÓN.
		INSERT INTO TMPBITACORAEVALPLD (FechaEvaluacion, TotalRegistros, TotalCambios)
		SELECT DATE(FechaEvaluacionMatriz), COUNT(*), Entero_Cero
			FROM HISEVALUACTEMATRIZ
		GROUP BY FechaEvaluacionMatriz;

		-- SE ACTUALIZA EL TOTAL DE REGISTROS DE CLIENTES QUE CAMBIARON DE NIVEL EN LA ULTIMA EVALUACIÓN.
		INSERT INTO TMPBITACORAMODIF (FechaEvaluacion, TotalCambios)
		SELECT DATE(FechaEvaluacionMatriz), COUNT(*)
			FROM HISEVALUACTEMATRIZ
		WHERE NivelRiesgo != NivelRiesgoAnterior
		GROUP BY FechaEvaluacionMatriz;

		-- SE ACTUALIZAN LOS TOTALES DE REGISTROS QUE FUERON MODIFICADOS.
		UPDATE TMPBITACORAEVALPLD TE INNER JOIN TMPBITACORAMODIF TM
			ON (TE.FechaEvaluacion = TM.FechaEvaluacion)
		SET TE.TotalCambios = TM.TotalCambios;

		-- RESULTADO DEL REPORTE.
		SELECT FechaEvaluacion, TotalRegistros, TotalCambios
			FROM TMPBITACORAEVALPLD
			WHERE FechaEvaluacion BETWEEN Par_FechaInicio AND Par_FechaFin;

	END IF;

END TerminaStore$$