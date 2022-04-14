-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COBRANZAAUTOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `COBRANZAAUTOCON`;

DELIMITER $$
CREATE PROCEDURE `COBRANZAAUTOCON`(
    /*SP PARA LA CONSULTA DE LA COBRANZA*/
    Par_CreditoID       BIGINT(12),     # Numero de Credito
    Par_CuentaID        BIGINT(12),     # Numero de Cuenta
    Par_NumCon          TINYINT UNSIGNED, # Numero de Consulta
    Par_EmpresaID       INT(11),      # Empresa

  /*Parametros de Auditoria */
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
)
TerminaStore: BEGIN


DECLARE Var_FecActual   DATETIME;
DECLARE Var_Empresa     INT;
DECLARE Var_TotalAde    DECIMAL(14,2);
DECLARE Var_MontoPag    DECIMAL(14,2);

DECLARE Var_CueClienID  BIGINT;
DECLARE Var_Cue_Saldo   DECIMAL(12,2);
DECLARE Var_CueMoneda   INT;
DECLARE Var_CueEstatus  CHAR(1);
DECLARE Var_CobraGarantiaFinanciada CHAR(1);


DECLARE Cadena_Vacia    CHAR(1);
DECLARE Fecha_Vacia     DATE;
DECLARE Entero_Cero     INT;
DECLARE Doble_Cero      INT;
DECLARE EstatusVigente  CHAR(1);
DECLARE EstatusAtraso   CHAR(1);
DECLARE EstatusVencido  CHAR(1);
DECLARE EstatusSuspendido CHAR(1);

DECLARE Inte_Activo     CHAR(1);
DECLARE Si_Prorratea    CHAR(1);
DECLARE Con_CredPorPag  INT;
DECLARE Con_CredGrupo   INT;
DECLARE Con_CredPorPagCom INT(11);
DECLARE ForCobroProg  CHAR(1);
DECLARE Prorratea_SI  CHAR(1);
DECLARE Prorratea_NO  CHAR(1);
DECLARE Inversion   CHAR(1);
DECLARE Cons_Si     CHAR(1);



SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Entero_Cero     := 0;
SET Doble_Cero      := 0.00;
SET EstatusVigente  := 'V';
SET EstatusAtraso   := 'A';
SET EstatusVencido  := 'B';
SET EstatusSuspendido := 'S';

SET Inte_Activo     := 'A';
SET Si_Prorratea    := 'S';
SET Con_CredPorPag  := 1;
SET Con_CredGrupo   := 2;
SET Con_CredPorPagCom := 3;
SET ForCobroProg  := 'P';   -- Forma de Cobro de la comision P:Programado
SET Prorratea_SI  := 'S';   -- Prorratea SI
SET Prorratea_NO  := 'N';
SET Inversion   := 'I';   -- Automatico por Inversion
SET Cons_Si   := 'S';   -- Constante SI

SELECT FechaSistema, EmpresaDefault  INTO Var_FecActual,  Var_Empresa
  FROM PARAMETROSSIS;

-- Obtiene el parametro que indica si la institución permite el cobro de garantía financiada
SET Var_CobraGarantiaFinanciada := IFNULL(FNPARAMGENERALES('CobraGarantiaFinanciada'),Cadena_Vacia);

IF ( Par_NumCon = Con_CredPorPag ) THEN

DROP TABLE IF EXISTS CREDITOSCOBRAUT;
CREATE TABLE CREDITOSCOBRAUT (
  CreditoID       BIGINT  (12)    NOT NULL COMMENT 'Credito ID',
    Ciclo         INT     (11)    NOT NULL COMMENT 'Ciclo',
    GrupoID       INT     (11)  NOT NULL COMMENT 'Grupo ID',
    CuentaAhoID     BIGINT  (12)    NOT NULL COMMENT 'CuentaAho ID',
    Exigible      DECIMAL (18,2)  NOT NULL COMMENT 'Exigible',
    Moneda        INT     (11)    NOT NULL COMMENT 'Moneda',
    ProrrateaPago CHAR    (1)     NOT NULL COMMENT 'Prorratea SI o NO',
    EsAutomatico    CHAR    (1)     NOT NULL COMMENT 'Automatico SI o NO',
    GarantiaFOGA  CHAR  (1)   COMMENT 'Cobra Garantia FOGA',
    GarantiaFOGAFI  CHAR  (1)   COMMENT 'Cobra Garantia FOGAFI',
    SaldoDisponible decimal(12,2),
    Integrante    INT(11),
    ClienteID   INT(11),
    SolicitudCreditoID    BIGINT(20),
    PRIMARY KEY (`CreditoID`),
    KEY `IDX_CREDITOSCOBRAUT_1` (`SolicitudCreditoID`)
   ) ENGINE=InnoDB DEFAULT CHARSET=latin1 COMMENT='Auxiliar Para la Cobranza';


