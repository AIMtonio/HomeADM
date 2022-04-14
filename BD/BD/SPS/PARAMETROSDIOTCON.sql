-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMETROSDIOTCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMETROSDIOTCON`;DELIMITER $$

CREATE PROCEDURE `PARAMETROSDIOTCON`(
-- --------------------------------------------------------------------
-- SP QUE REALIZA LA CONSULTA DE LOS PARAMETROS DE LA DIOT
-- --------------------------------------------------------------------
	Par_NumCon			TINYINT UNSIGNED,	-- Numero de Consulta

	/* Parametros de Auditoria */
    Par_EmpresaID 		int(11) ,
	Aud_Usuario			INT(11),			-- Auditoria
	Aud_FechaActual		DATETIME,			-- Auditoria
	Aud_DireccionIP		VARCHAR(15), 		-- Auditoria
	Aud_ProgramaID		VARCHAR(50), 		-- Auditoria
	Aud_Sucursal		INT(11), 			-- Auditoria
	Aud_NumTransaccion	BIGINT(20) 			-- Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia			CHAR(1);
	DECLARE	Fecha_Vacia				DATE;
    DECLARE Entero_Cero				INT(11);
	DECLARE	Str_SI					CHAR(1);
	DECLARE	Str_NO					CHAR(1);
    DECLARE Con_Principal			INT(11);


	-- Asignacion de constantes
	SET	Cadena_Vacia			:= '';				-- Cadena vacia
	SET	Fecha_Vacia				:= '1900-01-01';	-- Fecha vacia
	SET	Entero_Cero				:= 0;				-- Entero cero

	SET	Str_SI					:= 'S';				-- Constante SI
	SET	Str_NO					:= 'N';				-- Constante NO
	SET Con_Principal			:= 1;				-- Consulta principal

	/* Consulta No. 1: para los parametros de Impuestos de la DIOT */
	IF(Par_NumCon = Con_Principal) THEN
	   SELECT ImpuestoID, IVA, RetIVA
		FROM PARAMETROSDIOT
        LIMIT 1;

	END IF;



END TerminaStore$$