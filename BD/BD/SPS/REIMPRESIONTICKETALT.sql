-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REIMPRESIONTICKETALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `REIMPRESIONTICKETALT`;DELIMITER $$

CREATE PROCEDURE `REIMPRESIONTICKETALT`(
/*SP para dar de alta la reimpresion de los tickets de la ventanilla*/
		Par_TransaccionID	 BIGINT,
		Par_TipoOperacion	 INT(11),
		Par_CajaID			 INT(11),
		Par_Sucursal		 INT(11),
		Par_UsuarioID		 INT(11),

		Par_OpcionCajaID	 INT(11),
		Par_Descripcion		 VARCHAR(100),
 		Par_Referencia		 VARCHAR(200),
		Par_MontoOpera		 DECIMAL(14,2),
		Par_Efectivo		 DECIMAL(14,2),

		Par_Cambio			 DECIMAL(14,2),
		Par_NombrePersona	 VARCHAR(200),
 		Par_NombreRecibe	 VARCHAR(100),
		Par_ClienteID		 INT(11),
		Par_ProspectoID		 INT(11),

		Par_EmpleadoID		 INT(11),
		Par_CtaIDRetiro		 BIGINT(12),
		Par_CtaIDDeposito	 BIGINT(12),
		Par_FormaPagoCobro	 CHAR(1),
		Par_CreditoID		 BIGINT(12),

 		Par_Comision		 DECIMAL(14,2),
		Par_IVA				 DECIMAL(14,2),
		Par_GarantAdicional	 DECIMAL(14,2),
		Par_InstitucionID	 INT(11),
		Par_NumCtaInstit	 VARCHAR(20),

		Par_NumCheque		 BIGINT(10),
		Par_PolizaID		 BIGINT(20),
		Par_Telefono		 VARCHAR(20),
		Par_Identificacion	 VARCHAR(100),
		Par_FolioIdentif	 VARCHAR(100),

		Par_FolioPago				 VARCHAR(45),
		Par_MontoServicio			 DECIMAL(14,2),
		Par_IVAServicio 			 DECIMAL(14,2),
		Par_CatalogoServID			 INT(11),
		Par_ChequeSBCID				 INT(11),

        Par_MonedaID				 	INT(11),
		Par_MontoPendPagoAportSocial 	DECIMAL(14,2), -- Monto Pendiente de Pago para la aportacion social
		Par_MontoPagAportSocial 	 	DECIMAL(14,2),	-- Monto Pagado de la aportacion social
		Par_CobraSeguroCuota			CHAR(1),
		Par_MontoSeguroCuota			DECIMAL(12,2),			# Monto del seguro de la cuota que pago el cliente

		Par_IVASeguroCuota			DECIMAL(12,2),			# Monto de IVA del seguro que pago el cliente
	 	Par_ArrendaID		 		BIGINT(12),				-- Número de arrendamiento
        Par_AccesorioID 			INT(11), 			# Indica Identificador de Accesorios

		Par_Salida			 CHAR(1),
INOUT	Par_NumErr   		 INT(11),
INOUT 	Par_ErrMen   		 VARCHAR(400),

		Par_EmpresaID		 INT(11),				-- Id de la empresa
		Aud_Usuario			 INT(11),				-- Usuario
		Aud_FechaActual		 DATETIME,     			-- Fecha actual
		Aud_DireccionIP		 VARCHAR(15),			-- Dirección IP
		Aud_ProgramaID		 VARCHAR(50),			-- Id del programa
		Aud_Sucursal		 INT(11),				-- Número de sucursal
		Aud_NumTransaccion	 BIGINT(20)				-- Número de transacción

			)
TerminaStore:BEGIN

-- Declaracion de Constantes
DECLARE Entero_Cero		INT;
DECLARE Decimal_Cero 	DECIMAL(2,1);
DECLARE Cadena_Vacia	CHAR(1);
DECLARE SalidaSI		CHAR(1);
DECLARE SalidaNO		CHAR(1);
DECLARE Fecha_Vacia		DATE;
DECLARE GrupalSI		CHAR(1);
DECLARE Con_PagoCredito	INT;
DECLARE Con_PrepagoCred	INT;
DECLARE Con_CarteraCast	INT;
DECLARE SI_AplicaIVA	CHAR(1);
DECLARE Con_Servifun	INT;
DECLARE Con_ApoyoEsc	INT;
DECLARE Con_CancelSoc	INT;
DECLARE Con_GastosAnt	INT;
DECLARE Con_ComisApert	INT;
DECLARE Con_HaberesMen  INT;
DECLARE Con_DesemCredit	INT;
DECLARE Con_GaranLiqAd	INT;
DECLARE Con_AnualidadTa INT;
DECLARE Con_PagoServic	INT;
DECLARE Con_GastosAntDe	INT;
DECLARE Con_RetiroEfec	INT;
DECLARE Con_Abonocta	INT;
DECLARE Con_PagoArrenda INT;

DECLARE EstatusPagado	CHAR(1);
DECLARE EstatusVencido	CHAR(1);
DECLARE EstatusVigente 	CHAR(1);
DECLARE	OutTotalAde 	VARCHAR(20);
DECLARE	OutMontoPag 	VARCHAR(20);
DECLARE	OutProxFecPag 	VARCHAR(20);
DECLARE Var_CapVigIns	VARCHAR(20);
-- Declaracion de Variables
DECLARE Var_Control			VARCHAR(200);
DECLARE Fecha_Sis			DATE;
DECLARE Var_Hora			TIME;
DECLARE Var_SucCliente		INT;
DECLARE Var_TipoCtaCliente	INT;
DECLARE Var_DescripCta		VARCHAR(100);
DECLARE Var_SaldoDispo		DECIMAL(14,2);
DECLARE Var_GrupoID			INT;
DECLARE	Var_NombreCompleto 	CHAR(250);
DECLARE Var_ProductCredito	INT(11);
DECLARE Var_ProductArrenda  INT(11);
DECLARE Var_DescProdArrenda CHAR(250);
DECLARE Var_MonedaID		INT(11);
DECLARE Var_TotCastigo		DECIMAL(14,2);
DECLARE Var_Recuperado		DECIMAL(14,2);
DECLARE Var_PorRecuperar	DECIMAL(14,2);
DECLARE Var_NombreInstit	VARCHAR(100);
DECLARE Var_NombreServ		VARCHAR(100);
DECLARE Var_Identifica		VARCHAR(100);
DECLARE Var_OrigenServ		CHAR(1);
DECLARE Var_AplicaIVA		CHAR(1);
DECLARE Var_TasaIVA			DECIMAL(14,2);
DECLARE Var_TipoServicio	CHAR(1);
DECLARE Var_NombreBene		VARCHAR(100);
DECLARE Var_NombreEmpleado	VARCHAR(100);
DECLARE Var_NombreOperacion	VARCHAR(200);
DECLARE Var_EtiquetaRet		VARCHAR(60);
DECLARE Var_EtiquetaDep		VARCHAR(60);
DECLARE Var_DescripCtaD		VARCHAR(100);
DECLARE Var_DescProdCred	VARCHAR(100);
DECLARE Var_NombreGrupo		VARCHAR(100);
DECLARE Var_Consecutivo		INT;
DECLARE Var_FechaCastigo	DATE;			-- Fecha de Castigo para el ticket de Recuperacion de CArtera Castigada
DECLARE Var_CredDetalle		BIGINT(12);			-- Numero de CreditoID de DETALLEPAGCRED
DECLARE Var_ArrendaDetalle	BIGINT(12);			-- Numero de ArrendaID de DETALLEPAGARRENDA

