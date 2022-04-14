-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COBROCOMAPERCREPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `COBROCOMAPERCREPRO`;
DELIMITER $$

CREATE PROCEDURE `COBROCOMAPERCREPRO`(
	/*SP que realiza el cobro de la comision por apertura del crédito.*/
	Par_CreditoID			BIGINT(12),
	Par_CuentaAhoID			BIGINT(12),
	Par_ClienteID			INT(11),
	Par_MonedaID			INT(11),
	Par_ProdCreID			INT(4),

	Par_MontoComAp			DECIMAL(14,2),		-- se refiere a la cantidad recibida
	Par_IvaComAp			DECIMAL(14,2),		-- se refiere a la cantidad recibida
	Par_ForCobroComAper		CHAR(1),
	Par_Poliza				INT(11),
	Par_OrigenPago			CHAR(1),			-- Origen de Pago S: SPEI, V: Ventanilla, C: Cargo A Cta, N: Nomina, D: Domiciliado, R: Depositos Referenciados, W: WebService, O: Otros, Cadena Vacia en caso que no sea un op de pago mov operativos

	Par_Salida    			CHAR(1),
    INOUT	Par_NumErr 		INT(11),
    INOUT	Par_ErrMen  	VARCHAR(400),
	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),

	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de variables
DECLARE Var_FechaOper 		DATE;
DECLARE Var_FechaApl 		DATE;
DECLARE Var_EsHabil			CHAR(1);
DECLARE Var_SucCliente		INT;
DECLARE Var_ClasifCre		CHAR(1);
DECLARE Var_CuentaAhoStr	VARCHAR(20);
DECLARE Par_Consecutivo		BIGINT;
DECLARE Var_MontoCom		DECIMAL(14,2);
DECLARE Var_MontoIva		DECIMAL(14,2);
DECLARE Var_Iva				DECIMAL(14,2);
DECLARE Var_SubClasifID     INT;
DECLARE Var_ConceptoCont	INT(11);
DECLARE Var_ConceptoContIVA	INT(11);
DECLARE Var_MontoTotCom		DECIMAL(14,2);
DECLARE Var_FechaCobCom		DATE;
DECLARE Var_PagaIVA			CHAR(1);
DECLARE Var_SI				CHAR(1);


-- Declaracion de Constantes
DECLARE Cadena_Vacia 		CHAR(1);
DECLARE Entero_Cero  		INT;
DECLARE Decimal_Cero 		DECIMAL(12,2);
DECLARE ComAnticipada		CHAR(1);
DECLARE Var_DescComAper		VARCHAR(100);
DECLARE Var_DcIVAComApe		VARCHAR(100);
DECLARE AltaPoliza_NO		CHAR(1);
DECLARE Salida_SI			CHAR(1);
DECLARE Con_ContComApe		INT; -- Concepto contable cartera  comision por apertura
DECLARE Con_ContIVACApe		INT; -- Concepto contable cartera IVA comision por apertura
DECLARE Con_ContGastos		INT(11); -- Concepto Contable Cartera: Cuenta Gastos
DECLARE MovAhoComAp			CHAR(3); -- Movimiento Comision por Apertura
DECLARE MovAhoIvaComAp		CHAR(3); -- Movimiento Iva Comision por Apertura
DECLARE AltaPolCre_SI		CHAR(1);
DECLARE AltaMovCre_NO		CHAR(1);
DECLARE Nat_Cargo			CHAR(1);
DECLARE Nat_Abono			CHAR(1);
DECLARE AltaMovAho_SI		CHAR(1);
DECLARE ComProgramada		CHAR(1);
DECLARE Cons_No				CHAR(1);
-- Asignacion de constantes
SET Cadena_Vacia		:= '';
SET Entero_Cero     	:= 0;
SET Decimal_Cero    	:= 0;
SET ComAnticipada   	:= 'A';
SET AltaPoliza_NO   	:= 'N';
SET Salida_SI			:= 'S';
SET Con_ContGastos		:= 58 ; -- Cuenta Puente para la Comision por Apertura
SET Con_ContComApe  	:= 22; -- corresponde con la tabla CONCEPTOSCARTERA
SET Con_ContIVACApe 	:= 23; -- corresponde con la tabla CONCEPTOSCARTERA
SET MovAhoComAp  	  	:= '83'; -- Corresponde con la tabla TIPOSMOVSAHO
SET MovAhoIvaComAp  	:= '84'; -- Corresponde con la tabla TIPOSMOVSAHO
SET AltaPolCre_SI		:= 'S';
SET AltaMovCre_NO		:= 'N';
SET Nat_Cargo			:= 'C';
SET Nat_Abono			:= 'A';
SET AltaMovAho_SI		:= 'S';
SET ComProgramada		:= 'P';
SET Var_SI				:= 'S';
SET Cons_No				:= 'N';

