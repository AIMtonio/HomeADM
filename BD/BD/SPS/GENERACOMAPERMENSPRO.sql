-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GENERACOMAPERMENSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `GENERACOMAPERMENSPRO`;
DELIMITER $$


CREATE PROCEDURE `GENERACOMAPERMENSPRO`(
	/*SP para Generar los asientos contables de la Comision por Apertura de Credito de forma Mensual*/
	Par_Fecha				DATE,			# Fecha del Cierre
    Par_Salida				CHAR(1),
	INOUT	Par_NumErr		INT(11),
	INOUT	Par_ErrMen		VARCHAR(400),

	# Parametros de Auditoria
	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
	)

TerminaStore: BEGIN

	# Declaracion de variables
	DECLARE Var_CreditoID			BIGINT(12);		# Numero de Credito

	DECLARE Var_EmpresaID			INT(11);		# Numero de Empresa	del Credito
	DECLARE Var_FormulaID			INT(11);		# Tipo de Calculo de Interes del Credito
	DECLARE Var_MonedaID			INT(11);		# Tipo Moneda del Credito
	DECLARE Var_SucCliente			INT(11);		# Sucursal del Cliente
	DECLARE Var_ProdCreID			INT(11);		# ID del Producto del Credito

	DECLARE Var_ClasifCre			CHAR(1);		# Clasificacion del Credito
	DECLARE Var_SubClasifID			INT(11);		# Subclasificacion del Cliente
	DECLARE Var_SucursalCred		INT(11);		# Sucursal del Credito
	DECLARE Var_CreditoStr			VARCHAR(30);	# Numero de Credito
	DECLARE Error_Key				INT(11);		# Numero de Error

	DECLARE Var_FecApl				DATE;			# Fecha de Aplicacion
	DECLARE Var_ContadorCre			INT;			# Contador: Almacena el Numero de registros que devuelve la consulta
	DECLARE Par_Consecutivo			BIGINT(20);

	DECLARE Var_Poliza 				BIGINT(20);		# Numero de Poliza
	DECLARE Var_CliPagIVA			CHAR(1);		# El Cliente Paga IVA
	DECLARE Var_IVASucurs			DECIMAL(12,2);	# IVA General de la sucursal
	DECLARE Var_MontoComAp			DECIMAL(14,2);	# Monto de la Comision por Apertura
    DECLARE Var_IVAComAp			DECIMAL(14,2);	# IVA de la Comision por Apertura

	DECLARE	Var_MontoCont			DECIMAL(14,2);  # Monto Comision Contabilizado
    DECLARE Var_MontoIVACont		DECIMAL(14,2);	# Monto IVA Comision Contabilizado
    DECLARE Var_MontoAmort			DECIMAL(14,2);	# Monto de la Comision a contabilizar
    DECLARE Var_MontoIVAAmort		DECIMAL(14,2);	# Monto IVA de la Comision a contabilizar
    DECLARE Var_NumAmort			INT(11);		# Numero de Amortizaciones del Credito
    DECLARE Var_NumAmortRees		INT(11);		# Numero de Amortizaciones del nuevo Plan de Pagos de una Reestructura
    DECLARE Var_TipoCredito			CHAR(1);		# Tipo de Credito (R: Reestructura, O: Renovacion, N:Nuevo)
    DECLARE Var_ComReest			DECIMAL(14,2);	# Comision por Apertura por Contabilizar (Reestructura de Credito)
    DECLARE Var_IVAComReest			DECIMAL(14,2);	# IVA de la Comision por Apertura por Contabilizar (Reestructura de Credito)
    DECLARE Var_NumMes				INT(11);		# Numero de mes a contabilizar
    DECLARE Var_TotMeses			INT(11);		# Total de meses a contabilizar
    DECLARE Var_TotMesesRees		INT(11);		# Total de meses a contabilizar

	-- Declaracion de constantes
	DECLARE Cadena_Vacia			CHAR(1);		# Constante: Cadena Vacia
	DECLARE Fecha_Vacia				DATE;			# Constante: Fecha
	DECLARE Entero_Cero				INT(11);		# Constante: Cero
	DECLARE Decimal_Cero			DECIMAL(12, 2);
	DECLARE Estatus_Vigente			CHAR(1);		# Estatus = Vigente
	DECLARE Estatus_Vencida			CHAR(1);		# Estatus = Vencida
	DECLARE Estatus_Atrasada		CHAR(1);		# Estatus = Atrasado
	DECLARE Estatus_Pagada			CHAR(1);		# Estatus Pagada
	DECLARE Pro_GenComAper			INT(11);		# Pro_GenComApertura ***********************
    DECLARE Salida_SI				CHAR(1);		# Constante = SI
	DECLARE Pol_Automatica 			CHAR(1);		# Constante: Poliza Automatica
	DECLARE Par_SalidaNO			CHAR(1);		# Constante: NO
	DECLARE AltaPoliza_NO			CHAR(1);		# Constante: Alta de Poliza = NO
    DECLARE AltaPoliza_SI			CHAR(1);		# Constante: Alta de Poliza = SI
	DECLARE AltaPolCre_SI			CHAR(1);		# Constante: Alta de Poliza de Credito = SI
    DECLARE AltaPolCre_NO			CHAR(1);		# Constante: Alta de Poliza de Credito = NO
	DECLARE AltaMovCre_SI			CHAR(1);		# Constante: Alta Movimiento de Credito = SI
	DECLARE AltaMovCre_NO			CHAR(1);		# Constante: Alta Movimiento de Credito = NO
	DECLARE AltaMovAho_NO			CHAR(1);		# Constante: Alta Movimiento de Ahorro = NO
	DECLARE Nat_Cargo				CHAR(1);		# Constante: Cargo
    DECLARE Nat_Abono				CHAR(1);		# Constante: Abono
	DECLARE Des_CieDia				VARCHAR(100);	# Constante: Descripcion -> Cierre Diario de Cartera
    DECLARE Var_DescComAper			VARCHAR(100);	# Descripcion: Comision por Apertura
	DECLARE Var_DcIVAComApe			VARCHAR(100);	# Descripcion: IVA Comision por Apertura
	DECLARE Con_ContComApe			INT(11);		# Concepto Cartera: Comision por Apertura
	DECLARE Con_ContIVACApe			INT(11); 		# Concepto Cartera: IVA Comision por Apertura
	DECLARE Con_ContGastos			INT(11);		# Concento Cartera: Cuenta Puente para la Comision por Apertura ***********
	DECLARE Con_ComApert			INT(11);		# Concepto Contable: Cobro comision por Apertura de Credito
	DECLARE Desc_ComApert			VARCHAR(100);	# Descripcion encabezado de Poliza
    DECLARE Cons_Si					CHAR(1);
    DECLARE TipoReestructura		CHAR(1);
	DECLARE Des_ErrorGral			VARCHAR(100);

	DECLARE Des_ErrorLlavDup		VARCHAR(100);
	DECLARE Des_ErrorCallSP			VARCHAR(100);
	DECLARE Des_ErrorValNulos		VARCHAR(100);


    /* Cursor que obtiene las amortizaciones de los Creditos que su fecha Exigible es igual a la fecha del Cierre y que tiene Comision por Apertura
     para Contabilizar */

	DECLARE CURSORCOMISIONAPERTURA CURSOR FOR
		SELECT Cre.CreditoID,				Cre.EmpresaID,				Cre.CalcInteresID,		Cre.MonedaID,			Cli.SucursalOrigen,
        Cre.ProductoCreditoID,				Des.Clasificacion,			Des.SubClasifID,		Cre.SucursalID,			Cre.MontoComApert,
		Cre.IVAComApertura,					Cre.ComAperCont,			Cre.IVAComAperCont,		Cli.PagaIVA,			Cre.NumAmortizacion,
        Cre.TipoCredito,      				Cre.ComAperReest,			Cre.IVAComAperReest,	Cob.NumMes
		FROM CREDITOS AS Cre
        INNER JOIN CRECOBCOMMENSUAL Cob
        ON Cre.CreditoID = Cob.CreditoID
        INNER JOIN
			 CLIENTES AS Cli ON Cre.ClienteID = Cli.ClienteID INNER JOIN
			 DESTINOSCREDITO Des ON Cre.DestinoCreID = Des.DestinoCreID
		WHERE
			Cre.MontoComApert > Decimal_Cero
			AND (Cre.Estatus	= Estatus_Vigente
				OR Cre.Estatus	= Estatus_Pagada
				OR Cre.Estatus	= Estatus_Vencida)
			AND Cre.ComAperCont > Decimal_Cero
            AND Cob.FechaCorte = Par_Fecha;

	-- Asignacion de constantes
	SET Cadena_Vacia			:= '';				-- Cadena Vacia
	SET Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero				:= 0;				-- Entero cero
	SET Decimal_Cero			:= 0.00;			-- Decimal cero
	SET Estatus_Vigente			:= 'V';				-- Estatus Amortizacion: VIGENTE
	SET Estatus_Vencida			:= 'B';				-- Estatus Amortizacion: VENCIDA
	SET Estatus_Atrasada		:= 'A';				-- Estatus Amortizacion: ATRASADA
	SET Estatus_Pagada			:= 'P';				-- Esatatus Amortizacion: PAGADA
	SET Pro_GenComAper			:= 211;				-- PROCESOSBATCH : 211 Generacion de Comision por Apertura de Credito
    SET Salida_SI				:= 'S';
	SET Pol_Automatica			:= 'A';				-- Tipo de Poliza: Automatica
	SET Par_SalidaNO			:= 'N';				-- El store no Arroja una Salida
	SET AltaPoliza_NO			:= 'N';				-- Alta del Encabezado de la Poliza: NO
	SET AltaPoliza_SI			:= 'S';				-- Alta Encabezado de la Poliza: SI
	SET AltaPolCre_SI			:= 'S';				-- Alta de la Poliza de Credito: SI
	SET AltaPolCre_NO			:= 'N'; 			-- Alta de la Poliza de Credito: NO
	SET AltaMovCre_SI			:= 'S';				-- Alta del Movimiento de Credito: SI
	SET AltaMovCre_NO			:= 'N';				-- Alta del Movimiento de Credito: NO
	SET AltaMovAho_NO			:= 'N';				-- Alta del Movimiento de Ahorro: NO
	SET Nat_Cargo				:= 'C';				-- Naturaleza de Movimiento: Cargo
    SET Nat_Abono				:= 'A';				-- Naturaleza de Movimiento: Abono
    SET Cons_Si					:= 'S';				-- Cobro IVA: SI
    SET TipoReestructura		:= 'R';				-- Tipo Reestructura (R)
	SET Des_CieDia				:= 'CIERRE DIARO CARTERA';
    SET Var_DescComAper			:= 'COMISION POR APERTURA';
	SET Var_DcIVAComApe			:= 'IVA COMISION POR APERTURA';
	SET Aud_ProgramaID			:= 'GENERACOMAPERMENSPRO';
	SET Des_ErrorGral			:= 'ERROR DE SQL GENERAL';
	SET Des_ErrorLlavDup		:= 'ERROR EN ALTA, LLAVE DUPLICADA';
	SET Des_ErrorCallSP			:= 'ERROR AL LLAMAR A STORE PROCEDURE';
	SET Des_ErrorValNulos		:= 'ERROR VALORES NULOS';
	SET Var_FecApl				:= Par_Fecha;
    SET Con_ContComApe  		:= 22; 				-- CONCEPTOSCARTERA: 22 Comision por Apertura
	SET Con_ContIVACApe 		:= 23; 				-- CONCEPTOSCARTERA: 23 IVA Comision por Apertura
	SET Con_ContGastos			:= 58; 				-- Cuenta Puente para la Comision por Apertura
    SET Con_ComApert			:= 31;
    SET Desc_ComApert			:= 'AJUSTE COMISION POR APERTURA';


ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-GENERACOMAPERMENSPRO');
		END;

    -- Consulta que devuelve el numero de Registros a procesar
	SELECT  COUNT(Cre.CreditoID) INTO Var_ContadorCre
    	FROM CREDITOS AS Cre
        INNER JOIN CRECOBCOMMENSUAL Cob
        ON Cre.CreditoID = Cob.CreditoID
        INNER JOIN
			 DESTINOSCREDITO Des ON Cre.DestinoCreID = Des.DestinoCreID
		WHERE
			Cre.MontoComApert > Decimal_Cero
			AND (Cre.Estatus	= Estatus_Vigente
				OR Cre.Estatus	= Estatus_Vencida)
			AND Cre.ComAperCont > Decimal_Cero
            AND Cob.FechaCorte = Par_Fecha;


	SET Var_ContadorCre := IFNULL(Var_ContadorCre, Entero_Cero);
    -- Si el numero de registros a procesar es mayor a cero se crea el encabezado de la poliza
	IF (Var_ContadorCre > Entero_Cero) THEN
		-- SP que crea la poliza contable
		CALL CONTACREDITOSPRO(
				Entero_Cero,			Entero_Cero,				Entero_Cero,			Entero_Cero,			Par_Fecha,
				Var_FecApl,				Decimal_Cero,				Entero_Cero,			Entero_Cero,			Entero_Cero,
				Entero_Cero,			Entero_Cero,				Var_DescComAper,		Cadena_Vacia,			AltaPoliza_SI,
				Con_ComApert,			Var_Poliza,					AltaPolCre_NO,			AltaMovCre_NO,			Entero_Cero,
				Entero_Cero,			Cadena_Vacia,				AltaMovAho_NO,			Cadena_Vacia,			Cadena_Vacia,
				Cadena_Vacia,			Par_Salida,					Par_NumErr,				Par_ErrMen,				Par_Consecutivo,
				Aud_EmpresaID,          Cadena_Vacia,				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,		
				Aud_ProgramaID,         Var_SucursalCred,			Aud_NumTransaccion);

	END IF;


	-- Se abre el cursor para crear los detalles de la poliza
	OPEN CURSORCOMISIONAPERTURA;
	BEGIN
		DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
		LOOP
			FETCH CURSORCOMISIONAPERTURA INTO
				Var_CreditoID,			Var_EmpresaID,				Var_FormulaID,			Var_MonedaID,			Var_SucCliente,
                Var_ProdCreID, 			Var_ClasifCre,				Var_SubClasifID,		Var_SucursalCred,		Var_MontoComAp,
                Var_IVAComAp,			Var_MontoCont,				Var_MontoIVACont,		Var_CliPagIVA,			Var_NumAmort,
                Var_TipoCredito,		Var_ComReest,				Var_IVAComReest,		Var_NumMes;


			START TRANSACTION;
			Transaccion: BEGIN
				DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key = 1;
				DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET Error_Key = 2;
				DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET Error_Key = 3;
				DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET Error_Key = 4;

				SET Error_Key		:= Entero_Cero;
				SET Var_MontoComAp	:= IFNULL(Var_MontoComAp, Decimal_Cero);
				SET Var_IVAComAp	:= IFNULL(Var_IVAComAp, Decimal_Cero);
				SET Var_MontoCont	:= IFNULL(Var_MontoCont, Decimal_Cero);
                SET Var_TotMeses 	:= (SELECT COUNT(CreditoID)
											FROM CRECOBCOMMENSUAL
                                            WHERE CreditoID = Var_CreditoID
                                            AND TipoCredito <> TipoReestructura);

                SET Var_TotMesesRees := (SELECT COUNT(CreditoID)
											FROM CRECOBCOMMENSUAL
                                            WHERE CreditoID = Var_CreditoID
                                            AND TipoCredito = TipoReestructura);


				SET Var_IVASucurs	:= IFNULL((SELECT IVA
							FROM SUCURSALES
							WHERE  SucursalID = Var_SucursalCred),  Decimal_Cero);

				SET Var_IVASucurs  := IFNULL(Var_IVASucurs, Decimal_Cero);

                IF(Var_TipoCredito = TipoReestructura) THEN
					SET Var_NumAmort 	:= Var_TotMesesRees;
                    SET Var_MontoComAp 	:= Var_ComReest;
                    SET Var_IVAComAp	:= Var_IVAComReest;

					IF(Var_IVAComAp > Decimal_Cero) THEN
                        IF (Var_CliPagIVA = Cons_Si) THEN
							SET Var_IVAComAp := ROUND(Var_MontoComAp *  Var_IVASucurs,2);
						END IF;
                    END IF;
				END IF;


				IF(Var_NumMes != Var_TotMeses) THEN
					SET Var_MontoAmort			:= IF(Var_TotMeses != Entero_Cero, ROUND((Var_MontoComAp)/Var_TotMeses,2), Entero_Cero);	# Obtiene el monto que se abona a la cuenta de Com. por Apert
					SET Var_MontoCont			:= ROUND(Var_MontoAmort,2);					# Monto que se Carga a la Cuenta Puente

				ELSE
					SET Var_MontoAmort			:= Var_MontoCont;							# Obtiene el monto que se abona a la cuenta de Com. por Apert
					SET Var_MontoCont			:= ROUND(Var_MontoAmort,2);					# Monto que se Carga a la Cuenta Puente
                END IF;

				# Si el monto de la Comision por apertura es mayor que cero, se procede a generar los asientos contables
				IF(Var_MontoComAp > Decimal_Cero)THEN

					# Se realiza el CARGO a la cuenta Puente (Gasto)
					CALL CONTACREDITOSPRO (
						Var_CreditoID,			Entero_Cero,				Entero_Cero,			Entero_Cero,			Par_Fecha,
						Var_FecApl,				Var_MontoCont,				Var_MonedaID,			Var_ProdCreID,			Var_ClasifCre,
						Var_SubClasifID,		Var_SucCliente,				Var_DescComAper,		Cadena_Vacia,			AltaPoliza_NO,
						Entero_Cero,			Var_Poliza,					AltaPolCre_SI,			AltaMovCre_NO,			Con_ContGastos,
						Entero_Cero,			Nat_Cargo,					AltaMovAho_NO,			Cadena_Vacia,			Cadena_Vacia,
						Cadena_Vacia,			Par_Salida,					Par_NumErr,				Par_ErrMen,				Par_Consecutivo,
						Aud_EmpresaID,			Cadena_Vacia,				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
						Aud_ProgramaID,			Var_SucursalCred,			Aud_NumTransaccion);

					IF(Par_NumErr != Entero_Cero)THEN
						SET Error_Key := 99;
						LEAVE Transaccion;
					END IF;



					 # Se realiza el ABONO a la cuenta de Comision por Apertura de Credito
					CALL CONTACREDITOSPRO (
						Var_CreditoID,			Entero_Cero,				Entero_Cero,			Entero_Cero,			Par_Fecha,
						Var_FecApl,				Var_MontoAmort,				Var_MonedaID,			Var_ProdCreID,			Var_ClasifCre,
						Var_SubClasifID,		Var_SucCliente,				Var_DescComAper,		Cadena_Vacia,			AltaPoliza_NO,
						Entero_Cero,			Var_Poliza,					AltaPolCre_SI,			AltaMovCre_NO,			Con_ContComApe,
						Entero_Cero,			Nat_Abono,					AltaMovAho_NO,			Cadena_Vacia,			Cadena_Vacia,
						Cadena_Vacia,			Par_Salida,					Par_NumErr,				Par_ErrMen,				Par_Consecutivo,
						Aud_EmpresaID,			Cadena_Vacia,				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
						Aud_ProgramaID,			Var_SucursalCred,			Aud_NumTransaccion);


					# Actualizando el Campo ComAperCont para disminuir lo que ya ha sido contabilizado
					UPDATE CREDITOS SET
						ComAperCont = ComAperCont - Var_MontoAmort
						WHERE CreditoID= Var_CreditoID;
				END IF;

			END;
			 SET Var_CreditoStr = CONCAT(CONVERT(Var_CreditoID, CHAR), '-', CONVERT(Var_NumMes, CHAR)) ;
			IF Error_Key = 0 THEN
				COMMIT;
			END IF;
			IF Error_Key = 1 THEN
				ROLLBACK;
				START TRANSACTION;
					CALL EXCEPCIONBATCHALT(
						Pro_GenComAper,	Par_Fecha,			Var_CreditoStr,		Des_ErrorGral,		Var_EmpresaID,
						Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
						Aud_NumTransaccion);
				COMMIT;
			END IF;
			IF Error_Key = 2 THEN
				ROLLBACK;
				START TRANSACTION;
					CALL EXCEPCIONBATCHALT(
						Pro_GenComAper,	Par_Fecha,			Var_CreditoStr,		Des_ErrorLlavDup,		Var_EmpresaID,
						Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
						Aud_NumTransaccion);
				COMMIT;
			END IF;
			IF Error_Key = 3 THEN
				ROLLBACK;
				START TRANSACTION;
					CALL EXCEPCIONBATCHALT(
						Pro_GenComAper,	Par_Fecha,			Var_CreditoStr,			Des_ErrorCallSP,	Var_EmpresaID,
						Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,
						Aud_NumTransaccion);
				COMMIT;
			END IF;
			IF Error_Key = 4 THEN
				ROLLBACK;
				START TRANSACTION;
					CALL EXCEPCIONBATCHALT(
						Pro_GenComAper,	Par_Fecha,			Var_CreditoStr,		Des_ErrorValNulos,			Var_EmpresaID,
						Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,				Aud_Sucursal,
						Aud_NumTransaccion);
				COMMIT;
			END IF;
            IF Error_Key = 99 THEN
				ROLLBACK;
				START TRANSACTION;
					CALL EXCEPCIONBATCHALT(
						Pro_GenComAper,	Par_Fecha,			Var_CreditoStr,		CONCAT(Par_NumErr,': ', Par_ErrMen),			Var_EmpresaID,
						Aud_Usuario,	Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,				Aud_Sucursal,
						Aud_NumTransaccion);
				COMMIT;
			END IF;
	 	END LOOP;
	 END;
	 CLOSE CURSORCOMISIONAPERTURA;
    END ManejoErrores;

END TerminaStore$$
