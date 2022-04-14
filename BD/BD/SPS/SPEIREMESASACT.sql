-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEIREMESASACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEIREMESASACT`;
DELIMITER $$


CREATE PROCEDURE `SPEIREMESASACT`(

	Par_SpeiRemID   	   BIGINT(20),
    Par_ClaveRastreo       VARCHAR(30),
	Par_FolioSpei          BIGINT(20),
	Par_UsuarioAutoriza    VARCHAR(30),
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
	DECLARE Estatus_Aut 	CHAR(1);
	DECLARE EstatusRem_Can 	INT;
	DECLARE Var_EstPend		CHAR(1);	-- Estatus Pendiente
	DECLARE Act_EstatusRem	INT;		-- Actualizacion: estatus de REMESASWS
	DECLARE Var_RemesaWSID	BIGINT(20);


	DECLARE Var_Control	    VARCHAR(200);
	DECLARE Var_Consecutivo	BIGINT(20);
	DECLARE Fecha_Sist      DATE;
	DECLARE Var_Estatus     CHAR(1);


	SET	Cadena_Vacia	:= '';
	SET	Fecha_Vacia		:= '1900-01-01 00:00:00';
	SET	Entero_Cero		:= 0;
	SET	Decimal_Cero	:= 0.0;
	SET Salida_SI 	   	:= 'S';
	SET	Salida_NO		:= 'N';
	SET Estatus_Ver  	:= 'V';
	SET Act_Principal   := 1;
	SET Act_Enviada     := 2;
	SET Act_Cancelada	:= 3;
	SET Act_Verificada	:= 4;
	SET Estatus_Env     := 'E';
	SET Estatus_Can     := 'C';
	SET Estatus_Aut		:= 'A';
	SET EstatusRem_Can  := 6;
	SET Var_EstPend		:= 'P';
	SET Act_EstatusRem	:= 3;

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operación. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-SPEIREMESASACT');
				SET Var_Control = 'sqlException';
			END;

		SET Fecha_Sist := (SELECT	FechaSistema	FROM	PARAMETROSSIS);

		IF(Par_NumAct = Act_Principal) THEN

			UPDATE	SPEIREMESAS	SET
				 Estatus 			= Estatus_Aut,
				 UsuarioAutoriza 	= Par_UsuarioAutoriza,
				 UsuarioEnvio		= Par_UsuarioAutoriza,
				 FechaAutorizacion	= CURRENT_TIMESTAMP(),
				 FolioSpei 			= Par_FolioSpei,

				 EmpresaID	  		= Par_EmpresaID,
				 Usuario        	= Aud_Usuario,
				 FechaActual    	= Aud_FechaActual,
				 DireccionIP    	= Aud_DireccionIP,
				 ProgramaID     	= Aud_ProgramaID,
				 Sucursal	   		= Aud_Sucursal,
				 NumTransaccion 	= Aud_NumTransaccion
			WHERE	SpeiRemID 		= Par_SpeiRemID;

			SET Par_NumErr	:= 000;
			SET Par_ErrMen	:= 'Remesa SPEI Actualizada Exitosamente';
			SET Var_Control	:= 'numero' ;
			SET Var_Consecutivo	:= Par_SpeiRemID;
		END IF;

		SET Var_Estatus:= (SELECT Estatus FROM SPEIREMESAS WHERE SpeiRemID = Par_SpeiRemID);

		IF(Par_NumAct = Act_Enviada) THEN
			IF(Var_Estatus = Estatus_Ver) THEN
				UPDATE	SPEIREMESAS	SET
					 Estatus 		= Estatus_Env,

					 EmpresaID	  	= Par_EmpresaID,
					 Usuario        = Aud_Usuario,
					 FechaActual    = Aud_FechaActual,
					 DireccionIP    = Aud_DireccionIP,
					 ProgramaID     = Aud_ProgramaID,
					 Sucursal	   	= Aud_Sucursal,
					 NumTransaccion = Aud_NumTransaccion
				WHERE	SpeiRemID  	= Par_SpeiRemID;

				SET Par_NumErr	:= 000;
				SET Par_ErrMen	:= 'Remesa SPEI Actualizada Exitosamente';
				SET Var_Control	:= 'numero' ;
				SET Var_Consecutivo	:= Par_SpeiRemID;
			ELSE
				SET	Par_NumErr 	:= 001;
				SET	Par_ErrMen	:= CONCAT('SPEI ',Par_SpeiRemID,' Tiene estatus diferente de Verificado, No puede ser enviado');
				SET Var_Control	:= 'numero';
			END IF;
		END IF;

		IF(Par_NumAct = Act_Verificada) THEN
			IF(Var_Estatus = Estatus_Aut) THEN
				UPDATE	SPEIREMESAS	SET
					 Estatus 		= Estatus_Ver,

					 EmpresaID	  	= Par_EmpresaID,
					 Usuario        = Aud_Usuario,
					 FechaActual    = Aud_FechaActual,
					 DireccionIP    = Aud_DireccionIP,
					 ProgramaID     = Aud_ProgramaID,
					 Sucursal	   	= Aud_Sucursal,
					 NumTransaccion = Aud_NumTransaccion
				WHERE	SpeiRemID  	= Par_SpeiRemID;

				SET Par_NumErr	:= 000;
				SET Par_ErrMen	:= 'Remesa SPEI Actualizada Exitosamente';
				SET Var_Control	:= 'numero' ;
				SET Var_Consecutivo	:= Par_SpeiRemID;
			ELSE
				SET	Par_NumErr 	:= 001;
				SET	Par_ErrMen	:= CONCAT('SPEI ',Par_SpeiRemID,' Tiene estatus diferente de Autorizado, No puede ser enviado');
				SET Var_Control	:= 'numero';
			END IF;
		END IF;


		IF(Par_NumAct = Act_Cancelada ) THEN
			IF(Var_Estatus = Estatus_Env || Var_Estatus = Var_EstPend) THEN

				UPDATE	SPEIREMESAS	SET
					Estatus        = Estatus_Can,
					EstatusRem	   = EstatusRem_Can,

					EmpresaID	   = Par_EmpresaID,
					Usuario        = Aud_Usuario,
					FechaActual    = Aud_FechaActual,
					DireccionIP    = Aud_DireccionIP,
					ProgramaID     = Aud_ProgramaID,
					Sucursal	   = Aud_Sucursal,
					NumTransaccion = Aud_NumTransaccion
				WHERE SpeiRemID  = Par_SpeiRemID;

				SET Var_RemesaWSID := (SELECT SD.RemesaWSID FROM SPEIREMESAS SR
										INNER JOIN SPEIDESCARGASREM SD ON SD.SpeiDetSolDesID = SR.SpeiDetSolDesID
											AND SD.SpeiSolDesID = SR.SpeiSolDesID
										WHERE SR.SpeiRemID = Par_SpeiRemID);

				CALL REMESASWSACT (
					Cadena_Vacia,		Cadena_Vacia,		Entero_Cero,	Decimal_Cero,	Cadena_Vacia,
					Cadena_Vacia, 		Entero_Cero,		Cadena_Vacia,	Cadena_Vacia,	Cadena_Vacia,
					Cadena_Vacia,		Cadena_Vacia,		Cadena_Vacia,	Cadena_Vacia,	Entero_Cero,
					Entero_Cero, 		Cadena_Vacia,		Cadena_Vacia,	Cadena_Vacia,	Cadena_Vacia,
					Entero_Cero,		Cadena_Vacia,		Cadena_Vacia,	Cadena_Vacia,	Cadena_Vacia,

					Entero_Cero,		Entero_Cero,		Entero_Cero,	Cadena_Vacia,	Cadena_Vacia,
					Cadena_Vacia, 		Cadena_Vacia,		Cadena_Vacia,	Cadena_Vacia,	Entero_Cero,
					Entero_Cero, 		Entero_Cero,		Entero_Cero,	Entero_Cero,	Entero_Cero,
					Cadena_Vacia, 		Cadena_Vacia,		Fecha_Vacia,	Cadena_Vacia,	Cadena_Vacia,
					Cadena_Vacia, 		Cadena_Vacia,		Cadena_Vacia,	Entero_Cero,	Entero_Cero,

					Entero_Cero, 		Entero_Cero,		Entero_Cero,	Cadena_Vacia,	Entero_Cero,
					Cadena_Vacia, 		Entero_Cero,		Entero_Cero,	Entero_Cero,	Entero_Cero,
					Entero_Cero,		Cadena_Vacia,		Entero_Cero,	Cadena_Vacia,	Cadena_Vacia,
					Cadena_Vacia, 		Entero_Cero,		Fecha_Vacia,	Cadena_Vacia,	Entero_Cero,
					Fecha_Vacia, 		Cadena_Vacia,		Cadena_Vacia,	Entero_Cero,	Entero_Cero,

					Entero_Cero, 		Entero_Cero,		Entero_Cero,	Cadena_Vacia,	Entero_Cero,
					Cadena_Vacia, 		Cadena_Vacia,		Entero_Cero,	Entero_Cero,	Cadena_Vacia,
					Cadena_Vacia, 		Cadena_Vacia,		Cadena_Vacia,	Cadena_Vacia,	Entero_Cero,
					Cadena_Vacia, 		Entero_Cero,		Cadena_Vacia,	Entero_Cero,	Cadena_Vacia,
					Entero_Cero, 		Cadena_Vacia,		Entero_Cero,	Cadena_Vacia,	Entero_Cero,

					Cadena_Vacia, 		Entero_Cero,		Cadena_Vacia, 	Entero_Cero, 	Cadena_Vacia,
					Entero_Cero, 		Cadena_Vacia,		Entero_Cero,	Cadena_Vacia, 	Entero_Cero,
					Cadena_Vacia, 		Entero_Cero,		Cadena_Vacia,	Entero_Cero, 	Cadena_Vacia,
					Entero_Cero, 		Cadena_Vacia,		Entero_Cero,	Cadena_Vacia, 	Var_RemesaWSID,
					Entero_Cero,		Estatus_Can,		Act_EstatusRem,

					Salida_NO,			Par_NumErr, 		Par_ErrMen,		Par_EmpresaID,	Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion
				);

				IF (Par_NumErr <> Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;

				SET	Par_NumErr 	:= 000;
				SET	Par_ErrMen	:= 'SPEI Cancelado Exitosamente';
				SET Var_Control	:= 'folio';

			ELSE
				SET	Par_NumErr 	:= 002;
				SET	Par_ErrMen	:= CONCAT('SPEI ',Par_SpeiRemID,' No puede ser cancelado');
				SET Var_Control	:= 'folio';
			END IF;
		END IF;

	END ManejoErrores;

		IF (Par_Salida = Salida_SI) THEN
			SELECT	Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					Var_Control AS control,
					Var_Consecutivo AS consecutivo;
		END IF;

END TerminaStore$$