-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOFONDEOASIGCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOFONDEOASIGCON`;DELIMITER $$

CREATE PROCEDURE `CREDITOFONDEOASIGCON`(
    Par_InstitutFondID  INT(11),
    Par_LineaFondeoID   INT(11),
    Par_CreditoID       BIGINT(12),
    Par_FechaAsig       DATE,
    Par_TipoConsulta    INT(1),

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
    )
TerminaStore: BEGIN
DECLARE Var_FechaSis    DATE;
DECLARE Oficial         CHAR(1);
DECLARE Est_Pagado      CHAR(1);
DECLARE Entero_Cero     INT;
DECLARE Principal       INT(1);
DECLARE Foranea         INT(1);
DECLARE CredAsig        INT(1);

SET Principal       := 1;
SET Foranea         := 2;
SET CredAsig       := 3;
SET Oficial := 'S';
SET Est_Pagado := 'P';
SET Entero_Cero := 0;

SELECT FechaSistema INTO Var_FechaSis
        FROM PARAMETROSSIS;

IF(Par_TipoConsulta = Principal) THEN

    IF(Par_FechaAsig = Var_FechaSis) THEN

    SELECT      (SELECT (CASE WHEN COUNT(Cred.CreditoID)>0 THEN 'SI'
                              ELSE 'NO' END )
                    FROM `HIS-CREDFONASIG` Cred
                    WHERE Cred.CreditoID = Cr.CreditoID) AS PrevioReporte,
                    Cr.CreditoID,Cl.NombreCompleto,Cr.FechaInicio,Cr.FechaVencimien,Cr.MontoCredito,(Cr.SaldoCapVigent+Cr.SaldoCapAtrasad+Cr.SaldoCapVencido+Cr.SaldCapVenNoExi) AS SaldoCapital,
               CASE Cl.TipoPersona WHEN 'F' THEN 'FISICA'
                    WHEN 'M' THEN 'MORAL'
                    WHEN 'A' THEN 'F. ACT. EMP'
                    END AS TIPO, Pr.Descripcion,Dir.DireccionCompleta,Cl.ClienteID,Cl.ActividadBancoMx,Act.Descripcion AS ActDescrip,
                CASE Cl.Sexo
                    WHEN 'F' THEN 'FEMENINO'
                    WHEN 'M' THEN 'MASCULINO'
                    END AS Sexo,
                CASE Cl.EstadoCivil
                    WHEN 'S' THEN 'SOLTERO'
                    WHEN 'CS' THEN 'CASADO BIENES SEPARADOS'
                    WHEN 'CM' THEN 'CASADO BIENES MANCOMUNADOS'
                    WHEN 'CC'THEN 'CASADO BIENES MANCUMUNADOS CON CAPITULACION'
                    WHEN 'V'THEN 'VIUDO'
                    WHEN 'D'THEN 'DIVORSIADO'
                    WHEN 'SE' THEN 'SEPARADO'
                    WHEN 'U' THEN 'UNION LIBRE'
                    END AS EstadoCivil,Cr.DestinoCreID,Dest.Descripcion AS Destino ,IFNULL((DATEDIFF(Var_FechaSis,MIN(Amo.FechaExigible))),Entero_Cero) AS DiasAtraso
        FROM CREDITOS Cr
        INNER JOIN CLIENTES AS Cl
                    ON Cr.ClienteID = Cl.ClienteID
        INNER  JOIN DIRECCLIENTE AS Dir
                    ON  Dir.ClienteID = Cl.ClienteID
                    AND Dir.Oficial = Oficial
        INNER JOIN PRODUCTOSCREDITO AS Pr
                    ON  Cr.ProductoCreditoID = Pr.ProducCreditoID
        INNER JOIN ACTIVIDADESBMX AS Act
                    ON Cl.ActividadBancoMx = Act.ActividadBMXID
        INNER JOIN DESTINOSCREDITO AS Dest
                    ON Cr.DestinoCreID = Dest.DestinoCreID
        LEFT JOIN AMORTICREDITO AS Amo
                            ON   Cr.CreditoID = Amo.CreditoID
                            AND Amo.FechaExigible <= Var_FechaSis
                            AND Amo.Estatus       !=  Est_Pagado
        WHERE Cr.CreditoID = Par_CreditoID;

    ELSE IF(Par_FechaAsig < Var_FechaSis) THEN

        SELECT      (SELECT (CASE WHEN COUNT(Cred.CreditoID)>0 THEN 'SI'
                              ELSE 'NO' END )
                    FROM `HIS-CREDFONASIG` Cred
                    WHERE Cred.CreditoID = Cr.CreditoID) AS PrevioReporte,
                    Cr.CreditoID,Cl.NombreCompleto,Cr.FechaInicio,Cr.FechaVencimiento AS FechaVencimien,Cr.MontoCredito,(Cr.SalCapVigente+Cr.SalCapAtrasado+Cr.SalCapVencido+Cr.SalCapVenNoExi) AS SaldoCapital,
               CASE Cl.TipoPersona WHEN 'F' THEN 'FISICA'
                    WHEN 'M' THEN 'MORAL'
                    WHEN 'A' THEN 'F. ACT. EMP'
                    END AS TIPO, Pr.Descripcion,Dir.DireccionCompleta,Cl.ClienteID,Cl.ActividadBancoMx,Act.Descripcion AS ActDescrip,
                CASE Cl.Sexo
                    WHEN 'F' THEN 'FEMENINO'
                    WHEN 'M' THEN 'MASCULINO'
                    END AS Sexo,
                CASE Cl.EstadoCivil
                    WHEN 'S' THEN 'SOLTERO'
                    WHEN 'CS' THEN 'CASADO BIENES SEPARADOS'
                    WHEN 'CM' THEN 'CASADO BIENES MANCOMUNADOS'
                    WHEN 'CC'THEN 'CASADO BIENES MANCUMUNADOS CON CAPITULACION'
                    WHEN 'V'THEN 'VIUDO'
                    WHEN 'D'THEN 'DIVORSIADO'
                    WHEN 'SE' THEN 'SEPARADO'
                    WHEN 'U' THEN 'UNION LIBRE'
                    END AS EstadoCivil,Cr.DestinoCreID,Dest.Descripcion AS Destino ,Cr.DiasAtraso
        FROM SALDOSCREDITOS Cr
        LEFT JOIN CLIENTES AS Cl
                    ON Cr.ClienteID = Cl.ClienteID
        LEFT  JOIN DIRECCLIENTE AS Dir
                    ON  Dir.ClienteID = Cl.ClienteID
                    AND Dir.Oficial = Oficial
        LEFT JOIN PRODUCTOSCREDITO AS Pr
                    ON  Cr.ProductoCreditoID = Pr.ProducCreditoID
        LEFT JOIN ACTIVIDADESBMX AS Act
                    ON Cl.ActividadBancoMx = Act.ActividadBMXID
        LEFT JOIN DESTINOSCREDITO AS Dest
                    ON Cr.DestinoCreID = Dest.DestinoCreID
        WHERE Cr.CreditoID = Par_CreditoID AND Cr.FechaCorte = Par_FechaAsig;
        END IF;
    END IF;
END IF;

IF(Par_TipoConsulta = Foranea) THEN
SELECT  CreditoID,CreditoFondeoID
        FROM    CREDITOFONDEOASIG
        WHERE CreditoID = Par_CreditoID
      AND FechaAsignacion = Par_FechaAsig;
END IF;

IF(Par_TipoConsulta = CredAsig) THEN
SELECT  CreditoID,CreditoFondeoID,0 as PorcenExtra
        FROM    CREDITOFONDEOASIG
        WHERE InstitutFondeoID = Par_InstitutFondID
        AND   LineaFondeoID = Par_LineaFondeoID
        AND   CreditoFondeoID   = Par_CreditoID
        AND   FechaAsignacion = Par_FechaAsig;
END IF;



END TerminaStore$$