-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDINFOSISTEMACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDINFOSISTEMACON`;
DELIMITER $$

CREATE PROCEDURE `PLDINFOSISTEMACON`(
	Par_NumCon						TINYINT UNSIGNED,		-- Numero de consulta

	Aud_EmpresaID					INT(11),				-- Parametro de auditoria
	Aud_Usuario						INT(11),				-- Parametro de auditoria
	Aud_FechaActual					DATETIME,				-- Parametro de auditoria
	Aud_DireccionIP					VARCHAR(15),			-- Parametro de auditoria
	Aud_ProgramaID					VARCHAR(50),			-- Parametro de auditoria
	Aud_Sucursal					INT(11),				-- Parametro de auditoria
	Aud_NumTransaccion				BIGINT(20)				-- Parametro de auditoria
)TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia				CHAR(1);			-- Constante cadena vacia
	DECLARE	Fecha_Vacia					DATE;				-- Constante Fecha vacia
	DECLARE	Entero_Cero					INT(11);			-- Constante Entero cero

	DECLARE	Con_Principal		INT(11);			-- Numero de consulta de conocimiento del cliente

	-- Asignacion de constantes
	SET	Cadena_Vacia					:= '';				-- Cadena Vacia
	SET	Fecha_Vacia						:= '1900-01-01';	-- Fecha Vacia
	SET	Entero_Cero						:= 0;				-- Entero Cero

	SET	Con_Principal			:= 1;				-- Numero de consulta de conocimiento del cliente


	-- 1.- Consulta de conocimiento del cliente
	IF(Par_NumCon = Con_Principal) THEN
		SELECT FechaSistema, 	NomCortoInstit AS NombreInstitucion, 	NombreRepresentante,		EjercicioVigente,		PeriodoVigente,
			OficialCumID
		FROM PARAMETROSSIS WHERE EmpresaID LIMIT 1;
	END IF;

END TerminaStore$$
