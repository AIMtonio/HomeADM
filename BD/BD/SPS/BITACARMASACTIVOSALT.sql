-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACARMASACTIVOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACARMASACTIVOSALT`;

DELIMITER $$
CREATE PROCEDURE `BITACARMASACTIVOSALT`(
	-- Store Procedure de Alta de la Bitacora de la Carga Masiva de Activos
	-- Modulo: Activos --> Registro --> Carga Masiva
	Par_RegistroID			INT(11),		-- Numero de Registro
	Par_TransaccionID		BIGINT(20),		-- Numero de Transaccion
	Par_NumeroError			INT(11),		-- Numero de Errores
	Par_MensajeError		VARCHAR(500),	-- Descripción del Error

	Par_Salida				CHAR(1),		-- Parametro de salida S= si, N= no
	INOUT Par_NumErr		INT(11),		-- Parametro de salida numero de error
	INOUT Par_ErrMen		VARCHAR(400),	-- Parametro de salida mensaje de error

	Par_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Fecha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_FechaSistema	DATE;			-- Fecha de Registro
	DECLARE Var_Consecutivo		INT(11);		-- Centro de Costo
	DECLARE Var_RegistroID		INT(11);		-- Numero de Registro
	DECLARE Var_Control			VARCHAR(50);	-- Control de Retorno a Pantalla

	-- Declaracion de Constantes
	DECLARE Fecha_Vacia			DATE;			-- Constante Fecha vacia
	DECLARE Entero_Uno			INT(11);		-- Constante Entero Uno
	DECLARE Entero_Cero			INT(11);		-- Constante Entero cero
	DECLARE Cadena_Vacia		CHAR(1);		-- Constante cadena vacia
	DECLARE Salida_SI			CHAR(1);		-- Constante de salida SI

	DECLARE Salida_NO			CHAR(1);		-- Constante de salida NO
	DECLARE Con_SI				CHAR(1);		-- Constante SI
	DECLARE Con_NO				CHAR(1);		-- Constante NO
	DECLARE Decimal_Cero		DECIMAL(14,2);	-- Constante Decimal cero

	-- Asignacion de Constantes
	SET Fecha_Vacia				:= '1900-01-01';
	SET Entero_Cero				:= 0;
	SET Entero_Uno				:= 1;
	SET Cadena_Vacia			:= '';
	SET Salida_SI				:= 'S';

	SET Salida_NO				:= 'N';
	SET Con_SI					:= 'S';
	SET Con_NO					:= 'N';
	SET Decimal_Cero			:= 0.00;

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-BITACARMASACTIVOSALT');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

		SET Var_Consecutivo		:= Entero_Cero;
		SET Par_RegistroID 		:= IFNULL(Par_RegistroID, Entero_Cero);
		SET Par_TransaccionID	:= IFNULL(Par_TransaccionID, Entero_Cero);
		SET Par_NumeroError		:= IFNULL(Par_NumeroError, Entero_Cero);
		SET Par_MensajeError	:= IFNULL(Par_MensajeError, Cadena_Vacia);

		IF( Par_TransaccionID = Entero_Cero ) THEN
			SET Par_NumErr	:= 1;
			SET Par_ErrMen	:= 'El Numero de Transaccion esta Vacio.';
			SET Var_Control	:= 'transaccionID';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_RegistroID = Entero_Cero ) THEN
			SET Par_NumErr	:= 2;
			SET Par_ErrMen	:= 'El Numero de Registro esta Vacio.';
			SET Var_Control	:= 'registroID';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_NumeroError = Entero_Cero ) THEN
			SET Par_NumErr	:= 3;
			SET Par_ErrMen	:= 'El Numero de Errores esta Vacio.';
			SET Var_Control	:= 'registroID';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_MensajeError = Cadena_Vacia ) THEN
			SET Par_NumErr	:= 4;
			SET Par_ErrMen	:= 'El Mensaje de Error esta Vacio.';
			SET Var_Control	:= 'registroID';
			LEAVE ManejoErrores;
		END IF;

		-- Se remueven las etiquetas html
		SET Par_MensajeError := REPLACE(Par_MensajeError, '</b>', Cadena_Vacia);
		SET Par_MensajeError := REPLACE(Par_MensajeError, '<b>', Cadena_Vacia);
		SET Par_MensajeError := REPLACE(Par_MensajeError, '<br>', ' ');

		SELECT	FechaSistema
		INTO	Var_FechaSistema
		FROM PARAMETROSSIS
		LIMIT Entero_Uno;

		SELECT	IFNULL(MAX(Consecutivo), Entero_Cero )+ Entero_Uno
		INTO	Var_Consecutivo
		FROM BITACARMASACTIVOS
		WHERE FechaRegistro = Var_FechaSistema
		FOR UPDATE;

		SET Aud_FechaActual := NOW();
		INSERT INTO BITACARMASACTIVOS (
			FechaRegistro,		Consecutivo,		RegistroID,			TransaccionID,		NumeroError,
			MensajeError,
			EmpresaID,			Usuario,			FechaActual, 		DireccionIP, 		ProgramaID,
			Sucursal,			NumTransaccion)
		VALUES (
			Var_FechaSistema,	Var_Consecutivo,	Par_RegistroID,		Par_TransaccionID,	Par_NumeroError,
			Par_MensajeError,
			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion);

		SET Par_NumErr 	:= Entero_Cero;
		SET Par_ErrMen 	:= CONCAT('Bitacora de Carga Masiva de Activos Registrada Exitosamente; ',CAST(Var_Consecutivo AS CHAR));
		SET Var_Control	:= 'transaccionID';

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$