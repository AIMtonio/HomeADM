-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TASASIMPUESTOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TASASIMPUESTOSLIS`;DELIMITER $$

CREATE PROCEDURE `TASASIMPUESTOSLIS`(
/* LISTA DE TASAS DE IMPUESTOS */
	Par_Nombre				VARCHAR(45),	-- Nombre corto.
	Par_NumLis				INT(11),		-- Tipo de Lista.
	/* Parámetro de Auditoría */
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,

	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore:BEGIN
-- DECLARACIÓN DE CONSTANTES.
DECLARE	Lis_Principal	INT(11);

-- ASIGNACIÓN DE CONSTANTES.
SET	Lis_Principal	:= 1;		-- Tipo de Lista Principal.

IF(Par_NumLis = Lis_Principal) THEN
	SELECT	TasaImpuestoID,	Nombre,	Valor
		FROM  TASASIMPUESTOS
		 WHERE Nombre LIKE CONCAT("%", Par_Nombre, "%");
END IF;

END TerminaStore$$