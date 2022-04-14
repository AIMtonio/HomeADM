-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGA041700003REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGA041700003REP`;
DELIMITER $$


CREATE PROCEDURE `REGA041700003REP`(
	-- Genera el reporte 417 para el formato SOFIPO
    Par_Fecha           DATETIME,
	Par_NumReporte      TINYINT UNSIGNED,

    Par_EmpresaID       INT,
    Aud_Usuario         INT,
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT,
    Aud_NumTransaccion  BIGINT
	)

TerminaStore: BEGIN
    DECLARE Var_ClaveEntidad    VARCHAR(300);
    DECLARE Var_Periodo         CHAR(6);
    DECLARE Var_UltFecEPRC      DATE;
    DECLARE Var_FechaConta		DATE;		-- Fecha Contable
    DECLARE Var_UbiCon			CHAR(1);	-- Ubicacion Contable

	DECLARE Clas_Credito				INT;
	DECLARE RestructuradoMarSi			INT;
	DECLARE RestructuradoMarNo			INT;
	DECLARE Clas_CreRestructuradoMarSi	INT;
	DECLARE Clas_CreRestructuradoMarNo	INT;
	DECLARE Clave_CuentaMayor			INT;

	DECLARE Rep_Excel       	INT;
	DECLARE Rep_Csv         	INT;
	DECLARE tipomoneda      	INT;
	DECLARE Entero_Cero      	INT;
	DECLARE Tipo_Cartera    	INT;

    DECLARE Tipo_EPRC       	INT;
	DECLARE folio_form      	CHAR(4);
	DECLARE Tipo_Saldo      	CHAR(1);
	DECLARE Tipo_EPRC_CAL   	CHAR(3);
	DECLARE Tipo_EPRC_ADI   	CHAR(3);

    DECLARE Nivel_Detalle       CHAR(1);
	DECLARE Nivel_Encabezado    CHAR(1);
	DECLARE ESTCRE_VENCIDO  	CHAR(1);
	DECLARE CLASIF_REEST    	CHAR(1);
	DECLARE Rest_ORI_NA     	CHAR(3);

    DECLARE CADENA_VACIA    	CHAR(1);
	DECLARE Cla_Comercial   	CHAR(1);
	DECLARE Cla_Consumo     	CHAR(1);
	DECLARE Cla_Vivienda    	CHAR(1);
	DECLARE Fecha_Vacia     	DATE;

    DECLARE Resp_NO         		CHAR(1);
	DECLARE Resp_SI         		CHAR(1);
	DECLARE Clasif_NA       		INT;
	DECLARE Cred_Vigente            CHAR(1);
	DECLARE Cred_Vencido            CHAR(1);

    DECLARE Clas_OtrConsumo         INT;
	DECLARE Clas_MedResgarHipo      INT;
	DECLARE Clas_MedResZonaMarg     INT;
	DECLARE Clas_MedResZonaNoMarg   INT;
	DECLARE Clas_MedResidencial     INT;

	DECLARE Clas_IntSocgarHipo      INT;
	DECLARE Clas_IntSocZonaMarg     INT;
	DECLARE Clas_IntSocZonaNoMarg   INT;
	DECLARE Clas_InteresSocial      INT;
	DECLARE Clas_ComerOtros        	INT;

    DECLARE Clas_ActEmpresarial    	INT;
	DECLARE Clas_Prendarios   		INT;
	DECLARE Clas_Puente   	   		INT;
	DECLARE Clas_PrendariosOtr 		INT;
	DECLARE Clas_PuenteOtros       	INT;

    DECLARE Clas_QuirograOtros     	INT;
	DECLARE Clas_Quirografarias    	INT;
	DECLARE Tmp_CuentaEPRCAdi      	VARCHAR(20);
	DECLARE Con_UbiHistorica     	CHAR(1);
	DECLARE Var_SumaInteresVencidos	CHAR(1);
	DECLARE Var_EPRC				DECIMAL(14,2);
	DECLARE Var_Total_EPRC			DECIMAL(14,2);
    DECLARE Decimal_Cero			DECIMAL(14,2);


    DECLARE Var_AjustaSaldo			CHAR(1);
	DECLARE Var_Redondeo			INT;
	DECLARE Var_Mes					INT;
	DECLARE Var_Anio				INT;
	DECLARE Var_MaxNivel			INT;
	DECLARE Var_MinNivel			INT;
	DECLARE Var_Contador			INT;
	DECLARE Var_ContadorAux			INT;
    DECLARE Var_CuentaBuscar		VARCHAR(15);
    DECLARE Var_DiferenciaCartera	DECIMAL(14,2);
    DECLARE Var_DiferenciaReserva	DECIMAL(14,2);
    DECLARE Var_ClienteEspecifico 	INT(11);
    DECLARE Var_NO					CHAR(1);


	SET Rep_Excel       	:=  1;
	SET Rep_Csv         	:=  2;
	SET tipomoneda      	:=  14;
	SET folio_form     		:=  '417';
	SET Tipo_Saldo      	:=  '1';
    SET Tipo_Cartera    	:=  9;
	SET Tipo_EPRC       	:=  10;
	SET Tipo_EPRC_CAL   	:=  'CAL';
	SET Tipo_EPRC_ADI   	:=  'ADI';
	SET Nivel_Detalle       :=  'D';
	SET Nivel_Encabezado    :=  'E';
	SET ESTCRE_VENCIDO  	:=  'B';
 	SET CLASIF_REEST    	:=  'R';
	SET Rest_ORI_NA     	:=  'na';
	SET CADENA_VACIA    	:=  '';

	SET Cla_Comercial   	:= 'C';
	SET Cla_Consumo     	:= 'O';
	SET Cla_Vivienda    	:= 'H';
	SET Fecha_Vacia     	:= '1900-01-01';
	SET Resp_NO         	:= 'N';


    SET Resp_SI         	:= 'S';
	SET Clasif_NA       	:= 99999;
	SET Cred_Vigente    	:= 'V';
	SET Cred_Vencido    	:= 'B';
	SET Clas_OtrConsumo 	:= 41125;

    SET Clas_MedResgarHipo 		:= 4112701;
	SET Clas_MedResidencial 	:= 41127;
	SET Clas_MedResZonaMarg		:= 411270202;
	SET Clas_MedResZonaNoMarg 	:= 411270201;
	SET Entero_Cero 			:= 0;
	SET Decimal_Cero 			:= 0.00;

    SET Clas_IntSocgarHipo      := 4112801;
	SET Clas_IntSocZonaMarg     := 411280202;
	SET Clas_IntSocZonaNoMarg   := 411280201;
	SET Clas_InteresSocial      := 41128;
	SET Clas_ComerOtros         := 41108;

    SET Clas_ActEmpresarial     := 41102;
	SET Clas_QuirograOtros      := 4110302;
	SET Clas_Quirografarias     := 41103;
	SET Tmp_CuentaEPRCAdi       := '139605000000';

	SET Clas_Prendarios   		:= '41104';
    SET Clas_Puente   	  		:= '41105';
    SET Clas_PrendariosOtr		:= '4110403';
    SET Clas_PuenteOtros  		:= '4110502';
    SET Var_UbiCon				:= 'A';

	SET Clas_Credito				:= 41129;		-- Clasificacion Creditos
	SET RestructuradoMarSi			:= 4112922;		-- Clasificacion Creditos Restructurados
	SET RestructuradoMarNo			:= 4112921;		-- Clasificacion Creditos no Restructurados
	SET Clas_CreRestructuradoMarSi	:= 4112912;		-- Clasificacion Creditos Restructurados en zona marginal
	SET Clas_CreRestructuradoMarNo	:= 4112911;		-- Clasificacion Creditos Restructurados en zona no marginal
	SET Clave_CuentaMayor			:= 10123;		-- Cuenta Mayor
	SET Con_UbiHistorica			:= 'H';			-- Ubicacion Historica
    SET Var_NO						:= 'N';

	SELECT  MAX(Fecha) INTO Var_UltFecEPRC
		FROM  CALRESCREDITOS
		WHERE  Fecha <= Par_Fecha;

	SET Var_UltFecEPRC 	 := IFNULL(Var_UltFecEPRC, Fecha_Vacia);

	SET Var_Periodo := CONCAT(SUBSTRING(REPLACE(CONVERT(Par_Fecha, CHAR),'-',CADENA_VACIA),1,4),
							  SUBSTRING(REPLACE(CONVERT(Par_Fecha, CHAR),'-',CADENA_VACIA),5,2));

	SET Var_ClaveEntidad := IFNULL((SELECT Ins.ClaveEntidad
										FROM PARAMETROSSIS Par,
											 INSTITUCIONES Ins
										WHERE Par.InstitucionID = Ins.InstitucionID), CADENA_VACIA);

	SET Var_Anio :=	CONVERT(SUBSTRING(REPLACE(CONVERT(Par_Fecha, CHAR),'-',CADENA_VACIA),1,4), UNSIGNED INTEGER) ;
	SET Var_Mes	 :=	CONVERT(SUBSTRING(REPLACE(CONVERT(Par_Fecha, CHAR),'-',CADENA_VACIA),5,2), UNSIGNED INTEGER) ;

	SET Var_SumaInteresVencidos := IFNULL((SELECT IntCredVencidos FROM PARAMREGULATORIOS), Resp_NO);
	SET Var_ClienteEspecifico := FNPARAMGENERALES('CliProcEspecifico');

	DROP TABLE IF EXISTS 	TMP_CATCON417;
	CREATE TEMPORARY TABLE	TMP_CATCON417
	SELECT cal.CreditoID,		cre.ClienteID,		sal.DiasAtraso,		cal.Capital,				(CASE WHEN Var_SumaInteresVencidos = Resp_SI THEN (sal.SalIntAtrasado + sal.SalIntVencido + sal.SalIntProvision + sal.SaldoMoraVencido) ELSE cal.Interes END) AS Interes,
		   cal.PorcReservaExp,	cal.Reserva, 		cal.Clasificacion,	Resp_NO AS Restructurado,	cal.ZonaMarginada AS Marginada,
		   sal.DestinoCreID,	sal.ClasifRegID AS ClasifRegID,	cre.Estatus
	FROM CALRESCREDITOS cal, SALDOSCREDITOS sal, CREDITOS cre
	WHERE 	sal.FechaCorte	= Par_Fecha
			AND sal.FechaCorte  = cal.Fecha
			AND sal.CreditoID	= cal.CreditoID
			AND sal.CreditoID	= cre.CreditoID
			AND sal.EstatusCredito	IN (Cred_Vigente ,Cred_Vencido );

	CREATE INDEX idx_abd1 ON TMP_CATCON417(CreditoID);



    UPDATE TMP_CATCON417 Car
	INNER JOIN DESTINOSCREDITO Des ON Car.DestinoCreID = Des.DestinoCreID
		SET Car.ClasifRegID = IFNULL(Des.ClasifRegID,Clas_OtrConsumo);



    UPDATE TMP_CATCON417 tem,REESTRUCCREDITO res
		SET tem.Restructurado = CLASIF_REEST
	WHERE tem.CreditoID = res.CreditoDestinoID AND res.Origen = CLASIF_REEST
    AND res.FechaRegistro <= Par_Fecha;





    UPDATE TMP_CATCON417 tem, CREGARPRENHIPO gar SET
		tem.DiasAtraso 	= Entero_Cero
	WHERE tem.CreditoID	= gar.CreditoID
	AND gar.GarHipotecaria > Entero_Cero
    AND tem.Clasificacion  = Cla_Comercial;



	UPDATE TMP_CATCON417 tem, CREGARPRENHIPO gar SET
		tem.ClasifRegID 	= Clas_MedResgarHipo
	WHERE tem.CreditoID 	= gar.CreditoID
	AND gar.GarHipotecaria  > Entero_Cero
	AND tem.ClasifRegID 	= Clas_MedResidencial
	AND tem.Clasificacion	= Cla_Vivienda;







	UPDATE TMP_CATCON417 tem
		SET tem.ClasifRegID = CASE WHEN tem.Marginada = Resp_SI THEN Clas_MedResZonaMarg ELSE Clas_MedResZonaNoMarg END
	WHERE tem.ClasifRegID 	= Clas_MedResidencial
	AND tem.Clasificacion 	= Cla_Vivienda;


	UPDATE TMP_CATCON417 tem, CREGARPRENHIPO gar SET
		tem.ClasifRegID 	= Clas_IntSocgarHipo
	WHERE tem.CreditoID 	= gar.CreditoID
	AND gar.GarHipotecaria 	> Entero_Cero
	AND tem.ClasifRegID 	= Clas_InteresSocial
	AND tem.Clasificacion 	= Cla_Vivienda;


	UPDATE TMP_CATCON417 tem
		SET tem.ClasifRegID = CASE WHEN tem.Marginada = Resp_SI THEN Clas_IntSocZonaMarg ELSE Clas_IntSocZonaNoMarg END
	WHERE tem.ClasifRegID 	= Clas_InteresSocial
	AND tem.Clasificacion 	= Cla_Vivienda;

	UPDATE TMP_CATCON417 tem
		SET tem.ClasifRegID = CASE WHEN tem.Marginada = Resp_SI  AND tem.Restructurado =  CLASIF_REEST THEN RestructuradoMarSi
								   WHEN tem.Marginada = Resp_NO  AND tem.Restructurado =  CLASIF_REEST THEN RestructuradoMarNo
                                   WHEN tem.Marginada = Resp_SI  AND tem.Restructurado =  Resp_NO THEN Clas_CreRestructuradoMarSI
                                   WHEN tem.Marginada = Resp_NO  AND tem.Restructurado =  Resp_NO THEN Clas_CreRestructuradoMarNo END
	WHERE tem.ClasifRegID 	= Clas_Credito
	AND tem.Clasificacion 	= Cla_Comercial;


	UPDATE TMP_CATCON417 tem
	SET tem.ClasifRegID =  CASE tem.ClasifRegID WHEN Clas_Quirografarias THEN Clas_QuirograOtros
												WHEN Clas_Prendarios 	 THEN Clas_PrendariosOtr
												WHEN Clas_Puente 		 THEN Clas_PuenteOtros
												WHEN Clas_ActEmpresarial THEN Clas_ComerOtros
							END
	WHERE tem.ClasifRegID IN (Clas_Quirografarias,Clas_Prendarios,Clas_Puente,Clas_ActEmpresarial);

IF Var_ClienteEspecifico <> 24 THEN
    UPDATE TMP_CATCON417 SET
		Restructurado = CLASIF_REEST
    WHERE Clasificacion = Cla_Consumo AND Marginada = Resp_SI;
END IF;

    UPDATE TMP_CATCON417 SET
		Restructurado = 'N'
    WHERE Clasificacion = Cla_Consumo AND Marginada <> Resp_SI;





    DROP TABLE IF EXISTS TMP_CATCONCREGULA417;
	CREATE TEMPORARY TABLE TMP_CATCONCREGULA417(
		ConceptoID 		INT(11),
		CuentaMayor 	VARCHAR(45),
		ClaveConcepto 	VARCHAR(45),
		Descripcion 	VARCHAR(400),
		TipoCartera 	INT(11),
		Clasificacion 	CHAR(2),
		MinDiasAtraso 	INT(11),
		MaxDiasAtraso 	INT(11),
		Nivel 			CHAR(1),
		Orden 			INT(11),
		TipoCredito 	CHAR(1),
		Monto 			DECIMAL(16,2),
		TipoEPRC 		VARCHAR(3),
		OrdenExcell 	INT,
		ClasifRegID 	INT(11),
		INDEX TMP_CATCONCREGULA417_idx1 (ClaveConcepto)
	);

	DROP TABLE IF EXISTS TMP_CTASMAYORREG;
	CREATE TEMPORARY TABLE TMP_CTASMAYORREG(
		ConceptoID 		INT(11),
		CuentaMayor 	VARCHAR(45),
		ClaveConcepto 	VARCHAR(45),
		Descripcion 	VARCHAR(400),
		TipoCartera 	INT(11),
		Clasificacion 	CHAR(2),
		MinDiasAtraso 	INT(11),
		MaxDiasAtraso 	INT(11),
		Nivel 			CHAR(1),
		Orden 			INT(11),
		TipoCredito 	CHAR(1),
		Monto 			DECIMAL(16,2),
		TipoEPRC 		VARCHAR(3),
		INDEX TMP_CTASMAYORREG_idx1 (ClaveConcepto)
    );

	INSERT INTO TMP_CATCONCREGULA417
	SELECT ConceptoID,		CuentaMayor,			ClaveConcepto,		Descripcion,		TipoCartera,
		   Clasificacion, 	MinDiasAtraso,			MaxDiasAtraso, 		Nivel,				Orden,
           TipoCredito,		Entero_cero AS Monto, 	trim(TipoEPRC), 	OrdenExcell,		ClasifRegID
	FROM CATCONCREGULA417
	WHERE TipoInstitID = 3;

	SELECT AjusteSaldo INTO Var_AjustaSaldo FROM PARAMREGULATORIOS LIMIT 1;
	SET Var_AjustaSaldo := IFNULL(Var_AjustaSaldo , Var_NO);

    IF(Var_AjustaSaldo = Resp_SI) THEN
		SET Var_Redondeo := Entero_Cero;
    ELSE
		SET Var_Redondeo := 2;
    END IF;



	UPDATE TMP_CATCONCREGULA417 Reg SET
		Reg.Monto = (SELECT ROUND(IFNULL(SUM(Tem.Capital +Tem.Interes), Entero_Cero), Var_Redondeo)
						FROM TMP_CATCON417 Tem
						WHERE Reg.TipoCredito =  CASE WHEN Tem.ClasifRegID IN (Clas_MedResZonaNoMarg,Clas_MedResZonaMarg,Clas_IntSocZonaNoMarg,Clas_MedResZonaMarg,Clas_IntSocZonaMarg)
													  THEN Reg.TipoCredito ELSE Tem.Restructurado END
						AND Reg.Clasificacion = Tem.Clasificacion
						AND Reg.MaxDiasAtraso != -1
						AND Reg.MinDiasAtraso != -1
						AND Reg.Nivel = Nivel_Detalle
						AND Reg.TipoCartera = Tipo_Cartera
						AND Reg.TipoEPRC = Tipo_EPRC_CAL
						AND Reg.ClasifRegID = Tem.ClasifRegID
						AND Tem.DiasAtraso BETWEEN Reg.MinDiasAtraso AND Reg.MaxDiasAtraso )
	WHERE Reg.TipoCartera = Tipo_Cartera;

	UPDATE TMP_CATCONCREGULA417 Reg SET
		Reg.Monto = (SELECT	ROUND(IFNULL(SUM(Tem.Reserva), Entero_Cero), Var_Redondeo)
						FROM TMP_CATCON417 Tem
						WHERE Reg.TipoCredito =  CASE WHEN Tem.ClasifRegID IN (Clas_MedResZonaNoMarg,Clas_MedResZonaMarg,Clas_IntSocZonaNoMarg,Clas_MedResZonaMarg,Clas_IntSocZonaMarg)
													  THEN Reg.TipoCredito ELSE Tem.Restructurado END
						AND Reg.Clasificacion = Tem.Clasificacion
						AND Reg.MaxDiasAtraso != -1
						AND Reg.MinDiasAtraso != -1
						AND Reg.Nivel = Nivel_Detalle
						AND Reg.TipoCartera = Tipo_EPRC
						AND Reg.TipoEPRC = Tipo_EPRC_CAL
						AND Reg.ClasifRegID = Tem.ClasifRegID
						AND Tem.DiasAtraso BETWEEN Reg.MinDiasAtraso AND Reg.MaxDiasAtraso )
	WHERE Reg.TipoCartera = Tipo_EPRC;





	DROP TABLE IF EXISTS tmp_adiRes;

	CREATE TABLE tmp_adiRes
	SELECT Tmp_CuentaEPRCAdi AS CuentaMayor, ROUND(IFNULL(SUM(sal.SalIntVencido + sal.SalIntProvision + sal.SaldoMoraVencido), Entero_Cero), Var_Redondeo) AS Monto
    FROM SALDOSCREDITOS sal
	WHERE sal.FechaCorte = Var_UltFecEPRC
	AND sal.EstatusCredito IN(Cred_Vencido);


	UPDATE TMP_CATCONCREGULA417 Reg SET
		Reg.Monto = (SELECT IFNULL(SUM(Tem.Monto), Entero_Cero)
						FROM tmp_adiRes Tem
						WHERE trim(Reg.TipoEPRC) = Tipo_EPRC_ADI
						AND Reg.ClaveConcepto 	 = Tem.CuentaMayor)
	WHERE Reg.ClaveConcepto  = Tmp_CuentaEPRCAdi
	AND trim(Reg.TipoEPRC)   = Tipo_EPRC_ADI;

	SELECT MAX(Fecha) INTO Var_FechaConta FROM `HIS-DETALLEPOL`;
    SET Var_FechaConta := IFNULL(Var_FechaConta,Fecha_Vacia);

    IF Var_FechaConta >= Par_Fecha THEN
		SET Var_UbiCon	:= Con_UbiHistorica;
    END IF;

    UPDATE TMP_CATCONCREGULA417 Reg SET
		Reg.Monto = @SaldoOrdCNBV
	WHERE Reg.TipoCartera  = Tipo_EPRC
	AND  Reg.CuentaMayor = Clave_CuentaMayor;


IF(Var_AjustaSaldo = Resp_SI) THEN

		DROP TABLE IF EXISTS TMP_REGCATA0417_SALDOS;
		CREATE TABLE TMP_REGCATA0417_SALDOS(
			TipoCartera			int,
            CuentaFija417		VARCHAR(25) ,
            Saldo				DECIMAL(14,2)
		);

		DROP TABLE IF EXISTS TMP_REGCATA0417;
		CREATE TABLE TMP_REGCATA0417(
			Concepto	  		INT,
            CuentaFija417		VARCHAR(25),
			CuentaFijaVigente	VARCHAR(25),
			CuentaFijaVencida 	VARCHAR(25),
            CuentaFijaEprc 		VARCHAR(25),
			SaldoCartera 		DECIMAL(14,2),
			SaldoEprc	  		DECIMAL(14,2),
            SaldoCartera417 	DECIMAL(14,2),
			SaldoEprc417  		DECIMAL(14,2),
			DiferenciaCartera	DECIMAL(14,2),
			DiferenciaEprc 		DECIMAL(14,2));

		CREATE INDEX INDEX_TMP_REGCATA04171 ON TMP_REGCATA0417(CuentaFijaEprc);
		CREATE INDEX INDEX_TMP_REGCATA04172 ON TMP_REGCATA0417(CuentaFijaVigente);
		CREATE INDEX INDEX_TMP_REGCATA04173 ON TMP_REGCATA0417(CuentaFijaVencida);

		INSERT INTO TMP_REGCATA0417 VALUES
        ( 1		,41103	,130105010000	,135105010000	,139150510501,0,0,0,0,0,0),
		( 2		,41104	,130105020000	,135105020000	,139150510502,0,0,0,0,0,0),
		( 3		,41105	,130105030000	,135105030000	,139150510503,0,0,0,0,0,0),
		( 4		,41106	,130105040000	,135105040000	,139150510504,0,0,0,0,0,0),
		( 5		,41107	,130105050000	,135105050000	,139150510505,0,0,0,0,0,0),
		( 6		,41129	,130105070000	,135105070000	,139150510506,0,0,0,0,0,0),
		( 7		,41108	,130105060000	,135105060000	,139150510507,0,0,0,0,0,0),
		( 8		,41130	,130122000000	,135122000000	,139150512200,0,0,0,0,0,0),
		( 9		,41119	,131101000000	,136101000000	,139150611000,0,0,0,0,0,0),
		( 10	,41120	,131103000000	,136103000000	,139150612000,0,0,0,0,0,0),
		( 11	,41121	,131113000000	,136113000000	,139150613000,0,0,0,0,0,0),
		( 12	,41122	,131105000000	,136105000000	,139150614000,0,0,0,0,0,0),
		( 13	,41123	,131106000000	,136106000000	,139150615000,0,0,0,0,0,0),
		( 14	,41124	,131104000000	,136104000000	,139150616000,0,0,0,0,0,0),
		( 15	,41125	,131190000000	,136190000000	,139150619000,0,0,0,0,0,0),
		( 16	,41127	,131601000000	,136601000000	,139150661000,0,0,0,0,0,0),
		( 17	,41128	,131602000000	,136602000000	,139150662000,0,0,0,0,0,0);


		UPDATE TMP_REGCATA0417 tmp, `HIS-CATALOGOMINIMO` cat SET
			tmp.SaldoCartera = cat.Monto
		WHERE cat.Anio = Var_Anio and cat.Mes = Var_Mes and cat.CuentaContable = tmp.CuentaFijaVigente;


		UPDATE TMP_REGCATA0417 tmp, `HIS-CATALOGOMINIMO` cat SET
			tmp.SaldoCartera =  tmp.SaldoCartera + cat.Monto
		WHERE cat.Anio = Var_Anio and cat.Mes = Var_Mes and cat.CuentaContable = tmp.CuentaFijaVencida;


		UPDATE TMP_REGCATA0417 tmp, `HIS-CATALOGOMINIMO` cat SET
			tmp.SaldoEprc =  cat.Monto
		WHERE cat.Anio = Var_Anio and cat.Mes = Var_Mes and cat.CuentaContable = tmp.CuentaFijaEprc;

        INSERT INTO TMP_REGCATA0417_SALDOS
        SELECT reg.TipoCartera,sal.CuentaFija417,sum(Monto)
        FROM TMP_CATCONCREGULA417 reg,TMP_REGCATA0417 sal
        where reg.ClasifRegID like concat(sal.CuentaFija417,'%')
        and reg.TipoCartera = 9
        group by reg.TipoCartera,sal.CuentaFija417;

        INSERT INTO TMP_REGCATA0417_SALDOS
        SELECT reg.TipoCartera,sal.CuentaFija417,sum(Monto)
        FROM TMP_CATCONCREGULA417 reg,TMP_REGCATA0417 sal
        where reg.ClasifRegID like concat(sal.CuentaFija417,'%')
        and reg.TipoCartera = 10
        group by reg.TipoCartera,sal.CuentaFija417;

        UPDATE TMP_REGCATA0417 sal,TMP_REGCATA0417_SALDOS rep
			SET sal.SaldoCartera417 = rep.Saldo
		WHERE sal.CuentaFija417 = rep.CuentaFija417
        AND rep.TipoCartera = 9;

         UPDATE TMP_REGCATA0417 sal,TMP_REGCATA0417_SALDOS rep
			SET sal.SaldoEprc417 = (rep.Saldo * -1)
		WHERE sal.CuentaFija417 = rep.CuentaFija417
        AND rep.TipoCartera = 10;



		UPDATE TMP_REGCATA0417 tmp SET
			tmp.DiferenciaCartera =    tmp.SaldoCartera - tmp.SaldoCartera417,
			tmp.DiferenciaEprc =    tmp.SaldoEprc - tmp.SaldoEprc417
		; -- vk


        set @numRegistros := (select max(Concepto) from TMP_REGCATA0417);
        set @consecutivo  := 1;

        while @consecutivo <= @numRegistros do

            set @diferCartera := 0;
            set @diferEprc	  := 0;
            set @concepto417  := '';


            select DiferenciaCartera,DiferenciaEprc,CuentaFija417
            into @diferCartera,@diferEprc,@concepto417
            from TMP_REGCATA0417
            where Concepto = @consecutivo;




            update TMP_CATCONCREGULA417
				set Monto = Monto + @diferCartera
			where TipoCartera = 9
            and Monto > @diferCartera
            and ClasifRegID like concat(@concepto417,'%')
            and Nivel = 'D'
            limit 1;

            update TMP_CATCONCREGULA417
				set Monto = Monto - @diferEprc
			where TipoCartera = 10
            and Monto > @diferEprc
            and ClasifRegID like concat(@concepto417,'%')
            and Nivel = 'D'
            limit 1;

            set @consecutivo := @consecutivo + 1;
        end while;


END IF;





    INSERT INTO TMP_CTASMAYORREG
		SELECT	ConceptoID,		CuentaMayor,	ClaveConcepto,	Descripcion,	TipoCartera,
				Clasificacion,	MinDiasAtraso,	MaxDiasAtraso,	Nivel,			Orden,
				TipoCredito,	Monto,			TipoEPRC
			FROM TMP_CATCONCREGULA417
			WHERE Nivel = Nivel_Detalle;

	UPDATE TMP_CATCONCREGULA417 Reg SET
		Reg.Monto = (SELECT SUM(IFNULL(Det.Monto,Entero_Cero))
						FROM TMP_CTASMAYORREG Det
						WHERE Det.Nivel = Nivel_Detalle
						  AND Det.CuentaMayor LIKE CONCAT(Reg.CuentaMayor, '%')
						  AND Reg.TipoCartera = Det.TipoCartera )
	WHERE Reg.Nivel = Nivel_Encabezado;

	DROP TABLE IF EXISTS TMP_CART9;
	CREATE TABLE TMP_CART9
	SELECT ClaveConcepto, Descripcion, Monto, OrdenExcell, Nivel, CuentaMayor
		FROM TMP_CATCONCREGULA417
		WHERE TipoCartera = Tipo_Cartera;

	DROP TABLE IF EXISTS TMP_CART10;
	CREATE TABLE TMP_CART10
	SELECT ClaveConcepto, Descripcion, Monto, OrdenExcell, Nivel, CuentaMayor
		FROM TMP_CATCONCREGULA417
		WHERE TipoCartera = Tipo_EPRC;

	DROP TABLE IF EXISTS TMP_REGA0417;
	CREATE TABLE TMP_REGA0417
	SELECT res.ClaveConcepto,		res.Descripcion,		IFNULL(car.Monto,Entero_Cero) AS Cartera,
		   (IFNULL(res.Monto,Entero_Cero)* -1) AS Reserva, car.Nivel, car.CuentaMayor
		FROM  TMP_CART10 res
		LEFT OUTER JOIN TMP_CART9 car ON res.ClaveConcepto = car.ClaveConcepto
		ORDER BY res.OrdenExcell;


	SELECT Cartera INTO  Var_Total_EPRC
    FROM TMP_REGA0417 WHERE ClaveConcepto = 139100000000;

	SELECT -Reserva INTO Var_EPRC
    FROM TMP_REGA0417 WHERE ClaveConcepto = 139605000000;
    
IF Var_ClienteEspecifico <> 24 THEN
	UPDATE TMP_REGA0417 SET
		Cartera = Var_EPRC
	WHERE ClaveConcepto IN (139600000000, 139605000000);

    UPDATE TMP_REGA0417 SET
		Cartera = Var_EPRC + Var_Total_EPRC
	WHERE ClaveConcepto = 139000000000;
END IF;

	IF( Par_NumReporte = Rep_Excel) THEN

		SELECT res.ClaveConcepto, res.Descripcion, res.Cartera, res.Reserva
			FROM  TMP_REGA0417 res;

	ELSE

		IF( Par_NumReporte = Rep_Csv) THEN

            (SELECT (CONCAT( ClaveConcepto,';',folio_form, ';',tipomoneda,';',Tipo_Cartera,';',IFNULL(Tipo_Saldo,Entero_Cero),';',ROUND(Cartera,Var_Redondeo))) AS Valor
				FROM TMP_REGA0417 WHERE ClaveConcepto NOT IN('139000000000','139600000000','139604000000','139605000000','139000000000','139609000000','139197000000','139603000000'))
			UNION
			(SELECT (CONCAT( ClaveConcepto,';',folio_form, ';',tipomoneda,';',Tipo_EPRC,';',IFNULL(Tipo_Saldo,Entero_Cero),';',ROUND((Reserva),Var_Redondeo))) AS Valor
				FROM TMP_REGA0417);
		END IF;
	END IF;

	DROP TABLE IF EXISTS TMP_CATCONCREGULA417;
	DROP TABLE IF EXISTS TMP_REG417;
	DROP TABLE IF EXISTS TMP_REGA0417;
	DROP TABLE IF EXISTS TMP_SALDOSACT;
	DROP TABLE IF EXISTS TMP_REGCATA0417;
	DROP TABLE IF EXISTS TMP_CTASACT;
	DROP TABLE IF EXISTS TMP_CTASMAYORREG;
	DROP TABLE IF EXISTS TMP_CATCON417;
	DROP TABLE IF EXISTS TMP_CARTERA;

END TerminaStore$$
DELIMITER ;
