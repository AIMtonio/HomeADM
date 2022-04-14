
-- PLDPERFILTRANSACCIONALALT --

DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDPERFILTRANSACCIONALALT`;

-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE `PLDPERFILTRANSACCIONALALT`(
	-- SP para dar de Alta el Perfil Transaccional.
	Par_ClienteID					INT(11),				-- Numero de Cliente
	Par_UsuarioServicioID			INT(11),				-- Número de usuario de servicios.
	Par_DepositosMax				DECIMAL(16,2),			-- Monto Maximo de Deposito por transacción
	Par_RetirosMax					DECIMAL(16,2),			-- Monto Maximo de Retiros por Transacción
	Par_NumDepositos				INT(11),				-- Numero Máximo de depositos

	Par_NumRetiros					INT(11),				-- Numero Máximo de Retiros
	Par_CatOrigenRecID				INT(11),				-- ID Del Origen de los Recursos CATPLDORIGENREC
	Par_CatDestinoRecID				INT(11),				-- ID del Destino de los recursos CATPLDDESTINOREC
	Par_ComentarioOrigenRec			VARCHAR(600),			-- Comentario Sobre el Origen de los Recursos
	Par_ComentarioDestRec			VARCHAR(600),			-- Comentario Sobre el Destino de los Recursos

    Par_Salida				    	CHAR(1),		    	-- Parametro de confirmación para salida de datos S=si, N=no.
	INOUT Par_NumErr		    	INT(11),            	-- Parametro de entrada/salida de numero de error.
	INOUT Par_ErrMen		    	VARCHAR(400),	    	-- Parametro de entrada/salida de mensaje de control de respuesta.

    Aud_EmpresaID               	INT(11),            	-- Parámetro de auditoría ID de la empresa.
    Aud_Usuario                 	INT(11),            	-- Parámetro de auditoría ID del usuario.
    Aud_FechaActual             	DATETIME,           	-- Parámetro de auditoría fecha actual.
    Aud_DireccionIP             	VARCHAR(15),        	-- Parámetro de auditoría direccion IP.
    Aud_ProgramaID              	VARCHAR(50),        	-- Parámetro de auditoría programa.
    Aud_Sucursal                	INT(11),            	-- Parámetro de auditoría ID de la sucursal.
    Aud_NumTransaccion          	BIGINT(20)          	-- Parámetro de auditoría numero de transaccion.
)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_Control				VARCHAR(50);				-- ID del Control en pantalla
	DECLARE Var_Consecutivo 		VARCHAR(200);				-- Numero consecutivo para la imagen a digitalizar
	DECLARE Var_FechaRegistro 		DATE;						-- Fecha en la que se digitalizo el Archivo
	DECLARE Var_ClienteID			INT(11);					-- ID del Cliente
	DECLARE Var_CliProcEspecifico	INT(11);					-- Almacena el numero del cliente parametrizado

	DECLARE Var_UsuarioID			INT(11);					-- Varible para el ID del usuario de servicios.

	-- Declaracion de constantes
	DECLARE Estatus_Activo			CHAR(1);
	DECLARE Entero_Cero				INT(11);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Cons_NO					CHAR(1);
	DECLARE SalidaSi				CHAR(1);

	DECLARE Pro_Manual				CHAR(1);					-- Constante tipo de proceso manual 'M'.
	DECLARE Cons_LlaveCliProEsp		VARCHAR(20);				-- Constante llave para filtrar el cliente parametrizado.
	DECLARE Cli_Rocktech			INT(11);					-- Número de cliente que le corresponde a Rocktech.
	DECLARE Cli_SofiExpress			INT(11);					-- Número de cliente que le corresponde a SOFI EXPRESS.


	-- Asignacion de constantes
	SET Estatus_Activo			:= 'A';							-- Estatus Activo
	SET Entero_Cero				:= 0;							-- Entero Cero
	SET Cadena_Vacia			:= '';							-- Cadena Vacia
	SET Cons_NO					:= 'N';							-- Constante No
	SET SalidaSi				:= 'S';							-- Salida Si

	SET Pro_Manual				:= 'M';
	SET Cons_LlaveCliProEsp		:= 'CliProcEspecifico';
	SET Cli_Rocktech			:= 44;
	SET Cli_SofiExpress			:= 15;


	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr		:= 999;
			SET Par_ErrMen		:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDPERFILTRANSACCIONALALT');
			SET Var_Control		:= 'sqlException' ;
		END;

		-- Redeclaración de parámetros en caso de venir con valor null.
		SET Par_ClienteID := IFNULL(Par_ClienteID, Entero_Cero);
		SET Par_UsuarioServicioID := IFNULL(Par_UsuarioServicioID, Entero_Cero);

		SET Var_CliProcEspecifico := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = Cons_LlaveCliProEsp);
		SET Var_CliProcEspecifico := IFNULL(Var_CliProcEspecifico, Entero_Cero);

		IF (Var_CliProcEspecifico = Cli_SofiExpress) THEN

			IF (Par_ClienteID = Entero_Cero AND Par_UsuarioServicioID = Entero_Cero) THEN
				SET Par_NumErr		:= 001;
				SET Par_ErrMen		:= 'No se envio un numero de cliente o numero de usuario de servicios.';
				SET Var_Control		:= 'clienteID';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			IF (Par_ClienteID > Entero_Cero AND Par_UsuarioServicioID > Entero_Cero) THEN
				SET Par_NumErr		:= 002;
				SET Par_ErrMen		:= '¡ERROR! Se envio tanto el numero del cliente como el numero del usuario de servicios.';
				SET Var_Control		:= 'clienteID';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;
		ELSE
			IF (Par_ClienteID = Entero_Cero) THEN
				SET Par_NumErr		:= 003;
				SET Par_ErrMen		:= 'El Numero de Cliente esta Vacio.';
				SET Var_Control		:= 'clienteID';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			SET Par_UsuarioServicioID := Entero_Cero;
		END IF;

		-- para el cliente rocktech no es necesario validar los campos
		IF(Var_CliProcEspecifico <> Cli_Rocktech) THEN

			IF(IFNULL(Par_DepositosMax, Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr			:= 004;
				SET Par_ErrMen			:= 'El Monto Maximo de Depositos esta Vacio.';
				SET Var_Control			:= 'depositosMax';
				SET Var_Consecutivo 	:= Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_RetirosMax, Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr			:= 005;
				SET Par_ErrMen			:= 'El Monto Maximo de Retiros esta Vacio..';
				SET Var_Control			:= 'retirosMax';
				SET Var_Consecutivo 	:= Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_NumDepositos, Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr			:= 006;
				SET Par_ErrMen			:= 'El Numero Maximo de Depositos esta Vacio.';
				SET Var_Control			:= 'numDepositos';
				SET Var_Consecutivo 	:= Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			IF(IFNULL(Par_NumRetiros, Entero_Cero) = Entero_Cero) THEN
				SET Par_NumErr			:= 007;
				SET Par_ErrMen			:= 'El Numero Maximo de Retiros esta Vacio.';
				SET Var_Control			:= 'numRetiros';
				SET Var_Consecutivo 	:= Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

		END IF;

		IF(IFNULL(Par_CatOrigenRecID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr			:= 008;
			SET Par_ErrMen			:= 'El Origen de los Recursos esta Vacio.';
			SET Var_Control			:= 'origenRecursos';
			SET Var_Consecutivo 	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_CatDestinoRecID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr			:= 009;
			SET Par_ErrMen			:= 'El Destino de los Recursos esta Vacio.';
			SET Var_Control			:= 'destinoRecursos';
			SET Var_Consecutivo 	:= Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF (Var_CliProcEspecifico = Cli_SofiExpress AND Par_UsuarioServicioID > Entero_Cero) THEN
			SET Var_UsuarioID := (SELECT UsuarioServicioID FROM PLDPERFILTRANS WHERE UsuarioServicioID = Par_UsuarioServicioID LIMIT 1);

			IF(IFNULL(Var_UsuarioID, Entero_Cero) > Entero_Cero) THEN
				SET Par_NumErr			:= 010;
				SET Par_ErrMen			:= 'El usuario de servicios ya cuenta con un perfil transaccional.';
				SET Var_Control			:= 'usuarioID';
				SET Var_Consecutivo 	:= Entero_Cero;
				LEAVE ManejoErrores;
			END IF;
		ELSE
			SET Var_ClienteID := (SELECT ClienteID FROM PLDPERFILTRANS WHERE ClienteID = Par_ClienteID LIMIT 1);

			IF(IFNULL(Var_ClienteID, Entero_Cero) > Entero_Cero) THEN
				SET Par_NumErr			:= 011;
				SET Par_ErrMen			:= 'El Cliente ya cuenta con un perfil transaccional.';
				SET Var_Control			:= 'clienteID';
				SET Var_Consecutivo 	:= Entero_Cero;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SET Aud_FechaActual := NOW();

		INSERT INTO PLDPERFILTRANS (
			ClienteID,			UsuarioServicioID,		DepositosMax,			RetirosMax,					NumDepositos,
			NumRetiros,			CatOrigenRecID,			CatDestinoRecID,		ComentarioOrigenRec,		ComentarioDestRec,
			TipoProceso,		Hora,
			EmpresaID,			Usuario,				FechaActual,			DireccionIP,				ProgramaID,
			Sucursal,			NumTransaccion)
		VALUES (
			Par_ClienteID,		Par_UsuarioServicioID,	Par_DepositosMax,		Par_RetirosMax,				Par_NumDepositos,
			Par_NumRetiros,		Par_CatOrigenRecID,		Par_CatDestinoRecID,	Par_ComentarioOrigenRec,	Par_ComentarioDestRec,
			Pro_Manual,			CURRENT_TIME(),
			Aud_EmpresaID,		Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion
		);

		CALL PLDPERFILTRANSHISALT (
			Par_ClienteID,	Par_UsuarioServicioID,	Cons_NO,			Par_NumErr,			Par_ErrMen,
			Aud_EmpresaID,	Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,	Aud_NumTransaccion
		);

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		IF (Par_ClienteID > Entero_Cero) THEN
			-- Se calcula el Nivel de Riesgo del Nuevo Cliente
			CALL RIESGOPLDCTEPRO(
				Par_ClienteID,      Cons_NO,        	Par_NumErr,       	Par_ErrMen,   Aud_EmpresaID,      Aud_Usuario,
				Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal, Aud_NumTransaccion
			);

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SET	Par_NumErr		:= 000;
		SET	Par_ErrMen		:= CONCAT('Perfil Transaccional Agregado Exitosamente.');
		SET Var_Control 	:= IF(Par_ClienteID > Entero_Cero, 'clienteID', 'usuarioID');
		SET Var_Consecutivo	:= IF(Par_ClienteID > Entero_Cero, Par_ClienteID, Par_UsuarioServicioID);

	END ManejoErrores;

	IF(Par_Salida = SalidaSi) THEN
		SELECT 	Par_NumErr AS NumErr,
		Par_ErrMen AS ErrMen,
		Var_Control AS Control,
		Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$
