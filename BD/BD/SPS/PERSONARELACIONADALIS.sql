-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PERSONARELACIONADALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PERSONARELACIONADALIS`;



	Par_NumList			TINYINT UNSIGNED,

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)


	)



    DECLARE Lis_GridAcreRel	INT(11);



    SET Lis_GridAcreRel 	:= 1;


	IF(Par_NumList = Lis_GridAcreRel) THEN
		SELECT 	`ClienteID`, 		`EmpleadoID`, 	`ClaveCNBV`
		FROM PERSONARELACIONADA;
    END IF;

END TerminaStore$$