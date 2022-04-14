-- SUBCTAMONFONCON
DELIMITER ;
DROP PROCEDURE IF EXISTS SUBCTAMONFONCON;
DELIMITER $$


CREATE PROCEDURE SUBCTAMONFONCON(
	Par_ConceptoFonID		INT(11),
	Par_TipoFondeo			CHAR(1),
	Par_MonedaID	        INT(11),
	Par_NumCon				TINYINT UNSIGNED,

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)

TerminaStore: BEGIN

	DECLARE		Con_Principal	INT(11);

	SET	Con_Principal	:= 1;

	IF(Par_NumCon = Con_Principal) THEN
		SELECT	ConceptoFonID,		TipoFondeo,		MonedaID,		SubCuenta
			FROM SUBCTAMONFON
			WHERE  ConceptoFonID 	= Par_ConceptoFonID
				AND MonedaID		= Par_MonedaID
				AND TipoFondeo 		= Par_TipoFondeo;
	END IF;
END TerminaStore$$
