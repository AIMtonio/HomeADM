-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDORESINTERNOFIRA010REP
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDORESINTERNOFIRA010REP`;
DELIMITER $$


CREATE PROCEDURE `EDORESINTERNOFIRA010REP`(
	/* REPORTE FINANCIERO DE ESTADO DE RESULTADOS PARA FIRA DEL CLIENTE CONSOL*/
	Par_Ejercicio					INT(11),		# Numero de Ejercicio
	Par_Periodo						INT(11),		# Numero de Periodo
	Par_Fecha						DATE,			# Fecha de la Consulta (Nesesario para el Tipo de Consulta por Fecha)
	Par_TipoConsulta				CHAR(1),		# Tipo de Consulta D: Por Fecha, P: Por Periodo F: Fin de Periodo
	Par_SaldosCero					CHAR(1),		# Permite cuentas con saldos en 0

	Par_Cifras						CHAR(1),		# Establece si se mostrara los saldos en formato de miles
	Par_CCInicial					INT(11),		# Centro de Costos Inicial
	Par_CCFinal						INT(11),		# Centro de Costos Final
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
  DECLARE For_ResulNeto     VARCHAR(500);
  DECLARE Var_CantCaracteres    INT;
  DECLARE Var_Columna       VARCHAR(20);
  DECLARE Var_CreateTable     VARCHAR(9000);
  DECLARE Var_DropTable     VARCHAR(5000);
  DECLARE Var_EjeCon        INT;
  DECLARE Var_EjercicioVig    INT;
  DECLARE Var_FecConsulta     DATE;
  DECLARE Var_FecFinPer     DATE;
  DECLARE Var_FecIniPer     DATE;
  DECLARE Var_FechaSaldos     DATE;
  DECLARE Var_FechaSistema    DATE;
  DECLARE Var_InsertTable     VARCHAR(5000);
  DECLARE Var_InsertValores   VARCHAR(5000);
  DECLARE Var_MaxCenCos     INT;
  DECLARE Var_MinCenCos     INT;
  DECLARE Var_Monto       DECIMAL(18,4);
  DECLARE Var_NombreTabla     VARCHAR(40);
  DECLARE Var_PerCon        INT;
  DECLARE Var_PeriodoVig      INT;
  DECLARE Var_SelectTable     VARCHAR(5000);
  DECLARE Var_Ubicacion     CHAR(1);
  DECLARE Var_ConceptoFinanID   INT(11);
  DECLARE Var_ConsecutivoID   INT(11);
  DECLARE Var_NombreCampo     VARCHAR(20);
  DECLARE Var_Saldo       DECIMAL(18,2);
  DECLARE Var_SaldoAcumulado    DECIMAL(18,2);
  DECLARE Var_EsCalculado     CHAR(1);
  DECLARE Var_TipoCalculo     CHAR(1);
  DECLARE Var_ConceptoFTemp   INT(11);
  DECLARE Var_ConsecID  INT(11);
  DECLARE For_CuentaContable  	VARCHAR(500);
  DECLARE Des_CuentaContable  	VARCHAR(300);
  DECLARE Var_SaldoCuenta  		DECIMAL(18,2);
  DECLARE Var_UltEjercicioCie INT;
  DECLARE Var_UltPeriodoCie INT;
  DECLARE Var_Registros 	INT(11);
  DECLARE Var_FinPer   DATE;

	-- Declaracion de constantes

  DECLARE Cadena_Vacia      CHAR(1);
  DECLARE Cifras_Miles      CHAR(1);
  DECLARE Cifras_Pesos      CHAR(1);
  DECLARE Entero_Cero       INT;
  DECLARE Fecha_Vacia       DATE;
  DECLARE No_SaldoCeros     CHAR(1);
  DECLARE NumCliente        INT;
  DECLARE Por_Fecha       CHAR(1);
  DECLARE Por_FinPeriodo      CHAR(1);
  DECLARE Por_Peridodo      CHAR(1);
  DECLARE TipoRepEdoResultados  INT;
  DECLARE TipoRepFira			INT;
  DECLARE Tip_Encabezado      CHAR(1);
  DECLARE Ubi_Actual        CHAR(1);
  DECLARE Ubi_Histor        CHAR(1);
  DECLARE VarAcreedora      CHAR(1);
  DECLARE VarDeudora        CHAR(1);
  DECLARE ConstanteSI       CHAR(1);
  DECLARE ConstanteNO       CHAR(1);
  DECLARE TipoSuma        CHAR(1);
  DECLARE TipoResta       CHAR(1);
  DECLARE Est_Cerrado	CHAR(1);

	-- Declaracion de constantes
  SET Cadena_Vacia        := '';
  SET Cifras_Miles        := 'M';
  SET Cifras_Pesos        := 'P';
  SET Entero_Cero         := 0;
  SET Fecha_Vacia         := '1900-01-01';
  SET No_SaldoCeros       := 'N';
  SET NumCliente          := 10;
  SET Por_Fecha         := 'D';
  SET Por_FinPeriodo        := 'F';
  SET Por_Peridodo        := 'P';
  SET TipoRepEdoResultados    := 9;
  SET TipoRepFira		:= 2;
  SET Tip_Encabezado        := 'E';
  SET Ubi_Actual          := 'A';
  SET Ubi_Histor          := 'H';
  SET VarAcreedora        := 'A';
  SET VarDeudora          := 'D';
  SET ConstanteSI         := 'S';
  SET ConstanteNO         := 'N';
  SET TipoSuma          := 'S';
  SET TipoResta         := 'R';
  SET Est_Cerrado   := 'C';


    DELETE FROM TMPCONTABLE
        WHERE NumeroTransaccion = Aud_NumTransaccion;

    DELETE FROM TMPBALANZACONTA
        WHERE NumeroTransaccion = Aud_NumTransaccion;

    TRUNCATE CONCEEDOSFINFIRA;
    SET Var_ConsecID := (SELECT COUNT(*) FROM CONCEEDOSFINFIRA
	  WHERE EstadoFinanID = TipoRepEdoResultados
		AND NumClien = NumCliente AND NumTransaccion = Aud_NumTransaccion);

    INSERT INTO CONCEEDOSFINFIRA
    SELECT EstadoFinanID, 	ConceptoFinanID, 	NumClien, 		Var_ConsecID,		Descripcion,
            Desplegado, 		CuentaContable, 	EsCalculado, 	Cadena_Vacia,		NombreCampo,
            Espacios, 			Negrita, 			Sombreado, 		CombinarCeldas,		CuentaFija,
            Presentacion, 		Tipo, 				Aud_NumTransaccion
    FROM CONCEPESTADOSFIN
    WHERE NumClien = NumCliente
        AND EstadoFinanID = TipoRepEdoResultados;

    SET Par_Fecha         := IFNULL(Par_Fecha, Fecha_Vacia);

    IF(Par_Fecha != Fecha_Vacia) THEN
        SET Var_FecConsulta := Par_Fecha;
    ELSE
        SELECT Fin INTO Var_FecConsulta
        FROM PERIODOCONTABLE
            WHERE EjercicioID   = Par_Ejercicio
            AND PeriodoID   = Par_Periodo;
    END IF;

    /*Validacion de los centros de costos*/
    SET Par_CCInicial   := IFNULL(Par_CCInicial, Entero_Cero);
    SET Par_CCFinal     := IFNULL(Par_CCFinal, Entero_Cero);

    SELECT MIN(CentroCostoID), MAX(CentroCostoID) INTO Var_MinCenCos, Var_MaxCenCos
    FROM CENTROCOSTOS;

    IF(Par_CCInicial = Entero_Cero OR Par_CCFinal = Entero_Cero) THEN
        SET Par_CCInicial   := Var_MinCenCos;
        SET Par_CCFinal     := Var_MaxCenCos;
    END IF;


    SELECT  MAX(EjercicioID),  MAX(Fin) INTO Var_UltEjercicioCie, Var_FinPer
    FROM PERIODOCONTABLE Per
    WHERE Per.Fin < Var_FecConsulta
      AND Per.Estatus = Est_Cerrado;

    SET Var_UltEjercicioCie    := IFNULL(Var_UltEjercicioCie, Entero_Cero);
    SET Var_FecIniPer := DATE_ADD(Var_FinPer,INTERVAL 1 DAY);


    IF(Var_UltEjercicioCie != Entero_Cero) THEN
        SELECT  MAX(PeriodoID) INTO Var_UltPeriodoCie
        FROM PERIODOCONTABLE Per
            WHERE Per.EjercicioID = Var_UltEjercicioCie
            AND Per.Estatus = Est_Cerrado
            AND Per.Fin < Var_FecConsulta;
    END IF;

    SET Var_UltPeriodoCie    := IFNULL(Var_UltPeriodoCie, Entero_Cero);

    IF (Par_TipoConsulta IN (Por_Fecha, Por_Peridodo)) THEN
        DELETE FROM TMPBALANZACONTAFIRA WHERE NumeroTransaccion = Aud_NumTransaccion;

        INSERT INTO TMPBALANZACONTAFIRA(
            NumeroTransaccion,  CuentaContable,   	Grupo,      		SaldoInicialDeu,	SaldoInicialAcre,
            Cargos,       		Abonos,       		SaldoDeudor,  		SaldoAcreedor,   	DescripcionCuenta,
            CuentaMayor,    	CentroCosto,    	ConsecutivoID)
        SELECT
            Aud_NumTransaccion, Con.NombreCampo, 	Cadena_Vacia,		Entero_Cero, 		Entero_Cero,
            Entero_Cero,		Entero_Cero,		SUM(Sal.SaldoFinal),Entero_Cero,		Cadena_Vacia,
            Cadena_Vacia,		Cadena_Vacia,		Entero_Cero
            FROM CONCEEDOSFINFIRA Con
                LEFT OUTER JOIN  SALDOSCONTABLES Sal
                    ON Sal.CuentaCompleta LIKE Con.CuentaContable
                    AND Con.EstadoFinanID = TipoRepEdoResultados
                    AND EsCalculado = ConstanteNO
            WHERE FechaCorte = LAST_DAY(Par_Fecha)
            GROUP BY Con.NombreCampo;

        INSERT INTO TMPBALANZACONTAFIRA(
            NumeroTransaccion,  CuentaContable,   	Grupo,      		SaldoInicialDeu,	SaldoInicialAcre,
            Cargos,       		Abonos,       		SaldoDeudor,  		SaldoAcreedor,   	DescripcionCuenta,
            CuentaMayor,    	CentroCosto,    	ConsecutivoID)
        SELECT
            Aud_NumTransaccion, NombreCampo, 		Cadena_Vacia,		Entero_Cero, 		Entero_Cero,
            Entero_Cero,		Entero_Cero,		Entero_Cero,		Entero_Cero,		Cadena_Vacia,
            Cadena_Vacia,		Cadena_Vacia,		Entero_Cero
		FROM CONCEEDOSFINFIRA
		WHERE CuentaContable = Cadena_Vacia;

        -- Se Insertan las Cuentas Contables que se requiere a realizar el Calculo
        DELETE FROM TMPFIRAESTADOSFIN
            WHERE NumTransaccion = Aud_NumTransaccion;

        SET @conta := Entero_Cero;
        INSERT INTO TMPFIRAESTADOSFIN (
            ConsecutivoID,		ConceptoFinanID,		CuentaContable,			NombreCampo,		NumTransaccion)
        SELECT
        (@conta := @conta+1),		ConceptoFinanID,  		CuentaContable, NombreCampo, Aud_NumTransaccion
        FROM CONCEEDOSFINFIRA
        WHERE	EstadoFinanID = TipoRepEdoResultados
            AND NumClien = NumCliente
            AND EsCalculado = ConstanteSI
        ORDER BY ConceptoFinanID;

        SELECT COUNT(*)
        INTO Var_Registros
        FROM TMPFIRAESTADOSFIN
        WHERE NumTransaccion = Aud_NumTransaccion;

        SELECT MAX(FechaCorte)
        INTO Var_FechaSaldos
        FROM SALDOSCONTABLES;

        IF(LAST_DAY(Par_Fecha) > Var_FechaSaldos) THEN
            SET Var_Ubicacion := Ubi_Actual; -- Ubicacion Actual
        ELSE
            SET Var_Ubicacion := Ubi_Histor; -- Ubicacion Historica
        END IF;

        SET @ContaFIRA := 1;
        WHILE (@ContaFIRA <= Var_Registros) DO

            SET For_CuentaContable := Cadena_Vacia;
            SET Des_CuentaContable := Cadena_Vacia;
            SET Var_SaldoCuenta := Entero_Cero;

            SELECT CuentaContable,		NombreCampo
            INTO For_CuentaContable,  	Des_CuentaContable
            FROM TMPFIRAESTADOSFIN
            WHERE ConsecutivoID = @ContaFIRA
                AND NumTransaccion = Aud_NumTransaccion;


            CALL `EVALFORMULACONTAPRO`(
            For_CuentaContable,	Var_Ubicacion,        Par_TipoConsulta,         LAST_DAY(Par_Fecha),        Var_UltEjercicioCie,
            Var_UltPeriodoCie,  Var_FecIniPer,        Var_SaldoCuenta,   		Par_CCInicial,              Par_CCFinal,
            Entero_Cero,      	Aud_Usuario,          Aud_FechaActual,      	Aud_DireccionIP,            Aud_ProgramaID,
            Aud_Sucursal,       Aud_NumTransaccion
            );

            INSERT TMPBALANZACONTAFIRA (
                NumeroTransaccion,  CuentaContable,     Grupo,          	SaldoInicialDeu,  	SaldoInicialAcre,
                Cargos,           	Abonos,           	SaldoDeudor,    	SaldoAcreedor,    	DescripcionCuenta,
                CuentaMayor,     	 CentroCosto,      ConsecutivoID)
            VALUES(
                Aud_NumTransaccion, Des_CuentaContable,     Cadena_Vacia,   	Entero_Cero,      	Entero_Cero,
                Entero_Cero,    	Entero_Cero,        	Var_SaldoCuenta,    Entero_Cero,    	Cadena_Vacia,
                Cadena_Vacia,     	Cadena_Vacia,   		Entero_Cero);

            SET @ContaFIRA := @ContaFIRA + 1;
        END WHILE;

    END IF;

    -- SE GUARDAN LOS RESULTADOS EN LA TABLA DEL REPORTE CON EL FORMATO CSV.
	DELETE FROM REPMONITOREOFIRA
		WHERE  TipoReporteID = TipoRepFira
		AND FechaGeneracion = Par_Fecha;


    INSERT INTO REPMONITOREOFIRA(
        TipoReporteID,      FechaGeneracion,  ConsecutivoID,    CSVReporte,     EmpresaID,
        Usuario,        FechaActual,    DireccionIP,    ProgramaID,     Sucursal,
        NumTransaccion)
        SELECT
        TipoRepFira, 		Par_Fecha,      Entero_Cero,
        CONCAT_WS(',', '#','GRUPO','SUBGRUPO', 'CONCEPTO', 'IMPORTE'),  Aud_EmpresaID,
        Aud_Usuario,      Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID,   Aud_Sucursal,
        Aud_NumTransaccion;

	-- DETALLE DEL REPORTE
    INSERT INTO REPMONITOREOFIRA(
        TipoReporteID,      FechaGeneracion,  ConsecutivoID,    CSVReporte,     EmpresaID,
        Usuario,        FechaActual,    DireccionIP,    ProgramaID,     Sucursal,
        NumTransaccion)
        SELECT
        TipoRepFira, 		Par_Fecha,      EDO.ConceptoFinanID,
        CONCAT_WS(',', EDO.ConceptoFinanID, EDO.Grupo, REPLACE(EDO.Descripcion,',',''), REPLACE(EDO.Desplegado,',',''), ROUND(BAL.SaldoDeudor,2)),
        Aud_EmpresaID,      Aud_Usuario,    Aud_FechaActual,  Aud_DireccionIP,  Aud_ProgramaID,
        Aud_Sucursal,     Aud_NumTransaccion
    FROM CONCEPESTADOSFIN AS EDO INNER JOIN TMPBALANZACONTAFIRA BAL ON (EDO.NombreCampo = BAL.CuentaContable)
        WHERE EDO.EstadoFinanID = TipoRepEdoResultados
            AND EDO.NumClien = NumCliente
            AND BAL.NumeroTransaccion = Aud_NumTransaccion;


    -- SE ELIMINAN LOS DATOS DE TABLAS TEMPORALES.
    DELETE FROM TMPEDOSFINFIRA
        WHERE NumTransaccion = Aud_NumTransaccion;

    DELETE FROM TMPCONTABLE
        WHERE NumeroTransaccion = Aud_NumTransaccion;

    DELETE FROM TMPBALANZACONTAFIRA
        WHERE NumeroTransaccion = Aud_NumTransaccion;

    DELETE FROM TMPFIRAESTADOSFIN
        WHERE NumTransaccion = Aud_NumTransaccion;

END TerminaStore$$