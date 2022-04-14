-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITODOCENTALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITODOCENTALT`;
DELIMITER $$


CREATE PROCEDURE `CREDITODOCENTALT`(
    Par_Credito         BIGINT(12),
    Par_Salida          CHAR(1),

    INOUT Par_NumErr    INT(11),
    INOUT Par_ErrMen    VARCHAR(400),
    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
        )

TerminaStore: BEGIN



DECLARE Var_Producto                INT(11);
DECLARE Var_Solicitud               INT(11);
DECLARE Var_Cargo                   INT(11);
DECLARE Var_CredGarantias           CHAR(1);
DECLARE Var_ComentarioMesaControl   VARCHAR(6000);


DECLARE Con_Cadena_Vacia        CHAR(1);
DECLARE Con_Fecha_Vacia         DATETIME;
DECLARE Con_Entero_Cero         INT(11);
DECLARE Con_Str_SI              CHAR(1);
DECLARE Con_Str_NO              CHAR(1);
DECLARE Con_CreStaInactivo      CHAR(1);
DECLARE Con_ClasificaAmbos      CHAR(1);
DECLARE Con_TipoMesaControl     CHAR(1);
DECLARE Con_DocNoEntregado      INT(11);
DECLARE Cla_RevisionMesaControl INT(11);


DECLARE Con_TipGrupSoloIndiv        CHAR(1);
DECLARE Con_TipGrupSoloGrup         CHAR(1);
DECLARE Con_TipGrupAmbos            CHAR(1);
DECLARE Con_GrupoAplicaTodos        INT(11);
DECLARE Con_GarantAutorizada        CHAR(1);






SET Con_Cadena_Vacia            := '';
SET Con_Fecha_Vacia             := '1900-01-01';
SET Con_Entero_Cero             := 0;
SET Con_Str_SI                  := 'S';
SET Con_Str_NO                  := 'N';
SET Con_CreStaInactivo          := 'I';
SET Con_ClasificaAmbos          := 'A';
SET Con_TipoMesaControl         := 'M';
SET Con_DocNoEntregado          := 9999;
SET Cla_RevisionMesaControl     := 9998;

SET Con_TipGrupSoloIndiv        := 'I';
SET Con_TipGrupSoloGrup         := 'G';
SET Con_TipGrupAmbos            := 'A';
SET Con_GrupoAplicaTodos        := 5;
SET Con_GarantAutorizada        := 'U';




SET Par_NumErr                  := 1;
SET Par_ErrMen                  := Con_Cadena_Vacia;

SET Aud_FechaActual             := CURRENT_TIMESTAMP();


IF(IFNULL(Par_Credito, Con_Entero_Cero))= Con_Entero_Cero THEN
    SELECT  '001' AS NumErr,
            'El numero de Credito no es valido.' AS ErrMen,
            'CreditoID' AS control,
            Con_Entero_Cero AS consecutivo;
    LEAVE TerminaStore;
END IF;



SELECT Cre.ProductoCreditoID, Cre.SolicitudCreditoID, Sol.ComentarioMesaControl
INTO Var_Producto, Var_Solicitud, Var_ComentarioMesaControl
FROM CREDITOS Cre
LEFT JOIN SOLICITUDCREDITO Sol ON Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
WHERE   Cre.CreditoID   = Par_Credito
    AND Cre.Estatus = Con_CreStaInactivo;

SET Var_ComentarioMesaControl   := IFNULL(Var_ComentarioMesaControl, Con_Cadena_Vacia);

IF IFNULL(Var_Producto, Con_Entero_Cero) = Con_Entero_Cero THEN
    SELECT  '002' AS NumErr,
            CONCAT("El Credito NO tiene estatus de Inactivo o no existe: ", CONVERT(Par_Credito, CHAR)) AS ErrMen,
            'CreditoID' AS control,
            Con_Entero_Cero AS consecutivo;
    LEAVE TerminaStore;
END IF;

IF EXISTS(SELECT CreditoID FROM CREDITODOCENT WHERE CreditoID = Par_Credito) THEN
    SELECT  '003' AS NumErr,
            CONCAT("El Credito ya existe en el checklist: ", CONVERT(Par_Credito, CHAR)) AS ErrMen,
            'CreditoID' AS control,
            Con_Entero_Cero AS consecutivo;
    LEAVE TerminaStore;
END IF;


IF NOT EXISTS(  SELECT Sol.SolDocReqID
            FROM SOLICIDOCREQ Sol,
                 CLASIFICATIPDOC Cla
            WHERE   Sol.ProducCreditoID  = Var_Producto
                AND Sol.ClasificaTipDocID    = Cla.ClasificaTipDocID
              AND   Cla.ClasificaTipo    IN (Con_TipoMesaControl, Con_ClasificaAmbos)) THEN
    SELECT  '004' AS NumErr,
            CONCAT("004.-El producto de Credito no tiene checklist parametrizado, para Mesa de Control.", CONVERT(Var_Producto, CHAR)) AS ErrMen,
            'productoCreditoID' AS control,
            Con_Entero_Cero AS consecutivo;
    LEAVE TerminaStore;
END IF;

SET Var_Cargo    :=  (SELECT IFNULL(Gru.Cargo, Con_Entero_Cero) AS Cargo
                FROM CREDITOS Cre
                    ,SOLICITUDCREDITO Sol
                    ,INTEGRAGRUPOSCRE Gru
                WHERE   Cre.CreditoID         = Par_Credito
                    AND Cre.SolicitudCreditoID = Sol.SolicitudCreditoID
                    AND Sol.SolicitudCreditoID  = Gru.SolicitudCreditoID) ;

SET Var_Cargo    :=  IFNULL(Var_Cargo, Con_Entero_Cero);

SET Var_CredGarantias = Con_Str_NO;

IF EXISTS (SELECT SolicitudCreditoID
        FROM ASIGNAGARANTIAS
        WHERE SolicitudCreditoID  = Var_Solicitud
            AND Estatus         = Con_GarantAutorizada)  THEN

    SET Var_CredGarantias = Con_Str_SI;

END IF;


IF (IFNULL(Var_Cargo, Con_Entero_Cero) = Con_Entero_Cero) THEN

    INSERT INTO CREDITODOCENT
    SELECT  Par_Credito,            Var_Producto,       Sol.ClasificaTipDocID,      Con_Str_NO,     MIN(Grp.TipoDocumentoID) AS TipoDocumentoID,
            Con_Cadena_Vacia,       Par_EmpresaID,  Aud_Usuario,                Aud_FechaActual,    Aud_DireccionIP,
            Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion
    FROM SOLICIDOCREQ Sol
        ,CLASIFICATIPDOC Cla
        ,CLASIFICAGRPDOC Grp
    WHERE   Sol.ProducCreditoID     = Var_Producto
        AND Sol.ClasificaTipDocID       = Cla.ClasificaTipDocID
        AND Cla.ClasificaTipo IN (Con_TipoMesaControl, Con_ClasificaAmbos)
        AND Cla.TipoGrupInd IN (Con_TipGrupAmbos, Con_TipGrupSoloIndiv)
        AND (Cla.EsGarantia = Con_Str_NO OR (Cla.EsGarantia = Con_Str_SI AND Var_CredGarantias = Con_Str_SI ))
        AND Sol.ClasificaTipDocID       = Grp.ClasificaTipDocID
    GROUP BY Sol.ClasificaTipDocID;

ELSE

    INSERT INTO CREDITODOCENT
    SELECT  Par_Credito,            Var_Producto,       Sol.ClasificaTipDocID,      Con_Str_NO,     MIN(Grp.TipoDocumentoID) AS TipoDocumentoID,
            Con_Cadena_Vacia,       Par_EmpresaID,  Aud_Usuario,                Aud_FechaActual,    Aud_DireccionIP,
            Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion
    FROM SOLICIDOCREQ Sol
        ,CLASIFICATIPDOC Cla
        ,CLASIFICAGRPDOC Grp
    WHERE   Sol.ProducCreditoID     = Var_Producto
        AND Sol.ClasificaTipDocID       = Cla.ClasificaTipDocID
        AND Cla.ClasificaTipo IN (Con_TipoMesaControl, Con_ClasificaAmbos)
        AND Cla.TipoGrupInd IN (Con_TipGrupAmbos, Con_TipGrupSoloGrup)
        AND Cla.GrupoAplica IN (Con_GrupoAplicaTodos, Var_Cargo)
        AND (Cla.EsGarantia = Con_Str_NO OR (Cla.EsGarantia = Con_Str_SI AND Var_CredGarantias = Con_Str_SI ))
        AND Sol.ClasificaTipDocID       = Grp.ClasificaTipDocID
    GROUP BY Sol.ClasificaTipDocID;
END IF;



IF CHAR_LENGTH(Var_ComentarioMesaControl) > Con_Entero_Cero THEN
    INSERT INTO CREDITODOCENT
    SELECT  Par_Credito,            Var_Producto,       Cla.ClasificaTipDocID,      Con_Str_NO,     MIN(Grp.TipoDocumentoID) AS TipoDocumentoID,
            Con_Cadena_Vacia,       Par_EmpresaID,  Aud_Usuario,                Aud_FechaActual,    Aud_DireccionIP,
            Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion
    FROM CLASIFICATIPDOC Cla
        ,CLASIFICAGRPDOC Grp
    WHERE Cla.ClasificaTipDocID = Cla_RevisionMesaControl
        AND Cla.ClasificaTipo = Con_TipoMesaControl
        AND Cla.TipoGrupInd IN (Con_TipGrupAmbos, Con_TipGrupSoloIndiv)
        AND Grp.ClasificaTipDocID = Cla.ClasificaTipDocID
    GROUP BY Cla.ClasificaTipDocID
    LIMIT 0,1;
END IF;


SET Par_NumErr  := Con_Entero_Cero;
SET Par_ErrMen  := CONCAT("Credito: ", CONVERT(Par_Credito, CHAR)," incluido en checklist de Mesa de Control");

IF(Par_Salida = Con_Str_SI) THEN
    SELECT  '000' AS NumErr,
            Par_ErrMen  AS ErrMen,
            'CreditoID' AS control,
            Par_Credito AS consecutivo;
END IF;



END TerminaStore$$