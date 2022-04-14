-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROMESASEGCOBLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PROMESASEGCOBLIS`;DELIMITER $$

CREATE PROCEDURE `PROMESASEGCOBLIS`(

    Par_CreditoID		BIGINT(12),
	Par_NumList			TINYINT UNSIGNED,

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)


	)
TerminaStore:BEGIN


    DECLARE Lis_Promesas	INT(11);



    SET Lis_Promesas 	:= 2;


	IF(Par_NumList = Lis_Promesas) THEN
		SELECT NumPromesa, FechaPromPago, 	MontoPromPago, 	ComentarioProm
		FROM PROMESASEGCOB psc
			INNER JOIN BITACORASEGCOB bsc
			ON psc.BitacoraID = bsc.BitacoraID
		WHERE bsc.CreditoID = Par_CreditoID;
    END IF;

END TerminaStore$$