-- Variables pago de credito
DECLARE Var_MontoTotal		VARCHAR(20);
DECLARE Var_Capital			VARCHAR(20);
DECLARE Var_Interes			VARCHAR(20);
DECLARE Var_MontoIntMora	VARCHAR(20);
DECLARE Var_MontoIVA		VARCHAR(20);
DECLARE Var_MontoComision	VARCHAR(20);
DECLARE Var_MontoGastoAdmon	VARCHAR(20);
DECLARE Var_TotalPago		VARCHAR(20);
DECLARE Var_TotalAdeudo		VARCHAR(20);
DECLARE Var_MontoPag		VARCHAR(20);
DECLARE	Var_ProxFechaPag	VARCHAR(20);
DECLARE Var_ProxFecha		DATE;
DECLARE Var_FechaVencim     DATE;
DECLARE Var_TotalDeuda		DECIMAL(14,2);
DECLARE Var_CicloGrupo		INT;
DECLARE	Var_CicloActual		INT;
DECLARE diasFaltaPago   	INT(11);
DECLARE Var_MontoCred		DECIMAL(14,2);
DECLARE Var_MontoPorDes		DECIMAL(14,2);
DECLARE Var_MontoDesem		DECIMAL(14,2);
DECLARE Var_IvaSucursal		DECIMAL(12,2);

-- Asignacion de Constantes
SET Entero_Cero     := 0;                   -- Entero Cero
SET Decimal_Cero    := 0.0;                 -- Decimal Cero
SET Cadena_Vacia    := '';                  -- Cadena o String Vacio
SET SalidaSI        := 'S';                 -- Salida del Store: SI
SET SalidaNO        := 'N';                 -- Salida del Store: NO
SET Fecha_Vacia     := '1900-01-01';        -- Fecha Vacia
SET GrupalSI		:= 'S';					-- Si Credito grupal
SET Con_PagoCredito := 8;					-- Pago de Credito CAJATIPOSOPERA
SET Con_PrepagoCred := 78;					-- Prepago de Credito CAJATIPOSOPERA
SET Con_CarteraCast	:= 87;					-- Recuperacion de cartera CAstigada CAJATIPOSOPERA
SET Con_Servifun	:= 91;					-- Pago de Servifun
SET Con_ApoyoEsc	:= 95;					-- Pago de Apoyo Escolatr
SET Con_CancelSoc	:= 116;					-- Pago CancelaciÃ³n de Socio
SET Con_GastosAnt	:= 123;					-- Gastos y Anticipos
SET Con_ComisApert	:= 23;					-- Cobro ComisiÃ³n por Apertura
SET Con_HaberesMen	:= 125;					-- PAgo de haberes de Socio Menor
SET Con_DesemCredit	:= 10;					-- Desembolso de Credito
SET Con_GaranLiqAd	:= 43;					-- Deposito de GL
SET Con_AnualidadTa := 114;					-- Anualidad de Tarjeta de Credito
SET Con_PagoServic	:= 80;					-- Pago de Servicios
SET Con_GastosAntDe	:= 119;					-- DevoluciÃ³n de Gastos y anticipos
SET Con_RetiroEfec	:=11;					-- Retiro de efectivo
SET Con_Abonocta	:=1;					-- Abono a cuenta
SET Con_PagoArrenda := 127;					-- Pago de Arrendamiento CAJATIPOSOPERA
SET SI_AplicaIVA	:= 'S';					-- SI aplica IVA
SET EstatusPagado   := 'P';     			-- Estatus Pagado
SET EstatusVencido	:= 'B';					-- Estatus Vencido
SET EstatusVigente	:= 'V';					-- Estatus vigente
-- Asignacion de Variables
SET Var_Control 		:= '';
SET Fecha_Sis			:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
SET Var_Hora			:= (SELECT CURRENT_TIME());
SET Var_NombreCompleto 	:= '';
SET Var_NombreBene		:= '';
SET Var_NombreEmpleado	:= '';
SET Var_NombreOperacion	:= '';

