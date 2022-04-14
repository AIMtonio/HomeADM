-- SUBCTAMONFONBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS SUBCTAMONFONBAJ;
DELIMITER $$


CREATE PROCEDURE SUBCTAMONFONBAJ(
	/*Sp para alta de credito pasivo */
	Par_ConceptoFonID		INT(11),
	Par_TipoFondeo			CHAR(1),
	Par_MonedaID			INT(11),
	
	Par_EmpresaID			INT(11),
	Aud_Usuario			   	INT,
	Aud_FechaActual			DATETIME,

	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
	)

TerminaStore: BEGIN



		DELETE FROM SUBCTAMONFON
			WHERE ConceptoFonID = Par_ConceptoFonID
				AND TipoFondeo	=Par_TipoFondeo
				AND MonedaID 	= Par_MonedaID; 


	SELECT 	'0' 	AS NumErr,
			'SubCuenta  Eliminada'	AS ErrMen,
			'ConceptoFonID' AS control;

END TerminaStore$$
