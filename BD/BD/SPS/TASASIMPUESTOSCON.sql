-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TASASIMPUESTOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TASASIMPUESTOSCON`;DELIMITER $$

CREATE PROCEDURE `TASASIMPUESTOSCON`(
/* CONSULTA DE LAS TASAS DE IMPUESTO */
	Par_TasaImpuestoID		INT(11),	-- Número de Tasa.
	Par_NumCon				INT(11),	-- Tipo de Consulta.
	/* Parámetros de Auditoría */
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
DECLARE	Con_Principal	INT(11);
DECLARE Entero_Uno		INT(11);
DECLARE Fecha_Vacia 	DATE;

-- DECLARACIÓN DE VARIABLES.
DECLARE Var_Fecha		DATE;

-- ASIGNACIÓN DE CONSTANTES,
SET	Con_Principal	:= 1;						-- Consulta Principal
SET Entero_Uno		:= 1;						-- Constante Uno
SET Fecha_Vacia		:= '1900-01-01';			-- Constante Fecha Vacia

# CONSULTA PARA LA TASA RESIDENTES NACIONALES.
IF(Par_NumCon = Con_Principal) THEN
	SET Var_Fecha := (SELECT MAX(Fecha) FROM `HIS-TASASIMPUESTOS` AS hti
						INNER JOIN TASASIMPUESTOS AS ti ON ti.Valor = hti.Valor
							WHERE ti.TasaImpuestoID = Par_TasaImpuestoID);
	SET Var_Fecha := IFNULL(Var_Fecha,Fecha_Vacia);
	SELECT
		TasaImpuestoID,	Nombre,	Descripcion,	Valor,	Var_Fecha AS Fecha,
		TipoTasa
	FROM TASASIMPUESTOS
		WHERE TasaImpuestoID  = Par_TasaImpuestoID;
END IF;

END TerminaStore$$