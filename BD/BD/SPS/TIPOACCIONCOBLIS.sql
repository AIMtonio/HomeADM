-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOACCIONCOBLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOACCIONCOBLIS`;DELIMITER $$

CREATE PROCEDURE `TIPOACCIONCOBLIS`(

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


    DECLARE Lis_TiposAcciones	INT(11);
    DECLARE Lis_ComboAcciones	INT(11);



    SET Lis_TiposAcciones 	:= 1;
    SET Lis_ComboAcciones 	:= 2;


	IF(Par_NumList = Lis_TiposAcciones) THEN
		SELECT 	`AccionID`,		`Descripcion`,		`Estatus`
		FROM TIPOACCIONCOB;
    END IF;

	IF(Par_NumList = Lis_ComboAcciones) THEN
		SELECT 	`AccionID`,		`Descripcion`,		`Estatus`
		FROM TIPOACCIONCOB;
    END IF;

END TerminaStore$$