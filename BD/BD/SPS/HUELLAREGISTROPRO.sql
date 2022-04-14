-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HUELLAREGISTROPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `HUELLAREGISTROPRO`;
DELIMITER $$

CREATE PROCEDURE `HUELLAREGISTROPRO`(
-- Registro de Huellas de Cliente y Usuario
	Par_TipoPersona			CHAR(1),			-- Tipo de persona U - Usuario, C - Cliente
	Par_PersonaID			BIGINT(11),			-- Identificador de la persona
	Par_ManoSelec			CHAR(1), 			-- Mano seleccionada
	Par_DedoSelec			CHAR(1),	 		-- Dedo Seleccionado
	Par_Huella				VARBINARY(4000), 	-- Caputa de Huella
	Par_FmdHuella			VARBINARY(4000), 	-- Caputa de Huella Fmd

	Par_Salida          	CHAR(1),			-- Salida
	INOUT Par_NumErr    	INT, 				-- Salida
	INOUT Par_ErrMen    	VARCHAR(400), 		-- Salida

	Aud_EmpresaID			INT,				-- Auditoria
	Aud_Usuario				INT, 				-- Auditoria
	Aud_FechaActual			DATETIME, 			-- Auditoria
	Aud_DireccionIP			VARCHAR(15), 		-- Auditoria
	Aud_ProgramaID			VARCHAR(50), 		-- Auditoria
	Aud_Sucursal			INT, 				-- Auditoria
	Aud_NumTransaccion		BIGINT 				-- Auditoria
)
TerminaStore: BEGIN

	-- variables
	DECLARE	Var_HuellaUno		VARBINARY(4000);	-- Binario huella uno
	DECLARE	Var_FmdHuellaUno	VARBINARY(4000);	-- Binario huella uno
	DECLARE	Var_DedoHuellaUno	CHAR(1); 			-- dedo de la huella uno
	DECLARE	Var_HuellaDos		VARBINARY(4000); 	-- binario huella dos
	DECLARE	Var_FmdHuellaDos	VARBINARY(4000); 	-- binario huella dos
	DECLARE	Var_DedoHuellaDos	CHAR(1); 			-- dedo huella dos
	DECLARE	Var_Control			VARCHAR(90); 		-- variable de control

	-- constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT;
	DECLARE	Salida_SI			CHAR(1);
	DECLARE	Salida_NO			CHAR(1);
	DECLARE	Mano_Izquierda		CHAR(1);
	DECLARE	Mano_Derecha		CHAR(1);
	DECLARE TipoUsuario			CHAR(1);
	DECLARE TipoFirmante		CHAR(1);
	DECLARE Estatus_Registrado	CHAR(1);

	DECLARE Dedo_Indice			CHAR(1);
	DECLARE Dedo_Medio			CHAR(1);
	DECLARE Dedo_Anular			CHAR(1);
	DECLARE Dedo_Menique		CHAR(1);
	DECLARE Dedo_Pulgar			CHAR(1);

	SET	Cadena_Vacia	:= '';
	SET	Fecha_Vacia		:= '1900-01-01';
	SET Entero_Cero		:= 0;
	SET Salida_SI		:= 'S';
	SET Salida_NO		:= 'N';

	SET	Mano_Izquierda	:= 'I';
	SET	Mano_Derecha	:= 'D';
	SET	TipoUsuario		:= 'U';
	SET	TipoFirmante	:= 'F';
	SET Estatus_Registrado := 'V';

	SET Dedo_Indice		:= 'I';
	SET Dedo_Medio		:= 'M';
	SET Dedo_Anular		:= 'A';
	SET Dedo_Menique	:= 'N';
	SET Dedo_Pulgar		:= 'P';

	SET Aud_FechaActual := NOW();
	SET Aud_ProgramaID	:= 'HUELLAREGISTROPRO';

