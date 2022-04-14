-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- NOMINAEMPLEADOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATQUINQUENIOSLIS`;
DELIMITER $$


CREATE PROCEDURE `CATQUINQUENIOSLIS`(
	Par_Descripcion				VARCHAR(100),		-- Descripcion
    Par_DescripcionCorta		VARCHAR(20),		-- Descripcion corta
    Par_TipoLis					INT(11),			-- Tipo de lista a ejecutar

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
	DECLARE Lis_Principal   	INT(11);

	-- ASIGNACION DE CONSTANTES
	SET Lis_Principal			:= 1;


	-- LISTA PRINCIPAL
	IF (Par_TipoLis = Lis_Principal) THEN
		SELECT QuinquenioID, Descripcion, DescripcionCorta
			FROM CATQUINQUENIOS;
	END IF;
    
    
END TerminaStore$$
