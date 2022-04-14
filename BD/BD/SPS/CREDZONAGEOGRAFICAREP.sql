-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDZONAGEOGRAFICAREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDZONAGEOGRAFICAREP`;DELIMITER $$

CREATE PROCEDURE `CREDZONAGEOGRAFICAREP`(
	-- SP para generar el reporte de Creditos Otorgados por Zona Geografica
	Par_FechaOperacion	DATE,

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
DECLARE Var_PorcentajeOax		DECIMAL(10,2);	 -- Porcentaje Parametrizado Oaxaca
DECLARE Var_PorcentajePue		DECIMAL(10,2);	 -- Porcentaje Parametrizado Puebla
DECLARE Var_PorcentajeVer		DECIMAL(10,2);	 -- Porcentaje Parametrizado Veracruz
DECLARE Var_FechaAnterior  		DATE;            -- Fecha Dia Anterior
DECLARE Var_MontoOaxaca     	DECIMAL(14,2);   -- Monto Cartera Vigente y Vencida Oaxaca

DECLARE Var_MontoPuebla     	DECIMAL(14,2);   -- Monto Cartera Vigente y Vencida Puebla
DECLARE Var_MontoVeracruz       DECIMAL(14,2);   -- Monto Cartera Vigente y Vencida Veracruz
DECLARE Var_MontoCartera 		DECIMAL(14,2);   -- Monto Cartera Vigente y Vencida (Credito Oaxaca + Credito Puebla  + Credito Veracruz)
DECLARE Var_SalCapVig       	DECIMAL(14,2);   -- Saldo Capital Vigente
DECLARE Var_SalCapAtr       	DECIMAL(14,2);   -- Saldo Capital Atrasado

DECLARE Var_SalIntVig       	DECIMAL(14,2);	 -- Saldo Interes Vogente
DECLARE Var_SalIntAtr       	DECIMAL(14,2);   -- Saldo Interes Atrasado
DECLARE	Var_SalCapVen			DECIMAL(14,2);   -- Saldo Capital Vencido
DECLARE Var_SalIntVen       	DECIMAL(14,2);   -- Saldo Interes Vencido
DECLARE Var_SalTotCartera   	DECIMAL(14,2);   -- Saldo Total de la Cartera de Credito

DECLARE Var_PorcentualOax   	DECIMAL(10,2);   -- Resultado Porcentual Monto Cartera Oaxaca
DECLARE Var_PorcentualPue		DECIMAL(10,2);   -- Resultado Porcentual Monto Cartera Puebla
DECLARE Var_PorcentualVer		DECIMAL(10,2);   -- Resultado Porcentual Monto Cartera Veracruz
DECLARE Var_PorcentualSalOax	DECIMAL(14,2); 	 -- Resultado Porcentual Saldo Cartera Oaxaca
DECLARE Var_PorcentualSalPue    DECIMAL(14,2); 	 -- Resultado Porcentual Saldo Cartera Puebla

DECLARE Var_PorcentualSalVer    DECIMAL(14,2);   -- Resultado Porcentual Saldo Cartera Veracruz
DECLARE Var_DifLimiteOax    	DECIMAL(10,2);   -- Diferencia entre el Parametro (Oaxaca) y el Resultado Porcentual (Monto Cartera Oaxaca)
DECLARE Var_DifLimitePue    	DECIMAL(10,2);   -- Diferencia entre el Parametro (Puebla) y el Resultado Porcentual (Monto Cartera Puebla)
DECLARE Var_DifLimiteVer    	DECIMAL(10,2);   -- Diferencia entre el Parametro (Veracruz) y el Resultado Porcentual (Monto Cartera Veracruz)
DECLARE Var_DifLimiteSalOax     DECIMAL(14,2);   -- Diferencia entre el Parametro (Oaxaca) y el Resultado Porcentual (Saldo Cartera Oaxaca)

DECLARE Var_DifLimiteSalPue     DECIMAL(14,2); 	 -- Diferencia entre el Parametro (Puebla) y el Resultado Porcentual (Saldo Cartera Puebla)
DECLARE Var_DifLimiteSalVer     DECIMAL(14,2);   -- Diferencia entre el Parametro (Veracruz) y el Resultado Porcentual (Saldo Cartera Veracruz)
DECLARE Var_SaldosCredOax		DECIMAL(14,2);   -- Saldos Oaxaca

DECLARE Var_SaldosCredPue		DECIMAL(14,2);   -- Saldos Puebla
DECLARE Var_SaldosCredVer		DECIMAL(14,2);   -- Saldos Veracruz
DECLARE Var_DiaAnterior         DATE;            -- Se obtiene la fecha anterior
DECLARE Var_SaldosDiaAnterior   DECIMAL(14,2);   -- Saldos acumulados al dia anterior
DECLARE Var_SaldoCarDiaAnt  	DECIMAL(14,2);	 -- Saldos Cartera del dia anterior
DECLARE Var_SaldosCartera		DECIMAL(14,2);   -- Saldos de Cartera acumulados al dia anterior por zona geografica

-- Declaracion de Constantes
DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Entero_Cero			INT(11);
DECLARE	Decimal_Cero		DECIMAL(14,2);
DECLARE Fecha_Vacia			DATE;
DECLARE ParamPorZonaGeo		INT(11);

DECLARE EstadoOaxaca		INT(11);
DECLARE EstadoPuebla		INT(11);
DECLARE EstadoVeracruz		INT(11);
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

DECLARE DirOficialSI        CHAR(1);

-- Asignacion de Constantes
SET	Cadena_Vacia		:= '';				-- Cadena Vacia
SET	Entero_Cero			:= 0;				-- Entero Cero
SET	Decimal_Cero		:= 0.0;				-- Decimal Cero
SET Fecha_Vacia			:= '1900-01-01';    -- Fecha Vacia
SET ParamPorZonaGeo   	:= 6;               -- CatParamRiesgosID: Parametro Creditos por Zona Geografica

SET EstadoOaxaca		:= 20;				-- EstadoID: Oaxaca
SET EstadoPuebla		:= 21;				-- EstadoID: Puebla
SET EstadoVeracruz		:= 30;				-- EstadoID: Veracruz
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

SET DirOficialSI        := 'S';             -- Indica Direccion Oficial del Cliente

-- Asignacion de Variables
SET Var_FechaAnterior 		:= (SELECT DATE_ADD(Par_FechaOperacion, INTERVAL -1 DAY));
SET Var_DiaAnterior 		:= (SELECT DATE_ADD(Var_FechaAnterior, INTERVAL -1 DAY));
SET Var_PorcentajeOax   	:= (SELECT Porcentaje FROM PARAMUACIRIESGOS WHERE CatParamRiesgosID = ParamPorZonaGeo AND ReferenciaID = EstadoOaxaca);
SET Var_PorcentajePue   	:= (SELECT Porcentaje FROM PARAMUACIRIESGOS WHERE CatParamRiesgosID = ParamPorZonaGeo AND ReferenciaID = EstadoPuebla);
SET Var_PorcentajeVer   	:= (SELECT Porcentaje FROM PARAMUACIRIESGOS WHERE CatParamRiesgosID = ParamPorZonaGeo AND ReferenciaID = EstadoVeracruz);
SET Var_PorcentajeOax   	:= IFNULL(Var_PorcentajeOax,Decimal_Cero);
SET Var_PorcentajePue   	:= IFNULL(Var_PorcentajePue,Decimal_Cero);
SET Var_PorcentajeVer   	:= IFNULL(Var_PorcentajeVer,Decimal_Cero);

-- ================= Monto de Cartera por Zona Geografica del Dia Anterior ======================
	SELECT SUM(CASE WHEN Mov.NatMovimiento = MovimientoCargo THEN Mov.Cantidad ELSE Decimal_Cero END)-
		   SUM(CASE WHEN Mov.NatMovimiento  = MovimientoAbono THEN Mov.Cantidad ELSE Decimal_Cero END)
		INTO Var_MontoOaxaca
		FROM CREDITOSMOVS Mov
		INNER JOIN CREDITOS Cre
			ON Mov.CreditoID = Cre.CreditoID
		INNER JOIN DIRECCLIENTE Dir
			ON Cre.ClienteID = Dir.ClienteID
		WHERE Mov.FechaAplicacion = Var_FechaAnterior
		AND Mov.TipoMovCreID IN(Mov_CapVen,Mov_CapVNE,Mov_IntVen,Mov_IntMoratoVen,
			Mov_CapOrd, Mov_CapAtr,Mov_IntOrd,Mov_IntAtr,Mov_IntPro,Mov_IntMor)
				  AND Dir.EstadoID = EstadoOaxaca
				  AND Dir.Oficial= DirOficialSI;

	SET Var_MontoOaxaca     := IFNULL(Var_MontoOaxaca, Decimal_Cero);

-- ==== Monto Cartera Credito Puebla del Dia Anterior ====
	SELECT SUM(CASE WHEN Mov.NatMovimiento = MovimientoCargo THEN Mov.Cantidad ELSE Decimal_Cero END) -
		   SUM(CASE WHEN Mov.NatMovimiento  = MovimientoAbono THEN Mov.Cantidad ELSE Decimal_Cero END)
		INTO Var_MontoPuebla
		FROM CREDITOSMOVS Mov
		INNER JOIN CREDITOS Cre
			ON Mov.CreditoID = Cre.CreditoID
		INNER JOIN DIRECCLIENTE Dir
			ON Cre.ClienteID = Dir.ClienteID
		WHERE Mov.FechaAplicacion = Var_FechaAnterior
		AND Mov.TipoMovCreID IN(Mov_CapVen,Mov_CapVNE,Mov_IntVen,Mov_IntMoratoVen,
			Mov_CapOrd, Mov_CapAtr,Mov_IntOrd,Mov_IntAtr,Mov_IntPro,Mov_IntMor)
				AND Dir.EstadoID = EstadoPuebla
				AND Dir.Oficial= DirOficialSI;

	SET Var_MontoPuebla     := IFNULL(Var_MontoPuebla, Decimal_Cero);

-- ==== Monto Cartera Credito Veracruz del Dia Anterior ====
	SELECT SUM(CASE WHEN  Mov.NatMovimiento = MovimientoCargo THEN Mov.Cantidad ELSE Decimal_Cero END) -
	       SUM(CASE WHEN Mov.NatMovimiento  = MovimientoAbono THEN Mov.Cantidad ELSE Decimal_Cero END)
		INTO Var_MontoVeracruz
		FROM CREDITOSMOVS Mov
		INNER JOIN CREDITOS Cre
			ON Mov.CreditoID = Cre.CreditoID
		INNER JOIN DIRECCLIENTE Dir
			ON Cre.ClienteID = Dir.ClienteID
		WHERE Mov.FechaAplicacion = Var_FechaAnterior
		AND Mov.TipoMovCreID IN(Mov_CapVen,Mov_CapVNE,Mov_IntVen,Mov_IntMoratoVen,
			Mov_CapOrd, Mov_CapAtr,Mov_IntOrd,Mov_IntAtr,Mov_IntPro,Mov_IntMor)
				AND Dir.EstadoID = EstadoVeracruz
				AND Dir.Oficial= DirOficialSI;

	SET Var_MontoVeracruz     := IFNULL(Var_MontoVeracruz, Decimal_Cero);

-- ====================== Saldo Acumulado de Cartera al dia Anterior ===================================
	SELECT SUM(SalCapVigente + SalCapAtrasado + SalIntProvision + SalMoratorios + SalIntAtrasado +
			SalCapVencido + SalCapVenNoExi + SalIntVencido + SaldoMoraVencido)
		INTO Var_SaldosDiaAnterior
		FROM SALDOSCREDITOS
			WHERE FechaCorte = Var_DiaAnterior;
	SET	Var_SaldosDiaAnterior	:= IFNULL(Var_SaldosDiaAnterior,Decimal_Cero);

-- ================= Saldo de Cartera por Zona Geografica al Dia Anterior ======================
	SELECT SUM(CASE WHEN Dir.EstadoID = EstadoOaxaca THEN (Sal.SalCapVigente + Sal.SalCapAtrasado + Sal.SalIntProvision + Sal.SalMoratorios + Sal.SalIntAtrasado +
			Sal.SalCapVencido + Sal.SalCapVenNoExi + Sal.SalIntVencido + Sal.SaldoMoraVencido) ELSE Decimal_Cero END),
		   SUM(CASE WHEN Dir.EstadoID = EstadoPuebla THEN (Sal.SalCapVigente + Sal.SalCapAtrasado + Sal.SalIntProvision + Sal.SalMoratorios + Sal.SalIntAtrasado +
				Sal.SalCapVencido + Sal.SalCapVenNoExi + Sal.SalIntVencido + Sal.SaldoMoraVencido) ELSE Decimal_Cero END),
		   SUM(CASE WHEN Dir.EstadoID = EstadoVeracruz THEN (Sal.SalCapVigente + Sal.SalCapAtrasado + Sal.SalIntProvision + Sal.SalMoratorios + Sal.SalIntAtrasado +
				Sal.SalCapVencido + Sal.SalCapVenNoExi + Sal.SalIntVencido + Sal.SaldoMoraVencido) ELSE Decimal_Cero END)
			INTO Var_SaldosCredOax, Var_SaldosCredPue, Var_SaldosCredVer
			FROM SALDOSCREDITOS Sal
			INNER JOIN DIRECCLIENTE Dir
				ON Sal.ClienteID = Dir.ClienteID
			WHERE Sal.FechaCorte = Var_FechaAnterior
					AND Dir.Oficial= DirOficialSI;

SET	Var_SaldosCredOax	:= IFNULL(Var_SaldosCredOax,Decimal_Cero);
SET	Var_SaldosCredPue	:= IFNULL(Var_SaldosCredPue,Decimal_Cero);
SET	Var_SaldosCredVer	:= IFNULL(Var_SaldosCredVer,Decimal_Cero);

-- ============ Saldo Total de la Cartera de Credito al Dia Anterior ======================
SELECT SUM(SalCapVigente), SUM(SalCapAtrasado), SUM(SalIntProvision + SalMoratorios),
	   SUM(SalIntAtrasado),SUM(SalCapVencido + SalCapVenNoExi),
	   SUM(SalIntVencido + SaldoMoraVencido)
	INTO Var_SalCapVig, Var_SalCapAtr, Var_SalIntVig,
		Var_SalIntAtr,	Var_SalCapVen, Var_SalIntVen
		FROM SALDOSCREDITOS
			WHERE FechaCorte = Var_FechaAnterior;

SET	Var_SalCapVig		:= IFNULL(Var_SalCapVig,Decimal_Cero);
SET Var_SalCapAtr		:= IFNULL(Var_SalCapAtr,Decimal_Cero);
SET Var_SalIntVig		:= IFNULL(Var_SalIntVig,Decimal_Cero);
SET Var_SalIntAtr		:= IFNULL(Var_SalIntAtr,Decimal_Cero);
SET Var_SalCapVen		:= IFNULL(Var_SalCapVen,Decimal_Cero);
SET Var_SalIntVen		:= IFNULL(Var_SalIntVen,Decimal_Cero);

SET Var_MontoCartera    := Var_MontoOaxaca + Var_MontoPuebla + Var_MontoVeracruz;
SET	Var_MontoCartera	:= IFNULL(Var_MontoCartera,Decimal_Cero);


SET Var_SaldosCartera   := Var_SaldosCredOax + Var_SaldosCredPue + Var_SaldosCredVer;
SET Var_SaldosCartera   := IFNULL(Var_SaldosCartera,Decimal_Cero);

SET Var_SalTotCartera   := Var_SalCapVig + Var_SalCapAtr + Var_SalIntVig + Var_SalIntAtr +
							Var_SalCapVen + Var_SalIntVen;
SET Var_SalTotCartera	:= IFNULL(Var_SalTotCartera,Decimal_Cero);

SET Var_SaldoCarDiaAnt  := Var_SalTotCartera - Var_SaldosDiaAnterior;
SET Var_SaldoCarDiaAnt	:= IFNULL(Var_SaldoCarDiaAnt,Decimal_Cero);

SET Var_PorcentualOax	:= (CASE WHEN Var_MontoCartera = Decimal_Cero THEN Decimal_Cero ELSE (Var_MontoOaxaca / Var_MontoCartera) END) * 100;
SET	Var_PorcentualOax	:= IFNULL(Var_PorcentualOax,Decimal_Cero);

SET Var_PorcentualPue	:= (CASE WHEN Var_MontoCartera = Decimal_Cero THEN Decimal_Cero ELSE (Var_MontoPuebla / Var_MontoCartera) END) * 100;
SET	Var_PorcentualPue	:= IFNULL(Var_PorcentualPue,Decimal_Cero);

SET Var_PorcentualVer	:= (CASE WHEN Var_MontoCartera = Decimal_Cero THEN Decimal_Cero ELSE (Var_MontoVeracruz / Var_MontoCartera) END) * 100;
SET	Var_PorcentualVer	:= IFNULL(Var_PorcentualVer,Decimal_Cero);

SET Var_DifLimiteOax  	:= Var_PorcentajeOax - Var_PorcentualOax;
SET	Var_DifLimiteOax	:= IFNULL(Var_DifLimiteOax,Decimal_Cero);

SET Var_DifLimitePue  	:= Var_PorcentajePue - Var_PorcentualPue;
SET	Var_DifLimitePue	:= IFNULL(Var_DifLimitePue,Decimal_Cero);

SET Var_DifLimiteVer  	:= Var_PorcentajeVer - Var_PorcentualVer;
SET	Var_DifLimiteVer	:= IFNULL(Var_DifLimiteVer,Decimal_Cero);

SET Var_PorcentualSalOax := (CASE WHEN Var_SalTotCartera = Decimal_Cero THEN Decimal_Cero ELSE (Var_SaldosCredOax / Var_SalTotCartera) END) * 100;
SET Var_PorcentualSalOax := IFNULL(Var_PorcentualSalOax,Decimal_Cero);

SET Var_PorcentualSalPue := (CASE WHEN Var_SalTotCartera = Decimal_Cero THEN Decimal_Cero ELSE (Var_SaldosCredPue / Var_SalTotCartera) END) * 100;
SET Var_PorcentualSalPue := IFNULL(Var_PorcentualSalPue,Decimal_Cero);

SET Var_PorcentualSalVer := (CASE WHEN Var_SalTotCartera = Decimal_Cero THEN Decimal_Cero ELSE (Var_SaldosCredVer / Var_SalTotCartera) END) * 100;
SET Var_PorcentualSalVer := IFNULL(Var_PorcentualSalVer,Decimal_Cero);

SET Var_DifLimiteSalOax  := Var_PorcentajeOax - Var_PorcentualSalOax;
SET	Var_DifLimiteSalOax	:= IFNULL(Var_DifLimiteSalOax,Decimal_Cero);

SET Var_DifLimiteSalPue  := Var_PorcentajePue - Var_PorcentualSalPue;
SET	Var_DifLimiteSalPue	:= IFNULL(Var_DifLimiteSalPue,Decimal_Cero);

SET Var_DifLimiteSalVer  := Var_PorcentajeVer - Var_PorcentualSalVer;
SET	Var_DifLimiteSalVer	:= IFNULL(Var_DifLimiteSalVer,Decimal_Cero);

SELECT  FORMAT(Var_MontoOaxaca,2) AS Var_MontoOaxaca,		Var_MontoOaxaca AS Var_MontoOaxacaExc,
		FORMAT(Var_MontoPuebla,2) AS Var_MontoPuebla,   	Var_MontoPuebla AS Var_MontoPueblaExc,
		FORMAT(Var_MontoVeracruz,2) AS Var_MontoVeracruz, 	Var_MontoVeracruz AS Var_MontoVeracruzExc,
		FORMAT(Var_MontoCartera,2) AS Var_MontoCartera,		Var_MontoCartera AS Var_MontoCarteraExc,
		Var_SaldoCarDiaAnt,		Var_PorcentualOax,			Var_PorcentajeOax,		Var_DifLimiteOax,
		Var_PorcentualPue,		Var_PorcentajePue,			Var_DifLimitePue,		Var_PorcentualVer,
		Var_PorcentajeVer,		Var_DifLimiteVer,  			Var_SaldosCartera,		Var_SaldosCredOax,
		Var_SaldosCredPue,	    Var_SaldosCredVer,			Var_PorcentualSalOax,   Var_PorcentualSalPue,
		Var_PorcentualSalVer,	Var_DifLimiteSalOax,		Var_DifLimiteSalPue,	Var_DifLimiteSalVer,
        Var_SalTotCartera,		Var_SalTotCartera as Var_SaldoCartera;

END TerminaStore$$