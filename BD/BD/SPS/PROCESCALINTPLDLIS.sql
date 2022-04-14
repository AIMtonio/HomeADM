-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROCESCALINTPLDLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PROCESCALINTPLDLIS`;DELIMITER $$

CREATE PROCEDURE `PROCESCALINTPLDLIS`(
    Par_Descripcion     VARCHAR(100),
    Par_NumLis          TINYINT UNSIGNED,
    /* Parametros de Auditoria */
    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,

    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
)
TerminaStore: BEGIN

/* Declaracion de Variables */
DECLARE Var_AplicaCaptacion		CHAR(1);

/* Declaracion de Constantes */
DECLARE Cadena_Vacia			CHAR(1);
DECLARE ValorSI					CHAR(1);
DECLARE ValorNO					CHAR(1);
DECLARE Fecha_Vacia				DATE;
DECLARE Entero_Cero             INT(11);
DECLARE Lis_Principal			INT(11);
DECLARE Lis_ReporteRiesgo		INT(11);
DECLARE EvaluacionPeriodica     VARCHAR(16);
DECLARE CuentaAhorro            VARCHAR(16);
DECLARE Inversion       		VARCHAR(16);

/* Asignacion de Constantes */
SET Cadena_Vacia    		:= '';
SET ValorSI		    		:= 'S';
SET ValorNO		    		:= 'N';
SET Fecha_Vacia     		:= '1900-01-01';
SET Entero_Cero             := 0;
SET Lis_Principal   		:= 1;
SET Lis_ReporteRiesgo  		:= 2;
SET EvaluacionPeriodica     := 'EVALPERIODO';-- Tipo de Procedimiento: Evaluacion Periodica ID de PROCESCALINTPLD
SET CuentaAhorro            := 'CTAAHO';-- Tipo de Procedimiento: Cuentas de Ahorro ID de PROCESCALINTPLD
SET Inversion       		:= 'INVERSION';-- Tipo de Procedimiento: inversiones ID de PROCESCALINTPLD

-- SE OBTIENE EL TIPO DE INSTITUCIÓN FINANCIERA
SET Var_AplicaCaptacion := (SELECT
				             CASE Tip.NombreCorto
				                WHEN 'sofipo'   THEN ValorSI
				                WHEN 'scap'     THEN ValorSI ELSE ValorNO END as AplicaCaptacion
				            FROM PARAMETROSSIS Par
				                INNER JOIN INSTITUCIONES Ins ON Par.InstitucionID = Ins.InstitucionID
				                INNER JOIN TIPOSINSTITUCION Tip ON Ins.TipoInstitID = Tip.TipoInstitID);

/* LISTA SÓLO LOS PROCESOS QUE NO SON DE LA EVALUACIÓN PERIÓDICA */
IF(Par_NumLis = Lis_Principal) THEN
    SELECT ProcesoEscID, Descripcion
      FROM PROCESCALINTPLD
        WHERE ProcesoEscID != EvaluacionPeriodica
        	AND IF(Var_AplicaCaptacion = ValorSI, AplicaCaptacion IN (ValorSI,ValorNO), AplicaCaptacion = ValorSI)
        ORDER BY Orden
    LIMIT 0, 30;
END IF;

/* LISTA TODOS LOS PROCESOS PARA PODER GENERAR EL REPORTE HISTORICO DE RIESGO*/
IF(Par_NumLis = Lis_ReporteRiesgo) THEN
    SELECT ProcesoEscID, Descripcion
      FROM PROCESCALINTPLD
        WHERE IF(Var_AplicaCaptacion = ValorSI, AplicaCaptacion IN (ValorSI,ValorNO), AplicaCaptacion = ValorSI)
        ORDER BY Orden
    LIMIT 0, 30;
END IF;

END TerminaStore$$