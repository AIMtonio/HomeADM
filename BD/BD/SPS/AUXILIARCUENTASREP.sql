-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AUXILIARCUENTASREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `AUXILIARCUENTASREP`;DELIMITER $$

CREATE PROCEDURE `AUXILIARCUENTASREP`(
	Par_FechaCreacion		VARCHAR(10),

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)

	)
TerminaStore:BEGIN
	-- Declaracion de Constantes
    DECLARE Decimal_Cero		DECIMAL(14,2);
	DECLARE	Fecha_Vacia			VARCHAR(10);
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	ConsePoliza			INT(2);
	DECLARE ConseDetalle		INT(2);
	DECLARE	ConseComprobante	INT(2);
	DECLARE FechaFinMes			DATE;
    DECLARE Var_FechaCorte 		DATE;			-- Ultima Fecha de Corte(SALDOSCONTABLES)
    DECLARE Var_FechaSistema 	DATE;			-- Fecha Actual del Sistema(PARAMETROSSIS)

	-- Asignacion de Constantes
    SET Decimal_Cero		:= '0.00';			-- Constante: Decimal_Cero
	SET	Fecha_Vacia			:= '1900-01-01';	-- Constante: Fecha Vacia
	SET	Cadena_Vacia		:= '';				-- Constante: Cadena Vacia
	SET	ConsePoliza			:= 1;				-- Nodo 1(Cuentas que tuvieron movimientos en cierto periodo)
	SET	ConseDetalle		:= 2;				-- Nodo 2(Detalle de los movimientos)
	SET	ConseComprobante	:= 3;				-- (Etiqueta Final)

	SET FechaFinMes			:=	LAST_DAY(Par_FechaCreacion);	-- Fecha Final del Mes


    SET Var_FechaSistema	:= (SELECT FechaSistema FROM PARAMETROSSIS);
    SET Var_FechaCorte		:= (SELECT MAX(FechaCorte) FROM SALDOSCONTABLES WHERE FechaCorte < Var_FechaSistema);

	-- TABLA PRINCIPAL: Almacena las cuentas contables que tuvieron movimientos en cierto periodo y el detalle de sus movimientos
	DROP TABLE IF EXISTS TEMPCEPOLIZASCONT;
	CREATE TEMPORARY TABLE TEMPCEPOLIZASCONT (
											Consecutivo			INT(11),
											CuentaCompleta		VARCHAR(50),
											DescripcionCuenta	VARCHAR(250),
											SaldoInicial  		DECIMAL(14,2),
											SaldoFinal			DECIMAL(14,2),
											Fecha				DATE,
											PolizaID			BIGINT(20),
                                            Concepto			VARCHAR(250),
											Debe				DECIMAL(14,4),
											Haber				DECIMAL(14,4),
                                            NaturalezaCuenta	CHAR(1),
                                            FechaCorteS			DATE,
                                            NumTransaccion		BIGINT(20),
											INDEX (PolizaID),
                                            INDEX (CuentaCompleta),
                                            INDEX (Fecha),
											INDEX (Consecutivo));

	-- TABLA QUE ALMACENA LOS SALDOS (INICIAL Y FINAL) DE LAS CUENTAS Y QUE TIENEN PERIODOS CERRADOS
	DROP TABLE IF EXISTS TEMPCESALDOSCUENTAS;
	CREATE TEMPORARY TABLE TEMPCESALDOSCUENTAS (
											CuentaCompleta		VARCHAR(50),
											SaldoInicial  		DECIMAL(14,2),
											SaldoFinal			DECIMAL(14,2),
											FechaCorte			DATE,
                                            NumTransaccion		BIGINT(20),
                                            INDEX (CuentaCompleta),
                                            INDEX (FechaCorte));

    -- TABLA QUE ALMACENA EL SALDO INICIAL TOTAL DE LAS CUENTAS
    DROP TABLE IF EXISTS TMPCESALDOINICIAL;
	CREATE TEMPORARY TABLE TMPCESALDOINICIAL (
											CuentaCompleta		VARCHAR(50),
											SaldoInicial  		DECIMAL(14,2),
                                            NumTransaccion		BIGINT(20),
                                            INDEX (CuentaCompleta));

	-- TABLA QUE ALMACENA EL SALDO FINAL TOTAL DE LAS CUENTAS
	DROP TABLE IF EXISTS TMPCESALDOFINAL;
	CREATE TEMPORARY TABLE TMPCESALDOFINAL (
											CuentaCompleta		VARCHAR(50),
											SaldoFinal			DECIMAL(14,2),
                                            NumTransaccion		BIGINT(20),
                                            INDEX (CuentaCompleta));


	-- Encabezado de la Poliza (Se obtienen las cuentas que tuvieron movimiento en cierto periodo de fechas

	INSERT INTO TEMPCEPOLIZASCONT
		(SELECT	ConsePoliza,		D.CuentaCompleta,	C.Descripcion,  Decimal_Cero,		Decimal_Cero,
				Fecha_Vacia,		P.PolizaID, 		Cadena_Vacia, 	Decimal_Cero, 		Decimal_Cero,
				C.Naturaleza ,		Fecha_Vacia,		Aud_NumTransaccion
			FROM	`HIS-POLIZACONTA` P
					INNER JOIN `HIS-DETALLEPOL` D ON P.PolizaID			= D.PolizaID
					INNER JOIN CUENTASCONTABLES C ON D.CuentaCompleta	= C.CuentaCompleta
			WHERE	(P.Fecha>=Par_FechaCreacion AND P.Fecha<= FechaFinMes)
			GROUP BY D.CuentaCompleta, C.Descripcion, P.PolizaID, C.Naturaleza)
		UNION
		(SELECT	ConsePoliza,		D.CuentaCompleta, 	C.Descripcion,	Decimal_Cero, 		Decimal_Cero,
				Fecha_Vacia, 		P.PolizaID, 		Cadena_Vacia, 	Decimal_Cero, 		Decimal_Cero,
				C.Naturaleza ,		Fecha_Vacia,		Aud_NumTransaccion
			FROM	POLIZACONTABLE P
					INNER JOIN DETALLEPOLIZA D ON P.PolizaID=D.PolizaID
					INNER JOIN CUENTASCONTABLES C ON D.CuentaCompleta=C.CuentaCompleta
			WHERE (P.Fecha>=Par_FechaCreacion AND P.Fecha<= FechaFinMes)
			GROUP BY D.CuentaCompleta, C.Descripcion, P.PolizaID, C.Naturaleza);

	-- Inserta el Saldo Inicial y Final de las Cuentas que tienen fecha de corte
	INSERT INTO TEMPCESALDOSCUENTAS
		SELECT  T.CuentaCompleta, IFNULL(SUM(S.SaldoInicial), Decimal_Cero), IFNULL(SUM(S.SaldoFinal), Decimal_Cero), IFNULL(MAX(S.FechaCorte), Fecha_Vacia),	Aud_NumTransaccion
			FROM	TEMPCEPOLIZASCONT T
					LEFT JOIN  SALDOSCONTABLES S ON S.CuentaCompleta = T.CuentaCompleta
			WHERE  S.FechaCorte = Var_FechaCorte
			GROUP BY T.CuentaCompleta;

	--  Se actualiza el Saldo Inicial de la tabla Principal
	UPDATE TEMPCEPOLIZASCONT T1, TEMPCESALDOSCUENTAS T2
			SET T1.SaldoInicial		= T2.SaldoInicial,
				T1.SaldoFinal		= T2.SaldoFinal,
                T1.FechaCorteS		= T2.FechaCorte
		WHERE	T1.CuentaCompleta	= T2.CuentaCompleta
        AND T1.NumTransaccion 		= Aud_NumTransaccion
        AND T2.NumTransaccion 		= Aud_NumTransaccion;


	-- Calcula el saldo inicial de las cuentas que no tienen fecha de corte
	INSERT INTO TMPCESALDOINICIAL
		SELECT  T1.CuentaCompleta, CASE
										WHEN T1.NaturalezaCuenta = 'D' THEN
											IFNULL(T2.SaldoFinal, Decimal_Cero)  + (IFNULL(SUM(D.Cargos), Decimal_Cero)
											-
											IFNULL( SUM(D.Abonos), Decimal_Cero))
											WHEN T1.NaturalezaCuenta = 'A' THEN
											IFNULL(T2.SaldoFinal, Decimal_Cero)  + (IFNULL(SUM(D.Abonos), Decimal_Cero)
											-
											IFNULL(SUM(D.Cargos), Decimal_Cero))
										END,	Aud_NumTransaccion
			FROM	TEMPCEPOLIZASCONT T1
					LEFT JOIN TEMPCESALDOSCUENTAS T2 ON T1.CuentaCompleta = T2.CuentaCompleta
					LEFT JOIN DETALLEPOLIZA D ON T1.CuentaCompleta = D.CuentaCompleta
			WHERE	(D.Fecha >Var_FechaCorte AND D.Fecha< Par_FechaCreacion)
			AND 	D.CuentaCompleta = T1.CuentaCompleta
			GROUP BY T1.CuentaCompleta, T1.NaturalezaCuenta, T2.SaldoFinal;

	-- Se actualizan los saldos Iniciales de la Tabla Principal
	UPDATE TEMPCEPOLIZASCONT T1
			LEFT JOIN TMPCESALDOINICIAL T2	ON T1.CuentaCompleta = T2.CuentaCompleta
				SET T1.SaldoInicial	=  IFNULL(T2.SaldoInicial, Decimal_Cero)
		WHERE	T1.CuentaCompleta	= T2.CuentaCompleta
        AND T1.NumTransaccion 		= Aud_NumTransaccion
        AND T2.NumTransaccion 		= Aud_NumTransaccion;


	-- Calcula el saldo final de las cuentas que no tienen fecha de corte
	INSERT INTO TMPCESALDOFINAL
		SELECT  T1.CuentaCompleta, CASE
										WHEN T1.NaturalezaCuenta = 'D' THEN
											 IFNULL(MAX(T1.SaldoInicial), Decimal_Cero)  + (IFNULL(SUM(D.Cargos), Decimal_Cero)
											-
											IFNULL( SUM(D.Abonos), Decimal_Cero))
											WHEN T1.NaturalezaCuenta = 'A' THEN
											IFNULL(MAX(T1.SaldoInicial), Decimal_Cero)  + (IFNULL(SUM(D.Abonos), Decimal_Cero)
											-
											IFNULL(SUM(D.Cargos), Decimal_Cero))
										END,	Aud_NumTransaccion
			FROM	TEMPCEPOLIZASCONT T1
					LEFT JOIN DETALLEPOLIZA D ON T1.CuentaCompleta = D.CuentaCompleta
			WHERE	D.Fecha >= Par_FechaCreacion
			AND		D.CuentaCompleta 	= T1.CuentaCompleta
            AND 	T1.NumTransaccion	= Aud_NumTransaccion
			GROUP BY T1.CuentaCompleta, T1.NaturalezaCuenta, T1.SaldoFinal;



	-- Se actualizan los saldos Finales de la Tabla Principal
	UPDATE TEMPCEPOLIZASCONT T1
			LEFT JOIN TMPCESALDOFINAL T2 ON T1.CuentaCompleta = T2.CuentaCompleta
			SET T1.SaldoFinal	=  IFNULL(T2.SaldoFinal, Decimal_Cero)
	WHERE	T1.CuentaCompleta 	= T2.CuentaCompleta
    AND T1.NumTransaccion 		= Aud_NumTransaccion
	AND T2.NumTransaccion 		= Aud_NumTransaccion;

	-- Se insertan los Detalles de las Polizas agrupadas por Cuentas
  	INSERT INTO TEMPCEPOLIZASCONT
		(SELECT	ConseDetalle,		D.CuentaCompleta,	Cadena_Vacia,		Decimal_Cero, 	Decimal_Cero,
				D.Fecha, 			P.PolizaID, 		P.Concepto, 		SUM(D.Cargos), 	SUM(D.Abonos),
				Cadena_Vacia ,		Fecha_Vacia,		Aud_NumTransaccion
			FROM	`HIS-POLIZACONTA` P
					INNER JOIN `HIS-DETALLEPOL` D 	ON	P.PolizaID=D.PolizaID
					AND P.Fecha>=Par_FechaCreacion 	AND	P.Fecha	<= FechaFinMes
					INNER JOIN CUENTASCONTABLES C	ON	D.CuentaCompleta=C.CuentaCompleta
			GROUP BY D.CuentaCompleta, D.PolizaID, D.Fecha, P.Concepto)

		UNION
		(SELECT ConseDetalle, 		D.CuentaCompleta,	Cadena_Vacia,		Decimal_Cero, 	Decimal_Cero,
				D.Fecha, 			P.PolizaID, 		P.Concepto, 		SUM(D.Cargos), SUM(D.Abonos),
				Cadena_Vacia ,		Fecha_Vacia,		Aud_NumTransaccion
			FROM	POLIZACONTABLE P
					INNER JOIN DETALLEPOLIZA  D ON P.PolizaID=D.PolizaID
					AND P.Fecha>=Par_FechaCreacion AND P.Fecha<= FechaFinMes
					INNER JOIN CUENTASCONTABLES C ON D.CuentaCompleta=C.CuentaCompleta
			GROUP BY D.CuentaCompleta, D.PolizaID, D.Fecha, P.Concepto);

-- Se insertan las cuentas que tuvieron movimientos en cierto periodo
	INSERT INTO TEMPCEPOLIZASCONT
		(SELECT	ConseComprobante,	D.CuentaCompleta,	Cadena_Vacia,	Decimal_Cero,	Decimal_Cero,
				Fecha_Vacia,		P.PolizaID, 		Cadena_Vacia,	Decimal_Cero, 	Decimal_Cero,
				Cadena_Vacia ,		Fecha_Vacia,		Aud_NumTransaccion
			FROM	`HIS-POLIZACONTA` P
					INNER JOIN `HIS-DETALLEPOL` D ON P.PolizaID=D.PolizaID
					AND P.Fecha>=Par_FechaCreacion AND P.Fecha<= FechaFinMes
					INNER JOIN CUENTASCONTABLES C ON D.CuentaCompleta=C.CuentaCompleta
			GROUP BY D.CuentaCompleta, P.PolizaID)

		UNION
		(SELECT ConseComprobante,	D.CuentaCompleta,	Cadena_Vacia,		Decimal_Cero, Decimal_Cero,
				Fecha_Vacia,		P.PolizaID, 		Cadena_Vacia,		Decimal_Cero, Decimal_Cero,
				Cadena_Vacia ,		Fecha_Vacia,		Aud_NumTransaccion
			FROM	POLIZACONTABLE P
					INNER JOIN DETALLEPOLIZA D ON P.PolizaID=D.PolizaID
					AND P.Fecha>=Par_FechaCreacion AND P.Fecha<= FechaFinMes
					INNER JOIN CUENTASCONTABLES C ON D.CuentaCompleta=C.CuentaCompleta
			GROUP BY D.CuentaCompleta, P.PolizaID);


	SELECT	Consecutivo,	CuentaCompleta,	DescripcionCuenta,	SaldoInicial ,	SaldoFinal,
			Fecha,			PolizaID,		Concepto,			IFNULL(Debe,Decimal_Cero) AS Debe,
			IFNULL(Haber,Decimal_Cero) AS Haber ,FechaCorteS,	NumTransaccion
		FROM	TEMPCEPOLIZASCONT
        WHERE NumTransaccion 		= Aud_NumTransaccion
		ORDER BY CuentaCompleta,Consecutivo, PolizaID;



END TerminaStore$$