-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APORTRENOVACIONESREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTRENOVACIONESREP`;
DELIMITER $$


CREATE PROCEDURE `APORTRENOVACIONESREP`(
# =============================================================
# ------------------ REPORTE DE RENOVACIONES ------------------
# =============================================================
	-- SP para generar el reporte de Aportaciones Vencidas
	Par_FechaInicial        DATE,       -- Fecha inicial
	Par_FechaFinal          DATE,       -- Fecha final
	Par_Estatus             CHAR(1),    -- Estatus
	Par_ClienteID           INT(11),    -- ID del Cliente
	Par_EmpresaID           INT(11),     -- Parametro de auditoria

	Aud_Usuario             INT(11),     -- Parametro de auditoria
	Aud_FechaActual         DATE,        -- Parametro de auditoria
	Aud_DireccionIP         VARCHAR(15), -- Parametro de auditoria
	Aud_ProgramaID          VARCHAR(50), -- Parametro de auditoria
	Aud_Sucursal            INT(11),     -- Parametro de auditoria

	Aud_NumTransaccion      BIGINT(20)   -- Parametro de auditoria
)
TerminaStore: BEGIN

	/*DECLARACION DE VARIABLES */
	DECLARE Var_Sentencia       VARCHAR(10000);         -- Sentencia SQL

	/*DECLARACION DE CONSTANTES */
	DECLARE Cadena_Vacia        VARCHAR(20);
	DECLARE Entero_Cero         INT;
	DECLARE Estatus_Vig         CHAR(1);
	DECLARE Estatus_Pag         CHAR(1);
	DECLARE Cons_NO				CHAR(1);
    DECLARE Cons_Reno			CHAR(1);

	/* ASIGNACION  DE CONSTANTES */
	SET	Entero_Cero		        := 0;      -- Constante entero cero
	SET Cadena_Vacia            := '';     -- Cadena vacia
	SET Estatus_Vig		        :='N';     -- Estatus vigente
	SET Estatus_Pag		        :='P';     -- Estatus pagado
	SET Cons_NO					:='N';     -- Constante NO
    SET Cons_Reno				:='R';

	SET Var_Sentencia := CONCAT('INSERT INTO TMPAPORTRENOVAREP (',
			'AportacionID,		ClienteID,			NombreCompleto,	PlazoOriginal,	FechaInicio, ',
			'FechaVencimiento,	MontoRenovacion,	TasaFija,		TasaBruta,		EstatusRenovacion, ',
			'AportacionRenovada,Motivo,				NumTransaccion,	TipoRenovacion,	TipoDocumento,',
			'TipoInteres) ',
		'SELECT ',
			'A.AportacionID,     C.ClienteID,            C.NombreCompleto,       A.PlazoOriginal, ',
			'A.FechaInicio,      A.FechaVencimiento,     O.MontoRenovacion,      A.TasaFija, ',
			'O.TasaBruta, IF(O.EstatusRenovacion = "R", "RENOVADA", "NO RENOVADA" ), ',
			'O.NuevaAportID, O.MotivoRenovacion, ', Aud_NumTransaccion,', ',
			'CASE 
				WHEN (O.TipoReinversion = "C") THEN "CAPITAL" 
				WHEN (O.TipoReinversion = "CI") THEN "CAPITAL + INTERESES"
				ELSE ""
			END AS TipoRenovacion, ',
			'CASE 
				WHEN O.ConsolidarSaldos =\'S\' THEN \'CONSOLIDACION\'
				ELSE UPPER(OpOri.NombreCorto) 
			END AS TipoDocumento, ',

			'CASE ',
				'WHEN (O.TipoPago = "V") THEN "AL VENCIMIENTO" ',
				'WHEN (O.TipoPago = "E" AND O.CapitalizaInteres="S") THEN "CAPITALIZABLE" ',
				'WHEN (O.TipoPago = "E" AND O.CapitalizaInteres="N") THEN "MENSUAL" ',
				'ELSE "" ',
				'END AS TipoInteres ',

		'FROM APORTACIONES A ',
		'INNER JOIN CONDICIONESVENCIMAPORT O ON O.AportacionID = A.AportacionID ',
		'INNER JOIN CLIENTES C ON C.ClienteID = A.ClienteID ',
		'LEFT JOIN APORTACIONOPCIONES OpOri ON OpOri.OpcionID = O.OpcionAportID ',
		'WHERE A.FechaVencimiento BETWEEN "', Par_FechaInicial, '" AND "', Par_FechaFinal, '"');

	IF(Par_Estatus != Cadena_Vacia) THEN
		SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' AND O.EstatusRenovacion = "', Par_Estatus, '"');
	ELSE
		SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' AND O.EstatusRenovacion IN ("R", "N")  ');
	END IF;

	IF(Par_ClienteID != Entero_Cero AND Par_ClienteID != Cadena_Vacia) THEN
		SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' AND C.ClienteID = ', Par_ClienteID, '');
	END IF;

	SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' ;');

	SET @Sentencia    = (Var_Sentencia);

	PREPARE STAPORTRENOVACIONESREP FROM @Sentencia;
	EXECUTE STAPORTRENOVACIONESREP;

	DEALLOCATE PREPARE STAPORTRENOVACIONESREP;

	# ACTUALIZACIÓN DE LAS APORTACIONES QUE FUERON CONSOLIDADAS Y RENOVARON.
	DROP TABLE IF EXISTS TMPAPORTCONSOLI;
	CREATE TABLE TMPAPORTCONSOLI
	SELECT
		AportacionID,
		GROUP_CONCAT(AportConsID) AS AportRenovadas,
		Aud_NumTransaccion AS NumTransaccion
	FROM APORTCONSOLIDADAS
	WHERE FechaVencimiento BETWEEN Par_FechaInicial AND Par_FechaFinal
	GROUP BY AportacionID;

	CREATE INDEX idx_TMPAPORTCONSOLI_1 ON TMPAPORTCONSOLI(AportacionID ,NumTransaccion);
	CREATE INDEX idx_TMPAPORTCONSOLI_2 ON TMPAPORTCONSOLI(NumTransaccion);


	# APORTACIONES QUE NO TUVIERON CONDICIONES Y SÓLO SE PAGARON.
	IF(Par_Estatus IN (Cons_NO,Cadena_Vacia))THEN
		SET Var_Sentencia := CONCAT('INSERT INTO TMPAPORTRENOVAREP (',
			'AportacionID,		ClienteID,				NombreCompleto,		PlazoOriginal,	FechaInicio, ',
			'FechaVencimiento,	MontoRenovacion,		TasaFija,			TasaBruta,		EstatusRenovacion, ',
			'AportacionRenovada,Motivo,					NumTransaccion,		TipoRenovacion,	TipoDocumento, ',
			'TipoInteres) ',
		'SELECT ',
			'A.AportacionID,	C.ClienteID,			C.NombreCompleto,	A.PlazoOriginal, ',
			'A.FechaInicio,		A.FechaVencimiento,
			CASE
				WHEN (A.Estatus = "N" AND A.Reinvertir = "C" AND A.OpcionAport = 3) THEN (A.Monto-A.CantidadReno)
				WHEN (A.Estatus = "N" AND A.Reinvertir = "C" AND A.OpcionAport = 2) THEN (A.Monto+A.CantidadReno)
				WHEN (A.Estatus = "N" AND A.Reinvertir = "CI" AND A.OpcionAport = 3) THEN A.InteresRecibir + (A.Monto-A.CantidadReno)
				WHEN (A.Estatus = "N" AND A.Reinvertir = "CI" AND A.OpcionAport = 2) THEN A.InteresRecibir + (A.Monto+A.CantidadReno)
				WHEN (A.Estatus = "N" AND A.Reinvertir = "C" AND A.OpcionAport = 4) THEN A.Monto
				WHEN (A.Estatus = "N" AND A.Reinvertir = "CI" AND A.OpcionAport = 4) THEN A.Monto+A.InteresRecibir
				ELSE 0
			END,
			A.TasaFija, ',
			'A.TasaNeta, IF(A.Estatus = "N","PENDIENTE","NO RENOVADA"), ',
			'0, A.MotivoCancela, ', Aud_NumTransaccion,', ',
			'CASE 
				WHEN (O.TipoReinversion = "C") THEN "CAPITAL" 
				WHEN (O.TipoReinversion = "CI") THEN "CAPITAL + INTERESES"
		 		ELSE ""
			END AS TipoRenovacion, ',
			'CASE 
				WHEN O.ConsolidarSaldos =\'S\' THEN \'CONSOLIDACION\'
				ELSE UPPER(OpOri.NombreCorto) 
			END AS TipoDocumento, ',

			'CASE ',
				'WHEN (O.TipoPago = "V") THEN "AL VENCIMIENTO" ',
				'WHEN (O.TipoPago = "E" AND O.CapitalizaInteres="S") THEN "CAPITALIZABLE" ',
				'WHEN (O.TipoPago = "E" AND O.CapitalizaInteres="N") THEN "MENSUAL" ',
				'ELSE "" ',
			'END AS TipoInteres ',
			'FROM APORTACIONES A ',
			'INNER JOIN CLIENTES C ON C.ClienteID = A.ClienteID ',
			'LEFT JOIN CONDICIONESVENCIMAPORT O ON O.AportacionID = A.AportacionID ',
			'LEFT JOIN APORTACIONOPCIONES OpOri ON OpOri.OpcionID = O.OpcionAportID ',
			'WHERE A.FechaVencimiento BETWEEN "', Par_FechaInicial, '" AND "', Par_FechaFinal, '" ',
			'AND (A.Estatus = "',Estatus_Pag, '" OR (A.Estatus = "N" AND A.OpcionAport IN (2,3,4)))',
			'AND A.ConCondiciones = "',Cons_NO,'" ',
			'AND A.Reinversion = "F" '
		);

		IF(Par_ClienteID != Entero_Cero AND Par_ClienteID != Cadena_Vacia) THEN
			SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' AND C.ClienteID = ', Par_ClienteID, '');
		END IF;

		SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' ;');

		SET @Sentencia := (Var_Sentencia);

		PREPARE APORTRENOVACIONESREP_NO FROM @Sentencia;
		EXECUTE APORTRENOVACIONESREP_NO;
		DEALLOCATE PREPARE APORTRENOVACIONESREP_NO;
	END IF;

	SELECT
		R.AportacionID,		R.ClienteID,	R.NombreCompleto,	R.PlazoOriginal,		R.FechaInicio,
		R.FechaVencimiento,	R.TasaFija,		R.TasaBruta,		R.EstatusRenovacion,	IFNULL(AC.AportRenovadas,R.AportacionRenovada) AS AportacionRenovada,
		R.Motivo,			FORMAT(R.MontoRenovacion, 2) AS MontoRenovacion, 			R.TipoRenovacion,
		IFNULL(R.TipoDocumento,Cadena_Vacia) AS TipoDocumento,	R.TipoInteres
	FROM TMPAPORTRENOVAREP R
	LEFT JOIN TMPAPORTCONSOLI AC ON R.AportacionID = AC.AportacionID
	AND R.NumTransaccion = AC.NumTransaccion
	WHERE R.NumTransaccion = Aud_NumTransaccion
	ORDER BY R.AportacionID;

	DELETE FROM TMPAPORTRENOVAREP
	WHERE NumTransaccion = Aud_NumTransaccion;
	DELETE FROM TMPAPORTCONSOLI
	WHERE NumTransaccion = Aud_NumTransaccion;

END TerminaStore$$