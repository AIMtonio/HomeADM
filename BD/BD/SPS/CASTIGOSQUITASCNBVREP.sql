-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CASTIGOSQUITASCNBVREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CASTIGOSQUITASCNBVREP`;DELIMITER $$

CREATE PROCEDURE `CASTIGOSQUITASCNBVREP`(
-- ---------------------------------------------------
-- SP PARA GENERAR EL REPORTE DE CASTIGOS Y QUITAS CNBV
-- ---------------------------------------------------
    Par_Fecha			DATE,    			-- Parametro Fecha
    Par_Sucursal		INT(11), 			-- Parametro Sucursal
    Par_Moneda			INT(11), 			-- Parametro Moneda
    Par_ProductoCre 	INT(11), 			-- Parametro Producto
    Par_Promotor 		INT(11), 			-- Parametro Promotor

    Par_Genero 			CHAR(1), 			-- Parametro Genero
    Par_Estado 			INT(11), 			-- Parametro Estado
    Par_Municipio 		INT(11), 			-- Parametro Municipio
   	Par_NumReporte      TINYINT UNSIGNED,


    Par_EmpresaID 		INT(11), 			-- Parametro de Auditoria
    Aud_Usuario 		INT(11), 			-- Parametro de Auditoria
    Aud_FechaActual 	DATETIME,    		-- Parametro de Auditoria
    Aud_DireccionIP 	VARCHAR(15), 		-- Parametro de Auditoria

    Aud_ProgramaID	 	VARCHAR(50), 		-- Parametro de Auditoria
    Aud_Sucursal 		INT(11),     		-- Parametro de Auditoria
    Aud_NumTransaccion 	BIGINT(20))
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
	DECLARE Var_Sentencia       VARCHAR(9000);	-- Variable sentencia
    DECLARE Var_PerFisica       CHAR(1);       	-- Indica el tipo de persona
    DECLARE Var_FinMes			DATE;			-- Fin de Mes
    DECLARE Var_FinMesAnt		DATE;			-- Fin de Mes(2 meses anteriores)
    DECLARE Var_InicioMes		DATE;			-- Fecha de Inicio de Mes

	-- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia        CHAR(1); 		-- Cadena vacia
    DECLARE Decimal_Cero		DECIMAL(14,2);	-- Decimal Cero
	DECLARE Fecha_Vacia         DATE;    		-- Fecha Vacia
	DECLARE Entero_Cero         INT(11); 		-- Entero Cero
	DECLARE EstatusVigente      CHAR(1); 		-- Estatus Vigente
	DECLARE EstatusVencido      CHAR(1); 		-- Estatus Vencido
    DECLARE Cons_SI				CHAR(1);		-- Constante SI
    DECLARE Cons_BloqGarLiq     INT(11);
    DECLARE Est_Bloqueado		CHAR(1);		-- Constante Bloqueado

    DECLARE Rep_Excel       	INT(11);		-- Tipo de Reporte Excel
	DECLARE Rep_Csv				INT(11); 		-- Tipo de Reporte CSV

	-- Asignacion de constantes
	SET Cadena_Vacia            := '';
    SET Decimal_Cero			:= 0.00;
	SET Fecha_Vacia             := '1900-01-01';
	SET Entero_Cero             :=	0;
	SET EstatusVigente          := 'V';
	SET EstatusVencido          := 'B';
	SET Var_PerFisica           := 'F';

    SET Cons_SI					:= 	'S';
    SET Cons_BloqGarLiq      	:=	8;
    SET Est_Bloqueado			:= 'B';
    SET Rep_Excel       		:= 	1;
	SET Rep_Csv					:=	2;

	CALL TRANSACCIONESPRO (Aud_NumTransaccion);


    SET Var_InicioMes := (SELECT SUBDATE(Par_Fecha, DAYOFMONTH(Par_Fecha) - 1));

    DROP TABLE IF EXISTS TMP_FECHA;
    CREATE TABLE TMP_FECHA(
		FechaEncIni			DATE,
        FechaEncFin			DATE
	);

	INSERT INTO TMP_FECHA VALUES(Var_InicioMes,	Par_Fecha);

	DROP TABLE IF EXISTS tmp_CASTIGOSQUITASCNBVREP;
	CREATE TEMPORARY TABLE tmp_CASTIGOSQUITASCNBVREP (
			Transaccion         BIGINT(20),
			ClienteID           INT(11),
			NombreCompleto      VARCHAR(200),
			CreditoID           BIGINT(12),
            Estatus				CHAR(1),
			SucursalID          INT(11),
            ClasiDestinCred		VARCHAR(20),
			ProductoCreditoID   VARCHAR(200),
			MontoCredito        DECIMAL(12,2),
			FechaOtorgamiento   DATE,
            FechaVencimiento	DATE,
            TasaInteres			DECIMAL(12,4),
			DiasMora	        INT(11),
            SaldoInsoluto 		DECIMAL(14,2),
			InteresesVencido    DECIMAL(14,2),
			InteresMoratorio    DECIMAL(14,2),
			InteresRefinanciado DECIMAL(14,2),
			MontoCastigo		DECIMAL(14,2),
            MontoCondonacion	DECIMAL(14,2),
            FechaCastigo		DATE,
			MontoEPRC	        DECIMAL(14,2),
			MontoGarLiquida     DECIMAL(14,2),
            INDEX tmp_CASTIGOSQUITASCNBVREP_idx1(CreditoID),
            INDEX tmp_CASTIGOSQUITASCNBVREP_idx2(Transaccion));


	DROP TABLE IF EXISTS TMP_CREQUITAS;
	CREATE TABLE TMP_CREQUITAS(
		CreditoID			BIGINT(12),
        SaldoCapital		DECIMAL(14,2),
        InteresVencido		DECIMAL(14,2),
        InteresMoratorio	DECIMAL(14,2),
        InteresRefinanciado	DECIMAL(14,2),
		MontoCondonacion	DECIMAL(14,2),
		FechaRegistro		DATE,
	PRIMARY KEY (CreditoID)
	);

	INSERT INTO TMP_CREQUITAS
	SELECT MAX(CreditoID),	SUM(SaldoCapital), SUM(SaldoInteres), SUM(SaldoMoratorios),	Decimal_Cero,
			IFNULL(((SUM(MontoInteres)) +(SUM(MontoMoratorios)) +(SUM(MontoCapital)) + (SUM(MontoComisiones))),0),
            MAX(FechaRegistro)
			FROM CREQUITAS WHERE FechaRegistro BETWEEN  Var_InicioMes AND Par_Fecha
		GROUP BY CreditoID;

   	# ===================== CONDONACIONES ====================================
    # Se llena la tabla principal con los datos de QUITAS
	SET Var_Sentencia := '
	INSERT INTO tmp_CASTIGOSQUITASCNBVREP (Transaccion,
		ClienteID,			NombreCompleto,		CreditoID,			Estatus,			SucursalID ,
		ClasiDestinCred,	ProductoCreditoID,	MontoCredito ,		FechaOtorgamiento,	FechaVencimiento,
        TasaInteres,		DiasMora,			SaldoInsoluto,		InteresesVencido,	InteresMoratorio,
        InteresRefinanciado,MontoCastigo,		MontoCondonacion,	FechaCastigo,		MontoEPRC,
        MontoGarLiquida)';
	SET Var_Sentencia :=    CONCAT(Var_Sentencia, '
		SELECT
		CONVERT("',Aud_NumTransaccion,'",UNSIGNED INT),
			Cre.ClienteID,		CLI.NombreCompleto,	T1.CreditoID,
            Cre.Estatus, 		CLI.SucursalOrigen,
            CASE  WHEN Cre.ClasiDestinCred = "C" THEN "COMERCIAL"
					WHEN Cre.ClasiDestinCred = "O" THEN "CONSUMO"
                    WHEN Cre.ClasiDestinCred = "H" THEN "VIVIENDA"
				ELSE ""
			END,	CONCAT(Cre.ProductoCreditoID,"-",PRO.Descripcion),	Cre.MontoCredito,		Cre.FechaMinistrado, Cre.FechaVencimien,
            Cre.TasaFija,	SAL.DiasAtraso,			T1.SaldoCapital,				T1.InteresVencido,
            T1.InteresMoratorio,	T1.InteresRefinanciado,	0.00, T1.MontoCondonacion, "1900-01-01", 0.00,				0.00');

	SET Var_Sentencia :=    CONCAT(Var_Sentencia,
		   '
		FROM TMP_CREQUITAS T1
		INNER JOIN CREDITOS Cre ON Cre.CreditoID = T1.CreditoID
		INNER JOIN PRODUCTOSCREDITO PRO ON PRO.ProducCreditoID = Cre.ProductoCreditoID
        INNER JOIN SALDOSCREDITOS SAL ON SAL.CreditoID = Cre.CreditoID');

	SET Par_ProductoCre := IFNULL(Par_ProductoCre,Entero_Cero);
	IF(Par_ProductoCre != Entero_Cero)THEN
		SET Var_Sentencia :=  CONCAT(Var_sentencia,' AND SAL.ProductoCreditoID =',CONVERT(Par_ProductoCre,CHAR));
	END IF;

	SET Var_Sentencia :=    CONCAT(Var_Sentencia,' 	INNER JOIN CLIENTES CLI ON SAL.ClienteID = CLI.ClienteID');

	SET Par_Genero := IFNULL(Par_Genero,Cadena_Vacia);
		IF(Par_Genero!=Cadena_Vacia)THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND CLI.Sexo="',Par_Genero,'" AND CLI.TipoPersona="',Var_PerFisica,'"');
	   END IF;

	SET Par_Estado := IFNULL(Par_Estado,Entero_Cero);
	IF(Par_Estado != Entero_Cero)THEN
		SET Var_Sentencia := CONCAT(Var_sentencia,'
		LEFT JOIN DIRECCLIENTE Dir ON CLI.ClienteID=Dir.ClienteID AND Dir.Oficial="',Cons_SI,'"  AND Dir.EstadoID= ',CONVERT(Par_Estado,CHAR));
	END IF;

	SET Par_Municipio := IFNULL(Par_Municipio,Entero_Cero);
	IF(Par_Municipio != Entero_Cero)THEN
		SET Var_Sentencia := CONCAT(Var_sentencia,'
		LEFT JOIN DIRECCLIENTE Dir2 ON CLI.ClienteID=Dir2.ClienteID AND Dir.Oficial="',Cons_SI,'"  AND Dir2.MunicipioID= ',CONVERT(Par_Municipio,CHAR));
	END IF;

	SET Var_Sentencia :=    CONCAT(Var_Sentencia,'
		INNER JOIN PROMOTORES PROM ON PROM.PromotorID=CLI.PromotorActual ');
	SET Par_Promotor := IFNULL(Par_Promotor,Entero_Cero);
	IF(Par_Promotor != Entero_Cero)THEN
		SET Var_Sentencia := CONCAT(Var_sentencia,'  AND PROM.PromotorID=',CONVERT(Par_Promotor,CHAR));
	END IF;
	SET Par_Moneda := IFNULL(Par_Moneda,Entero_Cero);
	IF(Par_Moneda != Entero_Cero)THEN
		SET Var_Sentencia = CONCAT(Var_sentencia,' AND SAL.MonedaID=',CONVERT(Par_Moneda,CHAR));
	END IF;
	SET Var_Sentencia :=    CONCAT(Var_Sentencia, '
		INNER JOIN SUCURSALES Suc ON Suc.SucursalID =  CLI.SucursalOrigen ');
	SET Par_Sucursal := IFNULL(Par_Sucursal,Entero_Cero);
		IF(Par_Sucursal != Entero_Cero)THEN
			SET Var_Sentencia = CONCAT(Var_sentencia,' AND CLI.SucursalOrigen=',CONVERT(Par_Sucursal,CHAR));
		END IF;
	SET Var_Sentencia :=    CONCAT(Var_Sentencia,'
		WHERE  SAL.FechaCorte = (SELECT DATE_SUB(T1.FechaRegistro, INTERVAL 1 DAY))
		ORDER BY SAL.Sucursal, SAL.ProductoCreditoID,CLI.PromotorActual,SAL.CreditoID ; ');



	SET @Sentencia  = (Var_Sentencia);
	SET @Fecha  = Par_Fecha;
	PREPARE STQUITASREP FROM @Sentencia;
	EXECUTE STQUITASREP;




	# ===================== CASTIGOS ====================================
	DROP TABLE IF EXISTS TMP_CASTIGOS;
    CREATE TABLE TMP_CASTIGOS(
		CreditoID			BIGINT(12),
		SaldoCapital		DECIMAL(14,2),
		InteresVencido		DECIMAL(14,2),
		InteresMoratorio	DECIMAL(14,2),
		InteresRefinanciado	DECIMAL(14,2),
		MontoCastigo		DECIMAL(14,2),
		FechaCastigo		DATE,
	PRIMARY KEY (CreditoID)
	);

	INSERT INTO TMP_CASTIGOS
	SELECT	CreditoID,		SaldoCapital,	SaldoInteres,	SaldoMoratorio,	SaldoCapital,
			TotalCastigo,	Fecha
			FROM CRECASTIGOS WHERE Fecha BETWEEN  Var_InicioMes AND Par_Fecha;


 # Se llena la tabla principal con los datos de CASTIGOS
	SET Var_Sentencia := '
	INSERT INTO tmp_CASTIGOSQUITASCNBVREP (Transaccion,
		ClienteID,			NombreCompleto,		CreditoID,			Estatus,			SucursalID ,
		ClasiDestinCred,	ProductoCreditoID,	MontoCredito ,		FechaOtorgamiento,	FechaVencimiento,
        TasaInteres,		DiasMora,			SaldoInsoluto,		InteresesVencido,	InteresMoratorio,
        InteresRefinanciado,MontoCastigo,		MontoCondonacion,	FechaCastigo,		MontoEPRC,
        MontoGarLiquida)';

	SET Var_Sentencia :=    CONCAT(Var_Sentencia, '
		SELECT
		CONVERT("',Aud_NumTransaccion,'",UNSIGNED INT),
			Cre.ClienteID,		CLI.NombreCompleto,	T2.CreditoID,
            Cre.Estatus, 		CLI.SucursalOrigen,
            CASE  WHEN Cre.ClasiDestinCred = "C" THEN "COMERCIAL"
					WHEN Cre.ClasiDestinCred = "O" THEN "CONSUMO"
                    WHEN Cre.ClasiDestinCred = "H" THEN "VIVIENDA"
				ELSE ""
			END,	CONCAT(Cre.ProductoCreditoID,"-",PRO.Descripcion),	Cre.MontoCredito,		Cre.FechaMinistrado, Cre.FechaVencimien,
            Cre.TasaFija,	SAL.DiasAtraso,			T2.SaldoCapital,				T2.InteresVencido,
            T2.InteresMoratorio,	T2.InteresRefinanciado,	T2.MontoCastigo, 0.00, T2.FechaCastigo, 0.00,				0.00');

	SET Var_Sentencia :=    CONCAT(Var_Sentencia,
		   '
		FROM TMP_CASTIGOS T2
		INNER JOIN CREDITOS Cre ON Cre.CreditoID = T2.CreditoID
		INNER JOIN PRODUCTOSCREDITO PRO ON PRO.ProducCreditoID = Cre.ProductoCreditoID
        INNER JOIN SALDOSCREDITOS SAL ON SAL.CreditoID = Cre.CreditoID');

	SET Par_ProductoCre := IFNULL(Par_ProductoCre,Entero_Cero);
	IF(Par_ProductoCre != Entero_Cero)THEN
		SET Var_Sentencia :=  CONCAT(Var_sentencia,' AND SAL.ProductoCreditoID =',CONVERT(Par_ProductoCre,CHAR));
	END IF;

	SET Var_Sentencia :=    CONCAT(Var_Sentencia,' 	INNER JOIN CLIENTES CLI ON SAL.ClienteID = CLI.ClienteID');

	SET Par_Genero := IFNULL(Par_Genero,Cadena_Vacia);
		IF(Par_Genero!=Cadena_Vacia)THEN
			SET Var_Sentencia := CONCAT(Var_sentencia,' AND CLI.Sexo="',Par_Genero,'" AND CLI.TipoPersona="',Var_PerFisica,'"');
	   END IF;

	SET Par_Estado := IFNULL(Par_Estado,Entero_Cero);
	IF(Par_Estado != Entero_Cero)THEN
		SET Var_Sentencia := CONCAT(Var_sentencia,'
		LEFT JOIN DIRECCLIENTE Dir ON CLI.ClienteID=Dir.ClienteID AND Dir.Oficial="',Cons_SI,'"  AND Dir.EstadoID= ',CONVERT(Par_Estado,CHAR));
	END IF;

	SET Par_Municipio := IFNULL(Par_Municipio,Entero_Cero);
	IF(Par_Municipio != Entero_Cero)THEN
		SET Var_Sentencia := CONCAT(Var_sentencia,'
		LEFT JOIN DIRECCLIENTE Direc ON CLI.ClienteID=Direc.ClienteID AND Direc.Oficial="',Cons_SI,'"  AND Direc.MunicipioID= ',CONVERT(Par_Municipio,CHAR));
	END IF;

	SET Var_Sentencia :=    CONCAT(Var_Sentencia,'
		INNER JOIN PROMOTORES PROM ON PROM.PromotorID=CLI.PromotorActual ');
	SET Par_Promotor := IFNULL(Par_Promotor,Entero_Cero);
	IF(Par_Promotor != Entero_Cero)THEN
		SET Var_Sentencia := CONCAT(Var_sentencia,'  AND PROM.PromotorID=',CONVERT(Par_Promotor,CHAR));
	END IF;
	SET Par_Moneda := IFNULL(Par_Moneda,Entero_Cero);
	IF(Par_Moneda != Entero_Cero)THEN
		SET Var_Sentencia = CONCAT(Var_sentencia,' AND SAL.MonedaID=',CONVERT(Par_Moneda,CHAR));
	END IF;
	SET Var_Sentencia :=    CONCAT(Var_Sentencia, '
		INNER JOIN SUCURSALES Suc ON Suc.SucursalID =  Cre.SucursalID ');
	SET Par_Sucursal := IFNULL(Par_Sucursal,Entero_Cero);
		IF(Par_Sucursal != Entero_Cero)THEN
			SET Var_Sentencia = CONCAT(Var_sentencia,' AND Cre.SucursalID=',CONVERT(Par_Sucursal,CHAR));
		END IF;
	SET Var_Sentencia :=    CONCAT(Var_Sentencia,'
         WHERE	Cre.Estatus = "K"
          AND SAL.FechaCorte = (SELECT DATE_SUB(T2.FechaCastigo, INTERVAL 1 DAY))
		ORDER BY SAL.Sucursal, SAL.ProductoCreditoID,CLI.PromotorActual,SAL.CreditoID ; ');

	SET @Sentencia  = (Var_Sentencia);
	SET @Fecha  = Par_Fecha;
	PREPARE STCASTIGOSREP FROM @Sentencia;
	EXECUTE STCASTIGOSREP;

    # ======== ACTUALIZACION MONTO EPRC ==============
    UPDATE tmp_CASTIGOSQUITASCNBVREP Temp LEFT JOIN CALRESCREDITOS Cal
	ON Temp.CreditoID = Cal.CreditoID SET
		Temp.MontoEPRC = IFNULL(Cal.Total, Decimal_Cero)
	WHERE Cal.Fecha = Par_Fecha;


	# ======== CALCULO DE GARANTIAS ===========

    DROP  TABLE IF EXISTS tmp_CREDITOGARANTIA;

    CREATE TABLE tmp_CREDITOGARANTIA (
        CreditoID           BIGINT(12),
        MontoEnGarCta       DECIMAL(14,2),
        MontoEnGarInv       DECIMAL(14,2),
        MontoTotGarantia    DECIMAL(14,2),
        PRIMARY KEY(CreditoID)  );

# Se obtienen el total bloqueado en la cuenta por credito
    INSERT INTO tmp_CREDITOGARANTIA
        SELECT Referencia, SUM(CASE WHEN NatMovimiento = Est_Bloqueado THEN  MontoBloq ELSE MontoBloq *-1 END),
               Entero_Cero, Entero_Cero
        FROM BLOQUEOS
        WHERE DATE(FechaMov) <= Par_Fecha
        AND TiposBloqID = Cons_BloqGarLiq
        GROUP BY Referencia;

## ============ INVERSIONES EN GARANTIA  =============
    DROP  TABLE IF EXISTS tmp_INVGARCREDITO;

    CREATE TABLE tmp_INVGARCREDITO (
        CreditoID           BIGINT(12),
        MontoEnGar          DECIMAL(12,2),
        PRIMARY KEY(CreditoID));

    # Se insertan los creditos que tienen una inversion en garantia
    INSERT INTO tmp_INVGARCREDITO
        SELECT Gar.CreditoID, SUM(Gar.MontoEnGar)
            FROM CREDITOINVGAR Gar,
                 CREDITOS Cre
            WHERE FechaAsignaGar <= Par_Fecha
              AND Gar.CreditoID = Cre.CreditoID
            GROUP BY Gar.CreditoID;

	# Se actualiza el valor del monto de inversion en garantía de los creditos que estan en la tabla principal
    UPDATE tmp_CREDITOGARANTIA Prin, tmp_INVGARCREDITO Inv
		SET	Prin.MontoEnGarInv = Inv.MontoEnGar
        WHERE Prin.CreditoID = Inv.CreditoID;

	# Se eliminas los registros de los creditos que ya estan en la tabla principal
    DELETE FROM t1 USING tmp_INVGARCREDITO t1 INNER JOIN tmp_CREDITOGARANTIA t2 ON ( t1.CreditoID = t2.CreditoID );

	# Se insertan a la tabla principal los créditos que no estan
    INSERT INTO tmp_CREDITOGARANTIA
        SELECT  CreditoID, Entero_Cero, MontoEnGar,Entero_Cero
            FROM tmp_INVGARCREDITO;

	# Se eliminan los registros de la tabla que almacena los creditos con inversion en garantia
    DELETE FROM tmp_INVGARCREDITO;

	# Se insertan los creditos que ya liberaron la inversion en garantia
    INSERT INTO tmp_INVGARCREDITO
        SELECT Gar.CreditoID, SUM(Gar.MontoEnGar)
            FROM HISCREDITOINVGAR Gar,
                 CREDITOS Cre
            WHERE Gar.Fecha > Par_Fecha
              AND Gar.FechaAsignaGar <= Par_Fecha
              AND Gar.ProgramaID NOT IN ('CIERREGENERALPRO')
              AND Gar.CreditoID = Cre.CreditoID
            GROUP BY Gar.CreditoID;

	# Se actualiza el valor del monto de inversion en garantia de los creditos
    UPDATE tmp_CREDITOGARANTIA Prin, tmp_INVGARCREDITO Inv SET
        Prin.MontoEnGarInv = Prin.MontoEnGarInv + Inv.MontoEnGar
        WHERE Prin.CreditoID = Inv.CreditoID;

	# Se eliminan los registros que ya se encuentran en la tabla principal.
    DELETE FROM t1 USING tmp_INVGARCREDITO t1 INNER JOIN tmp_CREDITOGARANTIA t2 ON ( t1.CreditoID = t2.CreditoID );

	# Se insertan a la tabla principal lo que faltan
    INSERT INTO tmp_CREDITOGARANTIA
        SELECT  CreditoID,	Entero_Cero,	MontoEnGar,	Entero_Cero
            FROM tmp_INVGARCREDITO;

    DELETE FROM tmp_INVGARCREDITO;

	UPDATE tmp_CREDITOGARANTIA
		SET MontoTotGarantia = IFNULL(MontoEnGarCta, Entero_Cero) + IFNULL(MontoEnGarInv, Entero_Cero);


	UPDATE tmp_CASTIGOSQUITASCNBVREP T1, tmp_CREDITOGARANTIA T2
    SET T1.MontoGarLiquida = T2.MontoTotGarantia
    WHERE T1.CreditoID = T2.CreditoID;



    DEALLOCATE PREPARE STCASTIGOSREP;
    DEALLOCATE PREPARE STQUITASREP;

    IF(Par_NumReporte = Rep_Excel) THEN
		SELECT	ClienteID,				NombreCompleto,     	CreditoID,			SucursalID,				ClasiDestinCred,
				ProductoCreditoID,  	MontoCredito,       	FechaOtorgamiento,	FechaVencimiento,		TasaInteres,
                DiasMora,				SaldoInsoluto,      	InteresesVencido,	InteresMoratorio,		InteresRefinanciado,
                MontoCastigo,           MontoCondonacion,		FechaCastigo,		MontoEPRC,				MontoGarLiquida,
                T2.FechaEncIni,			T2.	FechaEncFin
                FROM
        TMP_FECHA  T2
        LEFT JOIN  tmp_CASTIGOSQUITASCNBVREP  T1 ON T2.FechaEncIni = T2.FechaEncIni
		WHERE T1. Transaccion = Aud_NumTransaccion
		UNION
		SELECT	'' ClienteID,				'' NombreCompleto,     ''	CreditoID,			'' SucursalID,				'' ClasiDestinCred,
				'' ProductoCreditoID,  	'' MontoCredito,       	'' FechaOtorgamiento,	'' FechaVencimiento,		'' TasaInteres,
                '' DiasMora,				'' SaldoInsoluto,     '' 	InteresesVencido,	'' InteresMoratorio,		'' InteresRefinanciado,
                '' MontoCastigo,           '' MontoCondonacion,		'' FechaCastigo,		'' MontoEPRC,				'' MontoGarLiquida,
                T2.FechaEncIni,				T2.	FechaEncFin
                FROM
        TMP_FECHA  T2;


	ELSE
		IF(Par_NumReporte = Rep_Csv) THEN
        SELECT	CONCAT(
			IFNULL(ClienteID,Cadena_Vacia),';',
            IFNULL(NombreCompleto,Cadena_Vacia),';',
			IFNULL(CreditoID, Entero_Cero),';',
            IFNULL(SucursalID,Entero_Cero),';',
            IFNULL(ClasiDestinCred,Cadena_Vacia),';',
            IFNULL(ProductoCreditoID,Cadena_Vacia),';',
            IFNULL(MontoCredito,Cadena_Vacia),';',
            IFNULL(FechaOtorgamiento,Cadena_Vacia),';',
			IFNULL(FechaVencimiento,Cadena_Vacia),';',
            IFNULL(TasaInteres,Cadena_Vacia),';',
            IFNULL(DiasMora,Cadena_Vacia),';',
            IFNULL(SaldoInsoluto,Cadena_Vacia),';',
            IFNULL(InteresesVencido,Cadena_Vacia),';',
            IFNULL(InteresMoratorio,Cadena_Vacia),';',
            IFNULL(InteresRefinanciado,Cadena_Vacia),';',
            IFNULL(MontoCastigo, Decimal_Cero),';',
			IFNULL(MontoCondonacion, Decimal_Cero),';',
            IFNULL(FechaCastigo, Fecha_Vacia),';',
			IFNULL(MontoEPRC,Cadena_Vacia),';',
			IFNULL(MontoGarLiquida,Cadena_Vacia),';') AS Valor
		FROM tmp_CASTIGOSQUITASCNBVREP
		WHERE Transaccion = Aud_NumTransaccion;

		END IF;
	END IF;


	DROP TABLE tmp_CASTIGOSQUITASCNBVREP;
END TerminaStore$$