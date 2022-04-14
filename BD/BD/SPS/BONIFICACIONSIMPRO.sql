-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BONIFICACIONSIMPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `BONIFICACIONSIMPRO`;

DELIMITER $$
CREATE PROCEDURE `BONIFICACIONSIMPRO`(
	-- Store Procedure para el Alta de las Amotizaciones de una Bonificacion por WS
	-- Modulo WS
	Par_BonificacionID 		BIGINT(20),		-- Numero de Bonificacion
	Par_Monto 				DECIMAL(14,2),	-- Monto de la Bonificacion
	Par_Meses				INT(11),		-- Numero de Meses de la bonificacion
	Par_Fecha 				DATE,			-- Fecha de Bonificacion

	Par_Salida 				CHAR(1), 		-- Salida en Pantalla
	INOUT Par_NumErr 		INT(11),		-- Parametro de numero de error
	INOUT Par_ErrMen 		VARCHAR(400),	-- Parametro de mensaje de error

	Par_EmpresaID			INT(11),		-- Parametro de Auditoria
	Aud_Usuario				INT(11),		-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,		-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de Auditoria
	Aud_Sucursal			INT(11),		-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_FechaSistema		DATE;			-- Fecha del Sistema
	DECLARE Var_FechaCorte			DATE;			-- Fecha Corte de la Amortizacion
	DECLARE Var_MaxAmortizacion 	INT(11);		-- Numero de maximo de Amortizaciones
	DECLARE Var_AmortizacionID 		INT(11);		-- Numero de Amortizacion Actual
	DECLARE Var_MontoOriginal 		DECIMAL(14,2);	-- Monto de la Bonificacion

	DECLARE Var_Bonificacion		DECIMAL(14,2);	-- Monto de la Bonificacion por Amortizacion
	DECLARE Var_MontoAcomulado		DECIMAL(14,2);	-- Monto Acomulado de la Bonificacion por Amortizacion
	DECLARE Var_MontoAjuste			DECIMAL(14,2);	-- Monto de Ajuste de la Bonificacion por Amortizacion
	DECLARE Var_MontoPendiente 		DECIMAL(14,2);	-- Monto de Pendiente de la Bonificacion

	DECLARE Var_Control				VARCHAR(50);	-- Control de Error

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia			CHAR(1);		-- Constante Cadena Vacia
	DECLARE Est_Inactivo 			CHAR(1);		-- Constante Estatus Inactiva
	DECLARE Est_Vigente 			CHAR(1);		-- Constante Estatus Vigente
	DECLARE Con_SI 					CHAR(1);		-- Constante SI
	DECLARE	Fecha_Vacia				DATE;			-- Constante Fecha Vacia

	DECLARE Entero_Cero				INT(11);		-- Constante Entero Cero
	DECLARE Entero_Uno 				INT(11);		-- Constante Entero uno
	DECLARE Decimal_Cero			DECIMAL(12,2);	-- Constante Decumal Cero

	-- Asignacion de Constantes
	SET	Cadena_Vacia				:= '';
	SET Est_Inactivo 				:= 'I';
	SET Est_Vigente 				:= 'V';
	SET Con_SI 						:= 'S';
	SET Fecha_Vacia 				:= '1900-01-01';

	SET	Entero_Cero					:= 0;
	SET Entero_Uno 					:= 1;
	SET	Decimal_Cero				:= 0.0;

	-- Se validan parametros nulos
	SET Par_BonificacionID := IFNULL(Par_BonificacionID, Entero_Cero);
	SET Par_Monto 	:= IFNULL(Par_Monto , Decimal_Cero);
	SET Par_Meses	:= IFNULL(Par_Meses , Entero_Cero);
	SET Par_Fecha 	:= IFNULL(Par_Fecha , Fecha_Vacia);

	SELECT IFNULL(FechaSistema, Fecha_Vacia)
	INTO Var_FechaSistema
	FROM PARAMETROSSIS LIMIT 1;

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									 'esto le ocasiona. Ref: SP-BONIFICACIONSIMPRO');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		IF( Par_Monto = Decimal_Cero ) THEN
			SET Par_NumErr  := 3;
			SET Par_ErrMen  := 'El Monto esta Vacio.';
			SET Var_Control := Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

		IF( Par_Meses = Entero_Cero ) THEN
			SET Par_NumErr  := 7;
			SET Par_ErrMen  := 'Los Meses estan Vacios.';
			SET Var_Control := Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

		IF( Par_Fecha = Fecha_Vacia ) THEN
			SET Par_NumErr  := 8;
			SET Par_ErrMen  := 'La Fecha esta vacia.';
			SET Var_Control := Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

		IF( Par_Fecha > Var_FechaSistema ) THEN
			SET Par_NumErr  := 8;
			SET Par_ErrMen  := 'La Fecha de Bonificacion es mayor a la del Sistema.';
			SET Var_Control := Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

		-- Inicializo las variables
		SET Var_MontoOriginal 	:= Par_Monto;
		SET Var_Bonificacion  	:= ROUND(Par_Monto / Par_Meses, 2);
		SET Var_MaxAmortizacion := Par_Meses;
		SET Var_AmortizacionID 	:= Entero_Uno;
		SET Var_FechaCorte  	:= LAST_DAY(Par_Fecha);
		SET Var_MontoAcomulado 	:= Entero_Cero;
		SET Var_MontoPendiente  := Par_Monto;


		WHILE( Var_AmortizacionID <= Var_MaxAmortizacion ) DO


			SET Var_MontoAcomulado := Var_MontoAcomulado + Var_Bonificacion;
			SET Var_MontoPendiente := Var_MontoPendiente - Var_Bonificacion;

			-- Validacion por ajuste de centavos
			IF( Var_AmortizacionID = Var_MaxAmortizacion ) THEN
				SET Var_MontoPendiente := Entero_Cero;

				IF( Var_MontoOriginal = Var_MontoAcomulado ) THEN
					SET Var_MontoAjuste := Entero_Cero;
				END IF;

				IF( Var_MontoOriginal > Var_MontoAcomulado ) THEN
					SET Var_MontoAjuste   := Var_MontoOriginal - Var_MontoAcomulado;
					SET Var_Bonificacion  := Var_Bonificacion + Var_MontoAjuste;
					SET Var_MontoAcomulado := Var_MontoAcomulado + Var_MontoAjuste;
				END IF;

				IF( Var_MontoOriginal < Var_MontoAcomulado ) THEN
					SET Var_MontoAjuste  := Var_MontoAcomulado - Var_MontoOriginal;
					SET Var_Bonificacion := Var_Bonificacion - Var_MontoAjuste;
					SET Var_MontoAcomulado := Var_MontoAcomulado - Var_MontoAjuste;
				END IF;
			END IF;

			-- Ajustar el estatus de nacimiento de la bonificacion Est_Inactivo
			SET Aud_FechaActual := NOW();
			INSERT INTO AMORTIZABONICACIONES(
				BonificacionID,			AmortizacionID,			Fecha,				Monto,				MontoPendiente,
				MontoAcomulado,			Estatus,				EmpresaID,			Usuario,			FechaActual,
				DireccionIP,			ProgramaID,				Sucursal,			NumTransaccion)
			VALUES (
				Par_BonificacionID,		Var_AmortizacionID,		Var_FechaCorte,		Var_Bonificacion,	Var_MontoPendiente,
				Var_MontoAcomulado,		Est_Vigente,			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

			SET Var_FechaCorte		:= DATE_ADD(Var_FechaCorte, INTERVAL Entero_Uno MONTH);
			SET Var_FechaCorte  	:= LAST_DAY(Var_FechaCorte);
			SET Var_AmortizacionID	:= Var_AmortizacionID + Entero_Uno;

		END WHILE;

		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= 'Amortizaciones Registradas Correctamente.';
		SET Var_Control	:= Cadena_Vacia;

	END ManejoErrores;

	IF( Par_Salida = Con_SI ) THEN
		SELECT  Par_NumErr	AS NumErr,
				Par_ErrMen	AS ErrMen,
				Var_Control	AS control,
				Par_BonificacionID AS consecutivo;
	END IF;

END TerminaStore$$