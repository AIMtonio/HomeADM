-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATQUINQUENIOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATQUINQUENIOSCON`;
DELIMITER $$


CREATE PROCEDURE `CATQUINQUENIOSCON`(
	Par_QuinquenioID			INT(11),			-- Quinquenio ID
    Par_NumCon					BIGINT UNSIGNED,	-- Parametro que solicita el numero de consulta
    
	Aud_EmpresaID				INT(11),			-- Parametros de auditoria
	Aud_Usuario					INT(11),			-- Parametros de auditoria
	Aud_FechaActual				DATETIME,			-- Parametros de auditoria
	Aud_DireccionIP				VARCHAR(15),		-- Parametros de auditoria
	Aud_ProgramaID				VARCHAR(50),		-- Parametros de auditoria
	Aud_Sucursal				INT(11),			-- Parametros de auditoria
	Aud_NumTransaccion			BIGINT(20)			-- Parametros de auditoria
	)

TerminaStore: BEGIN


-- DECLARACION DE CONSTANTES
	DECLARE Con_Principal   	INT(11);

	-- ASIGNACION DE CONSTANTES
	SET Con_Principal			:= 1;


 
 -- Consulta principal
	IF (Par_NumCon = Con_Principal) THEN
		SELECT QuinquenioID, Descripcion, DescripcionCorta
			FROM CATQUINQUENIOS
            WHERE QuinquenioID =Par_QuinquenioID;
	END IF;
    
END TerminaStore$$