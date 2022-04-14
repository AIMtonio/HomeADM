-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRWFONDEOAPGPRO
DELIMITER ;

DROP PROCEDURE IF EXISTS CRWFONDEOAPGPRO;

DELIMITER $$

CREATE PROCEDURE `CRWFONDEOAPGPRO`(
	Par_CreditoID			BIGINT(12),		-- ID del credito.
    Par_GaranCapital		CHAR(1),        -- Si se garantiza Capital
	Par_GaranInteres		CHAR(1),        -- Si Se garantiza Interes
    Par_AltaEncPoliza		CHAR(1),        -- Alta poliza?
	Par_PolizaID			BIGINT(20),     -- PolizaID

	Par_Salida				CHAR(1),        -- Salida S/N
	INOUT Par_NumErr		INT(11),		-- Numero de validación.
	INOUT Par_ErrMen		VARCHAR(400),	-- Mensaje de validación.
	/* Parámetros de Auditoría.*/
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),

	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore:BEGIN

-- declaracion de variables
DECLARE	Var_CuentaAhoID			BIGINT(12);
DECLARE	Var_ClienteID			INT(11);
DECLARE Var_SaldoCapVig			DECIMAL(14,4);
DECLARE Var_SaldoCapExi			DECIMAL(14,4);
DECLARE Var_MonedaID			INT(11);
DECLARE Var_FechaSistema		DATE;
DECLARE Var_SolFondeoID			BIGINT(20);
DECLARE Var_FondeoIdStr			VARCHAR(200);
DECLARE Var_PolizaID			BIGINT(20);
DECLARE Var_AmortizaID			INT(4);
DECLARE Var_SaldoInteres		DECIMAL(14,4);
DECLARE Var_FechaVencimiento	DATE;
DECLARE	Var_InteresAcum			DECIMAL(14,4);
DECLARE	Var_RetencAcum			DECIMAL(14,4);
DECLARE	Var_NumRetMes			INT;
DECLARE Var_InteresAplGar		DECIMAL(14,4);
DECLARE Var_MontoAplInt			DECIMAL(14,4);
DECLARE	Aho_MovPago				VARCHAR(4);
DECLARE Mov_Capita				INT(11);
DECLARE Con_Capita				INT(11);
DECLARE Var_CapitalAplGar		DECIMAL(14,2);
DECLARE	Var_MonRetener			DECIMAL(14,2);
DECLARE	Var_PagaISR				CHAR(1);
DECLARE Var_CredFondeo			BIGINT(12);

-- Declaracion de constantes
DECLARE Entero_Cero				INT(11);
DECLARE Cadena_Vacia			CHAR(1);
DECLARE Decimal_Cero			DECIMAL;
DECLARE MontoPagoMin			DECIMAL(12,2);

DECLARE SalidaNO				CHAR(1);
DECLARE SalidaSI				CHAR(1);
DECLARE	Nat_Cargo				CHAR(1);
DECLARE	Nat_Abono				CHAR(1);
DECLARE Pol_Automatica			CHAR(1);
DECLARE	PagaISR_SI				CHAR(1);
DECLARE PolizaAhoSI				CHAR(1);
DECLARE StringSI				CHAR(1);
DECLARE Consecutivo				INT(11);

DECLARE AltaEncPolizaSI			CHAR(1);
DECLARE	AltaPolKubo_SI			CHAR(1);
DECLARE	AltaMovKubo_SI			CHAR(1);
DECLARE	AltaMovKubo_NO			CHAR(1);
DECLARE	AltaMovAho_NO			CHAR(1);
DECLARE AltaMovAho_SI   		CHAR(1);
DECLARE	AltaPoliza_NO			CHAR(1);

DECLARE ConceptoContable		INT(11);
DECLARE Con_CtaOrdenCap			INT(11);
DECLARE Con_CorrCtaOrdenCap		INT(11);
DECLARE Con_CtaOrdenInt			INT(11);
DECLARE Con_CorrCtaOrdenInt		INT(11);
DECLARE	Con_CapOrdinario		INT;
DECLARE	Con_CapExigible			INT;
DECLARE	Con_RetInt				INT;
DECLARE	Con_IntDeven			INT;
DECLARE Mov_kuboCapCtaOr		INT(4);
DECLARE Mov_kuboIntCtaOr		INT(4);
DECLARE	Mov_kuboRetInt			INT;
DECLARE	Mov_CapOrdinario 		INT;
DECLARE	Mov_CapExigible 		INT;
DECLARE	Mov_KuboIntPro			INT;

DECLARE ConceptoAho				INT(11);
DECLARE TipoMovAho				CHAR(4);
DECLARE TipoMovAhoInt			CHAR(4);
DECLARE	Aho_PagIntGra			CHAR(4);
DECLARE	Aho_PagIntExe			CHAR(4);
DECLARE	Aho_Capital				CHAR(4);
DECLARE	Aho_RetInteres			CHAR(4);

