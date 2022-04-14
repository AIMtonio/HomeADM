-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COBCARTERAPAGOSASIGNAREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `COBCARTERAPAGOSASIGNAREP`;DELIMITER $$

CREATE PROCEDURE `COBCARTERAPAGOSASIGNAREP`(
	-- SP creado para generar el Reporte de Pagos de Asignacion de Cartera
	Par_FechaInicio		DATE,
	Par_FechaFin 		DATE,
	Par_GestorID 		INT(11),

	-- Parametros de Auditoria
	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
	)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_Sentencia		VARCHAR(10000);		-- Sentencia SQL
	DECLARE Var_Monto			DECIMAL(14,2);		-- Almacena la suma de los montos de pagos
    DECLARE Var_Comision		DECIMAL(14,2);		-- Almacena la suma de las comisiones

	 -- Declaracion de constantes
	DECLARE	Entero_Cero			INT;
	DECLARE Decimal_Cero 		DECIMAL(14,2);
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE NatAbono 			CHAR(1);
	DECLARE DescPagoCredito 	VARCHAR(50);
    DECLARE DescAbonoCuenta		VARCHAR(50);

	-- Asignacion de constantes
	SET	Entero_Cero			:= 0;					-- Entero cero
	SET Decimal_Cero 		:= 0.0;					-- Decimal cero
	SET Cadena_Vacia		:= '';					-- Cadena Vacia
	SET NatAbono			:= 'A'; 				-- Naturaleza de Movimiento: Abono
	SET DescPagoCredito 	:= 'PAGO DE CREDITO'; 	-- Descripcion de Movimiento: Pago de Credito
	SET DescAbonoCuenta		:= 'ABONO A CUENTA';    -- Descripcion de Movimiento: Abono a Cuenta

	-- Tabla temporal para registrar los creditos asignados a Gestores
	DROP TEMPORARY TABLE IF EXISTS TMPCREDASIGNADOS;
	CREATE TEMPORARY TABLE TMPCREDASIGNADOS(
		GestorID			INT(11),
		NombreGestor		VARCHAR(200),
		FechaAsignacion		DATE,
		ClienteID			BIGINT,
		CreditoID			BIGINT(12),
		NombreCompleto		VARCHAR(200),
		SucursalID			INT(11),
		NombreSucursal		VARCHAR(200),
		PorcComision 		DECIMAL(12,4));

	 -- Se obtienen los creditos asignados  a Gestores
	 SET Var_Sentencia := CONCAT("
	 INSERT INTO TMPCREDASIGNADOS(
			GestorID,		NombreGestor,	FechaAsignacion,	ClienteID, 	CreditoID,
			NombreCompleto,	SucursalID, 	PorcComision)

	 SELECT Cob.GestorID, 	Ges.NombreCompleto,	Cob.FechaAsig, 	Det.ClienteID, Det.CreditoID,
			Cli.NombreCompleto,	Cli.SucursalOrigen, (Cob.PorcentajeComision / 100) AS PorcentajeComision
			FROM DETCOBCARTERAASIG Det
			INNER JOIN COBCARTERAASIG Cob
			on Cob.FolioAsigID = Det.FolioAsigID
			INNER JOIN GESTORESCOBRANZA Ges
			ON Ges.GestorID = Cob.GestorID
			INNER JOIN CLIENTES Cli
			ON Det.ClienteID = Cli.ClienteID
            WHERE Det.CredAsignado = 'S'
			AND Cob.FechaAsig BETWEEN ? and ? ");

	-- Filtro por Gestor
	IF(IFNULL(Par_GestorID, Entero_Cero) != Entero_Cero) then
		SET Var_Sentencia := CONCAT(Var_Sentencia, " AND Cob.GestorID = ",Par_GestorID);
	END IF;

	SET Var_Sentencia := 	CONCAT(Var_Sentencia,' ORDER BY FechaAsig; ');

	SET @Sentencia	= (Var_Sentencia);
	SET @FechaInicio	= Par_FechaInicio;
	SET @FechaFin		= Par_FechaFin;

	PREPARE COBCARTERAPAGOSASIGNAREP FROM @Sentencia;
	EXECUTE COBCARTERAPAGOSASIGNAREP USING @FechaInicio, @FechaFin;
	DEALLOCATE PREPARE COBCARTERAPAGOSASIGNAREP;

	-- Se actualiza el Nombre de la Sucursal del Cliente
	UPDATE TMPCREDASIGNADOS Tmp,
		SUCURSALES Suc
	SET Tmp.NombreSucursal = Suc.NombreSucurs
	WHERE Tmp.SucursalID = Suc.SucursalID;


	-- Tabla temporal para obtener el Monto Pagado de Credito
	DROP TEMPORARY TABLE IF EXISTS TMPCREDMONTOPAGO;
	CREATE TEMPORARY TABLE TMPCREDMONTOPAGO(
		CreditoID			BIGINT(12),
		FechaOperacion 		DATE,
		MontoPagado 		DECIMAL(14,2),
		Capital				DECIMAL(14,2),
		InteresNormal		DECIMAL(14,2),
		IVAIntNormal 		DECIMAL(14,2),
		InteresMora 		DECIMAL(14,2),

		IVAIntMora			DECIMAL(14,2),
		DescripcionMov 		VARCHAR(50));

	-- Se obtiene el monto pagado del credito
	INSERT INTO TMPCREDMONTOPAGO
	SELECT Mov.CreditoID, Mov.FechaOperacion,
		IFNULL(ROUND(SUM(CASE WHEN Mov.TipoMovCreID IN (1,2,3,4,10,11,12,13,14,15,16,17,20,21) THEN Mov.Cantidad ELSE Decimal_Cero END),2), Decimal_Cero), -- Monto Total Pago
		IFNULL(ROUND(SUM(CASE WHEN Mov.TipoMovCreID IN (1,2,3,4) THEN Mov.Cantidad ELSE Decimal_Cero END),2), Decimal_Cero), -- Monto Pago Capital
		IFNULL(ROUND(SUM(CASE WHEN Mov.TipoMovCreID IN (10,11,12,13,14) THEN Mov.Cantidad ELSE Decimal_Cero END),2), Decimal_Cero), -- Monto Pago Interes Normal
		IFNULL(ROUND(SUM(CASE WHEN Mov.TipoMovCreID IN (20) THEN Mov.Cantidad ELSE Decimal_Cero END),2), Decimal_Cero), -- Monto Pago IVA Interes Normal
		IFNULL(ROUND(SUM(CASE WHEN Mov.TipoMovCreID IN (15,16,17) THEN Mov.Cantidad ELSE Decimal_Cero END),2), Decimal_Cero), -- Monto Pago Interes Moratorio
		IFNULL(ROUND(SUM(CASE WHEN Mov.TipoMovCreID IN (21) THEN Mov.Cantidad ELSE Decimal_Cero END),2), Decimal_Cero), -- Monto Pago IVA Interes Moratorio
		DescPagoCredito
		FROM CREDITOSMOVS Mov
	WHERE Mov.FechaOperacion >= Par_FechaInicio
		AND Mov.FechaOperacion <= Par_FechaFin
		AND Mov.NatMovimiento = NatAbono
		AND (Mov.Descripcion LIKE 'PAGO%' OR Mov.Descripcion LIKE 'PREPAGO%')
	GROUP BY Mov.CreditoID, Mov.FechaOperacion;

	-- Tabla temporal para registrar los pagos de los creditos y abonos a la cuenta
    DROP TEMPORARY TABLE IF EXISTS TMPCREDITOSPAGOASIGNADOS;
	CREATE TEMPORARY TABLE TMPCREDITOSPAGOASIGNADOS(
		Fecha				DATE,
		ClienteID			BIGINT,
		CreditoID			BIGINT(12),
		NombreCompleto		VARCHAR(200),
		NombreSucursal		VARCHAR(200),
		Monto 				DECIMAL(14,2),
		DescripcionMov 		VARCHAR(50),
		Capital				DECIMAL(14,2),
		InteresNormal		DECIMAL(14,2),
		IVAIntNormal 		DECIMAL(14,2),
		InteresMora 		DECIMAL(14,2),
		IVAIntMora			DECIMAL(14,2),
		PorcComision 		DECIMAL(12,4),
        Comision			DECIMAL(14,2),
        GestorID			INT(11),
        NombreGestor		VARCHAR(200));

    -- Se registran los pagos de los creditos asignados
    INSERT TMPCREDITOSPAGOASIGNADOS
 	SELECT Tmp1.FechaOperacion,	Tmp2.ClienteID, 		Tmp1.CreditoID,		Tmp2.NombreCompleto,		Tmp2.NombreSucursal,
			Tmp1.MontoPagado,	Tmp1.DescripcionMov, 	Tmp1.Capital,  		Tmp1.InteresNormal, 		Tmp1.IVAIntNormal,
			Tmp1.InteresMora, 	Tmp1.IVAIntMora, 		Tmp2.PorcComision, 	ROUND((Tmp1.MontoPagado * Tmp2.PorcComision),2) AS Comision,
            Tmp2.GestorID,		Tmp2.NombreGestor
	FROM TMPCREDMONTOPAGO Tmp1
    INNER JOIN TMPCREDASIGNADOS Tmp2
    WHERE Tmp1.CreditoID = Tmp2.CreditoID
    AND Tmp1.MontoPagado > Entero_Cero;

    -- Tabla temporal para obtener los abonos historicos a las cuentas del credito
	DROP TEMPORARY TABLE IF EXISTS TMPABONOCTAHISCREDITOS;
	CREATE TEMPORARY TABLE TMPABONOCTAHISCREDITOS(
		CreditoID			BIGINT(12),
		FechaAbono			DATE,
		MontoAbono			DECIMAL(14,2),
		DescripcionMov		VARCHAR(50));

	-- Se obtienen los abonos historicos a las cuentas del credito
    INSERT INTO TMPABONOCTAHISCREDITOS
    SELECT Cre.CreditoID, Mov.Fecha,Mov.CantidadMov,DescAbonoCuenta
	FROM `HIS-CUENAHOMOV` Mov
		INNER JOIN CUENTASAHO Cta
			ON Mov.CuentaAhoID = Cta.CuentaAhoID
		INNER JOIN CREDITOS Cre
			ON Cta.CuentaAhoID = Cre.CuentaID
		AND Cta.ClienteID = Cre.ClienteID
	WHERE Mov.Fecha >= Par_FechaInicio
		AND Mov.Fecha <= Par_FechaFin
		AND Mov.NatMovimiento = NatAbono
		AND Mov.DescripcionMov LIKE 'ABONO%'
		GROUP BY Mov.CuentaAhoID, Cre.CreditoID, Mov.Fecha, Mov.CantidadMov;

	-- Se registran los abonos historicos a las cuentas del credito
	INSERT TMPCREDITOSPAGOASIGNADOS
    SELECT Tmp1.FechaAbono,		Tmp2.ClienteID, 		Tmp1.CreditoID,		Tmp2.NombreCompleto,		Tmp2.NombreSucursal,
			Tmp1.MontoAbono,	Tmp1.DescripcionMov, 	Entero_Cero,  		Entero_Cero, 				Entero_Cero,
			Entero_Cero, 		Entero_Cero, 			Tmp2.PorcComision, 	ROUND((Tmp1.MontoAbono * Tmp2.PorcComision),2) AS Comision,
            Tmp2.GestorID,		Tmp2.NombreGestor
	FROM TMPABONOCTAHISCREDITOS Tmp1
    INNER JOIN TMPCREDASIGNADOS Tmp2
    WHERE Tmp1.CreditoID = Tmp2.CreditoID;

     -- Tabla temporal para obtener los abonos del periodo actual a las cuentas del credito
	DROP TEMPORARY TABLE IF EXISTS TMPABONOCTACREDITOS;
	CREATE TEMPORARY TABLE TMPABONOCTACREDITOS(
		CreditoID			BIGINT(12),
		FechaAbono			DATE,
		MontoAbono			DECIMAL(14,2),
		DescripcionMov		VARCHAR(50));

	-- Se obtienen los abonos del periodo a las cuentas del credito
    INSERT INTO TMPABONOCTACREDITOS
    SELECT Cre.CreditoID, Mov.Fecha,Mov.CantidadMov,DescAbonoCuenta
	FROM CUENTASAHOMOV Mov
		INNER JOIN CUENTASAHO Cta
			ON Mov.CuentaAhoID = Cta.CuentaAhoID
		INNER JOIN CREDITOS Cre
			ON Cta.CuentaAhoID = Cre.CuentaID
		AND Cta.ClienteID = Cre.ClienteID
	WHERE Mov.Fecha >= Par_FechaInicio
		AND Mov.Fecha <= Par_FechaFin
		AND Mov.NatMovimiento = NatAbono
		AND Mov.DescripcionMov LIKE 'ABONO%'
		GROUP BY Mov.CuentaAhoID, Cre.CreditoID, Mov.Fecha, Mov.CantidadMov;

    -- Se registran los abonos del periodo a las cuentas del credito
	INSERT TMPCREDITOSPAGOASIGNADOS
    SELECT Tmp1.FechaAbono,		Tmp2.ClienteID, 		Tmp1.CreditoID,		Tmp2.NombreCompleto,		Tmp2.NombreSucursal,
			Tmp1.MontoAbono,	Tmp1.DescripcionMov, 	Entero_Cero,  		Entero_Cero, 				Entero_Cero,
			Entero_Cero, 		Entero_Cero, 			Tmp2.PorcComision, 	ROUND((Tmp1.MontoAbono * Tmp2.PorcComision),2) AS Comision,
            Tmp2.GestorID,		Tmp2.NombreGestor
	FROM TMPABONOCTACREDITOS Tmp1
    INNER JOIN TMPCREDASIGNADOS Tmp2
    WHERE Tmp1.CreditoID = Tmp2.CreditoID;


    -- Se obtiene la suma de los Montos y de las Comisiones
    SELECT SUM(Monto), SUM(Comision) INTO Var_Monto, Var_Comision
    FROM TMPCREDITOSPAGOASIGNADOS;

    -- Se obtiene la infomacion de pagos de creditos asignados para mostrarlo en el reporte
    SELECT  Fecha,			ClienteID,			CreditoID,		NombreCompleto,		NombreSucursal,
			Monto,			DescripcionMov, 	Capital,		InteresNormal,		IVAIntNormal,
			InteresMora, 	IVAIntMora,			PorcComision, 	Comision,			Var_Monto AS MontoTotal,
            Var_Comision AS ComisionTotal,		GestorID,		NombreGestor
	FROM TMPCREDITOSPAGOASIGNADOS
    GROUP BY GestorID,			CreditoID,		Fecha,				ClienteID,		NombreCompleto,
			 NombreSucursal,	Monto,			DescripcionMov, 	Capital,		InteresNormal,
             IVAIntNormal,		InteresMora, 	IVAIntMora,			PorcComision, 	Comision,
             NombreGestor;

	DROP TEMPORARY TABLE IF EXISTS TMPCREDASIGNADOS;
	DROP TEMPORARY TABLE IF EXISTS TMPCREDMONTOPAGO;
	DROP TEMPORARY TABLE IF EXISTS TMPABONOCTAHISCREDITOS;
    DROP TEMPORARY TABLE IF EXISTS TMPABONOCTACREDITOS;
    DROP TEMPORARY TABLE IF EXISTS TMPCREDITOSPAGOASIGNADOS;

END TerminaStore$$