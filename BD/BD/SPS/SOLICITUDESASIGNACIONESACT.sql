-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICITUDESASIGNACIONESACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLICITUDESASIGNACIONESACT`;
DELIMITER $$


CREATE PROCEDURE `SOLICITUDESASIGNACIONESACT`(
# ======================================================
# ------- STORE PARA ACTUALIZACION DE ESTATUS DE SOLICITUDES DE CREDITOS ASIGNADOS A ANALISTAS----------
# ======================================================
	Par_SolicitudCreditoID   BIGINT(12),		-- Numero de solictud de credito
	Par_Estatus              CHAR(1),  			-- Numero de transaccion del simulador
    Par_NumAct               INT(11),           -- Numero de actualizacion

	Par_Salida          CHAR(1),			    -- Salida S:SI  N:NO

	INOUT Par_NumErr    INT(11),			-- Numero de Error
	INOUT Par_ErrMen    VARCHAR(400),		-- Mensaje de Error
		-- Parametros de Auditoria
    Par_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
    Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
    Aud_FechaActual			DATETIME,		-- Parametro de auditoria Feha actual
    Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
    Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
    Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)

TerminaStore: BEGIN
	/* Declaracion de Constantes */
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Entero_Cero				INT;
	DECLARE Estatus_Asignada	    CHAR(1);
	DECLARE Estatus_EnRevision		CHAR(1);
    DECLARE Estatus_NoAsignada		CHAR(1);
    DECLARE Act_Estatus     		INT(11);
    DECLARE SalidaSI                CHAR(1);
	DECLARE SalidaNO                CHAR(1);
	



    DECLARE Var_solicitudID         BIGINT(12);
    DECLARE Var_Control              VARCHAR(50);

	/* Asignacion de Constantes */
	SET Cadena_Vacia        		:= '';
	SET Entero_Cero         		:= 0;
	SET Estatus_Asignada  		    := 'G';
    SET Estatus_EnRevision  		:= 'E';
	SET Estatus_NoAsignada    		:= 'N';
    SET SalidaSI                    := 'S';             # Constante salida si
    SET SalidaNO                    := 'N';             # Constante salida no



	SET Act_Estatus         		:= 1;  -- Tipo Actualizacion: Autorizacion del estatus de la solicitud de credito

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al
										concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-SOLICITUDESASIGNACIONESACT');
				SET Var_Control := 'SQLEXCEPTION' ;
			END;




        IF(IFNULL(Par_Estatus,Cadena_Vacia)= Cadena_Vacia ) THEN
			SET Par_NumErr  := Entero_Cero;
			SET Par_ErrMen  := 'Modificacion exitosa';
			SET Var_Control	:= 'estatus';
			LEAVE ManejoErrores;
		END IF;

       IF(Par_Estatus = Estatus_NoAsignada ) THEN
			SET Par_NumErr  := Entero_Cero;
			SET Par_ErrMen  := 'Modificacion exitosa';
			SET Var_Control	:= 'estatus';
			LEAVE ManejoErrores;
		END IF;

		SET Var_solicitudID:= (SELECT SolicitudCreditoID FROM SOLICITUDESASIGNADAS WHERE SolicitudCreditoID=Par_SolicitudCreditoID);
       
        IF(IFNULL(Var_SolicitudID,Entero_Cero)= Entero_Cero ) THEN
			SET Par_NumErr  := Entero_Cero;
			SET Par_ErrMen  := 'Modificacion exitosa';
			SET Var_Control	:= 'estatus';
			LEAVE ManejoErrores;
		END IF;


        IF(Par_NumAct = Act_Estatus)THEN
            UPDATE SOLICITUDESASIGNADAS Sol
			SET	Sol.Estatus  		= Par_Estatus
		    WHERE Sol.SolicitudCreditoID = Par_SolicitudCreditoID;

            -- ACTUALIZA EL ESTATUS EN REVISION EN ANALISIS POR UN ANALISTA DE CREDITO
			IF Par_Estatus=Estatus_EnRevision THEN
				CALL ESTATUSSOLCREDITOSALT(
				Par_SolicitudCreditoID,    Entero_Cero,          Estatus_EnRevision,        Cadena_Vacia,            Cadena_Vacia,
				SalidaNO, 			       Par_NumErr,           Par_ErrMen,                Par_EmpresaID,           Aud_Usuario,        
				Aud_FechaActual,           Aud_DireccionIP,      Aud_ProgramaID,            Aud_Sucursal,            Aud_NumTransaccion);	

				IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
				END IF;
			ELSE
			    CALL ESTATUSSOLCREDITOSALT(
				Par_SolicitudCreditoID,    Entero_Cero,          Estatus_Asignada,        Cadena_Vacia,            Cadena_Vacia,
				SalidaNO, 			       Par_NumErr,           Par_ErrMen,                Par_EmpresaID,           Aud_Usuario,        
				Aud_FechaActual,           Aud_DireccionIP,      Aud_ProgramaID,            Aud_Sucursal,            Aud_NumTransaccion);	

				IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
				END IF;
			   
			END IF;

			SET Par_NumErr      :=  Entero_Cero;
			SET Par_ErrMen      := 'Modificacion exitosa';
			SET Var_Control      := 'estatus';
		END IF;
		

		
		
	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr          AS Par_NumErr,
				Par_ErrMen          AS ErrMen,
				Var_Control          AS control;
	END IF;

END TerminaStore$$
