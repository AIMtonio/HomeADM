-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSIDENTILIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSIDENTILIS`;
DELIMITER $$

CREATE PROCEDURE `TIPOSIDENTILIS`(
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

	DECLARE	Lis_Principal	INT(11);			-- Lista principal donde se realiza la busqueda por la descripcion del tipo identificacion
	DECLARE Lis_Foranea		INT(11);			-- Lista de toda la informacion de la tabla TIPOSIDENTI Para el ws de milagro
	DECLARE	Lis_Identi		INT(11);			-- Lista de los tipos de identificacion

	-- Asignacion de constante
	SET Cadena_Vacia	:= '';					-- Cadena Vacia
	SET Fecha_Vacia		:= '1900-01-01';		-- Fecha Vacia
	SET Entero_Cero		:= 0;					-- Entero cero

	SET	Lis_Principal	:= 1;					-- Lista principal donde se realiza la busqueda por la descripcion del tipo identificacion
	SET Lis_Foranea		:= 2;					-- Lista de toda la informacion de la tabla TIPOSIDENTI Para el ws de milagro
	SET	Lis_Identi		:= 3;					-- Lista de los tipos de identificacion

	-- 1.- Lista principal donde se realiza la busqueda por la descripcion del tipo identificacion
	IF(Par_NumLis = Lis_Principal) THEN
		SELECT	`TipoIdentiID`,		`Nombre` , `NumeroCaracteres`
		FROM TIPOSIDENTI
		WHERE  Nombre LIKE CONCAT("%", Par_Nombre, "%")
		LIMIT 0, 15;
	END IF;

	-- 2.- Lista de toda la informacion de la tabla TIPOSIDENTI Para el ws de milagro
	IF(Par_NumLis = Lis_Foranea) THEN
		SELECT TipoIdentiID,		Nombre,			NumeroCaracteres,		Oficial
		FROM TIPOSIDENTI;
	END IF;

	-- 3.- Lista de los tipos de identificacion
	IF(Par_NumLis = Lis_Identi) THEN
		SELECT TipoIdentiID,		Nombre,			NumeroCaracteres
		FROM TIPOSIDENTI;
	END IF;

END TerminaStore$$