-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDCARGAMOVSHEADLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDCARGAMOVSHEADLIS`;DELIMITER $$

CREATE PROCEDURE `PLDCARGAMOVSHEADLIS`(
	-- Lista del historico de los movimientos del cliente cargado
	Par_PIDTarea	 	VARCHAR(50),		-- Numero referente a la tarea
	Par_NumLis			TINYINT UNSIGNED,	-- Numero de Lista

	Aud_EmpresaID		INT(11),			-- Parametro de Auditoria
	Aud_Usuario			INT(11),			-- Parametro de Auditoria
	Aud_FechaActual		DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP		VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID		VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal		INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion	BIGINT(20)			-- Parametro de Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia	CHAR(1);		-- Constante cadena vacia
	DECLARE	Fecha_Vacia		DATE;			-- Constante fecha vacia
	DECLARE	Entero_Cero		INT;			-- Constante entero cero
	DECLARE	Lis_Principal	INT;			-- Numero indicador de la lista principal

	-- Asignacion de Constantes
	SET	Cadena_Vacia	:= '';				-- Cadena Vacia
	SET	Fecha_Vacia		:= '1900-01-01';	-- Fecha Vacia
	SET	Entero_Cero		:= 0;				-- Entero Cero
	SET	Lis_Principal	:= 1;				-- Lista Principal

	-- 1.- Lista Principal
	IF (Par_NumLis = Lis_Principal) THEN
		SELECT CargaID, Estatus, PIDTarea, NombreArchivo
			FROM PLDCARGAMOVSHEAD
			WHERE PIDTarea = Par_PIDTarea
			AND Estatus = Cadena_Vacia
			ORDER BY CargaID;
	END IF;

END TerminaStore$$