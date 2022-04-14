-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSOCIEDADLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSOCIEDADLIS`;
DELIMITER $$

CREATE PROCEDURE `TIPOSOCIEDADLIS`(
	Par_Descripcion		VARCHAR(100),				-- Parametro para la descripcion de tipo de sociedad a buscar
	Par_NumLis			TINYINT UNSIGNED,			-- Parametro de tipo de lista
	Par_EmpresaID		INT(11),					-- Parametro de Auditoria

	Aud_Usuario			INT(11),					-- Parametro de auditoria
	Aud_FechaActual		DATETIME,					-- Parametro de auditoria
	Aud_DireccionIP		VARCHAR(15),				-- Parametro de auditoria
	Aud_ProgramaID		VARCHAR(50),				-- Parametro de auditoria
	Aud_Sucursal		INT(11),					-- Parametro de auditoria
	Aud_NumTransaccion	BIGINT(20)					-- Parametro de auditoria

)TerminaStore: BEGIN

	-- Declaracion de constante
	DECLARE	Cadena_Vacia	CHAR(1);			-- Cadena Vacia
	DECLARE	Fecha_Vacia		DATE;				-- Fecha Vacia
	DECLARE	Entero_Cero		INT(11);			-- Entero cero

	DECLARE	Lis_Principal	INT(11);			-- Lista principal por la descripcion del tipo de sociedad
	DECLARE	Lis_Foranea		INT(11);			-- Consulta de listado de toda la informacion de la tabla de TIPOSOCIEDAD Para el ws de milagro

	-- Asignacion de constante
	SET Cadena_Vacia	:= '';					-- Cadena Vacia
	SET Fecha_Vacia		:= '1900-01-01';		-- Fecha Vacia
	SET Entero_Cero		:= 0;					-- Entero cero

	SET Lis_Principal	:= 1;					-- Lista principal por la descripcion del tipo de sociedad
	SET Lis_Foranea		:= 2;					-- Consulta de listado de toda la informacion de la tabla de TIPOSOCIEDAD Para el ws de milagro

	-- 1.- Lista principal por la descripcion del tipo de sociedad
	IF(Par_NumLis = Lis_Principal) THEN
		SELECT	`TipoSociedadID`,		`Descripcion`
		FROM		 TIPOSOCIEDAD
		WHERE  Descripcion LIKE CONCAT("%", Par_Descripcion, "%")
		LIMIT 0, 15;
	END IF;

	-- Consulta de listado de toda la informacion de la tabla de TIPOSOCIEDAD Para el ws de milagro
	IF(Par_NumLis = Lis_Foranea) THEN
		SELECT	TipoSociedadID,		Descripcion,		AbreviCNBV,			EsFinanciera
			FROM TIPOSOCIEDAD;
	END IF;

END TerminaStore$$