-- Asignacion de variables
SET Var_DescComAper	:= 'COMISION POR APERTURA';
SET Var_DcIVAComApe	:= 'IVA COMISION POR APERTURA';
SET Aud_FechaActual 	:= NOW();
SET Var_FechaOper 	:=(SELECT FechaSistema FROM PARAMETROSSIS);
SET	Var_CuentaAhoStr 	:= CONVERT(Par_CuentaAhoID, CHAR(20));

CALL DIASFESTIVOSCAL(
	Var_FechaOper,	Entero_Cero,		Var_FechaApl,		Var_EsHabil,		Aud_EmpresaID,
	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
	Aud_NumTransaccion);

SELECT	Cli.SucursalOrigen, Des.Clasificacion, Des.SubClasifID,	FechaCobroComision, 	Cli.PagaIVA
		INTO Var_SucCliente, Var_ClasifCre, Var_SubClasifID,	Var_FechaCobCom,		Var_PagaIVA
	FROM CREDITOS Cre,
        CLIENTES Cli,
        DESTINOSCREDITO Des
	WHERE CreditoID 			= Par_CreditoID
	  AND Cre.ClienteID		= Cli.ClienteID
     AND Cre.DestinoCreID   = Des.DestinoCreID;

SET Var_SubClasifID := IFNULL(Var_SubClasifID, Entero_Cero);

IF(IFNULL(Par_MontoComAp, Decimal_Cero))= Decimal_Cero THEN
	IF (Par_Salida = Salida_SI) THEN
		SELECT 	'001' AS NumErr,
			'Especificar Monto Comision Por apertura' AS ErrMen,
			'cuentaAhoID' AS control,
			Entero_Cero AS consecutivo;
		LEAVE TerminaStore;
	ELSE
		SET Par_NumErr := 001;
		SET Par_ErrMen := 'Especificar Monto';
		LEAVE TerminaStore;
	END IF;
END IF;


IF(IFNULL(Par_ForCobroComAper, Cadena_Vacia))= Cadena_Vacia THEN
	IF (Par_Salida = Salida_SI) THEN
		SELECT 	'002' AS NumErr,
			'Especificar Forma de Cobro' AS ErrMen,
			'cuentaAhoID' AS control,
			Entero_Cero AS consecutivo;
		LEAVE TerminaStore;
	ELSE
		SET Par_NumErr := 002;
		SET Par_ErrMen := 'Especificar Forma de Cobro' ;
		LEAVE TerminaStore;
	END IF;
END IF;
SET Var_Iva := (SELECT IVA FROM SUCURSALES WHERE  SucursalID = Aud_Sucursal);

	IF(Var_PagaIVA = Var_SI) THEN
		-- se calcula el monto y el iva proporcional
		SET Var_MontoCom := ROUND(Par_MontoComAp/(1+Var_Iva),2);
		SET Var_MontoIva := ROUND((Par_MontoComAp/(1+Var_Iva)) * Var_Iva,2);

    ELSE
		-- cuando el cliente no paga iva
		SET Var_MontoCom := ROUND(Par_MontoComAp,2);
		SET Var_MontoIva := Entero_Cero;
	END IF;


