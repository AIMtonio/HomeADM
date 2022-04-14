-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETALLEPAGFONPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `DETALLEPAGFONPRO`;DELIMITER $$

CREATE PROCEDURE `DETALLEPAGFONPRO`(
    Par_AmortizacionID      INT(4),         /* ID de la amortizacion de fondeo */
    Par_CreditoFondeoID     INT(11),        /* ID del credito de fondeo */
    Par_FechaPago           DATE,
    Par_Transaccion         BIGINT(20),
    Par_MontoPago           DECIMAL(12,2),
    Par_TipoMovFondeoID    INT(4),

    Par_Salida              CHAR(1),
INOUT   Par_NumErr          INT,
INOUT   Par_ErrMen          VARCHAR(400),

    Aud_EmpresaID           INT,
    Aud_Usuario             INT,
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(20),
    Aud_Sucursal            INT,
    Aud_NumTransaccion      BIGINT      )
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_Transaccion BIGINT;
DECLARE Var_MontoCapOrd     DECIMAL(12,2);
DECLARE Var_MontoCapAtr     DECIMAL(12,2);
DECLARE Var_MontoIntOrd     DECIMAL(12,2);
DECLARE Var_MontoIntAtr     DECIMAL(12,2);
DECLARE Var_MontoIntMora    DECIMAL(12,2);
DECLARE Var_MontoIVA        DECIMAL(12,2);
DECLARE Var_MontoComision   DECIMAL(12,2);
DECLARE Var_Control         VARCHAR(50);

-- Declaracion de Constantes
DECLARE Cadena_Vacia    CHAR(1);
DECLARE Fecha_Vacia     DATE;
DECLARE Entero_Cero     INT;
DECLARE Decimal_Cero    DECIMAL(12,2);
DECLARE Salida_SI       CHAR(1);

DECLARE Mov_CapVig          INT(4);         /* Movimiento de Capital Vigente tabla - TIPOSMOVSFONDEO*/
DECLARE Mov_CapExi          INT(4);         /* Movimiento de Capital Exigible tabla - TIPOSMOVSFONDEO */
DECLARE Mov_IntOrd          INT(4);         /* Movimiento de Interes Ordinario  tabla - TIPOSMOVSFONDEO*/
DECLARE Mov_IntAtr          INT(4);         /* Movimiento de Interes Atrasado  tabla - TIPOSMOVSFONDEO*/
DECLARE Mov_IntMor          INT(4);         /* Movimiento de Interes Moratorio  tabla - TIPOSMOVSFONDEO*/
DECLARE Mov_ComFalPag       INT(4);         /* Movimiento de Comision por Falta de Pago  tabla - TIPOSMOVSFONDEO*/
DECLARE Mov_IvaInt          INT(4);         /* Movimiento de Iva de Interes tabla - TIPOSMOVSFONDEO*/
DECLARE Mov_IvaIntMora      INT(4);         /* Movimiento de Iva de interes moratorio tabla - TIPOSMOVSFONDEO*/
DECLARE Mov_IvaComFalP      INT(4);         /* Movimiento de Iva de comision por falta de pago  tabla - TIPOSMOVSFONDEO*/

-- Asignacion de Constantes
SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Entero_Cero     := 0;
SET Decimal_Cero    := 0.00;
SET Salida_SI       := 'S';

SET Mov_CapVig      := 1;               /* Movimiento de Capital Vigente tabla - TIPOSMOVSFONDEO*/
SET Mov_CapExi      := 2;               /* Movimiento de Capital Exigible tabla - TIPOSMOVSFONDEO */
SET Mov_IntOrd      := 10;              /* Movimiento de Interes Ordinario  tabla - TIPOSMOVSFONDEO*/
SET Mov_IntAtr      := 11;              /* Movimiento de Interes Atrasado  tabla - TIPOSMOVSFONDEO*/
SET Mov_IntMor      := 15;              /* Movimiento de Interes Moratorio  tabla - TIPOSMOVSFONDEO*/
SET Mov_ComFalPag   := 40;              /* Movimiento de Comision por Falta de Pago  tabla - TIPOSMOVSFONDEO*/
SET Mov_IvaInt      := 20;              /* Movimiento de Iva de Interes tabla - TIPOSMOVSFONDEO*/
SET Mov_IvaIntMora  := 21;              /* Movimiento de Iva de interes moratorio tabla - TIPOSMOVSFONDEO*/
SET Mov_IvaComFalP  := 22;              /* Movimiento de Iva de comision por falta de pago  tabla - TIPOSMOVSFONDEO*/

-- Inicializaciones
SET Par_NumErr  := Entero_Cero;
SET Par_ErrMen  := Cadena_Vacia;

