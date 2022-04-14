-- SP CRECALCULOSALDOSPRO

DELIMITER ;
DROP PROCEDURE IF EXISTS CRECALCULOSALDOSPRO;

DELIMITER $$
CREATE PROCEDURE `CRECALCULOSALDOSPRO`(
# ====================================================================
# -------SP PARA GENERAR LOS SALDOS DIARIOS DE LOS CREDITOS--------
# ====================================================================
  Par_Fecha     		DATE,				-- Fecha De Operacion
  Par_EmpresaID     	INT(11),			-- Parametro de Auditoria

  Aud_Usuario     		INT(11),			-- Parametro de Auditoria
  Aud_FechaActual   	DATETIME,			-- Parametro de Auditoria
  Aud_DireccionIP   	VARCHAR(15),		-- Parametro de Auditoria
  Aud_ProgramaID    	VARCHAR(50),		-- Parametro de Auditoria
  Aud_Sucursal      	INT(11),			-- Parametro de Auditoria
  Aud_NumTransaccion  	BIGINT(20)			-- Parametro de Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_InicioMes       		DATE;           -- Fecha de Inicio de Mes
	DECLARE Var_FinMes          		DATE;           -- Fecha de Fin de Mes
	DECLARE Var_CorteMesAnt     		DATE;           -- Fecha de Corte de Mes Anterior
	DECLARE Var_FecAnioAnt      		DATE;           -- Fecha de Un Año Anterior
	DECLARE Var_DiasMes         		INT;            -- Numero de dias del Mes
	DECLARE Ref_Desembolso      		VARCHAR(50);    -- Referencia de Desembolso
	DECLARE Var_ClienteEsp				INT;
	-- Declaracion de constantes
	DECLARE Decimal_Cero        		DECIMAL(12,2);  -- Decimal Cero
	DECLARE Entero_Cero         		INT(11);        -- Entero Cero
	DECLARE Estatus_Inactivo    		CHAR(1);        -- Estatus Inactivo
	DECLARE Estatus_Vigente     		CHAR(1);        -- Estatus Vigente
	DECLARE Estatus_Vencido     		CHAR(1);        -- Estatus Vencido
	DECLARE Estatus_Castigado   		CHAR(1);        -- Estatus Castigado
	DECLARE Estatus_Atrasado   CHAR(1);
	DECLARE Estatus_Pagado      		CHAR(1);        -- Estatus Pagado
	DECLARE Nat_Cargo           		CHAR(1);        -- Naturaleza de Cargo
	DECLARE Nat_Abono           		CHAR(1);        -- Naturaleza de Abono
	DECLARE Tip_CapVigente      		INT(11);        -- Tipo Capital Vigente
	DECLARE Tip_CapAtrasado     		INT(11);        -- Tipo Capital Atrasado
	DECLARE Tip_CapVencido      		INT(11);        -- Tipo Capital Vencido
	DECLARE Tip_CapVenNoExi     		INT(11);        -- Tipo Capital Vencido No exigible
	DECLARE Tip_IntVigente      		INT(11);        -- Tipo Interes Vigente
	DECLARE Tip_IntAtrasado     		INT(11);        -- Tipo Interes Atrasado
	DECLARE Tip_IntVencido      		INT(11);        -- Tipo Interes Vencido
	DECLARE Tip_IntNoConta      		INT(11);        -- Tipo Interes No Contable
	DECLARE Tip_IntProvision    		INT(11);        -- Tipo Interes Provisionado
	DECLARE Tip_IntMorato       		INT(11);        -- Tipo Interes Moratorio
	DECLARE Tip_ComFalPago      		INT(11);        -- Tipo Interes Comision Falta de Pago
	DECLARE Tip_ComAdmon        		INT(11);        -- Tipo Interes Comision Administracion
	DECLARE Tip_IVAIntOrd       		INT(11);        -- Tipo IVA Interes Ordinario
	DECLARE Tip_IVAMorato       		INT(11);        -- Tipo IVA Moratorio
	DECLARE Tip_IVAFalPag       		INT(11);        -- Tipo IVA Falta de Pago
	DECLARE TipoMovComFalPago 			INT(11);		-- Tipo Movimiento Comision por Falta de Pago
	DECLARE TipoMovComApeCred 			INT(11);		-- Tipo Movimiento Comision por Apertura
	DECLARE TipoMovComAdmon 			INT(11);		-- Tipo Movimiento Comision por Gastos de Administracion
	DECLARE TipoMovComAnual 			INT(11);		-- Tipo Movimiento Comision por Anualidad
	DECLARE TipoMovIVAComFalPago		INT(11);		-- Tipo Movimiento IVA de Comision por Falta de Pago
	DECLARE TipoMovIVAComApeCre 		INT(11);		-- Tipo Movimiento IVA de Comision por Apertura
	DECLARE TipoMovIVAComAdmon 			INT(11);		-- Tipo Movimiento IVA de Comision por Gastos de Administracion
	DECLARE TipoMovIVAComAnual 			INT(11);		-- Tipo Movimiento IVA de Comision por Anualidad
	DECLARE Fecha_Vacia         		DATE;           -- Fecha Vacia
	DECLARE Cadena_Vacia        		CHAR(1);        -- Cadena Vacia
	DECLARE Sig_DiaHab      	DATE;
	DECLARE Var_EsHabil     	CHAR(1);
	DECLARE Ref_PasoAtraso      		VARCHAR(50);    -- Referencia Pago Atrasado
	DECLARE Ref_PasoVencido     		VARCHAR(50);    -- Referencia Pago Vencido
	DECLARE Ref_Regulariza      		VARCHAR(50);    -- Referencia Regularizacion
	DECLARE Ref_DevInteres      		VARCHAR(50);    -- Referencia Devengamiento de Intereses
	DECLARE Ref_PagoCredito     		VARCHAR(50);    -- Referencia Pago de credito
	DECLARE Ref_PagoAntici      		VARCHAR(50);    -- Referencia Pago Anticipado
	DECLARE Des_PagoAntici      		VARCHAR(50);    -- Referencia Descripcion Pago Anticipado
	DECLARE Ref_Condonacion     		VARCHAR(50);    -- Referencia Condonacion
	DECLARE Clien_Crediclub			INT;
	DECLARE Estatus_Suspendido	CHAR(1);
	DECLARE Tip_Nueva           		CHAR(1);        -- Tipo Normal
	DECLARE Tip_Renovacion      		CHAR(1);        -- Tipo Renovacion
	DECLARE Tip_Restructura     		CHAR(1);        -- Tipo Restructura
	DECLARE Tipo_Normal         		CHAR(2);        -- Tipo Normal
	DECLARE Tipo_Renovacion     		CHAR(2);        -- Tipo Renovacion
	DECLARE Tipo_Restructurada  		CHAR(2);        -- Tipo Restructura
	DECLARE Con_SI              		CHAR(1);        -- Constate SI
	DECLARE Con_NO              		CHAR(1);        -- Constate NO
	DECLARE Est_CredEliminado 			CHAR(1);		-- Estatus del Credito : Eliminado
	DECLARE TipoMovIntMora				DECIMAL(16,2);
	DECLARE TipoMovIntMoraVen			DECIMAL(16,2);
	DECLARE TipoMovIntMoraCarVen		DECIMAL(16,2);
	DECLARE TipoMovIVAIntMora			DECIMAL(16,2);
	DECLARE Tipo_TotalCapProxPag        INT(11);		-- Total de Captial para Proximo Pago
	DECLARE Tipo_TotalIntOrdProxPag     INT(11);		-- Total de Interes Ordinario para Proximo Pago
	DECLARE Tipo_TotalIVAIntOrdPorxPag  INT(11);		-- Total de IVA de Interes Ordinario para Proximo Pago
	DECLARE Tipo_IvaIntExig  			INT(11);
	DECLARE Tipo_IvaOtrosCargos			INT(11);
	
	DECLARE Mov_OtrasComisiones     INT(11);  
	DECLARE Mov_IVAOtrasComisiones  INT(11);     
	DECLARE Var_TipoMovIntAcc	INT(11);			
	DECLARE Var_TipoMovIvaIntAc	INT(11);			

	SET   Fecha_Vacia     	:= '1900-01-01';
	SET   Cadena_Vacia      := '';
	SET Decimal_Cero    	:= 0.00;
	SET Entero_Cero             	:= 0;
    SET Estatus_Inactivo        	:= 'I';
	SET Estatus_Vigente 	:= 'V';
	SET Estatus_Vencido 	:= 'B';
	SET Estatus_Atrasado   := 'A';
	SET Estatus_Castigado 	:= 'K';
	SET Estatus_Pagado  	:= 'P';
	SET Nat_Cargo   		:= 'C';
	SET Nat_Abono   		:= 'A';

	SET Tip_CapVigente  	:= 1;
	SET Tip_CapAtrasado 	:= 2;
	SET Tip_CapVencido  	:= 3;
	SET Tip_CapVenNoExi 	:= 4;

	SET Tip_IntVigente  	:= 10;
	SET Tip_IntAtrasado 	:= 11;
	SET Tip_IntVencido  	:= 12;
	SET Tip_IntNoConta  	:= 13;
	SET Tip_IntProvision  	:= 14;
	SET Tip_IntMorato   	:= 15;

	SET Tip_ComFalPago      := 40;
	SET Tip_ComAdmon        := 42;

	SET Tip_IVAIntOrd     := 20;
	SET Tip_IVAMorato     := 21;
	SET Tip_IVAFalPag     := 22;

	SET TipoMovIntMora				:= 15;
	SET TipoMovIntMoraVen			:= 16;
	SET TipoMovIntMoraCarVen		:= 17;
	SET TipoMovIVAIntMora			:= 21;
	SET TipoMovComFalPago 			:= 40;
 	SET TipoMovComApeCred 			:= 41;
 	SET TipoMovComAdmon 			:= 42;
 	SET TipoMovComAnual 			:= 51;
 	SET TipoMovIVAComFalPago 		:= 22;
 	SET TipoMovIVAComApeCre 		:= 23;
 	SET TipoMovIVAComAdmon 			:= 24;
 	SET TipoMovIVAComAnual 			:= 52;

	SET Mov_OtrasComisiones     := 43;    
	SET Mov_IVAOtrasComisiones  := 26;    
	SET Var_TipoMovIntAcc		:= 57;				
	SET Var_TipoMovIvaIntAc		:= 58;	
			


	SET Ref_PasoAtraso  := 'GENERACION INTERES MORATORIO';
	SET Ref_PasoVencido := 'TRASPASO A CARTERA VENCIDA';
	SET Ref_Regulariza  := 'REGULARIZACION DE CREDITO';
	SET Ref_DevInteres  := 'GENERACION INTERES';
	SET Ref_PagoCredito := 'PAGO DE CREDITO';
	SET Des_PagoAntici  := 'DEVENGO INT.PAGO ANTICI';
	SET Ref_PagoAntici  := 'PAGO ANTICIPADO';
	SET Ref_Condonacion := 'CONDONACION CARTERA';
	SET Ref_Desembolso  := 'DESEMBOLSO DE CREDITO';
	SET Clien_Crediclub	:= 24;
	SET Con_NO      := 'N';

	SET Var_InicioMes = DATE_ADD(Par_Fecha, interval -1*(day(Par_Fecha))+1 day);
	SET Var_FinMes = LAST_DAY(Par_Fecha);
	SET Var_DiasMes = (DATEDIFF(Var_FinMes, Var_InicioMes) + 1);
	SET Var_FecAnioAnt = DATE_SUB(Par_Fecha, INTERVAL 1 YEAR);

	SET Var_ClienteEsp := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = 'CliProcEspecifico');
	SET Estatus_Suspendido	:= 'S';
	SET Tip_Nueva               	:= 'N';
	SET Tip_Renovacion          	:= 'O';
	SET Tip_Restructura         	:= 'R';
	SET Tipo_Normal             	:= 'NO';
	SET Tipo_Renovacion         	:= 'RN';
	SET Tipo_Restructurada      	:= 'RE';
	SET Con_NO                  	:= 'N';
	SET Con_SI                  	:= 'S';
	SET Est_CredEliminado 			:= 'E';				  -- Estatus del Credito : Eliminado
	SET Tipo_TotalCapProxPag        := 5;                 -- Total de Captial para Proximo Pago  -> para la funcion FNEDOCTAGENERALSALDO
	SET Tipo_TotalIntOrdProxPag     := 6;                 -- Total de Interes Ordinario para Proximo Pago  -> para la funcion FNEDOCTAGENERALSALDO
	SET Tipo_TotalIVAIntOrdPorxPag  := 7;                 -- Total de IVA de Interes Ordinario para Proximo Pago  -> para la funcion FNEDOCTAGENERALSALDO
	SET Tipo_IvaIntExig  			:= 10;                -- Total de IVA de Interes Ordinario Exigible  -> para la funcion FNEDOCTAGENERALSALDO	
	SET Tipo_IvaOtrosCargos  		:= 11;                -- Total de IVA de Otros Cargos Exigibles  -> para la funcion FNEDOCTAGENERALSALDO	

