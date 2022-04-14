DELIMITER ;
DROP PROCEDURE IF EXISTS `RELACIONADOSFISCALESCON`;
DELIMITER $$
CREATE PROCEDURE `RELACIONADOSFISCALESCON` (
# ==========================================================================
# ------ STORED PARA CONSULTA DE RELACIONADOS FISCALES  -----------------------
# ==========================================================================
	Par_ClienteID				INT(11),		-- ID del cliente tabla CLIENTES
    Par_Ejercicio				INT(11),		-- Anio del ejercicio
	Par_NumCon					INT(11),		-- Numero de consulta

	Par_EmpresaID 				INT(11), 		-- Parametro de Auditoria
	Aud_Usuario 				INT(11), 		-- Parametro de Auditoria
	Aud_FechaActual 			DATETIME, 		-- Parametro de Auditoria
	Aud_DireccionIP 			VARCHAR(15), 	-- Parametro de Auditoria
	Aud_ProgramaID 				VARCHAR(50), 	-- Parametro de Auditoria
	Aud_Sucursal 				INT(11), 		-- Parametro de Auditoria
	Aud_NumTransaccion 			BIGINT(20) 		-- Parametro de Auditoria
)
TerminaStore:BEGIN

	-- Declaracion de Constantes
	DECLARE Entero_Cero			INT(11);
	DECLARE Decimal_Cero		DECIMAL(12,2);
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE SalidaSI			CHAR(1);
	DECLARE Fecha_Vacia			DATE;

	DECLARE Con_Participacion	INT(11);		-- Consulta 1: participacion del cliente
	DECLARE TipoRel_Cte			CHAR(1);		-- Tipo de relacionado cliente
    DECLARE Cont_SI				CHAR(1);		-- Constante si

	-- Seteo de valores
	SET Entero_Cero     	:= 0;
	SET Decimal_Cero     	:= 0.0;
	SET Cadena_Vacia    	:= '';
	SET SalidaSI        	:= 'S';
	SET Fecha_Vacia     	:= '1900-01-01';

	SET Con_Participacion	:= 1;
    SET TipoRel_Cte			:= 'C';
    SET Cont_SI				:= 'S';

    -- Consulta 1: participacion del cliente
	IF(Par_NumCon = Con_Participacion)THEN
		SELECT 	REL.ParticipaFiscalCte
        FROM RELACIONADOSFISCALES REL
		WHERE REL.ClienteID = Par_ClienteID
			AND REL.Ejercicio = Par_Ejercicio
		GROUP BY REL.ParticipaFiscalCte;
	END IF;

END TerminaStore$$