DROP TABLE IF EXISTS GRUPOSCOB;
CREATE TABLE GRUPOSCOB (
  GrupoID     INT   (12)    NOT NULL COMMENT 'Credito ID',
    Exigible    DECIMAL (18,2)  NOT NULL COMMENT 'Exigible',
     CicloGrp         INT     (11)    NOT NULL COMMENT 'Ciclo',
    INDEX (GrupoID)
);


INSERT INTO CREDITOSCOBRAUT(
  CreditoID,  GrupoID,      Ciclo,        CuentaAhoID,  Exigible,
  Moneda,     ProrrateaPago,  EsAutomatico, GarantiaFOGA, GarantiaFOGAFI,
  SaldoDisponible,  Integrante,   ClienteID,    SolicitudCreditoID)

 SELECT Amo.CreditoID, IFNULL(MAX(Cre.GrupoID), Entero_Cero),
    IFNULL(MAX(Cre.CicloGrupo), Entero_Cero),
    MAX(Amo.CuentaID),
    FUNCIONEXIGIBLE(Cre.CreditoID),
    MAX(Cre.MonedaID), IFNULL(MAX(Integ.ProrrateaPago),Prorratea_SI) AS ProrrateaPago,
    MAX(Cre.EsAutomatico) AS EsAutomatico,  Cadena_Vacia, Cadena_Vacia,
    Entero_Cero, Entero_Cero,  MAX(Cre.ClienteID), Entero_Cero
  FROM AMORTICREDITO Amo
  INNER JOIN CUENTASAHO  Cue
    ON Amo.CuentaID = Cue.CuentaAhoID
    INNER JOIN CREDITOS Cre
  ON Amo.CreditoID = Cre.CreditoID
  LEFT JOIN  INTEGRAGRUPOSCRE Integ
  ON Cre.GrupoID = Integ.GrupoID
  WHERE Amo.FechaExigible <= Var_FecActual
      AND ( Amo.Estatus = EstatusVigente
       OR    Amo.Estatus = EstatusAtraso
       OR Amo.Estatus = EstatusVencido  )
      AND Amo.CuentaID  = Cue.CuentaAhoID
      AND Cue.SaldoDispon > Doble_Cero
     AND Amo.CreditoID = Cre.CreditoID
    AND Cre.TipoAutomatico <> Inversion
    GROUP BY Amo.CreditoID
    ORDER BY Amo.CreditoID;


-- Valida si se cobra garantía financiada para poder incluir los creditos que cobran garantia financiada, esto es para que en el pago de credito
-- aplique el desbloqueo de garantia FOGA/FOGAFI y pueda aplicar el pago
  IF(Var_CobraGarantiaFinanciada = Cons_Si )THEN
    INSERT INTO CREDITOSCOBRAUT(
        CreditoID,    GrupoID,      Ciclo,        CuentaAhoID,  Exigible,
        Moneda,     ProrrateaPago,  EsAutomatico, GarantiaFOGA, GarantiaFOGAFI,
    SaldoDisponible,  Integrante,   ClienteID,    SolicitudCreditoID)

    SELECT Amo.CreditoID,   IFNULL(MAX(Cre.GrupoID), Entero_Cero),    IFNULL(MAX(Cre.CicloGrupo), Entero_Cero), MAX(Amo.CuentaID),    FUNCIONEXIGIBLE(Cre.CreditoID),
            MAX(Cre.MonedaID),    IFNULL(MAX(Integ.ProrrateaPago),Prorratea_NO) AS ProrrateaPago,             MAX(Cre.EsAutomatico) AS EsAutomatico,
            Cadena_Vacia,     Cadena_Vacia, Entero_Cero, Entero_Cero, MAX(Cre.ClienteID),  Entero_Cero
        FROM AMORTICREDITO Amo
    INNER JOIN DETALLEGARLIQUIDA AS DET ON Amo.CreditoID = DET.CreditoID
    INNER JOIN CUENTASAHO  Cue
            ON Amo.CuentaID = Cue.CuentaAhoID
    INNER JOIN CREDITOS Cre
      ON Amo.CreditoID = Cre.CreditoID
        LEFT JOIN  INTEGRAGRUPOSCRE Integ
      ON Cre.GrupoID = Integ.GrupoID
        WHERE Amo.FechaExigible <= Var_FecActual
      AND ( Amo.Estatus = EstatusVigente
        OR    Amo.Estatus = EstatusAtraso
        OR Amo.Estatus = EstatusVencido  )
      AND Amo.CuentaID  = Cue.CuentaAhoID
            AND Cue.SaldoDispon = Doble_Cero
            AND Amo.CreditoID = Cre.CreditoID
            AND Cre.TipoAutomatico <> Inversion
    GROUP BY Amo.CreditoID
    ORDER BY Amo.CreditoID;

  END IF;
