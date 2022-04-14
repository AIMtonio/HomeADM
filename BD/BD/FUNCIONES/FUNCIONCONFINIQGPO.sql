-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FUNCIONCONFINIQGPO
DELIMITER ;
DROP FUNCTION IF EXISTS `FUNCIONCONFINIQGPO`;DELIMITER $$

CREATE FUNCTION `FUNCIONCONFINIQGPO`(

    Par_CreditoID   BIGINT(12)


) RETURNS decimal(14,2)
    DETERMINISTIC
BEGIN

DECLARE Var_CicloGrupo          INT;
DECLARE Var_GrupoID             INT;
DECLARE Var_CicloActual         INT;
DECLARE Var_TotalDeuda          DECIMAL(14,2);


DECLARE Cadena_Vacia            CHAR(1);
DECLARE Fecha_Vacia             DATE;
DECLARE Entero_Cero             INT;
DECLARE Esta_Activo             CHAR(1);
DECLARE Esta_Vencido            CHAR(1);
DECLARE Esta_Vigente            CHAR(1);
DECLARE Esta_Pagado             CHAR(1);
DECLARE Si_Prorratea            CHAR(1);


SET Cadena_Vacia                := '';
SET Fecha_Vacia                 := '1900-01-01';
SET Entero_Cero                 := 0;
SET Esta_Activo                 := 'A';
SET Esta_Vencido                := 'B';
SET Esta_Vigente                := 'V';
SET Esta_Pagado                 := 'P';
SET Si_Prorratea                := 'S';

SELECT  CicloGrupo,     GrupoID
INTO    Var_CicloGrupo, Var_GrupoID
    FROM CREDITOS
        WHERE CreditoID = Par_CreditoID;

SELECT CicloActual INTO Var_CicloActual
    FROM GRUPOSCREDITO
        WHERE GrupoID = Var_GrupoID;

SET Var_CicloActual := IFNULL(Var_CicloActual, Entero_Cero);

IF(IFNULL(Var_GrupoID,Entero_Cero)>Entero_Cero)THEN


    IF(Var_CicloGrupo = Var_CicloActual) THEN
        SELECT  SUM(FUNCIONCONFINIQCRE(Cre.CreditoID)) INTO Var_TotalDeuda
            FROM INTEGRAGRUPOSCRE Ing,
                 SOLICITUDCREDITO Sol,
                 CREDITOS Cre
            WHERE Ing.GrupoID               = Var_GrupoID
              AND Ing.Estatus               = Esta_Activo
              AND Ing.ProrrateaPago         = Si_Prorratea
              AND Ing.SolicitudCreditoID    = Sol.SolicitudCreditoID
              AND Sol.CreditoID             = Cre.CreditoID
              AND   (   Cre.Estatus     = Esta_Vigente
                   OR  Cre.Estatus      = Esta_Vencido  );
    ELSE
        SELECT  SUM(FUNCIONCONFINIQCRE(Cre.CreditoID)) INTO Var_TotalDeuda
            FROM `HIS-INTEGRAGRUPOSCRE` Ing,
                 SOLICITUDCREDITO Sol,
                 CREDITOS Cre
            WHERE Ing.GrupoID               = Var_GrupoID
              AND Ing.Estatus               = Esta_Activo
              AND Ing.ProrrateaPago         = Si_Prorratea
              AND Ing.SolicitudCreditoID    = Sol.SolicitudCreditoID
              AND Ing.Ciclo                 = Var_CicloGrupo
              AND Sol.CreditoID             = Cre.CreditoID
              AND   (   Cre.Estatus     = Esta_Vigente
                   OR  Cre.Estatus      = Esta_Vencido  );
    END IF;
END IF;

SET Var_TotalDeuda    := IFNULL(Var_TotalDeuda, Entero_Cero);

RETURN Var_TotalDeuda;
END$$