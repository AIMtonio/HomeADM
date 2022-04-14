-- SP SERVICIOSADICIONALESBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS SERVICIOSADICIONALESBAJ;
DELIMITER $$

CREATE PROCEDURE SERVICIOSADICIONALESBAJ(
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

	# Declaracion de contantes
	DECLARE Var_Control		VARCHAR(200);
	DECLARE SalidaSI		CHAR(1);
	DECLARE Con_Estatus		CHAR(1);	-- Constante para indicar el estatus en INACTIVO
	DECLARE Var_Consecutivo	INT(11);

	#Seteo de constantes
	SET SalidaSI 		:= 'S';			-- Constante de Salida  Si
	SET Con_Estatus 	:= 'I';			-- Constante de Estaus Inactivo

	SET Var_Consecutivo := Par_ServicioID;			-- Consecutivo Cero

	# *** Manejo de excepciones ***
	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-SERVICIOSADICIONALESBAJ');
				SET Var_Control :='SQLEXCEPTION';
			END;

		UPDATE SERVICIOSADICIONALES
			SET Estatus = Con_Estatus
		WHERE 	ServicioID 	= Par_ServicioID;

		SET Par_NumErr 	:= 000;
		SET Par_ErrMen 	:= 'Proceso de Baja Termino Exitosamente';
		SET Var_Control := 'servicioID';

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr  		AS NumErr,
				Par_ErrMen  		AS ErrMen,
				Var_Control			AS Control,
				Var_Consecutivo		AS Consecutivo;
	END IF;

END TerminaStore$$