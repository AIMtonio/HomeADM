-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GENERAACCESORIOSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `GENPROYECACCESORIOSPRO`;
DELIMITER $$

CREATE PROCEDURE `GENPROYECACCESORIOSPRO`(
# ======================================================================================================
# ----- SP QUE REALIZA LOS MOVIMIENTOS OPERATIVOS DE LA GENERACION DE LOS ACCESORIOS  DE UN CREDITO ----
# ======================================================================================================
    Par_Fecha           	DATE,			-- Fecha de Aplicacion
    Par_CreditoID			BIGINT,			-- Numero de credito
    Par_AmortizacionID		BIGINT,			-- Numero de Amortizacion
    INOUT Par_MontoProyectado DECIMAL(14,2),  -- Monto Proyectado
    Par_OrigenPago    		CHAR(1),		-- Origen de Pago S: SPEI, V: Ventanilla, C: Cargo A Cta, N: Nomina, D: Domiciliado, R: Depositos Referenciados, W: WebService, O: Otros, Cadena Vacia en caso que no sea un op de pago mov operativos
    Par_Salida				CHAR(1),		-- Par_Salida
	INOUT	Par_NumErr		INT(11),		-- Numero de Error
	INOUT	Par_ErrMen		VARCHAR(400),	-- Mensaje de Error

    /* Parametros de Auditoria */
    Par_EmpresaID       	INT(11),
    Aud_Usuario         	INT(11),
    Aud_FechaActual			DATETIME,
    Aud_DireccionIP     	VARCHAR(15),
    Aud_ProgramaID      	VARCHAR(50),
    Aud_Sucursal        	INT(11),
    Aud_NumTransaccion  	BIGINT(20)


)
TerminaStore: BEGIN

-- DECLARACION DE VARIABLES
DECLARE Var_AbrevAccesorio		VARCHAR(20);	-- Abreviatura del Accesorio
DECLARE Var_SucursalCred		INT(11);		-- Sucursal del Credito
DECLARE Var_Subclasificacion	INT(11);
DECLARE Var_Clasificacion		CHAR(1);
DECLARE Var_CobraAccesorios		CHAR(1);
DECLARE Var_AccesorioID			INT(11);
DECLARE Var_MontoAccesorio		DECIMAL(14,2);
DECLARE Var_IVAAccesorio		DECIMAL(14,2);
DECLARE Var_SucCliente			INT(11);
DECLARE Var_ProdCreID			INT(11);
DECLARE Var_EmpresaID			INT(11);
DECLARE Var_FormulaID			INT(11);
DECLARE Var_AmortizacionID		INT(11);
DECLARE Var_FechaInicio 		DATE;
DECLARE Var_FechaVencim			DATE;
DECLARE Var_FechaExigible		DATE;
DECLARE Var_FecActual   		DATETIME;
DECLARE Var_NumRegistros		INT(11);
DECLARE Var_Contador			INT(11);
DECLARE Var_CreditoID			BIGINT(12);
DECLARE Var_CuentaAhoID			BIGINT(12);
DECLARE	Var_MonedaID			INT(11);
DECLARE Var_Poliza 				BIGINT(20);		-- Numero de Poliza
DECLARE Par_Consecutivo	 		BIGINT(20);
DECLARE Var_CreditoStr			VARCHAR(30);	-- Numero de Credito
DECLARE Error_Key				INT(11);		-- Numero de Error
DECLARE Var_FecApl				DATE;			-- Fecha de Aplicacion
DECLARE Var_CobraIVAAc			CHAR(1);		-- Indica si el accesorio cobra IVA
DECLARE Var_PagaIVA				CHAR(1);		-- Indica si el cliente paga IVA
DECLARE Var_MontoIva			DECIMAL(14,2);	# Monto de IVA del Accesorio

-- DECLARACION DE CONSTANTES
DECLARE Cadena_Vacia    		CHAR(1);
DECLARE Fecha_Vacia     		DATE;
DECLARE Entero_Cero    	 		INT;
DECLARE Decimal_Cero   			DECIMAL(12,2);
DECLARE EstatusVigente  		CHAR(1);
DECLARE EstatusAtraso   		CHAR(1);
DECLARE EstatusVencido  		CHAR(1);

