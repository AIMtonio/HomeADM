-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEIDEVOLUCIONESPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEIDEVOLUCIONESPRO`;
DELIMITER $$

CREATE PROCEDURE `SPEIDEVOLUCIONESPRO`(
# =====================================================================================
# ------- STORE PARA PROCESAR UNA DEVOLUCION SPEI ---------
# =====================================================================================
	Par_ClaveRastreo       	VARCHAR(30),
	Par_TipoPago		   	INT(2),
	Par_CuentaAho		   	BIGINT(20),
	Par_TipoCuentaOrd	   	INT(2),
	Par_CuentaOrd		   	VARCHAR(20),

	Par_NombreOrd		   	VARCHAR(40),
	Par_RFCOrd	           	VARCHAR(18),
	Par_MonedaID		   	INT(11),
	Par_TipoOperacion	   	INT(2),
	Par_MontoTransferir	   	DECIMAL(16,2),

	Par_IVAPorPagar		   	DECIMAL(16,2),
	Par_InstiRemitente	   	INT(5),
	Par_TotalCargoCuenta   	DECIMAL(18,2),
    Par_InstiReceptora	   	INT(5),
	Par_CuentaBeneficiario 	VARCHAR(20),

	Par_NombreBeneficiario 	VARCHAR(40),
	Par_RFCBeneficiario	   	VARCHAR(18),
	Par_TipoCuentaBen	   	INT(2),
    Par_ConceptoPago	   	VARCHAR(40),
	Par_CuentaBenefiDos    	VARCHAR(20),

	Par_NombreBenefiDos    	VARCHAR(40),
	Par_RFCBenefiDos	   	VARCHAR(18),
	Par_TipoCuentaBenDos   	INT(2),
    Par_ConceptoPagoDos    	VARCHAR(40),
	Par_ReferenciaCobranza 	VARCHAR(40),

	Par_ReferenciaNum      	INT(7),
    Par_PrioridadEnvio	   	INT(1),
	Par_UsuarioEnvio       	VARCHAR(30),
	Par_AreaEmiteID	       	INT(2),
    Par_CausaDevol         	INT(2),

	Par_Firma              	VARCHAR(1000),
	Par_OrigenOperacion		CHAR(1),		-- Indica si la Operacion se Origina en Ventanilla,Banca Movil o ClienteSpei

    Par_Salida			   	CHAR(1),
	INOUT Par_NumErr	   	INT,
	INOUT Par_ErrMen	   	VARCHAR(400),

	Par_EmpresaID		   	INT(11),
	Aud_Usuario			   	INT(11),
	Aud_FechaActual		   	DATETIME,
	Aud_DireccionIP		   	VARCHAR(20),
	Aud_ProgramaID		   	VARCHAR(50),
	Aud_Sucursal		   	INT(11),
	Aud_NumTransaccion	   	BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Entero_Cero		INT;
	DECLARE	Decimal_Cero	DECIMAL(18,2);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE Salida_SI 		CHAR(1);
	DECLARE	Salida_NO		CHAR(1);
	DECLARE Est_Ver         CHAR(1);
	DECLARE TipoConBanxico	CHAR(1);

	-- Declaracion de Variables
    DECLARE Var_Consecutivo	BIGINT(20);     -- Variable consecutivo
	DECLARE Var_Folio       BIGINT(20);     -- Folio
	DECLARE Var_FechaAuto   DATETIME;       -- Fecha de autorizacion
	DECLARE Var_EstatusEnv  INT(3);         -- Estatus de envio
	DECLARE Var_ClavePago   VARCHAR(10);    -- Clave de pago
	DECLARE Var_Estatus     CHAR(1);        -- estatus del safi
	DECLARE Var_FechaRecep  DATETIME;       -- fecha de recepcion
	DECLARE Var_FechaEnvio  DATETIME;       -- fecha envio
	DECLARE Var_Control	    VARCHAR(200);   -- Variable de control

	-- Asignacion de Constantes
	SET	Cadena_Vacia	    := '';             -- Cadena Vacia
	SET	Fecha_Vacia	    	:= '1900-01-01 00:00:00';   -- Fecha Vacia
	SET	Entero_Cero		    := 0;              -- Entero Cero
	SET	Decimal_Cero	    := 0.0;            -- DECIMAL cero
	SET Salida_SI 	     	:= 'S';            -- Salida SI
	SET	Salida_NO	       	:= 'N';            -- Salida NO
	SET Est_Ver             := 'E';            -- Estatus autorizada
	SET TipoConBanxico		:= 'B';				-- Tipo de Conexión Banxico (conecta).

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-SPEIDEVOLUCIONESPRO');
				SET Var_Control = 'SQLEXCEPTION';
			END;


		SET Var_FechaAuto 	:= CURRENT_DATE();
		SET Var_EstatusEnv 	:= Entero_Cero;
		-- CLAVE PAGO
		SET Var_ClavePago  	:= Cadena_Vacia;
		SET Var_Estatus 	:= Est_Ver; -- Se cambia por E para que no sea tomado por el Servicio de Envio, debido a que ya se actualizo el estatus en REST
		SET Var_FechaRecep 	:= CURRENT_TIMESTAMP();

		-- FECHA ENVIO
		SET Var_FechaEnvio := Fecha_Vacia;
		SET Par_ReferenciaCobranza := Cadena_Vacia;

		CALL SPEIENVIOSALT(
			Var_Folio,				Par_ClaveRastreo,       Entero_Cero,            Entero_Cero,     		Par_TipoCuentaOrd,
			Par_CuentaOrd,	        Par_NombreOrd,          Par_RFCOrd,             1,                      Par_TipoOperacion,
			Par_MontoTransferir,    Par_IVAPorPagar,        Decimal_Cero,           Decimal_Cero,           Par_InstiRemitente,
			Decimal_Cero,           Par_InstiReceptora,     Par_CuentaBeneficiario, Par_NombreBeneficiario, Par_RFCBeneficiario,
			Par_TipoCuentaBen,	    Par_ConceptoPago,	    Par_CuentaBenefiDos,	Par_NombreBenefiDos,    Par_RFCBenefiDos,
			Par_TipoCuentaBenDos,   Par_ConceptoPagoDos,	Par_ReferenciaCobranza ,Par_ReferenciaNum,      Par_PrioridadEnvio,
			Var_FechaAuto,	        Var_EstatusEnv,		    Var_ClavePago,	        47,                     Par_AreaEmiteID	,
			Var_Estatus,		    Var_FechaRecep,         Var_FechaEnvio,         Par_CausaDevol,		    Par_Firma,
			Par_OrigenOperacion,	Entero_Cero,			TipoConBanxico,			Salida_NO,             	Par_NumErr,
			Par_ErrMen,             Par_EmpresaID,			Aud_Usuario,            Aud_FechaActual,	 	Aud_DireccionIP,
            Aud_ProgramaID,	        Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

        SET Par_NumErr	:= 000;
		SET Par_ErrMen	:= CONCAT("Envio SPEI Agregado Exitosamente: ", CONVERT(Var_Folio, CHAR));
		SET Var_Control	:= 'folio' ;
		SET Var_Consecutivo	:= Var_Folio;

	END ManejoErrores;

        IF (Par_Salida = Salida_SI) THEN
			SELECT	Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					Var_Control AS control,
					Var_Consecutivo AS consecutivo;
		END IF;

END TerminaStore$$