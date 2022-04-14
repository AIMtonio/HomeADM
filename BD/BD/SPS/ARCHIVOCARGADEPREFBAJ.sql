-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARCHIVOCARGADEPREFBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `ARCHIVOCARGADEPREFBAJ`;DELIMITER $$

CREATE PROCEDURE `ARCHIVOCARGADEPREFBAJ`(
	/* SP DE BAJA DE LA TABLA DE CARGA PARA DEPÓSITOS REFERENCIADOS. */
	Par_TranCarga			BIGINT(20),		-- Numero de transacción de la carga.
	Par_TipoBaja			INT(1),			-- Tipo de Baja.
	Par_Salida				CHAR(1),		-- Indica el tipo de Salida.
	INOUT Par_NumErr		INT(11),		-- Número de Error.
	INOUT Par_ErrMen		VARCHAR(400),	-- Mensaje de Error.

	INOUT Par_Consecutivo	BIGINT(20),		-- Número consecutivo.
	/* Parámetros de Auditoría */
	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),

	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_Control			VARCHAR(50);

-- Declaracion de Constantes
DECLARE Entero_Cero 		INT;
DECLARE Cadena_Vacia		CHAR(1);
DECLARE Salida_SI			CHAR(1);
DECLARE Salida_NO			CHAR(1);
DECLARE TipoXTransaccion	CHAR(1);

-- Asignacion de Constantes
SET Entero_Cero		:= 0;
SET Salida_SI		:= 'S';
SET Salida_NO		:= 'N';
SET TipoXTransaccion := 1;

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-ARCHIVOCARGADEPREFBAJ');
			SET Var_Control:= 'sqlException' ;
		END;

	IF(Par_TipoBaja=TipoXTransaccion)THEN
		IF(Par_TranCarga!=Entero_Cero)THEN
			DELETE FROM ARCHIVOCARGADEPREF
				WHERE NumTran = Par_TranCarga;
		END IF;

		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen := 'Baja Exitosa.';
		LEAVE ManejoErrores;
	END IF;

END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen;
	END IF;

END TerminaStore$$