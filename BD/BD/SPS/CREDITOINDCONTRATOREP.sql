-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOINDCONTRATOREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOINDCONTRATOREP`;DELIMITER $$

CREATE PROCEDURE `CREDITOINDCONTRATOREP`(
    Par_CreditoID                   BIGINT(12),

    Par_EmpresaID                   INT(11),
    Aud_Usuario                     INT(11),
    Aud_FechaActual                 DATETIME,
    Aud_DireccionIP                 VARCHAR(15),
    Aud_ProgramaID                  VARCHAR(50),
    Aud_Sucursal                    INT(11),
    Aud_NumTransaccion              BIGINT(20)
    )
TerminaStore: BEGIN


DECLARE S CHAR(1);
DECLARE C CHAR(1);
DECLARE Q CHAR(1);
DECLARE M CHAR(1);
DECLARE P CHAR(1);
DECLARE R CHAR(1);
DECLARE E CHAR(1);
DECLARE A CHAR(1);
DECLARE L CHAR(1);
DECLARE B CHAR(1);
DECLARE T CHAR(1);
DECLARE Semanas         VARCHAR(10);
DECLARE Catorcenas      VARCHAR(10);
DECLARE Quincenas       VARCHAR(10);
DECLARE Meses           VARCHAR(10);
DECLARE Periodos        VARCHAR(10);
DECLARE Bimestres       VARCHAR(10);
DECLARE Trimestres      VARCHAR(10);
DECLARE TetraMestres    VARCHAR(11);
DECLARE Semestres       VARCHAR(10);
DECLARE Anios           VARCHAR(10);
DECLARE Libres          VARCHAR(10);
DECLARE Semana          VARCHAR(10);
DECLARE Catorcena       VARCHAR(10);
DECLARE Quincena        VARCHAR(10);
DECLARE Mes             VARCHAR(10);
DECLARE Periodo         VARCHAR(10);
DECLARE Bimestre        VARCHAR(10);
DECLARE Trimestre       VARCHAR(10);
DECLARE TetraMestre     VARCHAR(11);
DECLARE Semestre        VARCHAR(10);
DECLARE Anio            VARCHAR(10);
DECLARE Libre           VARCHAR(10);
DECLARE Sin_Espacio     VARCHAR(1);
DECLARE  Cadena_Vacia   VARCHAR(2);
DECLARE Entero_Uno      INT(11);
DECLARE Reca            VARCHAR(100);
DECLARE FolioReca       VARCHAR(20);
DECLARE Var_NumAmorti   INT(11);
DECLARE Var_Reca        VARCHAR(100);
DECLARE Var_RegContrato VARCHAR(100);
DECLARE Var_TasaFija    DECIMAL(12,2);
DECLARE Var_NombreInsti VARCHAR(100);
DECLARE Var_Institucion INT(11);
DECLARE Var_FolioReca   VARCHAR(100);
DECLARE Var_FechaSis    DATE;
DECLARE Var_PresidenteConsejo VARCHAR(45);
DECLARE Var_NombreCorto VARCHAR(45);

SET S   :='S';
SET C   :='C';
SET Q   :='Q';
SET M   :='M';
SET P   :='P';
SET R   :='R';
SET E   :='E';
SET A   :='A';
SET L   :='L';
SET B   :='B';
SET T   :='T';
SET Entero_uno :=1;
SET Semanas         :='Semanas';
SET Catorcenas      :='Catorcenas';
SET Quincenas       :='Quincenas';
SET Meses           :='Meses';
SET Periodos        :='Periodos';
SET Bimestres       :='Bimestres';
SET Trimestres      :='Trimestres';
SET TetraMestres    :='TetraMestres';
SET Semestres       :='Semestres';
SET Anios           :='Años';
SET Libres          :='Libres';
SET Sin_Espacio     :='';
SET Cadena_Vacia    :=' ';
SET Semana          :='Semana';
SET Catorcena       :='Catorcena';
SET Quincena        :='Quincena';
SET Mes             :='Mes';
SET Periodo         :='Periodo';
SET Bimestre        :='Bimestre';
SET Trimestre       :='Trimestre';
SET TetraMestre     :='TetraMestre';
SET Semestre        :='Semestre';
SET Anio            :='Año';
SET Libre           :='Libre';
SET Anio            :='Año';
SET Reca            :='DATOS DE INSCRIPCIÓN EN EL REGISTRO DE CONTRATOS DE ADHESIÓN No.:';
SET FolioReca       :='FOLIO RECA:';

SELECT InstitucionID, FechaSistema
    INTO Var_Institucion, Var_FechaSis
    FROM PARAMETROSSIS
    WHERE EmpresaID = Entero_uno;

SELECT Nombre
    INTO Var_NombreInsti
    FROM  INSTITUCIONES
    WHERE EmpresaID =Entero_uno
    AND InstitucionID = Var_Institucion;


SELECT NumAmortizacion, TasaFija
    INTO Var_NumAmorti, Var_TasaFija
    FROM CREDITOS
    WHERE CreditoID = Par_CreditoID
    LIMIT 1;

SELECT p.RegistroRECA
    INTO Var_Reca
    FROM PRODUCTOSCREDITO p,
    CREDITOS c
    WHERE c.CreditoID = Par_CreditoID
    AND c.ProductoCreditoID  = p.ProducCreditoID;

IF(Var_Reca != Cadena_Vacia)THEN
SET Var_RegContrato := CONCAT(Reca, Cadena_Vacia, Var_Reca );
ELSE
SET Var_RegContrato := CONCAT(Cadena_Vacia);
END IF;


IF(Var_Reca != Cadena_Vacia)THEN
SET Var_FolioReca := CONCAT(FolioReca, Cadena_Vacia, Var_Reca );
ELSE
SET Var_FolioReca := CONCAT(Cadena_Vacia);
END IF;



IF(Var_NumAmorti > Entero_Uno)THEN
SELECT SUM(Amo.Capital + Amo.Interes + Amo.IVAInteres) AS MontoTotal,  cre.TasaFija, cre.MontoCredito, cre.ValorCAT,
        cre.NumAmortizacion, CAST(IFNULL(FORMAT(cre.MontoComApert, 2),0.0) AS CHAR )AS MontoComApert,Var_RegContrato,Var_TasaFija,
        CASE  cre.FrecuenciaInt
        WHEN S THEN Semanas
        WHEN C THEN Catorcenas
        WHEN Q THEN Quincenas
        WHEN M THEN Meses
        WHEN P THEN Periodos
        WHEN B THEN Bimestres
        WHEN T THEN Trimestres
        WHEN R THEN TetraMestres
        WHEN E THEN Semestres
        WHEN A THEN Anios
        WHEN L THEN Libres
        ELSE Cadena_Vacia   END AS Frecuencia, pro.Descripcion,Var_NombreInsti, CONCAT(cli.PrimerNombre,
            (CASE
                WHEN IFNULL(cli.SegundoNombre, '') != '' THEN CONCAT(' ', cli.SegundoNombre)
                ELSE ''
            END),
            (CASE
                WHEN IFNULL(cli.TercerNombre, '') != '' THEN CONCAT(' ', cli.TercerNombre)
                ELSE ''
            END),' ',IFNULL(cli.ApellidoPaterno,''),' ',IFNULL(cli.ApellidoMaterno,'')) AS NombreCompleto, pro.RegistroRECA, Var_FolioReca, FUNCIONLETRASFECHA(Var_FechaSis) AS Fecha
        FROM CREDITOS cre,
            AMORTICREDITO Amo,
            PRODUCTOSCREDITO pro,
            CLIENTES cli
        WHERE cre.CreditoID   = Par_CreditoID
            AND Amo.CreditoID = cre.CreditoID
            AND cre.ProductoCreditoID  = pro.ProducCreditoID
            AND cre.ClienteID = cli.ClienteID;
ELSE
SELECT SUM(Amo.Capital + Amo.Interes + Amo.IVAInteres) AS MontoTotal,  cre.TasaFija, cre.MontoCredito, cre.ValorCAT,
        cre.NumAmortizacion, CAST(IFNULL(FORMAT(cre.MontoComApert, 2),0.0)AS CHAR) AS MontoComApert,Var_RegContrato,Var_TasaFija,
        CASE  cre.FrecuenciaInt
        WHEN S THEN Semana
        WHEN C THEN Catorcena
        WHEN Q THEN Quincena
        WHEN M THEN Mes
        WHEN P THEN Periodo
        WHEN B THEN Bimestre
        WHEN T THEN Trimestre
        WHEN R THEN TetraMestre
        WHEN E THEN Semestre
        WHEN A THEN Anio
        WHEN L THEN Libre
        ELSE Cadena_Vacia   END AS Frecuencia, pro.Descripcion,Var_NombreInsti, CONCAT(cli.PrimerNombre,
            (CASE
                WHEN IFNULL(cli.SegundoNombre, '') != '' THEN CONCAT(' ', cli.SegundoNombre)
                ELSE ''
            END),
            (CASE
                WHEN IFNULL(cli.TercerNombre, '') != '' THEN CONCAT(' ', cli.TercerNombre)
                ELSE ''
            END),' ',IFNULL(cli.ApellidoPaterno,''),' ',IFNULL(cli.ApellidoMaterno,'')) AS NombreCompleto, pro.RegistroRECA, Var_FolioReca, FUNCIONLETRASFECHA(Var_FechaSis) AS Fecha
        FROM CREDITOS cre,
            AMORTICREDITO Amo,
            PRODUCTOSCREDITO pro,
            CLIENTES cli
        WHERE cre.CreditoID   = Par_CreditoID
            AND Amo.CreditoID = cre.CreditoID
            AND cre.ProductoCreditoID  = pro.ProducCreditoID
            AND cre.ClienteID = cli.ClienteID;
END IF;
END TerminaStore$$