DROP TABLE IF EXISTS TMP_CALCULOIVAACCESORIOS;

-- CREAMOS LA TABLA PARA EL CALCULO DEL IVA DE ACCESORIOS
CREATE TABLE TMP_CALCULOIVAACCESORIOS (
	CreditoID bigint(12) NOT NULL DEFAULT '0' COMMENT 'ID del Credito',
    SalIVAAccesorio DECIMAL(14,2) DEFAULT '0.00' COMMENT 'Monto de IVA de la suma de Moratorios y Comisiones',
	PRIMARY KEY (CreditoID)
) ENGINE=MEMORY DEFAULT CHARSET=latin1 COMMENT='IVA ACCESORIOS';

-- INSERTAMOS LOS DATOS DEL IVA DE ACCESORIOS
INSERT INTO TMP_CALCULOIVAACCESORIOS
   SELECT distinct AMO.CreditoID, 
		SUM(CASE WHEN Det.CobraIVA ="S" THEN ROUND((Det.SaldoVigente + Det.SaldoAtrasado)*SUC.IVA,2) ELSE 0 END) 
        FROM AMORTICREDITO AMO
        INNER JOIN DETALLEACCESORIOS Det ON Det.CreditoID = AMO.CreditoID
        INNER JOIN CREDITOS CRE ON AMO.CreditoID = CRE.CreditoID
        INNER JOIN CLIENTES CLI ON CLI.ClienteID= CRE.ClienteID
        INNER JOIN SUCURSALES SUC ON SUC.SucursalID=CLI.SucursalOrigen
    WHERE AMO.Estatus <> Estatus_Pagado 
	AND AMO.FechaExigible  <= Par_Fecha
    group by AMO.CreditoID,AMO.AmortizacionID;
    

