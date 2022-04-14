-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CANCELAINTERECREPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CANCELAINTERECREPRO`;
DELIMITER $$

CREATE PROCEDURE `CANCELAINTERECREPRO`(
# =====================================================================================
# ----- SP QUE CANCELA LOS INTERESES DEVENGADOS DE UN CREDITO -----------------
# =====================================================================================

    Par_CreditoID		BIGINT(12),		# Numero de Credito
    INOUT	Par_Poliza	BIGINT,			# Numero de Poliza
    Par_Fecha			DATE,			# Fecha de Aplicacion
	Par_Salida          CHAR(1),		# Indica si existira una respuesta de salida S:SI  N:NO

    INOUT Par_NumErr    INT(11),		# Numero de Error
    INOUT Par_ErrMen    VARCHAR(400),	# Mensaje de Error

    # Parametros de Auditoria
    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)

		)
TerminaStore: BEGIN

/* Declaracion de Variables */
DECLARE Var_CreditoID       BIGINT(12);
DECLARE Var_AmortizacionID  INT(11);
DECLARE Var_MonedaID        INT(11);
DECLARE Var_Estatus         CHAR(1);
DECLARE Var_SucCliente      INT(11);
DECLARE Var_ProdCreID       INT(11);
DECLARE Var_ClasifCre       CHAR(1);
DECLARE Var_Interes         DECIMAL(14,4);
DECLARE Var_SucursalCred	INT(11);
DECLARE Var_FecApl      	DATE;
DECLARE Ref_GenInt      	VARCHAR(50);
DECLARE Mov_AboConta    	INT(11);
DECLARE Mov_CarConta    	INT(11);
DECLARE Mov_CarOpera    	INT(11);
DECLARE Par_Consecutivo 	BIGINT;
DECLARE Var_SubClasifID 	INT(11);
DECLARE Var_Control			VARCHAR(100);

/* Declaracion de Constantes */
DECLARE Estatus_Vigente 	CHAR(1);
DECLARE Cadena_Vacia    	CHAR(1);
DECLARE Fecha_Vacia     	DATE;
DECLARE Entero_Cero     	INT;
DECLARE Entero_Uno			INT(11);
DECLARE Decimal_Cero    	DECIMAL(12, 2);
DECLARE Nat_Cargo       	CHAR(1);
DECLARE Nat_Abono       	CHAR(1);
DECLARE Mov_IntPro      	INT;
DECLARE Con_IntDeven    	INT;
DECLARE Con_IngreInt    	INT;
DECLARE Pol_Automatica  	CHAR(1);
DECLARE Con_GenIntere   	INT;
DECLARE SalidaNO    		CHAR(1);
DECLARE SalidaSI    		CHAR(1);
DECLARE AltaPoliza_NO   	CHAR(1);
DECLARE AltaPolCre_SI   	CHAR(1);
DECLARE AltaMovCre_SI   	CHAR(1);
DECLARE AltaMovCre_NO   	CHAR(1);
DECLARE AltaMovAho_NO   	CHAR(1);
DECLARE Des_CieDia      	VARCHAR(100);
DECLARE Cons_SI				CHAR(1);		# Constante SI
DECLARE Cons_NO				CHAR(1);
DECLARE AltaPoliza_SI		CHAR(1);


/* Asignacion de Constantes */
SET Estatus_Vigente := 'V';                 -- Estatus Amortizacion: Vigente
SET Cadena_Vacia    := '';                  -- Cadena Vacia
SET Fecha_Vacia     := '1900-01-01';        -- Fecha Vacia
SET Entero_Cero     := 0;                   -- Entero en Cero
SET Entero_Uno		:= 1;					-- Entero Uno
SET Decimal_Cero    := 0.00;            	-- Decimal Cero
SET Nat_Cargo       := 'C';                 -- Naturaleza de Cargo
SET Nat_Abono       := 'A';                 -- Naturaleza de Abono
SET Mov_IntPro      := 14;                  -- Tipo de Movimiento de Credito: Interes Provisionado
SET Con_IntDeven    := 19;                  -- Concepto Contable: Interes Devengado
SET Con_IngreInt    := 5;                   -- Concepto Contable: Ingreso por Intereses
SET Pol_Automatica  := 'A';                 -- Tipo de Poliza: Automatica
SET Con_GenIntere   := 51;	                -- Tipo de Proceso Contable: Generacion de Interes Ordinario
SET SalidaNO    	:= 'N';                 -- El store no Arroja una Salida
SET SalidaSI    	:= 'S';                 -- El store no Arroja una Salida
SET AltaPoliza_NO   := 'N';                 -- Alta del Encabezado de la Poliza: NO
SET AltaPolCre_SI   := 'S';                 -- Alta de la Poliza de Credito: SI
SET AltaMovCre_NO   := 'N';                 -- Alta del Movimiento de Credito: NO
SET AltaMovCre_SI   := 'S';                 -- Alta del Movimiento de Credito: SI
SET AltaMovAho_NO   := 'N';                 -- Alta del Movimiento de Ahorro: NO
SET Cons_SI			:= 'S';					-- Constante: SI
SET Cons_NO			:= 'N';					-- Constante: NO
SET Des_CieDia      := 'CANC. DEV. INTERES';
SET Ref_GenInt      := 'GENERACION INTERES';
SET Aud_ProgramaID  := 'GENERAINTERECREPRO';
SET AltaPoliza_SI   := 'S';


SET Var_FecApl 		:= Par_Fecha;
SET Var_CreditoID	:= Par_CreditoID;	-- Se asigna el numero de Credito

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
		   SET Par_NumErr  := 999;
		   SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
					  'Disculpe las molestias que esto le ocasiona. Ref: SP-CANCELAINTERECREPRO');
		   SET Var_Control  := 'sqlexception';
		END;


	SELECT	Cre.MonedaID,	Cli.SucursalOrigen,	Cre.ProductoCreditoID,	Des.Clasificacion,	Des.SubClasifID
	 INTO	Var_MonedaID,	Var_SucCliente,		Var_ProdCreID,			Var_ClasifCre,		Var_SubClasifID
		FROM  CREDITOS Cre,
			  CLIENTES Cli,
			  DESTINOSCREDITO Des
		WHERE Cre.ClienteID		= Cli.ClienteID
		  AND Cre.DestinoCreID 	= Des.DestinoCreID
		  AND (	Cre.Estatus		=  Estatus_Vigente)
          AND Cre.CreditoID 	= Par_CreditoID;



	-- Es el Interes Original Calculado de la Amortizacion
	SET Var_Interes := (SELECT SUM(SaldoInteresPro) FROM AMORTICREDITO WHERE CreditoID = Var_CreditoID);
    SET Par_Poliza := IFNULL(Par_Poliza,Entero_Cero);
	IF(Par_Poliza>Entero_cero)THEN
		SET AltaPoliza_SI:= AltaPoliza_NO;
	END IF;

	-- Si el credito ya devengo intereses se crea el encabezado de la poliza
	IF (Var_Interes > Decimal_Cero AND AltaPoliza_SI = Cons_SI) THEN
		-- Se da de alta el encabezado de la poliza
		CALL MAESTROPOLIZASALT(
			Par_Poliza,			Par_EmpresaID,		Var_FecApl,		Pol_Automatica,		Con_GenIntere,
			Ref_GenInt,			SalidaNO,			Par_NumErr,		Par_ErrMen,			Aud_Usuario,
            Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
	END IF;

	-- Si el credito ya devengo intereses se realizan los movimientos de la reversa de intereses.
	IF (Var_Interes > Entero_Cero) THEN

		SET	Mov_AboConta	:= Con_IngreInt;
		SET	Mov_CarConta	:= Con_IntDeven;
		SET	Mov_CarOpera	:= Mov_IntPro;


		CALL  CONTACREDITOSPRO (
			Var_CreditoID,		Entero_Uno,			Entero_Cero,		Entero_Cero,		Par_Fecha,
			Var_FecApl,			Var_Interes,		Var_MonedaID,		Var_ProdCreID,		Var_ClasifCre,
			Var_SubClasifID,    Var_SucCliente,		Des_CieDia,    	 	Ref_GenInt,			AltaPoliza_NO,
			Entero_Cero,		Par_Poliza,     	AltaPolCre_SI,		AltaMovCre_SI,		Mov_CarConta,
			Mov_CarOpera,   	Nat_Abono,			AltaMovAho_NO,		Cadena_Vacia,		Cadena_Vacia,
			Cadena_Vacia,		Cons_NO,			Par_NumErr,			Par_ErrMen,			Par_Consecutivo,
			Par_EmpresaID,		Cadena_Vacia,      	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,	    Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

		CALL  CONTACREDITOSPRO (
			Var_CreditoID,		Entero_Uno,			Entero_Cero,		Entero_Cero,		Par_Fecha,
			Var_FecApl,			Var_Interes,		Var_MonedaID,		Var_ProdCreID,		Var_ClasifCre,
			Var_SubClasifID,    Var_SucCliente,		Des_CieDia,     	Ref_GenInt,			AltaPoliza_NO,
			Entero_Cero,		Par_Poliza,     	AltaPolCre_SI,		AltaMovCre_NO,		Mov_AboConta,
			Entero_Cero,		Nat_Cargo,			AltaMovAho_NO,		Cadena_Vacia,   	Cadena_Vacia,
			Cadena_Vacia,		Cons_NO,			Par_NumErr,			Par_ErrMen,			Par_Consecutivo,
			Par_EmpresaID,		Cadena_Vacia,       Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,	   	Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

	END IF;
		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= 'Intereses Cancelados Exitosamente.';
END ManejoErrores;  # END del Handler de Errores

IF(Par_Salida = SalidaSI) THEN
	SELECT  CONVERT(Par_NumErr, CHAR) AS NumErr,
			Par_ErrMen 		AS ErrMen,
			Var_Control	 	AS control,
			Par_CreditoID 	AS consecutivo;
END IF;


END TerminaStore$$