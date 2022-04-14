DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAV2TARENVIOCORREOLIS`;
DELIMITER $$

CREATE PROCEDURE `EDOCTAV2TARENVIOCORREOLIS`(
	-- Stored procedure para listar los correos electronicos
	Par_EnvioCorreoID					BIGINT(20),				-- Identificador unico de la notificacion de correo
	Par_EmailDestino					VARCHAR(500),			-- Correo electronico donde sera enviado el correo
	Par_Asunto							VARCHAR(100),			-- Asunto del correo electronico
	Par_Mensaje							VARCHAR(5000),			-- Contenido del correo electronico
	Par_GrupoEmailID					INT(11),				-- Identificador de la tabla GRUPOSEMAIL en caso que se requiera mandar a varios correos
	Par_EstatusEnvio					CHAR(1),				-- Estus de la notificacion, podra tener los valores P= Pendiente E=Enviado F=Fallo C=Caducado
	Par_PIDTarea						VARCHAR(50),			-- Identificador de la tarea
	Par_FechaEnvio						DATETIME,				-- Fecha y hora de envio del correo
	Par_FechaProgramada					DATETIME,				-- Es la fecha con la cual se programa el envio de correo
	Par_FechaVencimiento				DATETIME,				-- Es la fecha con la cual se vence el correo
	Par_NumLis							TINYINT UNSIGNED,		-- Numero de lista

	-- Parametros de Auditoria
	Aud_EmpresaID						INT(11),				-- Parametro de auditoria
	Aud_Usuario							INT(11),				-- Parametro de auditoria
	Aud_FechaActual						DATETIME,				-- Parametro de auditoria
	Aud_DireccionIP						VARCHAR(15),			-- Parametro de auditoria
	Aud_ProgramaID						VARCHAR(50),			-- Parametro de auditoria
	Aud_Sucursal						INT(11),				-- Parametro de auditoria
	Aud_NumTransaccion					BIGINT(20)				-- Parametro de auditoria
)
TerminaStore:BEGIN
	-- Declaracion de constantes
	DECLARE Entero_Cero					INT(1);				-- Entero vacio
	DECLARE Var_LisCorreoProceso		TINYINT(1);			-- Lista todos los correo pendentes
	DECLARE Var_LisCorreoEnviados		TINYINT(1);			-- Lista todos los correo enviados
	DECLARE Var_LisCorreoFallados		TINYINT(1);			-- Lista todos los correo fallados
	DECLARE Var_LisCorreoCaducado		TINYINT(1);			-- Lista todos los correo Caducados
	DECLARE Var_LisCorreoNoEnviado		TINYINT(1);			-- Lista todos los correo No enviados
	DECLARE Var_EstProceso				CHAR(1);			-- Estatus en proceso
	DECLARE Var_EstEnviado				CHAR(1);			-- Estatus Enviado
	DECLARE Var_EstFallado				CHAR(1);			-- Estatus Fallado
	DECLARE Var_EstCaducado				CHAR(1);			-- Estatus Caducado
	DECLARE Var_EstNoEnviados			CHAR(1);			-- Estatus No enviado

	-- Asignacion de constantes
	SET Entero_Cero						:= 0;					-- Asignacion de entero vacio
	SET Var_LisCorreoProceso			:= 1;					-- Asignacion para lista de correos pendentes
	SET Var_LisCorreoEnviados			:= 2;					-- Asignacion para lista de correos enviados
	SET Var_LisCorreoFallados			:= 3;					-- Asignacion para lista de correos fallados
	SET Var_LisCorreoCaducado			:= 4;					-- Asignacion para lista de correos caducados
	SET Var_LisCorreoNoEnviado			:= 5;					-- Asignacion para lista de correos no enviados
	SET Var_EstProceso					:= 'P';					-- Asignacion de valor para el estatus en proceso
	SET Var_EstEnviado					:= 'E';					-- Asignacion de valor para el estatus Enviado
	SET Var_EstFallado					:= 'F';					-- Asignacion de valor para el estatus Fallado
	SET Var_EstCaducado					:= 'C';					-- Asignacion de valor para el estatus Caducado
	SET Var_EstNoEnviados				:= 'N';					-- Asignacion de valor para el estatus No envido

	-- Valores por default
	SET Par_NumLis					:= IFNULL(Par_NumLis,Entero_Cero);

	-- Lista todos los correos en proceso
	IF (Par_NumLis = Var_LisCorreoProceso) THEN
		SELECT		ENV.EnvioCorreoID,			ENV.EmailDestino,			ENV.Asunto,				ENV.Mensaje,			ENV.ClienteID,
					ENV.EstatusEnvio,			ENV.FechaEnvio,				ENV.FechaProgramada,	ENV.FechaVencimiento,	ENV.Proceso,
					ENV.PIDTarea,				ENV.DescripcionError,		PAR.Descripcion,		PAR.ServidorSMTP,		PAR.PuertoServerSMTP,
					PAR.TipoSeguridad,			PAR.CorreoSalida,			PAR.ConAutentificacion,	PAR.Contrasenia AS ContraseniaRemitente,	PAR.Estatus,
					PAR.Comentario,				PAR.RemitenteID, 			PAR.AliasRemitente,		PAR.TamanioMax, 		PAR.Tipo,
					ENV.Periodo,				ENV.Contrasenia
			FROM	EDOCTAV2TARENVIOCORREO ENV
				INNER JOIN TARENVIOCORREOPARAM PAR ON ENV.RemitenteID = PAR.RemitenteID
			WHERE	ENV.EstatusEnvio	= Var_EstProceso
				AND	ENV.PIDTarea		= Par_PIDTarea
				ORDER BY PAR.RemitenteID ASC;
	END IF;

	-- Lista todos los correos Enviado
	IF (Par_NumLis = Var_LisCorreoEnviados) THEN
		DROP TABLE IF EXISTS EDOCTAV2TMPTARENVIOCORREO;

		CREATE TEMPORARY TABLE EDOCTAV2TMPTARENVIOCORREO (
			EnvioCorreoID		BIGINT(20)		NOT NULL,
			EmailDestino 		VARCHAR(500)	NOT NULL,
			Asunto				VARCHAR(100)	NOT NULL,
			Mensaje				VARCHAR(5000)	NOT NULL,
			EstatusEnvio		CHAR(1)			NOT NULL,
			FechaEnvio			DATETIME		NOT NULL,
			FechaProgramada		DATETIME		NOT NULL,
			FechaVencimiento	DATETIME		NOT NULL,
			Proceso				VARCHAR(50)		NOT NULL,
			PIDTarea			VARCHAR(50)		NOT NULL,
			DescripcionError	VARCHAR(100)	NOT NULL,
			RemitenteID			INT(11)			NOT NULL,
			Descripcion			VARCHAR(80)		NOT NULL,
			ServidorSMTP		VARCHAR(80)		NOT NULL,
			PuertoServerSMTP	VARCHAR(6)		NOT NULL,
			TipoSeguridad		CHAR(2)			NOT NULL,
			CorreoSalida		VARCHAR(80)		NOT NULL,
			ConAutentificacion	CHAR(1)			NOT NULL,
			Contrasenia			VARCHAR(20)		NOT NULL,
			Estatus				CHAR(1)			NOT NULL,
			Comentario			VARCHAR(200)	NOT NULL,
			PRIMARY KEY (EnvioCorreoID)
		);

		INSERT INTO EDOCTAV2TMPTARENVIOCORREO (
					EnvioCorreoID,			EmailDestino,			Asunto,					Mensaje,			EstatusEnvio,	
					FechaEnvio,				FechaProgramada,		FechaVencimiento,		Proceso,			PIDTarea,		
					DescripcionError,		RemitenteID,			Descripcion,			ServidorSMTP,		PuertoServerSMTP,
					TipoSeguridad,			CorreoSalida,			ConAutentificacion,		Contrasenia,		Estatus,		
					Comentario
				)
		SELECT		ENV.EnvioCorreoID,		ENV.EmailDestino,		ENV.Asunto,				ENV.Mensaje,
					ENV.EstatusEnvio,		ENV.FechaEnvio,			ENV.FechaProgramada,	ENV.FechaVencimiento,	ENV.Proceso,
					ENV.PIDTarea,			ENV.DescripcionErro,	PAR.RemitenteID,		PAR.Descripcion,		PAR.ServidorSMTP,
					PAR.PuertoServerSMTP,	PAR.TipoSeguridad,		PAR.CorreoSalida,		PAR.ConAutentificacion,	PAR.Contrasenia,
					PAR.Estatus,			PAR.Comentario
			FROM	EDOCTAV2TARENVIOCORREO ENV
				INNER JOIN TARENVIOCORREOPARAM PAR ON ENV.RemitenteID = PAR.RemitenteID
			WHERE	ENV.EstatusEnvio = Var_EstEnviado;

		INSERT INTO EDOCTAV2TMPTARENVIOCORREO (
					EnvioCorreoID,			EmailDestino,			Asunto,					Mensaje,
					EstatusEnvio,			FechaEnvio,				FechaProgramada,		FechaVencimiento,		Proceso,
					PIDTarea,				DescripcionError,		RemitenteID,			Descripcion,			ServidorSMTP,
					PuertoServerSMTP,		TipoSeguridad,			CorreoSalida,			ConAutentificacion,		Contrasenia,
					Estatus,				Comentario
		)
		SELECT		ENV.EnvioCorreoID,		ENV.EmailDestino,		ENV.Asunto,				ENV.Mensaje,
					ENV.EstatusEnvio,		ENV.FechaEnvio,			ENV.FechaProgramada,	ENV.FechaVencimiento,	ENV.Proceso,
					ENV.PIDTarea,			ENV.DescripcionErro,	PAR.RemitenteID,		PAR.Descripcion,		PAR.ServidorSMTP,
					PAR.PuertoServerSMTP,	PAR.TipoSeguridad,		PAR.CorreoSalida,		PAR.ConAutentificacion,	PAR.Contrasenia,
					PAR.Estatus,			PAR.Comentario
			FROM	EDOCTAV2TARENVIOCORREOHIS ENV
				INNER JOIN TARENVIOCORREOPARAM PAR ON ENV.RemitenteID = PAR.RemitenteID
			WHERE	ENV.EstatusEnvio	= Var_EstEnviado;

		SELECT		EnvioCorreoID,			EmailDestino,			Asunto,					Mensaje,
					EstatusEnvio,			FechaEnvio,				FechaProgramada,		FechaVencimiento,		Proceso,
					PIDTarea,				DescripcionError,		RemitenteID,			Descripcion,			ServidorSMTD,
					PuertoServerSMTD,		TipoSeguridad,			CorreoSalida,			ConAutentificacion,		Contrasenia,
					Estatus,				Comentario
			FROM	EDOCTAV2TMPTARENVIOCORREO
			WHERE	EstatusEnvio	= Var_EstEnviado;
	END IF;

	-- Lista todos los correos Fallado
	IF (Par_NumLis = Var_LisCorreoFallados) THEN
		DROP TABLE IF EXISTS EDOCTAV2TMPTARENVIOCORREO1;

		CREATE TEMPORARY TABLE EDOCTAV2TMPTARENVIOCORREO1 (
			EnvioCorreoID		BIGINT(20)		NOT NULL,
			EmailDestino 		VARCHAR(500)	NOT NULL,
			Asunto				VARCHAR(100)	NOT NULL,
			Mensaje				VARCHAR(5000)	NOT NULL,
			EstatusEnvio		CHAR(1)			NOT NULL,
			FechaEnvio			DATETIME		NOT NULL,
			FechaProgramada		DATETIME		NOT NULL,
			FechaVencimiento	DATETIME		NOT NULL,
			Proceso				VARCHAR(50)		NOT NULL,
			PIDTarea			VARCHAR(50)		NOT NULL,
			DescripcionError	VARCHAR(100)	NOT NULL,
			RemitenteID			INT(11)			NOT NULL,
			Descripcion			VARCHAR(80)		NOT NULL,
			ServidorSMTP		VARCHAR(80)		NOT NULL,
			PuertoServerSMTP	VARCHAR(6)		NOT NULL,
			TipoSeguridad		CHAR(2)			NOT NULL,
			CorreoSalida		VARCHAR(80)		NOT NULL,
			ConAutentificacion	CHAR(1)			NOT NULL,
			Contrasenia			VARCHAR(20)		NOT NULL,
			Estatus				CHAR(1)			NOT NULL,
			Comentario			VARCHAR(200)	NOT NULL,
			PRIMARY KEY (EnvioCorreoID)
		);

		INSERT INTO EDOCTAV2TMPTARENVIOCORREO1 (
					EnvioCorreoID,			EmailDestino,			Asunto,					Mensaje,     	  EstatusEnvio,	
					FechaEnvio,				FechaProgramada,		FechaVencimiento,		Proceso,	      PIDTarea,	
					DescripcionError,		RemitenteID,			Descripcion,			ServidorSMTP,	  PuertoServerSMTP,	
					TipoSeguridad,			CorreoSalida,			ConAutentificacion,		Contrasenia,	  Estatus,			
					Comentario
				
	            	)
		SELECT		ENV01.EnvioCorreoID,	ENV01.EmailDestino,		ENV01.Asunto,			ENV01.Mensaje,		ENV01.EstatusEnvio,	
		         	ENV01.FechaEnvio,		ENV01.FechaProgramada,	ENV01.FechaVencimiento,	ENV01.Proceso,		ENV01.PIDTarea,		
					ENV01.DescripcionError,	PAR.RemitenteID,		PAR.Descripcion,		PAR.ServidorSMTP,	PAR.PuertoServerSMTP,
					PAR.TipoSeguridad,		PAR.CorreoSalida,		PAR.ConAutentificacion,	PAR.Contrasenia,	PAR.Estatus,	
					PAR.Comentario
			FROM	EDOCTAV2TARENVIOCORREO ENV01
				INNER JOIN TARENVIOCORREOPARAM PAR ON ENV.RemitenteID = PAR.RemitenteID
			WHERE	ENV01.EstatusEnvio = Var_EstFallado;

		INSERT INTO EDOCTAV2TMPTARENVIOCORREO1 (
					EnvioCorreoID,			EmailDestino,			Asunto,					Mensaje,				EstatusEnvio,
					FechaEnvio,				FechaProgramada,		FechaVencimiento,		Proceso,				PIDTarea,	
					DescripcionError,		RemitenteID,			Descripcion,			ServidorSMTP,			PuertoServerSMTP,	
					TipoSeguridad,			CorreoSalida,			ConAutentificacion,		Contrasenia,			Estatus,
					Comentario
		)
		SELECT		ENV01.EnvioCorreoID,	ENV01.EmailDestino,		ENV01.Asunto,			ENV01.Mensaje,		ENV01.EstatusEnvio,
		         	ENV01.FechaEnvio,		ENV01.FechaProgramada,	ENV01.FechaVencimiento,	ENV01.Proceso,		ENV01.PIDTarea,
					ENV01.DescripcionError,	PAR.RemitenteID,		PAR.Descripcion,		PAR.ServidorSMTP,   PAR.PuertoServerSMTP,	
					PAR.TipoSeguridad,		PAR.CorreoSalida,		PAR.ConAutentificacion,	PAR.Contrasenia,    PAR.Estatus,	
					PAR.Comentario
			FROM	EDOCTAV2TARENVIOCORREOHIS ENV01
				INNER JOIN TARENVIOCORREOPARAM PAR ON ENV01.RemitenteID = PAR.RemitenteID
			WHERE	ENV01.EstatusEnvio = Var_EstFallado;

		SELECT		EnvioCorreoID,			EmailDestino,			Asunto,					Mensaje,    		    EstatusEnvio,		
		         	FechaEnvio,				FechaProgramada,	   FechaVencimiento,		Proceso,    		 	PIDTarea,			
					DescripcionError,		RemitenteID,		Descripcion,				ServidorSMTP,			PuertoServerSMTP,	
					TipoSeguridad,			CorreoSalida,		ConAutentificacion,			Contrasenia,        	Estatus,
					Comentario
			FROM	EDOCTAV2TMPTARENVIOCORREO1
			WHERE	EstatusEnvio = Var_EstFallado;
	END IF;

	-- Lista todos los correos Caducados
	IF (Par_NumLis = Var_LisCorreoCaducado) THEN
		DROP TABLE IF EXISTS EDOCTAV2TMPTARENVIOCORREO2;

		CREATE TEMPORARY TABLE EDOCTAV2TMPTARENVIOCORREO2 (
			EnvioCorreoID		BIGINT(20)		NOT NULL,
			EmailDestino 		VARCHAR(500)	NOT NULL,
			Asunto				VARCHAR(100)	NOT NULL,
			Mensaje				VARCHAR(5000)	NOT NULL,
			EstatusEnvio		CHAR(1)			NOT NULL,
			FechaEnvio			DATETIME		NOT NULL,
			FechaProgramada		DATETIME		NOT NULL,
			FechaVencimiento	DATETIME		NOT NULL,
			Proceso				VARCHAR(50)		NOT NULL,
			PIDTarea			VARCHAR(50)		NOT NULL,
			DescripcionError	VARCHAR(100)	NOT NULL,
			RemitenteID			INT(11)			NOT NULL,
			Descripcion			VARCHAR(80)		NOT NULL,
			ServidorSMTP		VARCHAR(80)		NOT NULL,
			PuertoServerSMTP	VARCHAR(6)		NOT NULL,
			TipoSeguridad		CHAR(2)			NOT NULL,
			CorreoSalida		VARCHAR(80)		NOT NULL,
			ConAutentificacion	CHAR(1)			NOT NULL,
			Contrasenia			VARCHAR(20)		NOT NULL,
			Estatus				CHAR(1)			NOT NULL,
			Comentario			VARCHAR(200)	NOT NULL,
			PRIMARY KEY (EnvioCorreoID)
		);

		INSERT INTO EDOCTAV2TMPTARENVIOCORREO2 (
					EnvioCorreoID,			EmailDestino,			Asunto,					Mensaje,		EstatusEnvio,	
					FechaEnvio,				FechaProgramada,		FechaVencimiento,		Proceso,	    PIDTarea,	
					DescripcionError,		RemitenteID,			Descripcion,			ServidorSMTP,	PuertoServerSMTP,
					TipoSeguridad,			CorreoSalida,			ConAutentificacion,		Contrasenia,	Estatus,
					Comentario
		)
		SELECT		ENV02.EnvioCorreoID,	ENV02.EmailDestino,		ENV02.Asunto,			ENV02.Mensaje,		ENV02.EstatusEnvio,
		     		ENV02.FechaEnvio,		ENV02.FechaProgramada,	ENV02.FechaVencimiento,	ENV02.Proceso,      ENV02.PIDTarea,	
					ENV02.DescripcionError,	PAR.RemitenteID,		PAR.Descripcion,		PAR.ServidorSMTP,	PAR.PuertoServerSMTP,
					PAR.TipoSeguridad,		PAR.CorreoSalida,		PAR.ConAutentificacion,	PAR.Contrasenia,    PAR.Estatus,	
					PAR.Comentario
			FROM	EDOCTAV2TARENVIOCORREO ENV02
				INNER JOIN TARENVIOCORREOPARAM PAR ON ENV02.RemitenteID = PAR.RemitenteID
			WHERE	ENV02.EstatusEnvio = Var_EstCaducado;

		INSERT INTO EDOCTAV2TMPTARENVIOCORREO2 (
					EnvioCorreoID,			EmailDestino,			Asunto,					Mensaje,	  EstatusEnvio,
					FechaEnvio,				FechaProgramada,		FechaVencimiento,		Proceso,      PIDTarea,
					DescripcionError,		RemitenteID,			Descripcion,			ServidorSMTP, PuertoServerSMTP,
					TipoSeguridad,			CorreoSalida,			ConAutentificacion,		Contrasenia,  Estatus,
					Comentario
		)
		SELECT		EnvioCorreoID,			EmailDestino,			Asunto,					Mensaje,		EstatusEnvio,
         			FechaEnvio,				FechaProgramada,		FechaVencimiento,		Proceso,		PIDTarea,
					DescripcionError
			FROM	EDOCTAV2TARENVIOCORREOHIS
			WHERE	EstatusEnvio = Var_EstCaducado;

		SELECT		ENV02.EnvioCorreoID,	ENV02.EmailDestino,		ENV02.Asunto,			ENV02.Mensaje,   	ENV02.EstatusEnvio,
		     		ENV02.FechaEnvio,		ENV02.FechaProgramada,	ENV02.FechaVencimiento,	ENV02.Proceso,		ENV02.PIDTarea,
					ENV02.DescripcionError,	PAR.RemitenteID,		PAR.Descripcion,		PAR.ServidorSMTP,	PAR.PuertoServerSMTP,
					PAR.TipoSeguridad,		PAR.CorreoSalida,		PAR.ConAutentificacion,	PAR.Contrasenia,    PAR.Estatus,	
			   		PAR.Comentario
			FROM	EDOCTAV2TMPTARENVIOCORREO2 ENV02
				INNER JOIN TARENVIOCORREOPARAM PAR ON ENV02.RemitenteID = PAR.RemitenteID
			WHERE	ENV02.EstatusEnvio = Var_EstCaducado;
	END IF;

	-- Lista todos los correos no enviados
	IF (Par_NumLis = Var_LisCorreoNoEnviado) THEN
		SELECT		ENV.EnvioCorreoID,			ENV.EmailDestino,			ENV.Asunto,				ENV.Mensaje,    		ENV.EstatusEnvio,	
		     		ENV.FechaEnvio,				ENV.FechaProgramada,		ENV.FechaVencimiento,	ENV.Proceso,			ENV.PIDTarea,			
					ENV.DescripcionError,		PAR.Descripcion,			PAR.ServidorSMTP,		PAR.PuertoServerSMTP,	PAR.TipoSeguridad,
					PAR.CorreoSalida,			PAR.ConAutentificacion,		PAR.Contrasenia, 		PAR.Estatus,			PAR.Comentario
			FROM	EDOCTAV2TARENVIOCORREO ENV
				INNER JOIN TARENVIOCORREOPARAM PAR ON ENV.RemitenteID = PAR.RemitenteID
			WHERE	ENV.EstatusEnvio = Var_EstNoEnviados;
	END IF;

-- Fin del SP
END TerminaStore$$