-- Debido a que la tabla de DETALLEPAGCRE No desglosa la parte de los IVas se tuvo que realizar este ajuste para
	-- Obtener el IVA realmente pagado por concepto, esto temporalmente en lo que se ajusta el proceso de pago para que realice el desglose

	DROP TEMPORARY TABLE IF EXISTS TMP_PAGOSCREDITOSMOVS;

	CREATE TEMPORARY TABLE TMP_PAGOSCREDITOSMOVS (
		  		CreditoID 		BIGINT(12) 		NOT NULL  	,
				IntOrd 			DECIMAL(16,2) 	DEFAULT '0' ,
				IntAtra 		DECIMAL(16,2) 	DEFAULT '0' ,
				IntVen 			DECIMAL(16,2) 	DEFAULT '0' ,
				IntDevNoConta 	DECIMAL(16,2) 	DEFAULT '0' ,
				IntProvision 	DECIMAL(16,2) 	DEFAULT '0' ,
				IVAInteres 		DECIMAL(16,2) 	DEFAULT '0' ,
				IntMora			DECIMAL(16,2) 	DEFAULT '0' ,
				IntMoraVen		DECIMAL(16,2) 	DEFAULT '0' ,
				IntMoraCarVen	DECIMAL(16,2) 	DEFAULT '0' ,
		  		ComFalPago		DECIMAL(16,2) 	DEFAULT '0' ,
		  		ComApeCred 		DECIMAL(16,2) 	DEFAULT '0' ,
		  		ComAdmon 		DECIMAL(16,2) 	DEFAULT '0' ,
		  		ComAnual 		DECIMAL(16,2) 	DEFAULT '0' ,
		  		IVAComFalPago 	DECIMAL(16,2) 	DEFAULT '0' ,
		  		IVAComApeCre 	DECIMAL(16,2) 	DEFAULT '0' ,
		  		IVAComAdmon 	DECIMAL(16,2) 	DEFAULT '0' ,
		  		IVAComAnual 	DECIMAL(16,2) 	DEFAULT '0' ,
				IVAMora 		DECIMAL(16,2) 	DEFAULT '0' ,
		  		PRIMARY KEY  (CreditoID)
		);

	DROP TABLE IF EXISTS TMP_SALDOSCREDITOS_CIERRE;
	CREATE TABLE TMP_SALDOSCREDITOS_CIERRE (	 CreditoID 				BIGINT(12) 		NOT NULL DEFAULT '0' 	COMMENT 'ID del Credito',
												 FechaCorte 			DATE 			NOT NULL 				COMMENT 'Fecha de Corte',
												 SalCapVigente 			DECIMAL(14,2) 	DEFAULT '0.00' 			COMMENT 'Saldo de Capital Vigente',
												 SalCapAtrasado 		DECIMAL(14,2) 	DEFAULT '0.00' 			COMMENT 'Saldo de Capital Atrasado',
												 SalCapVencido 			DECIMAL(14,2) 	DEFAULT '0.00' 			COMMENT 'Saldo de Capital Vencido',
												 SalCapVenNoExi 		DECIMAL(14,2) 	DEFAULT '0.00' 			COMMENT 'Saldo de Capital Vencido no Exigible',
												 SalIntOrdinario 		DECIMAL(14,2) 	DEFAULT '0.00' 			COMMENT 'Saldo de Interes Ordinario',
												 SalIntAtrasado 		DECIMAL(14,2) 	DEFAULT '0.00' 			COMMENT 'Saldo de Interes Atrasado',
												 SalIntVencido 			DECIMAL(14,2) 	DEFAULT '0.00' 			COMMENT 'Saldo de Interes Vencido',
												 SalIntProvision 		DECIMAL(14,2) 	DEFAULT '0.00' 			COMMENT 'Saldo de Provision',
												 SalIntNoConta 			DECIMAL(14,2) 	DEFAULT '0.00' 			COMMENT 'Saldo de Interes no Contabilizado',
												 SalMoratorios 			DECIMAL(14,2) 	DEFAULT '0.00' 			COMMENT 'Saldo Moratorios',
												 SaldoMoraVencido 		DECIMAL(14,2) 	DEFAULT '0.00' 			COMMENT 'Saldo de Interes Moratorio en atraso o vencido',
												 SaldoMoraCarVen 		DECIMAL(14,2) 	DEFAULT '0.00' 			COMMENT 'Saldo de Moratorios deirvado de cartera vencida, en ctas de orden',
												 SalComFaltaPago 		DECIMAL(14,2) 	DEFAULT '0.00' 			COMMENT 'Saldo Comision Falta Pago',
												 SalOtrasComisi 		DECIMAL(14,2) 	DEFAULT '0.00' 			COMMENT 'Saldo Comision Otras Comisiones', 
												`SaldoComisionAnual`	DECIMAL(16,2)	DEFAULT '0.00'			COMMENT 'Saldo Comision por Anualidad',
												`SaldoSeguroCuota`		DECIMAL(16,2)	DEFAULT '0.00'			COMMENT 'Saldo Saldo Seguro Cuota',
												 SalIVAInteres 			DECIMAL(14,2) 	DEFAULT '0.00' 			COMMENT 'Saldo Iva Interes',
											     SalIVAMoratorios 		DECIMAL(14,2) 	DEFAULT '0.00' 			COMMENT 'Saldo Iva Moratorios',
											     SalIVAComFalPago 		DECIMAL(14,2) 	DEFAULT '0.00' 			COMMENT 'Saldo Iva Comision Falta Pago',
											     SalIVAComisi 			DECIMAL(14,2) 	DEFAULT '0.00' 			COMMENT 'Saldo Iva Otras Comisiones',
												`SaldoComisionAnualIVA`	DECIMAL(16,2)	DEFAULT '0.00'			COMMENT 'Saldo Iva Comision por Anualidad',
												`SaldoIVASeguroCuota`	DECIMAL(16,2)	DEFAULT '0.00'			COMMENT 'Saldo Iva Seguro Cuota',
												 PasoCapAtraDia 		DECIMAL(14,2) 	DEFAULT '0.00' 			COMMENT 'Monto Capital que paso a Atrasado dia de hoy',
												 PasoCapVenDia 			DECIMAL(14,2) 	DEFAULT '0.00' 			COMMENT 'Monto Capital que paso a Vencido dia de hoy',
												 PasoCapVNEDia 			DECIMAL(14,2) 	DEFAULT '0.00' 			COMMENT 'Monto Capital que paso a VNE dia de hoy',
												 PasoIntAtraDia 		DECIMAL(14,2) 	DEFAULT '0.00' 			COMMENT 'Monto Interes que paso a Atrasado dia de hoy',
												 PasoIntVenDia 			DECIMAL(14,2) 	DEFAULT '0.00' 			COMMENT 'Monto Interes que paso a Vencido dia de hoy',
												 CapRegularizado 		DECIMAL(14,2) 	DEFAULT '0.00' 			COMMENT 'Monto del Capital Regularizado al dia',
											     IntOrdDevengado 		DECIMAL(14,2) 	DEFAULT '0.00' 			COMMENT 'Monto de interes Ordinario Devengado',
											     IntMorDevengado 		DECIMAL(14,2) 	DEFAULT '0.00' 			COMMENT 'Monto de interes Moratorio Devengado',
											     ComisiDevengado 		DECIMAL(14,2) 	DEFAULT '0.00' 			COMMENT 'Monto de Comision por Falta de Pago',
											     PagoCapVigDia 			DECIMAL(14,2) 	DEFAULT '0.00' 			COMMENT 'Pagos de Capital Vigente del Dia',
											     PagoCapAtrDia 			DECIMAL(14,2) 	DEFAULT '0.00' 			COMMENT 'Pagos de Capital Atrasado del Dia',
											     PagoCapVenDia 			DECIMAL(14,2) 	DEFAULT '0.00' 			COMMENT 'Pagos de Capital Vencido del Dia',
											     PagoCapVenNexDia 		DECIMAL(14,2) 	DEFAULT '0.00' 			COMMENT 'Pagos de Capital VNE del Dia',
											     PagoIntOrdDia 			DECIMAL(14,2) 	DEFAULT '0.00' 			COMMENT 'Pagos de Interes Ordinario del Dia',
											     PagoIntVenDia 			DECIMAL(14,2) 	DEFAULT '0.00' 			COMMENT 'Pagos de Interes  Vencido del Dia',
											     PagoIntAtrDia 			DECIMAL(14,2) 	DEFAULT '0.00' 			COMMENT 'Pagos de Interes  Atrasado del Dia',
											     PagoIntCalNoCon 		DECIMAL(14,2) 	DEFAULT '0.00' 			COMMENT 'Pagos de Interes No Contabilizado del Dia',
											     PagoComisiDia 			DECIMAL(14,2) 	DEFAULT '0.00' 			COMMENT 'Pagos de Interes No Comisiones del Dia',
												 PagoMoratorios 		DECIMAL(14,2) 	DEFAULT '0.00' 			COMMENT 'Pagos de\nMoratorio del Dia',
												 PagoIvaDia 			DECIMAL(14,2) 	DEFAULT '0.00' 			COMMENT 'Pagos de IVAS del Dia',
												 IntCondonadoDia 		DECIMAL(14,2) 	DEFAULT '0.00' 			COMMENT 'Interes Codonado\nDel Dia',
												 MorCondonadoDia 		DECIMAL(14,2) 	DEFAULT '0.00' 			COMMENT 'Moratorios\nCodonados\nDel Dia',
												 DiasAtraso 			int(11) 		DEFAULT '0' 			COMMENT 'Numero de Dias de Atraso Al Dia',
												 NoCuotasAtraso 		int(11) 		DEFAULT '0' 			COMMENT 'Numero de Cuotas en Atraso al Dia',
												 MaximoDiasAtraso 		int(11) 		DEFAULT NULL 			COMMENT 'Numero de Maximo Dias de atraso, historico',
												 LineaCreditoID 		bigint(20) 		DEFAULT NULL COMMENT 'Id de linea de Credito',
												 ClienteID 				int(11) 		DEFAULT NULL COMMENT 'Id de cliente',
												 MonedaID 				int(11) 		DEFAULT NULL COMMENT 'Id de moneda',
												 FechaInicio 			date 			DEFAULT NULL COMMENT 'Fecha de Inicio',
												 FechaVencimiento 		date 			DEFAULT NULL COMMENT 'Fecha Vencimiento',
												 FechaExigible 			date 			DEFAULT NULL COMMENT 'Fecha Exigibilidad',
												 FechaLiquida 			date 			DEFAULT NULL COMMENT 'Fecha Liquidación',
											     ProductoCreditoID 		int(11) 		DEFAULT NULL COMMENT 'id de producto',
												`SolicitudCreditoID`	BIGINT(12) 		DEFAULT '0'				COMMENT 'ID de la solicitud de Credito Asociado al Credito',
												`TipoCredito`			CHAR(1) 		DEFAULT ''				COMMENT 'Indica el tratamiento al credito \nN=nuevo, \nR=reestructura, \nO=renovacion',
												`PlazoID`				VARCHAR(20) 	DEFAULT ''				COMMENT 'Plazo del credito',
												`TasaFija`				DECIMAL(14,2) 	DEFAULT '0.00'			COMMENT 'Tasa fija anual que fue pactada con el credito.',
												`TasaBase`				DECIMAL(14,2) 	DEFAULT '0.00'			COMMENT 'Tasa Base anualizada, esto solo aplica en caso que el credito maneje tasa variable',
												`SobreTasa`				DECIMAL(14,2) 	DEFAULT '0.00'			COMMENT 'Sobre tasa que le aplica a la tasa base, esto solo si fue pactada una sobre tasa en el credito.',
												`PisoTasa`				DECIMAL(14,2) 	DEFAULT '0.00'			COMMENT 'Piso tasa que le aplica a la tasa base, esto solo si fue pactada una sobre tasa en el credito.',
												`TechoTasa`				DECIMAL(14,2) 	DEFAULT '0.00'			COMMENT 'Techo tasa que le aplica a la tasa base, esto solo si fue pactada una sobre tasa en el credito.',
												`TipoCartera`			VARCHAR(2) 		DEFAULT ''				COMMENT 'Se refiere el tipo de cartera que corresponde el crédito conforme a su origen (reestructurada, renovada, normal):\nNO = Normal \nRE = Reestructura \nRN = Renovada.',
												`TipCobComMorato`		CHAR(1) 		DEFAULT ''				COMMENT 'Campo que indica como se generan los moratorios:\nN = Indica que la mora se calcula con N veces la tasa ordinaria \nT = Indica que es una tasa fija para el calculo de moratorios.',
												`FactorMora`			DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Factor de Moratorio',
												`CreditoOrigen`			VARCHAR(200) 	DEFAULT ''				COMMENT 'Numero de credito de acuerdo a SAFI. Es el credito a reestructurar o a renovar según sea el caso, es decir, credito que se va a liquidar con la renovación o la reestrutura.',
												`ConGarPrenda`			CHAR(1) 		DEFAULT ''				COMMENT 'Requiere Garantia Prendaria(mobiliaria)',
												`ConGarLiq`				CHAR(1) 		DEFAULT ''				COMMENT 'Requiere Garantia liquida',
												`TotalParticipantes`	INT(11) 		DEFAULT '0'				COMMENT 'Total Participantes del Credito o Solicitud Credito',
												`FechaProximoPago`		DATE			DEFAULT '1900-01-01'	COMMENT 'Fecha de Proximo Pago inmediato',
												`MontoProximoPago`		DECIMAL(14,2)	DEFAULT '0.00'			COMMENT 'Monto de Proximo Pago inmediato',
												 EstatusCredito 		char(1) 		DEFAULT NULL COMMENT 'Estatus credito al cierre de mes',
												 SaldoPromedio 			DECIMAL(14,2) 	DEFAULT NULL COMMENT 'Monto Original Credito',
												 MontoCredito 			DECIMAL(14,2) 	DEFAULT NULL,
												 FrecuenciaCap 			char(1) 		DEFAULT NULL,
												 PeriodicidadCap 		int(11) 		DEFAULT NULL COMMENT 'Periodicidad',
											     FrecuenciaInt 			char(1) 		DEFAULT NULL COMMENT 'Frecuencia de Pago de las Amortizaciones de Interes\\\nS .- Semanal, C .- Catorcenal Q .- Quincenal M .- Mensual P .- Periodo\\\nB.-Bimestral  T.-Trimestral  R.-TetraMestral E.-Semestral  A.-Anual',
											     PeriodicidadInt 		int(11) 		DEFAULT NULL,
											     NumAmortizacion 		int(11) 		DEFAULT NULL COMMENT 'Numero de Amortizaciones o Cuotas',
											     FechTraspasVenc 		date 			DEFAULT NULL COMMENT 'Fecha de Traspaso a Vencido',
											     FechAutoriza 			date 			DEFAULT NULL,
											     ClasifRegID	 		int(11) 		DEFAULT NULL COMMENT 'Clasificacion Segun Reportes Regulatorios',
											     DestinoCreID 			int(11) 		DEFAULT NULL,
											     Calificacion 			char(2) 		DEFAULT NULL COMMENT 'Calificacion de Cartera',
											     PorcReserva 			DECIMAL(14,2) 	DEFAULT NULL COMMENT 'Porcentaje de Reserva',
											     TipoFondeo 			char(1) 		DEFAULT NULL COMMENT 'Tipo de Fondeo:\nP .- Recursos Propios\nF .- Institucion de Fondeo',
												 InstitFondeoID 		int(11) 		DEFAULT NULL COMMENT 'Insitucion de Fondeo, puede no escoger linea de fondeo',
											     IntDevCtaOrden 		DECIMAL(14,2) 	DEFAULT NULL COMMENT 'Interes Devengado de Cartera Vencida, \nCuentas de Orden',
											     CapCondonadoDia 		DECIMAL(14,2) 	DEFAULT NULL COMMENT 'Capital Condonado del Dia',
											     ComAdmonPagDia 		DECIMAL(14,2) 	DEFAULT NULL COMMENT 'Comision por Admon, Pagad en el Dia',
											     ComCondonadoDia 		DECIMAL(14,2) 	DEFAULT NULL COMMENT 'Comision Condonado en el Dia',
												 DesembolsosDia 		DECIMAL(14,2) 	DEFAULT NULL COMMENT 'Comision Condonado en el Dia',
											     CapVigenteExi 			DECIMAL(14,2) 	DEFAULT NULL COMMENT 'Capital vigente exigible',
											     MontoTotalExi 			DECIMAL(14,2) 	DEFAULT NULL COMMENT 'Monto total exigible',
												 SalMontoAccesorio 		DECIMAL(14,2) 	DEFAULT '0.00' COMMENT 'Monto que suma Moratorios y Comisiones',
												 SalIVAAccesorio 		DECIMAL(14,2) 	DEFAULT '0.00' COMMENT 'Monto de IVA de la suma de Moratorios y Comisiones',
											     SalIntAccesorio 		DECIMAL(14,2) 	DEFAULT '0.00' COMMENT 'Almacena el importe de interes de accesorios',
											     SalIVAIntAccesorio 	DECIMAL(14,2) 	DEFAULT '0.00' COMMENT 'Almacena el importe de IVA de interes de los accesorios',
											     SaldoComServGar 		DECIMAL(14,2) 	DEFAULT '0.00' COMMENT 'Saldo Comision por Servicio de Garantia Agro' ,
											     SaldoIVAComSerGar 		DECIMAL(14,2) 	DEFAULT '0.00' COMMENT 'Saldo Iva Comision por Servicio de Garantia Agro',
												`SaldoParaFiniq` 		DECIMAL(16,2) 	DEFAULT '0.00'			COMMENT 'Monto para Finiquitar el Credito',
												`CuotasPagadas`			INT(11)			DEFAULT '0.00'			COMMENT 'Numero de cuotas pagadas del credito',
												`ValorCAT`				DECIMAL(12,4)	DEFAULT '0.00'			COMMENT 'Valor de CAT que tiene el credito',
												`CapitalProxPago`		DECIMAL(16,2)	DEFAULT '0.00'			COMMENT 'Capital a Pagar en el Proximo Pago',
												`InteresProxPago`		DECIMAL(16,2)	DEFAULT '0.00'			COMMENT 'Interes Ordinario a pagar en el Proximo Pago',
												`IvaProxPago`			DECIMAL(16,2)	DEFAULT '0.00'			COMMENT 'IVA de Intereses a pagar en el Proximo Pago',
												`SalInteresExigible`	DECIMAL(16,2)	DEFAULT '0.00'			COMMENT 'Saldo de Interes Exigible, Tendra valor cuando el credito tiene al menos una cuota de atraso',
												`IVAInteresExigible`	DECIMAL(16,2)	DEFAULT '0.00'			COMMENT 'IVA de Interes Exigible, Tendra valor cuando el credito tiene al menos una cuota de atraso',
												`PagoIntOrdMes`			DECIMAL(16,2)	DEFAULT '0.00'			COMMENT 'Monto de Intereses Ordinarios pagadas en el Mes',
												`PagoIVAIntOrdMes`		DECIMAL(16,2)	DEFAULT '0.00'			COMMENT 'Monto de IVA de Intereses Ordinarios pagadas en el Mes',
												`PagoMoraMes`			DECIMAL(16,2)	DEFAULT '0.00'			COMMENT 'Monto de Interes Moratorio pagado en el Mes',
												`PagoIVAMoraMes`		DECIMAL(16,2)	DEFAULT '0.00'			COMMENT 'Monto de IVA de Interes Moratorio pagado en el Mes',
												`PagoComisiMes`			DECIMAL(16,2)	DEFAULT '0.00'			COMMENT 'Monto de Comisiones pagadas en el Mes',
												`PagoIVAComisiMes`		DECIMAL(16,2)	DEFAULT '0.00'			COMMENT 'Monto de IVA de Comisiones pagadas en el Mes',
												`OtrosCargosApagar`		DECIMAL(16,2)	DEFAULT '0.00'			COMMENT 'Monto que suma Moratorios y Comisiones',
												`IVAOtrosCargosApagar`	DECIMAL(16,2)	DEFAULT '0.00'			COMMENT 'Monto de IVA de la suma de Moratorios y Comisiones',
											     EmpresaID 				int(11) 		DEFAULT NULL 			COMMENT 'Parametro de auditoria',
											     Usuario 				int(11) 		DEFAULT NULL 			COMMENT 'Parametro de auditoria',
											     FechaActual 			datetime 		DEFAULT NULL 			COMMENT 'Parametro de auditoria',
											     DireccionIP 			varchar(15) 	DEFAULT NULL 			COMMENT 'Parametro de auditoria',
											     ProgramaID 			varchar(50) 	DEFAULT NULL 			COMMENT 'Parametro de auditoria',
											     Sucursal 				int(11) 		DEFAULT NULL 			COMMENT 'Parametro de auditoria',
												 NumTransaccion 		int(15) 		DEFAULT NULL 			COMMENT 'Parametro de auditoria',
												 PRIMARY KEY (CreditoID),
												 KEY IDX_TMP_SALDOSCREDITOS_CIERRE_01 (FechaCorte) USING BTREE,
												 KEY IDX_TMP_SALDOSCREDITOS_CIERRE_02 (CreditoID,FechaCorte),
												 KEY IDX_TMP_SALDOSCREDITOS_CIERRE_03 (CreditoID),
												 KEY IDX_TMP_SALDOSCREDITOS_CIERRE_04 (EstatusCredito),
												 KEY IDX_TMP_SALDOSCREDITOS_CIERRE_05 (FechaCorte,EstatusCredito)
												) ENGINE=MEMORY DEFAULT CHARSET=latin1 COMMENT='Saldos Diarios de Credito';

	DROP TEMPORARY TABLE IF EXISTS TMP_EDOCTA_AMORTICREDITO;

	CREATE TEMPORARY TABLE TMP_EDOCTA_AMORTICREDITO(	CreditoID				BIGINT(12),
														SaldoMoratorios			DECIMAL(16,2) DEFAULT '0.00',
														SaldoMoraVencido 		DECIMAL(16,2) DEFAULT '0.00',
														SaldoMoraCarVen			DECIMAL(16,2) DEFAULT '0.00',
														SaldoComFaltaPa			DECIMAL(16,2) DEFAULT '0.00',
														SaldoOtrasComis			DECIMAL(16,2) DEFAULT '0.00',
														SaldoComisionAnual		DECIMAL(16,2) DEFAULT '0.00',
														SaldoComisionAnualIVA	DECIMAL(16,2) DEFAULT '0.00',
														SaldoSeguroCuota		DECIMAL(16,2) DEFAULT '0.00',
														SaldoIVASeguroCuota		DECIMAL(16,2) DEFAULT '0.00',
														CuotasPagadas			INT(11) 	  DEFAULT '0',
														CapitalProxPago			DECIMAL(16,2) DEFAULT '0.00',
														InteresProxPago			DECIMAL(16,2) DEFAULT '0.00',
														IvaProxPago				DECIMAL(16,2) DEFAULT '0.00',
														SalInteresExigible		DECIMAL(16,2) DEFAULT '0.00',
														IVAInteresExigible		DECIMAL(16,2) DEFAULT '0.00',
														PagoIntOrdMes			DECIMAL(16,2) DEFAULT '0.00',
														PagoIVAIntOrdMes		DECIMAL(16,2) DEFAULT '0.00',
														PagoMoraMes				DECIMAL(16,2) DEFAULT '0.00',
														PagoIVAMoraMes			DECIMAL(16,2) DEFAULT '0.00',
														PagoComisiMes			DECIMAL(16,2) DEFAULT '0.00',
														PagoIVAComisiMes		DECIMAL(16,2) DEFAULT '0.00',
														OtrosCargosApagar		DECIMAL(16,2) DEFAULT '0.00',
														IVAOtrosCargosApagar	DECIMAL(16,2) DEFAULT '0.00',
														CliPagIVA 				CHAR(1) 	  DEFAULT 'S',
														SucIVA 					DECIMAL(16,2) DEFAULT '0.0',
														ProdPagIVAInt			CHAR(1) 	  DEFAULT 'S',
														ProdPagIVAMora 			CHAR(1) 	  DEFAULT 'S',
														PRIMARY KEY (CreditoID)
													);

	INSERT INTO TMP_PAGOSCREDITOSMOVS
	SELECT CreditoID,
			SUM(CASE TipoMovCreID WHEN Tip_IntVigente  		 THEN IFNULL(Cantidad, Entero_Cero) ELSE Entero_Cero END ) AS IntOrd,
			SUM(CASE TipoMovCreID WHEN Tip_IntAtrasado 		 THEN IFNULL(Cantidad, Entero_Cero) ELSE Entero_Cero END ) AS IntAtra,
			SUM(CASE TipoMovCreID WHEN Tip_IntVencido  		 THEN IFNULL(Cantidad, Entero_Cero) ELSE Entero_Cero END ) AS IntVen,
			SUM(CASE TipoMovCreID WHEN Tip_IntNoConta  		 THEN IFNULL(Cantidad, Entero_Cero) ELSE Entero_Cero END ) AS IntDevNoConta,
			SUM(CASE TipoMovCreID WHEN Tip_IntProvision		 THEN IFNULL(Cantidad, Entero_Cero) ELSE Entero_Cero END ) AS IntProvision,
			SUM(CASE TipoMovCreID WHEN Tip_IVAIntOrd 		 THEN IFNULL(Cantidad, Entero_Cero) ELSE Entero_Cero END ) AS IVAInteres,
			SUM(CASE TipoMovCreID WHEN TipoMovIntMora 	 	 THEN IFNULL(Cantidad, Entero_Cero) ELSE Entero_Cero END ) AS IntMora,
			SUM(CASE TipoMovCreID WHEN TipoMovIntMoraVen 	 THEN IFNULL(Cantidad, Entero_Cero) ELSE Entero_Cero END ) AS IntMoraVen,
			SUM(CASE TipoMovCreID WHEN TipoMovIntMoraCarVen  THEN IFNULL(Cantidad, Entero_Cero) ELSE Entero_Cero END ) AS IntMoraCarVen,
			SUM(CASE TipoMovCreID WHEN TipoMovComFalPago 	 THEN IFNULL(Cantidad, Entero_Cero) ELSE Entero_Cero END ) AS ComFalPago,
			SUM(CASE TipoMovCreID WHEN TipoMovComApeCred 	 THEN IFNULL(Cantidad, Entero_Cero) ELSE Entero_Cero END ) AS ComApeCred,
			SUM(CASE TipoMovCreID WHEN TipoMovComAdmon 	 	 THEN IFNULL(Cantidad, Entero_Cero) ELSE Entero_Cero END ) AS ComAdmon,
			SUM(CASE TipoMovCreID WHEN TipoMovComAnual 	 	 THEN IFNULL(Cantidad, Entero_Cero) ELSE Entero_Cero END ) AS ComAnual,
			SUM(CASE TipoMovCreID WHEN TipoMovIVAComFalPago  THEN IFNULL(Cantidad, Entero_Cero) ELSE Entero_Cero END ) AS IVAComFalPago,
			SUM(CASE TipoMovCreID WHEN TipoMovIVAComApeCre   THEN IFNULL(Cantidad, Entero_Cero) ELSE Entero_Cero END ) AS IVAComApeCre,
			SUM(CASE TipoMovCreID WHEN TipoMovIVAComAdmon 	 THEN IFNULL(Cantidad, Entero_Cero) ELSE Entero_Cero END ) AS IVAComAdmon,
			SUM(CASE TipoMovCreID WHEN TipoMovIVAComAnual 	 THEN IFNULL(Cantidad, Entero_Cero) ELSE Entero_Cero END ) AS IVAComAnual,
			SUM(CASE TipoMovCreID WHEN TipoMovIVAIntMora 	 THEN IFNULL(Cantidad, Entero_Cero) ELSE Entero_Cero END ) AS IVAMora
	FROM CREDITOSMOVS
	WHERE TipoMovCreID IN (	Tip_IntVigente, 	 	Tip_IntAtrasado, 		Tip_IntVencido, 		Tip_IntNoConta, 	Tip_IntProvision,
							Tip_IVAIntOrd, 		 	TipoMovComFalPago, 		TipoMovComApeCred, 		TipoMovComAdmon, 	TipoMovComAnual,
							TipoMovIVAComFalPago, 	TipoMovIVAComApeCre, 	TipoMovIVAComAdmon, 	TipoMovIVAComAnual,	TipoMovIntMora,
							TipoMovIntMoraVen,		TipoMovIntMoraCarVen,	TipoMovIVAIntMora)
	AND NatMovimiento = Nat_Abono
	AND FechaOperacion >= Var_InicioMes
	AND FechaOperacion <= Var_FinMes
	AND Descripcion = 'PAGO DE CREDITO'
	GROUP BY CreditoID;






	INSERT INTO TMP_EDOCTA_AMORTICREDITO (	CreditoID, 			SaldoMoratorios, 		SaldoMoraVencido, 			SaldoMoraCarVen, 		SaldoComFaltaPa,
											SaldoOtrasComis, 	SaldoComisionAnual, 	SaldoComisionAnualIVA,		SaldoSeguroCuota, 		SaldoIVASeguroCuota,
											CuotasPagadas, 		SalInteresExigible,		OtrosCargosApagar)
	SELECT 	Amo.CreditoID,
			SUM(CASE WHEN Amo.Estatus != Estatus_Pagado THEN	IFNULL(Amo.SaldoMoratorios, Entero_Cero) ELSE Entero_Cero END ) AS SaldoMoratorios,
			SUM(CASE WHEN Amo.Estatus != Estatus_Pagado THEN	IFNULL(Amo.SaldoMoraVencido, Entero_Cero) ELSE Entero_Cero END ) AS SaldoMoraVencido,
			SUM(CASE WHEN Amo.Estatus != Estatus_Pagado THEN	IFNULL(Amo.SaldoMoraCarVen, Entero_Cero) ELSE Entero_Cero END ) AS SaldoMoraCarVen,
			SUM(CASE WHEN Amo.Estatus != Estatus_Pagado THEN	IFNULL(Amo.SaldoComFaltaPa, Entero_Cero) ELSE Entero_Cero END ) AS SaldoComFaltaPa,
			SUM(CASE WHEN Amo.Estatus != Estatus_Pagado THEN	IFNULL(Amo.SaldoOtrasComis, Entero_Cero) ELSE Entero_Cero END ) AS SaldoOtrasComis,
			SUM(CASE WHEN Amo.Estatus != Estatus_Pagado THEN	IFNULL(Amo.SaldoComisionAnual, Entero_Cero) ELSE Entero_Cero END ) AS SaldoComisionAnual,
			SUM(IFNULL(Amo.SaldoComisionAnualIVA, Entero_Cero) )AS SaldoComisionAnualIVA,
			SUM(CASE WHEN Amo.Estatus != Estatus_Pagado THEN	IFNULL(Amo.SaldoSeguroCuota, Entero_Cero) ELSE Entero_Cero END ) AS SaldoSeguroCuota,
			SUM(IFNULL(Amo.SaldoIVASeguroCuota, Entero_Cero) )AS SaldoIVASeguroCuota,
			SUM(CASE WHEN Amo.Estatus = Estatus_Pagado THEN 1 ELSE 0 END ) AS   CuotasPagadas,
			SUM(CASE WHEN Amo.Estatus != Estatus_Pagado AND Amo.FechaExigible <= Par_Fecha THEN	  IFNULL(Amo.SaldoInteresOrd, Entero_Cero)
																								+ IFNULL(Amo.SaldoInteresAtr, Entero_Cero)
																								+ IFNULL(Amo.SaldoInteresVen, Entero_Cero)
																								+ IFNULL(Amo.SaldoInteresPro, Entero_Cero)
																								+ IFNULL(Amo.SaldoIntNoConta, Entero_Cero) ELSE Entero_Cero END ) AS SalInteresExigible,
			SUM(CASE WHEN Amo.Estatus != Estatus_Pagado AND Amo.FechaExigible <= Par_Fecha THEN	  IFNULL(Amo.SaldoMoratorios, Entero_Cero)
																								+ IFNULL(Amo.SaldoMoraVencido, Entero_Cero)
																								+ IFNULL(Amo.SaldoMoraCarVen, Entero_Cero)
																								+ IFNULL(Amo.SaldoComFaltaPa, Entero_Cero)
																								+ IFNULL(Amo.SaldoOtrasComis, Entero_Cero)
																								+ IFNULL(Amo.SaldoComisionAnual, Entero_Cero) ELSE Entero_Cero END ) AS OtrosCargosApagar
	 FROM AMORTICREDITO Amo
	 INNER JOIN CREDITOS Cre ON  Amo.CreditoID = Cre.CreditoID AND ( Cre.Estatus = Estatus_Vigente OR Cre.Estatus = Estatus_Vencido OR Cre.Estatus =  Est_CredEliminado
	 																	OR ( Cre.Estatus = Estatus_Castigado 	AND Cre.FechTerminacion = Par_Fecha )
																		OR ( Cre.Estatus = Estatus_Pagado		AND Cre.FechTerminacion = Par_Fecha ) )
	GROUP BY Amo.CreditoID;


    UPDATE TMP_EDOCTA_AMORTICREDITO Tmp
    	INNER JOIN CREDITOS Cre 		ON Tmp.CreditoID  = Cre.CreditoID
        INNER JOIN CLIENTES Cli 		ON Cre.ClienteID  = Cli.ClienteID
        INNER JOIN SUCURSALES Suc 		ON Cre.SucursalID = Suc.SucursalID
        INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID
    SET CliPagIVA 		= Cli.PagaIVA,
    	SucIVA 			= Suc.IVA,
    	ProdPagIVAInt	= Pro.CobraIVAInteres,
    	ProdPagIVAMora 	= Pro.CobraIVAMora;

    UPDATE TMP_EDOCTA_AMORTICREDITO
	SET CapitalProxPago		 = FNEDOCTAGENERALSALDO(CreditoID, Tipo_TotalCapProxPag),
		InteresProxPago		 = FNEDOCTAGENERALSALDO(CreditoID, Tipo_TotalIntOrdProxPag),
		IvaProxPago			 = FNEDOCTAGENERALSALDO(CreditoID, Tipo_TotalIVAIntOrdPorxPag),
		IVAInteresExigible	 = FNEDOCTAGENERALSALDO(CreditoID, Tipo_IvaIntExig),
		IVAOtrosCargosApagar = FNEDOCTAGENERALSALDO(CreditoID, Tipo_IvaOtrosCargos);






	SELECT  MAX(FechaCorte) INTO Var_CorteMesAnt
	FROM SALDOSCREDITOS
	WHERE FechaCorte < Var_InicioMes;

	SET Var_CorteMesAnt := IFNULL(Var_CorteMesAnt, Fecha_Vacia);

	CALL CRECLASIFCARTPRO(
		Par_Fecha,      Par_EmpresaID,  Aud_Usuario,        Aud_FechaActual,  Aud_DireccionIP,
		Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);


  INSERT INTO TMP_SALDOSCREDITOS_CIERRE
  SELECT Cre.CreditoID,    		Par_Fecha,      		MAX(SaldoCapVigent),  	MAX(SaldoCapAtrasad),	MAX(SaldoCapVencido), 
		 MAX(SaldCapVenNoExi), 	MAX(SaldoInterOrdin), 	MAX(SaldoInterAtras),	MAX(SaldoInterVenc),  	MAX(SaldoInterProvi), 
         MAX(SaldoIntNoConta),  MAX(SaldoMoratorios),	MAX(SaldoMoraVencido),  MAX(SaldoMoraCarVen),	MAX(SaldComFaltPago), 
			MAX(SaldoOtrasComis),   	Entero_Cero AS SalComAnualidad,		Entero_Cero AS SalSeguroCuota, 		MAX(SaldoIVAInteres),  				MAX(SaldoIVAMorator),
			MAX(SalIVAComFalPag),   	MAX(SaldoIVAComisi),				Entero_Cero AS SalComAnualIVA,		Entero_Cero AS SalIVASegCuota,
          IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Cargo AND
                               Mov.TipoMovCreID = Tip_CapAtrasado AND
                               Mov.Referencia = Ref_PasoAtraso THEN Mov.Cantidad
                           ELSE Decimal_Cero END),
                       Decimal_Cero) AS TrasCapAtraso,

          IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Cargo AND
                               Mov.TipoMovCreID = Tip_CapVencido AND
                               Mov.Referencia = Ref_PasoVencido THEN Mov.Cantidad
                           ELSE Decimal_Cero END),
                       Decimal_Cero) AS TrasCapVencido,

          IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Cargo AND
                               Mov.TipoMovCreID = Tip_CapVenNoExi AND
                               Mov.Referencia = Ref_PasoVencido THEN Mov.Cantidad
                           ELSE Decimal_Cero END),
                       Decimal_Cero) AS TrasCapVenNoExi,

          IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Cargo AND
                               Mov.TipoMovCreID = Tip_IntAtrasado AND
                               Mov.Referencia = Ref_PasoAtraso THEN Mov.Cantidad
                           ELSE Decimal_Cero END),
                       Decimal_Cero) AS TrasIntAtraso,

         IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Cargo AND
                               Mov.TipoMovCreID = Tip_IntVencido AND
                               Mov.Referencia = Ref_PasoVencido THEN Mov.Cantidad
                           ELSE Decimal_Cero END),
                       Decimal_Cero) AS TrasIntVencido,


         IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Cargo AND
                               Mov.TipoMovCreID = Tip_CapVigente AND
                               Mov.Referencia = Ref_Regulariza THEN Mov.Cantidad
                           ELSE Decimal_Cero END),
                       Decimal_Cero) AS Regulariza,

         IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Cargo AND
                               Mov.TipoMovCreID = Tip_IntProvision AND
                               Mov.Referencia = Ref_DevInteres THEN Mov.Cantidad
                           ELSE Decimal_Cero END) +
                  SUM(CASE WHEN Mov.NatMovimiento = Nat_Cargo AND
                               Mov.TipoMovCreID = Tip_IntProvision AND
                               Mov.Descripcion = Des_PagoAntici AND
                               Mov.Referencia = Ref_PagoAntici THEN Mov.Cantidad
                           ELSE Decimal_Cero END),
                       Decimal_Cero) AS IntOrdDevengado,

         IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Cargo AND
                               Mov.TipoMovCreID = Tip_IntMorato AND
                               Mov.Referencia = Ref_PasoAtraso THEN Mov.Cantidad
                           ELSE Decimal_Cero END),
                       Decimal_Cero) AS IntMorato,

         IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Cargo AND
                               Mov.TipoMovCreID = Tip_ComFalPago AND
                               Mov.Referencia = Ref_PasoAtraso THEN Mov.Cantidad
                           ELSE Decimal_Cero END),
                       Decimal_Cero) AS ComFalPago,

        IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND
                               Mov.TipoMovCreID = Tip_CapVigente AND
                               Mov.Descripcion = Ref_PagoCredito THEN Mov.Cantidad
                           ELSE Decimal_Cero END),
                       Decimal_Cero) AS PagoCapVigente,

          IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND
                               Mov.TipoMovCreID = Tip_CapAtrasado AND
                               Mov.Descripcion = Ref_PagoCredito THEN Mov.Cantidad
                           ELSE Decimal_Cero END),
                       Decimal_Cero) AS PagoCapAtraso,

          IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND
                               Mov.TipoMovCreID = Tip_CapVencido AND
                               Mov.Descripcion = Ref_PagoCredito THEN Mov.Cantidad
                           ELSE Decimal_Cero END),
                       Decimal_Cero) AS PagoCapVencido,

          IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND
                               Mov.TipoMovCreID = Tip_CapVenNoExi AND
                               Mov.Descripcion = Ref_PagoCredito THEN Mov.Cantidad
                           ELSE Decimal_Cero END),
                       Decimal_Cero) AS PagoCapVencidoNE,

          IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND
                               Mov.TipoMovCreID = Tip_IntProvision AND
                               Mov.Descripcion = Ref_PagoCredito THEN Mov.Cantidad
                           ELSE Decimal_Cero END),
                       Decimal_Cero) AS PagoIntProvisionado,

          IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND
                               Mov.TipoMovCreID = Tip_IntVencido AND
                               Mov.Descripcion = Ref_PagoCredito THEN Mov.Cantidad
                           ELSE Decimal_Cero END),
                       Decimal_Cero) AS PagoIntVencido,

          IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND
                               Mov.TipoMovCreID = Tip_IntAtrasado AND
                               Mov.Descripcion = Ref_PagoCredito THEN Mov.Cantidad
                           ELSE Decimal_Cero END),
                       Decimal_Cero) AS PagoIntAtraso,

          IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND
                               Mov.TipoMovCreID = Tip_IntNoConta AND
                               Mov.Descripcion = Ref_PagoCredito THEN Mov.Cantidad
                           ELSE Decimal_Cero END),
                       Decimal_Cero) AS PagoIntNoConta,

          IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND
                               Mov.TipoMovCreID = Tip_ComFalPago AND
                               Mov.Descripcion = Ref_PagoCredito THEN Mov.Cantidad
                           ELSE Decimal_Cero END),
                       Decimal_Cero) AS PagoComisi,

          IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND
                               Mov.TipoMovCreID = Tip_IntMorato AND
                               Mov.Descripcion = Ref_PagoCredito THEN Mov.Cantidad
                           ELSE Decimal_Cero END),
                       Decimal_Cero) AS PagoMorato,

          IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND
                               Mov.TipoMovCreID = Tip_IVAIntOrd AND
                               Mov.Descripcion = Ref_PagoCredito THEN Mov.Cantidad
                           ELSE Decimal_Cero END) +

                 SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND
                               Mov.TipoMovCreID = Tip_IVAMorato AND
                               Mov.Descripcion = Ref_PagoCredito THEN Mov.Cantidad
                           ELSE Decimal_Cero END) +

                SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND
                               Mov.TipoMovCreID = Tip_IVAFalPag AND
                               Mov.Descripcion = Ref_PagoCredito THEN Mov.Cantidad
                           ELSE Decimal_Cero END),

                       Decimal_Cero) AS PagoIVAS,

         IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND
                              Mov.Descripcion = Ref_Condonacion AND
                              (Mov.TipoMovCreID = Tip_IntProvision OR
                               Mov.TipoMovCreID = Tip_IntVencido OR
                               Mov.TipoMovCreID = Tip_IntAtrasado OR
                               Mov.TipoMovCreID = Tip_IntNoConta) THEN Mov.Cantidad
                           ELSE Decimal_Cero END),
                       Decimal_Cero) AS CondIntere,

         IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND
                               Mov.TipoMovCreID = Tip_IntMorato AND
                               Mov.Descripcion = Ref_Condonacion THEN Mov.Cantidad
                           ELSE Decimal_Cero END),
                       Decimal_Cero) AS CondMorato,

        (SELECT (CASE WHEN IFNULL(min(FechaExigible), Fecha_Vacia) = Fecha_Vacia THEN 0
                           ELSE ( datediff(Par_Fecha,min(FechaExigible)) + 1)  END)
            FROM AMORTICREDITO Amo
            WHERE Amo.CreditoID = Cre.CreditoID
              AND Amo.Estatus != Estatus_Pagado
              AND Amo.FechaExigible <= Par_Fecha),

        (SELECT  IFNULL(count(CreditoID), 0)
            FROM AMORTICREDITO Amo
            WHERE Amo.CreditoID = Cre.CreditoID
              AND Amo.Estatus != Estatus_Pagado
              AND Amo.FechaExigible <= Par_Fecha),

        (SELECT IFNULL(MAX(DATEDIFF(Case WHEN (IFNULL(Amo.FechaLiquida,Fecha_Vacia) = Fecha_Vacia) THEN Par_Fecha
                                    ELSE Amo.FechaLiquida
                                    END, Amo.FechaExigible))+1, 0)
            FROM AMORTICREDITO Amo
            WHERE Amo.CreditoID = Cre.CreditoID
              AND FechaExigible <= Par_Fecha
              AND FechaExigible >= Var_FecAnioAnt),


        Cre.LineaCreditoID,     Cre.ClienteID,      Cre.MonedaID,           Cre.FechaInicio,
        Cre.FechaVencimien,      Fecha_Vacia,
        CASE WHEN  Cre.Estatus IN(Estatus_Pagado,Estatus_Castigado) THEN Cre.FechTerminacion
        ELSE Fecha_Vacia END,    Cre.ProductoCreditoID,
		Cre.SolicitudCreditoID,             Cre.TipoCredito,                        Cre.PlazoID,                           	IFNULL(Cre.TasaFija, Entero_Cero),
		IFNULL(Cre.TasaBase, Entero_Cero),  IFNULL(Cre.SobreTasa, Entero_Cero),     IFNULL(Cre.PisoTasa, Entero_Cero),     	IFNULL(Cre.TechoTasa, Entero_Cero),
		CASE WHEN Cre.TipoCredito = Tip_Nueva       THEN Tipo_Normal
			 WHEN Cre.TipoCredito = Tip_Renovacion  THEN Tipo_Renovacion
			 WHEN Cre.TipoCredito = Tip_Restructura THEN Tipo_Restructurada END,
		Cre.TipCobComMorato,        IFNULL(Cre.FactorMora, Entero_Cero),    		Cadena_Vacia,		FNCREDITOPRENDARIO(Cre.CreditoID),
		CASE WHEN AporteCliente = Decimal_Cero AND PorcGarLiq = Decimal_Cero THEN Con_NO
			 ELSE Con_SI END, 	Entero_Cero,
		FNFECHAPROXPAGO(Cre.CreditoID),
		IFNULL(FNEXIGIBLEPROXPAG(Cre.CreditoID),Decimal_Cero),
        Cre.Estatus,            Decimal_Cero,       Cre.MontoCredito,       Cre.FrecuenciaCap,
        Cre.PeriodicidadCap,    Cre.FrecuenciaInt,  Cre.PeriodicidadInt,    Cre.NumAmortizacion,
        Cre.FechTraspasVenc,    Cre.FechaAutoriza,  Cre.ClasifRegID,        Cre.DestinoCreID,
        Cadena_Vacia,           Decimal_Cero,       Cre.TipoFondeo,         Cre.InstitFondeoID,

        IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Cargo AND
                               Mov.TipoMovCreID = Tip_IntNoConta AND
                               Mov.Referencia = Ref_DevInteres THEN Mov.Cantidad
                           ELSE Decimal_Cero END), Decimal_Cero) AS IntDevCtaOrden,

         IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND
                              Mov.Descripcion = Ref_Condonacion AND
                              (Mov.TipoMovCreID = Tip_CapVigente OR
                               Mov.TipoMovCreID = Tip_CapAtrasado OR
                               Mov.TipoMovCreID = Tip_CapVencido OR
                               Mov.TipoMovCreID = Tip_CapVenNoExi) THEN Mov.Cantidad
                           ELSE Decimal_Cero END),
                       Decimal_Cero) AS CondCapita,

        IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND
                             Mov.TipoMovCreID = Tip_ComAdmon AND
                             Mov.Descripcion = Ref_PagoCredito THEN Mov.Cantidad
                        ELSE Decimal_Cero END),
                        Decimal_Cero) AS PagoComAdmon,

        IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND
                               Mov.TipoMovCreID = Tip_ComFalPago AND
                               Mov.Descripcion = Ref_Condonacion THEN Mov.Cantidad
                           ELSE Decimal_Cero END),
                       Decimal_Cero) AS CondComisi,

  IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Cargo AND
                               Mov.TipoMovCreID = Tip_CapVigente AND
                               Mov.Descripcion = Ref_Desembolso  THEN Mov.Cantidad
                           ELSE Decimal_Cero END),
                       Decimal_Cero) AS Desembolso,
        (SELECT  IFNULL(SUM(SaldoCapVigente), 0)
            FROM AMORTICREDITO Amo
            WHERE Amo.CreditoID = Cre.CreditoID
              AND Amo.Estatus != Estatus_Pagado
              AND Amo.FechaExigible <= Par_Fecha) AS CapVigenteExi,
          FUNCIONDEUCRENOIVA(Cre.CreditoID) AS MontoTotalExi,


            /*
          ACCESORIOS
          Se separan los importes correspondientes a los accesoriosy su correspondientes IVA
          */
          IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND
                               Mov.TipoMovCreID = Mov_OtrasComisiones AND
                               Mov.Descripcion = Ref_PagoCredito  THEN Mov.Cantidad
                           ELSE Decimal_Cero END),
                       Decimal_Cero) AS SalMontoAccesorio,

          IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND
                               Mov.TipoMovCreID = Mov_IVAOtrasComisiones AND
                               Mov.Descripcion = Ref_PagoCredito  THEN Mov.Cantidad
                           ELSE Decimal_Cero END),
                       Decimal_Cero) AS SalIVAAccesorio,

            /*TERMINA ACCESORIOS */

          -- INICIO INTERES ACCESORIOS

          IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND
                               Mov.TipoMovCreID = Var_TipoMovIntAcc AND
                               Mov.Descripcion = Ref_PagoCredito  THEN Mov.Cantidad
                           ELSE Decimal_Cero END),
                       Decimal_Cero) AS SalIntAccesorio,

          IFNULL(SUM(CASE WHEN Mov.NatMovimiento = Nat_Abono AND
                               Mov.TipoMovCreID = Var_TipoMovIvaIntAc AND
                               Mov.Descripcion = Ref_PagoCredito  THEN Mov.Cantidad
                           ELSE Decimal_Cero END),
                       Decimal_Cero) AS SalIVAIntAccesorio,

        -- FIN INTERES ACCESORIOS
        MAX(Cre.SaldoComServGar),   MAX(Cre.SaldoIVAComSerGar),
		Entero_Cero AS SaldoParaFiniq,
		Entero_Cero AS CuotasPagadas,
		Cre.ValorCAT AS ValorCAT,
		Entero_Cero AS CapitalProxPago,
		Entero_Cero AS InteresProxPago,
		Entero_Cero AS IvaProxPago,
		Entero_Cero AS SalInteresExigible,
		Entero_Cero AS IVAInteresExigible,
		Entero_Cero AS PagoIntOrdMes,
		Entero_Cero AS PagoIVAIntOrdMes,
		Entero_Cero AS PagoMoraMes,
		Entero_Cero AS PagoIVAMoraMes,
		Entero_Cero AS PagoComisiMes,
		Entero_cero AS PagoIVAComisiMes,
		Entero_Cero AS OtrosCargosApagar,
		Entero_Cero AS IVAOtrosCargosApagar,
		-- FIN INTERES ACCESORIOS
        Par_EmpresaID,          Aud_Usuario,        Aud_FechaActual,        Aud_DireccionIP,
        Aud_ProgramaID,         Aud_Sucursal,       Aud_NumTransaccion


    FROM CREDITOS Cre
     LEFT OUTER JOIN CREDITOSMOVS AS Mov ON   (Cre.CreditoID      =  Mov.CreditoID
                    AND   Mov.FechaOperacion  = Par_Fecha)

    WHERE (Estatus = Estatus_Suspendido OR Estatus = Estatus_Vigente
       OR   Estatus = Estatus_Vencido
       OR (   Estatus = Estatus_Castigado
       AND    FechTerminacion = Par_Fecha )
       OR   ( Estatus = Estatus_Pagado
       AND    FechTerminacion = Par_Fecha ))
    GROUP BY Cre.CreditoID;


	-- Se actualiza los montos de pagos realizados durante el Mes.
	UPDATE TMP_SALDOSCREDITOS_CIERRE Sal
		INNER JOIN TMP_PAGOSCREDITOSMOVS Mov ON Sal.CreditoID = Mov.CreditoID
	SET Sal.PagoIntOrdMes 		= Mov.IntOrd + Mov.IntAtra + Mov.IntVen + Mov.IntDevNoConta + Mov.IntProvision,
		Sal.PagoIVAIntOrdMes	= IVAInteres,
		Sal.PagoMoraMes	= Mov.IntMora + Mov.IntMoraVen + Mov.IntMoraCarVen,
		Sal.PagoIVAMoraMes	= Mov.IVAMora,
		Sal.PagoComisiMes 		= Mov.ComFalPago + Mov.ComApeCred + Mov.ComAdmon + Mov.ComAnual ,
		Sal.PagoIVAComisiMes 	= Mov.IVAComFalPago + Mov.IVAComApeCre + Mov.IVAComAdmon + Mov.IVAComAnual;


	-- Se actualiza los monto de Saldo para Finiquitar.
	UPDATE TMP_SALDOSCREDITOS_CIERRE
	SET SaldoParaFiniq	= FUNCIONCONFINIQCRE(CreditoID) ;

	-- Se Actualiza el monto de total exigible sin considerar el IVA
	UPDATE TMP_SALDOSCREDITOS_CIERRE
	SET MontoTotalExi	= FUNCIONDEUCRENOIVA(CreditoID);

	-- Se actualiza Saldos y columnas obtenidas de la tabla de amortizaciones
	UPDATE TMP_SALDOSCREDITOS_CIERRE Sal
		INNER JOIN TMP_EDOCTA_AMORTICREDITO Amo ON Sal.CreditoID = Amo.CreditoID
	SET Sal.SaldoComisionAnual 		= Amo.SaldoComisionAnual,
		Sal.SaldoSeguroCuota 		= Amo.SaldoSeguroCuota,
		Sal.SaldoComisionAnualIVA 	= Amo.SaldoComisionAnualIVA,
		Sal.SaldoIVASeguroCuota		= Amo.SaldoIVASeguroCuota,
		Sal.CuotasPagadas 			= Amo.CuotasPagadas,
		Sal.CapitalProxPago			= Amo.CapitalProxPago,
		Sal.InteresProxPago 		= Amo.InteresProxPago,
		Sal.IvaProxPago				= Amo.IvaProxPago,
		Sal.SalInteresExigible 		= Amo.SalInteresExigible,
		Sal.OtrosCargosApagar 		= Amo.OtrosCargosApagar,
		Sal.IVAInteresExigible 		=  Amo.IVAInteresExigible,
        Sal.IVAOtrosCargosApagar 	=  Amo.IVAOtrosCargosApagar;
    DROP TABLE IF EXISTS TMTPFECHAEXIGIBLE;
    CREATE TEMPORARY TABLE TMTPFECHAEXIGIBLE
        SELECT Sal.CreditoID, min(Amo.FechaExigible) FechaExigible FROM
         TMP_SALDOSCREDITOS_CIERRE Sal
           LEFT OUTER JOIN AMORTICREDITO AS Amo
           ON Sal.CreditoID = Amo.CreditoID AND Sal.FechaCorte = Par_Fecha
           WHERE Amo.Estatus != Estatus_Pagado
           AND Amo.FechaExigible <= Par_Fecha
           GROUP BY Amo.CreditoID,  Sal.CreditoID;

	ALTER TABLE TMTPFECHAEXIGIBLE
		ADD COLUMN RegistroID bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY FIRST;

    UPDATE TMP_SALDOSCREDITOS_CIERRE Sal,TMTPFECHAEXIGIBLE Tem SET
      Sal.FechaExigible = IFNULL(Tem.FechaExigible,Fecha_Vacia)
      WHERE Sal.CreditoID = Tem.CreditoID
      AND Sal.FechaCorte = Par_Fecha;



