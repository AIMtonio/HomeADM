
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACTIVACIONESCTESALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACTIVACIONESCTESALT`;

DELIMITER $$
CREATE PROCEDURE `BITACTIVACIONESCTESALT`(
/* ALTA EN BITÁCORA DE ACTIVACIONES E INACTIVACIONES DE CLIENTES. */
	Par_ClienteID			INT(11),		-- Número de Cliente.
	Par_Salida				CHAR(1),		-- Indica el tipo de salida S.- Si N.- No.
	INOUT Par_NumErr		INT(11),		-- Numero de Validación.
	INOUT Par_ErrMen		VARCHAR(400),	-- Mensaje de Validación.
	/* Parametros de Auditoria */
	Par_EmpresaID			INT(11),

	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),

	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE Var_Control			CHAR(15);				-- Control.
DECLARE Var_Estatus			CHAR(1);				-- Estatus del cliente. A.- Activo. I.- Inactivo.
DECLARE Var_TipoInactiva	INT;					-- Tipo de Movimiento. 1.-Activación. 2.-Inactivacion.
DECLARE Var_MotivoInactiva	VARCHAR(150);			-- Motivo de la Activación o Inactivación.
DECLARE Var_FechaBaja		DATE;					-- Fecha en la que se da de Baja al Cliente.
DECLARE Var_FechaReact		DATE;					-- Fecha de Reactivación del Cliente.

-- Declaracion de Constantes
DECLARE Cadena_Vacia		VARCHAR(1);
DECLARE Fecha_Vacia			DATE;
DECLARE Entero_Cero			INT(11);
DECLARE Str_SI				CHAR(1);
DECLARE Str_NO				CHAR(1);

-- Asignacion de Constantes
SET Cadena_Vacia			:= '';				-- Cadena vacia
SET Fecha_Vacia				:= '1900-01-01';	-- Fecha vacia
SET Entero_Cero				:= 0;				-- Entero Cero
SET Str_SI					:= 'S';				-- Salida Si
SET Str_NO					:= 'N'; 			-- Salida No
SET Aud_FechaActual 		:= NOW();

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			GET DIAGNOSTICS condition 1
			@Var_SQLState = RETURNED_SQLSTATE, @Var_SQLMessage = MESSAGE_TEXT;
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-BITACTIVACIONESCTESALT[',@Var_SQLState,'-' , @Var_SQLMessage,']');
			SET Var_Control:= 'sqlException' ;
		END;

	IF(IFNULL(Par_ClienteID, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr := 1;
		SET Par_ErrMen := CONCAT('El Numero de ',FNGENERALOCALE('safilocale.cliente'),' esta Vacio.');
		SET Var_Control:= 'clienteID' ;
		LEAVE ManejoErrores;
	END IF;

	# SE OBTIENEN LOS DATOS ANTES DE LA ACTIVACIÓN O INACTIVACIÓN.
	SELECT
		Estatus,		TipoInactiva,		MotivoInactiva,		FechaBaja,		FechaReactivacion
	INTO
		Var_Estatus,	Var_TipoInactiva,	Var_MotivoInactiva,	Var_FechaBaja,	Var_FechaReact
	FROM CLIENTES
	WHERE ClienteID = Par_ClienteID;

	SET Var_Estatus			:= IFNULL(Var_Estatus,Cadena_Vacia);
	SET Var_TipoInactiva	:= IFNULL(Var_TipoInactiva,Entero_Cero);
	SET Var_MotivoInactiva	:= IFNULL(Var_MotivoInactiva,Cadena_Vacia);
	SET Var_FechaBaja		:= IFNULL(Var_FechaBaja,Fecha_Vacia);
	SET Var_FechaReact		:= IFNULL(Var_FechaReact,Fecha_Vacia);

	# REGISTRO EN LA BITÁCORA.
	INSERT INTO BITACTIVACIONESCTES(
		ClienteID,			Estatus,		TipoInactiva,		MotivoInactiva,		FechaBaja,
		FechaReactivacion,	EmpresaID,		Usuario,			FechaActual,		DireccionIP,
		ProgramaID,			Sucursal,		NumTransaccion)
	VALUES(
		Par_ClienteID,		Var_Estatus,	Var_TipoInactiva,	Var_MotivoInactiva,	Var_FechaBaja,
		Var_FechaReact,		Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
		Aud_ProgramaID, 	Aud_Sucursal,	Aud_NumTransaccion);

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := 'Registro Grabado Exitosamente.';
	SET Var_Control:= 'clienteID' ;

END ManejoErrores;

IF (Par_Salida = Str_SI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Par_ClienteID AS Consecutivo;
END IF;

END TerminaStore$$

