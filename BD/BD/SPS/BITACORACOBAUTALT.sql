-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORACOBAUTALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORACOBAUTALT`;DELIMITER $$

CREATE PROCEDURE `BITACORACOBAUTALT`(
    Par_FechaProceso        DATE,
    Par_Estatus             CHAR(1),
    Par_CreditoID           BIGINT(12),
    Par_ClienteID           INT(11),
    Par_CuentaID            BIGINT(12),

    Par_SaldoDisponCta      DECIMAL(12,2),
    Par_MontoExigible       DECIMAL(12,2),
    Par_MontoAplicado       DECIMAL(12,2),
    Par_TiempoProceso       DECIMAL(8,2),
    Par_GrupoID             INT,

    Par_EmpresaID           INT(11),
    Par_Salida              CHAR(1),
    INOUT   Par_NumErr      INT(11),
    INOUT   Par_ErrMen      VARCHAR(400),

    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
        )
TerminaStore: BEGIN


DECLARE Var_FechaProceso    DATETIME;


DECLARE Cadena_Vacia        CHAR(1);
DECLARE Fecha_Vacia         DATE;
DECLARE Entero_Cero         INT;
DECLARE Salida_SI           CHAR(1);


SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Entero_Cero     := 0;
SET Salida_SI       := 'S';

SET Par_NumErr  := Entero_Cero;
SET Par_ErrMen  := Cadena_Vacia;

SET Aud_FechaActual := NOW();
SET Var_FechaProceso := CONVERT(CONCAT(Par_FechaProceso,":",CURRENT_TIME),DATETIME);

BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr = 999;
            SET Par_ErrMen = CONCAT("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
                                     "estamos trabajando para resolverla. Disculpe las molestias que ",
                                     "esto le ocasiona. Ref: SP-BITACORACOBAUTALT");
        END;


    IF(IFNULL(Par_FechaProceso, Fecha_Vacia))= Fecha_Vacia THEN
        IF (Par_Salida = Salida_SI) THEN
            SELECT  '001' AS NumErr,
                 'La Fecha de Operacion es Incorrecta.' AS ErrMen,
                 'fechaOperacion' AS control,
                 Entero_Cero AS consecutivo;
        ELSE
            SET Par_NumErr := 1;
            SET Par_ErrMen := 'La Fecha de Operacion es Incorrecta.' ;
        END IF;
        LEAVE TerminaStore;
    END IF;


    INSERT INTO BITACORACOBAUT(
        FechaProceso,       Estatus,            CreditoID,          ClienteID,          CuentaID,
        SaldoDisponCta,     MontoExigible,      MontoAplicado,      TiempoProceso,      GrupoID,
        EmpresaID,          Usuario,            FechaActual,        DireccionIP,        ProgramaID,
        Sucursal,           NumTransaccion) VALUES
        (
        Var_FechaProceso,   Par_Estatus,        Par_CreditoID,      Par_ClienteID,      Par_CuentaID,
        Par_SaldoDisponCta, Par_MontoExigible,  Par_MontoAplicado,  Par_TiempoProceso,  Par_GrupoID,
        Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
        Aud_Sucursal,       Aud_NumTransaccion);

    SET Par_NumErr := 0;
    SET Par_ErrMen := 'Bitacora Agregada.';

 END;

 IF (Par_Salida = Salida_SI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(10)) AS NumErr,
            Par_ErrMen AS ErrMen;
END IF;

END TerminaStore$$