TRUNCATE TABLE TMPCREDITOSMOVS;

INSERT INTO TMPCREDITOSMOVS (
                        Transaccion,                      CreditoID,                        Fecha,                        SaldoDia)
    SELECT  Aud_NumTransaccion,
            Mov.CreditoID, Mov.FechaOperacion,
            (   SUM(LOCATE(Nat_Cargo, Mov.NatMovimiento) * Mov.Cantidad ) -
                             SUM(LOCATE(Nat_Abono, Mov.NatMovimiento) * Mov.Cantidad ) ) *
                            (DATEDIFF(Var_FinMes, Mov.FechaOperacion) + 1)

    FROM CREDITOSMOVS Mov,
         TMP_SALDOSCREDITOS_CIERRE Sal
    WHERE  Sal.FechaCorte = Par_Fecha
      AND Sal.CreditoID = Mov.CreditoID
      AND FechaOperacion  >= Var_InicioMes
      AND FechaOperacion  <= Par_Fecha
      AND ( Mov.TipoMovCreID = Tip_CapVigente
       OR   Mov.TipoMovCreID = Tip_CapAtrasado
       OR   Mov.TipoMovCreID = Tip_CapVencido
       OR   Mov.TipoMovCreID = Tip_CapVenNoExi   )
    GROUP BY CreditoID, FechaOperacion;