INSERT INTO GRUPOSCOB
  (GrupoID,   Exigible, CicloGrp)

        (SELECT  Ing.GrupoID, SUM(FUNCIONEXIGIBLE(Cre.CreditoID)) AS TotExi , Cre.CicloGrupo
        FROM INTEGRAGRUPOSCRE Ing,
             SOLICITUDCREDITO Sol,
             CREDITOS Cre
        WHERE Ing.Estatus               = Inte_Activo
          AND Ing.ProrrateaPago         = Si_Prorratea
          AND Ing.SolicitudCreditoID    = Sol.SolicitudCreditoID
          AND Sol.CreditoID             = Cre.CreditoID
          AND (   Cre.Estatus   = EstatusVigente
               OR  Cre.Estatus    = EstatusVencido
               OR Cre.Estatus = EstatusSuspendido)
        GROUP BY Ing.GrupoID, Cre.CicloGrupo
        HAVING TotExi > Doble_Cero)
    UNION ALL
        (SELECT  Ing.GrupoID, SUM(FUNCIONEXIGIBLE(Cre.CreditoID)) AS TotExi, Cre.CicloGrupo
            FROM `HIS-INTEGRAGRUPOSCRE` Ing,
                 SOLICITUDCREDITO Sol,
                 CREDITOS Cre
            WHERE Ing.Estatus               = Inte_Activo
              AND Ing.ProrrateaPago         = Si_Prorratea
              AND Ing.SolicitudCreditoID    = Sol.SolicitudCreditoID
              AND Ing.Ciclo                 = Cre.CicloGrupo
              AND Sol.CreditoID             = Cre.CreditoID
              AND (   Cre.Estatus   = EstatusVigente
                   OR  Cre.Estatus    = EstatusVencido
                   OR Cre.Estatus = EstatusSuspendido)
            GROUP BY Ing.GrupoID , Cre.CicloGrupo
            HAVING TotExi > Doble_Cero);

    # Se actualiza el Exigible con el monto exigible del grupo
    UPDATE CREDITOSCOBRAUT  AS CRE
  INNER JOIN GRUPOSCOB AS GRU ON GRU.GrupoID=CRE.GrupoID
    SET CRE.Exigible=GRU.Exigible
        WHERE CRE.ProrrateaPago= Prorratea_SI AND GRU.CicloGrp = CRE.Ciclo;

  # Se actualizan los campos GarantiaFOGA y GarantiaFOGAFI para los creditos que asi lo requieren
  IF(Var_CobraGarantiaFinanciada = Cons_Si )THEN
    UPDATE CREDITOSCOBRAUT  AS CRE
    INNER JOIN DETALLEGARLIQUIDA AS DET ON CRE.CreditoID = DET.CreditoID
    SET CRE.GarantiaFOGA  = DET.RequiereGarantia,
      CRE.GarantiaFOGAFI  = DET.RequiereGarFOGAFI;

    UPDATE CREDITOSCOBRAUT Cre
    INNER JOIN CREDITOS Cred ON Cre.CreditoID = Cred.CreditoID SET
    Cre.SolicitudCreditoID = Cred.SolicitudCreditoID;

    UPDATE CREDITOSCOBRAUT Cre , CUENTASAHO Cue
    SET Cre.SaldoDisponible = Cue.SaldoDispon
    WHERE Cre.CuentaAhoID = Cue.CuentaAhoID;

    UPDATE CREDITOSCOBRAUT Cre
    INNER JOIN INTEGRAGRUPOSCRE Ing ON Cre.GrupoID = Ing.GrupoID AND Cre.SolicitudCreditoID = Ing.SolicitudCreditoID AND Cre.ClienteID = Ing.ClienteID
    SET Cre.Integrante = Ing.Cargo;

    UPDATE CREDITOSCOBRAUT Cre
    INNER JOIN `HIS-INTEGRAGRUPOSCRE` Ing ON Cre.GrupoID = Ing.GrupoID AND Cre.SolicitudCreditoID = Ing.SolicitudCreditoID AND Cre.ClienteID = Ing.ClienteID
    SET Cre.Integrante = Ing.Cargo;

    DROP TABLE IF EXISTS CREDITOSCOBRAUT_2;
    CREATE TABLE CREDITOSCOBRAUT_2
    SELECT  CreditoID, SolicitudCreditoID, GrupoID,      Ciclo,   ClienteID, Integrante,    CuentaAhoID,    SaldoDisponible, Exigible,
            Moneda,   ProrrateaPago,  EsAutomatico, GarantiaFOGA, GarantiaFOGAFI
    FROM CREDITOSCOBRAUT
    WHERE GarantiaFOGA  = Cadena_Vacia
      AND GarantiaFOGAFI  = Cadena_Vacia;

    INSERT INTO CREDITOSCOBRAUT_2
    SELECT  CreditoID, SolicitudCreditoID, GrupoID,      Ciclo,   ClienteID, Integrante,    CuentaAhoID,    SaldoDisponible, Exigible,
        Moneda,   ProrrateaPago,  EsAutomatico, GarantiaFOGA, GarantiaFOGAFI
    FROM CREDITOSCOBRAUT
    WHERE GarantiaFOGA  = 'S'
      AND GarantiaFOGAFI  = 'S'
    AND Integrante = 1
      ORDER BY  GrupoID,  SaldoDisponible DESC;

    SELECT  CreditoID,  GrupoID,      Ciclo,        CuentaAhoID,    Exigible,
        Moneda,   ProrrateaPago,  EsAutomatico, GarantiaFOGA, GarantiaFOGAFI,
        SolicitudCreditoID, ClienteID, SaldoDisponible, Integrante
    FROM CREDITOSCOBRAUT_2;

    LEAVE TerminaStore;
   END IF;
  SELECT  CreditoID,  GrupoID,      Ciclo,        CuentaAhoID,    Exigible,
      Moneda,   ProrrateaPago,  EsAutomatico, GarantiaFOGA, GarantiaFOGAFI,
        SolicitudCreditoID, ClienteID, SaldoDisponible, Integrante
        FROM CREDITOSCOBRAUT;

