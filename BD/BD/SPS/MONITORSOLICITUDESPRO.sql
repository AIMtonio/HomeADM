-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MONITORSOLICITUDESPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `MONITORSOLICITUDESPRO`;
DELIMITER $$


CREATE PROCEDURE `MONITORSOLICITUDESPRO`(

    Par_SolicitudCreditoID	BIGINT(20),
    Par_Condicionada		CHAR(1),
    Par_Comentario			VARCHAR(500),
    Par_Usuario				INT(11),
    Par_Salida        		CHAR(1),

	INOUT Par_NumErr    	INT(11),
	INOUT Par_ErrMen    	VARCHAR(400),

    Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
	)

TerminaStore: BEGIN

	-- VARIABLES
	DECLARE VarControl          CHAR(15);
	DECLARE Var_NombreUsuario	VARCHAR(160);	-- Nombre del Usuario
	DECLARE Var_FechaActual		DATETIME;		-- Fecha del Sistema
	DECLARE Con_Solicitud		INT(11);		-- Cantidad de Solicitudes
	DECLARE Var_ComentarioID	INT(11);		-- Comentario ID
    DECLARE Var_NumSolicitud	INT(11);
	DECLARE Var_CreditoID       BIGINT(12);     -- CreditoID

	-- CONSTANTES
	DECLARE Entero_Cero			INT(11);		-- Constante Entero Cero
	DECLARE Cadena_Vacia		CHAR(1);		-- Constante Cadena Vacia
	DECLARE Fecha_Vacia			DATE;			-- Constante Fecha Vacia
	DECLARE Con_Principal   	INT(11);		-- Consulta Principal
	DECLARE Est_Condicionada	CHAR(1);		-- Estatus Condicionado
	DECLARE Est_Solventa		CHAR(2);		-- Estatus Solventado
	DECLARE Var_Si				CHAR(1);
	DECLARE Var_No				CHAR(1);
	DECLARE SalidaSI			CHAR(1);
	DECLARE SalidaNO			CHAR(1);
	DECLARE EstatusDesCondi     CHAR(1);


	/* Asignacion de Constantes */

	SET Entero_Cero			:= 0;				-- Entero Cero
	SET Cadena_Vacia 		:= '';				-- Cadena Vacia
    SET Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
	SET Con_Principal       := 1;   			-- Consulta Principal
	SET Est_Solventa 		:= 'CI';				-- Estatus Solventado
	SET Est_Condicionada 	:= 'N';				-- Estatus Condicionado
	SET Var_Si				:= 'S';
	SET Par_NumErr    		:= 0;
	SET Par_ErrMen    		:= '';
	SET SalidaSI			:= 'S';
	SET SalidaNO			:= 'N';
    SET EstatusDesCondi     := 'F';

	ManejoErrores: BEGIN
		 DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
						 'esto le ocasiona. Ref: SP-MONITORSOLICITUDESPRO');
				SET VarControl = 'sqlException' ;
			END;

			IF(Par_Comentario = Cadena_Vacia AND Par_Condicionada = Var_Si)THEN
				SET Par_NumErr	:=01;
				SET Par_ErrMen	:='El Comentario esta Vacio';
				SET Varcontrol	:='comentario';
				LEAVE ManejoErrores;
			END IF;

			SET Var_FechaActual :=  (SELECT FechaSistema FROM PARAMETROSSIS);

			SELECT	NombreCompleto INTO Var_NombreUsuario
				FROM	USUARIOS
				WHERE	UsuarioID	= Par_Usuario;

            SET Var_NumSolicitud := (SELECT COUNT(SolicitudCreditoID) FROM SOLICITUDCREDITO
								WHERE SolicitudCreditoID = Par_SolicitudCreditoID);

			SET	Var_NumSolicitud := IFNULL(Var_NumSolicitud, Entero_Cero);

			IF(Par_Condicionada = Var_Si) THEN

				IF(Var_NumSolicitud > Entero_Cero) THEN

					UPDATE SOLICITUDCREDITO
							SET Condicionada			= Est_Condicionada
							WHERE SolicitudCreditoID = Par_SolicitudCreditoID;

					SET Var_ComentarioID:= (SELECT IFNULL(MAX(ComentarioID),Entero_Cero) + 1 FROM COMENTARIOSSOL);

					CALL COMENTARIOSALT (
					Par_SolicitudCreditoID,   	Est_Solventa,	Var_FechaActual, 	Par_Comentario,		Par_Usuario,
					SalidaNO,			Par_NumErr,				Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,   	Aud_NumTransaccion  );

               
					IF(Par_NumErr <> Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;
				ELSE
					UPDATE SOLICITUDESCERO
						SET Condicionada			= Est_Condicionada
						WHERE CreditoID  = Par_SolicitudCreditoID;

					SET Var_ComentarioID:= (SELECT IFNULL(MAX(ComentarioID),Entero_Cero) + 1 FROM COMENTARIOSSOL);

					CALL COMENTARIOSALT (
						Par_SolicitudCreditoID,   	Est_Solventa,	Var_FechaActual, 	Par_Comentario,		Par_Usuario,
						SalidaNO,			Par_NumErr,				Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,
						Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,   	Aud_NumTransaccion  );
				END IF;

				SET Var_CreditoID :=(SELECT CreditoID FROM CREDITOS WHERE SolicitudCreditoID=Par_SolicitudCreditoID);
                SET Var_CreditoID := (SELECT IFNULL(Var_CreditoID,Entero_Cero));
				CALL ESTATUSSOLCREDITOSALT(
					Par_SolicitudCreditoID,    Var_CreditoID,        EstatusDesCondi,              Cadena_Vacia,            Cadena_Vacia,
					SalidaNO, 			       Par_NumErr,           Par_ErrMen,                Par_EmpresaID,           Aud_Usuario,        
					Aud_FechaActual,           Aud_DireccionIP,      Aud_ProgramaID,            Aud_Sucursal,            Aud_NumTransaccion);	

					IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
					END IF;
			END IF;

			SET 	Par_NumErr := 000;
			SET 	Par_ErrMen := CONCAT('Solicitud Solventada Correctamente ');
			SET		VarControl := '';

	END ManejoErrores;

	IF(Par_Salida =Var_Si) THEN
		SELECT  Par_NumErr AS NumErr,
		Par_ErrMen  AS ErrMen,
		VarControl AS control,
		Entero_Cero AS consecutivo;
	END IF;
END TerminaStore$$