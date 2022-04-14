-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MONITORCARTERANOFIRAREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `MONITORCARTERANOFIRAREP`;
DELIMITER $$


CREATE PROCEDURE `MONITORCARTERANOFIRAREP`(
	/* Reporte de Cartera NO FIRA*/
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
	DECLARE Var_MaxTransaccion		BIGINT(20);
	DECLARE Var_MaxTransaccionFIRA	BIGINT(20);
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
	DECLARE Con_DiasMax				INT(1);
    DECLARE Con_DiasIncRees			INT(11);
    DECLARE Con_PeriodoRees			INT(11);
    DECLARE Con_DiasCumpRees		INT(11);
    DECLARE Var_FechaCorte          DATE;

	# Asignacion de Constantes
	SET Entero_Cero					:= 0;
    SET Fecha_Vacia					:= '1900-01-01';
	SET TipoReporte_CartVenc		:= 6;
	SET Mes12 						:= 12;
	SET Desc_CastigosCartVenc		:= 'CASTIGOS DE CARTERA VENCIDA';
	SET Desc_CastigosCartVent		:= 'VENTA DE CARTERA VENCIDA';
	SET Desc_ConceptoMes12			:= 'ACUMULADA ÚLTIMOS 12 MESES';
	SET Desc_ConceptoMesActual		:= 'MES ACTUAL';
	SET Var_FechaReporte			:= Par_Fecha;
	SET Var_Fecha12MesesAtras		:= DATE_SUB(Var_FechaReporte, INTERVAL 12 MONTH);
	SET Var_Contador1				:= 1;
    SET Con_DiasMax					:= 1;
    SET Con_DiasIncRees 			:= 2;
    SET Con_PeriodoRees				:= 3;
    SET Con_DiasCumpRees 			:= 4;
	SET Cadena_Vacia				:= '';

	DELETE FROM REPMONITOREOFIRA
			WHERE TipoReporteID = TipoReporte_CartVenc;

	SET lc_time_names := 'es_MX';

	SET Var_FechaCorte :=  LAST_DAY(Par_Fecha);
	SET Var_MaxTransaccion :=	(SELECT MAX(TransaccionID) FROM TMPARCHRESERVNOFIRA);

	-- Se eliminan los registros vacios
	DELETE FROM TMPARCHRESERVNOFIRA WHERE TransaccionID != Var_MaxTransaccion;
	DELETE FROM TMPARCHRESERVNOFIRA WHERE IdCreditoFira = '';
	DELETE FROM TMPARCHRESERVNOFIRA WHERE NumControl = 'NUM_CONTROL';

	DROP TABLE IF EXISTS TMPMONITORCARTGARANTIAS;
	CREATE TABLE TMPMONITORCARTGARANTIAS
	SELECT ASI.CreditoID, SUM(ROUND((GAR.ValorComercial*(CLA.PorcAjuste/100)),2)) AS MontoGarantiaAjus
    FROM ASIGNAGARANTIAS AS ASI
	INNER JOIN GARANTIAS AS GAR ON ASI.GarantiaID = GAR.GarantiaID
	INNER JOIN CLASIFGARANTIAS AS CLA ON GAR.ClasifGarantiaID = CLA.ClasifGarantiaID
		AND GAR.TipoGarantiaID = CLA.TipoGarantiaID
	INNER JOIN CREDITOS AS CRED ON ASI.CreditoID=CRED.CreditoID
	WHERE ASI.Estatus='U'
	GROUP BY ASI.CreditoID;
	/*Se inserta el contenido del reporte*/
	SET @cont := 0;
	INSERT INTO REPMONITOREOFIRA(
		TipoReporteID,				FechaGeneracion,				ConsecutivoID,
		CSVReporte,						EmpresaID,
		Usuario,					FechaActual,					DireccionIP,			ProgramaID,						Sucursal,
		NumTransaccion)
		SELECT
		TipoReporte_CartVenc,		Par_Fecha,						@cont:=@cont+1,
		CONCAT_WS(',',
			'NO. CREDITO BANCO',
			'NOMBRE ACREDITADO',
			'FECHA OPERACION',
			'TIPO PERSONA',
			'RFC',
			'CURP',
			'MONEDA DE ORIGEN',
			'CADENA PRODUCTIVA',
			'ENTIDAD FEDERATIVA',
			'PORCENTAJE GTIA LIQUIDA',
			'TRATAMIENTO CREDITICIO',
			'DESCRIPCION TRATAMIENTO CREDITICIO',
			'SALDO INSOLUTO IF-ACREDITADO',
            'ESTATUS',
            'TIPO CREDITO',
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
			'% RESERVAS POR PERDIDA ESPERADA',
			'NIVEL DE RIESGO POR PERDIDA ESPERADA',
			'SALDO EXPUESTO',
			'SALDO EXPUESTO FINAL',
			'RESERVAS GARANTIA LIQUIDA',
			'RESERVAS "B" OTRAS GTIAS',
			'RESERVAS SALDO EXPUESTO FINAL',
			'RESERVAS TOTALES'
		)
		,			Aud_EmpresaID,
		Aud_Usuario,				Aud_FechaActual,				Aud_DireccionIP,		Aud_ProgramaID,					Aud_Sucursal,
		Aud_NumTransaccion;

	-- Se crea una Tabla Temporal donde se almacena los Registrs del Archivo Cargado de Reservas  No FIRA
	DROP TABLE IF EXISTS MONITORCARTERANOFIRA;
	CREATE TABLE MONITORCARTERANOFIRA
	SELECT
		 IFNULL(CRED.CreditoID,Entero_Cero) AS CreditoID,
		 IFNULL(TMP.NomAcreditado,'') AS NomAcreditado,
		 IF(IFNULL(CRED.CreditoID,0) != 0,(IF(IFNULL(CRED.FechaMinistrado,'1900-01-01') != '1900-01-01',CRED.FechaMinistrado, CRED.FechaInicio)),'') AS FechaOperacion,
		 IF(CLI.TipoPersona = 'M','MORAL', 'FISICA') AS TipoPersona,
		 IFNULL(TMP.RfcAcreditado,'') AS RFC,
		 IFNULL(CLI.CURP,'') AS CURP,
		 'MN' AS Moneda,
		IFNULL(CAD.NomCadenaProdSCIAN,'OTRAS CADENAS PRODUC.') AS NombreCadena,
		IFNULL(EDO.Nombre,'') AS Entidad,
		 IFNULL(CRED.PorcGarLiq,'') AS PorcGarLiq,
		 'NO' AS TratamientoCred,
		 'SIN TRATAMIENTO' AS DescTratamiento,
		 IFNULL(TMP.Ei,0) AS SaldoIFAcreditado,
         'VIGENTE' AS Estatus,
		'TIPO DE CREDITO NO DEFINIDO' AS TipoCredito,
		'PE' AS MetodologiaCal,
		 0 AS DiasMaxInc,
		 IFNULL(CRED.AporteCliente,0) + IFNULL(GAR.MontoGarantiaAjus,0) AS NC,
		 0 AS A1,
		 0 AS A2,
		 0 AS B1,
		 0 AS B2,
		 0 AS B3,
		 0 AS C1,
		 0 AS C2,
		 0 AS D,
		 0 AS E,
		 0 AS CalifInicialExp,
		 0 AS LimiteEst,
		 'NO' AS PagoSostenido,
		 0 AS DiasIncPostRest,
		 0 AS DiasIncPrevRest,
		 0 AS DiasIncDespRest,
		 0 AS DiasAmortOri,
		 IFNULL(TMP.PiAcred,0) AS PIA,
		 IFNULL(TMP.SpFinal,0) AS SP,
		 IFNULL(TMP.Ei,0) AS EI,
		 IFNULL(TMP.PorcReservaTotal,0) AS PorcReservasPerd,
		 REPLACE(IFNULL(TMP.GradoRiesgoCredito,0),'-','') AS NivelRiesgoPerd,
		 '' AS SaldoExp,
		 '' AS SaldExpFinal,
		 '' AS ResGarantLiq,
		 '' AS ReservasOtrasGar,
		 '' AS ReservasSaldExp,
		 '' AS ReservasTotales,
		 TMP.IdCreditoIfnb AS CredReferencia
		FROM TMPARCHRESERVNOFIRA AS TMP LEFT JOIN
			CREDITOS AS CRED ON TMP.IdCreditoIfnb = CRED.CreditoID  LEFT JOIN
			CLIENTES AS CLI ON TMP.RfcAcreditado = CLI.RFCOficial LEFT JOIN
			DIRECCLIENTE AS DIR ON CLI.ClienteID = DIR.ClienteID AND DIR.Oficial='S' LEFT JOIN
			ESTADOSREPUB AS EDO ON DIR.EstadoID = EDO.EstadoID LEFT JOIN
			CATCADENAPRODUCTIVA AS CAD ON CRED.CadenaProductivaID=CAD.CveCadena LEFT JOIN
			TMPMONITORCARTGARANTIAS AS GAR ON CRED.CreditoID = GAR.CreditoID
		WHERE IFNULL(TMP.IdCreditoIfnb,Entero_Cero)!= Entero_Cero;

	/* A Peticion de CONSOL Los casos que se hayan enviado en los archivos de Reservas FIRA y no se incluyan en el precargado
		* de Calificación de cartera FIRA, deberán moverse al archivo de Calificación de Cartera NO FIRA,
		* con el único detalle de que en la primer columna NO. CREDITO BANCO, se deberá reportar con el ID de FIRA
		* que se envió en el archivo Reservas FIRA.  */

	SET Var_MaxTransaccionFIRA := (SELECT MAX(TransaccionID) FROM TMPARCHRESERVFIRA);
	DELETE FROM TMPARCHRESERVFIRA WHERE TransaccionID != Var_MaxTransaccionFIRA;

	SET Var_MaxTransaccionFIRA := (SELECT MAX(TransaccionID) FROM TMPCALCARTERAFIRA);
	DELETE FROM TMPCALCARTERAFIRA WHERE TransaccionID != Var_MaxTransaccionFIRA;

	DROP TABLE IF EXISTS AUXDATOSTRASPASOFIRA;
	CREATE TABLE AUXDATOSTRASPASOFIRA
    SELECT RES.IdCreditoFira , RES.IdAcreditadoFira, RES.NomAcreditado,
		Entero_Cero AS CreditoIDSAFI
	FROM TMPARCHRESERVFIRA RES
    WHERE RES.IdCreditoFira > Entero_Cero AND IdCreditoFira NOT IN (SELECT CreditoID FROM TMPCALCARTERAFIRA);

	UPDATE AUXDATOSTRASPASOFIRA TMP
	INNER JOIN CREDITOS CRE ON TMP.IdCreditoFira = CRE.CreditoIDFIRA
		SET TMP.CreditoIDSAFI = CRE.CreditoID;

	INSERT INTO MONITORCARTERANOFIRA (
		CreditoID, 		NomAcreditado, 		FechaOperacion, 		TipoPersona, 	RFC,
		CURP, 			Moneda, 			NombreCadena, 			Entidad, 		PorcGarLiq,
		TratamientoCred, DescTratamiento,	SaldoIFAcreditado,		Estatus,		TipoCredito,
		MetodologiaCal,	DiasMaxInc,			NC,		A1,		A2,
		B1,		B2,		B3,		C1,		C2,
		D,		E,		CalifInicialExp,	LimiteEst,				PagoSostenido,
		DiasIncPostRest, DiasIncPrevRest,	DiasIncDespRest,		DiasAmortOri,	PIA,
		SP,		EI,		PorcReservasPerd,	NivelRiesgoPerd,		SaldoExp,
		SaldExpFinal,	ResGarantLiq,		ReservasOtrasGar,		ReservasSaldExp,	ReservasTotales,
		CredReferencia)
	SELECT
		AUX.IdCreditoFira,		AUX.NomAcreditado,
		IF(IFNULL(CRE.FechaMinistrado,Fecha_Vacia) != Fecha_Vacia,CRE.FechaMinistrado, CRE.FechaInicio) AS FechaOperacion,
		IF(CLI.TipoPersona = 'M','MORAL', 'FISICA') AS TipoPersona,
		IFNULL(CLI.RFCOficial,Cadena_Vacia) AS RFC, 	 IFNULL(CLI.CURP,'') AS CURP,	 'MN' AS Moneda,
		IFNULL(CAD.NomCadenaProdSCIAN,'OTRAS CADENAS PRODUC.') AS NombreCadena,
		IFNULL(EDO.Nombre,'') AS Entidad,
		IFNULL(CRE.PorcGarLiq,'') AS PorcGarLiq,
		'NO' AS TratamientoCred,
		'SIN TRATAMIENTO' AS DescTratamiento,
		RES.SaldoInsoluto AS SaldoIFAcreditado,
		'VIGENTE' AS Estatus,
		'TIPO DE CREDITO NO DEFINIDO' AS TipoCredito,
		'PE' AS MetodologiaCal,
		0 AS DiasMaxInc,
		IFNULL(CRE.AporteCliente,0) + IFNULL(GAR.MontoGarantiaAjus,0) AS NC,
		0 AS A1,
		0 AS A2,		0 AS B1,	0 AS B2,
		0 AS B3,		0 AS C1,	0 AS C2,
		0 AS D,		0 AS E,
		0 AS CalifInicialExp,		0 AS LimiteEst,
		'NO' AS PagoSostenido,		0 AS DiasIncPostRest,
		0 AS DiasIncPrevRest,		0 AS DiasIncDespRest,
		0 AS DiasAmortOri,
		IFNULL(RES.PiAcred,0) AS PIA,
		IFNULL(RES.SeveridadFinal,0) AS SP,
		IFNULL(RES.SaldoInsoluto,0) AS EI,
		IFNULL(RES.PorReservaTotal, 0) AS PorcReservasPerd,
		REPLACE(IFNULL(RES.GradoRiesgoCred,0),'-','') AS NivelRiesgoPerd,
		'' AS SaldoExp,
		'' AS SaldExpFinal,
		'' AS ResGarantLiq,
		'' AS ReservasOtrasGar,
		'' AS ReservasSaldExp,
		'' AS ReservasTotales,
		AUX.CreditoIDSAFI AS CredReferencia
	FROM AUXDATOSTRASPASOFIRA AS AUX
		LEFT OUTER JOIN TMPARCHRESERVFIRA AS RES ON AUX.IdCreditoFira = RES.IdCreditoFira
		LEFT OUTER JOIN CREDITOS CRE ON AUX.CreditoIDSAFI = CRE.CreditoID
		LEFT OUTER JOIN CLIENTES AS CLI ON CRE.ClienteID = CLI.ClienteID
		LEFT OUTER JOIN DIRECCLIENTE AS DIR ON CLI.ClienteID = DIR.ClienteID AND DIR.Oficial='S'
		LEFT OUTER JOIN	ESTADOSREPUB AS EDO ON DIR.EstadoID = EDO.EstadoID
		LEFT OUTER JOIN	CATCADENAPRODUCTIVA AS CAD ON CRE.CadenaProductivaID=CAD.CveCadena
		LEFT OUTER JOIN	TMPMONITORCARTGARANTIAS AS GAR ON CRE.CreditoID = GAR.CreditoID
    WHERE AUX.CreditoIDSAFI > Entero_Cero;

	-- Se actualizan los datos de Acuerdo a la Fecha Corte
    UPDATE MONITORCARTERANOFIRA TMP LEFT OUTER JOIN SALDOSCREDITOS SAL  ON TMP.CreditoID = SAL.CreditoID SET
            TMP.Estatus = CASE WHEN SAL.EstatusCredito = 'V' THEN 'VIGENTE'
			                    WHEN SAL.EstatusCredito = 'B'  THEN 'VENCIDA'
                              ELSE 'VIGENTE' END,
            TMP.DiasMaxInc = CASE WHEN SAL.DiasAtraso < 365 THEN SAL.DiasAtraso
				                    WHEN SAL.DiasAtraso > 365 THEN 365 ELSE Entero_Cero END
    WHERE SAL.FechaCorte = Var_FechaCorte;

	-- Se actualiza el Tipo de Credito de acuerdo a su Clasificacion
	UPDATE MONITORCARTERANOFIRA TMP LEFT OUTER JOIN CREDITOS CRE ON TMP.CreditoID = CRE.CreditoID
					LEFT OUTER JOIN DESTINOSCREDITO DES ON CRE.DestinoCreID = DES.DestinoCreID
                    LEFT OUTER JOIN CLASIFICCREDITO CLA ON DES.SubClasifID = CLA.ClasificacionID SET
			TMP.TipoCredito = CASE WHEN CLA.ClasificacionID = 102 THEN 'PRENDARIO'
								WHEN CLA.ClasificacionID = 125 THEN 'AVIO'
                                WHEN CLA.ClasificacionID = 126 THEN 'REFACCIONARIO'
                                ELSE 'PRENDARIO' END ;

		  /* Se crea Tabla para los campos de CREDTOS Y REESTRUCTURA */
    DROP TABLE IF EXISTS TMPCREDRESTRUCTURA;
    CREATE TABLE TMPCREDRESTRUCTURA(
        CreditoID   			BIGINT(12),
       	TratamientoCred			CHAR(2),
		DescTratamiento			VARCHAR(20),
        PagoSoste				CHAR(2),
        DiasCumPostRestr		INT(12),
        DiasIncPrevREstruct		INT(12),
        DiasIncDespRestruct			INT(12),
        DiasAmortOriginal			INT(12)
       );

	CREATE INDEX idx_TMPCREDRESTRUCTURA_1 ON TMPCREDRESTRUCTURA(CreditoID);

    INSERT INTO TMPCREDRESTRUCTURA
    SELECT
    	CRED.CreditoID,
		IF(REST.NumPagoSoste > Entero_Cero,'SI','NO') AS TratamientoCred,
		IF(REST.Origen != '',REST.Origen,'') AS DescTratamiento,
		IF(REST.Regularizado = 'S','SI','NO') AS PagoSoste,
		-- Dias de Cumplimiento Posterior a la Reestructura
		IF(REST.CreditoDestinoID IS NULL,Entero_Cero,IFNULL(FNDIASCARTERAFIRACAL(Con_DiasCumpRees,REST.CreditoDestinoID,Fecha_Vacia,Var_FechaCorte),Entero_Cero)) AS DiasCumPostRestr,
		-- Dias de Incumplimiento Previo a la Reestructura
        IF(REST.CreditoDestinoID IS NULL,Entero_Cero,IFNULL(FNDIASCARTERAFIRACAL(Con_DiasIncRees,REST.CreditoDestinoID,Fecha_Vacia,Var_FechaCorte),Entero_Cero)) AS DiasIncPrevREstruct,
		-- Dias de Incumplimiento Despues de la Reestructura
		IF(REST.CreditoDestinoID IS NULL,Entero_Cero,IFNULL(FNDIASCARTERAFIRACAL(Con_DiasMax,REST.CreditoDestinoID,Fecha_Vacia,Var_FechaCorte),Entero_Cero)) AS DiasIncDespRestruct,
		-- Dias de la fecuencia del credito la Amorizacion Original
		IF(REST.CreditoDestinoID IS NULL,Entero_Cero,IFNULL(FNDIASCARTERAFIRACAL(Con_PeriodoRees,REST.CreditoOrigenID,Fecha_Vacia,Var_FechaCorte),Entero_Cero)) AS DiasAmortOriginal
	FROM MONITORCARTERANOFIRA AS TMP
		LEFT JOIN CREDITOS CRED ON TMP.CredReferencia = CRED.CreditoID
		LEFT JOIN REESTRUCCREDITO AS REST ON CRED.CreditoID = REST.CreditoDestinoID;


	UPDATE MONITORCARTERANOFIRA AS TMP INNER JOIN TMPCREDRESTRUCTURA AS CRE
        ON TMP.CredReferencia = CRE.CreditoID SET
		TMP.TratamientoCred = CRE.TratamientoCred,
		TMP.DescTratamiento = CASE WHEN CRE.DescTratamiento = 'R' THEN 'REESTRUCTURA'
			                    WHEN CRE.DescTratamiento = 'O'  THEN 'RENOVACION'
                              ELSE '' END,
	   TMP.PagoSostenido = IFNULL(CRE.PagoSoste,'NO'),
	   TMP.DiasIncPostRest = IFNULL(CRE.DiasCumPostRestr,0),
	   TMP.DiasIncPrevRest = IFNULL(CRE.DiasIncPrevREstruct,0),
	   TMP.DiasIncDespRest = IFNULL(CRE.DiasIncDespRestruct,0),
	   TMP.DiasAmortOri = IFNULL(CRE.DiasAmortOriginal,0);

	UPDATE MONITORCARTERANOFIRA AS TMP SET
		TMP.CreditoID = IF(TMP.FechaOperacion != '', TMP.CredReferencia, 0);

	INSERT INTO REPMONITOREOFIRA(
		TipoReporteID,				FechaGeneracion,				ConsecutivoID,
		CSVReporte,						EmpresaID,
		Usuario,					FechaActual,					DireccionIP,			ProgramaID,						Sucursal,
		NumTransaccion)
		SELECT
		TipoReporte_CartVenc,		Par_Fecha,						@cont:=@cont+1,
		CONCAT_WS(',',
			CreditoID,				-- NO. CREDITO BANCO
			NomAcreditado,			-- NOMBRE ACREDITADO
			FechaOperacion,			-- FECHA OPERACION
			TipoPersona,			-- TIPO PERSONA
			RFC,					-- RFC
			CURP,					-- CURP
			Moneda,					-- MONEDA DE ORIGEN
			NombreCadena,			-- CADENA PRODUCTIVA
			Entidad,				-- ENTIDAD FEDERATIVA
			PorcGarLiq,				-- PORCENTAJE GTIA LIQUIDA
			TratamientoCred,		-- TRATAMIENTO CREDITICIO
			DescTratamiento,		-- DESCRIPCION TRATAMIENTO CREDITICIO
			SaldoIFAcreditado,		-- SALDO INSOLUTO IF-ACREDITADO
            Estatus,				-- ESTATUS
            TipoCredito,			-- TIPO CREDITO
			MetodologiaCal,			-- METODOLOGIA DE CALIFICACION
			DiasMaxInc,				-- DIAS MAXIMO INCUMPLIMIENTO
			NC,						-- NC VALOR AJUSTADO GTIAS
			A1,						-- A1 VALOR AJUSTADO GTIAS
			A2,						-- A2 VALOR AJUSTADO GTIAS
			B1,						-- B1 VALOR AJUSTADO GTIAS
			B2,						-- B2 VALOR AJUSTADO GTIAS
			B3,						-- B3 VALOR AJUSTADO GTIAS
			C1,						-- C1 VALOR AJUSTADO GTIAS
			C2,						-- C2 VALOR AJUSTADO GTIAS
			D,						-- D VALOR AJUSTADO GTIAS
			E,						-- E VALOR AJUSTADO GTIAS
			CalifInicialExp,		-- CALIF INICIAL PORC EXPUESTA (DEUDOR)
			LimiteEst,				-- LIMITE DE ESTIMACIONES
			PagoSostenido,			-- PAGO SOSTENIDO
			DiasIncPostRest,		-- DIAS CUMPLIMIENTO POSTERIOR RESTRUCTURA
			DiasIncPrevRest,		-- DIAS INCUMPLIMIENTO PREVIO RESTRUCTURA
			DiasIncDespRest,		-- DIAS INCUMPLIMIENTO DESPUES RESTRUCTURA
			DiasAmortOri,			-- DIAS AMORTIZACION ORIGINAL
			PIA,					-- PI
			SP,						-- SP
			EI,						-- EI
			PorcReservasPerd,		-- % RESERVAS POR PERDIDA ESPERADA
			NivelRiesgoPerd,		-- NIVEL DE RIESGO POR PERDIDA ESPERADA
			SaldoExp,				-- SALDO EXPUESTO
			SaldExpFinal,			-- SALDO EXPUESTO FINAL
			ResGarantLiq,			-- RESERVAS GARANTIA LIQUIDA
			ReservasOtrasGar,		-- RESERVAS "B" OTRAS GTIAS
			ReservasSaldExp,		-- RESERVAS SALDO EXPUESTO FINAL
			ReservasTotales			-- RESERVAS TOTALES
			),
		Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,					Aud_Sucursal,
		Aud_NumTransaccion
		FROM MONITORCARTERANOFIRA AS TMP
		WHERE IFNULL(TMP.CredReferencia,0)!=0;

	--  TRUNCATE TMPARCHRESERVNOFIRA;

END TerminaStore$$