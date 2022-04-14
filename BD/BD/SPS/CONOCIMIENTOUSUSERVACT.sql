-- SP CONOCIMIENTOUSUSERVACT

DELIMITER ;
DROP PROCEDURE IF EXISTS `CONOCIMIENTOUSUSERVACT`;

DELIMITER $$
CREATE PROCEDURE `CONOCIMIENTOUSUSERVACT`(
    -- Stored procedure para actualizar conocimientos del usuario de servicios.
    Par_UsuarioServicioID       BIGINT(11),         -- Identificador del usuario de servicios.
    Par_EvaluaXMatriz           CHAR(1),            -- Confirmación evalua o no la matriz de riesgo S=si, N=no.
    Par_ComentarioNivel         VARCHAR(200),       -- Comentario si el el OC cambió el nivel de riesgo.
	Par_NumAct                  TINYINT UNSIGNED,	-- Numero de Actualizacion

    Par_Salida				    CHAR(1),		    -- Parametro para salida de datos
	INOUT Par_NumErr		    INT(11),    		-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen		    VARCHAR(400),	    -- Parametro de entrada/salida de mensaje de control de respuesta

    Aud_EmpresaID               INT(11),            -- Parámetro de auditoría ID de la empresa.
    Aud_Usuario                 INT(11),            -- Parámetro de auditoría ID del usuario.
    Aud_FechaActual             DATETIME,           -- Parámetro de auditoría fecha actual.
    Aud_DireccionIP             VARCHAR(15),        -- Parámetro de auditoría direccion IP.
    Aud_ProgramaID              VARCHAR(50),        -- Parámetro de auditoría programa.
    Aud_Sucursal                INT(11),            -- Parámetro de auditoría ID de la sucursal.
    Aud_NumTransaccion          BIGINT(20)          -- Parámetro de auditoría numero de transaccion.
)
TerminaStore: BEGIN

    -- Declaración de variables.
    DECLARE Var_Control	    	VARCHAR(100);  	-- Variable de control.
	DECLARE Var_Consecutivo		INT(11);        -- Variable consecutivo.
    DECLARE Var_UsuarioID       BIGINT(11);     -- Variable para número de identificación del usuario de servicios.

    -- Declaración de constantes.
    DECLARE	Entero_Cero		    INT(11);        -- Constante número cero (0).
    DECLARE Cadena_Vacia        CHAR(1);        -- Constante cadena vacía ''.
    DECLARE Cons_Si             CHAR(1);        -- Constante si 'S'.
    DECLARE Cons_No             CHAR(1);        -- Constante no 'N'.
    DECLARE Act_EvaluaXMatriz   INT(11);        -- Actualizacion valor para evaluación de la matriz de riesgo.

    -- Asignación de constantes.
    SET Entero_Cero         := 0;
    SET Cadena_Vacia        := '';
    SET Cons_Si             := 'S';
    SET Cons_No             := 'N';
    SET Act_EvaluaXMatriz   := 1;

    ManejoErrores: BEGIN

        DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			GET DIAGNOSTICS condition 1
			@Var_SQLState = RETURNED_SQLSTATE, @Var_SQLMessage = MESSAGE_TEXT;
			SET Par_NumErr := 999;
			SET Par_ErrMen := LEFT(CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
				'esto le ocasiona. Ref: SP-CONOCIMIENTOUSUSERVACT','[',@Var_SQLState,'-' , @Var_SQLMessage,']'), 400);
			SET Var_Control := 'SQLEXCEPTION';
		END;

        IF (Par_NumAct = Act_EvaluaXMatriz) THEN

            IF (IFNULL(Par_UsuarioServicioID, Entero_Cero) = Entero_Cero) THEN
                SET Par_NumErr		:= 1;
			    SET Par_ErrMen		:= 'El identificador del usuario de servicios esta vacio.';
			    SET	Var_Control		:= Cadena_Vacia;
                LEAVE ManejoErrores;
            END IF;

            IF (Par_EvaluaXMatriz NOT IN (Cons_No, Cons_Si)) THEN
				SET Par_NumErr		:= 2;
			    SET Par_ErrMen		:= 'El valor para evaluacion de la matriz de riesgo no es valido.';
			    SET	Var_Control		:= Cadena_Vacia;
                LEAVE ManejoErrores;
			END IF;

            SET Var_UsuarioID := (SELECT UsuarioServicioID FROM CONOCIMIENTOUSUSERV WHERE UsuarioServicioID = Par_UsuarioServicioID);

            IF (IFNULL(Var_UsuarioID, Entero_Cero) = Entero_Cero) THEN
                SET Par_NumErr		:= 3;
			    SET Par_ErrMen		:= 'El usuario de servicios no existe.';
			    SET	Var_Control		:= Cadena_Vacia;
                LEAVE ManejoErrores;
            END IF;

            UPDATE CONOCIMIENTOUSUSERV
            SET EvaluaXMatriz   = Par_EvaluaXMatriz,
                ComentarioNivel	= Par_ComentarioNivel,

                EmpresaID       = Aud_EmpresaID,
				Usuario		    = Aud_Usuario,
				FechaActual	    = Aud_FechaActual,
				DireccionIP	    = Aud_DireccionIP,
				ProgramaID	    = Aud_ProgramaID,
				Sucursal	    = Aud_Sucursal,
				NumTransaccion  = Aud_NumTransaccion
            WHERE UsuarioServicioID = Par_UsuarioServicioID;

            SET Par_NumErr 		:= Entero_Cero;
            SET Par_ErrMen 		:= CONCAT("Conocimientos del usuario de servicios actualizado correctamente: ", Par_UsuarioServicioID);
			SET Var_Control  	:= 'usuarioID';
			SET Var_Consecutivo := Entero_Cero;
        END IF;

    END ManejoErrores;

    IF (Par_Salida = Cons_Si) THEN
		SELECT	Par_NumErr 		AS NumErr,
				Par_ErrMen 		AS ErrMen,
				Var_Control 	AS Control,
				Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$