-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- VERIFICAPREGUNTASSEGPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `VERIFICAPREGUNTASSEGPRO`;DELIMITER $$

CREATE PROCEDURE `VERIFICAPREGUNTASSEGPRO`(
	-- Valida Preguntas de Seguridad
	Par_ClienteID         	INT(11),			-- Numero de Cliente
    Par_Telefono            VARCHAR(20),		-- Numero de Telefono
    Par_TipoSoporteID		INT(11),			-- Tipo de Soporte
    Par_PreguntaID			INT(11),			-- Numero de Pregunta
    Par_Respuestas 			VARCHAR(100),		-- Respuestas

    Par_Comentarios 		VARCHAR(200),		-- Comentarios
	Par_UsuarioID			INT(11),			-- Numero de Usuario

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
    DECLARE Var_FinalAprobado		VARCHAR(100); -- Almacena resultado final 'si'
	DECLARE Var_Control 			VARCHAR(100);
	DECLARE Var_VerificaPreguntaID	INT(11);
    DECLARE Var_FechaVerifica		DATETIME;
    DECLARE Var_VechaSistema		DATE;
    DECLARE Var_Resultado			VARCHAR(20);

    DECLARE Var_Respuestas			VARCHAR(100);
    DECLARE Var_RespuestasParam		INT(11);
    DECLARE Var_ResCorrectas		INT(11);
    DECLARE Var_Mensaje				VARCHAR(100);
    DECLARE Var_NumPreguntas		INT(11);

    DECLARE Var_PreguntasParam		INT(11);
    DECLARE Var_PregunParamCor		INT(11);
	DECLARE Var_PreParametrizadas	INT(11);
    DECLARE Var_ResParametrizadas	INT(11);

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATETIME;
	DECLARE	Entero_Cero		INT(11);
	DECLARE	Salida_SI		CHAR(1);
	DECLARE	Salida_NO		CHAR(1);

    DECLARE Mayusculas		CHAR(2);
    DECLARE ResAprobado		VARCHAR(45);
	DECLARE ResRechazado	VARCHAR(45);
    DECLARE Con_FinAprobado	CHAR(2);		-- constante 'si'

	-- Asignacion de constantes
	SET Cadena_Vacia 	:= '';				-- Cadena vacia
	SET Fecha_Vacia 	:= '1900-01-01';	-- Fecha vacia
	SET Entero_Cero 	:= 0;				-- Entero cero
	SET Salida_SI 		:= 'S';				-- Constante: SI
	SET Salida_NO 		:= 'N';				-- Constante: NO

    SET Mayusculas		:= 'MA';	   		-- Obtener el resultado en Mayusculas
    SET ResAprobado		:= 'APROBADO';		-- Resultado: Aprobado
    SET ResRechazado	:= 'RECHAZADO';		-- Resultado: Rechazado
    SET Con_FinAprobado	:=	'si';


  -- crea la tabla temporal si no existe
	CREATE TEMPORARY TABLE IF NOT EXISTS TMPVERIFICAPREGUNTASSEG(
		VerificaPreguntaID	INT(11) NOT NULL,
		ClienteID 			INT(11) DEFAULT NULL,
		PreguntaID 			INT(11) DEFAULT NULL,
		ResultadoPregunta 	VARCHAR(45) DEFAULT NULL,
		ResultadoVerifica 	VARCHAR(45) DEFAULT NULL,
		ResultadoFinal 		VARCHAR(45) DEFAULT NULL,
		NumTransaccion 		BIGINT(20) DEFAULT NULL
	);
     ManejoErrores: BEGIN

	 DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
				 'esto le ocasiona. Ref: SP-VERIFICAPREGUNTASSEGPRO');

		END;
		-- Se obtiene la fecha del sistema
		SET Var_VechaSistema 	:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
		SET Var_FechaVerifica 	:= CONVERT(CONCAT(Var_VechaSistema,":",CURRENT_TIME),DATETIME);

		SET Par_Telefono		:= IFNULL(FNLIMPIACARACTERESGEN(TRIM(REPLACE(Par_Telefono, " ",Cadena_Vacia)),Mayusculas),Cadena_Vacia);

        SET Par_Respuestas		:= IFNULL(Par_Respuestas,Cadena_Vacia);
        SET Par_Comentarios		:= IFNULL(Par_Comentarios,Cadena_Vacia);
        SET Var_Resultado		:= IFNULL(Var_Resultado,Cadena_Vacia);

        IF(IFNULL(Par_ClienteID,Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr := 001;
			SET Par_ErrMen := 'El Cliente esta Vacio.';
			SET Var_Control:= 'clienteID' ;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Telefono,Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr 	:= 002;
			SET Par_ErrMen 	:= 'El Telefono esta Vacio.';
			SET Var_Control	:= 'numeroTelefono';
			LEAVE ManejoErrores;
		END IF;

        IF(IFNULL(Par_TipoSoporteID,Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr 	:= 003;
			SET Par_ErrMen 	:= 'El Tipo de Soporte esta Vacio.';
			SET Var_Control	:= 'tipoSoporteID';
			LEAVE ManejoErrores;
		END IF;

        IF(IFNULL(Par_PreguntaID,Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr 	:= 004;
			SET Par_ErrMen 	:= 'El Numero de Pregunta esta Vacio.';
			SET Var_Control	:= 'preguntaID';
			LEAVE ManejoErrores;
		END IF;

        IF(IFNULL(Par_Respuestas,Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr 	:= 005;
			SET Par_ErrMen 	:= 'La Respuesta esta Vacia.';
			SET Var_Control	:= 'respuestas';
			LEAVE ManejoErrores;
		END IF;

        IF NOT EXISTS (SELECT ClienteID FROM CLIENTES
							WHERE ClienteID = Par_ClienteID) THEN
			SET Par_NumErr 	:= 006;
			SET Par_ErrMen 	:= 'El Cliente no Existe';
			SET Var_Control	:= 'clienteID';
			LEAVE ManejoErrores;
		END IF;

        IF NOT EXISTS (SELECT PreguntaID FROM CATPREGUNTASSEG
						WHERE PreguntaID = Par_PreguntaID) THEN
			SET Par_NumErr 	:= 007;
			SET Par_ErrMen 	:= 'La Pregunta de Seguridad no Existe';
			SET Var_Control	:= 'clienteID';
			LEAVE ManejoErrores;
		END IF;

        IF NOT EXISTS (SELECT TipoSoporteID FROM CATTIPOSOPORTE
						WHERE TipoSoporteID  = Par_TipoSoporteID) THEN
			SET Par_NumErr 	:= 008;
			SET Par_ErrMen 	:= 'El Tipo de Soporte no Existe';
			SET Var_Control	:= 'tipoSoporteID';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_Respuestas != Cadena_Vacia)THEN
			SELECT 	Respuestas, 	NumeroPreguntas,		NumeroRespuestas
            INTO 	Var_Respuestas,	Var_PreguntasParam,		Var_RespuestasParam
			FROM PREGUNTASSEGURIDAD
			WHERE ClienteID = Par_ClienteID
			AND PreguntaID = Par_PreguntaID;

			IF(Par_Respuestas != Var_Respuestas)THEN
				SET Var_Resultado := ResRechazado;
			ELSE
				SET Var_Resultado := ResAprobado;
			END IF;

		END IF;

		SET Var_PreParametrizadas := (SELECT NumeroPreguntas FROM PARAMETROSPDM LIMIT 1);
        SET Var_ResParametrizadas := (SELECT NumeroRespuestas FROM PARAMETROSPDM LIMIT 1);

        SET Var_PreguntasParam 	:= IFNULL(Var_PreguntasParam,Var_PreParametrizadas);
        SET Var_RespuestasParam := IFNULL(Var_RespuestasParam,Var_ResParametrizadas);

		SET Var_PregunParamCor := Var_PreguntasParam;

		SET Var_PreguntasParam := Var_PreguntasParam -1;

		SET	Aud_FechaActual		:= NOW();

		SET Var_VerificaPreguntaID := (SELECT IFNULL(MAX(VerificaPreguntaID),Entero_Cero)+1 FROM TMPVERIFICAPREGUNTASSEG);

		-- INSERT a la tabla temporal
		INSERT INTO TMPVERIFICAPREGUNTASSEG(
			VerificaPreguntaID,		ClienteID,			PreguntaID,			ResultadoPregunta,		ResultadoVerifica,
			ResultadoFinal,			NumTransaccion)

		VALUES (
			Var_VerificaPreguntaID,	Par_ClienteID,		Par_PreguntaID, 	Var_Resultado, 			Cadena_Vacia,
            Cadena_Vacia,			Aud_NumTransaccion);

		SELECT COUNT(PreguntaID) INTO Var_ResCorrectas
		FROM TMPVERIFICAPREGUNTASSEG
		WHERE ResultadoPregunta = ResAprobado
		AND NumTransaccion = Aud_NumTransaccion
		AND ClienteID = Par_ClienteID;

		IF(Var_ResCorrectas >= Var_RespuestasParam)THEN
			UPDATE TMPVERIFICAPREGUNTASSEG SET
				ResultadoVerifica = CONCAT(Var_ResCorrectas,'/',Var_RespuestasParam),
				ResultadoFinal = ResAprobado
                WHERE NumTransaccion = Aud_NumTransaccion
				AND ClienteID = Par_ClienteID;

			SET Var_Mensaje 	:= CONCAT('Respuestas Correctas ',Var_ResCorrectas,'/',Var_PregunParamCor, ' Aprobado.');
			SET Var_FinalAprobado:=Con_FinAprobado;
		ELSEIF(Var_ResCorrectas < Var_RespuestasParam)THEN
			UPDATE TMPVERIFICAPREGUNTASSEG SET
				ResultadoVerifica = CONCAT(Var_ResCorrectas,'/',Var_RespuestasParam),
				ResultadoFinal = ResRechazado
                WHERE NumTransaccion = Aud_NumTransaccion
				AND ClienteID = Par_ClienteID;

			SET Var_Mensaje 	:= CONCAT('Respuestas Correctas ',Var_ResCorrectas,'/',Var_PregunParamCor, ' No Aprobado.');
		END IF;

		SET Par_NumErr 	:= Entero_Cero;
		SET Par_ErrMen 	:= Var_Mensaje;
		SET Var_Control	:= 'clienteID';

    END ManejoErrores;

    IF(Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Aud_NumTransaccion AS control,
				Entero_Cero AS consecutivo,
                Var_FinalAprobado;
	END IF;
END TerminaStore$$