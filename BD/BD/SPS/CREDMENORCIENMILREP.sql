-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDMENORCIENMILREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDMENORCIENMILREP`;DELIMITER $$

CREATE PROCEDURE `CREDMENORCIENMILREP`(
	-- SP para generar el reporte de Creditos Menor $ 100,000.00
	Par_FechaOperacion	DATE,	        -- Fecha para generar el reporte

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT
)
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_Porcentaje			DECIMAL(10,2);	         -- Porcentaje Parametrizado Creditos Menor a $ 100,000.00
DECLARE Var_FechaAnterior  	 	DATE;                    -- Fecha un Dia Anterior
DECLARE Var_SalCapVig       	DECIMAL(14,2);           -- Saldo Capital Vigente
DECLARE Var_SalCapAtr       	DECIMAL(14,2);           -- Saldo Capital Atrasado
DECLARE Var_SalIntVig       	DECIMAL(14,2);	         -- Saldo Interes Vigente

DECLARE Var_SalIntAtr       	DECIMAL(14,2);   		 -- Saldo Interes Atrasado
DECLARE	Var_SalCapVen			DECIMAL(14,2);   		 -- Saldo Capital Vencido
DECLARE Var_SalIntVen       	DECIMAL(14,2);   		 -- Saldo Interes Vencido
DECLARE Var_SalTotCartera   	DECIMAL(14,2);   		 -- Saldo Total de la Cartera de Credito
DECLARE Var_Porcentual 			DECIMAL(10,2);   		 -- Resultado Porcentual Monto Creditos Menor a $ 100,000.00

DECLARE Var_DifLimite  			DECIMAL(10,2);   		 -- Diferencia entre el Parametro y el Resultado Porcentual (Monto Creditos Menor a $ 100,000.00)
DECLARE Var_PorcentSaldo	    DECIMAL(14,2);	 		 -- Resultado porcentual Saldo Creditos Menor a $ 100,000.00
DECLARE Var_DifLimiteSaldo      DECIMAL(14,2);   		 -- Diferencia entre el Parametro y el Resultado Porcentual (Saldos Creditos Menor a $ 100,000.00)


DECLARE Var_MontoCarDiaAnt 		DECIMAL(14,2);   		 -- Monto Cartera Dia Anterior
DECLARE Var_SaldosCreditos      DECIMAL(14,2);  		 -- Saldos de Creditos Menor $ 100,000.00
DECLARE Var_DiaAnterior         DATE;                    -- Se obtiene la fecha anterior
DECLARE Var_SaldosDiaAnterior   DECIMAL(14,2);           -- Saldos acumulados al dia anterior
DECLARE Var_SaldoCarDiaAnt  	DECIMAL(14,2);			 -- Saldo del dia anterior

-- Declaracion de Constantes
DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Entero_Cero			INT(11);
DECLARE	Decimal_Cero		DECIMAL(14,2);
DECLARE Fecha_Vacia			DATE;
DECLARE ParamMenorCienMil	INT(11);

DECLARE Estatus_Vigente     CHAR(1);
DECLARE Estatus_Vencida     CHAR(1);
DECLARE ValorCienMil     	DECIMAL(14,2);
DECLARE MovimientoCargo		CHAR(1);
DECLARE MovimientoAbono		CHAR(1);

DECLARE Mov_CapOrd          INT(11);
DECLARE Mov_CapAtr          INT(11);
DECLARE Mov_CapVen          INT(11);
DECLARE Mov_CapVNE          INT(11);
DECLARE Mov_IntOrd          INT(11);

DECLARE Mov_IntAtr          INT(11);
DECLARE Mov_IntVen          INT(11);
DECLARE Mov_IntPro          INT(11);
DECLARE Mov_IntMor          INT(11);
DECLARE Mov_IntMoratoVen	INT(11);

-- Asignacion de Constantes
SET	Cadena_Vacia		:= '';				-- Cadena Vacia
SET	Entero_Cero			:= 0;				-- Entero Cero
SET	Decimal_Cero		:= 0.0;				-- Decimal Cero
SET Fecha_Vacia			:= '1900-01-01';    -- Fecha Vacia
SET ParamMenorCienMil   := 5;               -- CatParamRiesgosID: Parametro Creditos Menor a $ 100,000.00

SET Estatus_Vigente     := 'V'; 			-- Estatus Credito: Vigente
SET Estatus_Vencida     := 'B'; 			-- Estatus Credito: Vencido
SET ValorCienMil     	:= 100000.00;       -- Monto Credito: Cien Mil Pesos
SET MovimientoCargo		:= 'C';				-- Naturaleza Movimiento: Cargo
SET MovimientoAbono		:= 'A';				-- Naturaleza Movimiento: Abono

SET Mov_CapOrd          := 1;			    -- Tipo de Movimiento: Capital Vigente
SET Mov_CapAtr          := 2;				-- Tipo de Movimiento: Capital Atrasado
SET Mov_CapVen          := 3;				-- Tipo de Movimiento: Capital Vencido
SET Mov_CapVNE          := 4;				-- Tipo de Movimiento: Capital Vencido no Exigible
SET Mov_IntOrd          := 10;				-- Tipo de Movimiento: Interes Ordinario

SET Mov_IntAtr          := 11;				-- Tipo de Movimiento: Interes Atrasado
SET Mov_IntVen          := 12;				-- Tipo de Movimiento: Interes Vencido
SET Mov_IntPro          := 14;				-- Tipo de Movimiento: Interes Provisionado
SET Mov_IntMor          := 15;				-- Tipo de Movimiento: Interes Moratorio
SET Mov_IntMoratoVen	:= 16;			    -- Tipo de Movimiento: Interes Moratorio Vencido

-- Asignacion de variables
SET Var_FechaAnterior 	:= (SELECT DATE_ADD(Par_FechaOperacion, INTERVAL -1 DAY));
SET Var_DiaAnterior 	:= (SELECT DATE_ADD(Var_FechaAnterior, INTERVAL -1 DAY));
SET Var_Porcentaje  	:= (SELECT Porcentaje FROM PARAMUACIRIESGOS WHERE CatParamRiesgosID = ParamMenorCienMil);
SET Var_Porcentaje   	:= IFNULL(Var_Porcentaje,Decimal_Cero);


-- ================== Monto de Cartera <= $ 100,000.00 del Dia Anterior ======================
	SELECT SUM(CASE WHEN NatMovimiento = MovimientoCargo THEN Cantidad ELSE Decimal_Cero END) -
		   SUM(CASE WHEN NatMovimiento  = MovimientoAbono THEN Cantidad ELSE Decimal_Cero END)
		INTO Var_MontoCarDiaAnt
		FROM CREDITOSMOVS
		 WHERE FechaAplicacion = Var_FechaAnterior
			AND TipoMovCreID IN(Mov_CapVen,Mov_CapVNE,Mov_IntVen,Mov_IntMoratoVen,
				Mov_CapOrd, Mov_CapAtr,Mov_IntOrd,Mov_IntAtr,Mov_IntPro,Mov_IntMor)
			AND Cantidad <= ValorCienMil;

	SET Var_MontoCarDiaAnt     := IFNULL(Var_MontoCarDiaAnt, Decimal_Cero);

-- ====================== Saldo Acumulado de Cartera al dia Anterior ===================================
	SELECT SUM(SalCapVigente + SalCapAtrasado + SalIntProvision + SalMoratorios + SalIntAtrasado +
			SalCapVencido + SalCapVenNoExi + SalIntVencido + SaldoMoraVencido)
		INTO Var_SaldosDiaAnterior
		FROM SALDOSCREDITOS
			WHERE FechaCorte = Var_DiaAnterior;
	SET	Var_SaldosDiaAnterior	:= IFNULL(Var_SaldosDiaAnterior,Decimal_Cero);

-- ================== Saldo de Cartera <= $ 100,000.00 al Dia Anterior ======================
	SELECT SUM(SalCapVigente + SalCapAtrasado + SalIntProvision + SalMoratorios + SalIntAtrasado +
			SalCapVencido + SalCapVenNoExi + SalIntVencido + SaldoMoraVencido)
		INTO Var_SaldosCreditos
		FROM SALDOSCREDITOS
			WHERE FechaCorte = Var_FechaAnterior
			AND MontoCredito <= ValorCienMil;

	SET	Var_SaldosCreditos	:= IFNULL(Var_SaldosCreditos,Decimal_Cero);

-- ============ Saldo Total de la Cartera al Dia Anterior ======================
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

	SET Var_SalTotCartera   := Var_SalCapVig + Var_SalCapAtr + Var_SalIntVig + Var_SalIntAtr +
								Var_SalCapVen + Var_SalIntVen;
	SET Var_SalTotCartera	:= IFNULL(Var_SalTotCartera,Decimal_Cero);

    SET Var_SaldoCarDiaAnt  := Var_SalTotCartera - Var_SaldosDiaAnterior;
    SET Var_SaldoCarDiaAnt	:= IFNULL(Var_SaldoCarDiaAnt,Decimal_Cero);

	SET Var_Porcentual		:= (CASE WHEN Var_SaldoCarDiaAnt = Decimal_Cero THEN Decimal_Cero ELSE (Var_MontoCarDiaAnt / Var_SaldoCarDiaAnt) END) * 100;
	SET	Var_Porcentual		:= IFNULL(Var_Porcentual,Decimal_Cero);

	SET Var_DifLimite  		:= Var_Porcentaje - Var_Porcentual;
	SET	Var_DifLimite		:= IFNULL(Var_DifLimite,Decimal_Cero);

	SET Var_PorcentSaldo    := (CASE WHEN Var_SalTotCartera = Decimal_Cero THEN Decimal_Cero ELSE (Var_SaldosCreditos / Var_SalTotCartera) END) * 100;
	SET Var_PorcentSaldo    := IFNULL(Var_PorcentSaldo,Decimal_Cero);

	SET Var_DifLimiteSaldo  := Var_Porcentaje - Var_PorcentSaldo;
	SET Var_DifLimiteSaldo  := IFNULL(Var_DifLimiteSaldo,Decimal_Cero);


	SELECT 	FORMAT(Var_MontoCarDiaAnt,2) AS Var_MontoCarDiaAnt, Var_MontoCarDiaAnt AS Var_MontoCarDiaAntExc,
			Var_SaldoCarDiaAnt,    	Var_Porcentual,				Var_Porcentaje, 		Var_DifLimite,
			Var_SaldosCreditos,		Var_SalTotCartera,			Var_PorcentSaldo,		Var_DifLimiteSaldo,
            Var_SalTotCartera as Var_SaldoCartera;
END TerminaStore$$