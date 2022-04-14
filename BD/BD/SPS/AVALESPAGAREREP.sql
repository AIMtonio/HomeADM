-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AVALESPAGAREREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `AVALESPAGAREREP`;DELIMITER $$

CREATE PROCEDURE `AVALESPAGAREREP`(
    Par_Credito         BIGINT(12),
    Par_TipoConsulta    INT(11)
        )
TerminaStore:BEGIN

DECLARE AvalesLis       INT(11);
DECLARE PagosLis        INT(11);
DECLARE Entero_Cero     INT(11);
DECLARE Cadena_Vacia    CHAR(1);
DECLARE TipoRestructura CHAR(1);

DECLARE Vuelta          INT;
DECLARE CantAvales      INT;
DECLARE VarSolCredito   INT;

DECLARE Var_NombreAval  VARCHAR(300);
DECLARE Var_DireccAval  VARCHAR(300);


DECLARE Var_CantCuotas  INT;
DECLARE Var_CantFilas   INT;
DECLARE Var_Vueltas     INT;
DECLARE Var_FechaPago   DATE;
DECLARE Var_Capital     DECIMAL(18,2);
DECLARE Var_NumFila     INT;
DECLARE Var_NumColumna  INT;
DECLARE Var_TipoCred    CHAR(1);


SET AvalesLis           :=1;
SET PagosLis            :=2;
SET Entero_Cero         := 0;
SET Cadena_Vacia        := '';
SET TipoRestructura     := 'R';

DROP TABLE IF EXISTS tmp_AvalesCreditoFinal;
CREATE TEMPORARY TABLE tmp_AvalesCreditoFinal ( Registro        INT,
                                                Campo           VARCHAR(100),
                                                Descripcion     VARCHAR(550),
                                                Orden           VARCHAR(1)
                                                );

DROP TABLE IF EXISTS tmp_PlanDePagos;
CREATE TEMPORARY TABLE tmp_PlanDePagos (    Fila        INT,
                                            FechaCol1   DATE,
                                            CapitalCol1 DECIMAL(18,2),
                                            FechaCol2   DATE,
                                            CapitalCol2 DECIMAL(18,2),
                                            FechaCol3   DATE,
                                            CapitalCol3 DECIMAL(18,2),
                                            PRIMARY KEY (Fila));

IF(Par_TipoConsulta=AvalesLis) THEN


    DROP TABLE IF EXISTS tmp_AvalesCredito;
    CREATE TEMPORARY TABLE tmp_AvalesCredito (
        Llave                   INT(11) AUTO_INCREMENT,
        SolicitudCreditoID      INT(11),
        ClienteIDAval           INT(11),
        AvalID                  INT(11),
        ProspectoIDAval         INT(11),
        NombreComAval           VARCHAR(300),
        Direccion               VARCHAR(500),
        Firma                   VARCHAR(40),
        Espacio                 VARCHAR(1),
        PRIMARY KEY (Llave),
        INDEX idxCliC(ClienteIDAval),
        INDEX idxCliA(AvalID),
        INDEX idxCliP(ProspectoIDAval)
    );

    SET Var_TipoCred := (SELECT TipoCredito FROM CREDITOS WHERE CreditoID = Par_Credito);


IF (Var_TipoCred = TipoRestructura)THEN
    SET VarSolCredito := (  SELECT      MAX(Sol.SolicitudCreditoID)
                                FROM    SOLICITUDCREDITO Sol
                                WHERE   Sol.CreditoID   = Par_Credito);

ELSE

    SET VarSolCredito := (  SELECT      Sol.SolicitudCreditoID
                                FROM    SOLICITUDCREDITO Sol
                                WHERE   Sol.CreditoID   = Par_Credito);
