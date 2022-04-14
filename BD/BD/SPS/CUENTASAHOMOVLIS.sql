-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASAHOMOVLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASAHOMOVLIS`;
DELIMITER $$

CREATE PROCEDURE `CUENTASAHOMOVLIS`(
	Par_CuentaAhoID		BIGINT(12),
	Par_Mes				INT,
	Par_Anio			INT,
	Par_NumLis			TINYINT UNSIGNED,

	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
	)
TerminaStore: BEGIN


/* DECLARACION DE CONSTANTES*/
DECLARE	Nat_Cargo			CHAR(1);
DECLARE	Cadena_Vacia		CHAR(1);
DECLARE	Decimal_Cero		DECIMAL(12,2);
DECLARE	Nat_Abono			CHAR(1);
DECLARE	Lis_Principal 		INT;
DECLARE	Lis_PrincipalHis 	INT;
DECLARE Lis_MovCtasInu		INT;
DECLARE DesCargo			VARCHAR(5);
DECLARE DesAbono			VARCHAR(5);
DECLARE Fecha_Vacia			DATE;

/* DECLARACION DE VARIABLES*/
DECLARE	SaldoDisp			DECIMAL(12,2);
DECLARE	Var_ClienteID 		INT;
DECLARE	Movimiento			CHAR(1);
DECLARE	NumeroMov			INT;
DECLARE	VarFecha			DATE;
DECLARE	VarMovimiento		CHAR(1);
DECLARE	VarDescripcion		VARCHAR(150);
DECLARE	VarCantidadMov		DECIMAL(12,2);
DECLARE	VarReferenciaMov	VARCHAR(50);
DECLARE	VarSaldo			DECIMAL(12,2);
DECLARE	Var_FechaSistema	DATE;
DECLARE	Var_FechaIni 		CHAR(16);
DECLARE	Var_FechaInicial 	DATE;
DECLARE	Var_FechaFinal 		DATE;
DECLARE	Var_FechaSis	 	DATE;
DECLARE	Var_FechaSisIni 	DATE;
DECLARE SaldoIniMesMov		DECIMAL(12,2);
DECLARE SaldoIniMesHis		DECIMAL(12,2);
DECLARE Var_FechaDeteccion	DATE;			-- Fecha de deteccion de operacion inusual --


/* ASIGNACION DE VARIABLES*/
SET	SaldoDisp		:= 0.0;
SET	Movimiento		:= '';
SET	NumeroMov		:= 0;
SET VarSaldo		:= 0;

SELECT FechaSistema INTO Var_FechaSistema FROM  PARAMETROSSIS;
SET Var_FechaIni		:= CONCAT(Par_Anio,'-', Par_Mes,'-','01');
SET Var_FechaInicial 	:= DATE_FORMAT(Var_FechaIni, '%Y-%m-%d');
SET Var_FechaFinal 		:= LAST_DAY(Var_FechaInicial);
SET Var_FechaSis 		:= (SELECT FechaSistema FROM PARAMETROSSIS);

SET Var_FechaSisIni	:= CONVERT(DATE_ADD(Var_FechaSis, INTERVAL -1*(DAY(Var_FechaSis))+1 DAY),CHAR(12));

SET SaldoIniMesMov 	:= (SELECT IFNULL(SaldoIniMes,Decimal_Cero) FROM CUENTASAHO WHERE CuentaAhoID = Par_CuentaAhoID LIMIT 1);

SET SaldoIniMesHis	:= (SELECT IFNULL(SaldoIniMes,Decimal_Cero) FROM `HIS-CUENTASAHO` WHERE CuentaAhoID = Par_CuentaAhoID
						AND Fecha >= CONCAT(Par_Anio,'-', Par_Mes,'-','01')
						AND Fecha <= LAST_DAY(CONCAT(Par_Anio,'-', Par_Mes,'-','01')) LIMIT 1);

/* ASIGNACION DE CONSTANTES*/
SET	Cadena_Vacia		:= '';
SET	Decimal_Cero		:= 0.00;
SET	Lis_Principal		:= 1;
SET	Lis_PrincipalHis	:= 2;
SET Lis_MovCtasInu		:=3;	-- Lista de movimientos de cuentas de ahorro usado en grid de pantalla de operaciones inusuales --
SET	Nat_Cargo		:= 'C';
SET	Nat_Abono		:= 'A';
SET DesCargo		:='CARGO';
SET DesAbono		:='ABONO';
SET Fecha_Vacia		:= '1900-01-01';

IF(Par_NumLis = Lis_Principal) THEN
	SET  	VarSaldo	:= SaldoIniMesMov;
	CREATE TEMPORARY TABLE TMPMOVIMIENTOS(Fecha DATE, NatMovimiento CHAR(1), DescripcionMov VARCHAR(150),
							CantidadMov DECIMAL(12,2), ReferenciaMov VARCHAR(50),  Saldo DECIMAL(12,2),
                            INDEX(Fecha, NatMovimiento));
	INSERT INTO TMPMOVIMIENTOS
				VALUES (	CONCAT(Par_Anio,'-', Par_Mes,'-','01'),	Cadena_Vacia,	'SALDO INICIAL DEL MES',
						IFNULL(SaldoIniMesMov,Decimal_Cero),	Cadena_Vacia,
						IFNULL(SaldoIniMesMov,Decimal_Cero));

	SET @SaldoCuenta := IFNULL(VarSaldo,Decimal_Cero);

	INSERT INTO TMPMOVIMIENTOS (
		Fecha,		NatMovimiento,		DescripcionMov,		CantidadMov,		ReferenciaMov,		Saldo)
	SELECT
		CM.Fecha,	CM.NatMovimiento,	CM.DescripcionMov,	CM.CantidadMov,		CM.ReferenciaMov,
		IF(CM.NatMovimiento = Nat_Abono , @SaldoCuenta:= (@SaldoCuenta + CM.CantidadMov) , @SaldoCuenta:= (@SaldoCuenta- CM.CantidadMov) ) AS SALDO
		FROM CUENTASAHOMOV	CM
			WHERE CM.CuentaAhoID = Par_CuentaAhoID
				AND CM.Fecha >= CONCAT(Par_Anio,'-', Par_Mes,'-','01')
				AND CM.Fecha <= last_day(CONCAT(Par_Anio,'-', Par_Mes,'-','01'))
			ORDER BY CM.Fecha, CM.FechaActual, CM.NatMovimiento;


	SELECT 	Fecha, 				NatMovimiento, 		DescripcionMov,			FORMAT(CantidadMov,2),	ReferenciaMov,
			FORMAT(Saldo,2)
	 FROM TMPMOVIMIENTOS;

	DROP TABLE TMPMOVIMIENTOS;

END IF;


IF(Par_NumLis = Lis_PrincipalHis) THEN
	SET  	VarSaldo	:= SaldoIniMesHis;
	CREATE TEMPORARY TABLE TMPMOVIMIENTOS(Fecha DATE, NatMovimiento CHAR(1), DescripcionMov VARCHAR(150),
							CantidadMov DECIMAL(12,2), ReferenciaMov VARCHAR(50),  Saldo DECIMAL(12,2),
                            INDEX(Fecha, NatMovimiento));
	INSERT INTO TMPMOVIMIENTOS
				VALUES (	CONCAT(Par_Anio,'-', Par_Mes,'-','01'),	Cadena_Vacia,	'SALDO INICIAL DEL MES',
						IFNULL(SaldoIniMesHis,Decimal_Cero),	Cadena_Vacia,
						IFNULL(SaldoIniMesHis,Decimal_Cero));

	SET @SaldoCuenta := VarSaldo;

	INSERT INTO TMPMOVIMIENTOS (
		Fecha,		NatMovimiento,		DescripcionMov,		CantidadMov,		ReferenciaMov,		Saldo)
	SELECT
		CM.Fecha,	CM.NatMovimiento,	CM.DescripcionMov,	CM.CantidadMov,		CM.ReferenciaMov,
		IF(CM.NatMovimiento = Nat_Abono , @SaldoCuenta:= (@SaldoCuenta + CM.CantidadMov) , @SaldoCuenta:= (@SaldoCuenta- CM.CantidadMov) ) AS SALDO
		FROM `HIS-CUENAHOMOV`	CM
			WHERE CM.CuentaAhoID = Par_CuentaAhoID
				AND CM.Fecha >= CONCAT(Par_Anio,'-', Par_Mes,'-','01')
				AND CM.Fecha <= last_day(CONCAT(Par_Anio,'-', Par_Mes,'-','01'))
			ORDER BY CM.Fecha, CM.FechaActual, CM.NatMovimiento;

	SELECT 	Fecha,			NatMovimiento,	DescripcionMov,	FORMAT(CantidadMov,2),	ReferenciaMov,
			FORMAT(Saldo,2)
	 FROM TMPMOVIMIENTOS;

	DROP TABLE TMPMOVIMIENTOS;

END IF;

IF(Par_NumLis = Lis_MovCtasInu)THEN
	SELECT FechaSistema INTO Var_FechaDeteccion
		FROM PARAMETROSSIS
		WHERE YEAR(FechaSistema) = Par_Anio
		AND MONTH(FechaSistema) = Par_Mes;
	SET Var_FechaDeteccion :=IFNULL(Var_FechaDeteccion,Fecha_Vacia);

		IF(Var_FechaDeteccion = Fecha_Vacia)THEN
			SELECT Fecha, DescripcionMov,  ReferenciaMov,FORMAT(CantidadMov,2) AS CantidadMov, CASE NatMovimiento
																									WHEN Nat_Cargo THEN DesCargo
																									WHEN Nat_Abono THEN DesAbono END AS TipoMovimiento

				FROM `HIS-CUENAHOMOV`
				WHERE  CuentaAhoID = Par_CuentaAhoID
				AND YEAR(Fecha) = Par_Anio
				AND MONTH(Fecha) = Par_Mes;

		ELSE
			SELECT Fecha, DescripcionMov,  ReferenciaMov,FORMAT(CantidadMov,2) AS CantidadMov, CASE NatMovimiento
																									WHEN Nat_Cargo THEN DesCargo
																									WHEN Nat_Abono THEN DesAbono END AS TipoMovimiento
				FROM CUENTASAHOMOV
				WHERE   CuentaAhoID = Par_CuentaAhoID
				AND YEAR(Fecha) = Par_Anio
				AND MONTH(Fecha) = Par_Mes;

		END IF;
END IF;

END TerminaStore$$