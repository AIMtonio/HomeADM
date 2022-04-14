-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOSCLASIFICAREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOSCLASIFICAREP`;DELIMITER $$

CREATE PROCEDURE `CREDITOSCLASIFICAREP`(

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


DECLARE Var_PorcentajeConsumo	DECIMAL(10,2);
DECLARE Var_PorcentajeComer		DECIMAL(10,2);
DECLARE Var_PorcentajeViv		DECIMAL(10,2);
DECLARE Var_FechaAnterior  	 	DATE;
DECLARE Var_MontoConsumo        DECIMAL(14,2);

DECLARE Var_MontoComercial      DECIMAL(14,2);
DECLARE Var_MontoVivienda       DECIMAL(14,2);
DECLARE Var_MontoCartera 		DECIMAL(14,2);
DECLARE Var_SalCapVig       	DECIMAL(14,2);
DECLARE Var_SalCapAtr       	DECIMAL(14,2);

DECLARE Var_SalIntVig       	DECIMAL(14,2);
DECLARE Var_SalIntAtr       	DECIMAL(14,2);
DECLARE	Var_SalCapVen			DECIMAL(14,2);
DECLARE Var_SalIntVen       	DECIMAL(14,2);
DECLARE Var_SalTotCartera   	DECIMAL(14,2);

DECLARE Var_PorcentualConsumo   DECIMAL(10,4);
DECLARE Var_PorcentualComer     DECIMAL(10,4);
DECLARE Var_PorcentualViv     	DECIMAL(10,4);
DECLARE Var_DifLimiteConsumo    DECIMAL(10,4);
DECLARE Var_DifLimiteComer      DECIMAL(10,4);

DECLARE Var_DifLimiteViv        DECIMAL(10,4);
DECLARE Var_PorcentSalConsumo   DECIMAL(14,2);
DECLARE Var_PorcentSalComer 	DECIMAL(14,2);
DECLARE Var_PorcentSalViv  		DECIMAL(14,2);
DECLARE Var_DifLimSalConsumo  	DECIMAL(14,2);

DECLARE Var_DifLimSalComer  	DECIMAL(14,2);
DECLARE Var_DifLimSalViv  		DECIMAL(14,2);
DECLARE Var_SaldosConsumo 		DECIMAL(14,2);

DECLARE Var_SaldosComercial 	DECIMAL(14,2);
DECLARE Var_SaldosVivienda	 	DECIMAL(14,2);
DECLARE Var_SaldoCartera        DECIMAL(14,2);
DECLARE Var_SaldoCarDiaAnt		DECIMAL(14,2);
DECLARE Var_DiaAnterior         DATE;

DECLARE Var_SaldosDiaAnterior   DECIMAL(14,2);


DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Entero_Cero			INT(11);
DECLARE	Decimal_Cero		DECIMAL(14,2);
DECLARE Fecha_Vacia			DATE;
DECLARE ParamPorClasifica	INT(11);

DECLARE ReferenciaConsumo	INT(11);
DECLARE ReferenciaComercial	INT(11);
DECLARE ReferenciaVivienda	INT(11);
DECLARE Cred_Comercial      CHAR(1);
DECLARE Cred_Consumo        CHAR(1);

DECLARE Cred_Vivienda       CHAR(1);
DECLARE Cred_Otros          CHAR(1);
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


SET	Cadena_Vacia			:= '';
SET	Entero_Cero				:= 0;
SET	Decimal_Cero			:= 0.0;
SET Fecha_Vacia				:= '1900-01-01';
SET ParamPorClasifica   	:= 7;

SET ReferenciaConsumo		:= 1;
SET ReferenciaComercial		:= 2;
SET ReferenciaVivienda		:= 3;
SET Cred_Comercial      	:= 'C';
SET Cred_Consumo        	:= 'O';

SET Cred_Vivienda       	:= 'H';
SET Cred_Otros          	:=  '';
SET MovimientoCargo			:= 'C';
SET MovimientoAbono			:= 'A';
SET Mov_CapOrd         	 	:= 1;

SET Mov_CapAtr          	:= 2;
SET Mov_CapVen          	:= 3;
SET Mov_CapVNE          	:= 4;
SET Mov_IntOrd          	:= 10;
SET Mov_IntAtr         	 	:= 11;

SET Mov_IntVen          	:= 12;
SET Mov_IntPro          	:= 14;
SET Mov_IntMor          	:= 15;
SET Mov_IntMoratoVen		:= 16;


SET Var_FechaAnterior 		:= (SELECT DATE_ADD(Par_FechaOperacion, INTERVAL -1 DAY));
SET Var_DiaAnterior 		:= (SELECT DATE_ADD(Var_FechaAnterior, INTERVAL -1 DAY));
SET Var_PorcentajeConsumo   := (SELECT Porcentaje FROM PARAMUACIRIESGOS WHERE CatParamRiesgosID = ParamPorClasifica AND ReferenciaID = ReferenciaConsumo);
SET Var_PorcentajeComer   	:= (SELECT Porcentaje FROM PARAMUACIRIESGOS WHERE CatParamRiesgosID = ParamPorClasifica AND ReferenciaID = ReferenciaComercial);
SET Var_PorcentajeViv   	:= (SELECT Porcentaje FROM PARAMUACIRIESGOS WHERE CatParamRiesgosID = ParamPorClasifica AND ReferenciaID = ReferenciaVivienda);

SET Var_PorcentajeConsumo   := IFNULL(Var_PorcentajeConsumo,Decimal_Cero);
SET Var_PorcentajeComer   	:= IFNULL(Var_PorcentajeComer,Decimal_Cero);
SET Var_PorcentajeViv   	:= IFNULL(Var_PorcentajeViv,Decimal_Cero);



	SELECT SUM(CASE WHEN  Mov.NatMovimiento = MovimientoCargo THEN Mov.Cantidad ELSE Decimal_Cero END) -
		   SUM(CASE WHEN Mov.NatMovimiento = MovimientoAbono THEN Mov.Cantidad ELSE Decimal_Cero END)
		INTO Var_MontoConsumo
		FROM CREDITOSMOVS Mov
		INNER JOIN CREDITOS Cre
			ON Mov.CreditoID = Cre.CreditoID
		WHERE Mov.FechaAplicacion = Var_FechaAnterior
		AND Mov.TipoMovCreID IN(Mov_CapVen,Mov_CapVNE,Mov_IntVen,Mov_IntMoratoVen,
			Mov_CapOrd, Mov_CapAtr,Mov_IntOrd,Mov_IntAtr,Mov_IntPro,Mov_IntMor)
		AND Cre.ClasiDestinCred IN(Cred_Consumo,Cred_Otros);

	SET Var_MontoConsumo     := IFNULL(Var_MontoConsumo, Decimal_Cero);


	SELECT SUM(CASE WHEN Mov.NatMovimiento = MovimientoCargo THEN Mov.Cantidad ELSE Decimal_Cero END) -
		   SUM(CASE WHEN Mov.NatMovimiento = MovimientoAbono THEN Mov.Cantidad ELSE Decimal_Cero END)
		INTO Var_MontoComercial
		FROM CREDITOSMOVS Mov
		INNER JOIN CREDITOS Cre
			ON Mov.CreditoID = Cre.CreditoID
		WHERE Mov.FechaAplicacion = Var_FechaAnterior
		AND Mov.TipoMovCreID IN(Mov_CapVen,Mov_CapVNE,Mov_IntVen,Mov_IntMoratoVen,
			Mov_CapOrd, Mov_CapAtr,Mov_IntOrd,Mov_IntAtr,Mov_IntPro,Mov_IntMor)
		AND Cre.ClasiDestinCred = Cred_Comercial;

	SET Var_MontoComercial    := IFNULL(Var_MontoComercial, Decimal_Cero);


	SELECT SUM(CASE WHEN  Mov.NatMovimiento = MovimientoCargo THEN Mov.Cantidad ELSE Decimal_Cero END) -
		   SUM(CASE WHEN Mov.NatMovimiento = MovimientoAbono THEN Mov.Cantidad ELSE Decimal_Cero END)
		INTO Var_MontoVivienda
		FROM CREDITOSMOVS Mov
		INNER JOIN CREDITOS Cre
			ON Mov.CreditoID = Cre.CreditoID
		WHERE Mov.FechaAplicacion = Var_FechaAnterior
		AND Mov.TipoMovCreID IN(Mov_CapVen,Mov_CapVNE,Mov_IntVen,Mov_IntMoratoVen,
			Mov_CapOrd, Mov_CapAtr,Mov_IntOrd,Mov_IntAtr,Mov_IntPro,Mov_IntMor)
		AND Cre.ClasiDestinCred = Cred_Vivienda;

	SET Var_MontoVivienda    := IFNULL(Var_MontoVivienda, Decimal_Cero);


	SELECT SUM(SalCapVigente + SalCapAtrasado + SalIntProvision + SalMoratorios + SalIntAtrasado +
			SalCapVencido + SalCapVenNoExi + SalIntVencido + SaldoMoraVencido)
		INTO Var_SaldosDiaAnterior
		FROM SALDOSCREDITOS
			WHERE FechaCorte = Var_DiaAnterior;

	SET	Var_SaldosDiaAnterior	:= IFNULL(Var_SaldosDiaAnterior,Decimal_Cero);



	SELECT SUM(Sal.SalCapVigente + Sal.SalCapAtrasado + Sal.SalIntProvision + Sal.SalMoratorios + Sal.SalIntAtrasado +
			Sal.SalCapVencido + Sal.SalCapVenNoExi + Sal.SalIntVencido + Sal.SaldoMoraVencido)
		INTO Var_SaldosConsumo
		FROM SALDOSCREDITOS Sal
		INNER JOIN CREDITOS Cre
			ON Sal.CreditoID = Cre.CreditoID
		WHERE Sal.FechaCorte = Var_FechaAnterior
		AND Cre.ClasiDestinCred IN(Cred_Consumo,Cred_Otros);

	SET	Var_SaldosConsumo	:= IFNULL(Var_SaldosConsumo,Decimal_Cero);


	SELECT SUM(Sal.SalCapVigente + Sal.SalCapAtrasado + Sal.SalIntProvision + Sal.SalMoratorios + Sal.SalIntAtrasado +
			Sal.SalCapVencido + Sal.SalCapVenNoExi + Sal.SalIntVencido + Sal.SaldoMoraVencido)
		INTO Var_SaldosComercial
		FROM SALDOSCREDITOS Sal
		INNER JOIN CREDITOS Cre
			ON Sal.CreditoID = Cre.CreditoID
		WHERE Sal.FechaCorte = Var_FechaAnterior
		AND Cre.ClasiDestinCred = Cred_Comercial;

	SET	Var_SaldosComercial	:= IFNULL(Var_SaldosComercial,Decimal_Cero);


	SELECT SUM(Sal.SalCapVigente + Sal.SalCapAtrasado + Sal.SalIntProvision + Sal.SalMoratorios + Sal.SalIntAtrasado +
			Sal.SalCapVencido + Sal.SalCapVenNoExi + Sal.SalIntVencido + Sal.SaldoMoraVencido)
		INTO Var_SaldosVivienda
		FROM SALDOSCREDITOS Sal
		INNER JOIN CREDITOS Cre
			ON Sal.CreditoID = Cre.CreditoID
			AND Cre.ClasiDestinCred IN (Cred_Vivienda)
		WHERE Sal.FechaCorte = Var_FechaAnterior;

	SET	Var_SaldosVivienda	:= IFNULL(Var_SaldosVivienda,Decimal_Cero);


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


SET Var_MontoCartera    := Var_MontoConsumo + Var_MontoComercial + Var_MontoVivienda;
SET Var_MontoCartera	:= IFNULL(Var_MontoCartera, Decimal_Cero);

SET Var_SalTotCartera   := Var_SalCapVig + Var_SalCapAtr + Var_SalIntVig + Var_SalIntAtr +
							Var_SalCapVen + Var_SalIntVen;
SET	Var_SalTotCartera	:= IFNULL(Var_SalTotCartera,Decimal_Cero);

SET Var_SaldoCarDiaAnt  := Var_SalTotCartera - Var_SaldosDiaAnterior;
SET Var_SaldoCarDiaAnt	:= IFNULL(Var_SaldoCarDiaAnt,Decimal_Cero);

SET Var_SaldoCartera    := Var_SaldosConsumo + Var_SaldosComercial + Var_SaldosVivienda;
SET Var_SaldoCartera	:= IFNULL(Var_SaldoCartera,Decimal_Cero);

SET Var_PorcentualConsumo	:= (CASE WHEN Var_SaldoCarDiaAnt = Decimal_Cero THEN Decimal_Cero ELSE (Var_MontoConsumo / Var_SaldoCarDiaAnt) END) * 100;
SET	Var_PorcentualConsumo	:= IFNULL(Var_PorcentualConsumo,Decimal_Cero);

SET Var_PorcentualComer		:= (CASE WHEN Var_SaldoCarDiaAnt = Decimal_Cero THEN Decimal_Cero ELSE (Var_MontoComercial / Var_SaldoCarDiaAnt) END) * 100;
SET	Var_PorcentualComer		:= IFNULL(Var_PorcentualComer,Decimal_Cero);

SET Var_PorcentualViv		:= (CASE WHEN Var_SaldoCarDiaAnt = Decimal_Cero THEN Decimal_Cero ELSE (Var_MontoVivienda / Var_SaldoCarDiaAnt) END) * 100;
SET	Var_PorcentualViv		:= IFNULL(Var_PorcentualViv,Decimal_Cero);

SET Var_DifLimiteConsumo  	:= Var_PorcentajeConsumo - Var_PorcentualConsumo;
SET	Var_DifLimiteConsumo	:= IFNULL(Var_DifLimiteConsumo,Decimal_Cero);

SET Var_DifLimiteComer  	:= Var_PorcentajeComer - Var_PorcentualComer;
SET	Var_DifLimiteComer		:= IFNULL(Var_DifLimiteComer,Decimal_Cero);

SET Var_DifLimiteViv  		:= Var_PorcentajeViv - Var_PorcentualViv;
SET	Var_DifLimiteViv		:= IFNULL(Var_DifLimiteViv,Decimal_Cero);

SET Var_PorcentSalConsumo   := (CASE WHEN Var_SalTotCartera = Decimal_Cero THEN Decimal_Cero ELSE (Var_SaldosConsumo / Var_SalTotCartera) END) * 100;
SET	Var_PorcentSalConsumo	:= IFNULL(Var_PorcentSalConsumo,Decimal_Cero);

SET Var_PorcentSalComer   	:= (CASE WHEN Var_SalTotCartera = Decimal_Cero THEN Decimal_Cero ELSE (Var_SaldosComercial / Var_SalTotCartera) END) * 100;
SET	Var_PorcentSalComer		:= IFNULL(Var_PorcentSalComer,Decimal_Cero);

SET Var_PorcentSalViv  		:= (CASE WHEN Var_SalTotCartera = Decimal_Cero THEN Decimal_Cero ELSE (Var_SaldosVivienda / Var_SalTotCartera) END) * 100;
SET	Var_PorcentSalViv		:= IFNULL(Var_PorcentSalViv,Decimal_Cero);

SET Var_DifLimSalConsumo  	:= Var_PorcentajeConsumo - Var_PorcentSalConsumo;
SET	Var_DifLimSalConsumo	:= IFNULL(Var_DifLimSalConsumo,Decimal_Cero);

SET Var_DifLimSalComer  	:= Var_PorcentajeComer - Var_PorcentSalComer;
SET	Var_DifLimSalComer		:= IFNULL(Var_DifLimSalComer,Decimal_Cero);

SET Var_DifLimSalViv  		:= Var_PorcentajeViv - Var_PorcentSalViv;
SET	Var_DifLimSalViv		:= IFNULL(Var_DifLimSalViv,Decimal_Cero);

SELECT  FORMAT(Var_MontoConsumo,2) AS Var_MontoConsumo,			FORMAT(Var_MontoComercial,2) AS Var_MontoComercial,
		FORMAT(Var_MontoVivienda,2) AS Var_MontoVivienda,		FORMAT(Var_MontoCartera,2) AS Var_MontoCartera,
		Var_MontoConsumo AS Var_MontoConsumoExc, 				Var_MontoComercial AS Var_MontoComercialExc,
		Var_MontoVivienda AS Var_MontoViviendaExc, 				Var_MontoCartera AS Var_MontoCarteraExc,
		Var_SaldoCarDiaAnt,			Var_PorcentualConsumo,	Var_PorcentajeConsumo,		Var_DifLimiteConsumo,
		Var_PorcentualComer,		Var_PorcentajeComer,		Var_DifLimiteComer,			Var_PorcentualViv,
		Var_PorcentajeViv,			Var_DifLimiteViv,			Var_SaldoCartera,			Var_SaldosConsumo,
		Var_SaldosComercial,		Var_SaldosVivienda,			Var_PorcentSalConsumo,		Var_PorcentSalComer,
		Var_PorcentSalViv,			Var_DifLimSalConsumo,		Var_DifLimSalComer,			Var_DifLimSalViv,
        Var_SalTotCartera;
END TerminaStore$$