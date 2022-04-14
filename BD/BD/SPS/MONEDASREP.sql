-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MONEDASREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `MONEDASREP`;DELIMITER $$

CREATE PROCEDURE `MONEDASREP`(
/*SP PARA EL REPORTE DE HISTORICO DE DIVISAS.*/
	Par_MonedaID			BIGINT(11), 		-- Moneda ID (ID de la DIVISA)
	Par_FechaInicio			DATE,				-- Fecha de Inicio
	Par_FechaFin			DATE,				-- Fecha Fin
	Par_NumCon				INT(11),			-- No. de Consulta

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
	DECLARE Var_Sentencia		VARCHAR(6000);		-- Sentencia SQL
	DECLARE Var_Filtro			VARCHAR(6000);		-- Sentencia SQL
	DECLARE Var_Consecutivo		VARCHAR(100);		-- Variable consecutivo
	DECLARE Var_Control			VARCHAR(100);		-- Variable de Control
	DECLARE Var_FechaActual		DATE;

	-- Declaracion de Constantes
	DECLARE ReporteHistorico	INT(11);			-- Reporte Historico de Divisas
	DECLARE Cadena_Vacia		CHAR(1);			-- Constante cadena vacia ''
	DECLARE Fecha_Vacia			DATE;				-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero			INT(1);				-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- DECIMAL cero
	-- Asignacion de Constantes
	SET ReporteHistorico		:= 1;
	SET Cadena_Vacia			:= '';
	SET Fecha_Vacia				:= '1900-01-01';
	SET Entero_Cero				:= 0;
	SET Decimal_Cero			:= 0;

	IF(Par_NumCon = ReporteHistorico) THEN
		SET Var_FechaActual	:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
		SET Par_MonedaID	:= IFNULL(Par_MonedaID, Entero_Cero);
		SET Par_FechaInicio	:= IFNULL(Par_FechaInicio, Fecha_Vacia);
		SET Par_FechaFin	:= IFNULL(Par_FechaFin, Fecha_Vacia);
		SET Var_Filtro		:= IFNULL(Var_Filtro, Cadena_Vacia);

		IF(Par_MonedaID != Entero_Cero) THEN
			SET Var_Filtro	:= CONCAT(Var_Filtro,' WHERE MonedaId = ',Par_MonedaID);
		END IF;

		IF(Par_FechaInicio != Fecha_Vacia AND Par_FechaFin != Fecha_Vacia) THEN
			SET Var_Filtro	:= CONCAT(IF(Var_Filtro = Cadena_Vacia," WHERE ",CONCAT(Var_Filtro," AND "))," FechaRegistro BETWEEN '",Par_FechaInicio,"' AND '", Par_FechaFin,"'");
		END IF;

		SET Var_Sentencia := CONCAT("SELECT * FROM
				(SELECT
				HIS.MonedaId,		HIS.Descripcion,		HIS.Simbolo,		HIS.TipCamComVen,		HIS.TipCamVenVen,
				HIS.TipCamComInt,	HIS.TipCamVenInt,		HIS.TipoMoneda,		HIS.TipCamFixCom,		HIS.TipCamFixVen,
				HIS.TipCamDof,		HIS.EqCNBVUIF,			HIS.EqBuroCred,		HIS.FechaRegistro
				FROM `HIS-MONEDAS` AS HIS
				UNION ALL
				SELECT
				MON.MonedaId,		MON.Descripcion,		MON.Simbolo,		MON.TipCamComVen,		MON.TipCamVenVen,
				MON.TipCamComInt,	MON.TipCamVenInt,		MON.TipoMoneda,		MON.TipCamFixCom,		MON.TipCamFixVen,
				MON.TipCamDof,		MON.EqCNBVUIF,			MON.EqBuroCred,		'",Var_FechaActual,"'
				FROM MONEDAS AS MON) AS MMM ", Var_Filtro);

		SET Var_Sentencia := CONCAT(Var_Sentencia, 'ORDER BY  FechaRegistro desc, MonedaId;');
		SET @Sentencia := (Var_Sentencia);
		PREPARE MONEDASREP FROM @Sentencia;
		EXECUTE MONEDASREP;
		DEALLOCATE PREPARE MONEDASREP;
	END IF;

END TerminaStore$$