-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CARTERAVENCIDAREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CARTERAVENCIDAREP`;DELIMITER $$

CREATE PROCEDURE `CARTERAVENCIDAREP`(
	# SP para generar el reporte de Carteras Vencidas
	Par_FechaOperacion	DATE,           # Fecha para generar el reporte de Cartera Vencida

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT
	)
TerminaStore: BEGIN


# Declaracion de Variables
DECLARE Var_PorCarteraVen   	DECIMAL(10,2);	 # Porcentaje Cartera Vencida
DECLARE Var_FechaAnterior   	DATE;            # Fecha un Dia Anterior a la Fecha del Sistema
DECLARE Var_MontoCapVen         DECIMAL(14,2);   # Monto Capital Vencido
DECLARE Var_MontoIntVen         DECIMAL(14,2);   # Monto Interes Vencido
DECLARE Var_MontoCreditoVen 	DECIMAL(14,2);   # Monto Credito Vencido

DECLARE Var_SalCapVig       	DECIMAL(14,2);   # Saldo Capital Vigente
DECLARE Var_SalCapAtr       	DECIMAL(14,2);   # Saldo Capital Atrasado
DECLARE Var_SalIntVig       	DECIMAL(14,2);	 # Saldo Interes Vigente
DECLARE Var_SalIntAtr       	DECIMAL(14,2);   # Saldo Interes Atrasado
DECLARE Var_SalCapVen		    DECIMAL(14,2);   # Saldo Capital Vencido

DECLARE Var_SalIntVen           DECIMAL(14,2);   # Saldo Interes Vencido
DECLARE Var_SalTotCarVen    	DECIMAL(14,2);   # Saldo Total Cartera Vencida del Dia Anterior
DECLARE Var_SaldoTotCredito  	DECIMAL(14,2);   # Saldo Total Credito (Cartera Vencida + Cartera Vigente)
DECLARE Var_PorcentCarVenAnt  	DECIMAL(10,2);   # Resultado Porcentual (Cartera Vencida del dia anterior)
DECLARE Var_DifLimCarVenAnt    	DECIMAL(10,2);   # Diferencia entre el Parametro (Cartera Vencida del dia anterior) y el Resultado Porcentual (Cartera Vencida del dia anterior)

DECLARE Var_SalCartCapVen   	DECIMAL(14,2);   # Saldo Capital Cartera Vencida del Dia Anterior
DECLARE	Var_SalCartIntVen   	DECIMAL(14,2);   # Saldo Interes Cartera Vencida del Dia Anterior
DECLARE Var_PorcentCarVenAcum  	DECIMAL(10,2);   # Resultado Porcentual (Cartera Vencida al dia anterior)
DECLARE Var_DifLimCarVenAcum    DECIMAL(10,2);   # Diferencia entre el Parametro (Cartera Vencida al dia anterior) y el Resultado Porcentual (Cartera Vencida al dia anterior)

# Declaracion de Constantes
DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Entero_Cero			INT(11);
DECLARE	Decimal_Cero		DECIMAL(14,2);
DECLARE Fecha_Vacia			DATE;
DECLARE ParamCarteraVen     INT(11);

# Asignacion de Constantes
SET	Cadena_Vacia		:= '';				# Cadena Vacia
SET	Entero_Cero			:= 0;				# Entero Cero
SET	Decimal_Cero		:= 0.0;				# Decimal Cero
Set Fecha_Vacia			:= '1900-01-01';    # Fecha Vacia
SET ParamCarteraVen     := 2;               # CatParamRiesgosID: Parametro Cartera Vencida

# Asignacion de variables
SET Var_PorCarteraVen   := (SELECT Porcentaje FROM PARAMUACIRIESGOS WHERE CatParamRiesgosID = ParamCarteraVen);
SET Var_FechaAnterior 	:= (SELECT DATE_ADD(Par_FechaOperacion, INTERVAL -1 DAY));

# ============== Monto de la Cartera de Credito Vencida del Dia Anterior ======================
	SELECT SUM(PasoCapVenDia),SUM(PasoIntVenDia)
		INTO Var_MontoCapVen, Var_MontoIntVen
		FROM SALDOSCREDITOS
	WHERE FechaCorte = Var_FechaAnterior;

SET	Var_MontoCapVen	:= IFNULL(Var_MontoCapVen,Decimal_Cero);
SET	Var_MontoIntVen	:= IFNULL(Var_MontoIntVen,Decimal_Cero);

SET Var_MontoCreditoVen := Var_MontoCapVen + Var_MontoIntVen;
SET	Var_MontoCreditoVen	:= IFNULL(Var_MontoCreditoVen,Decimal_Cero);

# ============= Saldo Total de la Cartera de Credito Vencida del Dia Anterior ======================
SELECT SUM(SalCapVencido + SalCapVenNoExi),	SUM(SalIntVencido + SaldoMoraVencido)
	INTO Var_SalCartCapVen,	Var_SalCartIntVen
		FROM SALDOSCREDITOS
		WHERE FechaCorte = Var_FechaAnterior;

SET	Var_SalCartCapVen	:= IFNULL(Var_SalCartCapVen,Decimal_Cero);
SET Var_SalCartIntVen	:= IFNULL(Var_SalCartIntVen,Decimal_Cero);

SET Var_SalTotCarVen     := Var_SalCartCapVen + Var_SalCartIntVen;
SET Var_SalTotCarVen     := IFNULL(Var_SalTotCarVen,Decimal_Cero);

# ============ Saldo Total de la Cartera de Credito Vigente y Vencida al Dia Anterior ======================
SELECT SUM(SalCapVigente), SUM(SalCapAtrasado), SUM(SalIntProvision + SalMoratorios),
	   SUM(SalIntAtrasado),SUM(SalCapVencido + SalCapVenNoExi),
	   SUM(SalIntVencido + SaldoMoraVencido)
	INTO 	Var_SalCapVig, 	Var_SalCapAtr, 		Var_SalIntVig,
			Var_SalIntAtr,	Var_SalCapVen, 		Var_SalIntVen
		FROM SALDOSCREDITOS
			WHERE FechaCorte = Var_FechaAnterior;

SET	Var_SalCapVig		:= IFNULL(Var_SalCapVig,Decimal_Cero);
SET Var_SalCapAtr		:= IFNULL(Var_SalCapAtr,Decimal_Cero);
SET Var_SalIntVig		:= IFNULL(Var_SalIntVig,Decimal_Cero);
SET Var_SalIntAtr		:= IFNULL(Var_SalIntAtr,Decimal_Cero);
SET Var_SalCapVen		:= IFNULL(Var_SalCapVen,Decimal_Cero);
SET Var_SalIntVen		:= IFNULL(Var_SalIntVen,Decimal_Cero);

SET Var_SaldoTotCredito  	:= Var_SalCapVig + Var_SalCapAtr + Var_SalIntVig + Var_SalIntAtr + Var_SalCapVen + Var_SalIntVen;
SET Var_SaldoTotCredito     := IFNULL(Var_SaldoTotCredito,Decimal_Cero);

SET Var_PorcentCarVenAnt 	:= (CASE WHEN Var_SalTotCarVen = Decimal_Cero THEN Decimal_Cero ELSE (Var_MontoCreditoVen / Var_SalTotCarVen) END) * 100;
SET Var_PorcentCarVenAnt	:= IFNULL(Var_PorcentCarVenAnt,Decimal_Cero);

SET Var_DifLimCarVenAnt     := Var_PorcentCarVenAnt - Var_PorCarteraVen;
SET Var_DifLimCarVenAnt		:= IFNULL(Var_DifLimCarVenAnt,Decimal_Cero);

SET Var_PorcentCarVenAcum   := (CASE WHEN Var_SaldoTotCredito = Decimal_Cero THEN Decimal_Cero ELSE (Var_SalTotCarVen / Var_SaldoTotCredito) END) * 100;
SET Var_PorcentCarVenAcum	:= IFNULL(Var_PorcentCarVenAcum,Decimal_Cero);

SET Var_DifLimCarVenAcum	:= Var_PorcentCarVenAcum - Var_PorCarteraVen;
SET Var_DifLimCarVenAcum	:= IFNULL(Var_DifLimCarVenAcum,Decimal_Cero);


SELECT 	Var_MontoCreditoVen, 		Var_SalTotCarVen,		Var_SaldoTotCredito,
		Var_PorcentCarVenAnt,		Var_PorCarteraVen,		Var_DifLimCarVenAnt,
		Var_PorcentCarVenAcum,		Var_DifLimCarVenAcum;

END TerminaStore$$