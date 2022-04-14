DELIMITER ;
DROP PROCEDURE IF EXISTS ISOTRXCONCILIATARDEBPRO;
DELIMITER $$

CREATE PROCEDURE ISOTRXCONCILIATARDEBPRO(
	-- Descripcion: Proceso operativo que realiza la concilacion de movimientos de tarjetas realizada por ISOTRX
	-- Modulo: Procesos de ISOTRX
	Par_NumeroTarjeta 			VARCHAR(16),		-- Numero de tarjeta
	Par_CodigoAutorizacion		CHAR(6),			-- Código es el que se utilizará para aplicar reversos. Par_CodigoAprobacion
	Par_NumeroProceso			INT(11),			-- Numero de proceso

	Par_Salida					CHAR(1),			-- Salida
	INOUT Par_NumErr			INT(11),			-- Numero de error
	INOUT Par_ErrMen			VARCHAR(400),		-- Mensaje de error descripctivo

	Par_EmpresaID				INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario					INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,			-- Parametro de auditoria Fecha actual
	Aud_DireccionIP				VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)  		-- Parametro de auditoria Numero de la transaccion
	)
TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(50);	-- Variable de control
	DECLARE Var_ClienteID			INT(11);		-- Identificador del cliente
	DECLARE Var_CuentaAhoID			BIGINT(12);		-- Numero de la cuenta de ahorro
	DECLARE Var_MonedaID			INT(11);		-- Moneda id de la cuenta
	DECLARE Var_FechaSistema		DATE;			-- Fecha del sistema
	DECLARE Var_CodigoAutorizacion	BIGINT(20);		-- Codigo de la operacion original
	DECLARE Var_FechaOperacion		DATE;			-- Fecha de la operacion original
	DECLARE Var_HoraOperacion		DATETIME;		-- Hora de la operacion original
	DECLARE Var_MontoComision		DECIMAL(12,4);	-- Variable para almacenar el monto de la operacion
	DECLARE Var_SaldoDisponible		DECIMAL(12,2);	-- Variable para almacenar el saldo disponible de la cuenta
	DECLARE Var_ExisteOperacion		INT(11);		-- Variable para validar que exista una operacion

	-- Declaracion de numero de procesos
	DECLARE Pro_Conciliacion		INT(11);		-- Proceso que realiza la actualizacion de la conciliacion de tarjetas

	-- Declaracion de constantes
	DECLARE Cadena_Vacia			CHAR(1);		-- Cadena vacia
	DECLARE Fecha_Vacia				DATE;			-- Fecha vacia
	DECLARE Entero_Cero				INT(11);		-- Entero cero
	DECLARE Decimal_Cero			DECIMAL(12,2);	-- Decimal cero
	DECLARE SalidaSI				CHAR(1); 		-- Salida SI
	DECLARE SalidaNO				CHAR(1); 		-- Salida NO
	DECLARE Con_SI					CHAR(1); 		-- Constante SI
	DECLARE Con_NO					CHAR(1); 		-- Constante NO
	DECLARE Est_Conciliado			CHAR(1);		-- Estatus conciliado

	-- Asignacion de constantes
	SET Cadena_Vacia				:= '';
	SET Fecha_Vacia					:= '1900-01-01';
	SET Entero_Cero					:= 0;
	SET Decimal_Cero				:= 0.00;
	SET Aud_FechaActual				:= NOW();
	SET Con_SI						:= 'S';
	SET Con_NO						:= 'N';
	SET SalidaSI					:= 'S';
	SET SalidaNO					:= 'N';
	SET Est_Conciliado				:= 'C';

	-- Asignacion de numero de procesos
	SET Pro_Conciliacion			:= 1;

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-ISOTRXCONCILIATARDEBPRO');
			SET Var_Control := 'SQLEXCEPTION';
		END;

		-- Fecha del sistema
		SELECT 	FechaSistema,		MonedaBaseID
		INTO	Var_FechaSistema,	Var_MonedaID
		FROM PARAMETROSSIS;

		-- Validacion de datos nulos
		SET Par_NumeroTarjeta			:= IFNULL(Par_NumeroTarjeta, Cadena_Vacia);
		SET Par_CodigoAutorizacion		:= IFNULL(Par_CodigoAutorizacion, Entero_Cero);
		SET Par_NumeroProceso			:= IFNULL(Par_NumeroProceso, Entero_Cero);

		IF(Par_NumeroProceso = Entero_Cero)THEN
			SET Par_NumErr	:= 1114;
			SET Par_ErrMen	:= 'El Numero de proceso para las actualizaciones no existe.';
			SET Var_Control	:= 'numeroProceso';
			LEAVE ManejoErrores;
		END IF;

		-- Validaciones
		IF(Par_NumeroTarjeta = Cadena_Vacia)THEN
			SET Par_NumErr	:= 1211;
			SET Par_ErrMen	:= 'El Numero de la Tarjeta se encuentra vacio';
			SET Var_Control	:= 'numeroTarjeta';
			LEAVE ManejoErrores;
		END IF;

		-- Se evalua que exista la operacion
		SELECT	COUNT(*)
		INTO	Var_ExisteOperacion
		FROM TARDEBBITACORAMOVS
		WHERE TarjetaDebID = Par_NumeroTarjeta
			AND CodigoAprobacion = Par_CodigoAutorizacion;

		-- Se valida que exista la operacion actual
		IF(Var_ExisteOperacion = Entero_Cero)THEN
			SET Par_NumErr	:= 0004;
			SET Par_ErrMen	:= 'Los Datos de Autorizacion no Coinciden con la Tarjeta.';
			SET Var_Control	:= 'numeroTarjeta';
			LEAVE ManejoErrores;
		END IF;

		-- PROCESO DE CONCILIACION DE TARJETAS
		IF(Par_NumeroProceso = Pro_Conciliacion)THEN
			UPDATE TARDEBBITACORAMOVS
				SET
					EstatusConcilia		= Est_Conciliado,
					FolioConcilia		= Entero_Cero,
					DetalleConciliaID	= Entero_Cero
			WHERE TarjetaDebID = Par_NumeroTarjeta
				AND CodigoAprobacion = Par_CodigoAutorizacion;

			SET Par_NumErr := 0;
			SET Par_ErrMen := 'Conciliacion de Movimientos Realizada Exitosamente.';
			LEAVE ManejoErrores;
		END IF;

END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen;
	END IF;

END TerminaStore$$