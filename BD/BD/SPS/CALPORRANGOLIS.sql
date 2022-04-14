-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALPORRANGOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CALPORRANGOLIS`;DELIMITER $$

CREATE PROCEDURE `CALPORRANGOLIS`(

    Par_TipoInstit	 	VARCHAR(2),
	Par_Clasificacion  	CHAR(1),
	Par_Tipo			CHAR(2),
	Par_NumLis			TINYINT UNSIGNED,

	 -- Parametros de Auditoria
	Aud_Empresa			INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
	)
TerminaStore: BEGIN

	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);
	DECLARE	Lis_TipoInver 		INT;
	DECLARE	Lis_Principal 		INT;
	DECLARE Lis_CalifRango		INT;

SET	Cadena_Vacia	:= '';
SET	Fecha_Vacia		:= '1900-01-01';
SET	Entero_Cero		:= 0;
SET	Lis_Principal	:= 1;
SET	Lis_CalifRango	:= 3;


IF(Par_NumLis = Lis_CalifRango) THEN
	SELECT LimInferior, LimSuperior, Calificacion
	FROM CALPORRANGO
	WHERE TipoInstitucion = Par_TipoInstit
    AND Tipo = Par_Tipo
    AND Clasificacion = Par_Clasificacion
    ORDER BY LimInferior ASC;
END IF;

END TerminaStore$$