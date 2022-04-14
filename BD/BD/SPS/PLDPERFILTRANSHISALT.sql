-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDPERFILTRANSHISALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDPERFILTRANSHISALT`;
DELIMITER $$

CREATE PROCEDURE `PLDPERFILTRANSHISALT`(
	-- SP que da de alta el Perfil Transaccional en la tabla historica
	Par_ClienteID					INT(11),					-- Numero de Cliente
	Par_UsuarioServicioID			INT(11),					-- Número de usuario de servicios.
	Par_Salida						CHAR(1),					-- Indica el tipo de salida S.- SI N.- No

	INOUT Par_NumErr				INT,						-- Numero de Error
	INOUT Par_ErrMen				VARCHAR(400),				-- Mensaje de Error

	-- Parametros de Auditoria
	Aud_EmpresaID					INT(11),
	Aud_Usuario						INT(11),
	Aud_FechaActual					DATETIME,
	Aud_DireccionIP					VARCHAR(15),
	Aud_ProgramaID					VARCHAR(50),
	Aud_Sucursal					INT(11),
	Aud_NumTransaccion				BIGINT(12)
)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_Control					VARCHAR(50);				-- ID del Control en pantalla
	DECLARE Var_Consecutivo 			VARCHAR(200);				-- Numero consecutivo para la imagen a digitalizar
	DECLARE Var_FechaActual				DATE;
	DECLARE Var_HoraActual				TIME;
	DECLARE Var_DepositosMax			DECIMAL(16,2);				-- Monto Maximo de Deposito por transacción

	DECLARE Var_RetirosMax				DECIMAL(16,2);				-- Monto Maximo de Retiros por Transacción
	DECLARE Var_NumDepositos			INT(11);					-- Numero Máximo de depositos
	DECLARE Var_NumRetiros				INT(11);					-- Numero Máximo de Retiros
	DECLARE Var_CatOrigenRecID			INT(11);					-- ID Del Origen de los Recursos CATPLDORIGENREC
	DECLARE Var_CatDestinoRecID			INT(11);					-- ID del Destino de los recursos CATPLDDESTINOREC

	DECLARE Var_ComentarioOrigenRec		VARCHAR(600);				-- Comentario Sobre el Origen de los Recursos
	DECLARE Var_ComentarioDestRec		VARCHAR(600);				-- Comentario Sobre el Destino de los Recursos
	DECLARE Var_NumDepoApli				INT(11);
	DECLARE Var_NumRetiApli				INT(11);
	DECLARE Var_TipoProceso				CHAR(1);

	DECLARE Var_AntDepositosMax			DECIMAL(16,2);
	DECLARE Var_AntRetirosMax			DECIMAL(16,2);
	DECLARE Var_AntNumDepositos			INT(11);
	DECLARE Var_AntNumRetiros			INT(11);
	DECLARE Var_CliProcEspecifico		INT(11);					-- Almacena el numero del cliente parametrizado.

	-- Historico
	DECLARE Var_DepositosMax2			DECIMAL(16,2);				-- Monto Maximo de Deposito por transacción
	DECLARE Var_RetirosMax2				DECIMAL(16,2);				-- Monto Maximo de Retiros por Transacción
	DECLARE Var_NumDepositos2			INT(11);					-- Numero Máximo de depositos
	DECLARE Var_NumRetiros2				INT(11);					-- Numero Máximo de Retiros
	DECLARE Var_CatOrigenRecID2			INT(11);					-- ID Del Origen de los Recursos CATPLDORIGENREC

	DECLARE Var_CatDestinoRecID2		INT(11);					-- ID del Destino de los recursos CATPLDDESTINOREC
	DECLARE Var_ComentarioOrigenRec2	VARCHAR(600);				-- Comentario Sobre el Origen de los Recursos
	DECLARE Var_ComentarioDestRec2		VARCHAR(600);				-- Comentario Sobre el Destino de los Recursos
	DECLARE Var_NumDepoApli2			INT(11);
	DECLARE Var_NumRetiApli2			INT(11);

	DECLARE Var_TipoProceso2			CHAR(1);
	DECLARE Var_NivelRiesgo				CHAR(1);

	-- Declaracion de constantes
	DECLARE Estatus_Activo			CHAR(1);
	DECLARE Entero_Cero				INT(11);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Cons_NO					CHAR(1);
	DECLARE SalidaSi				CHAR(1);

	DECLARE Cons_LlaveCliProEsp		VARCHAR(20);				-- Constante llave para filtrar el cliente parametrizado.
	DECLARE Cli_SofiExpress			INT(11);					-- Número de cliente que le corresponde a SOFI EXPRESS.


	-- Asignacion de constantes
	SET Estatus_Activo			:= 'A';							-- Estatus Activo
	SET Entero_Cero				:= 0;							-- Entero Cero
	SET Cadena_Vacia			:= '';							-- Cadena Vacia
	SET Cons_NO					:= 'N';							-- Constante No
	SET SalidaSi				:= 'S';							-- Salida Si

	SET Cons_LlaveCliProEsp		:= 'CliProcEspecifico';
	SET Cli_SofiExpress			:= 15;

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr		:= 999;
			SET Par_ErrMen		:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDPERFILTRANSHISALT');
			SET Var_Control		:= 'sqlException' ;
		END;

		-- Redeclaración de parámetros en caso de venir con valor null.
		SET Par_ClienteID := IFNULL(Par_ClienteID, Entero_Cero);
		SET Par_UsuarioServicioID := IFNULL(Par_UsuarioServicioID, Entero_Cero);

		SET Var_FechaActual := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

		SET Var_CliProcEspecifico := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = Cons_LlaveCliProEsp);
		SET Var_CliProcEspecifico := IFNULL(Var_CliProcEspecifico, Entero_Cero);

		IF (Var_CliProcEspecifico = Cli_SofiExpress AND Par_UsuarioServicioID > Entero_Cero) THEN
			SELECT
				DepositosMax,		 	RetirosMax,			  		NumDepositos,			NumRetiros,		  		CatOrigenRecID,
				CatDestinoRecID,	 	ComentarioOrigenRec,	  	ComentarioDestRec,		NumDepoApli,		  	NumRetiApli,
				TipoProceso,		 	AntDepositosMax,		  	AntRetirosMax,			AntNumDepositos,	  	AntNumRetiros
			INTO
				Var_DepositosMax,		Var_RetirosMax,		  		Var_NumDepositos,		Var_NumRetiros, 	  	Var_CatOrigenRecID,
				Var_CatDestinoRecID,	Var_ComentarioOrigenRec,	Var_ComentarioDestRec,	Var_NumDepoApli,	  	Var_NumRetiApli,
				Var_TipoProceso,		Var_AntDepositosMax,	  	Var_AntRetirosMax,	 	Var_AntNumDepositos,	Var_AntNumRetiros
			FROM PLDPERFILTRANS
			WHERE UsuarioServicioID = Par_UsuarioServicioID LIMIT 1;

			SELECT
				DepositosMax,			RetirosMax,					NumDepositos,			NumRetiros,			CatOrigenRecID,
				CatDestinoRecID,		ComentarioOrigenRec,		ComentarioDestRec,		NumDepoApli,		NumRetiApli,
				TipoProceso
			INTO
				Var_DepositosMax2,		Var_RetirosMax2,			Var_NumDepositos2,		Var_NumRetiros2,	Var_CatOrigenRecID2,
				Var_CatDestinoRecID2,	Var_ComentarioOrigenRec2,	Var_ComentarioDestRec2,	Var_NumDepoApli2,	Var_NumRetiApli2,
				Var_TipoProceso2
			FROM PLDHISPERFILTRANS
			WHERE UsuarioServicioID = Par_UsuarioServicioID
			ORDER BY FechaAct DESC, Hora DESC LIMIT 1;
		ELSE
			SELECT
				DepositosMax,		 	RetirosMax,			  		NumDepositos,			NumRetiros,		  		CatOrigenRecID,
				CatDestinoRecID,	 	ComentarioOrigenRec,	  	ComentarioDestRec,		NumDepoApli,		  	NumRetiApli,
				TipoProceso,		 	AntDepositosMax,		  	AntRetirosMax,			AntNumDepositos,	  	AntNumRetiros
			INTO
				Var_DepositosMax,		Var_RetirosMax,		  		Var_NumDepositos,		Var_NumRetiros, 	  	Var_CatOrigenRecID,
				Var_CatDestinoRecID,	Var_ComentarioOrigenRec,	Var_ComentarioDestRec,	Var_NumDepoApli,	  	Var_NumRetiApli,
				Var_TipoProceso,		Var_AntDepositosMax,	  	Var_AntRetirosMax,	 	Var_AntNumDepositos,	Var_AntNumRetiros
			FROM PLDPERFILTRANS
			WHERE ClienteID = Par_ClienteID LIMIT 1;

			SELECT
				DepositosMax,			RetirosMax,					NumDepositos,			NumRetiros,			CatOrigenRecID,
				CatDestinoRecID,		ComentarioOrigenRec,		ComentarioDestRec,		NumDepoApli,		NumRetiApli,
				TipoProceso
			INTO
				Var_DepositosMax2,		Var_RetirosMax2,			Var_NumDepositos2,		Var_NumRetiros2,	Var_CatOrigenRecID2,
				Var_CatDestinoRecID2,	Var_ComentarioOrigenRec2,	Var_ComentarioDestRec2,	Var_NumDepoApli2,	Var_NumRetiApli2,
				Var_TipoProceso2
			FROM PLDHISPERFILTRANS
			WHERE ClienteID = Par_ClienteID
			ORDER BY FechaAct DESC, Hora DESC LIMIT 1;
		END IF;

		SET Aud_FechaActual			:= NOW();
		SET Var_HoraActual			:= CURRENT_TIME();

		SET Var_DepositosMax 		:= IFNULL(Var_DepositosMax, Entero_Cero);
		SET Var_RetirosMax 			:= IFNULL(Var_RetirosMax, Entero_Cero);
		SET Var_NumDepositos 		:= IFNULL(Var_NumDepositos, Entero_Cero);
		SET Var_NumRetiros 			:= IFNULL(Var_NumRetiros, Entero_Cero);
		SET Var_CatOrigenRecID 		:= IFNULL(Var_CatOrigenRecID, Entero_Cero);
		SET Var_CatDestinoRecID 	:= IFNULL(Var_CatDestinoRecID, Entero_Cero);
		SET Var_ComentarioOrigenRec := IFNULL(Var_ComentarioOrigenRec, Cadena_Vacia);
		SET Var_ComentarioDestRec 	:= IFNULL(Var_ComentarioDestRec, Cadena_Vacia);
		SET Var_TipoProceso 		:= IFNULL(Var_TipoProceso, Cadena_Vacia);

		SET Var_DepositosMax2		:= IFNULL(Var_DepositosMax2, Entero_Cero);
		SET Var_RetirosMax2			:= IFNULL(Var_RetirosMax2, Entero_Cero);
		SET Var_NumDepositos2		:= IFNULL(Var_NumDepositos2, Entero_Cero);
		SET Var_NumRetiros2			:= IFNULL(Var_NumRetiros2, Entero_Cero);
		SET Var_CatOrigenRecID2		:= IFNULL(Var_CatOrigenRecID2, Entero_Cero);
		SET Var_CatDestinoRecID2	:= IFNULL(Var_CatDestinoRecID2, Entero_Cero);
		SET Var_ComentarioOrigenRec2:= IFNULL(Var_ComentarioOrigenRec2, Cadena_Vacia);
		SET Var_ComentarioDestRec2	:= IFNULL(Var_ComentarioDestRec2, Cadena_Vacia);
		SET Var_TipoProceso2		:= IFNULL(Var_TipoProceso2, Cadena_Vacia);

		IF(Var_DepositosMax			!= Var_DepositosMax2 OR
			Var_RetirosMax			!= Var_RetirosMax2 OR
			Var_NumDepositos		!= Var_NumDepositos2 OR
			Var_NumRetiros			!= Var_NumRetiros2 OR
			Var_CatOrigenRecID		!= Var_CatOrigenRecID2 OR
			Var_CatDestinoRecID		!= Var_CatDestinoRecID2 OR
			Var_ComentarioOrigenRec	!= Var_ComentarioOrigenRec2 OR
			Var_ComentarioDestRec	!= Var_ComentarioDestRec2 OR
			Var_TipoProceso			!= Var_TipoProceso2
			) THEN

			IF (Var_CliProcEspecifico = Cli_SofiExpress AND Par_UsuarioServicioID > Entero_Cero) THEN
				SET Var_NivelRiesgo := (SELECT NivelRiesgo FROM USUARIOSERVICIO WHERE UsuarioServicioID = Par_UsuarioServicioID);
			ELSE
				SET Var_NivelRiesgo := (SELECT NivelRiesgo FROM CLIENTES WHERE ClienteID = Par_ClienteID);
			END IF;

			INSERT INTO PLDHISPERFILTRANS (
				TransaccionID,			FechaAct,					Hora,					ClienteID,				UsuarioServicioID,
				DepositosMax,			RetirosMax,					NumDepositos,			NumRetiros,				CatOrigenRecID,
				CatDestinoRecID,		ComentarioOrigenRec,		ComentarioDestRec,		NumDepoApli,			NumRetiApli,
				TipoProceso,			AntDepositosMax,			AntRetirosMax,			AntNumDepositos,		AntNumRetiros,
				NivelRiesgo,			EmpresaID,					Usuario,				FechaActual,			DireccionIP,
				ProgramaID,				Sucursal,					NumTransaccion
			) VALUES (
				Aud_NumTransaccion,		Var_FechaActual,			Var_HoraActual,			Par_ClienteID,			Par_UsuarioServicioID,
				Var_DepositosMax,		Var_RetirosMax,				Var_NumDepositos,		Var_NumRetiros,			Var_CatOrigenRecID,
				Var_CatDestinoRecID,	Var_ComentarioOrigenRec,	Var_ComentarioDestRec,	Var_NumDepoApli,		Var_NumRetiApli,
				Var_TipoProceso,		Var_AntDepositosMax,		Var_AntRetirosMax,		Var_AntNumDepositos,	Var_AntNumRetiros,
				Var_NivelRiesgo,		Aud_EmpresaID,				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
				Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion
			);
		END IF;

		SET	Par_NumErr		:= 000;
		SET	Par_ErrMen		:= CONCAT('Perfil Transaccional Historico Agregado Exitosamente.');
		SET Var_Control 	:= 'sucursalID' ;
		SET Var_Consecutivo	:= 0;

	END ManejoErrores;

	IF(Par_Salida = SalidaSi) THEN
		SELECT 	Par_NumErr AS NumErr,
		Par_ErrMen AS ErrMen,
		Var_Control AS Control,
		Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$