-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RIESGOCOMUNCLICREACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `RIESGOCOMUNCLICREACT`;DELIMITER $$

CREATE PROCEDURE `RIESGOCOMUNCLICREACT`(

# =====================================================================================
# ------- STORED PARA LA ACTUALIZACION DEL COMENTARIO Y SI LA SOLICITUD PRESENTA RIESGO ---------
# =====================================================================================
    Par_SolicitudCreditoID	BIGINT(20), 	-- Numero de Solicitud de Credito
    Par_CreditoID			BIGINT(12), 	-- Numero de Credito con el que tiene relacion
    Par_ClienteID			INT(11), 		-- Numero del Cliente con el que tiene relacion
    Par_RiesgoComun 		CHAR(1), 		-- Es Riesgo Comun S:SI  N:NO
    Par_Comentario			VARCHAR(520), 	-- Comentario

    Par_Procesado			CHAR(1),		-- Indica si la solicitud ya se proceso
    Par_ComentarioMonitor	VARCHAR(520), 	-- Comentario del Monitor de Riesgos
    Par_Estatus				CHAR(1),		-- Estatus de la solicitud relacionada
    Par_Clave				INT(11),
    Par_ConsecutivoID		INT(11),		-- Numero de Consecutivo
    Par_NumAct  			TINYINT UNSIGNED,	-- Tipo de Actualizacion


    Par_Salida    			CHAR(1),		-- Parametro de salida S= si, N= no
    INOUT Par_NumErr 		INT(11),		-- Parametro de salida numero de error
    INOUT Par_ErrMen  		VARCHAR(400),	-- Parametro de salida mensaje de error

	-- Parametros de Auditoria
    Par_EmpresaID       	INT(11),		-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),		-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,		-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),		-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
    DECLARE Var_Consecutivo		VARCHAR(100);   	-- Variable consecutivo
	DECLARE Var_Control         VARCHAR(100);   	-- Variable de Control
    DECLARE Var_FechaSistema	DATE;
    DECLARE Var_FechaRegistro	DATE;
    DECLARE Var_Estatus			CHAR(1);			-- Estatus Procesado
    DECLARE Var_Comentario		TEXT;
    DECLARE Var_Cliente         INT(11);
    DECLARE Var_Excedente       CHAR(1);


    -- DECLARACION DE CONSTANTES

	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- DECIMAL cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI
    DECLARE Act_Riesgo			INT(11);			-- Actualiza si la solicitud presenta riesgo
    DECLARE Act_Procesado		INT(11);			-- Actualiza si una solicitud ya fue procesada

	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO
    DECLARE Cons_SI 			CHAR(1);
    DECLARE Cons_NO 			CHAR(1);
    DECLARE Est_Revisado		CHAR(1);

    -- ASIGNACION DE CONSTANTES

	SET Cadena_Vacia        	:= '';				-- Constante Cadena Vacia
	SET Fecha_Vacia         	:= '1900-01-01';	-- Constante Fecha Vacia
	SET Entero_Cero         	:= 0;  				-- Constante Cero
	SET Decimal_Cero			:= 0.0;				-- Constate Decimal 0.00
	SET Salida_SI          		:= 'S';				-- Constante Salida SI

	SET Salida_NO           	:= 'N';				-- Constante Salida NO
	SET Cons_SI 				:= 'S';				-- Constante SI
	SET Cons_NO 				:= 'N';				-- Constante NO
    SET Act_Riesgo				:= 1;				-- Actualizacion Es Riesgo

    SET Act_Procesado			:= 2;				-- Actualizacion Procesado(Monitor Riesgo)
    SET Est_Revisado			:= 'R';				-- Estatus Revisado


	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-RIESGOCOMUNCLICREACT');
			SET Var_Control := 'SQLEXCEPTION';
		END;


		SET Aud_FechaActual := NOW();

        # ACTUALIZA SI UNA SOLICITUD PRESENTA RIESGO O NO Y ACTUALIZA EL COMENTARIO
		IF(Par_NumAct = Act_Riesgo) THEN

			SET Var_Comentario := (SELECT Comentario FROM RIESGOCOMUNCLICRE
									WHERE SolicitudCreditoID = Par_SolicitudCreditoID
									AND CreditoID = Par_CreditoID
									AND ClienteID = Par_ClienteID
									AND ConsecutivoID = Par_ConsecutivoID);
			SET Var_Comentario := IFNULL(Var_Comentario, Cadena_Vacia);

			IF( IFNULL(Par_Comentario, Cadena_Vacia) <> Cadena_Vacia)THEN
				SET Var_Comentario := CONCAT("--> ",LTRIM(RTRIM(IFNULL(Par_Comentario, Cadena_Vacia)))," ",Var_Comentario);
			END IF;

			IF(LENGTH(Var_Comentario)>500)THEN
				SET Par_NumErr 		:= 01;
				SET Par_ErrMen 		:= CONCAT('Los comentarios han exedido el limite permitido' );
				SET Var_Control		:= 'GridMonitor';
				LEAVE ManejoErrores;
			END IF;

			UPDATE RIESGOCOMUNCLICRE SET
				RiesgoComun			= Par_RiesgoComun,
				Comentario 			= Var_Comentario,
				EmpresaID			= Par_EmpresaID,
				Usuario				= Aud_Usuario,
				FechaActual			= Aud_FechaActual,
				DireccionIP			= Aud_DireccionIP,
				ProgramaID			= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion
			WHERE SolicitudCreditoID = Par_SolicitudCreditoID
			AND CreditoID = Par_CreditoID
			AND ClienteID = Par_ClienteID
            AND ConsecutivoID = Par_ConsecutivoID;

			SET Var_FechaSistema :=(SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);

			SET Par_NumErr 		:= 0;
			SET Par_ErrMen 		:= CONCAT('Riesgo Modificado Exitosamente' );
			SET Var_Control		:= 'solicitudCreditoID';

		END IF;

    # ACTUALIZA SI UNA SOLICITUD PRESENTA RIESGO O NO Y ACTUALIZA SU COMENTARIO (Monitor de Riesgo Comun)
     IF(Par_NumAct = Act_Procesado) THEN

		IF(Par_Procesado = Cons_SI) THEN

			SET Var_Estatus := Est_Revisado;

        ELSE
			SET Var_Estatus := Par_Estatus;

            END IF;

			IF( IFNULL(Par_ComentarioMonitor, Cadena_Vacia) <> Cadena_Vacia)THEN
				SET Var_Comentario := CONCAT("--> ",LTRIM(RTRIM(IFNULL(Par_ComentarioMonitor, Cadena_Vacia)))," ",Par_Comentario);
			ELSE
				SET Var_Comentario := LTRIM(RTRIM(IFNULL(Par_Comentario, Cadena_Vacia)));
			END IF;

			IF(LENGTH(Var_Comentario)>500)THEN
				SET Par_NumErr 		:= 01;
				SET Par_ErrMen 		:= CONCAT('Los comentarios han exedido el limite permitido' );
				SET Var_Control		:= 'GridMonitor';
				LEAVE ManejoErrores;
			END IF;

        UPDATE RIESGOCOMUNCLICRE SET
			RiesgoComun			= Par_RiesgoComun,
			Comentario			= Var_Comentario,
			Procesado			= Par_Procesado,
            Estatus 			= Var_Estatus,
            Clave				= Par_Clave,

			EmpresaID			= Par_EmpresaID,
            Usuario				= Aud_Usuario,
            FechaActual			= Aud_FechaActual,
            DireccionIP			= Aud_DireccionIP,
            ProgramaID			= Aud_ProgramaID,
			Sucursal			= Aud_Sucursal,
            NumTransaccion		= Aud_NumTransaccion
        WHERE SolicitudCreditoID = Par_SolicitudCreditoID
        AND CreditoID = Par_CreditoID
        AND
			CASE WHEN ClienteIDSolicitud = Entero_Cero
				THEN ProspectoID = Par_ClienteID
            ELSE
				ClienteIDSolicitud  = Par_ClienteID
            END
        AND ConsecutivoID = Par_ConsecutivoID;

		SET Var_FechaSistema :=(SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);


		SET Par_NumErr 		:= 0;
		SET Par_ErrMen 		:= CONCAT('Solicitud Procesada Exitosamente' );
        SET Var_Control		:= 'GridMonitor';

	END IF;

    SET Var_Cliente := (SELECT ClienteID  FROM CREDITOS WHERE CreditoID = Par_CreditoID);
    SET Var_Excedente := (SELECT Procesado FROM RIESGOCOMUNCLICRE
                             WHERE SolicitudCreditoID = Par_SolicitudCreditoID AND CreditoID = Par_CreditoID
                                    AND Procesado = Cons_SI AND RiesgoComun = Cons_SI AND Estatus = 'R' AND ConsecutivoID = Par_ConsecutivoID);
	SET Var_Excedente := IFNULL(Var_Excedente,Cons_NO);

   IF(Var_Excedente = Cons_SI) THEN
        CALL EXCEDENTERIESGOCOMUNPRO (Par_ClienteID,        Par_CreditoID,      Salida_NO,          Par_NumErr,         Par_ErrMen,
                                        Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                                        Aud_Sucursal,       Aud_NumTransaccion);

    		IF (Par_NumErr!=Entero_Cero) THEN
          LEAVE ManejoErrores;
        END IF;
    END IF;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT
			Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;

	END IF;

END TerminaStore$$