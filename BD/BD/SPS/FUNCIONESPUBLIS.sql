-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FUNCIONESPUBLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `FUNCIONESPUBLIS`;
DELIMITER $$

CREATE PROCEDURE `FUNCIONESPUBLIS`(
	Par_Descripcion		VARCHAR(150),			-- Descripcion de la funcion publica
	Par_NumLis			TINYINT UNSIGNED,		-- NUmero de lista
	Par_EmpresaID		INT(11),				-- Parametros de auditoria

	Aud_Usuario			INT(11),				-- Parametros de auditoria
	Aud_FechaActual		DATETIME,				-- Parametros de auditoria
	Aud_DireccionIP		VARCHAR(15),			-- Parametros de auditoria
	Aud_ProgramaID		VARCHAR(50),			-- Parametros de auditoria
	Aud_Sucursal		INT(11),				-- Parametros de auditoria
	Aud_NumTransaccion	BIGINT(20)				-- Parametros de auditoria

)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);			-- Cadena Vacia
	DECLARE	Fecha_Vacia			DATE;				-- Fecha Vacia
	DECLARE	Entero_Cero			INT(11);			-- Entero Cero
	DECLARE	Lis_Principal		INT(11);			-- Numero de lista Principal por descricion
	DECLARE Lis_FuncPublicWS	INT(11);			-- Numero de listado que sirve para devolver todos los registro de la tabla para ws de milagro

	-- Asignacion de Constantes
	SET	Cadena_Vacia		:= '';					-- Cadena Vacia
	SET	Fecha_Vacia			:= '1900-01-01';		-- Fecha Vacia
	SET	Entero_Cero			:= 0;					-- Entero Cero
	SET	Lis_Principal		:= 1;					-- Numero de lista Principal por descricion
	SET LIS_FuncPublicWS	:= 2;					-- Numero de listado que sirve para devolver todos los registro de la tabla para ws de milagro

	-- 1.- Numero de lista Principal por descricion
	IF(Par_NumLis = Lis_Principal) THEN
		SELECT	`FuncionID`,		`Descripcion`
		FROM FUNCIONESPUB
		WHERE  Descripcion LIKE CONCAT("%", Par_Descripcion, "%")
		LIMIT 0, 15;
	END IF;

	-- 2.- Numero de listado que sirve para devolver todos los registro de la tabla para ws de milagro
	IF(Par_NumLis = Lis_Principal) THEN
		SELECT	FuncionID,		Descripcion
		FROM FUNCIONESPUB;
	END IF;

END TerminaStore$$