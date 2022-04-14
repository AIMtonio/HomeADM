-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGULATORIOD0842003LIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGULATORIOD0842003LIS`;DELIMITER $$

CREATE PROCEDURE `REGULATORIOD0842003LIS`(
# =====================================================================================
# -----       STORE DE LISTA DE REGULATORIOS  		 	 ------
# ====================================================================================
	Par_Anio                INT(11),            		-- Anio en que se reporta
	Par_Mes                 INT(11),            		-- mes de generacion del reporte
	Par_Descripcion		    VARCHAR(50),				-- Parametro a comparar
	Par_NumLis				TINYINT UNSIGNED,			-- Tipo  de lista

	Par_EmpresaID			INT(11),					-- Parametros de Auditoria
	Aud_Usuario         	INT(11),					-- Parametros de Auditoria
	Aud_FechaActual     	DATETIME,					-- Parametros de Auditoria
	Aud_DireccionIP     	VARCHAR(15),				-- Parametros de Auditoria
	Aud_ProgramaID      	VARCHAR(50),				-- Parametros de Auditoria
	Aud_Sucursal        	INT(11),					-- Parametros de Auditoria
	Aud_NumTransaccion  	BIGINT(20)					-- Parametros de Auditoria
	)
TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE Var_Descripcion   VARCHAR(100);

	-- Declaracion de Constantes
	DECLARE Lis_Principal		INT(11);
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);
	DECLARE MenuEntidad			INT(11);
	-- Asignacion de Constantes
	SET Lis_Principal			:= 2;
	SET	Cadena_Vacia			:= '';
	SET	Fecha_Vacia				:= '1900-01-01';
	SET	Entero_Cero				:= 0;
	SET MenuEntidad				:= 1;

	IF (Par_NumLis = Lis_Principal)THEN
		SELECT Reg.Consecutivo,	Op.Descripcion, Reg.NumeroContrato
			FROM REGULATORIOD0842003 Reg, OPCIONESMENUREG Op
				WHERE 	Reg.Anio = Par_Anio
					AND	Reg.Mes  = Par_Mes
                    AND Reg.NumeroIden = Op.CodigoOpcion
                    AND Op.MenuID = MenuEntidad
                    AND Op.Descripcion LIKE CONCAT('%',Par_Descripcion,'%') LIMIT 15;
	END IF;

END TerminaStore$$