-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORABATCHALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORABATCHALT`;DELIMITER $$

CREATE PROCEDURE `BITACORABATCHALT`(
# ===================================================================
# -------- SP PARA REGISTRAR LOS PROCESO BATCH EN LA BITACORA -------
# ===================================================================
	Par_ProcesoBatchID 	INT(11),
	Par_Fecha			DATE,
	Par_Tiempo			INT(11),

	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_Consecutivo	INT(11);

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT(11);

	-- Asignaciond e constantes
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;

	SET Var_Consecutivo 	:= (SELECT IFNULL(MAX(Orden),Entero_Cero) + 1 FROM BITACORABATCH WHERE Fecha = Par_Fecha);

	INSERT INTO BITACORABATCH VALUES(
		Par_ProcesoBatchID,		Par_Fecha,			Par_Tiempo,			Var_Consecutivo,
        Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
        Aud_Sucursal,			Aud_NumTransaccion);

END TerminaStore$$