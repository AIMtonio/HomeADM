-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RELACIONEMPLEADOBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `RELACIONEMPLEADOBAJ`;DELIMITER $$

CREATE PROCEDURE `RELACIONEMPLEADOBAJ`(
# =====================================================================================
# ----- SP PARA DARA DE BAJA LAS RELACIONES DE LOS EMPLEADOS -----------------
# =====================================================================================
	Par_EmpleadoID		INT(11),	-- Clave del Empleado

	/* Parametros de Auditoria */
	Aud_Empresa			INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
	)
TerminaStore: BEGIN

	-- Declaracion de constantes
DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT(11);

	-- Asignacion de constantes
SET	Cadena_Vacia	:= '';
SET	Fecha_Vacia		:= '1900-01-01';
SET	Entero_Cero		:= 0;

DELETE FROM RELACIONEMPLEADO
WHERE EmpleadoID = Par_EmpleadoID;

SELECT '000' AS NumErr ,
	  'Relaciones del Cliente Eliminados' AS ErrMen,
	  'clienteID' AS control;

END TerminaStore$$