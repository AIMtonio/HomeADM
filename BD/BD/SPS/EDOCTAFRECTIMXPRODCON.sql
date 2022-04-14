-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAFRECTIMXPRODCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAFRECTIMXPRODCON`;
DELIMITER $$


CREATE PROCEDURE `EDOCTAFRECTIMXPRODCON`(
-- SP PARA VALIDAR PARAMETRIZACION DE PRODUCTO
	Par_FrecuenciaID		CHAR(1),			-- FRECUENCIA	
	Par_ProducCreditoID		INT(11),			-- PRODUCTO DE CREDITO	
    Par_NumCon				TINYINT UNSIGNED,	-- NUMERO DE CONSULTA
	-- PARAMETROS DE AUDITORIA
	Aud_EmpresaID       	INT(11),		
    Aud_Usuario         	INT(11),
    Aud_FechaActual     	DATETIME,		
    Aud_DireccionIP     	VARCHAR(15),	
    Aud_ProgramaID      	VARCHAR(50),	
    Aud_Sucursal        	INT(11),		
    Aud_NumTransaccion  	BIGINT(20)  	
)
TerminaStore:BEGIN

	-- DECLARQACION DE CONSTANTES
    DECLARE Con_Principal		INT(11);
	
    -- ASIGNACION DE CONSTANTES
	SET Con_Principal	:= 1;
                                     
	IF(Par_NumCon = Con_Principal)THEN
		SELECT EDO.FrecuenciaID, EDO.ProducCreditoID, PRO.Descripcion
			FROM EDOCTAFRECTIMXPROD AS EDO
            INNER JOIN PRODUCTOSCREDITO PRO ON PRO.ProducCreditoID = EDO.ProducCreditoID
			WHERE EDO.ProducCreditoID = Par_ProducCreditoID
			AND EDO.FrecuenciaID = Par_FrecuenciaID;
			
	END IF;


END TerminaStore$$