ManejoErrores: BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		SET Par_NumErr := 999;
		SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
								 'esto le ocasiona. Ref: SP-HUELLAREGISTROPRO');
		SET Var_Control := 'SQLEXCEPTION' ;
	END;

	IF(IFNULL(Aud_NumTransaccion, Entero_Cero) = Entero_Cero) THEN
		CALL TRANSACCIONESPRO(Aud_NumTransaccion);
	END IF;

	IF (IFNULL(Par_DedoSelec, Cadena_Vacia) = Cadena_Vacia) THEN
		SET Par_NumErr := 01;
        SET Par_ErrMen := 'No hay un dedo seleccionado.';
        SET Var_Control := Cadena_Vacia;
        LEAVE ManejoErrores;
	END IF;

	IF (Par_DedoSelec NOT IN (Dedo_Indice, Dedo_Medio, Dedo_Anular, Dedo_Menique, Dedo_Pulgar)) THEN
		SET Par_NumErr := 02;
        SET Par_ErrMen := 'El dedo seleccionado no es valido.';
        SET Var_Control := Cadena_Vacia;
        LEAVE ManejoErrores;
	END IF;

	IF(Par_ManoSelec = Mano_Izquierda) THEN
		SET	Var_DedoHuellaUno 	:= Par_DedoSelec;
		SET	Var_DedoHuellaDos 	:= Cadena_Vacia;

		SET	Var_HuellaUno		:= Par_Huella;
		SET	Var_HuellaDos		:= NULL;
		SET	Var_FmdHuellaUno	:= Par_FmdHuella;
		SET	Var_FmdHuellaDos	:= NULL;
	ELSE
		SET	Var_DedoHuellaUno	:= Cadena_Vacia;
		SET	Var_DedoHuellaDos	:= Par_DedoSelec;

		SET	Var_HuellaUno		:= NULL;
		SET	Var_HuellaDos		:= Par_Huella;
		SET	Var_FmdHuellaUno	:= NULL;
		SET	Var_FmdHuellaDos	:= Par_FmdHuella;

	END IF;

    IF Par_TipoPersona = TipoUsuario THEN
		UPDATE USUARIOS SET
				AccedeHuella = Salida_SI
		WHERE UsuarioID = Par_PersonaID;
	END IF;

	IF NOT EXISTS (SELECT TipoPersona
				FROM HUELLADIGITAL
				WHERE TipoPersona = Par_TipoPersona
				  AND PersonaID = Par_PersonaID)	THEN

		CALL `HUELLADIGITALALT`(
			Par_TipoPersona,	Par_PersonaID,		Var_HuellaUno,		Var_FmdHuellaUno,	Var_DedoHuellaUno,
			Var_HuellaDos,		Var_FmdHuellaDos,	Var_DedoHuellaDos,	Salida_NO,			Par_NumErr,
			Par_ErrMen,			Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
		);

		IF Par_NumErr <> Entero_Cero THEN
			LEAVE ManejoErrores;
        END IF;

	ELSE

		IF(Par_ManoSelec = Mano_Izquierda) THEN

			UPDATE `HUELLADIGITAL` SET
				HuellaUno		= Var_HuellaUno,
				FmdHuellaUno	= Var_FmdHuellaUno,
				DedoHuellaUno	= Var_DedoHuellaUno,
				PIDTarea		= Cadena_Vacia,
				Estatus 		= Estatus_Registrado,

				EmpresaID		= Aud_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual		= NOW(),
				DireccionIP		= Aud_DireccionIP,
				ProgramaID		= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion

			WHERE TipoPersona = Par_TipoPersona
			  AND PersonaID = Par_PersonaID;

		ELSE
			UPDATE `HUELLADIGITAL` SET
				HuellaDos		= Var_HuellaDos,
				FmdHuellaDos	= Var_FmdHuellaDos,
				DedoHuellaDos	= Var_DedoHuellaDos,
				PIDTarea		= Cadena_Vacia,
				Estatus 		= Estatus_Registrado,

				EmpresaID		= Aud_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual		= NOW(),
				DireccionIP		= Aud_DireccionIP,
				ProgramaID		= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion

			WHERE TipoPersona = Par_TipoPersona
			  AND PersonaID = Par_PersonaID;

		END IF;

		SET Par_NumErr  := 0;
		SET Par_ErrMen  := "Huella Registrada Correctamente en SAFI.";
        SET Var_Control  := 'huellaDigital';

	END IF;

END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Entero_Cero AS consecutivo;
	END IF;
END TerminaStore$$