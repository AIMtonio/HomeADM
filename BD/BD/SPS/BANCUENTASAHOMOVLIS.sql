-- SP BANCUENTASAHOMOVLIS

DELIMITER ;

DROP PROCEDURE IF EXISTS BANCUENTASAHOMOVLIS;

DELIMITER $$

CREATE PROCEDURE `BANCUENTASAHOMOVLIS`(

	Par_CuentaAhoID		BIGINT(12),
	Par_FechaInicio		DATE,
	Par_FechaFin		DATE,
	Par_NumLis			TINYINT UNSIGNED,
	Par_NatMov			CHAR(6),
	Par_TipoMovAhoID    CHAR(6),
	Par_Busqueda		VARCHAR(50),
	Par_TamanioLista	INT(11),
	Par_PosicionInicial	INT(11),

	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN


	DECLARE	Var_SaldoIniMes		DECIMAL(14,2);
	DECLARE	Var_FechaSistema	DATE;
	DECLARE	Var_FechaSisIni		DATE;
	DECLARE	Var_FechaSisIniText	VARCHAR(50);
	DECLARE SaldoIniMesMov		DECIMAL(12,2);
	DECLARE SaldoIniMesHis		DECIMAL(12,2);
	DECLARE	Var_FechaIniMov		DATE;


	DECLARE Fecha_Vacia			DATE;
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Decimal_Cero		DECIMAL(12,2);
	DECLARE Entero_Cero			INT(11);
	DECLARE	Var_LisMovFechas 	TINYINT UNSIGNED;
	DECLARE	Var_LisMovFechasWeb TINYINT UNSIGNED;
	DECLARE	Nat_Abono			CHAR(1);
	DECLARE	Nat_Cargo			CHAR(1);
	DECLARE	Var_DesSaldoInicial	VARCHAR(50);
	DECLARE Var_CodigoIcono		VARCHAR(30);


	SET Fecha_Vacia				:= '1900-01-01';
	SET	Cadena_Vacia			:= '';
	SET	Decimal_Cero			:= 0.00;
	SET Entero_Cero				:= 0;
	SET	Var_LisMovFechas 		:= 1;
	SET	Var_LisMovFechasWeb 	:= 2;
	SET	Nat_Abono				:= 'A';
	SET	Nat_Cargo				:= 'C';
	SET Var_DesSaldoInicial 	:= 'SALDO INICIAL DEL MES';
	SET Var_CodigoIcono			:= 'fa fa-hourglass-start';

	SELECT FechaSistema INTO Var_FechaSistema
			FROM PARAMETROSSIS
			LIMIT 1;

	SET Var_SaldoIniMes := IFNULL(Var_SaldoIniMes,Decimal_Cero);
	SET Var_FechaIniMov := IFNULL(Var_FechaIniMov, Fecha_Vacia);


	IF (Par_NumLis = Var_LisMovFechas) THEN

		SET Par_FechaInicio := IFNULL(Par_FechaInicio, Fecha_Vacia);
		SET Par_FechaFin 	:= IFNULL(Par_FechaFin, Fecha_Vacia);

		SET Var_FechaSisIni := CONVERT(DATE_ADD(Var_FechaSistema, INTERVAL -1*(DAY(Var_FechaSistema))+1 DAY),CHAR(12));

		IF(IFNULL(Par_NatMov,Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NatMov 	:= '[A-Z]';
		END IF;

		IF(IFNULL(Par_TipoMovAhoID,Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_TipoMovAhoID='[0-9]*';
		END IF;

		IF(IFNULL(Par_Busqueda,Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_Busqueda='%%%';
		END IF;

		IF ( (MONTH(Par_FechaInicio) = MONTH(Var_FechaSistema) AND YEAR(Par_FechaInicio) = YEAR(Var_FechaSistema) )
			AND (MONTH(Par_FechaFin) = MONTH(Var_FechaSistema) AND YEAR(Par_FechaFin) = YEAR(Var_FechaSistema)) ) THEN

			SELECT Ca.Fecha, 					Ca.NatMovimiento, 							Ca.DescripcionMov,
			IFNULL(Ca.CantidadMov,Decimal_Cero)  AS CantidadMov,		Ca.ReferenciaMov,	Ca.NumeroMov,
			Ca.FechaActual,						Tm.Icono
					FROM CUENTASAHOMOV AS Ca
					INNER JOIN TIPOSMOVSAHO AS Tm ON Ca.TipoMovAhoID = Tm.TipoMovAhoID
					WHERE Ca.CuentaAhoID = Par_CuentaAhoID
					AND Ca.Fecha >= Par_FechaInicio
					AND Ca.Fecha <= Par_FechaFin
					AND Ca.NatMovimiento REGEXP Par_NatMov
					AND Ca.TipoMovAhoID REGEXP Par_TipoMovAhoID
					AND Ca.DescripcionMov LIKE  CONCAT("%", Par_Busqueda, "%")
					ORDER BY NumeroMov,Fecha ASC;
		END IF;

		IF ( (MONTH(Par_FechaInicio) != MONTH(Var_FechaSistema)  AND YEAR(Par_FechaInicio) <= YEAR(Var_FechaSistema))
			AND ( MONTH(Par_FechaFin) != MONTH(Var_FechaSistema) AND YEAR(Par_FechaFin) <= YEAR(Var_FechaSistema)) ) THEN

			SELECT Ca.Fecha, 					Ca.NatMovimiento, 							Ca.DescripcionMov,
			IFNULL(Ca.CantidadMov,Decimal_Cero)  AS CantidadMov,		Ca.ReferenciaMov,	Ca.NumeroMov,
			Ca.FechaActual,						Tm.Icono
					FROM `HIS-CUENAHOMOV` AS Ca
					INNER JOIN TIPOSMOVSAHO AS Tm ON Ca.TipoMovAhoID = Tm.TipoMovAhoID
					WHERE Ca.CuentaAhoID = Par_CuentaAhoID
					AND Ca.Fecha >= Par_FechaInicio
					AND Ca.Fecha <= Par_FechaFin
					AND Ca.NatMovimiento REGEXP Par_NatMov
					AND Ca.TipoMovAhoID REGEXP Par_TipoMovAhoID
					AND Ca.DescripcionMov LIKE  CONCAT("%", Par_Busqueda, "%")
					ORDER BY NumeroMov,Fecha ASC;
		END IF;

		IF ( (MONTH(Par_FechaInicio) != MONTH(Var_FechaSistema) AND YEAR(Par_FechaInicio) <= YEAR(Var_FechaSistema))
				AND (MONTH(Par_FechaFin) = MONTH(Var_FechaSistema) AND YEAR(Par_FechaFin) = YEAR(Var_FechaSistema)) ) THEN
			(SELECT Ca.Fecha, 					Ca.NatMovimiento, 							Ca.DescripcionMov,
					IFNULL(Ca.CantidadMov,Decimal_Cero)  AS CantidadMov,		Ca.ReferenciaMov,	Ca.NumeroMov,
					Ca.FechaActual,						Tm.Icono
					FROM `HIS-CUENAHOMOV` AS Ca
					INNER JOIN TIPOSMOVSAHO AS Tm ON Ca.TipoMovAhoID = Tm.TipoMovAhoID
					WHERE Ca.CuentaAhoID = Par_CuentaAhoID
					AND Ca.Fecha >= Par_FechaInicio
					AND Ca.NatMovimiento REGEXP Par_NatMov
					AND Ca.TipoMovAhoID REGEXP Par_TipoMovAhoID
					AND Ca.DescripcionMov LIKE  CONCAT("%", Par_Busqueda, "%")
					ORDER BY NumeroMov,Fecha ASC )
			UNION ALL
			(SELECT ahoMov.Fecha, 								ahoMov.NatMovimiento, 							ahoMov.DescripcionMov,
					IFNULL(ahoMov.CantidadMov,Decimal_Cero)  AS CantidadMov,		ahoMov.ReferenciaMov,		ahoMov.NumeroMov,
					ahoMov.FechaActual,					tip.Icono
					FROM CUENTASAHOMOV AS ahoMov
					INNER JOIN TIPOSMOVSAHO AS tip ON ahoMov.TipoMovAhoID = tip.TipoMovAhoID
					WHERE ahoMov.CuentaAhoID = Par_CuentaAhoID
					AND ahoMov.Fecha <= Par_FechaFin
					AND ahoMov.NatMovimiento REGEXP Par_NatMov
					AND ahoMov.TipoMovAhoID REGEXP Par_TipoMovAhoID
					AND ahoMov.DescripcionMov LIKE  CONCAT("%", Par_Busqueda, "%")
					ORDER BY ahoMov.NumeroMov,ahoMov.Fecha ASC
			);
		END IF;
	END IF;

	IF (Par_NumLis = Var_LisMovFechasWeb) THEN

		SET Par_FechaInicio := IFNULL(Par_FechaInicio, Fecha_Vacia);
		SET Par_FechaFin 	:= IFNULL(Par_FechaFin, Fecha_Vacia);

		SET Var_FechaSisIni := CONVERT(DATE_ADD(Var_FechaSistema, INTERVAL -1*(DAY(Var_FechaSistema))+1 DAY),CHAR(12));

		IF(IFNULL(Par_NatMov,Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NatMov 	:= '[A-Z]';
		END IF;

		IF(IFNULL(Par_TipoMovAhoID,Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_TipoMovAhoID='[0-9]*';
		END IF;

		IF(IFNULL(Par_Busqueda,Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_Busqueda='%%%';
		END IF;

		IF ( (MONTH(Par_FechaInicio) = MONTH(Var_FechaSistema) AND YEAR(Par_FechaInicio) = YEAR(Var_FechaSistema) )
			AND (MONTH(Par_FechaFin) = MONTH(Var_FechaSistema) AND YEAR(Par_FechaFin) = YEAR(Var_FechaSistema)) ) THEN

			SELECT SaldoIniMes
			INTO Var_SaldoIniMes
			FROM CUENTASAHO
			WHERE CuentaAhoID = Par_CuentaAhoID
			LIMIT 1;

			SET Var_SaldoIniMes := IFNULL(Var_SaldoIniMes,Decimal_Cero);

			SET Var_FechaIniMov := Var_FechaSisIni;


			(SELECT Var_FechaIniMov AS Fecha,			Cadena_Vacia AS NatMovimiento,				Var_DesSaldoInicial AS DescripcionMov,
					Var_SaldoIniMes AS CantidadMov,		Cadena_Vacia AS ReferenciaMov, 				Cadena_Vacia AS NumeroMov,
					Var_FechaSisIni AS FechaActual, 	Var_CodigoIcono  AS Icono )
			UNION ALL
			(SELECT Ca.Fecha, 					Ca.NatMovimiento, 							Ca.DescripcionMov,
			IFNULL(Ca.CantidadMov,Decimal_Cero)  AS CantidadMov,		Ca.ReferenciaMov,	Ca.NumeroMov,
			Ca.FechaActual,						Tm.Icono
					FROM CUENTASAHOMOV AS Ca
					INNER JOIN TIPOSMOVSAHO AS Tm ON Ca.TipoMovAhoID = Tm.TipoMovAhoID
					WHERE Ca.CuentaAhoID = Par_CuentaAhoID
					AND Ca.Fecha >= Par_FechaInicio
					AND Ca.Fecha <= Par_FechaFin
					AND Ca.NatMovimiento REGEXP Par_NatMov
					AND Ca.TipoMovAhoID REGEXP Par_TipoMovAhoID
					AND Ca.DescripcionMov LIKE  CONCAT("%", Par_Busqueda, "%")
					ORDER BY NumeroMov,Fecha ASC );
		END IF;



		IF ( (MONTH(Par_FechaInicio) != MONTH(Var_FechaSistema)  AND YEAR(Par_FechaInicio) <= YEAR(Var_FechaSistema))
			AND ( MONTH(Par_FechaFin) != MONTH(Var_FechaSistema) AND YEAR(Par_FechaFin) <= YEAR(Var_FechaSistema)) ) THEN

			SELECT SaldoIniMes
			INTO Var_SaldoIniMes
			FROM `HIS-CUENTASAHO`
			WHERE CuentaAhoID = Par_CuentaAhoID
			AND Fecha >= Par_FechaInicio
			AND Fecha <= Par_FechaFin
			LIMIT 1;

			SET Var_SaldoIniMes := IFNULL(Var_SaldoIniMes,Decimal_Cero);

			SET Var_FechaIniMov := CONCAT(SUBSTRING(Par_FechaInicio,1,8),'01');


			(SELECT Var_FechaIniMov AS Fecha,			Cadena_Vacia AS NatMovimiento,				Var_DesSaldoInicial AS DescripcionMov,
					Var_SaldoIniMes AS CantidadMov,		Cadena_Vacia AS ReferenciaMov, 				Cadena_Vacia AS NumeroMov,
					Var_FechaSisIni AS FechaActual, 	Var_CodigoIcono  AS Icono )
			UNION ALL
			(SELECT Ca.Fecha, 					Ca.NatMovimiento, 							Ca.DescripcionMov,
			IFNULL(Ca.CantidadMov,Decimal_Cero)  AS CantidadMov,		Ca.ReferenciaMov,	Ca.NumeroMov,
			Ca.FechaActual,						Tm.Icono
					FROM `HIS-CUENAHOMOV` AS Ca
					INNER JOIN TIPOSMOVSAHO AS Tm ON Ca.TipoMovAhoID = Tm.TipoMovAhoID
					WHERE Ca.CuentaAhoID = Par_CuentaAhoID
					AND Ca.Fecha >= Par_FechaInicio
					AND Ca.Fecha <= Par_FechaFin
					AND Ca.NatMovimiento REGEXP Par_NatMov
					AND Ca.TipoMovAhoID REGEXP Par_TipoMovAhoID
					AND Ca.DescripcionMov LIKE  CONCAT("%", Par_Busqueda, "%")
					ORDER BY NumeroMov,Fecha ASC );

		END IF;

		IF ( (MONTH(Par_FechaInicio) != MONTH(Var_FechaSistema) AND YEAR(Par_FechaInicio) <= YEAR(Var_FechaSistema))
				AND (MONTH(Par_FechaFin) = MONTH(Var_FechaSistema) AND YEAR(Par_FechaFin) = YEAR(Var_FechaSistema)) ) THEN

			SELECT SaldoIniMes
			INTO Var_SaldoIniMes
			FROM `HIS-CUENTASAHO`
			WHERE CuentaAhoID = Par_CuentaAhoID
			AND Fecha >= Par_FechaInicio
			AND Fecha <= Par_FechaFin
			LIMIT 1;

			SET Var_SaldoIniMes := IFNULL(Var_SaldoIniMes,Decimal_Cero);

			SET Var_FechaIniMov := CONCAT(SUBSTRING(Par_FechaInicio,1,8),'01');

			(SELECT Var_FechaIniMov AS Fecha,			Cadena_Vacia AS NatMovimiento,				Var_DesSaldoInicial AS DescripcionMov,
					Var_SaldoIniMes AS CantidadMov,		Cadena_Vacia AS ReferenciaMov, 				Cadena_Vacia AS NumeroMov,
					Var_FechaSisIni AS FechaActual, 	Var_CodigoIcono  AS Icono )
			UNION ALL
			(SELECT Ca.Fecha, 					Ca.NatMovimiento, 							Ca.DescripcionMov,
					IFNULL(Ca.CantidadMov,Decimal_Cero)  AS CantidadMov,		Ca.ReferenciaMov,	Ca.NumeroMov,
					Ca.FechaActual,						Tm.Icono
					FROM `HIS-CUENAHOMOV` AS Ca
					INNER JOIN TIPOSMOVSAHO AS Tm ON Ca.TipoMovAhoID = Tm.TipoMovAhoID
					WHERE Ca.CuentaAhoID = Par_CuentaAhoID
					AND Ca.Fecha >= Par_FechaInicio
					AND Ca.NatMovimiento REGEXP Par_NatMov
					AND Ca.TipoMovAhoID REGEXP Par_TipoMovAhoID
					AND Ca.DescripcionMov LIKE  CONCAT("%", Par_Busqueda, "%")
					ORDER BY NumeroMov,Fecha ASC )
			UNION ALL
			(SELECT ahoMov.Fecha, 								ahoMov.NatMovimiento, 							ahoMov.DescripcionMov,
					IFNULL(ahoMov.CantidadMov,Decimal_Cero)  AS CantidadMov,		ahoMov.ReferenciaMov,		ahoMov.NumeroMov,
					ahoMov.FechaActual,					tip.Icono
					FROM CUENTASAHOMOV AS ahoMov
					INNER JOIN TIPOSMOVSAHO AS tip ON ahoMov.TipoMovAhoID = tip.TipoMovAhoID
					WHERE ahoMov.CuentaAhoID = Par_CuentaAhoID
					AND ahoMov.Fecha <= Par_FechaFin
					AND ahoMov.NatMovimiento REGEXP Par_NatMov
					AND ahoMov.TipoMovAhoID REGEXP Par_TipoMovAhoID
					AND ahoMov.DescripcionMov LIKE  CONCAT("%", Par_Busqueda, "%")
					ORDER BY ahoMov.NumeroMov,ahoMov.Fecha ASC
			);

		END IF;

	END IF;

END TerminaStore$$
