-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOSPRODUCTOREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOSPRODUCTOREP`;DELIMITER $$

CREATE PROCEDURE `CREDITOSPRODUCTOREP`(
	-- SP para generar el reporte de Creditos por Producto de Credito
	Par_FechaOperacion	DATE,					-- Fecha para generar el Reporte
	Par_NumRep			TINYINT UNSIGNED,		-- Numero de Reporte

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
DECLARE Var_MontoCartera 	DECIMAL(14,2);   -- Monto Cartera Producto Credito
DECLARE Var_SalCapVig       DECIMAL(14,2);   -- Saldo Capital Vigente
DECLARE Var_SalCapAtr       DECIMAL(14,2);   -- Saldo Capital Atrasado
DECLARE Var_SalIntVig       DECIMAL(14,2);	 -- Saldo Interes Vigente

DECLARE Var_SalIntAtr       DECIMAL(14,2);   -- Saldo Interes Atrasado
DECLARE	Var_SalCapVen		DECIMAL(14,2);   -- Saldo Capital Vencido
DECLARE Var_SalIntVen       DECIMAL(14,2);   -- Saldo Interes Vencido
DECLARE Var_SalTotCartera   DECIMAL(14,2);   -- Saldo Total de la Cartera de Credito
DECLARE Var_SaldoCartera    DECIMAL(14,2);   -- Saldo de Cartera

DECLARE Var_MontoProdCred DECIMAL(14,2);   	 -- Monto Producto Credito

-- Declaracion de Constantes
DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Entero_Cero			INT(11);
DECLARE	Decimal_Cero		DECIMAL(14,2);
DECLARE Fecha_Vacia			DATE;
DECLARE ParamPorProducto	INT(11);

DECLARE Rep_MontoPorProduc  INT(11);
DECLARE Rep_SaldoPorProduc  INT(11);
DECLARE Rep_Excel  			INT(11);
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
SET Rep_MontoPorProduc	:= 1;				-- Reporte: Monto de Cartera por Producto

SET Rep_SaldoPorProduc	:= 2;				-- Reporte: Parametro de Porcentaje por Producto
SET Rep_Excel  			:= 3;				-- Reporte: Creditos por Productos en Excel
SET ParamPorProducto   	:= 15;              -- CatParamRiesgosID: Parametro Creditos por Producto
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


	-- Total Montos de Cartera del Dia Anterior
	DROP TABLE IF EXISTS TMPMONTOPRODUCTOCREDITO;
	CREATE TEMPORARY TABLE TMPMONTOPRODUCTOCREDITO(
			NombreProducto	    VARCHAR(50),
			MontoCredito       	DECIMAL(14,2));

    INSERT INTO TMPMONTOPRODUCTOCREDITO
	SELECT Pro.Descripcion,SUM(CASE WHEN Mov.NatMovimiento = MovimientoCargo THEN Mov.Cantidad ELSE 0 END) -
		SUM(CASE WHEN Mov.NatMovimiento = MovimientoAbono THEN Mov.Cantidad ELSE 0 END)
        FROM CREDITOSMOVS Mov
        INNER JOIN CREDITOS Cre
			ON Mov.CreditoID = Cre.CreditoID
		INNER JOIN PRODUCTOSCREDITO Pro
			ON Cre.ProductoCreditoID = Pro.ProducCreditoID
        WHERE Mov.FechaAplicacion = Var_FechaAnterior
        AND Mov.TipoMovCreID IN(Mov_CapVen,Mov_CapVNE,Mov_IntVen,Mov_IntMoratoVen,
			Mov_CapOrd, Mov_CapAtr,Mov_IntOrd,Mov_IntAtr,Mov_IntPro,Mov_IntMor)
        AND Pro.Descripcion != 'MULTICREDI'
        GROUP BY Pro.Descripcion;

	SELECT SUM(MontoCredito) INTO Var_MontoProdCred FROM TMPMONTOPRODUCTOCREDITO;

-- Reporte: Monto de Cartera por Producto
IF(Par_NumRep = Rep_MontoPorProduc) THEN
	DROP TABLE IF EXISTS TMPPORCENTAJEPROD;
	CREATE TEMPORARY TABLE TMPPORCENTAJEPROD(
		NombreProducto	    VARCHAR(50),
		Porcentaje          DECIMAL(10,2));

	INSERT INTO TMPPORCENTAJEPROD
	SELECT Pro.Descripcion, IFNULL(Porcentaje,Decimal_Cero)
		FROM PARAMUACIRIESGOS Par
		INNER JOIN PRODUCTOSCREDITO Pro
			ON Par.ReferenciaID = Pro.ProducCreditoID
		WHERE Par.CatParamRiesgosID = ParamPorProducto
		AND Pro.Descripcion != 'MULTICREDI'
		GROUP BY Pro.Descripcion, Porcentaje;

	DROP TABLE IF EXISTS TMPRESPORCENTUALPROD;
	CREATE TEMPORARY TABLE TMPRESPORCENTUALPROD(
		NombreProducto	   	VARCHAR(50),
		MontoCredito       	DECIMAL(14,2),
		Resultado	       	DECIMAL(10,2));

	INSERT INTO TMPRESPORCENTUALPROD
	SELECT Pro.Descripcion,SUM(CASE WHEN Mov.NatMovimiento = MovimientoCargo THEN Mov.Cantidad ELSE Decimal_Cero END) -
		SUM(CASE WHEN Mov.NatMovimiento = MovimientoAbono THEN Mov.Cantidad ELSE Decimal_Cero END), Decimal_Cero
        FROM CREDITOSMOVS Mov
        INNER JOIN CREDITOS Cre
			ON Mov.CreditoID = Cre.CreditoID
		INNER JOIN PRODUCTOSCREDITO Pro
			ON Cre.ProductoCreditoID = Pro.ProducCreditoID
        WHERE Mov.FechaAplicacion = Var_FechaAnterior
        AND Mov.TipoMovCreID IN(Mov_CapVen,Mov_CapVNE,Mov_IntVen,Mov_IntMoratoVen,
			Mov_CapOrd, Mov_CapAtr,Mov_IntOrd,Mov_IntAtr,Mov_IntPro,Mov_IntMor)
        AND Pro.Descripcion != 'MULTICREDI'
        GROUP BY Pro.Descripcion;

	UPDATE TMPRESPORCENTUALPROD Tmp
		SET  Resultado = IFNULL((CASE WHEN Var_MontoProdCred = Decimal_Cero THEN Decimal_Cero ELSE (MontoCredito / Var_MontoProdCred) END),Decimal_Cero) * 100;

	DROP TABLE IF EXISTS TMPDIFERENCIA;
	CREATE TEMPORARY TABLE TMPDIFERENCIA(
		NombreProducto	   	VARCHAR(50),
		MontoCredito       	DECIMAL(14,2),
		Porcentaje	       	DECIMAL(10,2),
		Resultado	       	DECIMAL(10,2),
		Diferencia	        DECIMAL(10,2));

	INSERT INTO TMPDIFERENCIA
	SELECT Por.NombreProducto, MontoCredito,Porcentaje, Resultado,Decimal_Cero
		FROM TMPPORCENTAJEPROD Por
		INNER JOIN TMPRESPORCENTUALPROD Res
		WHERE Por.NombreProducto = Res.NombreProducto;

	UPDATE TMPDIFERENCIA Tmp
		SET  Diferencia = Porcentaje - Resultado;

	SELECT NombreProducto, FORMAT(MontoCredito,2) AS MontoCredito, Resultado, Porcentaje, Diferencia
			FROM TMPDIFERENCIA;

	DROP TABLE TMPPORCENTAJEPROD;
	DROP TABLE TMPRESPORCENTUALPROD;
	DROP TABLE TMPDIFERENCIA;
END IF;

-- Reporte: Saldo de Cartera por Producto
IF(Par_NumRep = Rep_SaldoPorProduc) THEN
	DROP TABLE IF EXISTS TMPPORCENTAJEPROD;
	CREATE TEMPORARY TABLE TMPPORCENTAJEPROD(
		NombreProducto	    VARCHAR(50),
		Porcentaje          DECIMAL(10,2));

	INSERT INTO TMPPORCENTAJEPROD
	SELECT Pro.Descripcion, IFNULL(Porcentaje,Decimal_Cero)
		FROM PARAMUACIRIESGOS Par
		INNER JOIN PRODUCTOSCREDITO Pro
			ON Par.ReferenciaID = Pro.ProducCreditoID
		WHERE Par.CatParamRiesgosID = ParamPorProducto
		AND Pro.Descripcion != 'MULTICREDI'
		GROUP BY Pro.Descripcion, Porcentaje;

	DROP TABLE IF EXISTS TMPRESPORCENTUALPROD;
	CREATE TEMPORARY TABLE TMPRESPORCENTUALPROD(
		NombreProducto	   	VARCHAR(50),
		SaldoCredito       	DECIMAL(14,2),
		Resultado	      	DECIMAL(10,2));

	INSERT INTO TMPRESPORCENTUALPROD
	SELECT Pro.Descripcion,SUM(Sal.SalCapVigente + Sal.SalCapAtrasado + Sal.SalIntProvision +
			Sal.SalMoratorios + Sal.SalIntAtrasado + Sal.SalCapVencido + Sal.SalCapVenNoExi + Sal.SalIntVencido +
			Sal.SaldoMoraVencido), Decimal_Cero
        FROM SALDOSCREDITOS Sal
        INNER JOIN CREDITOS Cre
			ON Cre.CreditoID = Sal.CreditoID
        INNER JOIN PRODUCTOSCREDITO Pro
            ON Cre.ProductoCreditoID = Pro.ProducCreditoID
		WHERE Sal.FechaCorte = Var_FechaAnterior
        AND Pro.Descripcion != 'MULTICREDI'
		GROUP BY Pro.Descripcion;

	UPDATE TMPRESPORCENTUALPROD Tmp
		SET  Resultado = IFNULL((CASE WHEN Var_SalTotCartera = Decimal_Cero THEN Decimal_Cero ELSE (SaldoCredito / Var_SalTotCartera) END),Decimal_Cero) * 100;

	DROP TABLE IF EXISTS TMPDIFERENCIA;
	CREATE TEMPORARY TABLE TMPDIFERENCIA(
		NombreProducto	   	VARCHAR(50),
		SaldoCredito       	DECIMAL(18,2),
		Porcentaje	       	DECIMAL(10,2),
		Resultado	       	DECIMAL(10,2),
		Diferencia	        DECIMAL(10,2));

	INSERT INTO TMPDIFERENCIA
	SELECT Por.NombreProducto, SaldoCredito,Porcentaje, Resultado,Decimal_Cero
		FROM TMPPORCENTAJEPROD Por
		INNER JOIN TMPRESPORCENTUALPROD Res
		WHERE Por.NombreProducto = Res.NombreProducto;

	UPDATE TMPDIFERENCIA Tmp
		SET  Diferencia = Porcentaje - Resultado;

	SELECT NombreProducto, FORMAT(SaldoCredito,2) AS SaldoCredito, Resultado, Porcentaje, Diferencia
			FROM TMPDIFERENCIA;

	DROP TABLE TMPPORCENTAJEPROD;
	DROP TABLE TMPRESPORCENTUALPROD;
	DROP TABLE TMPDIFERENCIA;

END IF;


-- Reporte: Creditos por Sucursales en Excel
IF(Par_NumRep = Rep_Excel) THEN
    -- Monto de Cartera Acumulado del Dia Anterior
	DROP TABLE IF EXISTS TMPPORCENTAJEPROD;
	CREATE TEMPORARY TABLE TMPPORCENTAJEPROD(
		NombreProducto	    VARCHAR(50),
		Porcentaje          DECIMAL(10,2));

	INSERT INTO TMPPORCENTAJEPROD
	SELECT Pro.Descripcion, IFNULL(Porcentaje,Decimal_Cero)
		FROM PARAMUACIRIESGOS Par
		INNER JOIN PRODUCTOSCREDITO Pro
			ON Par.ReferenciaID = Pro.ProducCreditoID
		WHERE Par.CatParamRiesgosID = ParamPorProducto
		AND Pro.Descripcion != 'MULTICREDI'
		GROUP BY Pro.Descripcion, Porcentaje;

	DROP TABLE IF EXISTS TMPRESPORCENTUALMONTO;
	CREATE TEMPORARY TABLE TMPRESPORCENTUALMONTO(
		NombreProducto	   	VARCHAR(50),
		MontoCredito        DECIMAL(14,2),
		Resultado	        DECIMAL(10,2));

	INSERT INTO TMPRESPORCENTUALMONTO
	SELECT Pro.Descripcion,SUM(CASE Mov.NatMovimiento WHEN MovimientoCargo THEN Mov.Cantidad ELSE Decimal_Cero END) -
			SUM(CASE Mov.NatMovimiento WHEN MovimientoAbono THEN Mov.Cantidad ELSE Decimal_Cero END),Decimal_Cero
		FROM CREDITOSMOVS Mov
        INNER JOIN CREDITOS Cre
			ON Mov.CreditoID = Cre.CreditoID
		INNER JOIN PRODUCTOSCREDITO Pro
			ON Cre.ProductoCreditoID = Pro.ProducCreditoID
        WHERE Mov.FechaAplicacion = Var_FechaAnterior
        AND Mov.TipoMovCreID IN(Mov_CapVen,Mov_CapVNE,Mov_IntVen,Mov_IntMoratoVen,
			Mov_CapOrd, Mov_CapAtr,Mov_IntOrd,Mov_IntAtr,Mov_IntPro,Mov_IntMor)
        AND Pro.Descripcion != 'MULTICREDI'
        GROUP BY Pro.Descripcion;

	UPDATE TMPRESPORCENTUALMONTO Tmp
		SET  Resultado = IFNULL((CASE WHEN Var_MontoProdCred = Decimal_Cero THEN Decimal_Cero ELSE (MontoCredito / Var_MontoProdCred) END),Decimal_Cero) * 100;

	DROP TABLE IF EXISTS TMPDIFERENCIAMONTO;
	CREATE TEMPORARY TABLE TMPDIFERENCIAMONTO(
		NombreProducto	   	VARCHAR(50),
		MontoCredito       	DECIMAL(14,2),
		Porcentaje	       	DECIMAL(10,2),
		Resultado	       	DECIMAL(10,2),
		Diferencia	        DECIMAL(10,2));

	INSERT INTO TMPDIFERENCIAMONTO
	SELECT Por.NombreProducto, MontoCredito,Porcentaje, Resultado,Decimal_Cero
		FROM TMPPORCENTAJEPROD Por
		INNER JOIN TMPRESPORCENTUALMONTO Res
		WHERE Por.NombreProducto = Res.NombreProducto;

	UPDATE TMPDIFERENCIAMONTO Tmp
		SET  Diferencia = Porcentaje - Resultado;

	DROP TABLE IF EXISTS TMPMONTOPRODUCTOS;
	CREATE TEMPORARY TABLE TMPMONTOPRODUCTOS(
		NombreProducto	   	VARCHAR(50),
		MontoCredito       	DECIMAL(14,2),
		ResultadoMonto	   	DECIMAL(10,2),
		PorcentajeMonto	  	DECIMAL(10,2),
		DiferenciaMonto	  	DECIMAL(10,2));

	INSERT INTO TMPMONTOPRODUCTOS
	SELECT NombreProducto, MontoCredito, Resultado, Porcentaje, Diferencia
			FROM TMPDIFERENCIAMONTO;

    -- Saldo de Cartera Acumulado al Dia Anterior
	DROP TABLE IF EXISTS TMPRESPORCENTUALSALDO;
	CREATE TEMPORARY TABLE TMPRESPORCENTUALSALDO(
		NombreProducto	   	VARCHAR(50),
		SaldoCredito       	DECIMAL(14,2),
		Resultado	      	DECIMAL(10,2));

	INSERT INTO TMPRESPORCENTUALSALDO
	SELECT Pro.Descripcion,SUM(Sal.SalCapVigente + Sal.SalCapAtrasado + Sal.SalIntProvision +
			Sal.SalMoratorios + Sal.SalIntAtrasado + Sal.SalCapVencido + Sal.SalCapVenNoExi + Sal.SalIntVencido +
			Sal.SaldoMoraVencido), Decimal_Cero
		 FROM SALDOSCREDITOS Sal
        INNER JOIN CREDITOS Cre
			ON Cre.CreditoID = Sal.CreditoID
        INNER JOIN PRODUCTOSCREDITO Pro
            ON Cre.ProductoCreditoID = Pro.ProducCreditoID
		WHERE Sal.FechaCorte = Var_FechaAnterior
        AND Pro.Descripcion != 'MULTICREDI'
		GROUP BY Pro.Descripcion;

	UPDATE TMPRESPORCENTUALSALDO Tmp
		SET  Resultado = IFNULL((CASE WHEN Var_SalTotCartera = Decimal_Cero THEN Decimal_Cero ELSE (SaldoCredito / Var_SalTotCartera) END),Decimal_Cero) * 100;

	DROP TABLE IF EXISTS TMPDIFERENCIASALDO;
	CREATE TEMPORARY TABLE TMPDIFERENCIASALDO(
		NombreProducto	   	VARCHAR(50),
		SaldoCredito       	DECIMAL(14,2),
		Porcentaje	       	DECIMAL(10,2),
		Resultado	       	DECIMAL(10,2),
		Diferencia	        DECIMAL(10,2));

	INSERT INTO TMPDIFERENCIASALDO
	SELECT Por.NombreProducto, SaldoCredito,Porcentaje, Resultado,Decimal_Cero
		FROM TMPPORCENTAJEPROD Por
		INNER JOIN TMPRESPORCENTUALSALDO Res
		WHERE Por.NombreProducto = Res.NombreProducto;

	UPDATE TMPDIFERENCIASALDO Tmp
		SET  Diferencia = Porcentaje - Resultado;

	DROP TABLE IF EXISTS TMPSALDOPRODUCTOS;
	CREATE TEMPORARY TABLE TMPSALDOPRODUCTOS(
		NombreProducto	   	VARCHAR(50),
		SaldoCredito       	DECIMAL(14,2),
		ResultadoSaldo	   	DECIMAL(10,2),
		PorcentajeSaldo	  	DECIMAL(10,2),
		DiferenciaSaldo	  	DECIMAL(10,2));

	INSERT INTO TMPSALDOPRODUCTOS
	SELECT NombreProducto, SaldoCredito, Resultado, Porcentaje, Diferencia
			FROM TMPDIFERENCIASALDO;

	SELECT Mon.NombreProducto, 		Mon.MontoCredito, 	Mon.ResultadoMonto,  Mon.PorcentajeMonto,
			Mon.DiferenciaMonto,	Sal.SaldoCredito, 	Sal.ResultadoSaldo,	 Sal.PorcentajeSaldo,
            Sal.DiferenciaSaldo
	FROM TMPMONTOPRODUCTOS Mon
	INNER JOIN TMPSALDOPRODUCTOS Sal
			WHERE Mon.NombreProducto = Sal.NombreProducto;

	DROP TABLE TMPPORCENTAJEPROD;
	DROP TABLE TMPRESPORCENTUALMONTO;
	DROP TABLE TMPDIFERENCIAMONTO;
	DROP TABLE TMPMONTOPRODUCTOS;
	DROP TABLE TMPRESPORCENTUALSALDO;
	DROP TABLE TMPDIFERENCIASALDO;
	DROP TABLE TMPSALDOPRODUCTOS;

END IF;

END TerminaStore$$