-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REVERSAPAGCREPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `REVERSAPAGCREPRO`;

DELIMITER $$
CREATE PROCEDURE `REVERSAPAGCREPRO`(
	# =============================================================================
	# ----- STORE PARA REALIZAR LAS REVERSAS DE PAGO DE CREDITO ------
	# =============================================================================
	Par_CreditoID       BIGINT(12),
	Par_UsuarioClave    VARCHAR(25),
	Par_ContraseniaAut  VARCHAR(45),
	Par_Motivo          VARCHAR(400),
	Par_TranRespaldo    BIGINT(20),
	Par_FormaPago       CHAR(1),

	Par_Salida          CHAR(1),
	INOUT Par_NumErr    INT(11),
	INOUT Par_ErrMen    VARCHAR(400),

	Par_EmpresaID       INT(11),
	Aud_Usuario         INT(11),
	Aud_FechaActual     DATETIME,
	Aud_DireccionIP     VARCHAR(15),
	Aud_ProgramaID      VARCHAR(50),
	Aud_Sucursal        INT(11),
	Aud_NumTransaccion  BIGINT(20)
)
TerminaStore:BEGIN

	DECLARE Var_Control				VARCHAR(100);	-- Nombre del control en la pantalla
	DECLARE ConcepCtaOrdenDeu       INT;
	DECLARE ConcepCtaOrdenCor       INT;
	DECLARE VarSucursalLin          INT;
	DECLARE Var_AltaPoliza          CHAR(1);
	DECLARE Var_MontoPagado         DECIMAL(12,2);
	DECLARE Var_CuentaAhoID         BIGINT(12);
	DECLARE Var_CueGarLiqID         BIGINT(12);
	DECLARE Var_CreditoID           BIGINT(12);
	DECLARE Var_FechaSistema        DATE;
	DECLARE Var_FormaPagoCredito    CHAR(1);
	DECLARE Var_MontoEnFirme        DECIMAL(14,2);
	DECLARE Var_CajaID              INT(12);
	DECLARE Var_SucursalCaja        INT(12);
	DECLARE Var_MonedaID            INT(11);
	DECLARE Var_ManejaLinea         CHAR(1);
	DECLARE Var_EsRevolvente        CHAR(1);
	DECLARE Var_LineaCredito        BIGINT;
	DECLARE Var_MontoPagadoCapital  DECIMAL(14,2);
	DECLARE Var_BloqueoID           INT(11);
	DECLARE Var_MontoBloq           DECIMAL(12,2);
	DECLARE Var_ProdUsaGarLiq       CHAR(1);
	DECLARE Var_LiberaAlLiquidar    CHAR(1);
	DECLARE Var_SaldoDipon          DECIMAL(12,2);
	DECLARE Var_Estatus             CHAR(1);
	DECLARE Var_CreditoIDMov        BIGINT(12);
	DECLARE Var_NumIverNoVig        INT(11);
	DECLARE Var_NumInver            INT(11);
	DECLARE	Var_NumTotInverGar		INT(11);
	DECLARE Var_NumFolio			INT(11);			-- Numero de Folio en BEPAGOSNOMINA
	DECLARE Var_CobraFOGAFI			CHAR(1);		-- Variable par indicar si permite el cobro de garantía financiada
	DECLARE Var_RequiereGarFOGAFI	CHAR(1);		-- Indica si se requiere garantía FOGAFI
	DECLARE Var_RequiereGarantia	CHAR(1);		-- Indica si se requiere el cobro de garantía Liquida(FOGA)
	DECLARE Var_ClienteID			INT(11);		-- Numero de Cliente
	DECLARE Var_MontoDeposito		DECIMAL(14,2);	-- Monto Deposito a Cuenta
	DECLARE Var_MontoPagCredito		DECIMAL(14,2);	-- Monto Pago de Credito
	DECLARE Var_MontoAjustar		DECIMAL(14,2);	-- Monto a Ajustar en el Credito
	DECLARE Var_FormaPago			CHAR(1);		-- Forma de Pago del Credito
	DECLARE Var_OrigenPago			CHAR(2);		-- Origen de Pago del Web 
	DECLARE Var_OrigenDepReferen	INT(11);
	DECLARE Var_MontoTotalDepRef	DECIMAL(14,2); 	-- Monto Total de los depositos referenciados a reversar
	DECLARE Var_ReferenciaMov		VARCHAR(150);
	DECLARE Var_MontoMov			DECIMAL(14,2);
	DECLARE Var_SaldoCuenta			DECIMAL(12,2);

	DECLARE Cadena_Vacia            CHAR(1);
	DECLARE Entero_Cero             INT(11);
	DECLARE Efectivo                CHAR(1);
	DECLARE Salida_SI               CHAR(1);
	DECLARE Salida_NO               CHAR(1);
	DECLARE Decimal_Cero            DECIMAL;
	DECLARE TipoOperacionCaja       INT;
	DECLARE NoManejaLinea           CHAR(1);
	DECLARE SiManejaLinea           CHAR(1);
	DECLARE NoEsRevolvente          CHAR(1);
	DECLARE SiEsRevolvente          CHAR(1);
	DECLARE EstatusDesembolsado     CHAR(1);
	DECLARE ValorSI                 CHAR(1);
	DECLARE CtaEstatusActiva        CHAR(1);
	DECLARE NatDesbloqueo           CHAR(1);
	DECLARE Var_EstatusInver        CHAR(1);
	DECLARE BloqDepositoGA          INT(11);
	DECLARE NaturalezaBloqueo       CHAR(1);
	DECLARE Esta_Vigente			CHAR(1);
	DECLARE Var_MontoComAnualLin 	DECIMAL(14,2);		-- Indica el monto de la comisión anual de la linea de crédito
	DECLARE Var_FechaPago 			DATE;		-- Indica la fecha de pago de la comisión anual
	DECLARE Var_CobraComAnual 		CHAR(1);		-- Indica si cobra comisión anual de linea o no
	DECLARE Con_NO			 		CHAR(1);		-- Constante NO
	DECLARE Con_SI			 		CHAR(1);		-- Constante SI
	DECLARE Var_EsLineaCreditoAgroRevolvente	CHAR(1);	-- Es Linea de Credito Agro Revolvente
	DECLARE Var_Consecutivo			BIGINT(12);		-- Numero de Consecutivo
	DECLARE Var_TotalAplicWSPagID	BIGINT(20);		-- Indica el ID de la bitacora de pagos por WS
	DECLARE Var_InstitucionID		INT(11);		-- Numero de institucion de tesoreria
	DECLARE Var_NumCtaInstit		VARCHAR(20);	-- Numero de Cuenta de de banco de la institucion
	DECLARE Var_RegistroID			INT(11);		-- Numero de Registro
	DECLARE Var_MaxRegistroID		INT(11);		-- Numero Maximo de Registros
	DECLARE Var_PagoReferenciadoWS	CHAR(1);		-- Indica si el pago es referenciado por Web Service
	DECLARE Nat_Abono		 		CHAR(1);		-- Naturaleza Abono
	DECLARE Nat_Cargo		 		CHAR(1);		-- Naturaleza Cargo
	DECLARE Pago_CargoCta 			CHAR(1);		-- Pago con cargo a cuenta
	DECLARE Pago_Efectivo 			CHAR(1);		-- Pago efectivo
	DECLARE Ori_WebService 			CHAR(1);		-- Origen de pago por web service
	DECLARE Reg_Automatico			CHAR(1); 		-- Tipo de registros Automatico por carga de archivo
	DECLARE Est_Cancelado			CHAR(1); 		-- Estatus cancelado para los depositos referenciados
	DECLARE TipoDepositoCCTA		CHAR(1);		-- Deposito de cuenta
	DECLARE TipoMovDepRef			CHAR(4); 		-- Corresponde con la tabla TIPOSMOVTESO (deposito Referenciado)
	DECLARE Entero_Uno				INT(11);		-- Entero Uno
	DECLARE TipoCanalCtaAho			INT(11);		-- Corresponde con la tabla TIPOCANAL
	DECLARE TipoCanalCred			INT(11);		-- Corresponde con el tipo de canal de pago a credito
	DECLARE Con_DepReferenciado		INT(11);		-- Deposito Referenciado de Documento


	SET Cadena_Vacia        := '';
	SET Entero_Cero         := 0;
	SET Efectivo            := 'E';
	SET Salida_SI           := 'S';
	SET Salida_NO           := 'N';
	SET Decimal_Cero        := 0.0;
	SET TipoOperacionCaja   := 28;
	SET NoManejaLinea       := 'N';
	SET SiManejaLinea       := 'S';
	SET NoEsRevolvente      := 'N';
	SET SiEsRevolvente      := 'S';
	SET EstatusDesembolsado := 'D';
	SET ValorSI             := 'S';
	SET CtaEstatusActiva    := 'A';
	SET NatDesbloqueo       := 'D';
	SET Var_SaldoDipon      := 0;
	SET ConcepCtaOrdenDeu   := 53;
	SET ConcepCtaOrdenCor   := 54;
	SET Var_EstatusInver    := "N";
	SET BloqDepositoGA      := 10;
	SET NaturalezaBloqueo   := 'B';
	SET Esta_Vigente		:= 'N';
	SET Con_NO				:= 'N';
	SET Con_SI				:= 'S';
	SET Nat_Abono			:= 'A';
	SET Nat_Cargo			:= 'B';
	SET Pago_CargoCta 		:= 'C';
	SET Pago_Efectivo 		:= 'E';
	SET Ori_WebService 		:= 'W';
	SET Reg_Automatico		:= 'A';
	SET TipoDepositoCCTA	:= 'C';
	SET Est_Cancelado		:= 'C';
	SET TipoMovDepRef		:= '1';
	SET Entero_Uno			:= 1;
	SET TipoCanalCtaAho		:= 2;
	SET Con_DepReferenciado	:= 16;
	SET TipoCanalCred		:= 1;


	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									 'esto le ocasiona. Ref: SP-REVERSAPAGCREPRO');
			SET Var_Control	= 'SQLEXCEPTION';
		END;

		SELECT	FechaSistema INTO Var_FechaSistema FROM PARAMETROSSIS LIMIT 1;
		SET Aud_FechaActual	:= NOW();

		-- Obtiene el parámetro que indica si cobra o no garnatia financiada.
		SET Var_CobraFOGAFI := IFNULL(FNPARAMGENERALES('CobraGarantiaFinanciada'),Con_NO);

		-- Obtiene el parámetro que indica si cobra o no garnatia financiada.
		SET Var_CobraFOGAFI := IFNULL(FNPARAMGENERALES('CobraGarantiaFinanciada'),Con_NO);

		SET Par_EmpresaID		:= IFNULL(Par_EmpresaID, Entero_Cero);
		SET Aud_Usuario			:= IFNULL(Aud_Usuario, Entero_Cero);
		SET Aud_FechaActual		:= IFNULL(Aud_FechaActual, NOW());
		SET Aud_DireccionIP		:= IFNULL(Aud_DireccionIP, Cadena_Vacia);
		SET Aud_ProgramaID		:= IFNULL(Aud_ProgramaID, Cadena_Vacia);
		SET Aud_Sucursal		:= IFNULL(Aud_Sucursal, Entero_Cero);
		SET Aud_NumTransaccion	:= IFNULL(Aud_NumTransaccion, Entero_Cero);

		DELETE FROM TMPREVERSAPAGOCREDITO WHERE TransaccionID = Par_TranRespaldo;

		SET @RegistroID := Entero_Cero;
		INSERT INTO TMPREVERSAPAGOCREDITO (
				RegistroID,
				CreditoID,		TransaccionID,		CuentaAhoID,		MontoPagado,		BloqueoID,
				MontoBloq,							CueGarLiqID,
				EmpresaID,		Usuario,			FechaActual,		DireccionIP,		ProgramaID,
				Sucursal,		NumTransaccion)
		SELECT
				@RegistroID := (@RegistroID + Entero_Uno ),
				Cre.CreditoID,	Par_TranRespaldo,	Cre.CuentaAhoID,	Cre.MontoPagado,	IFNULL(Blo.BloqueoID, Entero_Cero),
				IFNULL(Blo.MontoBloq, Entero_Cero),	IFNULL(Blo.CuentaAhoID, Entero_Cero),
				Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,	Aud_NumTransaccion
		FROM RESPAGCREDITO Cre
		LEFT OUTER JOIN BLOQUEOS Blo ON Blo.Referencia = Cre.CreditoID
									AND Blo.NatMovimiento = NatDesbloqueo
									AND Blo.TiposBloqID = 8
									AND Blo.NumTransaccion = Par_TranRespaldo
		WHERE Cre.TranRespaldo = Par_TranRespaldo;


		SELECT MAX(RegistroID)
		INTO Var_MaxRegistroID
		FROM TMPREVERSAPAGOCREDITO
		WHERE TransaccionID = Par_TranRespaldo;

		SET Var_RegistroID 		:= Entero_Uno;
		SET Var_MaxRegistroID	:= IFNULL(Var_MaxRegistroID, Entero_Cero);

		WHILE (Var_RegistroID <= Var_MaxRegistroID) DO

			SELECT	CuentaAhoID,		CreditoID,		MontoPagado,		BloqueoID,		CueGarLiqID,
					MontoBloq
			INTO 	Var_CuentaAhoID,	Var_CreditoID,	Var_MontoPagado,	Var_BloqueoID,	Var_CueGarLiqID,
					Var_MontoBloq
			FROM TMPREVERSAPAGOCREDITO
			WHERE RegistroID = Var_RegistroID;

			SET Var_CreditoIDMov :=(SELECT CreditoID
									FROM RESCREDITOS
									WHERE TranRespaldo= Par_TranRespaldo
									  AND CreditoID = Var_CreditoID);

			IF EXISTS(SELECT CreditoOrigenID
					  FROM REESTRUCCREDITO
					  WHERE CreditoOrigenID = Var_CreditoID
						AND EstatusReest = EstatusDesembolsado
						AND NumTransaccion = Par_TranRespaldo)THEN

				SET Par_NumErr  := 1;
				SET Par_ErrMen  := 'El pago es por el Otorgamiento de un Credito, Reestructura, La Reversa no puede ser Realizada';
				LEAVE ManejoErrores;
			END IF;

			IF EXISTS(SELECT Transaccion
					  FROM CREDITOSMOVS
					  WHERE CreditoID =Var_CreditoID
						AND Transaccion >Par_TranRespaldo
						AND ProgramaID <> 'MIGRACION')THEN
				SET Par_NumErr  := 2;
				SET Par_ErrMen  := 'Existen Operaciones Posteriores Al pago de Credito, la Reversa no puede ser Realizada';
				LEAVE ManejoErrores;
			END IF;

			SET Var_NumFolio :=(SELECT FolioCargaID
								FROM BEPAGOSNOMINA
								WHERE CreditoID = Var_CreditoID
								  AND FechaAplicacion = Var_FechaSistema
								  AND NumTransaccion = Par_TranRespaldo
								LIMIT 1);

			SET Var_NumFolio := IFNULL(Var_NumFolio, Entero_Cero);


			IF (Var_NumFolio != Entero_Cero)THEN
				SET Par_NumErr  := 3;
				SET Par_ErrMen  := 'El Credito Pertenece a un Folio de Carga, la Reversa no puede ser Realizada.';
				LEAVE ManejoErrores;
			END IF;

			SET Var_RequiereGarFOGAFI := (	SELECT RequiereGarFOGAFI
											FROM DETALLEGARLIQUIDA Det
											WHERE Det.CreditoID = Var_CreditoID);

			SET Var_RequiereGarantia := (	SELECT RequiereGarantia
											FROM DETALLEGARLIQUIDA Det
											WHERE Det.CreditoID = Var_CreditoID);

			SET Var_RequiereGarantia  :=IFNULL(Var_RequiereGarantia,  Con_NO);
			SET Var_RequiereGarFOGAFI :=IFNULL(Var_RequiereGarFOGAFI, Con_NO );

			IF( Var_CobraFOGAFI = Con_SI AND (Var_RequiereGarFOGAFI = Con_SI OR Var_RequiereGarantia = Con_SI)) THEN
				SET Par_NumErr  := 4;
				SET Par_ErrMen  := 'La Reversa no puede ser Realizada, debido a que el Credito cuenta con un Tipo de Garantia FOGAFI.';
				LEAVE ManejoErrores;
			END IF;

			SET Var_BloqueoID   := IFNULL(Var_BloqueoID,Entero_Cero);
			SET Var_CueGarLiqID := IFNULL(Var_CueGarLiqID,Entero_Cero);
			SET Var_MontoBloq   := IFNULL(Var_MontoBloq, Entero_Cero);


			UPDATE CUENTASAHO Cue
			INNER JOIN BLOQUEOS Blo ON Cue.CuentaAhoID = Blo.cuentaAhoID SET
				Cue.SaldoDispon = SaldoDispon + Blo.MontoBloq,
				Cue.SaldoBloq 	= SaldoBloq - Blo.MontoBloq
			WHERE Blo.TiposBloqID = BloqDepositoGA
			  AND Blo.Referencia = Var_CreditoID
			  AND Blo.NatMovimiento = NaturalezaBloqueo
			  AND Blo.NumTransaccion = Par_TranRespaldo;

			DELETE FROM BLOQUEOS
			WHERE TiposBloqID = BloqDepositoGA
			  AND Referencia = Var_CreditoID
			  AND NatMovimiento	= NaturalezaBloqueo
			  AND NumTransaccion = Par_TranRespaldo;


			SET Var_SaldoDipon  :=( SELECT SaldoDispon
									FROM CUENTASAHO
									WHERE CuentaAhoID = Var_CueGarLiqID);

			SET Var_SaldoDipon := IFNULL(Var_SaldoDipon, Decimal_Cero);

			IF(Var_BloqueoID > Entero_Cero)THEN
				IF(Var_MontoBloq > Var_SaldoDipon ) THEN
					SET Par_NumErr  := 3;
					SET Par_ErrMen  := 'Saldo Insuficiente en la Cuenta. No se Puede Realizar el Bloqueo de Garantia Liquida';
					LEAVE ManejoErrores;
				END IF;

				IF EXISTS(SELECT CreditoID
					FROM CREDITODEVGL
					WHERE  CreditoID = Var_CreditoID
						AND CuentaID = Var_CuentaAhoID
						AND Monto = Var_MontoBloq)THEN

					SET Par_NumErr  := 4;
					SET Par_ErrMen  :='Existen Operaciones Posteriores Al pago de Credito, la Reversa no puede ser Realizada';
					LEAVE ManejoErrores;
				END IF;

				DELETE FROM BLOQUEOS
				WHERE BloqueoID = Var_BloqueoID
				  AND CuentaAhoID = Var_CueGarLiqID
				  AND NumTransaccion = Par_TranRespaldo;


				UPDATE BLOQUEOS SET
					FolioBloq = Entero_Cero
				WHERE FolioBloq	= Var_BloqueoID;

				UPDATE CUENTASAHO SET
					SaldoDispon = SaldoDispon - Var_MontoBloq,
					SaldoBloq   = SaldoBloq + Var_MontoBloq
				WHERE CuentaAhoID = Var_CueGarLiqID;

			END IF;

			-- Segmento de reversa de pagos de creditos referenciados por web services
			SET Var_PagoReferenciadoWS 	:= Con_NO;
			SET Var_MontoAjustar 		:= Entero_Cero;

			SELECT	ClienteID
			INTO 	Var_ClienteID
			FROM CREDITOS
			WHERE CreditoID = Var_CreditoID;

			SET Var_ClienteID 	:= IFNULL(Var_ClienteID, Entero_Cero);

			SELECT 	MAX(TotalAplicWSPagID)
			INTO 	Var_TotalAplicWSPagID
			FROM TOTALAPLICADOSWSPAG
			WHERE FechaPago = Var_FechaSistema
			  AND CreditoID = Var_CreditoID
			  AND ClienteID = Var_ClienteID
			  AND NumTransaccion = Par_TranRespaldo;

			SET Var_TotalAplicWSPagID	:= IFNULL(Var_TotalAplicWSPagID, Entero_Cero);

			-- Si existe un pago referenciado de web service se obtiene el monto de deposito y el monto de pago de credito
			IF( Var_TotalAplicWSPagID > Entero_Cero ) THEN

				-- Se obtiene el origen de pago y la forma de pago de la operacion
				SELECT	MAX(FormaPago)
				INTO	Var_FormaPago
				FROM DETALLEPAGCRE
				WHERE CreditoID = Var_CreditoID
				  AND FechaPago = Var_FechaSistema
				  AND Transaccion = Par_TranRespaldo
				  AND ClienteID = Var_ClienteID;

				SELECT	MAX(OrigenPago)
				INTO 	Var_OrigenPago
				FROM DETALLEPAGCRE
				WHERE CreditoID = Var_CreditoID
				  AND FechaPago = Var_FechaSistema
				  AND Transaccion = Par_TranRespaldo
				  AND ClienteID = Var_ClienteID;

				SELECT	CantidadMov
				INTO	Var_MontoDeposito
				FROM CUENTASAHOMOV
				WHERE CuentaAhoID = Var_CuentaAhoID
				  AND NumeroMov = Par_TranRespaldo
				  AND Fecha = Var_FechaSistema
				  AND NatMovimiento = Nat_Abono
				  AND DescripcionMov = 'DEPOSITO A CUENTA'
				  AND ReferenciaMov = Var_CuentaAhoID
				  AND TipoMovAhoID = Con_DepReferenciado;

				SELECT	SUM(MontoTotPago)
				INTO	Var_MontoPagCredito
				FROM DETALLEPAGCRE
				WHERE CreditoID = Var_CreditoID
				  AND FechaPago = Var_FechaSistema
				  AND Transaccion = Par_TranRespaldo
				  AND ClienteID = Var_ClienteID;

				SET Var_FormaPago		:= IFNULL(Var_FormaPago, Cadena_Vacia);
				SET Var_OrigenPago		:= IFNULL(Var_OrigenPago, Cadena_Vacia);
				SET Var_MontoDeposito	:= IFNULL(Var_MontoDeposito, Entero_Cero);
				SET Var_MontoPagCredito	:= IFNULL(Var_MontoPagCredito, Entero_Cero);

				-- se obtiene la institucion de la operacion y
				-- Se elimina el movimiento operativo de tesoreria

				-- Se recomienta actualizar este delete si se modifica el web service referencedCreditPayment
				-- debido a que los resultados de 2 parametros son cadenas pero el ws lo transforma a entero
				-- Asi como la busqueda de la institucion y la cuenta de la institucion(Obtener de la tabla TOTALAPLICADOSWSPAG
				-- agregando el campo de intitucion)

				SELECT 	InstitucionID,		CuentaAhoID
				INTO 	Var_InstitucionID,	Var_NumCtaInstit
				FROM DEPOSITOREFERE
				WHERE FechaCarga = Var_FechaSistema
				  AND FechaAplica = Var_FechaSistema
				  AND NatMovimiento = Nat_Abono
				  AND MontoMov = Var_MontoDeposito
				  AND TipoMov = TipoMovDepRef
				  AND DescripcionMov = CONCAT('DEPOSITO CTA ',Var_CuentaAhoID)
				  AND ReferenciaMov = Var_CuentaAhoID
				  AND TipoDeposito = TipoDepositoCCTA
				  AND TipoCanal = TipoCanalCtaAho
				  AND NumTransaccion = Par_TranRespaldo;

				SET Var_InstitucionID := IFNULL(Var_InstitucionID, Entero_Cero);
				SET Var_NumCtaInstit  := IFNULL(Var_NumCtaInstit, Entero_Cero);

				DELETE FROM TESORERIAMOVS
				WHERE NumeroMov = Entero_Cero
				  AND FechaMov = Var_FechaSistema
				  AND NatMovimiento = Nat_Abono
				  AND MontoMov = Var_MontoDeposito
				  AND TipoMov = TipoMovDepRef
				  AND ReferenciaMov = Var_CuentaAhoID
				  AND TipoRegristro = Reg_Automatico
				  AND NumTransaccion = Par_TranRespaldo;

				-- Se actualiza el saldo de la cuenta de tesoreria
				CALL SALDOSCTATESOREACT(
					Var_NumCtaInstit,	Var_InstitucionID,	Var_MontoDeposito,	Nat_Cargo,		Salida_NO,
					Par_NumErr,			Par_ErrMen,			Var_Consecutivo,	Par_EmpresaID,	Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID, 	Aud_Sucursal, 	Aud_NumTransaccion);

				IF (Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;

				-- Se cancela el deposito referenciado
				UPDATE DEPOSITOREFERE SET
					Status = Est_Cancelado
				WHERE FechaCarga = Var_FechaSistema
				  AND FechaAplica = Var_FechaSistema
				  AND NatMovimiento = Nat_Abono
				  AND MontoMov = Var_MontoDeposito
				  AND TipoMov = TipoMovDepRef
				  AND DescripcionMov = CONCAT('DEPOSITO CTA ',Var_CuentaAhoID)
				  AND ReferenciaMov = Var_CuentaAhoID
				  AND TipoDeposito = TipoDepositoCCTA
				  AND TipoCanal = TipoCanalCtaAho
				  AND NumTransaccion = Par_TranRespaldo;

				-- Se obtiene el monto a ajustar en caso de que el deposito sea mayor al pago del credito
				SET Var_MontoAjustar := Var_MontoDeposito - Var_MontoPagCredito;
				IF( Var_MontoAjustar < Entero_Cero) THEN
					SET Var_MontoAjustar := Entero_Cero;
				END IF;

				IF( Var_FormaPago IN (Pago_CargoCta, Pago_Efectivo) AND Var_OrigenPago = Ori_WebService ) THEN
					SET Var_PagoReferenciadoWS := Con_SI;
				END IF;
			END IF;

			IF(IFNULL(Var_CreditoIDMov, Entero_Cero) > Entero_Cero)THEN

				CALL REVERSAPAGCREALT(
					Par_TranRespaldo,   Var_CreditoID,  Par_UsuarioClave,   Par_ContraseniaAut, Par_Motivo,
					Var_CuentaAhoID,    Salida_NO,      Par_NumErr,         Par_ErrMen,         Par_EmpresaID,
					Aud_Usuario,        Aud_FechaActual,Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
					Aud_NumTransaccion);

				IF (Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

				UPDATE RESCREDITOS RCRE
				INNER JOIN CREDITOS CRE ON RCRE.CreditoID = CRE.CreditoID SET
					CRE.CreditoID 			= RCRE.CreditoID,
					CRE.LineaCreditoID 		= RCRE.LineaCreditoID,
					CRE.ClienteID 			= RCRE.ClienteID,
					CRE.CuentaID 			= RCRE.CuentaID,
					CRE.MonedaID 			= RCRE.MonedaID,
					CRE.ProductoCreditoID 	= RCRE.ProductoCreditoID,
					CRE.DestinoCreID 		= RCRE.DestinoCreID,
					CRE.MontoCredito 		= RCRE.MontoCredito,
					CRE.Relacionado 		= RCRE.Relacionado,
					CRE.SolicitudCreditoID 	= RCRE.SolicitudCreditoID,
					CRE.TipoFondeo 			= RCRE.TipoFondeo,
					CRE.InstitFondeoID 		= RCRE.InstitFondeoID,
					CRE.LineaFondeo 		= RCRE.LineaFondeo,
					CRE.FechaInicio 		= RCRE.FechaInicio,
					CRE.FechaVencimien 		= RCRE.FechaVencimien,
					CRE.CalcInteresID 		= RCRE.CalcInteresID,
					CRE.TasaBase 			= RCRE.TasaBase,
					CRE.TasaFija 			= RCRE.TasaFija,
					CRE.SobreTasa 			= RCRE.SobreTasa,
					CRE.PisoTasa 			= RCRE.PisoTasa,
					CRE.TechoTasa 			= RCRE.TechoTasa,
					CRE.FactorMora 			= RCRE.FactorMora,
					CRE.FrecuenciaCap 		= RCRE.FrecuenciaCap,
					CRE.PeriodicidadCap 	= RCRE.PeriodicidadCap,
					CRE.FrecuenciaInt 		= RCRE.FrecuenciaInt,
					CRE.PeriodicidadInt 	= RCRE.PeriodicidadInt,
					CRE.TipoPagoCapital 	= RCRE.TipoPagoCapital,
					CRE.NumAmortizacion 	= RCRE.NumAmortizacion,
					CRE.MontoCuota 			= RCRE.MontoCuota,
					CRE.FechTraspasVenc 	= RCRE.FechTraspasVenc,
					CRE.FechTerminacion 	= RCRE.FechTerminacion,
					CRE.IVAInteres 			= RCRE.IVAInteres,
					CRE.IVAComisiones 		= RCRE.IVAComisiones,
					CRE.Estatus 			= RCRE.Estatus,
					CRE.FechaAutoriza 		= RCRE.FechaAutoriza,
					CRE.UsuarioAutoriza 	= RCRE.UsuarioAutoriza,
					CRE.SaldoCapVigent 		= RCRE.SaldoCapVigent,
					CRE.SaldoCapAtrasad 	= RCRE.SaldoCapAtrasad,
					CRE.SaldoCapVencido 	= RCRE.SaldoCapVencido,
					CRE.SaldCapVenNoExi 	= RCRE.SaldCapVenNoExi,
					CRE.SaldoInterOrdin 	= RCRE.SaldoInterOrdin,
					CRE.SaldoInterAtras 	= RCRE.SaldoInterAtras,
					CRE.SaldoInterVenc 		= RCRE.SaldoInterVenc,
					CRE.SaldoInterProvi 	= RCRE.SaldoInterProvi,
					CRE.SaldoIntNoConta 	= RCRE.SaldoIntNoConta,
					CRE.SaldoMoratorios 	= RCRE.SaldoMoratorios,
					CRE.SaldoMoraVencido 	= RCRE.SaldoMoraVencido,
					CRE.SaldoMoraCarVen 	= RCRE.SaldoMoraCarVen,
					CRE.SaldoIVAMorator 	= RCRE.SaldoIVAMorator,
					CRE.SaldComFaltPago 	= RCRE.SaldComFaltPago,
					CRE.SalIVAComFalPag 	= RCRE.SalIVAComFalPag,
					CRE.SaldoOtrasComis 	= RCRE.SaldoOtrasComis,
					CRE.SaldoIVAInteres 	= RCRE.SaldoIVAInteres,
					CRE.SaldoIVAComisi 		= RCRE.SaldoIVAComisi,
					CRE.ProvisionAcum 		= RCRE.ProvisionAcum,
					CRE.PagareImpreso 		= RCRE.PagareImpreso,
					CRE.FechaInhabil 		= RCRE.FechaInhabil,
					CRE.CalendIrregular 	= RCRE.CalendIrregular,
					CRE.DiaPagoInteres 		= RCRE.DiaPagoInteres,
					CRE.DiaPagoCapital 		= RCRE.DiaPagoCapital,
					CRE.DiaMesInteres 		= RCRE.DiaMesInteres,
					CRE.DiaMesCapital 		= RCRE.DiaMesCapital,
					CRE.AjusFecUlVenAmo 	= RCRE.AjusFecUlVenAmo,
					CRE.AjusFecExiVen 		= RCRE.AjusFecExiVen,
					CRE.NumTransacSim 		= RCRE.NumTransacSim,
					CRE.FechaMinistrado 	= RCRE.FechaMinistrado,
					CRE.FolioDispersion 	= RCRE.FolioDispersion,
					CRE.SucursalID 			= RCRE.SucursalID,
					CRE.ValorCAT 			= RCRE.ValorCAT,
					CRE.ClasifRegID 		= RCRE.ClasifRegID,
					CRE.MontoComApert 		= RCRE.MontoComApert,
					CRE.IVAComApertura 		= RCRE.IVAComApertura,
					CRE.PlazoID 			= RCRE.PlazoID,
					CRE.TipoDispersion 		= RCRE.TipoDispersion,
					CRE.TipoCalInteres 		= RCRE.TipoCalInteres,
					CRE.MontoDesemb 		= RCRE.MontoDesemb,
					CRE.MontoPorDesemb 		= RCRE.MontoPorDesemb,
					CRE.NumAmortInteres 	= RCRE.NumAmortInteres,
					CRE.AporteCliente 		= RCRE.AporteCliente,
					CRE.MontoSeguroVida 	= RCRE.MontoSeguroVida,
					CRE.SeguroVidaPagado 	= RCRE.SeguroVidaPagado,
					CRE.ForCobroSegVida 	= RCRE.ForCobroSegVida,
					CRE.ComAperPagado 		= RCRE.ComAperPagado,
					CRE.ForCobroComAper 	= RCRE.ForCobroComAper,
					CRE.ClasiDestinCred 	= RCRE.ClasiDestinCred,
					CRE.CicloGrupo 			= RCRE.CicloGrupo,
					CRE.GrupoID 			= RCRE.GrupoID,
					CRE.MontoSeguroCuota	= RCRE.MontoSeguroCuota,
					CRE.IVASeguroCuota		= RCRE.IVASeguroCuota,
					CRE.SaldoComAnual		= RCRE.SaldoComAnual,/*COMISION ANUAL*/
					CRE.EmpresaID 			= RCRE.EmpresaID,
					CRE.Usuario 			= RCRE.Usuario,
					CRE.FechaActual 		= RCRE.FechaActual,
					CRE.DireccionIP 		= RCRE.DireccionIP,
					CRE.ProgramaID 			= RCRE.ProgramaID,
					CRE.Sucursal 			= RCRE.Sucursal,
					CRE.NumTransaccion		= RCRE.NumTransaccion,
					CRE.ComAperCont			= RCRE.ComAperCont,
					CRE.IVAComAperCont		= RCRE.IVAComAperCont,
					CRE.ComAperReest		= RCRE.ComAperReest,
					CRE.IVAComAperReest		= RCRE.IVAComAperReest,
					CRE.FechaAtrasoCapital	= RCRE.FechaAtrasoCapital,
					CRE.FechaAtrasoInteres  = RCRE.FechaAtrasoInteres,
					CRE.CobraAccesorios		= RCRE.CobraAccesorios,
					CRE.SaldoNotCargoRev	= RCRE.SaldoNotCargoRev,	/* NOTA CARGO*/
					CRE.SaldoNotCargoSinIVA	= RCRE.SaldoNotCargoSinIVA,
					CRE.SaldoNotCargoConIVA	= RCRE.SaldoNotCargoConIVA,
					CRE.ManejaComAdmon 		= RCRE.ManejaComAdmon,
					CRE.ComAdmonLinPrevLiq 	= RCRE.ComAdmonLinPrevLiq,
					CRE.ForCobComAdmon 		= RCRE.ForCobComAdmon,
					CRE.ForPagComAdmon 		= RCRE.ForPagComAdmon,
					CRE.PorcentajeComAdmon 	= RCRE.PorcentajeComAdmon,
					CRE.ManejaComGarantia 	= RCRE.ManejaComGarantia,
					CRE.ComGarLinPrevLiq 	= RCRE.ComGarLinPrevLiq,
					CRE.ForCobComGarantia 	= RCRE.ForCobComGarantia,
					CRE.ForPagComGarantia 	= RCRE.ForPagComGarantia,
					CRE.PorcentajeComGarantia = RCRE.PorcentajeComGarantia,
					CRE.MontoPagComAdmon 	= RCRE.MontoPagComAdmon,
					CRE.MontoCobComAdmon 	= RCRE.MontoCobComAdmon,
					CRE.MontoPagComGarantia = RCRE.MontoPagComGarantia,
					CRE.MontoCobComGarantia = RCRE.MontoCobComGarantia,
					CRE.SaldoComServGar		= RCRE.SaldoComServGar,
					CRE.SaldoIVAComSerGar	= RCRE.SaldoIVAComSerGar,
					CRE.MontoPagComGarantiaSim = RCRE.MontoPagComGarantiaSim
				WHERE RCRE.CreditoID = Var_CreditoID
				  AND RCRE.TranRespaldo	= Par_TranRespaldo;

				DELETE FROM RESCREDITOS
				WHERE TranRespaldo = Par_TranRespaldo
				  AND CreditoID = Var_CreditoID;

				UPDATE CUENTASAHO SET
					Saldo       	= (Saldo + Var_MontoPagado),
					SaldoDispon 	= (SaldoDispon + Var_MontoPagado),
					CargosMes   	= (CargosMes - Var_MontoPagado),
					CargosDia   	= (CargosDia - Var_MontoPagado)
				WHERE CuentaAhoID = Var_CuentaAhoID;

				IF(Par_FormaPago = Efectivo OR Var_PagoReferenciadoWS = Con_SI )THEN
					UPDATE CUENTASAHO SET
						Saldo       	= (Saldo - Var_MontoPagado - Var_MontoAjustar),
						SaldoDispon 	= (SaldoDispon - Var_MontoPagado - Var_MontoAjustar),
						AbonosMes   	= (AbonosMes - Var_MontoPagado - Var_MontoAjustar),
						AbonosDia   	= (AbonosDia - Var_MontoPagado - Var_MontoAjustar)
					WHERE CuentaAhoID = Var_CuentaAhoID;
				END IF;


				DELETE FROM AMORTICREDITO
					WHERE	CreditoID	= Var_CreditoID;

				INSERT INTO  AMORTICREDITO (
						`AmortizacionID`,		`CreditoID`,				`ClienteID`,			`CuentaID`,
						`FechaInicio`,			`FechaVencim`,				`FechaExigible`,		`Estatus`,					`FechaLiquida`,
						`Capital`,				`Interes`,					`IVAInteres`,			`SaldoCapVigente`,			`SaldoCapAtrasa`,
						`SaldoCapVencido`,		`SaldoCapVenNExi`,			`SaldoInteresOrd`,		`SaldoInteresAtr`,			`SaldoInteresVen`,
						`SaldoInteresPro`,		`SaldoIntNoConta`,			`SaldoIVAInteres`,		`SaldoMoratorios`,			`SaldoIVAMorato`,
						`SaldoComFaltaPa`,		`SaldoIVAComFalP`,			`MontoOtrasComisiones`,	`MontoIVAOtrasComisiones`,	`SaldoOtrasComis`,
						`SaldoIVAComisi`,		`ProvisionAcum`,			`SaldoCapital`,			`NumProyInteres`,			`SaldoMoraVencido`,
						`SaldoMoraCarVen`,		`MontoSeguroCuota`,			`IVASeguroCuota`,		`SaldoSeguroCuota`,			`SaldoIVASeguroCuota`,
						`SaldoComisionAnual`,	`SaldoComisionAnualIVA`,	`SaldoNotCargoRev`,		`SaldoNotCargoSinIVA`,		`SaldoNotCargoConIVA`,
						`SaldoComServGar`,		`SaldoIVAComSerGar`,		`MontoIVAIntComisi`,	`MontoIntOtrasComis`,		`SaldoIntOtrasComis`,
						`SaldoIVAIntComisi`,
						`EmpresaID`,			`Usuario`,
						`FechaActual`,			`DireccionIP`,				`ProgramaID`,			`Sucursal`,					`NumTransaccion`)

				SELECT
						`AmortizacionID`,		`CreditoID`,				`ClienteID`,			`CuentaID`,
						`FechaInicio`,			`FechaVencim`,				`FechaExigible`,		`Estatus`,					`FechaLiquida`,
						`Capital`,				`Interes`,					`IVAInteres`,			`SaldoCapVigente`,			`SaldoCapAtrasa`,
						`SaldoCapVencido`,		`SaldoCapVenNExi`,			`SaldoInteresOrd`,		`SaldoInteresAtr`,			`SaldoInteresVen`,
						`SaldoInteresPro`,		`SaldoIntNoConta`,			`SaldoIVAInteres`,		`SaldoMoratorios`,			`SaldoIVAMorato`,
						`SaldoComFaltaPa`,		`SaldoIVAComFalP`,			`MontoOtrasComisiones`,	`MontoIVAOtrasComisiones`,	`SaldoOtrasComis`,
						`SaldoIVAComisi`,		`ProvisionAcum`,			`SaldoCapital`,			`NumProyInteres`,			`SaldoMoraVencido`,
						`SaldoMoraCarVen`,		`MontoSeguroCuota`,			`IVASeguroCuota`,		`SaldoSeguroCuota`,			`SaldoIVASeguroCuota`,
						`SaldoComisionAnual`,	`SaldoComisionAnualIVA`,	`SaldoNotCargoRev`,		`SaldoNotCargoSinIVA`,		`SaldoNotCargoConIVA`,
						`SaldoComServGar`,		`SaldoIVAComSerGar`,		`MontoIVAIntComisi`,	`MontoIntOtrasComis`,		`SaldoIntOtrasComis`,
						`SaldoIVAIntComisi`,
						`EmpresaID`,			`Usuario`,
						`FechaActual`,			`DireccionIP`,				`ProgramaID`,			`Sucursal`,					`NumTransaccion`
				FROM RESAMORTICREDITO
				WHERE TranRespaldo = Par_TranRespaldo
				  AND CreditoID = Var_CreditoID;


				DELETE FROM RESAMORTICREDITO
				WHERE TranRespaldo = Par_TranRespaldo
				  AND CreditoID	= Var_CreditoID;


				DELETE FROM CREDITOSMOVS
				WHERE CreditoID	= Var_CreditoID;

				INSERT INTO CREDITOSMOVS (
						`CreditoID`,    `AmortiCreID`,  `Transaccion`,  `FechaOperacion`,   `FechaAplicacion`,
						`TipoMovCreID`, `NatMovimiento`,`MonedaID`,     `Cantidad`,         `Descripcion`,
						`Referencia`,   `EmpresaID`,    `Usuario`,      `FechaActual`,      `DireccionIP`,
						`ProgramaID`,   `Sucursal`,     `NumTransaccion`)

				SELECT  `CreditoID`,    `AmortiCreID`,  `Transaccion`,  `FechaOperacion`,   `FechaAplicacion`,
						`TipoMovCreID`, `NatMovimiento`,`MonedaID`,     `Cantidad`,         `Descripcion`,
						`Referencia`,   `EmpresaID`,    `Usuario`,      `FechaActual`,      `DireccionIP`,
						`ProgramaID`,   `Sucursal`,     `NumTransaccion`
				FROM RESCREDITOSMOVS
				WHERE TranRespaldo = Par_TranRespaldo
				  AND CreditoID	= Var_CreditoID;


				DELETE FROM RESCREDITOSMOVS
				WHERE TranRespaldo = Par_TranRespaldo
				  AND CreditoID = Var_CreditoID;

				-- Inicio Reversa del los pagos de creditos consolidados.
				DELETE FROM REGCRECONSOLIDADOS
				WHERE CreditoID = Var_CreditoID;

				INSERT INTO REGCRECONSOLIDADOS (
					FechaRegistro,		CreditoID,			EstatusCredito,		EstatusCreacion,		NumDiasAtraso,
					NumPagoSoste,		NumPagoActual,		Regularizado,		FechaRegularizacion,	ReservaInteres,
					FechaLimiteReporte,	EmpresaID,			Usuario,			FechaActual,			DireccionIP,
					ProgramaID,			Sucursal,			NumTransaccion)
				SELECT
					FechaRegistro,		CreditoID,			EstatusCredito,		EstatusCreacion,		NumDiasAtraso,
					NumPagoSoste,		NumPagoActual,		Regularizado,		FechaRegularizacion,	ReservaInteres,
					FechaLimiteReporte,	EmpresaID,			Usuario,			FechaActual,			DireccionIP,
					ProgramaID,			Sucursal,			NumTransaccion
				FROM RESREGCRECONSOLIDADOS
				WHERE TranRespaldo = Par_TranRespaldo
				  AND CreditoID = Var_CreditoID;

				DELETE FROM RESREGCRECONSOLIDADOS
				WHERE TranRespaldo = Par_TranRespaldo
				  AND CreditoID = Var_CreditoID;
				-- Final Reversa del los pagos de creditos consolidados.


				-- Inicia reversa de los pagos de creditos consolidados no agro
				DELETE FROM CONSOLIDACIONCARTALIQ
				WHERE CreditoID = Var_CreditoID;

				INSERT INTO CONSOLIDACIONCARTALIQ(
					ConsolidaCartaID, 	ClienteID, 			SolicitudCreditoID, 	Estatus,
					EsConsolidado, 		FlujoOrigen, 		TipoCredito, 			Relacionado, 		MontoConsolida,
					CreditoID,          EstatusCredito,     EstatusCreacion,    	NumDiasAtraso,      NumPagoSoste,
					NumPagoActual,      Regularizado,       FechaRegularizacion,	ReservaInteres,     FechaLimiteReporte,
					EmpresaID,          Usuario,            FechaActual,			DireccionIP,        ProgramaID,
					Sucursal,           NumTransaccion)
				SELECT
					ConsolidaCartaID, 	ClienteID, 			SolicitudCreditoID, 	Estatus,
					EsConsolidado, 		FlujoOrigen, 		TipoCredito, 			Relacionado, 		MontoConsolida,
					CreditoID,          EstatusCredito,     EstatusCreacion,    	NumDiasAtraso,      NumPagoSoste,
					NumPagoActual,      Regularizado,       FechaRegularizacion,	ReservaInteres,     FechaLimiteReporte,
					EmpresaID,          Usuario,            FechaActual,			DireccionIP,        ProgramaID,
					Sucursal,           NumTransaccion
				FROM RESCONSOLIDACIONCARTALIQ
				WHERE TranRespaldo = Par_TranRespaldo
				  AND CreditoID = Var_CreditoID;

				  
				DELETE FROM RESCONSOLIDACIONCARTALIQ
				WHERE TranRespaldo = Par_TranRespaldo
				  AND CreditoID = Var_CreditoID;

				-- Fin Reversa de lo pagos de creditos consolidados no agro.

				SELECT  COUNT(InversionID)  INTO Var_NumInver
				FROM RESCREDITOINVGAR
				WHERE CreditoID	= Var_CreditoID
				  AND TranRespaldo = Par_TranRespaldo;

				SET Var_NumInver	:= IFNULL(Var_NumInver,Entero_cero);

				IF( Var_NumInver > Entero_Cero) THEN
					SELECT COUNT(Inv.Estatus) INTO Var_NumIverNoVig
					FROM RESCREDITOINVGAR Res
					INNER JOIN INVERSIONES Inv ON Res.InversionID = Inv.InversionID
					WHERE Res.CreditoID	= Var_CreditoID
					  AND Res.TranRespaldo = Par_TranRespaldo
					  AND Inv.Estatus != Esta_Vigente;

					SET Var_NumIverNoVig := IFNULL(Var_NumIverNoVig,Entero_cero);

					IF (Var_NumIverNoVig > Entero_Cero) THEN
						SET Par_NumErr  := 5;
						SET Par_ErrMen  := 'La (s) Inversion (es) No esta (n) Vigente (s).' ;
						LEAVE ManejoErrores;
					END IF;

					IF NOT EXISTS(SELECT Inv.CreditoInvGarID
									FROM CREDITOINVGAR Inv
									INNER JOIN RESCREDITOINVGAR Res ON Res.CreditoID = Inv.CreditoID
																   AND Res.CreditoInvGarID = Inv.CreditoInvGarID
									WHERE Res.CreditoID	= Var_CreditoID
									  AND Res.TranRespaldo = Par_TranRespaldo) THEN

						INSERT INTO CREDITOINVGAR(
								`CreditoInvGarID`,  `CreditoID`,        `InversionID`,  `MontoEnGar`,
								`FechaAsignaGar`,   `EmpresaID`,        `Usuario`,      `FechaActual`,
								`DireccionIP`,      `ProgramaID`,       `Sucursal`,     `NumTransaccion`)
						SELECT  `CreditoInvGarID`,  `CreditoID`,        `InversionID`,  `MontoEnGar`,
								`FechaAsignaGar`,   `EmpresaID`,        `Usuario`,      `FechaActual`,
								`DireccionIP`,      `ProgramaID`,       `Sucursal`,     `NumTransaccion`
						FROM RESCREDITOINVGAR
						WHERE TranRespaldo = Par_TranRespaldo
						  AND CreditoID = Var_CreditoID;

						DELETE FROM RESCREDITOINVGAR
						WHERE TranRespaldo = Par_TranRespaldo
						  AND CreditoID = Var_CreditoID;

						DELETE FROM  HISCREDITOINVGAR
						WHERE CreditoID =  Var_CreditoID
						  AND NumTransaccion = Par_TranRespaldo
						  AND Fecha = Var_FechaSistema;
					ELSE
						DELETE FROM RESCREDITOINVGAR
						WHERE TranRespaldo = Par_TranRespaldo
						  AND CreditoID = Var_CreditoID;

						DELETE FROM  HISCREDITOINVGAR
						WHERE CreditoID = Var_CreditoID
						  AND NumTransaccion = Par_TranRespaldo
						  AND Fecha = Var_FechaSistema;
					END IF;
				END IF;

				SET Var_ManejaLinea	:=( SELECT PRO.ManejaLinea
										FROM PRODUCTOSCREDITO PRO, CREDITOS CRE
										WHERE PRO.ProducCreditoID = CRE.ProductoCreditoID
										  AND CRE.CreditoID = Var_CreditoID);

				SET Var_EsRevolvente :=(SELECT PRO.EsRevolvente
										FROM PRODUCTOSCREDITO PRO, CREDITOS CRE
										WHERE PRO.ProducCreditoID = CRE.ProductoCreditoID
										  AND CRE.CreditoID = Var_CreditoID);

				SET Var_LineaCredito :=(SELECT CRE.LineaCreditoID
										FROM CREDITOS CRE
										WHERE CRE.CreditoID	= Var_CreditoID);

				SET VarSucursalLin := ( SELECT SucursalID
										FROM LINEASCREDITO
										WHERE LineaCreditoID = Var_LineaCredito);

				SET Var_LineaCredito := IFNULL(Var_LineaCredito,Entero_Cero);
				SET Var_ManejaLinea  := IFNULL(Var_ManejaLinea,NoManejaLinea);
				SET Var_EsRevolvente := IFNULL(Var_EsRevolvente,NoEsRevolvente);

				IF( Var_LineaCredito <> Entero_Cero ) THEN
					SET Var_EsLineaCreditoAgroRevolvente := (SELECT	EsRevolvente
															 FROM LINEASCREDITO
															 WHERE LineaCreditoID = Var_LineaCredito
															   AND EsAgropecuario = Con_SI);
				END IF;

				SET Var_EsLineaCreditoAgroRevolvente := IFNULL(Var_EsLineaCreditoAgroRevolvente, Cadena_Vacia);

				SET Var_MontoPagadoCapital	:=(SELECT IFNULL(SUM(DT.MontoCapOrd + DT.MontoCapAtr + DT.MontoCapVen),Entero_Cero)
											FROM DETALLEPAGCRE DT
											WHERE DT.CreditoID = Var_CreditoID
											AND DT.Transaccion = Par_TranRespaldo
											GROUP BY DT.CreditoID);


				IF( Var_LineaCredito != Entero_Cero) THEN
					IF( Var_ManejaLinea = SiManejaLinea OR Var_EsLineaCreditoAgroRevolvente = Con_SI) THEN
						IF(Var_EsRevolvente = SiEsRevolvente OR Var_EsLineaCreditoAgroRevolvente = Con_SI) THEN

							UPDATE LINEASCREDITO SET
								Pagado              = IFNULL(Pagado, Entero_Cero) - Var_MontoPagadoCapital,
								SaldoDisponible     = IFNULL(SaldoDisponible, Entero_Cero) - Var_MontoPagadoCapital ,
								SaldoDeudor         = IFNULL(SaldoDeudor, Entero_Cero) + Var_MontoPagadoCapital,

								Usuario             = Aud_Usuario,
								FechaActual         = Aud_FechaActual,
								DireccionIP         = Aud_DireccionIP,
								ProgramaID          = Aud_ProgramaID,
								Sucursal            = Aud_Sucursal,
								NumTransaccion      = Aud_NumTransaccion
							WHERE LineaCreditoID    = Var_LineaCredito;
						ELSE
							UPDATE LINEASCREDITO SET
								Pagado              = IFNULL(Pagado,Entero_Cero) - Var_MontoPagadoCapital,
								SaldoDeudor         = IFNULL(SaldoDeudor,Entero_Cero) + Var_MontoPagadoCapital,

								Usuario             = Aud_Usuario,
								FechaActual         = Aud_FechaActual,
								DireccionIP         = Aud_DireccionIP,
								ProgramaID          = Aud_ProgramaID,
								Sucursal            = Aud_Sucursal,
								NumTransaccion      = Aud_NumTransaccion
							WHERE LineaCreditoID    = Var_LineaCredito;
						END IF;

						-- Seccion Reversa Comisión Anual de Linea de Crédito
							SET Var_CobraComAnual := (SELECT CobraComAnual
						FROM LINEASCREDITO
													  WHERE LineaCreditoID = Var_LineaCredito);

						SET Var_CobraComAnual := IFNULL(Var_CobraComAnual,Cadena_Vacia);

						IF(Var_CobraComAnual='S')THEN

							-- Obtiene Fecha en que se realizo el pago de crédito
								SET Var_FechaPago := (SELECT FechaPago FROM RESPAGCREDITO
												  WHERE TranRespaldo = Par_TranRespaldo
													AND CreditoID = Var_CreditoID);

							-- Obtiene el monto pagado por la comisión anual
								SET Var_MontoComAnualLin :=(SELECT Abonos
							FROM DETALLEPOLIZA
							WHERE Fecha = Var_FechaPago
							  AND Instrumento = Var_LineaCredito
							  AND Descripcion = CONCAT('CARGO POR ANUALIDAD DE LA LINEA No.',Var_LineaCredito)
															  AND NumTransaccion=Par_TranRespaldo);

							SET Var_MontoComAnualLin := IFNULL(Var_MontoComAnualLin, Entero_Cero);

							IF(Var_MontoComAnualLin>Entero_Cero)THEN
								UPDATE LINEASCREDITO SET
									ComisionCobrada = 'N',
									SaldoComAnual = SaldoComAnual + Var_MontoComAnualLin
								WHERE LineaCreditoID = Var_LineaCredito;
							END IF;
						END IF;

					END IF;
				END IF;

				# SE OBTIENEN LOS DATOS ANTES DEL DESEMBOLSO DEL CREDITO
				UPDATE RESDETACCESORIOS	RDET
				INNER JOIN DETALLEACCESORIOS DET ON RDET.CreditoID = DET.CreditoID
												AND RDET.AccesorioID = DET.AccesorioID
												AND RDET.AmortizacionID = DET.AmortizacionID SET
					DET.CreditoID 			= RDET.CreditoID,
					DET.SolicitudCreditoID	= RDET.SolicitudCreditoID,
					DET.NumTransacSim 		= RDET.NumTransacSim,
					DET.AccesorioID 		= RDET.AccesorioID,
					DET.PlazoID 			= RDET.PlazoID,
					DET.CobraIVA 			= RDET.CobraIVA,
					DET.GeneraInteres		= RDET.GeneraInteres,
					DET.CobraIVAInteres		= RDET.CobraIVAInteres,
					DET.TipoFormaCobro 		= RDET.TipoFormaCobro,
					DET.TipoPago 			= RDET.TipoPago,
					DET.BaseCalculo 		= RDET.BaseCalculo,
					DET.Porcentaje 			= RDET.Porcentaje,
					DET.AmortizacionID 		= RDET.AmortizacionID,
					DET.MontoAccesorio 		= RDET.MontoAccesorio,
					DET.MontoIVAAccesorio 	= RDET.MontoIVAAccesorio,
					DET.MontoCuota 			= RDET.MontoCuota,
					DET.MontoIVACuota 		= RDET.MontoIVACuota,
					DET.SaldoVigente 		= RDET.SaldoVigente,
					DET.SaldoAtrasado 		= RDET.SaldoAtrasado,
					DET.SaldoIVAAccesorio 	= RDET.SaldoIVAAccesorio,
					DET.MontoPagado 		= RDET.MontoPagado,
					DET.FechaLiquida 		= RDET.FechaLiquida,
					DET.SaldoInteres		= RDET.SaldoInteres,
					DET.MontoIntPagado		= RDET.MontoIntPagado
				WHERE DET.CreditoID = Var_CreditoID
				  AND RDET.TranRespaldo	= Par_TranRespaldo;

				DELETE FROM RESDETACCESORIOS
				WHERE CreditoID	= Var_CreditoID
				  AND TranRespaldo = Par_TranRespaldo;
			END IF;

			SET Var_RegistroID := Var_RegistroID + Entero_Uno;
		END WHILE;

		IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;


		DELETE FROM DETALLEPAGCRE
			WHERE	Transaccion = Par_TranRespaldo ;


		DELETE FROM CUENTASAHOMOV
			WHERE	NumeroMov	= Par_TranRespaldo;


		DELETE FROM DETALLEPOLIZA
			WHERE	NumTransaccion	= Par_TranRespaldo;


		DELETE FROM POLIZACONTABLE
			WHERE NumTransaccion	= Par_TranRespaldo;


		DELETE FROM RESCREDITOINVGAR
			WHERE NumTransaccion	= Aud_NumTransaccion;


		IF(Par_FormaPago <> Efectivo)THEN
			DELETE FROM RESPAGCREDITO
				WHERE	TranRespaldo	= Par_TranRespaldo;
		END IF;


		-- Se valida que la reversa a realizar no pertenezca a un pago de credito por deposito por referencia
		SELECT COUNT(*) INTO Var_OrigenDepReferen FROM DEPOSITOREFERE 
		WHERE NumTransaccion = Par_TranRespaldo;

		SET Var_OrigenDepReferen := IFNULL(Var_OrigenDepReferen, Entero_Cero);
		-- Si se cumple la condicion se eliminan los movimientos de  Tesoreria y se actualizan los saldos 
		IF (Var_OrigenDepReferen > Entero_Cero) THEN
			-- obtenemos la institucion y la cuenta de tesoreria a afectar
			SELECT 	MAX(InstitucionID),		MAX(CuentaAhoID), SUM(MontoMov)
				INTO 	Var_InstitucionID,	Var_NumCtaInstit, Var_MontoTotalDepRef
				FROM DEPOSITOREFERE
				WHERE NatMovimiento = Nat_Abono
				  AND TipoMov = TipoMovDepRef
				  AND TipoCanal = TipoCanalCred
				  AND NumTransaccion = Par_TranRespaldo;

				SET Var_InstitucionID 		:= IFNULL(Var_InstitucionID, Entero_Cero);
				SET Var_NumCtaInstit  		:= IFNULL(Var_NumCtaInstit, Entero_Cero);
				SET Var_MontoTotalDepRef  	:= IFNULL(Var_MontoTotalDepRef, Entero_Cero);

				-- Se eliminan los movs de Tesoreria
				DELETE FROM TESORERIAMOVS
				WHERE NatMovimiento = Nat_Abono
				  AND TipoMov = TipoMovDepRef
				  AND TipoRegristro = Reg_Automatico
				  AND NumTransaccion = Par_TranRespaldo;

				-- Se actualiza el saldo de la cuenta de tesoreria
				UPDATE CUENTASAHOTESO SET
					Saldo	     		= Saldo - Var_MontoTotalDepRef
				WHERE InstitucionID  	= Var_InstitucionID
			 	AND NumCtaInstit     	= Var_NumCtaInstit;

				-- Se actualizan los saldos de las cuentas de ahorro
				SET @Consecutivo := 0;
				INSERT INTO TMPDEPOSITOREFEREN (
									Consecutivo, 		CuentaAhoID,		InstitucionID,		NatMovimiento,		MontoMov,
									ReferenciaMov,		EmpresaID,			Usuario,			FechaActual,		DireccionIP,
									ProgramaID,			Sucursal,			NumTransaccion)
				SELECT 
				(@Consecutivo:= @Consecutivo+1),		CuentaAhoID,		InstitucionID,		NatMovimiento,		MontoMov,
									ReferenciaMov,		EmpresaID,			Usuario,			FechaActual,		DireccionIP,
									ProgramaID,			Sucursal,			NumTransaccion
				FROM DEPOSITOREFERE
				WHERE NatMovimiento = Nat_Abono
				  AND TipoMov = TipoMovDepRef
				  AND TipoCanal = TipoCanalCred
				  AND NumTransaccion = Par_TranRespaldo;

				SELECT COUNT(*) INTO Var_MaxRegistroID
				FROM TMPDEPOSITOREFEREN 
				WHERE NumTransaccion = Par_TranRespaldo;

				SET Var_RegistroID 		:= Entero_Uno;
				SET Var_MaxRegistroID	:= IFNULL(Var_MaxRegistroID, Entero_Cero);

				WHILE (Var_RegistroID <= Var_MaxRegistroID) DO
					-- obtenemos el monto del abono a cuenta por cada deposito referenciado
					SELECT ReferenciaMov, MontoMov
					INTO Var_ReferenciaMov, Var_MontoMov
					FROM TMPDEPOSITOREFEREN 
					WHERE Consecutivo = Var_RegistroID
					AND NumTransaccion = Par_TranRespaldo;

					SET Var_ReferenciaMov := IFNULL(Var_ReferenciaMov, Cadena_Vacia);
					-- obtenemos la cuenta de ahorro que se afectara
					SELECT	CreditoID,		ClienteID, 		CuentaID
		        	INTO	Var_CreditoID,	Var_ClienteID,	Var_CuentaAhoID
			    	FROM CREDITOS
			    	WHERE CreditoID = Var_ReferenciaMov;

					SET Var_CreditoID := IFNULL(Var_CreditoID, Entero_Cero);
					SET Var_ClienteID	:= IFNULL(Var_ClienteID, Entero_Cero);
					SET Var_CuentaAhoID	:= IFNULL(Var_CuentaAhoID, Entero_Cero);

					IF (Var_CuentaAhoID <> Entero_Cero) THEN
						SELECT SaldoDispon INTO Var_SaldoCuenta
						FROM CUENTASAHO 
						WHERE CuentaAhoID = Var_CuentaAhoID;

						SET Var_SaldoCuenta := IFNULL(Var_SaldoCuenta, Entero_Cero);

						IF (Var_SaldoCuenta < Var_MontoMov) THEN
							SET Par_NumErr := 400;
	    					SET Par_ErrMen := 'No es Posible Reversar el Pago de Credito Por Referencia, \nSaldo Insuficiente en Cuenta de Ahorro.';
							LEAVE ManejoErrores;
						END IF;

						-- actualizamos el saldo de la cuenta
						UPDATE	CUENTASAHO SET
				    		AbonosDia		= AbonosDia		- Var_MontoMov,
				    		AbonosMes		= AbonosMes		- Var_MontoMov,
				    		Saldo 			= SaldoDispon 	- Var_MontoMov,
							SaldoDispon		= SaldoDispon 	- Var_MontoMov
			    		WHERE	CuentaAhoID = Var_CuentaAhoID;
					END IF;
					SET Var_RegistroID := Var_RegistroID + Entero_Uno;
				END WHILE;

				-- Se cancela el deposito referenciado
				UPDATE DEPOSITOREFERE SET
					Status = Est_Cancelado
				WHERE NatMovimiento = Nat_Abono
				  AND TipoMov = TipoMovDepRef
				  AND TipoCanal = TipoCanalCred
				  AND NumTransaccion = Par_TranRespaldo;
			
		END IF;

		DELETE FROM TMPREVERSAPAGOCREDITO WHERE TransaccionID = Par_TranRespaldo;
		SET Par_NumErr  := Entero_Cero;
		SET Par_ErrMen  := 'Reversa de Pago de Credito, Realizado Exitosamente.';

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				'creditoID' AS control,
				Par_CreditoID AS consecutivo;
	END IF;

END TerminaStore$$