-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGULATORIOI0453REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGULATORIOI0453REP`;DELIMITER $$

CREATE PROCEDURE `REGULATORIOI0453REP`(
	Par_Anio 			INT,
    Par_Mes				INT,
	Par_NumReporte      TINYINT UNSIGNED,
	Par_NumDecimales    INT,

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de Variables..
DECLARE Var_UltFecEPRC 		DATE;
DECLARE	Var_ClaveEntidad	VARCHAR(300);
DECLARE Var_Periodo			CHAR(6);
DECLARE Var_FechaIni		DATE;
DECLARE Var_FechaFin		DATE;
DECLARE Var_FechaActual		DATE;
DECLARE Var_UltFecSaldos	DATE;

-- Declaracion de Constantes
DECLARE Rep_Excel       	INT;
DECLARE Rep_Csv				INT;
DECLARE Reg_0453			INT;
DECLARE Cadena_Vacia		CHAR(1);
DECLARE Espacio_blanco		VARCHAR(2);
DECLARE Fecha_Vacia			DATE;
DECLARE SI 					CHAR(1);
DECLARE RNO					CHAR(1);
DECLARE Fisica				CHAR(1);
DECLARE Moral				CHAR(1);
DECLARE Fisica_empre		CHAR(1);
DECLARE Masculino			CHAR(1);
DECLARE Femenino    		CHAR(1);
DECLARE Vencido 			CHAR(1);
DECLARE Castigado 			CHAR(1);
DECLARE Vigente 			CHAR(1);
DECLARE Pagado				CHAR(1);
DECLARE Nacional 			CHAR(1);
DECLARE Cadena_Espacio		VARCHAR(2);
DECLARE Entero_Cero			INT;
DECLARE Entero_Uno			INT;
DECLARE Entero_Dos			INT;
DECLARE Frec_Semanal		CHAR;
DECLARE Frec_Quincenal		CHAR;
DECLARE Frec_Mensual		CHAR;
DECLARE Frec_Decenal		CHAR;
DECLARE Frec_Catorcenal		CHAR;
DECLARE ClaveSIC_Uno		VARCHAR(5);
DECLARE ClaveSIC_Dos		VARCHAR(5);
DECLARE ClaveSIC_Tres		VARCHAR(5);
DECLARE ClaveSIC_Cuatro		VARCHAR(5);
DECLARE ClaveSIC_Cinco		VARCHAR(5);
DECLARE ClaveSIC_Seis		VARCHAR(5);
DECLARE ClaveSIC_Cero		VARCHAR(5);
DECLARE ClaveSIC_Siete		VARCHAR(5);
DECLARE ClaveSIC_Ocho		VARCHAR(5);
DECLARE Tip_CapVigente	INT;
DECLARE Tip_CapAtrasado	INT;
DECLARE Tip_CapVencido	INT;
DECLARE Tip_CapVenNoExi	INT;
DECLARE Tip_Moratorios	INT;
DECLARE Tip_MoraVencido	INT;
DECLARE Tip_IntOrdinario	INT;
DECLARE Tip_IntAtrasado		INT;
DECLARE Tip_IntProvision	INT;
DECLARE Tip_IntVencido		INT;
DECLARE Apellido_Vacio		CHAR(1);

-- Asignacion de Constantes
SET Rep_Excel       := 	1;
SET Rep_Csv			:=	2;
SET Reg_0453		:= 	0453;
SET Cadena_Vacia	:= 	'';
SET Espacio_blanco  :=	' ';
SET Fecha_Vacia		:= 	'1900-01-01';
SET SI 				:=	'S';
SET RNO 			:=	'N';
SET Fisica			:=	'F';
SET Moral			:=	'M';
SET Fisica_empre	:=	'A';
SET Masculino		:=	'M';
SET Femenino		:=	'F';
SET Vencido  		:=	'B';
SET Castigado       :=	'K';
SET Vigente 		:= 	'V';
SET Pagado 			:=  'P';
SET Nacional		:= 	'N';
SET Cadena_Espacio	:=	' ';
SET Entero_Cero		:= 	0;
SET Entero_Uno		:=  1;
SET Entero_Dos		:= 	2;
SET Frec_Semanal	:= 'S';
SET Frec_Quincenal	:= 'Q';
SET Frec_Mensual	:= 'M';
SET Frec_Catorcenal	:= 'C';
SET Frec_Decenal    := 'D';
SET ClaveSIC_Uno	:= 	'10001';
SET ClaveSIC_Dos	:= 	'10002';
SET ClaveSIC_Tres	:= 	'10003';
SET ClaveSIC_Cuatro	:= 	'10004';
SET ClaveSIC_Cinco	:= 	'10005';
SET ClaveSIC_Seis	:= 	'10006';
SET ClaveSIC_Cero	:= 	'10000';
SET ClaveSIC_Siete	:= 	'10007';
SET ClaveSIC_Ocho	:= 	'10008';

SET Tip_CapVigente	:= 1;				-- 	Tipo Capital Vigente
SET Tip_CapAtrasado	:= 2;				-- 	Tipo Capital Atrasado
SET Tip_CapVencido	:= 3;				-- 	Tipo Capital Vencido
SET Tip_CapVenNoExi	:= 4;				-- 	Tipo Capital Vencido no Exigible
SET Tip_Moratorios	:= 15;				-- 	Tipo Moratorios
SET Tip_MoraVencido	:= 16;				-- 	Tipo Moratorios de Cartera Vencida
SET Tip_IntOrdinario	:= 10;			-- 	Tipo de Interes Ordinario
SET Tip_IntAtrasado		:= 11;			-- 	Tipo de Interes Atrasado
SET Tip_IntProvision	:= 14;			-- 	Tipo de Interes Provisionado
SET Tip_IntVencido		:= 12;			-- 	Tipo de Interes Vencido
SET Par_NumDecimales	:= 0;			-- Los saldos se deben presentar redondeados a 0 decimales
SET Apellido_Vacio		:= 'X';

    SET Var_FechaActual = (SELECT FechaSistema FROM PARAMETROSSIS WHERE EmpresaID = Par_EmpresaID);

	IF(Par_Mes < 10) THEN
        SET Var_FechaIni = CONCAT(Par_anio,'-0',Par_Mes,'-01');
	ELSE
		SET Var_FechaIni = CONCAT(Par_anio,'-',Par_Mes,'-01');
    END IF;

	SET Var_FechaFin = LAST_DAY(Var_FechaIni);


	SET Var_Periodo = CONCAT(SUBSTRING(REPLACE(CONVERT(Var_FechaIni, CHAR),'-',Cadena_Vacia),1,4),
							  SUBSTRING(REPLACE(CONVERT(Var_FechaIni, CHAR),'-',Cadena_Vacia),5,2));

	SET Var_ClaveEntidad	:= IFNULL((SELECT Par.ClaveEntidad
										FROM PARAMETROSSIS Par
										WHERE Par.EmpresaID = Par_EmpresaID), Cadena_Vacia);

SET Var_UltFecSaldos := Fecha_Vacia;

SELECT  MAX(FechaCorte) INTO Var_UltFecSaldos
	FROM SALDOSCREDITOS
	WHERE FechaCorte <= Var_FechaFin;

SET Var_UltFecSaldos := IFNULL(Var_UltFecSaldos, Fecha_Vacia);


	DROP TEMPORARY TABLE IF EXISTS R04I0453;

	CREATE TEMPORARY TABLE R04I0453(
		CreditoID 		BIGINT(12),
		ClienteID		BIGINT,
		TipoPersona		CHAR(1),
		Denominacion	VARCHAR(200),
		ApellidoPat		VARCHAR(200),
		ApellidoMat		VARCHAR(200),
		RFC				VARCHAR(13),
		CURP			VARCHAR(18),
		Genero			CHAR(1),
		ClaveSucursal	VARCHAR(100),
		DestinoCreID	INT,
		ClasifRegID		INT,
		ClasifConta		VARCHAR(20),
		ProductoCredito	VARCHAR(200),
		FechaDisp		DATE,
		FechaVencim		DATE,
		TipoAmorti		INT,
		MontoCredito	DECIMAL(16,2),
		FecUltPagoCap	DATE,
		FecUltPagoInt	DATE,
		MonUltPagoCap	DECIMAL(16,2),
		MonUltPagoInt	DECIMAL(16,2),
		FecPrimAtraso	VARCHAR(20),
		MontoCondona	DECIMAL(16,2),
		FecUltCondona	VARCHAR(20),
		NumDiasAtraso	INT,
		TipoCredito		CHAR(1),
		SalCapital		DECIMAL(16,2),
		SalIntOrdin		DECIMAL(16,2),
		SalIntMora		DECIMAL(16,2),
		IntereRefinan	DECIMAL(16,2),
		SaldoInsoluto	DECIMAL(16,2),
		MontoCastigo	DECIMAL(16,2),
        MontoBonifi		DECIMAL(16,2),
		FechaCastigo    DATE,
		TipoRelacion	CHAR(1),
		ReservaCubierta	DECIMAL(16,2),
		ReservaExpuesta	DECIMAL(16,2),
		EPRCTotal       DECIMAL(16,2),
		GtiaCtaAhorro	DECIMAL(16,2),
		GtiaInversion	DECIMAL(16,2),
		GtiaHisInver	DECIMAL(16,2),
		TotGtiaLiquida	DECIMAL(16,2),
		GtiaHipotecaria	DECIMAL(16,2),
		FecConsultaSIC	VARCHAR(20),
		ClaveSIC		VARCHAR(20),
        TipoCobranza    INT,
        UltFecVen		DATE,
		SaldoEstimable	DECIMAL(16,2),
		AntFecSaldos	DATE,

		INDEX R04C0451_idx1(DestinoCreID),
		INDEX R04C0451_idx2(ClasifRegID),
		INDEX R04C0451_idx3(CreditoID),
		INDEX R04C0451_idx4(ClienteID)
		);



	INSERT INTO R04I0453
		SELECT	Sal.CreditoID,
				Sal.ClienteID,
				CASE WHEN Cli.TipoPersona = Moral AND Cli.Nacion = Nacional THEN Entero_Dos
					 WHEN Cli.TipoPersona IN (Fisica_empre, Fisica)  THEN Entero_Uno
				END,

				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						UPPER(
							SUBSTRING(CONCAT(IFNULL(Cli.PrimerNombre, Cadena_Vacia),
								CASE WHEN IFNULL(Cli.SegundoNombre, Cadena_Vacia) != Cadena_Vacia THEN
									CONCAT(Espacio_blanco, Cli.SegundoNombre) ELSE Cadena_Vacia
								END,
								CASE WHEN IFNULL(Cli.TercerNombre, Cadena_Vacia) != Cadena_Vacia THEN
									CONCAT(Espacio_blanco, Cli.TercerNombre) ELSE Cadena_Vacia
								END),  1, 200)
	                    )
					 ELSE UPPER(CONCAT( REPLACE(REPLACE(REPLACE(REPLACE( REPLACE(Cli.RazonSocial, 'S.A DE C.V.', Cadena_Vacia),
									'SA DE CV', Cadena_Vacia), 'S. A. de CV.', Cadena_Vacia), 'sa de cv', Cadena_Vacia), 's.a. de c.v.', Cadena_Vacia)))
				END,

				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
                            CASE WHEN IFNULL(Cli.ApellidoPaterno,Cadena_Vacia) = Cadena_Vacia
									OR IFNULL(Cli.ApellidoPaterno,Cadena_Vacia) = '.' THEN
								Apellido_Vacio
							ELSE
								UPPER(IFNULL(Cli.ApellidoPaterno,Apellido_Vacio))
							END
					 ELSE Cadena_Vacia
				END ,

				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
                           CASE WHEN IFNULL(Cli.ApellidoMaterno,Cadena_Vacia) = Cadena_Vacia
							OR	IFNULL(Cli.ApellidoMaterno,Cadena_Vacia) = '.' THEN
								Apellido_Vacio
						ELSE
						   UPPER(IFNULL(Cli.ApellidoMaterno,Apellido_Vacio))
						END
					 ELSE Cadena_Vacia
				END,

				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						   Cli.RFCOficial
					 ELSE CONCAT("_", Cli.RFCOficial)
				END,

				CASE WHEN Cli.TipoPersona = Fisica  OR  Cli.TipoPersona = Fisica_empre THEN
						   Cli.CURP
					 ELSE Entero_Cero
				END,

				CASE WHEN Cli.TipoPersona = Moral THEN Entero_Cero
					 WHEN Cli.TipoPersona IN (Fisica_empre, Fisica) AND Cli.Sexo = Masculino THEN Entero_Dos
					 WHEN Cli.TipoPersona IN (Fisica_empre, Fisica) AND Cli.Sexo = Femenino THEN Entero_Uno
				END,

				CONVERT(Cre.SucursalID, CHAR),
				Sal.DestinoCreID,

				0 AS ClasifRegID,

				Cadena_Vacia AS ClasifConta,

				Pro.Descripcion,

				DATE_FORMAT(Cre.FechaInicio, '%Y%m%d') AS FechaDisp,

				DATE_FORMAT(Cre.FechaVencimien, '%Y%m%d') AS FechaVencim,

				CASE WHEN Pro.ManejaLinea = SI  AND Pro.EsRevolvente = SI 	THEN 7
					 WHEN Pro.ManejaLinea = RNO AND Sal.NumAmortizacion <= Entero_Uno THEN Entero_Uno
					 WHEN Pro.ManejaLinea = RNO AND Sal.NumAmortizacion > Entero_Uno
												AND Sal.FrecuenciaCap = Frec_Semanal THEN 4
					 WHEN Pro.ManejaLinea = RNO AND Sal.NumAmortizacion > Entero_Uno
												AND Sal.FrecuenciaCap IN (Frec_Catorcenal, Frec_Quincenal) THEN 5
					 WHEN Pro.ManejaLinea = RNO AND Sal.NumAmortizacion > Entero_Uno
												AND Sal.FrecuenciaCap = Frec_Mensual THEN 6
					 WHEN Pro.ManejaLinea = RNO AND Sal.NumAmortizacion > Entero_Uno
												AND Sal.FrecuenciaCap NOT IN (Frec_Semanal, Frec_Decenal, Frec_Catorcenal, Frec_Quincenal,Frec_Mensual) THEN 3
				END,
				Cre.MontoCredito,
				Cas.FecUltPagoCap AS FecUltPagoCap,
				Cas.FecUltPagoInt AS FecUltPagoInt,
				Cas.MonUltPagoCap AS MonUltPagoCap,
				Cas.MonUltPagoInt AS MonUltPagoInt,
				Cas.FecPrimAtraso,
				Entero_Cero,
				Fecha_Vacia,
				Entero_Cero AS DiasAtraso,
				Entero_Uno AS TipoCredito,
				Cas.SaldoCapital,
				Cas.SaldoInteres,
				Cas.SaldoMoratorio AS SalIntMora,
				Entero_Cero AS IntereRefinan,
				(Cas.SaldoCapital + Cas.SaldoInteres + Cas.SaldoMoratorio) AS SaldoInsoluto,
				Cas.TotalCastigo AS MontoCastigo,
                Entero_Cero AS MontoBonifi,
				Cas.Fecha        AS FechaCastigo,
				Entero_Uno AS Tip_Relacion,
				Entero_Cero AS ReservaCubierta,
				Entero_Cero AS ReservaExpuesta,
				Entero_Cero AS EPRCTotal,
				Entero_Cero,
				Entero_Cero,
				Entero_Cero,
				0 AS TotGtiaLiquida,
				0 AS GtiaHipotecaria,
				Fecha_Vacia,
				' ' AS ClaveSIC,
                Cas.TipoCobranza,
                Fecha_Vacia,
				Entero_Cero,
				Fecha_Vacia

		FROM CLIENTES Cli,
			 CREDITOS Cre,
             CRECASTIGOS Cas,
			 PRODUCTOSCREDITO Pro,
			 SALDOSCREDITOS Sal

		WHERE Cas.Fecha BETWEEN Var_FechaIni AND Var_FechaFin
		  AND Cas.CreditoID = Sal.CreditoID
		  AND Sal.FechaCorte = Cas.Fecha
		  AND Sal.EstatusCredito = Castigado
		  AND Sal.CreditoID = Cre.CreditoID
		  AND Cli.ClienteID = Sal.ClienteID
		  AND Cre.ProductoCreditoID = Pro.ProducCreditoID;


	DROP TABLE IF EXISTS TMPCONDONACION;
	CREATE TEMPORARY TABLE TMPCONDONACION
    SELECT Cre.CreditoID,IFNULL(SUM( Cre.MontoCapital + Cre.MontoInteres), Entero_Cero) AS Monto, CONVERT(IFNULL(MAX(FechaRegistro), Cadena_Vacia), CHAR) AS Fecha
    FROM CREQUITAS Cre, R04I0453 Rep
    WHERE 	Rep.CreditoID = Cre.CreditoID
	AND 	Cre.FechaRegistro <= Var_FechaFin
    GROUP BY Cre.CreditoID;

	UPDATE R04I0453 Rep, TMPCONDONACION Cre SET
			Rep.MontoCondona = Cre.Monto,
            Rep.FecUltCondona = Cre.Fecha
			WHERE 	Rep.CreditoID = Cre.CreditoID;




	 DROP TABLE IF EXISTS TMPCUENAHORRO;

     CREATE TEMPORARY TABLE TMPCUENAHORRO
		 SELECT Rep.CreditoID, SUM(CASE WHEN Blo.NatMovimiento = Vencido THEN  Blo.MontoBloq ELSE Blo.MontoBloq *-1 END) AS Garantia
		 FROM R04I0453 Rep,
			  BLOQUEOS Blo,
			  CUENTASAHO Cue
		 WHERE Rep.ClienteID = Cue.ClienteID
		   AND Cue.CuentaAhoID = Blo.CuentaAhoID
		   AND Rep.CreditoID = Blo.Referencia
		   AND DATE(FechaMov) < Rep.FechaCastigo
		   AND Blo.TiposBloqID = 8
		 GROUP BY Blo.Referencia, Rep.CreditoID;

     UPDATE R04I0453 Rep,TMPCUENAHORRO Cue SET
		Rep.GtiaCtaAhorro = Cue.Garantia
        WHERE Rep.CreditoID = Cue.CreditoID;


     DROP TABLE IF EXISTS TMPINVGAR;
     CREATE TEMPORARY TABLE TMPINVGAR
	 SELECT Rep.CreditoID,IFNULL(SUM(Gar.MontoEnGar),Entero_Cero) AS Inversion
     FROM R04I0453 Rep, CREDITOINVGAR Gar
     WHERE Gar.CreditoID = Rep.CreditoID
     AND Gar.FechaAsignaGar < Rep.FechaCastigo
     GROUP BY Rep.CreditoID;

	 UPDATE R04I0453 Rep, TMPINVGAR Gar SET
			Rep.GtiaInversion = Gar.Inversion
			WHERE Gar.CreditoID = Rep.CreditoID;


	 DROP TABLE IF EXISTS TMPHISINVGAR;
     CREATE TEMPORARY TABLE TMPHISINVGAR
     SELECT Rep.CreditoID, IFNULL(SUM(Gar.MontoEnGar),Entero_Cero) AS Inversion
     FROM R04I0453 Rep,  HISCREDITOINVGAR Gar
     WHERE Rep.CreditoID = Gar.CreditoID
     AND   Gar.Fecha > Rep.FechaCastigo
	AND   Gar.FechaAsignaGar <= Rep.FechaCastigo
	AND   Gar.ProgramaID NOT IN ('CIERREGENERALPRO')
    GROUP BY Gar.CreditoID, Rep.CreditoID;



	 UPDATE R04I0453 Rep,  TMPHISINVGAR Gar SET
			Rep.GtiaHisInver = Gar.Inversion
            WHERE Rep.CreditoID = Gar.CreditoID;


	UPDATE R04I0453 Tem SET
		TotGtiaLiquida = IFNULL(GtiaCtaAhorro, Entero_Cero) + IFNULL(GtiaInversion, Entero_Cero) + IFNULL(GtiaHisInver, Entero_Cero);




	UPDATE R04I0453 Tem, CREGARPRENHIPO Gah SET
		GtiaHipotecaria = Gah.GarHipotecaria
		WHERE Tem.CreditoID = Gah.CreditoID
		AND IFNULL(Gah.CreditoID, Entero_Cero) != Entero_Cero
		AND IFNULL(Gah.GarHipotecaria, Entero_Cero) > Entero_Cero;






	DROP TABLE IF EXISTS TMPCONSULTASIC;
     CREATE TEMPORARY TABLE TMPCONSULTASIC
     SELECT Rep.CreditoID, CONVERT(IFNULL(MAX(CONVERT(Sob.FechaConsulta,DATE)), Cadena_Vacia), CHAR) AS Fecha
     FROM  R04I0453 Rep,SOLBUROCREDITO Sob
     WHERE Rep.RFC = Sob.RFC
		AND   Sob.FechaConsulta <= Var_FechaFin
		AND (	IFNULL(Sob.FolioConsulta, Cadena_Vacia) != Cadena_Vacia
				OR	IFNULL(Sob.FolioConsultaC, Cadena_Vacia) != Cadena_Vacia)
		GROUP BY Sob.RFC, Rep.CreditoID;

	UPDATE R04I0453 Rep,TMPCONSULTASIC Sob SET
		   Rep.FecConsultaSIC = Sob.Fecha
			WHERE Rep.CreditoID = Sob.CreditoID;





    DROP TABLE IF EXISTS TMPFECHAVEN;
     CREATE TEMPORARY TABLE TMPFECHAVEN
     SELECT Rep.CreditoID, IFNULL(MAX(Amo.FechaExigible), Fecha_Vacia) AS Fecha
     FROM  R04I0453 Rep,  AMORTICREDITO Amo
     WHERE  Amo.CreditoID = Rep.CreditoID
     AND Amo.FechaVencim < Var_FechaFin
     GROUP BY Amo.CreditoID, Rep.CreditoID;


     UPDATE R04I0453 Rep,TMPFECHAVEN Ven SET
		   Rep.UltFecVen = Ven.Fecha
			WHERE Rep.CreditoID = Ven.CreditoID;






	DROP TEMPORARY TABLE IF EXISTS  TMPCLIENTES453 ;

	CREATE TEMPORARY TABLE TMPCLIENTES453
		SELECT ClienteID
			FROM R04I0453
		GROUP BY ClienteID;
	CREATE INDEX id_TMPCLIENTES451_1 ON TMPCLIENTES453 (ClienteID);


	DROP TEMPORARY TABLE IF EXISTS TMPRELACIONCLI453;
	CREATE TEMPORARY TABLE TMPRELACIONCLI453
		SELECT	Rel.ClienteID,	Rel.RelacionadoID,	Rel.TipoRelacion,	Tip.Grado,	RNO AS TienePoder
			FROM	RELACIONCLIEMPLEADO	Rel,
					TMPCLIENTES453		Car,
					TIPORELACIONES		Tip
			WHERE 	Rel.ClienteID		=	Car.ClienteID
			AND		Rel.ParentescoID	=	Tip.TipoRelacionID;

	CREATE INDEX id_indexClienteID ON TMPRELACIONCLI453 (ClienteID);
	CREATE INDEX id_indexTipoRelacion ON TMPRELACIONCLI453 (TipoRelacion);


	UPDATE TMPRELACIONCLI453 Tmp,
		CLIEMPRELACIONADO Rel
	SET
		Tmp.TienePoder = Rel.TienePoder
	WHERE
		Tmp.TipoRelacion = Entero_Dos
			AND Rel.EmpleadoID > Entero_Cero
			AND Tmp.RelacionadoID = Rel.EmpleadoID;


	UPDATE TMPRELACIONCLI453 Tmp,
		CLIEMPRELACIONADO Rel
	SET
		Tmp.TienePoder = Rel.TienePoder
	WHERE
		Tmp.TipoRelacion = Entero_Uno
			AND Rel.ClienteID > Entero_Cero
			AND Tmp.RelacionadoID = Rel.ClienteID;


	UPDATE TMPRELACIONCLI453 Tmp,
		CLIEMPRELACIONADO Rel
	SET
		Tmp.TienePoder = SI
	WHERE
		Rel.EmpleadoID = Entero_Cero
			AND Tmp.ClienteID = Rel.ClienteID;


	DELETE FROM TMPRELACIONCLI453
	WHERE
		TienePoder = RNO;



	UPDATE R04I0453 Car,
    TMPRELACIONCLI453 Rel
SET
    Car.TipoRelacion = 6
WHERE
    Rel.TipoRelacion = Entero_Uno
        AND Car.ClienteID = Rel.ClienteID
        AND TienePoder = SI
        AND Grado IN (Entero_Uno , Entero_Dos);


	UPDATE R04I0453 Car,
    TMPRELACIONCLI453 Rel
SET
    Car.TipoRelacion = 7
WHERE
    Rel.TipoRelacion = Entero_Dos
        AND Car.ClienteID = Rel.ClienteID
        AND TienePoder = SI
        AND Grado IN (Entero_Uno , Entero_Dos);


	UPDATE R04I0453 Car,
    CLIEMPRELACIONADO Rel
SET
    Car.TipoRelacion = 7
WHERE
    Car.ClienteID = Rel.ClienteID
        AND TienePoder = SI;


	UPDATE R04I0453 Car,
    CLIEMPRELACIONADO Rel
SET
    Car.TipoRelacion = 7
WHERE
    Car.ClienteID = Rel.ClienteID
        AND Rel.EmpleadoID > Entero_Cero
        AND TienePoder = SI;

	DROP TEMPORARY TABLE IF EXISTS  TMPCLIENTES453;
	DROP TEMPORARY TABLE IF EXISTS TMPRELACIONCLI453;



	UPDATE R04I0453 Prin,
    REESTRUCCREDITO Res
SET
    TipoCredito = CASE
        WHEN Origen = 'R' THEN '3'
        WHEN Origen = 'O' THEN '2'
        ELSE TipoCredito
    END,
    IntereRefinan = CASE
        WHEN
            Res.EstatusCreacion = Vencido
                AND Res.Regularizado = RNO
        THEN
            Res.SaldoInteres
        ELSE Entero_Cero
    END
WHERE
    Prin.CreditoID = Res.CreditoDestinoID;


UPDATE R04I0453 Tem SET
    Tem.NumDiasAtraso = CASE WHEN FecPrimAtraso = Fecha_Vacia THEN Entero_Cero
    ELSE DATEDIFF(Tem.FechaCastigo, CONVERT(FecPrimAtraso , DATE))
	END;


	UPDATE R04I0453 Tem,
    DESTINOSCREDITO Des
	SET
    Tem.ClasifRegID = Des.ClasifRegID
	WHERE
    Tem.DestinoCreID = Des.DestinoCreID;


	UPDATE R04I0453 Tem,
    CATCLASIFREPREG Cat
SET
    Tem.ClasifConta = Cat.ClavePorDestino
WHERE
    Tem.ClasifRegID = Cat.ClasifRegID;

-- ---------------------------------------------------
-- Reservas Totales al momento del Castigo
-- ---------------------------------------------------
UPDATE R04I0453 Tem SET
	AntFecSaldos = (SELECT MAX(FechaCorte)
						FROM SALDOSCREDITOS Sal
						WHERE Sal.CreditoID = Tem.CreditoID
						  AND Sal.FechaCorte < Tem.FechaCastigo

					);


UPDATE R04I0453 Tem, SALDOSCREDITOS Sal  SET
    Tem.SaldoEstimable = IFNULL(Sal.SalCapVigente, Entero_Cero) + IFNULL(Sal.SalCapAtrasado, Entero_Cero) +
						 IFNULL(Sal.SalCapVencido, Entero_Cero) + IFNULL(Sal.SalCapVenNoExi, Entero_Cero) +
						 IFNULL(Sal.SalMoratorios, Entero_Cero) + IFNULL(Sal.SaldoMoraVencido, Entero_Cero) +
						 IFNULL(Sal.SalIntOrdinario, Entero_Cero) + IFNULL(Sal.SalIntAtrasado, Entero_Cero) +
						 IFNULL(Sal.SalIntProvision, Entero_Cero) + IFNULL(Sal.SalIntVencido, Entero_Cero)

	WHERE Tem.CreditoID = Sal.CreditoID
	  AND Sal.FechaCorte = Tem.AntFecSaldos;

-- PAGOS REALIZADOS DURANTE EL DÃA DE LOS CONCEPTOS QUE ESON ESTIMABLES (QUE CAUSAN EPRC)
DROP TABLE IF EXISTS TMPPAGOS453;
CREATE TEMPORARY TABLE TMPPAGOS453(
	CreditoID	BIGINT(12),
	MontoPago	DECIMAL(14,2)
);

INSERT INTO TMPPAGOS453
	SELECT Mov.CreditoID,
		   SUM(Mov.Cantidad)
		FROM CREDITOSMOVS Mov,
			 R04I0453 Tem
		WHERE Mov.CreditoID = Tem.CreditoID
		  AND Mov.FechaOperacion = Tem.FechaCastigo
		  AND Mov.NatMovimiento = 'A'
		  AND Mov.Descripcion = 'PAGO DE CREDITO'
		  AND Mov.ProgramaID = 'PAGOCREDITOPRO'
		  AND Mov.TipoMovCreID IN (Tip_CapVigente, Tip_CapAtrasado, Tip_CapVencido, Tip_CapVenNoExi,
								   Tip_Moratorios, Tip_MoraVencido, Tip_IntOrdinario, Tip_IntAtrasado,
								   Tip_IntProvision, Tip_IntVencido)
		GROUP BY Mov.CreditoID;


UPDATE R04I0453 Tem, TMPPAGOS453 Pag  SET
    Tem.SaldoEstimable = Tem.SaldoEstimable - IFNULL(Pag.MontoPago, Entero_Cero)

	WHERE Tem.CreditoID = Pag.CreditoID;

DROP TABLE IF EXISTS TMPPAGOS453;
 -- -----------------------------------------------------

	UPDATE R04I0453 Tem
SET
    ClaveSIC = ClaveSIC_Cero
WHERE
    Tem.UltFecVen = Fecha_Vacia
        AND IFNULL(Tem.NumDiasAtraso, Entero_Cero) = Entero_Cero
        AND Tem.TipoPersona = Entero_Uno;

UPDATE R04I0453 Tem
SET
    ClaveSIC = CASE
        WHEN IFNULL(Tem.NumDiasAtraso, Entero_Cero) = Entero_Cero THEN ClaveSIC_Uno
        WHEN IFNULL(Tem.NumDiasAtraso, Entero_Cero) BETWEEN 1 AND 29 THEN ClaveSIC_Dos
        WHEN IFNULL(Tem.NumDiasAtraso, Entero_Cero) BETWEEN 30 AND 59 THEN ClaveSIC_Tres
        WHEN IFNULL(Tem.NumDiasAtraso, Entero_Cero) BETWEEN 60 AND 89 THEN ClaveSIC_Cuatro
        WHEN IFNULL(Tem.NumDiasAtraso, Entero_Cero) BETWEEN 90 AND 119 THEN ClaveSIC_Cinco
        WHEN IFNULL(Tem.NumDiasAtraso, Entero_Cero) BETWEEN 120 AND 149 THEN ClaveSIC_Seis
        WHEN IFNULL(Tem.NumDiasAtraso, Entero_Cero) BETWEEN 150 AND 360 THEN ClaveSIC_Siete
        WHEN IFNULL(Tem.NumDiasAtraso, Entero_Cero) > 360 THEN ClaveSIC_Ocho
    END
WHERE
    UltFecVen != Fecha_Vacia
        AND Tem.TipoPersona = Entero_Uno;

-- Fecha de Consulta en BC
UPDATE R04I0453 Tem SET
    FecConsultaSIC = FechaDisp
	WHERE TRIM(FecConsultaSIC) = Fecha_Vacia;


	SET Par_NumDecimales := Entero_Cero;

	IF(Par_NumReporte = Rep_Excel) THEN
		SELECT	Var_Periodo AS Periodo,
				Var_ClaveEntidad AS ClaveEntidad,
                Reg_0453 AS Formulario,
                IFNULL(CONVERT(ClienteID, CHAR),Cadena_Vacia) AS ClienteID,
                IFNULL(TipoPersona,Cadena_Vacia) AS TipoPersona,
                IFNULL(Denominacion,Cadena_Vacia) AS Denominacion,
                IFNULL(ApellidoPat,Cadena_Vacia) AS ApellidoPat,
				IFNULL(ApellidoMat,Cadena_Vacia) AS ApellidoMat,
                IFNULL(RFC,Cadena_Vacia) AS RFC,
				IFNULL(CURP,Cadena_Vacia) AS CURP,
                IFNULL(Genero,Entero_Cero) AS Genero,
                IFNULL(CONVERT(CreditoID, CHAR),Cadena_Vacia) AS CreditoID,
				IFNULL(CONVERT(ClaveSucursal, CHAR),Cadena_Vacia) AS ClaveSucursal,
				IFNULL(ClasifConta,Cadena_Vacia) AS ClasifConta,
                IFNULL(ProductoCredito,Cadena_Vacia) AS ProductoCredito,
				REPLACE(IFNULL(FechaDisp,Fecha_Vacia),'-',Cadena_Vacia) AS FechaDisp,
				REPLACE(IFNULL(FechaVencim,Fecha_Vacia),'-',Cadena_Vacia) AS FechaVencim,
				IFNULL(TipoAmorti,Entero_Cero) as TipoAmorti,
                ROUND(IFNULL(MontoCredito,Entero_Cero),Par_NumDecimales) as MontoCredito,
				CASE WHEN IFNULL(FecUltPagoCap,Fecha_Vacia) != Fecha_Vacia THEN
						REPLACE(CONVERT(FecUltPagoCap,CHAR),'-',Cadena_Vacia)
					  ELSE REPLACE(Fecha_Vacia,'-',Cadena_Vacia)
				END AS FecUltPagoCap,
				IFNULL(ROUND(MonUltPagoCap,Par_NumDecimales),Entero_Cero) AS MonUltPagoCap,
				CASE WHEN IFNULL(FecUltPagoInt,Fecha_Vacia) != Fecha_Vacia THEN
						REPLACE(CONVERT(FecUltPagoInt,CHAR),'-',Cadena_Vacia)
					 ELSE REPLACE(Fecha_Vacia,'-',Cadena_Vacia)
				END FecUltPagoInt,
				IFNULL(ROUND(MonUltPagoInt,Par_NumDecimales),Entero_Cero) AS MonUltPagoInt,
				CASE IFNULL(FecPrimAtraso,Fecha_Vacia) WHEN Fecha_Vacia
                THEN REPLACE(Fecha_Vacia,'-',Cadena_Vacia)  ELSE REPLACE(FecPrimAtraso,'-',Cadena_Vacia) END AS FecPrimAtraso,
                NumDiasAtraso,
                TipoCredito,
                ROUND(SalCapital,Par_NumDecimales) AS SalCapital,
				ROUND(SalIntOrdin,Par_NumDecimales) AS SalIntOrdin,
				ROUND(SalIntMora,Par_NumDecimales) AS SalIntMora,
				ROUND(IntereRefinan,Par_NumDecimales) AS IntereRefinan,
				ROUND(SaldoInsoluto,Par_NumDecimales) AS SaldoInsoluto,
                ROUND(MontoCastigo,Par_NumDecimales) AS MontoCastigo,
                ROUND(MontoCondona,Par_NumDecimales) AS MontoCondona,
                ROUND(MontoBonifi,Par_NumDecimales) AS MontoBonifi,
				REPLACE(CONVERT(IFNULL(FechaCastigo,Fecha_Vacia),CHAR),'-',Cadena_Vacia) AS FechaCastigo,
				TipoRelacion,
				ROUND(IFNULL(SaldoEstimable,0)) AS EPRCTotal,
                ClaveSIC,
                 CASE IFNULL(FecConsultaSIC,Fecha_Vacia) WHEN Fecha_Vacia THEN Cadena_Vacia ELSE REPLACE(FecConsultaSIC,'-',Cadena_Vacia) END AS FecConsultaSIC,
                TipoCobranza,
                ROUND(TotGtiaLiquida,Par_NumDecimales) AS TotGtiaLiquida,
				ROUND(GtiaHipotecaria,Par_NumDecimales) AS GtiaHipotecaria
			FROM R04I0453;
	ELSE
		IF(Par_NumReporte = Rep_Csv) THEN

			SELECT	CONCAT(
				IFNULL(Reg_0453,Cadena_Vacia),';',
                CONVERT(IFNULL(ClienteID,Cadena_Vacia), CHAR),';',
                IFNULL(TipoPersona,Cadena_Vacia),';',
                IFNULL(Denominacion,Cadena_Vacia),';',
                IFNULL(ApellidoPat,Cadena_Vacia),';',
				IFNULL(ApellidoMat,Cadena_Vacia),';',
                IFNULL(RFC,Cadena_Vacia),';',
				IFNULL(CURP,Cadena_Vacia),';',
                IFNULL(Genero,Cadena_Vacia),';',
                CONVERT(IFNULL(CreditoID,Cadena_Vacia), CHAR),';',
				CONVERT(IFNULL(ClaveSucursal,Cadena_Vacia), CHAR),';',
				IFNULL(ClasifConta,Cadena_Vacia),';',
                IFNULL(ProductoCredito,Cadena_Vacia),';',
				REPLACE(IFNULL(FechaDisp,Fecha_Vacia),'-',Cadena_Vacia),';',
				REPLACE(IFNULL(FechaVencim,Fecha_Vacia),'-',Cadena_Vacia),';',
				IFNULL(TipoAmorti,Cadena_Vacia),';',
                ROUND(IFNULL(MontoCredito,Entero_Cero),Par_NumDecimales),';',
				CASE WHEN IFNULL(FecUltPagoCap,Fecha_Vacia) != Fecha_Vacia THEN
						REPLACE(CONVERT(IFNULL(FecUltPagoCap,Cadena_Vacia),CHAR),'-',Cadena_Vacia)
					  ELSE REPLACE(Fecha_Vacia,'-',Cadena_Vacia)
				END,';',
				ROUND(IFNULL(MonUltPagoCap,Entero_Cero),Par_NumDecimales),';',
				CASE WHEN IFNULL(FecUltPagoInt,Fecha_Vacia) != Fecha_Vacia THEN
						REPLACE(CONVERT(IFNULL(FecUltPagoInt,Cadena_Vacia),CHAR),'-',Cadena_Vacia)
					 ELSE REPLACE(Fecha_Vacia,'-',Cadena_Vacia)
				END,';',
				ROUND(IFNULL(MonUltPagoInt,Entero_Cero),Par_NumDecimales),';',
				CASE IFNULL(FecPrimAtraso,Fecha_Vacia) WHEN Fecha_Vacia THEN
                REPLACE(Fecha_Vacia,'-',Cadena_Vacia) ELSE
                REPLACE(IFNULL(FecPrimAtraso,Cadena_Vacia),'-',Cadena_Vacia) END,';',
                IFNULL(NumDiasAtraso,Cadena_Vacia),';',
                IFNULL(TipoCredito,Cadena_Vacia),';',
                ROUND(IFNULL(SalCapital,Entero_Cero),Par_NumDecimales),';',
				ROUND(IFNULL(SalIntOrdin,Entero_Cero),Par_NumDecimales),';',
				ROUND(IFNULL(SalIntMora,Entero_Cero),Par_NumDecimales),';',
				ROUND(IFNULL(IntereRefinan,Entero_Cero),Par_NumDecimales),';',
                ROUND(IFNULL(MontoCastigo,Entero_Cero),Par_NumDecimales),';',
                ROUND(IFNULL(MontoCondona,Entero_Cero),Par_NumDecimales),';',
                ROUND(IFNULL(MontoBonifi,Entero_Cero),Par_NumDecimales),';',
				REPLACE(IFNULL(CONVERT(IFNULL(FechaCastigo,Fecha_Vacia),CHAR),Cadena_Vacia),'-',Cadena_Vacia),';',
				IFNULL(TipoRelacion,Cadena_Vacia),';',
				ROUND(IFNULL(SaldoEstimable,Entero_Cero),Entero_Cero),';',
                IFNULL(ClaveSIC,Cadena_Vacia),';',
                CASE IFNULL(FecConsultaSIC,Fecha_Vacia) WHEN Fecha_Vacia
                THEN REPLACE(Fecha_Vacia,'-',Cadena_Vacia)
                ELSE REPLACE(IFNULL(FecConsultaSIC,Cadena_Vacia),'-',Cadena_Vacia) END,';',
                IFNULL(TipoCobranza,Cadena_Vacia),';',
                ROUND(IFNULL(TotGtiaLiquida,Entero_Cero),Par_NumDecimales),';',
				ROUND(IFNULL(GtiaHipotecaria,Entero_Cero),Par_NumDecimales),';'

            ) AS Valor

				FROM R04I0453;
		END IF;
	END IF;

	DROP TEMPORARY TABLE IF EXISTS R04I0453;

END TerminaStore$$