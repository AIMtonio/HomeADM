-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PREPAGOCREDPASPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PREPAGOCREDPASPRO`;
DELIMITER $$


CREATE PROCEDURE `PREPAGOCREDPASPRO`(
/* SP QUE REALIZA EL PROCESO DE PREPAGO EN EL CRÉDITO PASIVO */
	Par_CreditoFonID	BIGINT(20),		/* ID del credito Pasivo*/
	Par_MontoPagar    	DECIMAL(12, 2)	/* Monto a Pagar */ ,
	Par_MonedaID		INT(11),		/* Identificador de la moneda*/
	Par_Finiquito		CHAR(1),		/* Indica si se trata de un Finiquito*/
	Par_AltaEncPoliza	CHAR(1),		/* Indica si se dara o no de alta un encabezado de poliza */

	Par_InstitucionID	INT(11),		/* Numero de Institucion (INSTITUCIONES) */
	Par_NumCtaInstit	VARCHAR(20),	/* Numero de Cuenta Bancaria. */
	Par_Salida        	CHAR(1),
	INOUT Par_MontoPago	DECIMAL(12,2),
	INOUT Par_Poliza	BIGINT,

	INOUT Par_NumErr	INT(11),
	INOUT Par_ErrMen	VARCHAR(400),
	OUT	Par_Consecutivo	BIGINT,
	/* Parametros de Auditoria */
	Par_EmpresaID     	INT(11),
	Aud_Usuario		    INT(11),

	Aud_FechaActual	    DATETIME,
	Aud_DireccionIP	    VARCHAR(15),
	Aud_ProgramaID	    VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion  BIGINT(20)
)

TerminaStore: BEGIN

-- Declaracion de variables
DECLARE Var_EstatusCre      CHAR(1);
DECLARE Var_EsGrupal        CHAR(1);
DECLARE Var_GrupoID         INT;
DECLARE Var_CicloGrupo      INT;
DECLARE Var_TipoPrepago		CHAR(1);
DECLARE Var_CicloActual     INT;
DECLARE Var_SoliciCreID		INT;
DECLARE Var_ProrrateaPago	CHAR(1);
DECLARE Var_EstGrupo		CHAR(1);
DECLARE Var_FechaInicioAmor	DATE;
DECLARE Var_FechaSistema	DATE;
DECLARE Var_NumRecPago		INT;
DECLARE Var_Control			VARCHAR(200);
DECLARE Var_Consecutivo		BIGINT;

-- Declaracion de Constantes
DECLARE Cadena_Vacia    	CHAR(1);
DECLARE Fecha_Vacia     	DATE;
DECLARE Entero_Cero     	INT;
DECLARE Entero_Uno			INT;
DECLARE Decimal_Cero    	DECIMAL(12, 2);
DECLARE Esta_Vencido    	CHAR(1);
DECLARE Esta_Vigente    	CHAR(1);
DECLARE NO_EsGrupal     	CHAR(1);
DECLARE Si_EsGrupal     	CHAR(1);
DECLARE SI_Prorratea		CHAR(1);
DECLARE Tip_UltCuo			CHAR(1);
DECLARE Tip_SigCuo			CHAR(1);
DECLARE Tip_Prorrateo		CHAR(1);
DECLARE Gru_Activo			CHAR(1);
DECLARE SalidaSI        	CHAR(1);
DECLARE SalidaNO        	CHAR(1);

-- Asignacion de Constantes
SET Cadena_Vacia    		:= '';				-- Cadena Vacia
SET Fecha_Vacia     		:= '1900-01-01';	-- Fecha Vacia
SET Entero_Cero     		:= 0;				-- Entero en Cero
SET Decimal_Cero    		:= 0.00;			-- Decimal Cero
SET Entero_Uno   			:= 1;				-- Decimal Cero
SET Esta_Vencido    		:= 'B';				-- Estatus del Credito: Vencido
SET Esta_Vigente    		:= 'V';				-- Estatus del Credito: Vigente
SET NO_EsGrupal     		:= 'N';				-- Si es un Credito Grupal
SET SI_EsGrupal     		:= 'S';				-- Si es un Credito Grupal
SET SI_Prorratea			:= 'S';				-- Si Prorrate el Pago Grupal
SET Tip_UltCuo				:= 'U';				-- Tipo de PrePago: Ultimas cuotas
SET Tip_SigCuo				:= 'I';				-- Tipo de PrePago: A las cuotas siguientes inmediatas
SET Tip_Prorrateo			:= 'V';				-- Tipo de PrePago: Prorrateo de pago en cuotas vivas
SET Gru_Activo				:= 'A';				-- Estatus dentro del Grupo: Activo
SET SalidaSI        		:= 'S';				-- El Store si Regresa una Salida
SET SalidaNO        		:= 'N';				-- El Store no Regresa una Salida
SET Var_NumRecPago			:= 0;

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
								'esto le ocasiona. Ref: SP-PREPAGOCREDPASPRO');
		END;

	IF IFNULL(Par_CreditoFonID,Entero_Cero)=Entero_Cero THEN
		SET Par_NumErr	:= 1;
		SET Par_ErrMen	:= 'El Numero de Credito esta vacio.';
		SET Var_Control	:= 'creditoID';
		SET Var_Consecutivo	:= Entero_Cero;
		LEAVE ManejoErrores;
	END IF;

	IF IFNULL(Par_NumCtaInstit,Entero_Cero)=Entero_Cero THEN
		SET Par_NumErr	:= 2;
		SET Par_ErrMen	:= 'El Numero de Cuenta esta vacio.';
		SET Var_Control	:= 'cuentaIDPre';
		SET Var_Consecutivo	:= Entero_Cero;
		LEAVE ManejoErrores;
	END IF;

	IF IFNULL(Par_MontoPagar,Decimal_Cero)=Decimal_Cero THEN
		SET Par_NumErr	:= 3;
		SET Par_ErrMen	:= 'El Monto a Pagar esta vacio.';
		SET Var_Control	:= 'montoPagar';
		SET Var_Consecutivo	:= Entero_Cero;
		LEAVE ManejoErrores;
	END IF;

	IF IFNULL(Par_MontoPagar,Decimal_Cero)<Entero_Uno THEN
		SET Par_NumErr	:= 4;
		SET Par_ErrMen	:= 'El Monto a Pagar no debe ser menor a $1.00.';
		SET Var_Control	:= 'montoPagar';
		SET Var_Consecutivo	:= Entero_Cero;
		LEAVE ManejoErrores;
	END IF;

	SET Par_MontoPago	:= Entero_Cero;
	SET Par_Consecutivo	:= Entero_Cero;
	SET Var_TipoPrepago	:= Tip_SigCuo;
	SET Aud_FechaActual	:= NOW();

	IF (Var_TipoPrepago = Tip_SigCuo) THEN
		-- Tipo de PrePago: A las cuotas siguientes inmediatas
		CALL PREPAGOPASIVOSIGCPRO(
			Par_CreditoFonID,	Par_MontoPagar,		Par_MonedaID,		Par_Finiquito,		Par_AltaEncPoliza,
			Par_InstitucionID,	Par_NumCtaInstit,	SalidaNO,			Par_MontoPago,		Par_Poliza,
			Par_NumErr,			Par_ErrMen,			Par_Consecutivo,	Par_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

        IF(Par_NumErr <> Entero_Cero) THEN
            SET Var_Control	:= 'numTransaccion';
            LEAVE ManejoErrores;
        END IF;
	ELSE
		SET Par_NumErr	:= 5;
		SET Par_ErrMen	:= 'El Tipo de Prepago no Existe';
		SET Var_Control	:= 'creditoID';
		SET Var_Consecutivo	:= Entero_Cero;
		LEAVE ManejoErrores;
	END IF;

	SET Par_NumErr  := Entero_Cero;
	SET Par_ErrMen	:= 'PrePago de Credito Aplicado Exitosamente.';
	SET Var_Control	:= 'numTransaccion';
	SET Var_Consecutivo	:= Par_CreditoFonID;

END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Var_Consecutivo AS Consecutivo,
			Par_Poliza AS PolizaID;
	END IF;

END TerminaStore$$
