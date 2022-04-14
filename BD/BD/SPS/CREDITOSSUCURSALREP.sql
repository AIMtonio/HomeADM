-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOSSUCURSALREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOSSUCURSALREP`;DELIMITER $$

CREATE PROCEDURE `CREDITOSSUCURSALREP`(
	-- SP para generar el reporte de Creditos Otorgados por Sucursal
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
DECLARE Var_FechaAnterior  	DATE;            -- Fecha un Dia Anterior
DECLARE Var_MontoCartera 	DECIMAL(14,2);   -- Monto Cartera
DECLARE Var_SalCapVig       DECIMAL(14,2);   -- Saldo Capital Vigente
DECLARE Var_SalCapAtr       DECIMAL(14,2);   -- Saldo Capital Atrasado
DECLARE Var_SalIntVig       DECIMAL(14,2);	 -- Saldo Interes Vigente

DECLARE Var_SalIntAtr       DECIMAL(14,2);   -- Saldo Interes Atrasado
DECLARE	Var_SalCapVen		DECIMAL(14,2);   -- Saldo Capital Vencido
DECLARE Var_SalIntVen       DECIMAL(14,2);   -- Saldo Interes Vencido
DECLARE Var_SalTotCartera   DECIMAL(14,2);   -- Saldo Total de la Cartera de Credito
DECLARE Var_SaldoCartera    DECIMAL(14,2);   -- Saldo de Cartera

DECLARE Var_MontoSucursales DECIMAL(14,2);   -- Montos de las Sucursales

-- Declaracion de Constantes
DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Entero_Cero			INT(11);
DECLARE	Decimal_Cero		DECIMAL(14,2);
DECLARE Fecha_Vacia			DATE;
DECLARE ParamPorSucursal	INT(11);

DECLARE Rep_MontoPorSucur   INT(11);
DECLARE Rep_SaldoPorSucur   INT(11);
DECLARE Rep_Excel    		INT(11);
DECLARE Suc_AtencionCli     CHAR(1);
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
SET Rep_MontoPorSucur	:= 1;				-- Reporte: Monto de Cartera por Sucursal

SET Rep_SaldoPorSucur	:= 2;				-- Reporte: Saldo de Cartera por Sucursal
SET Rep_Excel    		:= 3;               -- Reporte: Creditos por Sucursales en Excel
SET ParamPorSucursal   	:= 17;              -- CatParamRiesgosID: Parametro Creditos por Sucursal
SET Suc_AtencionCli     := 'A';             -- Tipo Sucursal: Atencion a Clientes
SET MovimientoCargo		:= 'C';				-- Naturaleza Movimiento: Cargo

SET MovimientoAbono		:= 'A';				-- Naturaleza Movimiento: Abono
SET Mov_CapOrd         	:= 1;			    -- Tipo de Movimiento: Capital Vigente
SET Mov_CapAtr          := 2;				-- Tipo de Movimiento: Capital Atrasado
SET Mov_CapVen          := 3;				-- Tipo de Movimiento: Capital Vencido
SET Mov_CapVNE          := 4;				-- Tipo de Movimiento: Capital Vencido no Exigible

SET Mov_IntOrd          := 10;				-- Tipo de Movimiento: Interes Ordinario
SET Mov_IntAtr         	:= 11;				-- Tipo de Movimiento: Interes Atrasado
SET Mov_IntVen          := 12;				-- Tipo de Movimiento: Interes Vencido
SET Mov_IntPro          := 14;				-- Tipo de Movimiento: Interes Provisionado
SET Mov_IntMor          := 15;				-- Tipo de Movimiento: Interes Moratorio

SET Mov_IntMoratoVen	:= 16;			    -- Tipo de Movimiento: Interes Moratorio Vencido

-- Asignacion de Variables
SET Var_FechaAnterior 	:= (SELECT DATE_ADD(Par_FechaOperacion, INTERVAL -1 DAY));

	-- ============ Saldo Total de la Cartera al Dia Anterior ======================
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

	SET Var_SalTotCartera   := Var_SalCapVig + Var_SalCapAtr + Var_SalIntVig + Var_SalIntAtr +
								Var_SalCapVen + Var_SalIntVen;

	SET	Var_SalTotCartera	:= IFNULL(Var_SalTotCartera,Decimal_Cero);

	-- Total Montos de Cartera del Dia Anterior de las Sucursales
	DROP TABLE IF EXISTS TMPMONTOSUCURSALES;
	CREATE TEMPORARY TABLE TMPMONTOSUCURSALES(
			SucursalID	    	INT(11),
			MontoCredito       	DECIMAL(14,2));

    INSERT INTO TMPMONTOSUCURSALES
	SELECT Suc.SucursalID,SUM(CASE WHEN Mov.NatMovimiento = MovimientoCargo THEN Mov.Cantidad ELSE Decimal_Cero END) -
		SUM(CASE WHEN Mov.NatMovimiento = MovimientoAbono THEN Mov.Cantidad ELSE Decimal_Cero END)
		FROM CREDITOSMOVS Mov
        INNER JOIN CREDITOS Cre
			ON Mov.CreditoID = Cre.CreditoID
		INNER JOIN SUCURSALES Suc
			ON Cre.SucursalID = Suc.SucursalID
        WHERE Mov.FechaAplicacion = Var_FechaAnterior
			AND Mov.TipoMovCreID IN(Mov_CapVen,Mov_CapVNE,Mov_IntVen,Mov_IntMoratoVen,
				Mov_CapOrd, Mov_CapAtr,Mov_IntOrd,Mov_IntAtr,Mov_IntPro,Mov_IntMor)
            AND Suc.TipoSucursal = Suc_AtencionCli
        GROUP BY Suc.SucursalID;

	SELECT SUM(MontoCredito) INTO Var_MontoSucursales FROM TMPMONTOSUCURSALES;

-- Reporte: Monto de Cartera por Sucursal
IF(Par_NumRep = Rep_MontoPorSucur) THEN
	DROP TABLE IF EXISTS TMPPORCENTAJESUC;
	CREATE TEMPORARY TABLE TMPPORCENTAJESUC(
		SucursalID		   INT(11),
		NombreSucursal	   VARCHAR(50),
		Porcentaje         DECIMAL(10,2));

	INSERT INTO TMPPORCENTAJESUC
	SELECT Suc.SucursalID, NombreSucurs, IFNULL(Porcentaje,Decimal_Cero)
		FROM PARAMUACIRIESGOS Par
		INNER JOIN SUCURSALES Suc
			ON Par.ReferenciaID = Suc.SucursalID
		WHERE Par.CatParamRiesgosID = ParamPorSucursal;

	DROP TABLE IF EXISTS TMPRESPORCENTUALSUC;
	CREATE TEMPORARY TABLE TMPRESPORCENTUALSUC(
		SucursalID		   INT(11),
		NombreSucursal	   VARCHAR(50),
		MontoCredito       DECIMAL(14,2),
		Resultado	       DECIMAL(10,2));

	INSERT INTO TMPRESPORCENTUALSUC
	SELECT Suc.SucursalID,NombreSucurs,SUM(CASE Mov.NatMovimiento WHEN MovimientoCargo THEN Mov.Cantidad ELSE Decimal_Cero END) -
			SUM(CASE Mov.NatMovimiento WHEN MovimientoAbono THEN Mov.Cantidad ELSE Decimal_Cero END),Decimal_Cero
		FROM CREDITOSMOVS Mov
        INNER JOIN CREDITOS Cre
			ON Mov.CreditoID = Cre.CreditoID
		INNER JOIN SUCURSALES Suc
			ON Cre.SucursalID = Suc.SucursalID
        WHERE Mov.FechaAplicacion = Var_FechaAnterior
			AND Mov.TipoMovCreID IN(Mov_CapVen,Mov_CapVNE,Mov_IntVen,Mov_IntMoratoVen,
				Mov_CapOrd, Mov_CapAtr,Mov_IntOrd,Mov_IntAtr,Mov_IntPro,Mov_IntMor)
            AND Suc.TipoSucursal = Suc_AtencionCli
        GROUP BY Suc.SucursalID, NombreSucurs;

	UPDATE TMPRESPORCENTUALSUC Tmp
		SET  Resultado = IFNULL((CASE WHEN Var_MontoSucursales = Decimal_Cero THEN Decimal_Cero ELSE (MontoCredito / Var_MontoSucursales) END),Decimal_Cero) * 100;

	DROP TABLE IF EXISTS TMPDIFERENCIA;
	CREATE TEMPORARY TABLE TMPDIFERENCIA(
		SucursalID		   INT(11),
		NombreSucursal	   VARCHAR(50),
		MontoCredito       DECIMAL(14,2),
		Porcentaje	       DECIMAL(10,2),
		Resultado	       DECIMAL(10,2),
		Diferencia	       DECIMAL(10,2));

	INSERT INTO TMPDIFERENCIA
	SELECT Por.SucursalID, Por.NombreSucursal, MontoCredito,Porcentaje, Resultado,Decimal_Cero
		FROM TMPPORCENTAJESUC Por
		INNER JOIN TMPRESPORCENTUALSUC Res
		WHERE Por.SucursalID = Res.SucursalID;

	UPDATE TMPDIFERENCIA Tmp
		SET  Diferencia = Porcentaje - Resultado;

	SELECT SucursalID, NombreSucursal, FORMAT(MontoCredito,2) AS MontoCredito, Resultado,  Porcentaje, Diferencia
			FROM TMPDIFERENCIA;

	DROP TABLE TMPPORCENTAJESUC;
	DROP TABLE TMPRESPORCENTUALSUC;
	DROP TABLE TMPDIFERENCIA;

END IF;

-- Reporte: Saldo de Cartera por Sucursal
IF(Par_NumRep = Rep_SaldoPorSucur) THEN
	DROP TABLE IF EXISTS TMPPORCENTAJESUC;
	CREATE TEMPORARY TABLE TMPPORCENTAJESUC(
		SucursalID		   INT(11),
		NombreSucursal	   VARCHAR(50),
		Porcentaje         DECIMAL(10,2));

	INSERT INTO TMPPORCENTAJESUC
	SELECT Suc.SucursalID, NombreSucurs, IFNULL(Porcentaje,Decimal_Cero)
		FROM PARAMUACIRIESGOS Par
		INNER JOIN SUCURSALES Suc
			ON Par.ReferenciaID = Suc.SucursalID
		WHERE Par.CatParamRiesgosID = ParamPorSucursal;

	DROP TABLE IF EXISTS TMPRESPORCENTUALSUC;
	CREATE TEMPORARY TABLE TMPRESPORCENTUALSUC(
		SucursalID		   INT(11),
		NombreSucursal	   VARCHAR(50),
		SaldoCredito       DECIMAL(14,2),
		Resultado	       DECIMAL(10,2));

	INSERT INTO TMPRESPORCENTUALSUC
	SELECT Suc.SucursalID,NombreSucurs,SUM(Sal.SalCapVigente + Sal.SalCapAtrasado + Sal.SalIntProvision +
			Sal.SalMoratorios + Sal.SalIntAtrasado + Sal.SalCapVencido + Sal.SalCapVenNoExi + Sal.SalIntVencido +
			Sal.SaldoMoraVencido), Decimal_Cero
         FROM SALDOSCREDITOS Sal
        INNER JOIN CREDITOS Cre
			ON Cre.CreditoID = Sal.CreditoID
		INNER JOIN SUCURSALES Suc
            ON Suc.SucursalID = Cre.SucursalID
		WHERE Sal.FechaCorte = Var_FechaAnterior
			AND Suc.TipoSucursal = Suc_AtencionCli
        GROUP BY Suc.SucursalID, NombreSucurs;

	UPDATE TMPRESPORCENTUALSUC Tmp
		SET  Resultado = IFNULL((CASE WHEN Var_SalTotCartera = Decimal_Cero THEN Decimal_Cero ELSE (SaldoCredito / Var_SalTotCartera) END),Decimal_Cero) * 100;

	DROP TABLE IF EXISTS TMPDIFERENCIA;
	CREATE TEMPORARY TABLE TMPDIFERENCIA(
		SucursalID		   INT(11),
		NombreSucursal	   VARCHAR(50),
		SaldoCredito       DECIMAL(14,2),
		Porcentaje	       DECIMAL(10,2),
		Resultado	       DECIMAL(10,2),
		Diferencia	       DECIMAL(10,2));

	INSERT INTO TMPDIFERENCIA
	SELECT Por.SucursalID, Por.NombreSucursal, SaldoCredito,Porcentaje, Resultado,Decimal_Cero
		FROM TMPPORCENTAJESUC Por
		INNER JOIN TMPRESPORCENTUALSUC Res
		WHERE Por.SucursalID = Res.SucursalID;

	UPDATE TMPDIFERENCIA Tmp
		SET  Diferencia = Porcentaje - Resultado;

	SELECT SucursalID, NombreSucursal, FORMAT(SaldoCredito,2) AS SaldoCredito, Resultado, Porcentaje, Diferencia
			FROM TMPDIFERENCIA;

	DROP TABLE TMPPORCENTAJESUC;
	DROP TABLE TMPRESPORCENTUALSUC;
	DROP TABLE TMPDIFERENCIA;

END IF;


-- Reporte: Creditos por Sucursales en Excel
IF(Par_NumRep = Rep_Excel) THEN
    -- Monto de Cartera Acumulado del Dia Anterior
	DROP TABLE IF EXISTS TMPPORCENTAJESUC;
	CREATE TEMPORARY TABLE TMPPORCENTAJESUC(
		SucursalID		   INT(11),
		NombreSucursal	   VARCHAR(50),
		Porcentaje         DECIMAL(10,2));

	INSERT INTO TMPPORCENTAJESUC
	SELECT Suc.SucursalID, NombreSucurs, IFNULL(Porcentaje,Decimal_Cero)
		FROM PARAMUACIRIESGOS Par
		INNER JOIN SUCURSALES Suc
			ON Par.ReferenciaID = Suc.SucursalID
		WHERE Par.CatParamRiesgosID = ParamPorSucursal;

	DROP TABLE IF EXISTS TMPRESPORCENTUALMONTO;
	CREATE TEMPORARY TABLE TMPRESPORCENTUALMONTO(
		SucursalID		   INT(11),
		NombreSucursal	   VARCHAR(50),
		MontoCredito       DECIMAL(14,2),
		Resultado	       DECIMAL(10,2));

	INSERT INTO TMPRESPORCENTUALMONTO
	SELECT Suc.SucursalID,NombreSucurs,SUM(CASE Mov.NatMovimiento WHEN MovimientoCargo THEN Mov.Cantidad ELSE Decimal_Cero END) -
			SUM(CASE Mov.NatMovimiento WHEN MovimientoAbono THEN Mov.Cantidad ELSE Decimal_Cero END),Decimal_Cero
		FROM CREDITOSMOVS Mov
        INNER JOIN CREDITOS Cre
			ON Mov.CreditoID = Cre.CreditoID
		INNER JOIN SUCURSALES Suc
			ON Cre.SucursalID = Suc.SucursalID
        WHERE Mov.FechaAplicacion = Var_FechaAnterior
			AND Mov.TipoMovCreID IN(Mov_CapVen,Mov_CapVNE,Mov_IntVen,Mov_IntMoratoVen,
				Mov_CapOrd, Mov_CapAtr,Mov_IntOrd,Mov_IntAtr,Mov_IntPro,Mov_IntMor)
            AND Suc.TipoSucursal = Suc_AtencionCli
        GROUP BY Suc.SucursalID, NombreSucurs;

	UPDATE TMPRESPORCENTUALMONTO Tmp
		SET  Resultado = IFNULL((CASE WHEN Var_MontoSucursales = Decimal_Cero THEN Decimal_Cero ELSE (MontoCredito / Var_MontoSucursales) END),Decimal_Cero) * 100;

	DROP TABLE IF EXISTS TMPDIFERENCIAMONTO;
	CREATE TEMPORARY TABLE TMPDIFERENCIAMONTO(
		SucursalID		   INT(11),
		NombreSucursal	   VARCHAR(50),
		MontoCredito       DECIMAL(14,2),
		Porcentaje	       DECIMAL(10,2),
		Resultado	       DECIMAL(10,2),
		Diferencia	       DECIMAL(10,2));

	INSERT INTO TMPDIFERENCIAMONTO
	SELECT Por.SucursalID, Por.NombreSucursal, MontoCredito,Porcentaje, Resultado,Decimal_Cero
		FROM TMPPORCENTAJESUC Por
		INNER JOIN TMPRESPORCENTUALMONTO Res
		WHERE Por.SucursalID = Res.SucursalID;

	UPDATE TMPDIFERENCIAMONTO Tmp
		SET  Diferencia = Porcentaje - Resultado;

	DROP TABLE IF EXISTS TMPMONTOSUCURSALES;
	CREATE TEMPORARY TABLE TMPMONTOSUCURSALES(
		SucursalID		   INT(11),
		NombreSucursal	   VARCHAR(50),
		MontoCredito       DECIMAL(14,2),
		ResultadoMonto	   DECIMAL(10,2),
		PorcentajeMonto	   DECIMAL(10,2),
		DiferenciaMonto	   DECIMAL(10,2));

	INSERT INTO TMPMONTOSUCURSALES
	SELECT SucursalID, NombreSucursal, MontoCredito, Resultado,  Porcentaje, Diferencia
			FROM TMPDIFERENCIAMONTO;

    -- Saldo de Cartera Acumulado al Dia Anterior
	DROP TABLE IF EXISTS TMPRESPORCENTUALSALDO;
	CREATE TEMPORARY TABLE TMPRESPORCENTUALSALDO(
		SucursalID		   INT(11),
		NombreSucursal	   VARCHAR(50),
		SaldoCredito       DECIMAL(14,2),
		Resultado	       DECIMAL(10,2));

	INSERT INTO TMPRESPORCENTUALSALDO
	SELECT Suc.SucursalID,NombreSucurs,SUM(Sal.SalCapVigente + Sal.SalCapAtrasado + Sal.SalIntProvision +
			Sal.SalMoratorios + Sal.SalIntAtrasado + Sal.SalCapVencido + Sal.SalCapVenNoExi + Sal.SalIntVencido +
			Sal.SaldoMoraVencido), Decimal_Cero
         FROM SALDOSCREDITOS Sal
        INNER JOIN CREDITOS Cre
			ON Cre.CreditoID = Sal.CreditoID
		INNER JOIN SUCURSALES Suc
            ON Suc.SucursalID = Cre.SucursalID
		WHERE Sal.FechaCorte = Var_FechaAnterior
			AND Suc.TipoSucursal = Suc_AtencionCli
        GROUP BY Suc.SucursalID, NombreSucurs;

	UPDATE TMPRESPORCENTUALSALDO Tmp
		SET  Resultado = IFNULL((CASE WHEN Var_SalTotCartera = Decimal_Cero THEN Decimal_Cero ELSE (SaldoCredito / Var_SalTotCartera) END),Decimal_Cero) * 100;

	DROP TABLE IF EXISTS TMPDIFERENCIASALDO;
	CREATE TEMPORARY TABLE TMPDIFERENCIASALDO(
		SucursalID		   INT(11),
		NombreSucursal	   VARCHAR(50),
		SaldoCredito       DECIMAL(12,2),
		Porcentaje	       DECIMAL(10,2),
		Resultado	       DECIMAL(10,2),
		Diferencia	       DECIMAL(10,2));

	INSERT INTO TMPDIFERENCIASALDO
	SELECT Por.SucursalID, Por.NombreSucursal, SaldoCredito,Porcentaje, Resultado,Decimal_Cero
		FROM TMPPORCENTAJESUC Por
		INNER JOIN TMPRESPORCENTUALSALDO Res
		WHERE Por.SucursalID = Res.SucursalID;

	UPDATE TMPDIFERENCIASALDO Tmp
		SET  Diferencia = Porcentaje - Resultado;

	DROP TABLE IF EXISTS TMPSALDOSUCURSALES;
	CREATE TEMPORARY TABLE TMPSALDOSUCURSALES(
		SucursalID		   INT(11),
		NombreSucursal	   VARCHAR(50),
		SaldoCredito       DECIMAL(14,2),
		ResultadoSaldo	   DECIMAL(10,2),
		PorcentajeSaldo	   DECIMAL(10,2),
		DiferenciaSaldo	   DECIMAL(10,2));

	INSERT INTO TMPSALDOSUCURSALES
	SELECT SucursalID, NombreSucursal, SaldoCredito, Resultado, Porcentaje,Diferencia
			FROM TMPDIFERENCIASALDO;


	SELECT Mon.SucursalID,			Mon.NombreSucursal, 	Mon.MontoCredito, 	Mon.ResultadoMonto,
		   Mon.PorcentajeMonto,		Mon.DiferenciaMonto,	Sal.SaldoCredito, 	Sal.ResultadoSaldo,
		   Sal.PorcentajeSaldo,     Sal.DiferenciaSaldo
	FROM TMPMONTOSUCURSALES Mon
	INNER JOIN TMPSALDOSUCURSALES Sal
			WHERE Mon.SucursalID = Sal.SucursalID;

	DROP TABLE TMPPORCENTAJESUC;
	DROP TABLE TMPRESPORCENTUALMONTO;
	DROP TABLE TMPDIFERENCIAMONTO;
	DROP TABLE TMPMONTOSUCURSALES;
	DROP TABLE TMPRESPORCENTUALSALDO;
	DROP TABLE TMPDIFERENCIASALDO;
	DROP TABLE TMPSALDOSUCURSALES;

END IF;

END TerminaStore$$