DECLARE SiCobraAccesorio		CHAR(1);
DECLARE SiCobraIVAAccesorio		CHAR(1);
DECLARE Des_CieDia				VARCHAR(100);	-- Constante: Descripcion -> Cierre Diario de Cartera
DECLARE Ref_GenAccesorios 		VARCHAR(100);
DECLARE Ref_GenIVAAccesorios	VARCHAR(100);
DECLARE Mov_OtrasComisiones		INT(11);		-- Tipo del Movimiento de Credito: Otras Comisiones (TIPOSMOVSCRE)
DECLARE Mov_IVAOtrasComisiones	INT(11);		-- Tipo del Movimiento de Credito: Otras Comisiones (TIPOSMOVSCRE)
DECLARE Estatus_Vigente 		CHAR(1);
DECLARE Estatus_Vencida 		CHAR(1);
DECLARE Estatus_Atrasada 		CHAR(1);

DECLARE TipoPoliza				CHAR(1);		-- Tipo Poliza   A:Automatica
DECLARE Con_PagoCred    		INT(11);
DECLARE Desc_PagoCred			VARCHAR(50);
DECLARE SalidaNO				CHAR(1);
DECLARE AltaPoliza_NO			CHAR(1);		-- Constante: Alta de Poliza = NO
DECLARE Pro_CobAccesorios		INT(11);
DECLARE Des_ErrorGral			VARCHAR(100);
DECLARE Des_ErrorLlavDup		VARCHAR(100);
DECLARE Des_ErrorCallSP			VARCHAR(100);
DECLARE Des_ErrorValNulos		VARCHAR(100);

DECLARE AltaPolCre_NO			CHAR(1);		-- Constante: Alta de Poliza de Credito = NO
DECLARE AltaMovCre_SI			CHAR(1);		-- Constante: Alta Movimiento de Credito = SI
DECLARE AltaMovAho_NO			CHAR(1);		-- Constante: Alta Movimiento de Ahorro = NO
DECLARE Nat_Cargo				CHAR(1);		-- Constante: Cargo
DECLARE FormaCobroFin			CHAR(1);		-- Forma de Cobro
DECLARE Var_SI					CHAR(1);		-- Constante SI

SET Cadena_Vacia    		:= '';        		-- Constante Cadena Vacia
SET Fecha_Vacia     		:= '1900-01-01';	-- Constante Fecha Vacia
SET Entero_Cero     		:= 0;               -- Constante Entero Cero
SET Decimal_Cero      		:= 0.00;			-- Constante DECIMAL Cero
SET EstatusVigente  		:= 'V';            	-- Estatus Vigente
SET EstatusAtraso   		:= 'A';          	-- Estatus Atrasado
SET EstatusVencido  		:= 'B';            	-- Estatus Vencido
SET TipoPoliza				:= 'A';				-- Poliza Automatica
SET Con_PagoCred			:= 54;				-- Concepto Pago de Credito
SET Desc_PagoCred    		:= 'PAGO DE CREDITO';	-- Descripcion del Concepto, Pago de Credito
SET SalidaNO				:= 'N';				-- Constante SALIDA:NO
SET AltaPoliza_NO			:= 'N';				-- Alta del Encabezado de la Poliza: NO
SET SiCobraAccesorio		:= 'S';				-- Constante que indica que si cobra accesorios
SET SiCobraIVAAccesorio		:= 'S';				-- Constante que indica que si cobra accesorios
SET Des_CieDia				:= 'CIERRE DIARO CARTERA'; -- Descripción Cierre diario de cartera
SET Mov_OtrasComisiones		:= 43;				-- TIPOSMOVSCRE: Otras Comisiones
SET Mov_IVAOtrasComisiones	:= 26;				-- TIPOSMOVSCRE: IVA Otras Comisiones
SET Estatus_Vigente 		:= 'V'; 			-- Estatus Amortizacion: VIGENTE
SET Estatus_Vencida 		:= 'B';				-- Estatus Amortizacion: VENCIDA
SET Estatus_Atrasada 		:= 'A'; 			-- Estatus Amortizacion: ATRASADA
SET Var_FecApl				:= Par_Fecha;    	-- Fecha de Aplicacion
SET AltaPolCre_NO			:= 'N'; 			-- Alta de la Poliza de Credito: NO
SET AltaMovCre_SI			:= 'S';				-- Alta del Movimiento de Credito: SI
SET AltaMovAho_NO			:= 'N';				-- Alta del Movimiento de Ahorro: NO
SET Nat_Cargo				:= 'C';				-- Naturaleza de Movimiento: Cargo
SET FormaCobroFin			:= 'F';				-- Forma de Cobro F: Financiada
SET Var_SI					:= 'S';				-- Constante SI

