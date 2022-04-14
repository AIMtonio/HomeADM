-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATTASAREFEREGCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATTASAREFEREGCON`;DELIMITER $$

CREATE PROCEDURE `CATTASAREFEREGCON`(
# =====================================================================================
# -----       STORE DE CONSULTA TIPO DE TASA DE REGULATORIOS  		 	 ------
# ====================================================================================
	Par_TasaReferenID		INT(11),					-- Id de la tasa de referencia a Consultar
	Par_NumConsulta			TINYINT UNSIGNED,			-- Tipo  de lista

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
	DECLARE Con_Principal		INT(11);
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);

	-- Asignacion de Constantes
	SET Con_Principal			:= 1;
	SET	Cadena_Vacia			:= '';
	SET	Fecha_Vacia				:= '1900-01-01';
	SET	Entero_Cero				:= 0;


	IF (Par_NumConsulta = Con_Principal)THEN
		SELECT CodigoOpcion,	Descripcion
			FROM CATTASAREFERENREG
		WHERE CodigoOpcion = Par_TasaReferenID;
	END IF;

END TerminaStore$$