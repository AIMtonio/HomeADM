-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COMENTARIOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `COMENTARIOSALT`;DELIMITER $$

CREATE PROCEDURE `COMENTARIOSALT`(
    /*SP PARA ALMACENAR LOS COMENTARIOS DE LA SOLICITUD DE CREDITO*/
    Par_SolicitudCreditoID  BIGINT(20),    	-- Solicitud de Credito
	Par_Estatus				CHAR(2),
	Par_Fecha    			DATETIME,		-- Fecha de Comentario
    Par_Comentario       	VARCHAR(500), 	-- Comentario
    Par_Usuario				INT(11),     	-- Usuario que realiza el comentario
	Par_Salida          	CHAR(1),

    INOUT Par_NumErr    	INT(11),
    INOUT Par_ErrMen    	VARCHAR(400),
    /* Parametros de Auditoria */
	Par_EmpresaID       	INT(11),
    Aud_Usuario         	INT(11),
    Aud_FechaActual     	DATETIME,
    Aud_DireccionIP     	VARCHAR(15),
    Aud_ProgramaID      	VARCHAR(50),
    Aud_Sucursal       	 	INT(11),
    Aud_NumTransaccion  	BIGINT(20)
    		)
TerminaStore: BEGIN

    # Declaracion de variables
	DECLARE Var_ComentarioID 	INT(11);
    DECLARE VarControl 			VARCHAR(15);
	DECLARE Var_FechaInicial	DATETIME;
    DECLARE Var_FechaFinal		DATETIME;
    DECLARE Var_FechaICond		DATETIME;
    DECLARE Var_FechaIAct		DATETIME;
    DECLARE Var_NumRegistros	INT(11);
    DECLARE Var_NombreUsuario	VARCHAR(150);
    DECLARE Var_NumSolicitud	INT(11);

    # Declaracion de constantes
    DECLARE Entero_Cero         INT(11);
    DECLARE Decimal_Cero        DECIMAL(14,2);
    DECLARE Cadena_Vacia        CHAR(1);
    DECLARE Fecha_Vacia         DATE;

    DECLARE Est_RegistraSol		CHAR(2);
    DECLARE Est_LiberaSol		CHAR(2);
    DECLARE Est_RechazaSol		CHAR(2);
    DECLARE Est_AutorizaSol		CHAR(2);
    DECLARE Est_ActualizaSol	CHAR(2);
    DECLARE Est_RegistraCre		CHAR(2);
    DECLARE Est_CondicionaCre	CHAR(2);
    DECLARE Est_AutorizaCre		CHAR(2);
    DECLARE Est_DesemCre		CHAR(2);


	DECLARE SalidaSI			CHAR(1);
    DECLARE SalidaNO			CHAR(1);

    # Asignacion de Constantes
    SET Entero_Cero             := 0;               # Constante entero cero
    SET Decimal_Cero            := 0.0;             # Constante DECIMAL cero
    SET Fecha_Vacia             := '1900-01-01';    # Constante fecha vacia
    SET Cadena_Vacia            := '';              # Constante cadena vacia


    SET Est_RegistraSol			:= 'SI';
    SET Est_LiberaSol			:= 'SL';
    SET Est_RechazaSol			:= 'SR';
    SET Est_AutorizaSol			:= 'SA';
    SET Est_ActualizaSol		:= 'SM';
    SET Est_RegistraCre			:= 'CI';
    SET Est_CondicionaCre		:= 'CC';
    SET Est_AutorizaCre			:= 'CA';
    SET Est_DesemCre			:= 'CD';


    SET SalidaSI            	:= 'S';
	SET SalidaNO            	:= 'N';



    SET Var_ComentarioID		:= (SELECT IFNULL(MAX(ComentarioID),Entero_Cero) + 1
									FROM COMENTARIOSSOL);

	SET Var_NumSolicitud 		:= (SELECT COUNT(SolicitudCreditoID) FROM SOLICITUDCREDITO
									WHERE SolicitudCreditoID = Par_SolicitudCreditoID);

    SET	Par_SolicitudCreditoID	:= IFNULL(Par_SolicitudCreditoID, Entero_Cero);
    SET	Par_Fecha 				:= IFNULL(CONCAT(DATE(Par_Fecha)," ",CURRENT_TIME), Fecha_Vacia);
    SET	Var_ComentarioID 		:= IFNULL(Var_ComentarioID, Cadena_Vacia);
    SET	Par_Usuario 			:= IFNULL(Par_Usuario, Entero_Cero);
    SET Aud_FechaActual 		:= CURRENT_TIMESTAMP();
	SET	Var_NumSolicitud 		:= IFNULL(Var_NumSolicitud, Entero_Cero);


	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que  ',
					' esto le ocasiona. Ref: SP-COMENTARIOSALT');
				SET VarControl = 'SQLEXCEPTION' ;
			END;

			-- Se inserta el comentario

			INSERT INTO COMENTARIOSSOL	(
				ComentarioID,		SolicitudCreditoID,		Estatus,		Fecha,			Comentario,
                UsuarioOperacion,	EmpresaID,         		Usuario,		FechaActual,	DireccionIP,
                ProgramaID,			Sucursal,           	NumTransaccion)
			VALUES (
				Var_ComentarioID,	Par_SolicitudCreditoID,	Par_Estatus,	Par_Fecha,		Par_Comentario,
                Par_Usuario,		Par_EmpresaID,      	Aud_Usuario,	Aud_FechaActual,Aud_DireccionIP,
                Aud_ProgramaID,		Aud_Sucursal,    		Aud_NumTransaccion  );

			-- Se actualiza el campo Comentario Ejecutivo cuando se registra la Solicitud
			IF(Par_Estatus = Est_RegistraSol) THEN
				SELECT NombreCompleto INTO Var_NombreUsuario
					FROM USUARIOS
					WHERE UsuarioID = Par_Usuario;

				 UPDATE SOLICITUDCREDITO
					SET ComentarioEjecutivo = CONCAT(CASE WHEN IFNULL(ComentarioEjecutivo, Cadena_Vacia) = Cadena_Vacia
														THEN Cadena_Vacia
														ELSE " " END,"--> ", CAST(NOW() AS CHAR)," -- ",Var_NombreUsuario," ----- ",  LTRIM(RTRIM(Par_Comentario)),
																" ", LTRIM(RTRIM(IFNULL(ComentarioEjecutivo, Cadena_Vacia)))  )
				WHERE SolicitudCreditoID = Par_SolicitudCreditoID;
				SET Par_NumErr := Entero_Cero;
			END IF;

			-- tiempo en estatus Inactivo Solicitud de Credito
			IF(Par_Estatus = Est_LiberaSol) THEN
				SET Var_FechaIAct:= (SELECT MAX(Fecha)
										FROM COMENTARIOSSOL
										WHERE SolicitudCreditoID = Par_SolicitudCreditoID
										AND Estatus = Est_ActualizaSol);

				-- Se obtiene la Fecha de Registro de Solicitud la cual sera la Fecha Inicial
				SET Var_FechaIAct := IFNULL(Var_FechaIAct, Fecha_Vacia);

				IF(Var_FechaIAct!= Fecha_Vacia) THEN
					SET Var_FechaInicial := Var_FechaIAct;

					UPDATE COMENTARIOSSOL
					SET	TiempoEstatus = (DATEDIFF(Par_Fecha, Var_FechaInicial))
					WHERE SolicitudCreditoID = Par_SolicitudCreditoID
					AND Estatus = Est_ActualizaSol
					AND Fecha = Var_FechaInicial;
				ELSE
					SET Var_FechaInicial := (SELECT MIN(Fecha)
											FROM COMENTARIOSSOL
											WHERE SolicitudCreditoID = Par_SolicitudCreditoID
											AND Estatus = Est_RegistraSol);

					UPDATE COMENTARIOSSOL
					SET	TiempoEstatus = (DATEDIFF(Par_Fecha, Var_FechaInicial))
					WHERE SolicitudCreditoID = Par_SolicitudCreditoID
					AND Estatus = Est_RegistraSol
					AND Fecha = Var_FechaInicial;
				END IF;
				SET Par_NumErr := Entero_Cero;
			END IF;

        IF(Par_Estatus = Est_ActualizaSol) THEN
			-- Se obtiene la Fecha de Registro de Solicitud la cual sera la Fecha Inicial
            SET Var_FechaInicial := (SELECT MAX(Fecha)
										FROM COMENTARIOSSOL
										WHERE SolicitudCreditoID = Par_SolicitudCreditoID
										 AND Estatus = Est_LiberaSol);


			UPDATE COMENTARIOSSOL
            SET	TiempoEstatus = (DATEDIFF(Par_Fecha, Var_FechaInicial))
            WHERE SolicitudCreditoID = Par_SolicitudCreditoID
            AND Estatus = Est_LiberaSol;

            SET Par_NumErr := Entero_Cero;
		END IF;

        -- Tiempo en estatus Liberado Solicitud de Credito
        IF(Par_Estatus = Est_AutorizaSol) THEN
			-- Se obtiene la Fecha de Registro de Solicitud la cual sera la Fecha Inicial
            SET Var_FechaInicial := (SELECT MIN(Fecha)
										FROM COMENTARIOSSOL
										WHERE SolicitudCreditoID = Par_SolicitudCreditoID
										 AND Estatus = Est_LiberaSol);


			UPDATE COMENTARIOSSOL
            SET	TiempoEstatus = (DATEDIFF(Par_Fecha, Var_FechaInicial))
            WHERE SolicitudCreditoID = Par_SolicitudCreditoID
            AND Estatus = Est_LiberaSol;

           SET Par_NumErr := Entero_Cero;
		END IF;

        -- Tiempo en Estatus Autorizado Solicitud

        IF(Par_Estatus = Est_RegistraCre) THEN
				SELECT NombreCompleto INTO Var_NombreUsuario
					FROM USUARIOS
					WHERE UsuarioID = Par_Usuario;

			-- Se actualiza comentario Mesa de Control
			IF(Var_NumSolicitud > Entero_Cero) THEN
				UPDATE SOLICITUDCREDITO SET
					ComentarioMesaControl	= CASE WHEN IFNULL(Par_Comentario,Cadena_Vacia)!=Cadena_Vacia
						THEN
							CONCAT("--> ", CAST(NOW() AS CHAR)," -- ", Var_NombreUsuario," ----- ",
							LTRIM(RTRIM(Par_Comentario)), " ",
							LTRIM(RTRIM(IFNULL(ComentarioMesaControl, Cadena_Vacia))) )
						ELSE
                        ComentarioMesaControl

					END
					WHERE SolicitudCreditoID  = Par_SolicitudCreditoID;
			ELSE
				UPDATE SOLICITUDESCERO SET
					ComentarioMesaControl	= CASE WHEN IFNULL(Par_Comentario,Cadena_Vacia)!=Cadena_Vacia
						THEN
							CONCAT("--> ", CAST(NOW() AS CHAR)," -- ", NombreCompleto," ----- ",
							LTRIM(RTRIM(Par_Comentario)), " ",
							LTRIM(RTRIM(IFNULL(ComentarioMesaControl, Cadena_Vacia))) )
						ELSE
						ComentarioMesaControl
					END
					WHERE CreditoID  = Par_SolicitudCreditoID;
			END IF;

			-- Se obtiene la Fecha de Registro de Solicitud la cual sera la Fecha Inicial
			SET Var_FechaICond:= (SELECT MAX(Fecha)
									FROM COMENTARIOSSOL
									WHERE SolicitudCreditoID = Par_SolicitudCreditoID
									AND Estatus = Est_CondicionaCre);
			IF(IFNULL(Var_FechaICond,Fecha_Vacia)!= Fecha_Vacia) THEN
				SET Var_FechaInicial := Var_FechaICond;

                UPDATE COMENTARIOSSOL
				SET	TiempoEstatus = (DATEDIFF(Par_Fecha, Var_FechaInicial))
				WHERE SolicitudCreditoID = Par_SolicitudCreditoID
				AND Estatus = Est_CondicionaCre
                AND Fecha = Var_FechaInicial;
			ELSE
				SET Var_FechaInicial := (SELECT MAX(Fecha )
										FROM COMENTARIOSSOL
										WHERE SolicitudCreditoID = Par_SolicitudCreditoID
										 AND Estatus = Est_AutorizaSol);
				UPDATE COMENTARIOSSOL
				SET	TiempoEstatus = (DATEDIFF(Par_Fecha, Var_FechaInicial))
				WHERE SolicitudCreditoID = Par_SolicitudCreditoID
				AND Estatus = Est_AutorizaSol
				AND Fecha = Var_FechaInicial;
            END IF;
			SET Par_NumErr := Entero_Cero;
		END IF;

         -- Tiempo en Estatus Inactivo Credito
        IF(Par_Estatus = Est_AutorizaCre) THEN

			SELECT NombreCompleto INTO Var_NombreUsuario
				FROM USUARIOS
				WHERE UsuarioID = Par_Usuario;

			-- Se actualiza comentario Mesa de Control
			IF(Var_NumSolicitud > Entero_Cero) THEN
				UPDATE SOLICITUDCREDITO SET
					ComentarioMesaControl	= CASE WHEN IFNULL(Par_Comentario,Cadena_Vacia)!=Cadena_Vacia
						THEN
							CONCAT("--> ", CAST(NOW() AS CHAR)," -- ", Var_NombreUsuario," ----- ",
							LTRIM(RTRIM(Par_Comentario)), " ",
							LTRIM(RTRIM(IFNULL(ComentarioMesaControl, Cadena_Vacia))) )
						ELSE
						ComentarioMesaControl
					END
					WHERE SolicitudCreditoID  = Par_SolicitudCreditoID;
			ELSE
				UPDATE SOLICITUDESCERO SET
					ComentarioMesaControl	= CASE WHEN IFNULL(Par_Comentario,Cadena_Vacia)!=Cadena_Vacia
						THEN
							CONCAT("--> ", CAST(NOW() AS CHAR)," -- ", Var_NombreUsuario," ----- ",
							LTRIM(RTRIM(Par_Comentario)), " ",
							LTRIM(RTRIM(IFNULL(ComentarioMesaControl, Cadena_Vacia))) )
						ELSE
						ComentarioMesaControl
					END
					WHERE CreditoID  = Par_SolicitudCreditoID;
			END IF;

			SET Var_NumRegistros := (SELECT COUNT(Estatus)
									 FROM COMENTARIOSSOL
									 WHERE SolicitudCreditoID = Par_SolicitudCreditoID
                                     AND Estatus = Est_CondicionaCre);
			IF(Var_NumRegistros = Entero_Cero) THEN
				-- Se obtiene la Fecha de Registro del Credito
				SET Var_FechaInicial := (SELECT Fecha
											FROM COMENTARIOSSOL
											WHERE SolicitudCreditoID = Par_SolicitudCreditoID
											 AND Estatus = Est_RegistraCre);


				UPDATE COMENTARIOSSOL
				SET	TiempoEstatus = (DATEDIFF(Par_Fecha, Var_FechaInicial))
				WHERE SolicitudCreditoID = Par_SolicitudCreditoID
				AND Estatus = Est_RegistraCre;
			ELSE
				SET Var_FechaInicial := (SELECT MAX(Fecha )
												FROM COMENTARIOSSOL
												WHERE SolicitudCreditoID = Par_SolicitudCreditoID
												 AND Estatus = Est_RegistraCre);


				UPDATE COMENTARIOSSOL
				SET	TiempoEstatus = (DATEDIFF(Par_Fecha, Var_FechaInicial))
				WHERE SolicitudCreditoID = Par_SolicitudCreditoID
				AND Estatus = Est_RegistraCre
                AND Fecha = Var_FechaInicial;
			END IF;
			SET Par_NumErr := Entero_Cero;
		END IF;

         -- Tiempo en Estatus Condicionado Credito
        IF(Par_Estatus = Est_CondicionaCre) THEN
			-- Se obtiene la Fecha de Registro del Credito
            SET Var_FechaInicial := (SELECT MAX(Fecha)
										FROM COMENTARIOSSOL
										WHERE SolicitudCreditoID = Par_SolicitudCreditoID
										 AND Estatus = Est_RegistraCre);

			UPDATE COMENTARIOSSOL
            SET	TiempoEstatus = (DATEDIFF(Par_Fecha, Var_FechaInicial))
            WHERE SolicitudCreditoID = Par_SolicitudCreditoID
            AND Estatus = Est_RegistraCre;

			SET Par_NumErr := Entero_Cero;
		END IF;

         -- Tiempo en Estatus Autorizado Credito
        IF(Par_Estatus = Est_DesemCre) THEN

			SELECT NombreCompleto INTO Var_NombreUsuario
				FROM USUARIOS
				WHERE UsuarioID = Par_Usuario;

			-- Se actualiza comentario Mesa de Control
			SET Var_FechaInicial := (SELECT MAX(Fecha)
											FROM COMENTARIOSSOL
											WHERE SolicitudCreditoID = Par_SolicitudCreditoID
											AND Estatus = Est_AutorizaCre);
			IF(Var_NumSolicitud > Entero_Cero) THEN
				UPDATE SOLICITUDCREDITO SET
						ComentarioMesaControl	= CASE WHEN IFNULL(Par_Comentario,Cadena_Vacia)!=Cadena_Vacia
							THEN
								CONCAT("--> ", CAST(NOW() AS CHAR)," -- ", Var_NombreUsuario," ----- ",
								LTRIM(RTRIM(Par_Comentario)), " ",
								LTRIM(RTRIM(IFNULL(ComentarioMesaControl, Cadena_Vacia))) )
							ELSE
								ComentarioMesaControl
							END
							WHERE SolicitudCreditoID  = Par_SolicitudCreditoID;
						ELSE
							UPDATE SOLICITUDESCERO SET
								ComentarioMesaControl	= CASE WHEN IFNULL(Par_Comentario,Cadena_Vacia)!=Cadena_Vacia
									THEN
										CONCAT("--> ", CAST(NOW() AS CHAR)," -- ", Var_NombreUsuario," ----- ",
										LTRIM(RTRIM(Par_Comentario)), " ",
										LTRIM(RTRIM(IFNULL(ComentarioMesaControl, Cadena_Vacia))) )
									ELSE
									ComentarioMesaControl
							END
							WHERE CreditoID  = Par_SolicitudCreditoID;
						END IF;

			UPDATE COMENTARIOSSOL
            SET	TiempoEstatus = (DATEDIFF(Par_Fecha, Var_FechaInicial))
            WHERE SolicitudCreditoID = Par_SolicitudCreditoID
            AND Estatus = Est_AutorizaCre;

			SET Par_NumErr := Entero_Cero;
		END IF;

		SET Par_NumErr  := 000;
		SET Par_ErrMen  := CONCAT('Comentario Agregado Exitosamente');
		SET VarControl	:= '';

	END ManejoErrores;
	IF (Par_Salida = SalidaSI) THEN
		SELECT Par_NumErr AS NumErr,
		Par_ErrMen AS ErrMen,
		VarControl AS control,
		Entero_Cero AS consecutivo;
	END IF;

END TerminaStore$$