-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FIRASPCOMERCIALPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `FIRASPCOMERCIALPRO`;
DELIMITER $$

CREATE PROCEDURE `FIRASPCOMERCIALPRO`(
/*SP QUE GENERA EL REPORTE SP COMERCIAL*/
	Par_Tipo			TINYINT,				-- Numero de Reporte
	Par_Fecha			DATETIME,				-- Fecha en la que se realizaron las solicitudes
	Par_RutaCSV			VARCHAR(200),			-- Ruta del CSV
	Par_RutaCSVFinal	VARCHAR(200),			-- Ruta del CSV Final
	Par_Salida			CHAR(1),				-- Salida S:S N:No

	INOUT Par_NumErr	INT(11),
	INOUT Par_ErrMen	VARCHAR(400),
	/* Parametros de Auditoria */
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
	DECLARE NumReg						INT(11);				-- Variable para el Numero de Registros
	DECLARE Var_FechaCorte				DATE;					-- Fecha Corte del Historico de Cuentas `HIS-CUENTASAHO`
	DECLARE Var_FechaInicio				DATE;					-- Fecha Inicio del Parametro de Fecha
	-- Declaracion de Constantes
	DECLARE Entero_Cero					INT;					-- Entero Cero
	DECLARE Cadena_Vacia				CHAR(1);				-- Cadena Vacia
	DECLARE SalidaNO					CHAR(1);				-- Salida No
	DECLARE SalidaSI					CHAR(1);				-- Salida Si
	DECLARE TipoReporteFira				INT(11);
	DECLARE TipoReporteNoFira			INT(11);
    DECLARE Est_Vigente                 CHAR(1);                -- Estatus Vigente
    DECLARE Est_Vencido                 CHAR(1);                -- Estatus Vencido
    DECLARE Est_Pagado                  CHAR(1);                -- Estatus Pagado
    DECLARE Est_Cancelado               CHAR(1);                -- Estatus Cancelado
    DECLARE Est_Castigado               CHAR(1);                -- Estatus Castigado
    DECLARE Num_1                       INT(11);                -- Numero 1
    DECLARE Num_2                       INT(11);                -- Numero 2
	DECLARE Num_3                       INT(11);                -- Numero 3
    DECLARE Num_4                       INT(11);                -- Numero 4
	DECLARE Est_Autorizado				CHAR(1);				-- Estatus de Garantia Autorizado
	DECLARE Con_NO						CHAR(1);				-- Constante NO
	DECLARE Con_SI						CHAR(1);				-- Constante NO

	-- Asignacion de constantes
	SET TipoReporteFira					:=3;
	SET TipoReporteNoFira				:=4;
	SET Entero_Cero						:=0;
	SET Cadena_Vacia					:='';
	SET SalidaSI						:='S';
	SET SalidaNO						:='N';
    SET Est_Vigente                     :='V';
    SET Est_Vencido                     :='B';
    SET Est_Cancelado                   :='C';
    SET Est_Castigado                   :='K';
    SET Num_1                           :=1;
    SET Num_2                           :=2;
	SET Num_3                           :=3;
    SET Num_4                           :=4;
	SET Est_Autorizado					:='A';
	SET Est_Pagado						:='P';
	SET Con_NO							:='N';
	SET Con_SI							:='S';

    ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-FIRASPCOMERCIALPRO');
			SET Var_Control := 'SQLEXCEPTION';
		END;

	SET Var_FechaInicio := (SELECT DATE_FORMAT(Par_Fecha, '%Y-%m-01'));

    IF(Par_Tipo = TipoReporteFira) THEN
		    -- Se toma los registros del Archivo de SP COMERCIAL ingresados por el KTR
		DROP TABLE IF EXISTS TMP_SPCOMERCIAL;
			CREATE TABLE TMP_SPCOMERCIAL
				SELECT NumeroID,	Idcreditofira, 	Idacreditadofira, 	Nomacreditadofira, Numcontrol
				FROM TMPFIRASPCOMERCIAL
				WHERE Idcreditofira<>0 AND Idacreditadofira<>0;

        DROP TABLE IF EXISTS TMP_SPFIRA;
        CREATE TABLE TMP_SPFIRA(
            CreditoIDFIRA		BIGINT(20),
            AcreditadoIDFIRA	BIGINT(20),
            CreditoID			BIGINT(12),
            ClienteID			INT(11),
			AplicaCont			CHAR(1)
        );

        /* Se insertar todos los registros que se presentan de forma correcta*/
        INSERT INTO TMP_SPFIRA
		(CreditoIDFIRA,		AcreditadoIDFIRA,		CreditoID,		ClienteID,		AplicaCont)
        SELECT cre.CreditoIDFIRA, cre.AcreditadoIDFIRA, cre.CreditoID, cre.ClienteID, Con_NO
        FROM TMP_SPCOMERCIAL ts
            INNER JOIN CREDITOS cre
                ON ts.Idcreditofira  = cre.CreditoIDFIRA
                AND ts.Idacreditadofira  =  cre.AcreditadoIDFIRA
            WHERE cre.Estatus IN (Est_Vigente,Est_Vencido) AND cre.EstatusGarantiaFIRA = Est_Autorizado
                    AND cre.GrupoID = Entero_Cero;

		/* Se insertar los registros que cumplen el Criterio pero el EstatusGarantiaFIRA Pagado*/
        INSERT INTO TMP_SPFIRA
		(CreditoIDFIRA,		AcreditadoIDFIRA,		CreditoID,		ClienteID,		AplicaCont)
        SELECT gar.CreditoContFondeador, gar.AcreditadoIDFIRA, cre.CreditoID, cre.ClienteID, Con_SI
        FROM TMP_SPCOMERCIAL ts
        	INNER JOIN BITACORAAPLIGAR gar ON ts.Idcreditofira = gar.CreditoContFondeador
        				AND ts.Idacreditadofira  =  gar.AcreditadoIDFIRA
            INNER JOIN CREDITOS cre ON cre.CreditoID = gar.CreditoID
            WHERE cre.Estatus IN (Est_Vigente,Est_Vencido)
            	AND cre.EstatusGarantiaFIRA = Est_Pagado
            	AND cre.GrupoID = Entero_Cero;

        /* Se insertar los registros que cumplen el Criterio pero el EstatusGarantiaFIRA  != Autorizado y Pagado*/
        INSERT INTO TMP_SPFIRA
		(CreditoIDFIRA,		AcreditadoIDFIRA,		CreditoID,		ClienteID,		AplicaCont)
        SELECT cre.CreditoIDFIRA, cre.AcreditadoIDFIRA, cre.CreditoID, cre.ClienteID, Con_NO
        FROM TMP_SPCOMERCIAL ts
            INNER JOIN CREDITOS cre
                ON ts.Idcreditofira  = cre.CreditoIDFIRA
                AND ts.Idacreditadofira  =  cre.AcreditadoIDFIRA
            WHERE cre.Estatus IN (Est_Vigente,Est_Vencido)
				AND cre.GrupoID = Entero_Cero
                AND ts.Idcreditofira NOT IN (SELECT CreditoIDFIRA FROM TMP_SPFIRA);


         /* Se insertar los registros que tienen un Estatus Diferente a VIGENTE o VENCIDO */
        INSERT INTO TMP_SPFIRA
		(CreditoIDFIRA,		AcreditadoIDFIRA,		CreditoID,		ClienteID,		AplicaCont)
        SELECT cre.CreditoIDFIRA, cre.AcreditadoIDFIRA, cre.CreditoID, cre.ClienteID, Con_NO
        FROM TMP_SPCOMERCIAL ts
            INNER JOIN CREDITOS cre
                ON ts.Idcreditofira  = cre.CreditoIDFIRA
                AND ts.Idacreditadofira  =  cre.AcreditadoIDFIRA
            WHERE cre.GrupoID = Entero_Cero
                AND ts.Idcreditofira NOT IN (SELECT CreditoIDFIRA FROM TMP_SPFIRA);

        /* Se insertan los registros de los Creditos Grupales */
        INSERT INTO TMP_SPFIRA
		(CreditoIDFIRA,		AcreditadoIDFIRA,		CreditoID,		ClienteID,		AplicaCont)
        SELECT cre.CreditoIDFIRA, cre.AcreditadoIDFIRA, cre.CreditoID, cre.ClienteID, Con_NO
        FROM TMP_SPCOMERCIAL ts
            INNER JOIN CREDITOS cre
                ON ts.Idcreditofira  = cre.CreditoIDFIRA
                AND ts.Idacreditadofira  =  cre.AcreditadoIDFIRA
            WHERE cre.GrupoID > Entero_Cero;

        /* Se insertan los registros a considerar en la Tabla Base */
        TRUNCATE TMPFIRASPCOMERCIAL;

		INSERT INTO TMPFIRASPCOMERCIAL (
					NumeroID,			Idcreditofira, 		Idacreditadofira, 		Nomacreditadofira, 		ClienteID,
                    CreditoID,			Numcontrol, 		EsAgro)
        SELECT MAX(TMP.NumeroID),	TMP.Idcreditofira, 	MAX(TMP.Idacreditadofira), 	MAX(TMP.Nomacreditadofira),	CRE.ClienteID,
            MAX(CRE.CreditoID),		MAX(TMP.Numcontrol),    'S'
        FROM TMP_SPCOMERCIAL TMP
        LEFT JOIN TMP_SPFIRA CRE
            ON CRE.CreditoIDFIRA=TMP.Idcreditofira
                AND CRE.AcreditadoIDFIRA=TMP.Idacreditadofira
        GROUP BY  TMP.Idcreditofira,CRE.ClienteID;

		UPDATE TMPFIRASPCOMERCIAL AS TMP
			LEFT OUTER JOIN TMP_SPFIRA AS SP
				ON TMP.Idcreditofira = SP.CreditoIDFIRA SET
			TMP.AplicaCont = SP.AplicaCont;

        -- Se identifica el tipo de Garantia
         UPDATE TMPFIRASPCOMERCIAL AS TMP INNER JOIN
			CREDITOS AS CRED ON TMP.CreditoID = CRED.CreditoID LEFT JOIN
			GRUPOSCREDITO AS GRU ON CRED.GrupoID=GRU.GrupoID  SET
			TMP.TipoGarantiaFIRAID = CRED.TipoGarantiaFIRAID,
			TMP.TipoOperaAgro = GRU.TipoOperaAgro;
    END IF;

    IF (Par_Tipo = TipoReporteNoFira) THEN
		TRUNCATE TMPFIRASPCOMERCIAL;

		/* Se insertan los registros de toda la Cartera sin contar los Creditos
			que se reportaron en el Reporte de SP COMERCIAL FIRA */
		INSERT INTO TMPFIRASPCOMERCIAL(
					NumeroID,	Idacredifnb,		ClienteID,		CreditoID,			EsAgro,		AplicaCont)
		SELECT 	Entero_Cero,	CRE.ClienteID,	CRE.ClienteID,			CRE.CreditoID,		CRE.EsAgropecuario, Con_NO
		FROM CREDITOS CRE
			INNER JOIN SALDOSCREDITOS SAL ON CRE.CreditoID=SAL.CreditoID
            INNER JOIN CLIENTES CLI ON CLI.ClienteID = CRE.ClienteID
				WHERE CRE.CreditoID NOT IN (SELECT CreditoID FROM TMP_SPFIRA)
				AND SAL.FechaCorte= Par_Fecha
				AND SAL.EstatusCredito IN (Est_Vigente,Est_Vencido);

		UPDATE TMPFIRASPCOMERCIAL TMP
			INNER JOIN BITACORAAPLIGAR GAR ON TMP.CreditoID = GAR.CreditoID
		SET
			AplicaCont = Con_SI
		WHERE FechaAplica <= Par_Fecha;

		/* A peticion de CONSOL no deben de reportar los siguientes Creditos */
		DELETE FROM TMPFIRASPCOMERCIAL
		WHERE  CreditoID IN(200003021, 200003055,  200003063, 200003110);

    END IF;

    	/*COL5
		 * RFC_ACREDITADO
		 * RFC del acreditado.
		 * Para los créditos con garantía FIRA: Este campo será aplicable solo en los casos de operaciones globales y
		 * deberá ser el mismo con el que se hizo la consulta del acreditado a la SIC mencionada en el anexo 1.
		 * Para los créditos sin garantía FIRA: Este campo es aplicable en todos los casos y deberá ser el mismo con el
		 * que se hizo la consulta del acreditado a la SIC mencionada en el anexo 1.*/
		/*COL6
		 * NOM_ACREDITADO
		 * Nombre del acreditado de acuerdo a lo registrado en los sistemas del IFNB.
		 * Para los créditos con garantía FIRA: Este campo será aplicable solo en los casos de operaciones globales.
		 * Para los créditos sin garantía FIRA: No aplica.*/
		/*COL7
		 * ID_ACRED_IFNB
		 * Número identificador del acreditado en las bases de datos del IFNB. Para los créditos con garantía FIRA: Este campo será aplicable
		 * solo en los casos de operaciones globales. Para los créditos sin garantía FIRA: Campo aplicable en todos los casos.*/

		UPDATE TMPFIRASPCOMERCIAL AS TMP INNER JOIN
			CLIENTES AS CTE ON TMP.ClienteID = CTE.ClienteID SET
			TMP.Rfcacreditado = CTE.RFCOficial,
			TMP.Nomacreditado = TRIM(CTE.NombreCompleto),
			TMP.Idacredifnb = CTE.ClienteID;

        /*COL8
		 * SUBORDINADO
		 * Indicar si es un crédito subordinado y en el caso de créditos sindicados indicar si contractualmente se encuentran subordinados
		 * respecto de otros acreedores en la prelación de pago: 1 = Si es subordinado
		 * 2 = No es subordinado.*/

		UPDATE TMPFIRASPCOMERCIAL AS TMP SET
			TMP.Subordinado = 2;

        /*COL9
		 * SP_100
		 * En caso de que al cierre del mes reportado el crédito ya presente atraso en el pago del monto exigible en los términos pactados
		 * originalmente con el IFNB, indicar los meses de atraso del crédito.*/

		-- Si se Aplico o No la Garantia se toma el Saldo del Credito es decir el valor de dias de atraso de la Cartera Activa
        UPDATE TMPFIRASPCOMERCIAL AS TMP
			LEFT JOIN SALDOSCREDITOS SAL
				ON TMP.CreditoID=SAL.CreditoID
		SET
			TMP.Sp100 = CASE
                        WHEN SAL.DiasAtraso > Entero_Cero THEN ROUND((SAL.DiasAtraso)/30,Num_3)
                        ELSE Entero_Cero END -- Cartera Agro y Activa con Aplicacion de Garantia No Pagadas
        WHERE SAL.FechaCorte = Par_Fecha;

        /*COL10
		 * GARANTIA_RF
		 * Indicar si el crédito cuenta con garantía real financiera admisible por FIRA de acuerdo a lo establecido en el inciso e) de este anexo:
		 * 1 = Cuenta con garantías reales financieras
		 * 2 = No cuenta con garantías reales financieras.*/
         /*COL11
		 * NUM_GRF
		 * En caso de que la variable GARANTIA_RF = 1, indicar con cuantas garantías reales financieras cuenta el crédito.
		 * Nota: Este campo no es aplicable para los créditos sin garantía FIRA.*/

		/*COL18
		 * VALOR_CONTABLE_GRF1
		 * Valor contable de la garantía real financiera (GRF) cuando es dinero en efectivo. En pesos. En caso de ser más de una
		 * GRF, se sumará el valor contable de las garantías de este tipo en su conjunto. */
		SET Var_FechaCorte := (SELECT MAX(Fecha)
									FROM `HIS-CUENTASAHO`
									WHERE  Fecha BETWEEN Var_FechaInicio AND Par_Fecha);
        DROP TABLE IF EXISTS TMPCTASALDOBLOQ;
        CREATE TABLE TMPCTASALDOBLOQ(
            CreditoID			BIGINT(12),
            CuentaAhoID			BIGINT(12),
            SaldoBloq			DECIMAL(12,2)
        );

        CREATE INDEX idx_TMPCTASALDOBLOQ_1 ON TMPCTASALDOBLOQ(CreditoID);
	    CREATE INDEX idx_TMPCTASALDOBLOQ_2 ON TMPCTASALDOBLOQ(CuentaAhoID);

		INSERT INTO TMPCTASALDOBLOQ
		SELECT CRE.CreditoID, CUE.CuentaAhoID, CUE.SaldoBloq
		FROM TMPFIRASPCOMERCIAL TMP
			INNER JOIN CREDITOS CRE  ON CRE.CreditoID = TMP.CreditoID
			INNER JOIN `HIS-CUENTASAHO` CUE ON CRE.CuentaID = CUE.CuentaAhoID
			WHERE CUE.Fecha = Var_FechaCorte AND CUE.SaldoBloq > 0;

		DROP TABLE IF EXISTS TMPGARANTIARF;
        CREATE TABLE TMPGARANTIARF(
            CreditoID			BIGINT(12),
            CuentaAhoID			BIGINT(12),
            SaldoBloq			DECIMAL(12,2)
        );

		CREATE INDEX idx_TMPGARANTIARF_1 ON TMPGARANTIARF(CreditoID);
	    CREATE INDEX idx_TMPGARANTIARF_2 ON TMPGARANTIARF(CuentaAhoID);

		-- Se insertan los registros de Bloqueos Vigentes
		INSERT INTO TMPGARANTIARF
		SELECT BLOQ.Referencia, MAX(BLOQ.CuentaAhoID), MAX(BLOQ.MontoBloq)
		FROM BLOQUEOS BLOQ
			INNER JOIN TMPCTASALDOBLOQ TMP ON BLOQ.Referencia = TMP.CreditoID
		WHERE BLOQ.TiposBloqID = 8 AND BLOQ.NatMovimiento = 'B' AND  BLOQ.FolioBloq = 0
		GROUP BY BLOQ.Referencia;

		-- Se insertan los registros de Bloqueos que se hayan echo posterior al mes de corte
		INSERT INTO TMPGARANTIARF
		SELECT BLOQ.Referencia, MAX(BLOQ.CuentaAhoID), MAX(BLOQ.MontoBloq)
		FROM BLOQUEOS BLOQ
			INNER JOIN TMPCTASALDOBLOQ TMP ON BLOQ.Referencia = TMP.CreditoID
		WHERE BLOQ.TiposBloqID = 8 AND BLOQ.NatMovimiento = 'D' AND BLOQ.FechaMov > Par_Fecha
			 -- AND BLOQ.Referencia NOT IN (SELECT Referencia FROM TMPGARANTIARF)
		GROUP BY BLOQ.Referencia;

		UPDATE TMPFIRASPCOMERCIAL AS TMP
		LEFT JOIN TMPGARANTIARF AS BLOQ ON TMP.CreditoID = BLOQ.CreditoID SET
			TMP.Garantiarf = CASE
                                WHEN BLOQ.SaldoBloq > Entero_Cero THEN Num_1
                                ELSE Num_2 END,  -- COL 10
            TMP.Numgrf = CASE
                                WHEN BLOQ.SaldoBloq > Entero_Cero THEN Num_1
                                ELSE Entero_Cero END,
			TMP.Valorcontablegrf1 = CASE
								WHEN BLOQ.SaldoBloq > Entero_Cero THEN ROUND(BLOQ.SaldoBloq,Num_3)
								ELSE Entero_Cero END;  -- COL 11


        /*COL12
		 * GARANTIA_RNF
		 * Indicar si el crédito cuenta con garantía real no financiera admisible por FIRA de acuerdo a lo establecido en el inciso f) de este anexo:
		 * 1 = Cuenta con garantías reales no financieras
		 * 2 = No cuenta con garantías reales no financieras.*/
		/*COL13
		 * NUM_GRNF
		 * En caso de que la variable GARANTIA_RNF = 1, indicar con cuantas garantías reales no financieras cuenta el crédito.
		 * Nota: Este campo no es aplicable para los créditos sin garantía FIRA.*/
		DROP TABLE IF EXISTS TMPFIRASPGARANTIASNF;
		CREATE TEMPORARY TABLE TMPFIRASPGARANTIASNF
			SELECT CRE.CreditoID, COUNT(ASI.GarantiaID) as NGarantias
	    	FROM ASIGNAGARANTIAS AS ASI
			    INNER JOIN CREDITOS AS CRE ON ASI.CreditoID  = CRE.CreditoID
				INNER JOIN GARANTIAS AS GAR ON ASI.GarantiaID = GAR.GarantiaID
			WHERE ASI.Estatus='U'  AND CRE.Estatus  NOT IN (Est_Cancelado,Est_Castigado)
			GROUP BY CRE.CreditoID;

		UPDATE TMPFIRASPCOMERCIAL AS TMP
			LEFT JOIN TMPFIRASPGARANTIASNF AS GAR
				ON TMP.CreditoID = GAR.CreditoID
			SET
				 TMP.Garantiarnf = CASE
                                WHEN IFNULL(GAR.NGarantias,Entero_Cero)>Entero_Cero THEN Num_1
                                ELSE Num_2 END,  -- COL 12
            	TMP.Numgrnf = CASE
                                WHEN IFNULL(GAR.NGarantias,Entero_Cero)>Entero_Cero THEN GAR.NGarantias
                                ELSE Entero_Cero END;  -- COL 13

		/*COL14
		 * GARANTIA_P
		 * Indicar si el crédito cuenta con garantía personal distinta de FIRA en cualquiera de sus modalidades de acuerdo a lo establecido en el inciso g) de este anexo:
		 * 1 = Cuenta con garantías personales
		 * 2 = No cuenta con garantías personales.*/
		/*COL15
		 * NUM_GP
		 * En caso de que la variable GARANTIA_P = 1, indicar con cuantas garantías personales cuenta el crédito.
		 * Nota: Este campo no es aplicable para los créditos sin garantía FIRA.*/

		UPDATE TMPFIRASPCOMERCIAL AS TMP SET
			TMP.Garantiap = Num_2,	-- COL14
			TMP.Numgp = Entero_Cero; -- COL15

        /*COL16
		 * SALDO_INSOLUTO
		 * Indicar el saldo insoluto del crédito al cierre del mes reportado, el cual representa el monto de crédito efectivamente
		 * otorgado al acreditado, ajustado por los intereses devengados, menos los pagos de principal e intereses, así como las
		 * quitas, condonaciones, bonificaciones y descuentos que se hubieren otorgado. En todo caso, dicho saldo no deberá incluir
		 * los intereses devengados no cobrados reconocidos en cuentas de orden dentro del balance, de créditos que estén en cartera
		 * vencida.*/

        DROP TABLE IF EXISTS TMPSALDOFIRA;
        CREATE TEMPORARY TABLE TMPSALDOFIRA
		SELECT TMP.CreditoID, IFNULL(SUM(
                SalCapVigente+		SalCapAtrasado+		SalCapVencido+ 		SalCapVenNoExi+
                SalIntOrdinario+	SalIntAtrasado+		SalIntVencido+ 		SalIntProvision),0) AS SaldoTotal
        FROM TMPFIRASPCOMERCIAL TMP
            LEFT OUTER JOIN SALDOSCREDITOS SAL
                ON TMP.CreditoID=SAL.CreditoID
                AND FechaCorte=Par_Fecha
        GROUP BY TMP.CreditoID;

        UPDATE TMPFIRASPCOMERCIAL TMP
            INNER JOIN TMPSALDOFIRA SAL
                ON TMP.CreditoID=SAL.CreditoID
        SET
            TMP.Saldoinsoluto = ROUND(SAL.SaldoTotal, Num_3);

		IF(Par_Tipo=TipoReporteFira)THEN
		/* Caso especial para CONSOL se deben de reportar los CreditoIDFIRA 1417870, 1527648, 1587422,  1620623 */
			DROP TABLE IF EXISTS TMPSALDOFIRAQUEMADOS;
			CREATE TEMPORARY TABLE TMPSALDOFIRAQUEMADOS
			SELECT TMP.Idcreditofira, SUM(
						SalCapVigente+		SalCapAtrasado+		SalCapVencido+ 		SalCapVenNoExi+
						SalIntOrdinario+	SalIntAtrasado+		SalIntVencido+ 		SalIntProvision+
						SalIntNoConta) AS SaldoTotal
				FROM TMPFIRASPCOMERCIAL TMP
					INNER JOIN CREDITOS CRE
						ON CRE.CreditoIDFIRA = TMP.Idcreditofira
					INNER JOIN SALDOSCREDITOS SAL
						ON CRE.CreditoID=SAL.CreditoID
						AND FechaCorte=Par_Fecha
				WHERE CreditoIDFIRA  IN (1417870, 1527648, 1587422,  1620623)
				GROUP BY TMP.Idcreditofira;

			UPDATE TMPFIRASPCOMERCIAL TMP
				INNER JOIN TMPSALDOFIRAQUEMADOS SAL ON TMP.Idcreditofira=SAL.Idcreditofira
			SET
				TMP.Saldoinsoluto = SAL.SaldoTotal;

        END IF;
        /*COL17
		 * TIPO_GRF
		 * Indicar con qué tipo de garantía real financiera cuenta el IFNB de acuerdo a las garantías admisibles por FIRA:
		 * 1 = Dinero en efectivo
		 * 2 = Valores o medios de pago con vencimiento menor a 7 días a favor del IFNB.
		 * 3 = Ambas (1 y 2).*/

		UPDATE TMPFIRASPCOMERCIAL AS TMP SET
			TMP.Tipogrf = CASE
                                WHEN TMP.Garantiarf = Num_1 THEN Num_1
								WHEN TMP.Garantiarf = Num_2 THEN Entero_Cero
                                ELSE Entero_Cero END;

       /*COL19
		 * VALOR_CONTABLE_GRF2
		 * Valor contable de las garantías reales financieras (GRF) cuando son valores o medios de pago con vencimiento menor
		 * a 7 días a favor del IFNB. En pesos. En caso de ser más de una GRF, se sumará el valor contable de las garantías de
		 * este tipo en su conjunto.*/
		UPDATE TMPFIRASPCOMERCIAL AS TMP SET
			TMP.Valorcontablegrf2 = Entero_Cero;

        /*COL20
		 * Hfx_GRF1
		 * Indicar si la moneda de las garantías reales financieras cuando es dinero en efectivo es la misma que la del saldo
		 * insoluto del crédito:
		 * 1 = Es la misma moneda
		 * 2 = Están en monedas diferentes.*/

		/*COL21
		 * Hfx_GRF2
		 * Indicar si la moneda de la garantías reales financieras cuando son valores o medios de pago con vencimiento menor a 7 días a favor del IFNB es la misma que la del saldo insoluto del crédito:
		 * 1 = Es la misma moneda
		 * 2 = Están en monedas diferentes.*/

		/*COL22
		 * FACTOR_AJUSTE
		 * Si la garantía real financiera es un valor ó medio de pago con vencimiento menor a 7 días indicar si es Soberano o si fue emitido por Otros emisores distintos al soberano:
		 * 1 = Emisor soberano
		 * 2 = Emisor no soberano.*/
		UPDATE TMPFIRASPCOMERCIAL AS TMP SET
			TMP.Hfxgrf1 = IF(TMP.Garantiarf = Num_1 AND TMP.Tipogrf = Num_1,Num_1,Entero_Cero),
			TMP.Hfxgrf2 = IF(TMP.Garantiarf = Num_1 AND TMP.Tipogrf = Num_2,Num_1,Entero_Cero),
			TMP.Factorajuste = Entero_Cero;

        /*COL23
		 * TIPO_GRNF
		 * Indicar qué tipo de garantías reales no financieras tiene el IFNB de acuerdo a las garantías admisibles por FIRA:
		 * 1 = Solo Bienes inmuebles comerciales o residenciales
		 * 2 = Solo Bienes muebles.
		 * 3 = Solo otras garantías previstas en el Artículo 32 del Reglamento del Registro Público de Comercio vigente.
		 * 4 = 1 y 2.
		 * 5 = 1 y 3.
		 * 6 = 2 y 3.
		 * 7 = Todas (1, 2 y 3).*/

		DROP TABLE IF EXISTS TMPTIPOGARANTIAS;
		CREATE TEMPORARY TABLE TMPTIPOGARANTIAS
		SELECT  CRE.CreditoID, GAR.TipoGarantiaID AS TipoGarantia
			    FROM ASIGNAGARANTIAS AS ASI
			    INNER JOIN CREDITOS AS CRE ON ASI.CreditoID  = CRE.CreditoID
				INNER JOIN GARANTIAS AS GAR ON ASI.GarantiaID = GAR.GarantiaID
				WHERE ASI.Estatus='U'  AND CRE.Estatus  NOT IN (Est_Cancelado,Est_Castigado);


		DROP TABLE IF EXISTS TMPTIPOGARANTIAS2;
		CREATE TEMPORARY TABLE TMPTIPOGARANTIAS2
			SELECT CreditoID, GROUP_CONCAT(DISTINCT (TipoGarantia)) AS TipoGarantia
			FROM TMPTIPOGARANTIAS
			GROUP BY CreditoID;

		UPDATE TMPFIRASPCOMERCIAL AS TMP
			LEFT JOIN TMPTIPOGARANTIAS2 AS TGAR
			ON TMP.CreditoID = TGAR.CreditoID
		SET TMP.Tipogrnf =
			CASE
				WHEN (FIND_IN_SET('2',TipoGarantia) > Entero_Cero AND FIND_IN_SET('3',TipoGarantia) > Entero_Cero) THEN Num_4
				WHEN (FIND_IN_SET('3',TipoGarantia) > Entero_Cero) THEN Num_1
				WHEN (FIND_IN_SET('2',TipoGarantia) > Entero_Cero) THEN Num_2
			ELSE Entero_Cero
			END;

        /*COL24
		* GARANTIA_ART32
		* En caso de haber contestado “3”, “5”, “6” o “7” en la variable anterior (TIPO_GRNF)
        * indicar con cual garantía prevista en el Artículo 32 del Reglamento del Registro Público de Comercio vigente cuenta el crédito (nombrarla).*/

        UPDATE TMPFIRASPCOMERCIAL AS TMP SET
			TMP.Garantiaart32 = Entero_Cero;

        /*COL25
		 * VALOR_GARANTIA_GRNF1
		 * Valor del bien inmueble, el cual deberá corresponder a la última valuación disponible de dicha garantía. Deberá considerarse un valor que no exceda el valor razonable corriente de la garantía en los términos del anexo 24 de la CUB. En pesos. En caso de ser más de un bien inmueble, se sumará el valor de las garantías de todos los bienes en su conjunto.*/
		/*COL26
		 * VALOR_GARANTÍA_GRNF2
		 * Valor del bien mueble, el cual deberá corresponder a la última valuación disponible de dicha garantía. Deberá considerarse un valor que no exceda el valor razonable corriente de la garantía en los términos del anexo 24 de la CUB. En pesos. En caso de ser más de un bien mueble, se sumará el valor de las garantías de este tipo en su conjunto.*/
		/*COL27
		 * VALOR_GARANTÍA_GRNF3
		 * Valor de garantía prevista en el Artículo 32 del Reglamento del Registro Público de Comercio vigente, el cual deberá corresponder a la última valuación disponible de dicha garantía. Deberá considerarse un valor que no exceda el valor razonable corriente de la garantía en los términos del anexo 24 de la CUB. En pesos. En caso de ser más de una garantía del Artículo 32, se sumará el valor de las garantas de este tipo en su conjunto.*/

        DROP TABLE IF EXISTS TMPFIRAVALORGARANTIAS;
		CREATE TEMPORARY TABLE TMPFIRAVALORGARANTIAS
		SELECT CRE.CreditoID, GAR.TipoGarantiaID AS TipoGarantia, sum(ASI.MontoAsignado) AS ValorGar
            FROM ASIGNAGARANTIAS AS ASI
            INNER JOIN CREDITOS AS CRE ON ASI.CreditoID  = CRE.CreditoID
            INNER JOIN GARANTIAS AS GAR ON ASI.GarantiaID = GAR.GarantiaID
            WHERE ASI.Estatus='U'  AND CRE.Estatus  NOT IN (Est_Cancelado,Est_Castigado)
            GROUP BY CRE.CreditoID, GAR.TipoGarantiaID ;

		DROP TABLE IF EXISTS TMPFIRAVALORGARSUM;
		CREATE TEMPORARY TABLE TMPFIRAVALORGARSUM
        SELECT CreditoID, TipoGarantia, SUM(ValorGar) AS ValorGar
            FROM TMPFIRAVALORGARANTIAS
            GROUP BY CreditoID, TipoGarantia;


        UPDATE TMPFIRASPCOMERCIAL AS TMP
        LEFT OUTER JOIN TMPFIRAVALORGARSUM GAR ON TMP.CreditoID = GAR.CreditoID SET
            TMP.Valorgarantiagrnf1 = ROUND(GAR.ValorGar,Num_3) -- COL 25
        WHERE GAR.TipoGarantia=Num_3;

        UPDATE TMPFIRASPCOMERCIAL AS TMP
        LEFT OUTER JOIN TMPFIRAVALORGARSUM GAR ON TMP.CreditoID = GAR.CreditoID SET
            TMP.Valorgarantiagrnf2 = ROUND(GAR.ValorGar,Num_3) -- COL 26
        WHERE GAR.TipoGarantia=Num_2;

        UPDATE TMPFIRASPCOMERCIAL AS TMP SET
			TMP.Valorgarantiagrnf3 = Entero_Cero; -- COL 27

        /* El IFNB debe enviar la siguiente información para los créditos cubiertos por alguna garantía personal
			distinta a FIRA.
			Se Reporta 0 ya que las garantias que amparan al crédito no estan dentro de las garantias
			que son adminisbles por FIRA como Garantia Personal
			* COL 28, 29, 30, 31, 32, 33, 34, 35, 36, 37 * */

		UPDATE TMPFIRASPCOMERCIAL AS TMP SET
			TMP.Porccubgp1 = Entero_Cero,
			TMP.Nomgarante1 = Entero_Cero,
			TMP.Rfcgarante1 = Entero_Cero,
			TMP.Tipogarante1 = Entero_Cero,
			TMP.Monedagp1 = Entero_Cero,
			TMP.Porccubgp2 = Entero_Cero,
			TMP.Nomgarante2 = Entero_Cero,
			TMP.Rfcgarante2 = Entero_Cero,
			TMP.Tipogarante2 = Entero_Cero,
			TMP.Monedagp2 = Entero_Cero;

        /*El IFNB debe enviar la siguiente información para los créditos cubiertos por garantía de Paso y Medida
			o de cobertura a Segundas Pérdidas cuando el garante es distinto a FIRA en todas sus modalidades
			Se Reportar 0 ya que  actualmente los créditos no estan amparados por este tipo de garantias
			COL 38, 39, 40, 41*/

		UPDATE TMPFIRASPCOMERCIAL AS TMP SET
			TMP.Nomgarantepm = Entero_Cero,
			TMP.Nomgarantesp = Entero_Cero,
			TMP.Porccubpm = Entero_Cero,
			TMP.Porccubsp = Entero_Cero;

		-- Seccion de Campos Especiales para el Rerporte de Tipo de Reporte NO FIRA
		-- Actualmente los créditos no estan amparados por este tipo de garantias
		UPDATE TMPFIRASPCOMERCIAL AS TMP SET
			RfcGarantePM = Entero_Cero,
			RfcGarantePP = Entero_Cero,
			IDPortafolioPP = Entero_Cero,
			MontoPortafolioPP = Entero_Cero,
			TipoGarantePM = Entero_Cero,
			TipoGarantePP = Entero_Cero,
			IDCreditoIFNB = CreditoID;

		UPDATE TMPFIRASPCOMERCIAL AS TMP
			LEFT JOIN SALDOSCREDITOS SAL
				ON TMP.CreditoID=SAL.CreditoID
		SET
			TMP.STCredito = CASE
                        WHEN SAL.EstatusCredito = Est_Vigente THEN 'VI' -- VIGENTE
						WHEN SAL.EstatusCredito = Est_Vencido THEN 'VE'	-- VENCIDO
                        ELSE 'VI' END
        WHERE SAL.FechaCorte = Par_Fecha AND TMP.AplicaCont = Con_NO;

		-- Si existe una Aplicacion de Garantia el Estatus del Credito debe de ser Vencido
		UPDATE TMPFIRASPCOMERCIAL AS TMP
		SET
			TMP.STCredito = 'VE'
        WHERE TMP.AplicaCont = Con_SI;

		IF(Par_Tipo = TipoReporteFira)THEN
			-- SELECT PARA REALIZAR EL PROCESO DE SP COMERCIAL
			SELECT * FROM
			(SELECT CONCAT_WS(',',
			'NUM_CONTROL',
			'ID_CREDITO_FIRA',
			'ID_ACREDITADO_FIRA',
			'NOM_ACREDITADO_FIRA',
			'RFC_ACREDITADO',
			'NOM_ACREDITADO',
			'ID_ACRED_IFNB',
			'SUBORDINADO',
			'SP_100',
			'GARANTIA_RF',
			'NUM_GRF',
			'GARANTIA_RNF',
			'NUM_GRNF',
			'GARANTIA_P',
			'NUM_GP',
			'SALDO_INSOLUTO',
			'TIPO_GRF',
			'VALOR_CONTABLE_GRF1',
			'VALOR_CONTABLE_GRF2',
			'Hfx_GRF1',
			'Hfx_GRF2',
			'FACTOR_AJUSTE',
			'TIPO_GRNF',
			'GARANTIA_ART32',
			'VALOR_GARANTIA_GRNF1',
			'VALOR_GARANTIA_GRNF2',
			'VALOR_GARANTIA_GRNF3',
			'PORC_CUB_GP1',
			'NOM_GARANTE1',
			'RFC_GARANTE1',
			'TIPO_GARANTE1',
			'MONEDA_GP1',
			'PORC_CUB_GP2',
			'NOM_GARANTE2',
			'RFC_GARANTE2',
			'TIPO_GARANTE2',
			'MONEDA_GP2',
			'NOM_GARANTE_PM',
			'NOM_GARANTE_SP',
			'PORC_CUB_PM',
			'PORC_CUB_SP') as Resultado
			UNION
			SELECT
			CONCAT_WS(',',
				IFNULL(Numcontrol,'0'),
				IFNULL(Idcreditofira,'0'),
				IFNULL(Idacreditadofira,'0'),
				IFNULL(REPLACE(Nomacreditadofira,',',''),'0'),
				IFNULL(Rfcacreditado,0),
				IFNULL(REPLACE(Nomacreditado,',',''),0),
				LPAD(IFNULL(ClienteID,0),11,'0'),
				IFNULL(Subordinado,0),
				IFNULL(Sp100,0),
				IFNULL(Garantiarf,0),
				IFNULL(Numgrf,0),
				IFNULL(Garantiarnf,0),
				IFNULL(Numgrnf,0),
				IFNULL(Garantiap,0),
				IFNULL(Numgp,0),
				IFNULL(Saldoinsoluto,0),
				IFNULL(Tipogrf,0),
				IFNULL(Valorcontablegrf1,0),
				IFNULL(Valorcontablegrf2,0),
				IFNULL(Hfxgrf1,0),
				IFNULL(Hfxgrf2,0),
				IFNULL(Factorajuste,0),
				IFNULL(Tipogrnf,0),
				IFNULL(Garantiaart32,0),
				IFNULL(Valorgarantiagrnf1,0),
				IFNULL(Valorgarantiagrnf2,0),
				IFNULL(Valorgarantiagrnf3,0),
				IFNULL(Porccubgp1,0),
				IFNULL(Nomgarante1,'0'),
				IFNULL(Rfcgarante1,'0'),
				IFNULL(Tipogarante1,0),
				IFNULL(Monedagp1,0),
				IFNULL(Porccubgp2,0),
				IFNULL(Nomgarante2,'0'),
				IFNULL(Rfcgarante2,'0'),
				IFNULL(Tipogarante2,0),
				IFNULL(Monedagp2,0),
				IFNULL(Nomgarantepm,'0'),
				IFNULL(Nomgarantesp,'0'),
				IFNULL(Porccubpm,0),
				IFNULL(Porccubsp,0)) as Resultado
			FROM TMPFIRASPCOMERCIAL AS TMP ) AS Resultado;
		ELSE
			-- SELECT PARA REALIZAR EL PROCESO DE SP COMERCIAL NO FIRA
			SELECT * FROM
			(SELECT CONCAT_WS(',',
			'NUM_CONTROL',
			'ID_CREDITO_FIRA',
			'ID_ACREDITADO_FIRA',
			'NOM_ACREDITADO_FIRA',
			'RFC_ACREDITADO',
			'NOM_ACREDITADO',
			'ID_ACRED_IFNB',
			'SUBORDINADO',
			'SP_100',
			'GARANTIA_RF',
			'NUM_GRF',
			'GARANTIA_RNF',
			'NUM_GRNF',
			'GARANTIA_P',
			'NUM_GP',
			'SALDO_INSOLUTO',
			'TIPO_GRF',
			'VALOR_CONTABLE_GRF1',
			'VALOR_CONTABLE_GRF2',
			'Hfx_GRF1',
			'Hfx_GRF2',
			'FACTOR_AJUSTE',
			'TIPO_GRNF',
			'GARANTIA_ART32',
			'VALOR_GARANTIA_GRNF1',
			'VALOR_GARANTIA_GRNF2',
			'VALOR_GARANTIA_GRNF3',
			'PORC_CUB_GP1',
			'NOM_GARANTE1',
			'RFC_GARANTE1',
			'TIPO_GARANTE1',
			'MONEDA_GP1',
			'PORC_CUB_GP2',
			'NOM_GARANTE2',
			'RFC_GARANTE2',
			'TIPO_GARANTE2',
			'MONEDA_GP2',
			'NOM_GARANTE_PM',
			'NOM_GARANTE_PP',
			'PORC_CUB_PM',
			'PORC_CUB_PP',
			'RFC_GARANTE_PM',
			'RFC_GARANTE_PP',
			'ID_PORTAFOLIO_PP',
			'MONTO_PORTAFOLIO_PP',
			'TIPO_GARANTE_PM',
			'TIPO_GARANTE_PP',
			'ID_CREDITO_IFNB',
			'ST_CREDITO'
			) as Resultado
			UNION
			SELECT
			CONCAT_WS(',',
			IFNULL(Numcontrol,'0'),
				IFNULL(Idcreditofira,'0'),
				IFNULL(Idacreditadofira,'0'),
				IFNULL(REPLACE(Nomacreditadofira,',',''),'0'),
				IFNULL(Rfcacreditado,0),
				IFNULL(REPLACE(Nomacreditado,',',''),0),
				LPAD(IFNULL(ClienteID,0),11,'0'),
				IFNULL(Subordinado,0),
				IFNULL(Sp100,0),
				IFNULL(Garantiarf,0),
				IFNULL(Numgrf,0),
				IFNULL(Garantiarnf,0),
				IFNULL(Numgrnf,0),
				IFNULL(Garantiap,0),
				IFNULL(Numgp,0),
				IFNULL(Saldoinsoluto,0),
				IFNULL(Tipogrf,0),
				IFNULL(Valorcontablegrf1,0),
				IFNULL(Valorcontablegrf2,0),
				IFNULL(Hfxgrf1,0),
				IFNULL(Hfxgrf2,0),
				IFNULL(Factorajuste,0),
				IFNULL(Tipogrnf,0),
				IFNULL(Garantiaart32,0),
				IFNULL(Valorgarantiagrnf1,0),
				IFNULL(Valorgarantiagrnf2,0),
				IFNULL(Valorgarantiagrnf3,0),
				IFNULL(Porccubgp1,0),
				IFNULL(Nomgarante1,'0'),
				IFNULL(Rfcgarante1,'0'),
				IFNULL(Tipogarante1,0),
				IFNULL(Monedagp1,0),
				IFNULL(Porccubgp2,0),
				IFNULL(Nomgarante2,'0'),
				IFNULL(Rfcgarante2,'0'),
				IFNULL(Tipogarante2,0),
				IFNULL(Monedagp2,0),
				IFNULL(Nomgarantepm,'0'),
				IFNULL(Nomgarantesp,'0'),
				IFNULL(Porccubpm,0),
				IFNULL(Porccubsp,0),
				IFNULL(RfcGarantePM,0),
				IFNULL(RfcGarantePP,0),
				IFNULL(IDPortafolioPP,0),
				IFNULL(MontoPortafolioPP,0),
				IFNULL(TipoGarantePM,0),
				IFNULL(TipoGarantePP,0),
				IFNULL(IDCreditoIFNB,0),
				IFNULL(STCredito,'VI')
				) as Resultado
			FROM TMPFIRASPCOMERCIAL AS TMP ) AS Resultado;

		END IF;

	END ManejoErrores;

	 IF(Par_Salida = SalidaSI) THEN
		SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen 		AS ErrMen,
				Var_Control 	AS control,
				Entero_Cero 	AS consecutivo;
	END IF;

END TerminaStore$$