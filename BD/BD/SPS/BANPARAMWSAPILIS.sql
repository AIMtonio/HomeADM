-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
DELIMITER ;
DROP PROCEDURE IF EXISTS `BANPARAMWSAPILIS`;
DELIMITER $$


CREATE PROCEDURE `BANPARAMWSAPILIS`(
	Par_NombreWS		VARCHAR(100),				-- Nombre del ws pertenecientes a los parametros
	Par_NumLis			TINYINT UNSIGNED,			-- Numero de consulta

	Aud_EmpresaID		INT(11),					-- Auditoria
	Aud_Usuario			INT(11),					-- Auditoria
	Aud_FechaActual		DATETIME,					-- Auditoria
	Aud_DireccionIP		VARCHAR(15),				-- Auditoria
	Aud_ProgramaID		VARCHAR(50),				-- Auditoria
	Aud_Sucursal		INT(11),					-- Auditoria
	Aud_NumTransaccion	BIGINT						-- Auditoria
	)

TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE	Cadena_Vacia			CHAR(1);
	DECLARE	Fecha_Vacia				DATE;
	DECLARE	Entero_Cero				INT(11);

	-- Asignacion de constantes
	SET	Cadena_Vacia			:= '';				-- Cadena vacia
	SET	Fecha_Vacia				:= '1900-01-01';	-- Fecha vacia
	SET	Entero_Cero				:= 0;				-- Entero cero


	CALL PARAMWSAPILIS(	Par_NombreWS,		Par_NumLis,			Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
						Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

END TerminaStore$$
