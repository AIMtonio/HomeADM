-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FORMATONOTIFICACOBLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `FORMATONOTIFICACOBLIS`;DELIMITER $$

CREATE PROCEDURE `FORMATONOTIFICACOBLIS`(

	Par_NumLis			TINYINT UNSIGNED,

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)

)
TerminaStore: BEGIN


    DECLARE List_Combo		INT(11);



    SET List_Combo			:=	1;


	IF(Par_NumLis = List_Combo) THEN
		SELECT 	FormatoID, 	Descripcion,	Reporte
		FROM FORMATONOTIFICACOB;

    END IF;


END TerminaStore$$