-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SALDOSCARTERACNBVREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `SALDOSCARTERACNBVREP`;
DELIMITER $$

CREATE PROCEDURE `SALDOSCARTERACNBVREP`(
-- ---------------------------------------------------
-- SP PARA GENERAR EL REPORTE DE CARTERA DE LA CNBV
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

	-- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia        CHAR(1); 		-- Cadena vacia
	DECLARE Fecha_Vacia         DATE;    		-- Fecha Vacia
    DECLARE Decimal_Cero		DECIMAL(12,2);	-- Decimal Cero
	DECLARE Entero_Cero         INT(11); 		-- Entero Cero
	DECLARE EstatusVigente      CHAR(1); 		-- Estatus Vigente
	DECLARE EstatusVencido      CHAR(1); 		-- Estatus Vencido
	DECLARE EstatusSuspendido	CHAR(1);		-- Estatus Ssupendido
    DECLARE Cons_SI				CHAR(1);		-- Constante SI
    DECLARE Cons_BloqGarLiq     INT(11);
	DECLARE Est_Bloqueado		CHAR(1);		-- Constante Bloqueado

    DECLARE Rep_Excel       	INT(11);		-- Tipo de Reporte Excel
	DECLARE Rep_Csv				INT(11); 		-- Tipo de Reporte CSV

	-- Asignacion de constantes
	SET Cadena_Vacia            := '';
	SET Fecha_Vacia             := '1900-01-01';
    SET Decimal_Cero			:= 0.00;
	SET Entero_Cero             :=	0;
	SET EstatusVigente          := 'V';
	SET EstatusVencido          := 'B';
    SET EstatusSuspendido       := 'S';
	SET Var_PerFisica           := 'F';
    SET Est_Bloqueado			:= 'B';

    SET Cons_SI					:= 	'S';
    SET Cons_BloqGarLiq      	:=	8;
    SET Rep_Excel       		:= 	1;
	SET Rep_Csv					:=	2;

	CALL TRANSACCIONESPRO (Aud_NumTransaccion);

     DROP TABLE IF EXISTS TMP_FECHA;
    CREATE TABLE TMP_FECHA(
		FechaEncFin			DATE
	);

	INSERT INTO TMP_FECHA VALUES(Par_Fecha);

	DROP TABLE IF EXISTS tmp_SALDOSCARTERACNBVREP;
	CREATE TEMPORARY TABLE tmp_SALDOSCARTERACNBVREP (
			Transaccion         BIGINT,
			ClienteID           INT(11),
			NombreCompleto      VARCHAR(200),
            CURP				CHAR(18),
            RFC					CHAR(13),
			CreditoID           BIGINT(12),
            Estatus				CHAR(1),
			SucursalID          INT(11),
            ClasiDestinCred		VARCHAR(20),
			ProductoCreditoID   VARCHAR(200),
			MontoCredito        DECIMAL(12,2),
			FechaOtorgamiento   DATE,
			FechaVencimiento    DATE,
            TasaInteres			DECIMAL(12,4),
            FormaPago			VARCHAR(200),
            FechaUltimoPagoCap	DATE,
            MontoUltimoPagoCap	DECIMAL(14,2),
            FechaUltimoPagoInt  DATE,
            MontoUltimoPagoInt	DECIMAL(14,2),
            FechaPrimerAmortCub	DATE,
			DiasMora	        INT(11),
            SaldoInsoluto 		DECIMAL(14,2),
			InteresesVencido    DECIMAL(14,2),
			InteresMoratorio    DECIMAL(14,2),
			InteresRefinanciado DECIMAL(14,2),
			TipoAcreditadoRel	VARCHAR(20),
			MontoEPRC	        DECIMAL(14,2),
			MontoGarLiquida     DECIMAL(14,2),
			FechaConsultaSIC    DATE,
			TipoCobranza		VARCHAR(20),
			INDEX tmp_SALDOSCARTERACNBVREP1(CreditoID),
            INDEX tmp_SALDOSCARTERACNBVREP2(RFC),
            INDEX tmp_SALDOSCARTERACNBVREP3(Transaccion));

	SET Var_Sentencia := '
	INSERT INTO tmp_SALDOSCARTERACNBVREP (
			Transaccion,
            ClienteID,			NombreCompleto,     	CURP,					RFC,					CreditoID,
            Estatus,            SucursalID,				ClasiDestinCred,		ProductoCreditoID,  	MontoCredito,
            FechaOtorgamiento,	FechaVencimiento,		TasaInteres,     		FormaPago,				FechaUltimoPagoCap,
            MontoUltimoPagoCap,	FechaUltimoPagoInt,		MontoUltimoPagoInt,		FechaPrimerAmortCub,	DiasMora,
            SaldoInsoluto,      InteresesVencido,		InteresMoratorio,		InteresRefinanciado,	TipoAcreditadoRel,
            MontoEPRC,			MontoGarLiquida,		FechaConsultaSIC,		TipoCobranza)';

	SET Var_Sentencia :=    CONCAT(Var_Sentencia, '
		SELECT
		CONVERT("',Aud_NumTransaccion,'",UNSIGNED INT),
			SAL.ClienteID,		CLI.NombreCompleto, 	CLI.CURP,				CLI.RFCOficial,			SAL.CreditoID,
            SAL.EstatusCredito, Cre.SucursalID,
            CASE  WHEN Cre.ClasiDestinCred = "C" THEN "COMERCIAL"
					WHEN Cre.ClasiDestinCred = "O" THEN "CONSUMO"
                    WHEN Cre.ClasiDestinCred = "H" THEN "VIVIENDA"
				ELSE ""
			END,	CONCAT(Cre.ProductoCreditoID,"-",PRO.Descripcion),	Cre.MontoCredito,		Cre.FechaMinistrado,	Cre.FechaVencimien,
            Cre.TasaFija,			CASE 	WHEN Cre.FrecuenciaCap = "U" AND Cre.FrecuenciaInt <> "U" THEN "Pago unico de principal al vencimiento y pagos periodicos de interes"
											WHEN Cre.FrecuenciaCap <> "U" AND Cre.FrecuenciaInt <> "U" THEN "Pagos periodicos de principal e interes"
                                            WHEN Cre.FrecuenciaCap = "U" AND Cre.FrecuenciaInt = "U" THEN "Pago unico de principal e intereses al vencimiento"
                                             WHEN Cre.FrecuenciaCap = "" AND Cre.FrecuenciaInt = "" THEN "Creditos revolventes" END
            , 					FNULTIMOPAGOCAPITALFECHA(Cre.CreditoID,"',Par_Fecha,'"),			FNULTIMOPAGOCAPITAL(Cre.CreditoID,"',Par_Fecha,'"),				FNULTIMOPAGOINTERESFECHA(Cre.CreditoID,"',Par_Fecha,'"),
            FNULTIMOPAGOINTERES(Cre.CreditoID,"',Par_Fecha,'"),					FNPRIMERAAMORTNOCUB(Cre.CreditoID,"',Par_Fecha,'"),					SAL.DiasAtraso,			(SAL.SalCapVigente + SAL.SalCapAtrasado + SAL.SalCapVencido + SAL.SalCapVenNoExi),				(SAL.SalIntVencido),
            (SAL.SalMoratorios),	0.00,					"NO RELACIONADO",
			IFNULL(Cal.Reserva+
				(CASE WHEN SAL.EstatusCredito = "B" THEN (
						ROUND(SAL.SaldoMoraVencido,2)+
						ROUND(SAL.SalIntProvision,2)+
						ROUND(SAL.SalIntVencido,2) )+
						SAL.SalIntOrdinario+
						SAL.SalIntAtrasado

						WHEN SAL.EstatusCredito = "S" THEN (
						ROUND(SAL.SaldoMoraVencido,2)+
						ROUND(SAL.SalIntProvision,2)+
						ROUND(SAL.SalIntVencido,2) )+
						SAL.SalIntOrdinario+
						SAL.SalIntAtrasado
				ELSE 0.00 END),0.00),				0.00,       "1900-01-01",
									CASE WHEN SAL.EstatusCredito = "V" THEN "VIGENTE"
										WHEN SAL.EstatusCredito = "B" THEN "VENCIDO"
                                        WHEN SAL.EstatusCredito = "K" THEN "CASTIGADO"
                                        WHEN SAL.EstatusCredito	= "P" THEN "PAGADO"
                                        WHEN SAL.EstatusCredito = "C" THEN "CANCELADO"
                                        WHEN SAL.EstatusCredito = "S" THEN "SUSPENDIDO"
									END');

	SET Var_Sentencia :=    CONCAT(Var_Sentencia,
		   '
		FROM SALDOSCREDITOS SAL
		INNER JOIN CREDITOS Cre ON Cre.CreditoID = SAL.CreditoID
		INNER JOIN PRODUCTOSCREDITO PRO ON SAL.ProductoCreditoID = PRO.ProducCreditoID
		INNER JOIN CALRESCREDITOS Cal ON Cal.CreditoID = Cre.CreditoID');

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
		LEFT JOIN DIRECCLIENTE Dir2 ON CLI.ClienteID=Dir2.ClienteID AND Dir2.Oficial="',Cons_SI,'"  AND Dir2.MunicipioID= ',CONVERT(Par_Municipio,CHAR));
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
		WHERE   (SAL.EstatusCredito = "',EstatusVigente,'" OR SAL.EstatusCredito = "',EstatusVencido,'" OR SAL.EstatusCredito = "',EstatusSuspendido,'")
		AND SAL.FechaCorte = ?  AND  DATE(Cal.Fecha) = "',Par_Fecha,'"
		ORDER BY SAL.Sucursal, SAL.ProductoCreditoID,CLI.PromotorActual,SAL.CreditoID ; ');

	SET @Sentencia  = (Var_Sentencia);
	SET @Fecha  = Par_Fecha;
	PREPARE STSALDOSCAPITALREP FROM @Sentencia;
	EXECUTE STSALDOSCAPITALREP USING @Fecha;


	# SE OBTIENE LA ULTIMA FECHA A BURO DE CREDITO
	DROP TABLE IF EXISTS TMPCONSULTASIC;

	CREATE TEMPORARY TABLE TMPCONSULTASIC
	SELECT Tmp.CreditoID, CONVERT(IFNULL(MAX(CONVERT(Sob.FechaConsulta,DATE)), Cadena_Vacia), CHAR) AS Fecha
	FROM  tmp_SALDOSCARTERACNBVREP Tmp,SOLBUROCREDITO Sob
	WHERE Tmp.RFC = Sob.RFC
		AND   Sob.FechaConsulta <= Par_Fecha
		AND (	IFNULL(Sob.FolioConsulta, Cadena_Vacia) != Cadena_Vacia
		OR	IFNULL(Sob.FolioConsultaC, Cadena_Vacia) != Cadena_Vacia)
	GROUP BY Sob.RFC, Tmp.CreditoID;

	# Se actualiza el campo FechaConsultaSIC
	UPDATE tmp_SALDOSCARTERACNBVREP T1,TMPCONSULTASIC Sob
		SET	T1.FechaConsultaSIC = Sob.Fecha
		WHERE T1.CreditoID = Sob.CreditoID;

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


	UPDATE tmp_SALDOSCARTERACNBVREP T1, tmp_CREDITOGARANTIA T2
    SET T1.MontoGarLiquida = T2.MontoTotGarantia
    WHERE T1.CreditoID = T2.CreditoID;

    DEALLOCATE PREPARE STSALDOSCAPITALREP;

    IF(Par_NumReporte = Rep_Excel) THEN
		SELECT	ClienteID,			NombreCompleto,     	CURP,					CreditoID,		 SucursalID,
            ClasiDestinCred,	ProductoCreditoID,  	MontoCredito,       	FechaOtorgamiento,	FechaVencimiento,
            TasaInteres,     	FormaPago,				IFNULL(FechaUltimoPagoCap, Fecha_Vacia) AS FechaUltimoPagoCap,
            IFNULL(MontoUltimoPagoCap,Decimal_Cero) AS MontoUltimoPagoCap,	IFNULL(FechaUltimoPagoInt, Fecha_Vacia) AS FechaUltimoPagoInt,
            IFNULL(MontoUltimoPagoInt, Decimal_Cero) AS MontoUltimoPagoInt,	FechaPrimerAmortCub,	DiasMora,				SaldoInsoluto,      InteresesVencido,
            InteresMoratorio,	InteresRefinanciado,	TipoAcreditadoRel,		MontoEPRC,			MontoGarLiquida,
            FechaConsultaSIC,	TipoCobranza,			T2.FechaEncFin

                          FROM
        TMP_FECHA  T2
        LEFT JOIN  tmp_SALDOSCARTERACNBVREP  T1 ON T2.FechaEncFin = T2.FechaEncFin
		WHERE T1. Transaccion = Aud_NumTransaccion
		UNION
		SELECT	'' ClienteID,		''	NombreCompleto,     ''	CURP,				''	CreditoID,		'' SucursalID,
				'' ClasiDestinCred,	'' ProductoCreditoID,  	'' MontoCredito,       	'' FechaOtorgamiento,	'' FechaVencimiento,
				''	TasaInteres,     	'' FormaPago,			''	FechaUltimoPagoCap,	''	MontoUltimoPagoCap,	'' FechaUltimoPagoInt,
				''	MontoUltimoPagoInt,	'' FechaPrimerAmortCub,	'' DiasMora,			''	SaldoInsoluto,      '' InteresesVencido,
				''	InteresMoratorio,	'' InteresRefinanciado,	''	TipoAcreditadoRel,	''	MontoEPRC,			'' MontoGarLiquida,
				''	FechaConsultaSIC,	'' TipoCobranza,
                T2.FechaEncFin
                FROM
        TMP_FECHA  T2;

	ELSE
		IF(Par_NumReporte = Rep_Csv) THEN

        SELECT	CONCAT(
			IFNULL(ClienteID,Cadena_Vacia),';',
            IFNULL(NombreCompleto,Cadena_Vacia),';',
            IFNULL(CURP,Cadena_Vacia),';',
			IFNULL(CreditoID, Entero_Cero),';',
            IFNULL(SucursalID,Entero_Cero),';',
            IFNULL(ClasiDestinCred,Cadena_Vacia),';',
            IFNULL(ProductoCreditoID,Cadena_Vacia),';',
            IFNULL(MontoCredito,Cadena_Vacia),';',
            IFNULL(FechaOtorgamiento,Cadena_Vacia),';',
            IFNULL(FechaVencimiento,Cadena_Vacia),';',
            IFNULL(TasaInteres,Cadena_Vacia),';',
            IFNULL(FormaPago,Cadena_Vacia),';',
            IFNULL(FechaUltimoPagoCap,Cadena_Vacia),';',
            IFNULL(MontoUltimoPagoCap,Cadena_Vacia),';',
            IFNULL(FechaUltimoPagoInt,Cadena_Vacia),';',
            IFNULL(MontoUltimoPagoInt,Cadena_Vacia),';',
            IFNULL(FechaPrimerAmortCub,Cadena_Vacia),';',
            IFNULL(DiasMora,Cadena_Vacia),';',
            IFNULL(SaldoInsoluto,Cadena_Vacia),';',
            IFNULL(InteresesVencido,Cadena_Vacia),';',
            IFNULL(InteresMoratorio,Cadena_Vacia),';',
            IFNULL(InteresRefinanciado,Cadena_Vacia),';',
            IFNULL(TipoAcreditadoRel,Cadena_Vacia),';',
			IFNULL(MontoEPRC,Cadena_Vacia),';',
			IFNULL(MontoGarLiquida,Cadena_Vacia),';',
			IFNULL(FechaConsultaSIC,Cadena_Vacia),';',
			IFNULL(TipoCobranza,Cadena_Vacia),';') AS Valor
		FROM tmp_SALDOSCARTERACNBVREP
		WHERE Transaccion = Aud_NumTransaccion;

		END IF;
	END IF;


	DROP TABLE tmp_SALDOSCARTERACNBVREP;
END TerminaStore$$