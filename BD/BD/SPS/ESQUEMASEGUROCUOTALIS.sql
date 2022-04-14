-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMASEGUROCUOTALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMASEGUROCUOTALIS`;DELIMITER $$

CREATE PROCEDURE `ESQUEMASEGUROCUOTALIS`(

	Par_ProducCreditoID		INT(11),
    Par_TipoLista			TINYINT,

	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
				)
TerminaStore: BEGIN

    DECLARE Lista_Principal		INT(11);


    SET Lista_Principal		:= 1;


    IF(Lista_Principal = Par_TipoLista) THEN
		SELECT
			ProducCreditoID,	Frecuencia,		Monto
		FROM ESQUEMASEGUROCUOTA
			WHERE ProducCreditoID = Par_ProducCreditoID;
	END IF;
END TerminaStore$$