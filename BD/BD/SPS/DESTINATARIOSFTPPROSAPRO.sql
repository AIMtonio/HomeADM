-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DESTINATARIOSFTPPROSAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `DESTINATARIOSFTPPROSAPRO`;
DELIMITER $$


CREATE PROCEDURE `DESTINATARIOSFTPPROSAPRO`(
-- PROCESO PARA ENVIAR CORREOS CUANDO LA LECTURA FTP FALLE
-- ---------------------------------------------------------------------------------
    Par_NumProceso 			INT(11)  ,     	-- Numero de proceso

    Par_Salida              CHAR(1),        -- Salida
    INOUT Par_NumErr        INT,            -- Salida
    INOUT Par_ErrMen        VARCHAR(800),   -- Salida

    Aud_EmpresaID           INT(11) ,       -- Auditoria
    Aud_Usuario             INT(11),        -- Auditoria
    Aud_FechaActual         DATETIME ,      -- Auditoria
    Aud_DireccionIP         VARCHAR(15) ,   -- Auditoria
    Aud_ProgramaID          VARCHAR(50) ,   -- Auditoria
    Aud_Sucursal            INT(11) ,       -- Auditoria
    Aud_NumTransaccion      BIGINT(20)      -- Auditoria

)
TerminaStore:BEGIN
	-- Declaracion de variables
	DECLARE Fecha_Vacia				DATETIME;				-- Fecha vacia
	DECLARE Var_FechaVencimiento	DATETIME;			-- Fecha vencimiento correo
	DECLARE Var_Destinatarios		VARCHAR(500);		-- Destinatarios separados por comas
	DECLARE Var_Asunto				VARCHAR(50);		-- Asunto del correo
	DECLARE Var_CorreoSalida		VARCHAR(50);		-- Correo de salida en el que se enviara
	DECLARE Var_MaxFilas        	INT(11);            -- Numero maximo de filas
    DECLARE Var_PosFila         	INT(11);            -- Posicion del CURSOR
	DECLARE Var_FechaSis        	DATE;           	-- Fecha actual del sistema
	DECLARE Var_Mensaje				VARCHAR(800);		-- Contenido del correo
	DECLARE Var_SumaTam				INT(11);			-- Suma de los caracteres
	DECLARE Var_Remitente			INT(11);			-- Remitente id el que enviara el correo
	DECLARE Var_Tama				INT(11);			-- Tamanio de los destinatarios

	-- Declaracion de constantes
	DECLARE Entero_Uno			INT(1);			-- Entero uno
	DECLARE Cadena_Vacia		VARCHAR(2);			-- Cadena vacia
	DECLARE Salida_SI       	CHAR(1);			-- Salida si
	DECLARE Cons_NO        	 	CHAR(1);			-- Constante no
	DECLARE Entero_Cero     	INT(1);				-- Entero cero
	DECLARE NumPro_EnvioCorr	INT(1);				-- Proceso para envio de correos de destinatarios registrados
	DECLARE Con_ProEjec			VARCHAR(50);		-- Proceso que ejecuta el llamado del store de envio de correo
	DECLARE Con_MaxCarac		INT(11);			-- Constante para el maximo de caracteres de los destinatarios




	-- Asignacion de constantes
	SET Entero_Uno			:= 1;					-- Entero uno
	SET Fecha_Vacia			:= '1900-01-01';		-- Asignacion de fecha vacia
	SET Salida_SI      	 	:= 'S';					-- Salida si
	SET Cons_NO         	:= 'N';					-- Constante no
	SET Entero_Cero     	:=  0;					-- Constante cero
	SET NumPro_EnvioCorr	:= 1;					-- Proceso para envio de correos
	SET Cadena_Vacia		:= '';					-- Constante cadena vacia
	SET Con_ProEjec			:= 'DESTINATARIOSFTPPROSAPRO';	-- Proceso que ejecuta el llamado del store de envio de correo
	SET Con_MaxCarac		:= 500;					-- Constante para el maximo de caracteres de los destinatarios

	SET Var_MaxFilas		:= 0;					-- Maximo filas
	SET Var_PosFila         := 1;					-- Posicion del while
	SET Var_Tama			:= 0;					-- Tamanio de los destinatarios
	SET Var_SumaTam			:= 0;					-- Suma de tamanio de destinatarios junto al actual
	SET Var_FechaVencimiento:= Fecha_Vacia;			-- Asignacion
	SET Var_Asunto			:= 'TRANSACCION ARCHIVOS PROSA';	-- Asunto

	ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-DESTINATARIOSFTPPROSAPRO');
		END;


	IF (Par_NumProceso = NumPro_EnvioCorr) THEN
		-- Fecha sistema
		SELECT FechaSistema
		INTO Var_FechaSis
		FROM PARAMETROSSIS
		WHERE EmpresaID = Aud_EmpresaID;

		SET Var_FechaVencimiento := DATE_ADD(Var_FechaSis, INTERVAL 3 DAY);

		-- Se obtiene el mensaje y remitente
		SELECT UsuarioRemiten,	Mensaje
		INTO Var_Remitente,		Var_Mensaje
		FROM CONFIGFTPPROSA WHERE ConfigFTPProsaID = 1;

		SET Var_Remitente		:= IFNULL(Var_Remitente, Entero_Cero);
		SET Var_Mensaje			:= IFNULL(Var_Mensaje, Cadena_Vacia);

		-- Validacion para el cuerpo del Correo
		IF (Var_Remitente = Entero_Cero) THEN
			SET Par_NumErr:= 202;
			SET Par_ErrMen:= 'No existe Remitente, No se puede enviar el correo';
			LEAVE ManejoErrores;
		END IF;

		SELECT COUNT(*)
		INTO Var_MaxFilas
        FROM DESTINATARIOSFTPPROSA;

		-- Destinatarios
		IF (IFNULL(Var_MaxFilas, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr:= 203;
			SET Par_ErrMen:= 'No existe destinatarios';
			LEAVE ManejoErrores;
		END IF;

		-- Creamos tabla de destinatarios
		DROP TABLE IF EXISTS TMP_DESTINATARIOSFTPPROSA;
		CREATE TEMPORARY TABLE TMP_DESTINATARIOSFTPPROSA(
			NumDestina			BIGINT(20)	AUTO_INCREMENT,
			CorreoDestina		VARCHAR(500),
			PRIMARY KEY(NumDestina)
			-- INDEX(NumDestina)
		);

		-- Llenamos la tabla temporal
		INSERT INTO TMP_DESTINATARIOSFTPPROSA(CorreoDestina)
			SELECT	USU.Correo
				FROM DESTINATARIOSFTPPROSA DEST
			INNER JOIN USUARIOS USU ON DEST.Usuario = USU.UsuarioID;
			/*SELECT	USU.CorreoSalida
				FROM DESTINATARIOSFTPPROSA DEST
			INNER JOIN TARENVIOCORREOPARAM USU ON DEST.Usuario = USU.RemitenteID;*/


		-- Se valida la cantidad de correos
		SELECT COUNT(*)
		INTO Var_MaxFilas
		FROM TMP_DESTINATARIOSFTPPROSA;

		SET Var_MaxFilas := IFNULL(Var_MaxFilas,Entero_Cero);

		IF (Var_MaxFilas  = Entero_Cero) THEN
			SET Par_NumErr:= 201;
			SET Par_ErrMen:= 'No existen Destinatarios, No se puede enviar correo.';
			LEAVE ManejoErrores;
		END IF;

		-- Validacion para el cuerpo del Correo
		IF (Var_Mensaje = Cadena_Vacia) THEN
			SET Par_NumErr:= 203;
			SET Par_ErrMen:= 'Mensaje Vacio, No se puede enviar el correo.';
			LEAVE ManejoErrores;
		END IF;



		-- ----------------------------------------------------------
		--  Se inicia el ciclo para registrar correos
		-- ----------------------------------------------------------
		SET Var_PosFila := 1;
		SET Var_Destinatarios := Cadena_Vacia;

		WHILE Var_PosFila <= Var_MaxFilas DO
			CicloWhile:BEGIN
				SET Var_CorreoSalida := Cadena_Vacia;
				-- Validar la existencia de los destinatarios
				SELECT CorreoDestina
				INTO Var_CorreoSalida
				FROM TMP_DESTINATARIOSFTPPROSA
				WHERE NumDestina = Var_PosFila;

				IF (IFNULL(Var_CorreoSalida, Cadena_Vacia) !=  Cadena_Vacia) THEN
				-- IF EXISTS(SELECT CorreoDestina FROM TMP_DESTINATARIOSFTPPROSA) THEN

							SET Var_SumaTam  := LENGTH(Var_Destinatarios) + LENGTH(Var_CorreoSalida);
							-- Se valida el tamaño total
							IF(Var_SumaTam > Con_MaxCarac) THEN

								-- insertar destinatarios
								CALL TARENVIOCORREOALT(	Var_Remitente,		Var_Destinatarios,		Var_Asunto,		Var_Mensaje,		Entero_Cero,
														Var_FechaSis,		Var_FechaVencimiento,	Con_ProEjec,	Cadena_Vacia,		Cons_NO,
														Par_NumErr, 		Par_ErrMen,				Aud_EmpresaID,	Aud_Usuario,		Aud_FechaActual,
														Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,	Aud_NumTransaccion);

								SET Var_Destinatarios  := Cadena_Vacia;
								IF(Par_NumErr <> Entero_Cero) THEN
									SET Par_NumErr := 02;
									LEAVE ManejoErrores;
								END IF;

							END IF;

							IF (Var_MaxFilas > 1) THEN
								IF(Var_PosFila = 1) THEN
									SET Var_Destinatarios := Var_CorreoSalida;
								ELSE
									SET Var_Destinatarios 	:= CONCAT(Var_Destinatarios,',',Var_CorreoSalida);
								END IF;

							ELSE
								SET Var_Destinatarios := Var_CorreoSalida;
							END IF;

				END IF; -- Fin del exists
				SET Var_PosFila := Var_PosFila + 1; -- incremental while

			END CICLOWHILE; -- Fin ciclo while loop
		END WHILE;-- fin while

		SET Var_Tama := LENGTH(Var_Destinatarios);
		-- Registrar usuario para envio correo
		IF(Var_Tama <> Entero_Cero ) THEN
			CALL TARENVIOCORREOALT(	Var_Remitente,		Var_Destinatarios,		Var_Asunto,		Var_Mensaje,		Entero_Cero,
									Var_FechaSis,		Var_FechaVencimiento,	Con_ProEjec,	Cadena_Vacia,		Cons_NO,
									Par_NumErr, 		Par_ErrMen,				Aud_EmpresaID,	Aud_Usuario,		Aud_FechaActual,
									Aud_DireccionIP, 	Aud_ProgramaID,			Aud_Sucursal,	Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero) THEN
				SET Par_NumErr := 01;
				LEAVE ManejoErrores;
			END IF;

		END IF;

		IF (Par_NumErr = Entero_Cero) THEN
			SET Par_NumErr	:= 000;
			SET Par_ErrMen	:= 'Destinatarios de Correos Agregados Exitosamente.';
			LEAVE ManejoErrores;
		ELSE
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:= 'No se pudo al Enviar el Correo a los Destinatarios.';
			LEAVE ManejoErrores;
		END IF;

	END IF;
	END ManejoErrores;

		IF Par_Salida = Salida_SI THEN
				SELECT Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen;
		END IF;

END TerminaStore$$
