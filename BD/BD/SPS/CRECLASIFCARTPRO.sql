-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRECLASIFCARTPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRECLASIFCARTPRO`;
DELIMITER $$


CREATE PROCEDURE `CRECLASIFCARTPRO`(

    Par_Fecha           DATETIME,

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
        )

TerminaStore: BEGIN


DECLARE Var_ClasifRegID INT;
DECLARE Var_AplSector   CHAR(1);
DECLARE Var_AplProducto CHAR(1);
DECLARE Var_AplActiv    CHAR(1);
DECLARE Var_AplTipoPer  CHAR(1);


DECLARE Entero_Cero     INT;
DECLARE Var_TipConDet   INT;
DECLARE var_RepRegID    INT;

DECLARE CURSORCLASIFICACION CURSOR FOR
    (   SELECT  ClasifRegID,    AplSector,  AplActividad,   AplProducto,    AplTipoPersona
            FROM CATCLASIFREPREG
            WHERE   Tipoconcepto    = Var_TipConDet
              AND   ReporteID       = var_RepRegID );


SET Entero_Cero     := 0;
SET Var_TipConDet   := 1;
SET var_RepRegID    := 1;


DROP TABLE IF EXISTS TMPCRECLASIF;

CREATE TEMPORARY TABLE TMPCRECLASIF (
    RegistroID bigint UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    CreditoID           BIGINT(12),
    ClienteID           INT(11),
    ProductoCreditoID   INT(4),
    ClasifRegID         INT(11)
    ) ENGINE=MEMORY;

INSERT INTO TMPCRECLASIF (
    CreditoID,  ClienteID,  ProductoCreditoID,  ClasifRegID   )
    SELECT  Cre.CreditoID,  Cre.ClienteID,  Cre.ProductoCreditoID,  Cre.ClasifRegID
        FROM CREDITOS Cre
        WHERE   IFNULL(Cre.ClasifRegID,Entero_Cero) = Entero_Cero
          AND   (   Cre.SaldoCapVigent + Cre.SaldoCapVencido + Cre.SaldCapVenNoExi + Cre.SaldoCapAtrasad +
                    ROUND(Cre.SaldoInterOrdin, 2) +
                    ROUND(Cre.SaldoInterAtras, 2) +
                    ROUND(Cre.SaldoInterVenc, 2) +
                    ROUND(Cre.SaldoInterProvi, 2) +
                    ROUND(Cre.SaldoIntNoConta, 2) ) > Entero_Cero;



    OPEN  CURSORCLASIFICACION;
BEGIN
    DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
    LOOP
    FETCH CURSORCLASIFICACION  INTO
    Var_ClasifRegID,    Var_AplSector,  Var_AplActiv,   Var_AplProducto,    Var_AplTipoPer;

    IF(Var_AplSector = 'S') THEN

        UPDATE TMPCRECLASIF temporal
            INNER JOIN CLIENTES Cli ON temporal.ClienteID = Cli.ClienteID
            INNER JOIN SECTORES Sec ON Cli.SectorGeneral = Sec.SectorID
            SET temporal.ClasifRegID    = Var_ClasifRegID
            WHERE   IFNULL(temporal.ClasifRegID, Entero_Cero) = Entero_Cero
              AND   Sec.ClasifRegID = Var_ClasifRegID
              AND   Cli.TipoPersona = CASE WHEN Var_AplTipoPer <> 'N' THEN
                                        Var_AplTipoPer
                                        ELSE
                                        Cli.TipoPersona END;
    END IF;

    IF(Var_AplActiv = 'S') THEN
        UPDATE TMPCRECLASIF temporal
            INNER JOIN CLIENTES Cli ON temporal.ClienteID = Cli.ClienteID
            INNER JOIN ACTIVIDADESBMX Act ON Cli.ActividadBancoMX   = Act.ActividadBMXID
            SET temporal.ClasifRegID = Var_ClasifRegID
            WHERE   IFNULL(temporal.ClasifRegID, Entero_Cero) = Entero_Cero
              AND   Act.ClasifRegID = Var_ClasifRegID
              AND   Cli.TipoPersona = CASE WHEN Var_AplTipoPer <> 'N' THEN
                                        Var_AplTipoPer
                                       ELSE
                                        Cli.TipoPersona END;
    END IF;

    IF(Var_AplProducto = 'S') THEN
        UPDATE TMPCRECLASIF temporal
            INNER JOIN CLIENTES Cli ON temporal.ClienteID = Cli.ClienteID
            INNER JOIN PRODUCTOSCREDITO Pro ON temporal.ProductoCreditoID = Pro.ProducCreditoID
            SET
            temporal.ClasifRegID = Var_ClasifRegID
            WHERE   IFNULL(temporal.ClasifRegID, Entero_Cero) = Entero_Cero
              AND   Pro.ClasifRegID = Var_ClasifRegID
              AND   Cli.TipoPersona = CASE WHEN Var_AplTipoPer <> 'N'  THEN
                                        Var_AplTipoPer
                                        ELSE
                                        Cli.TipoPersona END;
    END IF;

    END LOOP;
END;
CLOSE CURSORCLASIFICACION;

UPDATE CREDITOS Cre
    INNER JOIN TMPCRECLASIF temporal ON Cre.CreditoID = temporal.CreditoID SET
    Cre.ClasifRegID     = temporal.ClasifRegID

    WHERE   IFNULL(temporal.ClasifRegID, Entero_Cero) <> Entero_Cero;

DROP TABLE IF EXISTS TMPCRECLASIF;

END TerminaStore$$
