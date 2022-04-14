-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- VALCAJASDESTINATARIOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `VALCAJASDESTINATARIOSALT`;
DELIMITER $$

CREATE PROCEDURE `VALCAJASDESTINATARIOSALT`(
	Par_UsuarioID			INT(11),		-- Usuario que se el envía correo
	Par_Tipo				CHAR(1),		-- Tipo de Usuario D=Destinatario, C=Con copia, O=Con copia oculta

	Par_Salida				CHAR(1),		-- Parametro de SALIDA S: SI N: No
	INOUT Par_NumErr		INT(11),		-- Parametro de SALIDA numero de error
	INOUT Par_ErrMen		VARCHAR(400),	-- Parametro de SALIDA Mensaje de error

	Par_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Fecha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- DECLARACIÓN DE CONSTANTES
	DECLARE Salida_SI 			CHAR(1);		# Constante Cadena Si
	DECLARE Entero_Cero			INT(11);		# Constante Entero Cero
	DECLARE Cadena_Vacia		VARCHAR(1);		# Constante Cadena Vacía
	DECLARE Var_Control			VARCHAR(50);	# Control en Pantalla

	-- ASIGNACIÓN DE CONSTANTES
	SET Salida_SI				:= 'S';			-- Constante Si
	SET Cadena_Vacia			:= '';			-- Cadena vacía
	SET Entero_Cero				:= 0;			-- Constante Cero

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr	:=	999;
			SET Par_ErrMen	:=	CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
								'esto le ocasiona. Ref: VALCAJASDESTINATARIOSALT');
		END;

		IF(IFNULL(Par_UsuarioID, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr := 01;
			SET Par_ErrMen := 'El Usuario ID está Vacío';
			SET Var_Control := 'usuarioID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Tipo, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr := 02;
			SET Par_ErrMen := 'El Tipo Usuario está Vacío';
			SET Var_Control := 'tipo';
			LEAVE ManejoErrores;
		END IF;

		INSERT INTO
			VALCAJASDESTINATARIOS(UsuarioID,		Tipo,			EmpresaID,		Usuario,		FechaActual,
								  DireccionIP,		ProgramaID,		Sucursal,		NumTransaccion)
						   VALUES(Par_UsuarioID,	Par_Tipo,		Par_EmpresaID,	Aud_Usuario,	Aud_FechaActual,
								  Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

		SET Par_NumErr		:= 000;
		SET Par_ErrMen		:= 'Destinatarios Guardados Exitosamente';
		SET Var_Control		:= 'destinatarioID';

	END ManejoErrores;

	IF(Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen  AS ErrMen,
				Var_Control AS control,
				Entero_Cero AS consecutivo;
	END IF;
END TerminaStore$$