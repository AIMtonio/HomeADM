-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOCREDACTIVOAGROPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOCREDACTIVOAGROPRO`;
DELIMITER $$


CREATE PROCEDURE `PAGOCREDACTIVOAGROPRO`(
/* SP DE PROCESO QUE REALIZA EL PAGO DE CREDITO ACTIVO AGRO */
	Par_CreditoID			BIGINT(12),		-- ID del Crédito.
	Par_CuentaAhoID			BIGINT(12),		-- ID de la Cuenta de Ahorro a la que se le hará el cargo.
	Par_MontoPagar			DECIMAL(14,2),	-- Monto a Pagar
	Par_MonedaID			INT(11),		-- ID de la Moneda.
	Par_TotalAdeudo			DECIMAL(14,2),	-- Total del adeudo del credito

	Par_PagoExigible		DECIMAL(14,2),	-- Total del Exigible del credito
	Par_EmpresaID			INT(11),		-- ID de la Empresa
	Par_Salida				CHAR(1),		-- Indica el tipo de Salida.

	Par_AltaEncPoliza		CHAR(1),		-- Indica si se da de alta el Encabezado de la póliza. S. Si N. No
	INOUT Par_MontoPago		DECIMAL(14,2),
	INOUT Par_Poliza		BIGINT,
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),

	INOUT Par_Consecutivo	BIGINT,
	Par_ModoPago			CHAR(1),
	Par_Origen				CHAR(1),
	/* Parametros de Auditoria */
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)

TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_CreditoID			BIGINT(12);
	DECLARE	Var_EstatusCre			CHAR(1);
	DECLARE	Var_EstatusGarFIRA		CHAR(1);
	DECLARE Var_PermitePrepago		CHAR(1);
	DECLARE	Var_MonedaID   			INT(11);
	DECLARE Var_Control				VARCHAR(100);
	DECLARE Var_AltaPoliza			CHAR(1);
	DECLARE Var_MontoPagado			DECIMAL(14,2);
	DECLARE Var_Poliza 				BIGINT;
	DECLARE Var_DiferenciaPago		DECIMAL(14,2);

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia    		CHAR(1);
	DECLARE Constante_NO			CHAR(1);
	DECLARE Constante_SI			CHAR(1);
	DECLARE Fecha_Vacia     		DATE;
	DECLARE Entero_Cero     		INT;
	DECLARE Decimal_Cero    		DECIMAL(12, 2);
	DECLARE Decimal_Cien    		DECIMAL(12, 2);
	DECLARE Estatus_Inactivo		CHAR(1);
	DECLARE Estatus_Aplicado		CHAR(1);
	DECLARE RespaldaCredSI			CHAR(1);

	-- Asignacion de Constantes
	SET Cadena_Vacia    	:= '';              	-- String Vacio
	SET Constante_NO		:= 'N';              	-- Constante No
	SET Constante_SI		:= 'S';              	-- Constante SI
	SET Fecha_Vacia     	:= '1900-01-01';    	-- Fecha Vacia
	SET Entero_Cero     	:= 0;               	-- Entero en Cero
	SET Decimal_Cero    	:= 0.00;            	-- DECIMAL Cero
	SET Decimal_Cien    	:= 100.00;          	-- DECIMAL en Cien
	SET Estatus_Inactivo	:= 'I';					-- Estatus INactivo
	SET Estatus_Aplicado	:= 'P';					-- Estatus INactivo
	SET RespaldaCredSI		:= 'S';

	ManejoErrores:BEGIN
	  DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGOCREDACTIVOAGROPRO');
		END;

		SET Aud_FechaActual     := NOW();
		SET Var_AltaPoliza		:= Constante_NO;
		SET Var_Poliza 			:= Par_Poliza;

		IF(IFNULL(Par_TotalAdeudo,Entero_Cero)=Entero_Cero)THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'El Credito Se Encuentra Pagado.';
			SET Var_Control:= 'creditoID';
			LEAVE ManejoErrores;
		END IF;

        SELECT Pro.PermitePrepago INTO Var_PermitePrepago FROM PRODUCTOSCREDITO Pro, CREDITOS Cre
			WHERE Cre.CreditoID=Par_CreditoID
				AND Cre.ProductoCreditoID= Pro.ProducCreditoID;

		-- si el monto ingresado para el activo es menor o igual al pago exigible y
		-- el pago exigible no esta pagado, entonces hace el abono a la cuota exigible
		IF(Par_MontoPagar<=Par_PagoExigible) THEN
			-- Procedimiento del Pago del Credito "ordinario"
			CALL PAGOCREDITOPRO(
				Par_CreditoID,		Par_CuentaAhoID,	Par_MontoPagar,		Par_MonedaID,		Constante_NO,
				Constante_NO,		Par_EmpresaID,		Constante_NO,		Var_AltaPoliza,		Var_MontoPagado,
				Var_Poliza,			Par_NumErr,			Par_ErrMen,			Par_Consecutivo,	Par_ModoPago,
				Par_Origen,			RespaldaCredSI,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		ELSE-- SI el monto ingresado es MAYOR al pago exigible Y sea MENOR al total adeudo y
			-- y el pago exigible se encuentra pagado, entonces hace el abono a la cuota exigible y/o prepago
			IF((Par_MontoPagar>Par_PagoExigible)AND(Par_MontoPagar<Par_TotalAdeudo))THEN
				-- Se calcula la diferencia para poder realizar el prepago
				SET Var_DiferenciaPago := Par_MontoPagar-Par_PagoExigible;
				SET Var_DiferenciaPago := IFNULL(Var_DiferenciaPago,Decimal_Cero);
				-- Procedimiento del Pago del Credito "ordinario"
				IF(Par_PagoExigible>Entero_Cero)THEN

					CALL PAGOCREDITOPRO(
						Par_CreditoID,		Par_CuentaAhoID,	Par_PagoExigible,	Par_MonedaID,		Constante_NO,
						Constante_NO,		Par_EmpresaID,		Constante_NO,		Var_AltaPoliza,		Var_MontoPagado,
						Var_Poliza,			Par_NumErr,			Par_ErrMen,			Par_Consecutivo,	Par_ModoPago,
						Par_Origen,			RespaldaCredSI,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
						Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;

				END IF;

				IF(Var_DiferenciaPago>Decimal_Cero) THEN-- si la diferencia es mayor a cero
					-- Procedimiento del Pago del Credito "prepago" con la difrencia antes calculada
					IF(Var_PermitePrepago=Constante_SI)THEN


						IF (Par_PagoExigible!=0.0) THEN
							CALL TRANSACCIONESPRO(Aud_NumTransaccion);
						END IF;


						CALL PREPAGOCREDITOPRO(
							Par_CreditoID,		Par_CuentaAhoID,	Var_DiferenciaPago,		Par_MonedaID,		Par_EmpresaID,
							Constante_NO,		Var_AltaPoliza,		Var_MontoPagado,		Var_Poliza,			Par_NumErr,
							Par_ErrMen,			Par_Consecutivo,	Par_ModoPago,			Par_Origen,			RespaldaCredSI,
							Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
							Aud_NumTransaccion);

						IF(Par_NumErr != Entero_Cero)THEN
							LEAVE ManejoErrores;
						END IF;

					ELSE-- Si el producto de credito NO permite prepago, entonces se envia mensaje

						SET Par_NumErr := 2;
						SET Par_ErrMen := 'El Producto de Credito No Permite Prepago.';
						SET Var_Control:= 'creditoID';
						LEAVE ManejoErrores;
					END IF;
				END IF;
			ELSE -- Si no, se comprueba que el monto a pagar sea igual al total del adeudo
				IF(Par_MontoPagar=Par_TotalAdeudo)THEN
				-- Procedimiento del Pago del Credito "finiquito"
					CALL PAGOCREDITOPRO(
						Par_CreditoID,		Par_CuentaAhoID,	Par_MontoPagar,		Par_MonedaID,		Constante_NO,
						Constante_SI,		Par_EmpresaID,		Constante_NO,		Var_AltaPoliza,		Var_MontoPagado,	Var_Poliza,			Par_NumErr,			Par_ErrMen,			Par_Consecutivo,
						Par_ModoPago,		Par_Origen,			RespaldaCredSI,		Aud_Usuario,		Aud_FechaActual,
						Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;
				ELSE
					IF(Par_MontoPagar>Par_TotalAdeudo)THEN
						SET Par_NumErr := 4;
						SET Par_ErrMen := 'El Monto No debe ser Mayor al Monto del Adeudo Total.';
						SET Var_Control:= 'montoPagar';
						LEAVE ManejoErrores;
					END IF;
				END IF;-- Fin si es finiquito
			END IF;-- Fin se paga exigible Mas prepago
		END IF;--  Fin si monto a pagar es menor o igual que exigible

		SET Par_NumErr		:= Entero_Cero;
		SET Par_ErrMen		:= 'Pago Aplicado Exitosamente';
		SET Par_Consecutivo	:= Entero_Cero;
		SET Var_Control		:= 'creditoID';

END ManejoErrores;

IF (Par_Salida = Constante_SI) THEN
	SELECT  Par_NumErr 		AS NumErr,
			Par_ErrMen 		AS ErrMen,
			Var_Control 	AS Control,
			Par_Consecutivo AS Consecutivo;
END IF;

END TerminaStore$$