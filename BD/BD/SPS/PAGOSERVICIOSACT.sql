-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOSERVICIOSACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOSERVICIOSACT`;DELIMITER $$

CREATE PROCEDURE `PAGOSERVICIOSACT`(

    Par_CatalogoServID  INT(11),
    Par_FolioDispersion INT(11),
    Par_Aplicado        CHAR(1),
    Par_NumAct          TINYINT UNSIGNED,
    Par_Salida          CHAR(1),

    INOUT Par_NumErr    INT,
    INOUT Par_ErrMen    VARCHAR(400),
    Par_EmpresaID       INT,
    Aud_Usuario         INT,
    Aud_FechaActual     DATETIME,

    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT,
    Aud_NumTransaccion  BIGINT
            )
TerminaStore: BEGIN


DECLARE Cadena_Vacia    CHAR(1);
DECLARE Entero_Cero     INT;
DECLARE Decimal_Cero    DECIMAL(12,2);
DECLARE Fecha_Vacia     DATE;
DECLARE Salida_SI       CHAR(1);

DECLARE Est_Activo      CHAR(1);
DECLARE Act_FolioDis    INT(11);
DECLARE Act_Aplicado    INT(11);
DECLARE Var_NO          CHAR(1);
DECLARE Var_SI          CHAR(1);



DECLARE Var_PagoServicioID  INT;
DECLARE Var_EstatusCa       CHAR(1);
DECLARE Var_EstatusOpera    CHAR(1);
DECLARE Var_Consecutivo     INT(11);
DECLARE Var_ClienteID       INT(11);
DECLARE Var_ProspectoID     BIGINT(20);
DECLARE Var_CreditoID       BIGINT(12);


SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Entero_Cero     := 0;
SET Decimal_Cero    := 0.0;
SET Salida_SI       := 'S';
SET Var_NO          := 'N';
SET Var_SI          := 'S';

SET Act_FolioDis    := 1;
SET Act_Aplicado    := 2;




SET Aud_FechaActual := CURRENT_TIMESTAMP();


IF (Par_NumAct = Act_FolioDis) THEN

    UPDATE PAGOSERVICIOS Pag,
            CATALOGOSERV    Cat SET
        Pag.FolioDispersion = Par_FolioDispersion,
        Pag.EmpresaID       = Par_EmpresaID,
        Pag.Usuario         = Aud_Usuario,
        Pag.FechaActual     = Aud_FechaActual,
        Pag.DireccionIP     = Aud_DireccionIP,
        Pag.ProgramaID      = Aud_ProgramaID,
        Pag.Sucursal        = Aud_Sucursal,
        Pag.NumTransaccion  = Aud_NumTransaccion
    WHERE Pag.CatalogoServID = Par_CatalogoServID
     AND    IFNULL(Pag.FolioDispersion,Entero_Cero)     = Entero_Cero
     AND    IFNULL(Pag.Aplicado,Var_NO)                 = Var_NO
     AND    Pag.CatalogoServID                          = Cat.CatalogoServID
     AND    IFNULL(Cat.PagoAutomatico,Var_NO)           = Var_SI;


END IF;


IF (Par_NumAct = Act_Aplicado) THEN
    IF(Par_Aplicado = Var_SI) THEN
        UPDATE PAGOSERVICIOS Pag,
            CATALOGOSERV    Cat SET
                Pag.Aplicado        = Par_Aplicado,
                Pag.FolioDispersion = Par_FolioDispersion,
                Pag.EmpresaID       = Par_EmpresaID,
                Pag.Usuario         = Aud_Usuario,
                Pag.FechaActual     = Aud_FechaActual,
                Pag.DireccionIP     = Aud_DireccionIP,
                Pag.ProgramaID      = Aud_ProgramaID,
                Pag.Sucursal        = Aud_Sucursal,
                Pag.NumTransaccion  = Aud_NumTransaccion
            WHERE Pag.CatalogoServID = Par_CatalogoServID
             AND    IFNULL(Pag.FolioDispersion,Entero_Cero)     = Par_FolioDispersion
             AND    IFNULL(Pag.Aplicado,Var_NO)                 = Var_NO
             AND    Pag.CatalogoServID                          = Cat.CatalogoServID
             AND    IFNULL(Cat.PagoAutomatico,Var_NO)           = Var_SI;
    ELSE
        UPDATE PAGOSERVICIOS Pag,
            CATALOGOSERV    Cat SET
                Pag.Aplicado        = Par_Aplicado,
                Pag.FolioDispersion = Entero_Cero,
                Pag.EmpresaID       = Par_EmpresaID,
                Pag.Usuario         = Aud_Usuario,
                Pag.FechaActual     = Aud_FechaActual,
                Pag.DireccionIP     = Aud_DireccionIP,
                Pag.ProgramaID      = Aud_ProgramaID,
                Pag.Sucursal        = Aud_Sucursal,
                Pag.NumTransaccion  = Aud_NumTransaccion
            WHERE Pag.CatalogoServID = Par_CatalogoServID
             AND    IFNULL(Pag.FolioDispersion,Entero_Cero)     = Par_FolioDispersion
             AND    IFNULL(Pag.Aplicado,Var_NO)                 = Var_NO
             AND    Pag.CatalogoServID                          = Cat.CatalogoServID
             AND    IFNULL(Cat.PagoAutomatico,Var_NO)           = Var_SI;
    END IF;


END IF;

SET Par_NumErr := 0;
SET Par_ErrMen := "Pago de Servicio Actualizado";

IF (Par_Salida = Salida_SI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(10)) AS NumErr,
        Par_ErrMen AS ErrMen,
        'pagoServicioID' AS control,
        Entero_Cero AS consecutivo;
END IF;

END TerminaStore$$