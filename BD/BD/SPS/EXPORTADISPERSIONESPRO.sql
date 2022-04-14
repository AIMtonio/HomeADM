DELIMITER ;

DROP PROCEDURE IF EXISTS EXPORTADISPERSIONESPRO;

DELIMITER $$

CREATE PROCEDURE `EXPORTADISPERSIONESPRO`(
/* PROCESAMIENTO DE EXPORTACION DE DISPERSIONES EN APORTACIONES */
	Par_AportacionID			INT(11),		-- ID de Aportación.
	Par_AmortizacionID			INT(11),		-- Id de la Amortizacion.
	Par_Salida					CHAR(1),		-- Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr			INT(11),		-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),	-- Mensaje de Error

	/* Parametros de Auditoria */
	Par_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),

	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE	Var_Control				CHAR(15);
	DECLARE	Var_FechaSistema		DATE;
	DECLARE	Var_Contador			INT(11);
	DECLARE	Var_ContadorEx			INT(11);
	DECLARE	Var_ContadorErr			INT(11);
	DECLARE	Var_TotalSPEI			INT(11);
	DECLARE	Var_NumBenef			INT(11);
	DECLARE	Var_ConBenef			CHAR(1);
	DECLARE	Var_Estatus				CHAR(1);
	DECLARE Var_MontoTotal			DECIMAL(18,2);
	DECLARE Var_MontoBenef			DECIMAL(18,2);
	DECLARE Var_ClabeOrden			varchar(18);

	DECLARE Var_Folio		   		BIGINT(20);
	DECLARE Var_ClaveRas	   		VARCHAR(30);
	DECLARE Var_TipoPago		   	INT(2);
	DECLARE Var_CuentaAho		   	BIGINT(12);
	DECLARE Var_TipoCuentaOrd	   	INT(2);
	DECLARE Var_CuentaOrd		   	VARCHAR(20);
	DECLARE Var_NombreOrd		   	VARCHAR(100);	-- NOMBRE DEL APORTANTE
	DECLARE Var_RFCOrd	           	VARCHAR(18);	-- RFC DEL APORTANTE
	DECLARE Var_MonedaID		   	INT(11);
	DECLARE Var_TipoOperacion	   	INT(2);
	DECLARE Var_MontoTransferir	   	DECIMAL(16,2);
	DECLARE Var_IVAPorPagar		   	DECIMAL(16,2);
	DECLARE Var_ComisionTrans	   	DECIMAL(16,2);
	DECLARE Var_IVAComision		   	DECIMAL(16,2);
	DECLARE Var_TotalCargoCuenta   	DECIMAL(18,2);
	DECLARE Var_InstiReceptora	   	INT(5);
	DECLARE Var_CuentaBeneficiario 	VARCHAR(20);
	DECLARE Var_NombreBeneficiario 	VARCHAR(100);
	DECLARE Var_RFCBeneficiario		VARCHAR(18);
	DECLARE Var_TipoCuentaBen	   	INT(2);
	DECLARE Var_ConceptoPago	   	VARCHAR(40);
	DECLARE Var_CuentaBenefiDos    	VARCHAR(20);
	DECLARE Var_NombreBenefiDos    	VARCHAR(100);
	DECLARE Var_RFCBenefiDos	   	VARCHAR(18);
	DECLARE Var_TipoCuentaBenDos   	INT(2);
	DECLARE Var_ConceptoPagoDos    	VARCHAR(40);
	DECLARE Var_ReferenciaCobranza 	VARCHAR(40);
	DECLARE Var_ReferenciaNum      	INT(7);
	DECLARE Var_UsuarioEnvio       	VARCHAR(30);
	DECLARE Var_AreaEmiteID	       	INT(2);
	DECLARE Var_OrigenOperacion		CHAR(1);
	DECLARE Var_NumInstitucion		VARCHAR(20);
	DECLARE Var_NumCtaInstitucion	VARCHAR(200);
	DECLARE	Var_Poliza				BIGINT;						-- Numero de poliza
	DECLARE Var_Descripcion			VARCHAR(150);
	DECLARE Var_Automatico			CHAR(1);
	DECLARE Var_CenCosto        	INT;
	DECLARE Var_CuentaCompleta		VARCHAR(50);
	DECLARE Var_SucursalOrigen		INT(11);
	DECLARE Var_Cuenta      		BIGINT(12);
	DECLARE Var_ClienteID			INT(11);
	DECLARE TipoMovAho				CHAR(4);
	DECLARE	Var_Cargos      		DECIMAL(14,4);
	DECLARE	Var_Abonos     	 		DECIMAL(14,4);
	DECLARE Var_TipoMovID			INT(11);

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia	VARCHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT(11);
	DECLARE	Cons_SI			CHAR(1);
	DECLARE	Cons_NO			CHAR(1);
	DECLARE	ActEstBenef		INT(11);
	DECLARE	ActEstatusAp	INT(11);
	DECLARE	EstatusSelec	CHAR(1);
	DECLARE	EstatusPend		CHAR(1);
	DECLARE	OrigenAport		CHAR(1);
	DECLARE	BajaXDispersion	INT(11);
	DECLARE	Pol_Automatica	CHAR(1);
	DECLARE CtoCon_Spei		INT(11);					-- Concepto Contable de ENVIO SPEI
	DECLARE	TipoMovAho_Spei	INT;
	DECLARE EncPoliza_NO	CHAR(1);
	DECLARE	AltaPoliza_SI	CHAR(1);
	DECLARE	Con_AhoCapital	INT;
	DECLARE	Nat_Cargo		CHAR(1);					-- Naturaleza Cargo
	DECLARE	Procedimiento   VARCHAR(30);
	DECLARE TipoInstrumentoID	INT(11);
	DECLARE CtoCon_DispRec	INT(11);
    DECLARE Decimal_Cero	DECIMAL(12,2);
    DECLARE Var_CuentaTranID INT(11);



	-- Asignacion de Constantes
	SET Cadena_Vacia		:= '';				-- Cadena vacia.
	SET Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia.
	SET Entero_Cero			:= 0;				-- Entero Cero.
	SET	Cons_SI				:= 'S';				-- Constante Si.
	SET	Cons_NO				:= 'N'; 			-- Constante No.
	SET ActEstBenef			:= 01;				-- Tipo de Actualización de Beneficiarios.
	SET ActEstatusAp		:= 02;				-- Tipo de Actualización Estatus de las Disp a Seleccionada.
	SET	EstatusSelec		:= 'S'; 			-- Estatus Seleccionada para Dispersar.
	SET	EstatusPend			:= 'P'; 			-- Estatus Pendiente por Dispersar.
	SET OrigenAport			:= 'A';				-- Tipo de Origen del SPEI: Aportación.
	SET BajaXDispersion		:= 02;				-- Tipo de Baja por Dispersión.
	SET Aud_FechaActual 	:= NOW();
	SET	Pol_Automatica  	:= 'A';				-- Poliza Automatica
	SET CtoCon_DispRec		:= 82;				-- Concepto Contable: DISPERSION DE RECURSOS corresponde de la tabla CONCEPTOSCONTA
	SET Nat_Cargo			:= 'C';				-- Naturaleza Cargo
	SET TipoMovAho_Spei		:= 224;				-- Tipo Movimiento SPEI
	SET EncPoliza_NO		:= 'N';				-- No genera Encabezado de Poliza en CARGOABONOCUENTAPRO
	SET	AltaPoliza_SI   	:= 'S';				-- Alta en poliza si
	SET	Con_AhoCapital  	:= 1;				-- Concepto Ahorro Capital corresponde con CONCEPTOSAHO
	SET Procedimiento		:= 'EXPORTADISPERSIONESPRO';	-- Nombre Procedimiento
	SET TipoInstrumentoID 	:= 31; 				-- Tipo de Instrumento: APORTACIONES corresponde de la tabla TIPOINSTRUMENTOS
	SET TipoMovAho   		:= '224';			-- Tipo de Movimiento de Ahorro
	SET Decimal_Cero		:= 0.00;			-- Decimal Cero

	-- Asignacion de Variables
	SET Var_Poliza			:= 0;				-- Inicializar Poliza
	SET Var_Automatico 		:= 'P';

	ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-EXPORTADISPERSIONESPRO');
			SET Var_Control:= 'sqlException' ;
		END;

	-- Se obtiene la fecha del sistema
	SELECT	FechaSistema 	INTO	Var_FechaSistema
	FROM	PARAMETROSSIS;

	SET Var_NumInstitucion 		:= (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = 'NumInstitucion');
	SET Var_NumCtaInstitucion 	:= (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = 'NumCtaInstitucion');

    SELECT CuentaAhoID,CuentaCompletaID
    INTO Var_Cuenta, Var_CuentaCompleta
    FROM CUENTASAHOTESO
    WHERE NumCtaInstit = Var_NumCtaInstitucion
    AND InstitucionID = Var_NumInstitucion
    LIMIT 1;

	DELETE FROM TMPAPORTDISPROC
	WHERE AportacionID = Par_AportacionID
		AND AmortizacionID = Par_AmortizacionID
		AND NumTransaccion = Aud_NumTransaccion;

	# VALIDAR QUE AL MENOS EXISTA 1 BENEFICIARIO.
	IF NOT EXISTS(SELECT * FROM APORTBENEFICIARIOS WHERE AportacionID = Par_AportacionID AND AmortizacionID = Par_AmortizacionID)THEN
		SET	Par_NumErr := 1;
		SET	Par_ErrMen := CONCAT('No Existen Beneficiarios para la Aportacion: ',Par_AportacionID,' Cuota: ',Par_AmortizacionID,'.');
		LEAVE ManejoErrores;
	END IF;

	SET Var_MontoTotal := (SELECT Total FROM APORTDISPERSIONES WHERE AportacionID = Par_AportacionID AND AmortizacionID = Par_AmortizacionID);
	SET Var_MontoBenef := (SELECT SUM(MontoDispersion) FROM APORTBENEFICIARIOS WHERE AportacionID = Par_AportacionID AND AmortizacionID = Par_AmortizacionID);

	# VALIDAR QUE EL MONTO A DISPERSAR SEA ELMISMO QUE SE TIENE QUE DISPERSAR.
	IF(IFNULL(Var_MontoTotal, Entero_Cero) != IFNULL(Var_MontoBenef, Entero_Cero))THEN
		SET	Par_NumErr := 2;
		SET	Par_ErrMen := CONCAT('El Monto a Dispersar debe ser Igual al Total a Dispersar. Aportacion: ',Par_AportacionID,' Cuota: ',Par_AmortizacionID,'.');
		LEAVE ManejoErrores;
	END IF;

	SET Var_TipoPago 			:= 1; # TIPO DE PAGO TERCERO A TERCERO (TIPOSPAGOSPEI)
	SET Var_TipoCuentaOrd 		:= 40; #TIPO CUENTA CLABE (TIPOSCUENTASPEI)
	SET Var_TipoOperacion 		:= Entero_Cero;
	SET Var_IVAPorPagar 		:= Entero_Cero;
	SET Var_ComisionTrans 		:= Entero_Cero;
	SET Var_IVAComision 		:= Entero_Cero;
	SET Var_ConceptoPago 		:= CONCAT('APORTACION: ',Par_AportacionID,'. CUOTA: ',Par_AmortizacionID,'.');
	SET Var_CuentaBenefiDos 	:= Entero_Cero;
	SET Var_NombreBenefiDos 	:= Cadena_Vacia;
	SET Var_RFCBenefiDos 		:= Cadena_Vacia;
	SET Var_TipoCuentaBenDos 	:= Entero_Cero;
	SET Var_ConceptoPagoDos 	:= Cadena_Vacia;
	SET Var_ReferenciaCobranza 	:= Cadena_Vacia;
	SET Var_ReferenciaNum 		:= Entero_Cero;
	SET Var_UsuarioEnvio 		:= (SELECT LEFT(UPPER(NombreCompleto),30) FROM USUARIOS WHERE UsuarioID = Aud_Usuario);
	SET Var_AreaEmiteID 		:= 6; # OTRA (AREASEMITESPEI)
	SET Var_OrigenOperacion 	:= OrigenAport;

	# DATOS DEL ORDENANTE (APORTANTE)
	SELECT
		LEFT(CT.NombreCompleto,100),CT.RFCOficial,	AD.CuentaAhoID,	CA.Clabe,		CA.MonedaID
	INTO
		Var_NombreOrd,				Var_RFCOrd,		Var_CuentaAho,	Var_CuentaOrd,	Var_MonedaID
	FROM APORTDISPERSIONES AD
		INNER JOIN CLIENTES CT ON AD.ClienteID = CT.ClienteID
		INNER JOIN CUENTASAHO CA ON AD.CuentaAhoID = CA.CuentaAhoID
	WHERE AD.AportacionID = Par_AportacionID AND AD.AmortizacionID = Par_AmortizacionID;

	SET @CONSID := Entero_Cero;

	# DATOS DE LOS BENEFICIARIOS.
	INSERT INTO TMPAPORTDISPROC(
		AportacionID,		AmortizacionID,			TMPID,						CuentaTranID,			TipoPago,
		CuentaAho,			TipoCuentaOrd,			CuentaOrd,					NombreOrd,				RFCOrd,
		MonedaID,			TipoOperacion,			MontoTransferir,			IVAPorPagar,			ComisionTrans,
		IVAComision,		TotalCargoCuenta,
		InstiReceptora,		CuentaBeneficiario,		NombreBeneficiario,
		RFCBeneficiario,	TipoCuentaBen,			ConceptoPago,				CuentaBenefiDos,		NombreBenefiDos,
		RFCBenefiDos,		TipoCuentaBenDos,		ConceptoPagoDos,			ReferenciaCobranza,		ReferenciaNum,
		UsuarioEnvio,		AreaEmiteID,			OrigenOperacion,			NumTransaccion)
	SELECT
		AB.AportacionID,	AB.AmortizacionID,		(@CONSID := @CONSID + 1),	AB.CuentaTranID,		Var_TipoPago,
		Var_CuentaAho,		Var_TipoCuentaOrd,		Var_CuentaOrd,				Var_NombreOrd,			Var_RFCOrd,
		Var_MonedaID,		Var_TipoOperacion,		AB.MontoDispersion,			Var_IVAPorPagar,		Var_ComisionTrans,
		Var_IVAComision,	(AB.MontoDispersion + Var_IVAPorPagar + Var_ComisionTrans + Var_IVAComision),
		AB.InstitucionID,	AB.Clabe,				AB.Beneficiario,
		CT.RFCBeneficiario,	AB.TipoCuentaSpei,		Var_ConceptoPago,			Var_CuentaBenefiDos,	Var_NombreBenefiDos,
		Var_RFCBenefiDos,	Var_TipoCuentaBenDos,	Var_ConceptoPagoDos,		Var_ReferenciaCobranza,	Var_ReferenciaNum,
		Var_UsuarioEnvio,	Var_AreaEmiteID,		Var_OrigenOperacion,		Aud_NumTransaccion
	FROM APORTBENEFICIARIOS AB
		INNER JOIN APORTACIONES AP ON AB.AportacionID = AP.AportacionID
		INNER JOIN CUENTASTRANSFER CT ON AP.ClienteID = CT.ClienteID AND AB.CuentaTranID = CT.CuentaTranID
	WHERE AB.AportacionID = Par_AportacionID AND AB.AmortizacionID = Par_AmortizacionID;


	SET Var_Contador := 1;
	SET Var_ContadorEx := Entero_Cero;
	SET Var_ContadorErr := Entero_Cero;
	SET Var_TotalSPEI := (SELECT COUNT(*) FROM TMPAPORTDISPROC WHERE AportacionID = Par_AportacionID
							AND AmortizacionID = Par_AmortizacionID AND NumTransaccion = Aud_NumTransaccion);

	WHILE(Var_Contador <= Var_TotalSPEI)DO
		SELECT
			TipoPago,				CuentaAho,				TipoCuentaOrd,		CuentaOrd,				CuentaTranID,
			NombreOrd,				RFCOrd,					MonedaID,			TipoOperacion,			MontoTransferir,
			IVAPorPagar,			ComisionTrans,			IVAComision,		TotalCargoCuenta,		InstiReceptora,
			CuentaBeneficiario,		NombreBeneficiario,		RFCBeneficiario,	TipoCuentaBen,			ConceptoPago,
			CuentaBenefiDos,		NombreBenefiDos,		RFCBenefiDos,		TipoCuentaBenDos,		ConceptoPagoDos,
			ReferenciaCobranza,		ReferenciaNum,			UsuarioEnvio,		AreaEmiteID,			OrigenOperacion
		INTO
			Var_TipoPago,			Var_CuentaAho,			Var_TipoCuentaOrd,	Var_CuentaOrd,			Var_CuentaTranID,
			Var_NombreOrd,			Var_RFCOrd,				Var_MonedaID,		Var_TipoOperacion,		Var_MontoTransferir,
			Var_IVAPorPagar,		Var_ComisionTrans,		Var_IVAComision,	Var_TotalCargoCuenta,	Var_InstiReceptora,
			Var_CuentaBeneficiario,	Var_NombreBeneficiario,	Var_RFCBeneficiario,Var_TipoCuentaBen,		Var_ConceptoPago,
			Var_CuentaBenefiDos,	Var_NombreBenefiDos,	Var_RFCBenefiDos,	Var_TipoCuentaBenDos,	Var_ConceptoPagoDos,
			Var_ReferenciaCobranza,	Var_ReferenciaNum,		Var_UsuarioEnvio,	Var_AreaEmiteID,		Var_OrigenOperacion
		FROM TMPAPORTDISPROC
		WHERE AportacionID = Par_AportacionID
			AND AmortizacionID = Par_AmortizacionID
			AND TMPID = Var_Contador
			AND NumTransaccion = Aud_NumTransaccion;

        SET Var_Descripcion := 'DISPERSION DE RECURSOS';
		CALL MAESTROPOLIZASALT(
			Var_Poliza,			Par_EmpresaID,    	Var_FechaSistema, 		Pol_Automatica,		CtoCon_DispRec,
			Var_Descripcion,	Cons_NO,      		Par_NumErr,				Par_ErrMen,			Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,   	Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

        SET Var_ClienteID		:= (SELECT ClienteID FROM CUENTASAHO WHERE CuentaAhoID = Var_CuentaAho);
        SET Var_ReferenciaNum	:= (SELECT CONCAT(DATE_FORMAT(Var_FechaSistema, '%d%m%y'),'0'));

        SET Var_SucursalOrigen := (SELECT SucursalOrigen FROM CLIENTES WHERE ClienteID = Var_ClienteID);
        SET Var_SucursalOrigen := IFNULL(Var_SucursalOrigen,Entero_Cero);

		CALL CARGOABONOCUENTAPRO(
			Var_CuentaAho,		Var_ClienteID,		Aud_NumTransaccion, Var_FechaSistema, 	Var_FechaSistema,
			Nat_Cargo,			Var_MontoTransferir,Var_Descripcion, 	Var_ReferenciaNum,	TipoMovAho,
			Var_MonedaID, 		Var_SucursalOrigen, EncPoliza_NO,		CtoCon_DispRec,		Var_Poliza,
			AltaPoliza_SI, 		Con_AhoCapital,		Nat_Cargo, 			Entero_Cero,		Cons_NO,
			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,   	Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		SET Var_TipoMovID	:= 13;

		CALL TESORERIAMOVIMIALT(
			Var_Cuenta,			Var_FechaSistema,		Var_MontoTransferir,Var_Descripcion, 	Var_ReferenciaNum,
			Cadena_Vacia,     	Nat_Cargo,  			Var_Automatico, 	Var_TipoMovID,  	Entero_Cero,
			Entero_Cero,		Cons_NO,        		Par_NumErr,         Par_ErrMen,     	Par_EmpresaID,
			Aud_Usuario,        Aud_FechaActual,    	Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,
			Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		CALL SALDOSCUENTATESOACT(
			Var_NumCtaInstitucion,	Var_NumInstitucion,	Var_MontoTransferir,Nat_Cargo,			Entero_Cero,
			Cons_NO,				Par_NumErr,       	Par_ErrMen,     	Par_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,		Aud_DireccionIP,   	Aud_ProgramaID, 	Aud_Sucursal,     	Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		SET	Var_Cargos	:= Decimal_Cero;
		SET	Var_Abonos	:= Var_MontoTransferir;

		SET Var_CenCosto := (SELECT CentroCostoID FROM SUCURSALES WHERE SucursalID = Aud_Sucursal);
        SET Var_CenCosto := IFNULL(Var_CenCosto,Entero_Cero);

		CALL DETALLEPOLIZASALT(
			Par_EmpresaID,		Var_Poliza,			Var_FechaSistema, 	Var_CenCosto,		Var_CuentaCompleta,
			Par_AportacionID,	Var_MonedaID,		Var_Cargos,			Var_Abonos,			Var_Descripcion,
			Par_AportacionID,	Procedimiento,		TipoInstrumentoID,	Cadena_Vacia,		Decimal_Cero,
			Cadena_Vacia,		Cons_NO,			Par_NumErr,			Par_ErrMen,			Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		-- SE GUARDAN EN LOS HISTÓRICOS. (DISPERSIONES Y SUS BENEFICIARIOS).

		CALL HISAPORTDISPERSIONESALT(
			Par_AportacionID,	Par_AmortizacionID,	Cons_NO,			Par_NumErr,			Par_ErrMen,
			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
			Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		CALL HISAPORTBENEFICIARIOSALT(
			Par_AportacionID,	Par_AmortizacionID,	Var_CuentaTranID,	BajaXDispersion,	Cons_NO,			
			Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		SET Var_Contador := Var_Contador + 1;
	END WHILE;

	DELETE FROM TMPAPORTDISPROC
	WHERE AportacionID = Par_AportacionID
		AND AmortizacionID = Par_AmortizacionID
		AND NumTransaccion = Aud_NumTransaccion;

	SET	Par_NumErr := 0;
	SET	Par_ErrMen := 'Exporta Dispersion(es) Procesada(s) Exitosamente.';
	SET Var_Control:= 'numTransaccion' ;

END ManejoErrores;

IF (Par_Salida = Cons_SI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Aud_NumTransaccion AS Consecutivo;
END IF;

END TerminaStore$$