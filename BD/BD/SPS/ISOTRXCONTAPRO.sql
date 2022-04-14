DELIMITER ;
DROP PROCEDURE IF EXISTS ISOTRXCONTAPRO;
DELIMITER $$

CREATE PROCEDURE ISOTRXCONTAPRO(
	-- Descripcion: Realiza el Registro contable de operaciones de ISOTRX
	-- Modulo: Procesos de ISOTRX
	Par_CuentaAhoID			BIGINT(12), 		-- Indica el numero de cuenta de ahorro
	Par_ClienteID			BIGINT(20),			-- Numero de cliente
	Par_NumeroTransacion	BIGINT(20),			-- Numero de la transaccion
	Par_Fecha				DATE,				-- Fecha
	Par_FechaAplicacion		DATE,				-- Fecha de Aplicacion

	Par_Monto				DECIMAL(14,4),		-- Monto de operacion o movimiento
	Par_Descripcion			VARCHAR(100),		-- Descripcion del movimiento
	Par_Referencia			VARCHAR(50),		-- Referencia del movimiento
	Par_TipoMovAhoID		CHAR(4),			-- Tipo de movimiento de cuenta de ahorro
	Par_MonedaID			INT(11),			-- moneda

	Par_ConceptoAho			INT(11),			-- Concepto de cuentas de ahorro
	Par_ConceptoTar			INT(11),			-- Concepto de cuentas de tarjetas
	Par_ConceptoCon			INT(11),			-- Concepto contable
	Par_NumeroTarjeta 		VARCHAR(16),		-- Numero de tarjeta
	Par_AltaEncPoliza		CHAR(1),			-- Alta de la poliza de encabezado

	Par_AltaPolizaAhorro	CHAR(1),			-- Alta de Poliza de Ahorro
	Par_AltaPolizaTarjeta	CHAR(1),			-- Alta de polizas de tarjetas
	Par_NatMovimiento		CHAR(1),			-- Naturaleza del movimiento contable
	INOUT Par_Poliza		BIGINT(20),			-- Numero de poliza para registrar los detalles contables

	Par_Salida				CHAR(1),			-- Salida
	INOUT Par_NumErr		INT(11),			-- Numero de error
	INOUT Par_ErrMen		VARCHAR(400),		-- Mensaje

	Par_EmpresaID			INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria Fecha actual
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)  		-- Parametro de auditoria Numero de la transaccion
	)
TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_Cargos				DECIMAL(14,4);	-- Variable para almacenar los cargos
	DECLARE Var_Abonos				DECIMAL(14,4);	-- Variable para almacenar los abonos
	DECLARE Var_Control				VARCHAR(50);	-- Variable de contrl
	DECLARE Var_Consecutivo			BIGINT(20);		-- Variable consecutivo

	-- Declaracion de constantes
	DECLARE Cadena_Vacia			CHAR(1);		-- Cadena vacia
	DECLARE Fecha_Vacia				DATE;			-- Fecha vacia
	DECLARE Entero_Cero				INT(11);		-- Entero cero
	DECLARE Decimal_Cero			DECIMAL(12, 2);	-- Decimal cero
	DECLARE Nat_Cargo				CHAR(1);		-- Naturaleza cargos
	DECLARE Nat_Abono				CHAR(1);		-- Naturaleza abobos
	DECLARE Pol_Automatica			CHAR(1);		-- Poliza automatica
	DECLARE SalidaSI				CHAR(1); 		-- Salida SI
	DECLARE SalidaNO				CHAR(1); 		-- Salida NO
	DECLARE Con_SI					CHAR(1); 		-- Constante SI
	DECLARE Con_NO					CHAR(1); 		-- Constante NO

	-- Asignacion de constantes
	SET Cadena_Vacia				:= '';
	SET Fecha_Vacia					:= '1900-01-01';
	SET Entero_Cero					:= 0;
	SET Decimal_Cero				:= 0.00;
	SET Nat_Cargo					:= 'C';
	SET Nat_Abono					:= 'A';
	SET Pol_Automatica				:= 'A';

	SET Aud_FechaActual				:= NOW();
	SET Con_SI						:= 'S';
	SET Con_NO						:= 'N';
	SET SalidaSI					:= 'S';
	SET SalidaNO					:= 'N';

