-- SP SERVICIOSXEMPRESABAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS SERVICIOSXEMPRESABAJ;
DELIMITER $$

CREATE PROCEDURE SERVICIOSXEMPRESABAJ(
	Par_ServicioID		INT(11),

	Par_Salida			CHAR(1),		-- Salida en Pantalla

	/* Parametros de Entrada/Salida */
	INOUT Par_NumErr	INT(11),		-- Numero  de Error o Exito
	INOUT Par_ErrMen	VARCHAR(400),	-- Mensaje de Error o Exito

	/* Parametros de Auditoria */
	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT
)

TerminaStore: BEGIN

	# Decalracion de Variables
	DECLARE Var_Control		VARCHAR(200);
	DECLARE Var_Consecutivo	INT(1);

	# Decalracion de Constantes
	DECLARE SalidaSI		CHAR(1);

	#Decalracion de Constantes
	SET SalidaSI := 'S';				-- Salida Si
	#Decalracion de Variables
	SET Var_Consecutivo := 0;			-- Consecutivo en cero

	# *** Manejo de excepciones ***
	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-SERVICIOSXEMPRESABAJ');
				SET Var_Control :='SQLEXCEPTION';
			END;

		DELETE FROM SERVICIOSXEMPRESA
			WHERE ServicioID = Par_ServicioID;

		SET Par_NumErr := 000;
		SET Par_ErrMen := 'Proceso Eliminación Termino Exitosamente';
		SET Var_Control := 'servicioID';

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr  	AS NumErr,
				Par_ErrMen  	AS ErrMen,
				Var_Control		AS Control,
				Var_Consecutivo	AS Consecutivo;
	END IF;

END TerminaStore$$