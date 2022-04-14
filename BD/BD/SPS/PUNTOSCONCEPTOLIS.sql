-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PUNTOSCONCEPTOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PUNTOSCONCEPTOLIS`;DELIMITER $$

CREATE PROCEDURE `PUNTOSCONCEPTOLIS`(

	Par_ConceptoCalifID		INT(11),
	Par_NumLis				TINYINT UNSIGNED,


	Par_EmpresaID			INT,
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
			SELECT	 PuntosConcepID,	ConceptoCalifID,	FORMAT(RangoInferior,2) AS RangoInferior,		FORMAT(RangoSuperior,2) AS RangoSuperior,
					 FORMAT(Puntos,2) AS Puntos
			FROM	 PUNTOSCONCEPTO
			WHERE	 ConceptoCalifID = Par_ConceptoCalifID
			ORDER BY RangoInferior;
		END IF;

	END TerminaStore$$