-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSACTIVOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSACTIVOSCON`;

DELIMITER $$
CREATE PROCEDURE `TIPOSACTIVOSCON`(
	# =====================================================================================
	# ------- STORED PARA CONSULTA DE TIPOS DE ACTIVOS ---------
	# =====================================================================================
	Par_TipoActivoID		INT(11), 		-- Idetinficador del tipo de activo
	Par_NumCon				TINYINT UNSIGNED,-- Numero de consulta

	Par_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Fecha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia		CHAR(1);		-- Constante Cadena Vacia
	DECLARE Fecha_Vacia			DATE;			-- Constante Fecha Vacia
	DECLARE Entero_Cero			INT(1);			-- Constante Entero Cero
	DECLARE Decimal_Cero		DECIMAL(14,2);	-- Constante Decimal Cero

	-- Declaracion de Consultas
	DECLARE Con_Principal		INT(11);		-- Consulta 1: tipo de activo

	-- Asignacion de Constantes
	SET Cadena_Vacia			:= '';
	SET Fecha_Vacia				:= '1900-01-01';
	SET Entero_Cero				:= 0;
	SET Decimal_Cero			:= 0.0;

	-- Asignacion de Consultas
	SET Con_Principal			:= 1;

	-- Consulta Principal
	IF( Par_NumCon = Con_Principal ) THEN

		SELECT 	TipoActivoID,		Descripcion,	DescripcionCorta,	DepreciacionAnual,	ClasificaActivoID,
				TiempoAmortiMeses,	Estatus,		ClaveTipoActivo
		FROM TIPOSACTIVOS
		WHERE  TipoActivoID = Par_TipoActivoID;

	END IF;

END TerminaStore$$