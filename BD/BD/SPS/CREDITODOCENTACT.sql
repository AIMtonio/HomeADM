-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITODOCENTACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITODOCENTACT`;DELIMITER $$

CREATE PROCEDURE `CREDITODOCENTACT`(
    Par_CreditoID           BIGINT(12),
    Par_ClasificaTipDocID   INT(11),
    Par_DocAceptado         CHAR(1),
    Par_TipoDocumentoID     INT(11),
    Par_Comentarios         VARCHAR(100),
    Par_TipAct              TINYINT UNSIGNED,

    Par_Salida              CHAR(1),
    INOUT Par_NumErr        INT,
    INOUT Par_ErrMen        VARCHAR(400),
    Par_EmpresaID           INT(11),
    Aud_Usuario             INT,
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT,
    Aud_NumTransaccion      BIGINT(20)
        )
TerminaStore: BEGIN



DECLARE Var_Producto            INT(11);
DECLARE Var_FecInicio           DATE;
DECLARE Var_FecVencim           DATE;

DECLARE Cadena_Vacia                CHAR(1);
DECLARE Fecha_Vacia             DATE;
DECLARE Entero_Cero             INT(11);
DECLARE Str_SI                  CHAR(1);
DECLARE Str_NO                  CHAR(1);
DECLARE CreStaInactivo          CHAR(1);
DECLARE TipoMesaControl         CHAR(1);
DECLARE ClasificaAmbos          CHAR(1);
DECLARE DocNoEntregado          INT(11);
DECLARE TipActGrabarGrid        INT(11);
DECLARE Cre_Autorizado          CHAR(1);



SET Cadena_Vacia                := '';
SET Fecha_Vacia                 := '1900-01-01';
SET Entero_Cero                 := 0;
SET Str_SI                      := 'S';
SET Str_NO                      := 'N';
SET CreStaInactivo              := 'I';
SET TipoMesaControl             := 'M';
SET ClasificaAmbos              := 'A';
SET DocNoEntregado              := 9999;
SET TipActGrabarGrid            := 1;
SET Cre_Autorizado              := 'A';


SET Par_NumErr                  := 1;
SET Par_ErrMen                  := Cadena_Vacia;
SET Aud_FechaActual             := NOW();


SELECT  FechaInicio,    FechaVencimien
        INTO
        Var_FecInicio,  Var_FecVencim
        FROM CREDITOS WHERE CreditoID= Par_CreditoID;


IF(IFNULL(Par_CreditoID, Entero_Cero))= Entero_Cero THEN
    SELECT  '001' AS NumErr,
            'El numero de credito no es valido.' AS ErrMen,
                'CreditoID' AS control,
                Entero_Cero AS consecutivo;
    LEAVE TerminaStore;
END IF;


SET Var_Producto := (   SELECT ProductoCreditoID
                        FROM CREDITOS
                        WHERE CreditoID = Par_CreditoID
                          AND Estatus   = CreStaInactivo);


IF IFNULL(Var_Producto, Entero_Cero) = Entero_Cero THEN
    SELECT  '002' AS NumErr,
            CONCAT("El Credito NO tiene estatus de Inactivo o no existe: ", CONVERT(Par_CreditoID, CHAR)) AS ErrMen,
                'CreditoID' AS control,
                Entero_Cero AS consecutivo;
    LEAVE TerminaStore;
END IF;

IF NOT EXISTS(SELECT CreditoID FROM CREDITODOCENT WHERE CreditoID = Par_CreditoID) THEN
    SELECT  '003' AS NumErr,
            CONCAT("El Credito NO existe en el checklist: ", CONVERT(Par_CreditoID, CHAR)) AS ErrMen,
                'CreditoID' AS control,
                Entero_Cero AS consecutivo;
    LEAVE TerminaStore;
END IF;


IF NOT EXISTS(  SELECT Sol.SolDocReqID
                FROM SOLICIDOCREQ Sol,
                     CLASIFICATIPDOC Cla
                WHERE Sol.ProducCreditoID = Var_Producto
                  AND Sol.ClasificaTipDocID = Cla.ClasificaTipDocID
                  AND Cla.ClasificaTipo IN (TipoMesaControl, ClasificaAmbos)) THEN
    SELECT  '004' AS NumErr,
            CONCAT("El producto de Credito no tiene checklist asignado para Mesa de Control.", CONVERT(Var_Producto, CHAR)) AS ErrMen,
            'productoCreditoID' AS control,
            Entero_Cero AS consecutivo;
    LEAVE TerminaStore;
END IF;

IF Par_DocAceptado NOT IN (Str_SI, Str_NO)  THEN
    SELECT  '005' AS NumErr,
            CONCAT("El valor para Documento Aceptado no es valido: ", CONVERT(Par_DocAceptado, CHAR)) AS ErrMen,
                'DocAceptado' AS control,
                Entero_Cero AS consecutivo;
    LEAVE TerminaStore;
END IF;


IF Par_TipAct = TipActGrabarGrid THEN
    IF Par_DocAceptado = Str_NO THEN
        SET Par_Comentarios     := Cadena_Vacia;
    ELSE
        IF NOT EXISTS(SELECT GrupoDocID
                        FROM CLASIFICAGRPDOC
                        WHERE ClasificaTipDocID = Par_ClasificaTipDocID
                          AND TipoDocumentoID = Par_TipoDocumentoID) THEN

            SELECT '005' AS NumErr,
                    CONCAT("El documento no corresponde con la categoria indicada.") AS ErrMen,
                    'TipoDocumentoID' AS control,
                    Entero_Cero AS consecutivo;
            LEAVE TerminaStore;

        END IF;

        IF  Par_TipoDocumentoID = DocNoEntregado THEN
            SELECT '006' AS NumErr,
                    CONCAT("El Documento seleccionado no es valido.") AS ErrMen,
                    'TipoDocumentoID' AS control,
                    Entero_Cero AS consecutivo;
            LEAVE TerminaStore;
        END IF;

    END IF;

    UPDATE CREDITODOCENT
    SET     Comentarios         = Par_Comentarios,
            DocAceptado         = Par_DocAceptado,
            Usuario             = Aud_Usuario,
            FechaActual         = Aud_FechaActual,
            DireccionIP         = Aud_DireccionIP,
            ProgramaID          = Aud_ProgramaID,
            Sucursal            = Aud_Sucursal,
            NumTransaccion      = Aud_NumTransaccion
    WHERE   CreditoID           = Par_CreditoID
      AND   ClasificaTipDocID   = Par_ClasificaTipDocID;



    UPDATE SEGUROVIDA Seg
            INNER JOIN CREDITOS Cre
            ON(Seg.CreditoID = Cre.CreditoID)
        SET Seg.FechaInicio         = Var_FecInicio,
            Seg.FechaVencimiento    = Var_FecVencim,

            Seg.EmpresaID           = Par_EmpresaID,
            Seg.Usuario             = Aud_Usuario,
            Seg.FechaActual         = Aud_FechaActual,
            Seg.DireccionIP         = Aud_DireccionIP,
            Seg.ProgramaID          = Aud_ProgramaID,
            Seg.Sucursal            = Aud_Sucursal,
            Seg.NumTransaccion      = Aud_NumTransaccion
        WHERE Seg.CreditoID     = Par_CreditoID
                AND Cre.Estatus IN (CreStaInactivo,Cre_Autorizado);

   SET  Par_ErrMen := CONCAT("Checklist para el credito: ", CONVERT(Par_CreditoID, CHAR)," fue grabado.");


END IF;


SET     Par_NumErr := Entero_Cero;

IF(Par_Salida = Str_SI) THEN
    SELECT '000' AS NumErr,
            Par_ErrMen  AS ErrMen,
            'creditoID' AS control,
            Entero_Cero AS consecutivo;
END IF;



END TerminaStore$$