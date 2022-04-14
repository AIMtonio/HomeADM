-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONCEPTOSINVAGROCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONCEPTOSINVAGROCON`;DELIMITER $$

CREATE PROCEDURE `CONCEPTOSINVAGROCON`(
	/*  SP PARA CONSULTAR CONCEPTOS DE INVERSION FIRA */
    Par_SolicitudCredito	BIGINT(20),				-- ID DE LA SOLICITUD DE CREDITO
    Par_ClienteID			INT(11),				-- ID dcel cliente
	Par_TipoRecurso			CHAR(2),				-- Tipo de recurso.
	Par_NumCon				TINYINT UNSIGNED,		-- no. del tipo de consulta

	Par_EmpresaID			INT(11),				-- Parametros de auditoria
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore:BEGIN
	-- DEclaracion variables
    DECLARE Var_TotalPrestamo	DECIMAL(16,2);
	-- Declaracion de constantes
	DECLARE Con_Fecha		INT(11);
	-- Asignacion de constantes
	SET Con_Fecha := 2;

	-- Consulta principal
	IF(Par_NumCon = Con_Fecha) THEN
		SELECT SolicitudCreditoID, ClienteID, MAX(FechaRegistro) AS FechaRegistro
			FROM CONCEPTOINVERAGRO
		WHERE SolicitudCreditoID = Par_SolicitudCredito
			AND ClienteID = Par_ClienteID;

    END IF;


END TerminaStore$$