-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMWSAPILIS`;
DELIMITER $$


CREATE PROCEDURE `PARAMWSAPILIS`(
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
	
	DECLARE		Con_Principal		INT(11);	-- Consulta que devuelve los valores de los parametros con clave 
	DECLARE 	Var_NombreWS		BIGINT;		-- Variable para nombre webservice

	
	-- Asignacion de constantes
	SET	Cadena_Vacia			:= '';				-- Cadena vacia
	SET	Fecha_Vacia				:= '1900-01-01';	-- Fecha vacia
	SET	Entero_Cero				:= 0;				-- Entero cero
	SET	Con_Principal			:= 1;				-- Variable que trae parametros por el nombre del ws


	IF(Par_NumLis = Con_Principal) THEN
		SELECT ParamID, NombreWS, NombreCampo, Valor, Descripcion FROM PARAMWSAPI 
			WHERE NombreWS = Par_NombreWS;
	END IF;
	
END TerminaStore$$