-- movimientos de comision por apertura solo si es Anticipada
IF((Par_ForCobroComAper = ComAnticipada) OR (Var_FechaCobCom <=Var_FechaOper AND Par_ForCobroComAper = ComProgramada)) THEN

		CALL  CONTACREDITOPRO (
        Par_CreditoID,      Entero_Cero,        Par_CuentaAhoID,    Par_ClienteID,      Var_FechaOper,
        Var_FechaApl,       Var_MontoCom,    	Par_MonedaID,       Par_ProdCreID,      Var_ClasifCre,
        Var_SubClasifID,    Var_SucCliente,     Var_DescComAper,    Var_CuentaAhoStr,   AltaPoliza_NO,
        Entero_Cero,        Par_Poliza,         AltaPolCre_SI,      AltaMovCre_NO,      Con_ContGastos,
        Entero_Cero,        Nat_Abono,          AltaMovAho_SI,      MovAhoComAp,        Nat_Cargo,
        Par_OrigenPago,		/*Cons_No,*/			Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
        Aud_EmpresaID,      Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
		Aud_ProgramaID,     Aud_Sucursal,		Aud_NumTransaccion);

	IF(Var_MontoIva != Entero_Cero) THEN
		-- movimientos de IVA  de comision por apertura
		CALL  CONTACREDITOPRO (
			Par_CreditoID,      Entero_Cero,        Par_CuentaAhoID,    Par_ClienteID,      Var_FechaOper,
			Var_FechaApl,       Var_MontoIva,       Par_MonedaID,       Par_ProdCreID,      Var_ClasifCre,
			Var_SubClasifID,    Var_SucCliente,     Var_DcIVAComApe,    Var_CuentaAhoStr,   AltaPoliza_NO,
			Entero_Cero,        Par_Poliza,         AltaPolCre_SI,      AltaMovCre_NO,      Con_ContIVACApe,
			Entero_Cero,        Nat_Abono,          AltaMovAho_SI,      MovAhoIvaComAp,     Nat_Cargo,
			Par_OrigenPago,		/*Cons_No,*/			Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
			Aud_EmpresaID,      Cadena_Vacia,		Aud_Usuario,		Aud_FechaActual,    Aud_DireccionIP,
			Aud_ProgramaID,     Aud_Sucursal,		Aud_NumTransaccion);
	END IF;

    -- Actualizamos el Monto Pagado del Credito
    UPDATE CREDITOS SET
        ComAperPagado = IFNULL(ComAperPagado, Entero_Cero) + Var_MontoCom,

        Usuario         = Aud_Usuario,
        FechaActual     = Aud_FechaActual,
        DireccionIP     = Aud_DireccionIP,
        ProgramaID      = Aud_ProgramaID,
        Sucursal        = Aud_Sucursal,
        NumTransaccion  = Aud_NumTransaccion

        WHERE CreditoID	= Par_CreditoID;

ELSE
	IF (Par_Salida = Salida_SI) THEN
		SELECT 	'003' AS NumErr,
			'La Forma de Cobro debe de ser Anticipada' AS ErrMen,
			'cuentaAhoID' AS control,
			Entero_Cero AS consecutivo;
		LEAVE TerminaStore;
	ELSE
		SET Par_NumErr := 003;
		SET Par_ErrMen := 'La Forma de Cobro debe de ser Anticipada' ;
		LEAVE TerminaStore;
	END IF;
END IF;

IF (Par_Salida = Salida_SI) THEN
	SELECT 	'000' AS NumErr,
		'Comision por Apertura Cobrada Exitosamente' AS ErrMen,
		'cuentaAhoID' AS control,
		Par_Poliza AS consecutivo;
	LEAVE TerminaStore;
ELSE
	SET Par_NumErr := 000;
	SET Par_ErrMen := 'Comision por Apertura Cobrada Exitosamente' ;
	LEAVE TerminaStore;
END IF;


END TerminaStore$$