-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INTERESESPAGADOSREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `INTERESESPAGADOSREP`;DELIMITER $$

CREATE PROCEDURE `INTERESESPAGADOSREP`(
# ==========================================================
# ----- SP PARA GENERAR REPORTE DE INTERESES PAGADOS -------
# ==========================================================
	Par_FechaInicio		DATE,			-- Fecha de Inicio
	Par_FechaFin		DATE,			-- Fecha Final

    Par_EmpresaID       INT(11),		-- Parametro de Auditoria
    Aud_Usuario         INT(11),		-- Parametro de Auditoria
    Aud_FechaActual     DATETIME,		-- Parametro de Auditoria
    Aud_DireccionIP     VARCHAR(15),	-- Parametro de Auditoria
    Aud_ProgramaID      VARCHAR(50),	-- Parametro de Auditoria
    Aud_Sucursal        INT(11),		-- Parametro de Auditoria
    Aud_NumTransaccion  BIGINT(20)		-- Parametro de Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);
    DECLARE Decimal_Cero		DECIMAL(14,2);

	-- Asignacion de Constantes
	SET	Cadena_Vacia			:= '';				-- Cadena Vacia
	SET	Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
	SET	Entero_Cero				:= 0;				-- Entero Cero
    SET Decimal_Cero			:= 0.00;			-- Decimal Cero


    DELETE FROM  TMPINTERESPAGADOSREP;

    INSERT INTO TMPINTERESPAGADOSREP(
				Fecha, 			ClienteID, 			NombreCompleto,			InstrumentoID,			FechaInicio,
				FechaFin,		Monto,				TasaInteres,			InteresGenerado,		ISR,
				InteresReal)
	(SELECT		CAL.Fecha,		CAL.ClienteID, 		CL.NombreCompleto,		CAL.InstrumentoID, 		CAL.FechaInicio,
				CAL.FechaFin,	IFNULL(CAL.Monto,Decimal_Cero), 			IFNULL(CAL.TasaInteres,Decimal_Cero),
                IFNULL(CAL.InteresGenerado,Decimal_Cero),					IFNULL(ISR,Decimal_Cero),
				CAL.InteresReal
		FROM	CALCULOINTERESREAL AS CAL
				INNER JOIN CLIENTES AS CL ON CAL.ClienteID = CL.ClienteID
		WHERE	CAL.Fecha >= Par_FechaInicio AND CAL.Fecha <= Par_FechaFin)

	UNION ALL

	(SELECT		CAL.Fecha,		CAL.ClienteID, 		CL.NombreCompleto,		CAL.InstrumentoID, 		CAL.FechaInicio,
				CAL.FechaFin,	IFNULL(CAL.Monto,Decimal_Cero), 			IFNULL(CAL.TasaInteres,Decimal_Cero),
                IFNULL(CAL.InteresGenerado,Decimal_Cero),					IFNULL(ISR,Decimal_Cero),
				CAL.InteresReal
		FROM	HISCALINTERESREAL AS CAL
				INNER JOIN CLIENTES AS CL ON CAL.ClienteID = CL.ClienteID
		WHERE	CAL.Fecha >= Par_FechaInicio AND CAL.Fecha <= Par_FechaFin);


    SELECT		CAL.ClienteID, 										CAL.NombreCompleto,	CAL.InstrumentoID, 		CAL.FechaInicio AS FechaApertura,	CAL.FechaFin AS FechaVencimiento,
				(DATEDIFF(CAL.FechaFin,CAL.FechaInicio)) AS NumDias,CAL.Monto, 			CAL.TasaInteres,		CAL.InteresGenerado AS InteresesGen,ISR,
				CAL.InteresReal
		FROM	TMPINTERESPAGADOSREP AS CAL;



END TerminaStore$$