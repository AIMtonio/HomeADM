-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMAPOYOESCOLARCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMAPOYOESCOLARCON`;DELIMITER $$

CREATE PROCEDURE `PARAMAPOYOESCOLARCON`(

	Par_ApoyoEscCicloID		INT(11),
	Par_NumCon				TINYINT UNSIGNED,


	Par_EmpresaID			INT(11),
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
	)
TerminaStore:BEGIN




	DECLARE Con_Principal		INT;


	SET Con_Principal			:=1;



		IF(Par_NumCon = Con_Principal) THEN
			SELECT  ParamApoyoEscID,  ApoyoEscCicloID,		TipoCalculo,		MesesAhorrocons,
			FORMAT(PromedioMinimo,2) AS PromedioMinimo,
			FORMAT(Cantidad,2) AS Cantidad
			FROM	PARAMAPOYOESCOLAR
			WHERE	ApoyoEscCicloID=Par_ApoyoEscCicloID;
		END IF;


	END TerminaStore$$