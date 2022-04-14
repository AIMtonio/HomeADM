-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AMORTIZAFONDEOSRACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `AMORTIZAFONDEOSRACT`;DELIMITER $$

CREATE PROCEDURE `AMORTIZAFONDEOSRACT`(
/* ACTUALIZA LOS INTERES DE LAS AMORTIZACIONES SIN REFINANCIAMIENTO */
    Par_CreditoFonID	BIGINT(12),
    Par_TipoAct			INT(11),
    Par_Salida        	CHAR(1),
	INOUT Par_NumErr	INT(11),
	INOUT Par_ErrMen	VARCHAR(400),

    /*Parametros de Auditoria*/
    Par_EmpresaID     	INT(11),
	Aud_Usuario		    INT(11),
	Aud_FechaActual	    DATETIME,
	Aud_DireccionIP	    VARCHAR(15),
	Aud_ProgramaID	    VARCHAR(50),

	Aud_Sucursal		INT(11),
	Aud_NumTransaccion  BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_CreditoFondeoID	BIGINT(12);
DECLARE Var_AmortizacionID  INT(11);
DECLARE Var_SaldoCapVigente DECIMAL(14,4);
DECLARE Var_FechaInicio     DATE;
DECLARE Var_FechaVencim     DATE;
DECLARE Var_FechaExigible   DATE;
DECLARE Var_AmoEstatus      CHAR(1);
DECLARE Var_SaldoInteresPro	DECIMAL(14,4);
DECLARE	Var_SaldoIntNoConta	DECIMAL(14,4);
DECLARE Var_ProvisionAcum   DECIMAL(14,4);
DECLARE Var_MonedaID        INT(11);
DECLARE Var_CalInteresID    INT(11);
DECLARE Var_Dias            INT(11);
DECLARE Var_TotCapital      DECIMAL(14,4);
DECLARE Var_Interes         DECIMAL(14,4);
DECLARE Var_IvaInt	        DECIMAL(10,2);
DECLARE Var_CreTasa         DECIMAL(14,4);
DECLARE Var_DiasCredito     INT(11);
DECLARE Var_SaldoCapital 	DECIMAL(14,4);
DECLARE Insoluto		 	DECIMAL(14,4);
DECLARE Var_FechaSistema    DATE;
DECLARE Var_SucCliente      INT(11);
DECLARE Var_IVAIntOrd   	CHAR(1);
DECLARE Var_IVA   			DECIMAL(8,4);
DECLARE Var_PagaIva			CHAR(1);
DECLARE Var_TipoCalInteres	INT(11);
DECLARE Var_Cuotas			INT(11);
DECLARE Var_Folio			VARCHAR(150);

-- Declaracion de Constantes
DECLARE Cadena_Vacia    	CHAR(1);
DECLARE Fecha_Vacia     	DATE;
DECLARE Entero_Cero     	INT(11);
DECLARE Decimal_Cero    	DECIMAL(14,4);
DECLARE SiPagaIVA       	CHAR(1);
DECLARE SalidaSI        	CHAR(1);
DECLARE SalidaNO        	CHAR(1);
DECLARE Esta_Pagado     	CHAR(1);
DECLARE Esta_Activo     	CHAR(1);
DECLARE Esta_Vencido    	CHAR(1);
DECLARE Esta_Vigente    	CHAR(1);
DECLARE Esta_Atrasado		CHAR(1);
DECLARE TipoActInteres		INT(11);
DECLARE CalculoSalInsol 	INT(11);
DECLARE CalculoSalGlob  	INT(11);
DECLARE Tasa_Fija       	INT(11);
DECLARE Contador			INT(11);

-- Declaracion del Cursor para actualizar los intereses de las amortizaciones
DECLARE CURSORAMOINTERES CURSOR FOR
    SELECT  Amo.CreditoFondeoID,	Amo.AmortizacionID,		Amo.SaldoCapVigente,	Cre.MonedaID,
            Amo.FechaInicio,		Amo.FechaVencimiento,	Amo.FechaExigible,		IFNULL(Amo.SaldoInteresPro, 0.00) AS Provision
		FROM AMORTIZAFONDEO Amo INNER JOIN CREDITOFONDEO Cre ON(Amo.CreditoFondeoID = Cre.CreditoFondeoID)
		WHERE Cre.CreditoFondeoID   = Par_CreditoFonID
		  AND Cre.Estatus IN (Esta_Vigente, Esta_Vencido)
		  AND Amo.Estatus = Esta_Vigente
        AND Amo.FechaExigible > Var_FechaSistema
		ORDER BY FechaExigible;

-- Asignacion de Constantes
SET Cadena_Vacia    := '';              	-- Cadena Vacia
SET Fecha_Vacia     := '1900-01-01';    	-- Fecha Vacia
SET Entero_Cero		:= 0;					-- Entero en Cero
SET Decimal_Cero    := 0.00;            	-- Decimal en Cero
SET SiPagaIVA       := 'S';             	-- El Cliente si Paga IVA
SET SalidaSI        := 'S';             	-- El Store si Regresa una Salida
SET SalidaNO        := 'N';             	-- El Store no Regresa una Salida
SET Esta_Pagado     := 'P';             	-- Estatus del Credito: Pagado
SET Esta_Activo     := 'A';             	-- Estatus: Activo
SET Esta_Vencido    := 'B';             	-- Estatus del Credito: Vencido
SET Esta_Vigente    := 'N';             	-- Estatus del Credito: Vigente
SET TipoActInteres	:= 1;             		-- Tipo de Actualizacion: actualiza los intereses
SET CalculoSalInsol	:= 1;					-- Calculo de Interes por Saldos Insolutos
SET CalculoSalGlob	:= 2;					-- Calculo de Interes por Saldos Globales (Monto Original)
SET Tasa_Fija       := 1;					-- CalInteresID para tasa fija

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-AMORTIZAFONDEOSRACT');
		END;

	SELECT 	FechaSistema, 		DiasCredito
	INTO 	Var_FechaSistema, 	Var_DiasCredito
		FROM PARAMETROSSIS;

	IF(IFNULL(Par_TipoAct,Entero_Cero)=TipoActInteres)THEN
		-- se obtienen los valores requeridos para las operaciones del sp
		SELECT  Cre.TasaFija,		Cre.MonedaID,	Cre.CalcInteresID,	Cre.TipoCalInteres,	Cre.PagaIva,
				Cre.PorcentanjeIVA,	Cre.Folio
			INTO
				Var_CreTasa,		Var_MonedaID,	Var_CalInteresID,	Var_TipoCalInteres,	Var_PagaIva,
                Var_IVA,			Var_Folio
			FROM CREDITOFONDEO Cre
			WHERE Cre.CreditoFondeoID = Par_CreditoFonID;

		SET Var_IVA   := IFNULL(Var_IVA, Decimal_Cero);

		/* se compara para saber si el credito pasivo paga o no iva*/
		IF(Var_PagaIva != SiPagaIVA) THEN
			SET Var_IVA := Decimal_Cero;
		ELSE
			SET Var_IVA	:= IFNULL(Var_IVA/100,Decimal_Cero);
		END IF;

		SELECT  SUM(IFNULL(SaldoCapVigente, Entero_Cero))
		INTO 	Var_SaldoCapital
		  FROM AMORTIZAFONDEO Amo
			WHERE CreditoFondeoID = Par_CreditoFonID
			  AND Amo.Estatus != Esta_Pagado;

		SET Var_SaldoCapital := IFNULL(Var_SaldoCapital,Decimal_Cero);

		IF(Var_SaldoCapital > Decimal_Cero AND Var_CalInteresID = Tasa_Fija AND Var_TipoCalInteres=CalculoSalInsol) THEN

			OPEN CURSORAMOINTERES;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				CICLOAMORTI:LOOP

				FETCH CURSORAMOINTERES INTO
					Var_CreditoFondeoID,      Var_AmortizacionID,		Var_SaldoCapVigente,		Var_MonedaID,
					Var_FechaInicio,	Var_FechaVencim,		Var_FechaExigible,			Var_ProvisionAcum;

				SET Var_ProvisionAcum 	:= IFNULL(Var_ProvisionAcum, 	Decimal_Cero);
				SET Var_SaldoCapVigente := IFNULL(Var_SaldoCapVigente, 	Decimal_Cero);
				SET Var_Interes 		:= Decimal_Cero;
				SET Var_TotCapital  	:= Var_SaldoCapVigente;

				IF(Var_FechaInicio < Var_FechaSistema) THEN
					SET Var_Dias := DATEDIFF(Var_FechaVencim, Var_FechaSistema);
				ELSE
					SET Var_Dias := DATEDIFF(Var_FechaVencim, Var_FechaInicio);
				END IF;

				SET Var_Interes := ROUND(Var_SaldoCapital * Var_Dias * Var_CreTasa / (Var_DiasCredito * 100.00),2);

				UPDATE AMORTIZAFONDEO SET
					Interes		= ROUND(Var_Interes + Var_ProvisionAcum,2),
					IVAInteres	= ROUND(ROUND(Var_Interes + Var_ProvisionAcum,2) * Var_IVA, 2)
					WHERE CreditoFondeoID = Var_CreditoFondeoID
					  AND AmortizacionID = Var_AmortizacionID;

				SET Var_SaldoCapital := Var_SaldoCapital - Var_TotCapital;

				END LOOP CICLOAMORTI;
			END;
			CLOSE CURSORAMOINTERES;

		ELSEIF (Var_SaldoCapital > Decimal_Cero AND Var_CalInteresID = Tasa_Fija AND Var_TipoCalInteres = CalculoSalGlob)THEN
			-- Se obtiene las fechas de inicio, de vencimiento, el numero de días y el nuemro de cuotas
            SET Var_FechaInicio := (SELECT FechaInicio FROM CREDITOFONDEO WHERE CreditoFondeoID = Par_CreditoFonID);
            SET Var_FechaVencim := (SELECT FechaVencimiento FROM CREDITOFONDEO WHERE CreditoFondeoID = Par_CreditoFonID);
			SET Var_Dias 		:= DATEDIFF(Var_FechaVencim, Var_FechaInicio);
            SET Var_Cuotas 		:= (SELECT COUNT(AmortizacionID) FROM AMORTIZAFONDEO WHERE Estatus != Esta_Pagado AND CreditoFondeoID = Par_CreditoFonID);

            SET Contador 		:= 1;
			SET Insoluto		:= ROUND(IFNULL(Var_SaldoCapital,Decimal_Cero),2);

			WHILE (Contador <= Var_Cuotas) DO
				IF(Contador < Var_Cuotas) THEN
					SET Var_Interes	:= ROUND((Var_SaldoCapital*((Var_CreTasa*Var_Dias)/(Var_DiasCredito*100.00)))/Var_Cuotas,2);
				ELSE
					SET Var_Interes	:= (ROUND((Var_SaldoCapital*((Var_CreTasa*Var_Dias)/(Var_DiasCredito*100.00)))/Var_Cuotas,2)*Var_Cuotas)-(Var_Interes*(Var_Cuotas-1));
				END IF;

                SET Var_IvaInt	:= ROUND(Var_Interes * Var_IVA,2);

				UPDATE AMORTIZAFONDEO SET
					Interes		= Var_Interes,
					IVAInteres	= Var_IvaInt
				WHERE CreditoFondeoID = Par_CreditoFonID
				AND AmortizacionID = Contador;

				SET Contador = Contador+1;
			END WHILE;
		END IF;
	END IF;

	SET Par_NumErr := Entero_Cero;
	SET Par_ErrMen := CONCAT('Los Intereses han sido Actualizados Correctamente. Credito: ',CONVERT(Par_CreditoFonID, CHAR(12)));

END ManejoErrores;

IF(Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
			Cadena_Vacia AS Control,
			Entero_Cero AS Consecutivo;
END IF;

END TerminaStore$$