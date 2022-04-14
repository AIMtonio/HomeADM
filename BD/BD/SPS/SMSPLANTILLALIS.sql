-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSPLANTILLALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `SMSPLANTILLALIS`;DELIMITER $$

CREATE PROCEDURE `SMSPLANTILLALIS`(
# ========================================================
# ------------ SP PARA LISTAR LAS PLANTILLAS SMS----------
# ========================================================
	Par_PlantillaID		VARCHAR(10),
	Par_Nombre			VARCHAR(45),

	Aud_EmpresaID		INT(11),
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
	DECLARE	Entero_Cero		INT;
	DECLARE	Lis_Principal	INT;
	DECLARE	EstatusActivo	CHAR(1);

	-- Asignacion de constantes
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Lis_Principal		:= 1;


	SELECT 		DISTINCT PlantillaID, Nombre, Descripcion
		FROM 	SMSPLANTILLA
		WHERE 	Nombre LIKE CONCAT("%", Par_Nombre, "%")
        LIMIT 	0, 15;

END TerminaStore$$