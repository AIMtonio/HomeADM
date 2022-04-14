-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DISPERSIONMINISPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `DISPERSIONMINISPRO`;
DELIMITER $$

CREATE PROCEDURE `DISPERSIONMINISPRO`(
# ===============================================================
# ---- SP PARA OBTENER DESEMBOLSOS DE CREDITO POR DISPERSION-----
# ===============================================================
	Par_InstitucionID 		INT(11),
	Par_NumCtaInstit 		VARCHAR(20),
	Par_Fecha				DATE,

	Par_Salida				CHAR(1),
	INOUT	Par_NumErr 		INT(11),
	INOUT	Par_ErrMen  	VARCHAR(400),

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_Credito				BIGINT(12);
	DECLARE Var_NumSucursal			INT(11);
	DECLARE NumError				INT(11);
	DECLARE ErrorMen				VARCHAR(200);
	DECLARE CtaPrincipal			CHAR(1);
	DECLARE Var_Institucion			INT(11);
	DECLARE Var_CtaInstitu			VARCHAR(20);
	DECLARE FolioOperac				INT(11);
	DECLARE Var_CuentaAhoID			BIGINT(12);
	DECLARE Var_MontoCred			DECIMAL(14,4);
	DECLARE Var_SoliciCredID		INT(11);
	DECLARE Var_NomCliente			VARCHAR(200);
	DECLARE VarRFCcte				VARCHAR(13);
	DECLARE VarRFCPMcte				VARCHAR(13);
	DECLARE VarTipoPerson			CHAR(1);
	DECLARE VarCuentaCLABE			VARCHAR(20);
	DECLARE RegistroSalida			INT(11);
	DECLARE Var_ForComApe			CHAR(1);
	DECLARE Var_MontoComAp			DECIMAL(12,4);
	DECLARE Var_IVAComAp			DECIMAL(12,4);
	DECLARE Var_TipoDispersion		CHAR(1);
	DECLARE Var_FormaPago			INT(11);
	DECLARE TipoMovDis				CHAR(4);
	DECLARE numeroCreditos			INT(11); -- variable para saber si existen o no creditos para ministrar
	DECLARE Var_FechaSistema		DATE;
	DECLARE Var_ForCobSeg			CHAR(1);
	DECLARE Var_MontoSegVid			DECIMAL(12,2);
    DECLARE	Var_Consecutivo			BIGINT(12);
    DECLARE Var_Control 			VARCHAR(100);
	DECLARE VarTipoChequera			CHAR(2);
	DECLARE Var_MontoCargoDisp		DECIMAL(12,4);
	DECLARE Var_ProductoCreditoID	INT(11);
	DECLARE Var_Dispersiones 		CHAR(10);			-- cambia de acuerdo a los tipos de dispersion habilitados
	DECLARE	Var_SpeiHab				CHAR(1);			-- indica el estatus de habilitado de SPEI
	DECLARE Var_PermiteDispersion	CHAR(1);			-- Indica si permite Multiples Dispersiones
	DECLARE Var_NumReg				INT(11);			-- Numero de Registros
	DECLARE Var_Contador			INT(11);			-- Variable Contador
	DECLARE Var_NumCartas			INT(11);			-- Numero de Registros de Cartas de  Liquidacion ligadas al Credito
	DECLARE Var_Conta				INT(11);			-- Variable Contador
	DECLARE Var_CasaCom				BIGINT(11);			-- Variable de Casa Comercial
	DECLARE Var_MontoCasa			DECIMAL(18,2);		-- Variable Monto de la Carta de Liquidacion
	DECLARE Var_MontoDispCasa		DECIMAL(18,2);		-- Variable Monto Dispersado de la Carta de Liquidacion
	DECLARE Var_EstCasa				CHAR(1);			-- Variable Estatus de la Carta de Liquidacion
	DECLARE Var_SaldoCliente		DECIMAL(14,2);		-- Variable de Saldo a Favor del Cliente con respecto a las Cartas de Liquidacion
	DECLARE Var_AsigCarta			BIGINT(11);			-- Variable de Asignacion de de Carta
	DECLARE Var_FormaPagoCarta		INT(11);			-- Forma de Pago para la Carta de Liq
	DECLARE TipoMovDisCarta			CHAR(4);			-- Tipo de Mov de Dispersion para la Carta de Liq
	DECLARE DescripCarta       		VARCHAR(40);		-- Descripcion de Movimiento de SPEI para la Carta Comercial
	DECLARE VarCuentaCLABECarta		VARCHAR(20);		-- Cuenta Clabe de la Casa Comercial con respecto a la Carta de Liq
	DECLARE VarTipoChequeraCarta	CHAR(2);			-- Tipo de Chequera
	DECLARE Var_EstImpDis			CHAR(1);			-- Estatus de Dispersion
	DECLARE Var_FolioDispExis	INT(11);				-- Variable que almancena el Folio de Dispersion del Credito
	DECLARE Par_Consecutivo		INT(11);				-- Variable Consecutivo
	DECLARE Var_DispersionSan 		CHAR(1);			-- Genera Dispersion Automatica
	DECLARE Var_RefAutomatico		VARCHAR(20);		-- Referencia Automatica
	DECLARE Var_EsAutomatico		CHAR(1);			-- requiere generar la referencia automantica
	DECLARE Var_Complemento		VARCHAR(18);
	DECLARE Var_Vigencia			INT(11);
	DECLARE Var_FechaVen 			DATE;
	DECLARE Var_TipoCuentaDisper	INT(11);			-- Tipo Cuenta Dispersion 1.- Instruccion Nueva , 2.- Instruc. de Carta Liq. Externas, 3.- Instruc. de Carta Liq. Interna
	DECLARE Var_EstImport			CHAR(1);			-- Estatado de la importacion S- Si importada N no importada
	DECLARE Var_EstDisper			CHAR(1);			-- Estado de la dispersion D dispersada N no dispersada
	DECLARE Var_FolioCredito		INT(11);
	-- Declaracion de Constantes
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Fecha_Vacia			DATE;
	DECLARE Entero_Cero			INT(11);
	DECLARE Decimal_Cero		DECIMAL(12,4);
	DECLARE EstatPagada			CHAR(1);
	DECLARE SalidaSi           	CHAR(1);
	DECLARE SalidaNo           	CHAR(1);
	DECLARE TipoDisperSPEI     	CHAR(1);
    DECLARE TipoDisperOrden		CHAR(1);
	DECLARE TipoDisperCheque   	CHAR(1);
	DECLARE TipoDisperSantan	CHAR(1);
	DECLARE TipoMovDisSPEI     	CHAR(4);
	DECLARE TipoMovDisCheq     	CHAR(4);
    DECLARE TipoMovDisOrden		CHAR(4);
    DECLARE TipoMovDisSantan	CHAR(4);
	DECLARE PerFisica          	CHAR(1);
	DECLARE PerMoral           	CHAR(1);
	DECLARE Descrip            	VARCHAR(40);
	DECLARE DescripSPEI        	VARCHAR(40);
	DECLARE DescripCheq		   	VARCHAR(40);
    DECLARE DescripOrdenPago	VARCHAR(50);
	DECLARE EstatusPendien	   	CHAR(1);
	DECLARE ForComApDeduc      	CHAR(1);
	DECLARE ForComApFinanc     	CHAR(1);
	DECLARE FormaPagoSPEI      	INT(11);
	DECLARE FormaPagoCheque	   	INT(11);
    DECLARE FormaPagoOrden	   	INT(11);
	DECLARE Bloq_DispCred      	INT(11);
	DECLARE Mov_Bloqueo        	CHAR(1);
	DECLARE Fecha				DATE;
	DECLARE SiHabilita			CHAR(1);
	DECLARE ValorParam			VARCHAR(100);
	DECLARE Var_SiHabilita		CHAR(1);
	DECLARE FechaSis			DATE;
	DECLARE ForCobDeduc			CHAR(1);
	DECLARE ForCobFinanc		CHAR(1);
	DECLARE Est_SpeiHab			CHAR(1);
	DECLARE NoPermiteDisp		CHAR(1);			-- No Permite Dispersiones
	DECLARE Est_DispCarta		CHAR(1);			-- Estatus de Carta Dispersada
	DECLARE Var_DispersionCarta	CHAR(1);			-- Dispersion de la Carta de Liquidacion
	DECLARE TipoCliente			CHAR(1);			-- Tipo de Movimiento perteneciente a Cliente
	DECLARE TipoCarta			CHAR(1);			-- Tipo de Movimiento pertenecietne a Cartas de Liquidacion
	DECLARE ParMulDisp			CHAR(1);			-- Parametro de Multiple Dispersiones
	DECLARE Con_SI				CHAR(1);			-- Constante SI 'S'
	DECLARE Con_NO				CHAR(1);			-- Constante NO 'N'
	DECLARE Est_Activo			CHAR(1);			-- Estatus Activo
	DECLARE Var_TipoActConcepto	INT(11);			-- Actualizacion de Concepto
	DECLARE ConcepCarta			INT(11);			-- Concepto Carta No de ID de CATCONCEPTOSDISPERSION
	DECLARE ConceptoCliente		INT(11);			-- Concepto Cliente No de ID de CATCONCEPTOSDISPERSION
	DECLARE DispersionSantander VARCHAR(50);		-- Llave Parametros Para dipersion Santander
	DECLARE Con_Credito			INT(11);			-- Valor indicado para la referencia automantica para creditos
	DECLARE Con_Automatico		CHAR(1);			-- indica referencia automatica
	DECLARE Con_TipoCredito		INT(11);
	DECLARE FormaPagoSantan		INT(11);
	DECLARE DescripRefSantan	VARCHAR(40);
	DECLARE Con_DispTransSanta	VARCHAR(50);		-- Llave parametro para el tipo de movimiento contable de Transferecnias Santander
	DECLARE Entero_Uno			INT(11);			-- Entero uno
	DECLARE Var_NombreBen		VARCHAR(250);       -- Nombre del beneficario
	DECLARE Var_FolioOperacion	int(11);
	DECLARE Var_ClaveDispMov    int(11);
	DECLARE Var_EstatusResSanta VARCHAR(3);

	-- Varibales y constantes para el proceso de dispersion
	DECLARE	Var_MontoDisp		DECIMAL(12, 4);			-- Monto a dispersar
	DECLARE	Var_NumInstruct		INT(11);
	DECLARE	FormaPago			INT(11);
	DECLARE	Var_CLABEDisp		VARCHAR(20);
	DECLARE Var_BenefID			INT(11);
	DECLARE ConceptoInstruct	INT(11);

	DECLARE CURSORDISPMINIS CURSOR FOR
	SELECT	Cre.CreditoID, Cre.SucursalID,	Cre.TipoDispersion, Cre.CuentaCLABE
		FROM 	CREDITOS Cre,  BLOQUEOS Blo
		WHERE 	Cre.FolioDispersion	= Entero_Cero
		AND 	Cre.CreditoID       = Blo.Referencia
		AND 	Blo.TiposBloqID     = Bloq_DispCred
		AND 	Blo.NatMovimiento   = Mov_Bloqueo
		AND 	IFNULL(Blo.FolioBloq,Entero_Cero)	= Entero_Cero
		AND 	Cre.CuentaID        = Blo.CuentaAhoID
		AND 	FIND_IN_SET(Cre.TipoDispersion,Var_Dispersiones) > Entero_Cero
		AND 	Cre.Estatus 		= 'V';


	-- Asignacion de Constantes
	SET Entero_Cero         := 0;
	SET Cadena_Vacia        := '';
	SET EstatPagada         := 'P';
	SET SalidaSi            := 'S';
	SET SalidaNo            := 'N';
	SET TipoDisperSPEI      := 'S';
	SET TipoDisperCheque    := 'C';
    SET TipoDisperOrden   	:= 'O';
    SET TipoDisperSantan	:= 'A';
	SET CtaPrincipal        := 'S';
	SET TipoMovDisSPEI      := '2';
	SET TipoMovDisCheq      := '12';
    SET TipoMovDisOrden     := '700';
	SET PerFisica           := 'F';
	SET PerMoral            := 'M';
	SET DescripSPEI         := 'SPEI DESEMBOLSO CREDITO';
	SET DescripCheq         := 'CHEQUE PAGADO DES CREDITO';
    SET DescripOrdenPago	:= 'ORDEN PAGO DESEMBOLSO CREDITO';
    SET DescripRefSantan	:= 'TRAN. SANTAN DESEMBOLSO DE CREDITO';
	SET EstatusPendien      := 'P';
	SET ForComApDeduc       := 'D';
	SET ForComApFinanc      := 'F';
	SET FormaPagoSPEI       := 1;
	SET FormaPagoCheque     := 2;
    SET FormaPagoOrden		:= 5;
    SET FormaPagoSantan		:= 6;
	SET Bloq_DispCred       := 1;       -- Tipo de Bloqueo por Dispersion de Credito
	SET Mov_Bloqueo         := 'B';     -- Movimiento de Bloqueo de Saldo
	SET Var_FechaSistema 	:= (SELECT FechaSistema FROM PARAMETROSSIS);
	SET SiHabilita			:= "S";
	SET ValorParam			:= "HabilitaFechaDisp";
	SET ForCobDeduc			:= 'D';
	SET ForCobFinanc		:= 'F';
	SET	Est_SpeiHab			:='S';
	SET NoPermiteDisp		:= 'N';
	SET Est_DispCarta		:= 'S';
	SET TipoCliente			:= 'C';
	SET TipoCarta			:= 'L';
	SET ParMulDisp			:= (SELECT PermitirMultDisp FROM PARAMETROSSIS LIMIT 1);
	SET Con_SI				:= 'S';
	SET Con_NO				:= 'N';
	SET Est_Activo			:= 'A';
	SET Var_TipoActConcepto	:= 3;
	SET ConcepCarta			:= 2;
	SET ConceptoInstruct	:= 3;
	SET ConceptoCliente		:= 1;
	SET DispersionSantander	:= 'DispersionSantander';				-- Llave Parametros Para dipersion Santander
	SET Con_Credito			:= 1;
	SET Con_Automatico		:= 'A';
	SET Con_TipoCredito		:= 1;
	SET Con_DispTransSanta	:= 'DispTransSantander';
	SET Entero_Uno			:= 1;

    SELECT ValorParametro INTO TipoMovDisSantan
		FROM PARAMGENERALES
		WHERE LlaveParametro=Con_DispTransSanta;

    SET TipoMovDisSantan := IFNULL(TipoMovDisSantan, Cadena_Vacia);
	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								  'Disculpe las molestias que esto le ocasiona. Ref: SP-DISPERSIONMINISPRO');
		END;

		SELECT ValorParametro INTO Var_SiHabilita
			FROM PARAMGENERALES WHERE LlaveParametro=ValorParam;

		SELECT ValorParametro INTO Var_DispersionSan
			FROM PARAMGENERALES WHERE LlaveParametro=DispersionSantander;

		IF Var_SiHabilita=SiHabilita THEN
			SET Fecha :=Par_Fecha;
		ELSE
			SET Fecha :=Var_FechaSistema;
		END IF;

		SELECT Habilitado
			INTO Var_SpeiHab
			FROM PARAMETROSSPEI
			LIMIT 1;

		IF Var_SpeiHab = Est_SpeiHab  THEN
			SET Var_Dispersiones :=	'C,O,A,E';
		ELSE
			SET	Var_Dispersiones :=	'S,C,O,A,E';
		END IF;

		-- se obtiene el numero de creditos que cumplen la condicion
		IF (ParMulDisp = Con_NO) THEN
			SET numeroCreditos := (SELECT	COUNT(Cre.CreditoID)
									FROM 	CREDITOS Cre,
											BLOQUEOS Blo
									WHERE 	Cre.FolioDispersion 	= Entero_Cero
									AND 	Cre.CreditoID       	= Blo.Referencia
									AND 	Blo.TiposBloqID     	= Bloq_DispCred
									AND 	Blo.NatMovimiento   	= Mov_Bloqueo
									AND 	IFNULL(Blo.FolioBloq,Entero_Cero) = Entero_Cero
									AND 	Cre.CuentaID        	= Blo.CuentaAhoID
									AND 	FIND_IN_SET(Cre.TipoDispersion,Var_Dispersiones) > Entero_Cero
									AND 	Cre.Estatus 			IN ('V','B')); -- Credito Vigente y Vencidos.
		ELSE
			SET numeroCreditos := (SELECT	COUNT(Cre.CreditoID)
									FROM 	CREDITOS Cre,
											BLOQUEOS Blo
									WHERE 	Cre.CreditoID       	= Blo.Referencia
									AND 	Blo.TiposBloqID     	= Bloq_DispCred
									AND 	Blo.NatMovimiento   	= Mov_Bloqueo
									AND 	IFNULL(Blo.FolioBloq,Entero_Cero) = Entero_Cero
									AND 	Cre.CuentaID        	= Blo.CuentaAhoID
									AND 	FIND_IN_SET(Cre.TipoDispersion,Var_Dispersiones) > Entero_Cero
									AND 	Cre.Estatus 			IN ('V','B')); -- Credito Vigente y Vencidos.
		END IF;

		IF(numeroCreditos = Entero_Cero)THEN
			SET	Par_NumErr 		:= 1;
			SET	Par_ErrMen		:= 'No Hay Creditos para Importar';
            SET Var_Control		:= 'folioOperacion';
            SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_EmpresaID,Entero_Cero) = Entero_Cero )THEN
			SET	Par_NumErr 		:= 1;
			SET	Par_ErrMen		:= 'La Empresa esta vacia';
            SET Var_Control		:= '';
            SET Var_Consecutivo := Par_EmpresaID;
			LEAVE ManejoErrores;
		END IF;

		-- se valida que exixte el numero de institucion
		SET Var_Institucion := IFNULL((SELECT InstitucionID
											FROM 	INSTITUCIONES
											WHERE 	InstitucionID = Par_InstitucionID ),Entero_Cero);

		IF(IFNULL(Var_Institucion,Entero_Cero) = Entero_Cero )THEN
			SET	Par_NumErr 		:= 1;
			SET	Par_ErrMen		:= 'La Institucion especificada no Existe';
            SET Var_Control		:= 'institucionID';
            SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		-- se valida que exixte el numero de cuenta de la institucion
		SET Var_CtaInstitu := IFNULL((SELECT NumCtaInstit
										FROM 	CUENTASAHOTESO
										WHERE 	InstitucionID	= Par_InstitucionID
										AND 	NumCtaInstit	= Par_NumCtaInstit),Cadena_Vacia);

		IF(IFNULL(Var_CtaInstitu,Cadena_Vacia) = Cadena_Vacia )THEN
			SET	Par_NumErr 		:= 2;
			SET	Par_ErrMen		:= 'La Cuenta Bancaria especificada no Existe';
            SET Var_Control		:= 'numCtaInstit';
            SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SET Aud_FechaActual := CURRENT_TIMESTAMP();

		SELECT C.AlgClaveRetiro, C.VigClaveRetiro INTO Var_EsAutomatico, Var_Vigencia
		FROM CUENTASAHOTESO C
		WHERE C.InstitucionID		= Var_Institucion
			AND	C.NumCtaInstit		= Var_CtaInstitu;

		IF (numeroCreditos > Entero_Cero) THEN

			CALL DISPERSIONALT(
				Fecha,				Var_Institucion,    Var_CtaInstitu,     Par_NumCtaInstit,	SalidaNo,
				Par_NumErr, 		Par_ErrMen,         FolioOperac,        Par_EmpresaID,      Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;

		SET Var_PermiteDispersion := (SELECT PermitirMultDisp FROM PARAMETROSSIS LIMIT 1);
		SET Var_PermiteDispersion := IFNULL(Var_PermiteDispersion,NoPermiteDisp);

		IF (Var_PermiteDispersion = NoPermiteDisp) THEN

			OPEN CURSORDISPMINIS;
				BEGIN
					DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
					CICLODISP:LOOP

					FETCH CURSORDISPMINIS 	INTO
						Var_Credito, Var_NumSucursal,	Var_TipoDispersion, VarCuentaCLABE;

						SELECT	Cre.CuentaID,				Cre.MontoCredito,	Cre.SolicitudCreditoID,	Cli.NombreCompleto,
								Cli.RFC,					Cli.RFCpm,			Cli.TipoPersona,		Pro.ForCobroComAper,
								IFNULL(Cre.MontoComApert,Entero_Cero),			IFNULL(Cre.IVAComApertura,Entero_Cero),
								IFNULL(Cre.ForCobroSegVida,Cadena_Vacia),		IFNULL(Cre.MontoSeguroVida,Entero_Cero),
								Cre.ProductoCreditoID
						INTO	Var_CuentaAhoID,			Var_MontoCred,		Var_SoliciCredID,			Var_NomCliente,
								VarRFCcte,					VarRFCPMcte,		VarTipoPerson,				Var_ForComApe,
								Var_MontoComAp,				Var_IVAComAp,		Var_ForCobSeg,				Var_MontoSegVid,
								Var_ProductoCreditoID
							FROM CREDITOS Cre,
								CLIENTES Cli,
								CUENTASAHO Cta,
								PRODUCTOSCREDITO Pro
							WHERE CreditoID 				= Var_Credito
							AND Cre.ClienteID				= Cli.ClienteID
							AND Cta.ClienteID				= Cre.ClienteID
							AND Cta.CuentaAhoID			= Cre.CuentaID
							AND Cre.ProductoCreditoID		= Pro.ProducCreditoID;

						IF IFNULL(Var_CuentaAhoID,Entero_Cero) > Entero_Cero THEN

							SELECT DATE_FORMAT(FechaSistema,'%Y-%m-01') INTO FechaSis
								FROM PARAMETROSSIS;

							IF (YEAR(Par_Fecha) <= YEAR(FechaSis))THEN
								IF (MONTH(Par_Fecha) < MONTH(FechaSis))THEN
									SET	Par_NumErr 		:= 3;
									SET	Par_ErrMen		:= 'El Mes no Puede ser Menor al del Sistema';
									SET Var_Control		:= 'fechaActual';
									SET Var_Consecutivo := Entero_Cero;
									LEAVE ManejoErrores;
								END IF;
							END IF;
						END IF;

                       -- Se elimina validacion por tickect  9599
						/* Si el tipo de cobro de comision por apertura es Por deduccion o Financiamiento
						resta al monto de credito la comision por apertura y su iva*/
						IF((Var_ForComApe = ForComApDeduc) OR (Var_ForComApe = ForComApFinanc))THEN
							SET Var_MontoCred := Var_MontoCred -(Var_MontoComAp + Var_IVAComAp);
						END IF;

						/* Si el tipo de cobro de cobro del seguro de vida es Por deduccion o Financiamiento
						resta al monto de seguro de vida*/
						IF((Var_ForCobSeg = ForCobDeduc) OR (Var_ForCobSeg = ForCobFinanc))THEN
							SET Var_MontoCred := Var_MontoCred - Var_MontoSegVid;
						END IF;

						IF(VarTipoPerson = PerFisica )THEN
							SET VarRFCcte := VarRFCcte;
						END IF;
						IF(VarTipoPerson = PerMoral )THEN
							SET VarRFCcte := VarRFCPMcte;
						END IF;

						-- -----
						IF(Var_TipoDispersion = TipoDisperSPEI) THEN
							SET Var_FormaPago	:=	FormaPagoSPEI;
							SET TipoMovDis		:=	TipoMovDisSPEI;
							SET Descrip			:=	DescripSPEI;
							SELECT 	CuentaCLABE INTO VarCuentaCLABE
								FROM CREDITOS
								WHERE CreditoID = Var_Credito;
							SET VarTipoChequera := '';
						END IF;
						IF(Var_TipoDispersion = TipoDisperCheque) THEN
							SET Var_FormaPago	:=	FormaPagoCheque;
							SET TipoMovDis		:=	TipoMovDisCheq;
							SET Descrip			:=	DescripCheq;
							SET VarCuentaCLABE	:= '';
							SET VarTipoChequera := '';
						END IF;
						IF(Var_TipoDispersion = TipoDisperOrden) THEN
							SET Var_FormaPago	:=	FormaPagoOrden;
							SET TipoMovDis		:=	TipoMovDisOrden;
							SET Descrip			:=	DescripOrdenPago;
							SET VarCuentaCLABE	:= '';
							SET VarTipoChequera := '';
						END IF;

						IF(Var_TipoDispersion = TipoDisperSantan) THEN
							SET Var_FormaPago	:=	FormaPagoSantan;
							SET TipoMovDis		:=	TipoMovDisSantan;
							SET Descrip			:=	DescripRefSantan;
							SELECT 	CASE
										WHEN S.TipoCtaSantander = 'A' THEN S.CtaSantander
										WHEN S.TipoCtaSantander = 'O' THEN S.CtaClabeDisp
										END INTO VarCuentaCLABE
							FROM CREDITOS C
							INNER JOIN SOLICITUDCREDITO S ON C.SolicitudCreditoID = S.SolicitudCreditoID
							WHERE C.CreditoID = Var_Credito;
							SET VarTipoChequera := '';
						END IF;
						-- -----

						-- -- Validacion si el credito tiene el monto de des

						IF Var_DispersionSan = Con_SI AND Var_TipoDispersion = TipoDisperOrden AND Var_EsAutomatico = Con_Automatico THEN

							CALL GENERAREFAUTSAN(Con_Credito,			Var_Credito,	Con_NO,				Par_NumErr,			Par_ErrMen,
												Var_RefAutomatico, 		Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
												Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

							IF Var_RefAutomatico != Cadena_Vacia THEN
								SET VarCuentaCLABE := Var_RefAutomatico;
							END IF;

						END IF;

						CALL DISPERSIONMOVALT(
							FolioOperac,		Var_CuentaAhoID,    Cadena_Vacia,		Descrip,			CONCAT("CREDITO ",CONVERT(Var_Credito,CHAR)),
							TipoMovDis,			Var_FormaPago,		Var_MontoCred,  	VarCuentaCLABE, 	Var_NomCliente,
							Fecha, 				VarRFCcte,			EstatusPendien, 	SalidaNo,			Var_NumSucursal,
							Var_Credito,		Entero_Cero,		Entero_Cero,		Entero_Cero,		Entero_Cero,
							Entero_Cero,		Cadena_Vacia,		VarTipoChequera,	Par_NumErr,			Par_ErrMen,
							RegistroSalida,		Par_EmpresaID, 		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
							Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

						IF(Par_NumErr != Entero_Cero)THEN
							LEAVE CICLODISP;
						END IF;

						UPDATE CREDITOS SET
							FolioDispersion = FolioOperac
						WHERE	CreditoID	= Var_Credito;


						IF Var_DispersionSan = Con_SI AND Var_TipoDispersion = TipoDisperOrden AND Var_EsAutomatico = Con_Automatico THEN
							SET Var_FolioCredito := SUBSTRING(Var_RefAutomatico,1,1);
							IF (Var_FolioCredito = 2) THEN -- OTRAS REFERENCIAS
								SET Var_Complemento := SUBSTRING(Var_RefAutomatico,20,1);
							END IF;
							IF(Var_FolioCredito = 3)THEN -- CUENTAS
								SET Var_Complemento := SUBSTRING(Var_RefAutomatico,14,1);
							END IF;
							IF(Var_FolioCredito = 1)THEN -- CREDITOS
								SET Var_Complemento := SUBSTRING(Var_RefAutomatico,13,1);
							END IF;

							CALL DIASFESTIVOSCAL(
								Var_FechaSistema,	Var_Vigencia,		Var_FechaVen,		@EsHabil,			Par_EmpresaID,
								Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
								Aud_NumTransaccion);

							CALL REFORDENPAGOSANALT(
								Var_RefAutomatico,		Var_Complemento,		FolioOperac,		RegistroSalida,		Var_FechaSistema,
								Var_FechaVen,			Con_TipoCredito,		Var_Credito,		Con_NO,
								Par_NumErr,				Par_ErrMen,				Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
								Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

							IF(Par_NumErr != Entero_Cero)THEN
								LEAVE CICLODISP;
							END IF;

						END IF;


					END LOOP CICLODISP;
				END;
			CLOSE CURSORDISPMINIS;

		ELSE -- Si permite Dispersiones Multiples
			-- Procedimiento para Realizar Multiples Dispersiones a los Creditos ligados con Cartas de Liquidacion o instrucciones de dipsersion

			SET @idConta := 0;
			DELETE FROM TMPCREDDISPMULTIPLE;
			INSERT INTO TMPCREDDISPMULTIPLE(IDTmp,CreditoID, SucursalID,	TipoDispersion, CuentaCLABE)
			SELECT (@idConta := @idConta +1 ),	Cre.CreditoID, Cre.SucursalID,	Cre.TipoDispersion, Cre.CuentaCLABE
				FROM 	CREDITOS Cre,  BLOQUEOS Blo
				WHERE 	Cre.CreditoID       = Blo.Referencia
				AND 	Cre.FolioDispersion = Entero_Cero
				AND 	Blo.TiposBloqID     = Bloq_DispCred
				AND 	Blo.NatMovimiento   = Mov_Bloqueo
				AND 	IFNULL(Blo.FolioBloq,Entero_Cero)	= Entero_Cero
				AND 	Cre.CuentaID        = Blo.CuentaAhoID
				AND 	FIND_IN_SET(Cre.TipoDispersion,Var_Dispersiones) > Entero_Cero
				AND 	Cre.Estatus 			IN ('V','B'); -- Credito Vigente y Vencidos.

			SET Var_NumReg := (SELECT COUNT(*) FROM TMPCREDDISPMULTIPLE);
			SET Var_NumReg := IFNULL(Var_NumReg, Entero_Cero);
			SET Var_Contador := 0;

			WHILE Var_Contador < Var_NumReg DO
				SET Var_Contador = Var_Contador + 1;

				SELECT 	CreditoID, 		SucursalID,			TipoDispersion
				INTO 	Var_Credito, 	Var_NumSucursal,	Var_TipoDispersion
					FROM TMPCREDDISPMULTIPLE
					WHERE IDTmp = Var_Contador;
				SELECT	Cre.CuentaID,				Cre.MontoCredito,	Cre.SolicitudCreditoID,	Cli.NombreCompleto,
						Cli.RFC,					Cli.RFCpm,			Cli.TipoPersona,		Pro.ForCobroComAper,
						IFNULL(Cre.MontoComApert,Entero_Cero),			IFNULL(Cre.IVAComApertura,Entero_Cero),
						IFNULL(Cre.ForCobroSegVida,Cadena_Vacia),		IFNULL(Cre.MontoSeguroVida,Entero_Cero),
						Cre.ProductoCreditoID
				INTO	Var_CuentaAhoID,			Var_MontoCred,		Var_SoliciCredID,			Var_NomCliente,
						VarRFCcte,					VarRFCPMcte,		VarTipoPerson,				Var_ForComApe,
						Var_MontoComAp,				Var_IVAComAp,		Var_ForCobSeg,				Var_MontoSegVid,
						Var_ProductoCreditoID
				FROM CREDITOS Cre,
						CLIENTES Cli,
						CUENTASAHO Cta,
						PRODUCTOSCREDITO Pro
				WHERE CreditoID 			= Var_Credito
					AND Cre.ClienteID		= Cli.ClienteID
					AND Cta.ClienteID		= Cre.ClienteID
					AND Cta.CuentaAhoID		= Cre.CuentaID
					AND Cre.ProductoCreditoID	= Pro.ProducCreditoID;

				IF (IFNULL(Var_CuentaAhoID,Entero_Cero) > Entero_Cero) THEN
					SELECT DATE_FORMAT(FechaSistema,'%Y-%m-01') INTO FechaSis
						FROM PARAMETROSSIS;
					IF (YEAR(Par_Fecha) <= YEAR(FechaSis))THEN
						IF (MONTH(Par_Fecha) < MONTH(FechaSis))THEN
							SET	Par_NumErr 		:= 3;
							SET	Par_ErrMen		:= 'El Mes no Puede ser Menor al del Sistema';
							SET Var_Control		:= 'fechaActual';
							SET Var_Consecutivo := Entero_Cero;
							LEAVE ManejoErrores;
						END IF;
					END IF;
				END IF;

				/* SE VALIDA SI EXISTE ALGUN MONTO PARAMETRIZADO PARA REALIZAR EL CARGO POR DISPOSICION
					* DEPENDIENDO DEL PRODUCTO DE CREDITO Y LA INSTITUCION CON LA QUE SE HACE LA DISPERSION.*/
				IF(EXISTS(SELECT ProductoCreditoID FROM ESQUEMACARGOSDISP WHERE ProductoCreditoID = Var_ProductoCreditoID
					AND InstitucionID = Var_Institucion))THEN
					/* SI EL TIPO DE DISPERSIÓN ES POR ORDEN DE PAGO SE OBTIENE EL MONTO DEL CARGO,
						* EL CUAL ES RESTADO AL MONTO DEL CRÉDITO. */
					IF(Var_TipoDispersion=TipoDisperOrden)THEN
						SET Var_MontoCargoDisp := (SELECT MontoCargo FROM ESQUEMACARGOSDISP WHERE ProductoCreditoID = Var_ProductoCreditoID
											AND InstitucionID = Var_Institucion LIMIT 1);
						SET Var_MontoCred := (Var_MontoCred - IFNULL(Var_MontoCargoDisp, Entero_Cero));
					END IF;
				END IF;

				/* Si el tipo de cobro de comision por apertura es Por deduccion o Financiamiento
				resta al monto de credito la comision por apertura y su iva*/
				IF((Var_ForComApe = ForComApDeduc) OR (Var_ForComApe = ForComApFinanc))THEN
					SET Var_MontoCred := Var_MontoCred -(Var_MontoComAp + Var_IVAComAp);
				END IF;

				/* Si el tipo de cobro de cobro del seguro de vida es Por deduccion o Financiamiento
				resta al monto de seguro de vida*/
				IF((Var_ForCobSeg = ForCobDeduc) OR (Var_ForCobSeg = ForCobFinanc))THEN
					SET Var_MontoCred := Var_MontoCred - Var_MontoSegVid;
				END IF;

				IF(VarTipoPerson = PerFisica )THEN
					SET VarRFCcte := VarRFCcte;
				END IF;
				IF(VarTipoPerson = PerMoral )THEN
					SET VarRFCcte := VarRFCPMcte;
				END IF;

				SET @idInstruct := 0;
				-- vkl
				DELETE FROM TMPINSTRUCDISPERSION;
				INSERT INTO TMPINSTRUCDISPERSION (	ConsecutivoID,
													CreditoID,
													BenefiDisperID,
													TipoDispersionID,
													TipoCuentaDisper,
													MontoDispersion,
													EstatusDispersion,
													EstatusImportacion,
													FolioOperacion,
													ClaveDispMov)
				SELECT (@idInstruct := @idInstruct +1 ),
						CreditoID,
						BenefiDisperID,
						TipoDispersionID,
						TipoCuentaDisper,
						MontoDispersion,
						EstatusDispersion,
						EstatusImportacion,
						FolioOperacion,
						ClaveDispMov
				FROM CTRINSTRUCCIONESDISP
				Where CreditoID = Var_Credito
				and TipoDispersionID not in('N');

				SET Var_NumInstruct := (SELECT COUNT(*) FROM TMPINSTRUCDISPERSION);
				SET Var_NumInstruct := IFNULL(Var_NumInstruct, Entero_Cero);
				SET Var_Conta := 0;


				IF (Var_NumInstruct > Entero_Cero) THEN
					WHILE Var_Conta < Var_NumInstruct DO

						SET Var_Conta = Var_Conta + 1;
						SELECT	MontoDispersion, BenefiDisperID, TipoDispersionID, TipoCuentaDisper, EstatusImportacion,
								EstatusDispersion,FolioOperacion,	ClaveDispMov
						INTO 	Var_MontoDisp, Var_BenefID, Var_TipoDispersion, Var_TipoCuentaDisper, Var_EstImport,
								Var_EstDisper,	Var_FolioOperacion,	Var_ClaveDispMov
						FROM TMPINSTRUCDISPERSION
						WHERE ConsecutivoID = Var_Conta;
						-- Asegurar que la importacion no venga vacia
						SET Var_EstImport := IFNULL(Var_EstImport, Con_SI);

						IF(Var_TipoDispersion = TipoDisperSPEI) THEN
								SET Var_FormaPago	:=	FormaPagoSPEI;
								SET TipoMovDis		:=	TipoMovDisSPEI;

								Select Ben.Cuenta, Ben.Beneficiario
								INTO Var_CLABEDisp, Var_NombreBen
								From BENEFICDISPERSIONCRE Ben
								INNER JOIN SOLICITUDCREDITO Sol ON Ben.SolicitudCreditoID = Sol.SolicitudCreditoID
								Where Sol.CreditoID = Var_Credito
								And Ben.BenefiDisperID = Var_BenefID;

								SET Var_CLABEDisp := IFNULL(Var_CLABEDisp, Cadena_Vacia);

						END IF;

						IF(Var_TipoDispersion = TipoDisperCheque) THEN
							SET Var_FormaPago	:=	FormaPagoCheque;
							SET TipoMovDis		:=	TipoMovDisCheq;
							SET Var_CLABEDisp	:= '';

							Select Ben.Beneficiario
							INTO  Var_NombreBen
							From BENEFICDISPERSIONCRE Ben
							INNER JOIN SOLICITUDCREDITO Sol ON Ben.SolicitudCreditoID = Sol.SolicitudCreditoID
							Where Sol.CreditoID = Var_Credito
							And Ben.BenefiDisperID = Var_BenefID;

						END IF;

						IF(Var_TipoDispersion = TipoDisperOrden) THEN
							SET Var_FormaPago	:=	FormaPagoOrden;
							SET TipoMovDis		:=	TipoMovDisOrden;

							Select Ben.Cuenta, Ben.Beneficiario
							INTO Var_CLABEDisp, Var_NombreBen
							From BENEFICDISPERSIONCRE Ben
							INNER JOIN SOLICITUDCREDITO Sol ON Ben.SolicitudCreditoID = Sol.SolicitudCreditoID
							Where Sol.CreditoID = Var_Credito
							And Ben.BenefiDisperID = Var_BenefID;
							SET Var_CLABEDisp := IFNULL(Var_CLABEDisp, Cadena_Vacia);

						END IF;

						IF(Var_TipoDispersion = 'T') THEN
							SET Var_FormaPago	:=	FormaPagoSantan;
							SET TipoMovDis		:=	TipoMovDisSantan;

							Select Ben.Cuenta, Ben.Beneficiario
							INTO Var_CLABEDisp, Var_NombreBen
							From BENEFICDISPERSIONCRE Ben
							INNER JOIN SOLICITUDCREDITO Sol ON Ben.SolicitudCreditoID = Sol.SolicitudCreditoID
							Where Sol.CreditoID = Var_Credito
							And Ben.BenefiDisperID = Var_BenefID;

							SET Var_CLABEDisp := IFNULL(Var_CLABEDisp, Cadena_Vacia);
						END IF;

						SET Var_NombreBen := IFNULL(Var_NombreBen, Var_NomCliente);


						IF Var_DispersionSan = Con_SI AND Var_TipoDispersion = TipoDisperOrden AND Var_EsAutomatico = Con_Automatico THEN
							CALL GENERAREFAUTSAN(	Con_Credito,		Var_Credito,		Con_NO,			Par_NumErr,			Par_ErrMen,
													Var_RefAutomatico, 		Par_EmpresaID,	 	Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,
													Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

							IF Var_RefAutomatico != Cadena_Vacia THEN
									SET Var_CLABEDisp := Var_RefAutomatico;
							END IF;
						END IF;

						IF Var_TipoDispersion IN (TipoDisperOrden,'T') THEN
							-- se valida si la dispersion de orden de pago o transferencia esta como pendiente en otro folio
							SET Var_EstatusResSanta := (select EstatusResSanta
							 							from DISPERSIONMOV
							 							where ClaveDispMov = Var_ClaveDispMov
							 							and DispersionID = Var_FolioOperacion
							 							and CreditoID = Var_Credito);

							IF IFNULL(Var_EstatusResSanta,Cadena_Vacia) in ('','50')  THEN
								SET Var_FolioDispExis := Entero_Cero;
							ELSE
								SET Var_FolioDispExis := 1;
							END IF;

						ELSE
							SET Var_FolioDispExis := Entero_Cero;
						END IF;


						-- SI la instruccion no ha sido importado ni dispersado proceder con la importacion
						IF(Var_MontoDisp > Entero_Cero AND Var_EstDisper = Con_NO AND Var_FolioDispExis = Entero_Cero) THEN
							CALL DISPERSIONMOVALT(
								FolioOperac,		Var_CuentaAhoID,	Cadena_Vacia,		CONCAT("INSTRUCCION DISPERSION ", CONVERT(Var_Credito,CHAR)),			CONCAT("CREDITO ",CONVERT(Var_Credito,CHAR)),
								TipoMovDis,			Var_FormaPago,		Var_MontoDisp,		Var_CLABEDisp,			Var_NombreBen,
								Fecha, 				VarRFCcte,			EstatusPendien, 	SalidaNo,				Var_NumSucursal,
								Var_Credito,		Entero_Cero,		Entero_Cero,		Entero_Cero,			Entero_Cero,
								Entero_Cero,		Cadena_Vacia,		Cadena_Vacia,		Par_NumErr,			Par_ErrMen,
								RegistroSalida,		Par_EmpresaID, 		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
								Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

							IF(Par_NumErr != Entero_Cero)THEN
									LEAVE ManejoErrores;
							END IF;

							CALL DISPERSIONMOVACT(
									RegistroSalida,		FolioOperac,		Cadena_Vacia,		Cadena_Vacia,		Var_TipoActConcepto,	ConceptoInstruct,
									SalidaNo,			Par_NumErr,			Par_ErrMen,			Par_Consecutivo,	Par_EmpresaID,			Aud_Usuario,
									Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
							IF (Par_NumErr != Entero_Cero)THEN
								LEAVE ManejoErrores;
							END IF;

							CALL CTRINSTRUCCIONESDISPACT(
								Var_BenefID,			Var_Credito,		FolioOperac,		RegistroSalida,	Var_TipoDispersion,
								Var_TipoCuentaDisper,	Fecha_Vacia,		Aud_FechaActual,	SalidaNo,		SalidaSi,
								Entero_Uno,				SalidaNo,			Par_NumErr,			Par_ErrMen,		Par_EmpresaID,
								Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
								Aud_NumTransaccion);

							UPDATE CREDITOS SET
								FolioDispersion = FolioOperac
							WHERE	CreditoID	= Var_Credito;

							IF(Par_NumErr != Entero_Cero)THEN
								LEAVE ManejoErrores;
							END IF;

							IF Var_DispersionSan = Con_SI AND Var_TipoDispersion = TipoDisperOrden AND Var_EsAutomatico = Con_Automatico THEN
									SET Var_FolioCredito := SUBSTRING(Var_RefAutomatico,1,1);
									IF (Var_FolioCredito = 2) THEN -- OTRAS REFERENCIAS
										SET Var_Complemento := SUBSTRING(Var_RefAutomatico,20,1);
									END IF;
									IF(Var_FolioCredito = 3)THEN -- CUENTAS
										SET Var_Complemento := SUBSTRING(Var_RefAutomatico,14,1);
									END IF;
									IF(Var_FolioCredito = 1)THEN -- CREDITOS
										SET Var_Complemento := SUBSTRING(Var_RefAutomatico,13,1);
									END IF;

									CALL DIASFESTIVOSCAL(
										Var_FechaSistema,	Var_Vigencia,		Var_FechaVen,		@EsHabil,			Par_EmpresaID,
										Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
										Aud_NumTransaccion);

									CALL REFORDENPAGOSANALT(
										Var_RefAutomatico,		Var_Complemento,		FolioOperac,		RegistroSalida,		Var_FechaSistema,
										Var_FechaVen,			Con_TipoCredito,		Var_Credito,		Con_NO,				Par_NumErr,
										Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
										Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);
									IF(Par_NumErr != Entero_Cero)THEN
									LEAVE ManejoErrores;
								END IF;
							END IF;
						END IF;
					END WHILE;
				ELSE
				 -- PROCESO NORMAL
				 	-- DISPERSION CON SALDO PERTENECIENTE AL CLIENTE
					SET Var_SaldoCliente := (SELECT MontoClienteCartas FROM CREDITOS WHERE CreditoID = Var_Credito);
					SET Var_SaldoCliente := IFNULL(Var_SaldoCliente,Entero_Cero);
					IF(Var_SaldoCliente > Entero_Cero)THEN
						IF(Var_TipoDispersion = TipoDisperSPEI) THEN
							SET Var_FormaPago	:=	FormaPagoSPEI;
							SET TipoMovDis		:=	TipoMovDisSPEI;
							SET Descrip			:=	DescripSPEI;
							SELECT 	CuentaCLABE INTO VarCuentaCLABE
								FROM CREDITOS
								WHERE CreditoID = Var_Credito;
							SET VarTipoChequera := '';
						END IF;
						IF(Var_TipoDispersion = TipoDisperCheque) THEN
							SET Var_FormaPago	:=	FormaPagoCheque;
							SET TipoMovDis		:=	TipoMovDisCheq;
							SET Descrip			:=	DescripCheq;
							SET VarCuentaCLABE	:= '';
							SET VarTipoChequera := '';
						END IF;
						IF(Var_TipoDispersion = TipoDisperOrden) THEN
							SET Var_FormaPago	:=	FormaPagoOrden;
							SET TipoMovDis		:=	TipoMovDisOrden;
							SET Descrip			:=	DescripOrdenPago;
							SET VarCuentaCLABE	:= '';
							SET VarTipoChequera := '';
						END IF;

						IF(Var_TipoDispersion = TipoDisperSantan) THEN
							SET Var_FormaPago	:=	FormaPagoSantan;
							SET TipoMovDis		:=	TipoMovDisSantan;
							SET Descrip			:=	DescripRefSantan;
							SELECT 	CASE
										WHEN S.TipoCtaSantander = 'A' THEN S.CtaSantander
										WHEN S.TipoCtaSantander = 'O' THEN S.CtaClabeDisp
										END INTO VarCuentaCLABE
							FROM CREDITOS C
							INNER JOIN SOLICITUDCREDITO S ON C.SolicitudCreditoID = S.SolicitudCreditoID
							WHERE C.CreditoID = Var_Credito;
							SET VarTipoChequera := '';
						END IF;
					-- -----
						IF Var_DispersionSan = Con_SI AND Var_TipoDispersion = TipoDisperOrden AND Var_EsAutomatico = Con_Automatico THEN

							CALL GENERAREFAUTSAN(Con_Credito,		Var_Credito,		Con_NO,			Par_NumErr,			Par_ErrMen,
												Var_RefAutomatico, 		Par_EmpresaID,	 	Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,
												Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

							IF Var_RefAutomatico != Cadena_Vacia THEN
								SET VarCuentaCLABE := Var_RefAutomatico;
							END IF;
						END IF;

						CALL DISPERSIONMOVALT(
							FolioOperac,		Var_CuentaAhoID,    Cadena_Vacia,		Descrip,			CONCAT("CREDITO ",CONVERT(Var_Credito,CHAR)),
							TipoMovDis,			Var_FormaPago,		Var_SaldoCliente,  	VarCuentaCLABE, 	Var_NomCliente,
							Fecha, 				VarRFCcte,			EstatusPendien, 	SalidaNo,			Var_NumSucursal,
							Var_Credito,		Entero_Cero,		Entero_Cero,		Entero_Cero,		Entero_Cero,
							Entero_Cero,		Cadena_Vacia,		VarTipoChequera,	Par_NumErr,			Par_ErrMen,
							RegistroSalida,		Par_EmpresaID, 		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
							Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

						IF(Par_NumErr != Entero_Cero)THEN
							LEAVE ManejoErrores;
						END IF;

						CALL DISPERSIONMOVACT(
							RegistroSalida,   	FolioOperac,   		Cadena_Vacia,    	Cadena_Vacia ,		Var_TipoActConcepto,		ConceptoCliente,
							SalidaNo,          Par_NumErr,         	Par_ErrMen,         Par_Consecutivo,	Par_EmpresaID,
							Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP ,   Aud_ProgramaID,     Aud_Sucursal,
							Aud_NumTransaccion  );

						IF (Par_NumErr != Entero_Cero)THEN
							LEAVE ManejoErrores;
						END IF;

						UPDATE CREDITOS SET
							FolioDispersion = FolioOperac
						WHERE	CreditoID	= Var_Credito;

						IF Var_DispersionSan = Con_SI AND Var_TipoDispersion = TipoDisperOrden AND Var_EsAutomatico = Con_Automatico THEN

							SET Var_FolioCredito := SUBSTRING(Var_RefAutomatico,1,1);
							IF (Var_FolioCredito = 2) THEN -- OTRAS REFERENCIAS
								SET Var_Complemento := SUBSTRING(Var_RefAutomatico,20,1);
							END IF;
							IF(Var_FolioCredito = 3)THEN -- CUENTAS
								SET Var_Complemento := SUBSTRING(Var_RefAutomatico,14,1);
							END IF;
							IF(Var_FolioCredito = 1)THEN -- CREDITOS
								SET Var_Complemento := SUBSTRING(Var_RefAutomatico,13,1);
							END IF;

							CALL DIASFESTIVOSCAL(
							Var_FechaSistema,	Var_Vigencia,		Var_FechaVen,		@EsHabil,			Par_EmpresaID,
							Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
							Aud_NumTransaccion);
							CALL REFORDENPAGOSANALT(
								Var_RefAutomatico,		Var_Complemento,		FolioOperac,		RegistroSalida,		Var_FechaSistema,
								Var_FechaVen,			Con_TipoCredito,		Var_Credito,		Con_NO,				Par_NumErr,
								Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
								Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);
							IF(Par_NumErr != Entero_Cero)THEN
								LEAVE ManejoErrores;
							END IF;
						END IF;
					END IF;
				END IF;
			END WHILE;

			SET Var_NumReg := (SELECT COUNT(*) FROM DISPERSIONMOV WHERE DispersionID = FolioOperac);
			SET Var_NumReg := IFNULL(Var_NumReg, Entero_Cero);

			IF(Var_NumReg = Entero_Cero)THEN
				SET	Par_NumErr 		:= 2;
				SET	Par_ErrMen		:= 'No Hay Creditos para Importar';
	            SET Var_Control		:= 'folioOperacion';
	            SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

		END IF;

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

        SET Par_NumErr		:= 0;
		SET Par_ErrMen 		:= CONCAT('Dispersion agregada: ',CONVERT(FolioOperac,CHAR(10)));
        SET Var_Control		:= 'folioOperacion';
		SET Var_Consecutivo := FolioOperac;

	END ManejoErrores;

	IF (Par_Salida = SalidaSi) THEN
		SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen		AS ErrMen,
				Var_Control		AS control,
				Var_Consecutivo	AS consecutivo;
	END IF;


END TerminaStore$$