INSERT INTO TMPCREDITOSMOVS (
                        Transaccion,                      CreditoID,                        Fecha,                        SaldoDia)
    SELECT  Aud_NumTransaccion,
            Cre.CreditoID, Var_InicioMes,
            (   IFNULL(SalCapVigente, Decimal_Cero) +
                IFNULL(SalCapAtrasado, Decimal_Cero) +
                IFNULL(SalCapVencido, Decimal_Cero) +
                IFNULL(SalCapVenNoExi, Decimal_Cero)    ) * Var_DiasMes
    FROM  TMP_SALDOSCREDITOS_CIERRE Cre
    WHERE Cre.FechaCorte  = Var_CorteMesAnt;


UPDATE TMP_SALDOSCREDITOS_CIERRE Sal SET
    SaldoPromedio = ( SELECT (IFNULL(SUM(SaldoDia),Decimal_Cero) / Var_DiasMes)
                             AS SaldoProm
                        FROM TMPCREDITOSMOVS Mov
                        WHERE Sal.CreditoID = Mov.CreditoID)
    WHERE Sal.FechaCorte  = Par_Fecha;

  -- Se actualizan los días de atraso para los creditos consolidados agro
  UPDATE SALDOSCREDITOS Sal
  INNER JOIN REGCRECONSOLIDADOS Ree ON Sal.CreditoID = Ree.CreditoID SET
    Sal.DiasAtraso = CASE WHEN Par_Fecha > Ree.FechaLimiteReporte
                               THEN DATEDIFF(Sal.FechaCorte, Ree.FechaRegistro ) + IFNULL(Ree.NumDiasAtraso, Entero_Cero)
                          ELSE IFNULL(Ree.NumDiasAtraso, Entero_Cero)
                     END
  WHERE Sal.FechaCorte = Par_Fecha
    AND Ree.Regularizado = Con_NO;

