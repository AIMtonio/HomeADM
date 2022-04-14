

-- APORTDISPERSIONESPRO --

DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTDISPERSIONESPRO`;
-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE `APORTDISPERSIONESPRO`(
/* PROCESAMIENTO DE DISPERSIONES EN APORTACIONES PARA ENVIARSE POR SPEI */
	Par_AportacionID			INT(11),		-- ID de Aportación.
	Par_AmortizacionID			INT(11),		-- Id de la Amortizacion.
	Par_CuentaTranID			INT(11),		-- No consecutivo de cuentas transfer por cliente.
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
DECLARE	Var_FechaSistema		CHAR(15);
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
DECLARE Var_CuentaTranID INT(11);
DECLARE Var_CuentaTrans	 INT(11);
DECLARE Var_SPEI		 CHAR(1);
DECLARE Var_MontoDispersion DECIMAL(18,2);
DECLARE Var_MontoPendiente  DECIMAL(18,2);
DECLARE Var_ClienteID 	INT(11);
DECLARE Var_NatMovBloqueo			CHAR(1);
DECLARE Var_TipoBloqueo		INT(11);
DECLARE Var_DescripBloqueo	VARCHAR(100);
DECLARE Var_BloqueoID	BIGINT(20);
DECLARE Var_AportacionID 	INT(11);
DECLARE	Var_AmortizacionID  INT(11)	;
DECLARE	Var_AportBeneficiarioID BIGINT UNSIGNED;
DECLARE Var_EsPrincipal		CHAR(1);


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
SET Var_SPEI			:= (SELECT Habilitado FROM PARAMETROSSPEI WHERE EmpresaID = 1);
SET Var_NatMovBloqueo 		:= 'B';
SET Var_FechaSistema 	:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
SET Var_TipoBloqueo		:= 1;				-- Tipo de Bloque por Dispersion
SET Var_DescripBloqueo  := 'BLOQUEO POR DISPERSION EN TESORERIA';

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-APORTDISPERSIONESPRO');
			SET Var_Control:= 'sqlException' ;
		END;

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

	SET Var_ClienteID := (SELECT  ClienteID  FROM APORTDISPERSIONES WHERE AportacionID = Par_AportacionID AND AmortizacionID = Par_AmortizacionID) ;
	SET Var_ClienteID := IFNULL(Var_ClienteID,Entero_Cero);
	SET Var_CuentaAho = (SELECT CuentaAhoID FROM APORTACIONES WHERE  AportacionID = Par_AportacionID);
	SET Var_MontoTotal := (SELECT MontoPendiente FROM APORTCTADISPERSIONES WHERE CuentaAhoID = Var_CuentaAho);
	SET Var_MontoBenef := (SELECT SUM(MontoDispersion) FROM APORTBENEFICIARIOS WHERE AportacionID = Par_AportacionID AND AmortizacionID = Par_AmortizacionID AND CuentaTranID = Par_CuentaTranID);

	# VALIDAR QUE EL MONTO A DISPERSAR NO SEA MAYOR QUE SE TIENE QUE DISPERSAR.
	IF( IFNULL(Var_MontoBenef, Entero_Cero)  > IFNULL(Var_MontoTotal, Entero_Cero))THEN
		SET	Par_NumErr := 2;
		SET	Par_ErrMen := CONCAT('El Monto a Dispersar no debe ser Mayor al Total a Dispersar. Aportacion: ',Par_AportacionID,' Cuota: ',Par_AmortizacionID,'.');
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
		UsuarioEnvio,		AreaEmiteID,			OrigenOperacion,			NumTransaccion,			AportBeneficiarioID)
	SELECT
		AB.AportacionID,	AB.AmortizacionID,		(@CONSID := @CONSID + 1),	AB.CuentaTranID,		Var_TipoPago,
		Var_CuentaAho,		Var_TipoCuentaOrd,		Var_CuentaOrd,				Var_NombreOrd,			Var_RFCOrd,
		Var_MonedaID,		Var_TipoOperacion,		AB.MontoDispersion,			Var_IVAPorPagar,		Var_ComisionTrans,
		Var_IVAComision,	AB.MontoDispersion,
		AB.InstitucionID,	AB.Clabe,				AB.Beneficiario,
		CT.RFCBeneficiario,	AB.TipoCuentaSpei,		Var_ConceptoPago,			Var_CuentaBenefiDos,	Var_NombreBenefiDos,
		Var_RFCBenefiDos,	Var_TipoCuentaBenDos,	Var_ConceptoPagoDos,		Var_ReferenciaCobranza,	Var_ReferenciaNum,
		Var_UsuarioEnvio,	Var_AreaEmiteID,		Var_OrigenOperacion,		Aud_NumTransaccion,		AB.AportBeneficiarioID
	FROM APORTBENEFICIARIOS AB
		INNER JOIN APORTACIONES AP ON AB.AportacionID = AP.AportacionID
		INNER JOIN CUENTASTRANSFER CT ON AP.ClienteID = CT.ClienteID AND AB.CuentaTranID = CT.CuentaTranID
	WHERE AB.AportacionID = Par_AportacionID AND AB.AmortizacionID = Par_AmortizacionID AND AB.CuentaTranID = Par_CuentaTranID;

	IF(Var_SPEI = "S") THEN
    	SET Var_Contador := 1;
		SET Var_ContadorEx := Entero_Cero;
		SET Var_ContadorErr := Entero_Cero;
		SET Var_TotalSPEI := (SELECT COUNT(*) FROM TMPAPORTDISPROC WHERE AportacionID = Par_AportacionID
								AND AmortizacionID = Par_AmortizacionID AND CuentaTranID = Par_CuentaTranID  AND NumTransaccion = Aud_NumTransaccion);

		WHILE(Var_Contador <= Var_TotalSPEI)DO

			SELECT
				TipoPago,				CuentaAho,				TipoCuentaOrd,		CuentaOrd,				CuentaTranID,
				NombreOrd,				RFCOrd,					MonedaID,			TipoOperacion,			MontoTransferir,
				IVAPorPagar,			ComisionTrans,			IVAComision,		TotalCargoCuenta,		InstiReceptora,
				CuentaBeneficiario,		NombreBeneficiario,		RFCBeneficiario,	TipoCuentaBen,			ConceptoPago,
				CuentaBenefiDos,		NombreBenefiDos,		RFCBenefiDos,		TipoCuentaBenDos,		ConceptoPagoDos,
				ReferenciaCobranza,		ReferenciaNum,			UsuarioEnvio,		AreaEmiteID,			OrigenOperacion,
				AportacionID,			AmortizacionID,			AportBeneficiarioID
			INTO
				Var_TipoPago,			Var_CuentaAho,			Var_TipoCuentaOrd,	Var_CuentaOrd,			Var_CuentaTranID,
				Var_NombreOrd,			Var_RFCOrd,				Var_MonedaID,		Var_TipoOperacion,		Var_MontoTransferir,
				Var_IVAPorPagar,		Var_ComisionTrans,		Var_IVAComision,	Var_TotalCargoCuenta,	Var_InstiReceptora,
				Var_CuentaBeneficiario,	Var_NombreBeneficiario,	Var_RFCBeneficiario,Var_TipoCuentaBen,		Var_ConceptoPago,
				Var_CuentaBenefiDos,	Var_NombreBenefiDos,	Var_RFCBenefiDos,	Var_TipoCuentaBenDos,	Var_ConceptoPagoDos,
				Var_ReferenciaCobranza,	Var_ReferenciaNum,		Var_UsuarioEnvio,	Var_AreaEmiteID,		Var_OrigenOperacion,
				Var_AportacionID,		Var_AmortizacionID,		Var_AportBeneficiarioID
			FROM TMPAPORTDISPROC
			WHERE AportacionID = Par_AportacionID
				AND AmortizacionID = Par_AmortizacionID
				AND CuentaTranID = Par_CuentaTranID
				AND TMPID = Var_Contador
				AND NumTransaccion = Aud_NumTransaccion;

			CALL SPEIENVIOSPRO(
				Var_Folio,				Var_ClaveRas,			Var_TipoPago,			Var_CuentaAho,			Var_TipoCuentaOrd,
				Var_CuentaOrd,			Var_NombreOrd,			Var_RFCOrd,				Var_MonedaID,			Var_TipoOperacion,
				Var_MontoTransferir,	Var_IVAPorPagar,		Var_ComisionTrans,		Var_IVAComision,		Var_TotalCargoCuenta,
				Var_InstiReceptora,		Var_CuentaBeneficiario,	Var_NombreBeneficiario,	Var_RFCBeneficiario,	Var_TipoCuentaBen,
				Var_ConceptoPago,		Var_CuentaBenefiDos,	Var_NombreBenefiDos,	Var_RFCBenefiDos,		Var_TipoCuentaBenDos,
				Var_ConceptoPagoDos,	Var_ReferenciaCobranza,	Var_ReferenciaNum,		Var_UsuarioEnvio,		Var_AreaEmiteID,
				Var_OrigenOperacion,	Cons_NO,				Par_NumErr,				Par_ErrMen,				Par_EmpresaID,
				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
				Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			INSERT INTO SPEIAPORTACIONES(FolioSpeiID,			 ClaveRastreo, 			Estatus, 			 AportBeneficiarioID,			CuentaAhoID,
										 MontoAportacion,		 EmpresaID,  			Usuario, 			 FechaActual, 					DireccionIP,
										 ProgramaID,			 Sucursal,    			NumTransaccion)
			SELECT 						 Var_Folio, 	 	     Var_ClaveRas, 			 EstatusPend,  			Var_AportBeneficiarioID, 	Var_CuentaAho,
				  						 Var_MontoTransferir,	 Par_EmpresaID,	  		 Aud_Usuario,			Aud_FechaActual,			Aud_DireccionIP,
				  						 Aud_ProgramaID,		 Aud_Sucursal,	  		 Aud_NumTransaccion;
			SET Var_Contador := Var_Contador + 1;
		END WHILE;
	ELSE

		SET Var_Contador := 1;
		SET Var_ContadorEx := Entero_Cero;
		SET Var_ContadorErr := Entero_Cero;
		SET Var_TotalSPEI := (SELECT COUNT(*) FROM TMPAPORTDISPROC WHERE AportacionID = Par_AportacionID
								AND AmortizacionID = Par_AmortizacionID AND CuentaTranID = Par_CuentaTranID  AND NumTransaccion = Aud_NumTransaccion);

		WHILE(Var_Contador <= Var_TotalSPEI)DO

			SELECT
				TipoPago,				CuentaAho,				TipoCuentaOrd,		CuentaOrd,				CuentaTranID,
				NombreOrd,				RFCOrd,					MonedaID,			TipoOperacion,			MontoTransferir,
				IVAPorPagar,			ComisionTrans,			IVAComision,		TotalCargoCuenta,		InstiReceptora,
				CuentaBeneficiario,		NombreBeneficiario,		RFCBeneficiario,	TipoCuentaBen,			ConceptoPago,
				CuentaBenefiDos,		NombreBenefiDos,		RFCBenefiDos,		TipoCuentaBenDos,		ConceptoPagoDos,
				ReferenciaCobranza,		ReferenciaNum,			UsuarioEnvio,		AreaEmiteID,			OrigenOperacion,
				AportacionID,			AmortizacionID,			AportBeneficiarioID
			INTO
				Var_TipoPago,			Var_CuentaAho,			Var_TipoCuentaOrd,	Var_CuentaOrd,			Var_CuentaTranID,
				Var_NombreOrd,			Var_RFCOrd,				Var_MonedaID,		Var_TipoOperacion,		Var_MontoTransferir,
				Var_IVAPorPagar,		Var_ComisionTrans,		Var_IVAComision,	Var_TotalCargoCuenta,	Var_InstiReceptora,
				Var_CuentaBeneficiario,	Var_NombreBeneficiario,	Var_RFCBeneficiario,Var_TipoCuentaBen,		Var_ConceptoPago,
				Var_CuentaBenefiDos,	Var_NombreBenefiDos,	Var_RFCBenefiDos,	Var_TipoCuentaBenDos,	Var_ConceptoPagoDos,
				Var_ReferenciaCobranza,	Var_ReferenciaNum,		Var_UsuarioEnvio,	Var_AreaEmiteID,		Var_OrigenOperacion,
				Var_AportacionID,		Var_AmortizacionID,		Var_AportBeneficiarioID
			FROM TMPAPORTDISPROC
			WHERE AportacionID = Par_AportacionID
				AND AmortizacionID = Par_AmortizacionID
				AND CuentaTranID = Par_CuentaTranID
				AND TMPID = Var_Contador
				AND NumTransaccion = Aud_NumTransaccion;

			CALL BLOQUEOSPRO(
					Entero_Cero,    	Var_NatMovBloqueo,  	Var_CuentaAho,  	    Var_FechaSistema,        	Var_TotalCargoCuenta,
					Fecha_Vacia,    	Var_TipoBloqueo,    	Var_DescripBloqueo,     Aud_NumTransaccion,         Cadena_Vacia,
					Cadena_Vacia,   	Cons_NO,       		  	Par_NumErr, 			Par_ErrMen,			 		Par_EmpresaID,
					Aud_Usuario,        Aud_FechaActual,    	Aud_DireccionIP,    	Aud_ProgramaID,   		 	Aud_Sucursal,
					Aud_NumTransaccion);

				IF (Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

			SET Var_BloqueoID := Entero_Cero;
			SET Var_EsPrincipal := (SELECT EsPrincipal FROM APORTBENEFICIARIOS WHERE AportBeneficiarioID = Var_AportBeneficiarioID);



			INSERT INTO TMPDISPERSIONAPOR(
				TransaccionID,			AportacionID,				AmortizacionID,			CuentaTranID,				InstitucionID,
				TipoCuentaSpei,			Clabe,						Beneficiario,			EsPrincipal,				MontoDispersion,
				NumReg,					EmpresaID,					Usuario,				FechaActual,				DireccionIP,
				ProgramaID,				Sucursal,					numTransaccion,			AportBeneficiarioID,		BloqueoID)
			SELECT
				Aud_NumTransaccion,		Var_AportacionID,			Var_AmortizacionID,		Var_CuentaTranID,			Var_InstiReceptora,
				Var_TipoCuentaBen,		Var_CuentaBeneficiario,		Var_NombreBeneficiario,	Var_EsPrincipal,			Var_MontoTransferir,
				Var_Contador,			Par_EmpresaID,				Aud_Usuario,			Aud_FechaActual,	    	Aud_DireccionIP,
				Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion,		Var_AportBeneficiarioID,	Var_BloqueoID;

			SET Var_Contador := Var_Contador + 1;

		END WHILE;




    END IF;
	# SE GUARDAN EN LOS HISTÓRICOS. (DISPERSIONES Y SUS BENEFICIARIOS).
            # SI SE PAGA EL TOTAL DE LA APORTACION ENTONCES ELIMINAMOS TANTO LA APORTACION COMO LOS BENEFICIARIOS
			IF (Var_MontoTotal = Var_MontoBenef) THEN
				CALL HISAPORTDISPERSIONESALT(
					Par_AportacionID,	Par_AmortizacionID,	Cons_NO,			Par_NumErr,			Par_ErrMen,
					Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
					Aud_Sucursal,		Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
			ELSE
				SELECT CuentaTranID INTO Var_CuentaTrans
				FROM APORTDISPERSIONES
					WHERE AportacionID = Par_AportacionID
						AND AmortizacionID = Par_AmortizacionID
                        AND CuentaTranID = Par_CuentaTranID;
				SET Var_CuentaTrans = IFNULL(Var_CuentaTrans,Entero_Cero);

                IF(Var_CuentaTrans > Entero_Cero ) THEN
					SET Var_CuentaTranID = Entero_Cero;
                    SET Var_CuentaTranID = (SELECT MAX(CuentaTranID) FROM APORTBENEFICIARIOS WHERE AportacionID = Par_AportacionID AND AmortizacionID = Par_AmortizacionID );
                    UPDATE APORTDISPERSIONES SET CuentaTranID = Var_CuentaTranID WHERE AportacionID = Par_AportacionID AND AmortizacionID = Par_AmortizacionID ;
                END IF;

                SELECT SUM(AB.MontoDispersion) INTO Var_MontoDispersion FROM APORTBENEFICIARIOS AB WHERE  AB.AportacionID =  Par_AportacionID AND AB.AmortizacionID = Par_AmortizacionID AND AB.CuentaTranID = Par_CuentaTranID;
				SET Var_MontoDispersion := IFNULL(Var_MontoDispersion,Entero_Cero);

                SELECT SUM(MontoPendiente) INTO Var_MontoPendiente FROM APORTCTADISPERSIONES WHERE CuentaAhoID = Var_CuentaAho;
                SET Var_MontoPendiente := IFNULL(Var_MontoPendiente,Entero_Cero);

                UPDATE  APORTDISPERSIONES AP
					SET AP.MontoPendiente = (Var_MontoPendiente - Var_MontoDispersion)
				WHERE  AP.AportacionID = Par_AportacionID AND AP.AmortizacionID = Par_AmortizacionID;

				SET Var_CuentaAho = (SELECT CuentaAhoID FROM APORTACIONES WHERE  AportacionID = Par_AportacionID);

			    UPDATE  APORTCTADISPERSIONES AP
					SET AP.MontoPendiente =  (AP.MontoPendiente  - Var_MontoDispersion)
				WHERE  AP.CuentaAhoID = Var_CuentaAho;


			END IF;

			CALL HISAPORTBENEFICIARIOSALT(
				Par_AportacionID,	Par_AmortizacionID,	Par_CuentaTranID,	BajaXDispersion,	Cons_NO,
				Par_NumErr,			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

	DELETE FROM TMPAPORTDISPROC
	WHERE AportacionID = Par_AportacionID
		AND AmortizacionID = Par_AmortizacionID
		AND NumTransaccion = Aud_NumTransaccion;

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := 'Dispersion(es) Procesada(s) Exitosamente.';
	SET Var_Control:= 'numTransaccion' ;

END ManejoErrores;

IF (Par_Salida = Cons_SI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Aud_NumTransaccion AS Consecutivo,
			Cadena_Vacia AS SpeiControl;
END IF;

END TerminaStore$$