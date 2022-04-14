-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before AND after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEIDESCARGASREMACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEIDESCARGASREMACT`;
DELIMITER $$


CREATE PROCEDURE `SPEIDESCARGASREMACT`(
	-- Stored procedure para actualizar SPEI descarga de remesas.
	Par_DetSolDesID			BIGINT(20),
	Par_SpeiSolDesID		BIGINT(20),
	Par_ClaveRastreo		VARCHAR(30),
	Par_NumAct				TINYINT UNSIGNED,

    Par_Salida				CHAR(1),
    INOUT Par_NumErr 		INT,
	INOUT Par_ErrMen 		VARCHAR(400),

	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(20),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)

TerminaStore: BEGIN

	-- Declaración de variables.
	DECLARE Var_Control	    VARCHAR(200);
	DECLARE Var_Consecutivo	VARCHAR(30);
	DECLARE Var_Estatus     CHAR(1);

	-- Declaración de constantes.
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Entero_Cero		INT;
	DECLARE	Fecha_Vacia		DATE;
	DECLARE Salida_SI 		CHAR(1);
	DECLARE	Salida_NO		CHAR(1);

	DECLARE Act_EstProce    INT;
	DECLARE Act_EstError    INT;
	DECLARE Est_Proc        CHAR(1);
	DECLARE Est_Error       CHAR(1);
	DECLARE Est_Pen         CHAR(1);

	-- Asignación de constantes.
	SET	Cadena_Vacia	:= '';
	SET	Fecha_Vacia		:= '1900-01-01 00:00:00';
	SET	Entero_Cero		:= 0;
	SET Salida_SI 	   	:= 'S';
	SET	Salida_NO		:= 'N';

	SET Act_EstProce    := 1;
	SET Act_EstError    := 2;
	SET Est_Proc        := 'R';
	SET Est_Error       := 'E';
	SET Est_Pen         := 'P';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			GET DIAGNOSTICS condition 1
			@Var_SQLState = RETURNED_SQLSTATE, @Var_SQLMessage = MESSAGE_TEXT;
			SET Par_NumErr = 999;
			SET Par_ErrMen =  LEFT(CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
				 'esto le ocasiona. Ref: SP-SPEIDESCARGASREMACT','[',@Var_SQLState,'-' , @Var_SQLMessage,']'), 400);
			SET Var_Control = 'sqlException';
		END;

		IF (Par_NumAct = Act_EstProce) THEN

			UPDATE SPEIDESCARGASREM SET
				SpeiSolDesID		= Par_SpeiSolDesID,
				Estatus 			= Est_Proc,

				EmpresaID	  		= Aud_EmpresaID,
				Usuario        		= Aud_Usuario,
				FechaActual    		= Aud_FechaActual,
				DireccionIP    		= Aud_DireccionIP,
				ProgramaID     		= Aud_ProgramaID,
				Sucursal	   		= Aud_Sucursal,
				NumTransaccion 		= Aud_NumTransaccion
			WHERE SpeiDetSolDesID = Par_DetSolDesID
			AND Estatus = Est_Pen;

			SET Par_NumErr	:= 000;
			SET Par_ErrMen	:= concat("Descarga de Remesa Actualizada Exitosamente");
			SET Var_Control	:= 'SpeiDetSolID' ;
			SET Var_Consecutivo	:= Par_ClaveRastreo;
		END IF;

		IF (Par_NumAct = Act_EstError) THEN

			UPDATE SPEIDESCARGASREM SET
				SpeiSolDesID		= Par_SpeiSolDesID,
				Estatus 			= Est_Error,
				MenError            = Par_ErrMen,

				EmpresaID	  		= Aud_EmpresaID,
				Usuario        		= Aud_Usuario,
				FechaActual    		= Aud_FechaActual,
				DireccionIP    		= Aud_DireccionIP,
				ProgramaID     		= Aud_ProgramaID,
				Sucursal	   		= Aud_Sucursal,
				NumTransaccion 		= Aud_NumTransaccion
			WHERE SpeiDetSolDesID = Par_DetSolDesID
			AND Estatus = Est_Pen;

			SET Par_NumErr	:= 000;
			SET Par_ErrMen	:= concat("Descarga de Remesa Actualizada Exitosamente");
			SET Var_Control	:= 'SpeiDetSolID' ;
			SET Var_Consecutivo	:= Par_ClaveRastreo;
		END IF;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$