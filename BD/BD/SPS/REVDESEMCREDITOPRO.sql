-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REVDESEMCREDITOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `REVDESEMCREDITOPRO`;
DELIMITER $$


CREATE PROCEDURE `REVDESEMCREDITOPRO`(
    Par_CreditoID       BIGINT(12),
	INOUT Par_PolizaID	BIGINT(20),
	Par_AltaEncPoliza   CHAR(1),
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
	DECLARE Var_Control         VARCHAR(100);
	DECLARE Str_NumErr          CHAR(3);
	DECLARE Var_CuentaAhoID     BIGINT(12);
	DECLARE Var_EstatusCre      CHAR(1);
	DECLARE Var_ManLine         CHAR(1);
	DECLARE Var_MontoCred       DECIMAL(14,2);
	DECLARE Var_FecIniCred      DATE;
	DECLARE Var_MonedaID        INT(11);
	DECLARE Var_MontoComAp      DECIMAL(12,2);
	DECLARE Var_IVAComAp        DECIMAL(12,2);
	DECLARE Var_ForComApe       CHAR(1);
	DECLARE Var_MontoSegVida    DECIMAL(14,2);
	DECLARE Var_ForCobSegVida   CHAR(1);
	DECLARE VarSucursalLin      INT;		 		-- Variables para el CURSOR

	DECLARE Var_FechaOper       DATE;
	DECLARE Var_FechaApl        DATE;
	DECLARE Var_EsHabil         CHAR(1);
	DECLARE Var_MontoCargo      DECIMAL(14,2);
	DECLARE Var_CueSaldo		DECIMAL(14,2);
	DECLARE Var_CueMoneda		INT;
	DECLARE Var_CueEstatus		CHAR(1);
	DECLARE Var_ClienteID       BIGINT;
	DECLARE Var_NumMovCred      INT;
	DECLARE Var_ProdCreID       INT;
	DECLARE Var_SucCliente      INT;
	DECLARE Var_CuentaAhoStr    VARCHAR(20);
	DECLARE Var_CreditoStr      VARCHAR(20);
	DECLARE Var_DcIVAComApe     VARCHAR(100);
	DECLARE Var_AltaPoliza      CHAR(1);
	DECLARE Par_Consecutivo     BIGINT;
	DECLARE Var_SoliciCredID    BIGINT;
	DECLARE Var_Relacionado     BIGINT;
	DECLARE Var_EsReestructura  CHAR(1);
	DECLARE ManjeaLinea         CHAR(1);
	DECLARE lineaCredito        BIGINT;
	DECLARE Var_TipoDisper		CHAR(1);
	DECLARE Var_FolioDisper     BIGINT;
	DECLARE Var_BloqueoID       BIGINT;
	DECLARE Var_Contrasenia     VARCHAR(45);
	DECLARE Var_SubClasifID     INT;
	DECLARE VarTipoPagoCapital	CHAR(1);
	DECLARE VarNumTransacSim	BIGINT(20);
	DECLARE VarNumTransac		BIGINT(20);
	DECLARE MontoTotCom			DECIMAL(14,2);
	DECLARE Con_ContGastos		INT(11);
	DECLARE Var_NumRegistros	INT(11); 		-- Variable número de registros
	DECLARE Var_AccesorioID		INT(11); 		-- Variable identificador del Accesorio
	DECLARE Contador			INT(11); 		-- Variable Contador
    DECLARE Var_PagaIVA			CHAR(1);		-- Indica si el cliente paga IVA
    DECLARE Var_MontoCuotaAc 	DECIMAL(12,2); 	-- Variable para el monto de Accesorios
    DECLARE MontoIVACuotaAc		DECIMAL(12,2); 	-- Variable para monto de IVA de Accesorios

    DECLARE Var_CobraComAnual 	CHAR(1);		-- Indica si cobra comisión anual de linea de crédito
    DECLARE Var_MontoComAnualLin DECIMAL(14,2);		-- Indica el monto de la comsión anual de linea de crédito
    DECLARE Var_MontoIVAComAnual DECIMAL(14,2);		-- Indica el monto del Iva de la comisión anual de linea
    DECLARE ConstDescipLinea 	VARCHAR(100);		-- Constante para la descripción del movimiento de comisión anual de linea
    DECLARE Var_IVA 			DECIMAL(14,2);	-- Variable para el  porcentaje de IVA
    DECLARE Var_SPEIHabilitado	CHAR(1);		-- Variable para validar si el modulo de SPEI se encuentra encendido

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia        CHAR(1);
	DECLARE Fecha_Vacia         DATE;
	DECLARE Entero_Cero         INT;
    DECLARE Decimal_Cero		DECIMAL(14,2);
	DECLARE Salida_SI           CHAR(1);
	DECLARE EstatusVigente   	CHAR(1);
	DECLARE Cue_Activa          CHAR(1);
	DECLARE ForComApAntici      CHAR(1);
    DECLARE ForComProg			CHAR(1);
	DECLARE Var_ClasifCre       CHAR(1);
	DECLARE Var_DescComAper     VARCHAR(100);
	DECLARE Var_DescSegVida     VARCHAR(100);
	DECLARE Var_Descripcion     VARCHAR(100);
	DECLARE Nat_Cargo           CHAR(1);
	DECLARE Nat_Abono           CHAR(1);
	DECLARE AltaPoliza_SI       CHAR(1);
	DECLARE AltaPoliza_NO       CHAR(1);
	DECLARE AltaPolCre_SI       CHAR(1);
	DECLARE AltaMovAho_SI       CHAR(1);
	DECLARE AltaMovAho_NO       CHAR(1);
	DECLARE AltaMovCre_NO       CHAR(1);
	DECLARE AltaPolCre_NO       CHAR(1);
	DECLARE Con_ContDesem       INT;
	DECLARE Con_ContCapCre      INT;
	DECLARE Con_ContComApe      INT;
	DECLARE Con_ContIVACApe     INT;
	DECLARE Con_PagoSegVida     INT;
	DECLARE Tip_MovAhoDesem     CHAR(3);
	DECLARE Tip_MovAhoComAp     CHAR(3);
	DECLARE Tip_MovIVAAhCAp     CHAR(3);
	DECLARE Tip_MovAhoSegVid    CHAR(3);
	DECLARE Act_Inactivo        INT;
	DECLARE SalidaNo            CHAR(1);
	DECLARE Estatus_Activo      CHAR(1);
	DECLARE Estatus_Inactivo    CHAR(1);
	DECLARE Estatus_Autoriza    CHAR(1);
	DECLARE No_EsReestruc       CHAR(1);
	DECLARE Si_EsReestruc       CHAR(1);
	DECLARE SiManejaLinea       CHAR(1);
	DECLARE DispersionSPEI      CHAR(1);
	DECLARE DispersionCheque    CHAR(1);
	DECLARE DispersionOrden		CHAR(1);
	DECLARE Deb_RevDesemb       INT;
	DECLARE Blo_Desemb          INT;
	DECLARE Nat_Desbloqueo      CHAR(1);
	DECLARE Nat_Bloqueo         CHAR(1);
	DECLARE DescripBloqSPEI     VARCHAR(40);
	DECLARE DescripBloqCheq     VARCHAR(40);
    DECLARE	DescripBloqOrden	VARCHAR(50);
	DECLARE Pol_Automatica      CHAR(1);
	DECLARE CapitalLibre		CHAR(1);
	DECLARE Var_UsuarioID       INT(11);
	DECLARE ConcepCtaOrdenDeu	INT;
	DECLARE ConcepCtaOrdenCor	INT;
	DECLARE Var_FechaSistema    DATE;
    DECLARE Var_NumGrupo		INT(11);
    DECLARE CobroDeduccion		CHAR(1);

    DECLARE Const_Si 			CHAR(1);	-- Constante Si
    DECLARE Con_ContComAnual 	INT(11);		-- Constante Movimiento Contable para la comisión anual de linea de crédito
    DECLARE Con_ContIVAComAnual INT(11);		-- Constante Movimiento Contable para el iva de la comisión anual de linea
    DECLARE TipoMovAhoComAnual 	VARCHAR(4);		-- Constante Movimiento de Ahorro para la comisión anual de linea
    DECLARE TipoMovAhoIVAComAnual VARCHAR(4);		-- Constante Movimiento de Ahorro para el IVA de la comisión anual de linea
    DECLARE Cons_No 			CHAR(1);
	DECLARE Var_EsLineaCreditoAgro 				CHAR(1);	-- Es linea de Credito Agro


	-- Asignacion de Constantes
	SET Cadena_Vacia        := '';              -- String Vacio
	SET Fecha_Vacia         := '1900-01-01';    -- Fecha Vacia
	SET Entero_Cero         := 0;               -- Entero en Cero
    SET Decimal_Cero		:= 0.00;			-- Decimal en Cero
	SET Salida_SI           := 'S';             -- Indica una salida en pantalla
	SET EstatusVigente      := 'V';             -- Estatus del Credito Vigente
	SET Cue_Activa          := 'A';             -- Estatus de la Cuenta: Activa
	SET ForComApAntici      := 'A';             -- La Comision por Apertura es por Anticipado
    SET ForComProg			:= 'P';				-- La Comision por Apertura es Programada
	SET Nat_Cargo           := 'C';             -- Naturaleza de Cargo
	SET Nat_Abono           := 'A';             -- Naturaleza de Abono.
	SET AltaPoliza_SI       := 'S';             -- Alta de Poliza Contable General: SI
	SET AltaPoliza_NO       := 'N';	            -- Alta de Poliza Contable General: NO
	SET AltaPolCre_SI       := 'S';		        -- Alta de Poliza Contable de Credito: SI
	SET AltaPolCre_NO       := 'N';             -- Alta de Poliza Contable de Credito: NO
	SET AltaMovAho_SI       := 'S';             -- Alta de Movimiento de Ahorro: SI
	SET AltaMovAho_NO       := 'N';             -- Alta de Movimiento de Ahorro: NO
	SET AltaMovCre_NO       := 'N';             -- Alta de Movimiento de Credito: NO
	SET Con_ContCapCre      := 1;               -- Concepto Contable de Credito: Capital (CONCEPTOSCARTERA)
	SET Con_ContDesem       := 58;              -- Concepto Contable de Reversa Desembolso (CONCEPTOSCONTA)
	SET Con_ContComApe      := 22;              -- Concepto Contable de Credito: Com x Apertura (CONCEPTOSCARTERA)
	SET Con_ContIVACApe     := 23;              -- Concepto Contable de Credito: IVA Com Apertura (CONCEPTOSCARTERA)
	SET Con_PagoSegVida     := 25;              -- Concepto Contable de Cobertura de Seguro de Vida
	SET Tip_MovAhoDesem     := '300';	          -- Tipo de Movimiento en Cta de Ahorro: Desembsolso (TIPOSMOVSAHO)
	SET Tip_MovAhoComAp     := '301';            -- Tipo de Movimiento en Cta de Ahorro: Com Apertura (TIPOSMOVSAHO)
	SET Tip_MovIVAAhCAp     := '302';            -- Tipo de Movimiento en Cta de Ahorro: IVA Com Apert (TIPOSMOVSAHO)
	SET Tip_MovAhoSegVid    := '303';            -- Tipo de Movimiento en Cta de Ahorro: Pago de Seguro de Vida
	SET Act_Inactivo        := 3;               -- Tipo de Actualizacion del seguro: Inactivo
	SET SalidaNo            := 'N';             -- Ejecutar Store sin Regreso o Mensaje de Salida
	SET Estatus_Activo      := 'A';             -- Estatus del Credito Activo
    SET Estatus_Autoriza	:= 'A';				-- Estatus Autoriza
	SET Estatus_Inactivo    := 'I';             -- Estatus del la Solicitud: Inactivo
	SET No_EsReestruc       := 'N';             -- El Producto de Credito no es para Reestructuras
	SET Si_EsReestruc       := 'S';             -- El credito si es una Reestructura
	SET SiManejaLinea       := 'S';             -- El Credito si Maneja Linea
	SET DispersionSPEI      := 'S';             -- Tipo de Dispersion por SPEI
	SET DispersionCheque    := 'C';             -- Tipo de Dispersion por Cheque
	SET DispersionOrden	    := 'O';             -- Tipo de Dispersion por Orden de pago
	SET Nat_Desbloqueo      := 'D';             -- Naturaleza de Desbloqueo
	SET Nat_Bloqueo         := 'B';             -- Naturaleza de Bloqueo
	SET Blo_Desemb          := 1;               -- Tipo de Bloqueo de Saldo en Cta: Dispersion del Desembolso
	SET Deb_RevDesemb       := 12;              -- Tipo de Desbloqueo de Saldo en Cta: Reversa de Desembolso
	SET Pol_Automatica      := 'A';             -- Poliza Automatica
	SET CapitalLibre		:= 'L';             /* Pago de Capital Libre*/
    SET CobroDeduccion 		:= 'D'; 			-- Especifica forma de cobro por Deducción
    SET Const_Si			:= 'S';
    SET Cons_No				:= 'N';


	SET DescripBloqSPEI     	:= 'BLOQUEO DE SALDO POR SPEI';
	SET DescripBloqCheq     	:= 'BLOQUEO DE SALDO POR CHEQUE';
    SET DescripBloqOrden		:= 'BLOQUEO DE SALDO POR ORDEN DE PAGO';
	SET Var_DescComAper     	:= 'REVERSA.COMISION POR APERTURA';
	SET Var_DcIVAComApe     	:= 'REVERSA.IVA COMISION POR APERTURA';
	SET Var_DescSegVida     	:= 'REVERSA.SEGURO DE VIDA';
	SET Var_Descripcion     	:= 'REVERSA.DESEMBOLSO DE CREDITO';
	SET ConcepCtaOrdenDeu		:= 53;		/* Linea Credito Cta. Orden */
	SET ConcepCtaOrdenCor		:= 54;		/* Linea Credito Corr. Cta Orden */
	SET Con_ContGastos			:= 58 ;

	SET Con_ContComAnual 		:= 100;
	SET Con_ContIVAComAnual 	:= 101;
	SET TipoMovAhoComAnual 		:= '208';
	SET TipoMovAhoIVAComAnual 	:= '209';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr 	= 999;
				SET Par_ErrMen 	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								  'Disculpe las molestias que esto le ocasiona. Ref: SP-REVDESEMCREDITOPRO');
				SET Var_Control = 'SQLEXCEPTION' ;
			END;

		-- Inicializacion
		SET Str_NumErr      := '0';

		SELECT  UsuarioID , Contrasenia INTO  Var_UsuarioID,Var_Contrasenia
			FROM USUARIOS
			WHERE Clave = Par_UsuarioClave;


		SET Var_Contrasenia	:= IFNULL(Var_Contrasenia, Cadena_Vacia);

		IF(Par_ContraseniaAut != Var_Contrasenia)THEN
			SET	Par_NumErr 	:= 9;
			SET	Par_ErrMen	:= "Contraseña o Usuario Incorrecto.";
			LEAVE ManejoErrores;
		END IF;

		IF(Var_UsuarioID = Aud_Usuario)THEN
			SET Par_NumErr      := 10;
			SET Par_ErrMen      := "El usuario que realiza la Transaccion no puede ser el mismo que  Autoriza.";
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Motivo, Cadena_Vacia) = Cadena_Vacia)THEN
			SET	Par_NumErr 	:= 11;
			SET	Par_ErrMen	:= "El Motivo de la Reversa no Puede estar Vacio";
			LEAVE ManejoErrores;
		END IF;

		SELECT FechaSucursal INTO Var_FechaOper
			FROM SUCURSALES
			WHERE SucursalID = Aud_Sucursal;

		SET Var_FechaOper   := IFNULL(Var_FechaOper, Fecha_Vacia);

		CALL DIASFESTIVOSCAL(
			Var_FechaOper,  Entero_Cero,        Var_FechaApl,       Var_EsHabil,    Par_EmpresaID,
			Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
			Aud_NumTransaccion);

		IF(IFNULL(Par_CreditoID, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr	:= 1;
			SET Par_ErrMen	:= 'El Numero de Credito esta Vacio.';
			LEAVE ManejoErrores;
		END IF;

		SELECT  Cre.CuentaID,           Cre.Estatus,            Pro.ManejaLinea,        Cre.MontoCredito,
				Cre.FechaInicio,        Cre.MonedaID,           Cre.MontoComApert,      Cre.IVAComApertura,
				Pro.ForCobroComAper,    Cre.MontoSeguroVida,    Cre.ForCobroSegVida,    Cre.ProductoCreditoID,
				Des.Clasificacion,      Cli.SucursalOrigen,     Cre.SolicitudCreditoID, Cre.Relacionado,
				EsReestructura,         Pro.ManejaLinea,        Cre.LineaCreditoID,     Cre.FolioDispersion,
				Des.SubClasifID,		Cre.TipoPagoCapital,	NumTransacSim,			Cre.TipoDispersion,
                Cre.GrupoID,			Cli.PagaIVA

		  INTO	Var_CuentaAhoID,        Var_EstatusCre,         Var_ManLine,        	Var_MontoCred,
				Var_FecIniCred,         Var_MonedaID,           Var_MontoComAp,     	Var_IVAComAp,
				Var_ForComApe,          Var_MontoSegVida,       Var_ForCobSegVida,  	Var_ProdCreID,
				Var_ClasifCre,          Var_SucCliente,         Var_SoliciCredID,   	Var_Relacionado,
				Var_EsReestructura,     ManjeaLinea,            lineaCredito,       	Var_FolioDisper,
				Var_SubClasifID,		VarTipoPagoCapital,		VarNumTransacSim,		Var_TipoDisper,
                Var_NumGrupo,			Var_PagaIVA

			FROM CREDITOS Cre,
				 CLIENTES Cli,
				 PRODUCTOSCREDITO Pro,
				 DESTINOSCREDITO Des
				WHERE CreditoID 			= Par_CreditoID
				  AND Cre.ClienteID			= Cli.ClienteID
				  AND Cre.ProductoCreditoID	= Pro.ProducCreditoID
				  AND Cre.DestinoCreID 		= Des.DestinoCreID;

		SET Var_EstatusCre  := IFNULL(Var_EstatusCre, Cadena_Vacia);
		SET Var_FolioDisper := IFNULL(Var_FolioDisper, Entero_Cero);
		SET Var_SubClasifID := IFNULL(Var_SubClasifID, Entero_Cero);
        SET Var_PagaIVA		:= IFNULL(Var_PagaIVA, Cadena_Vacia);
		SET lineaCredito	:= IFNULL(lineaCredito, Entero_Cero);

		IF( lineaCredito <> Entero_Cero ) THEN
			SELECT	EsAgropecuario
			INTO	Var_EsLineaCreditoAgro
			FROM LINEASCREDITO
			WHERE LineaCreditoID = lineaCredito
			  AND EsAgropecuario = Const_Si;
		END IF;

		SET Var_EsLineaCreditoAgro	:= IFNULL(Var_EsLineaCreditoAgro, Cons_No);

		IF(Var_EstatusCre != EstatusVigente) THEN
			SET Par_NumErr	:= 2;
			SET Par_ErrMen	:= 'El Credito no esta Vigente.';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_FechaOper != Var_FecIniCred) THEN
			SET Par_NumErr	:= 3;
			SET Par_ErrMen	:= 'El Credito no fue Desembolsado el Dia de Hoy.';
			LEAVE ManejoErrores;
		END IF;


		SET Var_MontoComAp  	:= IFNULL(Var_MontoComAp, Entero_Cero);
		SET Var_IVAComAp    	:= IFNULL(Var_IVAComAp, Entero_Cero);
		SET Var_ForComApe   	:= IFNULL(Var_ForComApe, Cadena_Vacia);
		SET Var_MontoSegVida    := IFNULL(Var_MontoSegVida, Entero_Cero);
		SET Var_ForCobSegVida   := IFNULL(Var_ForCobSegVida, Cadena_Vacia);
		SET Var_CuentaAhoStr    := CONVERT(Var_CuentaAhoID, CHAR);
		SET Var_CreditoStr      := CONVERT(Par_CreditoID, CHAR);
		SET Var_MontoCargo  	:= Var_MontoCred;

		SELECT SUM(MontoCuota), SUM(MOntoIVACuota) INTO Var_MontoCuotaAc, MontoIVACuotaAc
		FROM DETALLEACCESORIOS
		WHERE CreditoID = Par_CreditoID
		AND TipoFormaCobro = CobroDeduccion;

        -- Si cobra Accesorios descuenta el monto de tale(s) Accesorio(s)
        IF(Var_MontoCuotaAc>Entero_Cero)THEN
			SET Var_MontoCargo  := Var_MontoCargo - (Var_MontoCuotaAc + MontoIVACuotaAc);
        END IF;

		-- Descontamos el Monto de la Comision por Apertura y Seguro de Vida
		IF(Var_MontoComAp > Entero_Cero AND (Var_ForComApe != ForComApAntici AND Var_ForComApe != ForComProg)) THEN
			SET Var_MontoCargo  := Var_MontoCargo - (Var_MontoComAp + Var_IVAComAp);
		END IF;

		IF(Var_MontoSegVida > Entero_Cero AND Var_ForCobSegVida != ForComApAntici) THEN
			SET Var_MontoCargo  := Var_MontoCargo - (Var_MontoSegVida);
		END IF;

        -- Reversa si Maneja Linea de Credito
		SET lineaCredito    := IFNULL(lineaCredito, Entero_Cero);

        SELECT CobraComAnual INTO Var_CobraComAnual
        FROM LINEASCREDITO
        WHERE LineaCreditoID=lineaCredito;

        SET Var_CobraComAnual := IFNULL(Var_CobraComAnual,Cadena_Vacia);
        -- Incia Validacion para determinar si se cobro anualidad de linea de credito o no
        IF( (ManjeaLinea = SiManejaLinea OR Var_EsLineaCreditoAgro = Const_Si ) AND Var_CobraComAnual = Const_Si ) THEN
			SELECT SUM(CantidadMov) INTO Var_MontoComAnualLin
			FROM CUENTASAHOMOV
			WHERE CuentaAhoID=Var_CuentaAhoID
			AND Fecha=Var_FechaOper
			AND NatMovimiento = Nat_Cargo
			AND ReferenciaMov=lineaCredito
			AND TipoMovAhoID IN ('208','209');

            SET Var_MontoComAnualLin := IFNULL(Var_MontoComAnualLin,Entero_Cero);

            SET Var_MontoCargo  := Var_MontoCargo - Var_MontoComAnualLin;
        END IF;
        -- Fin validación cobro por anualidad de linea de credito

		-- Validamos que el Credito no Tenga Movimientos Posteriores al Desembolso
		SELECT COUNT(Mov.CreditoID) INTO Var_NumMovCred
			FROM CREDITOSMOVS Mov
			WHERE Mov.CreditoID = Par_CreditoID
			  AND Mov.Descripcion != 'DESEMBOLSO DE CREDITO';

		SET Var_NumMovCred  := IFNULL(Var_NumMovCred, Entero_Cero);

		IF(Var_NumMovCred != Entero_Cero) THEN
			SET Par_NumErr	:= 4;
			SET Par_ErrMen	:= 'El Credito Presenta Movimientos Posteriores al Desembolso';
			LEAVE ManejoErrores;
		END IF;

		-- Validar que NO sea una Reestructura la que se Quiere Dar Reversa
		IF(Var_Relacionado != Entero_Cero AND Var_EsReestructura = Si_EsReestruc) THEN
			SET Par_NumErr	:= 5;
			SET Par_ErrMen	:= 'El Desembolso de Un Credito Reestructura no Puede ser Reversado con esta Opcion.';
			LEAVE ManejoErrores;
		END IF;

		SELECT 	Par.Habilitado
			INTO Var_SPEIHabilitado
			FROM PARAMETROSSPEI Par
			LIMIT 1;

		SET Var_SPEIHabilitado := IFNULL(Var_SPEIHabilitado, SalidaNo);

		IF (Var_TipoDisper = DispersionSPEI AND Var_SPEIHabilitado =  Salida_SI) THEN
			SET Par_NumErr	:= 6;
			SET Par_ErrMen	:= 'El Desembolso por SPEI no puede ser Reversado porque se realizo con el SPEI Habilitado.';
			LEAVE ManejoErrores;
		END IF;

		-- Validar que la Dispersion no haya Sido Realizada en Tesoreria (Si Fue por Cheque, SPEI, u Orden de Pago)
		SET Var_TipoDisper  := IFNULL(Var_TipoDisper, Cadena_Vacia);

		IF( Var_FolioDisper != Entero_Cero AND((Var_TipoDisper = DispersionSPEI) OR (Var_TipoDisper = DispersionCheque)OR (Var_TipoDisper = DispersionOrden))) THEN

			SET Par_NumErr	:= 7;
			SET Par_ErrMen	:= 'La Dispersion del Desembolso por el Cheque, SPEI u Orden de Pago, ya se encuentra en Tesoreria.';
			LEAVE ManejoErrores;
		END IF;

		SET Var_CuentaAhoID := IFNULL(Var_CuentaAhoID, Entero_Cero);

		-- 1) Desbloqueo del Saldo si fue por SPEI o Cheque
		IF( Var_TipoDisper = DispersionSPEI OR Var_TipoDisper = DispersionCheque OR Var_TipoDisper = DispersionOrden) THEN

			SELECT BloqueoID INTO Var_BloqueoID
				FROM BLOQUEOS
				WHERE CuentaAhoID = Var_CuentaAhoID
				  AND NatMovimiento = Nat_Bloqueo
				  AND TiposBloqID = Blo_Desemb
				  AND Referencia = Par_CreditoID
				  AND FolioBloq = Entero_Cero
				  AND ( Descripcion = DescripBloqSPEI
				  OR    Descripcion = DescripBloqCheq
	              OR	Descripcion = DescripBloqOrden);

			SET Var_BloqueoID   := IFNULL(Var_BloqueoID, Entero_Cero);

			CALL BLOQUEOSPRO(
				Var_BloqueoID,  	Nat_Desbloqueo, Var_CuentaAhoID,    Var_FechaOper,      Entero_Cero,
				Var_FechaOper,  	Deb_RevDesemb,  Var_Descripcion,    Par_CreditoID,      Cadena_Vacia,
				Cadena_Vacia,   	SalidaNo,      	Par_NumErr, 		Par_ErrMen,  		Par_EmpresaID,
	            Aud_Usuario,        Aud_FechaActual,Aud_DireccionIP,   	Aud_ProgramaID, 	Aud_Sucursal,
	            Aud_NumTransaccion);

	        IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;

		CALL SALDOSAHORROCON(Var_ClienteID, Var_CueSaldo, Var_CueMoneda, Var_CueEstatus, Var_CuentaAhoID);

		SET Var_ClienteID   := IFNULL(Var_ClienteID, Entero_Cero);
		SET Var_CueSaldo   	:= IFNULL(Var_CueSaldo, Entero_Cero);

		IF(IFNULL(Var_CueEstatus, Cadena_Vacia) != Cue_Activa) THEN
			SET Par_NumErr	:= 8;
			SET Par_ErrMen	:= 'La Cuenta no Existe o no Esta Activa';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Var_CueSaldo, Entero_Cero) < Var_MontoCargo ) THEN
			SET Par_NumErr	:= 9;
			SET Par_ErrMen	:= 'Saldo Insuficiente en la Cuenta del Cliente';
			LEAVE ManejoErrores;
		END IF;

		IF( ManjeaLinea = SiManejaLinea OR Var_EsLineaCreditoAgro = Const_Si ) THEN
			IF(IFNULL(lineaCredito,0)>0)THEN

				SELECT CobraComAnual INTO Var_CobraComAnual
				FROM LINEASCREDITO
				WHERE LineaCreditoID=lineaCredito;

				UPDATE LINEASCREDITO SET
					Dispuesto 		= Dispuesto - Var_MontoCred,
					SaldoDisponible	= SaldoDisponible + Var_MontoCred,
					NumeroCreditos	= NumeroCreditos - 1,
					SaldoDeudor		= IFNULL(SaldoDeudor,0) - Var_MontoCred,

					Usuario			= Aud_Usuario,
					FechaActual		= Aud_FechaActual,
					DireccionIP 	= Aud_DireccionIP,
					ProgramaID  	= Aud_ProgramaID,
					Sucursal		= Aud_Sucursal,
					NumTransaccion	= Aud_NumTransaccion
				WHERE LineaCreditoID	= lineaCredito;
			END IF;
		END IF;

		-- TODO: Reversa al Fondeador

		-- Realizamos los Movimientos Operativos y Contables de la Reversa

		-- 2) Abono a Cuenta por el Cargo de la Comision por Apertura
		IF (Par_AltaEncPoliza = AltaPoliza_SI) THEN
			CALL MAESTROPOLIZAALT(
				Par_Poliza,         Par_EmpresaID,	Var_FechaApl, 	Pol_Automatica,     Con_ContDesem,
				Var_Descripcion,    SalidaNo,       Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,
				Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion);
		END IF;

		IF(Var_MontoComAp > Entero_Cero AND (Var_ForComApe != ForComApAntici AND Var_ForComApe != ForComProg)) THEN

			CALL  CONTACREDITOPRO (
				Par_CreditoID,      Entero_Cero,        Var_CuentaAhoID,    Var_ClienteID,		Var_FechaOper,
				Var_FechaApl,       Var_MontoComAp,     Var_MonedaID,		Var_ProdCreID,      Var_ClasifCre,
				Var_SubClasifID,    Var_SucCliente,		Var_DescComAper,    Var_CuentaAhoStr,   AltaPoliza_NO,
				Con_ContDesem,		Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,      Con_ContGastos,
				Entero_Cero,        Nat_Cargo,          AltaMovAho_SI,      Tip_MovAhoComAp,	Nat_Abono,
				Cadena_Vacia,		/*Cons_No,*/			Str_NumErr,         Par_ErrMen,         Par_Consecutivo,
				Par_EmpresaID,		Cadena_Vacia,		Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			SET Par_NumErr := CONVERT(Str_NumErr, UNSIGNED);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			-- Movimientos de IVA  de comision por apertura
			IF(Var_IVAComAp != Entero_Cero) THEN

				CALL  CONTACREDITOPRO (
					Par_CreditoID,      Entero_Cero,        Var_CuentaAhoID,    Var_ClienteID,		Var_FechaOper,
					Var_FechaApl,       Var_IVAComAp,       Var_MonedaID,		Var_ProdCreID,      Var_ClasifCre,
					Var_SubClasifID,    Var_SucCliente,		Var_DcIVAComApe,    Var_CuentaAhoStr,   AltaPoliza_NO,
					Con_ContDesem,		Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,      Con_ContIVACApe,
					Entero_Cero,        Nat_Cargo,          AltaMovAho_SI,      Tip_MovIVAAhCAp,	Nat_Abono,
					Cadena_Vacia,		/*Cons_No,*/			Str_NumErr,         Par_ErrMen,         Par_Consecutivo,
					Par_EmpresaID,      Cadena_Vacia,		Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,     Aud_Sucursal,		Aud_NumTransaccion);

				SET Par_NumErr := CONVERT(Str_NumErr, UNSIGNED);

				IF (Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;

		ELSE
			SET Var_MontoComAp  := Entero_Cero;
		END IF;

		-- 3) Abono a Cuenta por el Cargo del Seguro de Vida
		 IF(Var_MontoSegVida > Entero_Cero AND Var_ForCobSegVida != ForComApAntici) THEN

			CALL  CONTACREDITOPRO (
				Par_CreditoID,      Entero_Cero,        Var_CuentaAhoID,    Var_ClienteID,		Var_FechaOper,
				Var_FechaApl,       Var_MontoSegVida,   Var_MonedaID,		Var_ProdCreID,      Var_ClasifCre,
				Var_SubClasifID,    Var_SucCliente,		Var_DescSegVida,    Var_CuentaAhoStr,   AltaPoliza_NO,
				Con_ContDesem,		Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,      Con_PagoSegVida,
				Entero_Cero,        Nat_Cargo,          AltaMovAho_SI,      Tip_MovAhoSegVid,	Nat_Abono,
				Cadena_Vacia,		/*Cons_No,*/			Str_NumErr,         Par_ErrMen,         Par_Consecutivo,
				Par_EmpresaID,      Cadena_Vacia,		Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,     Aud_Sucursal,		Aud_NumTransaccion);

			SET Par_NumErr := CONVERT(Str_NumErr, UNSIGNED);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

				-- Actualizamos el Seguro de Vida como NO Pagado
			CALL SEGUROVIDAACT (
				Entero_Cero,        Par_CreditoID,  Var_CuentaAhoID,    Act_Inactivo,       SalidaNo,
				Par_NumErr,         Par_ErrMen,     Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,
				Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		ELSE
			SET Var_MontoSegVida := Entero_Cero;
		END IF;

		-- ========= REVERSA DE COMISIÓN POR ANUALIDAD SI MANEJA LINEA Y SI FUE PAGADA EN ESTE DESEMBOLSO ========
		IF(ManjeaLinea = SiManejaLinea AND Var_CobraComAnual=Const_Si)THEN
			SELECT CantidadMov INTO Var_MontoComAnualLin
			FROM CUENTASAHOMOV
			WHERE CuentaAhoID=Var_CuentaAhoID
			AND Fecha=Var_FechaOper
			AND NatMovimiento = Nat_Cargo
			AND ReferenciaMov=lineaCredito
			AND TipoMovAhoID='208';

			IF(IFNULL(Var_MontoComAnualLin,Entero_Cero)<>Entero_Cero)THEN
				SELECT	MonedaID,		SucursalID
					INTO	Var_MonedaID,	VarSucursalLin
				FROM  LINEASCREDITO
				WHERE LineaCreditoID = lineaCredito;

				SET ConstDescipLinea := CONCAT('REV. COM. ANUALIDAD LINEA No.',lineaCredito);

				-- SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES DE LA COMISIÓN ANUAL , DENTRO MANDA A LLAMAR A POLIZALINEACREPRO Y POLIZAAHORROPRO
				CALL CONTALINEACREPRO(
					lineaCredito,		Entero_Cero,			Var_FechaOper,		Var_FechaOper,		Var_MontoComAnualLin,
					Var_MonedaID,		Var_ProdCreID,			VarSucursalLin,		ConstDescipLinea,	lineaCredito,
					AltaPoliza_NO,		Entero_Cero,			AltaPolCre_SI,		AltaMovAho_SI,		Con_ContComAnual,
					TipoMovAhoComAnual,	Nat_Cargo,				Nat_Abono,			Par_NumErr,			Par_ErrMen,
                    Par_PolizaID,		Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
                    Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);
				IF (Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

				IF(Var_PagaIVA = Const_Si) THEN

					SELECT IVA INTO Var_IVA
					FROM SUCURSALES
					WHERE SucursalID = Var_SucCliente;
					SET Var_IVA := IFNULL(Var_IVA,Decimal_Cero);

					SET Var_MontoIVAComAnual := (Var_MontoComAnualLin * Var_IVA);
					SET ConstDescipLinea := CONCAT('REV. IVA COM. ANUALIDAD LINEA No.',lineaCredito);
					-- SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES DE IVA DE LA COMISIÓN ANUAL , DENTRO MANDA A LLAMAR A POLIZALINEACREPRO Y POLIZAAHORROPRO
					CALL CONTALINEACREPRO(
						lineaCredito,			Entero_Cero,			Var_FechaOper,		Var_FechaOper,		Var_MontoIVAComAnual,
						Var_MonedaID,			Var_ProdCreID,			VarSucursalLin,		ConstDescipLinea,	lineaCredito,
						AltaPoliza_NO,			Entero_Cero,			AltaPolCre_SI,		AltaMovAho_SI,		Con_ContIVAComAnual,
						TipoMovAhoIVAComAnual,	Nat_Cargo,				Nat_Abono,				Par_NumErr,			Par_ErrMen,
                        Par_PolizaID,			Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
                        Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

					IF (Par_NumErr <> Entero_Cero)THEN
						LEAVE ManejoErrores;
					END IF;
				END IF;

               UPDATE LINEASCREDITO SET
					ComisionCobrada = 'N',
                    SaldoComAnual = Var_MontoComAnualLin
				WHERE LineaCreditoID = lineaCredito;
			END IF;

		END IF;

				# =================== REVERSA ACCESORIOS =================
        # SE OBTIENE EL NUMERO DE ACCESORIOS COBRADOS POR EL CREDITO
			SET Var_NumRegistros := (SELECT COUNT(*) FROM RESDETACCESORIOS WHERE CreditoID = Par_CreditoID);
			SET Var_NumRegistros := IFNULL(Var_NumRegistros, Entero_Cero);
			SET Contador := 1;

			# INICIA CICLO PARA EL COBRO DE ACCESORIOS
		   CICLO: WHILE(Contador <= Var_NumRegistros) DO

				# SE OBTIENEN EL ACCESORIO AL QUE SE LE APLICARA LA REVERSA DEL PAGO
                SET Var_AccesorioID := (SELECT AccesorioID FROM RESDETACCESORIOS WHERE CreditoID = Par_CreditoID AND Consecutivo = Contador);

				CALL REVACCESORIOSCREDPRO(
					Par_CreditoID,	Var_AccesorioID,	Var_CuentaAhoID,	Var_ClienteID,		Var_MonedaID,
					Var_ProdCreID,	Var_SucCliente,		Var_ClasifCre,		Var_SubClasifID,	Var_PagaIVA,
					Par_PolizaID,	SalidaNo,      		Par_NumErr, 		Par_ErrMen,  		Par_EmpresaID,
					Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,   	Aud_ProgramaID, 	Aud_Sucursal,
					Aud_NumTransaccion);

				IF (Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

				SET Contador := Contador + 1;
			END WHILE CICLO;

		-- 4 ) Movimientos del Desembolso del credito, realiza tambien el Cargo a Cuenta

		CALL  CONTACREDITOPRO (
			Par_CreditoID,      Entero_Cero,        Var_CuentaAhoID,    Var_ClienteID,		Var_FechaOper,
			Var_FechaApl,       Var_MontoCred,      Var_MonedaID,		Var_ProdCreID,      Var_ClasifCre,
			Var_SubClasifID,    Var_SucCliente,		Var_Descripcion,    Var_CuentaAhoStr,   AltaPoliza_NO,
			Con_ContDesem,		Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,      Con_ContCapCre,
			Entero_Cero,        Nat_Abono,          AltaMovAho_SI,      Tip_MovAhoDesem,	Nat_Cargo,
			Cadena_Vacia,		/*Cons_No,*/			Str_NumErr,         Par_ErrMen,         Par_Consecutivo,
			Par_EmpresaID,      Cadena_Vacia,		Aud_Usuario,        Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,     Aud_Sucursal,		Aud_NumTransaccion  );

		SET Par_NumErr := CONVERT(Str_NumErr, UNSIGNED);

		IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		SELECT	FechaSistema
		INTO	Var_FechaSistema
			FROM PARAMETROSSIS
			WHERE EmpresaID = Par_EmpresaID;

		IF(ManjeaLinea = SiManejaLinea)THEN
			IF(IFNULL(lineaCredito,0)>0)THEN
				SELECT	MonedaID,		SucursalID
				INTO	Var_MonedaID,	VarSucursalLin
					FROM  LINEASCREDITO
					WHERE LineaCreditoID = lineaCredito;

				/* se manda a llamar a sp que genera los detalles contables de lineas de credito . */
				CALL CONTALINEACREPRO(	-- SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES, DENTRO MANDA A LLAMAR A POLIZALINEACREPRO
					lineaCredito,		Entero_Cero,			Var_FechaSistema,	Var_FechaSistema,	Var_MontoCred,
					Var_MonedaID,		Var_ProdCreID,			VarSucursalLin,		Var_Descripcion,	lineaCredito,
					AltaPoliza_NO,		Con_ContDesem,			AltaPolCre_SI,		'N',				ConcepCtaOrdenDeu,
					Entero_Cero,		Nat_Cargo,				Nat_Cargo,			Par_NumErr,			Par_ErrMen,
                    Par_PolizaID,		Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
                    Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);


				IF (Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

				CALL CONTALINEACREPRO(	-- SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES, DENTRO MANDA A LLAMAR A POLIZALINEACREPRO
					lineaCredito,		Entero_Cero,			Var_FechaSistema,		Var_FechaSistema,	Var_MontoCred,
					Var_MonedaID,		Var_ProdCreID,			VarSucursalLin,			Var_Descripcion,	lineaCredito,
					AltaPoliza_NO,		Con_ContDesem,			AltaPolCre_SI,			'N',				ConcepCtaOrdenCor,
					Entero_Cero,		Nat_Abono,				Nat_Abono,				Par_NumErr,			Par_ErrMen,
                    Par_PolizaID,		Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
                    Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

				IF (Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;
		END IF;



		/* se valida, si se trata de un credito con un tipo de pago de
		***capital LIBRE  o Irrregular entonces el numero de transaccion del
		***cotizador se pone en cero */
		IF(VarTipoPagoCapital = CapitalLibre) THEN
			SET VarNumTransac := Entero_Cero;
		ELSE
			SET VarNumTransac := VarNumTransacSim ;
		END IF;

		-- 5 ) Actualizamos el Credito
		UPDATE CREDITOS SET
			Estatus         	= Estatus_Activo,
		   --  FechaMinistrado = Fecha_Vacia,    //SE QUITO LA ACTULIZACION DE LA FECHA MINISTRA PARA QUE SE HABILITARA EL BOTON DE DESEMBOLSAR EN LA PANTALLA DE DESEMBOLSO CREDITO GRUPAL
			ComAperPagado    	= ComAperPagado -  Var_MontoComAp,
			SeguroVidaPagado 	= SeguroVidaPagado - Var_MontoSegVida,
			SaldoCapVigent		= Entero_Cero,
			SaldoCapVencido 	= Entero_Cero,
			SaldCapVenNoExi		= Entero_Cero,
			NumTransacSim		= VarNumTransac,

			Usuario				= Aud_Usuario,
			FechaActual			= Aud_FechaActual,
			DireccionIP			= Aud_DireccionIP,
			ProgramaID			= Aud_ProgramaID,
			Sucursal			= Aud_Sucursal,
			NumTransaccion		= Aud_NumTransaccion
		WHERE	CreditoID		= Par_CreditoID;

		-- 6 ) Actualizamos las Amortizaciones
		UPDATE AMORTICREDITO SET
			Estatus         = Estatus_Inactivo,
			SaldoCapVigente = Entero_Cero,
			SaldoCapVencido = Entero_Cero,
			SaldoCapVenNExi = Entero_Cero,

			Usuario         = Aud_Usuario,
			FechaActual     = Aud_FechaActual,
			DireccionIP     = Aud_DireccionIP,
			ProgramaID      = Aud_ProgramaID,
			Sucursal        = Aud_Sucursal,
			NumTransaccion  = Aud_NumTransaccion
		WHERE	CreditoID	= Par_CreditoID;

		-- 7 ) Actualizamos la Solicitud de Credito
		SET Var_SoliciCredID    := IFNULL(Var_SoliciCredID, Entero_Cero);

		UPDATE SOLICITUDCREDITO SET
			Estatus			    	= Estatus_Autoriza,
			FechaFormalizacion  	= Fecha_Vacia,

			Usuario					= Aud_Usuario,
			FechaActual 			= Aud_FechaActual,
			DireccionIP 			= Aud_DireccionIP,
			ProgramaID  			= Aud_ProgramaID,
			Sucursal				= Aud_Sucursal,
			NumTransaccion			= Aud_NumTransaccion
		WHERE	SolicitudCreditoID 	= Var_SoliciCredID;

		-- 8 ) Borramos los Movimientos del Credito
		DELETE FROM CREDITOSMOVS
			WHERE CreditoID = Par_CreditoID
			  AND Descripcion = 'DESEMBOLSO DE CREDITO';

		-- 9 Borramos la tabla del pagare de Credito
		DELETE FROM PAGARECREDITO
				WHERE CreditoID = Par_CreditoID;

		-- 10) Guardar Bitacora de la Reversa
		INSERT INTO REVERSADESCRE VALUES(
			Var_FechaOper,  Par_CreditoID,  Par_Motivo,         Var_UsuarioID,      Var_ClienteID,
			Par_EmpresaID,  Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
			Aud_Sucursal,   Aud_NumTransaccion);

        -- 10 Borramos de la tabla CRECOBCOMMENSUAL los cortes de mes generados
		DELETE FROM CRECOBCOMMENSUAL
				WHERE CreditoID = Par_CreditoID;

		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= 'Reversa del Desembolso del Credito, Realizado Exitosamente.';

	END ManejoErrores;  -- END del Handler de Errores

		IF	(Par_Salida = Salida_SI) THEN
			SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
			  		Par_ErrMen AS ErrMen,
                    CASE Var_NumGrupo
						WHEN 0 THEN 'creditoID'
                        ELSE  'grupoID' END AS control,
					CASE Var_NumGrupo
						WHEN 0 THEN Par_CreditoID
                        ELSE  Var_NumGrupo END AS consecutivo;
		END IF;

END TerminaStore$$