-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_BITACORAMOVSACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TC_BITACORAMOVSACT`;

DELIMITER $$
CREATE PROCEDURE `TC_BITACORAMOVSACT`(
	/* ----------------------------------------------------------
	Actualiza el Estatus de la bitacora de Transacciones
	-- ---------------------------------------------------------- */
	Par_TarCredMovID		INT(11),		-- Numero de movimiento en bitacora
	Par_NumAct				TINYINT UNSIGNED,-- Numero de Operacion

	Par_Salida				CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr		INT(11),		-- Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- Mensaje de Error

	Par_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore:BEGIN

	DECLARE Var_TarCredMovID	INT(11);	-- Numero de Movimiento de la Tarjeta

	-- Declaracion de constantes
	DECLARE Salida_SI			CHAR(1);	-- Constante Salida NO
	DECLARE Estatus_Pro			CHAR(1);	-- Estatus Procesado
	DECLARE Act_Estatus			INT(11);	-- Estatus Procesado
	DECLARE Entero_Cero			INT(11);	-- Entero Cero

	-- Asignacion de constantes
	SET Salida_SI			:= 'S';
	SET Estatus_Pro			:= 'P';
	SET Act_Estatus			:= 1;
	SET Entero_Cero			:= 0;

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									 'Disculpe las molestias que esto le ocasiona. Ref: SP-TC_BITACORAMOVSACT');
		END;

		SET Par_TarCredMovID := IFNULL(Par_TarCredMovID, Entero_Cero);

		IF( Par_TarCredMovID = Entero_Cero) THEN
			SET Par_NumErr:= 001;
			SET Par_ErrMen:= 'El Numero de Movimiento de Tarjeta de Credito esta Vacio';
			LEAVE ManejoErrores;
		END IF;

		SELECT TarCredMovID
		INTO Var_TarCredMovID
		FROM TC_BITACORAMOVS
		WHERE TarCredMovID = Par_TarCredMovID;

		SET Var_TarCredMovID := IFNULL(Var_TarCredMovID, Entero_Cero);

		IF( Var_TarCredMovID = Entero_Cero) THEN
			SET Par_NumErr:= 001;
			SET Par_ErrMen:= 'El Numero de Movimiento de Tarjeta de Credito No Existe';
			LEAVE ManejoErrores;
		END IF;

		IF Par_NumAct = Act_Estatus THEN
			UPDATE TC_BITACORAMOVS SET
				Estatus 		= Estatus_Pro,
				Usuario			= Aud_Usuario,
				FechaActual		= Aud_FechaActual,
				DireccionIP		= Aud_DireccionIP,
				ProgramaID		= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE TarCredMovID = Par_TarCredMovID;

			SET Par_NumErr:= Entero_Cero;
			SET Par_ErrMen:= 'Actualizacion de Bitacora Exitoso';
			LEAVE ManejoErrores;
		END IF;

	END ManejoErrores;

	IF Par_Salida = Salida_SI THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen;
	END IF;

END TerminaStore$$