END IF;

    INSERT INTO tmp_AvalesCredito
        (   SolicitudCreditoID, ClienteIDAval,          AvalID,     ProspectoIDAval,
            NombreComAval,      Direccion,              Firma,      Espacio)
    SELECT  VarSolCredito,      IFNULL(AvaSol.ClienteID,0), IFNULL(AvaSol.AvalID,0),    IFNULL(AvaSol.ProspectoID,0),
            Ava.NombreCompleto, Ava.DireccionCompleta,  '',         ''
        FROM    AVALESPORSOLICI AvaSol
        LEFT OUTER JOIN AVALES  Ava ON AvaSol.AvalID = Ava.AvalID
        WHERE AvaSol.SolicitudCreditoID  = VarSolCredito
         AND    AvaSol.Estatus = 'U';



    UPDATE  tmp_AvalesCredito   tmp,
            CLIENTES            cli     SET
        NombreComAval   =   cli.NombreCompleto
        WHERE   tmp.ClienteIDAval = cli.ClienteID
         AND    tmp.ClienteIDAval > 0;


    UPDATE  tmp_AvalesCredito   tmp,
            PROSPECTOS          Pros        SET
        NombreComAval   =   Pros.NombreCompleto,
        Direccion       =   CONCAT(Pros.Calle," No. ",Pros.NumExterior,", Manzana x",Pros.Manzana,", Lote ",Pros.Lote,", ",Pros.Colonia)
        WHERE   tmp.ProspectoIDAval = Pros.ProspectoID
         AND    tmp.ClienteIDAval       = 0
         AND    tmp.AvalID          = 0
         AND    tmp.ProspectoIDAval > 0 ;