DECLARE Des_PagInvAPG			VARCHAR(100);
DECLARE Des_PagoCapAPG			VARCHAR(100);
DECLARE DesConcepto				VARCHAR(200);
DECLARE Des_PagoCap				VARCHAR(200);
DECLARE Des_PagoInt				VARCHAR(100);
DECLARE Var_Control				VARCHAR(80);

-- --> Vladimir Jz
DECLARE Var_SalCapCred          DECIMAL(14,6); -- Vladimir Jz
DECLARE Var_SalIntCred          DECIMAL(14,6); -- Vladimir Jz
DECLARE Var_SalAcumCapInv		DECIMAL(14,6);
DECLARE Var_SalAcumIntInv		DECIMAL(14,6);
DECLARE Var_FactorCapital		DECIMAL(14,6); 	-- Proporcion del Saldo de Capital de la inversión con respecto al Credito
DECLARE Var_FactorInteres		DECIMAL(14,6); 	-- Proporcion del Saldo de Interes de la inversión con respecto al  credito.
DECLARE Var_MontoIntGar			DECIMAL(14,6); 	-- Monto del Interes Requerido  realmente como Garantia.
DECLARE Var_SucCliente			INT; 			-- Sucursal del Acreditado. (Para obtener el % de IVA)
DECLARE Var_ProIVAInt			CHAR(1); 		-- Determina si el producto cobra IVA de Interes
DECLARE Var_CliPagaIVA   		CHAR(1); 		-- Determina si paga IVA de Intereses (Credito)
DECLARE Var_IVASucursal			DECIMAL(12,2); 	-- Tasa de IVA de la sucursal del acreditado
DECLARE Var_MontoCapInv			DECIMAL(14,4);	-- Monto de CApital de la Inversión
DECLARE Var_MontoIntInv			DECIMAL(14,4);	-- Monto de CApital de la Inversión
DECLARE Var_MontoGarApl			DECIMAL(14,4);  -- Monto Acumulado de la garantia aplicada por Cuota,
DECLARE Var_CuotaActual			DATE;			-- Bandera, para validar el monto aplicado.
DECLARE Var_NumCuotasInv		INT;			-- Numero de Cuotas de Fondeo para la cuota del credito
DECLARE Var_NumCuota			INT;			-- Numero de Cuota Actual (Contador)
-- Constantes
DECLARE PagaIVA_SI				CHAR(1);
DECLARE Entero_Uno              INT; -- Vladimir Jz

-- <-- |

-- CURSOR para el cargo a cuentas de ahorro.
DECLARE CURSORINVER CURSOR FOR

	SELECT	SolFondeoID,       ClienteID,          CuentaAhoID,        AmortizacionID,     ProvisionAcum,
            RetencionIntAcum,   NumRetirosMes,      SucursalOrigen,     PagaISR,            SaldoInteres ,
            MonedaID,           SaldoCapVigente,    SaldoCapExigible,   FechaVencimiento,	SalCapCred,
			SalIntCred,			SalAcumCapInv,		SalAcumIntInv,		NumCuotasInv
		FROM TMPCURSORGARANTIAS
		WHERE CreditoID = Par_CreditoID
        AND NumTransaccion = Aud_NumTransaccion
		ORDER BY CreditoID,FechaVencimiento ASC;



-- declaracion de constantes
SET Entero_Cero			:= 0;
SET Decimal_Cero		:= 0.0;						-- DECIMAL Cero
SET Consecutivo			:= 0;						-- Consecutivo Cero
SET MontoPagoMin		:= 0.01;					-- Monto de Pago minimo
SET Cadena_Vacia		:= '';						-- Cadena Vacia
SET SalidaNO			:= 'N';						-- salida en Pantalla NO
SET SalidaSI			:= 'S';						-- Salida en Pantalla SI
SET Nat_Cargo       	:= 'C';						-- Naturaleza Cargo
SET Nat_Abono       	:= 'A';						-- Naturaleza Abono
SET PagaISR_SI      	:= 'S';						-- Si Paga ISR
SET StringSI			:= 'S';						-- String SI
SET Pol_Automatica		:= 'A';						-- Poliza automatica

SET AltaEncPolizaSI		:='S';						-- Alta en el encabezado de la poliza SIset AltaEncPolizaSI		:='S';						-- Alta en el encabezado de la poliza SI
SET AltaPolKubo_SI  	:='S';						-- Alta en Poliza kubo SI
SET AltaMovKubo_SI  	:='S';						-- Alta de movimiento de kubo si
SET AltaMovKubo_NO  	:='N';						-- Alta de Movimeinto de kubo no
SET AltaMovAho_SI   	:='S';						-- Alta movimiento de ahorro si
SET AltaMovAho_NO   	:='N';						-- Alta del Movimiento Operativo en Cuenta de Ahorro: NO
SET PolizaAhoSI			:='S';						-- Alta Poliza de ahorro si

