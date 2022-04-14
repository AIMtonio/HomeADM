-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PREGUNTASSEGURIDADALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PREGUNTASSEGURIDADALT`;DELIMITER $$

CREATE PROCEDURE `PREGUNTASSEGURIDADALT`(
	-- Registro Preguntas de Seguridad
	Par_ClienteID			INT(11),			-- Numero de Cliente
	Par_CuentaAhoID		 	BIGINT(12),			-- Numero de Cuenta del Cliente
	Par_PreguntaID 			INT(11),			-- Numero de Pregunta
	Par_Respuestas 			VARCHAR(100),		-- Respuestas

	Par_Salida 				CHAR(1),			-- Indica si espera un SELECT de Salida
	INOUT Par_NumErr 		INT(11),			-- Numero de Error
	INOUT Par_ErrMen 		VARCHAR(400),		-- Mensaje de Error

	Par_EmpresaID 			INT(11),			-- Parametro de Auditoria
	Aud_Usuario 			INT(11),			-- Parametro de Auditoria
	Aud_FechaActual 		DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP 		VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID 			VARCHAR(50), 		-- Parametro de Auditoria
	Aud_Sucursal 			INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion 		BIGINT(20)			-- Parametro de Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_Control 			VARCHAR(100);
	DECLARE Var_PreguntaID			INT(11);
	DECLARE Var_PreguntaSegID		INT(11);
	DECLARE Var_NumPreguntas		INT(11);
    DECLARE Var_NumRespuestas		INT(11);

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATETIME;
	DECLARE	Entero_Cero		INT(11);
	DECLARE	Salida_SI		CHAR(1);
	DECLARE	Salida_NO		CHAR(1);

	-- Asignacion de constantes
	SET Cadena_Vacia 	:= '';				-- Cadena vacia
	SET Fecha_Vacia 	:= '1900-01-01';	-- Fecha vacia
	SET Entero_Cero 	:= 0;				-- Entero cero
	SET Salida_SI 		:= 'S';				-- Constante: SI
	SET Salida_NO 		:= 'N';				-- Constante: NO


	 ManejoErrores: BEGIN

	 DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
				 'esto le ocasiona. Ref: SP-PREGUNTASSEGURIDADALT');

		END;

		IF(IFNULL(Par_ClienteID,Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr 	:= 001;
			SET Par_ErrMen 	:= 'El Cliente esta Vacio.';
			SET Var_Control	:= 'clienteID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_CuentaAhoID,Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr 	:= 002;
			SET Par_ErrMen 	:= 'El Numero de Cuenta esta Vacio.';
			SET Var_Control	:= 'cuentaAhoID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_PreguntaID,Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr 	:= 003;
			SET Par_ErrMen 	:= 'El Numero de Pregunta esta Vacio.';
			SET Var_Control	:= 'preguntaID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Respuestas,Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr 	:= 004;
			SET Par_ErrMen 	:= 'La Respuesta esta Vacia.';
			SET Var_Control	:= 'respuestas';
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS (SELECT ClienteID FROM CLIENTES
							WHERE ClienteID = Par_ClienteID) THEN
			SET Par_NumErr 	:= 005;
			SET Par_ErrMen 	:= 'El Cliente no Existe.';
			SET Var_Control	:= 'clienteID';
			LEAVE ManejoErrores;
		END IF;

		IF NOT EXISTS (SELECT CuentaAhoID FROM CUENTASAHO
						WHERE CuentaAhoID = Par_CuentaAhoID) THEN
			SET Par_NumErr 	:= 005;
			SET Par_ErrMen 	:= 'La Cuenta no Existe.';
			SET Var_Control	:= 'cuentaAhoID';
			LEAVE ManejoErrores;
		END IF;

		SET	Aud_FechaActual		:= NOW();

		SET Var_PreguntaSegID 	:= (SELECT IFNULL(MAX(PreguntaSegID),Entero_Cero)+1 FROM PREGUNTASSEGURIDAD);

        -- Se obtiene el numero de Preguntas y Respuesta parametrizadas
        SET Var_NumPreguntas    := (SELECT NumeroPreguntas FROM PARAMETROSPDM LIMIT 1);
        SET Var_NumRespuestas	:= (SELECT NumeroRespuestas FROM PARAMETROSPDM LIMIT 1);

		INSERT INTO PREGUNTASSEGURIDAD (
			PreguntaSegID,			ClienteID,			CuentaAhoID,		PreguntaID,			Respuestas,
            NumeroPreguntas,		NumeroRespuestas,	EmpresaID, 			Usuario, 			FechaActual,
            DireccionIP, 			ProgramaID, 		Sucursal,			NumTransaccion)
		VALUES (
			Var_PreguntaSegID,		Par_ClienteID,		Par_CuentaAhoID,	Par_PreguntaID, 	Par_Respuestas,
            Var_NumPreguntas,		Var_NumRespuestas,	Par_EmpresaID, 		Aud_Usuario, 		Aud_FechaActual,
            Aud_DireccionIP, 		Aud_ProgramaID,     Aud_Sucursal, 		Aud_NumTransaccion);

			SET Par_NumErr 	:= Entero_Cero;
			SET Par_ErrMen 	:= 'Preguntas de Seguridad Agregadas Exitosamente.';
			SET Var_Control	:= 'guardar';


	END ManejoErrores;

	IF(Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Entero_Cero AS consecutivo;
	END IF;


END TerminaStore$$