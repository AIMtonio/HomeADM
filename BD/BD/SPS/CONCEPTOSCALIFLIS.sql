-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONCEPTOSCALIFLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONCEPTOSCALIFLIS`;DELIMITER $$

CREATE PROCEDURE `CONCEPTOSCALIFLIS`(

	Par_NumLis				TINYINT UNSIGNED,


	Par_EmpresaID			INT(11),
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
	)
TerminaStore:BEGIN




	DECLARE Lis_Principal		INT;


	SET Lis_Principal			:=1;



		IF(Par_NumLis = Lis_Principal) THEN
			SELECT   ConceptoCalifID,	  Concepto,		  Descripcion,	   FORMAT(Puntos,2) AS Puntos
			FROM	 CONCEPTOSCALIF
			ORDER BY ConceptoCalifID;
		END IF;


	END TerminaStore$$