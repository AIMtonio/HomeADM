-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBCONCIENCABEZAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBCONCIENCABEZAALT`;DELIMITER $$

CREATE PROCEDURE `TARDEBCONCIENCABEZAALT`(
# =====================================================================================
# ----- STORED QUE INSERTA EL ENCABEZADO DEL ARCHIVO DE CONCILIACION DE TARJETAS DE DEBITO -------
# =====================================================================================

	Par_NomInstituGene	VARCHAR(20),		-- Nombre institucion que genera
	Par_NomInstituReci	VARCHAR(20),		-- Nombre institucion que recibe
	Par_FechaProceso	CHAR(6),			-- Fecha de proceso
	Par_Consecutivo		INT(11),			-- Consecutivo
    Par_NombreArchivo	VARCHAR(150),		-- Nombre del archivo cargado

	Par_Salida			CHAR(1),			-- Salida del store
	INOUT Par_NumErr	INT(11),			-- Numero de error
	INOUT Par_ErrMen	VARCHAR(400),		-- Mensaje de error
	INOUT Par_ConciID	INT(11),			-- Id concicliacion

	-- Parametros Auditoria
	Par_EmpresaID		INT(11), 			-- Auditoria
	Aud_Usuario			INT(11), 			-- Auditoria
	Aud_FechaActual		DATETIME, 			-- Auditoria
	Aud_DireccionIP		VARCHAR(15), 		-- Auditoria
	Aud_ProgramaID		VARCHAR(250), 		-- Auditoria
	Aud_Sucursal		INT(11), 			-- Auditoria
	Aud_NumTransaccion	BIGINT(20) 			-- Auditoria
	)
TerminaStore: BEGIN

DECLARE Cadena_Vacia	CHAR(1);		-- Cadena vacia
DECLARE Entero_Cero		INT(11);		-- Entero cero
DECLARE Salida_SI		CHAR(1);		-- Salida del store
DECLARE Var_Control		VARCHAR(100);	-- Variable de control
DECLARE Var_ConciliaID	INT(11);		-- Variable Id conciliacion

SET Cadena_Vacia	:= '';			-- Cadena vacia
SET Entero_Cero		:= 0;			-- Entero cero
SET Salida_SI		:= 'S';			-- Store Si tiene un valor de salida

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr   := 999;
			SET Par_ErrMen   := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
				'esto le ocasiona. Ref: SP-TARDEBCONCIENCABEZAALT');
			SET Var_Control  := 'SQLEXCEPTION';
		END;

		CALL FOLIOSAPLICAACT('TARDEBCONCIENCABEZA', Par_ConciID);

		INSERT INTO `TARDEBCONCIENCABEZA`(
				`ConciliaID`,	`NomInstituGenera`,	`NomInstituRecibe`,	`FechaProceso`,	`Consecutivo`,
				`EmpresaID`,	`Usuario`,			`FechaActual`,		`DireccionIP`,	`ProgramaID`,
				`Sucursal`,		`NumTransaccion`,	`NombreArchivo`)
		VALUES(
				Par_ConciID,	Par_NomInstituGene,	Par_NomInstituReci,	Par_FechaProceso,	Par_Consecutivo,
				Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,	Aud_NumTransaccion,	Par_NombreArchivo );

		SET Par_NumErr  := 000;
		SET Par_ErrMen	:= 'Registro Guardado Correctamente';
        SET Var_Control := Cadena_Vacia;
		SET Entero_Cero := Par_ConciID;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI)THEN
		    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Entero_Cero AS consecutivo;
	END IF;
END TerminaStore$$