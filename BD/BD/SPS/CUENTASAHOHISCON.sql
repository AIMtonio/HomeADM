-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASAHOHISCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASAHOHISCON`;

DELIMITER $$
CREATE PROCEDURE `CUENTASAHOHISCON`(
	Par_CuentaAhoID		BIGINT(12),
	Par_ClienteID		INT(11),
	Par_Mes				INT(11),
	Par_Anio			INT(11),
	Par_NumCon			TINYINT UNSIGNED,

	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT
)
TerminaStore: BEGIN


	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Fecha_Vacia			date;
	DECLARE Entero_Cero			INT(11);
	DECLARE Con_SaldoDispHis	INT(11);
	DECLARE Con_SaldosHis		INT(11);
	DECLARE Con_SaldosHisWS		INT(11);
	DECLARE Decimal_Cero		DECIMAL(12,2);

	DECLARE Var_SumPenAct	DECIMAL(12,2);
	DECLARE Var_CuentaAhoID	BIGINT(12);
	DECLARE Var_ClienteID	INT(11);
	DECLARE Var_Saldo		DECIMAL(12,2);
	DECLARE Var_SaldoDispon	DECIMAL(12,2);
	DECLARE Var_SaldoSBC	DECIMAL(12,2);
	DECLARE Var_SaldoBloq	DECIMAL(12,2);

	DECLARE Var_SaldoIniMes	DECIMAL(12,2);
	DECLARE Var_CargosMes	DECIMAL(12,2);
	DECLARE Var_AbonosMes	DECIMAL(12,2);
	DECLARE Var_SaldoIniDia	DECIMAL(12,2);
	DECLARE Var_CargosDia	DECIMAL(12,2);
	DECLARE Var_AbonosDia	DECIMAL(12,2);
	DECLARE Var_Gat			DECIMAL(12,2);
	DECLARE Var_GatReal		DECIMAL(12,2);
	DECLARE Var_SaldoProm	DECIMAL(12,2);

	DECLARE Var_MonedaID	INT(11);
	DECLARE Var_DescriCorta	VARCHAR(300);
	DECLARE Var_Estatus		CHAR(1);



	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Con_SaldoDispHis	:= 12;
	SET	Con_SaldosHis		:= 13;
	SET Con_SaldosHisWS		:= 22;
	SET Decimal_Cero		:= 0.00;



	IF(Par_NumCon = Con_SaldoDispHis) THEN
		SELECT SUM(	CASE WHEN Cli.PagaIVA = 'S' THEN IFNULL(Pen.CantPenAct , Entero_Cero) + (IFNULL(Pen.CantPenAct, Entero_Cero)* Suc.IVA) ELSE IFNULL(Pen.CantPenAct,Entero_Cero) END) AS CantPenAct
			INTO 	Var_SumPenAct
			FROM 	COBROSPEND Pen,
					CLIENTES Cli,
					SUCURSALES Suc
			WHERE	Pen.CuentaAhoID = Par_CuentaAhoID
			AND 	Pen.ClienteID 	= Cli.ClienteID
			AND	    Suc.SucursalID	= Cli.SucursalOrigen

			 AND 	Pen.Fecha >= CONCAT(Par_Anio,'-', Par_Mes,'-','01')
			 AND 	Pen.Fecha <= LAST_DAY(CONCAT(Par_Anio,'-', Par_Mes,'-','01'));

		SELECT 	HC.CuentaAhoID,
				ClienteID,
				IFNULL(Saldo,Entero_Cero),
				IFNULL(SaldoDispon,Entero_Cero),
				IFNULL(SaldoSBC,Entero_Cero),

				IFNULL(SaldoBloq,Entero_Cero),
				HC.MonedaID,		DescriCorta,		Estatus,		Gat,				SaldoProm,
				GatReal
		INTO	Var_CuentaAhoID,	Var_ClienteID,	Var_Saldo,			Var_SaldoDispon,	Var_SaldoSBC,
				Var_SaldoBloq,		Var_MonedaID,	Var_DescriCorta,	Var_Estatus,		Var_Gat,
				Var_SaldoProm,		Var_GatReal
			FROM 	`HIS-CUENTASAHO` HC,
					MONEDAS MO
			WHERE	HC.CuentaAhoID	  =	Par_CuentaAhoID
			AND 		HC.MonedaID = MO.MonedaId
			AND 		HC.Fecha >= CONCAT(Par_Anio,'-', Par_Mes,'-','01')
			AND 		HC.Fecha <= LAST_DAY(CONCAT(Par_Anio,'-', Par_Mes,'-','01'));

		SET Var_SumPenAct 	:= IFNULL(Var_SumPenAct,0);
		SET Var_CuentaAhoID	:= IFNULL(Var_CuentaAhoID,Par_CuentaAhoID);
		SET Var_ClienteID	:= IFNULL(Var_ClienteID,(SELECT ClienteID FROM CUENTASAHO WHERE CuentaAhoID = Par_CuentaAhoID));


		SELECT	Var_CuentaAhoID,					Var_ClienteID,								FORMAT(IFNULL(Var_Saldo,0),2),	FORMAT(IFNULL(Var_SaldoDispon,0),2),	FORMAT(IFNULL(Var_SaldoSBC,0),2),
				FORMAT(IFNULL(Var_SaldoBloq,0),2),	IFNULL(Var_MonedaID,1)AS Var_MonedaID,		IFNULL(Var_DescriCorta,'MXN'),		Var_Estatus,				Var_SumPenAct,	IFNULL(Var_Gat,Decimal_Cero) AS Gat,
				FORMAT(IFNULL(Var_SaldoProm,0),2) AS SaldoProm,	IFNULL(Var_GatReal,Decimal_Cero) AS GatReal;
	END IF;


	IF(Par_NumCon = Con_SaldosHis) THEN
		SELECT SUM(	CASE WHEN Cli.PagaIVA = 'S' THEN IFNULL(Pen.CantPenAct , Entero_Cero) + (IFNULL(Pen.CantPenAct, Entero_Cero)* Suc.IVA) ELSE IFNULL(Pen.CantPenAct,Entero_Cero) END) AS CantPenAct
			INTO 	Var_SumPenAct
			FROM 	COBROSPEND Pen,
					CLIENTES Cli,
					SUCURSALES Suc
			WHERE	Pen.CuentaAhoID = Par_CuentaAhoID
		 	AND 	Pen.ClienteID 	= Cli.ClienteID
			AND		Suc.SucursalID	= Cli.SucursalOrigen
			AND 	Fecha >= CONCAT(Par_Anio,'-', Par_Mes,'-','01')
			AND 	Fecha <= LAST_DAY(CONCAT(Par_Anio,'-', Par_Mes,'-','01'));

		SELECT 	HC.CuentaAhoID,	 			ClienteID ,			MonedaID,
				IFNULL(SaldoIniMes,Entero_Cero) AS SaldoIniMes,
				IFNULL(CargosMes,Entero_Cero) AS CargoMes,
				IFNULL(AbonosMes,Entero_Cero) AS AbonosMes,
				IFNULL(SaldoIniDia,Entero_Cero) AS SaldoIniDia,
				IFNULL(CargosDia,Entero_Cero) AS CargosDia,
				IFNULL(AbonosDia,Entero_Cero) AS AbonosDia,
				Gat,		SaldoProm
		INTO	Var_CuentaAhoID,	Var_ClienteID,		Var_MonedaID,		Var_SaldoIniMes,	Var_CargosMes,
				Var_AbonosMes,		Var_SaldoIniDia,	Var_CargosDia,		Var_AbonosDia,		Var_Gat,
				Var_SaldoProm
			FROM 	`HIS-CUENTASAHO` HC
			WHERE	HC.CuentaAhoID	  =	Par_CuentaAhoID
			AND 		HC.Fecha >= CONCAT(Par_Anio,'-', Par_Mes,'-','01')
			AND 		HC.Fecha <= LAST_DAY(CONCAT(Par_Anio,'-', Par_Mes,'-','01'));


		SET Var_SumPenAct 	:= IFNULL(Var_SumPenAct,0);
		SET Var_CuentaAhoID	:= IFNULL(Var_CuentaAhoID,Par_CuentaAhoID);
		SET Var_ClienteID	:= IFNULL(Var_ClienteID,(SELECT ClienteID FROM CUENTASAHO WHERE CuentaAhoID = Par_CuentaAhoID));

		SELECT	Var_CuentaAhoID AS CuentaAhoID,		Var_ClienteID AS ClienteID,		IFNULL(Var_MonedaID,1) AS MonedaID,		FORMAT(IFNULL(Var_SaldoIniMes,0),2) AS SaldoIniMes,	FORMAT(IFNULL(Var_CargosMes,0),2) AS CargoMes,
				FORMAT(IFNULL(Var_AbonosMes,0),2) AS AbonosMes,		FORMAT(IFNULL(Var_SaldoIniDia,0),2) AS SaldoIniDia,	FORMAT(IFNULL(Var_CargosDia,0),2) AS CargosDia,		FORMAT(IFNULL(Var_AbonosDia,0),2) AS AbonosDia,
				Var_SumPenAct,	Var_Gat AS Gat, FORMAT(IFNULL(Var_SaldoProm,0),2) AS SaldoProm;
	END IF;

	IF(Par_NumCon = Con_SaldosHisWS) THEN
		SELECT SUM(	CASE WHEN Cli.PagaIVA = 'S' THEN IFNULL(Pen.CantPenAct , Entero_Cero) + (IFNULL(Pen.CantPenAct, Entero_Cero)* Suc.IVA) ELSE IFNULL(Pen.CantPenAct,Entero_Cero) END) AS CantPenAct

			INTO 	Var_SumPenAct
			FROM 	COBROSPEND Pen,
					CLIENTES Cli,
					SUCURSALES Suc
			WHERE	Pen.CuentaAhoID = Par_CuentaAhoID
			AND 	Pen.ClienteID 	= Cli.ClienteID
			AND		Suc.SucursalID	= Cli.SucursalOrigen
			AND 	Fecha >= CONCAT(Par_Anio,'-', Par_Mes,'-','01')
			AND 	Fecha <= LAST_DAY(CONCAT(Par_Anio,'-', Par_Mes,'-','01'));

		SELECT 	CuentaAhoID,	ClienteID,
			FORMAT(IFNULL(Saldo,0),2) AS Saldo,
			FORMAT(IFNULL(SaldoDispon,0),2) AS SaldoDisp,
			FORMAT(IFNULL(SaldoSBC,0),2) AS SaldoSBC,
			FORMAT(IFNULL(SaldoBloq,0),2) AS SaldoBloqueado,
			HC.MonedaID,DescriCorta,		HC.Estatus,
			FORMAT(IFNULL(SaldoIniMes,0),2) AS SaldoIniMes,
			FORMAT(IFNULL(CargosMes,0),2) AS CargoMes,
			FORMAT(IFNULL(AbonosMes,0),2) AS AbonosMes,
			FORMAT(IFNULL(SaldoIniDia,0),2) AS SaldoIniDia,
			FORMAT(IFNULL(CargosDia,0),2) AS CargosDia,
			FORMAT(IFNULL(AbonosDia,0),2) AS AbonosDia,
			FORMAT(IFNULL(Var_SumPenAct,0),2) AS Var_SumPenAct,
			tc.Descripcion AS TipoCuenta

		FROM 	`HIS-CUENTASAHO` HC INNER JOIN TIPOSCUENTAS tc on HC.TipoCuentaID=tc.TipoCuentaID,
		MONEDAS		mon
		WHERE	CuentaAhoID	  	= Par_CuentaAhoID
		AND	mon.MonedaId 	= HC.MonedaID

		AND 		HC.Fecha >= CONCAT(Par_Anio,'-', Par_Mes,'-','01')
		AND 		HC.Fecha <= LAST_DAY(CONCAT(Par_Anio,'-', Par_Mes,'-','01'));



	END IF;



END TerminaStore$$