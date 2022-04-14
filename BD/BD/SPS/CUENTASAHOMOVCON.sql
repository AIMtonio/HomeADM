-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASAHOMOVCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASAHOMOVCON`;DELIMITER $$

CREATE PROCEDURE `CUENTASAHOMOVCON`(

	Par_CuentaAhoID		BIGINT(12),
	Par_Mes				INT,
	Par_Anio			INT,
	Par_NumCon			TINYINT UNSIGNED,

	Aud_EmpresaID		INT,
	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
			)
TerminaStore: BEGIN

/* DECLARACION DE CONSTANTES*/
DECLARE Cadena_Vacia           	CHAR(1);
DECLARE Entero_Cero             INT;
DECLARE	Decimal_Cero			DECIMAL(12,2);
DECLARE	Nat_Cargo				CHAR(1);
DECLARE	Nat_Abono				CHAR(1);
DECLARE	Con_ReporteMovmientos 	INT;
DECLARE	Con_ReporteMovHis 		INT;
DECLARE	Con_ReporteMovExcel		INT(11);
DECLARE Fecha_Vacia				DATE;

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
DECLARE	Var_FechaIniAnt 	DATE;
DECLARE	Var_FechaFinAnt		DATE;
DECLARE SaldoIniMesMov		DECIMAL(12,2);
DECLARE SaldoIniMesHis		DECIMAL(12,2);
DECLARE Var_Cliente			INT(11);        -- VARIABLE PARA OBTENER EL ID DEL CLIENTE
DECLARE Var_Nombre			VARCHAR(2000);	-- VARIABLE PARA OBTENER EL NOMBRE DEL CLIENTE
DECLARE Var_NumDatos   		INT(11);		-- CONTADOR PARA SABER SI EXISTEN REGISTROS EN LA TABLA TEMPORAL
DECLARE Var_NumDatosHIs     INT(11);		-- CONTADOR PARA SABER SI EXISTEN REGISTROS EN LA TABLA TEMPORAL
DECLARE Var_Fecha	        DATE;
DECLARE Var_PrimerDia		DATE;
DECLARE Var_UltimoDia		DATE;

/* ASIGNACION DE CONSTANTES*/
SET	SaldoDisp				:= 0.0;
SET	Movimiento				:= '';
SET	NumeroMov				:= 0;
SET VarSaldo				:= 0;
SET	Con_ReporteMovmientos	:= 1;
SET	Con_ReporteMovHis		:= 2;
SET Con_ReporteMovExcel		:= 3;
SET	Nat_Cargo				:= 'C';
SET	Nat_Abono				:= 'A';
SET	Decimal_Cero			:= 0.0;
SET Cadena_Vacia			:= '';		-- CADENA VACIA
SET Entero_Cero          	:= 0;		-- ENTERO CERO
SET Fecha_Vacia				:= '1900-01-01';

/* ASIGNACION DE VARIABLES*/
SELECT FechaSistema INTO Var_FechaSistema FROM  PARAMETROSSIS;

SET Var_FechaIni		:= CONCAT(Par_Anio,'-', Par_Mes,'-','01');
SET Var_FechaInicial 	:= date_format(Var_FechaIni, '%Y-%m-%d');
SET Var_FechaFinal 		:= last_day(Var_FechaInicial);


SET SaldoIniMesMov 	:= (SELECT IFNULL(SaldoIniMes,Decimal_Cero) FROM CUENTASAHO WHERE CuentaAhoID = Par_CuentaAhoID);

SET SaldoIniMesHis	:= (SELECT IFNULL(SaldoIniMes,Decimal_Cero) FROM `HIS-CUENTASAHO` WHERE CuentaAhoID = Par_CuentaAhoID
						AND Fecha >= CONCAT(Par_Anio,'-', Par_Mes,'-','01')
						AND Fecha <= last_day(CONCAT(Par_Anio,'-', Par_Mes,'-','01')) LIMIT 1);

/* fecha del mes anterior*/
SET Var_FechaIniAnt := DATE_ADD(Var_FechaInicial, INTERVAL -1 month);
SET Var_FechaFinAnt := DATE_ADD(Var_FechaFinal, INTERVAL -1 month);

-- obtiene identificacion y nombre del cliente
SET Var_Cliente := (SELECT ClienteID FROM CUENTASAHO WHERE CuentaAhoID=Par_CuentaAhoID);
SET Var_Nombre  := (SELECT NombreCompleto FROM CLIENTES WHERE ClienteID = Var_Cliente);
SET Var_Nombre  := IFNULL(Var_Nombre, Cadena_Vacia);

IF(Par_NumCon = Con_ReporteMovmientos) THEN
	CREATE Temporary TABLE TMPMOVIMIENTOS(
				Fecha 			DATE,
                NatMovimiento 	CHAR(1),
                DescripcionMov 	VARCHAR(150),
				CantidadMov 	DECIMAL(12,2),
                ReferenciaMov 	VARCHAR(50),
                Saldo 			DECIMAL(12,2),
				index(Fecha, NatMovimiento));

	SET VarSaldo := SaldoIniMesMov;

	set @SaldoCuenta := VarSaldo;

	insert into TMPMOVIMIENTOS (
		Fecha,		NatMovimiento,		DescripcionMov,		CantidadMov,		ReferenciaMov,		Saldo)
	select
		CM.Fecha,	CM.NatMovimiento,	CM.DescripcionMov,	CM.CantidadMov,		CM.ReferenciaMov,
		if(CM.NatMovimiento = Nat_Abono , @SaldoCuenta:= (@SaldoCuenta + CM.CantidadMov) , @SaldoCuenta:= (@SaldoCuenta- CM.CantidadMov) ) as SALDO
		from CUENTASAHOMOV	CM
			where CM.CuentaAhoID = Par_CuentaAhoID
				and CM.Fecha >= CONCAT(Par_Anio,'-', Par_Mes,'-','01')
				and CM.Fecha <= last_day(CONCAT(Par_Anio,'-', Par_Mes,'-','01'))
			order by CM.Fecha, CM.FechaActual, CM.NatMovimiento;
-- se validan datos en la temporal
	SET Var_NumDatos := (SELECT COUNT(*) FROM TMPMOVIMIENTOS);
	SET Var_NumDatos := IFNULL(Var_NumDatos, Entero_Cero);

	IF(Var_NumDatos	> Entero_Cero) THEN

			SELECT 	tmp.Fecha,
					tmp.NatMovimiento,
                    tmp.DescripcionMov,
                    FORMAT(tmp.CantidadMov,2) AS CantidadMov,
                    tmp.ReferenciaMov,
					FORMAT(tmp.Saldo,2) AS Saldo,
                    Var_Nombre
			FROM 	TMPMOVIMIENTOS tmp;
		ELSE
			SELECT 	Cadena_Vacia AS Fecha,
					Cadena_Vacia AS NatMovimiento,
                    Cadena_Vacia AS DescripcionMov,
                    Decimal_Cero AS CantidadMov,
                    Cadena_Vacia AS ReferenciaMov,
					Decimal_Cero AS Saldo,
                    Var_Nombre;
	END IF;

	DROP TABLE TMPMOVIMIENTOS;

END IF;

IF(Par_NumCon = Con_ReporteMovHis) THEN
	CREATE Temporary TABLE TMPMOVIMIENTOS(
				Fecha 			DATE,
				NatMovimiento 	CHAR(1),
                DescripcionMov 	VARCHAR(150),
				CantidadMov 	DECIMAL(12,2),
                ReferenciaMov 	VARCHAR(50),
                Saldo 			DECIMAL(12,2),
				index(Fecha, NatMovimiento));

	SET VarSaldo := SaldoIniMesHis;

	set @SaldoCuenta := VarSaldo;

	insert into TMPMOVIMIENTOS (
		Fecha,		NatMovimiento,		DescripcionMov,		CantidadMov,		ReferenciaMov,		Saldo)
	select
		CM.Fecha,	CM.NatMovimiento,	CM.DescripcionMov,	CM.CantidadMov,		CM.ReferenciaMov,
		if(CM.NatMovimiento = Nat_Abono , @SaldoCuenta:= (@SaldoCuenta + CM.CantidadMov) , @SaldoCuenta:= (@SaldoCuenta- CM.CantidadMov) ) as SALDO
		from `HIS-CUENAHOMOV`	CM
			where CM.CuentaAhoID = Par_CuentaAhoID
				and CM.Fecha >= CONCAT(Par_Anio,'-', Par_Mes,'-','01')
				and CM.Fecha <= last_day(CONCAT(Par_Anio,'-', Par_Mes,'-','01'))
			order by CM.Fecha, CM.FechaActual, CM.NatMovimiento;
-- se validan datos en la tabla temporal
	SET Var_NumDatosHIs := (SELECT COUNT(*) FROM TMPMOVIMIENTOS);
	SET Var_NumDatosHIs := IFNULL(Var_NumDatosHIs, Entero_Cero);


	IF(Var_NumDatosHIs	> Entero_Cero) THEN

		SELECT 	tmp.Fecha,
				tmp.NatMovimiento,
                tmp.DescripcionMov,
                FORMAT(tmp.CantidadMov,2) AS CantidadMov,
                tmp.ReferenciaMov,
				FORMAT(tmp.Saldo,2) AS Saldo,
                Var_Nombre
		FROM TMPMOVIMIENTOS tmp;
	ELSE
		SELECT 	Cadena_Vacia AS Fecha,
				Cadena_Vacia AS  NatMovimiento,
                Cadena_Vacia AS DescripcionMov,
                Decimal_Cero AS CantidadMov,
                Cadena_Vacia AS ReferenciaMov,
				Decimal_Cero AS Saldo,
                Var_Nombre;
	END IF;

	DROP TABLE TMPMOVIMIENTOS;

END IF;

IF(Par_NumCon = Con_ReporteMovExcel) THEN

	SELECT 	CM.Fecha into Var_Fecha
	FROM	CUENTASAHOMOV	CM
	WHERE	CM.CuentaAhoID = Par_CuentaAhoID
	AND 	CM.Fecha >= Var_FechaIni
	AND 	CM.Fecha <= Var_FechaFinal
    limit 1;

    SET Var_Fecha = IFNULL(Var_Fecha,  Fecha_Vacia);

    CREATE Temporary TABLE TMPMOVIMIENTOS(
					Fecha 			DATE,
                    NatMovimiento 	CHAR(1),
                    DescripcionMov 	VARCHAR(150),
					CantidadMov 	DECIMAL(12,2),
                    ReferenciaMov 	VARCHAR(50),
                    Saldo 			DECIMAL(12,2),
					index(Fecha, NatMovimiento));

	IF(Var_Fecha != Fecha_Vacia)THEN

        SET VarSaldo := SaldoIniMesMov;

	set @SaldoCuenta := VarSaldo;

	insert into TMPMOVIMIENTOS (
		Fecha,		NatMovimiento,		DescripcionMov,		CantidadMov,		ReferenciaMov,		Saldo)
	select
		CM.Fecha,	CM.NatMovimiento,	CM.DescripcionMov,	CM.CantidadMov,		CM.ReferenciaMov,
		if(CM.NatMovimiento = Nat_Abono , @SaldoCuenta:= (@SaldoCuenta + CM.CantidadMov) , @SaldoCuenta:= (@SaldoCuenta- CM.CantidadMov) ) as SALDO
		from CUENTASAHOMOV	CM
			where CM.CuentaAhoID = Par_CuentaAhoID
				and CM.Fecha >= CONCAT(Par_Anio,'-', Par_Mes,'-','01')
				and CM.Fecha <= last_day(CONCAT(Par_Anio,'-', Par_Mes,'-','01'))
			order by CM.Fecha, CM.FechaActual, CM.NatMovimiento;

	ELSE

		SET VarSaldo := SaldoIniMesHis;

	set @SaldoCuenta := VarSaldo;

	insert into TMPMOVIMIENTOS (
		Fecha,		NatMovimiento,		DescripcionMov,		CantidadMov,		ReferenciaMov,		Saldo)
	select
		CM.Fecha,	CM.NatMovimiento,	CM.DescripcionMov,	CM.CantidadMov,		CM.ReferenciaMov,
		if(CM.NatMovimiento = Nat_Abono , @SaldoCuenta:= (@SaldoCuenta + CM.CantidadMov) , @SaldoCuenta:= (@SaldoCuenta- CM.CantidadMov) ) as SALDO
		from `HIS-CUENAHOMOV`	CM
			where CM.CuentaAhoID = Par_CuentaAhoID
				and CM.Fecha >= CONCAT(Par_Anio,'-', Par_Mes,'-','01')
				and CM.Fecha <= last_day(CONCAT(Par_Anio,'-', Par_Mes,'-','01'))
			order by CM.Fecha, CM.FechaActual, CM.NatMovimiento;


	END IF;

		-- se validan datos en la temporal
		SET Var_NumDatos := (SELECT COUNT(*) FROM TMPMOVIMIENTOS);
		SET Var_NumDatos := IFNULL(Var_NumDatos, Entero_Cero);
		IF(Var_NumDatos	> Entero_Cero) THEN

				SELECT 	tmp.Fecha,
						tmp.NatMovimiento,
                        tmp.DescripcionMov,
                        FORMAT(tmp.CantidadMov,2) AS CantidadMov,
                        tmp.ReferenciaMov,
						FORMAT(tmp.Saldo,2) AS Saldo,
                        Var_Nombre
				FROM 	TMPMOVIMIENTOS tmp;
		ELSE
				SELECT 	Cadena_Vacia AS Fecha,
						Cadena_Vacia AS NatMovimiento,
						Cadena_Vacia AS DescripcionMov,
                        Decimal_Cero AS CantidadMov,
                        Cadena_Vacia AS ReferenciaMov,
						Decimal_Cero AS Saldo,
                        Var_Nombre;
		END IF;
    DROP TABLE TMPMOVIMIENTOS;
END IF;

END TerminaStore$$