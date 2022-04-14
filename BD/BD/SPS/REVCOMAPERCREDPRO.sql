-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REVCOMAPERCREDPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `REVCOMAPERCREDPRO`;
DELIMITER $$

CREATE PROCEDURE `REVCOMAPERCREDPRO`(
	Par_CreditoID			BIGINT(12),
	Par_CuentaAhoID			BIGINT(12),
	Par_ClienteID			INT(11),
	Par_MonedaID			INT(11),
	Par_ProdCreID			INT(4),

	Par_MontoComAp			DECIMAL(14,2), -- se refiere a la cantidad recibida
	Par_ForCobroComAper		CHAR(1),
	Par_Poliza				INT(11),

	Par_Salida    			CHAR(1),

    INOUT	Par_NumErr 		INT,
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


	-- Declaracion de Constantes
	DECLARE Cadena_Vacia 		CHAR(1);
	DECLARE Entero_Cero  		INT;
	DECLARE Decimal_Cero 		DECIMAL(12,2);
	DECLARE ComAnticipada		CHAR(1);
	DECLARE Var_DescComAper		VARCHAR(100);
	DECLARE Var_DcIVAComApe		VARCHAR(100);
	DECLARE AltaPoliza_SI		CHAR(1);
	DECLARE Salida_SI			CHAR(1);
	DECLARE Con_ContComApe		INT; 		-- Concepto contable cartera  comision por apertura
	DECLARE Con_ContIVACApe		INT; 		-- Concepto contable cartera IVA comision por apertura
	DECLARE RevMovAhoComAp		CHAR(3);	-- Movimiento  Reversa Comision por Apertura
	DECLARE RevMovAhoIvaComAp	CHAR(3); 	-- Movimiento Reversa Iva Comision por Apertura
	DECLARE AltaPolCre_SI		CHAR(1);
	DECLARE AltaMovCre_NO		CHAR(1);
	DECLARE Nat_Cargo			CHAR(1);
	DECLARE Nat_Abono			CHAR(1);
	DECLARE AltaMovAho_SI		CHAR(1);
	DECLARE ConContaComAperRev	INT;
	DECLARE AltaPoliza_NO		CHAR(1);
	DECLARE Con_ContGastos		INT(11);
	DECLARE Cons_No 			CHAR(1);

	-- Asignacion de constantes
	SET Cadena_Vacia		:= '';
	SET Entero_Cero     	:= 0;
	SET Decimal_Cero    	:= 0;
	SET ComAnticipada   	:= 'A';
	SET AltaPoliza_SI   	:= 'S';
	SET AltaPoliza_NO		:='N';
	SET Salida_SI			:= 'S';
	SET Con_ContComApe  	:= 22; 		-- corresponde con la tabla CONCEPTOSCARTERA
	SET Con_ContIVACApe 	:= 23; 		-- corresponde con la tabla CONCEPTOSCARTERA
	SET RevMovAhoComAp 	  	:= '301'; 	-- Corresponde con la tabla TIPOSMOVSAHO Reversa Comicion por apertura
	SET RevMovAhoIvaComAp  	:= '302'; 	-- Corresponde con la tabla TIPOSMOVSAHO Reversa Comicion por apertura
	SET AltaPolCre_SI		:= 'S';
	SET AltaMovCre_NO		:= 'N';
	SET Nat_Cargo			:= 'C';
	SET Nat_Abono			:= 'A';
	SET AltaMovAho_SI		:= 'S';
	SET ConContaComAperRev  := 61;          -- Concepto Contable de Seguro de Vida tabla CONCEPTOSCONTA
	SET Con_ContGastos		:= 58 ;
	SET Cons_No 			:= 'N';

	-- Asignacion de variables
	SET Var_DescComAper	:= 'REVERSA COMISION POR APERTURA';
	SET Var_DcIVAComApe	:= 'REVERSA IVA COMISION POR APERTURA';
	SET Aud_FechaActual := NOW();
	SET Var_FechaOper 	:=(SELECT FechaSistema FROM PARAMETROSSIS);
	SET	Var_CuentaAhoStr := CONVERT(Par_CuentaAhoID, CHAR(20));

	CALL DIASFESTIVOSCAL(
		Var_FechaOper,	Entero_Cero,		Var_FechaApl,		Var_EsHabil,		Aud_EmpresaID,
		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
		Aud_NumTransaccion);

	SELECT	Cli.SucursalOrigen,	Des.Clasificacion,   Des.SubClasifID
			INTO
			Var_SucCliente,		Var_ClasifCre, Var_SubClasifID
		FROM CREDITOS Cre,
			 CLIENTES Cli,
			 DESTINOSCREDITO Des
		WHERE CreditoID         = Par_CreditoID
		  AND Cre.ClienteID     = Cli.ClienteID
		  AND Cre.DestinoCreID  = Des.DestinoCreID;

	SET Var_SubClasifID     := IFNULL(Var_SubClasifID, Entero_Cero);


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
	-- se calcula el monto y el iva proporcional
	SET Var_MontoCom := ROUND(Par_MontoComAp/(1+Var_Iva),2);
	SET Var_MontoIva := ROUND((Par_MontoComAp/(1+Var_Iva)) * Var_Iva,2);


	-- movimientos de comision por apertura solo si es Anticipada
	SET Par_Poliza := IFNULL(Par_Poliza,Entero_Cero);
	IF(Par_Poliza>Entero_cero)THEN
		SET AltaPoliza_SI:="N";
	END IF;
	IF(Par_ForCobroComAper = ComAnticipada) THEN
		CALL  CONTACREDITOPRO (
			Par_CreditoID,      Entero_Cero,        Par_CuentaAhoID,    Par_ClienteID,      Var_FechaOper,
			Var_FechaApl,       Var_MontoCom, 	 	Par_MonedaID,       Par_ProdCreID,      Var_ClasifCre,
			Var_SubClasifID,    Var_SucCliente,     Var_DescComAper,    Var_CuentaAhoStr,   AltaPoliza_SI,
			ConContaComAperRev, Par_Poliza,         AltaPolCre_SI,      AltaMovCre_NO,      Con_ContGastos,
			Entero_Cero,        Nat_Cargo,          AltaMovAho_SI,      RevMovAhoComAp,     Nat_Abono,
			Cadena_Vacia,		/*Cons_No,*/			Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
			Aud_EmpresaID,      Cadena_Vacia,		Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
			Aud_ProgramaID,     Aud_Sucursal,		Aud_NumTransaccion  );

		IF(Var_MontoIva != Entero_Cero) THEN
			-- movimientos de IVA  de comision por apertura
			CALL  CONTACREDITOPRO (
				Par_CreditoID,      Entero_Cero,        Par_CuentaAhoID,    Par_ClienteID,      Var_FechaOper,
				Var_FechaApl,       Var_MontoIva,       Par_MonedaID,       Par_ProdCreID,      Var_ClasifCre,
				Var_SubClasifID,    Var_SucCliente,     Var_DcIVAComApe,    Var_CuentaAhoStr,   AltaPoliza_NO,
				Entero_Cero,       Par_Poliza,         AltaPolCre_SI,      AltaMovCre_NO,      Con_ContIVACApe,
				Entero_Cero,        Nat_Cargo,          AltaMovAho_SI,      RevMovAhoIvaComAp,  Nat_Abono,
				Cadena_Vacia,		/*Cons_No,*/			Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
				Aud_EmpresaID,      Cadena_Vacia,		Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
				Aud_ProgramaID,     Aud_Sucursal,		Aud_NumTransaccion  );
		END IF;

		 -- Actualizamos el Monto Pagado del Credito
		UPDATE CREDITOS SET
			ComAperPagado = IFNULL(ComAperPagado, Entero_Cero) - Var_MontoCom,

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
			'Operacion realizada Exitosamente' AS ErrMen,
			'cuentaAhoID' AS control,
			Par_Poliza AS consecutivo;
		LEAVE TerminaStore;
	ELSE
		SET Par_NumErr := 000;
		SET Par_ErrMen := 'Operacion Realizada Exitosamente' ;
		LEAVE TerminaStore;
	END IF;

END TerminaStore$$