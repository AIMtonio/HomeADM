-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COBROCOMANUALLINEAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `COBROCOMANUALLINEAPRO`;DELIMITER $$

CREATE PROCEDURE `COBROCOMANUALLINEAPRO`(
	-- Sp para realizar los movimientos contables y operativos para la comisión anual de líneas de crédito.
	Par_CreditoID		BIGINT,			-- ID del credito
	Par_ClienteID		INT(11),		-- numero de cliente
INOUT Par_MontoPagar 	DECIMAL(14,2),	-- monto que se debera pagar por concepto de comision anual de linea
	Par_CuentaAhoID 	BIGINT,			-- numero de cuenta de ahorro
	Par_PolizaID 		INT(11),		-- numero de poliza

	Par_MonedaID		INT(11),		-- ID de moneda
	Par_Salida			CHAR(1),		-- indica una salida
INOUT Par_NumErr 		INT(11),		-- numero de error
INOUT Par_ErrMen		VARCHAR(400),	-- mensaje de error
	/*Parametros Auditoria*/
	Par_EmpresaID		INT(11),		-- Parametro de Auditoria

    Aud_Usuario			INT(11),		-- Parametro de Auditoria
    Aud_FechaActual 	DATETIME,		-- Parametro de Auditoria
    Aud_DireccionIP 	VARCHAR(50),	-- Parametro de Auditoria
    Aud_ProgramaID		VARCHAR(50),	-- Parametro de Auditoria
    Aud_Sucursal 		INT(11),		-- Parametro de Auditoria

    Aud_NumTransaccion 	BIGINT 			-- Parametro de Auditoria
)
TerminaStore:BEGIN
	/*Declaración de Variables*/
	DECLARE varControl 				VARCHAR(100);
	DECLARE Var_SucCliente			INT(11);
	DECLARE Var_TipoComAnualLin		CHAR(1);
	DECLARE Var_MontoComAnual 		DECIMAL(14,2);
	DECLARE Var_SaldoLinea			DECIMAL(14,2);

	DECLARE Var_ValorComAnualLin 	DECIMAL(14,2);
	DECLARE Var_MontoIVAComAnual 	DECIMAL(14,2);
	DECLARE ConstDescipLinea		VARCHAR(200);
	DECLARE Var_LineaCreditoID		BIGINT(20);
	DECLARE Var_CobraComAnual 		CHAR(1);

	DECLARE FechSistema				DATE;
	DECLARE Var_PagaIVA 			CHAR(1);
    DECLARE Var_ProducCreditoID 	INT(11);
    DECLARE Var_SubClasifCredito 	CHAR(1);
    DECLARE Var_ClasificaCredito 	CHAR(1);

    DECLARE Var_EstatusCredito 		CHAR(1);
    DECLARE Var_EsGrupal			CHAR(1);
    DECLARE Var_GrupoID				INT(11);
    DECLARE Var_IVASucurs			DECIMAL(14,2);
    DECLARE Var_CicloGrupo			INT(11);

    DECLARE Var_SaldoComAnual 		DECIMAL(14,2);
    DECLARE VarSucursalLin			INT(11);

	/*Declaración de Constantes*/
	DECLARE SiPagaIVA 				CHAR(1);
	DECLARE Decimal_Cero 			DECIMAL(14,2);
	DECLARE Entero_Cero				INT(11);
    DECLARE Con_ContComAnual		INT(11);
    DECLARE Con_ContIVAComAnual		INT(11);

    DECLARE TipoMovAhoComAnual 		VARCHAR(4);
    DECLARE TipoMovAhoIVAComAnual 	VARCHAR(4);
    DECLARE Nat_Abono				CHAR(1);
    DECLARE Nat_Cargo 				CHAR(1);
    DECLARE AltaPoliza_NO			CHAR(1);
    DECLARE AltaPolCre_SI			CHAR(1);
    DECLARE AltaMovAho_SI			CHAR(1);
    DECLARE AltaMovAho_NO			CHAR(1);

	/*Asignación de Constantes*/
	SET SiPagaIVA 			:= 'S';
	SET Decimal_Cero		:= 0.00;
	SET Entero_Cero 		:= 0;
    SET Con_ContComAnual 	:= 100; -- Concepto Contable Cartera: Comisión por Anualidad
    SET Con_ContIVAComAnual := 101; -- Concepto Contable Cartera: IVA Comisión por Anualidad

    SET TipoMovAhoComAnual 	:= '208';
    SET TipoMovAhoIVAComAnual	:= '209';
    SET Nat_Abono 				:= 'A';
    SET Nat_Cargo				:= 'C';
    SET AltaPoliza_NO			:= 'N';
    SET AltaPolCre_SI			:= 'S';
    SET AltaMovAho_SI			:= 'S';
    SET AltaMovAho_NO 			:= 'N';

	-- Sección para verificar el monto de pago
	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  := 999;
			SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
					  'Disculpe las molestias que esto le ocasiona. Ref: SP-COBROCOMANUALLINEAPRO');
			SET varControl  := 'SQLEXCEPTION';
			END ;

		-- Obtiene Datos Generales Para el pago de la comisión
		SELECT 	Cli.SucursalOrigen,			Cli.PagaIVA,
				Cre.ProductoCreditoID,
				Cre.Estatus,				Cre.GrupoID,			Cre.CicloGrupo,
	            Cre.LineaCreditoID
		INTO 	Var_SucCliente,				Var_PagaIVA,
				Var_ProducCreditoID,
				Var_EstatusCredito,			Var_GrupoID,			Var_CicloGrupo,
	           	Var_LineaCreditoID
		FROM CLIENTES Cli
			INNER JOIN CREDITOS Cre ON (Cli.ClienteID = Cre.ClienteID)
		WHERE Cre.CreditoID=Par_CreditoID;

		-- Setea la fecha del sistema
		SET FechSistema := (SELECT FechaSistema FROM PARAMETROSSIS);

		-- Obitnene el monto de adeudo por la comisión anual
		SELECT	CobraComAnual,		SaldoComAnual, SucursalID
			INTO Var_CobraComAnual,	Var_SaldoComAnual, VarSucursalLin
		FROM LINEASCREDITO
		WHERE LineaCreditoID = Var_LineaCreditoID;

        -- Setea el monto de la Comisión si es null
		SET Var_MontoComAnual 	:= IFNULL(Var_SaldoComAnual,Entero_Cero);

        -- Verifica si paga iva para recalcular los montos
        IF(Var_PagaIVA=SiPagaIVA)THEN
			-- Obtiene el porcentaje de iva a cobrar
			SELECT IVA INTO Var_IVASucurs -- IVA Sucursal
			FROM SUCURSALES
			WHERE SucursalID = Var_SucCliente;
            -- Valida que el pocentaje de iva no sea null
            SET Var_IVASucurs := IFNULL(Var_IVASucurs,Entero_Cero); -- Default IVA Comisisón
			-- Calcula el monto del iva a cobrar
            SET Var_MontoIVAComAnual := ROUND(Var_MontoComAnual*Var_IVASucurs,2);
        END IF;

        SET Var_MontoIVAComAnual := IFNULL(Var_MontoIVAComAnual,Entero_Cero);

	    IF( (Var_MontoComAnual+Var_MontoIVAComAnual) > Par_MontoPagar)THEN
			SET Var_MontoComAnual := ROUND(Par_MontoPagar / (1 + Var_IVASucurs),2);
			SET Var_MontoIVAComAnual := ROUND(Var_MontoComAnual * Var_IVASucurs,2);

            IF( (Var_MontoComAnual+Var_MontoIVAComAnual)<>Par_MontoPagar)THEN
				SET Var_MontoComAnual := ROUND(Par_MontoPagar - Var_MontoIVAComAnual,2);
            END IF;
	    END IF;

		SET ConstDescipLinea := CONCAT('CARGO POR ANUALIDAD DE LA LINEA NO.',Var_LineaCreditoID);

		-- SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES DE LA COMISIÓN ANUAL , DENTRO MANDA A LLAMAR A POLIZALINEACREPRO Y POLIZAAHORROPRO
		CALL CONTALINEACREPRO(
			Var_LineaCreditoID,	Entero_Cero,			FechSistema,		FechSistema,		Var_MontoComAnual,
			Par_MonedaID,		Var_ProducCreditoID,	VarSucursalLin,		ConstDescipLinea,	Var_LineaCreditoID,
			AltaPoliza_NO,		Entero_Cero,			AltaPolCre_SI,		AltaMovAho_NO,		Con_ContComAnual,
			TipoMovAhoComAnual,	Nat_Abono,				Nat_Cargo,			Par_NumErr,			Par_ErrMen,
	        Par_PolizaID,		Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
	        Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

		IF (Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		IF(Var_PagaIVA = SiPagaIVA) THEN

			SET ConstDescipLinea := CONCAT('CARGO IVA POR ANUALIDAD DE LA LINEA No.',Var_LineaCreditoID);
			-- SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES DE IVA DE LA COMISIÓN ANUAL , DENTRO MANDA A LLAMAR A POLIZALINEACREPRO Y POLIZAAHORROPRO
			CALL CONTALINEACREPRO(
				Var_LineaCreditoID,		Entero_Cero,			FechSistema,		FechSistema,		Var_MontoIVAComAnual,
				Par_MonedaID,			Var_ProducCreditoID,	VarSucursalLin,		ConstDescipLinea,	Var_LineaCreditoID,
				AltaPoliza_NO,			Entero_Cero,			AltaPolCre_SI,		AltaMovAho_NO,		Con_ContIVAComAnual,
				TipoMovAhoIVAComAnual,	Nat_Abono,				Nat_Cargo,			Par_NumErr,			Par_ErrMen,
	            Par_PolizaID,			Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
	            Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

        SET Par_MontoPagar := Par_MontoPagar - (Var_MontoComAnual+Var_MontoIVAComAnual);

	    UPDATE LINEASCREDITO SET
			SaldoComAnual = SaldoComAnual - Var_MontoComAnual,
			ComisionCobrada = IF(SaldoComAnual=Entero_Cero,'S','N')
		WHERE LineaCreditoID = Var_LineaCreditoID;

	END ManejoErrores;

END TerminaStore$$