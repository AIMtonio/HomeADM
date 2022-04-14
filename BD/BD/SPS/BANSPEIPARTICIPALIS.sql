-- BANSPEIPARTICIPALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `BANSPEIPARTICIPALIS`;
DELIMITER $$


CREATE PROCEDURE `BANSPEIPARTICIPALIS`(

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


DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT;
DECLARE	Lis_Principal 	INT;


SET	Cadena_Vacia	:= '';
SET	Fecha_Vacia		:= '1900-01-01';
SET	Entero_Cero		:= 0;
SET	Lis_Principal	:= 1;

IF(Par_NumLis = Lis_Principal) THEN

	SELECT	ClaveParticipaSpei, NombreCorto, Folio
		FROM INSTITUCIONES
		WHERE  ClaveParticipaSpei != Entero_Cero
        ORDER BY NombreCorto;

END IF;


END TerminaStore$$