SET ConceptoContable	:= 24;						-- Concepto kubo contable de Aplicacion de Inversion e garantia corresponde con CONCEPTOSCONTA
SET Con_CtaOrdenCap		:= 11;						-- concepto kubo cuenta de Orden Capital apg corresponde con CONCEPTOSKUBO
SET Con_CorrCtaOrdenCap	:= 12;						-- concepto kubo correlativa cuenta de Orden capital apg corresponde con CONCEPTOSKUBO
SET Con_CtaOrdenInt		:= 13;						-- concepto kubo cuenta de Orden Interes apg corresponde con CONCEPTOSKUBO
SET Con_CorrCtaOrdenInt	:= 14;						-- concepto kubo correlativa cuenta de Orden Interes apg corresponde con CONCEPTOSKUBO
SET Con_CapOrdinario	:= 1;						-- concepto kubo Capital Vigente u Ordinario
SET Con_CapExigible		:= 2;						-- concepto kubo Capital Exigible o en Atraso
SET Con_RetInt      	:= 5;						-- Concepto kubo Retencion de interes interes
SET Con_IntDeven   	 	:= 8;						-- Concepto kubo interes devengado
SET Mov_CapOrdinario 	:= 1;						-- Movimiento kubo Capital Vigente u Ordinario
SET Mov_CapExigible 	:= 2;						-- Movimiento kubo Capital Exigible o en Atras
SET Mov_kuboCapCtaOr	:= 3;						-- Movimiento kubo Capital en cuenta de Orden corresponde con TIPOSMOVSCRW
SET Mov_kuboIntCtaOr	:= 16;						-- Movimiento kubo Interés en cuenta de Orden corresponde con TIPOSMOVSCRW
SET Mov_kuboRetInt		:= 50;						-- Movimiento kubo Retencion de interes TIPOSMOVSCRW
SET Mov_KuboIntPro		:= 10;						-- Movimiento kubo interes ordinario TIPOSMOVSCRW

SET ConceptoAho			:= 1;						-- Concepto de Ahorro Capital corresponde con CONCEPTOSAHORRO
SET TipoMovAho			:= '86';       				-- Movimiento de ahorro Aplicacion Garantia de Capital en Garantia TIPOSMOVSAHO
SET TipoMovAhoInt		:= '87';						-- Movimiento de ahorro Aplicacion Garantia de Interes en Garantia TIPOSMOVSAHO
SET Aho_PagIntGra   	:= '72';						-- Movimiento de ahorro pago de inversion kubo interes gravado TIPOSMOVSAHO
SET Aho_PagIntExe   	:= '73';						-- Movimiento de ahorro pago de inversion kubo interes excento TIPOSMOVSAHO
SET Aho_Capital     	:= '71';			    		-- Movimiento de ahorro pago de inversion Capital TIPOSMOVSAHO
SET Aho_RetInteres  	:= '76';						-- Movimiento de ahorro Retencion de ISR de inversion TIPOSMOVSAHO.

SET Des_PagoCapAPG     	:= 'PAGO DE INVERSION. CAPITAL CO.';
SET Des_PagInvAPG		:= 'PAGO DE INVERSION. INTERES CO.';
SET Des_PagoInt     	:= 'PAGO DE INVERSION. INTERES';
SET Des_PagoCap     	:= 'PAGO DE INVERSION. CAPITAL';
SET DesConcepto			:= 'APLICACION DE GARANTIA'; -- usado para poliza, movimientos de ahorro y movimientos de fondeo.
SET DesConcepto			:= CONCAT('APLICACION DE GARANTIA:',' ',Par_CreditoID); -- usado para poliza, movimientos de ahorro y movimientos de fondeo.



SET Entero_Uno          := 1; 	-- Vladimir Jz
SET PagaIVA_SI			:='S'; 	-- SI paga IVA (Credito)


ManejoErrores: BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
	   SET Par_NumErr  := 999;
	   SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
				  				'Disculpe las molestias que esto le ocasiona. Ref: SP-CRWFONDEOAPGPRO');
	   SET Var_Control := 'SQLEXCEPTION';
	END;


SET Var_FechaSistema	:= ( SELECT FechaSistema
								FROM PARAMETROSSIS LIMIT 1);

SET Var_CredFondeo		:=(SELECT CreditoID
								FROM CRWFONDEO WHERE CreditoID = Par_CreditoID LIMIT 1);

SET Var_PolizaID		:= Par_PolizaID;
SET Var_MontoGarApl		:= Decimal_Cero;
SET Var_NumCuota		:= Entero_Cero;

-- ----------------Llenamos la tabla Pivote --------------
# --------------

