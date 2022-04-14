-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREPROYECCION
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREPROYECCION`;
DELIMITER $$

CREATE PROCEDURE `CREPROYECCION`(
    Var_CreditoID       BIGINT(12),
    Var_Monto           DECIMAL(12,2),
    Par_CuentaContable  VARCHAR(30),
    INOUT Var_Poliza    BIGINT

        )
TerminaStore:BEGIN


DECLARE Var_CentroCosto INT;
DECLARE Out_MontoPago   DECIMAL(12,2);
DECLARE Suma_MontoPago  DECIMAL(12,2);

DECLARE Var_MontoIVAInt DECIMAL(12, 2);
DECLARE Var_MontoIVAMora    DECIMAL(12, 2);
DECLARE Var_MontoIVAComi    DECIMAL(12, 2);

DECLARE Sum_MontoIVAInt DECIMAL(12, 2);
DECLARE Sum_MontoIVAMora    DECIMAL(12, 2);
DECLARE Sum_MontoIVAComi    DECIMAL(12, 2);

DECLARE Var_FechaSistema    DATE;

DECLARE Aud_FechaActual         DATETIME;
DECLARE Aud_DireccionIP         VARCHAR(15);
DECLARE Aud_ProgramaID          VARCHAR(50);
DECLARE Aud_Sucursal            INT;
DECLARE Aud_NumTransaccion      BIGINT;

DECLARE Par_NumErr      INT(11);
DECLARE Par_ErrMen      VARCHAR(400);
DECLARE Par_Consecutivo BIGINT;

DECLARE Aud_Usuario INT;
DECLARE OrigPag_Pro     CHAR(1);


SET Aud_FechaActual := NOW();
SET Aud_DireccionIP := 'corContableProyeccion';
SET Aud_ProgramaID := 'PAGOCREDITOPRO';
SET Aud_Usuario := 1;
SET Aud_Sucursal    := 1;
SET Var_CentroCosto := Aud_Sucursal;

CALL TRANSACCIONESPRO(Aud_NumTransaccion);

SELECT FechaSistema INTO Var_FechaSistema
    FROM PARAMETROSSIS;

CALL MAESTROPOLIZAALT(
    Var_Poliza,     1,  Var_FechaSistema,   'A',        54,
    'PROYECCION.PAGO DE CREDITO. ', 'n',    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
    Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);

SET Suma_MontoPago  := 0;
SET Sum_MontoIVAInt := 0;
SET Sum_MontoIVAMora    := 0;
SET Sum_MontoIVAComi    := 0;

SET Par_NumErr      := 0;
SET Par_ErrMen      := '';
SET Par_Consecutivo := 0;




    SET Out_MontoPago       := 0;
    SET Var_MontoIVAInt     := 0;
    SET Var_MontoIVAMora    := 0;
    SET Var_MontoIVAComi    := 0;
    SET OrigPag_Pro         := 'P';


    CALL PAGOCREPROYECCION(
        Var_CreditoID,Par_CuentaContable,Var_CentroCosto,
        Var_Monto,1,
        'N',
        'N',
        'N',
        1,
        'N',
        'N',
        Out_MontoPago,
        Var_MontoIVAInt,
        Var_MontoIVAMora,
        Var_MontoIVAComi,
        Var_Poliza,
        OrigPag_Pro,

        Par_NumErr,
        Par_ErrMen,
        Par_Consecutivo,

        Aud_Usuario,
        Aud_FechaActual,
        Aud_DireccionIP,
        Aud_ProgramaID,
        Aud_Sucursal,
        Aud_NumTransaccion
    );

    SET Suma_MontoPago  := Suma_MontoPago + Out_MontoPago;
    SET Sum_MontoIVAInt := Sum_MontoIVAInt + Var_MontoIVAInt;
    SET Sum_MontoIVAMora    := Sum_MontoIVAMora + Var_MontoIVAMora;
    SET Sum_MontoIVAComi    := Sum_MontoIVAComi + Var_MontoIVAComi;


SELECT 'Proceso Realizado Correctamente',
        Var_Poliza AS PolizaID,
        Aud_NumTransaccion AS Transaccion,
        Suma_MontoPago  AS TotalMontoPagado,
     Sum_MontoIVAInt    AS TotalIVAIntNoPagado,
     Sum_MontoIVAMora   AS TotalIVAMoratorioNoPagado;


END TerminaStore$$