-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- VALCAJASDESTINATARIOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `VALCAJASDESTINATARIOSLIS`;
DELIMITER $$

CREATE PROCEDURE `VALCAJASDESTINATARIOSLIS`(
	Par_NumLis				TINYINT UNSIGNED,	-- Numero de

	Par_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Fecha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- DECLARACION DE CONSTANTES
	DECLARE Lis_Dest		INT(1);
	DECLARE Lis_Copia		INT(1);

	-- ASIGNACION DE CONSTANTES
	SET Lis_Dest			:= 1;
	SET Lis_Copia			:= 2;

	IF(Par_NumLis = Lis_Dest) THEN
		SELECT CD.UsuarioID, CD.Tipo, U.NombreCompleto
		FROM VALCAJASDESTINATARIOS CD
		INNER JOIN
			USUARIOS U ON U.UsuarioID = CD.UsuarioID
		WHERE CD.Tipo = 'D'
		LIMIT 0, 15;
	END IF;

	IF(Par_NumLis = Lis_Copia) THEN
		SELECT CD.UsuarioID, CD.Tipo, U.NombreCompleto
		FROM VALCAJASDESTINATARIOS CD
		INNER JOIN
			USUARIOS U ON U.UsuarioID = CD.UsuarioID
		WHERE CD.Tipo = 'C'
		LIMIT 0, 15;
	END IF;

END TerminaStore$$