-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOARCHIVOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGTOARCHIVOSALT`;DELIMITER $$

CREATE PROCEDURE `SEGTOARCHIVOSALT`(
    Par_SegtoID             INT(11),
    Par_SecuenciaID         INT(11),
    Par_FolioID             INT(11),
    Par_Ruta                VARCHAR(60),
    Par_NombreArchivo       VARCHAR(100),
    Par_TipoDocumentoID     INT(11),
    Par_Comentario          VARCHAR(100),

    Par_Salida              CHAR(1),
    INOUT Par_NumErr        INT(11),
    INOUT Par_ErrMen        VARCHAR(400),

    Aud_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
    )
TerminaStore:BEGIN

DECLARE Cadena_Vacia    CHAR(1);
DECLARE Entero_Cero     INT(11);
DECLARE SalidaSI        CHAR(1);
DECLARE Var_FechaSistema    DATE;
DECLARE Var_Control     VARCHAR(25);


SET Cadena_Vacia    := '';
SET Entero_Cero     := 0;
SET SalidaSI        := 'S';
SET Var_FechaSistema:= (SELECT FechaSistema FROM PARAMETROSSIS);


    ManejoErrores: BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
        SET Par_NumErr = 999;
        SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
        concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-SEGTOARCHIVOSALT');
        SET Var_Control = 'sqlException' ;
    END;

        IF (IFNULL(Par_SegtoID, Entero_Cero) = Entero_Cero) THEN
            SET Par_NumErr  := '001';
            SET Par_ErrMen  := 'Especifique el Numero de Seguimiento';
            SET Var_Control := 'segtoPrograID';
            LEAVE ManejoErrores;
        END IF;
        IF (IFNULL(Par_SecuenciaID, Entero_Cero) = Entero_Cero) THEN
            SET Par_NumErr  := '002';
            SET Par_ErrMen  := 'Especifique el Consecutivo de Seguimiento';
            SET Var_Control := 'segtoRealizaID';
            LEAVE ManejoErrores;
        END IF;

        INSERT INTO `SEGTOARCHIVOS`(
            `SegtoPrograID`,`NumSecuencia`,     `FolioID`,      `Fecha`,        `RutaArchivo`,
            `NombreArchivo`,`TipoDocumentoID`,  `Comentarios`,  `EmpresaID`,    `Usuario`,
            `FechaActual`,  `DireccionIP`,      `ProgramaID`,   `Sucursal`,     `NumTransaccion`)
        VALUES(
            Par_SegtoID,        Par_SecuenciaID,        Par_FolioID,    Var_FechaSistema,Par_Ruta,
            Par_NombreArchivo,  Par_TipoDocumentoID,    Par_Comentario, Aud_EmpresaID,  Aud_Usuario,
            Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);

        SET Par_NumErr  := 000;
        SET Par_ErrMen  := 'Archivo Adjuntado Correctamente';
        SET Var_Control := Cadena_Vacia;

    END ManejoErrores;

    SELECT
        Par_NumErr AS NumErr,
        Par_ErrMen AS ErrMen,
        Var_Control AS control,
        Entero_Cero AS consecutivo;
END TerminaStore$$