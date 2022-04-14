-- COMENTASEGUIMIENTOPDMLIS

DELIMITER ;
DROP PROCEDURE IF EXISTS `COMENTASEGUIMIENTOPDMLIS`;
DELIMITER $$
CREATE  PROCEDURE `COMENTASEGUIMIENTOPDMLIS`(
	/*
	* SP para Listar lis cometario del cliente y del usuario
	* en el seguimiento de folios JPMovil
	*/
	Par_SeguimientoID		INT(11),			-- Folio de seguimiento a listar comentarios
	Par_NumLista			INT(11),			-- Numero de lista a realizar

	Par_EmpresaID 			INT(11),			-- Parametro de Auditoria
	Aud_Usuario 			INT(11),			-- Parametro de Auditoria
	Aud_FechaActual 		DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP 		VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID 			VARCHAR(50), 		-- Parametro de Auditoria
	Aud_Sucursal 			INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion 		BIGINT(20)			-- Parametro de Auditoria
)

TerminaStore:BEGIN

	-- Declaracion de constantes
	DECLARE Lis_Principal	INT(11);		-- Numero de lista a generar
	DECLARE Entero_Cuatro	INT(11);		-- Numero de registros a devolver
	-- Declaracion de Variables


	-- Seteo de valores
	SET Lis_Principal		:= 2;
	SET Entero_Cuatro		:= 4;

	-- Lista de comentarios para la pantalla de Seguimiento de Folio JPMovil
	IF Par_NumLista = Lis_Principal THEN
		SELECT ConsecutivoID,ComentarioUsuario,ComentarioCliente
		FROM COMENTASEGUIMIENTOPDM
		WHERE SeguimientoID = Par_SeguimientoID
		ORDER BY ConsecutivoID DESC LIMIT Entero_Cuatro;
	END IF;


END TerminaStore$$