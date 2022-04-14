-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCUENTAIVACARTCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCUENTAIVACARTCON`;DELIMITER $$

CREATE PROCEDURE `SUBCUENTAIVACARTCON`(
-- =================================================
-- SP PARA CONSULTAR LA SUB CUENTA POR IVA ASIGNADO
-- =================================================
	Par_ConceptoCartID		INT(11),
	Par_Porcentaje			DECIMAL(12,2),
	Par_TipoCon				INT(11),

	/* Parametros Auditoria */
	Aud_EmpresaID		INT(11),
	Aud_UsuarioID		INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore:BEGIN

	/* Declaración de Constantes*/
	DECLARE Con_Principal 	INT(11);

	/*Asignación de Constantes*/
	SET Con_Principal	:= 1;

	IF(Par_TipoCon=Con_Principal)THEN
		SELECT ConceptoCartID,	Porcentaje, SubCuenta
		FROM SUBCUENTAIVACART
		WHERE ConceptoCartID = Par_ConceptoCartID
		AND Porcentaje = Par_Porcentaje;
	END IF;

END TerminaStore$$