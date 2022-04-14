-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RELACIONEMPLEADOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `RELACIONEMPLEADOLIS`;DELIMITER $$

CREATE PROCEDURE `RELACIONEMPLEADOLIS`(
# =====================================================================================
# ----- SP PARA LISTAR LAS RELACIONES DE LOS EMPLEADOS -----------------
# =====================================================================================
    Par_EmpleadoID      INT(11),			-- Clave del Empleado
    Par_NombreEmpleado 	VARCHAR(200),		-- Nombre del Empleado
    Par_NumLis          TINYINT UNSIGNED,	-- Numero de Lista

	/* Parametros de Auditoria */
    Par_EmpresaID      	INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
	)
TerminaStore: BEGIN

	-- Declaracion de constantes
DECLARE Cadena_Vacia	CHAR(1);
DECLARE Fecha_Vacia		DATE;
DECLARE Entero_Cero		INT(11);
DECLARE Lis_Principal	INT(11);
DECLARE Lis_Relaciones 	INT(11);

	-- Asignacion de constantes
SET	Cadena_Vacia	:= '';
SET	Fecha_Vacia		:= '1900-01-01';
SET	Entero_Cero		:= 0;
SET	Lis_Principal	:= 1;
SET	Lis_Relaciones	:= 3;

	IF(Par_NumLis = Lis_Principal) THEN
		SELECT	PersonaID,		NombrePersona, 	CURP,		RFC,		PuestoID
		FROM RELACIONPERSONAS
		WHERE  NombrePersona	LIKE	CONCAT("%", Par_NombreEmpleado, "%")
        LIMIT 0, 15;

	END IF;

	IF(Par_NumLis = Lis_Relaciones) THEN
        SELECT
            Rel.EmpleadoID, Rel.RelacionadoID,	Rel.NombreRelacionado,	Rel.CURP,	Rel.RFC,
            Rel.PuestoID,	Rel.ParentescoID, 	Rel.TipoRelacion
        FROM
            RELACIONEMPLEADO Rel
        WHERE Rel.EmpleadoID = Par_EmpleadoID;
	END IF;

END TerminaStore$$