END IF;

IF ( Par_NumCon = Con_CredGrupo ) THEN

    (SELECT  Ing.GrupoID, SUM(FUNCIONEXIGIBLE(Cre.CreditoID)) AS TotExi,
            MAX(Cre.MonedaID), MAX(Ing.Ciclo)
        FROM INTEGRAGRUPOSCRE Ing,
             SOLICITUDCREDITO Sol,
             CREDITOS Cre
        WHERE Ing.Estatus               = Inte_Activo
          AND Ing.ProrrateaPago         = Si_Prorratea
          AND Ing.SolicitudCreditoID    = Sol.SolicitudCreditoID
          AND Sol.CreditoID             = Cre.CreditoID
          AND (   Cre.Estatus   = EstatusVigente
               OR  Cre.Estatus    = EstatusVencido)
        GROUP BY Ing.GrupoID
        HAVING TotExi > Doble_Cero)
    UNION ALL
        (SELECT  Ing.GrupoID, SUM(FUNCIONEXIGIBLE(Cre.CreditoID)) AS TotExi,
                MAX(Cre.MonedaID), MAX(Ing.Ciclo)
            FROM `HIS-INTEGRAGRUPOSCRE` Ing,
                 SOLICITUDCREDITO Sol,
                 CREDITOS Cre
            WHERE Ing.Estatus               = Inte_Activo
              AND Ing.ProrrateaPago         = Si_Prorratea
              AND Ing.SolicitudCreditoID    = Sol.SolicitudCreditoID
              AND Ing.Ciclo                 = Cre.CicloGrupo
              AND Sol.CreditoID             = Cre.CreditoID
              AND (   Cre.Estatus   = EstatusVigente
                   OR  Cre.Estatus    = EstatusVencido)
            GROUP BY Ing.GrupoID
            HAVING TotExi > Doble_Cero);

END IF;

-- LISTA DE CREDITOS QUE ADEUDAN LA COMISION POR APERTURA DE CREDITO
IF ( Par_NumCon = Con_CredPorPagCom ) THEN

  SELECT  Cre.CreditoID, MAX(IFNULL(Cre.GrupoID, Entero_Cero)),
          MAX(IFNULL(Cre.CicloGrupo, Entero_Cero)),
          MAX(Cre.CuentaID),
          SUM(Cre.MontoComApert+Cre.IVAComApertura),
          MAX(Cre.MonedaID), Cadena_Vacia AS ProrrateaPago,
          MAX(Cre.EsAutomatico) AS EsAutomatico,
          Cadena_Vacia AS GarantiaFOGA,
          Cadena_Vacia AS GarantiaFOGAFI
        FROM CREDITOS Cre,
            CUENTASAHO   Cue
        WHERE Cre.FechaCobroComision <= Var_FecActual
               AND (Cre.Estatus =  EstatusVigente
        OR  Cre.Estatus =  EstatusVencido
        OR  Cre.Estatus =  EstatusSuspendido)
              AND Cre.CuentaID  = Cue.CuentaAhoID
              AND Cue.SaldoDispon > Doble_Cero
              AND Cre.ForCobroComAper = ForCobroProg
              AND Cre.ComAperPagado != (Cre.MontoComApert)
              AND Cre.ComAperPagado < Cre.MontoComApert
              GROUP BY Cre.CreditoID;

END IF;
END TerminaStore$$
