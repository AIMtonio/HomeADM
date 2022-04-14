-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNEXIGIBLEPROXPAGPAS
DELIMITER ;
DROP FUNCTION IF EXISTS `FNEXIGIBLEPROXPAGPAS`;DELIMITER $$

CREATE FUNCTION `FNEXIGIBLEPROXPAGPAS`(
-- FUNCION QUE RETORNA EL MONTO EXIGIBLE DE LA TABLA AMORTIZAFONDEO

    Par_CreditoFonID   BIGINT(12)



) RETURNS decimal(16,2)
    DETERMINISTIC
BEGIN

DECLARE Var_PagaIva         	CHAR(1);
DECLARE Var_PagaISR         	CHAR(1);
DECLARE Var_IVA             	DECIMAL(12,2);
DECLARE Var_ISR             	DECIMAL(12,2);
DECLARE Var_CapIntere       	CHAR(1);
DECLARE Var_NumTotAmorti    	INT;
DECLARE Var_NumAmortAtrasadas	INT;
DECLARE Var_AmortizacionID		INT;

DECLARE Var_Tasa            	DECIMAL(12,4);
DECLARE Var_MontoExigible    	DECIMAL(16,4);
DECLARE Var_FechaIni        	DATE;
DECLARE Var_FechaVenc       	DATE;
DECLARE Var_MonDescri       	VARCHAR(100);


DECLARE Cadena_Vacia    	CHAR(1);
DECLARE Fecha_Vacia     	DATE;
DECLARE Entero_Cero     	INT(11);
DECLARE Decimal_Cero     	DECIMAL(12,4);
DECLARE Con_Principal   	INT(11);
DECLARE Con_Foranea     	INT(11);
DECLARE Con_Ajuste        	INT(11);
DECLARE Con_PagCreExi		INT(11);
DECLARE Con_BancaLinea  	INT;
DECLARE Con_Prepago			INT(11);
DECLARE Var_SI				CHAR(1);
DECLARE Var_NO				CHAR(1);
DECLARE Est_Pagado			CHAR(1);
DECLARE Est_Vigente			CHAR(1);
DECLARE Est_Atrasado		CHAR(1);
DECLARE Var_FecActual       DATE;
DECLARE NO_Capitaliza   	CHAR(1);
DECLARE SI_Capitaliza   	CHAR(1);



SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Entero_Cero     := 0;
SET Decimal_Cero    := 0.0;
SET Con_Principal   := 1;
SET Con_Foranea     := 2;
SET Con_Ajuste      := 3;
SET Con_PagCreExi   := 4;
SET Con_BancaLinea  := 5;
SET Con_Prepago		:= 6;
SET Var_NO          := 'N';
SET Var_SI          := 'S';
SET Est_Pagado      := 'P';
SET Est_Vigente     := 'N';
SET Est_Atrasado    := 'A';
SET NO_Capitaliza   := 'N';
SET SI_Capitaliza   := 'S';

SELECT FechaSistema INTO Var_FecActual
	FROM PARAMETROSSIS;

    SELECT
           IFNULL(PagaIVA, Var_NO),
           IFNULL(PorcentanjeIVA/100, 0),
           IFNULL(CobraISR, Var_NO),
           IFNULL(TasaISR, Entero_Cero),
           IFNULL(CapitalizaInteres, NO_Capitaliza),
           IFNULL(NumAmortInteres, NumAmortInteres),
           TasaFija, FechaInicio, FechaVencimien, Mon.Descripcion
            INTO
           Var_PagaIva,         Var_IVA,    Var_PagaISR,    Var_ISR,        Var_CapIntere,
           Var_NumTotAmorti,    Var_Tasa,   Var_FechaIni,   Var_FechaVenc,  Var_MonDescri
		FROM CREDITOFONDEO Cre,
           MONEDAS Mon
		WHERE Cre.CreditoFondeoID = Par_CreditoFonID
        AND Cre.MonedaID = Mon.MonedaId;

    IF(Var_PagaIva = Var_SI) THEN
        SET Var_IVA := Var_IVA;
    ELSE
        SET Var_IVA := Entero_Cero;
    END IF;

    IF(Var_PagaISR = Var_SI) THEN
        SET Var_ISR := Var_ISR;
    ELSE
        SET Var_ISR := Entero_Cero;
    END IF;

	SELECT

				IFNULL(SUM(SaldoCapVigente),Entero_Cero) + IFNULL(SUM(SaldoCapAtrasad),Entero_Cero) +
				IFNULL(SUM(ROUND(SaldoInteresPro,2)),Entero_Cero) + IFNULL(SUM(ROUND(SaldoInteresAtra,2)),Entero_Cero) +
				ROUND(IFNULL(SUM(SaldoInteresPro + SaldoInteresAtra) * Var_IVA, 0) +
				ROUND(IFNULL(SUM(SaldoMoratorios),Entero_Cero),2)  +
				ROUND(IFNULL(SUM(ROUND(SaldoMoratorios,2) * Var_IVA),Entero_Cero),2) +
				ROUND(IFNULL(SUM(SaldoComFaltaPa),Entero_Cero),2) +
				ROUND(IFNULL(SUM(ROUND(SaldoComFaltaPa,2) * Var_IVA),Entero_Cero),2) +
				ROUND(IFNULL(SUM(SaldoOtrasComis),Entero_Cero),2)  +
				ROUND(IFNULL(SUM(ROUND(SaldoOtrasComis,2) * Var_IVA),Entero_Cero),2)
			, 2) AS TotalExigible
			INTO Var_MontoExigible
	FROM AMORTIZAFONDEO
	WHERE CreditoFondeoID = Par_CreditoFonID
		AND Estatus <> Est_Pagado
		AND FechaExigible <= Var_FecActual
      AND ( Var_CapIntere = NO_Capitaliza
      OR    (   Var_CapIntere = SI_Capitaliza
      AND       AmortizacionID  = Var_NumTotAmorti )    );
	SET Var_MontoExigible := IFNULL(Var_MontoExigible, Entero_Cero);
     RETURN Var_MontoExigible;

END$$