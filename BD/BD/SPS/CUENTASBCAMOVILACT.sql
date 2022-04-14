-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASBCAMOVILACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASBCAMOVILACT`;DELIMITER $$

CREATE PROCEDURE `CUENTASBCAMOVILACT`(



	Par_CuentasBcaMovID		BIGINT(20),
	Par_ClienteID			INT(11),
    Par_UsuarioPDMID		INT(11),
    Par_NumAct			   	TINYINT UNSIGNED,

	Par_Salida			   	CHAR(1),
    INOUT Par_NumErr 	   	INT,
    INOUT Par_ErrMen	   	VARCHAR(400),

	Par_EmpresaID		   	INT(11),
	Aud_Usuario			   	INT(11),
	Aud_FechaActual		   	DATETIME,
	Aud_DireccionIP		   	VARCHAR(20),
	Aud_ProgramaID		   	VARCHAR(50),
	Aud_Sucursal		   	INT(11),
	Aud_NumTransaccion	   	BIGINT(20)
)
TerminaStore:BEGIN

	DECLARE Var_Control	        VARCHAR(200);
	DECLARE	Var_Estatus			CHAR(1);


	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Entero_Cero			INT;
	DECLARE Decimal_Cero		DECIMAL;
	DECLARE SalidaSI			CHAR(1);
	DECLARE	SalidaNO			CHAR(1);
	DECLARE	Act_Inactiva  		INT;
	DECLARE	Act_Activa  		INT;
	DECLARE	Act_Alta	  		INT;
	DECLARE	Estatus_Act  		CHAR(1);
	DECLARE	Estatus_Inc  		CHAR(1);
	DECLARE	Estatus_Blo  		CHAR(1);
	DECLARE	Estatus_Des  		CHAR(1);
	DECLARE Var_FechaRegis		DATETIME;


	SET Cadena_Vacia		:= '';
	SET Entero_Cero			:= 0;
	SET Decimal_Cero		:= 0.0;
	SET SalidaSI			:= 'S';
	SET SalidaNO			:= 'N';
	SET	Par_NumErr			:= 0;
	SET	Par_ErrMen			:= '';
	SET	Act_Inactiva  		:= 1;
	SET Act_Activa         	:= 2;
	SET Act_Alta         	:= 3;
	SET Estatus_Act       	:= 'A';
	SET	Estatus_Inc  		:= 'I';
	SET Estatus_Blo         := 'B';
	SET Estatus_Des         := 'D';
	SET Aud_FechaActual 	:= CURRENT_TIMESTAMP();
	SET Var_FechaRegis 		:= CURRENT_TIMESTAMP();

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					SET Par_NumErr	= 999;
					SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operación. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-CUENTASBCAMOVILACT');
					SET Var_Control = 'sqlException';
				END;


		IF NOT EXISTS (SELECT	CuentasBcaMovID
			FROM CUENTASBCAMOVIL
			WHERE	CuentasBcaMovID = Par_CuentasBcaMovID) THEN
			SET Par_NumErr := 001;
			SET Par_ErrMen := CONCAT('La cuenta ',Par_CuentasBcaMovID, 'no Existe');
			SET Var_Control:=  'cuentasBcaMovID' ;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_NumAct = Act_Alta) THEN
			UPDATE	CUENTASBCAMOVIL	SET
				UsuarioPDMID   		= Par_UsuarioPDMID,

				EmpresaID	   		= Par_EmpresaID,
				Usuario        		= Aud_Usuario,
				FechaActual    		= Aud_FechaActual,
				DireccionIP    		= Aud_DireccionIP,
				ProgramaID     		= Aud_ProgramaID,
				Sucursal	   		= Aud_Sucursal,
				NumTransaccion 		= Aud_NumTransaccion
			WHERE	CuentasBcaMovID = Par_CuentasBcaMovID;

			SET	Par_NumErr 	:= 0;
			SET	Par_ErrMen	:= CONCAT("Alta En Banca Movil Exitosamente: ", CONVERT(Par_CuentasBcaMovID, CHAR));
			SET Var_Control	:= 'cuentasBcaMovID';

		END IF;


		IF(Par_NumAct = Act_Inactiva) THEN
			UPDATE	CUENTASBCAMOVIL SET
				Estatus        		= Estatus_Inc,

				EmpresaID	   		= Par_EmpresaID,
				Usuario        		= Aud_Usuario,
				FechaActual    		= Aud_FechaActual,
				DireccionIP    		= Aud_DireccionIP,
				ProgramaID     		= Aud_ProgramaID,
				Sucursal	   		= Aud_Sucursal,
				NumTransaccion 		= Aud_NumTransaccion
			WHERE	CuentasBcaMovID = Par_CuentasBcaMovID;

			CALL HISTOBCAMOVILALT(
				Par_CuentasBcaMovID,	Estatus_Blo,	Var_FechaRegis,		SalidaNO,			Par_NumErr,
				Par_ErrMen,				Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,			Aud_Sucursal,	Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero) THEN
				SET Var_Control	:= 'cuentasBcaMovID';
				LEAVE ManejoErrores;
			 ELSE
				SET	Par_NumErr 	:= 0;
				SET	Par_ErrMen	:= 'Cuenta Banca Movil Bloqueada Exitosamente';
				SET Var_Control	:= 'cuentasBcaMovID';
			END IF;
		END IF;


		IF(Par_NumAct = Act_Activa) THEN

			IF EXISTS (SELECT	ClienteID
				FROM	CUENTASBCAMOVIL
				WHERE	ClienteID = Par_ClienteID
				AND		Estatus = Estatus_Act) THEN
				SET Par_NumErr := 002;
				SET Par_ErrMen := CONCAT('El Cliente ',Par_ClienteID, ' ya Tiene una Cuenta Activa');
				SET Var_Control:= 'cuentasBcaMovID' ;
				LEAVE ManejoErrores;
			END IF;

			UPDATE	CUENTASBCAMOVIL	SET
				Estatus        	= Estatus_Act,

				EmpresaID	   	= Par_EmpresaID,
				Usuario        	= Aud_Usuario,
				FechaActual    	= Aud_FechaActual,
				DireccionIP    	= Aud_DireccionIP,
				ProgramaID     	= Aud_ProgramaID,
				Sucursal	   	= Aud_Sucursal,
				NumTransaccion 	= Aud_NumTransaccion
			WHERE	CuentasBcaMovID = Par_CuentasBcaMovID;

			CALL HISTOBCAMOVILALT(
				Par_CuentasBcaMovID,	Estatus_Des,	Var_FechaRegis,		SalidaNO,			Par_NumErr,
				Par_ErrMen,				Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,			Aud_Sucursal,	Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero) THEN
				SET Var_Control	:= 'cuentasBcaMovID';
				LEAVE ManejoErrores;
			 ELSE
				SET	Par_NumErr 	:= 0;
				SET	Par_ErrMen	:= 'Cuenta Banca Movil Activada Exitosamente';
				SET Var_Control	:= 'cuentasBcaMovID';
			END IF;
		END IF;

	END ManejoErrores;

		IF (Par_Salida = SalidaSI) THEN
			SELECT	Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					Var_Control AS control,
					Par_CuentasBcaMovID AS consecutivo;
		END IF;

END  TerminaStore$$