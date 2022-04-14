-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APLICASEGUROVIDAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `APLICASEGUROVIDAPRO`;
DELIMITER $$

CREATE PROCEDURE `APLICASEGUROVIDAPRO`(

    Par_SeguroVidaID        INT(11),
    Par_CreditoID           BIGINT(12),
    Par_CuentaAhoID         BIGINT(12),
    Par_ClienteID           INT(11),
    Par_MonedaID            INT(11),

    Par_ProdCreID           INT(4),
    Par_MontoPago           DECIMAL(14,2),
   INOUT Par_Poliza         BIGINT(20),
    Par_Salida              CHAR(1),
    INOUT   Par_NumErr      INT(11),

    INOUT   Par_ErrMen      VARCHAR(400),
    INOUT   Par_Consecutivo BIGINT(12),
    Par_EmpresaID           INT,
    Aud_Usuario             INT,
    Aud_FechaActual         DATETIME,

    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT,
    Aud_NumTransaccion      BIGINT
    )
TerminaStore: BEGIN


DECLARE Var_FechaOper      DATE;
DECLARE Var_FechaApl        DATE;
DECLARE Var_EsHabil         CHAR(1);
DECLARE Var_SegCreditoID    BIGINT;
DECLARE Var_EstatusSeguro   CHAR(1);
DECLARE Var_SucCliente      INT;
DECLARE Var_ClasifCre       CHAR(1);
DECLARE Var_SegPoliza       DECIMAL(14,2);
DECLARE Var_DiasAtraso      INT;
DECLARE Var_ForCobSegVida   CHAR(1);
DECLARE Var_FechaVencim     DATE;
DECLARE Var_StrSegVidaID    VARCHAR(20);
DECLARE Par_Fecha           DATE;
DECLARE Var_SubClasifID     INT;



DECLARE Cadena_Vacia    CHAR(1);
DECLARE Entero_Cero     INT;
DECLARE Decimal_Cero    DECIMAL(12,2);
DECLARE Nat_Cargo       CHAR(1);
DECLARE Nat_Abono       CHAR(1);
DECLARE Salida_SI       CHAR(1);
DECLARE Salida_NO       CHAR(1);
DECLARE AltaPoliza_NO   CHAR(1);
DECLARE AltaPoliza_SI   CHAR(1);
DECLARE AltaPolCre_SI   CHAR(1);
DECLARE AltaMovCre_NO   CHAR(1);
DECLARE AltaMovAho_SI   CHAR(1);
DECLARE AltaMovAho_NO   CHAR(1);
DECLARE Est_Vigente     CHAR(1);
DECLARE Est_Pagado      CHAR(1);
DECLARE Act_Siniest     INT;
DECLARE Con_PagoSegVida INT;
DECLARE ConContaPagSeg  INT;
DECLARE Var_DesCobSeg   CHAR(100);
DECLARE Cob_Anticipado  CHAR(1);
DECLARE Cons_No         CHAR(1);


SET Cadena_Vacia    := '';
SET Entero_Cero     := 0;
SET Decimal_Cero    := 0;
SET Nat_Cargo       := 'C';
SET Nat_Abono       := 'A';
SET Salida_SI       := 'S';
SET Salida_NO       := 'N';
SET AltaPoliza_NO   := 'N';
SET AltaPoliza_SI   := 'S';
SET AltaPolCre_SI   := 'S';
SET AltaMovCre_NO   := 'N';
SET AltaMovAho_SI   := 'S';
SET AltaMovAho_NO   := 'N';
SET Est_Vigente     := 'V';
SET Est_Pagado      := 'P';
SET Act_Siniest     := 2;
SET Con_PagoSegVida := 25;
SET ConContaPagSeg  := 33;
SET Cob_Anticipado  := 'A';
SET Var_DesCobSeg   := 'COBRO COBERTURA DE RIESGO POR SINIESTRO';
SET Cons_No         := 'N';


ManejoErrores: BEGIN


SET Par_NumErr          := Entero_Cero;
SET Par_ErrMen          := Cadena_Vacia;
SET Var_StrSegVidaID    := CONVERT(Par_SeguroVidaID, CHAR);
SET Aud_FechaActual     := NOW();
SET Var_FechaOper       := (SELECT FechaSistema
                            FROM PARAMETROSSIS);

SELECT CreditoID, Estatus, MontoPoliza, ForCobroSegVida, FechaVencimiento
        INTO Var_SegCreditoID, Var_EstatusSeguro, Var_SegPoliza, Var_ForCobSegVida, Var_FechaVencim
    FROM SEGUROVIDA
    WHERE SeguroVidaID = Par_SeguroVidaID;

