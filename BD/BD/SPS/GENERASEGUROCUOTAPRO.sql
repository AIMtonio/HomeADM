-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GENERASEGUROCUOTAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `GENERASEGUROCUOTAPRO`;
DELIMITER $$

CREATE PROCEDURE `GENERASEGUROCUOTAPRO`(
	-- Genera el Saldo de Seguro por Cuota
	Par_Fecha 				DATE,
	Par_Salida 				CHAR(1),		# Salida S:Si N:No
	Par_NumErr				INT(11),		# Numero de Error
	Par_ErrMen				VARCHAR(400),	# Mensaje de Error
	Par_EmpresaID 			INT(11),

	Aud_Usuario 			INT(11),
	Aud_FechaActual 		DATETIME,
	Aud_DireccionIP 		VARCHAR(15),
	Aud_ProgramaID 			VARCHAR(50),
	Aud_Sucursal 			INT(11),
	Aud_NumTransaccion 		BIGINT(20)

		)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_CreditoID			BIGINT(12);
	DECLARE Var_AmortizacionID		INT;
	DECLARE Var_FechaInicio			DATE;
	DECLARE Var_FechaVencim			DATE;
	DECLARE Var_FechaExigible		DATE;

	DECLARE Var_EmpresaID			INT;
	DECLARE Var_FormulaID			INT(11);
	DECLARE Var_MonedaID			INT(11);
	DECLARE Var_SucCliente			INT;
	DECLARE Var_ProdCreID			INT;

	DECLARE Var_ClasifCre			CHAR(1);
	DECLARE Var_MontoSeguroCuota	DECIMAL(14,2);
	DECLARE Var_IVASeguroCuota		DECIMAL(14,2);
	DECLARE Var_SubClasifID 		INT;
	DECLARE Var_SucursalCred		INT;

	DECLARE Var_CobraSeguroCuota	CHAR(1);
	DECLARE Var_CobraIVASeguroCuota	CHAR(1);
	DECLARE Var_CreditoStr 			VARCHAR(30);
	DECLARE Error_Key 	 			INT;
	DECLARE Mov_AboConta 	 		INT;

    DECLARE Var_FecApl      		DATE;
    DECLARE Var_ContadorCre 		INT;
    DECLARE Par_Consecutivo 		BIGINT;

	DECLARE Mov_CarContaSegCuota 	INT;
	DECLARE Mov_CarOperaSegCuota 	INT;
    DECLARE Mov_CarContaIVASegCuota INT;
    DECLARE Mov_CarOperaIVASegCuota INT;
    DECLARE Var_Poliza  		    BIGINT;

	-- Declaracion de constantes
	DECLARE Cadena_Vacia 			CHAR(1);
	DECLARE Fecha_Vacia 			DATE;
	DECLARE Entero_Cero 			INT;
	DECLARE Decimal_Cero 			DECIMAL(12, 2);
	DECLARE Estatus_Vigente 		CHAR(1);

	DECLARE Estatus_Vencida 		CHAR(1);
	DECLARE Estatus_Atrasada 		CHAR(1);
	DECLARE Pro_GenSegCuota 		INT;
	DECLARE SiCobSeguroCuota		CHAR(1);
	DECLARE Mov_SegCuota 			INT;

    DECLARE Con_IngSegCuota 		INT;
	DECLARE SiCobIVASeguroCuota		CHAR(1);
	DECLARE Mov_IVASegCuota 		INT;
	DECLARE Con_IVASegCuota 		INT;
    DECLARE Pol_Automatica  		CHAR(1);

    DECLARE Par_SalidaNO    		CHAR(1);
    DECLARE Con_GenSegCuota			INT;
	DECLARE AltaPoliza_NO   		CHAR(1);
    DECLARE AltaPolCre_SI   		CHAR(1);
    DECLARE AltaMovCre_SI   		CHAR(1);

    DECLARE AltaMovCre_NO   		CHAR(1);
	DECLARE AltaMovAho_NO   		CHAR(1);
    DECLARE Nat_Cargo       		CHAR(1);

	DECLARE Des_CieDia 				VARCHAR(100);
	DECLARE Ref_GenSeguroCuota 		VARCHAR(100);
    DECLARE Ref_GenIVASeguroCuota   VARCHAR(100);

    DECLARE Des_ErrorGral 			VARCHAR(100);
	DECLARE Des_ErrorLlavDup 		VARCHAR(100);
	DECLARE Des_ErrorCallSP 		VARCHAR(100);
	DECLARE Des_ErrorValNulos 		VARCHAR(100);
    DECLARE AltaPolCre_NO   		CHAR(1);

	DECLARE CURSORSEGUROCUOTA CURSOR FOR
	 SELECT Cre.CreditoID, 				Amo.AmortizacionID, 		Amo.FechaInicio, 		Amo.FechaVencim, 			Amo.FechaExigible,
			Cre.EmpresaID,				Cre.CalcInteresID, 			Cre.MonedaID, 			Cli.SucursalOrigen, 		Cre.ProductoCreditoID,
			Cre.TipoCalInteres,			Amo.MontoSeguroCuota, 		Amo.IVASeguroCuota, 	Des.SubClasifID,			Cre.SucursalID,
			Cre.CobraSeguroCuota,		Cre.CobraIVASeguroCuota
		FROM AMORTICREDITO Amo,
			 CLIENTES Cli,
			 DESTINOSCREDITO Des,
			 CREDITOS Cre
		WHERE Amo.CreditoID = Cre.CreditoID
			AND Cre.ClienteID = Cli.ClienteID
			AND Cre.DestinoCreID = Des.DestinoCreID
			AND IFNULL(Amo.NumProyInteres, Entero_Cero) = Entero_Cero
			AND (Amo.Estatus	= Estatus_Vigente
				OR Amo.Estatus	= Estatus_Atrasada
				OR Amo.Estatus	= Estatus_Vencida)
			AND (Cre.Estatus	= Estatus_Vigente
				OR Cre.Estatus	= Estatus_Vencida)
			AND Amo.MontoSeguroCuota > Decimal_Cero
			AND Amo.FechaInicio = Par_Fecha;


	-- Asignacion de constantes
	SET Cadena_Vacia 			:= ''; 					-- Cadena Vacia
	SET Fecha_Vacia 			:= '1900-01-01'; 		-- Fecha Vacia
	SET Entero_Cero 			:= 0; 					-- Entero cero
	SET Decimal_Cero 			:= 0.00; 				-- Decimal cero
	SET Estatus_Vigente 		:= 'V'; 				-- Estatus Amortizacion: VIGENTE

	SET Estatus_Vencida 		:= 'B';					-- Estatus Amortizacion: VENCIDA
	SET Estatus_Atrasada 		:= 'A'; 				-- Estatus Amortizacion: ATRASADA
	SET Pro_GenSegCuota 		:= 209;					-- PROCESOSBATCH : 209 Generacion de Seguros por Cuota
	SET SiCobSeguroCuota		:= 'S'; 				-- Cobro Seguro Cuota: SI
	SET Mov_SegCuota 			:= 50;					-- TIPOSMOVSCRE: 50 Seguro por Cuota

	SET Con_IngSegCuota			:= 26;					-- CONCEPTOSCARTERA: 26 Ingreso Seguro
	SET SiCobIVASeguroCuota 	:= 'S'; 				-- Cobro IVA Seguro Cuota: SI
	SET Mov_IVASegCuota 		:= 25;					-- TIPOSMOVSCRE: 25 IVA Seguro por Cuota
	SET Con_IVASegCuota			:= 55;					-- CONCEPTOSCARTERA: 55 IVA Seguro por Cuota
	SET Pol_Automatica  		:= 'A';    				-- Tipo de Poliza: Automatica

    SET Par_SalidaNO    		:= 'N';   				-- El store no Arroja una Salida
    SET Con_GenSegCuota   		:= 412;	                -- Tipo de Proceso Contable: GENERACION SEGURO CUOTA
	SET AltaPoliza_NO   		:= 'N';					-- Alta del Encabezado de la Poliza: NO
    SET AltaPolCre_SI   		:= 'S';  				-- Alta de la Poliza de Credito: SI
	SET AltaMovCre_SI   		:= 'S';     			-- Alta del Movimiento de Credito: SI

    SET AltaMovCre_NO   		:= 'N';       			-- Alta del Movimiento de Credito: NO
	SET AltaMovAho_NO   		:= 'N';  				-- Alta del Movimiento de Ahorro: NO
    SET Nat_Cargo       		:= 'C';              	-- Naturaleza de Movimiento: Cargo

	SET Des_CieDia 				:= 'CIERRE DIARO CARTERA';
	SET Ref_GenSeguroCuota 		:= 'GENERACION SEGURO CUOTA';
    SET Ref_GenIVASeguroCuota 	:= 'GENERACION IVA SEGURO CUOTA';
	SET Aud_ProgramaID 			:= 'GENERASEGUROCUOTAPRO';

	SET Des_ErrorGral 			:= 'ERROR DE SQL GENERAL';
	SET Des_ErrorLlavDup 		:= 'ERROR EN ALTA, LLAVE DUPLICADA';
	SET Des_ErrorCallSP 		:= 'ERROR AL LLAMAR A STORE PROCEDURE';
	SET Des_ErrorValNulos 		:= 'ERROR VALORES NULOS';
	SET AltaPolCre_NO   		:= 'N';  				-- Alta de la Poliza de Credito: NO


	SET Var_FecApl 	:= Par_Fecha;
    SET Var_Poliza  := Entero_Cero;


	OPEN CURSORSEGUROCUOTA;
	BEGIN
		DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
		LOOP

		FETCH CURSORSEGUROCUOTA INTO
			Var_CreditoID, 			Var_AmortizacionID, 		Var_FechaInicio, 		Var_FechaVencim, 	Var_FechaExigible,
			Var_EmpresaID, 			Var_FormulaID, 				Var_MonedaID, 			Var_SucCliente,	 	Var_ProdCreID,
			Var_ClasifCre, 			Var_MontoSeguroCuota, 		Var_IVASeguroCuota,		Var_SubClasifID,	Var_SucursalCred,
			Var_CobraSeguroCuota, 	Var_CobraIVASeguroCuota;

		START TRANSACTION;
		BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1;
		DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET Error_Key = 2;
		DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET Error_Key = 3;
		DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET Error_Key = 4;


		SET Error_Key 		 		:= Entero_Cero;
		SET Var_MontoSeguroCuota 	:= IFNULL(Var_MontoSeguroCuota, Decimal_Cero);
		SET Var_IVASeguroCuota 		:= IFNULL(Var_IVASeguroCuota, Decimal_Cero);

		-- Seguro por Cuota
		IF(Var_CobraSeguroCuota = SiCobSeguroCuota AND Var_MontoSeguroCuota > Decimal_Cero)THEN

			SET	Mov_CarContaSegCuota	:= Con_IngSegCuota;
			SET	Mov_CarOperaSegCuota	:= Mov_SegCuota;

			CALL CONTACREDITOPRO (
				Var_CreditoID,			Var_AmortizacionID,			Entero_Cero,			Entero_Cero,			Par_Fecha,
				Var_FecApl,				Var_MontoSeguroCuota,		Var_MonedaID,			Var_ProdCreID,			Var_ClasifCre,
				Var_SubClasifID, 		Var_SucCliente,				Des_CieDia, 			Ref_GenSeguroCuota,		AltaPoliza_NO,
				Entero_Cero,			Var_Poliza, 				AltaPolCre_NO,			AltaMovCre_SI,			Mov_CarContaSegCuota,
				Mov_CarOperaSegCuota, 	Nat_Cargo,					AltaMovAho_NO,			Cadena_Vacia,			Cadena_Vacia,
				Cadena_Vacia,			/*Par_Salida,*/					Par_NumErr,				Par_ErrMen,				Par_Consecutivo,
				Par_EmpresaID, 			Cadena_Vacia,				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
				Aud_ProgramaID, 		Var_SucursalCred,			Aud_NumTransaccion);
		END IF;

		-- IVA Seguro por Cuota
		IF(Var_CobraIVASeguroCuota = SiCobIVASeguroCuota AND Var_IVASeguroCuota > Decimal_Cero)THEN

			SET	Mov_CarContaIVASegCuota	:= Con_IVASegCuota;
			SET	Mov_CarOperaIVASegCuota	:= Mov_IVASegCuota;

			CALL CONTACREDITOPRO (
				Var_CreditoID,				Var_AmortizacionID,		Entero_Cero,			Entero_Cero,			Par_Fecha,
				Var_FecApl,					Var_IVASeguroCuota,		Var_MonedaID,			Var_ProdCreID,			Var_ClasifCre,
				Var_SubClasifID, 			Var_SucCliente,			Des_CieDia, 			Ref_GenIVASeguroCuota,	AltaPoliza_NO,
				Entero_Cero,				Var_Poliza, 			AltaPolCre_NO,			AltaMovCre_SI,			Mov_CarContaIVASegCuota,
				Mov_CarOperaIVASegCuota,	Nat_Cargo,				AltaMovAho_NO,			Cadena_Vacia,			Cadena_Vacia,
				Cadena_Vacia,				/*Par_Salida,*/				Par_NumErr,				Par_ErrMen,				Par_Consecutivo,
				Par_EmpresaID, 				Cadena_Vacia,			Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
				Aud_ProgramaID, 			Var_SucursalCred,		Aud_NumTransaccion);
		END IF;


		END;
			SET Var_CreditoStr = CONCAT(CONVERT(Var_CreditoID, CHAR), '-', CONVERT(Var_AmortizacionID, CHAR)) ;
			IF Error_Key = 0 THEN
				COMMIT;
			END IF;
			IF Error_Key = 1 THEN
				ROLLBACK;
				START TRANSACTION;
					CALL EXCEPCIONBATCHALT(
						Pro_GenSegCuota, 	Par_Fecha, 			Var_CreditoStr, 		Des_ErrorGral,
						Var_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
						Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
				COMMIT;
			END IF;
			IF Error_Key = 2 THEN
				ROLLBACK;
				START TRANSACTION;
					CALL EXCEPCIONBATCHALT(
						Pro_GenSegCuota, 	Par_Fecha, 			Var_CreditoStr, 		Des_ErrorLlavDup,
						Var_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
						Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
				COMMIT;
			END IF;
			IF Error_Key = 3 THEN
				ROLLBACK;
				START TRANSACTION;
					CALL EXCEPCIONBATCHALT(
						Pro_GenSegCuota, 	Par_Fecha, 			Var_CreditoStr, 		Des_ErrorCallSP,
						Var_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
						Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
				COMMIT;
			END IF;
			IF Error_Key = 4 THEN
				ROLLBACK;
				START TRANSACTION;
					CALL EXCEPCIONBATCHALT(
						Pro_GenSegCuota, 	Par_Fecha, 			Var_CreditoStr, 		Des_ErrorValNulos,
						Var_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
						Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
				COMMIT;
			END IF;
		END LOOP;
	END;
	CLOSE CURSORSEGUROCUOTA;

END TerminaStore$$