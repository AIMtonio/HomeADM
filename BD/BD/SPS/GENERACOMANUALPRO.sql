-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GENERACOMANUALPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `GENERACOMANUALPRO`;
DELIMITER $$

CREATE PROCEDURE `GENERACOMANUALPRO`(
	/*SP para Generar la Comision por Anualidad de Credito*/
	Par_Fecha				DATE,			# Fecha del Cierre
	Par_Salida 				CHAR(1),		# Salida S:Si N:No
	Par_NumErr				INT(11),		# Numero de Error
	Par_ErrMen				VARCHAR(400),	# Mensaje de Error
	/*Auditoria*/
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
	DECLARE Var_ComAnualIVA			DECIMAL(14,2);
	DECLARE Var_SubClasifID			INT;
	DECLARE Var_SucursalCred		INT;

	DECLARE Var_CobraComAnualidad	CHAR(1);
	DECLARE Var_CobraIVASeguroCuota	CHAR(1);
	DECLARE Var_CreditoStr			VARCHAR(30);
	DECLARE Error_Key				INT;
	DECLARE Mov_AboConta			INT;

	DECLARE Var_FecApl				DATE;
	DECLARE Var_ContadorCre			INT;
	DECLARE Par_Consecutivo			BIGINT;
	DECLARE Mov_CarContaComAnual	INT;
	DECLARE Mov_CarOperaComAnual	INT;
	DECLARE Mov_CarContaComAnualIVA INT;
	DECLARE Mov_CarOperaComAnualIVA INT;
	DECLARE Var_Poliza 				BIGINT;
	DECLARE Var_SaldoComAnual		DECIMAL(14,2);			# Saldo de Comision por Anualidad en el credito
	DECLARE Var_ComisionAnual		DECIMAL(14,2);			# Saldo de Comision por Anualidad en el credito
	DECLARE Var_CliPagIVA			CHAR(1);				# El Cliente Paga IVA
	DECLARE Var_ValIVAGen			DECIMAL(12,2);			# IVA General de la sucursal
	DECLARE Var_IVASucurs			DECIMAL(12,2);			# IVA General de la sucursal

	-- Declaracion de constantes
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Fecha_Vacia				DATE;
	DECLARE Entero_Cero				INT;
	DECLARE Decimal_Cero			DECIMAL(12, 2);
	DECLARE Estatus_Vigente			CHAR(1);
	DECLARE Estatus_Vencida			CHAR(1);
	DECLARE Estatus_Atrasada		CHAR(1);
	DECLARE Pro_GenComAnual			INT;
	DECLARE Mov_ComAnual			INT;
	DECLARE Con_IngComAnual			INT;
	DECLARE Cons_Si					CHAR(1);
	DECLARE Mov_ComAnualIVA			INT;
	DECLARE Con_ComAnual			INT;
	DECLARE Pol_Automatica 			CHAR(1);
	DECLARE Par_SalidaNO			CHAR(1);
	DECLARE Con_GenComAnual			INT;
	DECLARE AltaPoliza_NO			CHAR(1);
	DECLARE AltaPolCre_SI			CHAR(1);
	DECLARE AltaMovCre_SI			CHAR(1);

	DECLARE AltaMovCre_NO			CHAR(1);
	DECLARE AltaMovAho_NO			CHAR(1);
	DECLARE Nat_Cargo				CHAR(1);
	DECLARE Des_CieDia				VARCHAR(100);
	DECLARE Ref_GenComAnual			VARCHAR(100);
	DECLARE Ref_GenComAnualIVA		VARCHAR(100);
	DECLARE Des_ErrorGral			VARCHAR(100);
	DECLARE Des_ErrorLlavDup		VARCHAR(100);
	DECLARE Des_ErrorCallSP			VARCHAR(100);
	DECLARE Des_ErrorValNulos		VARCHAR(100);
	DECLARE AltaPolCre_NO			CHAR(1);

	DECLARE CURSORCOMISIONANUAL CURSOR FOR
		SELECT Cre.CreditoID,				Amo.AmortizacionID,			Amo.FechaInicio,		Amo.FechaVencim,			Amo.FechaExigible,
			Cre.EmpresaID,					Cre.CalcInteresID,			Cre.MonedaID,			Cli.SucursalOrigen,			Cre.ProductoCreditoID,
			Cre.TipoCalInteres,				Des.SubClasifID,			Cre.SucursalID,			Cre.SaldoComAnual,			Cre.CobraComAnual,
			FNCOMISIONANUALCRED(Cre.CreditoID,Amo.AmortizacionID,
								(IFNULL(Cre.SaldoCapVigent,Decimal_Cero) + IFNULL(Cre.SaldCapVenNoExi,Decimal_Cero))+
								(IFNULL(Cre.SaldoCapAtrasad,Decimal_Cero) + IFNULL(Cre.SaldoCapVencido,Decimal_Cero)),Par_Fecha),Cli.PagaIVA
		FROM AMORTICREDITO Amo INNER JOIN
			 CREDITOS AS Cre ON Amo.CreditoID = Cre.CreditoID INNER JOIN
			 CLIENTES AS Cli ON Cre.ClienteID = Cli.ClienteID INNER JOIN
			 DESTINOSCREDITO Des ON Cre.DestinoCreID = Des.DestinoCreID
		WHERE
			Cre.CobraComAnual = Cons_Si AND
			IFNULL(Amo.NumProyInteres, 0) = 0 AND
			(Amo.Estatus	= Estatus_Vigente
				OR Amo.Estatus	= Estatus_Atrasada
				OR Amo.Estatus	= Estatus_Vencida)
			AND (Cre.Estatus	= Estatus_Vigente
				OR Cre.Estatus	= Estatus_Vencida)
			AND Amo.FechaInicio = Par_Fecha;

	-- Asignacion de constantes
	SET Cadena_Vacia			:= '';					-- Cadena Vacia
	SET Fecha_Vacia				:= '1900-01-01';		-- Fecha Vacia
	SET Entero_Cero				:= 0;					-- Entero cero
	SET Decimal_Cero			:= 0.00;				-- Decimal cero
	SET Estatus_Vigente			:= 'V';					-- Estatus Amortizacion: VIGENTE
	SET Estatus_Vencida			:= 'B';					-- Estatus Amortizacion: VENCIDA
	SET Estatus_Atrasada		:= 'A';					-- Estatus Amortizacion: ATRASADA
	SET Pro_GenComAnual			:= 210;					-- PROCESOSBATCH : 210 Generacion de Comision por Anualidad
	SET Mov_ComAnual			:= 51;					-- TIPOSMOVSCRE: 51 Comision por Anualidad
	SET Con_IngComAnual			:= 56;					-- CONCEPTOSCARTERA: 56 Ingreso Comision por Anualidad
	SET Cons_Si					:= 'S';					-- Cobro IVA Seguro Cuota: SI
	SET Mov_ComAnualIVA			:= 52;					-- TIPOSMOVSCRE: 52 IVA Comision por Anualidad
	SET Con_ComAnual			:= 57;					-- CONCEPTOSCARTERA: 57 IVA Comision por Anualidad
	SET Pol_Automatica			:= 'A';					-- Tipo de Poliza: Automatica
	SET Par_SalidaNO			:= 'N';					-- El store no Arroja una Salida
	SET Con_GenComAnual			:= 413;					-- Tipo de Proceso Contable: GENERACION COMISION POR ANUALIDAD DE CREDITO
	SET AltaPoliza_NO			:= 'N';					-- Alta del Encabezado de la Poliza: NO
	SET AltaPolCre_SI			:= 'S';					-- Alta de la Poliza de Credito: SI
	SET AltaMovCre_SI			:= 'S';					-- Alta del Movimiento de Credito: SI
	SET AltaMovCre_NO			:= 'N';					-- Alta del Movimiento de Credito: NO
	SET AltaMovAho_NO			:= 'N';					-- Alta del Movimiento de Ahorro: NO
	SET Nat_Cargo				:= 'C';					-- Naturaleza de Movimiento: Cargo
	SET Des_CieDia				:= 'CIERRE DIARO CARTERA';
	SET Ref_GenComAnual			:= 'GENERACION COMISION POR ANUALIDAD DE CRED';
	SET Ref_GenComAnualIVA		:= 'GENERACION IVA COMISION POR ANUALIDAD DE CRED';
	SET Aud_ProgramaID			:= 'GENERACOMANUALPRO';
	SET Des_ErrorGral			:= 'ERROR DE SQL GENERAL';
	SET Des_ErrorLlavDup		:= 'ERROR EN ALTA, LLAVE DUPLICADA';
	SET Des_ErrorCallSP			:= 'ERROR AL LLAMAR A STORE PROCEDURE';
	SET Des_ErrorValNulos		:= 'ERROR VALORES NULOS';
	SET AltaPolCre_NO			:= 'N'; 				-- Alta de la Poliza de Credito: NO
	SET Var_FecApl				:= Par_Fecha;
	SET Var_Poliza				:= Entero_Cero;
ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-GENERACOMANUALPRO');
		END;

	OPEN CURSORCOMISIONANUAL;
	BEGIN
		DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
		LOOP
		FETCH CURSORCOMISIONANUAL INTO
			Var_CreditoID,			Var_AmortizacionID,			Var_FechaInicio,		Var_FechaVencim,	Var_FechaExigible,
			Var_EmpresaID,			Var_FormulaID,				Var_MonedaID,			Var_SucCliente,		Var_ProdCreID,
			Var_ClasifCre,			Var_SubClasifID,			Var_SucursalCred,		Var_SaldoComAnual,	Var_CobraComAnualidad,
			Var_ComisionAnual,		Var_CliPagIVA;
		START TRANSACTION;
		BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1;
		DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET Error_Key = 2;
		DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET Error_Key = 3;
		DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET Error_Key = 4;

		SET Error_Key				:= Entero_Cero;
		SET Var_SaldoComAnual		:= IFNULL(Var_SaldoComAnual, Entero_Cero);# Saldo en el credito
		SET Var_ComisionAnual		:= IFNULL(Var_ComisionAnual, Entero_Cero);#Comision x amortizacion
		SET Var_ComAnualIVA			:= IFNULL(Var_ComAnualIVA, Decimal_Cero);
		SET Var_IVASucurs			:= IFNULL(Var_IVASucurs, Decimal_Cero);


		-- Seguro por Cuota
		IF(Var_CobraComAnualidad = Cons_Si AND Var_ComisionAnual > Decimal_Cero)THEN
			IF (Var_CliPagIVA = Cons_Si) THEN
				SET	Var_IVASucurs	:= IFNULL((SELECT IVA
					FROM SUCURSALES
					WHERE  SucursalID = Var_SucursalCred),  Decimal_Cero);

				SET Var_IVASucurs  := IFNULL(Var_IVASucurs, Decimal_Cero);
			END IF;

			SET	Mov_CarContaComAnual	:= Con_IngComAnual;
			SET	Mov_CarOperaComAnual	:= Mov_ComAnual;

			CALL CONTACREDITOPRO (
				Var_CreditoID,			Var_AmortizacionID,			Entero_Cero,			Entero_Cero,			Par_Fecha,
				Var_FecApl,				Var_ComisionAnual,			Var_MonedaID,			Var_ProdCreID,			Var_ClasifCre,
				Var_SubClasifID,		Var_SucCliente,				Des_CieDia,				Ref_GenComAnual,		AltaPoliza_NO,
				Entero_Cero,			Var_Poliza,					AltaPolCre_NO,			AltaMovCre_SI,			Mov_CarContaComAnual,
				Mov_CarOperaComAnual,	Nat_Cargo,					AltaMovAho_NO,			Cadena_Vacia,			Cadena_Vacia,
				Cadena_Vacia,			/*Par_Salida,*/					Par_NumErr,				Par_ErrMen,				Par_Consecutivo,
				Aud_EmpresaID,			Cadena_Vacia,				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
				Aud_ProgramaID,			Var_SucursalCred,			Aud_NumTransaccion);
			/*Actualizando el Saldo x Comision */
			UPDATE AMORTICREDITO SET
					SaldoComisionAnual = Var_ComisionAnual
					WHERE CreditoID= Var_CreditoID AND
						AmortizacionID = Var_AmortizacionID;
			/*Actualizando el Saldo en el Credito*/
			UPDATE CREDITOS SET
				SaldoComAnual = SaldoComAnual + Var_ComisionAnual
				WHERE CreditoID= Var_CreditoID;
		END IF;
		-- IVA Seguro por Cuota
		IF(Var_CobraComAnualidad = Cons_Si AND Var_ComAnualIVA > Decimal_Cero AND Var_IVASucurs > Decimal_Cero)THEN

			SET	Mov_CarContaComAnualIVA	:= Con_ComAnual;
			SET	Mov_CarOperaComAnualIVA	:= Mov_ComAnualIVA;

			CALL CONTACREDITOPRO (
				Var_CreditoID,				Var_AmortizacionID,			Entero_Cero,			Entero_Cero,			Par_Fecha,
				Var_FecApl,					Var_ComAnualIVA,			Var_MonedaID,			Var_ProdCreID,			Var_ClasifCre,
				Var_SubClasifID,			Var_SucCliente,				Des_CieDia,				Ref_GenComAnualIVA,		AltaPoliza_NO,
				Entero_Cero,				Var_Poliza,					AltaPolCre_NO,			AltaMovCre_SI,			Mov_CarContaComAnualIVA,
				Mov_CarOperaComAnualIVA,	Nat_Cargo,					AltaMovAho_NO,			Cadena_Vacia,			Cadena_Vacia,
				Cadena_Vacia,				/*Par_Salida,*/					Par_NumErr,				Par_ErrMen,				Par_Consecutivo,
				Aud_EmpresaID,				Cadena_Vacia,				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
				Aud_ProgramaID,				Var_SucursalCred,			Aud_NumTransaccion);
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
						Pro_GenComAnual,	Par_Fecha,			Var_CreditoStr,		Des_ErrorGral,		Var_EmpresaID,
						Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
						Aud_NumTransaccion);
				COMMIT;
			END IF;
			IF Error_Key = 2 THEN
				ROLLBACK;
				START TRANSACTION;
					CALL EXCEPCIONBATCHALT(
						Pro_GenComAnual,	Par_Fecha,			Var_CreditoStr,		Des_ErrorLlavDup,	Var_EmpresaID,
						Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
						Aud_NumTransaccion);
				COMMIT;
			END IF;
			IF Error_Key = 3 THEN
				ROLLBACK;
				START TRANSACTION;
					CALL EXCEPCIONBATCHALT(
						Pro_GenComAnual,	Par_Fecha,			Var_CreditoStr,			Des_ErrorCallSP,	Var_EmpresaID,
						Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
						Aud_NumTransaccion);
				COMMIT;
			END IF;
			IF Error_Key = 4 THEN
				ROLLBACK;
				START TRANSACTION;
					CALL EXCEPCIONBATCHALT(
						Pro_GenComAnual,	Par_Fecha,			Var_CreditoStr,		Des_ErrorValNulos,			Var_EmpresaID,
						Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,				Aud_Sucursal,
						Aud_NumTransaccion);
				COMMIT;
			END IF;
		END LOOP;
	END;
	CLOSE CURSORCOMISIONANUAL;
    END ManejoErrores;

END TerminaStore$$