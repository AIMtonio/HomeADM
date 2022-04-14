-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOARCHIVOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOARCHIVOSALT`;
DELIMITER $$

CREATE PROCEDURE `CREDITOARCHIVOSALT`(
    Par_CreditoID           BIGINT(12),
    Par_TipoDocumentoID     INT(11),
    Par_Comentario          VARCHAR(200),
    Par_Recurso             VARCHAR(200),
    Par_Extension           VARCHAR(20),

    Par_Salida              CHAR(1),
    INOUT Par_NumErr        INT(11),
    INOUT Par_ErrMen        VARCHAR(400),
    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
            )
TerminaStore: BEGIN



DECLARE     Var_NombreArchivo   VARCHAR(25);
DECLARE     NumeroArchivo       INT(11);


DECLARE     Con_Cadena_Vacia    CHAR(1);
DECLARE     Con_Fecha_Vacia     DATETIME;
DECLARE     Con_Entero_Cero     INT(11);
DECLARE     Con_Str_SI          CHAR(1);
DECLARE     Con_Str_NO          CHAR(1);
DECLARE     Con_CreStaInactivo  CHAR(1);
DECLARE     Con_TipoSolicitud   CHAR(1);
DECLARE     Con_DocNoEntregado  INT(11);
DECLARE     Con_RutaArchivos    VARCHAR(150);

DECLARE CONTINUE HANDLER FOR SQLEXCEPTION


SET     Con_Cadena_Vacia        := '';
SET     Con_Fecha_Vacia         := '1900-01-01';
SET     Con_Entero_Cero         := 0;
SET     Con_Str_SI              := 'S';
SET     Con_Str_NO              := 'N';
SET     Con_CreStaInactivo      := 'I';
SET     Con_TipoSolicitud       := 'S';
SET     Con_DocNoEntregado      := 9999;

SET Aud_FechaActual := CURRENT_TIMESTAMP();


SET     Par_NumErr  := 1;
SET     Par_ErrMen  := Con_Cadena_Vacia;



IF(NOT EXISTS(SELECT CreditoID
            FROM CREDITOS
            WHERE CreditoID = Par_CreditoID)) THEN
    SELECT '001' AS NumErr,
         'El Numero de Credito no existe' AS ErrMen,
         'creditoID' AS control,
         Con_Entero_Cero AS consecutivo;
    LEAVE TerminaStore;
END IF;

IF NOT EXISTS(SELECT TipoDocumentoID FROM TIPOSDOCUMENTOS WHERE TipoDocumentoID = Par_TipoDocumentoID) THEN
    SELECT  '002' AS NumErr,
            'El Tipo de documento no Existe.' AS ErrMen,
            'creditoID' AS control,
            Con_Entero_Cero AS consecutivo;
    LEAVE TerminaStore;

END IF;



SET NumeroArchivo       := (SELECT IFNULL(MAX(DigCreaID),Con_Entero_Cero)+1
                            FROM CREDITOARCHIVOS );

SET Var_NombreArchivo   :=  CONCAT(RIGHT(CONCAT("0000000000",CONVERT(NumeroArchivo, CHAR)), 10), Par_Extension);

SELECT RutaArchivos INTO Con_RutaArchivos FROM PARAMETROSSIS;
SET Par_Recurso := CONCAT(Con_RutaArchivos, Par_Recurso, CONVERT(Var_NombreArchivo, CHAR));

INSERT INTO CREDITOARCHIVOS
        (   DigCreaID,   CreditoID,  TipoDocumentoID,  Comentario,   Recurso,
            EmpresaID,   Usuario,    FechaActual,    DireccionIP,  ProgramaID,
            Sucursal,    NumTransaccion)

    VALUES  (NumeroArchivo,   Par_CreditoID,   Par_TipoDocumentoID,  Par_Comentario,  Par_Recurso,
            Par_EmpresaID,   Aud_Usuario,     Aud_FechaActual,    Aud_DireccionIP, Aud_ProgramaID,
            Aud_Sucursal,    Aud_NumTransaccion);


SET     Par_NumErr := Con_Entero_Cero;
SET Par_ErrMen := "El archivo se ha digitalizado Exitosamente";

IF(Par_Salida = Con_Str_SI) THEN
    SELECT  '000' AS NumErr,
        Par_ErrMen AS ErrMen,
        'creditoID' AS control,
        NumeroArchivo AS consecutivo,
        Par_Recurso AS NombreArchivo;
END IF;

END TerminaStore$$