ManejoErrores: BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
					SET Par_NumErr := 999;
					SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
											'esto le ocasiona. Ref: SP-REIMPRESIONTICKETALT');
					SET Var_Control := 'sqlException' ;
	END;

	SET Par_TransaccionID := IFNULL(Par_TransaccionID,Entero_Cero);
	IF(Par_TransaccionID=Entero_Cero) THEN
		SET Par_NumErr  := 001;
		SET Par_ErrMen  := 'Se Requiere el numero de Transaccion';
		SET Var_Control := 'TransaccionID';
		LEAVE ManejoErrores;
	END IF;

	SET Par_TipoOperacion := IFNULL(Par_TipoOperacion,Entero_Cero);
	IF(Par_TipoOperacion= Entero_Cero) THEN
		SET Par_NumErr := 002;
		SET Par_ErrMen	:= 'Se Requiere el Tipo de Operacion';
		SET Var_Control	:= 'TipoOpera';
		LEAVE ManejoErrores;
	END IF;

	SET Par_CajaID := IFNULL(Par_CajaID, Entero_Cero);
	IF(Par_CajaID=Entero_Cero)THEN
		SET Par_NumErr := 003;
		SET Par_ErrMen	:= 'Se Requiere el Numero de Caja';
		SET Var_Control	:= 'TipoOpera';
		LEAVE ManejoErrores;
	END IF;

	SET Par_Sucursal := IFNULL(Par_Sucursal,Entero_Cero);
	IF(Par_Sucursal = Entero_Cero) THEN
		SET Par_NumErr := 004;
		SET Par_ErrMen:= 'Se Requiere el Numero de Sucursal';
		SET Var_Control := 'SucursalID';
		LEAVE ManejoErrores;
	END IF;

	SET Par_UsuarioID	:= IFNULL(Par_UsuarioID,Entero_Cero);
	IF(Par_UsuarioID = Entero_Cero) THEN
		SET Par_NumErr:=005;
		SET Par_ErrMen:='Se Requiere el Usuario';
		SET Var_Control := 'UsuarioID';
		LEAVE ManejoErrores;
	END IF;


	IF(Par_TipoOperacion = Con_CancelSoc) THEN
		SET Par_ClienteID := IFNULL(Par_Referencia,Entero_Cero);
		SET Var_NombreBene	:= Par_NombreRecibe;
	END IF;

	-- Datos del cliente y de la cuenta de ahorro
	IF(Par_ClienteID>Entero_Cero) THEN
		SELECT SucursalOrigen, NombreCompleto INTO Var_SucCliente,Var_NombreCompleto FROM CLIENTES WHERE ClienteID=Par_ClienteID;
	ELSE
		SET Var_NombreCompleto := IFNULL(Par_NombrePersona,Cadena_Vacia);
	END IF;

	IF(Par_EmpleadoID>Entero_Cero) THEN
		SELECT NombreCompleto INTO Var_NombreEmpleado
				FROM EMPLEADOS WHERE EmpleadoID = Par_EmpleadoID;
		IF(Par_TipoOperacion = Con_GastosAnt OR Par_TipoOperacion = Con_GastosAntDe) THEN
				SET Var_NombreCompleto := Var_NombreEmpleado;
		END IF;
	END IF;

	IF(Par_TipoOperacion = Con_ApoyoEsc) THEN
		SET Var_NombreBene := IFNULL(Par_NombrePersona,Cadena_Vacia);

	ELSEIF(Par_TipoOperacion = Con_GastosAnt OR Par_TipoOperacion = Con_GastosAntDe) THEN
		SELECT Descripcion INTO Var_NombreOperacion
						FROM TIPOSANTGASTOS WHERE TipoAntGastoID = Par_Referencia;
		SET Par_Referencia := Var_NombreOperacion;

	ELSEIF(Par_TipoOperacion = Con_ComisApert )THEN
	SELECT IVA INTO Var_IvaSucursal
		FROM SUCURSALES WHERE SucursalID =Aud_Sucursal;

		SET Var_MontoComision := ROUND(Par_MontoOpera/(1 + Var_IvaSucursal),2);
		SET Var_MontoIVA	  := ROUND((((Par_MontoOpera/(1 + Var_IvaSucursal ))*Var_IvaSucursal)*100)/100,2);

	ELSEIF(Par_TipoOperacion = Con_HaberesMen) THEN
	-- Algoritmo de consulta de CANCSOCMENORCTACON que utiliza para encontrar la cta de un cliente
		SELECT  Cue.CuentaAhoID
			INTO Par_CtaIDRetiro
			FROM CANCSOCMENORCTA Cta
			INNER JOIN CUENTASAHO Cue ON Cue.CuentaAhoID=Cta.CuentaAhoID AND EsPrincipal="S"
			WHERE Cta.ClienteID=Par_ClienteID;

		SET Par_CtaIDRetiro:= IFNULL(Par_CtaIDRetiro,Entero_Cero);

		IF Par_CtaIDRetiro=Entero_Cero THEN
			SELECT  Cue.CuentaAhoID
				INTO Par_CtaIDRetiro
				FROM CANCSOCMENORCTA Cta
				INNER JOIN CUENTASAHO Cue ON Cue.CuentaAhoID = Cta.CuentaAhoID
				WHERE Cta.ClienteID=Par_ClienteID LIMIT 1;
		END IF;
	END IF;

	SET Par_CtaIDRetiro := IFNULL(Par_CtaIDRetiro,Entero_Cero);
	IF(Par_CtaIDRetiro <> Entero_Cero AND Par_TipoOperacion<>Con_AnualidadTa) THEN
		IF EXISTS (SELECT CuentaAhoID FROM CUENTASAHO WHERE CuentaAhoID = Par_CtaIDRetiro) THEN
				SELECT TC.Descripcion, CA.SaldoDispon, CA.Etiqueta
						INTO Var_DescripCta, Var_SaldoDispo, Var_EtiquetaRet
							FROM CUENTASAHO CA INNER JOIN TIPOSCUENTAS TC ON CA.TipoCuentaID = TC.TipoCuentaID
							WHERE CuentaAhoID = Par_CtaIDRetiro
							AND ClienteID=Par_ClienteID;
		ELSE
				SET Par_NumErr:=006;
				SET Par_ErrMen:='La Cuenta de Ahorro No Existe';
				SET Var_Control := 'CuentaAhoID';
				LEAVE ManejoErrores;
		END IF;
	END IF;

	SET Par_CtaIDDeposito := IFNULL(Par_CtaIDDeposito, Entero_Cero);
	IF(Par_CtaIDDeposito <> Entero_Cero) THEN
		SELECT CA.Etiqueta, TC.Descripcion INTO Var_EtiquetaDep, Var_DescripCtaD
			FROM CUENTASAHO CA
				INNER JOIN CLIENTES CL ON CA.ClienteID = CL.ClienteID
				INNER JOIN TIPOSCUENTAS TC ON CA.TipoCuentaID = TC.TipoCuentaID
				WHERE CuentaAhoID=Par_CtaIDDeposito;
	END IF;

	-- Seccion solo cuando haya un CREDITO de por medio
	SET Par_CreditoID := IFNULL(Par_CreditoID,Entero_Cero);

	IF(Par_CreditoID > Entero_Cero) THEN
		SELECT CRED.GrupoID, CRED.ProductoCreditoID,CRED.MonedaID, CRED.CicloGrupo, PC.Descripcion
					INTO Var_GrupoID, Var_ProductCredito, Var_MonedaID, Var_CicloGrupo, Var_DescProdCred
							FROM CREDITOS CRED INNER JOIN PRODUCTOSCREDITO PC ON CRED.ProductoCreditoID= PC.ProducCreditoID
							WHERE CRED.CreditoID = Par_CreditoID;
		IF(Var_GrupoID > Entero_Cero) THEN
				SELECT GC.NombreGrupo INTO Var_NombreGrupo
									FROM CREDITOS CRED
									INNER JOIN GRUPOSCREDITO GC ON CRED.GrupoID =GC.GrupoID
									WHERE CRED.CreditoID = Par_CreditoID;
		END IF;

		SET Var_GrupoID := IFNULL(Var_GrupoID,Entero_Cero);
		SET Var_CicloGrupo := IFNULL(Var_CicloGrupo, Entero_Cero);


		IF(Par_TipoOperacion = Con_CarteraCast) THEN

			SELECT IVARecuperacion INTO Var_AplicaIVA
				FROM PARAMSRESERVCASTIG;

			SET	Var_AplicaIVA	:= IFNULL(Var_AplicaIVA, SI_AplicaIVA);

			IF(Var_AplicaIVA = SI_AplicaIVA) THEN
				SELECT Suc.IVA INTO Var_TasaIVA
					FROM CREDITOS Cre,
						SUCURSALES Suc
					WHERE CreditoID = Par_CreditoID
					AND Cre.SucursalID = Suc.SucursalID;
			END IF;

			SET	Var_TasaIVA 	:= IFNULL(Var_TasaIVA, Entero_Cero);

			SELECT
				ROUND(TotalCastigo * (1 + Var_TasaIVA),2) ,
				ROUND(MonRecuperado,2) ,
				ROUND((SaldoCapital + SaldoInteres + SaldoMoratorio + SaldoAccesorios) * (1+Var_TasaIVA), 2),
				Fecha
				INTO Var_TotCastigo, Var_Recuperado, Var_PorRecuperar, Var_FechaCastigo
			FROM CRECASTIGOS
				WHERE CreditoID = Par_CreditoID;

		ELSEIF(Par_TipoOperacion = Con_DesemCredit) THEN

			SELECT 	Cre.MontoCredito,Cre.MontoPorDesemb, Cre.MontoDesemb
					INTO Var_MontoCred, Var_MontoPorDes, Var_MontoDesem
					FROM CREDITOS Cre,
				PRODUCTOSCREDITO Pro
				WHERE Pro.ProducCreditoID = Cre.ProductoCreditoID
				AND Cre. CreditoID = Par_CreditoID;

			SELECT CA.Saldo INTO  Var_SaldoDispo
					FROM CUENTASAHO CA
					WHERE CuentaAhoID = Par_CtaIDRetiro ;
		END IF;
	END IF;

	IF(Par_InstitucionID > Entero_Cero) THEN
		SELECT CONCAT(Nombre,' (',NombreCorto,')')  INTO Var_NombreInstit FROM INSTITUCIONES WHERE InstitucionID=Par_InstitucionID;
	END IF;

	IF(Par_CatalogoServID > Entero_Cero) THEN
		SELECT NombreServicio,Origen INTO Var_NombreServ, Var_OrigenServ FROM CATALOGOSERV WHERE CatalogoServID = Par_CatalogoServID;
	END IF;

	IF(Par_Identificacion > Entero_Cero) THEN
		SELECT Nombre	INTO Var_Identifica FROM TIPOSIDENTI
							WHERE TipoIdentiID =  Par_Identificacion;
	END IF;

	IF(Par_ChequeSBCID > Entero_Cero) THEN
		SELECT BancoEmisor, CuentaEmisor INTO Par_InstitucionID, Par_NumCtaInstit
							FROM ABONOCHEQUESBC WHERE ChequeSBCID =	Par_ChequeSBCID;
		SELECT CONCAT(Nombre,' (',NombreCorto,')')  INTO Var_NombreInstit FROM INSTITUCIONES WHERE InstitucionID=Par_InstitucionID;
	END IF;

	IF(Par_TipoOperacion = Con_Servifun) THEN

		SELECT TipoServicio INTO Var_TipoServicio
						FROM SERVIFUNFOLIOS WHERE ServiFunFolioID = Par_Referencia;

	ELSEIF(Par_TipoOperacion =  Con_PagoServic) THEN

		SET Var_MontoIVA := Par_IVA;
		IF(Par_ClienteID <= Entero_Cero) THEN
			SET Var_NombreCompleto := Var_NombreServ;
		END IF;
	ELSEIF(Par_TipoOperacion IN (Con_RetiroEfec,Con_Abonocta ) )THEN
		SELECT CA.Saldo INTO  Var_SaldoDispo
					FROM CUENTASAHO CA
					WHERE CuentaAhoID = Par_CtaIDRetiro ;


	END IF;

	-- Se consulta e inserta simultaneamente debido a que puede ser un credito o prepago grupal
	IF (Par_TipoOperacion = Con_PagoCredito OR Par_TipoOperacion = Con_PrepagoCred )THEN
	SELECT ROUND(IFNULL(SUM(ROUND(SaldoCapVigente,2) + ROUND(SaldoCapAtrasa,2) +
								ROUND(SaldoCapVencido,2) + ROUND(SaldoCapVenNExi,2)
							), Entero_Cero),2)
					INTO  Var_SaldoDispo
					FROM AMORTICREDITO
					WHERE CreditoID     =  Par_CreditoID
					AND Estatus       <> EstatusPagado;

		SET	@Var_Consecutivo :=(SELECT IFNULL(MAX(ReimpresionID),Entero_Cero)+1
							FROM REIMPRESIONTICKET
							WHERE TransaccionID = Par_TransaccionID );

		-- Hay registros en detallepagcre
		SET Var_CredDetalle = (SELECT	DT.CreditoID
								FROM
									CLIENTES CL
									LEFT OUTER JOIN  DETALLEPAGCRE DT	ON CL.ClienteID=DT.ClienteID AND DT.Transaccion = Par_TransaccionID AND	DT.FechaPago = Fecha_Sis
									INNER JOIN CREDITOS CRED ON DT.CreditoID=CRED.CreditoID
									LEFT JOIN GRUPOSCREDITO GC ON GC.GrupoID=CRED.GrupoID
									INNER JOIN CUENTASAHO CA ON CA.ClienteID= CRED.ClienteID AND CA.CuentaAhoID=CRED.CuentaID
								WHERE DT.Transaccion =	Par_TransaccionID
								AND CL.ClienteID=Par_ClienteID
									GROUP BY DT.CreditoID);
		# SEGUROS
		SET Par_CobraSeguroCuota :=IFNULL(Par_CobraSeguroCuota, 'N'); # No cobra seguro por cuota
		SET Par_MontoSeguroCuota :=IFNULL(Par_MontoSeguroCuota,Entero_Cero);
		SET Par_IVASeguroCuota := IFNULL(Par_IVASeguroCuota, Entero_Cero);
		# FIN SEGUROS

		IF(IFNULL(Var_CredDetalle,Entero_Cero)>Entero_Cero) THEN
			INSERT INTO REIMPRESIONTICKET(
				ReimpresionID,		TransaccionID, 		TipoOperacionID,	SucursalID,			CajaID,
				UsuarioID,			Fecha,				Hora,				OpcionCajaID,		Descripcion,
				MontoOperacion,		Efectivo,			Cambio,				NombrePersona,		ClienteID,
				ProspectoID,		EmpleadoID,			CuentaIDRetiro,		EtiquetaCtaRetiro,	DesTipoCuenta,
				SaldoActualCta,		Referencia,			FormaPagoCobro,		CreditoID,			ProducCreditoID,
				NombreProdCred,		GrupoID,			NombreGrupo,		CicloActual,		TotalAdeudo,
				Capital,			Interes,			Moratorios,			Comision,			ComisionAdmon,
				IVA,				GarantiaAdicional,	InstitucionID,		NumCtaInstit,		NumCheque,
				NombreInstit,		PolizaID,			EmpresaID,			Usuario,			FechaActual,
				DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion,		MonedaIDOperacion,
				CobraSeguroCuota,	MontoSeguroCuota,	IVASeguroCuota
			)SELECT
				(SELECT  (@Var_Consecutivo:= @Var_Consecutivo+1) ),
				Par_TransaccionID,	Par_TipoOperacion,	Par_Sucursal,		Par_CajaID,			Par_UsuarioID,
				Fecha_Sis,			Var_Hora,			Par_OpcionCajaID,	Par_Descripcion,	Par_MontoOpera,
				Par_Efectivo,		Par_Cambio,			CL.NombreCompleto,	CL.ClienteID,		Par_ProspectoID,
				Par_EmpleadoID,		CA.CuentaAhoID,		CA.Etiqueta,		Var_DescripCta,		Var_SaldoDispo,
				Par_Referencia,		Par_FormaPagoCobro,	DT.CreditoID,		Var_ProductCredito,	Var_DescProdCred,
				GC.GrupoID,			GC.NombreGrupo,		CRED.CicloGrupo,	Var_TotalAdeudo,
				FORMAT(SUM(IFNULL(
						(DT.MontoCapOrd + DT.MontoCapAtr + DT.MontoCapVen),Entero_Cero)),2),
				FORMAT(SUM(ROUND(IFNULL(
						(DT.MontoIntOrd + DT.MontoIntAtr + DT.MontoIntVen),Entero_Cero),2)),2),
				FORMAT(SUM(IFNULL((DT.MontoIntMora),Entero_Cero)),2),
				FORMAT(SUM(IFNULL((DT.MontoComision),Entero_Cero)),2) ,
				FORMAT(SUM(IFNULL((DT.MontoGastoAdmon),Entero_Cero)),2) ,
				FORMAT(SUM(IFNULL((DT.MontoIVA),Entero_Cero)),2),
				Par_GarantAdicional,Par_InstitucionID,  Par_NumCtaInstit,   Par_NumCheque,      Var_NombreInstit,
				Par_PolizaID,       Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
				Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion, Par_MonedaID,
				Par_CobraSeguroCuota,
				FORMAT(SUM(IFNULL((DT.MontoSeguroCuota),Entero_Cero)),2),
				FORMAT(SUM(IFNULL((DT.MontoIVASeguroCuota),Entero_Cero)),2)
				FROM     CLIENTES CL
				LEFT OUTER JOIN  DETALLEPAGCRE DT	ON CL.ClienteID=DT.ClienteID
													AND DT.Transaccion = Par_TransaccionID
													AND	DT.FechaPago = Fecha_Sis
				INNER JOIN CREDITOS CRED ON DT.CreditoID=CRED.CreditoID
				LEFT JOIN GRUPOSCREDITO GC ON GC.GrupoID=CRED.GrupoID
				INNER JOIN CUENTASAHO CA ON CA.ClienteID= CRED.ClienteID
											AND CA.CuentaAhoID=CRED.CuentaID
													WHERE DT.Transaccion =	Par_TransaccionID
													AND CL.ClienteID=Par_ClienteID
														GROUP BY DT.CreditoID,  DT.Transaccion,	CL.NombreCompleto,	CL.ClienteID,		CA.CuentaAhoID,
																 CA.Etiqueta,	GC.GrupoID,		GC.NombreGrupo,		CRED.CicloGrupo;
			ELSE
				INSERT INTO REIMPRESIONTICKET (
				`ReimpresionID`,	`TransaccionID`,	`TipoOperacionID`,		`SucursalID`,		CajaID,
				`UsuarioID`,		`Fecha`,			`Hora`,					`OpcionCajaID`,		`Descripcion`,
				`MontoOperacion`,	`Efectivo`,			`Cambio`,`NombrePersona`,`NombreBeneficiario`,
				`ClienteID`,		`ProspectoID`,		`EmpleadoID`,			`NombreEmpleado`,	`CuentaIDRetiro`,
				`CuentaIDDeposito`,	`EtiquetaCtaRetiro`,`EtiquetaCtaDepo`,		`DesTipoCuenta`,	`DesTipoCtaDepo`,

				SaldoActualCta,		`Referencia`,		`FormaPagoCobro`,		`CreditoID`,		`ProducCreditoID`,
				`NombreProdCred`,	`MontoCredito`,		`MontoPorDesem`,		`MontoDesemb`,		`GrupoID`,
				`NombreGrupo`,		`CicloActual`,		`MontoProximoPago`,		`FechaProximoPago`,	`TotalAdeudo`,
				`Capital`,			`Interes`,			`Moratorios`,			`Comision`,			`ComisionAdmon`,
				`IVA`,				`GarantiaAdicional`,`InstitucionID`,		`NumCtaInstit`,		`NumCheque`,

				`NombreInstit`,		`PolizaID`,			`Telefono`,				`Identificacion`,	`FolioIdentificacion`,
					`FolioPago`,		`CatalogoServID`,	`NombreCatalServ`,		`MontoServicio`,	`IVAServicio`,
				`OrigenServicio`,	`MontoComision`,	`TotalCastigado`,		`TotalRecuperado`,	`Monto_PorRecuperar`,
				FechaCastigo, `TipoServServifun`,	`EmpresaID`,		`Usuario`,				`FechaActual`,		`DireccionIP`,
				`ProgramaID`,		`Sucursal`,			`NumTransaccion`, 		MonedaIDOperacion, MontoPendPagoAportSocial,
				MontoPagAportSocial,CobraSeguroCuota,	MontoSeguroCuota,	IVASeguroCuota)
			VALUES(
				(SELECT  (@Var_Consecutivo:= @Var_Consecutivo+1) ),	Par_TransaccionID,	Par_TipoOperacion,		Par_Sucursal,		Par_CajaID,
				Par_UsuarioID,		Fecha_Sis,			Var_Hora,				Par_OpcionCajaID,	Par_Descripcion,
				Par_MontoOpera,		Par_Efectivo,		Par_Cambio,				Var_NombreCompleto,	Var_NombreBene,
				Par_ClienteID,		Par_ProspectoID,	Par_EmpleadoID,			Var_NombreEmpleado,	Par_CtaIDRetiro,
				Par_CtaIDDeposito,	Var_EtiquetaRet,	Var_EtiquetaDep,		Var_DescripCta,		Var_DescripCtaD,

				Var_SaldoDispo,		Par_Referencia,		Par_FormaPagoCobro,		Par_CreditoID,		Var_ProductCredito,
				Var_DescProdCred,	Var_MontoCred, 		Var_MontoPorDes,		Var_MontoDesem,		Var_GrupoID,
				Var_NombreGrupo,	Var_CicloGrupo,		Var_MontoPag,			Var_ProxFechaPag,	Var_TotalAdeudo,
				Var_Capital,		Var_Interes,		Var_MontoIntMora,		Var_MontoComision,	Var_MontoGastoAdmon,
				Var_MontoIVA,		Par_GarantAdicional,Par_InstitucionID,		Par_NumCtaInstit,	Par_NumCheque,

				Var_NombreInstit,	Par_PolizaID,		Par_Telefono,			Var_Identifica,		Par_FolioIdentif,
				Par_FolioPago,		Par_CatalogoServID,	Var_NombreServ,			Par_MontoServicio,	Par_IVAServicio,
				Var_OrigenServ,		Par_Comision,		Var_TotCastigo,			Var_Recuperado,		Var_PorRecuperar,
				Var_FechaCastigo,	Var_TipoServicio,	Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion,		Par_MonedaID,Par_MontoPendPagoAportSocial,
				Par_MontoPagAportSocial, Par_CobraSeguroCuota, Par_MontoSeguroCuota, Par_IVASeguroCuota
		);
		END IF;

	-- Reimpresión 	Pago de Arrendamiento. Cardinal Sistemas Inteligentes
	ELSEIF(Par_TipoOperacion = Con_PagoArrenda) THEN
		SELECT ROUND(IFNULL(SUM(ROUND(SaldoInteresVigente,2) + ROUND(SaldoInteresAtras,2) +ROUND(SaldoInteresVen,2)), Entero_Cero),2)
			INTO  Var_SaldoDispo
			FROM ARRENDAAMORTI
			WHERE ArrendaID     =  Par_ArrendaID
			AND Estatus       <> EstatusPagado;

		SET	@Var_Consecutivo :=(SELECT IFNULL(MAX(ReimpresionID),Entero_Cero)+1
							FROM REIMPRESIONTICKET
							WHERE TransaccionID = Par_TransaccionID );

		SET Par_FormaPagoCobro :=IFNULL(Par_FormaPagoCobro, Cadena_Vacia);

		SELECT arrenda.ProductoArrendaID,	prod.NombreCorto
			INTO	Var_ProductArrenda,			Var_DescProdArrenda
			FROM	ARRENDAMIENTOS arrenda
			INNER JOIN	PRODUCTOARRENDA prod	ON	arrenda.ProductoArrendaID = prod.ProductoArrendaID
			WHERE arrenda.ArrendaID	= Par_ArrendaID;

		SET	Par_ProspectoID					:= IFNULL(Par_ProspectoID, Entero_Cero);
		SET	Par_CtaIDRetiro					:= IFNULL(Par_CtaIDRetiro,Entero_Cero);
		SET	Par_CtaIDDeposito				:= IFNULL(Par_CtaIDDeposito, Entero_Cero);
		SET	Par_Referencia					:= IFNULL(Par_Referencia,Cadena_Vacia);
		SET	Par_GarantAdicional				:= IFNULL(Par_GarantAdicional,Decimal_Cero);
		SET	Par_NumCtaInstit				:= IFNULL(Par_NumCtaInstit,Entero_Cero);
		SET	Par_NumCheque					:= IFNULL(Par_NumCheque,Cadena_Vacia);
		SET	Par_MontoServicio				:= IFNULL(Par_MontoServicio,Decimal_Cero);
		SET	Par_IVAServicio					:= IFNULL(Par_IVAServicio,Decimal_Cero);
		SET	Par_Comision					:= IFNULL(Par_Comision,Decimal_Cero);
		SET	Par_MontoPendPagoAportSocial	:= IFNULL(Par_MontoPendPagoAportSocial,Decimal_Cero);
		SET	Par_MontoPagAportSocial			:= IFNULL(Par_MontoPagAportSocial,Decimal_Cero);
		SET	Par_CobraSeguroCuota			:= IFNULL(Par_CobraSeguroCuota,Cadena_Vacia);
		SET	Par_MontoSeguroCuota			:= IFNULL(Par_MontoSeguroCuota,Decimal_Cero);
		SET	Par_IVASeguroCuota				:= IFNULL(Par_IVASeguroCuota,Decimal_Cero);
		SET	Par_Telefono					:= IFNULL(Par_Telefono,Cadena_Vacia);
		SET	Par_Identificacion				:= IFNULL(Par_Identificacion,Cadena_Vacia);
		SET	Par_FolioIdentif				:= IFNULL(Par_FolioIdentif,Cadena_Vacia);
		SET	Par_FolioPago					:= IFNULL(Par_FolioPago,Cadena_Vacia);
		SET	Par_CatalogoServID				:= IFNULL(Par_CatalogoServID,Entero_Cero);

		SELECT NombreCompleto INTO Var_NombreEmpleado
					FROM USUARIOS WHERE UsuarioID = Par_EmpleadoID;


		INSERT INTO REIMPRESIONTICKET(
				ReimpresionID,
				TransaccionID,	 		TipoOperacionID,	SucursalID,			CajaID,						UsuarioID,
				Fecha,					Hora,				OpcionCajaID,		Descripcion,				MontoOperacion,
				Efectivo,				Cambio,				NombrePersona,		NombreBeneficiario,			ClienteID,
				ProspectoID,			EmpleadoID,			NombreEmpleado,		CuentaIDRetiro,				CuentaIDDeposito,
				EtiquetaCtaRetiro,		EtiquetaCtaDepo,	DesTipoCuenta,		DesTipoCtaDepo,				SaldoActualCta,
				Referencia,				FormaPagoCobro,		CreditoID ,		 	ProducCreditoID,			NombreProdCred,
				MontoCredito,			MontoPorDesem,		MontoDesemb,		GrupoID,					NombreGrupo,
				CicloActual,			MontoProximoPago,	FechaProximoPago,	TotalAdeudo,				ArrendaID,
				ProdArrendaID,			NomProdArrendaID,	GarantiaAdicional,	NumCtaInstit,				NumCheque,
				IVA,					Capital,			Interes,			Moratorios,					Comision,
				ComisionAdmon,			Seguro,				SeguroVida,			IVASeguroVida,				IVACapital,
				IVAInteres,				IVAMora,			IVAOtrasComi,		IVAComFaltaPag,				IVASeguro,
				InstitucionID,			NombreInstit,		PolizaID,			Telefono,					Identificacion,
				FolioIdentificacion,	FolioPago,			CatalogoServID,		NombreCatalServ,			MontoServicio,
				IVAServicio,			OrigenServicio,		MontoComision,		TotalCastigado,				TotalRecuperado,
				Monto_PorRecuperar,		FechaCastigo,		TipoServServifun,	MontoPendPagoAportSocial,	MontoPagAportSocial,
				CobraSeguroCuota,		MontoSeguroCuota,	IVASeguroCuota,		MonedaIDOperacion,			EmpresaID,
				Usuario,				FechaActual,		DireccionIP,		ProgramaID,					Sucursal,
				NumTransaccion
			)
		SELECT
				(SELECT  (@Var_Consecutivo:= @Var_Consecutivo+1) ),
				Par_TransaccionID,	Par_TipoOperacion,		Par_Sucursal,			Par_CajaID,			Par_UsuarioID,
				Fecha_Sis,			Var_Hora,				Par_OpcionCajaID,		Par_Descripcion,	Par_MontoOpera,
				Par_Efectivo,		Par_Cambio,				CL.NombreCompleto,		Var_NombreBene,		CL.ClienteID,
				Par_ProspectoID,	Par_EmpleadoID,			Var_NombreEmpleado,		Par_CtaIDRetiro,	Par_CtaIDDeposito,
				Cadena_Vacia,		Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,		Var_SaldoDispo,
				Par_Referencia,		Par_FormaPagoCobro,		Par_CreditoID,			Entero_Cero,		Cadena_Vacia,
				Decimal_Cero,		Decimal_Cero,			Decimal_Cero,			Entero_Cero,		Cadena_Vacia,
				Entero_Cero,		Cadena_Vacia,			Cadena_Vacia,			Cadena_Vacia,		DT.ArrendaID,
				Var_ProductArrenda,	Var_DescProdArrenda,	Par_GarantAdicional,	Par_NumCtaInstit,	Par_NumCheque,
				Cadena_Vacia,
				FORMAT(ROUND(IFNULL(SUM(DT.MontoCapVen + DT.MontoCapVig + DT.MontoCapAtr),Decimal_Cero),2),2),
				FORMAT(ROUND(IFNULL(SUM(DT.MontoIntVen + DT.MontoIntVig + DT.MontoIntAtr),Decimal_Cero),2),2),
				FORMAT(ROUND(IFNULL(SUM(DT.MontoMoratorios),Decimal_Cero),2),2),
				FORMAT(ROUND(IFNULL(SUM(DT.MontoComision),Decimal_Cero),2),2),      /* Otras Comisiones */
				FORMAT(ROUND(IFNULL(SUM(DT.MontoComFaltPago),Decimal_Cero),2),2),   /* Comisiones Falta de Pago */
				ROUND(IFNULL(SUM(DT.MontoSeguro),Decimal_Cero),2),
				ROUND(IFNULL(SUM(DT.MontoSeguroVida),Decimal_Cero),2),
				ROUND(IFNULL(SUM(DT.MontoIVASeguroVida),Decimal_Cero),2),
				ROUND(IFNULL(SUM(DT.MontoIVACapital),Decimal_Cero),2),
				ROUND(IFNULL(SUM(DT.MontoIVAInteres),Decimal_Cero),2),
				ROUND(IFNULL(SUM(DT.MontoIVAMora),Decimal_Cero),2),
				ROUND(IFNULL(SUM(DT.MontoIVAComi),Decimal_Cero),2),
				ROUND(IFNULL(SUM(DT.MontoIVAComFalPag),Decimal_Cero),2),
				ROUND(IFNULL(SUM(DT.MontoIVASeguro),Decimal_Cero),2),
				Par_InstitucionID,		Var_NombreInstit,		Par_PolizaID,		Par_Telefono,					Par_Identificacion,
				Par_FolioIdentif,		Par_FolioPago,			Par_CatalogoServID,	Cadena_Vacia,					Par_MontoServicio,
				Par_IVAServicio,		Cadena_Vacia,			Par_Comision,		Decimal_Cero,					Decimal_Cero,
				Decimal_Cero,			Fecha_Vacia,			Cadena_Vacia,		Par_MontoPendPagoAportSocial,	Par_MontoPagAportSocial,
				Par_CobraSeguroCuota,	Par_MontoSeguroCuota,	Par_IVASeguroCuota,	Par_MonedaID,					Par_EmpresaID,
				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,					Aud_Sucursal,
				Aud_NumTransaccion
				FROM     CLIENTES CL
				LEFT OUTER JOIN  DETALLEPAGARRENDA DT	ON CL.ClienteID = DT.ClienteID
				WHERE DT.Transaccion =	Par_TransaccionID
				AND DT.FechaPago = Fecha_Sis
				AND CL.ClienteID = Par_ClienteID
				AND DT.ArrendaID = Par_ArrendaID
			GROUP BY DT.ArrendaID, DT.Transaccion, CL.NombreCompleto, CL.ClienteID, DT.ArrendaID;
	ELSE
		SET Var_Consecutivo := (SELECT IFNULL(MAX(ReimpresionID),Entero_Cero)+1
							FROM REIMPRESIONTICKET
							WHERE TransaccionID = Par_TransaccionID );

		SET Par_FormaPagoCobro :=IFNULL(Par_FormaPagoCobro, Cadena_Vacia);

		IF(Par_MontoPendPagoAportSocial!=Entero_Cero) THEN
			SET Par_MontoPendPagoAportSocial := Par_MontoPendPagoAportSocial - Par_MontoOpera;
		END IF;


		INSERT INTO REIMPRESIONTICKET (
				`ReimpresionID`,	`TransaccionID`,	`TipoOperacionID`,		`SucursalID`,		CajaID,
				`UsuarioID`,		`Fecha`,			`Hora`,					`OpcionCajaID`,		`Descripcion`,
				`MontoOperacion`,	`Efectivo`,			`Cambio`,`NombrePersona`,`NombreBeneficiario`,
				`ClienteID`,		`ProspectoID`,		`EmpleadoID`,			`NombreEmpleado`,	`CuentaIDRetiro`,
				`CuentaIDDeposito`,	`EtiquetaCtaRetiro`,`EtiquetaCtaDepo`,		`DesTipoCuenta`,	`DesTipoCtaDepo`,

				SaldoActualCta,		`Referencia`,		`FormaPagoCobro`,		`CreditoID`,		`ProducCreditoID`,
				`NombreProdCred`,	`MontoCredito`,		`MontoPorDesem`,		`MontoDesemb`,		`GrupoID`,
				`NombreGrupo`,		`CicloActual`,		`MontoProximoPago`,		`FechaProximoPago`,	`TotalAdeudo`,
				`Capital`,			`Interes`,			`Moratorios`,			`Comision`,			`ComisionAdmon`,
				`IVA`,				`GarantiaAdicional`,`InstitucionID`,		`NumCtaInstit`,		`NumCheque`,

				`NombreInstit`,		`PolizaID`,			`Telefono`,				`Identificacion`,	`FolioIdentificacion`,
					`FolioPago`,		`CatalogoServID`,	`NombreCatalServ`,		`MontoServicio`,	`IVAServicio`,
				`OrigenServicio`,	`MontoComision`,	`TotalCastigado`,		`TotalRecuperado`,	`Monto_PorRecuperar`,
				FechaCastigo, `TipoServServifun`,	`EmpresaID`,		`Usuario`,				`FechaActual`,		`DireccionIP`,
				`ProgramaID`,		`Sucursal`,			`NumTransaccion`, 		MonedaIDOperacion, MontoPendPagoAportSocial,
				MontoPagAportSocial,CobraSeguroCuota,	MontoSeguroCuota,	IVASeguroCuota,			AccesorioID)
			VALUES(
				Var_Consecutivo,	Par_TransaccionID,	Par_TipoOperacion,		Par_Sucursal,		Par_CajaID,
				Par_UsuarioID,		Fecha_Sis,			Var_Hora,				Par_OpcionCajaID,	Par_Descripcion,
				Par_MontoOpera,		Par_Efectivo,		Par_Cambio,				Var_NombreCompleto,	Var_NombreBene,
				Par_ClienteID,		Par_ProspectoID,	Par_EmpleadoID,			Var_NombreEmpleado,	Par_CtaIDRetiro,
				Par_CtaIDDeposito,	Var_EtiquetaRet,	Var_EtiquetaDep,		Var_DescripCta,		Var_DescripCtaD,

				Var_SaldoDispo,		Par_Referencia,		Par_FormaPagoCobro,		Par_CreditoID,		Var_ProductCredito,
				Var_DescProdCred,	Var_MontoCred, 		Var_MontoPorDes,		Var_MontoDesem,		Var_GrupoID,
				Var_NombreGrupo,	Var_CicloGrupo,		Var_MontoPag,			Var_ProxFechaPag,	Var_TotalAdeudo,
				Var_Capital,		Var_Interes,		Var_MontoIntMora,		Var_MontoComision,	Var_MontoGastoAdmon,
				Var_MontoIVA,		Par_GarantAdicional,Par_InstitucionID,		Par_NumCtaInstit,	Par_NumCheque,

				Var_NombreInstit,	Par_PolizaID,		Par_Telefono,			Var_Identifica,		Par_FolioIdentif,
				Par_FolioPago,		Par_CatalogoServID,	Var_NombreServ,			Par_MontoServicio,	Par_IVAServicio,
				Var_OrigenServ,		Par_Comision,		Var_TotCastigo,			Var_Recuperado,		Var_PorRecuperar,
				Var_FechaCastigo,	Var_TipoServicio,	Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion,		Par_MonedaID,		Par_MontoPendPagoAportSocial,
				Par_MontoPagAportSocial,  Par_CobraSeguroCuota, Par_MontoSeguroCuota, Par_IVASeguroCuota, 	Par_AccesorioID
		);
	END IF;



SET	Par_NumErr := Entero_Cero;
SET	Par_ErrMen := CONCAT("Datos Ticket Agregado Exitosamente");
SET Var_Control := '';

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Entero_Cero AS consecutivo;
END IF;

END TerminaStore$$