SET Pro_CobAccesorios	:= 213;					-- Proceso Batch para realizar el cobro de creditos automaticos
SET Des_ErrorGral		:= 'ERROR DE SQL GENERAL';
SET Des_ErrorLlavDup	:= 'ERROR EN ALTA, LLAVE DUPLICADA';
SET Des_ErrorCallSP		:= 'ERROR AL LLAMAR A STORE PROCEDURE';
SET Des_ErrorValNulos	:= 'ERROR VALORES NULOS';
SET Aud_ProgramaID		:= 'GENERAACCESORIOSPRO';
SET Par_MontoProyectado := 0.0;

SELECT FechaSistema	 INTO Var_FecActual
	FROM PARAMETROSSIS;

ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-GENERAACCESORIOSPRO');
		END;

	DELETE FROM TMPCREDITOSACCESORIOS;
	# SE INSERTAN LOS REGISTROS A LA TABLA
	INSERT INTO TMPCREDITOSACCESORIOS(
			Consecutivo,				CreditoID,				AmortizacionID,			FechaInicio,			FechaVencimiento,
			FechaExigible,				CalcInteresID,			MonedaID,				SucursalOrigen,			ProductoCreditoID,
 			Clasificacion,				SubClasifID,  			SucursalID, 			CobraAccesorios,		AccesorioID,
            MontoAccesorio,				IVAAccesorio,			CobraIVA,				PagaIVA,           		EmpresaID,
            Usuario,					FechaActual,			DireccionIP,			ProgramaID,				Sucursal,
            NumTransaccion)

	SELECT	@s:=@s+1 AS Consecutivo,	Cre.CreditoID, 			Amo.AmortizacionID, 	Amo.FechaInicio,		Amo.FechaVencim,
			Amo.FechaExigible,			Cre.CalcInteresID, 		Cre.MonedaID, 			Cli.SucursalOrigen,		Cre.ProductoCreditoID,
            Des.Clasificacion,			Des.SubClasifID,		Cre.SucursalID,			Cre.CobraAccesorios,	Det.AccesorioID,
			Det.MontoCuota,				Det.MontoIVACuota,		Det.CobraIVA,			Cli.PagaIVA,			Cre.EmpresaID,
            Aud_Usuario,				Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,
            Aud_NumTransaccion
		FROM  CREDITOS Cre
			INNER JOIN AMORTICREDITO Amo ON
				Cre.CreditoID 	= Amo.CreditoID
            INNER JOIN CLIENTES Cli	ON
				Cre.ClienteID 	= Cli.ClienteID
            INNER JOIN DESTINOSCREDITO Des ON
				Cre.DestinoCreID = Des.DestinoCreID
            INNER JOIN  DETALLEACCESORIOS Det ON
				Cre.CreditoID 	= Det.CreditoID
                AND Det.AmortizacionID = Amo.AmortizacionID,
			(SELECT @s:= Entero_Cero) AS S
		WHERE Amo.CreditoID 	= Cre.CreditoID	AND
                (Amo.Estatus	= Estatus_Vigente OR  Amo.Estatus	= Estatus_Atrasada OR Amo.Estatus	= Estatus_Vencida)AND
                (Cre.Estatus	= Estatus_Vigente OR Cre.Estatus	= Estatus_Vencida) AND
                Det.MontoAccesorio > Decimal_Cero AND
				Det.CreditoID > 0
                AND Det.TipoFormaCobro = FormaCobroFin
                AND Amo.CreditoID = Par_CreditoID
                AND	Amo.AmortizacionID = Par_AmortizacionID
                AND Amo.FechaInicio >= Par_Fecha
                AND IFNULL(Amo.NumProyInteres,Entero_Cero) = Entero_Cero;



	SET	Var_NumRegistros	:= (SELECT COUNT(*) FROM TMPCREDITOSACCESORIOS);
	SET	Var_Contador		:=	1;

     # CICLO PARA RECORRER LA TABLA Y REALIZAR EL PAGO DE LOS CREDITOS
    WHILE(Var_Contador <= Var_NumRegistros) DO
	Transaccion: BEGIN

		# SE OBTIENEN LOS DATOS DE MANERA INDIVIDUAL
		SELECT 	CreditoID,				AmortizacionID,			FechaInicio,		FechaVencimiento,		FechaExigible,
				EmpresaID,				CalcInteresID,			MonedaID,			SucursalOrigen,			ProductoCreditoID,
				Clasificacion, 			SubClasifID, 			SucursalID, 		CobraAccesorios, 		AccesorioID,
				MontoAccesorio, 		IVAAccesorio,			CobraIVA,			PagaIVA
        INTO	Var_CreditoID,    		Var_AmortizacionID,    	Var_FechaInicio,  	Var_FechaVencim,		Var_FechaExigible,
				Var_EmpresaID,			Var_FormulaID,			Var_MonedaID,		Var_SucCliente,			Var_ProdCreID,
                Var_Clasificacion,		Var_Subclasificacion,	Var_SucursalCred,	Var_CobraAccesorios,	Var_AccesorioID,
                Var_MontoAccesorio,		Var_IVAAccesorio,		Var_CobraIVAAc,		Var_PagaIVA
        FROM TMPCREDITOSACCESORIOS
        WHERE Consecutivo = Var_Contador;

        SET Var_CreditoID 	:= IFNULL(Var_CreditoID, Entero_Cero);
        SET Var_CuentaAhoID	:= IFNULL(Var_CuentaAhoID, Entero_Cero);
        SET Var_MonedaID	:= IFNULL(Var_MonedaID, Entero_Cero);


		IF(Var_PagaIVA = Var_SI) THEN
			IF(Var_CobraIVAAc = Var_SI) THEN
				-- SE CALCULA EL MONTO Y EL IVA PROPORCIONAL
				SET Var_MontoIva := ROUND(Var_IVAAccesorio,2);

			ELSE
				# VALORES CUANDO EL CLIENTE NO PAGA IVA
				SET Var_MontoIva := Entero_Cero;
			END IF;
		ELSE
				# VALORES CUANDO EL CLIENTE NO PAGA IVA
			SET Var_MontoIva := Entero_Cero;
		END IF;

				-- Accesorios Credito
		IF(Var_CobraAccesorios = SiCobraAccesorio AND Var_MontoAccesorio > Decimal_Cero)THEN

			SET Var_AbrevAccesorio := (SELECT NombreCorto FROM ACCESORIOSCRED WHERE AccesorioID  = Var_AccesorioID);

            SET Ref_GenAccesorios := CONCAT('PROYECTA OTRAS COMISIONES ' , Var_AbrevAccesorio);


			CALL CONTACCESORIOSCREDPRO (
					Var_CreditoID,			Var_AmortizacionID,			Var_AccesorioID,		Entero_Cero,			Entero_Cero,
					Par_Fecha,				Var_FecApl,					Var_MontoAccesorio,		Var_MonedaID,			Var_ProdCreID,
					Var_Clasificacion,		Var_Subclasificacion, 		Var_SucCliente,			Des_CieDia, 			Ref_GenAccesorios,
					AltaPoliza_NO,			Entero_Cero,				Var_Poliza, 			AltaPolCre_NO,			AltaMovCre_SI,
					Entero_Cero,			Mov_OtrasComisiones, 		Nat_Cargo,				AltaMovAho_NO,			Cadena_Vacia,
					Cadena_Vacia, 			Par_OrigenPago,				Par_Salida,				Par_NumErr,				Par_ErrMen,				Par_Consecutivo,
					Par_EmpresaID,			Cadena_Vacia, 				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
					Aud_ProgramaID,			Var_SucursalCred,	 		Aud_NumTransaccion);

				IF(Par_NumErr != Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;
            SET Par_MontoProyectado := Par_MontoProyectado + Var_MontoAccesorio;

		END IF;

		IF(Var_MontoIva > Decimal_Cero) THEN

         SET Ref_GenIVAAccesorios := CONCAT('PROYECTA IVA OTRAS COMISIONES ' , Var_AbrevAccesorio);


			CALL CONTACCESORIOSCREDPRO (
					Var_CreditoID,			Var_AmortizacionID,			Var_AccesorioID,		Entero_Cero,			Entero_Cero,
					Par_Fecha,				Var_FecApl,					Var_MontoIva,			Var_MonedaID,			Var_ProdCreID,
					Var_Clasificacion,		Var_Subclasificacion, 		Var_SucCliente,			Des_CieDia, 			Ref_GenAccesorios,
					AltaPoliza_NO,			Entero_Cero,				Var_Poliza, 			AltaPolCre_NO,			AltaMovCre_SI,
					Entero_Cero,			Mov_IVAOtrasComisiones, 	Nat_Cargo,				AltaMovAho_NO,			Cadena_Vacia,
					Cadena_Vacia, 			Par_OrigenPago,				Par_Salida,					Par_NumErr,				Par_ErrMen,				Par_Consecutivo,
					Par_EmpresaID,			Cadena_Vacia, 				Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,
					Aud_ProgramaID,			Var_SucursalCred,	 		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

        END IF;

		END Transaccion;

		SET Var_Contador := Var_Contador + 1; -- Incrementa el contador

    END WHILE;

END ManejoErrores;

IF Par_Salida != SalidaNO THEN
	SELECT Par_NumErr AS NumErr,
		   Par_ErrMen AS ErrMen;
END IF;

END TerminaStore$$