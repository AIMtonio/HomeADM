-- SP BANINVERSIONESACT

DELIMITER ;

DROP PROCEDURE IF EXISTS BANINVERSIONESACT;

DELIMITER $$

CREATE PROCEDURE `BANINVERSIONESACT`(

	Par_InversionID			INT(11),
	Par_Poliza      		BIGINT(20),
	Par_NumAct				TINYINT UNSIGNED,

	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen   		VARCHAR(400),

	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN


	DECLARE Var_Control					VARCHAR(50);
	DECLARE Var_InversionID        		INT(11);
	DECLARE Var_CuentaAhoID       		BIGINT(12);
	DECLARE Var_ClienteID       		INT(11);
	DECLARE Var_TipoInversionID     	INT(11);
	DECLARE Var_FechaInicio       		DATE;
	DECLARE Var_FechaVencimiento    	DATE;
	DECLARE Var_Monto         			DECIMAL(12,2);
	DECLARE Var_Plazo         			INT(11);
	DECLARE Var_Tasa          			DECIMAL(8,4);
	DECLARE Var_TasaISR         		DECIMAL(8,4);
	DECLARE Var_TasaNeta        		DECIMAL(8,4);
	DECLARE Var_InteresGenerado     	DECIMAL(12,2);
	DECLARE Var_InteresRecibir      	DECIMAL(12,2);
	DECLARE Var_InteresRetener      	DECIMAL(12,2);
	DECLARE Var_Reinvertir        		VARCHAR(5);
	DECLARE Var_Usuario         		INT(11);
	DECLARE Var_MonedaID        		INT(11);
	DECLARE Var_Etiqueta        		VARCHAR(100);
	DECLARE Var_Beneficiario       		CHAR(1);
	DECLARE Var_UsuarioClave     		VARCHAR(25);
	DECLARE Var_FechaSis      			DATE;


	DECLARE	Cadena_Vacia				CHAR(1);
	DECLARE	Fecha_Vacia					DATE;
	DECLARE	Entero_Cero					INT(11);
	DECLARE	Est_Activo					CHAR(1);
	DECLARE	Est_Inactivo				CHAR(1);
	DECLARE	Act_Reinversion				INT(11);
	DECLARE FechaSist					DATE;
	DECLARE	SalidaSI					CHAR(1);
	DECLARE	SalidaNO					CHAR(1);
	DECLARE Reinversion					INT(11);


	SET	Cadena_Vacia			:= '';
	SET	Fecha_Vacia				:= '1900-01-01';
	SET	Entero_Cero				:= 0;
	SET	Est_Activo				:= 'A';
	SET	Est_Inactivo			:= 'I';
	SET	SalidaSI				:= 'S';
	SET	SalidaNO				:= 'N';
	SET	Act_Reinversion			:= 1;
	SET Reinversion				:= 3;

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
						'Disculpe las molestias que esto le ocasiona. Ref: SP-BANINVERSIONESACT');
			SET Var_Control = 'SQLEXCEPTION' ;
		END;

		IF(IFNULL(Par_InversionID, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr := 001;
			SET Par_ErrMen := 'El ID de la Inversion es Obligatorio.';
			SET Var_Control :='inversionID';
			LEAVE ManejoErrores;
		END IF;

		SELECT FechaSistema	INTO Var_FechaSis FROM PARAMETROSSIS;

		IF(Par_NumAct = Act_Reinversion) THEN

			SELECT
				InversionID,			CuentaAhoID,			ClienteID,				TipoInversionID,			FechaInicio,
				FechaVencimiento,		Monto,					Plazo,					Tasa,						TasaISR,
				TasaNeta,				InteresGenerado,		InteresRecibir,			InteresRetener,				Reinvertir,
				Usuario,				MonedaID,				Etiqueta,				Beneficiario,				UsuarioID
			INTO
				Var_InversionID,		Var_CuentaAhoID,		Var_ClienteID,			Var_TipoInversionID,		Var_FechaInicio,
				Var_FechaVencimiento,	Var_Monto,				Var_Plazo,				Var_Tasa,					Var_TasaISR,
				Var_TasaNeta,			Var_InteresGenerado,	Var_InteresRecibir,		Var_InteresRetener,			Var_Reinvertir,
				Var_Usuario,			Var_MonedaID,			Var_Etiqueta,			Var_Beneficiario,			Var_UsuarioClave
			FROM INVERSIONES
				WHERE InversionID = Par_InversionID;

			SET Var_InversionID := IFNULL(Var_InversionID, Entero_Cero);

			IF(Var_InversionID = Entero_Cero) THEN
				SET	Par_NumErr 	:= 001;
				SET	Par_ErrMen	:= 'No se encontro la Inversion';
				SET Var_Control := 'inversionID';
				LEAVE ManejoErrores;
			END IF;

			IF(Var_FechaSis != Var_FechaVencimiento)THEN
      			SET Par_NumErr  := 017;
		      	SET Par_ErrMen  := 'La Fecha de Vigencia no es la de Hoy' ;
		      	SET Var_Control := 'inversionID';
		      	LEAVE ManejoErrores;
		    END IF;


			SET Var_FechaVencimiento := DATE_ADD(Var_FechaVencimiento, INTERVAL Var_Plazo DAY);

			CALL INVERSIONVAL(
				Var_InversionID,		Var_CuentaAhoID,		Var_ClienteID,			Var_TipoInversionID,	Var_FechaInicio,
				Var_FechaVencimiento,	Var_Monto,				Var_Plazo,				Var_Tasa,				Var_TasaISR,
				Var_TasaNeta,			Var_InteresGenerado,	Var_InteresRecibir,		Var_InteresRetener,		Var_Reinvertir,
				Var_Usuario,			Reinversion,			Var_InversionID,		Var_MonedaID,			Var_Etiqueta,
				Var_Beneficiario,		Var_UsuarioClave,		Cadena_Vacia,			SalidaNO,				Par_NumErr,
				Par_ErrMen,				Aud_EmpresaID,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
				Aud_Sucursal,			Aud_NumTransaccion
			);

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			CALL INVERSIONALT(
				Var_CuentaAhoID,		Var_ClienteID,			Var_TipoInversionID,		Var_FechaSis,		Var_FechaVencimiento,
				Var_Monto,				Var_Plazo,				Var_Tasa,					Var_TasaISR,		Var_TasaNeta,
				Var_InteresGenerado,	Var_InteresRecibir,		Var_InteresRetener,			Var_Reinvertir,		Var_Usuario,
				Reinversion,			Var_InversionID,		Var_MonedaID,				Var_Etiqueta,		Var_Beneficiario,
				Par_Poliza,				SalidaNO,				Par_NumErr,					Par_ErrMen,			Aud_EmpresaID,
				Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,		Aud_NumTransaccion
			);

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			SET Par_NumErr := 000;
			SET Par_ErrMen := 'Proceso realizado correctamente';
			SET Var_Control :='inversionID';

		END IF;

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Par_InversionID AS consecutivo;
	END IF;

END TerminaStore$$