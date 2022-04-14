-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESTADISTICOCUENTASREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESTADISTICOCUENTASREP`;DELIMITER $$

CREATE PROCEDURE `ESTADISTICOCUENTASREP`(
# =====================================================================================
# -- STORED QUE  REALIZA EL REPORTE ESTADISTICO DE CARTERA Y CAPTACION
# =====================================================================================
    Par_NumCon              TINYINT UNSIGNED,   	-- Numero de consulta
    Par_FechaCorte  		DATETIME,				-- fecha de corte
    Par_TipoReporte			CHAR(1),				-- Tipo de reporte
    Par_MostrarGL			CHAR(1),				-- Indica si muestra Garantia liquida
    Par_MinimoSaldo			DECIMAL(12,2),			-- Saldo Minimo

    Par_CtasEstRegis		CHAR(1),				-- Estatus de cuentas

    Par_EmpresaID			INT(11),				-- Empresa ID
    Aud_Usuario             INT(11),				-- Uusario ID
    Aud_FechaActual         DATETIME,				-- Fecha Actual
    Aud_DireccionIP         VARCHAR(15),			-- Direccion IP
    Aud_ProgramaID          VARCHAR(50),			-- Programa ID
    Aud_Sucursal            INT(11),				-- sucursal ID
    Aud_NumTransaccion      BIGINT(20)				-- NUmero de transaccion
)
TerminaStore:BEGIN

	-- Declaracion de Vraiables
	DECLARE Var_FechaSistema 	DATE;
	DECLARE Var_FechaInicio	 	DATE;
	DECLARE Var_CtasEstRegis 	CHAR(1);

	-- Declaracion de Constantes
	DECLARE Entero_Cero 		INT(11);
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Decimal_Cero		DECIMAL(14,2);
	DECLARE Fecha_Vacia			DATE;
	DECLARE ReporteDetallado 	CHAR(1);

	DECLARE ReporteSinGarLiq 	CHAR(1);
	DECLARE ReporteGLOBAL	 	CHAR(1);
	DECLARE Tipo_Ahorro		 	VARCHAR(20);
	DECLARE Tipo_Inversion	 	VARCHAR(20);
	DECLARE Var_Activa			CHAR(1);

	DECLARE Var_Bloqueada		CHAR(1);
	DECLARE Var_Inactiva		CHAR(1);
	DECLARE Bloqueo 			CHAR(1);
	DECLARE Var_Vigente			CHAR(1);
	DECLARE Var_Pagado			CHAR(1);
	DECLARE Var_Castigado		CHAR(1);
	DECLARE Var_Cancelado		CHAR(1);
    DECLARE Var_EstatusVige		CHAR(1);

    DECLARE Con_DetCarteraPDF	INT(11);
    DECLARE Con_SumCarteraPDF	INT(11);
    DECLARE Con_DetCaptacionPDF	INT(11);
    DECLARE Con_SumCaptacionPDF	INT(11);
    DECLARE Con_DetCarteraExcel	INT(11);
    DECLARE Con_SumCarteraExcel	INT(11);
    DECLARE Con_DetCapExcel		INT(11);
    DECLARE Con_SumCapExcel		INT(11);

    DECLARE Var_Ahorro			VARCHAR(50);
    DECLARE Var_Inversion		VARCHAR(50);
    DECLARE Est_Activo			VARCHAR(50);
    DECLARE Est_Bloqueado		VARCHAR(50);
	DECLARE Est_Vigente			VARCHAR(50);
	DECLARE Est_Registrado		VARCHAR(50);

	-- ASignacion de variables
	SET Var_CtasEstRegis 	:= 'S'; 			-- Incluir cuentas que no fueron Autorizasas

	-- Asiganacion de Constantes
	SET Entero_Cero			:= 0;				-- Entero Cero
	SET Cadena_Vacia		:= '';				-- Cadena Vacia
	SET Decimal_Cero		:= 0.0;				-- DECIMAL Cero
	SET Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
	SET ReporteDetallado	:= 'D'; 			-- Detalle de slados por Cuenta Inversion y Creditos.
	SET ReporteGLOBAL		:= 'G'; 			-- Informacion a grupado por producto.END
	SET ReporteSinGarLiq 	:= 'S'; 			-- Informacion glogal sin Garantia Liquida.
	SET Tipo_Ahorro			:= 'CUENTAS';		-- tipo de ahorro cunetas
	SET Tipo_Inversion		:= 'INVERSION';		-- tipo Inversion
	SET Var_Activa 			:= 'A';				-- Estatus activo de la cuenta.
	SET Var_Bloqueada		:= 'B';				-- Estatus bloqueado
	SET Var_Inactiva		:= 'I';				-- Estatus Inactivo
	SET Bloqueo 			:= 'B';				-- Movimiento BLoqueo
	SET Var_Vigente			:= 'N';				-- Estatus Vigente
	SET Var_Pagado			:= 'P';				-- Estatus pagado
	SET Var_Castigado		:= 'K';				-- Estatus castigado
	SET Var_Cancelado		:= 'C';				-- Estatus Cancelado
	SET Var_EstatusVige		:= 'V';				-- Estatus vigente
	SET Con_DetCarteraPDF	:= 1;				-- Consulta para reporte detallado de cartera
    SET Con_SumCarteraPDF	:= 2;				-- consulta para reporte sumarizado de cartera
    SET Con_DetCaptacionPDF	:= 3;				-- Consulta para reporte detallado captacion
    SET Con_SumCaptacionPDF	:= 4;				-- Consulta para reporte sumarizado captacion
    SET Con_DetCarteraExcel	:= 5;				-- Consulta para reporte detallado de cartera excel
    SET Con_SumCarteraExcel	:= 6;				-- consulta para reporte sumarizado de cartera
    SET Con_DetCapExcel 	:= 7; 				-- Consulta para reporte detallado captacion
    SET Con_SumCapExcel		:= 8;				-- Consulta para reporte sumarizado captacion
    SET Var_Ahorro			:= 'AHORRO A LA VISTA';
    SET Var_Inversion		:= 'INVERSION A PLAZO';
    SET Est_Activo 			:= 'ACTIVO';
    SET Est_Bloqueado		:= 'BLOQUEADO';
    SET Est_Vigente			:= 'VIGENTE';
    SET Est_Registrado		:= 'REGISTRADO';

	DROP TABLE IF EXISTS SaldoCuentasGL;
 	CREATE TABLE  SaldoCuentasGL(
		Cuenta 		BIGINT(12),
		Importe 	DECIMAL(18,2),
        PRIMARY KEY(Cuenta));

	DROP TABLE IF EXISTS tmp_SaldosBloqueo;
    CREATE TABLE tmp_SaldosBloqueo (
    	Cuenta 		BIGINT(12),
		Saldo       DECIMAL(18,2),
		Referencia 	BIGINT(20),
		SaldoAho 	DECIMAL(18,2),
		PRIMARY KEY(Cuenta));

	DROP TABLE IF EXISTS tmp_SaldosCaptacion;
    CREATE TABLE tmp_SaldosCaptacion (

		NumCuenta     	BIGINT(12),
		Descripcion 	VARCHAR(100),
		Importe        	DECIMAL(18,2),
		SaldoGarantias 	DECIMAL(18,2),
		Sucursal		VARCHAR(100),

		SucursalID    	INT(11),
		Producto		VARCHAR(50),
		TipoProducto  	VARCHAR(20),
		NombreCliente 	VARCHAR(500),
		Estatus			VARCHAR(15),
        ClienteID		INT(11)
		);

	DROP TABLE IF EXISTS Temp_SaldosCredito;
    CREATE TABLE Temp_SaldosCredito(

		CreditoID 		BIGINT (12),
		NombreCompleto	VARCHAR(200),
		Descripcion		VARCHAR(100),
		MontoCredito	DECIMAL(12,2),
		SaldoCapital	DECIMAL(12,2),
		SaldoInteres	DECIMAL(12,2),
		NombreSucurs	VARCHAR(200),
        ClienteID		INT(11),
		PRIMARY KEY (CreditoID)
		);

	SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS);
	SET Var_FechaInicio  := (SELECT Par_FechaCorte - INTERVAL DAYOFMONTH(Par_FechaCorte) - 1 DAY);

 	-- Saldo de Garantia Liqida Fecha Corte
	INSERT INTO tmp_SaldosBloqueo
		SELECT CuentaAhoID,
			SUM(CASE WHEN NatMovimiento = Bloqueo
				THEN IFNULL(MontoBloq,Decimal_Cero)
				ELSE IFNULL(MontoBloq,Decimal_Cero)  * -1
				END) AS Saldo,
			MAX(Referencia) , Decimal_Cero
		FROM BLOQUEOS
			WHERE   DATE(FechaMov)  <= Par_FechaCorte AND 	TiposBloqID = 8
			GROUP BY CuentaAhoID;

	CREATE INDEX tmp_idx  ON tmp_SaldosBloqueo(Referencia);
	CREATE INDEX tmp_idx2 ON tmp_SaldosBloqueo(Cuenta);

	IF (substring(Var_FechaSistema,1,7) = substring(Par_FechaCorte,1,7)) THEN

		-- Inserta en SaldoCuentasGL
		INSERT INTO SaldoCuentasGL
			SELECT C.CuentaAhoID AS Cuenta,
				SUM(CASE WHEN CM.NatMovimiento = Var_Activa THEN IFNULL(CM.CantidadMov,Decimal_Cero)
					ELSE IFNULL(CM.CantidadMov,Decimal_Cero) * -1  END) + IFNULL(MAX(C.SaldoIniMes),Decimal_Cero) AS Importe
			FROM  CUENTASAHO C
				INNER JOIN 	tmp_SaldosBloqueo tm 	ON C.CuentaAhoID = tm.Cuenta
				LEFT  JOIN 	CUENTASAHOMOV CM 		ON C.CuentaAhoID = CM.CuentaAhoID
					AND CM.Fecha >= Var_FechaInicio
					AND CM.Fecha <= Par_FechaCorte
				WHERE C.ClienteID!=1 AND C.Estatus IN (Var_Activa,Var_Bloqueada)
				AND tm.Saldo <> Decimal_Cero
				GROUP BY C.CuentaAhoID ;

		-- Inserta en tmp_SaldosCaptacion
		INSERT INTO tmp_SaldosCaptacion
			SELECT C.CuentaAhoID AS Cuenta, Var_Ahorro,
				SUM(CASE WHEN CM.NatMovimiento = Var_Activa THEN IFNULL(CM.CantidadMov,Decimal_Cero)
						ELSE IFNULL(CM.CantidadMov,Decimal_Cero) * -1  END) + IFNULL(MAX(C.SaldoIniMes),Decimal_Cero) AS Importe,
						Decimal_Cero AS Saldo_Garantias,	Suc.NombreSucurs,	Suc.SucursalID,	T.Descripcion,Tipo_Ahorro,
						Cli.NombreCompleto,
					CASE C.Estatus WHEN Var_Activa THEN Est_Activo
						WHEN Var_Bloqueada THEN Est_Bloqueado END AS Estatus, MAX(Cli.ClienteID)
			FROM  CUENTASAHO C
				LEFT JOIN CUENTASAHOMOV CM ON C.CuentaAhoID = CM.CuentaAhoID
					AND CM.Fecha >= Var_FechaInicio
					AND CM.Fecha <= Par_FechaCorte
				INNER JOIN TIPOSCUENTAS T ON T.TipoCuentaID = C.TipoCuentaID
				INNER JOIN SUCURSALES Suc ON C.SucursalID   = Suc.SucursalID
				INNER JOIN CLIENTES Cli   ON C.ClienteID 	= Cli.ClienteID
					WHERE C.Saldo> Par_MinimoSaldo AND C.ClienteID!=1
						AND C.Estatus IN (Var_Activa,Var_Bloqueada)
						AND FechaApertura <= Par_FechaCorte
						AND C.CuentaAhoid NOT IN(SELECT DISTINCT Cuenta FROM tmp_SaldosBloqueo WHERE Saldo <> Decimal_Cero )
					GROUP BY  C.CuentaAhoID;

		-- Inversiones que no las hayan vencido anticiapadamente
		INSERT INTO tmp_SaldosCaptacion
			SELECT Inv.InversionID,	Var_Inversion ,Inv.Monto AS Importe, Decimal_Cero AS Saldo_Garantias,
					Suc.NombreSucurs, Suc.SucursalID, Cat.Descripcion,Tipo_Inversion, Cl.NombreCompleto,
				CASE Inv.Estatus WHEN Var_Vigente THEN Est_Vigente END AS Estatus, Cl.ClienteID
			FROM INVERSIONES  Inv
				INNER JOIN CATINVERSION Cat ON Inv.TipoInversionID = Cat.TipoInversionID
				INNER JOIN CLIENTES Cl 		ON Cl.ClienteID 	   = Inv.ClienteID
				INNER JOIN SUCURSALES Suc 	ON Cl.SucursalOrigen   = Suc.SucursalID
					WHERE Inv.FechaVencimiento > Par_FechaCorte
						AND Inv.FechaInicio <= Par_FechaCorte
						AND Inv.Estatus NOT IN (Var_Inactiva,Var_Cancelado)
						AND  Inv.FechaVenAnt = Fecha_Vacia ;

		-- Inversiones que se se vencieron anticipadamente
		INSERT INTO tmp_SaldosCaptacion
			SELECT Inv.InversionID,	Var_Inversion,Inv.Monto AS Importe, Decimal_Cero AS Saldo_Garantias,
				Suc.NombreSucurs, Suc.SucursalID, Cat.Descripcion,Tipo_Inversion, Cl.NombreCompleto,
				CASE Inv.Estatus WHEN Var_Vigente THEN Est_Vigente END AS Estatus, Cl.ClienteID
			FROM INVERSIONES  Inv
				INNER JOIN CATINVERSION Cat ON Inv.TipoInversionID = Cat.TipoInversionID
				INNER JOIN CLIENTES Cl 		ON Cl.ClienteID 	   = Inv.ClienteID
				INNER JOIN SUCURSALES Suc 	ON Cl.SucursalOrigen   = Suc.SucursalID
					WHERE  Inv.FechaVencimiento >	Par_FechaCorte
						AND Inv.FechaInicio <=	Par_FechaCorte
						AND Inv.Estatus NOT IN (Var_Inactiva)
						AND  Inv.FechaVenAnt >Par_FechaCorte;
	ELSE
		-- CAPTACION
		INSERT INTO SaldoCuentasGL
			SELECT C.CuentaAhoID AS Cuenta,
				SUM(CASE WHEN CM.NatMovimiento = Var_Activa THEN IFNULL(CM.CantidadMov,Decimal_Cero)
					ELSE IFNULL(CM.CantidadMov,Decimal_Cero) * -1  END) + IFNULL(MAX(C.SaldoIniMes),Decimal_Cero) AS Importe
			FROM  `HIS-CUENTASAHO`  C
				INNER JOIN tmp_SaldosBloqueo tm ON C.CuentaAhoID = tm.Cuenta
				LEFT JOIN `HIS-CUENAHOMOV` CM ON C.CuentaAhoID   = CM.CuentaAhoID
					AND CM.Fecha >= Var_FechaInicio
					AND CM.Fecha <= Par_FechaCorte
				WHERE  C.ClienteID!=1   AND C.Estatus IN (Var_Activa, Var_Bloqueada)
					AND substring(C.Fecha,1,7) = substring(Par_FechaCorte,1,7)
					AND tm.Saldo<>Decimal_Cero
				GROUP BY C.CuentaAhoID ;

		INSERT INTO tmp_SaldosCaptacion
			SELECT C.CuentaAhoID, Var_Ahorro,
				SUM(CASE WHEN CM.NatMovimiento = Var_Activa THEN
				IFNULL(CM.CantidadMov,Decimal_Cero)
					ELSE IFNULL(CM.CantidadMov,Decimal_Cero) * -1  END) + IFNULL(MAX(C.SaldoIniMes),Decimal_Cero) AS Importe,
				Decimal_Cero AS Saldo_Garantias,
				MAX(Suc.NombreSucurs) AS NombreSucurs, MAX(Suc.SucursalID) AS SucursalID, MAX(T.Descripcion) AS Descripcion, Tipo_Ahorro, MAX(Cli.NombreCompleto) AS NombreCompleto,
				CASE MAX(C.Estatus) WHEN Var_Activa THEN Est_Activo
					WHEN Var_Bloqueada THEN Est_Bloqueado END AS Estatus, MAX(Cli.ClienteID)
			FROM `HIS-CUENTASAHO` C
				INNER JOIN  TIPOSCUENTAS T 	ON T.TipoCuentaID	=	C.TipoCuentaID
				LEFT  JOIN `HIS-CUENAHOMOV` CM ON C.CuentaAhoID = 	CM.CuentaAhoID
					AND CM.Fecha >= Var_FechaInicio AND CM.Fecha <= Par_FechaCorte
				INNER JOIN SUCURSALES Suc ON C.SucursalID = Suc.SucursalID
				INNER JOIN CLIENTES Cli   ON C.ClienteID  = Cli.ClienteID
					WHERE C.Saldo> Par_MinimoSaldo
						AND  C.ClienteID!=1
						AND  C.Estatus IN (Var_Activa,Var_Bloqueada)
						AND  substring(C.Fecha,1,7) = substring(Par_FechaCorte,1,7)
						AND C.CuentaAhoID NOT IN(SELECT DISTINCT Cuenta FROM tmp_SaldosBloqueo WHERE Saldo <> Decimal_Cero)
					GROUP BY C.CuentaAhoID;

		-- Inversiones que no las hayan vencido anticiapadamente
		INSERT INTO tmp_SaldosCaptacion
			SELECT Inv.InversionID,	Var_Inversion,Inv.Monto AS Importe, Decimal_Cero AS Saldo_Garantias,
				Suc.NombreSucurs, Suc.SucursalID, Cat.Descripcion,Tipo_Inversion, Cl.NombreCompleto,
				CASE Inv.Estatus WHEN Var_Vigente THEN Est_Vigente END AS Estatus, Cl.ClienteID
			FROM INVERSIONES  Inv
				INNER JOIN CATINVERSION Cat ON Inv.TipoInversionID = Cat.TipoInversionID
				INNER JOIN CLIENTES Cl      ON Cl.ClienteID = Inv.ClienteID
				INNER JOIN SUCURSALES Suc   ON Cl.SucursalOrigen = Suc.SucursalID
					WHERE  Inv.FechaVencimiento > Par_FechaCorte
						AND Inv.FechaInicio <=	Par_FechaCorte
						AND Inv.Estatus NOT IN (Var_Inactiva,Var_Cancelado)
						AND  Inv.FechaVenAnt = Fecha_Vacia;

		-- Inversiones que se se vencieron anticipadamente
		INSERT INTO tmp_SaldosCaptacion
			SELECT Inv.InversionID,	Var_Inversion,	Inv.Monto AS Importe, Decimal_Cero AS Saldo_Garantias,
				Suc.NombreSucurs, Suc.SucursalID, Cat.Descripcion,Tipo_Inversion, Cl.NombreCompleto,
				CASE Inv.Estatus WHEN Var_Vigente THEN Est_Vigente END AS Estatus, Cl.ClienteID
			FROM INVERSIONES  Inv
				INNER JOIN CATINVERSION Cat ON Inv.TipoInversionID = Cat.TipoInversionID
				INNER JOIN CLIENTES Cl      ON Cl.ClienteID        = Inv.ClienteID
				INNER JOIN SUCURSALES Suc   ON Cl.SucursalOrigen   = Suc.SucursalID
					WHERE  Inv.FechaVencimiento > Par_FechaCorte
						AND Inv.FechaInicio <=  Par_FechaCorte
						AND Inv.Estatus NOT IN  (Var_Inactiva)
						AND Inv.FechaVenAnt >   Par_FechaCorte;
	END IF;

	-- Si requieren que se muetra los saldos de Garantia liquida en el reporte
	IF(Par_MostrarGL = ReporteSinGarLiq) THEN

		INSERT INTO tmp_SaldosCaptacion
			SELECT t.Cuenta AS NumCuenta, P.Descripcion,SG.Importe  AS importe ,t.Saldo AS Saldo_Garantias,
					Suc.NombreSucurs, Suc.SucursalID, P.Descripcion, Tipo_Ahorro, Cli.NombreCompleto,
					CASE Cu.Estatus WHEN Var_Activa THEN Est_Activo
						WHEN Var_Bloqueada THEN Est_Bloqueado END AS Estatus, Cli.ClienteID
			FROM tmp_SaldosBloqueo t
				LEFT JOIN  SaldoCuentasGL SG  ON  t.Cuenta 	          = SG.Cuenta
				INNER JOIN CREDITOS C 		  ON  t.Referencia 		  = C.CreditoID
				INNER JOIN PRODUCTOSCREDITO P ON  C.ProductoCreditoID = P.ProducCreditoID
				INNER JOIN CUENTASAHO Cu 	  ON  t.Cuenta            = Cu.CuentaAhoID
				INNER JOIN CLIENTES Cli 	  ON  Cu.ClienteID 		  = Cli.ClienteID
				INNER JOIN SUCURSALES Suc 	  ON  Cu.SucursalID 	  = Suc.SucursalID
			WHERE t.Saldo <> Decimal_Cero;

	END IF;

 	-- Si requieren que se muetra las Cuentas Registrada que no se han Autorizaron
	IF(Par_CtasEstRegis=Var_CtasEstRegis) THEN

		-- Creditos que Esta con estatus Registrados Actualmente
		INSERT INTO tmp_SaldosCaptacion
			SELECT C.CuentaAhoID AS Cuenta, Var_Ahorro, Decimal_Cero AS Importe,
				Decimal_Cero AS Saldo_Garantias,	Suc.NombreSucurs,Suc.SucursalID,T.Descripcion,Tipo_Ahorro,
				Cli.NombreCompleto, Est_Registrado  AS Estatus,	Cli.ClienteID
			FROM  CUENTASAHO C
				INNER JOIN TIPOSCUENTAS T ON T.TipoCuentaID = C.TipoCuentaID
				INNER JOIN SUCURSALES Suc ON C.SucursalID   = Suc.SucursalID
	            INNER JOIN CLIENTES Cli   ON C.ClienteID    = Cli.ClienteID
					WHERE FechaReg <= Par_FechaCorte
						AND  IFNULL(FechaApertura,Cadena_Vacia)= Cadena_Vacia
						AND IFNULL(C.FechaCan,Cadena_Vacia)= Cadena_Vacia;

		--  Creditos que Estuvieron con estatus registrados y que posteriormente lo Activaron
		INSERT INTO tmp_SaldosCaptacion
			SELECT C.CuentaAhoID AS Cuenta, Var_Ahorro, Decimal_Cero AS Importe,
				Decimal_Cero AS Saldo_Garantias,Suc.NombreSucurs,Suc.SucursalID,T.Descripcion,Tipo_Ahorro,
				Cli.NombreCompleto, Est_Registrado  AS Estatus,	Cli.ClienteID
			FROM  CUENTASAHO C
				INNER JOIN TIPOSCUENTAS T ON T.TipoCuentaID = C.TipoCuentaID
				INNER JOIN SUCURSALES Suc ON C.SucursalID   = Suc.SucursalID
		        INNER JOIN CLIENTES Cli   ON C.ClienteID    = Cli.ClienteID
					WHERE   C.FechaReg <> C.FechaApertura
					AND C.FechaReg <= Par_FechaCorte
					AND C.FechaApertura > Par_FechaCorte
					AND (IFNULL(C.FechaCan,Cadena_Vacia)= Cadena_Vacia OR C.FechaCan > Par_FechaCorte);

		-- Creditos que Estuvieron con estatus registrados y los cancelaron posteriormente
		INSERT INTO tmp_SaldosCaptacion
			SELECT C.CuentaAhoID AS Cuenta,	Var_Ahorro, Decimal_Cero AS Importe,
				Decimal_Cero AS Saldo_Garantias,	Suc.NombreSucurs, Suc.SucursalID, T.Descripcion,Tipo_Ahorro,
				Cli.NombreCompleto,	Est_Registrado  AS Estatus, Cli.ClienteID
			FROM  CUENTASAHO C
				INNER JOIN TIPOSCUENTAS T ON T.TipoCuentaID = C.TipoCuentaID
				INNER JOIN SUCURSALES Suc ON C.SucursalID   = Suc.SucursalID
		        INNER JOIN CLIENTES Cli   ON C.ClienteID    = Cli.ClienteID
					WHERE   C.FechaReg <= Par_FechaCorte
						AND IFNULL(C.FechaApertura,Cadena_Vacia)= Cadena_Vacia
						AND C.FechaCan > Par_FechaCorte;
	END IF;


	IF (Var_FechaSistema =   Par_FechaCorte) THEN

		--  CREDITOS
		INSERT INTO Temp_SaldosCredito
			SELECT C.CreditoID, MAX(Cli.NombreCompleto) AS NombreCompleto, MAX(P.Descripcion) AS Descripcion, MAX(C.MontoCredito) AS Monto_Credito,
				SUM(AM.SaldoCapVigente+AM.SaldoCapAtrasa+AM.SaldoCapVencido+AM.SaldoCapVenNExi) AS 'Saldo Capital',
				SUM(AM.SaldoInteresPro+AM.SaldoInteresAtr+AM.SaldoInteresVen+AM.SaldoIntNoConta) AS 'Saldo Intereses',
				MAX(Suc.NombreSucurs) AS NombreSucurs,	Cli.ClienteID
		FROM  CREDITOS C
			INNER JOIN AMORTICREDITO AM	  ON C.CreditoID = AM.CreditoID
		    INNER JOIN CLIENTES Cli       ON C.ClienteID = Cli.ClienteID
		    INNER JOIN PRODUCTOSCREDITO P ON C.ProductoCreditoID = P.ProducCreditoID
			INNER JOIN SUCURSALES Suc     ON C.SucursalID = Suc.SucursalID
		WHERE P.ProducCreditoID = C.ProductoCreditoID
			AND AM.Estatus <> Var_Pagado
			AND C.Estatus IN (Var_EstatusVige,Var_Bloqueada,Var_Castigado)
		GROUP BY C.CreditoID ORDER BY C.SucursalID ASC;

	ELSE

		INSERT INTO Temp_SaldosCredito
			SELECT S.CreditoID, MAX(Cli.NombreCompleto) AS NombreCompleto, MAX(P.Descripcion) AS Descripcion, MAX(S.MontoCredito) AS Monto_Credito,
				SUM(SalCapVigente+SalCapAtrasado+SalCapVencido+SalCapVenNoExi) AS 'Saldo Capital',
				SUM(SalIntOrdinario+SalIntAtrasado+SalIntVencido+SalIntProvision+SalIntNoConta) AS 'Saldo Intereses',
				MAX(Suc.NombreSucurs) AS NombreSucurs,	 Cli.ClienteID
			FROM SALDOSCREDITOS S
				INNER JOIN CREDITOS C ON S.CreditoID = C.CreditoID
			    INNER JOIN CLIENTES Cli ON C.ClienteID = Cli.ClienteID
			    INNER JOIN PRODUCTOSCREDITO P ON C.ProductoCreditoID = P.ProducCreditoID
				INNER JOIN SUCURSALES Suc ON C.SucursalID =Suc.SucursalID
		WHERE P.ProducCreditoID=C.ProductoCreditoID AND S.FechaCorte=Par_FechaCorte
		GROUP BY S.CreditoID ORDER BY C.SucursalID ASC;

	END IF;

	IF (ReporteDetallado = Par_TipoReporte) THEN

		IF(Par_NumCon = Con_DetCaptacionPDF OR Par_NumCon = Con_DetCapExcel )THEN

			IF(Par_MostrarGL = ReporteSinGarLiq) THEN
				SELECT NumCuenta,UPPER(NombreCliente) AS NombreCliente, UPPER(Descripcion) AS Descripcion,	Estatus,
					   UPPER(Producto) AS Producto,	UPPER(TipoProducto) AS TipoProducto,	IFNULL(Importe,Decimal_Cero) AS Importe,
                       IFNULL(SaldoGarantias,Decimal_Cero) AS SaldoGarantias,	Sucursal, ClienteID
				FROM tmp_SaldosCaptacion ORDER BY TipoProducto,SucursalID ASC;
			ELSE
				SELECT NumCuenta,	UPPER(NombreCliente) AS NombreCliente ,	UPPER(Descripcion) AS Descripcion,	Estatus,
					   UPPER(Producto) AS Producto,	UPPER(TipoProducto) AS TipoProducto,	IFNULL(Importe,Decimal_Cero) AS Importe,
                       Decimal_Cero AS SaldoGarantias,	Sucursal,	 ClienteID
				FROM tmp_SaldosCaptacion
				ORDER BY TipoProducto,SucursalID ASC;
			END IF;
		ELSE IF(Par_NumCon = Con_DetCarteraPDF OR Par_NumCon = Con_DetCarteraExcel)THEN

			SELECT CreditoID, UPPER(NombreCompleto) AS NombreCompleto, UPPER(Descripcion) AS Descripcion, MontoCredito,	IFNULL(SaldoCapital,Decimal_Cero) AS SaldoCapital,
				IFNULL(SaldoInteres,Decimal_Cero) AS SaldoInteres,	NombreSucurs, ClienteID
				FROM Temp_SaldosCredito;

			END IF;
		END IF;
	END IF;


	IF (ReporteGLOBAL = Par_TipoReporte) THEN

		IF(Par_NumCon = Con_SumCaptacionPDF OR Par_NumCon = Con_SumCapExcel )THEN

			IF(Par_MostrarGL = ReporteSinGarLiq ) THEN

				SELECT COUNT(*) AS Cantidad, UPPER(Descripcion) AS Descripcion,	UPPER(TipoProducto) AS TipoProducto, IFNULL(SUM(Importe),Decimal_Cero) AS Saldo ,
						IFNULL(SUM(SaldoGarantias),Decimal_Cero) AS GarantiaLiquida, Entero_Cero
					FROM tmp_SaldosCaptacion
					GROUP BY Descripcion, TipoProducto
					ORDER BY TipoProducto ASC;

			ELSE
					SELECT COUNT(*) AS Cantidad, UPPER(Descripcion) AS Descripcion,	UPPER(TipoProducto) AS TipoProducto, IFNULL(SUM(Importe),Decimal_Cero) AS Saldo ,
					Decimal_Cero AS	GarantiaLiquida, Entero_Cero FROM tmp_SaldosCaptacion
					GROUP BY Descripcion, TipoProducto
                    ORDER BY TipoProducto ASC;

			 END IF;
		ELSE
			IF(Par_NumCon = Con_SumCarteraPDF OR Par_NumCon = Con_SumCarteraExcel)THEN

				SELECT COUNT(CreditoID) AS Cantidad ,	UPPER(Descripcion) AS Descripcion, IFNULL(SUM(MontoCredito),Decimal_Cero) AS MontoCredito,
					IFNULL(SUM(SaldoCapital),Decimal_Cero) AS SaldoCapital,
					IFNULL(SUM(SaldoInteres),Decimal_Cero) AS SaldoIntereses, Entero_Cero
				FROM Temp_SaldosCredito
				GROUP BY Descripcion;
			END IF;
		END IF;
	END IF;

END  TerminaStore$$