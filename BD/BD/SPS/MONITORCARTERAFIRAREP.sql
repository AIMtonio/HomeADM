-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MONITORCARTERAFIRAREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `MONITORCARTERAFIRAREP`;
DELIMITER $$

CREATE PROCEDURE `MONITORCARTERAFIRAREP`(
	/* Reporte de Cartera FIRA*/
	Par_Fecha						DATE,				-- Fecha en la que se genera el reporte
	Par_Salida						CHAR(1),			-- Tipo de Salida S. Si N. No
	INOUT	Par_NumErr				INT(11),			-- Numero de Error
	INOUT	Par_ErrMen				VARCHAR(400),		-- Mensaje de Error

	/* Parametros de Auditoria */
	Aud_EmpresaID					INT(11),
	Aud_Usuario						INT(11),
	Aud_FechaActual					DATETIME,
	Aud_DireccionIP					VARCHAR(15),
	Aud_ProgramaID					VARCHAR(50),
	Aud_Sucursal					INT(11),
	Aud_NumTransaccion				BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_FechaSis			DATE;				-- Fecha del sistema
	DECLARE Var_Control				VARCHAR(50);		-- Variable para el ID del control de pantalla
	DECLARE Var_FechaReporte		DATE;				-- Fecha en la que se generaReporte
	DECLARE Var_Fecha12MesesAtras	DATE;				-- Fecha 12 meses atras en la que se generaReporte
	DECLARE Var_Contador1			INT(11);			-- Contador
	DECLARE Var_MaxTransaccion	 	BIGINT(20);

	-- Declaracion de Constantes
	DECLARE Cons_No					CHAR(1);			-- Constantes No
	DECLARE Cons_SI					CHAR(1);			-- Constantes Si
	DECLARE Entero_Cero				INT(11);			-- Entero Cero
	DECLARE Fecha_Vacia				DATE;
	DECLARE Mes12					INT(11);			-- Mes 12 (Diciembre)
	DECLARE Cadena_Vacia			VARCHAR(1);			-- Entero Cero
	DECLARE EsAgropecuarioCons		VARCHAR(1);			-- Es Credito Agropecuario
	DECLARE TipoFondeoFinanciado	VARCHAR(1);			-- Tipo de Fondeo Financiado
	DECLARE TipoReporte_CartVenc	INT(11);			-- ID CATREPORTESFIRA Cartera Vencida
	DECLARE Desc_CastigosCartVenc	VARCHAR(50);		-- Descripcion del grupo 1
	DECLARE Desc_CastigosCartVent	VARCHAR(50);		-- Descripcion del grupo 2
	DECLARE Desc_ConceptoMes12		VARCHAR(50);		-- Descripcion que aplica al mes 12 para el campo de concepto
	DECLARE Desc_ConceptoMesActual	VARCHAR(50);		-- Descripcion que aplica al mes actual para el campo de concepto
	DECLARE FechaSist				DATE;
    DECLARE Con_DiasMax				INT(1);
    DECLARE Con_DiasIncRees			INT(11);
    DECLARE Con_PeriodoRees			INT(11);
    DECLARE Con_DiasCumpRees		INT(11);
    DECLARE Var_FechaCorte			DATE;

	-- Asignacion de Constantes
	SET Entero_Cero					:= 0;
	SET Fecha_Vacia					:= '1900-01-01';
	SET TipoReporte_CartVenc		:= 5;
	SET Mes12 						:= 12;
	SET Var_FechaReporte			:= Par_Fecha;
	SET Var_Fecha12MesesAtras		:= DATE_SUB(Var_FechaReporte, INTERVAL 12 MONTH);
	SET Var_Contador1				:= 1;
    SET Con_DiasMax					:= 1;
    SET Con_DiasIncRees 			:= 2;
    SET Con_PeriodoRees				:= 3;
    SET Con_DiasCumpRees 			:= 4;

	DELETE FROM REPMONITOREOFIRA
			WHERE TipoReporteID = TipoReporte_CartVenc;

	SET lc_time_names := 'es_MX';


	SET Var_MaxTransaccion :=	(SELECT MAX(TransaccionID) FROM TMPCALCARTERAFIRA);

	-- Se eliminan registros anteriores
	DELETE FROM TMPARCHRESERVFIRA WHERE TransaccionID != Var_MaxTransaccion;
	DELETE FROM TMPCALCARTERAFIRA WHERE TransaccionID != Var_MaxTransaccion;
	-- Se eliminan los registros vacios
	DELETE FROM TMPARCHRESERVFIRA WHERE NumControl = '';
	DELETE FROM TMPARCHRESERVFIRA WHERE IdCreditoFira = '';
	DELETE FROM TMPARCHRESERVFIRA WHERE NumControl = 'NUM_CONTROL';
	DELETE FROM TMPCALCARTERAFIRA WHERE CreditoID = '';

	/* Se crea Temporal para las Garantias */
	DROP TABLE IF EXISTS TMPMONITORCARTGARANTIAS;
	CREATE TEMPORARY TABLE TMPMONITORCARTGARANTIAS
	SELECT ASI.CreditoID, SUM(ROUND((GAR.ValorComercial*(CLA.PorcAjuste/100)),2)) AS MontoGarantiaAjus
		FROM ASIGNAGARANTIAS AS ASI
		INNER JOIN GARANTIAS AS GAR ON ASI.GarantiaID = GAR.GarantiaID
		INNER JOIN CLASIFGARANTIAS AS CLA ON GAR.ClasifGarantiaID = CLA.ClasifGarantiaID
				AND GAR.TipoGarantiaID = CLA.TipoGarantiaID
		INNER JOIN CREDITOS AS CRED ON ASI.CreditoID=CRED.CreditoID
		WHERE ASI.Estatus='U'
		GROUP BY ASI.CreditoID;

	/* Se inserta el registro de cabecera para el reporte FIRA */
	SET @cont := 0;
	INSERT INTO REPMONITOREOFIRA(
		TipoReporteID,				FechaGeneracion,				ConsecutivoID,
		CSVReporte,						EmpresaID,
		Usuario,					FechaActual,					DireccionIP,			ProgramaID,						Sucursal,
		NumTransaccion)
		SELECT
		TipoReporte_CartVenc,		Par_Fecha,						@cont:=@cont+1,
		CONCAT_WS(',',
			'CREDITO ID',
			'NOMBRE ACREDITADO',
			'FECHA OPERACION',
			'TIPO PERSONA',
			'RFC',
			'CURP',
			'MONEDA DE ORIGEN',
			'SALDO INSOLUTO FIRA-IF',
			'GARANTIA FEGA SIN FONDEO',
			'% GARANTIA EFECTIVA FEGA',
			'% GARANTIA NOMINAL FEGA',
			'CREDITO ESTRUCTURADO CON FIRA',
			'CADENA PRODUCTIVA',
			'ENTIDAD FEDERATIVA',
			'PORCENTAJE GTIA LIQUIDA',
			'TRATAMIENTO CREDITICIO',
			'DESCRIPCION TRATAMIENTO',
			'TIPO CREDITO',
			'CLAVE FONAGA',
			'TIPO PORTAFOLIO',
			'MONTO BOLSA FONAGA',
			'NO. CREDITO BANCO',
			'SALDO INSOLUTO IF-ACREDITADO',
            'ESTATUS',
			'METODOLOGIA DE CALIFICACION',
			'DIAS MAXIMO INCUMPLIMIENTO',
			'NC VALOR AJUSTADO GTIAS',
			'A1 VALOR AJUSTADO GTIAS',
			'A2 VALOR AJUSTADO GTIAS',
			'B1 VALOR AJUSTADO GTIAS',
			'B2 VALOR AJUSTADO GTIAS',
			'B3 VALOR AJUSTADO GTIAS',
			'C1 VALOR AJUSTADO GTIAS',
			'C2 VALOR AJUSTADO GTIAS',
			'D VALOR AJUSTADO GTIAS',
			'E VALOR AJUSTADO GTIAS',
			'CALIF INICIAL PORC EXPUESTA (DEUDOR)',
			'LIMITE DE ESTIMACIONES',
			'PAGO SOSTENIDO',
			'DIAS CUMPLIMIENTO POSTERIOR RESTRUCTURA',
			'DIAS INCUMPLIMIENTO PREVIO RESTRUCTURA',
			'DIAS INCUMPLIMIENTO DESPUES RESTRUCTURA',
			'DIAS AMORTIZACION ORIGINAL',
			'PI',
			'SP',
			'EI',
			'% RESERVAS POR PERDIDA  ESPERADA',
			'NIVEL DE RIESGO POR PERDIDA ESPERADA',
			'SALDO INICIAL CUBIERTO FONAGA',
			'RESERVAS FONAGA',
			'PROPORCION C/ CREDITO EN EL PORTAFOLIO',
			'MONTO GARANTIA POR CREDITO',
			'SALDO FINAL CUBIERTO FONAGA',
			'SALDO EXPUESTO',
			'SALDO GARANTIA FEGA',
			'SALDO EXPUESTO FINAL',
			'RESERVAS GARANTIA LIQUIDA',
			'RESERVAS "B" FEGA',
			'RESERVAS "B" OTRAS GTIAS',
			'RESERVAS SALDO EXPUESTO FINAL',
			'RESERVAS TOTALES')
		,Aud_EmpresaID,
		Aud_Usuario,				Aud_FechaActual,				Aud_DireccionIP,		Aud_ProgramaID,					Aud_Sucursal,
		Aud_NumTransaccion;

	SET FechaSist := (SELECT FechaSistema FROM PARAMETROSSIS);

    SET Var_FechaCorte :=  LAST_DAY(Par_Fecha);

	DROP TABLE IF EXISTS TMPCALCARTERAFIRA2;
	CREATE TABLE TMPCALCARTERAFIRA2
		SELECT
			Var_MaxTransaccion AS TransaccionID,
			CAL.CreditoID,
            0 AS CreditoSAFI,
            2 AS Flag,
            'N' AS TCred, -- Tipo de Credito N-No existe en SAFI | I-Individual  | G-Grupal
			MAX(IFNULL(CONCAT('"',CAL.NombreAcreditado ,'"'),'')) AS NombreAcreditado,
			MAX(IFNULL(CAL.FechaOperacion, '')) AS FechaOperacion,
			MAX(IFNULL(CONCAT('"',CAL.TipoPersona ,'"'),'')) AS TipoPersona,
			MAX(IFNULL(CONCAT('"',CAL.RFC,'"'),'')) AS RFC,
			MAX(IFNULL(CONCAT('"',CAL.CURP,'"'),'')) AS CURP,
			MAX(IFNULL(CONCAT('"',CAL.MonedaOrigen ,'"'),''))	AS MonedaOrigen,
			MAX(IFNULL(CONCAT('"',CAL.SaldoInsolutoFiraIf ,'"'),Entero_Cero))	AS SaldoInsoluto,
			MAX(IFNULL(CAL.GtiaFEGASinFondeo,Entero_Cero)) 	AS GtiaFEGASinFondeo,
			MAX(IFNULL(CAL.PorcGtiaEfectivaFEGA,Entero_Cero)) AS GarantiaEfectivaFEGA,
			MAX(IFNULL(CAL.PorcGtiaNominalFEGA,'')) AS GarantiaNominalFEGA,
			MAX(IFNULL(CAL.CredEstructConFira,'')) AS CredEstructuradoFIRA,
			MAX(IFNULL(CAL.CadenaProductiva,'')) AS CadenaProd,
			MAX(IFNULL(CAL.EntidadFederativa,'')) AS EntidadFed,
			MAX(IFNULL(CAL.PorcGtiaLiquida,'')) AS PorcGarantiaLiq,
			MAX(IFNULL(CAL.TratamientoCredcio,'')) AS TratamientoCred,
			MAX(IFNULL(CAL.DescTratamiento,'')) AS DescTratamiento,
			MAX(IFNULL(CAL.TipoCred,'')) AS TipoCredito,
			MAX(IFNULL(CAL.ClaveFonaga,'')) AS ClaveFonaga,
			MAX(IFNULL(CAL.TipoPortafolio,'')) AS TipoPortafolio,
			MAX(IFNULL(CAL.MontoBolsaFonaga,'')) AS MontoBolsaFonaga,
			0	AS NoCreditoBanco,
			MAX(IFNULL(RES.SaldoInsoluto,Entero_Cero)) AS SaldoInsolutoIfAcre,
            'VIGENTE' AS Estatus,
			"PE"    AS MetodologiaCal,
            0 AS DiasMaxInc,
            0 AS ValorAjustado,
			0 AS A1,
			0 AS A2,
			0 AS B1,
			0 AS B2,
			0 AS B3,
			0 AS C1,
			0 AS C2,
			0 AS DG,
			0 AS EG,
            0 AS CalifInicial,
			0 AS LimiteEst,
			'NO'    AS PagoSoste,
            0 AS DiasIncDesRestr,
			0 AS DiasIncPrevREstruct,
            0 AS DiasRestruct,
            0 AS DiasAmortOriginal,
			MAX(IFNULL(RES.PiAcred, '')) 				AS PiAcred ,
            MAX(IFNULL(RES.SeveridadFinal, ''))			AS SP ,
			MAX(IFNULL(RES.SaldoInsoluto,Entero_Cero))	AS EI ,
            MAX(IFNULL(RES.PorReservaTotal, ''))		AS PorReservaTotal,
            MAX(IFNULL(REPLACE(RES.GradoRiesgoCred,'-',''), ''))		AS GradoRiesgoCred,
			 ''		AS SaldInicCubFonaga,
			 ''		AS ReservFonaga,
			 ''		AS ProporCredPortafolio,
			 '' 	AS MontoGtiaCred ,
			 '' 	AS SaldFinCubFonaga,
			 ''		AS SaldoExpuesto,
			 '' 	AS SaldoGtiaFEGA,
			 '' 	AS SaldoExpuestoFinal,
			 '' 	AS ReservGtiaLiq,
			 '' 	AS ReservBFEGA,
			 '' 	AS ReservBOtrasGtias,
			 ''		AS ReservSalExpFinal,
			 '' 	AS ReservaTotal
		FROM
			TMPCALCARTERAFIRA AS CAL LEFT JOIN
			TMPARCHRESERVFIRA AS RES ON CAL.CreditoID = RES.IdCreditoFira AND
			RES.TransaccionID = Var_MaxTransaccion
			WHERE CAL.TransaccionID = Var_MaxTransaccion
			GROUP BY CAL.CreditoID;

    CREATE INDEX idx_TMPCALCARTERAFIRA2_1 ON TMPCALCARTERAFIRA2(CreditoID);
	CREATE INDEX idx_TMPCALCARTERAFIRA2_2 ON TMPCALCARTERAFIRA2(CreditoSAFI);

	-- =============== PROCESO PARA ASIGNAR EL MATCH CON EL CREDITO ===========
	-- ================ ID FIRA EN  CREDITOS INDIVIDUALES  =====================

    /* Se realiza el proceso para tomar el ID del Credito que corresponde al CreditoIDFIRA */
    DROP TABLE IF EXISTS TMPCREDSAFIRA;
    CREATE TABLE TMPCREDSAFIRA(
        CreditoID   BIGINT(12),
        CreditoFira BIGINT(12)
    );

	CREATE INDEX idx_TMPCREDSAFIRA_1 ON TMPCREDSAFIRA(CreditoID);
	CREATE INDEX idx_TMPCREDSAFIRA_2 ON TMPCREDSAFIRA(CreditoFira);

	/* Se insertan los Creditos que la fecha de inicio correspondan
	 	a la Fecha de Operación del Archivo de Calificación
	 */
    INSERT INTO TMPCREDSAFIRA
    SELECT DISTINCT CRED.CreditoID, CAL.CreditoID
    FROM    TMPCALCARTERAFIRA2 AS CAL LEFT JOIN
			CREDITOS AS CRED ON CAL.CreditoID = CRED.CreditoIDFIRA
	WHERE CAL.CreditoID != Entero_Cero AND CAL.FechaOperacion  = CRED.FechaInicio
			AND CRED.GrupoID = Entero_Cero AND CRED.Estatus NOT IN ('K','C','P');

    UPDATE TMPCALCARTERAFIRA2 AS TMP LEFT JOIN TMPCREDSAFIRA AS CRE
        ON TMP.CreditoID = CRE.CreditoFira SET
       TMP.CreditoSAFI = CASE WHEN IFNULL(CRE.CreditoID,Entero_Cero) <> Entero_Cero THEN
	   						IFNULL(CRE.CreditoID,Entero_Cero) ELSE TMP.CreditoSAFI END,
       TMP.Flag = CASE WHEN IFNULL(CRE.CreditoID,Entero_Cero) <> Entero_Cero THEN 1 ELSE TMP.Flag END,
       TMP.TCred =  CASE WHEN IFNULL(CRE.CreditoID,Entero_Cero) <> Entero_Cero THEN 'I' ELSE 'N' END;

	/* Se realiza el Proceso de aquellos Creditos que no coiciden con su Fecha de Inicio
        con respecto a la Fecha de Operacion del Archivo de Calificación*/

    DROP TABLE IF EXISTS TMPCREDFALTFIRA;
    CREATE TABLE TMPCREDFALTFIRA(
        CreditoID   BIGINT(12),
        CreditoFira BIGINT(12)
    );

	CREATE INDEX idx_TMPCREDFALTFIRA_1 ON TMPCREDFALTFIRA(CreditoID);
	CREATE INDEX idx_TMPCREDFALTFIRA_2 ON TMPCREDFALTFIRA(CreditoFira);

	/* Se inserta los Creditos restantes que no se han agregado
	 * en la tabla TMPCREDSAFIRA pero hacen match con el CreditoIDFIRA */
    INSERT INTO TMPCREDFALTFIRA
    SELECT DISTINCT CRED.CreditoID, CAL.CreditoID
    FROM    TMPCALCARTERAFIRA2 AS CAL INNER JOIN
			CREDITOS AS CRED ON CAL.CreditoID = CRED.CreditoIDFIRA
	WHERE CAL.CreditoID != Entero_Cero AND CRED.GrupoID = Entero_Cero
         AND CRED.CreditoIDFIRA NOT IN (SELECT CreditoFira FROM TMPCREDSAFIRA)
	     AND CRED.Estatus NOT IN ('K','C','P');


    UPDATE TMPCALCARTERAFIRA2 AS TMP INNER JOIN TMPCREDFALTFIRA AS CRE
        ON TMP.CreditoID = CRE.CreditoFira SET
       TMP.CreditoSAFI = IFNULL(CRE.CreditoID,Entero_Cero),
       TMP.Flag = CASE WHEN IFNULL(CRE.CreditoID,Entero_Cero) <> Entero_Cero THEN 1 ELSE TMP.Flag END,
      TMP.TCred =  CASE WHEN IFNULL(CRE.CreditoID,Entero_Cero) <> Entero_Cero THEN 'I' ELSE 'N' END;

     /* Se insertan los Creditos restantos que no cumplen las condiciones
       de los dos procesos anteriores ya que se encuentran con Estatus Pagado*/
	DROP TABLE IF EXISTS TMPCREDPAGADOSFALT;
    CREATE TABLE TMPCREDPAGADOSFALT(
        CreditoID   BIGINT(12),
        CreditoFira BIGINT(12)
    );

	CREATE INDEX idx_TMPCREDPAGADOSFALT_1 ON TMPCREDPAGADOSFALT(CreditoID);
	CREATE INDEX idx_TMPCREDPAGADOSFALT_2 ON TMPCREDPAGADOSFALT(CreditoFira);

	INSERT INTO TMPCREDPAGADOSFALT
    SELECT DISTINCT CRED.CreditoID, CAL.CreditoID
    FROM    TMPCALCARTERAFIRA2 AS CAL INNER JOIN
			CREDITOS AS CRED ON CAL.CreditoID = CRED.CreditoIDFIRA
	WHERE CAL.CreditoID != Entero_Cero AND CRED.GrupoID = Entero_Cero
         AND Flag = 2;

   UPDATE TMPCALCARTERAFIRA2 AS TMP INNER JOIN TMPCREDPAGADOSFALT AS CRE
      ON TMP.CreditoID = CRE.CreditoFira SET
	      TMP.CreditoSAFI = IFNULL(CRE.CreditoID,Entero_Cero),
	      TMP.Flag = CASE WHEN IFNULL(CRE.CreditoID,Entero_Cero) <> Entero_Cero THEN 1 ELSE TMP.Flag END,
	      TMP.TCred =  CASE WHEN IFNULL(CRE.CreditoID,Entero_Cero) <> Entero_Cero THEN 'I' ELSE 'N' END;

	-- =============== PROCESO PARA ASIGNAR EL MATCH CON EL CREDITO ===========
	-- ================ ID FIRA EN  CREDITOS GRUPALES  =====================

	DROP TABLE IF EXISTS TMPCREDGRUPAL;
    CREATE TABLE TMPCREDGRUPAL(
    	CreditoIDFIRA			BIGINT (12),
        CreditoID   			BIGINT(12)
       );

	CREATE INDEX idx_TMPCREDGRUPAL_1 ON TMPCREDGRUPAL(CreditoIDFIRA);

    INSERT INTO TMPCREDGRUPAL
    SELECT TMP.CreditoID, MAX(CRED.CreditoID)
    FROM TMPCALCARTERAFIRA2 AS TMP
    	LEFT JOIN CREDITOS AS CRED ON TMP.CreditoID = CRED.CreditoIDFIRA
    WHERE TMP.TCred != 'I' AND CRED.CreditoID  IS NOT NULL AND CRED.GrupoID > Entero_Cero
   GROUP BY TMP.CreditoID;

   	UPDATE TMPCALCARTERAFIRA2 AS TMP INNER JOIN TMPCREDGRUPAL AS CRE
      ON TMP.CreditoID = CRE.CreditoIDFIRA SET
	      TMP.CreditoSAFI = IFNULL(CRE.CreditoID,Entero_Cero),
	      TMP.Flag = CASE WHEN IFNULL(CRE.CreditoID,Entero_Cero) <> Entero_Cero THEN 1 ELSE TMP.Flag END,
	      TMP.TCred =  CASE WHEN IFNULL(CRE.CreditoID,Entero_Cero) <> Entero_Cero THEN 'G' ELSE 'N' END;

    /* TABLA PARA OBTENER LOS REGISTROS DE ARCHIVO DE RESERVA QUE SE CONSIDERAN COMO GRUPALES */
    DROP TABLE IF EXISTS TMPCREDGRUPOFIRA;
    CREATE TABLE TMPCREDGRUPOFIRA(
    	CreditoIDFIRA			BIGINT (12)
       );

    CREATE INDEX idx_TMPCREDGRUPOFIRA_1 ON TMPCREDGRUPOFIRA(CreditoIDFIRA);

    INSERT INTO TMPCREDGRUPOFIRA
    SELECT IdCreditoFira FROM TMPARCHRESERVFIRA
	GROUP BY IdCreditoFira
	HAVING COUNT(IdCreditoFira)> 1;

    /* PROCESO PARA OBTENER LOS VALORES DEL ARCHIVO DE RESERVA DE AQUELLOS CREDITOS GRUPALES */
   	DROP TABLE IF EXISTS TMPVALORESGRUPO;
    CREATE TABLE TMPVALORESGRUPO(
    	CreditoIDFIRA			BIGINT (12),
        PiAcred					DOUBLE,
        SeveridadFinal			DOUBLE,
        ReservaTotal			DOUBLE,
        PorcReservaTot			DOUBLE,
        SaldoInsoluto 			DOUBLE
       );

	CREATE INDEX idx_TMPVALORESGRUPO_1 ON TMPVALORESGRUPO(CreditoIDFIRA);

    -- Se inserta los Registros que el Credito FIRA  esta ligado con un Credito Global (Grupal)
    INSERT INTO TMPVALORESGRUPO
    SELECT RES.IdCreditoFira, RES.PiAcred, RES.SeveridadFinal, RES.ReservaTotal, RES.PorReservaTotal, RES.SaldoInsoluto
    FROM TMPARCHRESERVFIRA  AS RES
    	LEFT JOIN TMPCALCARTERAFIRA2 AS TMP ON RES.IdCreditoFira = TMP.CreditoID
    WHERE TMP.TCred = 'G';

	/* *A peticion de Consol se realiza la insercion del ID 1896249, esto se debe a que no existe la forma de ligar con SAFI
    * pero en el Archivo se debe de reportar como un ID GRUPAL con su respectivos calculos */
   INSERT INTO TMPVALORESGRUPO
   SELECT RES.IdCreditoFira, RES.PiAcred, RES.SeveridadFinal, RES.ReservaTotal, RES.PorReservaTotal, RES.SaldoInsoluto
   	FROM TMPARCHRESERVFIRA  AS RES
    WHERE RES.IdCreditoFira = '1896249';

    -- Se insertan aquellos registros que no pertenecen a un Credito Grupal, sin embargo el Archivo de Reserva lo considera como Grupal
    INSERT INTO TMPVALORESGRUPO
    SELECT RES.IdCreditoFira, RES.PiAcred, RES.SeveridadFinal, RES.ReservaTotal, RES.PorReservaTotal, RES.SaldoInsoluto
    FROM TMPARCHRESERVFIRA  AS RES
    	INNER JOIN TMPCREDGRUPOFIRA AS TMP ON RES.IdCreditoFira = TMP.CreditoIDFIRA
        WHERE TMP.CreditoIDFIRA NOT IN (SELECT CreditoIDFIRA FROM TMPVALORESGRUPO);

 	-- Se realiza el Proceso de Calculo para los Creditos Grupales
 	DROP TABLE IF EXISTS TMPCALCULOGRUPAL;
    CREATE TABLE TMPCALCULOGRUPAL(
    	CreditoIDFIRA			BIGINT (12),
       	PiAcred					DOUBLE,
        Severidad				DOUBLE,
        ReservaTotal			DOUBLE,
        PorcReservaTot			DOUBLE,
        SaldoInsoluto			DOUBLE
       );

	CREATE INDEX idx_TMPCALCULOGRUPAL_1 ON TMPCALCULOGRUPAL(CreditoIDFIRA);

    INSERT INTO TMPCALCULOGRUPAL
    SELECT CreditoIDFIRA, AVG(PiAcred),Entero_Cero, SUM(ReservaTotal),Entero_Cero, SUM(SaldoInsoluto)
    	FROM TMPVALORESGRUPO
    	GROUP BY  CreditoIDFIRA;

   UPDATE TMPCALCULOGRUPAL SET
   		Severidad = (ReservaTotal)/((PiAcred/100)*(SaldoInsoluto/100));

   UPDATE TMPCALCULOGRUPAL SET
   		PorcReservaTot = (PiAcred/100)*(Severidad/100)*100;

  UPDATE TMPCALCARTERAFIRA2 AS TMP
  		INNER JOIN TMPCALCULOGRUPAL AS GRU ON TMP.CreditoID = GRU.CreditoIDFIRA
  		SET
  			TMP.PiAcred = GRU.PiAcred,
  			TMP.PorReservaTotal = ROUND(GRU.PorcReservaTot,10),
  			TMP.EI = GRU.SaldoInsoluto,
  			TMP.SaldoInsolutoIfAcre = GRU.SaldoInsoluto,
  			TMP.SP = ROUND(GRU.Severidad,4);

   	-- =============== PROCESO PARA LOS CMAPOS DE REESTRUCTURA ===========
    DROP TABLE IF EXISTS TMPCREDRESTRUCTURA;
    CREATE TABLE TMPCREDRESTRUCTURA(
        CreditoID   			BIGINT(12),
       	ValorAjustado			DECIMAL (14,2),
        PagoSoste				CHAR(2),
        DiasCumPostRestr			INT(12),
        DiasIncPrevREstruct		INT(12),
        DiasIncDespRestruct			INT(12),
        DiasAmortOriginal			INT(12)
       );

	CREATE INDEX idx_TMPCREDRESTRUCTURA_1 ON TMPCREDRESTRUCTURA(CreditoID);

    INSERT INTO TMPCREDRESTRUCTURA
    SELECT
    	CRED.CreditoID,
    	IFNULL(CRED.AporteCliente,0) AS ValorAjustado,
		IF(REST.Regularizado = 'S','SI','NO') AS PagoSoste,
		-- Dias de Cumplimiento Posterior a la Reestructura
		IF(REST.CreditoDestinoID IS NULL,Entero_Cero,IFNULL(FNDIASCARTERAFIRACAL(Con_DiasCumpRees,REST.CreditoDestinoID,Fecha_Vacia,Var_FechaCorte),Entero_Cero)) AS DiasCumPostRestr,
        -- Dias de Incumplimiento Previo a la Reestructura
		 IF(REST.CreditoDestinoID IS NULL,Entero_Cero,IFNULL(FNDIASCARTERAFIRACAL(Con_DiasIncRees,REST.CreditoDestinoID,Fecha_Vacia,Var_FechaCorte),Entero_Cero)) AS DiasIncPrevREstruct,
		-- Dias de Incumplimiento Despues de la Reestructura
		IF(REST.CreditoDestinoID IS NULL,Entero_Cero,IFNULL(FNDIASCARTERAFIRACAL(Con_DiasMax,REST.CreditoDestinoID,Fecha_Vacia,Var_FechaCorte),Entero_Cero)) AS DiasIncDespRestruct,
		-- Dias de la fecuencia del credito la Amorizacion Original
		IF(REST.CreditoDestinoID IS NULL,Entero_Cero,IFNULL(FNDIASCARTERAFIRACAL(Con_PeriodoRees,REST.CreditoOrigenID,Fecha_Vacia,Var_FechaCorte),Entero_Cero)) AS DiasAmortOriginal
	FROM TMPCALCARTERAFIRA2 AS TMP
		LEFT JOIN CREDITOS CRED ON TMP.CreditoSAFI = CRED.CreditoID
		LEFT JOIN REESTRUCCREDITO AS REST ON CRED.CreditoID = REST.CreditoDestinoID
		AND REST.FechaRegistro <= Var_FechaCorte;


	UPDATE TMPCALCARTERAFIRA2 AS TMP INNER JOIN TMPCREDRESTRUCTURA AS CRE
        ON TMP.CreditoSAFI = CRE.CreditoID SET
       TMP.ValorAjustado = IFNULL(CRE.ValorAjustado,Entero_Cero),
	   TMP.PagoSoste = IFNULL(CRE.PagoSoste,'NO'),
	   TMP.DiasIncDesRestr = IFNULL(CRE.DiasCumPostRestr,Entero_Cero),
	   TMP.DiasIncPrevREstruct = IFNULL(CRE.DiasIncPrevREstruct,Entero_Cero),
	   TMP.DiasRestruct = IFNULL(CRE.DiasIncDespRestruct,Entero_Cero),
	   TMP.DiasAmortOriginal = IFNULL(CRE.DiasAmortOriginal,Entero_Cero);

	-- Se actualizan los campos de Estatus y DiasMaxInc estos valores deben de coincidir con el reporte de Saldos de Cartera
	UPDATE TMPCALCARTERAFIRA2 TMPGRAL
            LEFT JOIN CREDITOS CRE ON TMPGRAL.CreditoSAFI = CRE.CreditoID
            LEFT JOIN SALDOSCREDITOS SAL ON CRE.CreditoID = SAL.CreditoID SET
		TMPGRAL.Estatus = CASE WHEN SAL.EstatusCredito = 'V' THEN 'VIGENTE'
			                    WHEN SAL.EstatusCredito = 'B'  THEN 'VENCIDA'
								ELSE 'VIGENTE' END,
		TMPGRAL.DiasMaxInc = CASE WHEN (SAL.DiasAtraso > Entero_Cero AND SAL.DiasAtraso < 365)  THEN SAL.DiasAtraso
								WHEN SAL.DiasAtraso >= 365 THEN 365 ELSE Entero_Cero END
	WHERE SAL.FechaCorte = Var_FechaCorte;

	-- Se actualiza el campo No Credito Banco con el Credito ID de SAFI
	UPDATE  TMPCALCARTERAFIRA2 SET
		NoCreditoBanco = CreditoSAFI;

	-- Si existen registros a nombre de Consol Negocios que corresponde a creditos grupales, debera reportarse el ID del grupo de credito.
	UPDATE TMPCALCARTERAFIRA2 TMP
		INNER JOIN CREDITOS CRE  ON TMP.CreditoSAFI = CRE.CreditoID
	SET
		TMP.TransaccionID = CRE.GrupoID
	WHERE  TMP.NombreAcreditado  LIKE '%CONSOL%'
		AND CRE.GrupoID > Entero_Cero;


	INSERT INTO REPMONITOREOFIRA(
		TipoReporteID,				FechaGeneracion,				ConsecutivoID,
		CSVReporte,						EmpresaID,
		Usuario,					FechaActual,					DireccionIP,			ProgramaID,						Sucursal,
		NumTransaccion)
		SELECT
		DISTINCT
		TipoReporte_CartVenc,		Par_Fecha,						@cont:=@cont+1,
		CONCAT_WS(",",
			IFNULL(CAL.CreditoID, ''),			-- CREDITO_ID
			IFNULL(NombreAcreditado, ''),		-- NOMBRE_ACREDITADO
			IFNULL(FechaOperacion, ''),			-- FECHA_OPERACION
			IFNULL(TipoPersona, ''),			-- TIPO_PERSONA
			IFNULL(RFC, ''),					-- RFC
			IFNULL(CURP, ''),					-- CURP
			IFNULL(MonedaOrigen, ''),			-- MONEDA_DE_ORIGEN
			IFNULL(SaldoInsoluto, ''),			-- SALDO_INSOLUTO_FIRA_IF
			IFNULL(GtiaFEGASinFondeo, ''),		-- GARANTIA_FEGA_SIN_FONDEO
			IFNULL(GarantiaEfectivaFEGA, ''),	-- GARANTIA_EFECTIVA_FEGA
			IFNULL(GarantiaNominalFEGA, ''),	-- GARANTIA_NOMINAL_FEGA
			IFNULL(CredEstructuradoFIRA, ''),	-- CREDITO_ESTRUCTURADO_CON_FIRA
			IFNULL(CadenaProd, ''),				-- CADENA_PRODUCTIVA
			IFNULL(EntidadFed, ''),				-- ENTIDAD_FEDERATIVA
			IFNULL(PorcGarantiaLiq, ''),		-- PORCENTAJE_GTIA_LIQUIDA
			IFNULL(TratamientoCred, ''),		-- TRATAMIENTO_CREDITICIO
			IFNULL(DescTratamiento, ''),		-- DESCRIPCION_TRATAMIENTO
			IFNULL(CAL.TipoCredito, ''),		-- TIPO_CREDITO
			IFNULL(ClaveFonaga, ''),			-- CLAVE_FONAGA
			IFNULL(TipoPortafolio, ''),			-- TIPO_PORTAFOLIO
			IFNULL(MontoBolsaFonaga, ''),		-- MONTO_BOLSA_FONAGA
			IFNULL(NoCreditoBanco, ''),			-- NO_CREDITO_BANCO
			IFNULL(SaldoInsolutoIfAcre, ''),	-- SALDO_INSOLUTO_IFACREDITADO
            IFNULL(CAL.Estatus, ''),			-- ESTATUS DEL CREDITO
			IFNULL(MetodologiaCal, ''),			-- METODOLOGIA_DE_CALIFICACION
			IFNULL(DiasMaxInc, '0'),			-- DIAS_MAXIMO_INCUMPLIMIENTO
			IFNULL(GAR.MontoGarantiaAjus,0)+IFNULL(CAL.ValorAjustado,0),	-- NC_VALOR_AJUSTADO_GTIAS -> Garantia No Financiera + Garantia Financiera
			IFNULL(A1, ''),						-- A1_VALOR_AJUSTADO_GTÍAS
			IFNULL(A2, ''),						-- A2_VALOR_AJUSTADO_GTIAS
			IFNULL(B1, ''),						-- B1_VALOR_AJUSTADO_GTIAS
			IFNULL(B2, ''),						-- B2_VALOR_AJUSTADO_GTIAS
			IFNULL(B3, ''),						-- B3_VALOR_AJUSTADO_GTIAS
			IFNULL(C1, ''),						-- C1_VALOR_AJUSTADO_GTIAS
			IFNULL(C2, ''),						-- C2_VALOR_AJUSTADO_GTIAS
			IFNULL(DG, ''),						-- D_VALOR_AJUSTADO_GTIAS
			IFNULL(EG, ''),						-- E_VALOR_AJUSTADO_GTIAS
			IFNULL(CalifInicial, ''),			-- CALIF_INICIAL_PORC_EXPUESTA_DEUDOR
			IFNULL(LimiteEst, ''),				-- LIMITE_DE_ESTIMACIONES
			IFNULL(PagoSoste,''),				-- PAGO_SOSTENIDO
			IFNULL(DiasIncDesRestr, 0),			-- DIAS_INCUMPLIMIENTO_POSTERIOR_RESTRUCTURA
			IFNULL(DiasIncPrevREstruct, 0),		-- DIAS_INCUMPLIMIENTO_PREVIO_RESTRUCTURA
			IFNULL(DiasRestruct, 0),			-- DIAS_INCUMPLIMIENTO_DESPUES_RESTRUCTURA
			IFNULL(DiasAmortOriginal, ''),		-- DIAS_AMORTIZACION_ORIGINAL
			IFNULL(PiAcred, ''),				-- PI
			IFNULL(SP, ''),						-- SP
			IFNULL(EI, ''),						-- EI
			IFNULL(PorReservaTotal, ''),		-- RESERVAS_POR_PERDIDA__ESPERADA
			IFNULL(GradoRiesgoCred, ''),		-- NIVEL_DE_RIESGO_POR_PERDIDA_ESPERADA
			IFNULL(SaldInicCubFonaga, ''),		-- SALDO_INICIAL_CUBIERTO_FONAGA
			IFNULL(ReservFonaga, ''),			-- RESERVAS_FONAGA
			IFNULL(ProporCredPortafolio, ''),	-- PROPORCION_C_CREDITO_EN_EL_PORTAFOLIO
			IFNULL(MontoGtiaCred, ''),			-- MONTO_GARANTIA_POR_CREDITO
			IFNULL(SaldFinCubFonaga, ''),		-- SALDO_FINAL_CUBIERTO_FONAGA
			IFNULL(SaldoExpuesto, ''),			-- SALDO_EXPUESTO
			IFNULL(SaldoGtiaFEGA, ''),			-- SALDO_GARANTIA_FEGA
			IFNULL(SaldoExpuestoFinal, ''),		-- SALDO_EXPUESTO_FINAL
			IFNULL(ReservGtiaLiq, ''),			-- RESERVAS_GARANTIA_LIQUIDA
			IFNULL(ReservBFEGA, ''),			-- RESERVAS_B_FEGA
			IFNULL(ReservBOtrasGtias, ''),		-- RESERVAS_B_OTRAS_GTIAS
			IFNULL(ReservSalExpFinal, ''),		-- RESERVAS_SALDO_EXPUESO_FINAL
			IFNULL(ReservaTotal, '')			-- RESERVAS_TOTAL
			) ,
		Aud_EmpresaID,
		Aud_Usuario,				Aud_FechaActual,				Aud_DireccionIP,		Aud_ProgramaID,					Aud_Sucursal,
		Aud_NumTransaccion
		FROM
			TMPCALCARTERAFIRA2 AS CAL LEFT JOIN
			CREDITOS AS CRED ON CAL.CreditoSAFI = CRED.CreditoID LEFT JOIN
			TMPMONITORCARTGARANTIAS AS GAR ON CRED.CreditoID = GAR.CreditoID
		WHERE IFNULL(CAL.CreditoID,0)!=0;

END TerminaStore$$