-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOCREDITOAGROPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOCREDITOAGROPRO`;

DELIMITER $$
CREATE PROCEDURE `PAGOCREDITOAGROPRO`(
	/* SP DE PROCESO QUE REALIZA EL PAGO DE CREDITO AGRO */
	Par_CreditoID			BIGINT(12),		-- ID del Crédito.
	Par_CuentaAhoID			BIGINT(12),		-- ID de la Cuenta de Ahorro a la que se le hará el cargo.
	Par_MontoPagar			DECIMAL(14,2),	-- Monto a Pagar
	Par_MonedaID			INT(11),		-- ID de la Moneda.
	Par_EsPrePago			CHAR(1),		-- Indica si es Prepago S. Si N. No

	Par_Finiquito			CHAR(1),		-- Indica si es Finiquito S. Si N. No
	Par_CreditoR			INT(11),		-- Porcentaje del Crédito Activo.
	Par_CreditoRC			INT(11),		-- Porcentaje del Crédito Contingente.
	Par_EmpresaID			INT(11),		-- ID de la Empresa
	Par_Salida				CHAR(1),		-- Indica el tipo de Salida.

	Par_AltaEncPoliza		CHAR(1),		-- Indica si se da de alta el Encabezado de la póliza. S. Si N. No
	INOUT Par_MontoPago		DECIMAL(14,2),	-- Monto de Pago del Credito
	INOUT Par_Poliza		BIGINT(20),		-- Numero de Poliza
	INOUT Par_NumErr		INT(11),		-- Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- Mensaje de Error

	INOUT Par_Consecutivo	BIGINT,			-- Numero Consecutivo de Pago
	Par_ModoPago			CHAR(1),		-- Modo de Pago
	Par_Origen				CHAR(1),		-- Origen del Pago

	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_CreditoID			BIGINT(12);		-- Numero de Credito
	DECLARE	Var_EstatusCre			CHAR(1);		-- Estatus del Credito
	DECLARE	Var_EstatusGarFIRA		CHAR(1);		-- Estatus de Aplicacion de la Garantia Fira
	DECLARE Var_PermitePrepago		CHAR(1);		-- Verificador del Prepago para el Credito
	DECLARE	Var_MonedaID			INT(11);		-- Moneda del Credito
	DECLARE Var_Control				VARCHAR(100);	-- Control de retorno a pantalla
	DECLARE Var_TotalAdeudo 		DECIMAL(14,2);	-- Total Adeudo del Credito
	DECLARE Var_TotalAdeudoCont		DECIMAL(14,2);	-- Total Adeudo del Credito Contigente
	DECLARE Var_PagoExigible		DECIMAL(14,2);	-- Pago Exigible del Credito
	DECLARE Var_PagoExigibleCont	DECIMAL(14,2);	-- Pago Exigible del Credito Contigente
	DECLARE Var_MontoContingente	DECIMAL(14,2);	-- Monto Contigente
	DECLARE Var_MontoActivo			DECIMAL(14,2);	-- Monto Activo
	DECLARE Var_AltaPoliza			CHAR(1);		-- Alta de Poliza
	DECLARE Var_MontoPagado			DECIMAL(14,2);	-- Monto de Pago del Credito
	DECLARE Var_Poliza 				BIGINT;			-- Numero de Poliza
	DECLARE Var_DiferenciaPago		DECIMAL(14,2);	-- Diferencia de Pago
	DECLARE Var_CreditoPasivoID		BIGINT;			-- Numero de Credito Pasivo
	DECLARE Var_PagoExigiblePas		DECIMAL(14,2);	-- Pago Exigible del Credito Pasivo
	DECLARE Var_TotalAdeudoPas		DECIMAL(14,2);	-- Total de Adeudo del Credito Pasivo
	DECLARE Var_LineaFondeoID		INT(11);		-- ID linea de fondeo
	DECLARE Var_InstitutFondID		INT(11);		-- ID instituto de fondeo
	DECLARE Var_EstatusCreFondeo	CHAR(1);		-- Estatus del Credito Fondeador

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia			CHAR(1);		-- Constante String Vacio
	DECLARE Constante_NO			CHAR(1);		-- Constante Constante NO
	DECLARE Constante_SI			CHAR(1);		-- Constante Constante SI
	DECLARE Fecha_Vacia				DATE;			-- Constante Fecha Vacia
	DECLARE Entero_Cero				INT(11);		-- Constante Entero  Cero
	DECLARE Decimal_Cero			DECIMAL(12, 2);	-- Constante Decimal Cero
	DECLARE Decimal_Cien			DECIMAL(12, 2);	-- Constante Decimal Cien
	DECLARE Estatus_Inactivo		CHAR(1);		-- Constante Estatus Inactivo
	DECLARE Estatus_Aplicado		CHAR(1);		-- Constante Estatus Aplicado
	DECLARE Origen_Agropecuario		CHAR(1);		-- Constante Origen Pago Agropecuario
	DECLARE Estatus_Vigente			CHAR(1);		-- Constante Estatus Vigente
	DECLARE Est_Pagado				CHAR(1);		-- Constante Estauts Pagado

	-- Asignacion de Constantes
	SET Cadena_Vacia		:= '';
	SET Constante_NO		:= 'N';
	SET Constante_SI		:= 'S';
	SET Fecha_Vacia			:= '1900-01-01';
	SET Entero_Cero			:= 0;
	SET Decimal_Cero		:= 0.00;
	SET Decimal_Cien		:= 100.00;
	SET Estatus_Inactivo	:= 'I';
	SET Estatus_Aplicado	:= 'P';
	SET Origen_Agropecuario	:= 'W';
	SET Estatus_Vigente		:= 'V';
	SET Est_Pagado			:= 'P';

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									 'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGOCREDITOAGROPRO');
			SET Var_Control	:= 'SQLEXCEPTION';
		END;

		SET Aud_FechaActual     := NOW();
		SET Var_AltaPoliza		:= Constante_NO;
		SET Var_Poliza 			:= Par_Poliza;

		SELECT  Cre.CreditoID,	Cre.Estatus,		Cre.EstatusGarantiaFIRA,    Pro.PermitePrepago,	    Cre.MonedaID
		INTO    Var_CreditoID,	Var_EstatusCre, 	Var_EstatusGarFIRA,    		Var_PermitePrepago,		Var_MonedaID
		FROM PRODUCTOSCREDITO Pro
		INNER JOIN CREDITOS Cre ON Pro.ProducCreditoID = Cre.ProductoCreditoID
		WHERE Cre.CreditoID	= Par_CreditoID;

		IF(IFNULL(Var_CreditoID,Entero_Cero)=Entero_Cero)THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := 'El Numero de Credito No Existe.';
			SET Var_Control:= 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_MontoPagar,Decimal_Cero) <= Decimal_Cero )THEN
			SET Par_NumErr := 2;
			SET Par_ErrMen := 'El Monto debe de ser Mayor a 0.';
			SET Var_Control:= 'montoPagar';
			LEAVE ManejoErrores;
		END IF;

		SET Var_PermitePrepago  := IFNULL(Var_PermitePrepago,Constante_NO);
		SET Par_Origen			:= Origen_Agropecuario;
		-- Primero valida si se cuenta con Garantias FIRA aplicadas para realizar pago contingente y pasivo,
		-- en caso de no estar aplicadas solo realiza el pago del credito
		IF(IFNULL(Var_EstatusGarFIRA,Estatus_Inactivo) = Estatus_Aplicado)THEN
			-- Se asignan los montos para activo y contingente
			SET Var_MontoActivo 	 := (Par_MontoPagar * Par_CreditoR) / Decimal_Cien;
			SET Var_MontoActivo 	 := IFNULL(Var_MontoActivo,Decimal_Cero);
			SET Var_MontoContingente := Par_MontoPagar - Var_MontoActivo;
			SET Var_MontoContingente := IFNULL(Var_MontoContingente,Decimal_Cero);

			SET	Var_TotalAdeudo 		:= FUNCIONCONFINIQCRE(Par_CreditoID);
			SET Var_PagoExigible 		:= FUNCIONEXIGIBLE(Par_CreditoID);
			SET	Var_TotalAdeudoCont 	:= FUNCIONTOTDEUDACRECONT(Par_CreditoID);
			SET Var_PagoExigibleCont 	:= FUNCIONEXIGIBLECONT(Par_CreditoID);

			/* Si se trata de un finiquito se valida el monto del adeudo contingente y activo */
			IF Par_Finiquito = Constante_SI THEN
				IF (Var_TotalAdeudo + Var_TotalAdeudoCont )  <> Par_MontoPagar THEN
					SET Par_NumErr := 40;
					SET Par_ErrMen := concat('El monto a pagar no coincide con el adeudo total. Pago: $',FORMAT(Par_MontoPagar,2) ,',  Total Adeudo: $',FORMAT(Var_TotalAdeudo + Var_TotalAdeudoCont,2));
					SET Var_Control:= 'montoPagar';
					LEAVE ManejoErrores;
				END IF;

				/* Se asignan los montos para finiquitar ambos creditos */
				SET Var_MontoActivo := Var_TotalAdeudo;
				SET Var_MontoContingente := Var_TotalAdeudoCont;

			END IF;

			-- Primero se realiza pago del credito Activo
			IF(Var_MontoActivo>Decimal_Cero)THEN

				-- adeudos del credito
				SET	Var_TotalAdeudo 	:= FUNCIONCONFINIQCRE(Par_CreditoID);
				SET Var_PagoExigible 	:= FUNCIONEXIGIBLE(Par_CreditoID);
				SET Var_TotalAdeudo		:= IFNULL(Var_TotalAdeudo,Entero_Cero);
				SET Var_PagoExigible	:= IFNULL(Var_PagoExigible,Entero_Cero);

				-- Se realiza llamada a SP encargado de validar si se tratan de pagos o prepago.
				CALL PAGOCREDACTIVOAGROPRO(
					Par_CreditoID,		Par_CuentaAhoID,	Var_MontoActivo,	Par_MonedaID,		Var_TotalAdeudo,
					Var_PagoExigible,	Par_EmpresaID,		Constante_NO,		Var_AltaPoliza,		Var_MontoPagado,
					Var_Poliza,			Par_NumErr,			Par_ErrMen,			Par_Consecutivo,	Par_ModoPago,
					Par_Origen,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
					Aud_Sucursal,		Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

				-- Se validara si el credito Pasivo se encuentra activo para realizar el pago
				SELECT  Re.CreditoFondeoID	INTO Var_CreditoPasivoID
				FROM RELCREDPASIVOAGRO Re
				WHERE Re.CreditoID=Par_CreditoID
				  AND  EstatusRelacion= Estatus_Vigente;

				SELECT Estatus
				INTO 	Var_EstatusCreFondeo
				FROM CREDITOFONDEO
				WHERE CreditoFondeoID=Var_CreditoPasivoID;

				IF(IFNULL(Var_CreditoPasivoID,Entero_Cero)>Entero_Cero)THEN
					-- Obtenemos los datos de linea e institucion de fondeo del credito y adeudos del credito
					-- adeudos del credito
					SET	Var_TotalAdeudoPas 	:= FUNCIONTOTALPASIVO(Var_CreditoPasivoID);
					SET Var_PagoExigiblePas := FNEXIGIBLEPASIVO(Var_CreditoPasivoID);
					SET Var_TotalAdeudoPas	:= IFNULL(Var_TotalAdeudoPas,Entero_Cero);
					SET Var_PagoExigiblePas	:= IFNULL(Var_PagoExigiblePas,Entero_Cero);

					SELECT LineaFondeoID, InstitutFondID INTO Var_LineaFondeoID,Var_InstitutFondID
					FROM CREDITOFONDEO
					WHERE CreditoFondeoID=Var_CreditoPasivoID;

					/* Validar si el monto de pago, supera el monto del credito pasivo, solo se hace el pago para finiquitar */
					IF Var_TotalAdeudoPas < Var_MontoActivo THEN
						SET Var_MontoActivo := Var_TotalAdeudoPas;
					END IF;

					-- Se realiza el pago del credito pasivo si su estatus es diferente de pagado
					IF( IFNULL(Var_EstatusCreFondeo, Cadena_Vacia) != Est_Pagado) THEN
						-- llamada SP que realizara pago o prepago de acuerdo a los montos
						CALL PAGOCREDPASIVOAGROPRO(
							Var_CreditoPasivoID,	Var_MontoActivo,		Par_MonedaID,			Var_TotalAdeudoPas,		Var_PagoExigiblePas,
							Var_AltaPoliza,			Var_LineaFondeoID,		Var_InstitutFondID,		Var_MontoPagado,		Var_Poliza,
							Constante_NO,			Par_NumErr,				Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,
							Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
							Aud_NumTransaccion);

						IF(Par_NumErr != Entero_Cero)THEN
							LEAVE ManejoErrores;
						END IF;
					END IF;

				END IF;-- fin de pago pasivo correspondiente al credito activo

				-- inicializar valores en cero
				SET Var_TotalAdeudo		:= Entero_Cero;
				SET Var_PagoExigible	:= Entero_Cero;
				SET Var_TotalAdeudoPas	:= Entero_Cero;
				SET Var_PagoExigiblePas	:= Entero_Cero;

			END IF; -- Fin pago Credito Activo

			-- Realizar Pago del contingente
			IF(Var_MontoContingente>Decimal_Cero)THEN
				-- Obtenemos los montos de exigible y total del adeudo del credito contingente
				SET	Var_TotalAdeudo 	:= FUNCIONTOTDEUDACRECONT(Par_CreditoID);
				SET Var_PagoExigible 	:= FUNCIONEXIGIBLECONT(Par_CreditoID);
				SET Var_TotalAdeudo		:= IFNULL(Var_TotalAdeudo,Entero_Cero);
				SET Var_PagoExigible	:= IFNULL(Var_PagoExigible,Entero_Cero);

				-- llamada a SP encargado de validar si se tratan de pagos o prepago.
				CALL PAGOCREDCONTAGROPRO(
					Par_CreditoID,		Par_CuentaAhoID,	Var_MontoContingente,	Par_MonedaID,		Var_TotalAdeudo,
					Var_PagoExigible,	Par_EmpresaID,		Constante_NO,			Var_AltaPoliza,		Var_MontoPagado,
					Var_Poliza,			Par_NumErr,			Par_ErrMen,				Par_Consecutivo,	Par_ModoPago,
					Par_Origen,			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
					Aud_Sucursal,		Aud_NumTransaccion	);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

				-- Validar pasivo contingente
				SELECT  CreditoFondeoID	INTO Var_CreditoPasivoID
				FROM CREDITOSCONT
				WHERE CreditoID=Par_CreditoID;

				IF(IFNULL(Var_CreditoPasivoID,Entero_Cero)>Entero_Cero)THEN
					-- Obtenemos los datos de linea e institucion de fondeo del credito y adeudos del credito
					-- adeudos del credito
					SET	Var_TotalAdeudoPas 	:= FUNCIONTOTALPASIVO(Var_CreditoPasivoID);
					SET Var_PagoExigiblePas := FNEXIGIBLEPASIVO(Var_CreditoPasivoID);
					SET Var_TotalAdeudoPas	:= IFNULL(Var_TotalAdeudoPas,Entero_Cero);
					SET Var_PagoExigiblePas	:= IFNULL(Var_PagoExigiblePas,Entero_Cero);

					SELECT LineaFondeoID, InstitutFondID, Estatus
					INTO Var_LineaFondeoID,Var_InstitutFondID,Var_EstatusCreFondeo
					FROM CREDITOFONDEO
					WHERE CreditoFondeoID=Var_CreditoPasivoID;

					/* Validar si el pago supera el monto de adeudo del contingente pasivo, solo se paga el monto de finiquio */
					IF( IFNULL(Var_EstatusCreFondeo, Cadena_Vacia) != Est_Pagado) THEN
						IF Var_TotalAdeudoPas < Var_MontoContingente then
							SET Var_MontoContingente := Var_TotalAdeudoPas;
						END IF;

						-- llamada SP que realizara pago o prepago de acuerdo a los montos
						CALL PAGOCREDPASIVOAGROPRO(
							Var_CreditoPasivoID,	Var_MontoContingente,	Par_MonedaID,			Var_TotalAdeudoPas,		Var_PagoExigiblePas,
							Var_AltaPoliza,			Var_LineaFondeoID,		Var_InstitutFondID,		Var_MontoPagado,		Var_Poliza,
							Constante_NO,			Par_NumErr,				Par_ErrMen,				Par_Consecutivo,		Par_EmpresaID,
							Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
							Aud_NumTransaccion);

						IF(Par_NumErr != Entero_Cero)THEN
							LEAVE ManejoErrores;
						END IF;

					END IF;
				END IF;-- fin de pago pasivo correspondiente al credito contingente
			END IF; -- fin pago contingente
		ELSE -- Si no existen garantias aplicadas se realiza pago de credito activo unicamente por el monto total indicado

			-- adeudos del credito
			SET	Var_TotalAdeudo 	:= FUNCIONCONFINIQCRE(Par_CreditoID);
			SET Var_PagoExigible 	:= FUNCIONEXIGIBLE(Par_CreditoID);
			SET Var_TotalAdeudo		:= IFNULL(Var_TotalAdeudo,Entero_Cero);
			SET Var_PagoExigible	:= IFNULL(Var_PagoExigible,Entero_Cero);

			-- Se realiza llamada a SP encargado de validar si se tratan de pagos o prepago.
			CALL PAGOCREDACTIVOAGROPRO(
				Par_CreditoID,		Par_CuentaAhoID,	Par_MontoPagar,		Par_MonedaID,		Var_TotalAdeudo,
				Var_PagoExigible,	Par_EmpresaID,		Constante_NO,		Var_AltaPoliza,		Var_MontoPagado,
				Var_Poliza,			Par_NumErr,			Par_ErrMen,			Par_Consecutivo,	Par_ModoPago,
				Par_Origen,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,		Aud_NumTransaccion	);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;-- Fin garantias aplicadas

		SET Par_NumErr		:= Entero_Cero;
		SET Par_ErrMen		:= 'Pago Aplicado Exitosamente';
		SET Par_Consecutivo	:= Entero_Cero;
		SET Var_Control		:= 'creditoID';

	END ManejoErrores;

	IF (Par_Salida = Constante_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Par_Consecutivo AS Consecutivo;
	END IF;
END TerminaStore$$