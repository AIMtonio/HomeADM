-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONSOLIDACIONAGROPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONSOLIDACIONAGROPRO`;

DELIMITER $$
CREATE PROCEDURE `CONSOLIDACIONAGROPRO`(
	-- Store Procedure para calcular el saldo interes a proyectar
	-- Solicitud de Credito Agro --> Registro --> Alta solicitud Credito Consolidado
	Par_CreditoID				BIGINT(12),			-- Folio de Consolidacion
	Par_CuentaAhoID				BIGINT(12),			-- Folio de Consolidacion
	INOUT Par_PolizaID			BIGINT(20),			-- Numero de Transaccion de la tabla en sesion

	Par_Salida					CHAR(1),			-- Indica si se muestra mensaje de exito o no
	INOUT Par_NumErr			INT(11),			-- Numero de error
	INOUT Par_ErrMen			VARCHAR(400),		-- Mensaje de error

	Aud_EmpresaID				INT(11),			-- Parametro de auditoria
	Aud_Usuario					INT(11),			-- Parametro de auditoria
	Aud_FechaActual				DATETIME,			-- Parametro de auditoria
	Aud_DireccionIP				VARCHAR(15),		-- Parametro de auditoria
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de auditoria
	Aud_Sucursal				INT(11),			-- Parametro de auditoria
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de auditoria
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_FechaSistema			DATE;			-- Fecha del Sistema
	DECLARE Var_FechaDesembolso			DATE;			-- Fecha de Desembolso
	DECLARE Var_FechaExigible			DATE;			-- Fecha de Exigibilidad
	DECLARE Var_NumRegistros			INT(11);		-- Numero de Registros Consolidados
	DECLARE Var_Contador				INT(11);		-- Contador para el Ciclo

	DECLARE Var_MonedaID				INT(11);		-- Numero de Moneda del Credito
	DECLARE Var_ClienteID				INT(11);		-- Numero de Cliente
	DECLARE Var_SucursalOrigen			INT(11);		-- Sucursal del cliente
	DECLARE Var_EstatusCreacion			CHAR(1);		-- Estatus de creacion de la consolidacion
	DECLARE Var_CliPagIVA				CHAR(1);		-- Si el cliente Paga IVA

	DECLARE Var_CobraIVAInteres			CHAR(1);		-- Iva de Interes Ordinario
	DECLARE Var_CobraIVAMora			CHAR(1);		-- Iva de Interes Moratorio
	DECLARE Var_TipoLiquidacion			CHAR(1);		-- Tipo de Liquidacion con el que se pagará un credito
	DECLARE Var_EstatusCredito			CHAR(1);		-- Estatus del Credito
	DECLARE Var_NumErr					CHAR(3);		-- Numero de Error

	DECLARE Var_ReferenciaMov			VARCHAR(50);	-- Referencia del movimiento
	DECLARE Var_Control					VARCHAR(100);	-- Control de Retorno en Pantalla
	DECLARE Var_DetalleFolioConsolidaID	BIGINT(12);		-- Folio de Detalle de Consolidacion
	DECLARE Var_CuentaAhoID				BIGINT(12);		-- Cuenta de Ahorro
	DECLARE Var_FolioConsolidacionID	BIGINT(12);		-- Folio de Consolidacion

	DECLARE Var_CreditoID				BIGINT(12);		-- ID de Credito
	DECLARE Var_SolicitudCreditoID		BIGINT(20);		-- ID de Solicitud de Credito
	DECLARE Var_Transaccion				BIGINT(20);		-- Numero de Transaccion
	DECLARE Var_Consecutivo				BIGINT(20);		-- Numero de Consecutivo
	DECLARE Var_IVASucursal				DECIMAL(8, 4);	-- IVA de sucursal

	DECLARE Var_IVAIntOrdinario			DECIMAL(12,2);	-- IVA Interes Ordinario
	DECLARE Var_IVAIntMoratorio			DECIMAL(12,2);	-- IVA Interes Moratorio
	DECLARE Var_IVAGeneral				DECIMAL(12,2);	-- IVA Interes General
	DECLARE Var_CantidadPagar			DECIMAL(12,2);	-- Cantidad a pagar
	DECLARE Var_MontoComApert			DECIMAL(12,2);	-- Monto de Comision por Apertura

	DECLARE Var_IVAComApertura			DECIMAL(12,2);	-- IVA del Monto de Comision por Apertura
	DECLARE Var_TotalAdeudoCap			DECIMAL(14,2);	-- Monto Total de Adeudo Capital
	DECLARE Var_TotalAdeudoInt			DECIMAL(14,2);	-- Monto Total de Adeudo Interes
	DECLARE Var_TotalAdeudoMora			DECIMAL(14,2);	-- Monto Total de Adeudo moratorio
	DECLARE Var_TotalAdeudoCom			DECIMAL(14,2);	-- Monto Total de Adeudo Comision Anual

	DECLARE Var_MontoCredito			DECIMAL(14,2);	-- Monto de Credito
	DECLARE Var_MontoConsolidado		DECIMAL(14,2);	-- Monto de Credito Consolidado
	DECLARE Var_MontoSeguroVida			DECIMAL(14,2);	-- Monto de Seguro de Vida
	DECLARE Var_MontoPago				DECIMAL(14,2);	-- Monto de Pago de Credito
	DECLARE Var_PagoAplicado			DECIMAL(14,2);	-- Monto de Pago Aplicado

	DECLARE Var_TotalAdeudo				DECIMAL(14,2);	-- Total de Adeudo del Credito
	DECLARE Var_CreditoFondeoID			BIGINT(12);		-- ID credito pasivo anterior
	DECLARE Var_MontoDeudaPasivo		DECIMAL(14,2);	-- monto del adeudo en credito pasivo
    DECLARE Var_NumCtaInstit			VARCHAR(20);	-- Numero de Cuenta Bancaria.
    DECLARE Var_InstitucionID			INT(11);		-- ID institucion de linea de fondeo anterior
	DECLARE Var_MontoPagoPasivo			DECIMAL(16,2);	-- MOnto del Pago
	DECLARE Var_ConsecutivoID			BIGINT(20);		-- Consecutivo
	DECLARE Var_LineaFondeoID   		INT(11);		-- Linea de Fondeo anterior, corresponde con la tabla LINEAFONDEADOR
	DECLARE Var_InstitutFondID			INT(11);		-- id de institucion anterior de fondeo corresponde con la tabla INSTITUTFONDEO
	DECLARE Var_IVAPasivo 				DECIMAL(12,2);	-- Guarda el valor del IVA
    DECLARE Var_PagaIVAPasivo 			CHAR(1);		-- Guarda el valor para saber si el credito paga IVA

	-- Declaracion de constantes
	DECLARE Fecha_Vacia				DATE;		-- Constante Fecha Vacia
	DECLARE Entero_Cero				INT(11);	-- Constante Entero en Cero
	DECLARE Entero_Uno				INT(11);	-- Constante Entero en Uno
	DECLARE ConcepContaAbono		INT(11);	-- Concepto Contable tipo ABONO
	DECLARE Mov_DepositoRef			INT(11);	-- ID del movimiento de Bonificacion hace referencia a la tabla TIPOSMOVSAHO

	DECLARE Con_ConceptoCredito		INT(11);	-- ID del concepto de ahorro gace referencia a la tabla CONCEPTOSAHORRO
	DECLARE Cadena_Vacia			CHAR(1);	-- Constante Cadena Vacia
	DECLARE SalidaSI				CHAR(1);	-- Constante Salida SI
	DECLARE SalidaNO				CHAR(1);	-- Constante Salida NO
	DECLARE Con_SI					CHAR(1);	-- Constante SI

	DECLARE Con_NO					CHAR(1);	-- Constante NO
	DECLARE Con_LiquidacionTotal	CHAR(1);	-- Liquidacion Total
	DECLARE PrePago_NO				CHAR(1);	-- El Tipo de Pago No es PrePago
	DECLARE Finiquito_SI			CHAR(1);	-- El Tipo de Pago SI es Finiquito
	DECLARE AltaPoliza_NO			CHAR(1);	-- Alta de Poliza Contable General: NO

	DECLARE Con_CargoCuenta			CHAR(1);	-- Indica que se trata de un pago con cargo a cuenta
	DECLARE Con_Origen				CHAR(1);	-- Constante Origen donde se llama el SP (S= safy, W=WS)
	DECLARE RespaldaCredSI			CHAR(1);	-- Respaldo de Credito
	DECLARE Est_Desembolso			CHAR(1);	-- Estatus Credito Desembolso
	DECLARE Est_Pagado				CHAR(1);	-- Estatus Credito Pagado

	DECLARE Est_Vencido				CHAR(1);	-- Estatus Credito Vencido
	DECLARE Est_Vigente				CHAR(1);	-- Estatus Credito Vigente
	DECLARE Est_Cancelado			CHAR(1);	-- Estatus Credito Cancelado
	DECLARE Est_Atrasado			CHAR(1);	-- Estatus Credito Atrasado
	DECLARE Est_Autorizado			CHAR(1);	-- Constante Estatus Autorizado

	DECLARE Nat_Abono				CHAR(1);	-- Naturaleza de movimiento tipo ABONO
	DECLARE EncPoliza_NO			CHAR(1);	-- NO encabezado de poliza
	DECLARE DetPoliza_SI			CHAR(1);	-- SI al detalle de poliza
    DECLARE Est_Finalizado			CHAR(1);
	DECLARE Con_DescripcionMov		VARCHAR(45);-- Descripcion de movimiento
	DECLARE Decimal_Cero			DECIMAL(14,2);-- Decimal Vacio
	DECLARE MonedaMX				INT(11);	-- Identificador de la moneda

	-- Asignacion de constantes
	SET Fecha_Vacia				:= '1900-01-01';
	SET Entero_Cero				:= 0;
	SET Entero_Uno				:= 1;
	SET Mov_DepositoRef			:= 10;
	SET ConcepContaAbono		:= 30;

	SET Con_ConceptoCredito		:= 1;
	SET Cadena_Vacia			:= '';
	SET SalidaSI				:= 'S';
	SET SalidaNO				:= 'N';
	SET Con_SI					:= 'S';

	SET Con_NO					:= 'N';
	SET Con_LiquidacionTotal	:= 'T';
	SET PrePago_NO				:= 'N';
	SET Finiquito_SI			:= 'S';
	SET AltaPoliza_NO			:= 'N';

	SET Con_CargoCuenta			:= 'C';
	SET Con_Origen				:= 'E';
	SET RespaldaCredSI			:= 'S';
	SET Est_Desembolso			:= 'D';
	SET Est_Pagado				:= 'P';

	SET Est_Vencido				:= 'B';
	SET Est_Vigente				:= 'V';
	SET Est_Cancelado			:= 'C';
	SET Est_Atrasado			:= 'A';
	SET Est_Autorizado			:= 'A';

	SET Nat_Abono				:= 'A';
	SET EncPoliza_NO			:= 'N';
	SET DetPoliza_SI			:= 'S';
    SET Est_Finalizado			:= 'F';
	SET Con_DescripcionMov		:= 'DEPOSITO PAGO DE CREDITO';
	SET Decimal_Cero			:= 0.00;
	SET MonedaMX				:= 1;

	-- Bloque de Manejo de Errores
	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			GET DIAGNOSTICS condition 1
			@Var_SQLState = RETURNED_SQLSTATE, @Var_SQLMessage = MESSAGE_TEXT;
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									 'Disculpe las molestias que esto le ocasiona. Ref: SP-CONSOLIDACIONAGROPRO','[',@Var_SQLState,'-' , @Var_SQLMessage,']');
			SET Var_Control := 'sqlexception';
		END;

		SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS LIMIT Entero_Uno);
		SET Var_FechaSistema := IFNULL(Var_FechaSistema,Fecha_Vacia);

		SET Par_CreditoID := IFNULL(Par_CreditoID,Entero_Cero);
		IF( Par_CreditoID = Entero_Cero)THEN
			SET Par_NumErr  := 1;
			SET Par_ErrMen  := 'El Numero de Credito es vacio.';
			SET Var_Control := 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		SELECT CreditoID,	SolicitudCreditoID
		INTO Var_CreditoID,	Var_SolicitudCreditoID
		FROM CREDITOS
		WHERE CreditoID = Par_CreditoID
		  AND EsAgropecuario = Con_SI
		  AND EsConsolidacionAgro = Con_SI;

		SET Var_CreditoID := IFNULL(Var_CreditoID, Entero_Cero);
		IF( Var_CreditoID = Entero_Cero)THEN
			SET Par_NumErr  := 2;
			SET Par_ErrMen  := 'El Credito No Existe.';
			SET Var_Control := 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		SELECT FolioConsolida,			FechaDesembolso
		INTO Var_FolioConsolidacionID,	Var_FechaDesembolso
		FROM CRECONSOLIDAAGROENC
		WHERE SolicitudCreditoID = Var_SolicitudCreditoID
		  AND CreditoID = Par_CreditoID
		  AND Estatus = Est_Autorizado;

		SET Var_FolioConsolidacionID := IFNULL(Var_FolioConsolidacionID, Entero_Cero);

		IF( IFNULL(Var_FolioConsolidacionID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 3;
			SET Par_ErrMen	:= 'El Credito no tiene un Folio de Consolidacion.';
			SET Var_Control	:= 'folioConsolidacionID';
			LEAVE ManejoErrores;
		END IF;

		SELECT IFNULL(COUNT(FolioConsolida), Entero_Cero)
		INTO Var_NumRegistros
		FROM CRECONSOLIDAAGRODET
		WHERE FolioConsolida = Var_FolioConsolidacionID
		  AND Estatus = Est_Autorizado;

		IF( Var_NumRegistros = Entero_Cero ) THEN
			SET Par_NumErr	:= 4;
			SET Par_ErrMen	:= 'El Folio de Consolidacion no tiene Creditos Autorizados.';
			SET Var_Control	:= 'folioConsolidacionID';
			LEAVE ManejoErrores;
		END IF;

		IF( Var_FechaDesembolso <> Var_FechaSistema ) THEN
			SET Par_NumErr	:= 4;
			IF( Var_FechaDesembolso > Var_FechaSistema ) THEN
				SET Par_ErrMen	:= CONCAT('El Credito: ',Par_CreditoID,' Tiene como fecha Desembolso: ', Var_FechaDesembolso,' por tal motivo no puede realizarse la Operacion.');
			END IF;
			IF( Var_FechaDesembolso < Var_FechaSistema ) THEN
				SET Par_ErrMen	:= CONCAT('La Fecha de Desembolso del Credito: ',Par_CreditoID,' fue el dia: ', Var_FechaDesembolso,' por tal motivo no puede realizarse la Operacion.');
			END IF;
			SET Var_Control	:= 'fechaDesembolso';
			LEAVE ManejoErrores;
		END IF;

		DELETE FROM TMPCRECONSOLIDAAGRO
		WHERE FolioConsolidaID = Var_FolioConsolidacionID
		  AND Transaccion = Aud_NumTransaccion;

		SET @RegistroID := Entero_Cero;
		SET Var_NumRegistros := Entero_Cero;
		INSERT INTO TMPCRECONSOLIDAAGRO (
			RegistroID,
			DetalleFolioConsolidaID,	FolioConsolidaID,	SolicitudCreditoID,	CreditoID,			Transaccion,
			EmpresaID,					Usuario,			FechaActual,		DireccionIP,		ProgramaID,
			Sucursal,					NumTransaccion)
		SELECT
			(@RegistroID:=@RegistroID +Entero_Uno),
			DetConsolidaID,				FolioConsolida,		SolicitudCreditoID,	CreditoID,			Aud_NumTransaccion,
			Aud_EmpresaID,				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,				Aud_NumTransaccion
		FROM CRECONSOLIDAAGRODET
		WHERE FolioConsolida = Var_FolioConsolidacionID;

		SELECT IFNULL(COUNT(RegistroID), Entero_Cero)
		INTO Var_NumRegistros
		FROM TMPCRECONSOLIDAAGRO
		WHERE FolioConsolidaID = Var_FolioConsolidacionID
		  AND NumTransaccion = Aud_NumTransaccion;

		SET Var_Contador := Entero_Uno;
		SET Var_DetalleFolioConsolidaID	:= Entero_Cero;
		SET Var_SolicitudCreditoID		:= Entero_Cero;
		SET Var_CreditoID 				:= Entero_Cero;
		SET Var_Transaccion 			:= Entero_Cero;
		SET Var_IVAGeneral				:= Entero_Cero;
		SET Var_IVAIntOrdinario			:= Entero_Cero;
		SET Var_IVAIntMoratorio			:= Entero_Cero;
		SET Var_SucursalOrigen			:= Entero_Cero;
		SET Var_CuentaAhoID				:= Entero_Cero;
		SET Var_MonedaID				:= Entero_Cero;
		SET Var_ClienteID				:= Entero_Cero;
		SET Var_LineaFondeoID			:= Entero_Cero;
		SET Var_InstitutFondID			:= Entero_Cero;
		SET Var_CreditoFondeoID			:= Entero_Cero;
		SET Var_InstitucionID 			:= Entero_Cero;

		SET Var_Consecutivo				:= Entero_Cero;
		SET Var_EstatusCredito			:= Cadena_Vacia;
		SET Var_NumErr 					:= Cadena_Vacia;
		SET Var_CliPagIVA				:= Cadena_Vacia;
		SET Var_CobraIVAInteres			:= Cadena_Vacia;
		SET Var_CobraIVAMora			:= Cadena_Vacia;
		SET Var_TipoLiquidacion			:= Cadena_Vacia;
		SET Var_ReferenciaMov			:= Cadena_Vacia;
		SET Var_NumCtaInstit 			:= Cadena_Vacia;
    	SET Var_PagaIVAPasivo 			:= Cadena_Vacia;
		SET Var_IVASucursal				:= Decimal_Cero;
		SET Var_TotalAdeudo 			:= Decimal_Cero;
		SET Var_TotalAdeudoCap			:= Decimal_Cero;
		SET Var_TotalAdeudoInt			:= Decimal_Cero;
		SET Var_MontoConsolidado 		:= Decimal_Cero;
		SET Var_TotalAdeudoMora			:= Decimal_Cero;
		SET Var_TotalAdeudoCom 			:= Decimal_Cero;
		SET Var_MontoComApert			:= Decimal_Cero;
		SET Var_IVAComApertura			:= Decimal_Cero;
		SET Var_MontoSeguroVida			:= Decimal_Cero;
		SET Var_MontoCredito			:= Decimal_Cero;
		SET Var_MontoPago				:= Decimal_Cero;
		SET Var_PagoAplicado			:= Decimal_Cero;
		SET Var_MontoDeudaPasivo		:= Decimal_Cero;
		SET Var_MontoPagoPasivo			:= Decimal_Cero;
		SET Var_IVAPasivo 				:= Decimal_Cero;

		WHILE( Var_Contador <= Var_NumRegistros ) DO

			SELECT 	DetalleFolioConsolidaID,		SolicitudCreditoID,			CreditoID,
					Transaccion
			INTO 	Var_DetalleFolioConsolidaID,	Var_SolicitudCreditoID,		Var_CreditoID,
					Var_Transaccion
			FROM TMPCRECONSOLIDAAGRO
			WHERE RegistroID = Var_Contador
			  AND NumTransaccion = Aud_NumTransaccion;

			SET Var_DetalleFolioConsolidaID	:= IFNULL(Var_DetalleFolioConsolidaID, Entero_Cero);
			SET Var_SolicitudCreditoID		:= IFNULL(Var_SolicitudCreditoID, Entero_Cero);
			SET Var_CreditoID 				:= IFNULL(Var_CreditoID, Entero_Cero);

			SELECT MontoCredito + MontoProyeccion
			INTO Var_MontoConsolidado
			FROM CRECONSOLIDAAGRODET
			WHERE DetConsolidaID = Var_DetalleFolioConsolidaID
			  AND FolioConsolida = Var_FolioConsolidacionID
			  AND SolicitudCreditoID = Var_SolicitudCreditoID
			  AND CreditoID = Var_CreditoID;

			SET Var_MontoConsolidado := IFNULL(Var_MontoConsolidado, Decimal_Cero);

			# Inicializacion de variables
			SELECT  Cli.PagaIVA,	Pro.CobraIVAInteres,	Pro.CobraIVAMora,	Cli.SucursalOrigen, Cre.Estatus
			INTO	Var_CliPagIVA,	Var_CobraIVAInteres,	Var_CobraIVAMora,	Var_SucursalOrigen, Var_EstatusCredito
			FROM CREDITOS Cre
			INNER JOIN CLIENTES Cli	ON Cre.ClienteID = Cli.ClienteID
			INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID
			INNER JOIN DESTINOSCREDITO Des ON  Cre.DestinoCreID  = Des.DestinoCreID
			WHERE Cre.CreditoID = Var_CreditoID;

			SET Var_SucursalOrigen := IFNULL(Var_SucursalOrigen, Entero_Cero);
			SET Var_EstatusCredito := IFNULL(Var_EstatusCredito, Cadena_Vacia);

			-- Se evalua que el Estatus del Credito Ligado no se encuentre Pagado
			IF(Var_EstatusCredito = Cadena_Vacia OR Var_EstatusCredito = Est_Pagado)THEN
				SET Par_NumErr	:= 5;
				SET Par_ErrMen	:= CONCAT('El Credito: ' , Var_CreditoID, ' se encuentra Pagado.');
				SET Var_Control	:= 'creditoID';
				LEAVE ManejoErrores;
			END IF;

			SET Var_EstatusCredito := Cadena_Vacia;

			SELECT IVA
			INTO Var_IVASucursal
			FROM SUCURSALES
			WHERE SucursalID = Var_SucursalOrigen;

			SET Var_IVASucursal 	:= IFNULL(Var_IVASucursal, Decimal_Cero);
			SET Var_CliPagIVA 		:= IFNULL(Var_CliPagIVA, Cadena_Vacia);
			SET Var_CobraIVAInteres	:= IFNULL(Var_CobraIVAInteres, Cadena_Vacia);
			SET Var_CobraIVAMora	:= IFNULL(Var_CobraIVAMora, Cadena_Vacia);

			IF( Var_CliPagIVA = Con_SI ) THEN
				SET Var_IVAGeneral := Var_IVASucursal;

				IF (Var_CobraIVAInteres = Con_SI) THEN
					SET Var_IVAIntOrdinario := Var_IVASucursal;
				END IF;

				IF (Var_CobraIVAMora = Con_SI) THEN
					SET Var_IVAIntMoratorio := Var_IVASucursal;
				END IF;
			END IF;

			SELECT FUNCIONTOTDEUDACRE(Var_CreditoID) INTO Var_TotalAdeudo;

			SET Var_TotalAdeudo := IFNULL(Var_TotalAdeudo, Decimal_Cero);

			IF (Var_TotalAdeudo <= Entero_Cero) THEN
				SET Par_NumErr	:= 111;
				SET Par_ErrMen	:= CONCAT('El Cr&eacute;dito a ', Var_CreditoID, '  No Presenta Adeudos.');
				SET Var_Control	:= 'creditoID';
				LEAVE ManejoErrores;
			END IF;

			SELECT 	SUM(ROUND(IFNULL(SaldoCapVigente, Entero_Cero),2) + ROUND(IFNULL(SaldoCapAtrasa, Entero_Cero),2) +
						ROUND(IFNULL(SaldoCapVencido, Entero_Cero),2) + ROUND(IFNULL(SaldoCapVenNExi, Entero_Cero),2)),
					SUM(ROUND(IFNULL(SaldoInteresOrd, Entero_Cero) + IFNULL(SaldoInteresAtr, Entero_Cero) +
							  IFNULL(SaldoInteresVen, Entero_Cero) + IFNULL(SaldoInteresPro, Entero_Cero) +
							  IFNULL(SaldoIntNoConta, Entero_Cero),2) +
						ROUND(  ROUND(IFNULL(SaldoInteresOrd, Entero_Cero) * Var_IVAIntOrdinario, 2) +
								ROUND(IFNULL(SaldoInteresAtr, Entero_Cero) * Var_IVAIntOrdinario, 2) +
								ROUND(IFNULL(SaldoInteresVen, Entero_Cero) * Var_IVAIntOrdinario, 2) +
								ROUND(IFNULL(SaldoInteresPro, Entero_Cero) * Var_IVAIntOrdinario, 2) +
								ROUND(IFNULL(SaldoIntNoConta, Entero_Cero) * Var_IVAIntOrdinario, 2), 2)),
					SUM(ROUND(IFNULL(SaldoMoratorios, Entero_Cero) + IFNULL(SaldoMoraVencido, Entero_Cero) + IFNULL(SaldoMoraCarVen, Entero_Cero),2) +
						ROUND( ROUND(IFNULL(SaldoMoratorios, Entero_Cero)  * Var_IVAIntMoratorio,2) +
							   ROUND(IFNULL(SaldoMoraVencido, Entero_Cero) * Var_IVAIntMoratorio,2) +
							   ROUND(IFNULL(SaldoMoraCarVen, Entero_Cero)  * Var_IVAIntMoratorio,2), 2)),
					SUM(ROUND(IFNULL(SaldoComFaltaPa, Entero_Cero),2) +  ROUND(ROUND(IFNULL(SaldoComFaltaPa, Entero_Cero),2) * Var_IVAGeneral,2) +
					    ROUND(IFNULL(SaldoComServGar, Entero_Cero),2) +  ROUND(ROUND(IFNULL(SaldoComServGar, Entero_Cero),2) * Var_IVAGeneral,2) +
						ROUND(IFNULL(SaldoOtrasComis, Entero_Cero),2) +  ROUND(ROUND(IFNULL(SaldoOtrasComis, Entero_Cero),2) * Var_IVAGeneral,2) +
						ROUND(IFNULL(SaldoSeguroCuota, Entero_Cero),2) + ROUND(IFNULL(SaldoIVASeguroCuota, Entero_Cero),2))
			INTO	Var_TotalAdeudoCap,		Var_TotalAdeudoInt,
					Var_TotalAdeudoMora,	Var_TotalAdeudoCom
			FROM AMORTICREDITO
			WHERE CreditoID = Var_CreditoID
				AND Estatus IN (Est_Vigente, Est_Vencido, Est_Atrasado );


			SET Var_TotalAdeudoCap	:= IFNULL(Var_TotalAdeudoCap, Decimal_Cero);
			SET Var_TotalAdeudoMora	:= IFNULL(Var_TotalAdeudoMora, Decimal_Cero);
			SET Var_TotalAdeudoCom	:= IFNULL(Var_TotalAdeudoCom, Decimal_Cero);
			SET Var_TotalAdeudoInt	:= IFNULL(Var_TotalAdeudoInt, Decimal_Cero);

			IF(Var_TotalAdeudoCom > Entero_Cero) THEN
				SET Par_NumErr	:= 202;
				SET Par_ErrMen	:= CONCAT('El Cr&eacute;dito Consolidado ',Var_CreditoID,' tiene Adeudo de Comisiones: $', FORMAT(Var_TotalAdeudoCom, 2));
				SET Var_Control	:= 'montoAutorizado';
				LEAVE ManejoErrores;
			END IF;

			IF(Var_TotalAdeudoMora > Entero_Cero) THEN
				SET Par_NumErr	:= 203;
				SET Par_ErrMen	:= CONCAT('El Cr&eacute;dito Consolidado ',Var_CreditoID,' tiene Adeudo de Inter&eacute;s Moratorio: $', FORMAT(Var_TotalAdeudoMora, 2));
				SET Var_Control	:= 'montoAutorizado';
				LEAVE ManejoErrores;
			END IF;

			IF((Var_TotalAdeudoCap + Var_TotalAdeudoInt) != Var_MontoConsolidado ) THEN
				SET Par_NumErr	:= 205;
				SET Par_ErrMen	:= CONCAT('El Monto Autorizado del Cr&eacute;dito Consolidado: ',Var_CreditoID,
										  ' debe ser Igual al Saldo Insoluto de Capital e Inter&eacute;s: $', FORMAT(Var_MontoConsolidado, 2),
										  '<br><b>Capital</b>: $', FORMAT(Var_TotalAdeudoCap, 2),
										  '<br><b>Interés</b>: $', FORMAT(Var_TotalAdeudoInt, 2)
										  );
				SET Var_Control	:= 'montoAutorizado';
				LEAVE ManejoErrores;
			END IF;


			SELECT 	Cre.TipoLiquidacion,	Cre.CuentaID,			Cre.MonedaID,			Cre.MontoComApert,
					Cre.IVAComApertura,		Cre.MontoSeguroVida,	Cre.MontoCredito,		Cre.ClienteID,
					Cre.CantidadPagar,		Cre.InstitFondeoID,		Cre.LineaFondeo
			INTO 	Var_TipoLiquidacion,	Var_CuentaAhoID,		Var_MonedaID,			Var_MontoComApert,
					Var_IVAComApertura,		Var_MontoSeguroVida,	Var_MontoCredito,		Var_ClienteID,
					Var_CantidadPagar,		Var_InstitutFondID,		Var_LineaFondeoID
			FROM CREDITOS Cre
			INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID
			WHERE Cre.CreditoID = Var_CreditoID;

			SET Var_TipoLiquidacion		:= IFNULL(Var_TipoLiquidacion, Cadena_Vacia);
			SET Var_CuentaAhoID			:= IFNULL(Var_CuentaAhoID, Entero_Cero);
			SET Var_MonedaID			:= IFNULL(Var_MonedaID, Entero_Cero);
			SET Var_MontoComApert		:= IFNULL(Var_MontoComApert, Decimal_Cero);
			SET Var_IVAComApertura		:= IFNULL(Var_IVAComApertura, Decimal_Cero);
			SET Var_MontoSeguroVida		:= IFNULL(Var_MontoSeguroVida, Decimal_Cero);
			SET Var_MontoCredito		:= IFNULL(Var_MontoCredito, Decimal_Cero);
			SET Var_ClienteID			:= IFNULL(Var_ClienteID, Entero_Cero);
			SET Var_LineaFondeoID		:= IFNULL(Var_LineaFondeoID, Entero_Cero);
			SET Var_InstitutFondID		:= IFNULL(Var_InstitutFondID, Entero_Cero);

			-- Se realiza el pago del credito por capital e Interes
			IF( Var_TipoLiquidacion = Con_LiquidacionTotal ) THEN
				SET Var_MontoPago := Var_TotalAdeudo;
			ELSE
				SET Var_MontoPago := Var_CantidadPagar;
			END IF;

			SET Var_ReferenciaMov		:= CONCAT(Var_CreditoID);

			SET Var_Consecutivo  := Entero_Cero;

			CALL PAGOCREDITOPRO(
				Var_CreditoID,		Par_CuentaAhoID,	Var_MontoPago,		Var_MonedaID,		PrePago_NO,
				Finiquito_SI,		Aud_EmpresaID,		SalidaNO,			AltaPoliza_NO,		Var_PagoAplicado,
				Par_PolizaID,		Par_NumErr,			Par_ErrMen,			Var_Consecutivo,	Con_CargoCuenta,
				Con_Origen,			RespaldaCredSI,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID, 	Aud_Sucursal,		Aud_NumTransaccion);

			IF( Par_NumErr <> Entero_Cero ) THEN
				LEAVE ManejoErrores;
			END IF;
			-- Se actualizan estos valores para que no permita hacer un desembolso fisico del dinero en ventanilla
			-- Ya que el monto del credito se utiliza para liquidar al que se le esta dando tratamiento
			UPDATE CREDITOS SET
				MontoDesemb		= Var_MontoCredito,
				MontoPorDesemb	= Var_MontoCredito - Var_MontoPago- (Var_MontoComApert + Var_IVAComApertura) - Var_MontoSeguroVida
			WHERE CreditoID = Var_CreditoID;

			SET Var_Control	:= 'creditoID';

			IF( IFNULL(Var_PagoAplicado, Entero_Cero) <= Entero_Cero ) THEN
				SET Par_NumErr	:= 301;
				SET Par_ErrMen	:= CONCAT('No se pudo Realizar el Pago del Credito: ', CONVERT(Var_CreditoID, CHAR),'.');
				LEAVE ManejoErrores;
			END IF;

			-- Consultamos el Credito Origen a Reestructurar o Renovar
			SELECT  Cre.Estatus
			INTO Var_EstatusCredito
			FROM CREDITOS Cre
			WHERE Cre.CreditoID = Var_CreditoID;

			SET Var_EstatusCredito := IFNULL(Var_EstatusCredito, Cadena_Vacia);

			IF( Var_TipoLiquidacion = Con_LiquidacionTotal ) THEN
				IF (Var_EstatusCredito != Est_Pagado) THEN
					SET Par_NumErr	:= 302;
					SET Par_ErrMen	:= CONCAT('El Credito: ', CONVERT(Var_CreditoID, CHAR), ', No fue Liquidado por Completo.');
					LEAVE ManejoErrores;
				END IF;
			END IF;

			-- Se cancelan todas las ministraciones pendientes.
			UPDATE MINISTRACREDAGRO SET
				Estatus 			= Est_Cancelado,
				FechaMinistracion	= Var_FechaSistema,
				UsuarioAutoriza 	= Aud_Usuario,
				FechaAutoriza 		= Var_FechaSistema,

				EmpresaID 			= Aud_EmpresaID,
				Usuario 			= Aud_Usuario,
				FechaActual 		= Aud_FechaActual,
				DireccionIP 		= Aud_DireccionIP,
				ProgramaID 			= Aud_ProgramaID,
				Sucursal 			= Aud_Sucursal,
				NumTransaccion 		= Aud_NumTransaccion
			WHERE CreditoID = Var_CreditoID
			  AND Estatus NOT IN (Est_Desembolso, Est_Cancelado);

			-- Obtenemos valor de credito pasivo
			SELECT  Re.CreditoFondeoID
			INTO	Var_CreditoFondeoID
			FROM RELCREDPASIVOAGRO Re
			WHERE Re.CreditoID = Var_CreditoID
			  AND  EstatusRelacion = Est_Vigente;

			SET Var_CreditoFondeoID := IFNULL(Var_CreditoFondeoID,Entero_Cero);
			-- Valores de IVA
			-- se obtienen los valores requeridos para las operaciones del sp
			SELECT	 IFNULL(PagaIVA,Con_NO),	IFNULL(PorcentanjeIVA/100,0)
				INTO Var_PagaIVAPasivo,			Var_IVAPasivo
			FROM CREDITOFONDEO Cre
			WHERE Cre.CreditoFondeoID = Var_CreditoFondeoID;


			-- Se realiza el pago de credito pasivo si existe
			IF( Var_CreditoFondeoID > Entero_Cero ) THEN

				-- se obtiene total de deuda en pasivo
				-- se compara para saber si el credito pasivo paga o no iva
				IF( Var_PagaIVAPasivo <> Con_SI ) THEN
					SET Var_IVAPasivo := Decimal_Cero;
				ELSE
					SET Var_IVAPasivo := IFNULL(Var_IVAPasivo, Decimal_Cero);
				END IF;

				SELECT   ROUND( IFNULL(
							SUM(ROUND(SaldoCapVigente,2) + ROUND(SaldoCapAtrasad,2) +
								  ROUND(SaldoInteresPro + SaldoInteresAtra,2) +
								  ROUND(ROUND(SaldoInteresPro + SaldoInteresAtra, 2) * Var_IVAPasivo, 2) +
								  ROUND(SaldoComFaltaPa,2) + ROUND(ROUND(SaldoComFaltaPa,2) * Var_IVAPasivo,2) +
								  ROUND(SaldoOtrasComis,2) + ROUND(ROUND(SaldoOtrasComis,2) * Var_IVAPasivo,2) +
								  ROUND(SaldoMoratorios,2) + ROUND(ROUND(SaldoMoratorios,2) * Var_IVAPasivo,2)
								 ),
							   Entero_Cero)
						, 2)
				INTO Var_MontoDeudaPasivo
				FROM AMORTIZAFONDEO
				WHERE CreditoFondeoID = Var_CreditoFondeoID
				  AND Estatus <> Est_Pagado;

				SET Var_MontoDeudaPasivo := IFNULL(Var_MontoDeudaPasivo, Entero_Cero);

				SELECT	lin.NumCtaInstit,	lin.InstitucionID
				INTO 	Var_NumCtaInstit,	Var_InstitucionID
				FROM LINEAFONDEADOR lin
				WHERE lin.LineaFondeoID = Var_LineaFondeoID
				  AND lin.InstitutFondID = Var_InstitutFondID;

				IF( Var_MontoDeudaPasivo > Entero_Cero ) THEN

					CALL PAGOCREDITOFONPRO(
						Var_CreditoFondeoID,	Var_MontoDeudaPasivo,	MonedaMX,				SalidaNO,				Con_NO,
						Var_InstitucionID,		Var_NumCtaInstit,		Con_NO,					Var_MontoPagoPasivo,	Par_PolizaID,
						Par_NumErr,				Par_ErrMen,				Var_ConsecutivoID,		Aud_EmpresaID,			Aud_Usuario,
						Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;
				END IF;

				UPDATE RELCREDPASIVOAGRO SET
					EstatusRelacion = Est_Finalizado
				WHERE CreditoFondeoID = Var_CreditoFondeoID
				  AND CreditoID = Var_CreditoID
				  AND EstatusRelacion = Est_Vigente;
			END IF;


			-- Reinicio de Variables
			SET Var_DetalleFolioConsolidaID	:= Entero_Cero;
			SET Var_SolicitudCreditoID		:= Entero_Cero;
			SET Var_CreditoID 				:= Entero_Cero;
			SET Var_Transaccion 			:= Entero_Cero;
			SET Var_IVAGeneral				:= Entero_Cero;
			SET Var_IVAIntOrdinario			:= Entero_Cero;
			SET Var_IVAIntMoratorio			:= Entero_Cero;
			SET Var_SucursalOrigen			:= Entero_Cero;
			SET Var_CuentaAhoID				:= Entero_Cero;
			SET Var_MonedaID				:= Entero_Cero;
			SET Var_ClienteID				:= Entero_Cero;
			SET Var_LineaFondeoID			:= Entero_Cero;
			SET Var_InstitutFondID			:= Entero_Cero;
			SET Var_CreditoFondeoID			:= Entero_Cero;
			SET Var_InstitucionID 			:= Entero_Cero;
			SET Var_Consecutivo				:= Entero_Cero;
			SET Var_NumCtaInstit 			:= Cadena_Vacia;
    		SET Var_PagaIVAPasivo 			:= Cadena_Vacia;
			SET Var_EstatusCredito			:= Cadena_Vacia;
			SET Var_NumErr 					:= Cadena_Vacia;
			SET Var_CliPagIVA				:= Cadena_Vacia;
			SET Var_CobraIVAInteres			:= Cadena_Vacia;
			SET Var_CobraIVAMora			:= Cadena_Vacia;
			SET Var_TipoLiquidacion			:= Cadena_Vacia;
			SET Var_ReferenciaMov			:= Cadena_Vacia;
			SET Var_IVASucursal				:= Decimal_Cero;
			SET Var_TotalAdeudo 			:= Decimal_Cero;
			SET Var_TotalAdeudoCap			:= Decimal_Cero;
			SET Var_TotalAdeudoInt			:= Decimal_Cero;
			SET Var_MontoConsolidado 		:= Decimal_Cero;
			SET Var_TotalAdeudoMora			:= Decimal_Cero;
			SET Var_TotalAdeudoCom 			:= Decimal_Cero;
			SET Var_MontoComApert			:= Decimal_Cero;
			SET Var_IVAComApertura			:= Decimal_Cero;
			SET Var_MontoSeguroVida			:= Decimal_Cero;
			SET Var_MontoCredito			:= Decimal_Cero;
			SET Var_MontoPago				:= Decimal_Cero;
			SET Var_PagoAplicado			:= Decimal_Cero;
			SET Var_MontoDeudaPasivo		:= Decimal_Cero;
			SET Var_MontoPagoPasivo			:= Decimal_Cero;
			SET Var_IVAPasivo 				:= Decimal_Cero;
			SET Var_Contador 				:= Var_Contador + Entero_Uno;

		END WHILE;

		DELETE FROM TMPCRECONSOLIDAAGRO
		WHERE FolioConsolidaID = Var_FolioConsolidacionID
		  AND Transaccion = Aud_NumTransaccion;

		SELECT 	SolicitudCreditoID
		INTO 	Var_SolicitudCreditoID
		FROM CREDITOS
		WHERE CreditoID = Par_CreditoID;

		SET Aud_NumTransaccion := NOW();
		UPDATE SOLICITUDCREDITO SET
			CreditoID			= Par_CreditoID,
			Estatus				= Est_Desembolso,
			FechaFormalizacion	= Var_FechaSistema,
			FechaInicioAmor		= Var_FechaSistema,

			Usuario				= Aud_Usuario,
			FechaActual 		= Aud_FechaActual,
			DireccionIP 		= Aud_DireccionIP,
			ProgramaID  		= Aud_ProgramaID,
			Sucursal			= Aud_Sucursal,
			NumTransaccion		= Aud_NumTransaccion
		WHERE SolicitudCreditoID = Var_SolicitudCreditoID;

		SET Aud_NumTransaccion := NOW();
		UPDATE REGCRECONSOLIDADOS SET
			FechaLimiteReporte	= FNFECHAREPORTADIASATRASO(CreditoID, Var_FechaSistema),

			Usuario				= Aud_Usuario,
			FechaActual 		= Aud_FechaActual,
			DireccionIP 		= Aud_DireccionIP,
			ProgramaID  		= Aud_ProgramaID,
			Sucursal			= Aud_Sucursal,
			NumTransaccion		= Aud_NumTransaccion
		WHERE CreditoID = Par_CreditoID;


		SET Par_NumErr 	:= Entero_Cero;
		SET Par_ErrMen 	:= CONCAT('Consolidacion de Credito: ', Par_CreditoID,' Realizada Correctamente');
		SET Var_Control	:= 'creditoID';

	END ManejoErrores;
	-- Fin Bloque de Manejo de Errores

	IF (Par_Salida = SalidaSI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Par_CreditoID AS consecutivo;
	END IF;

END TerminaStore$$