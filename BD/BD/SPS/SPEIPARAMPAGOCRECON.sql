-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEIPARAMPAGOCRECON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEIPARAMPAGOCRECON`;
DELIMITER $$


CREATE PROCEDURE `SPEIPARAMPAGOCRECON`(
/* SP PARA CONSULTAR LOS PARAMETROS DE PAGO DE CREDITO POR SPEI */
	Par_NumEmpresaID 			INT(11),		# ID de la empresa
	Par_TipoConsulta			TINYINT UNSIGNED,		-- Especifica el tipo de consulta
	
    -- Parametros de Auditoria
	Aud_EmpresaID       	INT(11),		-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),		-- Parametro de auditoria ID del usuario

    Aud_FechaActual     	DATETIME,		-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),		-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)

TerminaStore:BEGIN

	
	DECLARE Con_Principal		INT(11);
	
    
    SET Con_Principal			:= 1;

	IF(Par_TipoConsulta=Con_Principal)THEN
		SELECT NumEmpresaID,		AplicaPagAutCre, 		EnCasoNoTieneExiCre,			EnCasoSobrantePagCre
			FROM SPEIPARAMPAGOCRE
            WHERE NumEmpresaID=Par_NumEmpresaID;
		
	END IF;


END TerminaStore$$
