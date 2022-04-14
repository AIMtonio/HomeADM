-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOARCHIVOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOSVENTACARPRO`;
DELIMITER $$

CREATE PROCEDURE `CREDITOSVENTACARPRO`(
    Par_EmpresaID           INT,
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
    )
TerminaStore: BEGIN

-- DECLARACION DE VARIABLES
DECLARE Var_CreditoID           BIGINT(12);
DECLARE Var_CreditoIDAmor       BIGINT(12);
DECLARE Var_CreditoVendido      BIGINT(12);
DECLARE Var_CreditoDiferido     BIGINT(12);
DECLARE Var_AmortizacionID      INT(4);
DECLARE Var_DiasAtraso			INT(11);
DECLARE Var_ContadorExito		INT(11);
DECLARE Var_ContadorFallo		INT(11);
DECLARE Var_SaldoCapVigente     DECIMAL(12,2);
DECLARE Var_SaldoCapAtrasa      DECIMAL(12,2);
DECLARE Var_SaldoCapVencido     DECIMAL(12,2);
DECLARE Var_SaldoCapVenNExi     DECIMAL(12,2);
DECLARE Var_SaldoInteresOrd     DECIMAL(12,4);
DECLARE Var_SaldoInteresAtr     DECIMAL(12,4);
DECLARE Var_SaldoInteresVen     DECIMAL(12,4);
DECLARE Var_SaldoInteresPro     DECIMAL(12,4);
DECLARE Var_SaldoIntNoConta     DECIMAL(12,4);
DECLARE Var_SaldoMoratorios     DECIMAL(12,2);
DECLARE Var_SaldoComFaltaPa     DECIMAL(12,2);
DECLARE Var_SaldoComServGar     DECIMAL(12,2);
DECLARE Var_SaldoOtrasComis     DECIMAL(12,2);
DECLARE Var_CreEstatus          CHAR(1);
DECLARE Var_AmorEstatus         CHAR(1);
DECLARE Var_BanderaPro          CHAR(1);
DECLARE Var_ProdNomina			CHAR(1);
DECLARE Var_SalMoraVencido      DECIMAL(12,2);
DECLARE Var_SalMoraCarVen       DECIMAL(12,2);
DECLARE Var_VenIntMora       	DECIMAL(12,2);
DECLARE Var_ResCapital          DECIMAL(14,2);
DECLARE Var_ResInteres          DECIMAL(14,2);
DECLARE Var_FecAntRes           DATE;
DECLARE Var_MonReservar         DECIMAL(14,2);
DECLARE Var_ConceptoCarID		INT;
DECLARE Var_FechaSistema        DATE;
DECLARE Var_FecApl              DATE;
DECLARE Var_EsHabil             CHAR(1);
DECLARE Var_SucCliente          INT;
DECLARE Var_MonedaID            INT(11);
DECLARE Var_ProdCreID           INT;
DECLARE Var_ClasifCre           CHAR(1);
DECLARE Var_Fallido             VARCHAR(10);
DECLARE Var_Procesado           VARCHAR(10);
DECLARE Var_DescripError        VARCHAR(100);
DECLARE Var_SubClasifID         INT;
DECLARE Var_CapitalVen          DECIMAL(14,2);		-- CAPITAL VENCIDO
DECLARE Var_InteresVen          DECIMAL(14,2);		-- INTERES VENCIDO
DECLARE Var_VendidoCapVig       DECIMAL(14,2);		-- TOTAL DE CAPITAL VIGENTE VENDIDO
DECLARE Var_VendidoCapAtr       DECIMAL(14,2);		-- TOTAL DE CAPITAL EN ATRASO VENDIDO
DECLARE Var_VendidoIntOrd       DECIMAL(14,2);		-- TOTAL DE INTERES EN ORDINARIO VENDIDO
DECLARE Var_VendidoIntAtr       DECIMAL(14,2);		-- TOTAL DE INTERES EN ATRASADO VENDIDO
DECLARE Var_VendidoIntPro       DECIMAL(14,2);		-- TOTAL DE INTERES EN PROVISIONADO VENDIDO
DECLARE Var_VendidoMoratorio	DECIMAL(14,2);
DECLARE Var_VendidoMoraVen		DECIMAL(14,2);
DECLARE Var_VendidoMoraCarVe	DECIMAL(14,2);
DECLARE Var_VendidoComFalPa		DECIMAL(14,2);
DECLARE Var_VendidoOtraCom		DECIMAL(14,2);
DECLARE Var_VendidoCapVenNEx	DECIMAL(14,2);
DECLARE Var_VendidoCapVencid	DECIMAL(14,2);
DECLARE Var_VendidoIntVencid	DECIMAL(14,2);
DECLARE Var_VendidoIntNoConta	DECIMAL(14,2);
DECLARE Var_AccesoriosVal		DECIMAL(14,2);
DECLARE Var_VendidoAccesor		DECIMAL(14,2);
DECLARE Par_Consecutivo         BIGINT;
DECLARE Var_SucursalCred        INT;
DECLARE Par_PolizaID            BIGINT;
-- DECLARACION DE CONSTANTES
DECLARE Cadena_Vacia            CHAR(1);
DECLARE Fecha_Vacia             DATE;
DECLARE Entero_Cero             INT;
DECLARE Decimal_Cero            DECIMAL(12, 2);
DECLARE Esta_Vigente            CHAR(1);
DECLARE Esta_Vencido            CHAR(1);
DECLARE Esta_Pagado             CHAR(1);
DECLARE Esta_Vendido            CHAR(1); -- Estatus Cedido o Vendido
DECLARE AltaPoliza_NO           CHAR(1);
DECLARE Par_SalidaNO            CHAR(1);
DECLARE AltaPolCre_SI           CHAR(1);
DECLARE AltaMovAho_NO           CHAR(1);
DECLARE AltaMovCre_SI           CHAR(1);
DECLARE AltaMovCre_NO           CHAR(1);
DECLARE Con_EstBalance          INT;
DECLARE Con_EstBalanceInt       INT;
DECLARE Con_IntProvis           INT;
DECLARE Con_IntAtrasado         INT;
DECLARE Con_CapVigente          INT;
DECLARE Con_CapAtrasado         INT;
DECLARE Con_CorCasMora         	INT;
DECLARE Con_CapVencido			INT;
DECLARE Con_CapVenNoExi     	INT;
DECLARE Con_MoraVigente     	INT;
DECLARE Con_CtaOrdMor       	INT;
DECLARE Con_CorIntMor       	INT;
DECLARE Con_CtaOrdInt       	INT;
DECLARE Con_CorIntOrd       	INT;
DECLARE Con_IntVencido      	INT;
DECLARE Con_MoraVencido     	INT;
DECLARE Si_AplicaConta          CHAR(1);
DECLARE Pol_Automatica          CHAR(1);
DECLARE Con_ConceptoConta       INT;
DECLARE Mov_IntProvis           INT;
DECLARE Mov_IntAtrasado         INT;
DECLARE Mov_CapVigente          INT;
DECLARE Mov_CapAtrasado         INT;
DECLARE Mov_CapVenNoExi     	INT;
DECLARE Mov_Moratorio       	INT;
DECLARE Mov_MoraCarVen      	INT;
DECLARE Mov_IntNoConta      	INT;
DECLARE Mov_IntVencido      	INT;
DECLARE Mov_CapVencido      	INT;
DECLARE Mov_MoraVencido     	INT;
DECLARE Con_OrdCasMora      	INT;
DECLARE Con_OrdCasComi			INT;
DECLARE Con_CorCasComi			INT;
DECLARE Nat_Cargo               CHAR(1);
DECLARE Nat_Abono               CHAR(1);
DECLARE Mon_MinPago             DECIMAL(12,2);
DECLARE Var_DesConPoliza        VARCHAR(100);
DECLARE Var_PerdidaCesion       DECIMAL(12,2);
DECLARE Var_ValorReserva        DECIMAL(12,2);
DECLARE Var_ValorVendido         DECIMAL(12,2);
DECLARE Par_NumErr              INT(11);
DECLARE	Par_ErrMen              VARCHAR(400);
DECLARE Var_CuentaConta         VARCHAR(50);

/* DECLARACION DE CURSORES */
DECLARE CURSORVENTACARTERA CURSOR FOR
    SELECT  CreditoID FROM  CREDITOSVENTACAR;

DECLARE CURSORAMORTI CURSOR FOR
  SELECT  	Amo.CreditoID,				(Amo.AmortizacionID),     (Amo.SaldoCapVigente),		(Amo.SaldoCapAtrasa),		(Amo.SaldoCapVencido),
            (Amo.SaldoCapVenNExi),      (Amo.SaldoInteresOrd),    (Amo.SaldoInteresAtr),		(Amo.SaldoInteresVen),		(Amo.SaldoInteresPro),
            (Amo.SaldoIntNoConta),      (Amo.SaldoMoratorios),    (Amo.SaldoComFaltaPa),		(Amo.SaldoComServGar),      (Amo.SaldoOtrasComis),
			(Cre.MonedaID),             (Amo.SaldoMoraVencido),   (Amo.SaldoMoraCarVen),        (Cre.Estatus),				(Amo.Estatus)
    FROM  AMORTICREDITO Amo,
        CREDITOSVENTACAR    Vta,
        CREDITOS Cre
    WHERE Amo.CreditoID   = Vta.CreditoID
      AND Amo.CreditoID   = Cre.CreditoID
      AND Vta.CreditoID   = Cre.CreditoID
      and Amo.CreditoID   = Var_CreditoID
      AND Amo.Estatus 	  != Esta_Pagado
    ORDER BY Amo.CreditoID;


-- ASIGNACION DE CONSTANTES
SET Cadena_Vacia        	:= '';
SET Fecha_Vacia         	:= '1900-01-01';
SET Entero_Cero         	:= 0;
SET Decimal_Cero        	:= 0.00;
SET Esta_Vigente        	:= 'V';
SET Esta_Vencido        	:= 'B';
SET Esta_Pagado         	:= 'P';
SET Esta_Vendido        	:= 'X';	-- Estatus Cedido o Vendido
SET Par_SalidaNO        	:= 'N';
SET AltaPoliza_NO       	:= 'N';
SET AltaPolCre_SI       	:= 'S';
SET AltaMovAho_NO       	:= 'N';
SET AltaMovCre_NO       	:= 'N';
SET AltaMovCre_SI       	:= 'S';
SET Si_AplicaConta      	:= 'S';
SET Pol_Automatica      	:= 'A';
SET Var_BanderaPro      	:= '1';
SET Mov_CapVigente      	:= 1;
SET Mov_CapAtrasado     	:= 2;
SET Mov_CapVencido      	:= 3;
SET Mov_CapVenNoExi     	:= 4;
SET Mov_IntAtrasado     	:= 11;
SET Mov_IntVencido      	:= 12;
SET Mov_IntNoConta			:= 13;
SET Mov_IntProvis       	:= 14;
SET Mov_Moratorio       	:= 15;
SET Mov_MoraVencido     	:= 16;
SET Mov_MoraCarVen      	:= 17;
SET Con_CapVigente      	:= 1;
SET Con_CapAtrasado     	:= 2;
SET Con_CapVencido      	:= 3;
SET Con_CapVenNoExi     	:= 4;
SET Con_CtaOrdInt       	:= 11;
SET Con_CorIntOrd       	:= 12;
SET Con_CtaOrdMor       	:= 13;
SET Con_CorIntMor       	:= 14;
SET Con_EstBalance      	:= 17;
SET Con_IntProvis       	:= 19;
SET Con_IntAtrasado     	:= 20;
SET Con_IntVencido      	:= 21;
SET Con_MoraVigente     	:= 33;
SET Con_MoraVencido     	:= 34;
SET Con_EstBalanceInt   	:= 36;
SET Con_OrdCasMora      	:= 42;
SET Con_CorCasMora      	:= 43;
SET Con_OrdCasComi      	:= 44;
SET Con_CorCasComi      	:= 45;
SET Con_ConceptoConta   	:= 85; -- CONCEPTO CONTABLE TABLA CONCEPTOSCONTA
SET Nat_Cargo           	:= 'C';
SET Nat_Abono           	:= 'A';
SET Mon_MinPago         	:= 0.01;
SET Var_DesConPoliza    	:= 'VENTA DE CARTERA';
SET Var_ContadorExito		:= 0;
SET Var_ContadorFallo		:= 0;
SET Var_AccesoriosVal		:= Entero_Cero;
SET Var_ResInteres      	:= Entero_Cero;
SET Var_ResCapital      	:= Entero_Cero;
SET Var_MonReservar     	:= Entero_Cero;
SET Var_VendidoCapVig   	:= Entero_Cero;
SET Var_VendidoCapAtr   	:= Entero_Cero;
SET Var_VendidoIntOrd   	:= Entero_Cero;
SET Var_VendidoIntAtr   	:= Entero_Cero;
SET Var_VendidoIntPro   	:= Entero_Cero;
SET Var_VendidoMoratorio	:= Entero_Cero;
SET Var_VendidoAccesor		:= Entero_Cero;
SET Var_VendidoIntVencid	:= Entero_Cero;
SET Var_VendidoIntNoConta	:= Entero_Cero;
SET Var_VendidoMoraVen		:= Entero_Cero;
SET Var_VendidoMoraCarVe	:= Entero_Cero;
SET Var_VendidoComFalPa		:= Entero_Cero;
SET Var_VendidoCapVenNEx	:= Entero_Cero;
SET Var_VendidoCapVencid	:= Entero_Cero;
SET Var_VendidoOtraCom		:= Entero_Cero;

SET Var_Fallido				:= 'FALLIDO';
SET Var_Procesado			:= 'PROCESADO';
SET Par_NumErr          	:= 000;
SET Par_ErrMen          	:= Cadena_Vacia;
SET Par_EmpresaID       	:= IFNULL(Par_EmpresaID, 1);
SET Par_PolizaID        	:= Entero_Cero;
SET Aud_FechaActual     	:= CURRENT_TIMESTAMP();
SET Var_CuentaConta	    	:= (SELECT ValorParametro
							FROM PARAMGENERALES WHERE LlaveParametro = 'CtaContaPerdCesionCartera');

ManejoErrores : BEGIN
    /*DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr := 999;
            SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                            'Disculpe las molestias que esto le ocasiona. Ref: SP-CREDITOSVENTACARPRO');
            END;*/

TRUNCATE  TMPHISCREDITOSVENTACAR;

-- SE OBTIENE LA FECHA DEL SISTEMA
SELECT FechaSistema INTO Var_FechaSistema FROM PARAMETROSSIS  LIMIT 1 ;
-- SE OBTIENE LA FECHA DE APLICACION
CALL DIASFESTIVOSCAL(
    Var_FechaSistema,   Entero_Cero,        Var_FecApl,         Var_EsHabil,    Par_EmpresaID,
    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
    Aud_NumTransaccion);

OPEN CURSORVENTACARTERA;
BEGIN
    DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
    CICLO:LOOP

    FETCH CURSORVENTACARTERA INTO
        Var_CreditoID;

	SELECT  MAX(Amo.CreditoID),            MAX(Amo.AmortizacionID),     SUM(Amo.SaldoCapVigente),		SUM(Amo.SaldoCapAtrasa),	SUM(Amo.SaldoCapVencido),
            SUM(Amo.SaldoCapVenNExi),      SUM(Amo.SaldoInteresOrd),    SUM(Amo.SaldoInteresAtr),		SUM(Amo.SaldoInteresVen),	SUM(Amo.SaldoInteresPro),
            SUM(Amo.SaldoIntNoConta),      SUM(Amo.SaldoMoratorios),    SUM(Amo.SaldoComFaltaPa),		SUM(Amo.SaldoComServGar),   SUM(Amo.SaldoOtrasComis),
			MAX(Cre.MonedaID),             SUM(Amo.SaldoMoraVencido),   SUM(Amo.SaldoMoraCarVen),       MAX(Cre.Estatus),			MAX(Amo.Estatus)
    INTO
            Var_CreditoID,                  Var_AmortizacionID,         Var_SaldoCapVigente,			Var_SaldoCapAtrasa,          Var_SaldoCapVencido,
        	Var_SaldoCapVenNExi,    		Var_SaldoInteresOrd,        Var_SaldoInteresAtr,			Var_SaldoInteresVen,         Var_SaldoInteresPro,
        	Var_SaldoIntNoConta,    		Var_SaldoMoratorios,        Var_SaldoComFaltaPa,			Var_SaldoComServGar,         Var_SaldoOtrasComis,
			Var_MonedaID,                   Var_SalMoraVencido,         Var_SalMoraCarVen,              Var_CreEstatus,				 Var_AmorEstatus
    FROM 	AMORTICREDITO Amo,
    		CREDITOS   Cre
    WHERE   	Amo.CreditoID   = Cre.CreditoID
    	AND   	Cre.CreditoID   = Var_CreditoID
    GROUP BY Cre.CreditoID;

    SELECT  Cli.SucursalOrigen,     Cre.MonedaID,   Pro.ProducCreditoID,    Des.Clasificacion,  Des.SubClasifID,
	        Cre.Estatus,            Cre.SucursalID
	INTO 	Var_SucCliente,         Var_MonedaID,   Var_ProdCreID,      	Var_ClasifCre,  Var_SubClasifID,
	        Var_CreEstatus,         Var_SucursalCred
	    FROM	PRODUCTOSCREDITO Pro,
				CLIENTES Cli,
		        DESTINOSCREDITO Des,
		        CREDITOS Cre,
		        CREDITOSVENTACAR Ven
	    WHERE 	Cre.CreditoID         = Var_CreditoID
	    	AND Cre.CreditoID         = Ven.CreditoID
	      	AND Cre.ProductoCreditoID = Pro.ProducCreditoID
	      	AND Cre.ClienteID         = Cli.ClienteID
	     	AND Cre.DestinoCreID      = Des.DestinoCreID;

	SET Var_SaldoCapVigente		:= IFNULL(Var_SaldoCapVigente, Entero_Cero);
	SET Var_SaldoCapAtrasa 		:= IFNULL(Var_SaldoCapAtrasa,  Entero_Cero);
	SET Var_SaldoCapVencido		:= IFNULL(Var_SaldoCapVencido, Entero_Cero);
	SET Var_SaldoCapVenNExi		:= IFNULL(Var_SaldoCapVenNExi, Entero_Cero);
	SET Var_SaldoInteresOrd		:= IFNULL(Var_SaldoInteresOrd, Entero_Cero);
	SET Var_SaldoInteresAtr		:= IFNULL(Var_SaldoInteresAtr, Entero_Cero);
	SET Var_SaldoInteresVen		:= IFNULL(Var_SaldoInteresVen, Entero_Cero);
	SET Var_SaldoInteresPro		:= IFNULL(Var_SaldoInteresPro, Entero_Cero);
	SET Var_SaldoIntNoConta		:= IFNULL(Var_SaldoIntNoConta, Entero_Cero);
	SET Var_SaldoMoratorios		:= IFNULL(Var_SaldoMoratorios, Entero_Cero);
	SET Var_SaldoComFaltaPa		:= IFNULL(Var_SaldoComFaltaPa, Entero_Cero);
	SET Var_SaldoComServGar		:= IFNULL(Var_SaldoComServGar, Entero_Cero);
	SET Var_SaldoOtrasComis		:= IFNULL(Var_SaldoOtrasComis, Entero_Cero);
	SET Var_SalMoraVencido 		:= IFNULL(Var_SalMoraVencido, Entero_Cero);
	SET Var_SalMoraCarVen  		:= IFNULL(Var_SalMoraCarVen, Entero_Cero);
	SET Var_ValorVendido		:= IFNULL(Var_ValorVendido,Entero_Cero);
	SET Var_ValorReserva		:= IFNULL(Var_ValorReserva,Entero_Cero);
	SET Var_ResInteres			:= IFNULL(Var_ResInteres,Entero_Cero);
	SET Var_ResCapital			:= IFNULL(Var_ResCapital,Entero_Cero);
	SET Var_VendidoCapVig		:= IFNULL(Var_VendidoCapVig,Entero_Cero);
	SET Var_VendidoCapAtr		:= IFNULL(Var_VendidoCapAtr,Entero_Cero);
	SET Var_VendidoIntOrd		:= IFNULL(Var_VendidoIntOrd,Entero_Cero);
	SET Var_VendidoIntAtr		:= IFNULL(Var_VendidoIntAtr,Entero_Cero);
	SET Var_VendidoIntPro		:= IFNULL(Var_VendidoIntPro,Entero_Cero);
	SET Var_VendidoMoratorio	:= IFNULL(Var_VendidoMoratorio,Entero_Cero);
	SET Var_VendidoMoraVen		:= IFNULL(Var_VendidoMoraVen,Entero_Cero);
	SET Var_VendidoMoraCarVe	:= IFNULL(Var_VendidoMoraCarVe,Entero_Cero);
	SET Var_VendidoComFalPa		:= IFNULL(Var_VendidoComFalPa,Entero_Cero);
	SET Var_VendidoOtraCom		:= IFNULL(Var_VendidoOtraCom,Entero_Cero);
	SET Var_VendidoCapVenNEx	:= IFNULL(Var_VendidoCapVenNEx,Entero_Cero);
	SET Var_VendidoCapVencid	:= IFNULL(Var_VendidoCapVencid,Entero_Cero);
	SET Var_VendidoIntVencid	:= IFNULL(Var_VendidoIntVencid,Entero_Cero);
	SET Var_VendidoIntNoConta	:= IFNULL(Var_VendidoIntNoConta,Entero_Cero);
	SET Var_VendidoAccesor		:= IFNULL(Var_VendidoAccesor,Entero_Cero);

	SET Var_CapitalVen		:= Var_SaldoCapVencido 	+ Var_SaldoCapVenNExi;
	SET Var_VenIntMora  	:= Var_SaldoMoratorios 	+ Var_SalMoraVencido + Var_SalMoraCarVen;
	SET Var_InteresVen		:= Var_SaldoInteresVen 	+ Var_SaldoIntNoConta;
	SET Var_AccesoriosVal 	:= Var_AccesoriosVal 	+ Var_SaldoComFaltaPa 	+ Var_SaldoOtrasComis + Var_SaldoComServGar;


	-- SE VALIDA QUE EL CREDITO NO HAYA SIDO VENDIDO PREVIAMENTE
	SET Var_CreditoVendido := (SELECT CreditoID FROM HISCREDITOSVENTACAR WHERE CreditoID = Var_CreditoID and Tipo = Var_Procesado);
	IF (Var_CreditoVendido = Var_CreditoID) THEN
		SET Var_DescripError := "El credito ya fue vendido previamente";
		INSERT INTO TMPHISCREDITOSVENTACAR (
			Fecha,				CreditoID,          Tipo,				Motivo,             SaldoCapVigente,
            SaldoCapAtrasa,     SaldoInteresOrd,    SaldoInteresAtr,  	SaldoInteresPro,    SaldoMoratorios,
            SalMoraVencido,		SalMoraCarVen,		SaldoComFaltaPa,	SaldoOtrasComis,	SaldoCapVenNExi,
            SaldoCapVencido,	SaldoInteresVen,	SaldoIntNoConta,	EmpresaID,			Usuario,
            FechaActual,        DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)
		VALUES(
            Var_FechaSistema,	Var_CreditoID,      Var_Fallido,		Var_DescripError,   Entero_Cero,
            Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,
            Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,
            Entero_Cero,        Entero_Cero,        Entero_Cero,        Par_EmpresaID,  	Aud_Usuario,
            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion
		);
		SET Var_BanderaPro	:= '2';
	END IF;

	-- SE VALIDA QUE NO SEA UN CREDITO DE NOMINA
	SET Var_ProdNomina := (SELECT ProductoNomina FROM PRODUCTOSCREDITO WHERE ProducCreditoID = Var_ProdCreID);
	IF (Var_ProdNomina = 'S' and Var_BanderaPro    = '1') THEN
		SET Var_DescripError := "El credito corresponde a un producto de credito de nomina";
		INSERT INTO TMPHISCREDITOSVENTACAR (
			Fecha,				CreditoID,          Tipo,				Motivo,             SaldoCapVigente,
            SaldoCapAtrasa,     SaldoInteresOrd,    SaldoInteresAtr,  	SaldoInteresPro,    SaldoMoratorios,
            SalMoraVencido,		SalMoraCarVen,		SaldoComFaltaPa,	SaldoOtrasComis,	SaldoCapVenNExi,
            SaldoCapVencido,	SaldoInteresVen,	SaldoIntNoConta,	EmpresaID,			Usuario,
            FechaActual,        DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)
		VALUES(
            Var_FechaSistema,	Var_CreditoID,      Var_Fallido,		Var_DescripError,   Entero_Cero,
            Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,
            Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,
            Entero_Cero,        Entero_Cero,        Entero_Cero,        Par_EmpresaID,  	Aud_Usuario,
            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion
		);
		SET Var_BanderaPro	:= '2';
	END IF;


	IF ( (Var_CreEstatus != Esta_Vigente AND Var_CreEstatus != Esta_Vencido ) and Var_BanderaPro  = '1') THEN -- Si el credito no tiene estatus vigente
		SET Var_DescripError := concat("El credito tiene estatus ",Var_CreEstatus);
		INSERT INTO TMPHISCREDITOSVENTACAR (
			Fecha,				CreditoID,          Tipo,				Motivo,             SaldoCapVigente,
            SaldoCapAtrasa,     SaldoInteresOrd,    SaldoInteresAtr,  	SaldoInteresPro,    SaldoMoratorios,
            SalMoraVencido,		SalMoraCarVen,		SaldoComFaltaPa,	SaldoOtrasComis,	SaldoCapVenNExi,
            SaldoCapVencido,	SaldoInteresVen,	SaldoIntNoConta,	EmpresaID,			Usuario,
            FechaActual,        DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)
		VALUES(
            Var_FechaSistema,	Var_CreditoID,      Var_Fallido,		Var_DescripError,   Entero_Cero,
            Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,
            Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,
            Entero_Cero,        Entero_Cero,        Entero_Cero,        Par_EmpresaID,  	Aud_Usuario,
            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion
		);
		SET Var_BanderaPro	:= '2';
	END IF; -- FIN DE IF Si el credito no tiene estatus vigente

	-- calcular dias de atraso PARA CREDITOS DIFERIDOS
	SET Var_CreditoDiferido := (SELECT MAX(CreditoID) FROM CREDITOSDIFERIDOS WHERE CreditoID = Var_CreditoID GROUP BY CreditoID);
	IF (Var_CreditoDiferido = Var_CreditoID) THEN
	   	SET Var_DiasAtraso := (
		    SELECT	(datediff(Var_FechaSistema,MIN(dif.FechaFinPeriodo))+MIN(dif.DiasDiferidos)) as DiasDiferNew
		    	FROM	CREDITOSDIFERIDOS dif,AMORTICREDITO amo
		    WHERE dif.CreditoID = amo.CreditoID
		    	AND dif.CreditoID = Var_CreditoID
				AND dif.FechaFinPeriodo > amo.FechaExigible
				AND amo.Estatus IN ('A','B')
				AND dif.FechaFinPeriodo < Var_FechaSistema
			GROUP BY dif.CreditoID);
	ELSE -- CREDITOS NO DIFERIDOS
 		SET Var_DiasAtraso := (SELECT (CASE WHEN IFNULL(min(FechaExigible), Fecha_Vacia) = Fecha_Vacia THEN 0
                           					ELSE ( datediff(Var_FechaSistema,min(FechaExigible)) + 1)  END)
									FROM AMORTICREDITO Amo
								WHERE Amo.CreditoID = Var_CreditoID
									AND Amo.Estatus != Esta_Pagado
									AND Amo.FechaExigible <= Var_FechaSistema);
	END IF;
/*
	IF (Var_DiasAtraso > 89 and Var_BanderaPro = '1' ) THEN -- SI LOS DIAS DE ATRASO SON MAYORES A 89
		SET Var_DescripError := CONCAT("El credito tiene mas de 89 dias de atraso. Dias Atraso: ",Var_DiasAtraso);
		INSERT INTO TMPHISCREDITOSVENTACAR (
			Fecha,				CreditoID,          Tipo,				Motivo,             SaldoCapVigente,
            SaldoCapAtrasa,     SaldoInteresOrd,    SaldoInteresAtr,  	SaldoInteresPro,    SaldoMoratorios,
            SalMoraVencido,		SalMoraCarVen,		SaldoComFaltaPa,	SaldoOtrasComis,	SaldoCapVenNExi,
            SaldoCapVencido,	SaldoInteresVen,	SaldoIntNoConta,	EmpresaID,			Usuario,
            FechaActual,        DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)
		VALUES(
            Var_FechaSistema,	Var_CreditoID,      Var_Fallido,		Var_DescripError,   Entero_Cero,
            Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,
            Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,
            Entero_Cero,        Entero_Cero,        Entero_Cero,        Par_EmpresaID,  	Aud_Usuario,
            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion
		);
		SET Var_BanderaPro	:= '2';
	END IF; -- FIN DE IF Si el credito no tiene estatus vigente */

	IF (Var_BanderaPro	= '1') THEN
		-- ANTES DE REALIZAR LOS CAMBIOS SE REALIZA RESPALDO DE LOS DATOS
		CALL CREDITOSVENTACARRES(	Var_CreditoID, 		Par_EmpresaID,		Aud_Usuario, 	Aud_FechaActual, 	Aud_DireccionIP,
									Aud_ProgramaID,		Aud_Sucursal, 		Aud_NumTransaccion);
	END IF;

	-- se verifica que el registro cumpla con las validaciones para continuar
	IF (Var_BanderaPro	= '1') THEN
        IF (Par_PolizaID  = Entero_Cero) THEN
             -- SE CREA EL ENCABEZADO DE LA POLIZA
            CALL MAESTROPOLIZASALT(
                Par_PolizaID,       Par_EmpresaID,      Var_FecApl,     Pol_Automatica,     Con_ConceptoConta,
                Var_DesConPoliza,   Par_SalidaNO,       Par_NumErr,     Par_ErrMen,         Aud_Usuario,
                Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion);
        END IF;

        SET Var_SaldoCapVigente	:= Entero_Cero;
		SET Var_SaldoCapAtrasa 	:= Entero_Cero;
		SET Var_SaldoCapVencido	:= Entero_Cero;
		SET Var_SaldoCapVenNExi	:= Entero_Cero;
		SET Var_SaldoInteresOrd	:= Entero_Cero;
		SET Var_SaldoInteresAtr	:= Entero_Cero;
		SET Var_SaldoInteresVen	:= Entero_Cero;
		SET Var_SaldoInteresPro	:= Entero_Cero;
		SET Var_SaldoIntNoConta	:= Entero_Cero;
		SET Var_SaldoMoratorios	:= Entero_Cero;
		SET Var_SaldoComFaltaPa	:= Entero_Cero;
		SET Var_SaldoComServGar	:= Entero_Cero;
		SET Var_SaldoOtrasComis	:= Entero_Cero;
		SET Var_SalMoraVencido 	:= Entero_Cero;
		SET Var_SalMoraCarVen  	:= Entero_Cero;

		SET Var_VendidoCapVig   	:= Entero_Cero;
		SET Var_VendidoCapAtr   	:= Entero_Cero;
		SET Var_VendidoIntOrd   	:= Entero_Cero;
		SET Var_VendidoIntAtr   	:= Entero_Cero;
		SET Var_VendidoIntPro   	:= Entero_Cero;
		SET Var_VendidoMoratorio	:= Entero_Cero;
		SET Var_VendidoAccesor		:= Entero_Cero;
		SET Var_VendidoIntVencid	:= Entero_Cero;
		SET Var_VendidoIntNoConta	:= Entero_Cero;
		SET Var_VendidoMoraVen		:= Entero_Cero;
		SET Var_VendidoMoraCarVe	:= Entero_Cero;
		SET Var_VendidoComFalPa		:= Entero_Cero;
		SET Var_VendidoCapVenNEx	:= Entero_Cero;
		SET Var_VendidoCapVencid	:= Entero_Cero;
		SET Var_VendidoOtraCom		:= Entero_Cero;


		OPEN CURSORAMORTI;
		BEGIN
	    DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
	    CICLOAmor:LOOP
	    FETCH CURSORAMORTI INTO
		Var_CreditoIDAmor,				Var_AmortizacionID,         Var_SaldoCapVigente,        Var_SaldoCapAtrasa,          Var_SaldoCapVencido,
    	Var_SaldoCapVenNExi,    		Var_SaldoInteresOrd,        Var_SaldoInteresAtr,        Var_SaldoInteresVen,         Var_SaldoInteresPro,
    	Var_SaldoIntNoConta,    		Var_SaldoMoratorios,        Var_SaldoComFaltaPa,        Var_SaldoComServGar,         Var_SaldoOtrasComis,
		Var_MonedaID,                   Var_SalMoraVencido,         Var_SalMoraCarVen,          Var_CreEstatus,				 Var_AmorEstatus;

        SET Var_SaldoOtrasComis := IFNULL(Var_SaldoOtrasComis, Entero_Cero) + IFNULL(Var_SaldoComServGar, Entero_Cero);

        IF(Var_AmorEstatus != Esta_Pagado )THEN
        	IF (Var_BanderaPro	= '1' AND Var_SaldoInteresPro >= Mon_MinPago) THEN
				SET Var_ConceptoCarID 	:= Con_IntProvis;
			    CALL  CONTACREDITOPRO (
			        Var_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,        Var_FechaSistema,
			        Var_FecApl,         Var_SaldoInteresPro,    Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
			        Var_SubClasifID,    Var_SucCliente,         Var_DesConPoliza,	Var_DesConPoliza,	AltaPoliza_NO,
			        Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_SI,      Var_ConceptoCarID ,
			        Mov_IntProvis,      Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
			        Cadena_Vacia,       Par_NumErr,				Par_ErrMen,			Par_Consecutivo,    Par_EmpresaID,
			        Cadena_Vacia,		Aud_Usuario,        	Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,
			        Var_SucursalCred,	Aud_NumTransaccion);

			    IF (Par_NumErr <> Entero_Cero)THEN
			        SET Var_DescripError := CONCAT(Par_NumErr , " - ", Par_ErrMen);
			       	INSERT INTO TMPHISCREDITOSVENTACAR (
						Fecha,				CreditoID,          Tipo,				Motivo,             SaldoCapVigente,
	                    SaldoCapAtrasa,     SaldoInteresOrd,    SaldoInteresAtr,  	SaldoInteresPro,    SaldoMoratorios,
		                SalMoraVencido,		SalMoraCarVen,		SaldoComFaltaPa,	SaldoOtrasComis,	SaldoCapVenNExi,
		                SaldoCapVencido,	SaldoInteresVen,	SaldoIntNoConta,	EmpresaID,			Usuario,
		                FechaActual,        DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)
					VALUES(
	                    Var_FechaSistema,	Var_CreditoID,      Var_Fallido,		Var_DescripError,   Entero_Cero,
	                    Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,
	                    Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,
	                    Entero_Cero,        Entero_Cero,        Entero_Cero,        Par_EmpresaID,  	Aud_Usuario,
	                    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion
					);
					SET Var_BanderaPro	:= '2';
			    END IF;
		  	END IF;

		  	IF (Var_BanderaPro	= '1' AND Var_SaldoInteresAtr >= Mon_MinPago) THEN
				SET Var_ConceptoCarID 	:= Con_IntAtrasado;

			    CALL  CONTACREDITOPRO (
			        Var_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,        Var_FechaSistema,
			        Var_FecApl,         Var_SaldoInteresAtr,    Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
			        Var_SubClasifID,    Var_SucCliente,         Var_DesConPoliza,	Var_DesConPoliza,	AltaPoliza_NO,
			        Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_SI,      Var_ConceptoCarID ,
			        Mov_IntAtrasado,    Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
			        Cadena_Vacia,      	Par_NumErr,				Par_ErrMen,			Par_Consecutivo,    Par_EmpresaID,
			        Cadena_Vacia,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,
			        Var_SucursalCred,	Aud_NumTransaccion);

			    IF (Par_NumErr <> Entero_Cero)THEN
			        SET Var_DescripError := CONCAT(Par_NumErr , " - ", Par_ErrMen);
			       	INSERT INTO TMPHISCREDITOSVENTACAR (
						Fecha,				CreditoID,          Tipo,				Motivo,             SaldoCapVigente,
	                    SaldoCapAtrasa,     SaldoInteresOrd,    SaldoInteresAtr,  	SaldoInteresPro,    SaldoMoratorios,
		                SalMoraVencido,		SalMoraCarVen,		SaldoComFaltaPa,	SaldoOtrasComis,	SaldoCapVenNExi,
		                SaldoCapVencido,	SaldoInteresVen,	SaldoIntNoConta,	EmpresaID,			Usuario,
		                FechaActual,        DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)
					VALUES(
	                    Var_FechaSistema,	Var_CreditoID,      Var_Fallido,		Var_DescripError,   Entero_Cero,
	                    Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,
	                    Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,
	                    Entero_Cero,        Entero_Cero,        Entero_Cero,        Par_EmpresaID,  	Aud_Usuario,
	                    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion
					);
					SET Var_BanderaPro	:= '2';
			    END IF;
		  	END IF;

		  	IF (Var_BanderaPro	= '1' AND Var_SaldoCapVigente >= Mon_MinPago) THEN
		  		SET Var_ConceptoCarID 	:= Con_CapVigente;

			    CALL  CONTACREDITOPRO (
			        Var_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,        Var_FechaSistema,
			        Var_FecApl,         Var_SaldoCapVigente,    Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
			        Var_SubClasifID,    Var_SucCliente,         Var_DesConPoliza,   Var_DesConPoliza,	AltaPoliza_NO,
			        Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_SI,      Var_ConceptoCarID ,
			        Mov_CapVigente,     Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
			        Cadena_Vacia,       Par_NumErr,         	Par_ErrMen,			Par_Consecutivo,    Par_EmpresaID,
			        Cadena_Vacia,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,
			        Var_SucursalCred,	Aud_NumTransaccion);

			    IF (Par_NumErr <> Entero_Cero)THEN
			        SET Var_DescripError := CONCAT(Par_NumErr , " - ", Par_ErrMen);
			       	INSERT INTO TMPHISCREDITOSVENTACAR (
						Fecha,				CreditoID,          Tipo,				Motivo,             SaldoCapVigente,
	                    SaldoCapAtrasa,     SaldoInteresOrd,    SaldoInteresAtr,  	SaldoInteresPro,    SaldoMoratorios,
		                SalMoraVencido,		SalMoraCarVen,		SaldoComFaltaPa,	SaldoOtrasComis,	SaldoCapVenNExi,
		                SaldoCapVencido,	SaldoInteresVen,	SaldoIntNoConta,	EmpresaID,			Usuario,
		                FechaActual,        DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)
					VALUES(
	                    Var_FechaSistema,	Var_CreditoID,      Var_Fallido,		Var_DescripError,   Entero_Cero,
	                    Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,
	                    Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,
	                    Entero_Cero,        Entero_Cero,        Entero_Cero,        Par_EmpresaID,  	Aud_Usuario,
	                    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion
					);
					SET Var_BanderaPro	:= '2';
			    END IF;
		  	END IF;

		  	IF (Var_BanderaPro	= '1' AND Var_SaldoCapAtrasa >= Mon_MinPago) THEN
				SET Var_ConceptoCarID 	:= Con_CapAtrasado;
			    CALL  CONTACREDITOPRO (
			        Var_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,        Var_FechaSistema,
			        Var_FecApl,         Var_SaldoCapAtrasa,     Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
			        Var_SubClasifID,    Var_SucCliente,         Var_DesConPoliza,	Var_DesConPoliza,	AltaPoliza_NO,
			        Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_SI,      Var_ConceptoCarID ,
			        Mov_CapAtrasado,    Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
			        Cadena_Vacia,       Par_NumErr,				Par_ErrMen,			Par_Consecutivo,    Par_EmpresaID,
			        Cadena_Vacia,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,
			        Var_SucursalCred,	Aud_NumTransaccion);

			    IF (Par_NumErr <> Entero_Cero)THEN
			        SET Var_DescripError := CONCAT(Par_NumErr , " - ", Par_ErrMen);
			       	INSERT INTO TMPHISCREDITOSVENTACAR (
						Fecha,				CreditoID,          Tipo,				Motivo,             SaldoCapVigente,
	                    SaldoCapAtrasa,     SaldoInteresOrd,    SaldoInteresAtr,  	SaldoInteresPro,    SaldoMoratorios,
		                SalMoraVencido,		SalMoraCarVen,		SaldoComFaltaPa,	SaldoOtrasComis,	SaldoCapVenNExi,
		                SaldoCapVencido,	SaldoInteresVen,	SaldoIntNoConta,	EmpresaID,			Usuario,
		                FechaActual,        DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)
					VALUES(
	                    Var_FechaSistema,	Var_CreditoID,      Var_Fallido,		Var_DescripError,   Entero_Cero,
	                    Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,
	                    Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,
	                    Entero_Cero,        Entero_Cero,        Entero_Cero,        Par_EmpresaID,  	Aud_Usuario,
	                    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion
					);
					SET Var_BanderaPro	:= '2';
			    END IF;
		  	END IF;

		    IF (Var_BanderaPro	= '1' AND Var_SaldoCapVencido >= Mon_MinPago) THEN
			    CALL  CONTACREDITOPRO (
			        Var_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,        Var_FechaSistema,
			        Var_FecApl,         Var_SaldoCapVencido,    Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
			        Var_SubClasifID,    Var_SucCliente,         Var_DesConPoliza,        Var_DesConPoliza,        AltaPoliza_NO,
			        Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_SI,      Con_CapVencido,
			        Mov_CapVencido,     Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
			        Cadena_Vacia,       /*Par_SalidaNO,*/
			        Par_NumErr,         Par_ErrMen,             Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
			        Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
			        Aud_NumTransaccion);

			    IF (Par_NumErr <> Entero_Cero)THEN
			        SET Var_DescripError := CONCAT(Par_NumErr , " - ", Par_ErrMen);
			       	INSERT INTO TMPHISCREDITOSVENTACAR (
						Fecha,				CreditoID,          Tipo,				Motivo,             SaldoCapVigente,
	                    SaldoCapAtrasa,     SaldoInteresOrd,    SaldoInteresAtr,  	SaldoInteresPro,    SaldoMoratorios,
		                SalMoraVencido,		SalMoraCarVen,		SaldoComFaltaPa,	SaldoOtrasComis,	SaldoCapVenNExi,
		                SaldoCapVencido,	SaldoInteresVen,	SaldoIntNoConta,	EmpresaID,			Usuario,
		                FechaActual,        DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)
					VALUES(
	                    Var_FechaSistema,	Var_CreditoID,      Var_Fallido,		Var_DescripError,   Entero_Cero,
	                    Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,
	                    Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,
	                    Entero_Cero,        Entero_Cero,        Entero_Cero,        Par_EmpresaID,  	Aud_Usuario,
	                    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion
					);
			    END IF;
			END IF;

		    IF (Var_BanderaPro	= '1' AND Var_SaldoCapVenNExi >= Mon_MinPago) THEN
			    CALL  CONTACREDITOPRO (
			        Var_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,        Var_FechaSistema,
			        Var_FecApl,         Var_SaldoCapVenNExi,    Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
			        Var_SubClasifID,    Var_SucCliente,         Var_DesConPoliza,        Var_DesConPoliza,        AltaPoliza_NO,
			        Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_SI,      Con_CapVenNoExi,
			        Mov_CapVenNoExi,    Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
			        Cadena_Vacia,       /*Par_SalidaNO,*/
			        Par_NumErr,         Par_ErrMen,             Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
			        Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
			        Aud_NumTransaccion);

			    IF (Par_NumErr <> Entero_Cero)THEN
			        SET Var_DescripError := CONCAT(Par_NumErr , " - ", Par_ErrMen);
			       	INSERT INTO TMPHISCREDITOSVENTACAR (
						Fecha,				CreditoID,          Tipo,				Motivo,             SaldoCapVigente,
	                    SaldoCapAtrasa,     SaldoInteresOrd,    SaldoInteresAtr,  	SaldoInteresPro,    SaldoMoratorios,
		                SalMoraVencido,		SalMoraCarVen,		SaldoComFaltaPa,	SaldoOtrasComis,	SaldoCapVenNExi,
		                SaldoCapVencido,	SaldoInteresVen,	SaldoIntNoConta,	EmpresaID,			Usuario,
		                FechaActual,        DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)
					VALUES(
	                    Var_FechaSistema,	Var_CreditoID,      Var_Fallido,		Var_DescripError,   Entero_Cero,
	                    Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,
	                    Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,
	                    Entero_Cero,        Entero_Cero,        Entero_Cero,        Par_EmpresaID,  	Aud_Usuario,
	                    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion
					);
			    END IF;
		  	END IF;

			IF (Var_BanderaPro	= '1' AND Var_SaldoMoratorios >= Mon_MinPago) THEN
				CALL  CONTACREDITOPRO (
					Var_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,        Var_FechaSistema,
					Var_SubClasifID,    Var_SucCliente,         Var_DesConPoliza,        Var_DesConPoliza,        AltaPoliza_NO,
					Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_SI,      Con_CtaOrdMor,
					Mov_Moratorio,      Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
					Cadena_Vacia,       /*Par_SalidaNO,*/
					Par_NumErr,         Par_ErrMen,             Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
					Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
					Aud_NumTransaccion);

				IF (Par_NumErr <> Entero_Cero)THEN
					SET Var_DescripError := CONCAT(Par_NumErr , " - ", Par_ErrMen);
					INSERT INTO TMPHISCREDITOSVENTACAR (
						Fecha,				CreditoID,          Tipo,				Motivo,             SaldoCapVigente,
						SaldoCapAtrasa,     SaldoInteresOrd,    SaldoInteresAtr,  	SaldoInteresPro,    SaldoMoratorios,
						SalMoraVencido,		SalMoraCarVen,		SaldoComFaltaPa,	SaldoOtrasComis,	SaldoCapVenNExi,
						SaldoCapVencido,	SaldoInteresVen,	SaldoIntNoConta,	EmpresaID,			Usuario,
						FechaActual,        DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)
					VALUES(
						Var_FechaSistema,	Var_CreditoID,      Var_Fallido,		Var_DescripError,   Entero_Cero,
						Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,
						Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,
						Entero_Cero,        Entero_Cero,        Entero_Cero,        Par_EmpresaID,  	Aud_Usuario,
						Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion
					);
				END IF;

				CALL  CONTACREDITOPRO (
					Var_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,        Var_FechaSistema,
					Var_FecApl,         Var_SaldoMoratorios,    Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
					Var_SubClasifID,    Var_SucCliente,         Var_DesConPoliza,        Var_DesConPoliza,        AltaPoliza_NO,
					Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_NO,      Con_CorIntMor,
					Mov_Moratorio,      Nat_Cargo,              AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
					Cadena_Vacia,       /*Par_SalidaNO,*/
					Par_NumErr,         Par_ErrMen,             Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
					Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
					Aud_NumTransaccion);

				IF (Par_NumErr <> Entero_Cero)THEN
					SET Var_DescripError := CONCAT(Par_NumErr , " - ", Par_ErrMen);
					INSERT INTO TMPHISCREDITOSVENTACAR (
						Fecha,				CreditoID,          Tipo,				Motivo,             SaldoCapVigente,
						SaldoCapAtrasa,     SaldoInteresOrd,    SaldoInteresAtr,  	SaldoInteresPro,    SaldoMoratorios,
						SalMoraVencido,		SalMoraCarVen,		SaldoComFaltaPa,	SaldoOtrasComis,	SaldoCapVenNExi,
						SaldoCapVencido,	SaldoInteresVen,	SaldoIntNoConta,	EmpresaID,			Usuario,
						FechaActual,        DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)
					VALUES(
						Var_FechaSistema,	Var_CreditoID,      Var_Fallido,		Var_DescripError,   Entero_Cero,
						Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,
						Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,
						Entero_Cero,        Entero_Cero,        Entero_Cero,        Par_EmpresaID,  	Aud_Usuario,
						Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion
					);
				END IF;

			END IF; -- FIN DE Var_SaldoMoratorios >= Mon_MinPago

			IF (Var_BanderaPro	= '1' AND  Var_SalMoraVencido >= Mon_MinPago) THEN
				CALL  CONTACREDITOPRO (
				    Par_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,        Var_FechaSistema,
				    Var_FecApl,         Var_SalMoraVencido,     Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
				    Var_SubClasifID,    Var_SucCliente,         Des_Castigo,        Des_Castigo,        AltaPoliza_NO,
				    Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_SI,      Con_MoraVencido,
				    Mov_MoraVencido,    Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
				    Cadena_Vacia,       Par_NumErr,             Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,
				    Cadena_Vacia,       Aud_Usuario,            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
				    Var_SucursalCred,   Aud_NumTransaccion);

				IF (Par_NumErr <> Entero_Cero)THEN
					SET Var_DescripError := CONCAT(Par_NumErr , " - ", Par_ErrMen);
					INSERT INTO TMPHISCREDITOSVENTACAR (
						Fecha,				CreditoID,          Tipo,				Motivo,             SaldoCapVigente,
						SaldoCapAtrasa,     SaldoInteresOrd,    SaldoInteresAtr,  	SaldoInteresPro,    SaldoMoratorios,
						SalMoraVencido,		SalMoraCarVen,		SaldoComFaltaPa,	SaldoOtrasComis,	SaldoCapVenNExi,
						SaldoCapVencido,	SaldoInteresVen,	SaldoIntNoConta,	EmpresaID,			Usuario,
						FechaActual,        DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)
					VALUES(
						Var_FechaSistema,	Var_CreditoID,      Var_Fallido,		Var_DescripError,   Entero_Cero,
						Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,
						Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,
						Entero_Cero,        Entero_Cero,        Entero_Cero,        Par_EmpresaID,  	Aud_Usuario,
						Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion
					);
				END IF;
			END IF;



			IF (Var_BanderaPro	= '1' AND Var_SalMoraCarVen >= Mon_MinPago) THEN

				CALL  CONTACREDITOPRO (
				    Var_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,        Var_FechaSistema,
				    Var_FecApl,         Var_SalMoraCarVen,      Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
				    Var_SubClasifID,    Var_SucCliente,         Var_DesConPoliza,        Var_DesConPoliza,        AltaPoliza_NO,
				    Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_SI,      Con_CtaOrdMor,
				    Mov_MoraCarVen,     Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
				    Cadena_Vacia,       Par_NumErr,				Par_ErrMen,			Par_Consecutivo,    Par_EmpresaID,
				    Cadena_Vacia,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,
				    Var_SucursalCred,	Aud_NumTransaccion);

				IF (Par_NumErr <> Entero_Cero)THEN
					SET Var_DescripError := CONCAT(Par_NumErr , " - ", Par_ErrMen);
					INSERT INTO TMPHISCREDITOSVENTACAR (
						Fecha,				CreditoID,          Tipo,				Motivo,             SaldoCapVigente,
						SaldoCapAtrasa,     SaldoInteresOrd,    SaldoInteresAtr,  	SaldoInteresPro,    SaldoMoratorios,
						SalMoraVencido,		SalMoraCarVen,		SaldoComFaltaPa,	SaldoOtrasComis,	SaldoCapVenNExi,
						SaldoCapVencido,	SaldoInteresVen,	SaldoIntNoConta,	EmpresaID,			Usuario,
						FechaActual,        DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)
					VALUES(
						Var_FechaSistema,	Var_CreditoID,      Var_Fallido,		Var_DescripError,   Entero_Cero,
						Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,
						Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,
						Entero_Cero,        Entero_Cero,        Entero_Cero,        Par_EmpresaID,  	Aud_Usuario,
						Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion
						);
				END IF;

				CALL  CONTACREDITOPRO (
				    Var_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,        Var_FechaSistema,
				    Var_FecApl,         Var_SalMoraCarVen,      Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
				    Var_SubClasifID,    Var_SucCliente,         Var_DesConPoliza,        Var_DesConPoliza,        AltaPoliza_NO,
				    Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_NO,      Con_CorIntMor,
				    Mov_MoraCarVen,     Nat_Cargo,              AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
				    Cadena_Vacia,       /*Par_SalidaNO,*/
				    Par_NumErr,         Par_ErrMen,             Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
				    Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
				    Aud_NumTransaccion);

				IF (Par_NumErr <> Entero_Cero)THEN
					SET Var_DescripError := CONCAT(Par_NumErr , " - ", Par_ErrMen);
					INSERT INTO TMPHISCREDITOSVENTACAR (
						Fecha,				CreditoID,          Tipo,				Motivo,             SaldoCapVigente,
						SaldoCapAtrasa,     SaldoInteresOrd,    SaldoInteresAtr,  	SaldoInteresPro,    SaldoMoratorios,
						SalMoraVencido,		SalMoraCarVen,		SaldoComFaltaPa,	SaldoOtrasComis,	SaldoCapVenNExi,
						SaldoCapVencido,	SaldoInteresVen,	SaldoIntNoConta,	EmpresaID,			Usuario,
						FechaActual,        DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)
					VALUES(
						Var_FechaSistema,	Var_CreditoID,      Var_Fallido,		Var_DescripError,   Entero_Cero,
						Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,
						Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,
						Entero_Cero,        Entero_Cero,        Entero_Cero,        Par_EmpresaID,  	Aud_Usuario,
						Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion
						);
				END IF;
		  	END IF;-- FIN Var_SalMoraCarVen >= Mon_MinPago


			IF (Var_BanderaPro	= '1' AND Var_SaldoIntNoConta >= Mon_MinPago) THEN
				CALL  CONTACREDITOPRO (
					Var_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,        Var_FechaSistema,
					Var_FecApl,         Var_SaldoIntNoConta,    Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
					Var_SubClasifID,    Var_SucCliente,         Var_DesConPoliza,        Var_DesConPoliza,        AltaPoliza_NO,
					Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_SI,      Con_CtaOrdInt,
					Mov_IntNoConta,     Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
					Cadena_Vacia,       Par_NumErr,				Par_ErrMen,			Par_Consecutivo,    Par_EmpresaID,
					Cadena_Vacia,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,
					Var_SucursalCred,	Aud_NumTransaccion);

			    IF (Par_NumErr <> Entero_Cero)THEN
					SET Var_DescripError := CONCAT(Par_NumErr , " - ", Par_ErrMen);
					INSERT INTO TMPHISCREDITOSVENTACAR (
						Fecha,				CreditoID,          Tipo,				Motivo,             SaldoCapVigente,
						SaldoCapAtrasa,     SaldoInteresOrd,    SaldoInteresAtr,  	SaldoInteresPro,    SaldoMoratorios,
						SalMoraVencido,		SalMoraCarVen,		SaldoComFaltaPa,	SaldoOtrasComis,	SaldoCapVenNExi,
						SaldoCapVencido,	SaldoInteresVen,	SaldoIntNoConta,	EmpresaID,			Usuario,
						FechaActual,        DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)
					VALUES(
						Var_FechaSistema,	Var_CreditoID,      Var_Fallido,		Var_DescripError,   Entero_Cero,
						Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,
						Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,
						Entero_Cero,        Entero_Cero,        Entero_Cero,        Par_EmpresaID,  	Aud_Usuario,
						Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion
						);
				END IF;

			    CALL  CONTACREDITOPRO (
			        Var_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,        Var_FechaSistema,
			        Var_FecApl,         Var_SaldoIntNoConta,    Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
			        Var_SubClasifID,    Var_SucCliente,         Var_DesConPoliza,        Var_DesConPoliza,        AltaPoliza_NO,
			        Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_NO,      Con_CorIntOrd,
			        Mov_IntNoConta,     Nat_Cargo,              AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
			        Cadena_Vacia,       Par_NumErr,				Par_ErrMen,			Par_Consecutivo,    Par_EmpresaID,
			        Cadena_Vacia,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,
			        Var_SucursalCred,	Aud_NumTransaccion);

			    IF (Par_NumErr <> Entero_Cero)THEN
					SET Var_DescripError := CONCAT(Par_NumErr , " - ", Par_ErrMen);
					INSERT INTO TMPHISCREDITOSVENTACAR (
						Fecha,				CreditoID,          Tipo,				Motivo,             SaldoCapVigente,
						SaldoCapAtrasa,     SaldoInteresOrd,    SaldoInteresAtr,  	SaldoInteresPro,    SaldoMoratorios,
						SalMoraVencido,		SalMoraCarVen,		SaldoComFaltaPa,	SaldoOtrasComis,	SaldoCapVenNExi,
						SaldoCapVencido,	SaldoInteresVen,	SaldoIntNoConta,	EmpresaID,			Usuario,
						FechaActual,        DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)
					VALUES(
						Var_FechaSistema,	Var_CreditoID,      Var_Fallido,		Var_DescripError,   Entero_Cero,
						Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,
						Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,
						Entero_Cero,        Entero_Cero,        Entero_Cero,        Par_EmpresaID,  	Aud_Usuario,
						Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion
						);
				END IF;
	  		END IF; -- fin Var_SaldoIntNoConta >= Mon_MinPago

		    IF (Var_BanderaPro	= '1' AND Var_AccesoriosVal > Entero_Cero) THEN
		        CALL  CONTACREDITOPRO (
		            Var_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,        Var_FechaSistema,
		            Var_FecApl,         Var_AccesoriosVal,	Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
		            Var_SubClasifID,    Var_SucCliente,     Var_DesConPoliza,        Var_DesConPoliza,        AltaPoliza_NO,
		            Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,      Con_CorCasComi,
		            Entero_Cero,        Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
		            Cadena_Vacia,       Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,
		            Cadena_Vacia,		Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
		            Var_SucursalCred,	Aud_NumTransaccion);

		        IF (Par_NumErr <> Entero_Cero)THEN
					SET Var_DescripError := CONCAT(Par_NumErr , " - ", Par_ErrMen);
					INSERT INTO TMPHISCREDITOSVENTACAR (
						Fecha,				CreditoID,          Tipo,				Motivo,             SaldoCapVigente,
						SaldoCapAtrasa,     SaldoInteresOrd,    SaldoInteresAtr,  	SaldoInteresPro,    SaldoMoratorios,
						SalMoraVencido,		SalMoraCarVen,		SaldoComFaltaPa,	SaldoOtrasComis,	SaldoCapVenNExi,
						SaldoCapVencido,	SaldoInteresVen,	SaldoIntNoConta,	EmpresaID,			Usuario,
						FechaActual,        DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)
					VALUES(
						Var_FechaSistema,	Var_CreditoID,      Var_Fallido,		Var_DescripError,   Entero_Cero,
						Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,
						Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,
						Entero_Cero,        Entero_Cero,        Entero_Cero,        Par_EmpresaID,  	Aud_Usuario,
						Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion
						);
				END IF;

		        CALL  CONTACREDITOPRO (
		            Var_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,        Var_FechaSistema,
		            Var_FecApl,         Var_AccesoriosVal,     Var_MonedaID,       Var_ProdCreID,     Var_ClasifCre,
		            Var_SubClasifID,    Var_SucCliente,     Var_DesConPoliza,        Var_DesConPoliza,        AltaPoliza_NO,
		            Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,      Con_OrdCasComi,
		            Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
		            Cadena_Vacia,       /*Par_SalidaNO,*/
		            Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
		            Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
		            Aud_NumTransaccion);

		        IF (Par_NumErr <> Entero_Cero)THEN
					SET Var_DescripError := CONCAT(Par_NumErr , " - ", Par_ErrMen);
					INSERT INTO TMPHISCREDITOSVENTACAR (
						Fecha,				CreditoID,          Tipo,				Motivo,             SaldoCapVigente,
						SaldoCapAtrasa,     SaldoInteresOrd,    SaldoInteresAtr,  	SaldoInteresPro,    SaldoMoratorios,
						SalMoraVencido,		SalMoraCarVen,		SaldoComFaltaPa,	SaldoOtrasComis,	SaldoCapVenNExi,
						SaldoCapVencido,	SaldoInteresVen,	SaldoIntNoConta,	EmpresaID,			Usuario,
						FechaActual,        DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)
					VALUES(
						Var_FechaSistema,	Var_CreditoID,      Var_Fallido,		Var_DescripError,   Entero_Cero,
						Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,
						Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,
						Entero_Cero,        Entero_Cero,        Entero_Cero,        Par_EmpresaID,  	Aud_Usuario,
						Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion
						);
				END IF;
		    END IF; -- fin Var_AccesoriosVal > Entero_Cero

			IF (Var_BanderaPro	= '1' AND Var_SaldoInteresVen >= Mon_MinPago) THEN
				CALL  CONTACREDITOPRO (
				Var_CreditoID,      Var_AmortizacionID,     Entero_Cero,        Entero_Cero,        Var_FechaSistema,
				Var_FecApl,         Var_SaldoInteresVen,    Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
				Var_SubClasifID,    Var_SucCliente,         Var_DesConPoliza,        Var_DesConPoliza,        AltaPoliza_NO,
				Entero_Cero,        Par_PolizaID,           AltaPolCre_SI,      AltaMovCre_SI,      Con_IntVencido,
				Mov_IntVencido,     Nat_Abono,              AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
				Cadena_Vacia,       /*Par_SalidaNO,*/
				Par_NumErr,         Par_ErrMen,             Par_Consecutivo,    Par_EmpresaID,      Cadena_Vacia,
				Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,     Var_SucursalCred,
				Aud_NumTransaccion);

				IF (Par_NumErr <> Entero_Cero)THEN
					SET Var_DescripError := CONCAT(Par_NumErr , " - ", Par_ErrMen);
					INSERT INTO TMPHISCREDITOSVENTACAR (
						Fecha,				CreditoID,          Tipo,				Motivo,             SaldoCapVigente,
						SaldoCapAtrasa,     SaldoInteresOrd,    SaldoInteresAtr,  	SaldoInteresPro,    SaldoMoratorios,
						SalMoraVencido,		SalMoraCarVen,		SaldoComFaltaPa,	SaldoOtrasComis,	SaldoCapVenNExi,
						SaldoCapVencido,	SaldoInteresVen,	SaldoIntNoConta,	EmpresaID,			Usuario,
						FechaActual,        DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)
					VALUES(
						Var_FechaSistema,	Var_CreditoID,      Var_Fallido,		Var_DescripError,   Entero_Cero,
						Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,
						Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,
						Entero_Cero,        Entero_Cero,        Entero_Cero,        Par_EmpresaID,  	Aud_Usuario,
						Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion
						);
				END IF;
			END IF; -- fi Var_SaldoInteresVen >= Mon_MinPago

			IF (Var_BanderaPro	= '1') THEN
				-- Las amortizaciones se marcarán como pagadas y la fecha de liquidación tendrá la fecha del sistema.
				UPDATE AMORTICREDITO SET
		    		Estatus     	= Esta_Pagado,
		    		FechaLiquida    = Var_FechaSistema,

				    Usuario			= Aud_Usuario,
				    FechaActual 	= Aud_FechaActual,
				    DireccionIP 	= Aud_DireccionIP,
				    ProgramaID  	= Aud_ProgramaID,
				    Sucursal    	= Aud_Sucursal,
				    NumTransaccion  = Aud_NumTransaccion
		    	WHERE CreditoID     = Var_CreditoID
		    	and AmortizacionID = Var_AmortizacionID
		      		AND Estatus   != Esta_Pagado;

		      	SET Var_DescripError := "PROCESADO ";
				INSERT INTO TMPHISCREDITOSVENTACAR (
					Fecha,              CreditoID,          Tipo,					Motivo,             SaldoCapVigente,
	                SaldoCapAtrasa,     SaldoInteresOrd,    SaldoInteresAtr,		SaldoInteresPro,    SaldoMoratorios,
	                SalMoraVencido,		SalMoraCarVen,		SaldoComFaltaPa,		SaldoOtrasComis,	SaldoCapVenNExi,
	                SaldoCapVencido,	SaldoInteresVen,	SaldoIntNoConta,		EmpresaID,			Usuario,
	                FechaActual,        DireccionIP,		ProgramaID,         	Sucursal,			NumTransaccion)
				VALUES(
					Var_FechaSistema,   Var_CreditoID,      Var_Procesado,			Var_DescripError,   Var_SaldoCapVigente,
	                Var_SaldoCapAtrasa, Var_SaldoInteresOrd,Var_SaldoInteresAtr,	Var_SaldoInteresPro,Var_SaldoMoratorios,
	                Var_SalMoraVencido,	Var_SalMoraCarVen,	Var_SaldoComFaltaPa,	Var_SaldoOtrasComis,Var_SaldoCapVenNExi,
	                Var_SaldoCapVencido,Var_SaldoInteresVen,Var_SaldoIntNoConta,	Par_EmpresaID,  	Aud_Usuario,
	                Aud_FechaActual,    Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,       Aud_NumTransaccion
				);


			  	-- ACUMULABLES PARA CIFRAS CONTROL
				SET Var_VendidoCapVig  		:= Var_VendidoCapVig 		+ Var_SaldoCapVigente;
				SET Var_VendidoCapAtr		:= Var_VendidoCapAtr 		+ Var_SaldoCapAtrasa;
				SET Var_VendidoIntOrd		:= Var_VendidoIntOrd 		+ Var_SaldoInteresOrd;
				SET Var_VendidoIntAtr		:= Var_VendidoIntAtr 		+ Var_SaldoInteresAtr;
				SET Var_VendidoIntPro		:= Var_VendidoIntPro 		+ Var_SaldoInteresPro;
				SET Var_VendidoMoratorio	:= Var_VendidoMoratorio 	+ Var_SaldoMoratorios;
				SET Var_VendidoMoraVen		:= Var_VendidoMoraVen 		+ Var_SalMoraVencido;
				SET Var_VendidoMoraCarVe	:= Var_VendidoMoraCarVe 	+ Var_SalMoraCarVen;
				SET Var_VendidoComFalPa		:= Var_VendidoComFalPa 		+ Var_SaldoComFaltaPa;
				SET Var_VendidoOtraCom		:= Var_VendidoOtraCom 		+ Var_SaldoOtrasComis;
				SET Var_VendidoCapVenNEx	:= Var_VendidoCapVenNEx 	+ Var_SaldoCapVenNExi;
				SET Var_VendidoCapVencid	:= Var_VendidoCapVencid		+ Var_SaldoCapVencido;
				SET Var_VendidoIntVencid	:= Var_VendidoIntVencid		+ Var_SaldoInteresVen;
				SET Var_VendidoIntNoConta	:= Var_VendidoIntNoConta	+ Var_SaldoIntNoConta;
				SET Var_VendidoAccesor		:= Var_VendidoAccesor		+ Var_AccesoriosVal;

			END IF;
      	END IF;


		END LOOP CICLOAmor;END;
		CLOSE CURSORAMORTI;

		SET Var_CreditoID := Var_CreditoIDAmor;

		IF (Var_BanderaPro	= '1') THEN
			-- El crédito se marcará con estatus "X".
			UPDATE CREDITOS SET
			    Estatus         = Esta_Vendido,
			    FechTerminacion = Var_FechaSistema,

			    Usuario			= Aud_Usuario,
			    FechaActual 	= Aud_FechaActual,
			    DireccionIP 	= Aud_DireccionIP,
			    ProgramaID  	= Aud_ProgramaID,
			    Sucursal    	= Aud_Sucursal,
			    NumTransaccion  = Aud_NumTransaccion
			WHERE CreditoID = Var_CreditoID;
		END IF;


		-- se cancelan las reservas  --------------------------------------------------------------------------------------
		SELECT  MAX(Fecha) INTO Var_FecAntRes FROM CALRESCREDITOS WHERE AplicaConta = Si_AplicaConta AND CreditoID = Var_CreditoID;
		SET Var_FecAntRes := IFNULL(Var_FecAntRes, Fecha_Vacia);

		IF(Var_FecAntRes != Fecha_Vacia) THEN
		    SELECT SUM(SaldoResInteres), SUM(SaldoResCapital) INTO Var_ResInteres, Var_ResCapital
		        FROM CALRESCREDITOS
		        WHERE AplicaConta = Si_AplicaConta
		          AND CreditoID = Var_CreditoID
		          AND Fecha = Var_FecAntRes
		    GROUP BY CreditoID;

		    SET Var_ResCapital := IFNULL(Var_ResCapital, Entero_Cero);
		    SET Var_ResInteres := IFNULL(Var_ResInteres, Entero_Cero);
		ELSE
			SET Var_ResCapital := Entero_Cero;
		    SET Var_ResInteres := Entero_Cero;
		END IF;

		-- SE CANCELA LA RESERVA DE CAPITAL
	  	SET Var_MonReservar 	:= Var_ResCapital;
		SET Var_ConceptoCarID	:= Con_EstBalance;

		IF (Var_BanderaPro	= '1' AND Var_MonReservar > Entero_Cero  AND Var_CreEstatus <> Esta_Vencido)  THEN
			CALL  CONTACREDITOPRO (
	        Var_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,        Var_FechaSistema,
	        Var_FecApl,         Var_MonReservar,    Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
	        Var_SubClasifID,    Var_SucCliente,     Var_DesConPoliza,	Var_DesConPoliza,	AltaPoliza_NO,
	        Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,      Var_ConceptoCarID ,
	        Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
	        Cadena_Vacia,       Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,
	        Cadena_Vacia, 		Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
	        Var_SucursalCred,	Aud_NumTransaccion);

		    IF (Par_NumErr <> Entero_Cero)THEN
				SET Var_DescripError := CONCAT(Par_NumErr , " - ", Par_ErrMen);
		       	INSERT INTO TMPHISCREDITOSVENTACAR (
					Fecha,				CreditoID,          Tipo,				Motivo,             SaldoCapVigente,
                    SaldoCapAtrasa,     SaldoInteresOrd,    SaldoInteresAtr,  	SaldoInteresPro,    SaldoMoratorios,
	                SalMoraVencido,		SalMoraCarVen,		SaldoComFaltaPa,	SaldoOtrasComis,	SaldoCapVenNExi,
	                SaldoCapVencido,	SaldoInteresVen,	SaldoIntNoConta,	EmpresaID,			Usuario,
	                FechaActual,        DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)
				VALUES(
                    Var_FechaSistema,	Var_CreditoID,      Var_Fallido,		Var_DescripError,   Entero_Cero,
                    Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,
                    Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,
                    Entero_Cero,        Entero_Cero,        Entero_Cero,        Par_EmpresaID,  	Aud_Usuario,
                    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion
				);
				SET Var_BanderaPro	:= '2';
		    END IF;
  		END IF;

  		IF (Var_BanderaPro	= '1' AND Var_CreEstatus <> Esta_Vencido) THEN
  			-- SE CANCELA LA RESERVA DE INTERES
			SET Var_MonReservar := Var_ResInteres;

		    SET Var_ConceptoCarID     := Con_EstBalanceInt;
		    IF(Var_MonReservar > Entero_Cero) THEN
		    	CALL  CONTACREDITOPRO (
			        Var_CreditoID,      Entero_Cero,        Entero_Cero,        Entero_Cero,        Var_FechaSistema,
			        Var_FecApl,         Var_MonReservar,    Var_MonedaID,       Var_ProdCreID,      Var_ClasifCre,
			        Var_SubClasifID,    Var_SucCliente,     Var_DesConPoliza,	Var_DesConPoliza,	AltaPoliza_NO,
			        Entero_Cero,        Par_PolizaID,       AltaPolCre_SI,      AltaMovCre_NO,      Var_ConceptoCarID ,
			        Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
			        Cadena_Vacia,       Par_NumErr,         Par_ErrMen,         Par_Consecutivo,    Par_EmpresaID,
			        Cadena_Vacia,		Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
			        Var_SucursalCred,	Aud_NumTransaccion);

			    IF (Par_NumErr <> Entero_Cero)THEN
					SET Var_DescripError := CONCAT(Par_NumErr , " - ", Par_ErrMen);
			       	INSERT INTO TMPHISCREDITOSVENTACAR (
						Fecha,				CreditoID,          Tipo,				Motivo,             SaldoCapVigente,
                        SaldoCapAtrasa,     SaldoInteresOrd,    SaldoInteresAtr,  	SaldoInteresPro,    SaldoMoratorios,
		                SalMoraVencido,		SalMoraCarVen,		SaldoComFaltaPa,	SaldoOtrasComis,	SaldoCapVenNExi,
		                SaldoCapVencido,	SaldoInteresVen,	SaldoIntNoConta,	EmpresaID,			Usuario,
		                FechaActual,        DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)
					VALUES(
                        Var_FechaSistema,	Var_CreditoID,      Var_Fallido,		Var_DescripError,   Entero_Cero,
                        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,
                        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,
                        Entero_Cero,        Entero_Cero,        Entero_Cero,        Par_EmpresaID,  	Aud_Usuario,
                        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion
					);
					SET Var_BanderaPro	:= '2';
			    END IF;
		  	END IF;
  		END IF;

  		IF (Var_BanderaPro	= '1') THEN
  			IF(Var_CreEstatus <> Esta_Vencido)  THEN
  				SET Var_ValorReserva	:= (Var_ResCapital + Var_ResInteres);
				SET Var_ValorVendido	:= Var_VendidoCapVig +Var_VendidoCapAtr+Var_VendidoIntOrd+Var_VendidoIntAtr+Var_VendidoIntPro+
					/*Var_VendidoMoratorio+*/Var_VendidoMoraVen+Var_VendidoMoraCarVe+Var_VendidoComFalPa+Var_VendidoOtraCom+
						Var_VendidoCapVenNEx+Var_VendidoCapVencid+Var_VendidoIntVencid+Var_VendidoIntNoConta+Var_VendidoAccesor;


				IF(Var_ValorReserva > Var_ValorVendido) THEN
					SET Var_PerdidaCesion	:= Var_ValorReserva - Var_ValorVendido;
				ELSE
					SET Var_PerdidaCesion	:= Var_ValorVendido  - Var_ValorReserva;
				END IF;
  			ELSE
				SET Var_PerdidaCesion	:= Var_VendidoCapVig +Var_VendidoCapAtr+Var_VendidoIntOrd+Var_VendidoIntAtr+Var_VendidoIntPro+
					Var_VendidoMoratorio+Var_VendidoMoraVen+Var_VendidoMoraCarVe+Var_VendidoComFalPa+Var_VendidoOtraCom+
						Var_VendidoCapVenNEx+Var_VendidoCapVencid+Var_VendidoIntVencid+Var_VendidoIntNoConta+Var_VendidoAccesor;
  			END IF;

		  	IF (Var_PerdidaCesion >= Mon_MinPago) THEN
			    CALL DETALLEPOLIZAALT(
    				Par_EmpresaID,		Par_PolizaID,			Var_FechaSistema,	Var_SucursalCred,	Var_CuentaConta,
    				Var_CreditoID, 		Var_MonedaID,			Var_PerdidaCesion,	Entero_Cero,		Var_DesConPoliza,
    				Var_CreditoID,		Aud_ProgramaID,			11, 				'',					Entero_Cero,
    				'',					'N', 					Par_NumErr,			Par_ErrMen,			Aud_Usuario,
    				Aud_FechaActual,	Aud_DireccionIP,    	Aud_ProgramaID,		Var_SucursalCred,	Aud_NumTransaccion);

			    IF (Par_NumErr <> Entero_Cero)THEN
			        SET Var_DescripError := CONCAT(Par_NumErr , " - ", Par_ErrMen);
			       	INSERT INTO TMPHISCREDITOSVENTACAR (
						Fecha,				CreditoID,          Tipo,				Motivo,             SaldoCapVigente,
                        SaldoCapAtrasa,     SaldoInteresOrd,    SaldoInteresAtr,  	SaldoInteresPro,    SaldoMoratorios,
		                SalMoraVencido,		SalMoraCarVen,		SaldoComFaltaPa,	SaldoOtrasComis,	SaldoCapVenNExi,
		                SaldoCapVencido,	SaldoInteresVen,	SaldoIntNoConta,	EmpresaID,			Usuario,
		                FechaActual,        DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)
					VALUES(
                        Var_FechaSistema,	Var_CreditoID,      Var_Fallido,		Var_DescripError,   Entero_Cero,
                        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,
                        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,        Entero_Cero,
                        Entero_Cero,        Entero_Cero,        Entero_Cero,        Par_EmpresaID,  	Aud_Usuario,
                        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion
					);
					SET Var_BanderaPro	:= '2';
			    END IF;
		  	END IF;
		END IF;

  		IF (Var_BanderaPro	= '1') THEN
			UPDATE CALRESCREDITOS SET
			    SaldoResCapital = Entero_Cero,
			    SaldoResInteres = Entero_Cero
			WHERE AplicaConta = Si_AplicaConta
			  AND CreditoID = Var_CreditoID
			  AND Fecha = Var_FecAntRes;
  		END IF;
		-- FIN DE se cancelan las reservas  --------------------------------------------------------------------------------------

		IF (Var_BanderaPro	= '1') THEN
            SET Var_ContadorExito := Var_ContadorExito + 1;
        ELSE
            SET Var_ContadorFallo := Var_ContadorFallo + 1;
		END IF;

    ELSE
        SET Var_ContadorFallo := Var_ContadorFallo + 1;
	END IF;-- FIN DE BANDERA DE PROCESADOS

	SET Var_BanderaPro	:= '1';
END LOOP CICLO;
END;
CLOSE CURSORVENTACARTERA;

INSERT INTO HISCREDITOSVENTACAR (
	Fecha, 					CreditoID, 				Tipo,						Motivo,             	SaldoCapVigente,
    SaldoCapAtrasa,     	SaldoInteresOrd,    	SaldoInteresAtr,			SaldoInteresPro,    	SaldoMoratorios,
    SalMoraVencido,			SalMoraCarVen,			SaldoComFaltaPa,			SaldoOtrasComis,		SaldoCapVenNExi,
    SaldoCapVencido,		SaldoInteresVen,		SaldoIntNoConta,			EmpresaID,				Usuario,
    FechaActual,        	DireccionIP,			ProgramaID,         		Sucursal,				NumTransaccion)
SELECT
	MAX(Fecha),				MAX(CreditoID),			MAX(Tipo), 			    	MAX(Motivo),			SUM(SaldoCapVigente),
    SUM(SaldoCapAtrasa),    SUM(SaldoInteresOrd),	SUM(SaldoInteresAtr),    	SUM(SaldoInteresPro),	SUM(SaldoMoratorios),
    SUM(SalMoraVencido),	SUM(SalMoraCarVen),		SUM(SaldoComFaltaPa),		SUM(SaldoOtrasComis),	SUM(SaldoCapVenNExi),
    SUM(SaldoCapVencido),	SUM(SaldoInteresVen),	SUM(SaldoIntNoConta),		MAX(EmpresaID),			MAX(Usuario),
    MAX(FechaActual),		MAX(DireccionIP),		MAX(ProgramaID),         	MAX(Sucursal),			MAX(NumTransaccion)
FROM TMPHISCREDITOSVENTACAR
GROUP BY CreditoID;

INSERT INTO CIFRASCREDITOSVENTACAR (
	Fecha, 					NumProcesados,			NumExitosos,			NumFallidos,		SaldoCapVigente,
	SaldoCapAtrasa, 		SaldoInteresOrd,		SaldoInteresAtr,		SaldoInteresPro,	SaldoMoratorios,
    SalMoraVencido,			SalMoraCarVen,			SaldoComFaltaPa,		SaldoOtrasComis,	SaldoCapVenNExi,
    SaldoCapVencido,		SaldoInteresVen,		SaldoIntNoConta,		EmpresaID,			Usuario,
    FechaActual,        	DireccionIP,			ProgramaID,         	Sucursal,			NumTransaccion)
SELECT
	Var_FechaSistema,	Var_ContadorExito+ Var_ContadorFallo,				Var_ContadorExito,	Var_ContadorFallo,	SUM(SaldoCapVigente),
    SUM(SaldoCapAtrasa),    SUM(SaldoInteresOrd),	SUM(SaldoInteresAtr),    	SUM(SaldoInteresPro),	SUM(SaldoMoratorios),
    SUM(SalMoraVencido),	SUM(SalMoraCarVen),		SUM(SaldoComFaltaPa),		SUM(SaldoOtrasComis),	SUM(SaldoCapVenNExi),
    SUM(SaldoCapVencido),	SUM(SaldoInteresVen),	SUM(SaldoIntNoConta),		MAX(EmpresaID),			MAX(Usuario),
    MAX(FechaActual),		MAX(DireccionIP),		MAX(ProgramaID),         	MAX(Sucursal),			MAX(NumTransaccion)
FROM TMPHISCREDITOSVENTACAR
;


SET Par_NumErr      := '000';
SET Par_ErrMen      := CONCAT('Proceso Ejecutado Exitosamente: ');

END ManejoErrores;

SELECT	MAX(Fecha) AS Fecha,					MAX(CreditoID)as CreditoID,				MAX(Tipo) as Tipo, 			    		MAX(Motivo)as Motivo,					SUM(SaldoCapVigente)as SaldoCapVigente,
	    SUM(SaldoCapAtrasa) as SaldoCapAtrasa,	SUM(SaldoInteresOrd)as SaldoInteresOrd,	SUM(SaldoInteresAtr)as SaldoInteresAtr,	SUM(SaldoInteresPro)as SaldoInteresPro,	SUM(SaldoMoratorios)as SaldoMoratorios,
	    SUM(SalMoraVencido)as SalMoraVencido,	SUM(SalMoraCarVen)as SalMoraCarVen,		SUM(SaldoComFaltaPa)as SaldoComFaltaPa,	SUM(SaldoOtrasComis)as SaldoOtrasComis,	SUM(SaldoCapVenNExi)as SaldoCapVenNExi,
	    SUM(SaldoCapVencido)as SaldoCapVencido,	SUM(SaldoInteresVen)as SaldoInteresVen,	SUM(SaldoIntNoConta)as SaldoIntNoConta,	MAX(EmpresaID)as EmpresaID,				MAX(Usuario)as Usuario,
	    MAX(FechaActual) as FechaActual,		MAX(DireccionIP)as DireccionIP,			MAX(ProgramaID)as ProgramaID,         	MAX(Sucursal)as Sucursal,				MAX(NumTransaccion)as NumTransaccion
	FROM TMPHISCREDITOSVENTACAR
	WHERE Fecha = Var_FechaSistema
GROUP BY CreditoID;

SELECT
	Fecha, 				NumProcesados,			NumExitosos,		NumFallidos,		SaldoCapVigente,
	SaldoCapAtrasa, 	SaldoInteresOrd,		SaldoInteresAtr,	SaldoInteresPro,	SaldoMoratorios,
    SalMoraVencido,		SalMoraCarVen,			SaldoComFaltaPa,	SaldoOtrasComis,	SaldoCapVenNExi,
    SaldoCapVencido,	SaldoInteresVen			SaldoIntNoConta,	EmpresaID,			Usuario,
    FechaActual,        DireccionIP,			ProgramaID,         Sucursal,			NumTransaccion
	FROM CIFRASCREDITOSVENTACAR
		WHERE Fecha = Var_FechaSistema;

TRUNCATE  TMPHISCREDITOSVENTACAR;

END TerminaStore$$