SET Var_SegCreditoID    := IFNULL(Var_SegCreditoID, Entero_Cero);
SET Var_EstatusSeguro   := IFNULL(Var_EstatusSeguro, Cadena_Vacia);
SET Var_SegPoliza       := IFNULL(Var_SegPoliza, Entero_Cero);

IF(Var_SegCreditoID != Par_CreditoID) THEN
    SET Par_NumErr  := 1;
    SET Par_ErrMen  := 'La Poliza de cobertura de riesgo no Pertenece al Credito.';
    LEAVE ManejoErrores;
END IF;
IF(Var_EstatusSeguro != Est_Vigente) THEN
    SET Par_NumErr  := 2;
    SET Par_ErrMen  := 'La Poliza de cobertura no se encuentra Vigente.';
    LEAVE ManejoErrores;
END IF;

CALL DIASFESTIVOSCAL(
    Var_FechaOper,  Entero_Cero,            Var_FechaApl,       Var_EsHabil,        Par_EmpresaID,
    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
    Aud_NumTransaccion);

SELECT  Cli.SucursalOrigen, Des.Clasificacion,  Des.SubClasifID  INTO
        Var_SucCliente, Var_ClasifCre, Var_SubClasifID
    FROM CREDITOS Cre,
          CLIENTES Cli,
        DESTINOSCREDITO Des
    WHERE CreditoID          = Par_CreditoID
      AND Cre.ClienteID      = Cli.ClienteID
     AND Cre.DestinoCreID   = Des.DestinoCreID;


IF(Par_MontoPago != Var_SegPoliza) THEN
    SET Par_NumErr  := 3;
    SET Par_ErrMen  := 'El Monto del Pago es diferente al Monto de la Poliza.';
    LEAVE ManejoErrores;
END IF;

IF(Par_MontoPago <= Entero_Cero) THEN
    SET Par_NumErr  := 4;
    SET Par_ErrMen  := 'El monto del Pago es Incorrecto.';
    LEAVE ManejoErrores;
END IF;


SELECT (DATEDIFF(Var_FechaOper, IFNULL(MIN(FechaExigible), Var_FechaOper)))  INTO Var_DiasAtraso
            FROM AMORTICREDITO Amo
            WHERE Amo.CreditoID = Par_CreditoID
              AND Amo.Estatus != Est_Pagado
              AND Amo.FechaExigible <= Var_FechaOper;

SET Var_DiasAtraso  := IFNULL(Var_DiasAtraso, Entero_Cero);

IF(Var_ForCobSegVida != Cob_Anticipado AND Var_DiasAtraso > Entero_Cero ) THEN
    SET Par_NumErr  := 5;
    SET Par_ErrMen  := 'La Cobertura de Riesgo fue Financiado y el Credito Relacionado presenta Atrasos.';
    LEAVE ManejoErrores;
END IF;


IF(Var_FechaVencim < Var_FechaOper ) THEN
    SET Par_NumErr  := 6;
    SET Par_ErrMen  := 'La Fecha de Vencimiento de la Cobertura de Riesgo ya Paso.';
    LEAVE ManejoErrores;
END IF;
SET Par_Poliza := IFNULL(Par_Poliza,Entero_Cero);

CALL  CONTACREDITOPRO (
    Par_CreditoID,      Entero_Cero,        Par_CuentaAhoID,    Par_ClienteID,      Var_FechaOper,
    Var_FechaApl,       Par_MontoPago,      Par_MonedaID,       Par_ProdCreID,      Var_ClasifCre,
    Var_SubClasifID,    Var_SucCliente,     Var_DesCobSeg,      Var_StrSegVidaID,   AltaPoliza_NO,
    ConContaPagSeg,     Par_Poliza,         AltaPolCre_SI,      AltaMovCre_NO,      Con_PagoSegVida,
    Entero_Cero,        Nat_Cargo,          AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
    Cadena_Vacia,       /*Cons_No,*/        Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
    Par_EmpresaID,      Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);



CALL SEGUROVIDAACT (
    Entero_Cero,        Par_CreditoID,  Par_CuentaAhoID,    Act_Siniest,    Salida_NO,
    Par_NumErr,         Par_ErrMen,     Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,
    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion);
IF (Par_NumErr <> Entero_Cero)THEN
    LEAVE ManejoErrores;
END IF;

SET Par_NumErr := Entero_Cero;
SET Par_ErrMen := "Cobertura de Riesgo Cobrada Exitosamente.";
END ManejoErrores;

 IF (Par_Salida = Salida_SI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen AS ErrMen,
            'seguroVidaID' AS control,
            Par_Poliza AS consecutivo;
END IF;

END TerminaStore$$