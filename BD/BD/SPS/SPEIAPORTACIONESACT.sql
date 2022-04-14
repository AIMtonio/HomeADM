-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEIAPORTACIONESACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEIAPORTACIONESACT`;
DELIMITER $$


CREATE PROCEDURE `SPEIAPORTACIONESACT`(
    Par_ClaveRastreo       VARCHAR(30),
	Par_FolioSpeiID          BIGINT(20),
	Par_NumAct             INT(2),

	Par_Salida			   CHAR(1),
	INOUT Par_NumErr	   INT,
	INOUT Par_ErrMen	   VARCHAR(350),

	Par_EmpresaID		   INT(11),
	Aud_Usuario			   INT(11),
	Aud_FechaActual		   DATETIME,
	Aud_DireccionIP		   VARCHAR(20),
	Aud_ProgramaID		   VARCHAR(50),
	Aud_Sucursal		   INT(11),
	Aud_NumTransaccion	   BIGINT(20)
)

TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
	DECLARE Var_RemitenteID		INT(11);
	DECLARE Var_Destinatario	VARCHAR(50);
	DECLARE	Con_MensajeEnviar	TEXT;

	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Entero_Cero		INT;
	DECLARE	Decimal_Cero	DECIMAL(18,2);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE Salida_SI 		CHAR(1);
	DECLARE	Salida_NO		CHAR(1);
	DECLARE Estatus_Ver  	CHAR(1);
	DECLARE Act_Principal   INT;
	DECLARE Act_Enviada     INT;
	DECLARE Act_Cancelada   INT;
	DECLARE Act_Verificada	INT;
	DECLARE Estatus_Env     CHAR(1);
	DECLARE Estatus_Can     CHAR(1);
	DECLARE Estatus_Dis 	CHAR(1);
	DECLARE EstatusRem_Can 	INT;
	DECLARE NumErrCorreo 	INT(11);
	DECLARE ErrMenCorreo 	VARCHAR(400);
	DECLARE	Con_Asunto		VARCHAR(150);
	DECLARE Var_Proceso		VARCHAR(50);

	DECLARE Var_Control	    VARCHAR(200);
	DECLARE Var_Consecutivo	BIGINT(20);
	DECLARE Fecha_Sist      DATE;
	DECLARE Var_Estatus     CHAR(1);


	SET	Cadena_Vacia	:= '';
	SET	Fecha_Vacia		:= '1900-01-01';
	SET	Entero_Cero		:= 0;
	SET	Decimal_Cero	:= 0.0;
	SET Salida_SI 	   	:= 'S';
	SET	Salida_NO		:= 'N';
	SET Estatus_Ver  	:= 'V';
	SET Act_Principal   := 1;
	SET Act_Cancelada	:= 2;
	SET Estatus_Env     := 'E';
	SET Estatus_Can     := 'C';
	SET Estatus_Dis		:= 'D';
	SET EstatusRem_Can  := 6;

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operación. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-SPEIAPORTACIONESACT');
				SET Var_Control = 'sqlException';
			END;

		SET Fecha_Sist := (SELECT	FechaSistema	FROM	PARAMETROSSIS);

		IF(Par_NumAct = Act_Principal) THEN

			UPDATE	SPEIAPORTACIONES	SET
				 Estatus 			= Estatus_Dis,

				 EmpresaID	  		= Par_EmpresaID,
				 Usuario        	= Aud_Usuario,
				 FechaActual    	= Aud_FechaActual,
				 DireccionIP    	= Aud_DireccionIP,
				 ProgramaID     	= Aud_ProgramaID,
				 Sucursal	   		= Aud_Sucursal,
				 NumTransaccion 	= Aud_NumTransaccion
			WHERE	FolioSpeiID 		= Par_FolioSpeiID;

			SET Par_NumErr	:= 000;
			SET Par_ErrMen	:= 'Aportacion SPEI Actualizada Exitosamente';
			SET Var_Control	:= 'numero' ;
			SET Var_Consecutivo	:= Par_FolioSpeiID;
		END IF;

		IF(Par_NumAct = Act_Cancelada ) THEN
			UPDATE	SPEIAPORTACIONES	SET
				Estatus        = Estatus_Can,

				EmpresaID	   = Par_EmpresaID,
				Usuario        = Aud_Usuario,
				FechaActual    = Aud_FechaActual,
				DireccionIP    = Aud_DireccionIP,
				ProgramaID     = Aud_ProgramaID,
				Sucursal	   = Aud_Sucursal,
				NumTransaccion = Aud_NumTransaccion
			WHERE	FolioSpeiID  = Par_FolioSpeiID;

			SET	Par_NumErr 	:= 000;
			SET	Par_ErrMen	:= 'SPEI Cancelado Exitosamente';
			SET Var_Control	:= 'folio';
		END IF;

		IF(Par_NumErr!=Entero_Cero) THEN
			SET Par_NumErr := 100;
		END IF;

	END ManejoErrores;

	EnvioCorreo:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operación. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-SPEIAPORTACIONESACT-CORREO');
				SET Var_Control = 'sqlException';
			END;
		
		SET Var_RemitenteID 	:= (SELECT RemitenteID FROM PARAMETROSSPEI LIMIT 1);
		SET Var_RemitenteID		:= IFNULL(Var_RemitenteID, Entero_Cero);
		SET Var_Destinatario	:= (SELECT CorreoNotificacion FROM PARAMETROSSPEI LIMIT 1);
		SET Var_Destinatario	:= IFNULL(Var_Destinatario, Cadena_Vacia);
		SET Con_Asunto 			:= CONCAT('ERROR AL ACTUALIZAR APORTACION FOLIO SPEI: ', Par_FolioSpeiID);
		SET Con_MensajeEnviar	:= CONCAT('Ha ocurrido un error al Actualizar el Estatus del SPEIAPORTACIONES:<br> Folio: <b>',Par_FolioSpeiID,'</b>.');
		SET Var_Proceso 		:= 'SPEI';

		IF(Par_NumErr != Entero_Cero) THEN
			IF(Var_RemitenteID > Entero_Cero) THEN
				CALL TARENVIOCORREOALT(
					Var_RemitenteID,	Var_Destinatario,		Con_Asunto, 		Con_MensajeEnviar,			Entero_Cero,
					Fecha_Sist,			Fecha_Vacia,			Var_Proceso,		Cadena_Vacia, 				Salida_NO,
					NumErrCorreo,		ErrMenCorreo,			Par_EmpresaID,		Aud_Usuario ,				Aud_FechaActual,
					Aud_DireccionIP,	Aud_ProgramaID, 		Aud_Sucursal, 		Aud_NumTransaccion);
			END IF;
		END IF;
	END EnvioCorreo;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$