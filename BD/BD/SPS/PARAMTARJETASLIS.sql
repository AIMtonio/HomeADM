-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMTARJETASLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS PARAMTARJETASLIS;

DELIMITER $$
CREATE PROCEDURE `PARAMTARJETASLIS`(
	-- Store Procedure de Consulta de los Parametros de Tarjetas
	Par_NumLista			TINYINT UNSIGNED,	-- Numero de Consulta

	Aud_EmpresaID			INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)
TerminaStore : BEGIN

	-- Declaracion de Listas
	DECLARE Lis_Principal					TINYINT UNSIGNED;

	-- Asignacion de Listas
	SET Lis_Principal					:= 1;

	-- Consulta Principal
	IF( Par_NumLista = Lis_Principal ) THEN

		SELECT LlaveParametro, ValorParametro
		FROM PARAMTARJETAS;

	END IF;
END TerminaStore$$
