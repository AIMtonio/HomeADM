-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RESPAGCREDITOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `RESPAGCREDITOPRO`;

DELIMITER $$
CREATE PROCEDURE `RESPAGCREDITOPRO`(
	/*SP para el Respaldo de los Creditos*/
	-- modulo de Cartera
	Par_CreditoID				BIGINT(12),		-- Numero de Credito

	Par_EmpresaID				INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario					INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP				VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)


TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE Var_Transaccion		BIGINT(20);		-- Numero de Transaccion
	DECLARE Var_Prorrateo		CHAR(2);		-- Prorreteo de Pago
	DECLARE Var_InverEnGar		INT(11);		-- Inversion en Garantia
	DECLARE Var_NumRegistros	INT;


	-- Declaracion de Constantes
	DECLARE Cadena_Vacia		CHAR(1);		-- Cadena Vacia
	DECLARE Entero_Cero			INT(11);		-- Entero en Cero
	DECLARE Decimal_Cero		DECIMAL(12,2);	-- Decimal Cero
	DECLARE Estatus_Vigente		CHAR(1);		-- Estatus Inversion:

	-- Asignacion de constantes
	SET Cadena_Vacia			:= '';
	SET Entero_Cero				:= 0;
	SET Decimal_Cero			:= 0;
	SET Estatus_Vigente			:= 'N';

	SET Var_Transaccion := (SELECT  MAX(Transaccion)
							FROM DETALLEPAGCRE
							WHERE CreditoID= Par_CreditoID);
	SELECT COUNT(CreditoID)
    INTO Var_NumRegistros
    FROM RESCREDITOS
    WHERE CreditoID = Par_CreditoID
    AND TranRespaldo = Aud_NumTransaccion;

    IF Var_NumRegistros > Entero_Cero THEN
    	LEAVE TerminaStore;
    END IF;
	-- Respaldo de la informacion  de la tabla  CREDITOS antes del proceso de pago de credito
	INSERT INTO RESCREDITOS (
		`TranRespaldo`,			`CreditoID`,			`LineaCreditoID`,		`ClienteID`,			`CuentaID`,
		`MonedaID`,				`ProductoCreditoID`,	`DestinoCreID`,			`MontoCredito`,			`Relacionado`,
		`SolicitudCreditoID`,	`TipoFondeo`,			`InstitFondeoID`,		`LineaFondeo`,			`FechaInicio`,
		`FechaVencimien`,		`CalcInteresID`,		`TasaBase`,				`TasaFija`,				`SobreTasa`,
		`PisoTasa`,				`TechoTasa`,			`FactorMora`,			`FrecuenciaCap`,		`PeriodicidadCap`,
		`FrecuenciaInt`,		`PeriodicidadInt`,		`TipoPagoCapital`,		`NumAmortizacion`,		`MontoCuota`,
		`FechTraspasVenc`,		`FechTerminacion`,		`IVAInteres`,			`IVAComisiones`,		`Estatus`,
		`FechaAutoriza`,		`UsuarioAutoriza`,		`SaldoCapVigent`,		`SaldoCapAtrasad`,		`SaldoCapVencido`,
		`SaldCapVenNoExi`,		`SaldoInterOrdin`,		`SaldoInterAtras`,		`SaldoInterVenc`,		`SaldoInterProvi`,
		`SaldoIntNoConta`,		`SaldoIVAInteres`,		`SaldoMoratorios`,		`SaldoIVAMorator`,		`SaldComFaltPago`,
		`SalIVAComFalPag`,		`SaldoOtrasComis`,		`SaldoIVAComisi`,		`ProvisionAcum`,		`PagareImpreso`,
		`FechaInhabil`,			`CalendIrregular`,		`DiaPagoInteres`,		`DiaPagoCapital`,		`DiaMesInteres`,
		`DiaMesCapital`,		`AjusFecUlVenAmo`,		`AjusFecExiVen`,		`NumTransacSim`,		`FechaMinistrado`,
		`FolioDispersion`,		`SucursalID`,			`ValorCAT`,				`ClasifRegID`,			`MontoComApert`,
		`IVAComApertura`,		`PlazoID`,				`TipoDispersion`,		`TipoCalInteres`,		`MontoDesemb`,
		`MontoPorDesemb`,		`NumAmortInteres`,		`AporteCliente`,		`MontoSeguroVida`,		`SeguroVidaPagado`,
		`ForCobroSegVida`,		`ComAperPagado`,		`ForCobroComAper`,		`ClasiDestinCred`,		`CicloGrupo`,
		`GrupoID`,				`SaldoMoraVencido`,		`SaldoMoraCarVen`,		`MontoSeguroCuota`,		`IVASeguroCuota`,
		`SaldoComAnual`,		`ComAperCont`,			`IVAComAperCont`,		`ComAperReest`,			`IVAComAperReest`,
		`FechaAtrasoCapital`,	`FechaAtrasoInteres`,	`CobraAccesorios`,		`SaldoNotCargoRev`,		`SaldoNotCargoSinIVA`,
		`SaldoNotCargoConIVA`,
		`ManejaComAdmon`,		`ComAdmonLinPrevLiq`,	`ForCobComAdmon`,		`ForPagComAdmon`,		`PorcentajeComAdmon`,
		`ManejaComGarantia`,	`ComGarLinPrevLiq`,		`ForCobComGarantia`,	`ForPagComGarantia`,	`PorcentajeComGarantia`,
		`MontoPagComAdmon`,		`MontoCobComAdmon`,		`MontoPagComGarantia`,	`MontoCobComGarantia`,	`SaldoComServGar`,
		`SaldoIVAComSerGar`,	`MontoPagComGarantiaSim`,
		`EmpresaID`,			`Usuario`,				`FechaActual`,			`DireccionIP`,			`ProgramaID`,
		`Sucursal`,				`NumTransaccion`)
	SELECT
		Aud_NumTransaccion,			`CreditoID`,			`LineaCreditoID`,		`ClienteID`,			`CuentaID`,
		`MonedaID`,					`ProductoCreditoID`,	`DestinoCreID`,			`MontoCredito`,			`Relacionado`,
		`SolicitudCreditoID`,		`TipoFondeo`,			`InstitFondeoID`,		`LineaFondeo`,			`FechaInicio`,
		`FechaVencimien`,			`CalcInteresID`,		`TasaBase`,				`TasaFija`,				`SobreTasa`,
		`PisoTasa`,					`TechoTasa`,			`FactorMora`,			`FrecuenciaCap`,		`PeriodicidadCap`,
		`FrecuenciaInt`,			`PeriodicidadInt`,		`TipoPagoCapital`,		`NumAmortizacion`,		`MontoCuota`,
		`FechTraspasVenc`,			`FechTerminacion`,		`IVAInteres`,			`IVAComisiones`,		`Estatus`,
		`FechaAutoriza`,			`UsuarioAutoriza`,		`SaldoCapVigent`,		`SaldoCapAtrasad`,		`SaldoCapVencido`,
		`SaldCapVenNoExi`,			`SaldoInterOrdin`,		`SaldoInterAtras`,		`SaldoInterVenc`,		`SaldoInterProvi`,
		`SaldoIntNoConta`,			`SaldoIVAInteres`,		`SaldoMoratorios`,		`SaldoIVAMorator`,		`SaldComFaltPago`,
		`SalIVAComFalPag`,			`SaldoOtrasComis`,		`SaldoIVAComisi`,		`ProvisionAcum`,		`PagareImpreso`,
		`FechaInhabil`,				`CalendIrregular`,		`DiaPagoInteres`,		`DiaPagoCapital`,		`DiaMesInteres`,
		`DiaMesCapital`,			`AjusFecUlVenAmo`,		`AjusFecExiVen`,		`NumTransacSim`,		`FechaMinistrado`,
		`FolioDispersion`,			`SucursalID`,			`ValorCAT`,				`ClasifRegID`,			`MontoComApert`,
		`IVAComApertura`,			`PlazoID`,				`TipoDispersion`,		`TipoCalInteres`,		`MontoDesemb`,
		`MontoPorDesemb`,			`NumAmortInteres`,		`AporteCliente`,		`MontoSeguroVida`,		`SeguroVidaPagado`,
		`ForCobroSegVida`,			`ComAperPagado`,		`ForCobroComAper`,		`ClasiDestinCred`,		`CicloGrupo`,
		`GrupoID`,					`SaldoMoraVencido`,		`SaldoMoraCarVen`,		`MontoSeguroCuota`,		`IVASeguroCuota`,
		`SaldoComAnual`,			`ComAperCont`,			`IVAComAperCont`,		`ComAperReest`,			`IVAComAperReest`,
		`FechaAtrasoCapital`,		`FechaAtrasoInteres`,	`CobraAccesorios`,		`SaldoNotCargoRev`,		`SaldoNotCargoSinIVA`,
		`SaldoNotCargoConIVA`,
		`ManejaComAdmon`,			`ComAdmonLinPrevLiq`,	`ForCobComAdmon`,		`ForPagComAdmon`,		`PorcentajeComAdmon`,
		`ManejaComGarantia`,		`ComGarLinPrevLiq`,		`ForCobComGarantia`,	`ForPagComGarantia`,	`PorcentajeComGarantia`,
		`MontoPagComAdmon`,			`MontoCobComAdmon`,		`MontoPagComGarantia`,	`MontoCobComGarantia`,	`SaldoComServGar`,
		`SaldoIVAComSerGar`,		`MontoPagComGarantiaSim`,
		`EmpresaID`,				`Usuario`,				`FechaActual`,			`DireccionIP`,			`ProgramaID`,
		`Sucursal`,					`NumTransaccion`
	FROM CREDITOS
	WHERE CreditoID = Par_CreditoID;

	-- Respaldo de la informacion  de la tabla AMORTICREDITO antes del pago de Credito
	INSERT INTO RESAMORTICREDITO (
		`TranRespaldo`,			`AmortizacionID`,			`CreditoID`,			`ClienteID`,				`CuentaID`,
		`FechaInicio`,			`FechaVencim`,				`FechaExigible`,		`Estatus`,					`FechaLiquida`,
		`Capital`,				`Interes`,					`IVAInteres`,			`SaldoCapVigente`,			`SaldoCapAtrasa`,
		`SaldoCapVencido`,		`SaldoCapVenNExi`,			`SaldoInteresOrd`,		`SaldoInteresAtr`,			`SaldoInteresVen`,
		`SaldoInteresPro`,		`SaldoIntNoConta`,			`SaldoIVAInteres`,		`SaldoMoratorios`,			`SaldoIVAMorato`,
		`SaldoComFaltaPa`,		`SaldoIVAComFalP`,			`MontoOtrasComisiones`,	`MontoIVAOtrasComisiones`,	`SaldoOtrasComis`,
		`SaldoIVAComisi`,		`ProvisionAcum`,			`SaldoCapital`,			`NumProyInteres`,			`SaldoMoraVencido`,
		`SaldoMoraCarVen`,		`MontoSeguroCuota`,			`IVASeguroCuota`,		`SaldoSeguroCuota`,			`SaldoIVASeguroCuota`,
		`SaldoComisionAnual`,	`SaldoComisionAnualIVA`,	`SaldoNotCargoRev`,		`SaldoNotCargoSinIVA`,		`SaldoNotCargoConIVA`,
		`SaldoComServGar`,		`SaldoIVAComSerGar`,		`MontoIVAIntComisi`,	`MontoIntOtrasComis`,		`SaldoIntOtrasComis`,
		`SaldoIVAIntComisi`,
		`EmpresaID`,			`Usuario`,					`FechaActual`,			`DireccionIP`,				`ProgramaID`,
		`Sucursal`,				`NumTransaccion`)
	SELECT
		Aud_NumTransaccion,		`AmortizacionID`,			`CreditoID`,			`ClienteID`,				`CuentaID`,
		`FechaInicio`,			`FechaVencim`,				`FechaExigible`,		`Estatus`,					`FechaLiquida`,
		`Capital`,				`Interes`,					`IVAInteres`,			`SaldoCapVigente`,			`SaldoCapAtrasa`,
		`SaldoCapVencido`,		`SaldoCapVenNExi`,			`SaldoInteresOrd`,		`SaldoInteresAtr`,			`SaldoInteresVen`,
		`SaldoInteresPro`,		`SaldoIntNoConta`,			`SaldoIVAInteres`,		`SaldoMoratorios`,			`SaldoIVAMorato`,
		`SaldoComFaltaPa`,		`SaldoIVAComFalP`,			`MontoOtrasComisiones`,	`MontoIVAOtrasComisiones`,	`SaldoOtrasComis`,
		`SaldoIVAComisi`,		`ProvisionAcum`,			`SaldoCapital`,			`NumProyInteres`,			`SaldoMoraVencido`,
		`SaldoMoraCarVen`,		`MontoSeguroCuota`,			`IVASeguroCuota`,		`SaldoSeguroCuota`,			`SaldoIVASeguroCuota`,
		`SaldoComisionAnual`,	`SaldoComisionAnualIVA`,	`SaldoNotCargoRev`,		`SaldoNotCargoSinIVA`,		`SaldoNotCargoConIVA`,
		`SaldoComServGar`,		`SaldoIVAComSerGar`,		`MontoIVAIntComisi`,	`MontoIntOtrasComis`,		`SaldoIntOtrasComis`,
		`SaldoIVAIntComisi`,
		`EmpresaID`,			`Usuario`,					`FechaActual`,			`DireccionIP`,				`ProgramaID`,
		`Sucursal`,				`NumTransaccion`
	FROM AMORTICREDITO
	WHERE CreditoID = Par_CreditoID;

	-- Respalda la informacion de la tabla CREDITOSMOVS antes del proceso de pago del credito
	INSERT INTO RESCREDITOSMOVS (
		`TranRespaldo`,		`CreditoID`,		`AmortiCreID`,		`Transaccion`,		`FechaOperacion`,
		`FechaAplicacion`,	`TipoMovCreID`,		`NatMovimiento`,	`MonedaID`,			`Cantidad`,
		`Descripcion`,		`Referencia`,		`EmpresaID`,		`Usuario`,			`FechaActual`,
		`DireccionIP`,		`ProgramaID`,		`Sucursal`,			`NumTransaccion`)

	SELECT
		Aud_NumTransaccion,	`CreditoID`,		`AmortiCreID`,		`Transaccion`,		`FechaOperacion`,
		`FechaAplicacion`,	`TipoMovCreID`,		`NatMovimiento`,	`MonedaID`,			`Cantidad`,
		`Descripcion`,		`Referencia`,		`EmpresaID`,		`Usuario`,			`FechaActual`,
		`DireccionIP`,		`ProgramaID`,		`Sucursal`,			`NumTransaccion`
	FROM CREDITOSMOVS
	WHERE CreditoID = Par_CreditoID;

	INSERT INTO RESREGCRECONSOLIDADOS (
		TranRespaldo,       FechaRegistro,      CreditoID,          EstatusCredito,     EstatusCreacion,
		NumDiasAtraso,      NumPagoSoste,       NumPagoActual,      Regularizado,       FechaRegularizacion,
		ReservaInteres,     FechaLimiteReporte, EmpresaID,          Usuario,            FechaActual,
		DireccionIP,        ProgramaID,         Sucursal,           NumTransaccion)
	SELECT
		Aud_NumTransaccion, FechaRegistro,      CreditoID,          EstatusCredito,     EstatusCreacion,
		NumDiasAtraso,      NumPagoSoste,       NumPagoActual,      Regularizado,       FechaRegularizacion,
		ReservaInteres,     FechaLimiteReporte, EmpresaID,          Usuario,            FechaActual,
		DireccionIP,        ProgramaID,         Sucursal,           NumTransaccion
	FROM REGCRECONSOLIDADOS
	WHERE CreditoID = Par_CreditoID;

        -- Respaldar la informacion de CONSOLIDACIONCARTALIQ
        INSERT INTO RESCONSOLIDACIONCARTALIQ(
        	TranRespaldo, 		ConsolidaCartaID, 	ClienteID, 				SolicitudCreditoID, Estatus,
        	EsConsolidado, 		FlujoOrigen, 		TipoCredito, 			Relacionado, 		MontoConsolida,
        	CreditoID,          EstatusCredito,     EstatusCreacion,    	NumDiasAtraso,      NumPagoSoste,
        	NumPagoActual,      Regularizado,       FechaRegularizacion,	ReservaInteres,     FechaLimiteReporte,
        	EmpresaID,          Usuario,            FechaActual,			DireccionIP,        ProgramaID,
        	Sucursal,           NumTransaccion)
        SELECT
        	Aud_NumTransaccion, ConsolidaCartaID, 	ClienteID, 				SolicitudCreditoID, Estatus,
        	EsConsolidado, 		FlujoOrigen, 		TipoCredito, 			Relacionado, 		MontoConsolida,
        	CreditoID,          EstatusCredito,     EstatusCreacion,    	NumDiasAtraso,      NumPagoSoste,
        	NumPagoActual,      Regularizado,       FechaRegularizacion,	ReservaInteres,     FechaLimiteReporte,
        	EmpresaID,          Usuario,            FechaActual,			DireccionIP,        ProgramaID,
        	Sucursal,           NumTransaccion
        FROM CONSOLIDACIONCARTALIQ
        WHERE CreditoID = Par_CreditoID;

	-- Respaldo de inversiones en Garantia
	SET Var_InverEnGar  := (SELECT COUNT(CreditoID)
							FROM CREDITOINVGAR
							WHERE CreditoID = Par_CreditoID);
	SET Var_InverEnGar  := IFNULL(Var_InverEnGar, Entero_Cero);

	IF(Var_InverEnGar > Entero_Cero)THEN
		-- Respalda La informacion de la TABLE CREDITOINVGAR antes del proceso de pago del credito
		INSERT INTO RESCREDITOINVGAR (
			`TranRespaldo`,			`CreditoInvGarID`,		`CreditoID`,		`InversionID`,		`MontoEnGar`,
			`FechaAsignaGar`,		`EmpresaID`,			`Usuario`,			`FechaActual`,		`DireccionIP`,
			`ProgramaID`,			`Sucursal`,				`NumTransaccion`)
		SELECT
			Aud_NumTransaccion,		CI.`CreditoInvGarID`,	CI.`CreditoID`,		CI.`InversionID`,	CI.`MontoEnGar`,
			CI.`FechaAsignaGar`,	CI.`EmpresaID`,			CI.`Usuario`,		CI.`FechaActual`,	CI.`DireccionIP`,
			CI.`ProgramaID`,		CI.`Sucursal`,			CI.`NumTransaccion`
		FROM CREDITOINVGAR CI
		INNER JOIN INVERSIONES Inv ON Inv.InversionID = CI.InversionID AND Inv.Estatus = Estatus_Vigente
		WHERE CI.CreditoID = Par_CreditoID;
	END IF;

END TerminaStore$$