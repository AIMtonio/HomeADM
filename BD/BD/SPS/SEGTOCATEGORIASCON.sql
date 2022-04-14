-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOCATEGORIASCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGTOCATEGORIASCON`;DELIMITER $$

CREATE PROCEDURE `SEGTOCATEGORIASCON`(
	Par_CategoriaID		INT(11),
	Par_NumCon			TINYINT UNSIGNED,

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal       	INT(11),
	Aud_NumTransaccion	BIGINT(20)
	)
TerminaStore: BEGIN



	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT(11);
	DECLARE	Con_Principal	INT(11);
	DECLARE Con_Foranea		INT(11);



	SET	Cadena_Vacia    := '';
	SET	Fecha_Vacia	   := '1900-01-01';
	SET	Entero_Cero		:= 0;
	SET	Con_Principal	:= 1;
	SET	Con_Foranea		:= 2;

	IF(Par_NumCon = Con_Principal) THEN
		SELECT
			CategoriaID,	TipoGestionID,	Descripcion,	NombreCorto,	Estatus,
			TipoCobranza
		FROM SEGTOCATEGORIAS
		WHERE CategoriaID = Par_CategoriaID;

	END IF;

	IF(Par_NumCon = Con_Foranea) THEN
		SELECT CategoriaID, Descripcion
			FROM SEGTOCATEGORIAS
			WHERE CategoriaID = Par_CategoriaID	;
	END IF;

END TerminaStore$$