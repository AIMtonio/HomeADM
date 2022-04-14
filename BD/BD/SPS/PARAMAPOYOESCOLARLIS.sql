-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMAPOYOESCOLARLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMAPOYOESCOLARLIS`;DELIMITER $$

CREATE PROCEDURE `PARAMAPOYOESCOLARLIS`(

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
			SELECT	 ParamApoyoEscID,	AE.ApoyoEscCicloID,	AC.Descripcion,						TipoCalculo,
			FORMAT(PromedioMinimo,2) AS PromedioMinimo,		FORMAT(Cantidad,2) AS Cantidad,		MesesAhorroCons
			FROM	 PARAMAPOYOESCOLAR AE INNER JOIN APOYOESCCICLO AC
			ON AE.ApoyoEscCicloID=AC.ApoyoEscCicloID;
		END IF;

	END TerminaStore$$