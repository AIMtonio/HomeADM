-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOPRODSUCURSALESBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOPRODSUCURSALESBAJ`;DELIMITER $$

CREATE PROCEDURE `TIPOPRODSUCURSALESBAJ`(
# =================================================================
# ----- SP PARA DAR DE BAJA SUCURSALES DE UN TIPO DE CEDE----------
# =================================================================
	Par_InstrumentoID		INT(11),

	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore:BEGIN

	-- Declaracion de variables
	DECLARE varControl 		    VARCHAR(20);	# almacena el elmento que es incorrecto
	DECLARE Var_TipCuentaSucID	INT(11);

	-- Declaracion de constantes
	DECLARE Entero_Cero			INT(11);		# entero cero
	DECLARE Decimal_Cero		DECIMAL(12,2);	# DECIMAL cero
	DECLARE Cadena_Vacia		CHAR(1);		# cadena vacia
	DECLARE Salida_SI			CHAR(1);		# salida SI
	DECLARE Estatus_Activo 		CHAR(1);		# Estatus activo
	DECLARE Estatus_Inactivo 	CHAR(1);		# Estatus inactivo
	DECLARE EliminarExistentes	CHAR(1);		# Indica si elimina los registros existente para el tipo de producto de credito indicado

	-- Asignacion de constantes
	SET Entero_Cero			:= 0;
	SET Decimal_Cero		:= 0.0;
	SET Cadena_Vacia		:='';
	SET Estatus_Activo		:= 'A';
	SET Estatus_Inactivo	:= 'I';
	SET Salida_SI			:= 'S';
	SET EliminarExistentes	:= 'S';


	ManejoErrores:BEGIN 	#bloque para manejar los posibles errores
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = '999';
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-TIPOPRODSUCURSALESBAJ');
				SET varControl = 'SQLEXCEPTION' ;
			END;

		DELETE FROM TIPOPRODSUCURSALES
			WHERE InstrumentoID = Par_InstrumentoID ;

		SET Par_NumErr  := '000';
		SET Par_ErrMen  := 'Sucursal(es) Eliminada(s) Exitosamente.';
		SET varControl  := 'tipoCuentaID';

	END ManejoErrores; /*fin del manejador de errores*/

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr		 	AS NumErr,
				Par_ErrMen		 	AS ErrMen,
				varControl		 	AS control,
				Par_InstrumentoID	AS consecutivo;
	END IF;

END TerminaStore$$