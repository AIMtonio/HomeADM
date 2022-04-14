-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ISRRETENANIOLIST
DELIMITER ;
DROP PROCEDURE IF EXISTS `ISRRETENANIOLIST`;DELIMITER $$

CREATE PROCEDURE `ISRRETENANIOLIST`(

	Par_tipoLista		INT,

    Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,

	Aud_NumTransaccion	BIGINT

	)
TerminaStore: BEGIN

	DECLARE	Entero_Cero		DECIMAL(12,2);
    DECLARE Lista_anios		INT;

    SET Entero_Cero		:= 0;
    SET Lista_anios		:=1;
    IF(Par_tipoLista=Lista_anios) THEN
		SELECT YEAR(Fecha) AS anio
			FROM `HIS-CUENTASAHO`
				WHERE ISRReal>Entero_Cero
					GROUP BY YEAR(Fecha)
						ORDER BY YEAR(Fecha) DESC;
     END IF;

END TerminaStore$$