UPDATE  tmp_AvalesCredito Tmp,  PROSPECTOS Pro
                                            LEFT OUTER JOIN MUNICIPIOSREPUB Mun ON Pro.EstadoID = Mun.EstadoID AND Pro.MunicipioID  = Mun.MunicipioID
                                            LEFT OUTER JOIN ESTADOSREPUB Est ON Pro.EstadoID = Est.EstadoID
                SET Tmp.NombreComAval   =   Pro.NombreCompleto,
                    Tmp.Direccion       =   CONCAT(
                                            CASE WHEN IFNULL(Pro.Calle, Cadena_Vacia) != Cadena_Vacia THEN Pro.Calle ELSE Cadena_Vacia END,
                                            CASE WHEN IFNULL(Pro.NumExterior, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(", No. ", Pro.NumExterior) ELSE Cadena_Vacia END,
                                            CASE WHEN IFNULL(Pro.NumInterior, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(", INT. ", Pro.NumInterior) ELSE Cadena_Vacia END,
                                            CASE WHEN IFNULL(Pro.Lote, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(", LOT. ", Pro.Lote) ELSE Cadena_Vacia END,
                                            CASE WHEN IFNULL(Pro.Manzana, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(", MZA. ", Pro.Manzana) ELSE Cadena_Vacia END,
                                            CASE WHEN IFNULL(Pro.Colonia, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(", COL. ", Pro.Colonia) ELSE Cadena_Vacia END,
                                            CASE WHEN IFNULL(Pro.CP, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(", C.P. ", Pro.CP) ELSE Cadena_Vacia END,
                                            CASE WHEN IFNULL(Mun.Nombre, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(', ', Mun.Nombre) ELSE Cadena_Vacia END,
                                            CASE WHEN IFNULL(Est.Nombre, Cadena_Vacia) != Cadena_Vacia THEN CONCAT(', ', Est.Nombre) ELSE Cadena_Vacia END)

            WHERE Tmp.ProspectoIDAval       = Pro.ProspectoID
                 AND    Tmp.ClienteIDAval   = Entero_Cero
                 AND    Tmp.AvalID          = Entero_Cero
                 AND    Tmp.ProspectoIDAval > Entero_Cero;




    UPDATE  tmp_AvalesCredito   tmp,
            DIRECCLIENTE        dir     SET
        Direccion   =   dir.DireccionCompleta
        WHERE   tmp.ClienteIDAval = dir.ClienteID
         AND    tmp.ClienteIDAval > 0
         AND    dir.Oficial   = 'S';


    SET Vuelta     := 1;

    SET CantAvales := (SELECT MAX(Llave) FROM tmp_AvalesCredito);

    SET CantAvales := IFNULL( CantAvales , 0);

    WHILE Vuelta <= CantAvales DO

        SET Var_NombreAval = (SELECT NombreComAval FROM tmp_AvalesCredito WHERE Llave = Vuelta);
        SET Var_DireccAval = (SELECT Direccion FROM tmp_AvalesCredito WHERE Llave = Vuelta);

        INSERT INTO tmp_AvalesCreditoFinal VALUES(Vuelta, "Nombre                        ", Var_NombreAval, 1 );
        INSERT INTO tmp_AvalesCreditoFinal VALUES(Vuelta, "Domicilio Convencional", Var_DireccAval, 2 );
        INSERT INTO tmp_AvalesCreditoFinal VALUES(Vuelta, "Firma                            ","_______________________________________________________________________", 3 );
        INSERT INTO tmp_AvalesCreditoFinal VALUES(Vuelta, " "," ", 4 );

        SET Vuelta  = Vuelta + 1;
    END WHILE;

    SELECT IFNULL(Campo,'') AS Campo, IFNULL(Descripcion,'') AS Descripcion
    FROM tmp_AvalesCreditoFinal
    ORDER BY Registro, Orden;

    DROP TABLE IF EXISTS tmp_AvalesCredito;
    DROP TABLE IF EXISTS tmp_AvalesCreditoFinal;


END IF;

IF(Par_TipoConsulta=PagosLis) THEN

    SET Var_CantCuotas  := (SELECT COUNT(AmortizacionID) FROM AMORTICREDITO WHERE CreditoID = Par_Credito);

    SET Var_CantFilas   := ROUND(Var_CantCuotas/3, 0);

    IF Var_CantCuotas >= 6 THEN
        IF MOD(Var_CantCuotas/3,1) > 0 AND MOD(Var_CantCuotas/3,1) < 0.5 THEN
            SET Var_CantFilas   :=  Var_CantFilas + 1;
        END IF;
    ELSE
        SET Var_CantFilas   :=  Var_CantCuotas;
    END IF;



    SET Var_Vueltas     := 1;
    SET Var_NumFila     := 1;
    SET Var_NumColumna  := 1;
    WHILE Var_Vueltas <= Var_CantCuotas DO

        IF Var_NumColumna = 3 THEN
            UPDATE  tmp_PlanDePagos
                    INNER JOIN AMORTICREDITO ON CreditoID = Par_Credito
                                                AND AmortizacionID = Var_Vueltas
            SET FechaCol3   = FechaExigible,
                CapitalCol3 = Capital
            WHERE Fila = Var_NumFila;


        END IF;



        IF Var_NumColumna = 2 THEN
            UPDATE  tmp_PlanDePagos
                    INNER JOIN AMORTICREDITO ON CreditoID = Par_Credito
                                                AND AmortizacionID = Var_Vueltas
            SET FechaCol2   = FechaExigible,
                CapitalCol2 = Capital
            WHERE Fila = Var_NumFila;

            IF Var_NumFila = Var_CantFilas THEN
                SET Var_NumFila     := 0;
                SET Var_NumColumna  := 3;
            END IF;

        END IF;

        IF Var_NumColumna = 1 THEN
            INSERT INTO tmp_PlanDePagos (Fila, FechaCol1, CapitalCol1)
            SELECT Var_NumFila, FechaExigible, Capital
            FROM AMORTICREDITO
            WHERE CreditoID = Par_Credito
              AND AmortizacionID = Var_Vueltas;

            IF Var_NumFila = Var_CantFilas THEN
                SET Var_NumFila     := 0;
                SET Var_NumColumna  := 2;
            END IF;

        END IF;

        SET Var_NumFila = Var_NumFila + 1;

        SET Var_Vueltas = Var_Vueltas + 1;
    END WHILE;

    SELECT * FROM tmp_PlanDePagos;

    DROP TABLE IF EXISTS tmp_PlanDePagos;
END IF;
END TerminaStore$$