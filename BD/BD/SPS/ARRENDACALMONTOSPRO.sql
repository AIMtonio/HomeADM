-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARRENDACALMONTOSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `ARRENDACALMONTOSPRO`;DELIMITER $$

CREATE PROCEDURE `ARRENDACALMONTOSPRO`(
	-- SP DE AYUDA PARA CALCULAR MONTOS EN ARRENDAMIENTO
	Par_ClienteID				INT(11),				-- 'Numero de Cliente al que se le da de alta el arrendamiento',
	Par_MontoArrenda			DECIMAL(14,2), 			-- 'Es el monto del Arrendamiento antes de Enganche o anticipo y sin IVA',
	Par_PorcEnganche			DECIMAL(5,2), 			-- 'Valor porcentual que representa el monto del enganche respecto al valor del Bien
	Par_TipoPagoSeguro			INT(11), 				-- '1 = Contado   2 = Financiado',
	Par_MontoSeguroAnual		DECIMAL(14,2), 			-- 'Es el monto del seguro Anual de contado',

	Par_TipoPagoSeguroVida		INT(11), 				-- ' 1 = Contado  2 = Financiado',
	Par_MontoSeguroVidaAnual	DECIMAL(14,2), 			-- 'Es el monto del seguro de Vida Anual de contado',
	Par_Plazo					INT(11), 				-- 'Numero correspondiente al plazo Ejemplo:   36, 48, 60',
	Par_TasaFijaAnual			DECIMAL(5,2), 			-- 'Valor porcentual anual para la tasa de interes',
	Par_MontoRenta  			DECIMAL(14,2), 			-- 'monto calculado del valor de la renta antes de IVA con la formula de Pago de Excel',

	Par_MontoDeposito 			DECIMAL(14,2), 			-- 'Monto total del Deposito',
	Par_MontoComApe				DECIMAL(14,2), 			-- 'Comision por Apertura',
	Par_CantRentaDepo 			INT(11), 				-- 'CANTIDAD DE RENTAS EN DEPOSITO ,
	Par_MontoEnganche 			DECIMAL(14,2), 			-- 'ENGANCHE
	Par_OtroGastos 				DECIMAL(14,2), 			-- 'Son otros gastos o Pagos que se pueden considerar como: Pueden ser Placas y Tenencia,

	Par_ValorResidual			DECIMAL(14,2), 			-- 'VALOR RESIDUAL
	Par_SucursalID 				INT(11),	 			-- 'Sucursal donde se dio de alta el Arrendamiento',
	Par_RentaAnticipada			CHAR(1),				-- Define si se busca el valor de renta de la primera cuota
	Par_RentasAdelantadas		INT(11),	 			-- Define si se busca el valor de renta de las primeras o ultimas N cuotas
	Par_Adelanto				CHAR(1),				-- Define si se buscan las primeras o las ultimas cuotas

	Par_NumTransSim				BIGINT(20),				-- Numero de transaccion que se usara para filtrar en TMPARRENDAPAGOSIM
	Par_NumCal   				TINYINT UNSIGNED,   	-- Numero de CALCULO A REALIZA
	Par_Salida					CHAR(1),				-- Indica si el SP genera o no una salida

	Aud_EmpresaID 				INT(11),				-- Parametro de Auditoria
	Aud_Usuario   				INT(11), 				-- Parametro de Auditoria
	Aud_FechaActual 			DATETIME, 				-- Parametro de Auditoria
	Aud_DireccionIP 			VARCHAR(15), 			-- Parametro de Auditoria
	Aud_ProgramaID 				VARCHAR(50),			-- Parametro de Auditoria
	Aud_Sucursal   				INT(11), 				-- Parametro de Auditoria
	Aud_NumTransaccion 			BIGINT(20) 				-- Parametro de Auditoria
)
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
	DECLARE Var_Control				VARCHAR(100); 		-- Variable de control
	DECLARE Var_CtePagIva 			CHAR(1);			-- VARIABLE PARA  GUARDAR SU EL CLIENTE PAGA O NO IVA
	DECLARE Var_FechaSistema 		DATETIME;			-- Fecha del sistema
	DECLARE Var_IVA  				DECIMAL(16,2);		-- VARIABLE PARA OBTENER EL VALOR DEL IVA

	DECLARE Var_IVAMontoArrenda 	DECIMAL(14,2);		-- 'Es el IVA del monto correspondiente al valor del Bien',
	DECLARE Var_IVAEnganche			DECIMAL(14,2); 		-- 'IVA del Enganche en caso de que aplique',
	DECLARE Var_MontoFinanciado		DECIMAL(14,2); 		-- 'Es el Valor a Financiar para el arrendamiento Reprsenta el Valor del Bien menos el Enganche',
	DECLARE Var_IVADeposito 		DECIMAL(14,2); 		-- 'IVA del monto en Deposito',
	DECLARE Var_IVAComApe			DECIMAL(14,2); 		-- 'Monto Comision por Apertura',
	DECLARE Var_IVAOtrosGastos		DECIMAL(14,2);		-- 'En caso de aplique IVA para Otros Pagos',
	DECLARE Var_TotalPagoInicial	DECIMAL(14,2);		-- 'Monto total a pagar, como pago inical, el cual incluye  el enganche, las comisiones por apertura, el deposito, otros gastos  y los seguros en caso de ser de contado',

	DECLARE Var_TasaMensual			DECIMAL(16,12);		-- PARA OBTENER EL VALOR DE TASA MENSUAL
	DECLARE Var_MontoSeg 			DECIMAL(16,2);		-- VARIABLE PARA OBTENER EL VALOR MONTO DE SEGURO ANUAL
	DECLARE Var_MontoSegVida 		DECIMAL(16,2);		-- VARIABLE PARA OBTENER EL VALOR MONTO DE SEGURO VIDA ANUAL
	DECLARE Var_MontoSegCal 		DECIMAL(16,2);		-- VARIABLE PARA OBTENER EL VALOR MONTO DE SEGURO ANUAL
	DECLARE Var_MontoSegVidaCal		DECIMAL(16,2);		-- VARIABLE PARA OBTENER EL VALOR MONTO DE SEGURO VIDA ANUAL
	DECLARE Var_MontoSegVidaAnual	DECIMAL(16,2); 		-- VARIABLE PARA OBTENER EL VALOR MONTO DE SEGURO VIDA ANUAL
	DECLARE Var_MontoSegAnual 		DECIMAL(16,2);		-- VARIABLE PARA OBTENER EL VALOR MONTO DE SEGURO VIDA ANUAL

	DECLARE Var_ValorCalculado		DECIMAL(16,2); 		-- PARA EL VALOR DE RENTA
	DECLARE Var_RentaAnt			DECIMAL(14,2);		-- Valor de la renta
	DECLARE Var_IVARenAnt			DECIMAL(14,2);		-- Valor del IVA de la renta
	DECLARE Var_RentasAd			DECIMAL(14,2);		-- Valor de la renta
	DECLARE Var_IVARentasAd			DECIMAL(14,2);		-- Valor del IVA de la renta
	DECLARE Var_NumErr				INT(11);			-- Parametro de salida que indica el num. de error
	DECLARE Var_ErrMen				VARCHAR(400);		-- Parametro de salida que indica el mensaje de eror

	-- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);				-- Cadena vacia
	DECLARE Fecha_Vacia 		DATE;					-- Fecha vacia
	DECLARE Entero_Cero 		INT(11);				-- Entero cero
	DECLARE Entero_Uno 			INT(11);				-- Entero uno
	DECLARE Var_CalAlta 		INT(11);				-- Calculo para dar de alta
	DECLARE Decimal_Cero 		DECIMAL(12,2);			-- Decimal cero
	DECLARE Var_SI 				CHAR(1);				-- Variable si
	DECLARE Var_NO 				CHAR(1);				-- Variable no
	DECLARE Var_Contado 		INT(11);				-- Tipo de pago Contado
	DECLARE Var_Financiado		INT(11);				-- Tipo de pago Financiado
	DECLARE Var_AnualMes		INT(11);				-- Numero de meses del anio
	DECLARE Var_RentaAntSi		CHAR(1);				-- Renta anticipada
	DECLARE Var_AdelantoPrim	CHAR(1);				-- Valor para marcar como pagadas N primeras cuotas
	DECLARE Var_AdeltantoUlt	CHAR(1);				-- Valor para marcar como pagadas N ultimas cuotas
	DECLARE	Est_Adelantado		CHAR(1);				-- Estatus Adelantado para arrendamiento.
	DECLARE	Est_Pagado			CHAR(1);				-- Estatus Pagado para arrendamiento.
	DECLARE	Salida_Si			CHAR(1);				-- Indica que si se devuelve un mensaje de salida

	-- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia			:= '';					-- Cadena Vacia
	SET Fecha_Vacia				:= '1900-01-01';		-- Fecha Vacia
	SET Entero_Cero 			:= 0; 					-- Entero en Cero
	SET Entero_Uno 				:= 1; 					-- Entero uno
	SET Decimal_Cero 			:= 0; 					-- Decimal cero
	SET Var_SI 					:= 'S';					-- Permite Salida SI
	SET Var_NO  				:= 'N';					-- Permite Salida NO
	SET Var_CalAlta				:= 1; 					-- Tipo de calculo de ayuda en el alta
	SET Var_AnualMes 			:= 12;					-- Numero de meses del anio
	SET Var_Contado 			:= 1; 					-- Para el tipo de pago de seguro 1 = Contado   2 = Financiado
	SET Var_Financiado  		:= 0; 					-- Para el tipo de pago de seguro 1 = Contado   2 = Financiado
	SET Var_RentaAntSi			:= 'S';					-- Renta anticipada
	SET Var_AdelantoPrim		:= 'P';					-- Valor para marcar como pagadas N primeras cuotas
	SET Var_AdeltantoUlt		:= 'U';					-- Valor para marcar como pagadas N ultimas cuotas
	SET	Est_Adelantado			:= 'A';					-- Valor de estatus anticipado
	SET	Est_Pagado				:= 'P';					-- Valor de estatus pagado
	SET	Salida_Si				:= 'S';					-- El SP si genera una salida

	-- ASIGNACION DE VARIABLES
	SET Aud_FechaActual         := NOW();
	SET Var_Control				:= Cadena_Vacia;
	SET Var_NumErr				:= Entero_Cero;
	SET Var_ErrMen				:= Cadena_Vacia;
	SELECT FechaSistema INTO Var_FechaSistema FROM PARAMETROSSIS LIMIT 1;

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Var_NumErr  = 999;
			SET Var_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									 'Disculpe las molestias que esto le ocasiona. REF: SP-ARRENDACALMONTOSPRO');
			SET Var_Control = 'SQLEXCEPTION';
		END;

	IF(Par_NumCal = Var_CalAlta)THEN
		-- **************************************************************************************
		-- SET OBTIENE EL VALOR DE IVA DEPENDIENDO DE SI EL CLIENTE PAGA O NO *******************
		-- **************************************************************************************
		-- se guarda el valor de si el cliente paga o no IVA
		SELECT PagaIVA INTO Var_CtePagIva   FROM CLIENTES  WHERE ClienteID = Par_ClienteID;

		IF(IFNULL(Var_CtePagIva, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Var_CtePagIva	:= Var_Si;
		END IF;

		IF(IFNULL(Par_SucursalID,Entero_Cero ) = Entero_Cero) THEN
			SET Par_SucursalID	:= (SELECT SucursalMatrizID FROM PARAMETROSSIS);
		END IF;

		SET Var_IVA		:= (SELECT IFNULL(IVA,Decimal_Cero) FROM SUCURSALES WHERE SucursalID = Par_SucursalID);

		IF (Var_CtePagIva = Var_No) THEN
			SET Var_IVA	:= Decimal_Cero;
		END IF;

		IF(IFNULL(Par_MontoEnganche,Entero_Cero)=Entero_Cero)THEN
			IF(IFNULL(Par_PorcEnganche,Entero_Cero)>Entero_Cero)THEN
				SET Par_MontoEnganche	:= Par_MontoArrenda * ROUND((Par_PorcEnganche/100),6);
			END IF;
		ELSE
			IF(Par_MontoArrenda > Entero_Cero)THEN
				SET Par_PorcEnganche	:= ROUND((Par_MontoEnganche  * 100) / Par_MontoArrenda,2);
			END IF;
		END IF;

		SET Var_IVAMontoArrenda		:= Par_MontoArrenda  * Var_IVA;
		SET Var_IVAEnganche			:= Par_MontoEnganche * Var_IVA;
		SET Var_MontoFinanciado 	:= Par_MontoArrenda - Par_MontoEnganche;
		SET Var_IVAComApe 			:= Par_MontoComApe  * Var_IVA;
		SET Var_IVAOtrosGastos 		:= Par_OtroGastos   * Var_IVA;

		IF(Par_TasaFijaAnual > Entero_Cero AND Par_Plazo > Entero_Cero)THEN
			SET Var_TasaMensual 	:= (Par_TasaFijaAnual / Var_AnualMes) / 100 ;

			-- **************************************************************************************
			-- SE REALIZAN LOS CALCULOS QUE SE UTILIZAN EN EL COTIZADOR *****************************
			-- SE CALCULA EL VALOR CALCULADO Y EL VALOR EN RENTA ************************************
			-- **************************************************************************************
			SET Var_ValorCalculado  := Par_ValorResidual * POWER((Entero_Uno + Var_TasaMensual), Par_Plazo* -Entero_Uno );
			-- CON EL VALOR CALCULADO SE OBTIENE EL VALOR DE RENTA
			SET Par_MontoRenta		:= ROUND( (Var_TasaMensual * POWER( (Entero_Uno + Var_TasaMensual) , Par_Plazo) * ( Var_MontoFinanciado - Var_ValorCalculado  ) )
												/ ( POWER((Entero_Uno + Var_TasaMensual) , Par_Plazo ) - Entero_Uno)    , 2);
			SET Par_MontoRenta		:= IFNULL(Par_MontoRenta,Entero_Cero);

			-- **************************************************************************************
			-- SE REALIZAN LOS CALCULOS PARA SEGURO ANUAL *******************************************
			-- **************************************************************************************

			SET Var_MontoSegCal		:= ROUND( (Var_TasaMensual * POWER( (Entero_Uno + Var_TasaMensual) , Var_AnualMes) * ( Par_MontoSeguroAnual ) )
											/ ( POWER((1 + Var_TasaMensual) , Var_AnualMes ) - Entero_Uno)  ,2);
			-- **************************************************************************************
			-- SE REALIZAN LOS CALCULOS PARA SEGURO DE VIDA ANUAL ***********************************
			-- **************************************************************************************
			SET Var_MontoSegVidaCal   := ROUND( (Var_TasaMensual * POWER( (Entero_Uno + Var_TasaMensual) , Var_AnualMes) * ( Par_MontoSeguroVidaAnual ) )
											/ ( POWER((1 + Var_TasaMensual) , Var_AnualMes ) - Entero_Uno)  ,2);
		END IF;

		-- SE VALIDA SI SE AGREGARA EL VALOR DEL SEGURO Y SEGURO  DE VIDA
		IF(Par_TipoPagoSeguro = Var_Contado)THEN
			SET Var_MontoSeg		:= Entero_Cero;
			SET Var_MontoSegAnual	:= Entero_Cero;
		ELSE
			SET Var_MontoSeg 		:= Var_MontoSegCal;
			SET Var_MontoSegAnual	:= Par_MontoSeguroAnual;
		END IF ;


		IF(Par_TipoPagoSeguroVida = Var_Contado)THEN
			SET Var_MontoSegVida		:= Entero_Cero;
			SET Var_MontoSegVidaAnual	:= Entero_Cero;
		ELSE
			SET Var_MontoSegVida		:= Var_MontoSegVidaCal;
			SET Var_MontoSegVidaAnual	:= Par_MontoSeguroVidaAnual;
		END IF ;

		SET Par_MontoDeposito 	:= (Par_CantRentaDepo * (Par_MontoRenta + Var_MontoSegVida + Var_MontoSeg) );
		SET Var_IVADeposito		:= Par_MontoDeposito  * Var_IVA;

		SET Par_MontoEnganche	:= IFNULL(Par_MontoEnganche,Entero_Cero);
		SET Var_IVAEnganche		:= IFNULL(Var_IVAEnganche,Entero_Cero);
		SET Par_MontoComApe 	:= IFNULL(Par_MontoComApe,Entero_Cero);
		SET Var_IVAComApe  		:= IFNULL(Var_IVAComApe,Entero_Cero);
		SET Par_MontoDeposito	:= IFNULL(Par_MontoDeposito,Entero_Cero);
		SET Par_OtroGastos		:= IFNULL(Par_OtroGastos,Entero_Cero);
		SET Var_IVAOtrosGastos	:= IFNULL(Var_IVAOtrosGastos,Entero_Cero);
		SET Var_MontoSeg 		:= IFNULL(Var_MontoSeg,Entero_Cero);
		SET Var_MontoSegVida 	:= IFNULL(Var_MontoSegVida,Entero_Cero);

		-- SE ASIGNA VALOR DE SEGURO PARA PAGO INICIAL
		-- SE VALIDA SI SE AGREGARA EL VALOR DEL SEGURO Y SEGURO  DE VIDA
		IF(Par_TipoPagoSeguro = Var_Contado)THEN
			SET Var_MontoSeg 		:= Var_MontoSegCal;
			SET Var_MontoSegAnual	:= Par_MontoSeguroAnual;
		ELSE
			SET Var_MontoSeg 		:= Entero_Cero;
			SET Var_MontoSegAnual 	:= Entero_Cero;
		END IF ;

			IF(Par_TipoPagoSeguroVida = Var_Contado)THEN
				SET Var_MontoSegVida 		:= Var_MontoSegVidaCal;
				SET Var_MontoSegVidaAnual	:= Par_MontoSeguroVidaAnual;
			ELSE
				SET Var_MontoSegVida  		:= Entero_Cero;
				SET Var_MontoSegVidaAnual	:= Entero_Cero;
			END IF ;

			-- Si se especifico que se dara la renta anticipada, se buscaran los valores de renta e IVA de renta de la primera cuota
			IF Par_RentaAnticipada = Var_RentaAntSi THEN
				SELECT		SUM(Tmp_Renta + Tmp_MontoSeg + Tmp_MontoSegVida),	SUM(Tmp_Iva+Tmp_MontoSegIva+Tmp_MontoSegVidaIva)
					INTO	Var_RentaAnt,	Var_IVARenAnt
					FROM TMPARRENDAPAGOSIM
					WHERE	NumTransaccion = Par_NumTransSim
					AND	Tmp_Consecutivo = Entero_Uno;

				SET Var_RentaAnt := IFNULL(Var_RentaAnt,Entero_Cero);
				SET Var_IVARenAnt := IFNULL(Var_IVARenAnt,Entero_Cero);
			ELSE
				SET Var_RentaAnt := Entero_Cero;
				SET Var_IVARenAnt := Entero_Cero;
			END IF;

			/* Si se especifico que se daran rentas adelantadas, se buscaran los valores de rentas e IVA de rentas de las primeras (o ultimas) cuotas como pagadas.
			Se sabe si son las primeras o las ultimas cuotas dependiendo de lo que venga en el parametro Par_Adelanto */
			IF Par_RentasAdelantadas > Entero_Cero THEN
				IF Par_Adelanto = Var_AdelantoPrim THEN
					SELECT		SUM(Tmp_Renta+Tmp_MontoSeg+Tmp_MontoSegVida),	SUM(Tmp_Iva+Tmp_MontoSegIva+Tmp_MontoSegVidaIva)
						INTO	Var_RentasAd,									Var_IVARentasAd
						FROM TMPARRENDAPAGOSIM
						WHERE	NumTransaccion	= Par_NumTransSim
						AND	Tmp_Estatus	= Est_Pagado
						AND	Tmp_Consecutivo <> Entero_Uno
						ORDER BY Tmp_Consecutivo ASC
						LIMIT	Par_RentasAdelantadas;
				ELSE
					SELECT		SUM(Tmp_Renta+Tmp_MontoSeg+Tmp_MontoSegVida),	SUM(Tmp_Iva+Tmp_MontoSegIva+Tmp_MontoSegVidaIva)
						INTO	Var_RentasAd,									Var_IVARentasAd
						FROM TMPARRENDAPAGOSIM
						WHERE	NumTransaccion	= Par_NumTransSim
						AND	Tmp_Estatus	= Est_Pagado
						AND	Tmp_Consecutivo <> Entero_Uno
						ORDER BY Tmp_Consecutivo DESC
						LIMIT	Par_RentasAdelantadas;
				END IF;
				SET Var_RentasAd := IFNULL(Var_RentasAd,Entero_Cero);
				SET Var_IVARentasAd := IFNULL(Var_IVARentasAd,Entero_Cero);
			ELSE
				SET Var_RentasAd := Entero_Cero;
				SET Var_IVARentasAd := Entero_Cero;
			END IF;

			-- SE CALCULA EL PAGO INICIAL
			SET Var_TotalPagoInicial	:=  Par_MontoEnganche   + Var_IVAEnganche       + Par_MontoComApe       + Var_IVAComApe         + Par_MontoDeposito +
											Par_OtroGastos      + Var_IVAOtrosGastos    + Var_MontoSegAnual     + Var_MontoSegVidaAnual + Var_IVADeposito +
											Var_RentaAnt		+ Var_IVARenAnt			+ Var_RentasAd			+ Var_IVARentasAd;

			SET Var_NumErr  = 000;
			SET Var_ErrMen  = CONCAT('Calculo realizado Exitosamente.');

		END IF;
	END ManejoErrores;

	IF (Par_Salida = Salida_Si) THEN
		SELECT  FORMAT(Var_IVAMontoArrenda,2) AS Var_IVAMontoArrenda,   FORMAT(Par_MontoEnganche,2) AS Var_MontoEnganche,
				FORMAT(Var_IVAEnganche,2) AS Var_IVAEnganche,           FORMAT(Var_MontoFinanciado,2) AS Var_MontoFinanciado,
				FORMAT(Var_IVAComApe,2) AS Var_IVAComApe,               FORMAT(Var_IVADeposito,2) AS Var_IVADeposito,
				FORMAT(Var_IVAOtrosGastos,2) AS Var_IVAOtrosGastos,     FORMAT(Var_MontoSeg,2) AS Var_MontoSeg,
				FORMAT(Var_MontoSegVida,2) AS  Var_MontoSegVida,        FORMAT(Var_TotalPagoInicial,2)AS Var_TotalPagoInicial,
				FORMAT(Par_MontoDeposito,2) AS  Var_MontoDeposito,      FORMAT(Par_PorcEnganche,2)AS Par_PorcEnganche,
				FORMAT(Var_MontoSegAnual,2) AS Var_MontoSegAnual,		FORMAT(Var_MontoSegVidaAnual,2) AS Var_MontoSegVidaAnual,
				FORMAT(Var_RentaAnt,2) AS  Var_RentaAnt,				FORMAT(Var_IVARenAnt,2)AS Var_IVARenAnt,
				FORMAT(Var_RentasAd,2) AS Var_RentasAd,					FORMAT(Var_IVARentasAd,2) AS Var_IVARentasAd,
				Var_NumErr AS NumErr,                       			Var_ErrMen AS ErrMen;
	END IF;
END TerminaStore$$