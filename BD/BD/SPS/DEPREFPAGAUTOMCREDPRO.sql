-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DEPREFPAGAUTOMCREDPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `DEPREFPAGAUTOMCREDPRO`;
DELIMITER $$


CREATE PROCEDURE `DEPREFPAGAUTOMCREDPRO`(
# =================================================================================
# - SP PARA APLICAR AUTOMATICAMENTE EL PAGO DE CREDITO DE DEPOSITOS REFERENCIADOS
# =================================================================================
	Par_CreditoID			BIGINT(12),				-- ID del credito
	Par_InstitucionID		INT(11),				-- ID de la institucion
	Par_BancoEstandar		CHAR(1),				-- Indica Layout Estandar(E) o Bancario(B)
	Par_MontoMov 			DECIMAL(12,2),			-- Monto del Movimiento
	INOUT Par_Consecutivo	BIGINT, 				-- Numero Consecutivo

	INOUT Var_MontoPago		DECIMAL(12,2),			-- Monto del Pago
	INOUT Var_Poliza		BIGINT,					-- Numero de Poliza
	Par_OrigenPago			CHAR(1),				-- Origen de Pago S: SPEI, V: Ventanilla, C: Cargo A Cta, N: Nomina, D: Domiciliado, R: Depositos Referenciados, W: WebService, O: Otros, Cadena Vacia en caso que no sea un op de pago mov operativos
	Par_Salida				CHAR(1),				-- Parametro de Salida SI o NO
	INOUT Par_NumErr		INT(11),				-- Numero de Error

	INOUT Par_ErrMen		VARCHAR(400),			-- Mensaje de error
	Aud_EmpresaID			INT(11),				-- Parametro de Auditoria
	Aud_Usuario				INT(11),				-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,				-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),			-- Parametro de Auditoria

	Aud_ProgramaID			VARCHAR(50),			-- Parametro de Auditoria
	Aud_Sucursal			INT(11),				-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)				-- Parametro de Auditoria
)

