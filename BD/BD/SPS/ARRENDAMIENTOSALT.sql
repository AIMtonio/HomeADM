-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARRENDAMIENTOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ARRENDAMIENTOSALT`;DELIMITER $$

CREATE PROCEDURE `ARRENDAMIENTOSALT`(
	-- STORED PROCEDURE PARA EL ALTA DE ARRENDAMIENTO
	Par_LineaArrendaID			BIGINT(12),		-- 'Numero ID de la linea de Arrendamiento solo en caso de existir',
	Par_ClienteID				INT(11),      	-- 'Numero de Cliente al que se le da de alta el arrendamiento',
	Par_TipoArrenda				CHAR(1),      	-- 'F = Financiero  P = Puro',
	Par_MonedaID				INT(11),      	-- 'Id de la moneda del Arrendamiento 01 = Pesos Mexicano',
	Par_ProductoArrendaID		INT(4),       	-- 'ID del Producto de Arrendamiento',

	Par_MontoArrenda			DECIMAL(14,2),	-- 'Es el monto del Arrendamiento antes de Enganche o anticipo y sin IVA',
	Par_PorcEnganche			DECIMAL(5,2), 	-- 'Valor porcentual que representa el monto del enganche respecto al valor del Bien
	Par_SeguroArrendaID			INT(11),      	-- 'Numero de ID de la aseguradora',
	Par_TipoPagoSeguro			INT(11),      	-- '1 = Contado   2 = Financiado',
	Par_MontoSeguroAnual		DECIMAL(14,2),	-- 'Es el monto del seguro Anual de contado',

	Par_SeguroVidaArrendaID		INT(11),      	-- 'Numero de ID de la aseguradora',
	Par_TipoPagoSeguroVida		INT(11),      	-- ' 1 = Contado  2 = Financiado',
	Par_MontoSeguroVidaAnual	DECIMAL(14,2),	-- 'Es el monto del seguro de Vida Anual de contado',
	Par_MontoResidual			DECIMAL(14,2),	-- 'Es el valor residual en caso que aplique',
	Par_FechaApertura			DATE,         	-- 'Fecha en la que se inicia el Arrendamiento',

	Par_FechaPrimerVen			DATE,         	-- 'Fecha del Primer Pago del Arrendamiento',
	Par_FechaUltimoVen			DATE,         	-- 'Fecha del ultimo Pago del Arrendamiento',
	Par_Plazo 					INT(11),      	-- 'Numero correspondiente al plazo Ejemplo:   36, 48, 60',
	Par_FrecuenciaPlazo			CHAR(1),      	-- 'Frecuencia en la cual esta expresado el plazo M.- Mensual',
	Par_TasaFijaAnual			DECIMAL(5,2), 	-- 'Valor porcentual anual para la tasa de interes',

	Par_MontoRenta				DECIMAL(14,2), 	-- 'monto calculado del valor de la renta antes de IVA con la formula de Pago de Excel',
	Par_MontoSeguro				DECIMAL(14,2), 	-- 'monto calculado del valor del seguro con la formula de Pago de Excel',
	Par_MontoSeguroVida			DECIMAL(14,2), 	-- 'monto calculado del valor del seguro de vida con la formula de Pago de Excel',
	Par_CantRentaDepo			INT(11),       	-- 'Cantidad de Rentas en Deposito',
	Par_MontoDeposito			DECIMAL(14,2), 	-- 'Monto total del Deposito',

	Par_MontoComApe				DECIMAL(14,2), 	-- 'Comision por Apertura',
	Par_OtroGastos				DECIMAL(14,2), 	-- 'Son otros gastos o Pagos que se pueden considerar como: Pueden ser Placas y Tenencia,
	Par_TipCobComMorato			CHAR(1),       	-- 'Tipo de Comision del Moratorio  N .- N Veces la Tasa Ordinaria  T .- Tasa Fija Anualizada',
	Par_FactorMora				DECIMAL(14,2), 	-- 'Es el porcentaje o la cantidad de N veces el valor de la tasa ordinaria',
	Par_CantCuota				INT(11),       	-- 'Cantidad de Cuotas o amortizaciones que tiene el plan de pagos del Arrendamiento',

	Par_MontoCuota				DECIMAL(14,2),	-- 'Valor final de cada cuota que el cliente debera pagar ',
	Par_SucursalID				INT(11),      	-- 'Sucursal donde se dio de alta el Arrendamiento',
	Par_DiaPagoProd				CHAR(1),      	-- 'Dias de Pago:  F = Fin de mes  A = Aniversario',
	Par_FechaInhabil			CHAR(1),      	-- 'Calculo de Fecha para cuando el vencimiento cae en dia Inhabil:  S.- Siguiente dia habil
	Par_TipoPrepago				CHAR(1),      	-- 'Tipo de prepago a aplicar U = Pago a ultimas cuotas I   = A las cuotas siguientes inmediatas',

	Par_NumTransacSim			BIGINT(20),    	-- NUMERO DE TRANSACCION DEL SIMULADOR
	Par_EsRentaAnticipada		CHAR(1),		-- Define si se anticipa la primera renta
	Par_CantRenAdelantadas		INT(11),		-- Define la cantidad de cuotas a adelantar
	Par_TipoRenAdelantadas		CHAR(1),		-- Define si se adelantan las primeras o las ultimas cuotas
	Par_RentaAnticipada			DECIMAL(14,2),	-- Monto a pagar de la cuota a anticipar
	Par_IVARentaAnticipada		DECIMAL(14,2),	-- IVA a pagar de la cuota a anticipar
	Par_CuotasAdelantadas		DECIMAL(14,2),	-- Monto a pagar de las cuotas a adelantar
	Par_IVACuotasAdelan			DECIMAL(14,2),	-- IVA a pagar de la cuotas a adelantar

	Par_Salida					CHAR(1),       	-- Salida Si o No
	INOUT Par_NumErr			INT(11),       	-- Control de Errores: Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),  	-- Control de Errores: Descripcion del Error
	Aud_EmpresaID				INT(11),       	-- Parametro de Auditoria

	Aud_Usuario					INT(11),       	-- Parametro de Auditoria
	Aud_FechaActual				DATETIME,      	-- Parametro de Auditoria
	Aud_DireccionIP				VARCHAR(15),   	-- Parametro de Auditoria
	Aud_ProgramaID				VARCHAR(50),	-- Parametro de Auditoria
	Aud_Sucursal				INT(11),       	-- Parametro de Auditoria

	Aud_NumTransaccion			BIGINT(20)     	-- Parametro de Auditoria
)
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
	DECLARE Var_Control				VARCHAR(100);      	-- Variable de control
	DECLARE Var_CtePagIva			CHAR(1);           	-- VARIABLE PARA  GUARDAR SU EL CLIENTE PAGA O NO IVA
	DECLARE Var_FechaSistema		DATETIME;          	-- FECHA DEL SISTEMA
	DECLARE Var_IVA					DECIMAL(14,2);     	-- VARIABLE PARA OBTENER EL VALOR DEL IVA

	DECLARE Var_IVAMontoArrenda		DECIMAL(14,2);     	-- 'Es el IVA del monto correspondiente al valor del Bien',
	DECLARE Var_IVAEnganche			DECIMAL(14,2);     	-- 'IVA del Enganche en caso de que aplique',
	DECLARE Var_MontoFinanciado		DECIMAL(14,2);     	-- 'Es el Valor a Financiar para el arrendamiento Reprsenta el Valor del Bien menos el Enganche',
	DECLARE Var_IVADeposito			DECIMAL(14,2);     	-- 'IVA del monto en Deposito',
	DECLARE Var_IVAComApe			DECIMAL(14,2);     	-- 'Monto Comision por Apertura',
	DECLARE Var_IVAOtrosGastos		DECIMAL(14,2);     	-- 'En caso de aplique IVA para Otros Pagos',
	DECLARE Var_MontoEnganche		DECIMAL(14,2);     	-- VALOR DE ENGANCGE
	DECLARE Var_TotalPagoInicial	DECIMAL(14,2);     	-- 'Monto total a pagar, como pago inical, el cual incluye  el enganche, las comisiones por     apertura, el deposito, oytros gastos  y los seguros en caso de ser de contado',

	DECLARE Var_AnualMes			INT(11);           	-- ANUAL MES
	DECLARE Var_SeguroArrendaID		INT(11);           	-- sEGURO ID
	DECLARE Var_SeguroVidaArrendaID	INT(11);           	-- sEGURO VIDA ID
	DECLARE Var_TasaMensual			DECIMAL(14,2);    	-- PARA OBTENER EL VALOR DE TASA MENSUAL
	DECLARE Var_MontoSeg			DECIMAL(14,2);     	-- VARIABLE PARA OBTENER EL VALOR MONTO DE SEGURO ANUAL
	DECLARE Var_MontoSegVida		DECIMAL(14,2);     	-- VARIABLE PARA OBTENER EL VALOR MONTO DE SEGURO VIDA ANUAL
	DECLARE Var_MontoSegCal			DECIMAL(14,2);     	-- VARIABLE PARA OBTENER EL VALOR MONTO DE SEGURO ANUAL
	DECLARE Var_MontoSegVidaCal		DECIMAL(14,2);     	-- VARIABLE PARA OBTENER EL VALOR MONTO DE SEGURO VIDA ANUAL
	DECLARE Var_ArrendaID			BIGINT(12);        	-- ID DE ARRENDAMIENTO
	DECLARE VarConsecutivo			BIGINT(12);        	-- NUMERO CONSECUTIVO

	DECLARE Var_MontoSegAnual		DECIMAL(14,2);     	-- MONTO DEL SEGURO ANUALIZADO
	DECLARE Var_MontoSegVidaAn		DECIMAL(14,2);     	-- MONTO DEL SEGURO DE VIDA ANUALIZADO

	-- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia			CHAR(1);			-- CADENA VACIA
	DECLARE Fecha_Vacia				DATE;				-- FECHA VACIA
	DECLARE Entero_Cero 			INT(11);			-- ENTERO CERO
	DECLARE Entero_Uno				INT(11);			-- ENTERO UNO
	DECLARE Decimal_Cero 			DECIMAL(14,2);		-- DECIMAL CERO
	DECLARE Var_SI 					CHAR(1);			-- VALOR SI
	DECLARE Var_NO					CHAR(1);			-- VALOR NO
	DECLARE Est_Generado			CHAR(1);            -- ESTATUS GENERADO
	DECLARE Var_Contado				INT(11);			-- VAR CONTADOR
	DECLARE Var_Financiado			INT(11);			-- VAR FINANCIADO
	DECLARE Var_TipoPrepago			CHAR(1);            -- TIPO DE PREPAGO
	DECLARE Var_TipCobComMorato		CHAR(1);            -- TIPO DE COBRO COMISION

	-- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia			:= '';					-- Cadena Vacia
	SET Fecha_Vacia				:= '1900-01-01';		-- Fecha Vacia
	SET Entero_Cero				:= 0;					-- Entero en Cero
	SET Entero_Uno				:= 1;					-- Entero UNO
	SET Decimal_Cero			:= 0;					-- DECIMAL CERO
	SET Var_SI					:= 'S';					-- Permite Salida SI
	SET Var_NO 					:= 'N';					-- Permite Salida NO
	SET Est_Generado			:= 'G';					-- ESTATUS GENERADO
	SET Var_AnualMes			:= 12;					-- NUMERO DE NESES AL ANIO
	SET Var_Contado				:= 1;					-- para el tipo de pago de seguro 1 = Contado   2 = Financiado
	SET Var_Financiado 			:= 0;					-- para el tipo de pago de seguro 1 = Contado   2 = Financiado
	SET Var_TipoPrepago			:= 'U';					-- TIPO PREPAGO
	SET Var_TipCobComMorato 	:= 'N';					-- TIPO COBRO COMISION

	-- ASIGNACION DE VARIABLES
	SET Aud_FechaActual         := NOW();				-- FECHA ACTUAL
	SELECT	FechaSistema
	  INTO	Var_FechaSistema
		FROM PARAMETROSSIS LIMIT 1;

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr  = 999;
				SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										 'Disculpe las molestias que esto le ocasiona. Ref: SP-ARRENDAMIENTOSALT');
				SET Var_Control = 'sqlException';
			END;

		IF(IFNULL(Par_MontoSeguroAnual, Entero_Cero) > Entero_Cero )THEN
			IF(IFNULL(Par_SeguroArrendaID, Entero_Cero) > Entero_Cero )THEN
				SET Var_SeguroArrendaID := (SELECT AseguradoraID FROM ARRASEGURADORA WHERE AseguradoraID = Par_SeguroArrendaID);
				IF(IFNULL(Var_SeguroArrendaID, Entero_Cero) = Entero_Cero )THEN
					SET Par_NumErr  := 001;
					SET Par_ErrMen  := 'La aseguradora no existe.';
					SET Var_Control := 'seguroArrendaID';
					LEAVE ManejoErrores;
				END IF;
			ELSE
				SET Par_NumErr  := 002;
				SET Par_ErrMen  := 'Especifique aseguradora.';
				SET Var_Control := 'seguroArrendaID';
			END IF;
		END IF;

		IF(IFNULL(Par_MontoSeguroVidaAnual, Entero_Cero) > Entero_Cero )THEN
			IF(IFNULL(Par_SeguroVidaArrendaID, Entero_Cero) > Entero_Cero )THEN
				SET Var_SeguroVidaArrendaID := (SELECT AseguradoraID FROM ARRASEGURADORA WHERE AseguradoraID = Par_SeguroVidaArrendaID);
				IF(IFNULL(Var_SeguroVidaArrendaID, Entero_Cero) = Entero_Cero )THEN
					SET Par_NumErr  := 003;
					SET Par_ErrMen  := 'La aseguradora no existe';
					SET Var_Control := 'seguroVidaArrendaID';
					LEAVE ManejoErrores;
				END IF;
			ELSE
				SET Par_NumErr  := 004;
				SET Par_ErrMen  := 'La aseguradora no existe.';
				SET Var_Control := 'seguroArrendaID';
			END IF;
		END IF;

		IF(NOT EXISTS(SELECT	ClienteID
						FROM 	CLIENTES
						WHERE 	ClienteID = Par_ClienteID)) THEN
			SET Par_NumErr	:= 005;
			SET Par_ErrMen	:= 'El cliente no existe.';
			SET Var_Control := 'Par_ClienteID';
			LEAVE ManejoErrores;
		END IF;

		-- **************************************************************************************
		-- SET OBTIENE EL VALOR DE IVA DEPENDIENDO DE SI EL CLIENTE PAGA O NO *******************
		-- **************************************************************************************
		-- se guarda el valor de si el cliente paga o no IVA
		SELECT	PagaIVA
		  INTO	Var_CtePagIva
			FROM CLIENTES
			WHERE	ClienteID = Par_ClienteID;

		IF(IFNULL(Var_CtePagIva, Cadena_Vacia) = Cadena_Vacia)THEN
			SET Var_CtePagIva	:= Var_Si;
		END IF;

		IF(IFNULL(Par_SucursalID,Entero_Cero ) = Entero_Cero) THEN
			SET Par_SucursalID	:= (SELECT SucursalMatrizID FROM PARAMETROSSIS);
		END IF;

		SET Var_IVA		:= (SELECT IFNULL(IVA,Decimal_Cero) FROM SUCURSALES WHERE SucursalID = Par_SucursalID);

		IF (Var_CtePagIva = Var_No) THEN
			SET Var_IVA := Decimal_Cero;
		END IF;


		SET Var_MontoEnganche		:= Par_MontoArrenda     * ROUND((Par_PorcEnganche/100),6);
		SET Var_TasaMensual			:= (Par_TasaFijaAnual / Var_AnualMes) / 100 ;
		SET Var_IVAMontoArrenda		:= Par_MontoArrenda     * Var_IVA;
		SET Var_IVAEnganche			:= Var_MontoEnganche    * Var_IVA;
		SET Var_MontoFinanciado		:= Par_MontoArrenda     - Var_MontoEnganche;
		SET Var_IVAComApe			:= Par_MontoComApe      * Var_IVA;
		SET Var_IVAOtrosGastos		:= Par_OtroGastos       * Var_IVA;

		-- **************************************************************************************
		-- SE REALIZAN LOS CALCULOS PARA SEGURO ANUAL *******************************************
		-- **************************************************************************************
		SET Var_MontoSegCal		:= ROUND( (Var_TasaMensual * POWER( (Entero_Uno + Var_TasaMensual) , Var_AnualMes) * ( Par_MontoSeguroAnual ) )
										/ ( POWER((1 + Var_TasaMensual) , Var_AnualMes ) - Entero_Uno)  ,2);

		SET Var_MontoSegCal		:= IFNULL(Var_MontoSegCal, Entero_Cero);
		-- **************************************************************************************
		-- SE REALIZAN LOS CALCULOS PARA SEGURO DE VIDA ANUAL ***********************************
		-- **************************************************************************************
		SET Var_MontoSegVidaCal	:= ROUND( (Var_TasaMensual * POWER( (Entero_Uno + Var_TasaMensual) , Var_AnualMes) * ( Par_MontoSeguroVidaAnual ) )
										/ ( POWER((1 + Var_TasaMensual) , Var_AnualMes ) - Entero_Uno)  ,2);

		SET Var_MontoSegVidaCal	:= IFNULL(Var_MontoSegVidaCal, Entero_Cero);

		-- SE VALIDA SI SE AGREGARA EL VALOR DEL SEGURO Y SEGURO  DE VIDA
		IF(Par_TipoPagoSeguro = Var_Contado)THEN
			SET Var_MontoSeg	:= Par_MontoSeguroAnual;
		ELSE
			SET Var_MontoSeg	:= Entero_Cero;
		END IF ;

		IF(Par_TipoPagoSeguroVida = Var_Contado)THEN
			SET Var_MontoSegVida	:= Par_MontoSeguroVidaAnual;
		ELSE
			SET Var_MontoSegVida	:=  Entero_Cero;
		END IF ;


		SET Var_IVADeposito		:= Par_MontoDeposito * Var_IVA;

		-- SE CALCULA EL PAGO INICIAL
		SET Var_MontoEnganche		:= IFNULL(Var_MontoEnganche,Entero_Cero);
		SET Var_IVAEnganche			:= IFNULL(Var_IVAEnganche,Entero_Cero);
		SET Par_MontoComApe			:= IFNULL(Par_MontoComApe,Entero_Cero);
        SET	Var_IVADeposito			:= IFNULL(Var_IVADeposito,Entero_Cero);
		SET Var_IVAComApe			:= IFNULL(Var_IVAComApe,Entero_Cero);
		SET Par_MontoDeposito		:= IFNULL(Par_MontoDeposito,Entero_Cero);
		SET Par_OtroGastos			:= IFNULL(Par_OtroGastos,Entero_Cero);
		SET Var_IVAOtrosGastos		:= IFNULL(Var_IVAOtrosGastos,Entero_Cero);
		SET Var_MontoSeg			:= IFNULL(Var_MontoSeg,Entero_Cero);
		SET Var_MontoSegVida		:= IFNULL(Var_MontoSegVida,Entero_Cero);
		SET Par_RentaAnticipada		:= IFNULL(Par_RentaAnticipada,Entero_Cero);
		SET Par_IVARentaAnticipada	:= IFNULL(Par_IVARentaAnticipada,Entero_Cero);
		SET Par_CuotasAdelantadas	:= IFNULL(Par_CuotasAdelantadas,Entero_Cero);
		SET Par_IVACuotasAdelan		:= IFNULL(Par_IVACuotasAdelan,Entero_Cero);

		SET Var_TotalPagoInicial	:=  Var_MontoEnganche	+ Var_IVAEnganche			+ Par_MontoComApe		+ Var_IVAComApe			+ Par_MontoDeposito +
										Par_OtroGastos		+ Var_IVAOtrosGastos		+ Var_MontoSeg			+ Var_MontoSegVida		+ Var_IVADeposito +
										Par_RentaAnticipada	+ Par_IVARentaAnticipada	+ Par_CuotasAdelantadas	+ Par_IVACuotasAdelan;



		SET Var_ArrendaID		:= (SELECT IFNULL(MAX(ArrendaID),Entero_Cero) + 1 FROM ARRENDAMIENTOS);
		SET Var_ArrendaID		:= LPAD(Var_ArrendaID, 10, 0);

		-- VALIDA SI LOS SEGUROS SE PAGAN DE CONTADO O FINANCIADOS
		IF(Par_TipoPagoSeguro = 1)THEN
			SET Var_MontoSegAnual	:= Entero_Cero;
		ELSE
			SET Var_MontoSegAnual	:= Par_MontoSeguroAnual;
		END IF;

		IF(Par_TipoPagoSeguroVida = 1)THEN
			SET Var_MontoSegVidaAn	:= Entero_Cero;
		ELSE
			SET Var_MontoSegVidaAn	:= Par_MontoSeguroVidaAnual;
		END IF;

		IF(IFNULL(Par_TipCobComMorato,Cadena_Vacia) = Cadena_Vacia)THEN
			SET Par_TipCobComMorato	:= Var_TipCobComMorato;
		END IF;
		IF(IFNULL(Par_TipoPrepago,Cadena_Vacia) = Cadena_Vacia)THEN
			SET Par_TipoPrepago		:= Var_TipoPrepago;
		END IF;

		-- **************************************************************************************
		-- SE INSERTAN LOS VALORES EN LA TABLA DE ARRENDAMIENTOS *******************
		-- **************************************************************************************

		INSERT INTO ARRENDAMIENTOS (
			ArrendaID,              LineaArrendaID,             ClienteID,              NumTransacSim,              TipoArrenda,
			MonedaID,               ProductoArrendaID,          MontoArrenda,           IVAMontoArrenda,            MontoEnganche,
			IVAEnganche,            PorcEnganche,               MontoFinanciado,        SeguroArrendaID,            TipoPagoSeguro,
			MontoSeguroAnual,       SeguroVidaArrendaID,        TipoPagoSeguroVida,     MontoSeguroVidaAnual,       MontoResidual,
			FechaRegistro,          FechaApertura,              FechaPrimerVen,         FechaUltimoVen,             FechaLiquida,
			Plazo,                  FrecuenciaPlazo,            TasaFijaAnual,          MontoRenta,                 MontoSeguro,
			MontoSeguroVida,        CantRentaDepo,              MontoDeposito,          IVADeposito,                MontoComApe,
			IVAComApe,              OtroGastos,                 IVAOtrosGastos,         TotalPagoInicial,           TipCobComMorato,
			FactorMora,             CantCuota,                  MontoCuota,             Estatus,                    SucursalID,
			UsuarioAlta,            UsuarioAutoriza,            FechaAutoriza,          FechaTraspasaVen,           FechaRegulariza,
			UsuarioCancela,         FechaCancela,               MotivoCancela,          SaldoCapVigente,            SaldoCapAtrasad,
			SaldoCapVencido,        MontoIVACapital,            SaldoInteresVigent,     SaldoInteresAtras,          SaldoInteresVen,
			MontoIVAInteres,        SaldoSeguro,                MontoIVASeguro,         SaldoSeguroVida,            MontoIVASeguroVida,
			SaldoMoratorios,        MontoIVAMora,               SaldComFaltPago,        MontoIVAComFalPag,          SaldoOtrasComis,
			MontoIVAComisi,         DiaPagoProd,                PagareImpreso,          FechaInhabil,               TipoPrepago,
			EsRenAnticipada,		TipRenAdelanta,				NumRenAdelantada,		RentasAdelantadas,			IVARenAdelanta,
			RentaAnticipada,		IVARentaAnticipa,			EmpresaID,				Usuario,					FechaActual,
			DireccionIP,			ProgramaID,					Sucursal,				NumTransaccion
		) VALUES (
			Var_ArrendaID,          Par_LineaArrendaID,         Par_ClienteID,          Par_NumTransacSim,          Par_TipoArrenda,
			Par_MonedaID,           Par_ProductoArrendaID,      Par_MontoArrenda,       Var_IVAMontoArrenda,        Var_MontoEnganche,
			Var_IVAEnganche,        Par_PorcEnganche,           Var_MontoFinanciado,    Par_SeguroArrendaID,        Par_TipoPagoSeguro,
			Par_MontoSeguroAnual,   Par_SeguroVidaArrendaID,    Par_TipoPagoSeguroVida, Par_MontoSeguroVidaAnual,   Par_MontoResidual,
			Var_FechaSistema,       Par_FechaApertura,          Par_FechaPrimerVen,     Par_FechaUltimoVen,         Fecha_Vacia,
			Par_Plazo,              Par_FrecuenciaPlazo,        Par_TasaFijaAnual,      Par_MontoRenta,             Par_MontoSeguro,
			Par_MontoSeguroVida,    Par_CantRentaDepo,          Par_MontoDeposito,      Var_IVADeposito,            Par_MontoComApe,
			Var_IVAComApe,          Par_OtroGastos,             Var_IVAOtrosGastos,     Var_TotalPagoInicial,       Par_TipCobComMorato,
			Par_FactorMora,         Par_CantCuota,              Par_MontoCuota,         Est_Generado,               Par_SucursalID,
			Aud_Usuario,            Entero_Cero,                Fecha_Vacia,            Fecha_Vacia,                Fecha_Vacia,
			Entero_Cero,            Fecha_Vacia,                Cadena_Vacia,           Decimal_Cero,               Decimal_Cero,
			Decimal_Cero,           Decimal_Cero,               Decimal_Cero,           Decimal_Cero,               Decimal_Cero,
			Decimal_Cero,           Decimal_Cero,               Decimal_Cero,           Decimal_Cero,               Decimal_Cero,
			Decimal_Cero,           Decimal_Cero,               Decimal_Cero,           Decimal_Cero,               Decimal_Cero,
			Decimal_Cero,           Par_DiaPagoProd,            Var_NO,                 Par_FechaInhabil,           Par_TipoPrepago,
			Par_EsRentaAnticipada,	Par_TipoRenAdelantadas,		Par_CantRenAdelantadas,	Par_CuotasAdelantadas,		Par_IVACuotasAdelan,
			Par_RentaAnticipada,	Par_IVARentaAnticipada,		Aud_EmpresaID,			Aud_Usuario,				Aud_FechaActual,
			Aud_DireccionIP,		Aud_ProgramaID,				Aud_Sucursal,			Aud_NumTransaccion
		);


		-- ********************************************************************************************
		-- SE INSERTAN LAS AMORTIZACIONES DE ARRENDAMIENTO
		-- ********************************************************************************************
		CALL ARRENDAAMORTIZAPRO(
			Var_MontoFinanciado,    Var_MontoSegAnual,      Var_MontoSegVidaAn,		    Par_DiaPagoProd,        Par_MontoResidual,
			Par_FechaApertura,      Par_FrecuenciaPlazo,    Par_Plazo,                  Par_TasaFijaAnual,      Par_FechaInhabil,
			Par_ClienteID,          Var_ArrendaID,			Par_EsRentaAnticipada,		Par_CantRenAdelantadas,	Par_TipoRenAdelantadas,
			Var_NO,					Par_NumErr,				Par_ErrMen,					Par_NumTransacSim,		Par_CantCuota,
			Par_FechaPrimerVen,		Par_FechaUltimoVen,		Aud_EmpresaID,				Aud_Usuario,			Aud_FechaActual,
			Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion
			);

		-- **************************************************************************************
		-- SE ACTUALIZAN LOS VALORES EN LA TABLA DE ARRENDAMIENTOS *******************
		-- **************************************************************************************
		UPDATE ARRENDAMIENTOS SET
			NumTransacSim           = Par_NumTransacSim,
			FechaPrimerVen          = Par_FechaPrimerVen,
			FechaUltimoVen          = Par_FechaUltimoVen,

			EmpresaID               = Aud_EmpresaID,
			Usuario                 = Aud_Usuario,
			FechaActual             = Aud_FechaActual,
			DireccionIP             = Aud_DireccionIP,
			ProgramaID              = Aud_ProgramaID,
			Sucursal                = Aud_Sucursal,
			NumTransaccion          = Aud_NumTransaccion
		WHERE ArrendaID = Var_ArrendaID;

		SET Par_NumErr      := 000;
		SET Var_Control     := 'arrendaID';
		SET Par_ErrMen      := CONCAT('Arrendamiento agregado exitosamente: ',Var_ArrendaID);
		SET VarConsecutivo  := Var_ArrendaID;
	END ManejoErrores;

		-- Se muestran los datos
	IF (Par_Salida = Var_SI) THEN
		SELECT  Par_NumErr                  AS NumErr,
				Par_ErrMen                  AS ErrMen,
				Var_Control                 AS Control,
				LPAD(VarConsecutivo, 10, 0) AS Consecutivo;
	END IF;
END TerminaStore$$