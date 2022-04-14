-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASMOVREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASMOVREP`;DELIMITER $$

CREATE PROCEDURE `CUENTASMOVREP`(
	Par_CuentaAhoID			BIGINT(12),
	Par_Mes					INT,
	Par_Anio				INT,
	Par_NumRep				TINYINT UNSIGNED,
    /* Parametros de Auditoria */
	Aud_EmpresaID			INT(11),

	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),

	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

DECLARE Rep_CueMov			INT;
DECLARE Rep_CueMovHis		INT;
DECLARE Decimal_Cero		DECIMAL(12,2);
DECLARE Var_SumPenAct		DECIMAL(12,2);
DECLARE Var_SaldoPromMesAnt	DECIMAL(12,2);


DECLARE	SaldoDisp			FLOAT;
DECLARE	MonedaCon			INT;
DECLARE	Cliente				INT;
DECLARE	EstatusC			CHAR(1);
DECLARE	Var_FechaSisIni 	DATE;
DECLARE	Var_FechaSis	 	DATE;
DECLARE	Var_FechaIni 		CHAR(16);
DECLARE	Var_FechaInicial 	DATE;
DECLARE	Var_FechaFinal 		DATE;
DECLARE	Var_FechaIniAnt 	DATE;
DECLARE	Var_FechaFinAnt		DATE;

SET	Rep_CueMov		:= 1;
SET	Rep_CueMovHis	:= 2;
SET Decimal_Cero 	:= 0.0;


SET	SaldoDisp		:= 0.0;
SET Var_FechaSis 	:= (SELECT FechaSistema FROM PARAMETROSSIS);

SET Var_FechaSisIni	:= CONVERT(DATE_ADD(Var_FechaSis, INTERVAL -1*(DAY(Var_FechaSis))+1 DAY),CHAR(12));


SET Var_FechaIni		:= CONCAT(Par_Anio,'-', Par_Mes,'-','01');
SET Var_FechaInicial 	:= DATE_FORMAT(Var_FechaIni, '%Y-%m-%d');
SET Var_FechaFinal 		:= LAST_DAY(Var_FechaInicial);

/* fecha del mes anterior*/
SET Var_FechaIniAnt := DATE_ADD(Var_FechaInicial, INTERVAL -1 MONTH);
SET Var_FechaFinAnt := DATE_ADD(Var_FechaFinal, INTERVAL -1 MONTH);

SELECT
	CASE WHEN Cli.PagaIVA = 'S' THEN SUM(Pen.CantPenAct)+SUM(Pen.CantPenAct* Suc.IVA)
		ELSE SUM(Pen.CantPenAct)
	END AS CantPenAct
	INTO 	Var_SumPenAct
	FROM 	COBROSPEND Pen,
			CLIENTES Cli,
			SUCURSALES Suc
	WHERE	Pen.CuentaAhoID = Par_CuentaAhoID
	AND 	Pen.ClienteID 	= Cli.ClienteID
	AND		Suc.SucursalID	= Cli.SucursalOrigen
    GROUP BY Cli.PagaIVA;

CALL SALDOSAHORROCON(Cliente,SaldoDisp,MonedaCon,EstatusC,Par_CuentaAhoID);
SET Var_SumPenAct := IFNULL(Var_SumPenAct,0.00);
/* SE OBTIENE EL SALDO PROMEDIO DEL MES ANTERIOR */
SET Var_SaldoPromMesAnt := (SELECT IFNULL(hcta.SaldoProm,Decimal_Cero)
			FROM `HIS-CUENTASAHO` hcta
			WHERE hcta.CuentaAhoID = Par_CuentaAhoID
				AND hcta.Fecha >= Var_FechaIniAnt
				AND hcta.Fecha <= Var_FechaFinAnt);
SET Var_SaldoPromMesAnt := IFNULL(Var_SaldoPromMesAnt,Decimal_Cero);

IF(Par_NumRep = Rep_CueMov) THEN

	SELECT	LPAD(CONVERT(CA.CuentaAhoID, CHAR),11,'0') AS CuentaAhoID,	 LPAD(CONVERT(CA.ClienteID, CHAR),10,'0') AS ClienteID,
			CL.NombreCompleto,	CA.TipoCuentaID,     		TC.Descripcion AS DescripcionTC,
			CA.MonedaID,		MO.Descripcion AS DescripcionMo,
			CONCAT(FORMAT(CA.SaldoIniMes,2)) AS SaldoIniMes,	CONCAT(FORMAT(CA.CargosMes,2))AS CargosMes,
			CONCAT(FORMAT(CA.AbonosMes,2)) AS AbonosMes,
			CONCAT(FORMAT(CA.SaldoIniDia,2)) AS SaldoIniDia,	CONCAT(FORMAT(CA.CargosDia,2)) AS CargosDia,
			CONCAT(FORMAT(CA.AbonosDia,2)) AS AbonosDia, CONCAT(FORMAT(CA.Saldo,2)) AS Saldo,
			CONCAT(FORMAT(CA.SaldoDispon,2)) AS SaldoDispon,	CONCAT(FORMAT(CA.SaldoBloq,2)) AS SaldoBloq,
			CONCAT(FORMAT(CA.SaldoSBC,2)) AS SaldoSBC, 	Var_FechaSisIni, CONVERT(FORMAT(CA.SaldoProm,2),CHAR) AS SaldoProm,Var_SumPenAct,
			CA.Gat, IFNULL(CA.GatReal,Decimal_Cero) AS GatReal
	FROM 	CUENTASAHO 	CA,
			CLIENTES	  	CL,
			TIPOSCUENTAS TC,
			MONEDAS	  	MO
	WHERE 	CA.CuentaAhoID	= Par_CuentaAhoID
	AND		TC.TipoCuentaID	= CA.TipoCuentaID
	AND		CL.ClienteID	  	= CA.ClienteID
	AND 	 	MO.MonedaID		= CA.MonedaID LIMIT 1;

END IF;


IF(Par_NumRep = Rep_CueMovHis) THEN

	SELECT	LPAD(CONVERT(CA.CuentaAhoID, CHAR),11,'0') AS CuentaAhoID,	 LPAD(CONVERT(CA.ClienteID, CHAR),10,'0') AS ClienteID,
			CL.NombreCompleto,	CA.TipoCuentaID,     		TC.Descripcion AS DescripcionTC,
			CA.MonedaID,		MO.Descripcion AS DescripcionMo,
			IFNULL(FORMAT(CA.SaldoIniMes,2),Decimal_Cero) AS SaldoIniMes,	CONCAT(FORMAT(CA.CargosMes,2))AS CargosMes,
			CONCAT(FORMAT(CA.AbonosMes,2)) AS AbonosMes,
			IFNULL(FORMAT(CA.SaldoIniDia,2),Decimal_Cero) AS SaldoIniDia,	CONCAT(FORMAT(CA.CargosDia,2)) AS CargosDia,
			CONCAT(FORMAT(CA.AbonosDia,2)) AS AbonosDia, IFNULL(FORMAT(CA.Saldo,2),Decimal_Cero) AS Saldo,
			CONCAT(FORMAT(CA.SaldoDispon,2)) AS SaldoDispon,	IFNULL(FORMAT(CA.SaldoBloq,2),Decimal_Cero) AS SaldoBloq,
			IFNULL(FORMAT(CA.SaldoSBC,2),Decimal_Cero) AS SaldoSBC, Var_FechaSisIni,CONVERT(FORMAT(CA.SaldoProm,2),CHAR) AS SaldoProm,Var_SumPenAct,
			CA.Gat, IFNULL(CA.GatReal,Decimal_Cero) AS GatReal
	FROM 	`HIS-CUENTASAHO` 	CA,
			CLIENTES	  	CL,
			TIPOSCUENTAS TC,
			MONEDAS	  	MO
	WHERE 	CA.CuentaAhoID	= Par_CuentaAhoID
	AND		TC.TipoCuentaID	= CA.TipoCuentaID
	AND		CL.ClienteID	  	= CA.ClienteID
	AND 	 	MO.MonedaID		= CA.MonedaID
	AND 		CA.Fecha >= CONCAT(Par_Anio,'-', Par_Mes,'-','01')
	AND 		CA.Fecha <= LAST_DAY(CONCAT(Par_Anio,'-', Par_Mes,'-','01')) LIMIT 1;

END IF;

END TerminaStore$$