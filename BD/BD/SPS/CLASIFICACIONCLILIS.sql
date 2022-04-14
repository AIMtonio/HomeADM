-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLASIFICACIONCLILIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLASIFICACIONCLILIS`;DELIMITER $$

CREATE PROCEDURE `CLASIFICACIONCLILIS`(

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
			SELECT   ClasificaCliID,	  Clasificacion,		  FORMAT(RangoInferior,2) AS RangoInferior,	   FORMAT(RangoSuperior,2) AS RangoSuperior
			FROM	 CLASIFICACIONCLI
			ORDER BY ClasificaCliID;
		END IF;


	END TerminaStore$$