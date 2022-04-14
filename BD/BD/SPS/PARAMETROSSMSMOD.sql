-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMETROSSMSMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMETROSSMSMOD`;DELIMITER $$

CREATE PROCEDURE `PARAMETROSSMSMOD`(
# ========================================================
# ---------- SP PARA MODIFICAR LOS PARAMETROS SMS---------
# ========================================================
	Par_NumeroInstitu1 		VARCHAR(15),
	Par_NumeroInstitu2  	VARCHAR(15),
	Par_NumeroInstitu3  	VARCHAR(15),
	Par_RutaMasivos			VARCHAR(100),
	Par_NumDigitosTel		INT(10),
	Par_NumMsmEnv			INT(10),
	Par_EnviarSiNoCoici		CHAR(1),

	Par_Salida				CHAR(1),
	INOUT Par_NumErr	    INT(11),
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

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Entero_Cero		INT;
	DECLARE SalidaSI		CHAR(1);
	DECLARE SalidaNO		CHAR(1);

	-- Declaracion de variables
	DECLARE VarPlantillaID	INT(11);
	DECLARE Var_Consecutivo	INT(11);
    DECLARE Var_Control 	VARCHAR(100);

-- Asignacion de constantes
	SET	Cadena_Vacia		:= '';				-- Cadena Vacia
	SET	Entero_Cero			:= 0;				-- Fecha Vacia
	SET SalidaSI			:='S';				-- Salida No
	SET SalidaNO			:='N';				-- Salida Si


	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								  'Disculpe las molestias que esto le ocasiona. Ref: SP-PARAMETROSSMSMOD');
			SET Var_Control = 'SQLEXCEPTION';
		END;


		IF(IFNULL(Par_NumeroInstitu1, Cadena_Vacia))= Cadena_Vacia THEN
			SET	Par_NumErr 		:= 1;
			SET Par_ErrMen 		:= 'El numero institucional esta vacio';
			SET	Var_Control 	:= 'numeroInstitu1';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_RutaMasivos, Cadena_Vacia))= Cadena_Vacia THEN
			SET	Par_NumErr 		:= 2;
			SET Par_ErrMen 		:= 'La ruta esta vacia';
			SET	Var_Control 	:= 'rutaMasivos';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_NumDigitosTel, Entero_Cero))= Entero_Cero THEN
			SET	 Par_NumErr 	:= 3;
			SET  Par_ErrMen 	:= 'El numero de digitos de Telefono esta vaacio';
			SET	Var_Control 	:= 'numDigitosTel';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_NumMsmEnv, Entero_Cero))= Entero_Cero THEN
			SET	 Par_NumErr 	:= 4;
			SET  Par_ErrMen 	:= 'El numero de mensajes enviados esta vacio.';
			SET	Var_Control 	:= 'numMsmEnv';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual := CURRENT_TIMESTAMP();

		UPDATE PARAMETROSSMS    SET
				NumeroInstitu1  = Par_NumeroInstitu1,
				NumeroInstitu2  = Par_NumeroInstitu2,
				NumeroInstitu3  = Par_NumeroInstitu3 ,
				RutaMasivos		= Par_RutaMasivos,
				NumDigitosTel	= Par_NumDigitosTel,
				NumMsmEnv		= Par_NumMsmEnv,
				EnviarSiNoCoici	= Par_EnviarSiNoCoici,

				EmpresaID		= Par_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual 	= Aud_FechaActual,
				DireccionIP 	= Aud_DireccionIP,
				ProgramaID  	= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion;


		SET	Par_NumErr := 000;
		SET Par_ErrMen := 'Parametros SMS Modificados Exitosamente.';


	END ManejoErrores;

	 IF (Par_Salida = SalidaSI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				'numeroInstitu1' AS control,
				Entero_Cero AS consecutivo;

	END IF;


END TerminaStore$$