-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOSMAYOR10PORCREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOSMAYOR10PORCREP`;DELIMITER $$

CREATE PROCEDURE `CREDITOSMAYOR10PORCREP`(
	-- SP para generar el reporte de mayor saldo insoluto 10 %
	Par_Anio			INT(11),			-- Anio para generar informacion del reporte
	Par_Mes				INT(11),			-- Mes para generar informacion del reporte
	Par_NumRep			TINYINT UNSIGNED,   -- Numero de Reporte

	Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion	BIGINT
)
TerminaStore: BEGIN

-- Declaracion de Variables.
DECLARE Var_IniMes				DATE;				-- Inicio de mes
DECLARE Var_FinMes				DATE;				-- Fin de mes
DECLARE Var_PorCred10Porc     	DECIMAL(10,2);	 	-- Porcentaje Creditos Mayor Saldo Insoluto 10 %
DECLARE Var_Resultado      		DECIMAL(14,2);   	-- Resultado sobre el 10% de la Cartera Total * 10 % (Parametro  de Porcentaje)
DECLARE Var_DifLimEsta   		DECIMAL(10,2);       -- Diferencia entre el Parametro (Creditos Mayor Saldo Insoluto 10 %) y el Resultado Porcentual

DECLARE Var_SalCapVig			DECIMAL(14,2);		-- Saldo Capital Credito Vigente
DECLARE Var_SalCapAtr       	DECIMAL(14,2);		-- Saldo Capital Credito Atrasado
DECLARE	Var_SalIntVig			DECIMAL(14,2);		-- Saldo Capital Credito Atrasado
DECLARE Var_SalIntAtr			DECIMAL(14,2);		-- Saldo Interes Credito Atrasado
DECLARE Var_SalCapVen   		DECIMAL(14,2);		-- Saldo Capital Credito Vencido

DECLARE Var_SalIntVen   		DECIMAL(14,2);		-- Saldo Interes Credito Vencido
DECLARE Var_SalTotCarVig    	DECIMAL(14,2);	    -- Saldo Total Credito Vigente
DECLARE Var_SalTotCarVen    	DECIMAL(14,2);	    -- Saldo Total Credito Vencido
DECLARE Var_SaldoTotCartera 	DECIMAL(14,2);	    -- Saldo Total de la Cartera de Credito
DECLARE Var_TotSaldoInsoluto 	DECIMAL(14,2);      -- Total Saldo Insoluto

DECLARE Var_DifLimite           DECIMAL(12,2);		-- Resultado sobre el 10% de la Cartera Total - Total Saldo Insoluto

-- Declaracion de Constantes
DECLARE Cadena_Vacia	CHAR(1);
DECLARE Fecha_Vacia		DATE;
DECLARE Entero_Cero		INT(11);
DECLARE Decimal_Cero	INT(11);
DECLARE ParamCred10Porc INT(11);
DECLARE EstatusVigente  CHAR(1);
DECLARE EstatusVencida  CHAR(1);
DECLARE Rep_Principal   INT(11);
DECLARE Rep_Parametro   INT(11);


-- Asignacion de Constantes
SET Cadena_Vacia		:= '';    				-- Cadena Vacia
SET Fecha_Vacia			:= '1900-01-01';		-- Fecha Vacia
SET Entero_Cero			:= 0;					-- Entero Cero
SET Decimal_Cero		:= 0.0;					-- Decimal Cero
SET ParamCred10Porc     := 13;                  -- CatParamRiesgosID: Parametro Creditos Mayor Saldo Insoluto 10 %
SET EstatusVigente      := 'V';					-- Estatus Credito: Vigente
SET EstatusVencida      := 'B';					-- Estatus Credito: Vencido
SET Rep_Principal       := 1;					-- Tipo Reporte: Mayor Saldo Insoluto
SET Rep_Parametro       := 2;					-- Tipo Reporte: Consulta Parametro 10 %


SET Var_IniMes			:= CONVERT(CONCAT(CONVERT(Par_Anio, CHAR), "-", CONVERT(Par_Mes, CHAR), "-01"), DATE);
SET Var_FinMes			:= DATE_ADD(DATE_ADD(Var_IniMes, INTERVAL 1 MONTH), INTERVAL -1 DAY);
SET Var_PorCred10Porc   := (SELECT Porcentaje FROM PARAMUACIRIESGOS WHERE CatParamRiesgosID = ParamCred10Porc);
SET Var_PorCred10Porc   := IFNULL(Var_PorCred10Porc,Decimal_Cero);

-- ============ Saldo Total de la Cartera de Credito Vigente y Vencida  del Dia Anterior ======================
SELECT	SUM(SalCapVigente),						SUM(SalCapAtrasado),
		SUM(SalIntProvision + SalMoratorios),	SUM(SalIntAtrasado),
		SUM(SalCapVencido + SalCapVenNoExi), 	SUM(SalIntVencido + SaldoMoraVencido)
	INTO Var_SalCapVig,		Var_SalCapAtr,		Var_SalIntVig,
		 Var_SalIntAtr,		Var_SalCapVen,		Var_SalIntVen
	FROM SALDOSCREDITOS
			WHERE FechaCorte = Var_FinMes;

SET	Var_SalCapVig	:= IFNULL(Var_SalCapVig,Decimal_Cero);
SET Var_SalCapAtr	:= IFNULL(Var_SalCapAtr,Decimal_Cero);
SET Var_SalIntVig	:= IFNULL(Var_SalIntVig,Decimal_Cero);
SET Var_SalIntAtr	:= IFNULL(Var_SalIntAtr,Decimal_Cero);
SET Var_SalCapVen	:= IFNULL(Var_SalCapVen,Decimal_Cero);
SET Var_SalIntVen	:= IFNULL(Var_SalIntVen,Decimal_Cero);


SET Var_SalTotCarVig    := Var_SalCapVig + Var_SalCapAtr + Var_SalIntVig + Var_SalIntAtr;
SET Var_SalTotCarVig	:= IFNULL(Var_SalTotCarVig,Decimal_Cero);

SET Var_SalTotCarVen    := Var_SalCapVen + Var_SalIntVen;
SET Var_SalTotCarVen	:= IFNULL(Var_SalTotCarVen,Decimal_Cero);

SET Var_SaldoTotCartera  := Var_SalTotCarVig + Var_SalTotCarVen;
SET Var_SaldoTotCartera  := IFNULL(Var_SaldoTotCartera,Decimal_Cero);

-- Mayor Saldo Insoluto 20 Creditos (Grid)
IF(Par_NumRep = Rep_Principal) THEN
	SELECT Cre.ClienteID,Cre.CreditoID, SUM(Sal.SalCapVigente + Sal.SalCapAtrasado + Sal.SalCapVencido +
						Sal.SalCapVenNoExi + Sal.SalIntOrdinario + Sal.SalIntProvision +
						Sal.SalIntAtrasado + Sal.SalIntVencido +
						Sal.SalMoratorios +	Sal.SaldoMoraVencido) AS SaldoInsoluto,
						Cre.SucursalID,Var_SaldoTotCartera, Var_PorCred10Porc
		FROM SALDOSCREDITOS Sal
			LEFT JOIN CREDITOS Cre
				ON Cre.CreditoID = Sal.CreditoID
			AND Sal.EstatusCredito IN(EstatusVigente,EstatusVencida)
			WHERE Sal.FechaCorte = Var_FinMes
			 GROUP BY Cre.CreditoID, Cre.ClienteID, Cre.SucursalID
			 ORDER BY SaldoInsoluto DESC
		LIMIT 20;
END IF;

-- Consulta Parametro Mayor Saldo Insoluto 10 %
IF(Par_NumRep = Rep_Parametro) THEN
	DROP TABLE IF EXISTS TMPCREDITOSMAYORSALDOINS;
	CREATE TEMPORARY TABLE TMPCREDITOSMAYORSALDOINS(
			ClienteID		   INT(11),
            CreditoID          BIGINT(12),
			SaldoInsoluto      DECIMAL(12,2),
			SucursalID         INT(11),
			SaldoCartera       DECIMAL(12,2),
		    Porcentaje   	   DECIMAL(10,2));

	INSERT INTO TMPCREDITOSMAYORSALDOINS()
	SELECT Cre.ClienteID,Cre.CreditoID, SUM(Sal.SalCapVigente + Sal.SalCapAtrasado + Sal.SalCapVencido +
						Sal.SalCapVenNoExi + Sal.SalIntOrdinario + Sal.SalIntProvision +
						Sal.SalIntAtrasado + Sal.SalIntVencido +
						Sal.SalMoratorios +	Sal.SaldoMoraVencido)AS SaldoInsoluto,
						Cre.SucursalID,Var_SaldoTotCartera, Var_PorCred10Porc
		FROM SALDOSCREDITOS Sal
			LEFT JOIN CREDITOS Cre
				ON Cre.CreditoID = Sal.CreditoID
			AND Sal.EstatusCredito IN(EstatusVigente,EstatusVencida)
			WHERE Sal.FechaCorte = Var_FinMes
			 GROUP BY Cre.CreditoID,  Cre.ClienteID, Cre.SucursalID
			 ORDER BY SaldoInsoluto DESC
		LIMIT 20;

	SELECT SUM(SaldoInsoluto) INTO Var_TotSaldoInsoluto FROM TMPCREDITOSMAYORSALDOINS;

	SET Var_Resultado   := (Var_SaldoTotCartera * (Var_PorCred10Porc /100));
	SET Var_Resultado	:= IFNULL(Var_Resultado,Decimal_Cero);

	SET Var_DifLimite   := (CASE WHEN Var_Resultado = Decimal_Cero THEN Decimal_Cero ELSE (Var_TotSaldoInsoluto / Var_Resultado) END) * 100;
	SET Var_DifLimite	:= IFNULL(Var_DifLimite,Decimal_Cero);


	SELECT 	Var_TotSaldoInsoluto,	Var_SaldoTotCartera, 	Var_Resultado,
			Var_PorCred10Porc, 		Var_DifLimite;

	DROP TABLE TMPCREDITOSMAYORSALDOINS;
END IF;
END TerminaStore$$