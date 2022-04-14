-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APOYOESCCICLOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `APOYOESCCICLOLIS`;DELIMITER $$

CREATE PROCEDURE `APOYOESCCICLOLIS`(

	Par_ApoyoEscCicloID			INT,
	Par_Descripcion				VARCHAR(150),
	Par_NumLis					TINYINT UNSIGNED,


	Par_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
	)
TerminaStore:BEGIN




	DECLARE Lis_Principal	INT;


	SET Lis_Principal		:=1;




		IF(Par_NumLis = Lis_Principal) THEN
			SELECT	 ApoyoEscCicloID,		Descripcion
			FROM	 APOYOESCCICLO
			LIMIT 	15;
		END IF;

	END TerminaStore$$