INSERT INTO TMPCURSORGARANTIAS(
    Fecha,				CreditoID,      	SolFondeoID,      	ClienteID,          CuentaAhoID,
	AmortizacionID,     ProvisionAcum,      RetencionIntAcum,   NumRetirosMes,      SucursalOrigen,
	PagaISR,            SaldoInteres ,      MonedaID,           SaldoCapVigente,    SaldoCapExigible,
	FechaVencimiento,	NumTransaccion
    )
        SELECT	Var_FechaSistema,		Fon.CreditoID,          Fon.SolFondeoID,		Fon.ClienteID,		Fon.CuentaAhoID,
				Amo.AmortizacionID,		Amo.ProvisionAcum,    	Amo.RetencionIntAcum,	Fon.NumRetirosMes,	Cli.SucursalOrigen,
				Cli.PagaISR,			Amo.SaldoInteres,       Fon.MonedaID,			Amo.SaldoCapVigente,Amo.SaldoCapExigible,
				Amo.FechaVencimiento,   Aud_NumTransaccion
            FROM CRWFONDEO Fon,
                AMORTICRWFONDEO Amo,
                CLIENTES Cli,
                CRWTIPOSFONDEADOR Tip
            WHERE Fon.CreditoID		= Par_CreditoID
            AND Fon.SolFondeoID	= Amo.SolFondeoID
            AND Fon.ClienteID		= Cli.ClienteID
            AND Fon.TipoFondeo		= Tip.TipoFondeadorID
            AND Fon.TipoFondeo		= 1
            AND Tip.PagoEnIncumple	= 'N'
            AND Fon.Estatus			= 'N'
            AND Amo.Estatus			IN('N','A')
        ORDER BY Amo.FechaVencimiento ASC;


DROP TABLE IF EXISTS TMPFACTORAMOR;
CREATE TABLE TMPFACTORAMOR
(	CreditoID			INT,
	FechaVencimiento	DATE,
	SalCapCred			DECIMAL(12,6),
	SalIntCred			DECIMAL(12,6),
	SalAcumCapInv		DECIMAL(12,6),
	SalAcumIntInv		DECIMAL(12,6),
	NumCuotasInv		INT
);


-- Para obtener la proporcion de la cobertura total(%) de los Fondeos respecto al saldo
-- del Credito por cuota.
INSERT INTO TMPFACTORAMOR
	SELECT Par_CreditoID,		FechaVencim,
		(amo.SaldoCApVigente+amo.SaldoCapAtrasa+amo.SaldoCapVencido+amo.SaldoCapVenNExi)SalCap,
		(amo.SaldoInteresOrd+amo.SaldoInteresAtr+amo.SaldoInteresVen+amo.SaldoInteresPro+amo.SaldoIntNoConta)SalInt,
		SUM(tmp.SaldoCapVigente+tmp.SaldoCapExigible)SalCapInv,
		SUM(tmp.SaldoInteres)SalIntInv,COUNT(FechaVencim)NumCuotasInv
	FROM AMORTICREDITO amo,TMPCURSORGARANTIAS  tmp
	WHERE amo.FechaVencim=tmp.FechaVencimiento
	AND amo.CreditoID=	Par_CreditoID
	AND tmp.NumTransaccion= Aud_NumTransaccion
	AND amo.Estatus<>'P'
	GROUP BY amo.FechaVencim, amo.SaldoCApVigente, amo.SaldoCapAtrasa, amo.SaldoCapVencido, amo.SaldoCapVenNExi, amo.SaldoInteresOrd, amo.SaldoInteresAtr, amo.SaldoInteresVen, amo.SaldoInteresPro, amo.SaldoIntNoConta;



UPDATE TMPCURSORGARANTIAS gar, TMPFACTORAMOR fac
SET gar.SalCapCred 		= fac.SalCapCred,
	gar.SalIntCred 		= fac.SalIntCred,
	gar.SalAcumCapInv 	= fac.SalAcumCapInv,
	gar.SalAcumIntInv 	= fac.SalAcumIntInv,
	gar.NumCuotasInv	= fac.NumCuotasInv
WHERE gar.FechaVencimiento = fac.FechaVencimiento
AND gar.CreditoID = Par_CreditoID
AND gar.CreditoID= fac.CreditoID
AND gar.NumTransaccion = Aud_NumTransaccion;

-- obtenemos datos del credito.

SET Var_CliPagaIVA:=(SELECT  Cli.PagaIVA
					FROM CREDITOS Cre, CLIENTES Cli
					WHERE Cre.CreditoID = Par_CreditoID
					AND Cre.ClienteID = Cli.ClienteID);


SET Var_SucCliente:=(SELECT  Cli.SucursalOrigen
					FROM CREDITOS Cre, CLIENTES Cli
					WHERE Cre.CreditoID = Par_CreditoID
					AND Cre.ClienteID = Cli.ClienteID);

SET Var_ProIVAInt :=(SELECT Pro.CobraIVAInteres
					FROM PRODUCTOSCREDITO Pro,
		  			CREDITOS Cre
					WHERE Pro.ProducCreditoID = Cre.ProductoCreditoID
					AND Cre.CreditoID=Par_CreditoID);



SET Var_IVASucursal:=(SELECT IVA
					FROM SUCURSALES Suc,CREDITOS Cre, CLIENTES Cli
					WHERE Suc.SucursalID = Cli.SucursalOrigen
					AND Cli.ClienteID = Cre.ClienteID
					AND Cre.CreditoID = Par_CreditoID);