IF Var_ClienteEsp = Clien_Crediclub  THEN


	UPDATE TMP_SALDOSCREDITOS_CIERRE Sal,CREDITOSDIFERIDOS Tem
		SET Sal.DiasAtraso = IFNULL(Tem.DiasDiferidos,0)
	WHERE Sal.CreditoID = Tem.CreditoID
      AND Tem.FechaFinPeriodo >= Par_Fecha
      AND Sal.FechaCorte  = Par_Fecha;

    DROP TABLE IF EXISTS TMPMAXDIFER;
    CREATE TEMPORARY TABLE TMPMAXDIFER(
      CreditoID         BIGINT(12) PRIMARY KEY,
      NumeroDiferimientos   INT(11)
    );

    INSERT INTO TMPMAXDIFER
    SELECT Cre.CreditoID , MAX(Dif.NumeroDiferimientos)
    FROM CREDITOSDIFERIDOS Dif,
       CREDITOS Cre
    WHERE Dif.CreditoID = Cre.CreditoID
      AND Cre.Estatus IN ('V','B')
    GROUP BY Dif.CreditoID;


    DROP TABLE IF EXISTS TMPDIASCREDDIFER;
	CREATE TEMPORARY TABLE TMPDIASCREDDIFER(
		CreditoID   BIGINT(12) PRIMARY KEY,
		DiasAtraso  INT(11));

    INSERT INTO TMPDIASCREDDIFER
    SELECT
   	 	dif.CreditoID,
    	(datediff(Par_Fecha,MIN(dif.FechaFinPeriodo))+MIN(dif.DiasDiferidos)) as DiasDiferNew
    FROM
    CREDITOSDIFERIDOS dif,AMORTICREDITO amo, TMPMAXDIFER M
    WHERE dif.CreditoID = amo.CreditoID
      AND dif.FechaFinPeriodo > amo.FechaExigible
      AND amo.Estatus IN ('A','B')
      AND dif.FechaFinPeriodo < Par_Fecha
      AND dif.CreditoID = M.CreditoID
      AND dif.NumeroDiferimientos = M.NumeroDiferimientos
    GROUP BY dif.CreditoID;

	UPDATE TMP_SALDOSCREDITOS_CIERRE Sal,TMPDIASCREDDIFER Tem SET
		Sal.DiasAtraso =  IFNULL(Tem.DiasAtraso,0)
	WHERE Sal.CreditoID = Tem.CreditoID
	  AND Sal.FechaCorte  = Par_Fecha;

