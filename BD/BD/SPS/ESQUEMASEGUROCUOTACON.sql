-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMASEGUROCUOTACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMASEGUROCUOTACON`;DELIMITER $$

CREATE PROCEDURE `ESQUEMASEGUROCUOTACON`(

	Par_ProducCreditoID		INT(11),
    Par_FrecuenciaCap		VARCHAR(1),
    Par_FrecuenciaInt		VARCHAR(1),
    Par_TipoConsulta		TINYINT,

	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
				)
TerminaStore: BEGIN

    DECLARE Consulta_Principal		INT(11);


    SET Consulta_Principal		:= 1;


    IF(Consulta_Principal = Par_TipoConsulta) THEN
		SELECT
				ProducCreditoID,	Frecuencia,		Monto
			FROM ESQUEMASEGUROCUOTA AS Esq INNER JOIN
				CATFRECUENCIAS AS Cat ON Esq.Frecuencia=Cat.FrecuenciaID
				WHERE ProducCreditoID = Par_ProducCreditoID
				AND Frecuencia IN(Par_FrecuenciaCap, Par_FrecuenciaInt) ORDER BY Dias ASC LIMIT 1;
	END IF;
END TerminaStore$$