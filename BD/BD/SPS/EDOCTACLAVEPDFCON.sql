-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTACLAVEPDFCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTACLAVEPDFCON`;DELIMITER $$

CREATE PROCEDURE `EDOCTACLAVEPDFCON`(
	-- SP para consulta de valores de la tabla EDOCTACLAVEPDF
	Par_ClienteID			BIGINT(20),			-- Numero de cliente
	Par_NumCon				TINYINT UNSIGNED,	-- Numero de consulta

	Par_EmpresaID			INT(11),			-- Parametros de Auditoria
	Aud_Usuario				INT(11),			-- Parametros de Auditoria
	Aud_FechaActual			DATETIME,			-- Parametros de Auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametros de Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametros de Auditoria
	Aud_Sucursal			INT(11),			-- Parametros de Auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametros de Auditoria
)
TerminaStore: BEGIN
	-- Declaracion de constantes
	DECLARE Con_Principal	TINYINT UNSIGNED;	-- Consulta principal

	-- Asignacion de constantes
	SET	Con_Principal		:= 1;				-- Consulta La clave usada en el envio de Estados de Cuenta de un Cliente

	-- Consulta La clave usada en el envio de Estados de Cuenta de un Cliente
	IF (Par_NumCon = Con_Principal) THEN
		SELECT	ClienteID,	Contrasenia,	CorreoEnvio,	FechaActualiza,	FROM_BASE64(Contrasenia) AS ClavePDF
			FROM EDOCTACLAVEPDF
			WHERE	ClienteID = Par_ClienteID;
	END IF;
END TerminaStore$$