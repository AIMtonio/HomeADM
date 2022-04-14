-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSTIPOSCAMPANICON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SMSTIPOSCAMPANICON`;DELIMITER $$

CREATE PROCEDURE `SMSTIPOSCAMPANICON`(
# ========================================================
# ------ SP PARA CONSULTAR LOS TIPOS DE CAMPANIA SMS------
# ========================================================
	Par_TipoCampID		INT(11),
	Par_NumCon			TINYINT UNSIGNED,

	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE		Cadena_Vacia	CHAR(1);
	DECLARE		Fecha_Vacia		DATE;
	DECLARE		Entero_Cero		INT;
	DECLARE		Con_Principal	INT;
	DECLARE		Con_Foranea		INT;


	-- Asignacion de Constantes
	SET	Cadena_Vacia	:= '';				-- Cadena Vacia
	SET	Fecha_Vacia		:= '1900-01-01';	-- Fecha DEFAULT
	SET	Entero_Cero		:= 0;				-- Entero cero
	SET	Con_Principal	:= 1;				-- Consulta Principal
	SET	Con_Foranea		:= 2;				-- Consulta Foranea


	IF(Par_NumCon = Con_Principal) THEN
		SELECT	TipoCampaniaID,		Nombre,	Clasificacion,	Categoria,	Reservado
			FROM SMSTIPOSCAMPANIAS
			WHERE  TipoCampaniaID 	= Par_TipoCampID;
	END IF;

	IF(Par_NumCon = Con_Foranea) THEN
		SELECT	TipoCampaniaID,		Nombre
			FROM SMSTIPOSCAMPANIAS
			WHERE  TipoCampaniaID 	= Par_TipoCampID;
	END IF;


END TerminaStore$$