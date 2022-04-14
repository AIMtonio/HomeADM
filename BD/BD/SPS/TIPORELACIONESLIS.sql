-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPORELACIONESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPORELACIONESLIS`;
DELIMITER $$

CREATE PROCEDURE `TIPORELACIONESLIS`(
	Par_TipoRelacionID	INT(11),					-- Parametro del numero de tipo relacion
	Par_Descripcion		VARCHAR(50),				-- Parametro de la descripcion del tipo de relacion

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
	DECLARE Lis_Principal		INT(11);			-- Numero de listado principal por la descripcion del tipo relacion
	DECLARE Lis_Foranea			INT(11);			-- Numero de listado de toda los registro de la tabla TIPORELACIONES Para el ws de milagro
	DECLARE Lis_Relaciones		INT(11);			-- Numero de listado de tipo relacion  por descripcion cuando parentesco es si

	-- Asignacion de constante
	Set	Lis_Principal			:= 1;				-- Numero de listado principal por la descripcion del tipo relacion
	Set	Lis_Foranea				:= 2;				-- Numero de listado de toda los registro de la tabla TIPORELACIONES Para el ws de milagro
	Set	Lis_Relaciones			:= 3;				-- Numero de listado de tipo relacion  por descripcion cuando parentesco es si

	-- 1.- Numero de listado principal por la descripcion del tipo relacion
	IF(Par_NumLis = Lis_Principal) THEN
		SELECT TipoRelacionID	,Descripcion
			FROM TIPORELACIONES
		WHERE Descripcion LIKE CONCAT("%", Par_Descripcion, "%")
		LIMIT 0, 15;
	END IF;

	-- 2.- -- Numero de listado de toda los registro de la tabla TIPORELACIONES Para el ws de milagro
	IF(Par_NumLis = Lis_Foranea) THEN
		SELECT	TipoRelacionID		,Descripcion,			EsParentesco,		Tipo,			Grado,
				Linea
			FROM TIPORELACIONES;
	END IF;

	-- 3.- Numero de listado de tipo relacion  por descripcion cuando parentesco es si
	IF(Par_NumLis = Lis_Relaciones) THEN
		SELECT TipoRelacionID	,Descripcion, Tipo, Grado, Linea
			FROM TIPORELACIONES
		WHERE Descripcion LIKE CONCAT("%", Par_Descripcion, "%")
		AND EsParentesco = "S"
		LIMIT 0, 15;
	END IF;

END TerminaStore$$