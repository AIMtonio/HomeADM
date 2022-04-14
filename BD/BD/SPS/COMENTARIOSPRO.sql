-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COMENTARIOSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `COMENTARIOSPRO`;
DELIMITER $$


CREATE PROCEDURE `COMENTARIOSPRO`(
    /*SP QUE CONDICIONA LOS CREDITOS */
    Par_CreditoID			BIGINT(12),
    Par_Comentario     		VARCHAR(500),
    Par_Condicionado 		CHAR(1),
    Par_Usuario				INT(11),

    Par_Salida          	CHAR(1),
    INOUT Par_NumErr    	INT(11),
    INOUT Par_ErrMen    	VARCHAR(400),

    -- Parametros de Auditoria --
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
    DECLARE Var_SolicitudCreditoID 	BIGINT(12);
    DECLARE Var_Estatus				CHAR(1);
    DECLARE Var_ComentarioID		INT(11);
    DECLARE Var_FechaSis			DATETIME;
	DECLARE VarControl 				VARCHAR(15);

    # Declaracion de constantes
    DECLARE Entero_Cero             INT;
    DECLARE Decimal_Cero            DECIMAL(12,2);
    DECLARE Cadena_Vacia            CHAR(1);
    DECLARE Fecha_Vacia             DATE;
    DECLARE Act_Condiciona			INT(11);
    DECLARE Act_Cancela				INT(11);
    DECLARE Est_Condicionado		CHAR(1);
    DECLARE Est_Inactivo			CHAR(1);
    DECLARE SalidaSI				CHAR(1);
    DECLARE SalidaNO				CHAR(1);
    DECLARE Est_Cancelado			CHAR(1);
    DECLARE Act_AltaCom				CHAR(1);
    DECLARE TipoCancelaCre     		INT(11);
    DECLARE Est_Condiciona			CHAR(2);
    DECLARE Est_Cancela				INT(11);

    # Asignacion de Constantes
    SET Entero_Cero             := 0;               # Constante entero cero
    SET Decimal_Cero            := 0.0;             # Constante decimal cero
    SET Fecha_Vacia             := '1900-01-01';	# Constante fecha vacia
    SET Cadena_Vacia            := '';              # Constante cadena vacia
	SET Act_Condiciona			:= 31;				# Condiciona el Credito
    SET Act_AltaCom				:= 5;				# Alta del Comentario de la Solicitud de Credito
    SET Est_Condicionado		:= 'S';				# Estatus condicionado
    SET Est_Inactivo			:= 'I';				# Estatus Inactivo
    SET SalidaSI            	:= 'S';
	SET SalidaNO            	:= 'N';
    SET Est_Condiciona			:= 'CC';

    SET Var_FechaSis		:= (SELECT FechaSistema FROM PARAMETROSSIS);
    SET Par_Comentario		:=	IFNULL(Par_Comentario, Cadena_Vacia) ;
    SET	Par_Condicionado	:=	IFNULL(Par_Condicionado, Entero_Cero);

    ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que  ',
					' esto le ocasiona. Ref: SP-COMENTARIOSPRO');
				SET VarControl = 'sqlException' ;
			END;

			SET Var_SolicitudCreditoID := (SELECT SolicitudCreditoID FROM CREDITOS WHERE CreditoID = Par_CreditoID);

			IF(Var_SolicitudCreditoID != Entero_Cero) THEN

				IF(Par_Condicionado = Est_Condicionado) THEN
					UPDATE SOLICITUDCREDITO SET
						Condicionada	 		= Est_Condicionado,
						ComentarioMesaControl	= CASE WHEN Par_Comentario!=Cadena_Vacia
														THEN
															 CONCAT("--> ", CAST(NOW() AS CHAR)," -- ", Par_Usuario," ----- ",
															 LTRIM(RTRIM(Par_Comentario)), " ",
															 LTRIM(RTRIM(IFNULL(ComentarioMesaControl, Cadena_Vacia))) )
														ELSE
														Cadena_Vacia
												   END
							WHERE SolicitudCreditoID  = Var_SolicitudCreditoID;

					SET Var_ComentarioID	:= (SELECT IFNULL(MAX(ComentarioID),Entero_Cero) + 1 FROM COMENTARIOSSOL);

					CALL COMENTARIOSALT (
					Var_SolicitudCreditoID,	Est_Condiciona,	Var_FechaSis,	Par_Comentario,	Par_Usuario,
					SalidaNO,				Par_NumErr,		Par_ErrMen,		Par_EmpresaID,	Aud_Usuario,
					Aud_FechaActual,		Aud_DireccionIP,Aud_ProgramaID,	Aud_Sucursal,   Aud_NumTransaccion  );

                    IF(Par_NumErr <> Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;
					
					# Actualizar estatus de la solicitud de credito
					CALL ESTATUSSOLCREDITOSALT(
					Var_SolicitudCreditoID,    Par_CreditoID,        Est_Condicionado,          Cadena_Vacia,             Cadena_Vacia,
					SalidaNO, 			       Par_NumErr,           Par_ErrMen,                Par_EmpresaID,            Aud_Usuario,        
					Aud_FechaActual,           Aud_DireccionIP,      Aud_ProgramaID,            Aud_Sucursal,             Aud_NumTransaccion);	

					IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
					END IF;	

				END IF;
			ELSE
				IF(Par_Condicionado = Est_Condicionado) THEN

					UPDATE SOLICITUDESCERO SET
						Condicionada			= Est_Condicionado,
						ComentarioMesaControl	= CASE WHEN Par_Comentario!=Cadena_Vacia
													THEN
														CONCAT("--> ", CAST(NOW() AS CHAR)," -- ", Par_Usuario," ----- ",
														LTRIM(RTRIM(Par_Comentario)), " ",
														LTRIM(RTRIM(IFNULL(ComentarioMesaControl, Cadena_Vacia))) )
													ELSE
														Cadena_Vacia
													END
					WHERE CreditoID  = Par_CreditoID;

					SET Var_ComentarioID	:= (SELECT IFNULL(MAX(ComentarioID),Entero_Cero) + 1 FROM COMENTARIOSSOL);

					CALL COMENTARIOSALT (
						Par_CreditoID,		Est_Condiciona,	Var_FechaSis,	Par_Comentario,	Par_Usuario,
						SalidaNO,				Par_NumErr,		Par_ErrMen,		Par_EmpresaID,	Aud_Usuario,
						Aud_FechaActual,		Aud_DireccionIP,Aud_ProgramaID,	Aud_Sucursal,   Aud_NumTransaccion  );

					IF(Par_NumErr <> Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;

						# Actualizar estatus de la solicitud de credito
					CALL ESTATUSSOLCREDITOSALT(
					Var_SolicitudCreditoID,    Par_CreditoID,        Est_Condicionado,          Cadena_Vacia,             Cadena_Vacia,
					SalidaNO, 			       Par_NumErr,           Par_ErrMen,                Par_EmpresaID,            Aud_Usuario,        
					Aud_FechaActual,           Aud_DireccionIP,      Aud_ProgramaID,            Aud_Sucursal,             Aud_NumTransaccion);	

					IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
					END IF;	

				END IF;
			END IF;
			SET Par_NumErr  := 000;
			SET Par_ErrMen  :='El Credito se ha Condicionado';
			SET VarControl	:= 'creditoID';

	END ManejoErrores; #Fin del Manejador de Errores

	IF (Par_Salida = SalidaSI) THEN
		SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen	AS ErrMen,
				VarControl	AS control,
				Entero_Cero	AS consecutivo;
	END IF;


END TerminaStore$$