SET Aud_FechaActual := NOW();

    ManejoErrores: BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
            SET Par_NumErr  := 999;
            SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operación. ',
                                'Disculpe las molestias que esto le ocasiona. Ref: SP-DETALLEPAGFONPRO');
            SET Var_Control := 'sqlException';
        END;

        SET Var_MontoCapOrd     := Decimal_Cero;
        SET Var_MontoCapAtr     := Decimal_Cero;
        SET Var_MontoIntOrd     := Decimal_Cero;
        SET Var_MontoIntAtr     := Decimal_Cero;
        SET Var_MontoIntMora    := Decimal_Cero;
        SET Var_MontoIVA        := Decimal_Cero;
        SET Var_MontoComision   := Decimal_Cero;

        IF (Par_TipoMovFondeoID = Mov_IntOrd ) THEN /* si el tipo de movimiento es interes Ordinario */
            SET Var_MontoIntOrd := Par_MontoPago;

        ELSEIF (Par_TipoMovFondeoID = Mov_CapVig) THEN /* si el tipo de movimiento es capital vigente */
            SET Var_MontoCapOrd := Par_MontoPago;

        ELSEIF (Par_TipoMovFondeoID = Mov_CapExi) THEN /* si el tipo de movimiento es capital atrasado */
            SET Var_MontoCapAtr := Par_MontoPago;

        ELSEIF (Par_TipoMovFondeoID = Mov_IntAtr) THEN /* si el monto del movimiento es interes atrasado */
            SET Var_MontoIntAtr := Par_MontoPago;

        ELSEIF (Par_TipoMovFondeoID = Mov_IntMor) THEN /* si el tipo de movimiento es interes moratorio */
            SET Var_MontoIntMora    := Par_MontoPago;

        ELSEIF (Par_TipoMovFondeoID = Mov_IVAInt OR/* si el tipo de movimiento es un iva de interes */
                Par_TipoMovFondeoID = Mov_IvaIntMora OR
                Par_TipoMovFondeoID = Mov_IvaComFalP ) THEN
            SET Var_MontoIVA    := Par_MontoPago;

        ELSEIF (Par_TipoMovFondeoID = Mov_ComFalPag) THEN /* si el tipo de movimiento es comision por falta de pago */
            SET Var_MontoComision   := Par_MontoPago;
        END IF;

        SELECT  Transaccion INTO Var_Transaccion
            FROM DETALLEPAGFON
            WHERE AmortizacionID    = Par_AmortizacionID
              AND CreditoFondeoID   = Par_CreditoFondeoID
              AND FechaPago         = Par_FechaPago
              AND Transaccion       = Par_Transaccion;

        SET Var_Transaccion = IFNULL(Var_Transaccion, Entero_Cero);

        IF (Var_Transaccion = Entero_Cero) THEN
            INSERT INTO DETALLEPAGFON(
                AmortizacionID,     CreditoFondeoID,        FechaPago,          Transaccion,        MontoTotPago,
                MontoCapVig,        MontoCapAtr,            MontoIntPro,        MontoIntAtr,        MontoIntMora,
                MontoIVA,           MontoComision,          EmpresaID,          Usuario,            FechaActual,
                DireccionIP,        ProgramaID,             Sucursal,           NumTransaccion)
            VALUES(
                Par_AmortizacionID, Par_CreditoFondeoID,    Par_FechaPago,      Par_Transaccion,    Par_MontoPago,
                Var_MontoCapOrd,    Var_MontoCapAtr,        Var_MontoIntOrd,    Var_MontoIntAtr,    Var_MontoIntMora,
                Var_MontoIVA,       Var_MontoComision,      Aud_EmpresaID,      Aud_Usuario,        Aud_FechaActual,
                Aud_DireccionIP,    Aud_ProgramaID,         Aud_Sucursal,       Aud_NumTransaccion);
        ELSE
            UPDATE DETALLEPAGFON SET
                MontoTotPago    = MontoTotPago + Par_MontoPago,
                MontoCapVig     = MontoCapVig + Var_MontoCapOrd,
                MontoCapAtr     = MontoCapAtr + Var_MontoCapAtr,
                MontoIntPro     = MontoIntPro + Var_MontoIntOrd,
                MontoIntAtr     = MontoIntAtr + Var_MontoIntAtr,
                MontoIntMora    = MontoIntMora + Var_MontoIntMora,
                MontoIVA        = MontoIVA + Var_MontoIVA,
                MontoComision   = MontoComision + Var_MontoComision,

                EmpresaID       = Aud_EmpresaID,
                Usuario         = Aud_Usuario,
                FechaActual     = Aud_FechaActual,
                DireccionIP     = Aud_DireccionIP,
                ProgramaID      = Aud_ProgramaID,
                Sucursal        = Aud_Sucursal,
                NumTransaccion  = Aud_NumTransaccion

                WHERE AmortizacionID    = Par_AmortizacionID
                  AND CreditoFondeoID   = Par_CreditoFondeoID
                  AND FechaPago         = Par_FechaPago
                  AND Transaccion       = Par_Transaccion;
        END IF;

        SET Par_NumErr      := 000;
        SET Par_ErrMen      := 'Movimientos Agregados Exitosamente';
        SET Var_Control     := 'graba';
    END ManejoErrores;

    IF (Par_Salida = Salida_SI) THEN
        SELECT  Par_NumErr  AS NumErr,
                Par_ErrMen  AS ErrMen,
                Var_Control AS control,
                Par_Consecutivo     AS consecutivo;
    END IF;

END TerminaStore$$