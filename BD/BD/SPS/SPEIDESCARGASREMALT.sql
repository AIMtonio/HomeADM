-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEIDESCARGASREMALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEIDESCARGASREMALT`;
DELIMITER $$

CREATE PROCEDURE `SPEIDESCARGASREMALT`(
-- =====================================================================================
-- ------- STORE PARA DAR DE ALTA REMESAS SPEI---------
-- =====================================================================================
	Par_SpeiSolDesID		BIGINT(20),
	Par_ClaveRastreo		VARCHAR(30),
	Par_TipoPago			INT(2),
	Par_TipoCuentaOrd		INT(2),
	Par_CuentaOrd			VARCHAR(20),

	Par_NombreOrd			VARCHAR(40),
	Par_RFCOrd	       		VARCHAR(18),
	Par_TipoOperacion		INT(2),
	Par_MontoTransferir		DECIMAL(16,2),
	Par_IVA					DECIMAL(16,2),

	Par_ComisionTrans	  	DECIMAL(16,2),
	Par_IVAComision		  	DECIMAL(16,2),
	Par_InstiRemitente	  	INT(5),
	Par_InstiReceptora	  	INT(5),
	Par_CuentaBeneficiario	VARCHAR(20),

	Par_NombreBeneficiario	VARCHAR(40),
	Par_RFCBeneficiario	  	VARCHAR(18),
	Par_TipoCuentaBen	  	INT(2),
	Par_ConceptoPago	  	VARCHAR(40),
	Par_CuentaBenefiDos   	VARCHAR(20),

	Par_NombreBenefiDos   	VARCHAR(40),
	Par_RFCBenefiDos	  	VARCHAR(18),
	Par_TipoCuentaBenDos  	INT(2),
	Par_ConceptoPagoDos   	VARCHAR(40),
	Par_ReferenciaCobranza	VARCHAR(40),

	Par_ReferenciaNum		INT(7),
	Par_Prioridad  			INT(1),
	Par_EstatusRem   		INT(3),
	Par_UsuarioEnvio 		VARCHAR(30),
	Par_AreaEmiteID	 		INT(2),

	Par_FechaRecepcion		DATETIME,
	Par_CausaDevol    		INT(2),
	Par_Topologia     		CHAR(1),
	Par_Folio         		BIGINT(20),
	Par_FolioPaquete  		BIGINT(20),

	Par_FolioServidor		BIGINT(20),
	Par_Firma				VARCHAR(250),
	Par_RemesaWSID			BIGINT(20),
	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT,
	INOUT Par_ErrMen		VARCHAR(400),

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(20),
	Aud_ProgramaID			VARCHAR(50),

	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)

TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Entero_Cero		INT;
	DECLARE	Decimal_Cero	DECIMAL(18,2);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE Salida_SI 		CHAR(1);
	DECLARE	Salida_NO		CHAR(1);
	DECLARE Est_Pen         CHAR(1);
	DECLARE Fecha_Sist      DATE;
	DECLARE Mon_Pesos       INT(11);

	-- Declaracion de Variables
	DECLARE Var_Control	    VARCHAR(200);   -- Variable de control
	DECLARE Var_Consecutivo	BIGINT(20);     -- Variable consecutivo
	DECLARE Var_SpeiDet     BIGINT(20);
	DECLARE Var_SpeiSol     BIGINT(20);
	DECLARE Var_FechaDes    DATETIME;       -- Fecha de descarga
	DECLARE Var_FechaAut    DATETIME;       -- fecha autorizacion
	DECLARE Var_Estatus     CHAR(1);        -- estatus safi
	DECLARE Var_TotCta      DECIMAL(18,2);  -- total cargo cuenta
	DECLARE Var_UsuarioAut  VARCHAR(30);    -- Usuario que autoriza
	DECLARE Var_FolioSpei   BIGINT(20);     -- Folio del spei
	DECLARE Var_CuentaAho   INT(12);        -- cuenta del cliente
	DECLARE Var_MenError    VARCHAR(250);   -- mensaje de error

	-- Asignacion de Constantes
	SET	Cadena_Vacia	:= '';             -- Cadena Vacia
	SET	Fecha_Vacia		:= '1900-01-01 00:00:00';   -- Fecha Vacia
	SET	Entero_Cero		:= 0;              -- Entero Cero
	SET	Decimal_Cero	:= 0.0;            -- DECIMAL cero
	SET Salida_SI 	   	:= 'S';            -- Salida SI
	SET	Salida_NO		:= 'N';            -- Salida NO
	SET Mon_Pesos       := 1;              -- moneda pesos
	SET Est_Pen         := 'P';            -- Estatus pendiente

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			GET DIAGNOSTICS condition 1
			@Var_SQLState = RETURNED_SQLSTATE, @Var_SQLMessage = MESSAGE_TEXT;
			SET Par_NumErr = 999;
			SET Par_ErrMen =  LEFT(CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
				 'esto le ocasiona. Ref: SP-SPEIDESCARGASREMALT','[',@Var_SQLState,'-' , @Var_SQLMessage,']'), 400);
			SET Var_Control = 'sqlException';
		END;

		-- cuenta de ahorro
		SET Var_CuentaAho := Entero_Cero;

		-- Si la referencia cobranza viene nula se setea con un valor vacio
		SET Par_ReferenciaCobranza := IFNULL(Par_ReferenciaCobranza, Cadena_Vacia);

		-- Si el tipo de pago es diferente de 4 el tipo de operacion va vacio.
		SET Par_TipoOperacion := IFNULL(Par_TipoOperacion, Entero_Cero);

		-- Si el beneficiario dos no existe se setean todos los parametros del beneficiario dos a 0 o valores vacios.
		SET Par_CuentaBenefiDos := IFNULL(Par_CuentaBenefiDos, Entero_Cero);
		SET Par_NombreBenefiDos := IFNULL(Par_NombreBenefiDos, Cadena_Vacia);
		SET Par_RFCBenefiDos := IFNULL(Par_RFCBenefiDos, Cadena_Vacia);
		SET Par_TipoCuentaBenDos := IFNULL(Par_TipoCuentaBenDos, Entero_Cero);
		SET Par_ConceptoPagoDos := IFNULL(Par_ConceptoPagoDos, Cadena_Vacia);

		-- se setea la fecha de operaciona  fecha del sistema
		SET Var_FechaAut  := Fecha_Vacia;

		-- se setea estatus recepcion P pendiente por autorizar
		SET Var_Estatus := Est_Pen;

		-- se setea causa devolucion con valor cero
		SET Par_CausaDevol := IFNULL(Par_CausaDevol, Entero_Cero);


		SET Par_ComisionTrans := IFNULL(Par_ComisionTrans,Decimal_Cero);
		SET Par_IVAComision := IFNULL(Par_IVAComision,Decimal_Cero);
		SET Var_TotCta :=(Par_MontoTransferir+Par_ComisionTrans+Par_IVAComision);
		SET Var_UsuarioAut := IFNULL(Var_UsuarioAut,Cadena_Vacia);
		SET Var_FolioSpei := IFNULL(Var_FolioSpei,Entero_Cero);

		SET Aud_FechaActual := CURRENT_TIMESTAMP();
		SET Var_FechaDes := CURRENT_TIMESTAMP();
		SET Var_MenError := Cadena_Vacia;

		-- NUMERO CONSECUTIVO DE SPEIREMESAS
		SET Var_SpeiDet := (SELECT IFNULL(MAX(SpeiDetSolDesID),Entero_Cero) + 1
								FROM SPEIDESCARGASREM);

		INSERT INTO SPEIDESCARGASREM (
			SpeiDetSolDesID,						SpeiSolDesID,						FechaDescarga,						ClaveRastreo,						TipoPagoID,
			CuentaAho,								TipoCuentaOrd,						CuentaOrd,							NombreOrd,							RFCOrd,
			MonedaID,								TipoOperacion,						MontoTransferir,					IVAPorPagar,						ComisionTrans,
			IVAComision,							TotalCargoCuenta,					InstiRemitenteID,					InstiReceptoraID,					CuentaBeneficiario,
			NombreBeneficiario,						RFCBeneficiario,					TipoCuentaBen,						ConceptoPago,						CuentaBenefiDos,
			NombreBenefiDos,						RFCBenefiDos,						TipoCuentaBenDos,					ConceptoPagoDos,					ReferenciaCobranza,
			ReferenciaNum,							PrioridadEnvio,						FechaAutorizacion,					EstatusRem,							UsuarioEnvio,
			AreaEmiteID,							Estatus,							UsuarioAutoriza,					FolioSpei,							FechaRecepcion,
			CausaDevol,								Topologia,							Folio,								FolioPaquete,						FolioServidor,
			Firma,									MenError,							SucursalOpera,						RemesaWSID,
			EmpresaID,								Usuario,							FechaActual,						DireccionIP,						ProgramaID,
			Sucursal,								NumTransaccion)
		VALUES(
			Var_SpeiDet,							Par_SpeiSolDesID,					Var_FechaDes,						Par_ClaveRastreo,					Par_TipoPago,
			Var_CuentaAho,							Par_TipoCuentaOrd,					FNENCRYPTSAFI(Par_CuentaOrd),		FNENCRYPTSAFI(Par_NombreOrd),		FNENCRYPTSAFI(Par_RFCOrd),
			Mon_Pesos,								Par_TipoOperacion,					FNENCRYPTSAFI(Par_MontoTransferir),	Par_IVA,							Par_ComisionTrans,
			Par_IVAComision,						FNENCRYPTSAFI(Var_TotCta),			Par_InstiRemitente,					Par_InstiReceptora,					FNENCRYPTSAFI(Par_CuentaBeneficiario),
			FNENCRYPTSAFI(Par_NombreBeneficiario),	FNENCRYPTSAFI(Par_RFCBeneficiario),	Par_TipoCuentaBen,					FNENCRYPTSAFI(Par_ConceptoPago),	Par_CuentaBenefiDos,
			Par_NombreBenefiDos,					Par_RFCBenefiDos,					Par_TipoCuentaBenDos,				Par_ConceptoPagoDos,				Par_ReferenciaCobranza,
			Par_ReferenciaNum,						Par_Prioridad,						Var_FechaAut,						Par_EstatusRem,						Par_UsuarioEnvio,
			Par_AreaEmiteID,						Var_Estatus,						Var_UsuarioAut,						Var_FolioSpei,						Par_FechaRecepcion,
			Par_CausaDevol,							Par_Topologia,						Par_Folio,							Par_FolioPaquete,					Par_FolioServidor,
			Par_Firma,								Var_MenError,						Aud_Sucursal,						Par_RemesaWSID,
			Par_EmpresaID,							Aud_Usuario,						Aud_FechaActual,					Aud_DireccionIP,					Aud_ProgramaID,
			Aud_Sucursal,							Aud_NumTransaccion);

			SET Par_NumErr	:= 000;
			SET Par_ErrMen	:= CONCAT("Descarga Remesa SPEI Agregada Exitosamente: ", CONVERT(Var_SpeiDet, CHAR));
			SET Var_Control	:= 'numero' ;
			SET Var_Consecutivo	:=Var_SpeiDet;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
		Par_ErrMen AS ErrMen,
		Var_Control AS control,
		Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$