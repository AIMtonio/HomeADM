-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIDATSOCIOECON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIDATSOCIOECON`;DELIMITER $$

CREATE PROCEDURE `CLIDATSOCIOECON`(



    Par_ClienteID           INT(11),
    Par_ProspectoID         INT(11),
    Par_SolicitudCreditoID  INT(11),
    Par_CatSocioEID         INT(11),
    Par_NumCon              TINYINT UNSIGNED,


    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
        )
TERMINASTORE:BEGIN


    DECLARE Var_Ingresos            DECIMAL(14,2);
    DECLARE Var_Gastos              DECIMAL(14,2);
    DECLARE Var_GastosPasivosID     VARCHAR(200);
    DECLARE Var_IDGastosAlimen      INT(11);
    DECLARE Var_SumaEgresosPasivos  DECIMAL(14,2);
    DECLARE Var_SumaIngresos        DECIMAL(14,2);
    DECLARE Var_SumaEgresos         DECIMAL(14,2);
    DECLARE Var_MontoAlimentacion   DECIMAL(14,2);


    DECLARE Con_Foranea         INT;
    DECLARE Ingreso             CHAR(1);
    DECLARE Egreso              CHAR(1);
    DECLARE Con_Ratios          INT;
    DECLARE Decimal_Cero        DECIMAL;
    DECLARE Entero_Cero         INT;

    SET Con_Foranea             :=2;
    SET Con_Ratios              :=3;
    SET Ingreso                 :='I';
    SET Egreso                  :='E';
    SET Decimal_Cero            :=0.0;
    SET Entero_Cero             :=0;

        IF(Par_NumCon = Con_Foranea) THEN

            SELECT SUM(Monto) INTO Var_Ingresos
            FROM CLIDATSOCIOE Cte,
                CATDATSOCIOE    dat
                WHERE Cte.ClienteID=Par_ClienteID
                    AND Cte.CatSocioEID=dat.CatSocioEID
                    AND dat.Tipo=Ingreso
                LIMIT 1;

            SELECT SUM(Monto) INTO Var_Gastos
            FROM CLIDATSOCIOE Cte,
                CATDATSOCIOE    dat
                WHERE Cte.ClienteID=Par_ClienteID
                    AND Cte.CatSocioEID=dat.CatSocioEID
                    AND dat.Tipo = Egreso
                LIMIT 1;

        SELECT Var_Ingresos AS Ingresos,
               Var_Gastos   AS Egresos;

        END IF;

    IF(Par_NumCon =  Con_Ratios)THEN
        SELECT GastosPasivos, IDGastoAlimenta
                INTO Var_GastosPasivosID,Var_IDGastosAlimen
                        FROM PARAMETROSCAJA
                        LIMIT 1;
            SET Var_SumaEgresosPasivos  :=(SELECT SUM(Monto)
                                            FROM CLIDATSOCIOE Cte,
                                                CATDATSOCIOE    dat
                                                WHERE CASE WHEN Par_ClienteID >Entero_Cero THEN Cte.ClienteID = Par_ClienteID
                                                                ELSE Cte.ProspectoID =Par_ProspectoID END
                                                AND Cte.CatSocioEID= dat.CatSocioEID
                                                AND dat.Tipo        = Egreso
                                                AND CONCAT(',',CONVERT(dat.CatSocioEID,CHAR),',') IN (CONCAT(',',Var_GastosPasivosID),',')
                                                GROUP BY Cte.LinNegID
                                                LIMIT 1);
            SET Var_SumaEgresosPasivos  := IFNULL(Var_SumaEgresosPasivos,0.0);
            SET Var_SumaIngresos    :=( SELECT SUM(Monto)
                                            FROM CLIDATSOCIOE Cte,
                                                CATDATSOCIOE    dat
                                                WHERE CASE WHEN Par_ClienteID >Entero_Cero THEN Cte.ClienteID = Par_ClienteID
                                                                ELSE Cte.ProspectoID =Par_ProspectoID END
                                                AND Cte.CatSocioEID=dat.CatSocioEID
                                                AND dat.Tipo=Ingreso
                                                GROUP BY Cte.LinNegID
                                                LIMIT 1);
            SET Var_SumaIngresos    := IFNULL(Var_SumaIngresos,0.0);
            SET Var_SumaEgresos     :=(SELECT SUM(Monto)
                                        FROM CLIDATSOCIOE Cte,
                                            CATDATSOCIOE    dat
                                            WHERE CASE WHEN Par_ClienteID >Entero_Cero THEN Cte.ClienteID = Par_ClienteID
                                                                ELSE Cte.ProspectoID =Par_ProspectoID END
                                            AND Cte.CatSocioEID=dat.CatSocioEID
                                            AND dat.Tipo=Egreso
                                            GROUP BY Cte.LinNegID
                                            LIMIT 1);
            SET Var_SumaEgresos := IFNULL(Var_SumaEgresos,0.0);

            SET Var_MontoAlimentacion   :=(SELECT   Monto
                                            FROM CLIDATSOCIOE Cte
                                                WHERE  CASE WHEN Par_ClienteID >Entero_Cero THEN Cte.ClienteID = Par_ClienteID
                                                                ELSE Cte.ProspectoID =Par_ProspectoID END
                                                    AND CatSocioEID= Var_IDGastosAlimen
                                                    LIMIT 1);
            SET Var_MontoAlimentacion   := IFNULL(Var_MontoAlimentacion,0.0);

            SELECT  Var_MontoAlimentacion AS MontoAlimentacion, Var_SumaEgresosPasivos AS EgresosPasivos,
                    Var_SumaIngresos AS Ingresos,   Var_SumaEgresos AS Egresos;
    END IF;


    END TERMINASTORE$$