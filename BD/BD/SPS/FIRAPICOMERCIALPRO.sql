-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FIRAPICOMERCIALPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `FIRAPICOMERCIALPRO`;
DELIMITER $$

CREATE PROCEDURE `FIRAPICOMERCIALPRO`(
/*SP QUE GENERA EL REPORTE PI COMERCIAL*/
	Par_TipoReporte		TINYINT,				-- Numero de Reporte
	Par_Fecha			DATETIME,				-- Fecha en la que se realizaron las solicitudes
	Par_RutaCSV			VARCHAR(200),			-- Ruta del CSV
	Par_RutaCSVFinal	VARCHAR(200),			-- Ruta del CSV Final
	Par_Salida			CHAR(1),				-- Salida S:S N:No

	INOUT Par_NumErr	INT(11),
	INOUT Par_ErrMen	VARCHAR(400),
	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,

	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
	)
TerminaStore:BEGIN

	-- Declaracion de variables
	DECLARE Var_Control					VARCHAR(50);
	DECLARE Var_TipoCambioDOFUDIS		DECIMAL(14,6);
	DECLARE Var_TipoCambioDOFPESOS		DECIMAL(14,6);
	DECLARE Var_CreditosPrincipales		DECIMAL(18,2);
	DECLARE Var_2100UDIS				DECIMAL(14,2);
	DECLARE Var_1400000UDIS				DECIMAL(14,2);
	DECLARE Var_54000000UDIS			DECIMAL(14,2);
	DECLARE Var_75000000UDIS			DECIMAL(14,2);
	DECLARE Var_FechaInicio				DATE;
	DECLARE Var_FechaFinal				DATE;
	DECLARE Var_FechaEPRC				DATE;

	-- Declaracion de Constantes
	DECLARE Entero_Cero					INT;					-- Entero Cero
    DECLARE Entero_Dos 					INT;					-- Entero Dos
	DECLARE Cadena_Vacia				CHAR(1);				-- Cadena Vacia
	DECLARE SalidaNO					CHAR(1);				-- Salida No
	DECLARE SalidaSI					CHAR(1);				-- Salida Si
	DECLARE ID_MonedaPesos				INT(11);				-- ID del Tipo Moneda Pesos
	DECLARE ID_MonedaUDIS				INT(11);				-- ID del Tipo Moneda de UDIS

	DECLARE Tip_RepFira					INT(11);				-- Tipo Reporte Fira
	DECLARE Tip_RepNoFira				INT(11);				-- Tipo Reporte NO Fira
	DECLARE TipoOperaGlobal				CHAR(1);				-- Tipo de Operacion Global Grupales
	DECLARE Cons_600Millones			DECIMAL(18,2);
	DECLARE Tip_Almacen					INT(11);
	DECLARE Var_Fecha12MesesAtras		DATE;					-- Fecha 12 meses atras en la que se generaReporte
	DECLARE Var_FechaSistema			DATE;

	-- Asignacion de constantes
	SET Entero_Cero						:= 0;
    SET Entero_Dos 						:= 2;
	SET Cadena_Vacia					:= '';
	SET SalidaSI						:= 'S';
	SET SalidaNO						:= 'N';
	SET ID_MonedaPesos					:= 1;
	SET ID_MonedaUDIS					:= 4;
	SET Tip_RepFira						:= 1;
	SET Tip_RepNoFira					:= 2;
	SET TipoOperaGlobal					:= 'G';

	SET Tip_Almacen						:= 21;
	SET Var_Fecha12MesesAtras			:= DATE_SUB(Par_Fecha, INTERVAL -12 MONTH);
	SET Var_FechaInicio					:= SUBDATE(Par_Fecha, DAYOFMONTH(Par_Fecha) - 1);
	SET Var_FechaFinal 					:= LAST_DAY(Par_Fecha);
	SET Var_FechaEPRC					:= LAST_DAY(DATE_SUB(Par_Fecha, INTERVAL 1 MONTH));

	 ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-FIRAPICOMERCIALPRO');
			SET Var_Control := 'SQLEXCEPTION';
		END;

		SET Var_TipoCambioDOFUDIS := (SELECT MAX(TipCamDof) FROM `HIS-MONEDAS` AS MON WHERE MON.MonedaId = ID_MonedaUDIS AND MONTH(MON.FechaRegistro) = MONTH(Var_FechaFinal));

		IF(Var_TipoCambioDOFUDIS = Entero_Cero)THEN
			SET Var_TipoCambioDOFUDIS := (SELECT TipCamDof FROM MONEDAS AS MON WHERE MON.MonedaId = ID_MonedaUDIS);
		END IF;

		SET Var_TipoCambioDOFPESOS := (SELECT TipCamDof FROM MONEDAS AS MON WHERE MON.MonedaId = ID_MonedaPesos);
		SET Var_2100UDIS			:= IFNULL(Var_TipoCambioDOFUDIS * 2100,0);
		SET Var_1400000UDIS			:= IFNULL(Var_TipoCambioDOFUDIS * 14000000,0);
		SET Var_54000000UDIS		:= IFNULL(Var_TipoCambioDOFUDIS * 54000000,0);
		SET Var_75000000UDIS		:= IFNULL(Var_TipoCambioDOFUDIS * 75000000,0);
		SET Cons_600Millones 		:= IFNULL(Var_TipoCambioDOFUDIS *600000000,0);
		SET Var_FechaSistema		:= (SELECT FechaSistema FROM PARAMETROSSIS);


        IF(Par_TipoReporte = Tip_RepFira) THEN
			-- Se toma los registros del Archivo de SP COMERCIAL ingresados por el KTR
			DROP TABLE IF EXISTS TMP_FIRAPI;
            CREATE TABLE TMP_FIRAPI
				SELECT NumeroID,Nomacreditadofira
                FROM TMPFIRAPICOMERCIAL;

			TRUNCATE TMPFIRAPICOMERCIAL;
			-- Llenado de la tabla de por acreditado IFNB
			INSERT INTO TMPFIRAPICOMERCIAL(
					Idacreditadofira,		Nomacreditadofira,		Idacredifnb, 	ClienteID)
				SELECT TMP.NumeroID,MAX(TMP.Nomacreditadofira),		CRE.ClienteID,	CRE.ClienteID
				FROM TMP_FIRAPI TMP
					LEFT JOIN CREDITOS CRE
						ON TMP.NumeroID=CRE.AcreditadoIDFIRA
						AND CRE.FechaInicio <= Var_FechaFinal
				GROUP BY TMP.NumeroID,CRE.ClienteID;

			-- A peticion de Consol se debe de mostrar los Creditos Globales que se procesan en el SP FIRA ID 7381857
			-- Eliminar los registros ID 7381857 que aparezcan la Carga de PI FIRA
			DELETE FROM TMPFIRAPICOMERCIAL WHERE Idacreditadofira=7381857;

			INSERT INTO TMPFIRAPICOMERCIAL(
				Idacreditadofira,		Nomacreditadofira,		Idacredifnb, 	ClienteID)
			SELECT AcreditadoIDFIRA,	Cadena_Vacia,			ClienteID,		ClienteID
			FROM TMP_SPFIRA
			WHERE AcreditadoIDFIRA = 7381857;

			-- Se actualiza el nombre para los Creditos Globales
			UPDATE TMPFIRAPICOMERCIAL REP
				INNER JOIN TMP_FIRAPI TMP ON REP.Idacreditadofira = TMP.NumeroID
				SET REP.Nomacreditadofira = TMP.Nomacreditadofira
			WHERE REP.Idacreditadofira = 7381857;

		ELSE
						/* Se realiza el Insert para que todos los Acreditados que se reportan en el Reporte
			* SP NO FIRA deben de apareer en el reporte PI NO FIRA */
            TRUNCATE TMPFIRAPICOMERCIAL;

			INSERT INTO TMPFIRAPICOMERCIAL(Idacredifnb,		ClienteID)
			SELECT Idacredifnb, ClienteID
			FROM TMPFIRASPCOMERCIAL
			WHERE IFNULL(Idacredifnb, Entero_Cero) != Entero_Cero;

        END IF;

        -- Actualiza INFO de la financiera Acreditado ID 7381857 (CONSOL)
		UPDATE TMPFIRAPICOMERCIAL AS TMP ,
			CLIENTES AS CTE SET
			TMP.Rfcacreditado = CTE.RFCOficial, -- COL3
			TMP.Nomacreditado = CTE.NombreCompleto, -- COL4
			TMP.Idacredifnb = CTE.ClienteID, -- COL5
            TMP.Entfin = 1
		WHERE CTE.ClienteID = 1 AND TMP.Idacreditadofira=7381857;

        -- Acualiza primeros datos
        UPDATE TMPFIRAPICOMERCIAL AS TMP INNER JOIN
				CLIENTES AS CTE ON TMP.ClienteID = CTE.ClienteID LEFT JOIN
				TIPOSOCIEDAD AS TIP ON CTE.TipoSociedadID = TIP.TipoSociedadID LEFT JOIN
				CREDITOS AS CRED ON TMP.ClienteID = CRED.ClienteID LEFT JOIN
				GRUPOSCREDITO AS GRU ON CRED.GrupoID = GRU.GrupoID
			  SET
				TMP.Rfcacreditado = CTE.RFCOficial, -- COL3 RFC_ACREDITADO
				TMP.Nomacreditado =	CTE.NombreCompleto, -- COL4 NOM_ACREDITADO
				TMP.Idacredifnb = CTE.ClienteID, -- COL5 ID_ACRED_IFNB
				TMP.Entfin = CASE
								WHEN TIP.EsFinanciera = 'S' THEN 1 -- ES FINANCIERA
								ELSE 2 END, -- FISICA Y FISICA CON ACT EMP - COL6
				TMP.TipoGarantiaFIRAID = CRED.TipoGarantiaFIRAID, -- EXTRA
				TMP.TipoFondeo = CRED.TipoFondeo, -- *EXTRA
				TMP.InstitFondeoID = CRED.InstitFondeoID, -- EXTRA
				TMP.TipoOperaAgro = GRU.TipoOperaAgro, -- EXTRA
				TMP.TipoPersona = CTE.TipoPersona, -- EXTRA
				TMP.EsFinanciera = IF(TIP.EsFinanciera IS NOT NULL, TIP.EsFinanciera,'N'),
                TMP.Garante = Entero_Dos; -- EXTRA

		-- VENTAS_NETAS - COL7
		UPDATE TMPFIRAPICOMERCIAL AS TMP
			INNER JOIN CLIENTES CLI ON TMP.ClienteID=CLI.ClienteID
			INNER JOIN CONOCIMIENTOCTE AS CON ON TMP.ClienteID = CON.ClienteID
		SET
			TMP.Ventasnetas = (IFNULL(CON.ImporteVta,Entero_Cero)*Var_TipoCambioDOFPESOS)/Var_TipoCambioDOFUDIS /*COL7*/
		WHERE (CLI.TipoPersona ='M' AND Entfin != 1) OR CLI.TipoPersona IN('A','F');

        -- MONTO_ACTIVOS - COL8
		UPDATE TMPFIRAPICOMERCIAL AS TMP
			INNER JOIN CONOCIMIENTOCTE AS CON ON TMP.ClienteID = CON.ClienteID
		SET
			TMP.Montoactivos = (IFNULL(CON.Activos,Entero_Cero)*Var_TipoCambioDOFPESOS)/Var_TipoCambioDOFUDIS /*COL8*/
		WHERE TMP.Entfin = 1;

		-- FECHA_SIC - COL9
		UPDATE TMPFIRAPICOMERCIAL AS TMP
			LEFT OUTER JOIN SOLBUROCREDITO AS SOL ON TMP.Rfcacreditado = SOL.RFC
		SET
			TMP.Fechasic = IFNULL(Date_format(SOL.FechaConsulta,'%Y%m'),Entero_Cero);

        -- LEY_FEDERAL - COL10
		/* Cuando el crédito tenga Fonaga debe reportarse un 1
			Cuando el crédito tenga Fega debe reportarse un 2
			Si al menos uno de los crédito del cliente tiene Fonaga y otros pudieran tener o no tener debe ir un valor de 1
			Si ninguno de los créditos tiene Fonaga debe reportarse un 2.*/

		-- Tabla Base
		DROP TABLE IF EXISTS CREDPORCLIENTEPIFIRA;
		CREATE TABLE CREDPORCLIENTEPIFIRA
		SELECT CRE.CreditoID, CRE.ClienteID,SAL.EstatusCredito,  CRE.TipoGarantiaFIRAID,
			IFNULL(SAL.SalCapVigente +  SAL.SalCapAtrasado +  SAL.SalCapVencido +  SAL.SalCapVenNoExi +
				SAL.SalIntOrdinario +  SAL.SalIntAtrasado +  SAL.SalIntVencido,0) AS SaldoCredito
		FROM TMPFIRAPICOMERCIAL TMP
			INNER JOIN CREDITOS CRE ON TMP.Idacredifnb = CRE.ClienteID
			INNER JOIN SALDOSCREDITOS SAL ON CRE.CreditoID = SAL.CreditoID
		WHERE SAL.EstatusCredito IN ('V','B','K')
			AND SAL.FechaCorte = Var_FechaFinal;

		IF(Par_TipoReporte = Tip_RepFira) THEN
			DROP TABLE IF EXISTS GARCREDPORCLIENTEPIFIRA;
			CREATE TABLE GARCREDPORCLIENTEPIFIRA
				SELECT ClienteID, GROUP_CONCAT(DISTINCT (TipoGarantiaFIRAID)) AS TipoGarantia
				FROM CREDPORCLIENTEPIFIRA
				WHERE EstatusCredito IN ('V','B')
				GROUP BY ClienteID;

			UPDATE TMPFIRAPICOMERCIAL AS TMP
				LEFT JOIN GARCREDPORCLIENTEPIFIRA CRE ON TMP.ClienteID=CRE.ClienteID
			SET
				TMP.Leyfederal =
					CASE
						WHEN (FIND_IN_SET('1',TipoGarantia) > Entero_Cero AND FIND_IN_SET('2',TipoGarantia) > Entero_Cero) THEN 1
						WHEN (FIND_IN_SET('1',TipoGarantia) > Entero_Cero) THEN 2
						WHEN (FIND_IN_SET('2',TipoGarantia) > Entero_Cero) THEN 1
					ELSE 2
					END;
		ELSE
			UPDATE TMPFIRAPICOMERCIAL AS TMP SET
				TMP.Leyfederal = 2;
		END IF;

		-- CVEN_CTOT - COL11
		DROP TABLE IF EXISTS CREDPORCLIENTESUM;
		CREATE TABLE CREDPORCLIENTESUM
		SELECT ClienteID,	SUM(SaldoCredito) AS SaldoCredito
		FROM CREDPORCLIENTEPIFIRA
		GROUP BY ClienteID;

		DROP TABLE IF EXISTS CREDPORCLIENTECVENCTOT;
		CREATE TABLE CREDPORCLIENTECVENCTOT
		SELECT ClienteID,	SUM(SaldoCredito) AS SaldoCredito
		FROM CREDPORCLIENTEPIFIRA
		WHERE EstatusCredito = 'B'
			GROUP BY ClienteID;

        UPDATE TMPFIRAPICOMERCIAL TMP SET -- Valor Default
			TMP.Cvenctot = '2';

		UPDATE TMPFIRAPICOMERCIAL TMP
			INNER JOIN CREDPORCLIENTESUM CRE ON TMP.ClienteID = CRE.ClienteID
			INNER JOIN CREDPORCLIENTECVENCTOT CVEN ON CRE.ClienteID = CVEN.ClienteID
		SET
			TMP.Cvenctot = IF(CVEN.SaldoCredito > (CRE.SaldoCredito * 0.05), 1, 2);

		-- PI_100 - COL12
		DROP TABLE IF EXISTS CARTERACLIENTEFIRA100;
		CREATE TABLE CARTERACLIENTEFIRA100(
			CreditoID BIGINT(12),
			ClienteID INT(11),
			Estatus CHAR(1)
		);

		INSERT INTO CARTERACLIENTEFIRA100 (CreditoID, ClienteID, Estatus)
		SELECT CRE.CreditoID, CRE.ClienteID, '' as Estatus
		FROM TMPFIRAPICOMERCIAL TMP
			INNER JOIN CREDITOS CRE ON TMP.Idacredifnb = CRE.ClienteID;

		UPDATE CARTERACLIENTEFIRA100 CAR
		 	INNER JOIN SALDOSCREDITOS SAL ON CAR.CreditoID = SAL.CreditoID SET
			 	CAR.Estatus = SAL.EstatusCredito
		WHERE SAL.FechaCorte = Var_FechaFinal;

		-- Se eliminan los registros para aquellos que no comprenden a la fecha de Corte
		DELETE FROM CARTERACLIENTEFIRA100
			WHERE  IFNULL(Estatus, Cadena_Vacia) = Cadena_Vacia;

		DROP TABLE IF EXISTS CREDPORCLIENTEPI100;
		CREATE TABLE CREDPORCLIENTEPI100
			SELECT ClienteID, GROUP_CONCAT(DISTINCT (Estatus)) AS Estatus
			FROM CARTERACLIENTEFIRA100
			WHERE Estatus IN ('B','K')
			GROUP BY ClienteID;

		UPDATE TMPFIRAPICOMERCIAL AS TMP
			LEFT OUTER JOIN CREDPORCLIENTEPI100 CRE ON TMP.ClienteID=CRE.ClienteID
		SET
			TMP.Pi100 =
				CASE
					WHEN (FIND_IN_SET('B',IFNULL(CRE.Estatus, 'V')) > Entero_Cero AND FIND_IN_SET('K',IFNULL(CRE.Estatus, 'V')) > Entero_Cero) THEN 2
					WHEN (FIND_IN_SET('K',IFNULL(CRE.Estatus,'V')) > Entero_Cero) THEN 2
					WHEN (FIND_IN_SET('B',IFNULL(CRE.Estatus,'V')) > Entero_Cero) THEN 1
					WHEN (FIND_IN_SET('V',IFNULL(CRE.Estatus,'V')) > Entero_Cero) THEN 3
				ELSE 3
				END;

			/*COL13
			 * TIPO_ENTIDAD
			 * Indicar si la entidad financiera es:
			 * 1 = Bancaria o No bancaria regulada perteneciente a una subsidiaria bancaria.
			 * 2 = No bancaria regulada.
			 * 3 = No bancaria no regulada usuaria de una SIC.
			 * 4 = Entidad financiera otorgante de crédito no usuaria de una SIC.*/
			/*COL14
			 * PASIVO_LARGO
			 * Pasivo a largo plazo (Préstamos bancarios y de otros organismos de largo plazo).*/
			/*COL15
			 * PASIVO_EXIGIBLE	Pasivos de exigibilidad inmediata (Depósitos de exigibilidad inmediata).*/
			/*COL16
			 * CARTERA_CREDITO
			 * Saldo de la cartera de crédito (Cartera de crédito vigente + Cartera de crédito vencida).*/
			/*COL17
			 * UTILIDAD_NETA
			 * Utilidad neta del trimestre anualizada.*/
			/*COL18
			 * ROE
			 * Calculado como la Utilidad neta del trimestre anualizada entre el Capital contable promedio (promedio anual).*/
			/*COL19
			 * CAPITAL_NETO
			 * Capital Neto del acreditado.
			 * Nota: Esta variable será aplicable solo si el acreditado es una institución de crédito. Si la institución acreditada
			 * no cuenta con esta información o no calcula el Índice de Capitalización (ICAP), entonces esta variable no será aplicable.*/
			/*COL20
			 * CAPITAL_CONTABLE
			 * Capital Contable del acreditado.*/
			/*COL21
			 * ASR_TOT
			 * Activos sujetos a riesgo totales.
			 * Nota: Esta variable será aplicable solo si el acreditado es una institución de crédito. Si la institución acreditada
			 * no cuenta con esta información o no calcula el Índice de Capitalización (ICAP), entonces esta variable no será aplicable.*/
			/*COL22
			 * GASTOS_ADMON
			 * Gastos de administración y promoción anualizados*/
			/*COL23
			 * INGRESOS_TOTALES
			 * Ingresos totales anualizados. Calculados como: Ingresos por intereses + Comisiones y tarifas cobradas – Comisiones y tarifas pagadas
			 * + Resultado por intermediación.*/
			/*COL24
			 * CARTERA_VENC
			 * Saldo de Cartera Vencida de la entidad acreditada con el IFNB.*/
			/*COL25
			 * EPRC
			 * Estimación preventiva para riesgos crediticios.*/
			/*COL26
			 * MARGEN_FIN
			 * Margen financiero (debe acumulados de 12 meses).*/
			/*COL27
			 * ACTIVOS_PROD
			 *  Calculados como: Disponibilidades + Inversiones en Valores + Cartera de Crédito Vigente + Operaciones con Valores
			 * y Derivados.*/
			/*COL28
			 * FECHA_EDOSFIN
			 * Indicar la fecha de los estados financieros de la entidad financiera de donde se obtuvo la información cuantitativa
			 * de este numeral I.2.
			 * Nota: Este campo no es aplicable para los acreditados sin garantía FIRA.*/
			/*COL29
			 * CONTA_GUBER
			 * Indicar si la entidad acreditada cumple o no con los criterios de contabilidad gubernamental:
			 * 1 = Cumple con los criterios de contabilidad gubernamental.
			 * 2 = No cumple con los criterios de contabilidad gubernamental.
			 * Nota: Este campo no es aplicable para los acreditados sin garantía FIRA.*/
			/*COL30
			 * EMISION_TIT
			 * Respecto a la emisión de títulos de deuda en oferta pública de la entidad financiera acreditada indicar si:
			 * 1 = No tiene emisiones.
			 * 2 = Emite estos títulos y los reconoce en su contabilidad como pasivo financiero.
			 * 3 = Emite estos títulos y los reconoce como transacciones estructuradas fuera de balance.*/
			/*COL31
			 * NUM_LINEAS
			 * Número de líneas de negocio de Nivel 2*/
			/*COL32
			 * NUM_FUENTES
			 * Para esta variable el IFNB debe considerar los tipos de fuentes de financiamiento del acreditado:
			 * 1 = Si solo cuenta con financiamiento bursátil.
			 * 2 = Si solo cuenta con fondeo de instituciones financieras y de otros organismos (incluyendo a FIRA).
			 * 3 = Si cuenta con ambos: financiamiento bursátil y fondeo de instituciones financieras y de otros organismos (incluyendo a FIRA).
			 * 4 = No cuenta con financiamiento bursátil ni con fondeo de instituciones financieras y de otros organismos (incluyendo a FIRA).*/
			/*COL33
			 * SALDO_PRINC_ACRED
			 * Suma del saldo total de los tres principales acreditados de la entidad (capital e intereses). En pesos.*/
			/*COL34
			 * NUM_CONS_IND
			 * Número de consejeros independientes en el consejo de administración de la entidad acreditada.*/
			/*COL35
			 * NUM_CONS_TOT
			 * Número de consejeros totales en el consejo de administración de la entidad acreditada.*/
			/*COL36
			 * PART_ACC_MAYOR
			 * Porcentaje de participación accionaria del accionista mayoritario. En caso de que la participación accionaria referida sea
			 * superior al 90% del capital social de la entidad acreditada y sea una persona moral, se indicará entonces el porcentaje
			 * de participación accionaria del accionista mayoritario de dicha persona moral.*/
			/*COL37
			 * GOBIERNO_CORP
			 * Indicar si la entidad financiera acreditada:
			 * 1 = Cuenta con un proceso de auditoría interna formalizado, el área de riesgos es una unidad independiente dentro de la
			 * entidad financiera y tiene alta injerencia en la toma de decisiones.
			 * 2 = Cuenta con un proceso de auditoría interna, pero éste no está formalizado, el área de riesgos es una unidad independiente
			 * dentro de la entidad financiera, pero tiene poca injerencia en la toma de decisiones.
			 * 3 = La entidad financiera no cuenta con un proceso de auditoría interna, el área de riesgos no es una unidad independiente
			 * dentro de la entidad y no tiene injerencia en la toma de decisiones.
			 * 0 = No fue posible obtener la información de la entidad.*/
			/*COL38
			 * AÑOS_EXP
			 * Indicar los años promedio de experiencia laboral relevante en el sistema financiero de los funcionarios de primer
			 * y segundo nivel que llevan la administración de la entidad acreditada:
			 * 1 = Más de 10 años promedio.
			 * 2 = Entre 5 y 10 años promedio.
			 * 3 = Menos de 5 años promedio.
			 * 0 =No fue posible obtener la información de la entidad.*/
			/*COL39
			 * NIVEL_POLITICAS
			 * Indicar si la entidad financiera acreditada:
			 * 1 = Implementa, difunde y aplica manuales de políticas y procedimientos.
			 * 2 = Cuenta con manuales de políticas y procedimientos pero no están implementados o formalizados.
			 * 3 = No cuenta con políticas y procedimientos.
			 * 0 = No fue posible obtener la información de la entidad.*/
			/*COL40
			 * EDOSFIN_AUD
			 * Periodicidad con la que han sido auditados los estados financieros de la entidad acreditada por parte de un despacho
			 * externo de prestigio reconocido:
			 * 1 = Han sido auditados durante más de 2 años consecutivos.
			 * 2 = Han sido auditados durante el último año.
			 * 3 = Nunca han sido auditados.
			 * 0 = No fue posible obtener la información de la entidad.*/
			/*COL16*/
			/*COL24*/

			UPDATE TMPFIRAPICOMERCIAL AS TMP
				INNER JOIN CLIENTES AS CLI ON TMP.ClienteID = CLI.ClienteID
				LEFT JOIN INFORMACIONADICFIRA AS INF ON TMP.ClienteID = INF.ClienteID
			SET
				TMP.Tipoentidad = IFNULL(INF.Tipoentidad,Entero_Cero),
				TMP.Pasivolargo = IFNULL(INF.Pasivolargo,Entero_Cero),
				TMP.Pasivoexigible = IFNULL(INF.Pasivoexigible,Entero_Cero),
				TMP.Carteracredito = IFNULL(INF.Carteracredito,Entero_Cero),
				TMP.Utilidadneta = IFNULL(INF.Utilidadneta,Entero_Cero),
				TMP.Roe = ROUND(IFNULL(INF.Roe,Entero_Cero),2)*100,
				TMP.Asrtot = IFNULL(INF.Asrtot,Entero_Cero),
				TMP.Gastosadmon = IFNULL(INF.Gastosadmon,Entero_Cero),
				TMP.Ingresostotales = IFNULL(INF.Ingresostotales,Entero_Cero),
				TMP.Carteravenc = IFNULL(INF.Carteravenc,Entero_Cero),
				TMP.Eprc = IFNULL(INF.Eprc,Entero_Cero),
				TMP.Margenfin = IFNULL(INF.Margenfin,Entero_Cero),
				TMP.Activosprod = IFNULL(INF.Activosprod,Entero_Cero),
				TMP.Fechaedosfin = IFNULL(INF.Fechaedosfin,Entero_Cero),
				TMP.Emisiontit = CASE
									WHEN INF.Emisiontit = 3 THEN 1
									WHEN INF.Emisiontit = 1 THEN 2
									WHEN INF.Emisiontit = 2 THEN 3
								ELSE Entero_Cero END
			WHERE TMP.EsFinanciera='S';

			UPDATE TMPFIRAPICOMERCIAL AS TMP
				LEFT JOIN CLIENTES AS CLI ON TMP.ClienteID = CLI.ClienteID
				LEFT JOIN CONOCIMIENTOCTE AS CON ON TMP.ClienteID = CON.ClienteID
			SET
				TMP.Capitalneto = IFNULL(CON.Capital,Entero_Cero),
				TMP.Capitalcontable = IFNULL(CON.CapitalContable,Entero_Cero)
			WHERE TMP.EsFinanciera='S';

			IF(Par_TipoReporte = Tip_RepFira) THEN
				UPDATE TMPFIRAPICOMERCIAL AS TMP
					INNER JOIN CLIENTES AS CLI ON TMP.ClienteID = CLI.ClienteID
					LEFT JOIN INFORMACIONADICFIRA AS INF ON TMP.ClienteID = INF.ClienteID
				SET
					TMP.Contaguber = IF(TMP.EsFinanciera='S', IFNULL(INF.Contaguber, Entero_Dos), Entero_Dos);
			ELSE
				UPDATE TMPFIRAPICOMERCIAL AS TMP
					INNER JOIN CLIENTES AS CLI ON TMP.ClienteID = CLI.ClienteID
					LEFT JOIN INFORMACIONADICFIRA AS INF ON TMP.ClienteID = INF.ClienteID
				SET
					TMP.Contaguber = IF (TMP.EsFinanciera='S', IFNULL(INF.Contaguber, Entero_Cero), Entero_Cero);
			END IF;

		/* Incluyendo a los AGDs ,cuando el monto de sus activos sean mayores a 600 millones de UDIS */
		UPDATE TMPFIRAPICOMERCIAL AS TMP
				INNER JOIN CLIENTES AS CLI ON TMP.ClienteID = CLI.ClienteID
				LEFT JOIN INFORMACIONADICFIRA AS INF ON TMP.ClienteID = INF.ClienteID
				LEFT JOIN CONOCIMIENTOCTE AS CON ON TMP.ClienteID=CON.ClienteID
			SET
				TMP.Numlineas = IFNULL(INF.Numlineas, Entero_Cero),
				TMP.Numfuentes = IFNULL(INF.Numfuentes,Entero_Cero),
				TMP.Saldoprincacred = IFNULL(INF.SaldoAcreditados,Entero_Cero),
				TMP.Numconsind = IFNULL(INF.NumConsejerosInd,Entero_Cero),
				TMP.Numconstot = IFNULL(INF.NumConsejerosTot,Entero_Cero),
				TMP.Partaccmayor = IFNULL(INF.PorcParticipacionAcc,Entero_Cero),
				TMP.Gobiernocorp = IFNULL(INF.Gobiernocorp, Entero_Cero),
				TMP.Aniosexp = IFNULL(INF.Aniosexp, Entero_Cero),
				TMP.Nivelpoliticas = IFNULL(INF.Nivelpoliticas,Entero_Cero),
				TMP.Edosfinaud = IFNULL(INF.Edosfinaud,Entero_Cero)
			WHERE (TMP.EsFinanciera='S' OR  CLI.TipoSociedadID = Tip_Almacen)
				AND CON.Activos > Cons_600Millones;

		/*II. Cuando el Acreditado sea un almacen general de depósioto AGD ****************************************************/

			/*COL41
			 * CARTERA_COMERCIAL
			 * Saldo de cartera de crédito total comercial del AGD.
			 * Nota: El saldo incluye Cartera de crédito vigente y Cartera de crédito vencida.*/
			/*COL42
			 * DEP_BIENES
			 * Depósito de bienes.
			 * Nota: Esta cuenta se encuentra en Cuentas de Orden e incluye Certificados por mercancías en bodega
			 * y Certificados por mercancías en tránsito.*/
			/*COL43
			 * CAPITAL_CONTABLE_AGD
			 * */
			/*COL45
			 * CARTERA_NETA
			 * Saldo de la Cartera Neta del AGD (Saldo de cartera total menos estimaciones preventivas para riesgos crediticios).*/
			/*COL46
			 * GASTOS_ADMON_AGD
			 * Gastos de administración y promoción anualizados*/
			/*COL47
			 * INGRESOS_TOT_AGD
			 * Ingresos totales anualizados.*/
			/*COL48
			 * UTILIDAD_NETA_AGD
			 * Ingresos totales = Ingresos por intereses + Comisiones y tarifas cobradas – Comisiones y tarifas pagadas +
			 * Resultado por intermediación. Utilidad neta del trimestre anualizada.*/
			/*COL49
			 * ROE_AGD
			 * Gastos de administración y promoción anualizados Calculado como la Utilidad neta del trimestre anualizada entre el
			 * Capital contable promedio (promedio anual).*/
			/*COL50
			 * FECHA_EDOSFIN_AGD
			 * Indicar la fecha de los estados financieros de la AGD de donde se obtuvo la información cuantitativa de este numeral II.
			 * Nota: Este campo no es aplicable para los acreditados sin garantía FIRA.*/
			/*COL51
			 * ENT_REGULADA
			 * Indicar si el AGD es:
			 * 1 = Entidad financiera no bancaria regulada.
			 * 2 = Entidad financiera no bancaria no regulada.*/
			/*COL52
			 * EMISION_TIT_AGD
			 * Respecto a la emisión de títulos de deuda en oferta pública de la entidad financiera acreditada indicar si:
			 * 1 = Emite estos títulos y los reconoce en su contabilidad como pasivo financiero.
			 * 2 = Emite estos títulos y los reconoce como transacciones estructuradas fuera de balance.
			 * 3 = No tiene emisiones.*/

			UPDATE TMPFIRAPICOMERCIAL AS TMP
				INNER JOIN CLIENTES AS CLI ON TMP.ClienteID = CLI.ClienteID
				LEFT JOIN INFORMACIONADICFIRA AS INF ON TMP.ClienteID = INF.ClienteID
				LEFT JOIN CONOCIMIENTOCTE AS CON ON TMP.ClienteID=CON.ClienteID
			SET
				TMP.Carteracomercial = IFNULL(INF.Carteracredito,Entero_Cero)/*COL41*/ ,
				TMP.Depbienes = IFNULL(INF.Depbienes,Entero_Cero)/*COL42*/ ,
				TMP.Capitalcontableagd = IFNULL(CON.CapitalContable,Entero_Cero)/*COL43*/ ,
				TMP.Fondeotot = IFNULL(INF.Fondeotot,Entero_Cero)/*COL44*/ ,
				TMP.Carteraneta = IFNULL(INF.Carteraneta,Entero_Cero)/*COL45*/ ,
				TMP.Gastosadmonagd = IFNULL(INF.Gastosadmonagd,Entero_Cero)/*COL46*/ ,
				TMP.Ingresostotagd = IFNULL(INF.Ingresostotagd,Entero_Cero)/*COL47*/ ,
				TMP.Utilidadnetaagd = IFNULL(INF.Utilidadnetaagd,Entero_Cero)/*COL48*/ ,
				TMP.Roeagd = ROUND(IFNULL(INF.Roeagd,Entero_Cero),2) * 100/*COL49*/ ,
				TMP.Fechaedosfinagd = IFNULL(INF.Fechaedosfinagd,Entero_Cero)/*COL50*/ ,
				TMP.Entregulada = IFNULL(INF.Entregulada,Entero_Cero)/*COL51*/ ,
				TMP.Emisiontitagd = IFNULL(INF.Emisiontitagd,Entero_Cero)/*COL52*/
				WHERE CLI.TipoSociedadID = Tip_Almacen;


		/* Es una persona Moral distinta a una financiera o es una persona F Ventas Anuales sean menores a 14 millones de UDIS. */
			/*COL53
			 * DIAS_ATRASO12
			 * Indicar si el acreditado ha registrado al menos 1 día de atraso con el IFNB en los últimos 12 meses
			 * (considerar solo las obligaciones del acreditado cuyos montos sean mayores a 2,100 UDIs, y no deben considerarse
			 * las obligaciones que se encuentren en litigio al cierre del mes):
			 * 1 = El acreditado ha registrado al menos 1 día de atraso con el IFNB en los últimos 12 meses.
			 * 2 = El acreditado no ha registrado atrasos con el IFNB en los últimos 12 meses.
			 * Nota: Esta variable solo será aplicable cuando se haya hecho la consulta a la SIC mencionada en el anexo 1 y no
			 * haya información disponible para este acreditado.*/
			/*COL54
			 * DÍAS_ATRASO
			 * Días de atraso del acreditado con el IFNB al cierre del mes reportado
			 * (considerar solo las obligaciones del acreditado cuyos montos sean mayores a 2,100 UDIs, y no deben considerarse
			 * las obligaciones que se encuentren en litigio al cierre del mes).*/
			/*COL55
			 * NUM_EMPLEADOS
			 * Se debe anotar el número de personas que laboran en la empresa acreditada independientemente de
			 * si tienen o no prestaciones sociales. En el caso de personas físicas con actividad empresarial, el acreditado
			 * deberá incluirse a sí mismo dentro del conteo de número de empleados.
			 * Nota: Este campo no es aplicable para los acreditados sin garantía FIRA.*/
			/*COL59
			 * FECHA_EDOSFIN_VN
			 * Indicar la fecha de los estados financieros del acreditado de donde se obtuvo la información cuantitativa sobre sus Ventas
			 * netas anuales 8 descritas en el campo VENTAS_NETAS.
			 * Nota: Este campo no es aplicable para los acreditados sin garantía FIRA.*/
			/*COL60
			 * INGRESO_BRUTO
			 * Indicar el monto en pesos de los ingresos brutos totales obtenidos por el acreditado durante el año inmediato anterior al
			 * de la fecha en la que se le autoriza el crédito. Se consideran ingresos brutos totales, aquellos que el acreditado genera
			 * por su actividad empresarial (venta de inventarios, prestación de servicios o cualquier otro concepto que se deriva de las
			 * actividades primarias que representan la principal fuente de ingresos del propio acreditado).
			 * Para las empresas que iniciaron operaciones durante el año inmediato anterior al de la fecha de otorgamiento del crédito
			 * (es decir que no tienen un ejercicio anual completo) se deberá anualizar el ingreso del ejercicio en curso. Por ejemplo,
			 * si la fecha del reporte es Junio 2009 y la empresa inició operaciones en 2006, deberá anotar el monto total de los ingresos
			 * brutos obtenidos durante 2008. Pero si la empresa hubiera iniciado operaciones en marzo de 2008, (o en cualquier otro mes
			 * de 2008 o de 2009) deberá anualizar el ingreso del ejercicio en curso.
			 * Nota: Este campo no es aplicable para los acreditados sin garantía FIRA.*/
			/*COL61
			 * AÑO_INGRESO_BRUTO
			 * Indicar el año al que corresponden los ingresos brutos reportados en el campo anterior de INGRESO_BRUTO.
			 * Nota: Este campo no es aplicable para los acreditados sin garantía FIRA.*/
			/*COL62
			 * IND_PERSONA
			 * Indicar el tipo de persona:
			 * 1 = Si es persona moral o fideicomiso.
			 * 2= Si es persona física con actividad empresarial. */
			/*COL53*/
			TRUNCATE TMPCREDITOSCARTFIRA;
			INSERT INTO TMPCREDITOSCARTFIRA(
				ClienteID,		Diasatraso12,	DiasAtraso)
			SELECT
			TMP.ClienteID,	Entero_Cero AS Diasatraso12,
				MAX(FNDIASPIFIRA(1,CRED.CreditoID,Var_FechaInicio, Var_FechaFinal)) AS Diasatraso
			FROM
				TMPFIRAPICOMERCIAL AS TMP INNER JOIN
				CREDITOS AS CRED ON TMP.ClienteID = CRED.ClienteID
				GROUP BY TMP.ClienteID;

			UPDATE TMPFIRAPICOMERCIAL AS TMP
				INNER JOIN CLIENTES AS CLI ON TMP.ClienteID = CLI.ClienteID
				LEFT JOIN CONOCIMIENTOCTE AS CON ON TMP.ClienteID = CON.ClienteID
				LEFT JOIN TMPCREDITOSCARTFIRA AS CC ON TMP.ClienteID = CC.ClienteID
			SET
				TMP.Diasatraso12 = CASE
										WHEN CC.DiasAtraso > Entero_Cero AND TMP.Fechasic > Entero_Cero THEN 1
										WHEN CC.DiasAtraso = Entero_Cero AND TMP.Fechasic > Entero_Cero THEN 2
										ELSE Entero_Cero
									END /*COL53*/,
				TMP.Diasatraso = IFNULL(CC.DiasAtraso, Entero_Cero) /*COL54*/
			WHERE ((CLI.TipoPersona = 'M' AND TMP.EsFinanciera != 'S') OR CLI.TipoPersona IN('F','A'))
				AND (IFNULL(CON.ImporteVta,0)*Var_TipoCambioDOFPESOS)<Var_1400000UDIS;

			UPDATE TMPFIRAPICOMERCIAL AS TMP
				INNER JOIN CLIENTES AS CLI ON TMP.ClienteID = CLI.ClienteID
				LEFT JOIN INFORMACIONADICFIRA AS INF ON TMP.ClienteID = INF.ClienteID
				LEFT JOIN CONOCIMIENTOCTE AS CON ON TMP.ClienteID = CON.ClienteID SET
				TMP.Numempleados = IFNULL(INF.Numempleadosm,Entero_Cero)/*COL55*/ ,
				TMP.Retlab1 = IFNULL(INF.Retlab1m,Entero_Cero)/*COL56*/ ,
				TMP.Retlab2 = IFNULL(INF.Retlab2m,Entero_Cero)/*COL57*/ ,
				TMP.Retlab3 = IFNULL(INF.Retlab3m,Entero_Cero)/*COL58*/ ,
				TMP.Fechaedosfinvn =  IFNULL(INF.Fechaedosfinm,Entero_Cero) /* COL59*/ ,
				TMP.Ingresobruto = IFNULL(INF.Ingresobrutom,Entero_Cero)/*COL60*/ ,
				TMP.Anioingresobruto = IFNULL(INF.Anioingresobrutom,Entero_Cero)/*COL61*/ ,
				TMP.Indpersona = IF(CLI.TipoPersona='M',1,2)/*COL62*/
				WHERE ((CLI.TipoPersona = 'M' AND TMP.EsFinanciera != 'S') OR CLI.TipoPersona IN('F','A'))
				AND (IFNULL(CON.ImporteVta,0)*Var_TipoCambioDOFPESOS)<Var_1400000UDIS;

			-- COL54
			DROP TABLE IF EXISTS TMPCREDITOSCARTFIRA2;
			CREATE TABLE TMPCREDITOSCARTFIRA2
				SELECT TMP.ClienteID,MAX(SC.DiasAtraso) AS DiasAtraso
					FROM TMPFIRAPICOMERCIAL TMP
						INNER JOIN CREDITOS CRE ON CRE.ClienteID = TMP.ClienteID
						INNER JOIN SALDOSCREDITOS SC ON SC.CreditoID = CRE.CreditoID
							AND FechaCorte = Var_FechaFinal AND SC.DiasAtraso>0
							AND (CRE.MontoCredito*Var_TipoCambioDOFPESOS)>Var_2100UDIS
					GROUP BY TMP.ClienteID;

			ALTER TABLE TMPCREDITOSCARTFIRA2 ADD INDEX `IDX_TMPCREDITOSCARTFIRA2_1` (`ClienteID` ASC);

			-- DIAS_ATRASO - COL54
			UPDATE TMPFIRAPICOMERCIAL TMP
					INNER JOIN TMPCREDITOSCARTFIRA2 TMPC
					ON TMP.ClienteID = TMPC.ClienteID
				SET
					TMP.Diasatraso = TMPC.Diasatraso;

		/* Es una persona Moral distinta a una financiera o es una persona F Ventas Anuales sean MAYORES a 14 millones de UDIS. */
			/*COL63
			 * NUM_EMPLEADOS_M
			 * Se debe anotar el número de personas que laboran en la empresa o entidad objeto del crédito comercial, independientemente
			 * de si tienen o no prestaciones sociales. En el caso de personas físicas con actividad empresarial, el acreditado deberá
			 * incluirse a sí mismo dentro del conteo de número de empleados.
			 * Nota: Este campo no es aplicable para los acreditados sin garantía FIRA.*/
			/*COL67
			 * ACTIVO_TOT * Activo total.*/
			/*COL68
			 * ACTIVO_CIRC
			 * Activo circulante.*/
			/*COL69
			 * PASIVO_CIRC
			 * Pasivo circulante.*/
			/*COL70
			 * ROE_M
			 * ROE calculado como la Utilidad neta del trimestre anualizada entre el Capital contable promedio (de un año).*/
				/*COL71
			 * UTILIDAD_NETA_M
			 * Utilidad neta del trimestre anualizada.*/
			/*COL72
			 * FECHA_EDOSFIN_M
			 * ROE calculado como la Utilidad neta del trimestre anualizada entre el Capital contable promedio (de un año).
			 * Utilidad neta del trimestre anualizada. Indicar la fecha de los estados financieros del acreditado de donde se obtuvo
			 * la información cuantitativa de este numeral IV.2, incluyendo el dato sobre las Ventas netas anuales descritas en el campo
			 * VENTAS_NETAS.
			 * Nota: Este campo no es aplicable para los acreditados sin garantía FIRA.*/
			/*COL73
			 * INGRESO_BRUTO_M
			 * Indicar el monto en pesos de los ingresos brutos totales obtenidos por el acreditado durante el año inmediato
			 * anterior al de la fecha en la que se le autoriza el crédito. Se consideran ingresos brutos totales, aquellos que el
			 * acreditado genera por su actividad empresarial (venta de inventarios, prestación de servicios o cualquier otro
			 * concepto que se deriva de las actividades primarias que representan la principal fuente de ingresos del propio
			 * acreditado). Para las empresas que iniciaron operaciones durante el año inmediato anterior al de la fecha de
			 * otorgamiento del crédito (es decir que no tienen un ejercicio anual completo) se deberá anualizar el ingreso
			 * del ejercicio en curso. Por ejemplo, si la fecha del reporte es Junio 2009 y la empresa inició operaciones en
			 * 2006, deberá anotar el monto total de los ingresos brutos obtenidos durante 2008.
			 * Pero si la empresa hubiera iniciado operaciones en marzo de 2008, (o en cualquier otro mes de 2008 o de 2009) deberá anualizar
			 * el ingreso del ejercicio en curso.
			 * Nota: Este campo no es aplicable para los acreditados sin garantía FIRA.*/
			/*COL74
			 * AÑO_INGRESO_BRUTO_M
			 * Indicar el año al que corresponden los ingresos brutos reportados en el campo anterior de INGRESO_BRUTO_M.
			 * Nota: Este campo no es aplicable para los acreditados sin garantía FIRA.*/
			UPDATE TMPFIRAPICOMERCIAL AS TMP
				INNER JOIN CLIENTES AS CLI ON TMP.ClienteID = CLI.ClienteID
				LEFT JOIN INFORMACIONADICFIRA AS INF ON TMP.ClienteID = INF.ClienteID
				LEFT JOIN CONOCIMIENTOCTE AS CON ON TMP.ClienteID = CON.ClienteID SET
				TMP.Numempleadosm = IFNULL(INF.Numempleadosm,Entero_Cero)/*COL63*/ ,
				TMP.Retlab1m = IFNULL(INF.Retlab1m,Entero_Cero)/*COL64*/ ,
				TMP.Retlab2m = IFNULL(INF.Retlab2m,Entero_Cero)/*COL65*/ ,
				TMP.Retlab3m = IFNULL(INF.Retlab3m,Entero_Cero)/*COL66*/ ,
				TMP.Activotot = IFNULL(CON.Activos,Entero_Cero) /*COL67*/ ,
				TMP.Activocirc = IFNULL(INF.Activocirc,Entero_Cero)/*COL68*/ ,
				TMP.Pasivocirc = IFNULL(INF.Pasivocirc,Entero_Cero) /*COL69*/ ,
				TMP.Roem = ROUND(IFNULL(INF.Roem,Entero_Cero),2) * 100 /*COL70*/ ,
				TMP.Utilidadnetam = IFNULL(INF.Utilidadnetam,Entero_Cero)/*COL71*/ ,
				TMP.Fechaedosfinm = IFNULL(INF.Fechaedosfinm,Entero_Cero)/*COL72*/ ,
				TMP.Ingresobrutom = IFNULL(INF.Ingresobrutom,Entero_Cero)/*COL73*/ ,
				TMP.Anioingresobrutom = IFNULL(INF.Anioingresobrutom,Entero_Cero)/*COL74*/
				WHERE ((CLI.TipoPersona = 'M' AND TMP.EsFinanciera != 'S') OR CLI.TipoPersona IN('F','A'))
					AND (IFNULL(CON.ImporteVta,0)*Var_TipoCambioDOFPESOS)>=Var_1400000UDIS;

			/* Es una persona Moral distinta a una financiera o es una persona F Ventas Anuales sean MAYORES a 54 millones de UDIS. */
			/*3 Adicionalmente ventas anuales de 54 millones*/
			/*COL83
			 * UAFIR
			 * Utilidad antes de gastos financieros e impuesto sobre la renta correspondiente al cierre del año previo al cierre del
			 * trimestre correspondiente.*/
			/*COL84
			 * GASTOS_FIN
			 * Gastos financieros. Son los Intereses pagados correspondientes al cierre del año previo al cierre del trimestre.*/
			/*COL85
			 * EDOSFIN_AUD_M
			 * Periodicidad con la que han sido auditados los estados financieros de la entidad acreditada por parte de un despacho
			 * externo de prestigio reconocido:
			 * 1 = Han sido auditados durante los últimos 2 años. 2 = Han sido auditados durante el último año.
			 * 3 = No han sido auditados en los últimos 2 años. 0 = No fue posible obtener la información de la entidad.*/
			/*COL85
			 * GARANTE
			 * Se indicará si la información reportada corresponde al garante o al acreditado:
			 * 1 = Corresponde al garante.
			 * 2 = Corresponde al acreditado.*/
			UPDATE TMPFIRAPICOMERCIAL AS TMP
				INNER JOIN CLIENTES AS CLI ON TMP.ClienteID = CLI.ClienteID
				LEFT JOIN INFORMACIONADICFIRA AS INF ON TMP.ClienteID = INF.ClienteID
				LEFT JOIN CONOCIMIENTOCTE AS CON ON TMP.ClienteID = CON.ClienteID
				LEFT JOIN ACTIVIDADESBMX ACT ON CLI.ActividadBancoMX = ACT.ActividadBMXID SET
				TMP.Acteco = ACT.ActividadFIRAID/*COL75*/ ,
				TMP.Competencia = IF(INF.Competencia != 5, INF.Competencia, 0) /*COL76*/ ,
				TMP.Proveedores = IF(INF.Proveedores != 4, INF.Proveedores, 0) /*COL77*/ ,
				TMP.Clientes = IF(INF.Clientes != 4, INF.Clientes,0) /*COL78*/ ,
				TMP.Califexterna = INF.Califexterna/*COL79*/ ,
				TMP.Consejoadmon = IF(INF.Consejoadmon != 5, INF.Consejoadmon, 0)/*COL80*/ ,
				TMP.Estrucorganiz = IF(INF.Estrucorganiz != 4, INF.Estrucorganiz, 0)/*COL81*/ ,
				TMP.Compaccion = IF(INF.Compaccion!= 4, INF.Compaccion, 0)/*COL82*/ ,
				TMP.Uafir = INF.Uafir/*COL83*/ ,
				TMP.Gastosfin = INF.Gastosfin/*COL84*/ ,
				TMP.Edosfinaudm = IF(INF.Edosfinaudm != 4, INF.Edosfinaudm, 0)/*COL85*/
				WHERE ((CLI.TipoPersona = 'M' AND TMP.EsFinanciera != 'S') OR CLI.TipoPersona IN('F','A'))
					AND (IFNULL(CON.ImporteVta,0)*Var_TipoCambioDOFPESOS)>=Var_54000000UDIS;

		IF(Par_TipoReporte = Tip_RepFira)THEN
			-- Se elimina el primer registro que es de Cabecera
			DELETE FROM TMPFIRAPICOMERCIAL WHERE NumeroID =1;
		END IF;

		SELECT CONCAT_WS(',',
			'ID_ACREDITADO_FIRA',			'NOM_ACREDITADO_FIRA',			'RFC_ACREDITADO',			'NOM_ACREDITADO',			'ID_ACRED_IFNB',
			'ENT_FIN',						'VENTAS_NETAS',					'MONTO_ACTIVOS',			'FECHA_SIC',				'LEY_FEDERAL',
			'CVEN_CTOT',					'PI_100',						'TIPO_ENTIDAD',				'PASIVO_LARGO',				'PASIVO_EXIGIBLE',
			'CARTERA_CREDITO',				'UTILIDAD_NETA',				'ROE',						'CAPITAL_NETO',				'CAPITAL_CONTABLE',
			'ASR_TOT',						'GASTOS_ADMON',					'INGRESOS_TOTALES',			'CARTERA_VENC',				'EPRC',
			'MARGEN_FIN',					'ACTIVOS_PROD',					'FECHA_EDOSFIN',			'CONTA_GUBER',				'EMISION_TIT',
			'NUM_LINEAS',					'NUM_FUENTES',					'SALDO_PRINC_ACRED',		'NUM_CONS_IND',				'NUM_CONS_TOT',
			'PART_ACC_MAYOR',				'GOBIERNO_CORP',				'ANIOS_EXP',				'NIVEL_POLITICAS',			'EDOSFIN_AUD',
			'CARTERA_COMERCIAL',			'DEP_BIENES',					'CAPITAL_CONTABLE_AGD',		'FONDEO_TOT',				'CARTERA_NETA',
			'GASTOS_ADMON_AGD',				'INGRESOS_TOT_AGD',				'UTILIDAD_NETA_AGD',		'ROE_AGD',					'FECHA_EDOSFIN_AGD',
			'ENT_REGULADA',					'EMISION_TIT_AGD',				'DIAS_ATRASO12',			'DIAS_ATRASO',				'NUM_EMPLEADOS',
			'RET_LAB1',						'RET_LAB2',						'RET_LAB3',					'FECHA_EDOSFIN_VN',			'INGRESO_BRUTO',
			'ANIO_INGRESO_BRUTO',			'IND_PERSONA',					'NUM_EMPLEADOS_M',			'RET_LAB1_M',				'RET_LAB2_M',
			'RET_LAB3_M',					'ACTIVO_TOT',					'ACTIVO_CIRC',				'PASIVO_CIRC',				'ROE_M',
			'UTILIDAD_NETA_M',				'FECHA_EDOSFIN_M',				'INGRESO_BRUTO_M',			'ANIO_INGRESO_BRUTO_M',		'ACT_ECO',
			'COMPETENCIA',					'PROVEEDORES',					'CLIENTES',					'CALIF_EXTERNA',			'CONSEJO_ADMON',
			'ESTRUC_ORGANIZ',				'COMP_ACCION',					'UAFIR',					'GASTOS_FIN',				'EDOSFIN_AUD_M',
			'GARANTE'					) AS Resultado
		UNION
		SELECT CONCAT_WS(',',
			IFNULL(Idacreditadofira,0),											IFNULL(REPLACE(IF(TRIM(Nomacreditadofira)='','0',Nomacreditadofira),',',''),'0'),
			IFNULL(Rfcacreditado,'0'),											IFNULL(Nomacreditado,'0'),
			CONCAT(LPAD(IFNULL(Idacredifnb,'0'),11,'0')),						IFNULL(IF(Entfin = '','0',Entfin),'0'),
			IFNULL(IF(Ventasnetas = '','0',Ventasnetas),'0'),					IFNULL(IF(Montoactivos = '','0',Montoactivos),'0'),
			IFNULL(IF(Fechasic = '','0',Fechasic),'0'),							IFNULL(IF(Leyfederal = '','0',Leyfederal),'0'),
			IFNULL(IF(Cvenctot = '','0',Cvenctot),'0'),							IFNULL(IF(Pi100 = '','0',Pi100),'0'),
			IFNULL(IF(Tipoentidad = '','0',Tipoentidad),'0'),					IFNULL(IF(Pasivolargo = '','0',Pasivolargo),'0'),
			IFNULL(IF(Pasivoexigible = '','0',Pasivoexigible),'0'),				IFNULL(IF(Carteracredito = '','0',Carteracredito),'0'),
			IFNULL(IF(Utilidadneta = '','0',Utilidadneta),'0'),					IFNULL(IF(Roe = '','0',Roe),'0'),
			IFNULL(IF(Capitalneto = '','0',Capitalneto),'0'),					IFNULL(IF(Capitalcontable = '','0',Capitalcontable),'0'),
			IFNULL(IF(Asrtot = '','0',Asrtot),'0'),								IFNULL(IF(Gastosadmon = '','0',Gastosadmon),'0'),
			IFNULL(IF(Ingresostotales = '','0',Ingresostotales),'0'),			IFNULL(IF(Carteravenc = '','0',Carteravenc),'0'),
			IFNULL(IF(Eprc = '','0',Eprc),'0'),									IFNULL(IF(Margenfin = '','0',Margenfin),'0'),
			IFNULL(IF(Activosprod = '','0',Activosprod),'0'),					IFNULL(IF(Fechaedosfin= '','0',Fechaedosfin),'0'),
			IFNULL(IF(Contaguber = '','2',Contaguber),'2'),						IFNULL(IF(Emisiontit = '','0',Emisiontit),'0'),
			IFNULL(IF(Numlineas = '','0',Numlineas),'0'),						IFNULL(IF(Numfuentes = '','0',Numfuentes),'0'),
			IFNULL(IF(Saldoprincacred = '', '0',Saldoprincacred),'0'),			IFNULL(IF(Numconsind = '', '0',Numconsind),'0'),
			IFNULL(IF(Numconstot = '', '0',Numconstot),'0'),					IFNULL(IF(Partaccmayor = '','0',Partaccmayor),'0'),
			IFNULL(IF(Gobiernocorp = '', '0',Gobiernocorp),'0'),				IFNULL(IF(Aniosexp = '', '0',Aniosexp),'0'),
			IFNULL(IF(Nivelpoliticas = '', '0',Nivelpoliticas),'0'),			IFNULL(IF(Edosfinaud = '', '0',Edosfinaud),'0'),
			IFNULL(IF(Carteracomercial = '','0',Carteracomercial),'0'),			IFNULL(IF(Depbienes = '', '0',Depbienes),'0'),
			IFNULL(IF(Capitalcontableagd = '', '0',Capitalcontableagd),'0'),	IFNULL(IF(Fondeotot = '', '0',Fondeotot),'0'),
			IFNULL(IF(Carteraneta = '', '0',Carteraneta),'0'),					IFNULL(IF(Gastosadmonagd = '','0',Gastosadmonagd),'0'),
			IFNULL(IF(Ingresostotagd = '', '0',Ingresostotagd),'0'),			IFNULL(IF(Utilidadnetaagd = '', '0',Utilidadnetaagd),'0'),
			IFNULL(IF(Roeagd = '', '0',Roeagd),'0'),							IFNULL(IF(Fechaedosfinagd = '','0',Fechaedosfinagd),'0'),
			IFNULL(IF(Entregulada = '','0',Entregulada),'0'),					IFNULL(IF(Emisiontitagd = '', '0',Emisiontitagd),'0'),
			IFNULL(IF(Diasatraso12 = '', '0',Diasatraso12),'0'),				IFNULL(IF(Diasatraso = '', '0',Diasatraso),'0'),
			IFNULL(IF(Numempleados = '', '0',Numempleados),'0'),				IFNULL(IF(Retlab1 = '','0',Retlab1),'0'),
			IFNULL(IF(Retlab2 = '', '0',Retlab2),'0'),							IFNULL(IF(Retlab3 = '', '0',Retlab3),'0'),
			IFNULL(IF(Fechaedosfinvn = '','0',Fechaedosfinvn),'0'),				IFNULL(IF(Ingresobruto = '', '0',Ingresobruto),'0'),
			IFNULL(IF(Anioingresobruto = '','0',Anioingresobruto),'0'),			IFNULL(IF(Indpersona = '', '0',Indpersona),'0'),
			IFNULL(IF(Numempleadosm = '', '0',Numempleadosm),'0'),				IFNULL(IF(Retlab1m = '', '0',Retlab1m),'0'),
			IFNULL(IF(Retlab2m = '', '0',Retlab2m),'0'),						IFNULL(IF(Retlab3m = '','0',Retlab3m),'0'),
			IFNULL(IF(Activotot = '', '0',Activotot),'0'),						IFNULL(IF(Activocirc = '', '0',Activocirc),'0'),
			IFNULL(IF(Pasivocirc = '', '0',Pasivocirc),'0'),					IFNULL(IF(Roem = '', '0',Roem),'0'),
			IFNULL(IF(Utilidadnetam = '','0',Utilidadnetam),'0'),				IFNULL(IF(Fechaedosfinm = '','0',Fechaedosfinm),'0'),
			IFNULL(IF(Ingresobrutom = '', '0',Ingresobrutom),'0'),				IFNULL(IF(Anioingresobrutom = '', '0',Anioingresobrutom),'0'),
			IFNULL(IF(Acteco = '', '0',Acteco),'0'),							IFNULL(IF(Competencia = '','0',Competencia),'0'),
			IFNULL(IF(Proveedores = '', '0',Proveedores),'0'),					IFNULL(IF(Clientes = '', '0',Clientes),'0'),
			IFNULL(IF(Califexterna = '', '0',Califexterna),'0'),				IFNULL(IF(Consejoadmon = '', '0',Consejoadmon),'0'),
			IFNULL(IF(Estrucorganiz = '','0',Estrucorganiz),'0'),				IFNULL(IF(Compaccion = '', '0',Compaccion),'0'),
			IFNULL(IF(Uafir = '', '0',Uafir),'0'),								IFNULL(IF(Gastosfin = '', '0',Gastosfin),'0'),
			IFNULL(IF(Edosfinaudm = '', '0',Edosfinaudm),'0'),					IFNULL(IF(Garante = '','0',Garante),'0')) AS Resultado
				FROM TMPFIRAPICOMERCIAL;

	END ManejoErrores;

	IF(Par_Salida = SalidaSI) THEN
		SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen 		AS ErrMen,
				Var_Control 	AS control,
				Entero_Cero 	AS consecutivo;
	END IF;
END TerminaStore$$