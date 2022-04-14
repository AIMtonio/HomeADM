-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REVERSAPAGCRENOMPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `REVERSAPAGCRENOMPRO`;

DELIMITER $$
CREATE PROCEDURE `REVERSAPAGCRENOMPRO`(
	# =============================================================================
	# ----- STORE PARA REALIZAR LAS REVERSAS DE PAGO DE CREDITO DE NOMINA------
	# =============================================================================
	Par_InstNominaID	INT(11),
	Par_FolioNominaID   INT(11),
	Par_UsuarioClave    VARCHAR(25),
	Par_ContraseniaAut  VARCHAR(45),
	Par_Motivo          VARCHAR(400),

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

	-- Declaracion de Variables
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
	DECLARE Var_Folio				INT(11);				-- Variable para almacenar el ID de Folio
	DECLARE Var_NumReg              INT(11);                -- Contador de Numero de Registros
	DECLARE Var_AuxRegistros        INT(11);                -- Auxiliar de Registros para el Ciclo
	DECLARE Var_NumTrans			BIGINT(20);				-- Numero de Transaccion de Pago
	DECLARE Var_EstatusPendientes   INT(11);     	        -- Num de Folios Pendientes
	DECLARE Var_FechaProces         DATE;                   -- Fecha de Procesamiento de BECARGAPAGNOMINA
	DECLARE Var_EstFolio            CHAR(1);                -- Estatus del Folio BECARGAPAGNOMINA
	DECLARE Var_FormaPago           CHAR(1);                -- Forma de Pago para la reversa
	DECLARE Var_FolioMax            INT(11);                -- Folio de Carga Maximo
	DECLARE Var_NumAmorti       	INT(11);            	-- Numero de amortización que corresponde al folio
	DECLARE Var_FolioReal			INT(11);				-- FolioNominaID de la tabla DESCNOMINAREAL
	DECLARE Var_EsLineaCreditoAgroRevolvente	CHAR(1);	-- Es Linea de Credito Agro Revolvente
	DECLARE Con_NO 								CHAR(1);	-- Constante NO
	DECLARE Con_SI 								CHAR(1);	-- Constante SI

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia            CHAR(1);
	DECLARE Fecha_Vacia             DATE;
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
	DECLARE Var_FechaPago 			DATE;		        -- Indica la fecha de pago de la comisión anual
	DECLARE Var_CobraComAnual 		CHAR(1);		    -- Indica si cobra comisión anual de linea o no
	DECLARE Var_Procesado           CHAR(1);            -- Estatus Procesado BECARGAPAGNOMINA
	DECLARE Var_NoProcesado         CHAR(1);            -- Estatus No Procesado BECARGAPAGNOMINA
	DECLARE Var_PorAplicar		    CHAR(1);            --  Estatus BEPAGOSNOMINA P= Aplicar
	DECLARE Est_Vigente         	CHAR(1);            -- Estatus vigente
	DECLARE Est_NoAplicado      	CHAR(1);            -- Estatus no aplicado
	DECLARE Entero_Uno				INT(11);			-- Constante entero uno
	DECLARE Est_Aplicado        	CHAR(1);            -- Estatus aplicado
	DECLARE Var_PolizaID			BIGINT(20);


	SET Fecha_Vacia        := '1900-01-01';
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
	SET Var_Procesado       := 'P';
	SET Var_NoProcesado     := 'N';
	SET Var_PorAplicar		:='P';
	SET Est_Vigente         :='V';
	SET Est_NoAplicado      := 'N';
	SET Entero_Uno			:= 1;
	SET Est_Aplicado        :='A';
	SET Con_NO				:= 'N';
	SET Con_SI				:= 'S';


	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-REVERSAPAGCRENOMPRO');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		SELECT	FechaSistema INTO Var_FechaSistema FROM PARAMETROSSIS LIMIT 1;
		SET Aud_FechaActual	:= NOW();

		SET Var_Folio := (SELECT FolioCargaID
							FROM BECARGAPAGNOMINA
							WHERE EmpresaNominaID = Par_InstNominaID
								AND FolioCargaID = Par_FolioNominaID);

		SET Var_Folio := IFNULL(Var_Folio, Entero_Cero);


		IF(Var_Folio = Entero_Cero ) THEN
			SET Par_NumErr  := 1;
			SET Par_ErrMen  := 'El Folio de Carga no Existe';
			LEAVE ManejoErrores;
		END IF;

		SET Var_EstatusPendientes := (SELECT COUNT(Estatus)
										FROM BEPAGOSNOMINA
										WHERE Estatus=Var_PorAplicar
										AND FolioCargaID= Par_FolioNominaID
										AND EmpresaNominaID = Par_InstNominaID );
		SET Var_EstatusPendientes := IFNULL(Var_EstatusPendientes, Entero_Cero);

		IF(Var_EstatusPendientes > Entero_Cero ) THEN
			SET Par_NumErr  := 2;
			SET Par_ErrMen  := 'Existen registros pendientes para procesar para el Folio';
			LEAVE ManejoErrores;
		END IF;

		SELECT Estatus,		FechaApliPago
		INTO Var_EstFolio,	Var_FechaProces
			FROM BECARGAPAGNOMINA
					WHERE EmpresaNominaID = Par_InstNominaID
					AND FolioCargaID =  Par_FolioNominaID;

		SET Var_EstFolio := IFNULL(Var_EstFolio, Cadena_Vacia);
		SET Var_FechaProces := IFNULL(Var_FechaProces, Fecha_Vacia);

		IF(Var_EstFolio != Var_Procesado ) THEN
			SET Par_NumErr  := 3;
			SET Par_ErrMen  := 'El Folio de Carga no esta Procesado';
			LEAVE ManejoErrores;
		END IF;


		IF(Var_FechaProces != Var_FechaSistema ) THEN
			SET Par_NumErr  := 4;
			SET Par_ErrMen  := 'La fecha de Procesamiento de Folio debe de Corresponder a la misma del Sistema';
			LEAVE ManejoErrores;
		END IF;

		SET @idConta := 0;

		DELETE FROM REVERSACREDPAGNOMINA WHERE NumTransaccion = Aud_NumTransaccion;

		INSERT INTO REVERSACREDPAGNOMINA (ReversaID,        CuentaAhoID,    CreditoID,      MontoPagado,        BloqueoID,
										  MontoBloq,		TranRespaldo,	NumTransaccion)
		SELECT	(@idConta := @idConta +1 ),     Res.CuentaAhoID,	Res.CreditoID,	    Res.MontoPagado,	    IFNULL(Blo.BloqueoID, Entero_Cero),
					IFNULL(Blo.MontoBloq, Decimal_Cero),		Res.TranRespaldo,		Aud_NumTransaccion
			FROM RESPAGCREDITO Res
				INNER JOIN CREDITOS Cre ON Cre.CreditoID = Res.CreditoID
				INNER JOIN PRODUCTOSCREDITO Pro ON Pro.ProducCreditoID =  Cre.ProductoCreditoID
				INNER JOIN BEPAGOSNOMINA Nom ON Nom.CreditoID = Cre.CreditoID AND Nom.FolioCargaID = Par_FolioNominaID
											AND Nom.EmpresaNominaID = Par_InstNominaID
											AND Nom.Estatus = 'A'
											AND Res.TranRespaldo = Nom.NumTransaccion
				LEFT OUTER JOIN BLOQUEOS Blo ON Blo.Referencia		= Cre.CreditoID
											AND Blo.NatMovimiento	= NatDesbloqueo
											AND Blo.TiposBloqID		= 8;


		SET Var_NumReg := (SELECT COUNT(*) FROM REVERSACREDPAGNOMINA WHERE NumTransaccion = Aud_NumTransaccion);
		SET Var_NumReg := IFNULL(Var_NumReg, Entero_Cero);
		SET Var_AuxRegistros := Entero_Cero;

		-- Movimientos Individuales
		WHILE(Var_AuxRegistros < Var_NumReg) DO
			SET Var_AuxRegistros := Var_AuxRegistros + 1;

			SELECT  CuentaAhoID,  CreditoID,  BloqueoID,        CuentaAhoID,
					MontoBloq,		TranRespaldo
			INTO    Var_CuentaAhoID,	Var_CreditoID,	Var_BloqueoID,	Var_CueGarLiqID,
					Var_MontoBloq,		Var_NumTrans
			FROM    REVERSACREDPAGNOMINA
				WHERE ReversaID = Var_AuxRegistros
					AND NumTransaccion = Aud_NumTransaccion;


			SELECT SUM(MontoPagos)
			INTO Var_MontoPagado
			FROM BEPAGOSNOMINA
			WHERE FolioCargaID = Par_FolioNominaID
				AND EmpresaNominaID = Par_InstNominaID
				AND CreditoID = Var_CreditoID
				AND Estatus =  Est_Aplicado;

			SET Var_BloqueoID := IFNULL(Var_BloqueoID,Entero_Cero);
			SET Var_MontoBloq := IFNULL(Var_MontoBloq,Decimal_Cero);

			SET Var_FormaPago :=(SELECT MAX(FormaPago)
									FROM DETALLEPAGCRE
									WHERE CreditoID = Var_CreditoID
									 AND Transaccion = Var_NumTrans);

			SET Var_CreditoIDMov :=(SELECT CreditoID FROM RESCREDITOS
											WHERE TranRespaldo	= Var_NumTrans
												AND CreditoID   = Var_CreditoID
												LIMIT 1);

			SET Var_FolioMax    := (SELECT MAX(FolioCargaID)
										FROM BEPAGOSNOMINA
										WHERE CreditoID = Var_CreditoID
											AND Estatus = Est_Aplicado);
			SET Var_FolioMax := IFNULL(Var_FolioMax, Entero_Cero);

			IF(Var_FolioMax !=  Par_FolioNominaID ) THEN
				SET Par_NumErr  := 5;
				SET Par_ErrMen  := CONCAT('Existen otros Folios con la Carga del Credito ', Var_CreditoID);
				LEAVE ManejoErrores;
			END IF;

			IF EXISTS(SELECT CreditoOrigenID
					FROM REESTRUCCREDITO
					WHERE CreditoOrigenID = Var_CreditoID
						AND EstatusReest = EstatusDesembolsado
						AND NumTransaccion = Var_NumTrans)THEN

				SET Par_NumErr  := 6;
				SET Par_ErrMen  := 'El pago es por el Otorgamiento de un Credito, Reestructura, La Reversa no puede ser Realizada';
				LEAVE ManejoErrores;
			END IF;


			SET Var_SaldoDipon :=(SELECT SaldoDispon
									FROM CUENTASAHO
									WHERE CuentaAhoID= Var_CueGarLiqID);

			SET Var_SaldoDipon := IFNULL(Var_SaldoDipon, Decimal_Cero);

			IF EXISTS(SELECT Transaccion
					FROM CREDITOSMOVS
					WHERE CreditoID = Var_CreditoID
					AND Transaccion >Var_NumTrans
					AND ProgramaID <> 'MIGRACION')THEN

					IF(Var_MontoBloq > Var_SaldoDipon ) THEN
						SET Par_NumErr  := 7;
						SET Par_ErrMen  := 'Saldo Insuficiente en la Cuenta. No se Puede Realizar el Bloqueo de Garantia Liquida';
						LEAVE ManejoErrores;
					END IF;
			END IF;


			UPDATE  CUENTASAHO Cue
			INNER JOIN  BLOQUEOS Blo ON Cue.CuentaAhoID = Blo.cuentaAhoID SET
				Cue.SaldoDispon = SaldoDispon + Blo.MontoBloq,
				Cue.SaldoBloq   = SaldoBloq - Blo.MontoBloq
			WHERE	Blo.TiposBloqID   	= BloqDepositoGA
				AND	Blo.Referencia		= Var_CreditoID
				AND	Blo.NatMovimiento 	= NaturalezaBloqueo
				AND	Blo.NumTransaccion 	= Var_NumTrans;

			DELETE FROM BLOQUEOS
				WHERE	TiposBloqID   	= BloqDepositoGA
					AND	Referencia 		= Var_CreditoID
					AND	NatMovimiento 	= NaturalezaBloqueo
					AND	NumTransaccion 	= Var_NumTrans;

			IF(Var_BloqueoID > Entero_Cero)THEN
				IF(Var_MontoBloq > Var_SaldoDipon ) THEN
					SET Par_NumErr  := 8;
					SET Par_ErrMen  := 'Saldo Insuficiente en la Cuenta. No se Puede Realizar el Bloqueo de Garantia Liquida';
					LEAVE ManejoErrores;
				END IF;

				IF EXISTS(SELECT CreditoID
					FROM CREDITODEVGL
					WHERE  CreditoID = Var_CreditoID
						AND CuentaID = Var_CuentaAhoID
						AND Monto = Var_MontoBloq)THEN

					SET Par_NumErr  := 9;
					SET Par_ErrMen  :='Existen Operaciones Posteriores Al pago de Credito, la Reversa no puede ser Realizada';
					LEAVE ManejoErrores;
				END IF;

					DELETE FROM BLOQUEOS
						WHERE	BloqueoID		= Var_BloqueoID
							AND	CuentaAhoID		= Var_CueGarLiqID
							AND	NumTransaccion	= Var_NumTrans;


					UPDATE BLOQUEOS SET
						FolioBloq		= Entero_Cero
					WHERE	FolioBloq	= Var_BloqueoID;

					UPDATE CUENTASAHO SET
						SaldoDispon = SaldoDispon - Var_MontoBloq,
						SaldoBloq   = SaldoBloq + Var_MontoBloq
					WHERE CuentaAhoID   = Var_CueGarLiqID;

				END IF;

				IF(IFNULL(Var_CreditoIDMov, Entero_Cero) > Entero_Cero)THEN

					IF NOT EXISTS(SELECT CreditoID FROM REVERSAPAGCRE WHERE CreditoID = Var_CreditoID AND TransaccionID = Var_NumTrans) THEN

						CALL REVERSAPAGCREALT(
							Var_NumTrans,   	Var_CreditoID,  Par_UsuarioClave,   Par_ContraseniaAut, Par_Motivo,
							Var_CuentaAhoID,    Salida_NO,      Par_NumErr,         Par_ErrMen,         Par_EmpresaID,
							Aud_Usuario,        Aud_FechaActual,Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
							Aud_NumTransaccion);

						IF (Par_NumErr <> Entero_Cero)THEN
							LEAVE ManejoErrores;
						END IF;

					END IF;

					UPDATE RESCREDITOS RCRE
					INNER JOIN CREDITOS CRE ON RCRE.CreditoID = CRE.CreditoID  SET
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
						CRE.SaldoIVAInteres 	= RCRE.SaldoIVAInteres,
						CRE.SaldoMoratorios 	= RCRE.SaldoMoratorios,
						CRE.SaldoMoraVencido 	= RCRE.SaldoMoraVencido,
						CRE.SaldoMoraCarVen 	= RCRE.SaldoMoraCarVen,
						CRE.SaldoIVAMorator 	= RCRE.SaldoIVAMorator,
						CRE.SaldComFaltPago 	= RCRE.SaldComFaltPago,
						CRE.SalIVAComFalPag 	= RCRE.SalIVAComFalPag,
						CRE.SaldoOtrasComis 	= RCRE.SaldoOtrasComis,
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
					WHERE 	RCRE.CreditoID 		= Var_CreditoID
					  AND	RCRE.TranRespaldo	= Var_NumTrans;

					DELETE FROM RESCREDITOS
						WHERE	TranRespaldo	= Var_NumTrans
						  AND	CreditoID   	= Var_CreditoID;

					UPDATE CUENTASAHO SET
							CargosMes   	= (CargosMes - Var_MontoPagado),
							CargosDia   	= (CargosDia - Var_MontoPagado),
							AbonosMes   	= (AbonosMes - Var_MontoPagado),
							AbonosDia   	= (AbonosDia - Var_MontoPagado)
						WHERE	CuentaAhoID	= Var_CuentaAhoID;

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
					WHERE	TranRespaldo	= Var_NumTrans
						  AND	CreditoID		= Var_CreditoID;


					DELETE FROM RESAMORTICREDITO
						WHERE	TranRespaldo	= Var_NumTrans
						  AND	CreditoID		= Var_CreditoID;


					DELETE FROM CREDITOSMOVS
						WHERE	CreditoID	= Var_CreditoID;

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
						WHERE TranRespaldo	= Var_NumTrans
						  AND CreditoID		= Var_CreditoID;


					DELETE FROM RESCREDITOSMOVS
						WHERE	TranRespaldo	= Var_NumTrans
						  AND	CreditoID		= Var_CreditoID;


					SELECT  COUNT(InversionID)  INTO Var_NumInver
						FROM RESCREDITOINVGAR
						WHERE	CreditoID		= Var_CreditoID
						  AND	TranRespaldo	= Var_NumTrans;

					SET Var_NumInver	:= IFNULL(Var_NumInver,Entero_Cero);

					IF(Var_NumInver > Entero_Cero)THEN
						SELECT COUNT(Inv.Estatus) INTO Var_NumIverNoVig
							FROM RESCREDITOINVGAR Res
							INNER JOIN INVERSIONES Inv ON Res.InversionID = Inv.InversionID
							WHERE	Res.CreditoID		= Var_CreditoID
							  AND	Res.TranRespaldo	= Var_NumTrans
							  AND	Inv.Estatus			!= Esta_Vigente;

						SET Var_NumIverNoVig := IFNULL(Var_NumIverNoVig,Entero_Cero);

						IF (Var_NumIverNoVig > Entero_Cero) THEN
							SET Par_NumErr  := 5;
							SET Par_ErrMen  := 'La (s) Inversion (es) No esta (n) Vigente (s).' ;
							LEAVE ManejoErrores;
						END IF;

						IF NOT EXISTS(SELECT Inv.CreditoInvGarID
										FROM CREDITOINVGAR Inv
										INNER JOIN RESCREDITOINVGAR Res ON Res.CreditoID 		= Inv.CreditoID
																	   AND Res.CreditoInvGarID	= Inv.CreditoInvGarID
										WHERE	Res.CreditoID		= Var_CreditoID
										  AND	Res.TranRespaldo	= Var_NumTrans) THEN

							INSERT INTO CREDITOINVGAR(
									`CreditoInvGarID`,  `CreditoID`,        `InversionID`,  `MontoEnGar`,
									`FechaAsignaGar`,   `EmpresaID`,        `Usuario`,      `FechaActual`,
									`DireccionIP`,      `ProgramaID`,       `Sucursal`,     `NumTransaccion`)
							SELECT  `CreditoInvGarID`,  `CreditoID`,        `InversionID`,  `MontoEnGar`,
									`FechaAsignaGar`,   `EmpresaID`,        `Usuario`,      `FechaActual`,
									`DireccionIP`,      `ProgramaID`,       `Sucursal`,     `NumTransaccion`
								FROM RESCREDITOINVGAR
								WHERE	TranRespaldo	= Var_NumTrans
								  AND 	CreditoID		= Var_CreditoID;

							DELETE FROM RESCREDITOINVGAR
								WHERE TranRespaldo	= Var_NumTrans
									AND CreditoID	= Var_CreditoID;

							DELETE FROM  HISCREDITOINVGAR
								WHERE CreditoID =  Var_CreditoID
								AND   NumTransaccion= Var_NumTrans
								AND   Fecha= Var_FechaSistema;
						ELSE
							DELETE FROM RESCREDITOINVGAR
								WHERE TranRespaldo	= Var_NumTrans
									AND CreditoID	= Var_CreditoID;

							DELETE FROM  HISCREDITOINVGAR
								WHERE CreditoID =  Var_CreditoID
								AND   NumTransaccion= Var_NumTrans
								AND   Fecha= Var_FechaSistema;
						END IF;
					END IF;

					SET Var_ManejaLinea	:=(SELECT PRO.ManejaLinea
											FROM PRODUCTOSCREDITO PRO, CREDITOS CRE
											WHERE	PRO.ProducCreditoID = CRE.ProductoCreditoID
											  AND	CRE.CreditoID       = Var_CreditoID);

					SET Var_EsRevolvente	:=(SELECT PRO.EsRevolvente
												FROM PRODUCTOSCREDITO PRO, CREDITOS CRE
												WHERE	PRO.ProducCreditoID = CRE.ProductoCreditoID
												  AND	CRE.CreditoID       = Var_CreditoID);

					SET Var_LineaCredito	:=(SELECT CRE.LineaCreditoID
												FROM CREDITOS CRE
												WHERE	CRE.CreditoID	= Var_CreditoID);


					SET VarSucursalLin := (SELECT   SucursalID
											FROM  LINEASCREDITO
											WHERE	LineaCreditoID	= Var_LineaCredito);

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
													FROM     DETALLEPAGCRE DT
													WHERE   DT.CreditoID = Var_CreditoID
													AND DT.Transaccion = Var_NumTrans
													GROUP BY DT.CreditoID);


					IF( Var_LineaCredito != Entero_Cero) THEN
						IF( Var_ManejaLinea = SiManejaLinea OR Var_EsLineaCreditoAgroRevolvente = Con_SI ) THEN
							IF( Var_EsRevolvente = SiEsRevolvente OR Var_EsLineaCreditoAgroRevolvente = Con_SI ) THEN

								UPDATE LINEASCREDITO SET
									Pagado              = IFNULL(Pagado,Entero_Cero) - Var_MontoPagadoCapital,
									SaldoDisponible     = IFNULL(SaldoDisponible,Entero_Cero) - Var_MontoPagadoCapital ,
									SaldoDeudor         = IFNULL(SaldoDeudor,Entero_Cero) + Var_MontoPagadoCapital,

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
							SELECT CobraComAnual INTO Var_CobraComAnual
							FROM LINEASCREDITO
							WHERE LineaCreditoID = Var_LineaCredito;

							SET Var_CobraComAnual := IFNULL(Var_CobraComAnual,Cadena_Vacia);

							IF(Var_CobraComAnual='S')THEN

								-- Obtiene Fecha en que se realizo el pago de crédito
								SET Var_FechaPago := (SELECT FechaPago FROM RESPAGCREDITO
													WHERE TranRespaldo	= Var_NumTrans
													AND CreditoID   = Var_CreditoID);
								-- Obtiene el monto pagado por la comisión anual
								SELECT Abonos INTO Var_MontoComAnualLin
									FROM DETALLEPOLIZA
									WHERE Fecha=Var_FechaPago
									AND Instrumento=Var_LineaCredito
									AND Descripcion = CONCAT('CARGO POR ANUALIDAD DE LA LINEA No.',Var_LineaCredito)
									AND NumTransaccion=Par_TranRespaldo;

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
					UPDATE RESDETACCESORIOS		RDET	INNER JOIN
							DETALLEACCESORIOS 	DET		ON
							RDET.CreditoID  		= DET.CreditoID	AND
							RDET.AccesorioID 		= DET.AccesorioID AND
							RDET.AmortizacionID 	= DET.AmortizacionID
						SET
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
							DET.SaldoIVAInteres		= RDET.SaldoIVAInteres,
							DET.MontoIVACuota 		= RDET.MontoIVACuota,
							DET.SaldoVigente 		= RDET.SaldoVigente,
							DET.SaldoAtrasado 		= RDET.SaldoAtrasado,
							DET.SaldoIVAAccesorio 	= RDET.SaldoIVAAccesorio,
							DET.MontoPagado 		= RDET.MontoPagado,
							DET.FechaLiquida 		= RDET.FechaLiquida,
							DET.SaldoInteres		= RDET.SaldoInteres,
							DET.MontoIntPagado		= RDET.MontoIntPagado
						WHERE 	DET.CreditoID 		= Var_CreditoID
						  AND	RDET.TranRespaldo	= Var_NumTrans ;

						DELETE FROM RESDETACCESORIOS
							WHERE	CreditoID		= Var_CreditoID
							AND 	TranRespaldo	= Var_NumTrans;
				END IF;

			-- Se Eliminan los Registros que se vieron afectados en el Pago de Credito de Nomian

			DELETE FROM DETALLEPAGCRE
				WHERE	Transaccion = Var_NumTrans
					AND CreditoID = Var_CreditoID;


			DELETE FROM CUENTASAHOMOV
				WHERE	NumeroMov	= Var_NumTrans
					AND ReferenciaMov = Var_CreditoID;

			DELETE FROM RESCREDITOINVGAR
				WHERE NumTransaccion	= Aud_NumTransaccion
					AND CreditoID = Var_CreditoID;

			DELETE FROM RESPAGCREDITO
				WHERE	TranRespaldo	= Var_NumTrans
				AND CreditoID = Var_CreditoID;

		END WHILE;

		SET Var_NumReg := (SELECT COUNT(*) FROM REVERSACREDPAGNOMINA WHERE NumTransaccion = Aud_NumTransaccion);
		SET Var_NumReg := IFNULL(Var_NumReg, Entero_Cero);
		SET Var_AuxRegistros := Entero_Cero;

		WHILE(Var_AuxRegistros < Var_NumReg) DO
			SET Var_AuxRegistros := Var_AuxRegistros + 1;

			SELECT  TranRespaldo
			INTO    Var_NumTrans
			FROM    REVERSACREDPAGNOMINA
				WHERE ReversaID = Var_AuxRegistros
				AND NumTransaccion = Aud_NumTransaccion;

			SELECT PolizaID
			INTO Var_PolizaID
			FROM DETALLEPOLIZA
			WHERE NumTransaccion = Var_NumTrans
			LIMIT 1;

			SET Var_PolizaID := IFNULL(Var_PolizaID, Entero_Cero);

			IF( Var_PolizaID > Entero_Cero ) THEN
				-- Se eliminan Registros Contables
				DELETE FROM DETALLEPOLIZA
					WHERE	PolizaID	= Var_PolizaID;

				DELETE FROM POLIZACONTABLE
					WHERE PolizaID	= Var_PolizaID;
			ELSE

				-- Se eliminan Registros Contables
				DELETE FROM DETALLEPOLIZA
					WHERE	NumTransaccion	= Var_NumTrans;

				DELETE FROM POLIZACONTABLE
					WHERE NumTransaccion	= Var_NumTrans;
			END IF;

			SET Var_PolizaID := Entero_Cero;


		END WHILE;

		DELETE FROM REVERSACREDSINPAGNOMINA WHERE NumTransaccion = Aud_NumTransaccion;

		SET @idConta := Entero_Cero;
		INSERT INTO REVERSACREDSINPAGNOMINA
			 (ReversaID,        CuentaAhoID,    CreditoID,      Monto,       TranRespaldo,	 NumTransaccion)
		SELECT	(@idConta := @idConta +1 ), Cre.CuentaID , Cre.CreditoID, Nom.MontoPagos, Nom.NumTransaccion,  Aud_NumTransaccion
		FROM BEPAGOSNOMINA Nom
			INNER JOIN CREDITOS Cre ON Nom.CreditoID = Cre.CreditoID
		WHERE FolioCargaID =  Par_FolioNominaID
				AND MontoAplicado = Entero_Cero;

		SET Var_NumReg := Entero_Cero;
		SET Var_NumReg := (SELECT COUNT(*) FROM REVERSACREDSINPAGNOMINA WHERE NumTransaccion = Aud_NumTransaccion);
		SET Var_NumReg := IFNULL(Var_NumReg, Entero_Cero);
		SET Var_AuxRegistros := Entero_Cero;

		-- Movimientos de Registros que no Aplicaron Pago de Credito
		WHILE(Var_AuxRegistros < Var_NumReg) DO
			 SET Var_AuxRegistros := Var_AuxRegistros + 1;

			SELECT  CreditoID,		CuentaAhoID,		TranRespaldo,		Monto
			INTO    Var_CreditoID,	Var_CuentaAhoID,	Var_NumTrans,		Var_MontoPagado
			FROM    REVERSACREDSINPAGNOMINA
				WHERE ReversaID = Var_AuxRegistros
				AND NumTransaccion = Aud_NumTransaccion;

			UPDATE CUENTASAHO SET
				Saldo       	= (Saldo - Var_MontoPagado),
				SaldoDispon 	= (SaldoDispon - Var_MontoPagado),
				AbonosMes   	= (AbonosMes - Var_MontoPagado),
				AbonosDia   	= (AbonosDia - Var_MontoPagado)
			WHERE	CuentaAhoID	= Var_CuentaAhoID;

			DELETE FROM CUENTASAHOMOV
				WHERE	NumeroMov	= Var_NumTrans
					AND ReferenciaMov = Var_CreditoID;
		END WHILE;
		-- Se actualiza el Estatus de los Pagos Aplicados
		UPDATE BEPAGOSNOMINA SET
			Estatus			= Var_PorAplicar,
			MontoAplicado	= Entero_Cero ,
			FechaAplicacion	=  Fecha_Vacia
		WHERE  FolioCargaID= Par_FolioNominaID
			AND EmpresaNominaID = Par_InstNominaID;

		-- Se actualiza el Estatus en la tabla BECARGAPAGNOMINA a Procesados
		UPDATE BECARGAPAGNOMINA SET
			Estatus = Var_NoProcesado,
			FechaApliPago = Fecha_Vacia
		WHERE  FolioCargaID=Par_FolioNominaID
			AND EmpresaNominaID = Par_InstNominaID;

		-- Se valida si existe registro en la Tabla de Respaldo de Aplicacion de Pagos de Nomina
		IF EXISTS (SELECT FolioCargaID
					FROM DETALLEPAGNOMINST
					WHERE FolioCargaID = Par_FolioNominaID) THEN

			-- Se realiza la llamada al SP de reversa de Pagos de Aplicacion por Institucion
			CALL APLICAPAGOINSTACT(
				Entero_Cero,	Par_FolioNominaID,		Entero_Cero,			Entero_Cero,		Entero_Cero,
				Decimal_Cero,	Entero_Uno,				Entero_Cero,			Cadena_Vacia,		Entero_Cero,
				Salida_NO,		Par_NumErr,				Par_ErrMen,				Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;

		DELETE FROM REVERSACREDPAGNOMINA WHERE NumTransaccion = Aud_NumTransaccion;
		DELETE FROM REVERSACREDSINPAGNOMINA WHERE NumTransaccion = Aud_NumTransaccion;

		SET Par_NumErr  := Entero_Cero;
		SET Par_ErrMen  := 'Reversa de Pago de Credito, Realizado Exitosamente.';

	END ManejoErrores;
		IF (Par_Salida = Salida_SI) THEN
			SELECT  Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					'creditoID' AS control,
					Var_CreditoID AS consecutivo;
		END IF;

END TerminaStore$$