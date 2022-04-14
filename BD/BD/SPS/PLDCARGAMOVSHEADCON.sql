-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDCARGAMOVSHEADCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDCARGAMOVSHEADCON`;DELIMITER $$

CREATE PROCEDURE `PLDCARGAMOVSHEADCON`(
	-- Lista del historico de los movimientos del cliente cargado
	Par_PIDTarea			VARCHAR(50),		-- Numero del PIDTarea

	Aud_EmpresaID			INT(11),			-- Parametro de Auditoria
	Aud_Usuario				INT(11),			-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal			INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia	CHAR(1);			-- Constante de cadenas vacias
	DECLARE	Fecha_Vacia		DATE;				-- Constante fecha vacia
	DECLARE	Entero_Cero		INT;				-- Constante entero cero

	-- Asignacion de Constantes
	SET	Cadena_Vacia	:= '';					-- Cadena Vacia
	SET	Fecha_Vacia		:= '1900-01-01';		-- Fecha Vacia
	SET	Entero_Cero		:= 0;					-- Entero Cero

	SELECT CargaID, Estatus, PIDTarea, NombreArchivo
	FROM PLDCARGAMOVSHEAD
	WHERE PIDTarea = Par_PIDTarea
    AND Estatus = Cadena_Vacia;

END TerminaStore$$