SET Var_CuotaActual:=(SELECT MIN(FechaVencimiento)
					FROM TMPCURSORGARANTIAS
					WHERE CreditoID=Par_CreditoID
					AND NumTransaccion=Aud_NumTransaccion);


-- <-- Vladimir Jz
# ----------

-- --------------------------- Aplicacion de Garantias  --------------------------------------------------------
IF (IFNULL(Var_CredFondeo, Entero_Cero)> Entero_Cero ) THEN
	IF (Par_AltaEncPoliza = AltaEncPolizaSI) THEN
		CALL MAESTROPOLIZASALT(
			Var_PolizaID,		Par_EmpresaID,		Var_FechaSistema,	Pol_Automatica,		ConceptoContable,
			DesConcepto,		SalidaNO,			Par_NumErr,			Par_ErrMen,			Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;
END IF;



OPEN CURSORINVER;
BEGIN
	DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
	CICLO:LOOP

	FETCH CURSORINVER INTO
		Var_SolFondeoID,	Var_ClienteID,		Var_CuentaAhoID,	Var_AmortizaID,		    Var_InteresAcum,
		Var_RetencAcum,		Var_NumRetMes,		Var_SucCliente,		Var_PagaISR,		    Var_SaldoInteres,
		Var_MonedaID,		Var_SaldoCapVig,	Var_SaldoCapExi, 	Var_FechaVencimiento,   Var_SalCapCred,
		Var_SalIntCred,		Var_SalAcumCapInv,	Var_SalAcumIntInv,	Var_NumCuotasInv;

	SET Var_SaldoCapVig		:=IFNULL(Var_SaldoCapVig, Decimal_Cero);
	SET Var_SaldoCapExi		:=IFNULL(Var_SaldoCapExi, Decimal_Cero);
	SET Var_SaldoInteres	:=IFNULL(Var_SaldoInteres, Decimal_Cero);
	SET Var_InteresAcum		:=IFNULL(Var_InteresAcum, Decimal_Cero);
	SET Var_RetencAcum		:=IFNULL(Var_RetencAcum, Decimal_Cero);
    SET Var_FactorCapital   :=IFNULL(Var_FactorCapital, Decimal_Cero);
	SET Var_FactorInteres   :=IFNULL(Var_FactorInteres, Decimal_Cero);
	SET	Var_CapitalAplGar		:= Decimal_Cero;
	SET	Var_MonRetener		:= Decimal_Cero;
	SET Var_InteresAplGar		:= Decimal_Cero;
	SET Var_MontoAplInt		:= Decimal_Cero;

# --------------
--  Vladimir Jz -->

	SET Var_SalCapCred		:=	IFNULL(Var_SalCapCred,Decimal_Cero);
	SET Var_SalIntCred		:=	IFNULL(Var_SalIntCred,Decimal_Cero);
	SET Var_SalAcumCapInv 	:= IFNULL(Var_SalAcumCapInv,Decimal_Cero);
	SET Var_SalAcumIntInv 	:= IFNULL(Var_SalAcumIntInv,Decimal_Cero);

-- Calculamos el monto a aplicar :  Capital
SET Var_FactorCapital :=  Var_SalCapCred / Var_SalAcumCapInv;   -- % de cobertura de la cuota del Credito.
IF (Var_FactorCapital>=Entero_Uno) THEN 		                -- Si la proporcion es >1 (100, El Saldo del Credito es mayor.)
     SET Var_FactorCapital := Entero_Uno ; 		                -- se aplica todo el monto de la inversion.
ELSEIF(Var_FactorCapital<=Entero_Cero)THEN
		SET Var_FactorCapital := Entero_Cero ;
END IF;



SET Var_CapitalAplGar := ( Var_SaldoCapExi + Var_SaldoCapVig )* Var_FactorCapital;
SET Var_CapitalAplGar:= ROUND(Var_CapitalAplGar,2);


-- Calculamos el monto a aplicar :  Interes
SET Var_FactorInteres:=Var_SalIntCred / Var_SalAcumIntInv;
IF (Var_FactorInteres>=Entero_Uno) THEN 		                    -- si la proporcion es >1 (100, El Saldo del Credito es mayor.)
	SET Var_FactorInteres := Entero_Uno ; 		                    -- se aplica todo el monto de la inversion.
ELSEIF (Var_FactorInteres>Entero_Cero) THEN						    -- Si % < 1, Solo esta cubierta una parte, se calcula la proporcion.
	SET Var_FactorInteres:=Var_SaldoInteres / Var_SalAcumIntInv;
ELSE
		SET Var_FactorInteres := Entero_Cero ;
END IF;
-- Factor de Interes.


	SET Var_MontoIntGar := Var_SaldoInteres *  Var_FactorInteres;
	SET Var_MontoAplInt	:=  ROUND(Var_MontoIntGar,2);

# -----|


	SET	Var_FondeoIdStr	:= CONCAT(CONVERT(Var_SolFondeoID, CHAR),'-',Var_AmortizaID);

	-- ------------------------------------ Aplicamos el pago del interes ---------------------------------------

	IF(Par_GaranInteres = StringSI)THEN
		IF (Var_MontoAplInt >= MontoPagoMin) THEN

			IF (Var_PagaISR = PagaISR_SI) THEN
				SET	Aho_MovPago	:= Aho_PagIntGra;
				SET	Var_MonRetener	:= ROUND((Var_RetencAcum / Var_InteresAcum) * ROUND(Var_MontoAplInt, 2), 2);
			ELSE
				SET	Aho_MovPago	:= Aho_PagIntExe;
			END IF;

			CALL CRWCONTAINVPRO(
				Var_SolFondeoID,		Var_AmortizaID,		Var_CuentaAhoID,	Var_ClienteID,		Var_FechaSistema,
				Var_FechaSistema,		Var_MontoAplInt,	Var_MonedaID,		Var_NumRetMes,		Var_SucCliente,
				Des_PagoInt,			Var_FondeoIdStr,	AltaPoliza_NO,		Entero_Cero,		Var_PolizaID,
				AltaPolKubo_SI,			AltaMovKubo_SI,		Con_IntDeven,		Mov_KuboIntPro,		Nat_Cargo,
				Nat_Abono,				AltaMovAho_SI,		Aho_MovPago,		Nat_Abono,			SalidaNO,
				Par_NumErr,				Par_ErrMen,			Consecutivo,		Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;

		-- Retencion del ISR
		IF (Var_MonRetener >= MontoPagoMin) AND (Var_PagaISR = PagaISR_SI) THEN

			CALL CRWCONTAINVPRO(
				Var_SolFondeoID,		Var_AmortizaID,		Var_CuentaAhoID,	Var_ClienteID,		Var_FechaSistema,
				Var_FechaSistema,		Var_MonRetener,		Var_MonedaID,		Var_NumRetMes,		Var_SucCliente,
				Des_PagoInt,			Var_FondeoIdStr,	AltaPoliza_NO,		Entero_Cero,		Var_PolizaID,
				AltaPolKubo_SI,			AltaMovKubo_SI,		Con_RetInt,			Mov_kuboRetInt,		Nat_Abono,
				Nat_Cargo,				AltaMovAho_SI,		Aho_RetInteres,		Nat_Cargo,			SalidaNO,
				Par_NumErr,				Par_ErrMen,			Consecutivo,		Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SET Var_InteresAplGar	:= Var_MontoAplInt - Var_MonRetener;
		IF(Var_InteresAplGar >= MontoPagoMin)THEN

            -- Registramos el interes en cuentas de Orden,
			CALL CRWCONTAINVPRO (
				Var_SolFondeoID, 		Var_AmortizaID, 		Var_CuentaAhoID, 	Var_ClienteID, 		Var_FechaSistema,
				Var_FechaSistema, 		Var_InteresAplGar,		Var_MonedaID, 		Var_NumRetMes,		Var_SucCliente,
				Des_PagInvAPG,	  		Var_FondeoIdStr, 		AltaPoliza_NO,		Entero_Cero,  		Var_PolizaID,
				AltaPolKubo_SI,			AltaMovKubo_SI,			Con_CtaOrdenInt,	Mov_kuboIntCtaOr,	Nat_Cargo,
				Nat_Cargo, 				AltaMovAho_NO,			Entero_Cero,		Cadena_Vacia,     	SalidaNO,
				Par_NumErr,				Par_ErrMen,				Consecutivo,		Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,    	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;


			 CALL CRWCONTAINVPRO (
				Var_SolFondeoID, 		Var_AmortizaID, 		Var_CuentaAhoID, 	Var_ClienteID, 		Var_FechaSistema,
				Var_FechaSistema, 		Var_InteresAplGar,		Var_MonedaID, 		Var_NumRetMes,		Var_SucCliente,
				Des_PagInvAPG,	  		Var_FondeoIdStr, 		AltaPoliza_NO,		Entero_Cero,  		Var_PolizaID,
				AltaPolKubo_SI,			AltaMovKubo_NO,			Con_CorrCtaOrdenInt,Entero_Cero,		Nat_Abono,
				Nat_Abono, 				AltaMovAho_NO,			Entero_Cero,		Cadena_Vacia,     	SalidaNO,
				Par_NumErr,				Par_ErrMen,				Consecutivo,		Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			-- Cargo a la cuenta de ahorro
			CALL CONTAAHOPRO(
				Var_CuentaAhoID,	Var_ClienteID,											Aud_NumTransaccion,	Var_FechaSistema,	Var_FechaSistema,
				Nat_Cargo,			Var_InteresAplGar, 										DesConcepto,		Var_FondeoIdStr,	TipoMovAhoInt,
				Var_MonedaID,		Var_SucCliente,											AltaPoliza_NO,		Entero_Cero,		Var_PolizaID,
				PolizaAhoSI,		FNCONCEPTOAHOPREPAGO(Var_CuentaAhoID, ConceptoAho),		Nat_Cargo,			Entero_Cero,		SalidaNO,
				Par_NumErr,			Par_ErrMen,												Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,											Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;
	END IF;
	-- ------------------------Aplicacion de Garantias de Capital --------------------------------------------------

	IF(Par_GaranCapital = StringSI)THEN
		SET Var_MontoCapInv	:= Var_SaldoCapExi + Var_SaldoCapVig ; -- Se paga el total del Fondeo al inversionista.
		IF(Var_SaldoCapExi > Decimal_Cero) THEN
			SET	Mov_Capita	:= Mov_CapExigible;
			SET	Con_Capita	:= Con_CapExigible;
		ELSE
			SET	Mov_Capita	:= Mov_CapOrdinario;
			SET	Con_Capita	:= Con_CapOrdinario;
		END IF;

		-- Alta de los Movimientos Operativos y Contables del Pago del Capital
		IF (Var_CapitalAplGar >= MontoPagoMin) THEN
			-- Pago de Inversión. (Se paga el total del Saldo, posteriormente se cargara solamente la parte
			-- que se pueda aplicar en garantia al credito segun el saldo del mismo.
			CALL CRWCONTAINVPRO(
				Var_SolFondeoID,		Var_AmortizaID,		Var_CuentaAhoID,	Var_ClienteID,	Var_FechaSistema,
				Var_FechaSistema,		Var_MontoCapInv,	Var_MonedaID,		Var_NumRetMes,	Var_SucCliente,
				Des_PagoCap,			Var_FondeoIdStr,	AltaPoliza_NO,		Entero_Cero,	Var_PolizaID,
				AltaPolKubo_SI,			AltaMovKubo_SI,		Con_Capita,			Mov_Capita,		Nat_Cargo,
				Nat_Abono,				AltaMovAho_SI,		Aho_Capital,		Nat_Abono,		SalidaNO,
				Par_NumErr,				Par_ErrMen,			Consecutivo,		Par_EmpresaID,	Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			-- !  Valida el Saldo aplicado de garantia contra el saldo de la cuota del credito
			IF(Var_CuotaActual<>Var_FechaVencimiento)THEN
				SET Var_CuotaActual:=Var_FechaVencimiento;
				SET Var_MontoGarApl:=Decimal_Cero;
				SET Var_NumCuota   :=Entero_Uno; -- reinicia el contador
			ELSE

				SET Var_NumCuota:=Var_NumCuota + Entero_Uno; -- Contador
				IF((Var_MontoGarApl + Var_CapitalAplGar)>Var_SalCapCred)THEN   -- Si  excede el saldo de la cuota
					SET Var_CapitalAplGar:= Var_SalCapCred-Var_MontoGarApl;    -- solo aplica el resto.
				END IF;

				IF(Var_NumCuota = Var_NumCuotasInv)THEN                                                             -- si es la ultima Inversion y no se  alcanza a cubrir
					IF((Var_MontoGarApl+Var_CapitalAplGar)<Var_SalCapCred  AND Var_FactorCapital < Entero_Uno )THEN -- el 100% (por redondeos)y el Saldo de los inversionistas es mayor al
                        IF((Var_SalCapCred-Var_MontoGarApl)<(Var_MontoCapInv ))THEN                                 -- credito, se ajusta en el ultimo inversionista, siempre que su saldo
                            SET Var_CapitalAplGar:= Var_SalCapCred-Var_MontoGarApl;                                 -- lo permita.
                        ELSE
                            SET Var_CapitalAplGar:=Var_MontoCapInv;                                                 -- de lo contrario, se aplicara lo que se puede.
                        END IF;
                    END IF;
				END IF;
			END IF;

            IF(Var_CapitalAplGar<Entero_Cero)THEN -- creo que esto no puede pasar...
                SET Var_CapitalAplGar:=Entero_Cero;
            END IF;

			SET Var_MontoGarApl:=Var_MontoGarApl+Var_CapitalAplGar; -- Incrementamos el Acumulado de gtia aplicada por cuota.
			-- !

			-- Registramos en cuentas de orden de APG Capital
			CALL CRWCONTAINVPRO (
				Var_SolFondeoID,		Var_AmortizaID,			Var_CuentaAhoID, 	Var_ClienteID, 		Var_FechaSistema,
				Var_FechaSistema, 		Var_CapitalAplGar,		Var_MonedaID, 		Var_NumRetMes,		Var_SucCliente,
				Des_PagoCapAPG,	  		Var_FondeoIdStr, 		AltaPoliza_NO,		Entero_Cero,  		Var_PolizaID,
				AltaPolKubo_SI,			AltaMovKubo_SI,			Con_CtaOrdenCap,	Mov_kuboCapCtaOr,	Nat_Cargo,
				Nat_Cargo,				AltaMovAho_NO,			Entero_Cero,		Cadena_Vacia,     	SalidaNO,
				Par_NumErr,				Par_ErrMen,				Consecutivo,		Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,    	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			CALL CRWCONTAINVPRO (
				Var_SolFondeoID, 		Var_AmortizaID,			Var_CuentaAhoID, 	Var_ClienteID, 		Var_FechaSistema,
				Var_FechaSistema, 		Var_CapitalAplGar,		Var_MonedaID, 		Var_NumRetMes,		Var_SucCliente,
				Des_PagoCapAPG,	  		Var_FondeoIdStr, 		AltaPoliza_NO,		Entero_Cero,  		Var_PolizaID,
				AltaPolKubo_SI,			AltaMovKubo_NO,			Con_CorrCtaOrdenCap,Entero_Cero,		Nat_Abono ,
				Cadena_Vacia, 			AltaMovAho_NO,			Entero_Cero,		Cadena_Vacia,     	SalidaNO,
				Par_NumErr,				Par_ErrMen,				Consecutivo,		Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,    	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;


			-- Cargo a la cuenta de ahorro
			CALL CONTAAHOPRO(
				Var_CuentaAhoID,	Var_ClienteID,											Aud_NumTransaccion,	Var_FechaSistema,		Var_FechaSistema,
				Nat_Cargo,			Var_CapitalAplGar, 										DesConcepto,		Var_FondeoIdStr,		TipoMovAho,
				Var_MonedaID,		Var_SucCliente,											AltaPoliza_NO,		Entero_Cero,			Var_PolizaID,
				PolizaAhoSI,		FNCONCEPTOAHOPREPAGO(Var_CuentaAhoID, ConceptoAho), 	Nat_Cargo,			Entero_Cero,			SalidaNO,
				Par_NumErr,			Par_ErrMen,												Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,											Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;
	END IF;

	IF(Var_CapitalAplGar >= MontoPagoMin  OR Var_InteresAplGar >= MontoPagoMin)THEN    -- si la cantidad que se puede aplicar al credito.
		-- Pago del Credito
		CALL PAGOCREDITOGARPRO(
			Par_CreditoID,		Var_CapitalAplGar,	Var_InteresAplGar,	Var_FechaVencimiento,	AltaPoliza_NO,
			Var_PolizaID,		Par_Salida,			Par_NumErr,			Par_ErrMen,				Par_EmpresaID,
			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,
			Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;
	END IF;

	-- Almacenamos una bitacora de garantias aplicadas a los inversionistas, solo si se aplicó algun monto.
   	IF(Var_CapitalAplGar >= MontoPagoMin  OR Var_InteresAplGar >= MontoPagoMin)THEN
		IF NOT EXISTS(SELECT CuentaAhoID
				FROM CRWINVGARANTIA
				WHERE CuentaAhoID = Var_CuentaAhoID
					AND SolFondeoID= Var_SolFondeoID
					AND Transaccion = Aud_NumTransaccion) THEN

				INSERT INTO CRWINVGARANTIA(
						CuentaAhoID,	SolFondeoID,	CreditoID, 			ClienteID,		MontoCapital,
						MontoInteres,	ISR,			SucursalID,		    Transaccion, 	MonedaID,
                        Fecha,          EmpresaID,		Usuario,		    FechaActual,	DireccionIP,
                        ProgramaID,     Sucursal,		NumTransaccion)
				VALUES(
						Var_CuentaAhoID, 	Var_SolFondeoID, 	Par_CreditoID,		Var_ClienteID,		Var_CapitalAplGar,
						Var_InteresAplGar,	Var_MonRetener,		Var_SucCliente, 	Aud_NumTransaccion, Var_MonedaID,
                        Var_FechaSistema,   Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
                        Aud_ProgramaID,     Aud_Sucursal,		Aud_NumTransaccion );
		ELSE
			UPDATE CRWINVGARANTIA SET
					MontoCapital	= IFNULL(MontoCapital,Decimal_Cero)  + IFNULL(Var_CapitalAplGar,Decimal_Cero),
					MontoInteres	= IFNULL(MontoInteres,Decimal_Cero)  + IFNULL(Var_InteresAplGar,Decimal_Cero),
					ISR				= IFNULL(ISR,Decimal_Cero)  + Var_MonRetener
			WHERE CuentaAhoID		= Var_CuentaAhoID
				AND SolFondeoID	= Var_SolFondeoID
				AND Transaccion 	= Aud_NumTransaccion;
		END IF;-- Actualizacion de ISaldo a Cargar
	END IF;


	END LOOP CICLO;
END;
CLOSE CURSORINVER;

DELETE FROM TMPCURSORGARANTIAS WHERE NumTransaccion=Aud_NumTransaccion;

SET Par_NumErr	:=0;
SET Par_ErrMen	:=CONCAT('Garantia Aplicada Exitosamene: ', CONVERT(Par_CreditoID,CHAR));


END ManejoErrores;
	IF(Par_Salida = SalidaSI)THEN
		SELECT Par_NumErr AS NumErr,
			   Par_ErrMen AS ErrMen,
			  'creditoID' AS control,
				Var_PolizaID AS consecutivo;
	END IF;
END TerminaStore$$