-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASAHOTESOBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASAHOTESOBAJ`;DELIMITER $$

CREATE PROCEDURE `CUENTASAHOTESOBAJ`(
# ============================================================
# ------------SP PARA DAR DE BAJA CUENTAS BANCARIAS-----------
# ============================================================
	Par_CuentaAhoID 	BIGINT(12),
	Par_InstitucionID 	INT(11),
	Par_NumCtaInstit 	VARCHAR(20),

	Par_Salida			CHAR(1),
	INOUT Par_NumErr	INT(11),
	INOUT Par_ErrMen	VARCHAR(400),

	Aud_EmpresaID 		INT(11),
	Aud_Usuario 		INT(11),
	Aud_FechaActual 	DATETIME,
	Aud_DireccionIP 	VARCHAR(20),
	Aud_ProgramaID 		VARCHAR(50),
	Aud_Sucursal 		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN
	-- Declaracion de constantes
	DECLARE	NumeroSucursal		INT(11);
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);
	DECLARE SalidaSI			CHAR(1);
	DECLARE	Estatus_Inactivo	CHAR(1);
	DECLARE VarControl 			VARCHAR(100);
	DECLARE	Var_Consecutivo		BIGINT(12);

	-- Asignación de constantes
	SET	NumeroSucursal			:= 0;
	SET	Cadena_Vacia			:= '';
	SET	Fecha_Vacia				:= '1900-01-01';
	SET	Entero_Cero				:= 0;
	SET SalidaSI				:= 'S';
	SET	Estatus_Inactivo		:= 'I';
	SET Aud_FechaActual 		:= CURRENT_TIMESTAMP();

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									 'Disculpe las molestias que esto le ocasiona. Ref: SP-CUENTASAHOTESOBAJ');
				SET VarControl = 'sqlException';
			END;


		UPDATE CUENTASAHOTESO SET
				Estatus			= Estatus_Inactivo,

				EmpresaID 		= Aud_EmpresaID,
				Usuario 		= Aud_Usuario,
				FechaActual 	= Aud_FechaActual,
				DireccionIP 	= Aud_DireccionIP,
				ProgramaID 		= Aud_ProgramaID,
				Sucursal 		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
		WHERE	InstitucionID	= Par_InstitucionID
		AND 	NumCtaInstit	= Par_NumCtaInstit;

		SET Par_NumErr		:= 000;
		SET Par_ErrMen		:= CONCAT('Cuenta Bancaria Cancelada Exitosamente: ', CONVERT(Par_NumCtaInstit, CHAR));
		SET VarControl		:= 'numCtaInstit';
		SET Var_Consecutivo := Entero_Cero;


	END ManejoErrores; -- End del Handler de Errores

	 IF (Par_Salida = SalidaSI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				VarControl AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$