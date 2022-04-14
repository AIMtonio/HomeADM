-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOSPAGOSREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOSPAGOSREP`;DELIMITER $$

CREATE PROCEDURE `CREDITOSPAGOSREP`(
		-- SP para generar el reporte de Pagos Parciales y Pagos Unicos
	Par_FechaOperacion	DATE,				-- Fecha para generar el Reporte
	Par_NumRep			TINYINT UNSIGNED,   -- Numero de Reporte

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
DECLARE Var_PorPagoParcial		DECIMAL(10,2);	 -- Porcentaje Parametrizado Pagos Parciales
DECLARE Var_FechaAnterior  	 	DATE;            -- Fecha Dia Anterior
DECLARE Var_SalCapVig       	DECIMAL(14,2);   -- Saldo Capital Vigente
DECLARE Var_SalCapAtr       	DECIMAL(14,2);   -- Saldo Capital Atrasado
DECLARE Var_SalIntVig      		DECIMAL(14,2);	 -- Saldo Interes Vigente

DECLARE Var_SalIntAtr       	DECIMAL(14,2);   -- Saldo Interes Atrasado
DECLARE	Var_SalCapVen			DECIMAL(12,2);   -- Saldo Capital Vencido
DECLARE Var_SalIntVen       	DECIMAL(14,2);   -- Saldo Interes Vencido
DECLARE Var_SalTotCartera   	DECIMAL(14,2);   -- Saldo Total de la Cartera de Credito
DECLARE Var_PorcentPagParc  	DECIMAL(10,2);   -- Resultado Porcentual Monto Pagos Parciales

DECLARE Var_DifLimPagParc   	DECIMAL(10,2);   -- Diferencia entre el Parametro (Pagos Parciales) y el Resultado Porcentual (Monto Pagos Parciales)
DECLARE Var_PorcentPagParSal  	DECIMAL(10,2);   -- Resultado Porcentual Saldo Pagos Parciales
DECLARE Var_DifLimPagParSal   	DECIMAL(10,2);   -- Diferencia entre el Parametro (Pagos Parciales) y el Resultado Porcentual (Saldo Pagos Parciales)
DECLARE Var_PorPagoUnico		DECIMAL(10,2);	 -- Porcentaje Parametrizado Pagos Unicos
DECLARE Var_PorcentPagUni		DECIMAL(10,2);   -- Resultado Porcentual Monto Pagos Unicos

DECLARE Var_DifLimPagUni		DECIMAL(10,2);   -- Diferencia entre el Parametro (Pagos Unicos) y el Resultado Porcentual (Monto Pagos Unicos)
DECLARE Var_PorcentPagUniSal	DECIMAL(10,2);   -- Resultado Porcentual Saldo Pagos Unicos
DECLARE Var_DifLimPagUniSal		DECIMAL(10,2);   -- Diferencia entre el Parametro (Pagos Unicos) y el Resultado Porcentual (Saldo Pagos Unicos)
DECLARE Var_MontoPagoUnico 		DECIMAL(14,2);   -- Valor del Monto del Pago Unico
DECLARE Var_MontoPagoParcial 	DECIMAL(14,2); 	 -- Valor del MOnto del Pago Parcial

DECLARE Var_SaldosCreditos      DECIMAL(14,2);   -- Saldos de Creditos (Pagos Parciales/Pagos Unicos)
DECLARE Var_DiaAnterior         DATE;            -- Se obtiene la fecha anterior
DECLARE Var_SaldosDiaAnterior   DECIMAL(14,2);   -- Saldos acumulados al dia anterior
DECLARE Var_SaldoCarDiaAnt  	DECIMAL(14,2);	 -- Saldo del dia anterior


-- Declaracion de Constantes
DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Entero_Cero			INT(11);
DECLARE	Decimal_Cero		DECIMAL(12,2);
DECLARE Fecha_Vacia			DATE;
DECLARE ParamPagParc	    INT(11);

DECLARE ParamPagUnico	    INT(11);
DECLARE Rep_PagoParcial   	INT(11);
DECLARE Rep_PagoUnico   	INT(11);
DECLARE FrecCapPagUnico     CHAR(1);
DECLARE FrecIntPagUnico     CHAR(1);

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
SET ParamPagParc     	:= 3;               -- CatParamRiesgosID: Parametro Pagos Parciales

SET ParamPagUnico       := 4;				-- CatParamRiesgosID: Parametro Pagos Unico
SET Rep_PagoParcial		:= 1;				-- Reporte: Pagos Parciales
SET Rep_PagoUnico       := 2;               -- Reporte: Pagos Unicos
SET FrecCapPagUnico     := 'U';             -- Frecuencia Capital: PAGO UNICO
SET FrecIntPagUnico     := 'U';				-- Frecuencia Interes: PAGO UNICO

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
SET Var_FechaAnterior	:= (SELECT DATE_ADD(Par_FechaOperacion, INTERVAL -1 DAY));
SET Var_DiaAnterior 	:= (SELECT DATE_ADD(Var_FechaAnterior, INTERVAL -1 DAY));
SET Var_PorPagoParcial  := (SELECT Porcentaje FROM PARAMUACIRIESGOS WHERE CatParamRiesgosID = ParamPagParc);
SET Var_PorPagoUnico  	:= (SELECT Porcentaje FROM PARAMUACIRIESGOS WHERE CatParamRiesgosID = ParamPagUnico);
SET Var_PorPagoParcial  := IFNULL(Var_PorPagoParcial, Decimal_Cero);
SET Var_PorPagoUnico  	:= IFNULL(Var_PorPagoUnico, Decimal_Cero);

-- Reporte Pagos Creditos Parciales
IF(Par_NumRep = Rep_PagoParcial) THEN
-- ================== Monto de Cartera Pagos Parciales del Dia Anterior ======================
	SELECT SUM(CASE WHEN Mov.NatMovimiento = MovimientoCargo THEN Mov.Cantidad ELSE Decimal_Cero END) -
		   SUM(CASE WHEN Mov.NatMovimiento = MovimientoAbono THEN Mov.Cantidad ELSE Decimal_Cero END)
			INTO Var_MontoPagoParcial
			FROM CREDITOSMOVS Mov
			INNER JOIN CREDITOS Cre
				ON Mov.CreditoID = Cre.CreditoID
					AND Cre.FrecuenciaCap != FrecCapPagUnico
					AND Cre.FrecuenciaInt != FrecIntPagUnico
			 WHERE Mov.FechaAplicacion = Var_FechaAnterior
				AND Mov.TipoMovCreID IN(Mov_CapVen,Mov_CapVNE,Mov_IntVen,Mov_IntMoratoVen,
						Mov_CapOrd, Mov_CapAtr,Mov_IntOrd,Mov_IntAtr,Mov_IntPro,Mov_IntMor);

	SET Var_MontoPagoParcial     := IFNULL(Var_MontoPagoParcial, Decimal_Cero);

-- ====================== Saldo Acumulado de Cartera al dia Anterior ===================================
	SELECT SUM(SalCapVigente + SalCapAtrasado + SalIntProvision + SalMoratorios + SalIntAtrasado +
			SalCapVencido + SalCapVenNoExi + SalIntVencido + SaldoMoraVencido)
		INTO Var_SaldosDiaAnterior
		FROM SALDOSCREDITOS
			WHERE FechaCorte = Var_DiaAnterior;

	SET	Var_SaldosDiaAnterior	:= IFNULL(Var_SaldosDiaAnterior,Decimal_Cero);

-- ================= Saldo de Cartera Pagos Parciales al Dia Anterior ======================
	SELECT SUM(Sal.SalCapVigente + Sal.SalCapAtrasado + Sal.SalIntProvision + Sal.SalMoratorios + Sal.SalIntAtrasado +
			Sal.SalCapVencido + Sal.SalCapVenNoExi + Sal.SalIntVencido + Sal.SaldoMoraVencido) AS SaldosCreditos
		INTO Var_SaldosCreditos
		FROM SALDOSCREDITOS Sal
		INNER JOIN CREDITOS Cre
			ON Sal.CreditoID = Cre.CreditoID
                AND Cre.NumAmortizacion >=2
		WHERE Sal.FechaCorte = Var_FechaAnterior;

	SET	Var_SaldosCreditos	:= IFNULL(Var_SaldosCreditos,Decimal_Cero);

-- ============ Saldo Total de la Cartera al Dia Anterior ======================
	SELECT	SUM(SalCapVigente),						SUM(SalCapAtrasado),
			SUM(SalIntProvision + SalMoratorios),	SUM(SalIntAtrasado),
			SUM(SalCapVencido	+ SalCapVenNoExi), 	SUM(SalIntVencido + SaldoMoraVencido)
		INTO Var_SalCapVig,		Var_SalCapAtr,		Var_SalIntVig,
			 Var_SalIntAtr,		Var_SalCapVen,		Var_SalIntVen
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
	SET	Var_SalTotCartera	:= IFNULL(Var_SalTotCartera,Decimal_Cero);

	SET Var_SaldoCarDiaAnt  := Var_SalTotCartera - Var_SaldosDiaAnterior;
	SET Var_SaldoCarDiaAnt	:= IFNULL(Var_SaldoCarDiaAnt,Decimal_Cero);

	SET Var_PorcentPagParc	:= (CASE WHEN Var_SaldoCarDiaAnt = Decimal_Cero THEN Decimal_Cero ELSE (Var_MontoPagoParcial / Var_SaldoCarDiaAnt) END) * 100;
	SET	Var_PorcentPagParc	:= IFNULL(Var_PorcentPagParc,Decimal_Cero);

	SET Var_DifLimPagParc   := Var_PorPagoParcial - Var_PorcentPagParc;
	SET	Var_DifLimPagParc	:= IFNULL(Var_DifLimPagParc,Decimal_Cero);

	SET Var_PorcentPagParSal	:= (CASE WHEN Var_SalTotCartera = Decimal_Cero THEN Decimal_Cero ELSE (Var_SaldosCreditos / Var_SalTotCartera) END) * 100;
	SET	Var_PorcentPagParSal	:= IFNULL(Var_PorcentPagParSal,Decimal_Cero);

	SET Var_DifLimPagParSal   	:= Var_PorPagoParcial - Var_PorcentPagParSal;
	SET	Var_DifLimPagParSal		:= IFNULL(Var_DifLimPagParSal,Decimal_Cero);


	SELECT 	FORMAT(Var_MontoPagoParcial,2) AS Var_MontoPagoParcial, Var_MontoPagoParcial AS Var_MontoPagoParcialExc,
			Var_SaldoCarDiaAnt,    	Var_PorcentPagParc,		Var_PorPagoParcial, 	Var_DifLimPagParc,
			Var_SaldosCreditos,		Var_PorcentPagParSal,	Var_DifLimPagParSal,    Var_SalTotCartera,
            0 AS Var_MontoCarteraExc, 0 AS Var_MontoCartera;

END IF;

-- Reporte Pagos Creditos Unicos
IF(Par_NumRep = Rep_PagoUnico) THEN
-- ================== Monto de Cartera Pagos Unicos del Di­a Anterior ======================
	SELECT SUM(CASE WHEN  Mov.NatMovimiento = MovimientoCargo THEN Mov.Cantidad ELSE Decimal_Cero END) -
	SUM(CASE WHEN Mov.NatMovimiento = MovimientoAbono THEN Mov.Cantidad ELSE Decimal_Cero END)
		INTO Var_MontoPagoUnico
		FROM CREDITOSMOVS Mov
		INNER JOIN CREDITOS Cre
			ON Mov.CreditoID = Cre.CreditoID
				AND Cre.FrecuenciaCap = FrecCapPagUnico
				AND Cre.FrecuenciaInt = FrecIntPagUnico
		 WHERE Mov.FechaAplicacion = Var_FechaAnterior
			AND Mov.TipoMovCreID IN(Mov_CapVen,Mov_CapVNE,Mov_IntVen,Mov_IntMoratoVen,
					Mov_CapOrd, Mov_CapAtr,Mov_IntOrd,Mov_IntAtr,Mov_IntPro,Mov_IntMor);

	SET Var_MontoPagoUnico  := IFNULL(Var_MontoPagoUnico, Decimal_Cero);

-- ====================== Saldo Acumulado de Cartera al dia Anterior ===================================
	SELECT SUM(SalCapVigente + SalCapAtrasado + SalIntProvision + SalMoratorios + SalIntAtrasado +
			SalCapVencido + SalCapVenNoExi + SalIntVencido + SaldoMoraVencido)
		INTO Var_SaldosDiaAnterior
		FROM SALDOSCREDITOS
			WHERE FechaCorte = Var_DiaAnterior;

	SET	Var_SaldosDiaAnterior	:= IFNULL(Var_SaldosDiaAnterior,Decimal_Cero);

-- ================= Saldo de Cartera Pagos Unicos al Dia Anterior ======================
	SELECT SUM(Sal.SalCapVigente + Sal.SalCapAtrasado + Sal.SalIntProvision + Sal.SalMoratorios + Sal.SalIntAtrasado +
			Sal.SalCapVencido + Sal.SalCapVenNoExi + Sal.SalIntVencido + Sal.SaldoMoraVencido) AS SaldosCreditos
		INTO Var_SaldosCreditos
		FROM SALDOSCREDITOS Sal
		INNER JOIN CREDITOS Cre
			ON Sal.CreditoID = Cre.CreditoID
                AND Cre.NumAmortizacion = 1
		WHERE Sal.FechaCorte = Var_FechaAnterior;

	SET	Var_SaldosCreditos	:= IFNULL(Var_SaldosCreditos,Decimal_Cero);

-- ============ Saldo Total de la Cartera al Dia Anterior ======================
	SELECT	SUM(SalCapVigente),						SUM(SalCapAtrasado),
			SUM(SalIntProvision + SalMoratorios),	SUM(SalIntAtrasado),
			SUM(SalCapVencido	+ SalCapVenNoExi), 	SUM(SalIntVencido + SaldoMoraVencido)
		INTO Var_SalCapVig,		Var_SalCapAtr,		Var_SalIntVig,
			 Var_SalIntAtr,		Var_SalCapVen,		Var_SalIntVen
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

	SET Var_PorcentPagUni	:= (CASE WHEN Var_SaldoCarDiaAnt = Decimal_Cero THEN Decimal_Cero ELSE (Var_MontoPagoUnico / Var_SaldoCarDiaAnt) END) * 100;
	SET Var_PorcentPagUni	:= IFNULL(Var_PorcentPagUni,Decimal_Cero);

	SET Var_DifLimPagUni	:= Var_PorPagoUnico - Var_PorcentPagUni;
	SET	Var_DifLimPagUni	:= IFNULL(Var_DifLimPagUni,Decimal_Cero);

	SET Var_PorcentPagUniSal 	:= (CASE WHEN Var_SalTotCartera = Decimal_Cero THEN Decimal_Cero ELSE (Var_SaldosCreditos / Var_SalTotCartera) END) * 100;
	SET Var_PorcentPagUniSal	:= IFNULL(Var_PorcentPagUniSal,Decimal_Cero);

	SET Var_DifLimPagUniSal		:= Var_PorPagoUnico - Var_PorcentPagUniSal;
	SET	Var_DifLimPagUniSal		:= IFNULL(Var_DifLimPagUniSal,Decimal_Cero);

	SELECT 	FORMAT(Var_MontoPagoUnico,2) AS Var_MontoPagoUnico, Var_MontoPagoUnico AS Var_MontoPagoUnicoExc,
			Var_SaldoCarDiaAnt,    	Var_PorcentPagUni,		Var_PorPagoUnico, 		Var_DifLimPagUni,
			Var_SaldosCreditos,		Var_PorcentPagUniSal,	Var_DifLimPagUniSal,    Var_SalTotCartera,
			0 AS Var_MontoCarteraExc, 0 AS Var_MontoCartera;

END IF;
END TerminaStore$$