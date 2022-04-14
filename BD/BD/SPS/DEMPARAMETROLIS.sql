-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DEMPARAMETROLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `DEMPARAMETROLIS`;DELIMITER $$

CREATE PROCEDURE `DEMPARAMETROLIS`(
	-- SP para listar los parametros de una tarea
	Par_TareaID					INT(11),				-- Identificador de la tarea
	Par_Parametro				VARCHAR(20),			-- Parametro
	Par_Valor					VARCHAR(200),			-- Valor
	Par_Descripcion				VARCHAR(800),			-- Descripcion

	Par_NumLis					TINYINT UNSIGNED,		-- Numero de lista

	Aud_EmpresaID				INT(11),				-- Parametro de auditoria
	Aud_Usuario					INT(11),				-- Parametro de auditoria
	Aud_FechaActual				DATETIME,				-- Parametro de auditoria
	Aud_DireccionIP				VARCHAR(15),			-- Parametro de auditoria
	Aud_ProgramaID				VARCHAR(50),			-- Parametro de auditoria
	Aud_Sucursal				INT(11),				-- Parametro de auditoria
	Aud_NumTransaccion			BIGINT(20)				-- Parametro de auditoria
	)
TerminaStore:BEGIN

	-- Declaracion de constantes
	DECLARE	Entero_Cero			INT(11);			-- Entero cero
	DECLARE	Lis_Principal		TINYINT UNSIGNED;	-- Lista principal

	-- Asignacion de constantes
	SET	Entero_Cero				:= 0;				-- Entero cero
	SET	Lis_Principal			:= 1;				-- Lista principal

	-- Lista Principal
	IF (Par_NumLis = Lis_Principal) THEN
		SELECT		TareaID,		Parametro,		Valor,		Descripcion
			FROM	DEMPARAMETRO;
	END IF;
END TerminaStore$$