-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGCRELINCONTPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS PAGCRELINCONTPRO;

DELIMITER $$
CREATE PROCEDURE `PAGCRELINCONTPRO`(
	-- Store Procedure: De Ajuste para el proceso de pago revolvente en lineas de credito contigentes
	-- Modulo Cartera Agro --> Registro --> Pago con Cargo a Cuenta
	Par_CreditoID				BIGINT(12),		-- Numero de Credito
	Par_AmortizacionID			INT(11),		-- Numero de Amortizacion
	Par_MontoPago				DECIMAL(14, 2),	-- Monto de la Operacion
	INOUT Par_Poliza			BIGINT(20),		-- Numero de Poliza

	Par_Salida					CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr			INT(11),		-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),	-- Mensaje de Error

	Aud_EmpresaID				INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario					INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP				VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control				VARCHAR(100);	-- Variable de Retorno en Pantalla
	DECLARE Var_CantidadPagar		DECIMAL(14,2);	-- Variable de Monto a Pagar
	DECLARE Var_SaldoPago			DECIMAL(14,2);	-- Variable de Monto a Pagar ajustado por iteracion
	DECLARE Var_CapitalOriginal		DECIMAL(16,2);	-- Capital Original
	DECLARE Var_InteresOriginal		DECIMAL(16,2);	-- Interes Original

	DECLARE Var_MoraOriginal		DECIMAL(16,2);	-- Moratorio Original
	DECLARE Var_ComOriginal			DECIMAL(16,2);	-- Comision Original
	DECLARE Var_LineaCreditoID		BIGINT(20);		-- Variable para guardar la linea de credito
	DECLARE Var_LineaCreditoAgroID	BIGINT(20);		-- Variable para guardar la linea de credito Agro

	DECLARE Var_CreditoID			BIGINT(12);		-- Variable de Numero de Credito
	DECLARE Var_SucursalID			INT(11);		-- ID de Sucursal
	DECLARE Var_MonedaID			INT(11);		-- ID de Moneda
	DECLARE Var_ProductoCreditoID	INT(11);		-- ID de Producto de Credito
	DECLARE Var_SucursalLinID		INT(11);		-- ID de Sucursal de la Linea de Credito

	DECLARE Var_AltaPoliza			CHAR(1);		-- Alta de Poliza
	DECLARE Var_FechaSistema		DATE;			-- Fecha del Sistema


	-- Declaracion de constantes
	DECLARE	Cadena_Vacia			CHAR(1);		-- Constante de Cadena Vacia
	DECLARE Con_SI					CHAR(1);		-- Constante SI
	DECLARE Con_NO					CHAR(1);		-- Constante NO
	DECLARE	Salida_SI				CHAR(1);		-- Constante de Salida SI
	DECLARE	Salida_NO				CHAR(1);		-- Constante de Salida NO

	DECLARE AltaPoliza_SI			CHAR(1);		-- Alta de la Poliza Contable: SI
	DECLARE AltaPoliza_NO			CHAR(1);		-- Alta de la Poliza Contable: NO
	DECLARE AltaPolCre_SI			CHAR(1);		-- Alta de la Poliza Contable de Credito: SI
	DECLARE AltaPolCre_NO			CHAR(1);		-- Alta de la Poliza Contable de Credito: NO
	DECLARE AltaMovAho_SI			CHAR(1);		-- Alta de los Movimientos de Ahorro: SI

	DECLARE AltaMovAho_NO			CHAR(1);		-- Alta de los Movimientos de Ahorro: NO.
	DECLARE Nat_Cargo				CHAR(1);		-- Naturaleza de Cargo
	DECLARE Nat_Abono				CHAR(1);		-- Naturaleza de Abono.
	DECLARE	Entero_Cero				INT(11);		-- Constante de Entero Cero
	DECLARE	Entero_Uno				INT(11);		-- Constante de Entero Uno

	DECLARE Con_ContaCtaOrdenDeu	INT(11);		-- Linea Credito Cta. Orden
	DECLARE Con_ContaCtaOrdenCor	INT(11);		-- Linea Credito Corr. Cta Orden
	DECLARE Con_ContaPagoCredito	INT(11);		-- Concepto Contable de Cartera: Pago de Credito
	DECLARE	Decimal_Cero			DECIMAL(12,2);	-- Constante de Decimal Cero
	DECLARE Des_PagoCredito			VARCHAR(50);	-- Descripcion de Pago de Credito

	-- Asignacion  de constantes
	SET	Cadena_Vacia			:= '';
	SET Con_SI					:= 'S';
	SET Con_NO					:= 'N';
	SET	Salida_SI				:= 'S';
	SET	Salida_NO				:= 'N';

	SET AltaPoliza_SI			:= 'S';
	SET AltaPoliza_NO			:= 'N';
	SET AltaPolCre_SI			:= 'S';
	SET AltaPolCre_NO			:= 'N';
	SET AltaMovAho_SI			:= 'S';

	SET AltaMovAho_NO			:= 'N';
	SET Nat_Cargo				:= 'C';
	SET Nat_Abono				:= 'A';
	SET	Entero_Cero				:= 0;
	SET	Entero_Uno				:= 1;

	SET	Decimal_Cero			:= 0.0;
	SET Con_ContaCtaOrdenDeu	:= 138;
	SET Con_ContaCtaOrdenCor	:= 139;
	SET Con_ContaPagoCredito	:= 54;
	SET Des_PagoCredito			:= 'PAGO DE CREDITO CONTINGENTE (LINEA)';

	SET Var_Control				:= Cadena_Vacia;

	-- Bloque para manejar los posibles errores
	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGCRELINCONTPRO');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

		SET Par_CreditoID := IFNULL(Par_CreditoID , Entero_Cero);

		IF( Par_CreditoID = Entero_Cero ) THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:= 'El Numero de Credito Contingente esta Vacio.';
			SET Var_Control	:= 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		SELECT	Cre.CreditoID,	Cre.LineaCreditoID
		INTO	Var_CreditoID,	Var_LineaCreditoID
		FROM CREDITOSCONT Cre
		WHERE Cre.CreditoID = Par_CreditoID;

		SET Var_CreditoID		:= IFNULL(Var_CreditoID, Entero_Cero);
		SET Var_LineaCreditoID	:= IFNULL(Var_LineaCreditoID, Entero_Cero);

		IF( Var_CreditoID = Entero_Cero ) THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:= 'El Numero de Credito Contingente no Existe.';
			SET Var_Control	:= 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		SELECT	LineaCreditoID
		INTO 	Var_LineaCreditoAgroID
		FROM LINEASCREDITO
		WHERE LineaCreditoID = Var_LineaCreditoID
		  AND EsAgropecuario = Con_SI;

		SET Var_LineaCreditoAgroID	:= IFNULL(Var_LineaCreditoAgroID, Entero_Cero);

		IF( Var_LineaCreditoAgroID > Entero_Cero ) THEN

			IF( Par_AmortizacionID = Entero_Cero ) THEN
				SET Par_NumErr	:= 002;
				SET Par_ErrMen	:= 'El Numero de Amortizacion esta Vacio.';
				SET Var_Control	:= 'creditoID';
				LEAVE ManejoErrores;
			END IF;

			SELECT	SalCapitalOriginal,		SalInteresOriginal,		SalMoraOriginal,	SalComOriginal
			INTO	Var_CapitalOriginal,	Var_InteresOriginal,	Var_MoraOriginal,	Var_ComOriginal
			FROM AMORTICREDITOCONT
			WHERE AmortizacionID = Par_AmortizacionID
			  AND CreditoID = Par_CreditoID;

			SET Var_CapitalOriginal	:= IFNULL(Var_CapitalOriginal, Entero_Cero);
			SET Var_InteresOriginal	:= IFNULL(Var_InteresOriginal, Entero_Cero);
			SET Var_MoraOriginal	:= IFNULL(Var_MoraOriginal, Entero_Cero);
			SET Var_ComOriginal		:= IFNULL(Var_ComOriginal, Entero_Cero);

			IF( (Var_CapitalOriginal + Var_InteresOriginal + Var_MoraOriginal + Var_ComOriginal) = Entero_Cero ) THEN
				SET Par_NumErr	:= 003;
				SET Par_ErrMen	:= CONCAT('EL Credito: ',Par_CreditoID,' en la Amortizacion: ',Par_AmortizacionID,' no presenta Adeudos.');
				SET Var_Control	:= 'creditoID';
				LEAVE ManejoErrores;
			END IF;

			SET Var_SaldoPago := Par_MontoPago;

			ProcesoValidaMonto:BEGIN

				-- Valido si existe un monto pendiente de pago por la comision Original de la amortizacion contigente
				IF ( Var_ComOriginal > Entero_Cero ) THEN

					IF( Var_SaldoPago  >= Var_ComOriginal ) THEN
						SET Var_CantidadPagar := Var_ComOriginal;
					ELSE
						SET Var_CantidadPagar := ROUND(Var_SaldoPago,2);
					END IF;

					-- Se actualiza el Monto Original de la Comision restando el monto pagado en la tabla de amortizacion y Credito
					UPDATE AMORTICREDITOCONT SET
						SalComOriginal		= SalComOriginal - Var_CantidadPagar,

						EmpresaID			= Aud_EmpresaID,
						Usuario				= Aud_Usuario,
						FechaActual			= Aud_FechaActual,
						DireccionIP			= Aud_DireccionIP,
						ProgramaID			= Aud_ProgramaID,
						Sucursal			= Aud_Sucursal,
						NumTransaccion 		= Aud_NumTransaccion
					WHERE AmortizacionID = Par_AmortizacionID
					  AND CreditoID = Par_CreditoID;

					UPDATE CREDITOSCONT SET
						SalComOriginal		= SalComOriginal - Var_CantidadPagar,

						EmpresaID			= Aud_EmpresaID,
						Usuario				= Aud_Usuario,
						FechaActual			= Aud_FechaActual,
						DireccionIP			= Aud_DireccionIP,
						ProgramaID			= Aud_ProgramaID,
						Sucursal			= Aud_Sucursal,
						NumTransaccion 		= Aud_NumTransaccion
					WHERE CreditoID = Par_CreditoID;

					SET Var_SaldoPago := Var_SaldoPago - Var_CantidadPagar;

					IF(ROUND(Var_SaldoPago,2) <= Decimal_Cero) THEN
						LEAVE ProcesoValidaMonto;
					END IF;
				END IF;

				-- Valido si existe un monto pendiente de pago por los Moratorios de la amortizacion contigente
				IF ( Var_MoraOriginal > Entero_Cero ) THEN

					IF( Var_SaldoPago  >= Var_MoraOriginal ) THEN
						SET Var_CantidadPagar := Var_MoraOriginal;
					ELSE
						SET Var_CantidadPagar := ROUND(Var_SaldoPago,2);
					END IF;

					-- Se actualiza el Monto Original de los Moratorios restando el monto pagado en la tabla de amortizacion y Credito
					UPDATE AMORTICREDITOCONT SET
						SalMoraOriginal		= SalMoraOriginal - Var_CantidadPagar,

						EmpresaID			= Aud_EmpresaID,
						Usuario				= Aud_Usuario,
						FechaActual			= Aud_FechaActual,
						DireccionIP			= Aud_DireccionIP,
						ProgramaID			= Aud_ProgramaID,
						Sucursal			= Aud_Sucursal,
						NumTransaccion 		= Aud_NumTransaccion
					WHERE AmortizacionID = Par_AmortizacionID
					  AND CreditoID = Par_CreditoID;

					UPDATE CREDITOSCONT SET
						SalMoraOriginal		= SalMoraOriginal - Var_CantidadPagar,

						EmpresaID			= Aud_EmpresaID,
						Usuario				= Aud_Usuario,
						FechaActual			= Aud_FechaActual,
						DireccionIP			= Aud_DireccionIP,
						ProgramaID			= Aud_ProgramaID,
						Sucursal			= Aud_Sucursal,
						NumTransaccion 		= Aud_NumTransaccion
					WHERE CreditoID = Par_CreditoID;

					SET Var_SaldoPago := Var_SaldoPago - Var_CantidadPagar;

					IF(ROUND(Var_SaldoPago,2) <= Decimal_Cero) THEN
						LEAVE ProcesoValidaMonto;
					END IF;
				END IF;

				-- Valido si existe un monto pendiente de pago por los Intereses Originales de la amortizacion contigente
				IF ( Var_InteresOriginal > Entero_Cero ) THEN

					IF( Var_SaldoPago  >= Var_InteresOriginal ) THEN
						SET Var_CantidadPagar := Var_InteresOriginal;
					ELSE
						SET Var_CantidadPagar := ROUND(Var_SaldoPago,2);
					END IF;

					-- Se actualiza el Monto Original de los Intereses restando el monto pagado en la tabla de amortizacion y Credito
					UPDATE AMORTICREDITOCONT SET
						SalInteresOriginal	= SalInteresOriginal- Var_CantidadPagar,

						EmpresaID			= Aud_EmpresaID,
						Usuario				= Aud_Usuario,
						FechaActual			= Aud_FechaActual,
						DireccionIP			= Aud_DireccionIP,
						ProgramaID			= Aud_ProgramaID,
						Sucursal			= Aud_Sucursal,
						NumTransaccion 		= Aud_NumTransaccion
					WHERE AmortizacionID = Par_AmortizacionID
					  AND CreditoID = Par_CreditoID;

					UPDATE CREDITOSCONT SET
						SalInteresOriginal	= SalInteresOriginal - Var_CantidadPagar,

						EmpresaID			= Aud_EmpresaID,
						Usuario				= Aud_Usuario,
						FechaActual			= Aud_FechaActual,
						DireccionIP			= Aud_DireccionIP,
						ProgramaID			= Aud_ProgramaID,
						Sucursal			= Aud_Sucursal,
						NumTransaccion 		= Aud_NumTransaccion
					WHERE CreditoID = Par_CreditoID;

					SET Var_SaldoPago := Var_SaldoPago - Var_CantidadPagar;

					IF(ROUND(Var_SaldoPago,2) <= Decimal_Cero) THEN
						LEAVE ProcesoValidaMonto;
					END IF;
				END IF;

				-- Valido si existe un monto pendiente de pago por al Capital Original de la amortizacion contigente
				IF ( Var_CapitalOriginal > Entero_Cero ) THEN

					IF( Var_SaldoPago  >= Var_CapitalOriginal ) THEN
						SET Var_CantidadPagar := Var_CapitalOriginal;
					ELSE
						SET Var_CantidadPagar := ROUND(Var_SaldoPago,2);
					END IF;

					-- Se actualiza el Monto Original del Capital restando el monto pagado en la tabla de amortizacion y Credito
					UPDATE AMORTICREDITOCONT SET
						SalCapitalOriginal	= SalCapitalOriginal- Var_CantidadPagar,

						EmpresaID			= Aud_EmpresaID,
						Usuario				= Aud_Usuario,
						FechaActual			= Aud_FechaActual,
						DireccionIP			= Aud_DireccionIP,
						ProgramaID			= Aud_ProgramaID,
						Sucursal			= Aud_Sucursal,
						NumTransaccion 		= Aud_NumTransaccion
					WHERE AmortizacionID = Par_AmortizacionID
					  AND CreditoID = Par_CreditoID;

					UPDATE CREDITOSCONT SET
						SalCapitalOriginal	= SalCapitalOriginal - Var_CantidadPagar,

						EmpresaID			= Aud_EmpresaID,
						Usuario				= Aud_Usuario,
						FechaActual			= Aud_FechaActual,
						DireccionIP			= Aud_DireccionIP,
						ProgramaID			= Aud_ProgramaID,
						Sucursal			= Aud_Sucursal,
						NumTransaccion 		= Aud_NumTransaccion
					WHERE CreditoID = Par_CreditoID;

					-- Realizo el movimiento de devolucion de pago de capital de la linea de credito
					UPDATE LINEASCREDITO SET
						Pagado				= IFNULL(Pagado,Entero_Cero) + Var_CantidadPagar,
						SaldoDisponible		= IFNULL(SaldoDisponible,Entero_Cero) + Var_CantidadPagar,
						SaldoDeudor			= IFNULL(SaldoDeudor,Entero_Cero) - Var_CantidadPagar,

						EmpresaID			= Aud_EmpresaID,
						Usuario				= Aud_Usuario,
						FechaActual			= Aud_FechaActual,
						DireccionIP			= Aud_DireccionIP,
						ProgramaID			= Aud_ProgramaID,
						Sucursal			= Aud_Sucursal,
						NumTransaccion 		= Aud_NumTransaccion
					WHERE LineaCreditoID = Var_LineaCreditoID;

					-- Obtengo los datos para realizar la contabilidad de lineas de credito agro
					SELECT	Cre.ProductoCreditoID
					INTO	Var_ProductoCreditoID
					FROM CREDITOSCONT Cre
					WHERE Cre.CreditoID = Par_CreditoID;

					SELECT	MonedaID,		SucursalID
					INTO	Var_MonedaID,	Var_SucursalLinID
					FROM  LINEASCREDITO
					WHERE LineaCreditoID = Var_LineaCreditoID;

					SELECT FechaSistema
					INTO Var_FechaSistema
					FROM PARAMETROSSIS
					LIMIT 1;

					--  se genera la parte contable  solo cuando es revolvente
					IF( Par_Poliza = Entero_Cero )THEN
						SET Var_AltaPoliza  := AltaPoliza_SI;
					ELSE
						SET Var_AltaPoliza  := AltaPoliza_NO;
					END IF;

					-- Realizo los acientos contables para el abono a la linea de credito
					-- se manda a llamar a sp que genera los detalles contables de lineas de credito .
					-- SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES, DENTRO MANDA A LLAMAR A POLIZALINEACREPRO
					CALL CONTALINEASCREPRO(
						Var_LineaCreditoID,		Entero_Cero,			Var_FechaSistema,		Var_FechaSistema,	Var_CantidadPagar,
						Var_MonedaID,			Var_ProductoCreditoID,	Var_SucursalLinID,		Des_PagoCredito,	Var_LineaCreditoID,
						Var_AltaPoliza,			Con_ContaPagoCredito,	AltaPolCre_SI,			AltaMovAho_NO,		Con_ContaCtaOrdenDeu,
						Cadena_Vacia,			Nat_Cargo,				Nat_Cargo,				Salida_NO,			Par_NumErr,
						Par_ErrMen,				Par_Poliza,				Aud_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
						Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

					IF( Par_NumErr <> Entero_Cero ) THEN
						LEAVE ManejoErrores;
					END IF;

					-- SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES, DENTRO MANDA A LLAMAR A POLIZALINEACREPRO
					CALL CONTALINEASCREPRO(
						Var_LineaCreditoID,		Entero_Cero,			Var_FechaSistema,		Var_FechaSistema,	Var_CantidadPagar,
						Var_MonedaID,			Var_ProductoCreditoID,	Var_SucursalLinID,		Des_PagoCredito,	Var_LineaCreditoID,
						AltaPoliza_NO,			Con_ContaPagoCredito,	AltaPolCre_SI,			AltaMovAho_NO,		Con_ContaCtaOrdenCor,
						Cadena_Vacia,			Nat_Abono,				Nat_Abono,				Salida_NO,			Par_NumErr,
						Par_ErrMen,				Par_Poliza,				Aud_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
						Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

					IF( Par_NumErr <> Entero_Cero ) THEN
						LEAVE ManejoErrores;
					END IF;

					SET Var_SaldoPago := Var_SaldoPago - Var_CantidadPagar;

					IF(ROUND(Var_SaldoPago,2) <= Decimal_Cero) THEN
						LEAVE ProcesoValidaMonto;
					END IF;
				END IF;
			END ProcesoValidaMonto;
		END IF;

		IF(Par_NumErr <> Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr	:= 	Entero_Cero;
		SET Par_ErrMen	:= 'Pago de Linea Registrado Correctamente.';
		SET Var_Control	:= 'creditoID';

	END ManejoErrores;
	-- Fin del manejador de errores.

	IF(Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Par_CreditoID AS Consecutivo;
	END IF;

END TerminaStore$$