ELSE

    DROP TABLE IF EXISTS TMPDIASCREDDIFER;
	CREATE TEMPORARY TABLE TMPDIASCREDDIFER(
	CreditoID 	BIGINT(12) PRIMARY KEY,
	DiasAtraso  INT(11)
	);

	INSERT INTO TMPDIASCREDDIFER
	SELECT Dif.CreditoID,MAX(Dif.DiasAtraso)
		FROM AMORTICREDITODIFER Dif,AMORTICREDITO Amo
		WHERE Dif.AmortizacionID = Amo.AmortizacionID
		  AND Dif.CreditoID = Amo.CreditoID
		  AND Amo.Estatus IN (Estatus_Vigente,Estatus_Atrasado,Estatus_Vencido)
      AND Dif.NumeroDiferimientos = 1
		GROUP BY Dif.CreditoID;

	UPDATE  TMP_SALDOSCREDITOS_CIERRE Sal,TMPDIASCREDDIFER Tem SET
		Sal.DiasAtraso = Sal.DiasAtraso + IFNULL(Tem.DiasAtraso,0)
	WHERE Sal.CreditoID = Tem.CreditoID
	AND Sal.FechaCorte  = Par_Fecha;

END IF;

-- ACTUALIZAMOS EL IVA DE ACCESORIOS
UPDATE TMP_SALDOSCREDITOS_CIERRE SAL
INNER JOIN TMP_CALCULOIVAACCESORIOS TMP ON SAL.CreditoID = TMP.CreditoID
    SET SAL.SalIVAComisi = TMP.SalIVAAccesorio
