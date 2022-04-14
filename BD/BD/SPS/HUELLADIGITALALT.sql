-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HUELLADIGITALALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `HUELLADIGITALALT`;
DELIMITER $$

CREATE PROCEDURE `HUELLADIGITALALT`(
	-- SP PARA EL ALTA DE HUELLA DIGITAL
	Par_TipoPersona			CHAR(1),				-- Parámetro tipo de persona U: usuario,  C: Cliente, F: Firmante.
	Par_PersonaID			BIGINT(11),				-- Parámetro identificador de la persona UsuarioID, ClienteID.
	Par_HuellaUno			VARBINARY(4000),		-- Parámetro primera huella capturada.
	Par_FmdHuellaUno		VARBINARY(4000),		-- Parámetro FMD de primera huella capturada.

	Par_DedoHuellaUno		CHAR(1),				-- Parámetro identificador del dedo de la primer huella.
	Par_HuellaDos			VARBINARY(4000),		-- Parámetro segunda huella capturada.
	Par_FmdHuellaDos		VARBINARY(4000),		-- Parámetro FMD de segunda huella capturada.
	Par_DedoHuellaDos		CHAR(1),				-- Parámetro identificador del dedo de la segunda huella.

	Par_Salida          	CHAR(1),				-- Parámetro de salida S=si, N=no.
    INOUT Par_NumErr    	INT(11),				-- Parámetro de salida número de error.
    INOUT Par_ErrMen    	VARCHAR(400),			-- Parámetro de salida mensaje de error.

    Aud_EmpresaID         	INT(11),				-- Parámetro de auditoría ID de la empresa.
	Aud_Usuario         	INT(11),				-- Parámetro de auditoría ID del usuario.
	Aud_FechaActual     	DATETIME,				-- Parámetro de auditoría fecha actual.
	Aud_DireccionIP     	VARCHAR(15),			-- Parámetro de auditoría direccion IP.
	Aud_ProgramaID      	VARCHAR(50),			-- Parámetro de auditoría programa.
	Aud_Sucursal        	INT(11),				-- Parámetro de auditoría ID de la sucursal.
	Aud_NumTransaccion  	BIGINT(20)				-- Parámetro de auditoría numero de transaccion.
)
TerminaStore: BEGIN
	-- Declaración de variables.
	DECLARE Var_Control         VARCHAR(50);		-- Variable para control de errores.
	DECLARE Var_RegHuellas		INT(11);			-- Variable para almacenar cantidad de registros en HUELLADIGITAL

	-- Declaración de constantes.
	DECLARE	Cadena_Vacia		CHAR(1);			-- Constante cadena vacia ''.
	DECLARE	Entero_Cero			INT(11);			-- Constante numero cero (0).
	DECLARE Tipo_Cliente		CHAR(1);			-- Constante persona tipo cliente 'C'.
	DECLARE Tipo_Usuario		CHAR(1);			-- Constante persona tipo usuario 'U'.
	DECLARE Tipo_Firmante		CHAR(1);			-- Constante persona tipo firmante 'F'.

	DECLARE Salida_SI			CHAR(1);			-- Constante afirmativa para salida 'S'.
	DECLARE Est_Registrado		CHAR(1);			-- Constante estatus registrado.
	DECLARE Var_TipoUsuarioServicio CHAR(1);  -- Tipo de usuario de servicio para la funcionalidad 15 de la carta SFP_CC_0090_Deteccion_PLD_en_Remesas

	-- Asignación de constantes.
	SET	Cadena_Vacia		:= '';
	SET	Entero_Cero			:= 0;
	SET Tipo_Cliente		:= 'C';
	SET Tipo_Usuario		:= 'U';
	SET Tipo_Firmante		:= 'F';

	SET Salida_SI			:="S";
	SET Est_Registrado		:= 'V';
	SET Var_TipoUsuarioServicio := 'S';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr   := 999;
			SET Par_ErrMen   := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
				'esto le ocasiona. Ref: SP-HUELLADIGITALALT');
			SET Var_Control  := 'SQLEXCEPTION';
		END;

		IF (IFNULL(Par_TipoPersona, Cadena_Vacia) = Cadena_Vacia) THEN
			SET Par_NumErr  := '001';
			SET Par_ErrMen  := 'Especificar Tipo de Persona.';
			SET Var_Control  := 'primerNombre' ;
			LEAVE ManejoErrores;
		END IF;

		SELECT COUNT(*) INTO Var_RegHuellas
		FROM HUELLADIGITAL
		WHERE TipoPersona = Par_TipoPersona AND PersonaID = Par_PersonaID;

		IF (IFNULL(Var_RegHuellas, Entero_Cero) > Entero_Cero) THEN

			SET Par_NumErr := '002';

			IF (Par_TipoPersona = Tipo_Cliente) THEN
				SET Par_ErrMen  := 'El safilocale.cliente ya Tiene tiene una Huella Digital Registrada.';
				SET Var_Control  := 'clienteID' ;
			END IF;

			IF (Par_TipoPersona = Tipo_Usuario) THEN
				SET Par_ErrMen  := 'El Usuario ya Tiene tiene una Huella Digital Registrada.';
				SET Var_Control  := 'usuarioID' ;
			END IF;

			IF (Par_TipoPersona = Tipo_Firmante) THEN
				SET Par_ErrMen  := 'La Persona Indicada ya Tiene tiene una Huella Digital Registrada';
				SET Var_Control  := 'personaID' ;
			END IF;

			LEAVE ManejoErrores;
		END IF;

		IF (IFNULL(Par_DedoHuellaUno, Cadena_Vacia) = Cadena_Vacia AND
			IFNULL(Par_DedoHuellaDos, Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr  := '003';
			SET Par_ErrMen  := 'Favor de Especificar el Dedo a Digitalizar';
			SET Var_Control  := 'dedoID' ;
			LEAVE ManejoErrores;
		END IF;

		-- Validacion para la funcionalidad 15 de la carta SFP_CC_0090_Deteccion_PLD_en_Remesas
		IF(Par_TipoPersona=Var_TipoUsuarioServicio) THEN
			IF EXISTS (SELECT * FROM HUELLADIGITAL
							WHERE TipoPersona=Par_TipoPersona
							AND PersonaID=Par_PersonaID) THEN
			SET Par_NumErr  := '004';
			SET Par_ErrMen  := 'El Usuario de Servicio ya Tiene tiene una Huella Digital Registrada';
			SET Var_Control := 'personaID' ;
			LEAVE ManejoErrores;
			END IF;
		END IF;

		INSERT INTO HUELLADIGITAL (
			TipoPersona,		PersonaID,			HuellaUno,		DedoHuellaUno,		HuellaDos,
			DedoHuellaDos,		Estatus,			PIDTarea,		EmpresaID,			Usuario,
			FechaActual,		DireccionIP,		ProgramaID,		Sucursal,			NumTransaccion,
			FmdHuellaUno,		FmdHuellaDos)
		VALUES (
			Par_TipoPersona,	Par_PersonaID,		Par_HuellaUno,	Par_DedoHuellaUno,	Par_HuellaDos,
			Par_DedoHuellaDos,	Est_Registrado, 	Cadena_Vacia,	Aud_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID, Aud_Sucursal,		Aud_NumTransaccion,
			Par_FmdHuellaUno,	Par_FmdHuellaDos
		);

		SET Par_NumErr  := 0;
		SET Par_ErrMen  := "Huella Registrada Correctamente en SAFI.";
		SET Var_Control := 'huellaDigital' ;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				'huellaDigital' AS control,
				Entero_Cero AS consecutivo;
	END IF;

END TerminaStore$$