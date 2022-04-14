-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMETROSESCALACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMETROSESCALACON`;DELIMITER $$

CREATE PROCEDURE `PARAMETROSESCALACON`(

	Par_TipoPerson		CHAR(1),
	Par_TipoInstrum		INT(11),
	Par_NacMoneda		CHAR(1),
	Par_NumCon			TINYINT UNSIGNED,

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
DECLARE	Con_Principal 	INT;
DECLARE	Con_Foranea	 	INT;


SET	Cadena_Vacia		:= '';
SET	Fecha_Vacia			:= '1900-01-01';
SET	Entero_Cero			:= 0;
SET	Con_Principal		:= 1;
SET	Con_Foranea			:= 2;



IF(Par_NumCon = Con_Principal) THEN

	SELECT 	FolioID, 	TipoPersona, 	TipoInstrumento,	NacMoneda,	LimiteInferior,
			MonedaComp,	RolTitular,		RolSuplente
		FROM PARAMETROSESCALA
			WHERE TipoPersona 		= Par_TipoPerson
				AND TipoInstrumento = Par_TipoInstrum
				AND NacMoneda 		= Par_NacMoneda;

END IF;

END TerminaStore$$