-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTALINEASCREPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTALINEASCREPRO`;

DELIMITER $$
CREATE PROCEDURE `CONTALINEASCREPRO`(
	-- SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES, DENTRO MANDA A LLAMAR A POLIZALINEACREPRO
	Par_LineaCreditoID		BIGINT(20),		-- Indica el numero de Linea de Credito
	Par_ClienteID			INT(11),		-- Cliente del credito
	Par_FechaOperacion		DATE,			-- Fecha de Operacion
	Par_FechaAplicacion		DATE,			-- Fecha de Aplicacion
	Par_Monto				DECIMAL(14,4),	-- Monto

	Par_MonedaID			INT(11),		-- moneda
	Par_ProdCreditoID		INT(11),		-- producto del credito
	Par_SucursalID			INT(11),		-- Sucursal de LA LINEA DE CREDITO
	Par_Descripcion			VARCHAR(100),	-- Descripcion
	Par_Referencia			VARCHAR(50),	-- Referencia

	Par_AltaEncPoliza		CHAR(1),		-- Indica si da de alta el Encabezado de la poliza (POLIZACONTABLE) SI = S
	Par_ConceptoCon			INT(11),		-- Indica el Concepto para el encabezado o detalle de la poliza tabla :CONCEPTOSCONTA
	Par_AltaPoliza			CHAR(1),		-- Indica si da de alta detalles de poliza de linea de credito  S= SI
	Par_AltaMovAho			CHAR(1),		-- Indica si da de alta movimientos de linea de credito  S= SI
	Par_ConcConta			INT(11),		-- Indica el concepto contable para la linea de crédito tabla: CUENTASMAYORCAR

	Par_TipoMovAho			VARCHAR(4),		-- Tipo Movimiento de Ahorro
	Par_NatContable			CHAR(1),		-- Indica si es CARGO (C) O ABONO (A)
	Par_NatLinea			CHAR(1),		-- Indica si es CARGO (C) O ABONO (A)

	Par_Salida				CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr		INT(11),		-- Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- Mensaje de Error
	INOUT Par_PolizaID		BIGINT(20),		-- Numero de Poliza

	Par_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control		VARCHAR(100);	-- Control del Retorno a pantalla
	DECLARE Var_Cargos		DECIMAL(14,4);	-- Cargos
	DECLARE Var_Abonos		DECIMAL(14,4);	-- Abonos
	DECLARE Var_LineaCreStr	VARCHAR(20);	-- Linea de Credito en Cadena
	DECLARE Var_CuentaAhoID	BIGINT(20);		-- Identificador de la cuenta de ahorro

	DECLARE Var_CuentaStr	VARCHAR(100); 	-- Cuenta de Ahorro en formato String
	DECLARE Var_CreditoStr	VARCHAR(100);	-- Identificador de crédito en formato String

	/* Declaracion de Constantes */
	DECLARE Cadena_Vacia	CHAR(1);		-- Constante Cadena Vacia
	DECLARE Fecha_Vacia		DATE;			-- Constante Fecha Vacia
	DECLARE Entero_Cero		INT(11);		-- Constante Entero Cero
	DECLARE Decimal_Cero	DECIMAL(12, 2);	-- Constante Decimal Cero
	DECLARE AltaPoliza_SI	CHAR(1);		-- Constante Alta en Poliza SI

	DECLARE AltaPolLinSI	CHAR(1);		-- Constante Alta en Poliza Linea SI
	DECLARE Nat_Cargo		CHAR(1);		-- Constante de Cargo
	DECLARE Nat_Abono		CHAR(1);		-- Constante de Abono
	DECLARE Pol_Automatica	CHAR(1);		-- Constante Poliza Automatica
	DECLARE Salida_NO		CHAR(1);		-- Constante Salida NO
	DECLARE Salida_SI		CHAR(1);		-- Constante Salida SI

	DECLARE AltaMovsAho		CHAR(1);		-- Contante Alta de Movimiento de Ahorro SI
	DECLARE Con_AhoCapital	INT(11);		-- Número de Concepto de Ahorro

	-- Asignacion de Constantes
	SET Cadena_Vacia		:= '';
	SET Fecha_Vacia			:= '1900-01-01';
	SET Entero_Cero			:= 0;
	SET Decimal_Cero		:= 0.00;
	SET AltaPoliza_SI		:= 'S';

	SET AltaPolLinSI		:= 'S';
	SET Nat_Cargo			:= 'C';
	SET Nat_Abono			:= 'A';
	SET Pol_Automatica		:= 'A';
	SET Salida_NO			:= 'N';

	SET Salida_SI			:= 'S';
	SET AltaMovsAho			:= 'S';
	SET Con_AhoCapital 		:= 1;
	SET Var_LineaCreStr		:= CONCAT("Lin.Cre",CONVERT(Par_LineaCreditoID, CHAR(20)));
	SET Aud_FechaActual		:= NOW();

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									 'Disculpe las molestias que esto le ocasiona. Ref: SP-CONTALINEASCREPRO');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		-- Da de alta el encabezado de la poliza
		IF( Par_AltaEncPoliza = AltaPoliza_SI ) THEN
			CALL MAESTROPOLIZASALT(
				Par_PolizaID,		Par_EmpresaID,		Par_FechaAplicacion,	Pol_Automatica,		Par_ConceptoCon,
				Par_Descripcion,	Salida_NO,			Par_NumErr,				Par_ErrMen,			Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;


		-- DA DE ALTA EL DETALLE DE POLIZA
		IF( Par_AltaPoliza = AltaPolLinSI ) THEN
			IF( Par_NatContable	= Nat_Cargo ) THEN
				SET	Var_Cargos	:= Par_Monto;
				SET	Var_Abonos	:= Decimal_Cero;
			ELSE
				SET	Var_Cargos	:= Decimal_Cero;
				SET	Var_Abonos	:= Par_Monto;
			END IF;

			CALL POLIZALINEASCREPRO(
				Par_PolizaID,		Par_EmpresaID,		Par_FechaAplicacion,	Par_LineaCreditoID,		Par_ProdCreditoID,
				Par_ConcConta,		Var_Cargos,			Var_Abonos,				Par_MonedaID,			Par_Descripcion,
				Var_LineaCreStr,	Par_SucursalID,		Salida_NO,				Par_NumErr,				Par_ErrMen,
				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
				Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF( Par_AltaMovAho = AltaMovsAho )THEN

			SELECT CuentaID
			INTO Var_CuentaAhoID
			FROM LINEASCREDITO
			WHERE LineaCreditoID = Par_LineaCreditoID;

			SET Var_CuentaStr	:= CONVERT(Var_CuentaAhoID, CHAR);
			SET Var_CreditoStr	:= CONVERT(Par_LineaCreditoID,CHAR);

			IF( Par_NatLinea = Nat_Cargo ) THEN
				SET	Var_Cargos	:= Par_Monto;
				SET	Var_Abonos	:= Decimal_Cero;
			ELSE
				SET	Var_Cargos	:= Decimal_Cero;
				SET	Var_Abonos	:= Par_Monto;
			END IF;

			CALL CUENTASAHOMOVSALT(
				Var_CuentaAhoID, 	Aud_NumTransaccion, 	Par_FechaAplicacion,	Par_NatLinea, 	Par_Monto,
				Par_Descripcion,	Var_CreditoStr,			Par_TipoMovAho,
				Salida_NO,			Par_NumErr,				Par_ErrMen,				Par_EmpresaID, 	Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,	Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			CALL POLIZASAHORROPRO(
				Par_PolizaID,       Par_EmpresaID,    		Par_FechaAplicacion,	Par_ClienteID,	    Con_AhoCapital,
				Var_CuentaAhoID,    Par_MonedaID,   		Var_Cargos,        		Var_Abonos,			Par_Descripcion,
				Var_CuentaStr,		Salida_NO,      		Par_NumErr,				Par_ErrMen,			Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,       Aud_NumTransaccion);

			IF (Par_NumErr  <> Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;

		SET Par_NumErr	:= 000;
		SET Par_ErrMen	:= CONCAT('Agregado Exitosamente el Movimiento de la Linea.');
		SET Var_Control	:= 'lineaCreditoID' ;

	END ManejoErrores;

	IF Par_Salida = Salida_SI THEN
		SELECT	Par_NumErr		   AS NumErr,
				Par_ErrMen		   AS ErrMen,
				Var_Control		   AS control,
				Par_LineaCreditoID AS consecutivo;
	END IF;

END TerminaStore$$