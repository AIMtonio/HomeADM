-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGUROVIDAACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGUROVIDAACT`;DELIMITER $$

CREATE PROCEDURE `SEGUROVIDAACT`(
    Par_SeguroVidaID    INT(11),
    Par_CreditoID       BIGINT(12),
    Par_CuentaAhoID     BIGINT(12),
    Par_NumAct          TINYINT UNSIGNED,

    Par_Salida          CHAR(1),
OUT Par_NumErr          INT,
OUT Par_ErrMen          VARCHAR(200),

    Aud_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
        )
TerminaStore: BEGIN




DECLARE Cadena_Vacia        CHAR(1);
DECLARE Fecha_Vacia         DATE;
DECLARE Entero_Cero         INT;
DECLARE SalidaSI            CHAR(1);
DECLARE SalidaNO            CHAR(1);
DECLARE Sta_Vigente         CHAR(1);
DECLARE Sta_Cobrado         CHAR(1);
DECLARE Sta_Inactivo        CHAR(1);
DECLARE Act_Vigente         INT;
DECLARE Act_Siniest         INT;
DECLARE Act_Inactivo        INT;




SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Entero_Cero     := 0;
SET SalidaSI        := 'S';
SET SalidaNO        := 'N';
SET Sta_Vigente     := 'V';
SET Sta_Cobrado     := 'C';
SET Sta_Inactivo    := 'I';
SET Act_Vigente     := 1;
SET Act_Siniest     := 2;
SET Act_Inactivo    :=3;
ManejoErrores: BEGIN


SET Par_NumErr  := Entero_Cero;
SET Par_ErrMen  := Cadena_Vacia;
SET Par_CreditoID       := IFNULL(Par_CreditoID, Entero_Cero);

SET Aud_FechaActual := CURRENT_TIMESTAMP();



IF(Par_NumAct = Act_Vigente) THEN

    UPDATE  SEGUROVIDA SET
        Estatus         = Sta_Vigente,

        EmpresaID       = Aud_EmpresaID,
        Usuario         =  Aud_Usuario,
        FechaActual     = Aud_FechaActual,
        DireccionIP     = Aud_DireccionIP,
        ProgramaID      = Aud_ProgramaID,
        Sucursal        = Aud_Sucursal,
        NumTransaccion  = Aud_NumTransaccion

        WHERE   CreditoID   = Par_CreditoID;

END IF;

IF(Par_NumAct = Act_Siniest) THEN

    UPDATE  SEGUROVIDA SET
        Estatus         = Sta_Cobrado,

        EmpresaID       = Aud_EmpresaID,
        Usuario         =  Aud_Usuario,
        FechaActual     = Aud_FechaActual,
        DireccionIP     = Aud_DireccionIP,
        ProgramaID      = Aud_ProgramaID,
        Sucursal        = Aud_Sucursal,
        NumTransaccion  = Aud_NumTransaccion

        WHERE   CreditoID   = Par_CreditoID;

END IF;

IF(Par_NumAct = Act_Inactivo) THEN

    UPDATE  SEGUROVIDA SET
        Estatus         = Sta_Inactivo,

        EmpresaID       = Aud_EmpresaID,
        Usuario         =  Aud_Usuario,
        FechaActual     = Aud_FechaActual,
        DireccionIP     = Aud_DireccionIP,
        ProgramaID      = Aud_ProgramaID,
        Sucursal        = Aud_Sucursal,
        NumTransaccion  = Aud_NumTransaccion

        WHERE   CreditoID   = Par_CreditoID;

END IF;

SET Par_NumErr := Entero_Cero;
SET Par_ErrMen := "Seguro de Vida Actualizado Exitosamente.";


END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen AS ErrMen,
            'seguroVidaID' AS control;
END IF;


END TerminaStore$$