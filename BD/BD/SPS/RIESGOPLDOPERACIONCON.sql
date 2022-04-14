-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RIESGOPLDOPERACIONCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `RIESGOPLDOPERACIONCON`;DELIMITER $$

CREATE PROCEDURE `RIESGOPLDOPERACIONCON`(
	-- SP Para consultar la evaluacion de alguna operacion  del cliente
    Par_ClienteID 					BIGINT(20),			-- Cliente a consultar
    Par_TipoProceso					VARCHAR(50),		-- Tipo de proceso CREDITO, CTAAHORRO etc
    Par_OperProcesoID				BIGINT(12),			-- Num. de transaccion
	Par_NumCon						INT(11),			-- Tipo de Consulta

    Par_EmpresaID       			INT(11),  			-- Auditoria
    Aud_Usuario         			INT(11),			-- Auditoria
    Aud_FechaActual     			DATETIME,			-- Auditoria
    Aud_DireccionIP     			VARCHAR(15),		-- Auditoria
    Aud_ProgramaID      			VARCHAR(50),		-- Auditoria
    Aud_Sucursal        			INT(11),			-- Auditoria

    Aud_NumTransaccion  			BIGINT(20) 			-- Auditoria
)
TerminaStore: BEGIN
	-- Declaracion de variables
    DECLARE Var_MatrizEvaluacion	INT;				-- Para guardar el num. de matriz con que fue evaluada la tabla
    DECLARE Var_TipoConsulta		INT;				-- Para determinar el fragmento de cogigo a ejecutar

	-- Declaracion de Constantes
	DECLARE Con_MatrizActual		INT;
    DECLARE Con_MatrizHistoricos	INT;
    DECLARE Entero_Cero				INT;
    DECLARE Cumple_CriterioSI		CHAR(1);
	DECLARE Cumple_CriterioNO		CHAR(1);

	DECLARE TotalPonderadoID		INT;
	DECLARE TotalPuntajeID			INT;
	DECLARE TotalPorcentajeID		INT;
	DECLARE TotalNivelRiesgoID		INT;

	DECLARE Text_TotPonderado 		VARCHAR(50);
	DECLARE Text_TotPuntaje   		VARCHAR(50);
	DECLARE Text_TotPorcentaje 		VARCHAR(50);
	DECLARE Text_NivelRiesgo 		VARCHAR(50);

	-- Asignacion de Constantes
	SET	Con_MatrizActual			:= 1;							-- Consulta Matriz Actual
    SET	Con_MatrizHistoricos		:= 2;							-- Consulta Matriz Historico
    SET Entero_Cero					:= 0;							-- Entero 0
    SET Cumple_CriterioSI			:= 'S';							-- Cumple Criterio Matriz de Riesgos
	SET Cumple_CriterioNO			:= 'N';							-- No cumple Cumple Criterio de la matriz

    SET TotalPonderadoID			:= 901;							-- Titulo columna totales
	SET TotalPuntajeID				:= 902;							-- Titulo columna totales
	SET TotalPorcentajeID			:= 903;							-- Titulo columna totales
	SET TotalNivelRiesgoID			:= 904; 						-- Titulo columna totales

	SET Text_TotPonderado 			:= 'Total Puntaje Que Aplica';	-- Texto de columna de totales
	SET Text_TotPuntaje   			:= 'Puntaje Obtenido';			-- Texto de columna de totales
	SET Text_TotPorcentaje 			:= 'Porcentaje de Puntos';		-- Texto de columna de totales
	SET Text_NivelRiesgo 			:= 'Nivel de Riesgo';			-- Texto de columna de totales


    # Obtenemos el codigo de matriz con que fue evaluada la operacion
	SET Var_MatrizEvaluacion := (SELECT CodigoMatriz FROM PLDEVALUAPROCESOENC
										WHERE  OperProcID=Par_OperProcesoID AND
												ClienteID= Par_ClienteID AND
												TipoProceso=Par_TipoProceso LIMIT 1);

	# Evaluamos la existencia de ese codigo de matriz
	IF EXISTS (SELECT CodigoMatriz  FROM CATMATRIZRIESGO WHERE  Var_MatrizEvaluacion=CodigoMatriz) THEN
		SET Var_TipoConsulta =1;  -- Consulta Matriz Actual
	ELSE
		SET Var_TipoConsulta =2;  -- Consulta Matriz HISTORICO
	END IF;

   # Consulta 1.- Consulta los parametros de evaluacion de la operacion en la matriz actual
	IF (Var_TipoConsulta=Con_MatrizActual) THEN
		(SELECT
			CASE
				WHEN det.ConceptoMatrizID = 10 THEN 6
				WHEN det.ConceptoMatrizID = 11 THEN 7
				WHEN det.ConceptoMatrizID > 5  AND det.ConceptoMatrizID < 15 THEN det.ConceptoMatrizID +2
				ELSE det.ConceptoMatrizID
			END ConceptoMatrizID,
                Concepto,
                Descripcion,
                Valor AS PonderadoMatriz,
                LimiteValida AS Limite,
                Cumple AS CumpleCriterio,
				(CASE WHEN  Cumple = Cumple_CriterioSI THEN Valor ELSE Entero_Cero END) AS PuntajeObtenido

			FROM PLDEVALUAPROCESODET det
				INNER JOIN PLDEVALUAPROCESOENC enc
				INNER JOIN CATMATRIZRIESGO cat
					ON  cat.CodigoMatriz = enc.CodigoMatriz
					AND det.OperacionID=enc.OperacionID
					AND det.ConceptoMatrizID = cat.ConceptoMatrizID
					WHERE enc.OperProcID =Par_OperProcesoID AND enc.ClienteID= Par_ClienteID AND enc.TipoProceso=Par_TipoProceso)

			UNION (SELECT TotalPonderadoID,Text_TotPonderado ,Text_TotPonderado ,Entero_Cero,Entero_Cero,Cumple_CriterioNO,FORMAT(PuntajeTotal,Entero_Cero)
							FROM PLDEVALUAPROCESOENC WHERE OperProcID =Par_OperProcesoID)
			UNION (SELECT TotalPuntajeID	,Text_TotPuntaje,Text_TotPuntaje,Entero_Cero,Entero_Cero,Cumple_CriterioNO,FORMAT(PuntajeObtenido,Entero_Cero)
							FROM PLDEVALUAPROCESOENC WHERE OperProcID =Par_OperProcesoID)
			UNION (SELECT TotalPorcentajeID,Text_TotPorcentaje,Text_TotPorcentaje,Entero_Cero,Entero_Cero,Cumple_CriterioNO,Porcentaje
							FROM PLDEVALUAPROCESOENC WHERE OperProcID =Par_OperProcesoID)
			UNION (SELECT TotalNivelRiesgoID	,Text_NivelRiesgo ,Text_NivelRiesgo,Entero_Cero,Entero_Cero,Cumple_CriterioNO,Descripcion
							FROM PLDEVALUAPROCESOENC AS PC,CATNIVELESRIESGO AS CN
							WHERE OperProcID =Par_OperProcesoID
							AND NivelRiesgoID=NivelRiesgo
							AND PC.TipoPersona = CN.TipoPersona)
				ORDER BY ConceptoMatrizID;
    END IF;

	# Consulta 2.- Consulta los parametros de evaluacion de la operacion en la matriz historica
    IF (Var_TipoConsulta=Con_MatrizHistoricos) THEN
		(SELECT
			CASE
				WHEN det.ConceptoMatrizID = 10 THEN 6
				WHEN det.ConceptoMatrizID = 11 THEN 7
				WHEN det.ConceptoMatrizID > 5  AND det.ConceptoMatrizID < 15 THEN det.ConceptoMatrizID +2
				ELSE det.ConceptoMatrizID
			END ConceptoMatrizID,
                Concepto,
                Descripcion,
                Valor AS PonderadoMatriz,
                LimiteValida AS Limite,
                Cumple AS CumpleCriterio,
				(CASE WHEN  Cumple = Cumple_CriterioSI THEN Valor ELSE Entero_Cero END) AS PuntajeObtenido

			FROM PLDEVALUAPROCESODET det
				INNER JOIN PLDEVALUAPROCESOENC enc
				INNER JOIN HISCATMATRIZRIESGO cat
					ON  cat.CodigoMatriz = enc.CodigoMatriz
					AND det.OperacionID=enc.OperacionID
					AND det.ConceptoMatrizID = cat.ConceptoMatrizID
					WHERE enc.OperProcID =Par_OperProcesoID AND enc.ClienteID= Par_ClienteID AND enc.TipoProceso=Par_TipoProceso)

			UNION (SELECT TotalPonderadoID,Text_TotPonderado,Text_TotPonderado,Entero_Cero,Entero_Cero,Cumple_CriterioNO,FORMAT(PuntajeTotal,Entero_Cero)
							FROM PLDEVALUAPROCESOENC WHERE OperProcID =Par_OperProcesoID)
			UNION (SELECT TotalPuntajeID,Text_TotPuntaje ,Text_TotPuntaje ,Entero_Cero,Entero_Cero,Cumple_CriterioNO,FORMAT(PuntajeObtenido,Entero_Cero)
							FROM PLDEVALUAPROCESOENC WHERE OperProcID =Par_OperProcesoID)
			UNION (SELECT TotalPorcentajeID,Text_TotPorcentaje,Text_TotPorcentaje,Entero_Cero,Entero_Cero,Cumple_CriterioNO,Porcentaje
							FROM PLDEVALUAPROCESOENC WHERE OperProcID =Par_OperProcesoID)
			UNION (SELECT TotalNivelRiesgoID	,Text_NivelRiesgo ,Text_NivelRiesgo ,Entero_Cero,Entero_Cero,Cumple_CriterioNO,Descripcion
							FROM PLDEVALUAPROCESOENC AS PC,CATNIVELESRIESGO  AS CN
							WHERE OperProcID =Par_OperProcesoID
							AND NivelRiesgoID=NivelRiesgo
							AND PC.TipoPersona = CN.TipoPersona)
				ORDER BY ConceptoMatrizID;
    END IF;

END TerminaStore$$