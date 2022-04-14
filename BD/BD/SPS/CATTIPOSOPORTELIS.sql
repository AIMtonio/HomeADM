-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATTIPOSOPORTELIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATTIPOSOPORTELIS`;DELIMITER $$

CREATE PROCEDURE `CATTIPOSOPORTELIS`(
	-- Lista de Tipos de Soporte
	Par_TipoSoporteID	INT(11),			-- Numero de Tipo de Soporte
    Par_Descripcion		VARCHAR(200),		-- Descripcion de Tipo de Soporte
    Par_NumLis          TINYINT UNSIGNED,	-- Numero de Lista

    Par_EmpresaID       INT(11),			-- Parametro de Auditoria
    Aud_Usuario         INT(11),			-- Parametro de Auditoria
    Aud_FechaActual     DATETIME,			-- Parametro de Auditoria
    Aud_DireccionIP     VARCHAR(15),		-- Parametro de Auditoria
    Aud_ProgramaID      VARCHAR(50),		-- Parametro de Auditoria
    Aud_Sucursal        INT(11),			-- Parametro de Auditoria
    Aud_NumTransaccion  BIGINT(20)  		-- Parametro de Auditoria

)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT(11);
	DECLARE	Lis_Principal 	INT(11);
	DECLARE	Lis_Combo   	CHAR(1);


	-- Asignacion de constantes
	SET	Cadena_Vacia		:= '';				-- Cadena vacia
	SET	Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia
	SET	Entero_Cero			:= 0;				-- Entero cero
	SET	Lis_Principal		:= 1;				-- Lista Principal de Tipos de Soporte
	SET	Lis_Combo       	:= 2;				-- Lista Combo Tipos de Soporte

	-- 1.- Lista Principal de Tipos de Soporte
	IF(Par_NumLis = Lis_Principal) THEN
		SELECT TipoSoporteID, Descripcion
			FROM CATTIPOSOPORTE
		WHERE Descripcion LIKE CONCAT("%", Par_Descripcion, "%")
		LIMIT 0, 15;
	END IF;

    -- 2.- Lista Combo de Tipos de Soporte
	IF(Par_NumLis = Lis_Combo) THEN
		SELECT TipoSoporteID, Descripcion
		FROM CATTIPOSOPORTE
		ORDER BY TipoSoporteID;
	END IF;

END TerminaStore$$