-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EMPLEADOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `EMPLEADOSLIS`;DELIMITER $$

CREATE PROCEDURE `EMPLEADOSLIS`(
# ==========================================================
#			SP PARA LAS LISTAS DE EMPLEADOS
# ==========================================================
	Par_EmpleadoID		BIGINT(20),			-- Id del empleado
	Par_NombreCompleto	VARCHAR(200),		-- Nombre completo
	Par_NumLis			TINYINT UNSIGNED,	-- Numero de lista

    -- Parametros de auditoria
	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia	CHAR(1);	-- Cadena vacia
	DECLARE	Fecha_Vacia		DATE;		-- Fecha vacia
	DECLARE	Entero_Cero		INT(11);	-- Entero cero
	DECLARE	Lis_Principal	INT(11);	-- Lista principal
	DECLARE	EstatusActivo	CHAR(1);	-- Estatus activo

	DECLARE Lis_Todos		INT(11);	-- Lista de empleados con cualquier estatus

	-- asignacion de constantes
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Lis_Principal		:= 1;
	SET EstatusActivo		:='A';

	SET Lis_Todos			:= 2;

	IF(Par_NumLis = Lis_Principal) THEN
		SELECT DISTINCT DES.EmpleadoID, DES.NombreCompleto
			FROM EMPLEADOS DES
			WHERE DES.NombreCompleto	LIKE	CONCAT("%", Par_NombreCompleto, "%")
			AND Estatus='A'
			LIMIT 0, 15;
	END IF;

	-- LISTA DE EMPLEADOS SIN IMPORTAR ESTATUS
	IF(Par_NumLis = Lis_Todos) THEN
		SELECT DISTINCT DES.EmpleadoID, DES.NombreCompleto
			FROM EMPLEADOS DES
			WHERE DES.NombreCompleto	LIKE	CONCAT("%", Par_NombreCompleto, "%") || DES.EmpleadoID	LIKE	CONCAT("%", Par_NombreCompleto, "%")
			LIMIT 0, 15;
	END IF;

END TerminaStore$$