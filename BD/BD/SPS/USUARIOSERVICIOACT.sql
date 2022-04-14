-- SP USUARIOSERVICIOACT

DELIMITER ;

DROP PROCEDURE IF EXISTS `USUARIOSERVICIOACT`;

DELIMITER $$

CREATE PROCEDURE `USUARIOSERVICIOACT`(
-- ==========================================================
-- ------- STORE PARA ACTUALIZAR USUARIO DE SERVICIO --------
-- ==========================================================
	Par_UsuarioServicioID	INT(11),				-- Numero de Usuario de Servicio
	Par_UsuarioUnificadoID  INT(11),                -- Parametro id del usuario de servicios al que se unificará.
	Par_NivelRiesgo			CHAR(1),				-- Nivel de riesgo a actualizar.
	Par_NumAct				TINYINT UNSIGNED,		-- Numero de Actualizacion

	Par_Salida				CHAR(1),				-- Parametro para salida de datos
	INOUT Par_NumErr		INT(11),				-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen		VARCHAR(400),			-- Parametro de entrada/salida de mensaje de control de respuesta

	Aud_EmpresaID       	INT(11),				-- Parametro de Auditoria ID de la Empresa
    Aud_Usuario         	INT(11),				-- Parametro de Auditoria ID del Usuario
    Aud_FechaActual     	DATETIME,				-- Parametro de Auditoria Fecha Actual
    Aud_DireccionIP     	VARCHAR(15),			-- Parametro de Auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),			-- Parametro de Auditoria Programa
    Aud_Sucursal        	INT(11),				-- Parametro de Auditoria ID de la Sucursal
    Aud_NumTransaccion  	BIGINT(20)  			-- Parametro de Auditoria Numero de la Transaccion
)
TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_Control	    		VARCHAR(100);  	-- Variable de control
	DECLARE Var_Consecutivo			BIGINT(20);     -- Variable consecutivo
	DECLARE Var_Estatus				CHAR(1);		-- Estatus del Usuario de Servicio
	DECLARE Var_UsuarioServicioID   INT(11);        -- Variable para el id del usuario
    DECLARE Var_UsuarioUnificadoID  INT(11);        -- Variable para el id del usuario al que se unificará

	DECLARE Var_NivelRiesgo			CHAR(1);		-- Varible para nivel de riesgo actual del usuario de servicios.

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia			CHAR(1);		-- Cadena Vacia
	DECLARE	Fecha_Vacia				DATE;			-- Fecha Vacia
	DECLARE	Entero_Cero				INT(11);		-- Entero Cero
	DECLARE Salida_SI				CHAR(1);		-- Salida: SI
	DECLARE Est_Inactivo			CHAR(1);		-- Estatus: INACTIVO

	DECLARE UnificarCoincid        	INT(11);        -- Actualización para unificar coincidencia encontrada. tabla COINCIDEREMESASUSUSERACT
	DECLARE	Act_InactivaUsu			INT(11);		-- Tipo de Actualizacion: Inactiva Usuario de Servicio
	DECLARE Act_Unificar            INT(11); 		-- Tipo de acrualizacion: Unificar usuario de servicios.
	DECLARE Act_NivelRiesgo			INT(11);		-- Actualizacion del nivel de riesgo del usuario de servicios.
    DECLARE Cons_No                 CHAR(1);        -- Constante no 'N'

	DECLARE Alta_UsuarioServ    	INT(11);        -- Número de Alta de historico de modificaciones de usuario de servicios.
	DECLARE Niv_Bajo				CHAR(1);		-- Nivel de riesgo bajo 'B'.
	DECLARE Niv_Medio				CHAR(1);		-- Nivel de riesgo media 'M'.
	DECLARE Niv_Alto				CHAR(1);		-- Nivel de riesgo alta 'A'.

	-- Asignacion de constantes
	SET	Cadena_Vacia			:= '';				-- Cadena Vacia
	SET	Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
	SET	Entero_Cero				:= 0;				-- Entero Cero
	SET Salida_SI				:= 'S';				-- Salida: SI
	SET Est_Inactivo			:='I';				-- Estatus: INACTIVO

	SET UnificarCoincid    		:= 1;
	SET	Act_InactivaUsu			:= 1;				-- Tipo de Actualizacion: Inactiva Usuario de Servicio
	SET Act_Unificar        	:= 2;
	SET Act_NivelRiesgo			:= 3;
    SET Cons_No             	:= 'N';

	SET Alta_UsuarioServ		:= 5;
	SET Niv_Bajo				:= 'B';
	SET Niv_Medio				:= 'M';
	SET Niv_Alto				:= 'A';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			GET DIAGNOSTICS condition 1
			@Var_SQLState = RETURNED_SQLSTATE, @Var_SQLMessage = MESSAGE_TEXT;
			SET Par_NumErr := 999;
			SET Par_ErrMen := LEFT(CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
				'esto le ocasiona. Ref: SP-USUARIOSERVICIOACT','[',@Var_SQLState,'-' , @Var_SQLMessage,']'), 400);
			SET Var_Control := 'SQLEXCEPTION';
		END;


		-- 1. Tipo de Actualizacion: Inactiva Usuario de Servicio
		IF(Par_NumAct = Act_InactivaUsu) THEN
			SELECT Estatus INTO Var_Estatus
			FROM USUARIOSERVICIO
			WHERE UsuarioServicioID = Par_UsuarioServicioID;

			SET Var_Estatus := IFNULL(Var_Estatus,Cadena_Vacia);

			IF(Var_Estatus = Est_Inactivo)THEN
				SET Par_NumErr 	:= 001;
				SET Par_ErrMen	:= 'El Usuario de Servicio ya se encuentra Inactivo.';
				SET Var_Control := 'usuarioID';
				LEAVE ManejoErrores;
			END IF;

			UPDATE USUARIOSERVICIO
			SET Estatus			= Est_Inactivo,

				EmpresaID		= Aud_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual 	= Aud_FechaActual,
				DireccionIP 	= Aud_DireccionIP,
				ProgramaID  	= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE UsuarioServicioID = Par_UsuarioServicioID;

			SET Par_NumErr		:= 000;
			SET Par_ErrMen		:= CONCAT('Usuario de Servicio Inactivado Exitosamente: ', CONVERT(Par_UsuarioServicioID, CHAR));
			SET Var_Control		:= 'usuarioID' ;
			SET Var_Consecutivo := Par_UsuarioServicioID;
		END IF;

		-- 2.- Actualizacion para unificar usuario de servicios.
		-- Pantalla: Ventanilla > Registro > Unificar Usuario Servicios.
		IF (Par_NumAct = Act_Unificar) THEN

            IF (IFNULL(Par_UsuarioServicioID, Entero_Cero) = Entero_Cero) THEN
                SET Par_NumErr		:= 1;
			    SET Par_ErrMen		:= 'El identificador del usuario de servicios esta vacio.';
			    SET	Var_Control		:= Cadena_Vacia;
                LEAVE ManejoErrores;
            END IF;

            IF (IFNULL(Par_UsuarioUnificadoID, Entero_Cero) = Entero_Cero) THEN
                SET Par_NumErr		:= 2;
			    SET Par_ErrMen		:= 'El identificador del usuario al que se unificara esta vacio.';
			    SET	Var_Control		:= Cadena_Vacia;
                LEAVE ManejoErrores;
            END IF;

            SET Var_UsuarioServicioID := (SELECT UsuarioServicioID FROM USUARIOSERVICIO WHERE UsuarioServicioID = Par_UsuarioServicioID LIMIT 1);
            SET Var_UsuarioServicioID := IFNULL(Var_UsuarioServicioID, Entero_Cero);

            IF (Var_UsuarioServicioID = Entero_Cero) THEN
                SET Par_NumErr		:= 3;
			    SET Par_ErrMen		:= 'El identificador del usuario de servicios no existe.';
			    SET	Var_Control		:= Cadena_Vacia;
                LEAVE ManejoErrores;
            END IF;

            SET Var_UsuarioUnificadoID := (SELECT UsuarioServicioID FROM USUARIOSERVICIO WHERE UsuarioServicioID = Par_UsuarioUnificadoID LIMIT 1);
            SET Var_UsuarioUnificadoID := IFNULL(Var_UsuarioUnificadoID, Entero_Cero);

            IF (Var_UsuarioServicioID = Entero_Cero) THEN
                SET Par_NumErr		:= 4;
			    SET Par_ErrMen		:= 'El identificador del usuario al que se unificara no existe.';
			    SET	Var_Control		:= Cadena_Vacia;
                LEAVE ManejoErrores;
            END IF;

            UPDATE USUARIOSERVICIO
            SET UsuarioUnificadoID = Par_UsuarioUnificadoID,
                EmpresaID          = Aud_EmpresaID,
                Usuario			   = Aud_Usuario,
			    FechaActual		   = Aud_FechaActual,
			    DireccionIP		   = Aud_DireccionIP,
			    ProgramaID		   = Aud_ProgramaID,
			    Sucursal		   = Aud_Sucursal,
			    NumTransaccion	   = Aud_NumTransaccion
            WHERE UsuarioServicioID = Par_UsuarioServicioID;

            -- Actualizar usuario como unificado en tabla de coincidencias encontradas.
            CALL COINCIDEREMESASUSUSERACT (
                Par_UsuarioServicioID,  UnificarCoincid,	Cons_No,            Par_NumErr,         Par_ErrMen,
                Aud_EmpresaID,          Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                Aud_Sucursal,           Aud_NumTransaccion
            );

            IF (Par_NumErr <> Entero_Cero) THEN
                LEAVE ManejoErrores;
            END IF;

            SET Par_NumErr 		:= Entero_Cero;
            SET Par_ErrMen 		:= CONCAT("Usuario de servicios unificado correctamente: ", Par_UsuarioUnificadoID);
			SET Var_Control  	:= 'usuarioID';
			SET Var_Consecutivo := Entero_Cero;

        END IF;

		-- 3. Actualización del nivel de riesgo de un usuario de servicios.
		IF (Par_NumAct = Act_NivelRiesgo) THEN

			IF (IFNULL(Par_UsuarioServicioID, Entero_Cero) = Entero_Cero) THEN
                SET Par_NumErr		:= 1;
			    SET Par_ErrMen		:= 'El identificador del usuario de servicios esta vacio.';
			    SET	Var_Control		:= Cadena_Vacia;
                LEAVE ManejoErrores;
            END IF;

			IF (Par_NivelRiesgo NOT IN (Niv_Bajo, Niv_Medio, Niv_Alto)) THEN
				SET Par_NumErr		:= 2;
			    SET Par_ErrMen		:= 'El nivel de riesgo no es valido.';
			    SET	Var_Control		:= Cadena_Vacia;
                LEAVE ManejoErrores;
			END IF;

			SELECT	UsuarioServicioID,		NivelRiesgo
			INTO	Var_UsuarioServicioID,	Var_NivelRiesgo
			FROM USUARIOSERVICIO
			WHERE UsuarioServicioID = Par_UsuarioServicioID;

            IF (IFNULL(Var_UsuarioServicioID, Entero_Cero) = Entero_Cero) THEN
                SET Par_NumErr		:= 3;
			    SET Par_ErrMen		:= 'El usuario de servicios no existe.';
			    SET	Var_Control		:= Cadena_Vacia;
                LEAVE ManejoErrores;
            END IF;

			IF (Var_NivelRiesgo <> Par_NivelRiesgo) THEN

				UPDATE USUARIOSERVICIO
            	SET NivelRiesgo			= Par_NivelRiesgo,
					EmpresaID          	= Aud_EmpresaID,
					Usuario			   	= Aud_Usuario,
					FechaActual		   	= Aud_FechaActual,
					DireccionIP		   	= Aud_DireccionIP,
					ProgramaID		   	= Aud_ProgramaID,
					Sucursal		   	= Aud_Sucursal,
					NumTransaccion	   	= Aud_NumTransaccion
            	WHERE UsuarioServicioID = Par_UsuarioServicioID;

				CALL BITACORAHISTPERSALT (
					Aud_NumTransaccion,	Alta_UsuarioServ,	Par_UsuarioServicioID,	Entero_Cero,	Entero_Cero,
					Entero_Cero,		Cons_No,			Par_NumErr,				Par_ErrMen,		Aud_EmpresaID,
					Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,
					Aud_NumTransaccion
				);

				IF (Par_NumErr <> Entero_Cero) THEN
					SET Par_NumErr		:= 4;
			    	SET Par_ErrMen		:= 'Error en el alta historico de modificacion de usuarios de servicios.';
			    	SET	Var_Control		:= Cadena_Vacia;
					LEAVE ManejoErrores;
				END IF;
			END IF;

			SET Par_NumErr 		:= Entero_Cero;
            SET Par_ErrMen 		:= CONCAT("Usuario de servicios actualizado correctamente: ", Par_UsuarioServicioID);
			SET Var_Control  	:= 'usuarioID';
			SET Var_Consecutivo := Entero_Cero;

		END IF;

	END ManejoErrores;

	-- Si Par_Salida = S (SI)
	IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr 		AS NumErr,
				Par_ErrMen 		AS ErrMen,
				Var_Control 	AS Control,
				Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$
