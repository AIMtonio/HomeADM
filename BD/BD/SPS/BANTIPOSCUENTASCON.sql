-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BANTIPOSCUENTASCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `BANTIPOSCUENTASCON`;
DELIMITER $$


CREATE PROCEDURE `BANTIPOSCUENTASCON`(
-- SP para consulta de tipo de cuenta de ahorro de las bancas.
	Par_NumCon                      TINYINT UNSIGNED,

	Par_EmpresaID					INT(11),				-- Parametros de Auditoria
	Aud_Usuario         			INT(11),				-- Parametros de Auditoria
	Aud_FechaActual    			 	DATETIME,				-- Parametros de Auditoria
	Aud_DireccionIP   			  	VARCHAR(15),			-- Parametros de Auditoria
	Aud_ProgramaID    			  	VARCHAR(50),			-- Parametros de Auditoria
	Aud_Sucursal     			   	INT(11),				-- Parametros de Auditoria
	Aud_NumTransaccion  			BIGINT(20)				-- Parametros de Auditoria
)
TerminaStore: BEGIN
	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia			CHAR(1);				-- Cadena Vacia
	DECLARE	Fecha_Vacia				DATE;					-- Fecha Vacia
	DECLARE	Entero_Cero				INT(11);				-- Entero cero
	DECLARE Con_Principal	      	INT(11);				-- Consulta principal

	-- Asignacion de Constantes
	SET	Cadena_Vacia				:= '';					-- Valor de cadena vacia
	SET	Fecha_Vacia					:= '1900-01-01';		-- Valor de fecha vacia.
	SET	Entero_Cero					:= 0;					-- Valor de entero cero.
	SET Con_Principal         		:= 1;					-- Consulta principal.

	IF (Par_NumCon = Con_Principal) THEN
		SELECT TipoCuentaID FROM BANTIPOSCUENTAS LIMIT 1;
	END IF;

END TerminaStore$$