WHERE SAL.FechaCorte=Par_Fecha
AND TMP.SalIVAAccesorio > 0;

TRUNCATE TABLE TMPCREDITOSMOVS;
DROP TABLE IF EXISTS TMTPFECHAEXIGIBLE;



INSERT INTO SALDOSCREDITOS (CreditoID,              FechaCorte,         SalCapVigente,          SalCapAtrasado,         SalCapVencido
                            ,SalCapVenNoExi,        SalIntOrdinario,    SalIntAtrasado,         SalIntVencido,          SalIntProvision
                            ,SalIntNoConta,         SalMoratorios,      SaldoMoraVencido,       SaldoMoraCarVen,        SalComFaltaPago
                            ,SalOtrasComisi,        SalIVAInteres,      SalIVAMoratorios,       SalIVAComFalPago,       SalIVAComisi
                            ,PasoCapAtraDia,        PasoCapVenDia,      PasoCapVNEDia,          PasoIntAtraDia,         PasoIntVenDia
                            ,CapRegularizado,       IntOrdDevengado,    IntMorDevengado,        ComisiDevengado,        PagoCapVigDia
                            ,PagoCapAtrDia,         PagoCapVenDia,      PagoCapVenNexDia,       PagoIntOrdDia,          PagoIntVenDia,
                            PagoIntAtrDia,          PagoIntCalNoCon,    PagoComisiDia,          PagoMoratorios,         PagoIvaDia
                            ,IntCondonadoDia,       MorCondonadoDia,    DiasAtraso,             NoCuotasAtraso,         MaximoDiasAtraso
                            ,LineaCreditoID,        ClienteID,          MonedaID,               FechaInicio,            FechaVencimiento
                            ,FechaExigible,         FechaLiquida,       ProductoCreditoID,      `SolicitudCreditoID`,	`TipoCredito`,		
                            `PlazoID`,				`TasaFija`,			`TasaBase`,				`SobreTasa`,			`PisoTasa`,			
                            `TechoTasa`,			`TipoCartera`,		`TipCobComMorato`,		`FactorMora`,			`CreditoOrigen`,	
                            `ConGarPrenda`,			`ConGarLiq`,		`TotalParticipantes`,	`FechaProximoPago`,		`MontoProximoPago`,		
                            EstatusCredito,         SaldoPromedio
                            ,MontoCredito,          FrecuenciaCap,      PeriodicidadCap,        FrecuenciaInt,          PeriodicidadInt
                            ,NumAmortizacion,       FechTraspasVenc,    FechAutoriza,           ClasifRegID,            DestinoCreID
                            ,Calificacion,          PorcReserva,        TipoFondeo,             InstitFondeoID,         IntDevCtaOrden
                            ,CapCondonadoDia,       ComAdmonPagDia,     ComCondonadoDia,        DesembolsosDia,         CapVigenteExi
                            ,MontoTotalExi,         SalMontoAccesorio,  SalIVAAccesorio,        SalIntAccesorio,		SalIVAIntAccesorio
                            ,SaldoComServGar,       SaldoIVAComSerGar,
                            `SaldoParaFiniq`,		`CuotasPagadas`,			`ValorCAT`,				`CapitalProxPago`,		`InteresProxPago`,		
							`IvaProxPago`,			`SalInteresExigible`,		`IVAInteresExigible`,	`PagoIntOrdMes`,		`PagoIVAIntOrdMes`,		
							`PagoMoraMes`,			`PagoIVAMoraMes`,			`PagoComisiMes`,		`PagoIVAComisiMes`,		`OtrosCargosApagar`,		
							`IVAOtrosCargosApagar`
                            ,EmpresaID,				Usuario,			FechaActual,        	DireccionIP,        	ProgramaID
                            ,Sucursal,				NumTransaccion)
					SELECT  CreditoID,              FechaCorte,         SalCapVigente,          SalCapAtrasado,         SalCapVencido
							,SalCapVenNoExi,        SalIntOrdinario,    SalIntAtrasado,         SalIntVencido,          SalIntProvision
							,SalIntNoConta,         SalMoratorios,      SaldoMoraVencido,       SaldoMoraCarVen,        SalComFaltaPago
							,SalOtrasComisi,        SalIVAInteres,      SalIVAMoratorios,       SalIVAComFalPago,       SalIVAComisi
							,PasoCapAtraDia,        PasoCapVenDia,      PasoCapVNEDia,          PasoIntAtraDia,         PasoIntVenDia
							,CapRegularizado,       IntOrdDevengado,    IntMorDevengado,        ComisiDevengado,        PagoCapVigDia
							,PagoCapAtrDia,         PagoCapVenDia,      PagoCapVenNexDia,       PagoIntOrdDia,          PagoIntVenDia,
							PagoIntAtrDia,          PagoIntCalNoCon,    PagoComisiDia,          PagoMoratorios,         PagoIvaDia
							,IntCondonadoDia,       MorCondonadoDia,    DiasAtraso,             NoCuotasAtraso,         MaximoDiasAtraso
							,LineaCreditoID,        ClienteID,          MonedaID,               FechaInicio,            FechaVencimiento
							,FechaExigible,         FechaLiquida,       ProductoCreditoID,      `SolicitudCreditoID`,	`TipoCredito`,		
                            `PlazoID`,				`TasaFija`,			`TasaBase`,				`SobreTasa`,			`PisoTasa`,			
                            `TechoTasa`,			`TipoCartera`,		`TipCobComMorato`,		`FactorMora`,			`CreditoOrigen`,	
                            `ConGarPrenda`,			`ConGarLiq`,		`TotalParticipantes`,	`FechaProximoPago`,		`MontoProximoPago`,		
                            EstatusCredito,         SaldoPromedio      
							,MontoCredito,          FrecuenciaCap,      PeriodicidadCap,        FrecuenciaInt,          PeriodicidadInt
							,NumAmortizacion,       FechTraspasVenc,    FechAutoriza,           ClasifRegID,            DestinoCreID
							,Calificacion,          PorcReserva,        TipoFondeo,             InstitFondeoID,         IntDevCtaOrden
							,CapCondonadoDia,       ComAdmonPagDia,     ComCondonadoDia,        DesembolsosDia,         CapVigenteExi
							,MontoTotalExi,         SalMontoAccesorio,  SalIVAAccesorio,        SalIntAccesorio,		SalIVAIntAccesorio
							,SaldoComServGar,       SaldoIVAComSerGar,
                            `SaldoParaFiniq`,		`CuotasPagadas`,			`ValorCAT`,				`CapitalProxPago`,		`InteresProxPago`,		
							`IvaProxPago`,			`SalInteresExigible`,		`IVAInteresExigible`,	`PagoIntOrdMes`,		`PagoIVAIntOrdMes`,		
							`PagoMoraMes`,			`PagoIVAMoraMes`,			`PagoComisiMes`,		`PagoIVAComisiMes`,		`OtrosCargosApagar`,		
							`IVAOtrosCargosApagar`
							,EmpresaID,             Usuario,			FechaActual,            DireccionIP,        	ProgramaID
							,Sucursal,              NumTransaccion
FROM TMP_SALDOSCREDITOS_CIERRE;

DROP TABLE IF EXISTS TMP_SALDOSCREDITOS_CIERRE;

-- ELIMINAMOS LA TABLA PARA EL CALCULO DEL IVA DE ACCESORIOS
DROP TABLE IF EXISTS TMP_CALCULOIVAACCESORIOS;

CALL CALIFICACREDITOPRO(
  Par_Fecha,    Par_EmpresaID,  Aud_Usuario,      Aud_FechaActual,  Aud_DireccionIP,
  Aud_ProgramaID, Aud_Sucursal, Aud_NumTransaccion);

CALL ELIMINARESCREDPRO(
  Par_Fecha,  Par_EmpresaID,    Aud_Usuario,    Aud_FechaActual,  Aud_DireccionIP,
  Aud_ProgramaID, Aud_Sucursal, Aud_NumTransaccion);

CALL DIASFESTIVOSCAL(
    Par_Fecha,      1,                  Sig_DiaHab,         Var_EsHabil,    Par_EmpresaID,
    Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
    Aud_NumTransaccion);


END TerminaStore$$

