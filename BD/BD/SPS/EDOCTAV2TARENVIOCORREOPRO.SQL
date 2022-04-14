DELIMITER ;
DROP PROCEDURE IF EXISTS EDOCTAV2TARENVIOCORREOPRO;
DELIMITER $$

CREATE PROCEDURE EDOCTAV2TARENVIOCORREOPRO(
	-- Stored procedure que pasa los correo a la tabla historica
	Par_NumProceso					TINYINT,				-- Numero de proceso para el envio de correo
	Par_Salida						CHAR(1),				-- Parametro para salida de datos
	INOUT Par_NumErr				INT(11),				-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen				VARCHAR(800),			-- Parametro de entrada/salida de mensaje de control de respuesta de acuerdo al desarrollador
	Aud_EmpresaID 					INT(11), 				-- Parametros de auditoria
	Aud_Usuario						INT(11),				-- Parametros de auditoria
	Aud_FechaActual					DATETIME,				-- Parametros de auditoria
	Aud_DireccionIP					VARCHAR(15),			-- Parametros de auditoria
	Aud_ProgramaID					VARCHAR(50),			-- Parametros de auditoria
	Aud_Sucursal 					INT(11), 				-- Parametros de auditoria
	Aud_NumTransaccion				BIGINT(20)				-- Parametros de auditoria
)
TerminaStore:BEGIN

	-- Declaracion de constantes
	DECLARE Entero_Vacio			INT;					-- Entero vacio
	DECLARE Decimal_Vacio			DECIMAL(8,2);			-- Decimal vacio
	DECLARE Cadena_Vacia			CHAR(1);				-- Cadena vacia
	DECLARE Fecha_Vacia				DATETIME;				-- Fecha vacia
	DECLARE SalidaSI				CHAR(1);				-- Salida si
	DECLARE Var_SalidaNO			CHAR(1);				-- Salida no
	DECLARE CodigoExito				CHAR(6);				-- Codigo exito
	DECLARE Pro_PaseHistorico		TINYINT;				-- Proceso para pase a historico
	DECLARE EstEnviado				CHAR(1);				-- Estatus Enviado
	DECLARE EstFallado				CHAR(1);				-- Estatus Fallado
	DECLARE EstCaducado				CHAR(1);				-- Estatus Caducado

	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(50);			-- Variable de Control
	DECLARE Var_EstNoEnviado		CHAR(1);				-- Estatus Pendiente
	DECLARE Var_GrupoEmail			VARCHAR(200);			-- Grupo de email
	DECLARE Var_CorreoGrupo			VARCHAR(200);			-- Correo de todos los grupo
	DECLARE Var_GrupoID				INT;					-- Almacena el id del grupo
	DECLARE Var_EnvioCorreoID		INT;					-- ID del correo

	-- Asignacion de constantes
	SET Entero_Vacio				:= 0;					-- Asignacion de entero vacio
	SET Decimal_Vacio				:= 0.0;					-- Asignacion de decimal vacio
	SET Cadena_Vacia				:= '';					-- Asignacion de cadena vacia
	SET Fecha_Vacia					:= '1900-01-01';		-- Asignacion de fecha vacia
	SET SalidaSI					:= 'S';					-- Asignacion de salida si
	SET Var_SalidaNO				:= 'N';					-- Asignacion de salida no
	SET CodigoExito					:= '000000';			-- Codigo exito
	SET Pro_PaseHistorico			:= 1;					-- Asignacion de proceso para pase a historico
	SET Var_EstNoEnviado			:= 'N';					-- Asignacion de valor para el estatus no enviado
	SET EstEnviado					:= 'E';					-- Asignacion de valor para el estatus Enviado
	SET EstFallado					:= 'F';					-- Asignacion de valor para el estatus Fallado
	SET EstCaducado					:= 'C';					-- Asignacion de valor para el estatus Caducado

	-- Proceso que se encarga de pasar los registros con estatus Fallados,Enviados y Caducados a una tabla historica
	IF	(Par_NumProceso	=	Pro_PaseHistorico) THEN

		INSERT INTO EDOCTAV2TARENVIOCORREOHIS 	(ClienteID,			Periodo,						Contrasenia,				EnvioCorreoID,			EmailDestino,	
		                                      	Asunto,				Mensaje,EstatusEnvio,			FechaEnvio,					FechaProgramada,		FechaVencimiento,		
												Proceso,			PIDTarea,						DescripcionError,			RemitenteID,			EmpresaID,			
												Usuario,			FechaActual,					DireccionIP,				ProgramaID,				Sucursal,				
												NumTransaccion
												)

							SELECT	TARENVIO.ClienteID,				TARENVIO.Periodo,				TARENVIO.Contrasenia,
									TARENVIO.EnvioCorreoID,			TARENVIO.EmailDestino,			TARENVIO.Asunto,			TARENVIO.Mensaje,
									TARENVIO.EstatusEnvio,			TARENVIO.FechaEnvio,			TARENVIO.FechaProgramada,	TARENVIO.FechaVencimiento,	TARENVIO.Proceso,
									TARENVIO.PIDTarea,				TARENVIO.DescripcionError,		TARENVIO.RemitenteID, 		TARENVIO.EmpresaID,			TARENVIO.Usuario,
									TARENVIO.FechaActual,			TARENVIO.DireccionIP,			TARENVIO.ProgramaID,		TARENVIO.Sucursal,			TARENVIO.NumTransaccion
								FROM EDOCTAV2TARENVIOCORREO TARENVIO
								WHERE TARENVIO.EstatusEnvio IN (EstEnviado,EstFallado,EstCaducado);

		DELETE EDOCTAV2TARENVIOCORREO FROM EDOCTAV2TARENVIOCORREO
		WHERE  EstatusEnvio IN (EstEnviado,EstFallado,EstCaducado);

		INSERT INTO EDOCTAV2TARARCHIVOCORREOHIS (	ArchivoID,		EnvioCorreoID,		NombreArchivo,		Extension,			Archivo,
													PesoByte,		EmpresaID,			Usuario,			FechaActual,		DireccionIP,
													ProgramaID,		Sucursal,			NumTransaccion)
											SELECT	arc.ArchivoID,	arc.EnvioCorreoID,	arc.NombreArchivo,	arc.Extension,		arc.Archivo,
													arc.PesoByte,	arc.EmpresaID,		arc.Usuario,		arc.FechaActual,	arc.DireccionIP,
													arc.ProgramaID,	arc.Sucursal,		arc.NumTransaccion
												FROM EDOCTAV2TARARCHIVOCORREO AS arc
												INNER JOIN EDOCTAV2TARENVIOCORREOHIS AS cor ON arc.EnvioCorreoID = cor.EnvioCorreoID;

		DELETE arc
			FROM EDOCTAV2TARARCHIVOCORREO AS arc
			INNER JOIN EDOCTAV2TARENVIOCORREOHIS AS cor ON arc.EnvioCorreoID = cor.EnvioCorreoID;

		SET	Par_NumErr 	:= 000;
		SET	Par_ErrMen	:= 'Proceso de pase a historica de los correos exitoso';
		SET Var_Control := 'EnvioCorreoID';
	END IF;

	-- Si Par_Salida = S (SI)
	IF(Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr	AS NumErr,
				Par_ErrMen	AS ErrMen,
				Var_Control	AS control;
	END IF;

-- Fin del SP
END TerminaStore$$
