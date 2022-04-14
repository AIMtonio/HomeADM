
-- SOLICITUDTRANSFERCAJAACT
DELIMITER ;
DROP PROCEDURE IF EXISTS SOLICITUDTRANSFERCAJAACT;
DELIMITER $$


CREATE PROCEDURE SOLICITUDTRANSFERCAJAACT(

    Par_SolicitudTransID		BIGINT(20),
    Par_NumAct					INT(11),

    Par_Salida					CHAR(1),
    INOUT Par_NumErr			INT(11),
    INOUT Par_ErrMen			VARCHAR(400),
    
    Aud_EmpresaID				INT(11),
    Aud_Usuario					INT(11),
    Aud_FechaActual				DATETIME,
    Aud_DireccionIP				VARCHAR(15),
    Aud_ProgramaID				VARCHAR(50),
    Aud_Sucursal				INT(11),
    Aud_NumTransaccion			BIGINT(11)
    )

TerminaStore: BEGIN

    DECLARE Var_Control         VARCHAR(100);
    DECLARE Var_Consecutivo     VARCHAR(20);
    DECLARE	Act_Recibido		INT(11);
    DECLARE Act_Rechazado		INT(11);


    DECLARE  Entero_Cero        INT;
    DECLARE  SalidaSI           CHAR(1);
    DECLARE  SalidaNO           CHAR(1);
    DECLARE  Cadena_Vacia       CHAR(1);
    DECLARE  EstatusR           CHAR(1);
    DECLARE  EstatusE			CHAR(1);
    
	SET Act_Recibido    := 1;
	SET Act_Rechazado	:= 2;
	
    SET Entero_Cero     := 0;
    SET SalidaSI        := 'S';
    SET SalidaNO        := 'N';
    SET Cadena_Vacia    := '';
    SET EstatusR        := 'R';
    SET EstatusE		:= 'E';

    ManejoErrores: BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
            SET Par_NumErr := 999;
            SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
            'Disculpe las molestias que esto le ocasiona. Ref: SP-SOLICITUDTRANSFERCAJAACT');
            SET Var_Consecutivo := Entero_Cero;
            SET Var_Control := 'sqlException' ;
        END;

        IF(IFNULL(Par_solicitudTransID,Entero_Cero))= Entero_Cero THEN
            SET Par_NumErr          := 001;
            SET Par_ErrMen          := CONCAT('El  numero de la solicitud esta vacio');
            SET Var_Control         := 'solicitudTransID' ;
            SET Var_Consecutivo     := Par_SolicitudTransID;
            LEAVE ManejoErrores;
        END IF;
        
        IF(Par_NumAct = Act_Recibido) THEN
			UPDATE SOLICITUDTRANSFERCAJA SET
				Estatus = EstatusR
			WHERE SolicitudTransID = Par_SolicitudTransID;
			
			SET Par_NumErr  := 000;
			SET Par_ErrMen  := CONCAT('Solicitud Recibida');
			SET Var_Control := 'solicitudTransID' ;
			SET Var_Consecutivo := Par_SolicitudTransID;
        END IF;
		
		IF(Par_NumAct = Act_Rechazado) THEN
			UPDATE SOLICITUDTRANSFERCAJA SET
				Estatus = EstatusE
			WHERE SolicitudTransID = Par_SolicitudTransID;
			
			SET Par_NumErr  := 000;
			SET Par_ErrMen  := CONCAT('Solicitud Rechazada');
			SET Var_Control := 'solicitudTransID' ;
			SET Var_Consecutivo := Par_SolicitudTransID;
        END IF;
        
    END ManejoErrores;

    IF (Par_Salida = SalidaSI) THEN
        SELECT  Par_NumErr AS NumErr,
                Par_ErrMen AS ErrMen,
                Var_Control AS control,
                Var_Consecutivo AS consecutivo;
    END IF;
END TerminaStore$$