ManejoErrores: BEGIN
	  DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-ISOTRXCONTAPRO');
			SET Var_Control := 'SQLEXCEPTION';
		END;

		-- Validacion de datos nulos
		SET Var_Consecutivo	:= Entero_Cero;

		-- Cuando la bandera de alta poliza esta como SI, se realiza el alta del encabezado de poliza
		IF (Par_AltaEncPoliza = Con_SI) THEN
			CALL MAESTROPOLIZASALT(
				Par_Poliza,			Par_EmpresaID,		Par_FechaAplicacion,	Pol_Automatica,		Par_ConceptoCon,
				Par_Descripcion,	SalidaNO,			Par_NumErr,				Par_ErrMen,			Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero) THEN
				SET Par_NumErr := 1300;
		        SET Par_ErrMen := CONCAT('Error en Alta de Encabezado de Poliza. ', Par_ErrMen);
				LEAVE ManejoErrores;
			END IF;

		END IF;

		-- Proceso contables de cuentas de ahorro
		IF (Par_AltaPolizaAhorro = Con_SI) THEN

			-- Procesos contables de cuentas de ahorro
			CALL CONTAAHOPRO(
				Par_CuentaAhoID,		Par_ClienteID,		Par_NumeroTransacion,	Par_Fecha,			Par_FechaAplicacion,
				Par_NatMovimiento,		Par_Monto,			Par_Descripcion,		Par_Referencia,		Par_TipoMovAhoID,
				Par_MonedaID,			Entero_Cero,		Con_NO,					Par_ConceptoCon,	Par_Poliza,
				Par_AltaPolizaAhorro,	Par_ConceptoAho,	Par_NatMovimiento,		Var_Consecutivo,	SalidaNO,
				Par_NumErr,				Par_ErrMen,			Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion
				);

			IF (Par_NumErr <> Entero_Cero) THEN
				SET Par_NumErr := 1301;
		        SET Par_ErrMen := CONCAT('Error en Alta de Poliza Contable. ',Par_ErrMen);
				LEAVE ManejoErrores;
			END IF;

		END IF;

		-- Procesos contables de tarjetas
		IF(Par_AltaPolizaTarjeta = Con_SI)THEN

				IF(Par_NatMovimiento = Nat_Cargo) THEN
					SET Var_Cargos	:= Decimal_Cero;
					SET Var_Abonos	:= Par_Monto;
				ELSE
					SET Var_Cargos	:= Par_Monto;
					SET Var_Abonos	:= Decimal_Cero;
				END IF;
				-- Polizas de cuentas de tarjetas
				CALL POLIZATARJETAPRO(
					Par_Poliza,			Par_EmpresaID,		Par_Fecha,			Par_NumeroTarjeta,	Par_ClienteID,
					Par_ConceptoTar,	Par_MonedaID,		Var_Cargos,			Var_Abonos,			Par_Descripcion,
					Par_Referencia,		Entero_Cero,		SalidaNO,			Par_NumErr,			Par_ErrMen,
					Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
					Aud_NumTransaccion
					);

				IF (Par_NumErr <> Entero_Cero) THEN
				    SET Par_NumErr := 1302;
		            SET Par_ErrMen := CONCAT('Error en Alta de Poliza Tarjeta. ',Par_ErrMen);
					LEAVE ManejoErrores;
				END IF;

		END IF;

		SET Par_NumErr := 0;
		SET Par_ErrMen := 'Movimiento Realizado Exitosamente';

END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen;

	END IF;

END TerminaStore$$