TerminaStore: BEGIN


	-- DECLARACION DE VARIABLES
	DECLARE Var_TipoLayout			INT(11);		-- Tipo de Layout
	DECLARE Var_PagoCredAutom		CHAR(1);		-- SI o NO aplica automaticamente el pago de credito
	DECLARE Var_SinExigible			CHAR(1);		-- Indica la accion a realizar en caso de NO exigible
	DECLARE Var_Sobrante			CHAR(1);		-- Indica la accion a realizar en caso de Sobrante
	DECLARE Var_ProductoCredID		INT(11);		-- ID del producto de credito
	DECLARE Var_MonedaID			INT(11);		-- Tipo de moneda
	DECLARE Var_ClienteID			INT(11);		-- ID del cliente
	DECLARE Var_CuentaAhoID			BIGINT(12);		-- ID de la cuenta de ahorro
	DECLARE Var_EstatusCredito		CHAR(1);		-- Estatus del Credito
	DECLARE Var_MontoExigible		DECIMAL(14,2);	-- Monto exigible del credito
	DECLARE Var_MontoAdeudo			DECIMAL(14,2);	-- Monto total de la deuda
	DECLARE Var_PermitePrepago		CHAR(1);		-- Permite prepago
	DECLARE Var_TipoPrepago			CHAR(1);		-- Tipo de Prepago
	DECLARE Var_MontoSobante		DECIMAL(14,2);	-- Monto Sobrante
	DECLARE Var_Control				VARCHAR(30);	-- Variable de Control
	DECLARE Var_Finiquito			CHAR(1);		-- SI o NO es finiquito del credito
	DECLARE Var_MontoPagoAplica		DECIMAL(14,2);	-- Monto a apliar
	DECLARE Var_ParamCobranzaReferID	INT(11);	-- Variable para guardar la configuracion del producto de credito consultado
	DECLARE Var_AplicaCobranzaRef		CHAR(1);	-- Variable para guardar la configuracion del producto de credito consultado
	DECLARE Cadena_Vacia				CHAR(1);
	DECLARE Estatus_Vigente				CHAR(1);
	DECLARE Estatus_Vencido				CHAR(1);
	DECLARE Var_EsAgropecuario			CHAR(1);

	-- DECLARACION DE CONSTANTES
	DECLARE Layout_Estandar			TINYINT;		-- Corresponte al tipo de Layout Estandar
	DECLARE Layout_Banorte			TINYINT;		-- Corresponde al tipo de Layout BANORTE
	DECLARE Layout_Banamex			TINYINT;		-- Corresponde al tipo de Layou BANAMEX
	DECLARE Layout_Bancomer			TINYINT;		-- COrresponde al tipo de Layout BANCOMER
	DECLARE Tipo_Banco				CHAR(1);		-- Indica que es formato de una institucion bancaria (B)
	DECLARE Tipo_Estandar			CHAR(1);		-- Indica que es un formato estandar (E)
	DECLARE Ins_Banorte				INT(2);			-- Constante para la institucion Bancaria BANORTE
	DECLARE Ins_Banamex				INT(2);			-- Constante para la institucion Bancaria BANAMEX
	DECLARE Ins_Bancomer			INT(2);			-- Constante para la institucion Bancaria BANCOMER
	DECLARE Constante_SI			CHAR(1);		-- Constante SI
	DECLARE Constante_NO			CHAR(1);		-- Constante NO
	DECLARE Decimal_Cero			DECIMAL(12,2);	-- Constante DECIMAL Cero
	DECLARE Estatus_Pagado			CHAR(1);		-- Estatus Pagado (P) del credito
	DECLARE Accion_PrepagoCred		CHAR(1);		-- Prepago de Credito (P)
	DECLARE Pago_CargoCuenta   		CHAR(1);		-- Pago Cargo a Cuenta (C)
	DECLARE Entero_Cero				TINYINT;		-- Constante Entero Cero
	DECLARE Entero_UNO				TINYINT;		-- Constante ENtero 1
    DECLARE Decimal_UNO				DECIMAL(12,2);	-- Constante Decimal UNO
	DECLARE RespaldaCredSI			CHAR(1);

	DECLARE Naturaleza_Bloq		CHAR(1);
	DECLARE TipoBloq			INT(11);
	DECLARE FechaDelSistema		DATE;
	DECLARE Descrip_Bloq		VARCHAR(200);
	DECLARE Cons_ExigibleAbono	CHAR(1);			-- Constante en caso de no tener exigible Abono a cuenta
	DECLARE Cons_SobranteAbono	CHAR(1);			-- En caso de tener sobrante realizar Abono a cuenta
	
	
	
	-- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia        	:= '';
	SET Layout_Estandar			:= 1;
	SET Layout_Banorte			:= 2;
	SET Layout_Banamex			:= 3;
	SET Layout_Bancomer			:= 4;
	SET Tipo_Banco				:= 'B';
	SET Tipo_Estandar			:= 'E';
	SET Ins_Banorte				:= 24;
	SET Ins_Banamex				:= 9;
	SET Ins_Bancomer			:= 37;
	SET Constante_SI			:= 'S';
	SET Constante_NO			:= 'N';
	SET Decimal_Cero			:= 0.0;
	SET Estatus_Pagado			:= 'P';
	SET Accion_PrepagoCred		:= 'P';
	SET Pago_CargoCuenta		:= 'C';
	SET Entero_Cero				:= 0;
	SET Entero_UNO				:= 1;
	SET Decimal_UNO				:= 1.0;
	SET RespaldaCredSI			:= 'S';

	SET Naturaleza_Bloq		:= 'B';
	SET TipoBloq			:= 26;
	SET FechaDelSistema		:= (SELECT FechaSistema FROM PARAMETROSSIS);
	SET Descrip_Bloq		:= 'BLOQUEO AUT. COBRANZA REFERENCIADO';	
	SET Cons_ExigibleAbono	:= 'A';			-- Constante en caso de no tener exigible Abono a cuenta
	SET Cons_SobranteAbono	:= 'A';			-- En caso de tener sobrante realizar Abono a cuenta
	SET Estatus_Vigente		:= 'V';
	SET Estatus_Vencido		:= 'B';

	ManejoErrores: BEGIN
			DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
				SET Par_NumErr  := 999;
				SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-DEPREFPAGAUTOMCREDPRO');
				SET Var_Control := 'SQLEXCEPTION' ;
			END;

	-- SE IDENTIFICA EL TIPO LAYOUT
		IF(Par_BancoEstandar = Tipo_Banco) THEN
			IF(Par_InstitucionID = Ins_Banorte) THEN
				SET Var_TipoLayout := Layout_Banorte;
			ELSEIF (Par_InstitucionID = Ins_Banamex) THEN
				SET Var_TipoLayout := Layout_Banamex;
			ELSEIF (Par_InstitucionID = Ins_Bancomer) THEN
				SET Var_TipoLayout := Layout_Bancomer;
			END IF;
		ELSE
			SET Var_TipoLayout := Layout_Estandar;
		END IF;

		-- SE CONSULTA LA PARAMETRIZACION DE ACUERDO AL TIPO DE LAYOUT
		SELECT PagoCredAutom,		Exigible,			Sobrante
		INTO Var_PagoCredAutom,		Var_SinExigible,	Var_Sobrante
		FROM PARAMDEPREFER
		WHERE TipoArchivo = Var_TipoLayout;

		-- Si NO permite pago automatico
	/*	IF(Var_PagoCredAutom != Constante_SI) THEN
			SET Par_NumErr  := 0;
			SET Par_ErrMen  := CONCAT('La parametrizacion no permite pago de credito automatico.');
			LEAVE ManejoErrores;
		END IF;
	*/

		IF(Par_MontoMov < Decimal_UNO) THEN
			SET Par_NumErr  := 0;
			SET Par_ErrMen  := CONCAT('El Monto a Pagar no debe ser menor a 1');
			LEAVE ManejoErrores;
		END IF;

		-- SE CONSULTA LA INFORMACION DEL CREDITO
		SELECT ClienteID,			CuentaID,				MonedaID,			Estatus,			ProductoCreditoID
		INTO Var_ClienteID,		Var_CuentaAhoID,		Var_MonedaID,		Var_EstatusCredito,	Var_ProductoCredID
		FROM CREDITOS
		WHERE CreditoID = Par_CreditoID;

    SELECT EsAgropecuario
        INTO Var_EsAgropecuario
      FROM PRODUCTOSCREDITO
      WHERE ProducCreditoID = Var_ProductoCredID;

	SET Var_EsAgropecuario	:= IFNULL(Var_EsAgropecuario,Constante_NO );

		-- Consultamos la parametrizacion de cobranza referenciada
		SELECT ParamCobranzaReferID,		AplicaCobranzaRef
			INTO Var_ParamCobranzaReferID,	Var_AplicaCobranzaRef
			FROM PARAMCOBRANZAREFER
			WHERE ConsecutivoID = Var_TipoLayout
			AND ProducCreditoID = Var_ProductoCredID;

		SET Var_ParamCobranzaReferID	:= IFNULL(Var_ParamCobranzaReferID,Entero_Cero);
		SET Var_AplicaCobranzaRef		:= IFNULL(Var_AplicaCobranzaRef	,Constante_NO);

		IF(Var_EstatusCredito = Estatus_Pagado) THEN
			SET Par_NumErr  := 0;
			SET Par_ErrMen  := CONCAT('El Credito ya esta pagado');
			LEAVE ManejoErrores;
		END IF;

		-- SE REALIZARA EL BLOQUEO DEL SALDO SI NO SE TIENE CONFIGURACION DEL TIPO DE LAYOUT PERMITE REALIZAR PAGO AUTOMATICO DE CREDITO
		-- LOS PRODUCTOS QUE NO SE ENCUENTRAN PARAMETRIZADO TAMBIEM SE REALIZA EL BLOQUEO AUTOMATICAMENTE
		IF(Var_PagoCredAutom = Constante_NO AND Var_AplicaCobranzaRef = Constante_SI AND Var_EstatusCredito IN (Estatus_Vigente,Estatus_Vencido) AND Var_EsAgropecuario = Constante_NO) THEN
			CALL BLOQUEOSPRO(	Entero_Cero,		Naturaleza_Bloq,	Var_CuentaAhoID,	FechaDelSistema,	Par_MontoMov,
								Aud_FechaActual,	TipoBloq,			Descrip_Bloq,		Par_CreditoID,		Cadena_Vacia,
								Cadena_Vacia,		Constante_NO,		Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
								Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
								Aud_NumTransaccion);

			-- SE VALIDA QUE NO HAYA DEVUELTO MENSAJE DE ERROR
				IF (Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;
		END IF;

		-- SI LA CONFIGURACION DEL TIPO DE LAYOUT PERMITE REALIZAR PAGO AUTOMATICO DE CREDITO
		IF(Var_PagoCredAutom = Constante_SI) THEN
			SET Var_MontoExigible := (SELECT FUNCIONEXIGIBLE(Par_CreditoID));
			SET Var_MontoExigible := IFNULL(Var_MontoExigible,Decimal_Cero);

			SET Var_PermitePrepago := (SELECT PermitePrepago FROM PRODUCTOSCREDITO WHERE ProducCreditoID = Var_ProductoCredID);
			SET Var_PermitePrepago := IFNULL(Var_PermitePrepago, Constante_NO);

			SET Var_MontoAdeudo := (SELECT FNTOTALADEUDO(Par_CreditoID));
			SET Var_MontoAdeudo	:= IFNULL(Var_MontoAdeudo,Decimal_Cero);

			IF(Par_MontoMov > Var_MontoExigible AND Par_MontoMov < Var_MontoAdeudo) THEN
				SET Var_MontoPagoAplica := Var_MontoExigible;
				SET Par_MontoMov := Par_MontoMov - Var_MontoPagoAplica;
				SET Var_Finiquito := Constante_NO;

			ELSEIF(Par_MontoMov > Var_MontoExigible AND Par_MontoMov >= Var_MontoAdeudo) THEN
				SET Var_MontoPagoAplica := Var_MontoAdeudo;
				SET Par_MontoMov := Par_MontoMov - Var_MontoPagoAplica;
				SET Var_Finiquito := Constante_SI;

			ELSE
				SET Var_MontoPagoAplica := Par_MontoMov;
				SET Par_MontoMov := Par_MontoMov - Var_MontoPagoAplica;
				SET Var_Finiquito := Constante_NO;
			END IF;

			-- LLAMADA AL SP DE PAGO DE CREDITO
			CALL PAGOCREDITOPRO(
						Par_CreditoID,			Var_CuentaAhoID,		Var_MontoPagoAplica,Entero_UNO,			Constante_NO,
						Var_Finiquito,			Aud_EmpresaID,			Constante_NO,		Constante_NO,		Var_MontoPago,
						Var_Poliza,				Par_NumErr,				Par_ErrMen,			Par_Consecutivo,	Pago_CargoCuenta,
						Par_OrigenPago,			RespaldaCredSI,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
						Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion
			);
			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			IF(Var_PermitePrepago = Constante_NO)THEN
				SET Par_NumErr  := 0;
				SET Par_ErrMen  := CONCAT('El producto de credito no permite prepago');
				LEAVE ManejoErrores;
			END IF;

			IF(Var_SinExigible  = Accion_PrepagoCred AND Var_MontoExigible = Decimal_Cero) THEN
				CALL PREPAGOCREDITOPRO(
					Par_CreditoID,		Var_CuentaAhoID,	Par_MontoMov,		Entero_UNO,			Aud_EmpresaID,
					Constante_NO,		Constante_NO,		Var_MontoPago,		Var_Poliza,			Par_NumErr,
					Par_ErrMen,			Par_Consecutivo,	Pago_CargoCuenta,	Par_OrigenPago,		RespaldaCredSI,
					Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
					Aud_NumTransaccion
				);
				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

			ELSEIF(Var_Sobrante = Accion_PrepagoCred AND Par_MontoMov > Decimal_UNO AND Var_MontoExigible > Decimal_Cero) THEN
				CALL PREPAGOCREDITOPRO(
					Par_CreditoID,		Var_CuentaAhoID,	Par_MontoMov,		Entero_UNO,			Aud_EmpresaID,
					Constante_NO,		Constante_NO,		Var_MontoPago,		Var_Poliza,			Par_NumErr,
					Par_ErrMen,			Par_Consecutivo,	Pago_CargoCuenta,	Par_OrigenPago,		RespaldaCredSI,
					Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
					Aud_NumTransaccion
				);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;
			
			-- REALIZAMOS LA EVALUACION PARA EL BLOQUEO DE SALDO SI SE TIENE HABILITADA COBRANZA REFERENCIADA TOMANDO EN CUENTA
			-- QUE EN LAS OPCIONES DE "EN CASO DE TENER SOBRANTE" Y "EN CASO DE SOBRANTE" SE TENGA HABILITADO ABONO A CUENTA.
			IF ( Par_MontoMov > Entero_Cero AND Var_Finiquito <> Constante_SI AND Var_EstatusCredito IN (Estatus_Vigente,Estatus_Vencido) AND Var_EsAgropecuario = Constante_NO) THEN
				IF((Var_SinExigible = Cons_ExigibleAbono AND Var_AplicaCobranzaRef = Constante_SI) OR (Var_Sobrante = Cons_SobranteAbono AND Var_AplicaCobranzaRef = Constante_SI)) THEN
					CALL BLOQUEOSPRO(	Entero_Cero,		Naturaleza_Bloq,	Var_CuentaAhoID,	FechaDelSistema,	Par_MontoMov,
										Aud_FechaActual,	TipoBloq,			Descrip_Bloq,		Par_CreditoID,		Cadena_Vacia,
										Cadena_Vacia,		Constante_NO,		Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
										Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
										Aud_NumTransaccion);

					-- SE VALIDA QUE NO HAYA DEVUELTO MENSAJE DE ERROR
					IF (Par_NumErr != Entero_Cero) THEN
						LEAVE ManejoErrores;
					END IF;
				END IF;
			END IF;
		END IF;

		SET Par_NumErr := 0;
		SET Par_ErrMen := CONCAT('Deposito Referenciado y Pago de Credito Realizado Exitosamente');

	END ManejoErrores;


	-- Si la salida es SI devuelve mensaje de exito
	IF (Par_Salida = Constante_SI) THEN
    SELECT	Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control	AS Control,
			Par_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$
