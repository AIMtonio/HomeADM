-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATCLASCONTAC0922LIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATCLASCONTAC0922LIS`;DELIMITER $$

CREATE PROCEDURE `CATCLASCONTAC0922LIS`(
# =====================================================================================
# -----       STORE DE LISTA TIPO DE PERCEPCION DE REGULATORIOS  		 	 ------
# ====================================================================================
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


	-- Declaracion de Constantes
	DECLARE Lis_Principal		INT(11);	-- Lista Principal
	DECLARE	Cadena_Vacia		CHAR(1);	-- Cadena vacia
	DECLARE	Fecha_Vacia			DATE;		-- Fecha vacia
	DECLARE	Entero_Cero			INT(11);	-- Entero cero

	-- Asignacion de Constantes
	SET Lis_Principal			:= 1;
	SET	Cadena_Vacia			:= '';
	SET	Fecha_Vacia				:= '1900-01-01';
	SET	Entero_Cero				:= 0;

	-- Lista principal
	IF (Par_NumLis = Lis_Principal)THEN
		SELECT ClasContableID ,	Descripcion
			FROM CATCLASCONTAC0922;
	END IF;

END TerminaStore$$