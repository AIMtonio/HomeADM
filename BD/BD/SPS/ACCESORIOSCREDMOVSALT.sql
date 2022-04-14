-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ACCESORIOSCREDMOVSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ACCESORIOSCREDMOVSALT`;
DELIMITER $$


CREATE PROCEDURE `ACCESORIOSCREDMOVSALT`(
/* SP PARA DAR DE ALTA LOS MOVIMIENTOS DE LOS ACCESORIOS DE UN CREDITO*/
	Par_CreditoID			BIGINT(12),			-- Indica el Credito ID
	Par_AmortiCreID			INT(11),			-- Indica la amortización ID
    Par_AccesorioID			INT(11),			-- Indica el accesorio ID
	Par_Transaccion			BIGINT(20),			-- Transaccion para el simulador
	Par_FechaOperacion		DATE,				-- Indica la Fecha de operacion
	Par_FechaAplicacion		DATE,				-- Fecha en la que se realiza el movimiento

	Par_TipoMovCreID		INT(4),				-- Especifica el tipo de movimiento de crédito
	Par_NatMovimiento		CHAR(1),			-- Indica la naturaleza del movimiento
	Par_MonedaID			INT(11),			-- Indica moneda ID
	Par_Cantidad			DECIMAL(14,4),		-- Indica la cantidad del Movimiento
	Par_Descripcion			VARCHAR(100),		-- Especifica la descripción para el movimiento

	Par_Referencia			VARCHAR(50),		-- Indica la referencia del movimiento
	Par_Poliza				BIGINT(20),			-- Indica la Poliza ID
	Par_OrigenPago			CHAR(1),			-- Origen de Pago S: SPEI, V: Ventanilla, C: Cargo A Cta, N: Nomina, D: Domiciliado, R: Depositos Referenciados, W: WebService, O: Otros, Cadena Vacia en caso que no sea un op de pago mov operativos
	Par_Salida            	CHAR(1),			-- Especifica salida o no del sp: Si:'S' y No:'N'
OUT	Par_NumErr				INT(11),			-- Especifica el numero de error

OUT	Par_ErrMen				VARCHAR(400),		-- Indica el Mensaje de Error
OUT	Par_Consecutivo			BIGINT,				-- Indica consecutivo
	Par_ModoPago			CHAR(1),			-- Indica el modo de pago
    -- Parametros de Auditoria
	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),

	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)

	)

TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Mov_Cantidad    DECIMAL(12,4);
	DECLARE Var_CreStatus   CHAR(1);
	DECLARE Var_AcumProv    DECIMAL(12,4);
	DECLARE Var_ClienteID   INT;
	DECLARE Var_Control		VARCHAR(100);				-- Variable de control
	DECLARE	Var_Consecutivo	VARCHAR(20);				-- Variable consecutivo

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);
	DECLARE	Decimal_Cero		DECIMAL(12,2);
	DECLARE	EstatusActivo		CHAR(1);
	DECLARE	Nat_Cargo			CHAR(1);
	DECLARE	Nat_Abono			CHAR(1);
	DECLARE	Cre_Vigente			CHAR(1);
	DECLARE	Cre_Vencido			CHAR(1);
	DECLARE	Cre_Castigado		CHAR(1);
	DECLARE Mov_OtrasComisiones		INT(11);		-- Tipo del Movimiento de Credito: Otras Comisiones (TIPOSMOVSCRE)
	DECLARE Mov_IVAOtrasComisiones	INT(11);		-- Tipo del Movimiento de Credito: Otras Comisiones (TIPOSMOVSCRE)
	DECLARE	Pro_GenInt				VARCHAR(50);
	DECLARE	Pro_PagCre				VARCHAR(50);
	DECLARE	Pro_Bonifi				VARCHAR(50);
	DECLARE	Des_PagoCred			VARCHAR(50);
	DECLARE	Salida_NO       	CHAR(1);
	DECLARE	Salida_SI			CHAR(1);
	DECLARE Estatus_Suspendido 	CHAR(1);			-- Estatus Suspendido

	DECLARE Var_TipoMovIntAcc	INT(11);			-- Tipo de movimiento de credito Interes Accesorios
	DECLARE Var_TipoMovIvaIntAc	INT(11);			-- Tipo de movimiento de credito Iva Interes Accesorios

	-- Asignacion de constates
	SET Cadena_Vacia        	:= '';				-- Constante cadena vacia
	SET Fecha_Vacia         	:= '1900-01-01';	-- Constante Fecha Vacia: 1900-01-01
	SET Entero_Cero         	:= 0;				-- Constante Entero Cero
	SET Decimal_Cero          	:= 0.0;				-- Constante DECIMAL Cero
	SET EstatusActivo       	:= 'A';				-- Estatus Activo: A
	SET Nat_Cargo           	:= 'C';				-- Naturaleza Cargo
	SET Nat_Abono           	:= 'A';				-- Naturaleza Abono
	SET Cre_Vigente         	:= 'V';				-- Estatus Vigente
	SET Cre_Vencido         	:= 'B';				-- Estatus Vencido
	SET Cre_Castigado       	:= 'K';				-- Estatus Castigado
	SET Salida_NO           	:= 'N';   			-- Salida No
    SET Mov_OtrasComisiones		:= 43;				-- TIPOSMOVSCRE: Otras Comisiones
	SET Mov_IVAOtrasComisiones	:= 26;				-- TIPOSMOVSCRE: IVA Otras Comisiones
	SET Pro_GenInt          	:= 'GENERAINTERECREPRO'; -- Descripcion generación de intereses
	SET Pro_PagCre          	:= 'PAGOCREDITOPRO';	-- Descripción pago de credito del programa
	SET Pro_Bonifi          	:= 'BONIFICACION';		-- Descripción Bonificación
	SET Des_PagoCred        	:= 'PAGO DE CREDITO';	-- Descripción de pago de crédito
	SET Salida_SI				:= 'S';				-- Salida Si

	SET Var_Consecutivo := '0';						-- Constante consecutivo
	SET Estatus_Suspendido		:= 'S';				-- Estatus Suspendido

	SET Var_TipoMovIntAcc		:= 57;				-- Tipo de movimiento de credito Interes Accesorios
	SET Var_TipoMovIvaIntAc		:= 58;				-- Tipo de movimiento de credito Iva Interes Accesorios

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
				'Disculpe las molestias que esto le ocasiona. Ref: SP-ACCESORIOSCREDMOVSALT');
			SET Var_Control := 'SQLEXCEPTION' ;
			SET Var_Consecutivo := Cadena_Vacia;
		END;

		IF(IFNULL(Par_CreditoID, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr 			:= 001;
			SET Par_ErrMen 			:= CONCAT('El Numero de Credito esta vacio.');
			SET Var_Control 		:= 'creditoID' ;
			LEAVE ManejoErrores;
		END IF;

		SELECT Estatus, ClienteID  INTO Var_CreStatus, Var_ClienteID
			FROM CREDITOS
				WHERE CreditoID = Par_CreditoID;

		SET Var_CreStatus := IFNULL(Var_CreStatus, Cadena_Vacia);

		IF Var_CreStatus= Cadena_Vacia THEN
			SET Par_NumErr 		:= 002;
			SET Par_ErrMen 		:= CONCAT('El Credito no Existe.');
			SET Var_Control 	:= 'creditoID' ;
			LEAVE ManejoErrores;
		END IF;

		IF(Aud_ProgramaID != "CLIENTESCANCELAPRO")THEN
			IF (Var_CreStatus != Cre_Vigente AND Var_CreStatus != Cre_Vencido  AND Var_CreStatus != Cre_Castigado AND Var_CreStatus != Estatus_Suspendido) THEN
					SET Par_NumErr 		:= 003;
					SET Par_ErrMen 		:= CONCAT('Estatus del Credito Incorrecto.');
					SET Var_Control 	:= 'creditoID' ;
					LEAVE ManejoErrores;
			END IF;
		END IF;


		IF(IFNULL(Par_Transaccion, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr 		:= 004;
			SET Par_ErrMen 		:= CONCAT('El Numero de Movimiento esta Vacio.');
			SET Var_Control 	:= 'creditoID' ;
			SET Var_Consecutivo := '0';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_FechaOperacion, Fecha_Vacia)) = Fecha_Vacia THEN
			SET Par_NumErr 		:= 005;
			SET Par_ErrMen 		:= CONCAT('La Fecha Op. esta Vacia.');
			SET Var_Control 	:= 'fecha' ;
			SET Var_Consecutivo := Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_FechaAplicacion, Fecha_Vacia)) = Fecha_Vacia THEN
			SET Par_NumErr 		:= 006;
			SET Par_ErrMen 		:= CONCAT('La Fecha de la Aplicacion del Movimiento esta Vacia.');
			SET Var_Control 	:= 'fecha' ;
			SET Var_Consecutivo := Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_NatMovimiento, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr 		:= 007;
			SET Par_ErrMen 		:= CONCAT('La Naturaleza del Movimiento esta Vacia.');
			SET Var_Control 	:= 'natMovimiento' ;
			SET Var_Consecutivo := Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

		IF(Par_NatMovimiento<>Nat_Cargo)THEN
			IF(Par_NatMovimiento<>Nat_Abono)THEN
				SET Par_NumErr 		:= 008;
				SET Par_ErrMen 		:= CONCAT('La Naturaleza del Movimiento no es Correcta.');
				SET Var_Control 	:= 'natMovimiento' ;
				SET Var_Consecutivo := Cadena_Vacia;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_NatMovimiento<>Nat_Abono)THEN
			IF(Par_NatMovimiento<>Nat_Cargo)THEN
				SET Par_NumErr 		:= 009;
				SET Par_ErrMen 		:= CONCAT('La Naturaleza del Movimiento no es Correcta.');
				SET Var_Control 	:= 'natMovimiento' ;
				SET Var_Consecutivo := Cadena_Vacia;
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(IFNULL(Par_Cantidad, Decimal_Cero)) <= Decimal_Cero THEN
			SET Par_NumErr 		:= 010;
			SET Par_ErrMen 		:= CONCAT('Cantidad del Movimiento de Credito Incorrecta.');
			SET Var_Control 	:= 'cantidad' ;
			SET Var_Consecutivo := 0;
			LEAVE ManejoErrores;
		END IF;


		IF(IFNULL(Par_Descripcion, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr 		:= 011;
			SET Par_ErrMen 		:= CONCAT('La Descripcion del Movimiento esta Vacia.');
			SET Var_Control 	:= 'descripcion' ;
			SET Var_Consecutivo := 0;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Referencia, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr 		:= 012;
			SET Par_ErrMen 		:= CONCAT('La Referencia esta Vacia.');
			SET Var_Control 	:= 'referencia' ;
			SET Var_Consecutivo := 0;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_TipoMovCreID, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr 		:= 013;
			SET Par_ErrMen 		:= CONCAT('El Tipo de Movimiento esta Vacio.');
			SET Var_Control 	:= 'tipoMovCreID' ;
			SET Var_Consecutivo := '0';
			LEAVE ManejoErrores;
		END IF;

		IF(NOT EXISTS(SELECT AmortizacionID
							FROM AMORTICREDITO
								WHERE CreditoID 		= Par_CreditoID
									AND AmortizacionID	= Par_AmortiCreID)) THEN
			SET Par_NumErr 		:= 014;
			SET Par_ErrMen 		:= CONCAT('La Amortizacion no Existe.');
			SET Var_Control 	:= 'amortizacionID' ;
			SET Var_Consecutivo := '0';
			LEAVE ManejoErrores;
		END IF;

		SET Mov_Cantidad = Par_Cantidad;

		IF (Par_NatMovimiento = Nat_Abono AND Par_TipoMovCreID = Mov_OtrasComisiones) THEN
			# Se incrementa el monto Pagado
			UPDATE DETALLEACCESORIOS SET
				MontoPagado	= MontoPagado + Mov_Cantidad
				WHERE CreditoID = Par_CreditoID
				AND AccesorioID = Par_AccesorioID
                AND AmortizacionID = Par_AmortiCreID;
		END IF;

		IF (Par_NatMovimiento = Nat_Abono) THEN
			SET Mov_Cantidad := Mov_Cantidad * -1;
		END IF;

		IF(Par_TipoMovCreID = Mov_OtrasComisiones) THEN
			IF(Par_NatMovimiento=Nat_Cargo)THEN
				# SI LA NATURALEZA DEL MOVIMIENTO ES UN CARGO, EL SALDO VIGENTE DEL ACCESORIO DISMINUYE
				UPDATE DETALLEACCESORIOS SET
					SaldoVigente	= SaldoVigente + Mov_Cantidad
					WHERE CreditoID = Par_CreditoID
					AND AccesorioID = Par_AccesorioID
                    AND AmortizacionID = Par_AmortiCreID;

				UPDATE AMORTICREDITO SET
					SaldoOtrasComis = SaldoOtrasComis + Mov_Cantidad
					WHERE CreditoID  = Par_CreditoID
					AND AmortizacionID  = Par_AmortiCreID;

				UPDATE CREDITOS SET
					SaldoOtrasComis = SaldoOtrasComis + Mov_Cantidad
					WHERE CreditoID  = Par_CreditoID;
			ELSE
				# SI LA NATURALEZA DEL MOVIMIENTO ES UN ABONO, EL SALDO VIGENTE DEL ACCESORIO AUMENTA
				UPDATE DETALLEACCESORIOS SET
					SaldoVigente	= SaldoVigente + Mov_Cantidad
					WHERE CreditoID = Par_CreditoID
					AND AccesorioID = Par_AccesorioID
					AND AmortizacionID = Par_AmortiCreID;

				UPDATE AMORTICREDITO SET
					SaldoOtrasComis = SaldoOtrasComis + Mov_Cantidad
					WHERE CreditoID  = Par_CreditoID
					AND AmortizacionID  = Par_AmortiCreID;

				UPDATE CREDITOS SET
					SaldoOtrasComis = SaldoOtrasComis + Mov_Cantidad
					WHERE CreditoID  = Par_CreditoID;
			END IF;

		END IF;

        IF(Par_TipoMovCreID = Mov_IVAOtrasComisiones) THEN
			IF(Par_NatMovimiento=Nat_Cargo)THEN
				# SI LA NATURALEZA DEL MOVIMIENTO ES UN CARGO, EL SALDO VIGENTE DEL ACCESORIO DISMINUYE
				UPDATE DETALLEACCESORIOS SET
					SaldoIVAAccesorio	= SaldoIVAAccesorio + Mov_Cantidad
					WHERE CreditoID = Par_CreditoID
					AND AccesorioID = Par_AccesorioID
                    AND AmortizacionID = Par_AmortiCreID;

				UPDATE AMORTICREDITO SET
					SaldoIVAComisi = SaldoIVAComisi + Mov_Cantidad
					WHERE CreditoID  = Par_CreditoID
					AND AmortizacionID  = Par_AmortiCreID;
			ELSE
				# SI LA NATURALEZA DEL MOVIMIENTO ES UN ABONO, EL SALDO VIGENTE DEL ACCESORIO AUMENTA
				UPDATE DETALLEACCESORIOS SET
					SaldoIVAAccesorio	= SaldoIVAAccesorio + Mov_Cantidad
					WHERE CreditoID = Par_CreditoID
					AND AccesorioID = Par_AccesorioID
                    AND AmortizacionID = Par_AmortiCreID;

				UPDATE AMORTICREDITO SET
					SaldoIVAComisi	= SaldoIVAComisi + Mov_Cantidad
					WHERE CreditoID	= Par_CreditoID
					AND AmortizacionID  = Par_AmortiCreID;

			END IF;

		END IF;

		IF (Par_TipoMovCreID = Var_TipoMovIntAcc) THEN

			UPDATE DETALLEACCESORIOS SET
				SaldoInteres	= SaldoInteres + Mov_Cantidad,
				MontoIntPagado	= IF (Par_NatMovimiento = Nat_Abono, MontoPagado + Par_Cantidad, MontoPagado)
			WHERE CreditoID = Par_CreditoID
			  AND AccesorioID = Par_AccesorioID
			  AND AmortizacionID = Par_AmortiCreID;

			UPDATE AMORTICREDITO SET
				SaldoIntOtrasComis = SaldoIntOtrasComis + Mov_Cantidad
				WHERE CreditoID  = Par_CreditoID
				  AND AmortizacionID  = Par_AmortiCreID;

		END IF;

		IF (Par_TipoMovCreID = Var_TipoMovIvaIntAc) THEN

			UPDATE DETALLEACCESORIOS SET
				SaldoIVAInteres	= SaldoIVAInteres + Par_Cantidad
			WHERE CreditoID = Par_CreditoID
			  AND AccesorioID = Par_AccesorioID
			  AND AmortizacionID = Par_AmortiCreID;

			UPDATE AMORTICREDITO SET
				SaldoIVAIntComisi = SaldoIVAIntComisi + Par_Cantidad
				WHERE CreditoID  = Par_CreditoID
				  AND AmortizacionID  = Par_AmortiCreID;

		END IF;

		INSERT CREDITOSMOVS (
				CreditoID, 				AmortiCreID, 		Transaccion, 		FechaOperacion, 		FechaAplicacion,
				TipoMovCreID, 			NatMovimiento, 		MonedaID, 			Cantidad,				Descripcion,
				Referencia,				PolizaID,			EmpresaID,			Usuario,				FechaActual,
				DireccionIP,			ProgramaID,			Sucursal,			NumTransaccion)
		VALUES(	Par_CreditoID,			Par_AmortiCreID,	Par_Transaccion,	Par_FechaOperacion,		Par_FechaAplicacion,
				Par_TipoMovCreID,		Par_NatMovimiento,	Par_MonedaID,		Par_Cantidad,			Par_Descripcion,
				Par_Referencia,			Par_Poliza,			Aud_EmpresaID,		Aud_Usuario,			Aud_FechaActual,
				Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion  );

		IF (Par_Descripcion = Des_PagoCred AND Aud_ProgramaID = Pro_PagCre) THEN
			CALL DETALLEPAGCREPRO(
				Par_AmortiCreID,	Par_CreditoID,		Par_FechaOperacion,	Par_Transaccion,	Var_ClienteID,
				Par_Cantidad,		Par_TipoMovCreID,	Par_OrigenPago,		Salida_NO,			Par_NumErr,
				Par_ErrMen,			Par_ModoPago,		Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr > Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;

		SET Par_NumErr	:= 000;
		SET Par_ErrMen	:= CONCAT('Movimiento de Credito Agregado Exitosamente.');
		SET Var_Control	:= 'cuentaAhoID' ;
		SET Par_Consecutivo := Entero_Cero;
		SET Var_Consecutivo := CONCAT(Par_Consecutivo);
	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr 	AS NumErr,
				Par_ErrMen 	AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo	AS consecutivo;
	END IF;

END TerminaStore$$