-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COBROSEGUROVIDAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `COBROSEGUROVIDAPRO`;
DELIMITER $$

CREATE PROCEDURE `COBROSEGUROVIDAPRO`(
    Par_SeguroVidaID    INT(11),
    Par_CreditoID       BIGINT(12),
    Par_CuentaAhoID     BIGINT(12),
    Par_ClienteID       INT(11),
    Par_MonedaID        INT(11),
    Par_ProdCreID       INT(4),
    Par_MontoPago       DECIMAL(14,2),
    INOUT Par_Poliza    BIGINT(20),

    Par_Salida          CHAR(1),

    INOUT   Par_NumErr  INT(11),
    INOUT   Par_ErrMen      VARCHAR(400),
    INOUT   Par_Consecutivo INT(11),

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
    )
TerminaStore: BEGIN


DECLARE Var_FechaOper       DATE;
DECLARE Var_FechaApl        DATE;
DECLARE Var_EsHabil         CHAR(1);
DECLARE Var_SegCreditoID    BIGINT;
DECLARE Var_EstatusSeguro   CHAR(1);
DECLARE Var_SucCliente      INT;
DECLARE Var_ClasifCre       CHAR(1);
DECLARE Var_StrSegVidaID    VARCHAR(20);
DECLARE Var_MontoSegVida    DECIMAL(12,2);
DECLARE Var_SegVidaPagado   DECIMAL(12,2);
DECLARE Var_MontoPendPago   DECIMAL(12,2);
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
DECLARE Cob_Anticipado  CHAR(1);
DECLARE Con_PagoSegVida INT;
DECLARE Act_SegVigente  INT;
DECLARE Var_DesPagSeg   CHAR(100);
DECLARE Con_CobroSegVida INT;

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
SET Est_Vigente     := 'S';
SET Est_Pagado      := 'P';
SET Cob_Anticipado  := 'A';
SET Con_PagoSegVida := 25;
SET Con_CobroSegVida    := 34;

SET Act_SegVigente  := 1;

SET Var_DesPagSeg   := 'PAGO COBERTURA DE RIESGO';


ManejoErrores: BEGIN


SET Par_NumErr  := Entero_Cero;
SET Par_ErrMen  := Cadena_Vacia;
SET Var_StrSegVidaID    := CONVERT(Par_SeguroVidaID, CHAR);


SET Aud_FechaActual := NOW();

SET Var_FechaOper   := (SELECT FechaSistema
                            FROM PARAMETROSSIS);

SELECT CreditoID, Estatus INTO Var_SegCreditoID, Var_EstatusSeguro
    FROM SEGUROVIDA
    WHERE SeguroVidaID = Par_SeguroVidaID;

SET Var_SegCreditoID    := IFNULL(Var_SegCreditoID, Entero_Cero);
SET Var_EstatusSeguro   := IFNULL(Var_EstatusSeguro, Cadena_Vacia);

IF(Var_SegCreditoID != Par_CreditoID) THEN
    SET Par_NumErr  := 1;
    SET Par_ErrMen  := 'La Poliza  no Pertenece al Credito';
    LEAVE ManejoErrores;
END IF;

IF(Var_EstatusSeguro = Est_Vigente) THEN
    SET Par_NumErr  := 2;
    SET Par_ErrMen  := 'La Cobertura de Riesgo ya se encuentra Pagada';
    LEAVE ManejoErrores;
END IF;


CALL DIASFESTIVOSCAL(
    Var_FechaOper,  Entero_Cero,            Var_FechaApl,       Var_EsHabil,        Par_EmpresaID,
    Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,
    Aud_NumTransaccion);

SELECT  Cli.SucursalOrigen, Des.Clasificacion, Cre.MontoSeguroVida, Cre.SeguroVidaPagado, Des.SubClasifID
        INTO
        Var_SucCliente, Var_ClasifCre, Var_MontoSegVida, Var_SegVidaPagado, Var_SubClasifID
    FROM CREDITOS Cre,
          CLIENTES Cli,
          DESTINOSCREDITO Des
    WHERE CreditoID         = Par_CreditoID
      AND Cre.ClienteID     = Cli.ClienteID
      AND Cre.DestinoCreID  = Des.DestinoCreID;

SET Var_MontoSegVida    := IFNULL(Var_MontoSegVida, Entero_Cero);
SET Var_SegVidaPagado   := IFNULL(Var_SegVidaPagado, Entero_Cero);
SET Var_SubClasifID     := IFNULL(Var_SubClasifID, Entero_Cero);
SET Var_MontoPendPago   := Var_MontoSegVida - Var_SegVidaPagado;

IF(Par_MontoPago > Var_MontoPendPago) THEN
    SET Par_NumErr  := 3;
    SET Par_ErrMen  := 'El Monto del Pago es mayor al Adeudo';
    LEAVE ManejoErrores;
END IF;

IF(Par_MontoPago <= Entero_Cero) THEN
    SET Par_NumErr  := 4;
    SET Par_ErrMen  := 'El monto del Pago es Incorrecto';
    LEAVE ManejoErrores;
END IF;

SET Par_Poliza := IFNULL(Par_Poliza,Entero_Cero);

CALL  CONTACREDITOPRO (
    Par_CreditoID,      Entero_Cero,        Par_CuentaAhoID,    Par_ClienteID,      Var_FechaOper,
    Var_FechaApl,       Par_MontoPago,      Par_MonedaID,       Par_ProdCreID,      Var_ClasifCre,
    Var_SubClasifID,    Var_SucCliente,     Var_DesPagSeg,      Var_StrSegVidaID,   AltaPoliza_NO,
    Con_CobroSegVida,   Par_Poliza,         AltaPolCre_SI,      AltaMovCre_NO,      Con_PagoSegVida,
    Entero_Cero,        Nat_Abono,          AltaMovAho_NO,      Cadena_Vacia,       Cadena_Vacia,
    Cadena_Vacia,       /*Salida_NO,*/          Par_NumErr,         Par_ErrMen,         Par_Consecutivo,
    Par_EmpresaID,      Cadena_Vacia,       Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);



IF((Par_MontoPago + Var_SegVidaPagado) >= Var_MontoSegVida)  THEN

    CALL SEGUROVIDAACT (
        Entero_Cero,        Par_CreditoID,  Par_CuentaAhoID,    Act_SegVigente, Salida_NO,
        Par_NumErr,         Par_ErrMen,     Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,
        Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion);
    IF (Par_NumErr <> Entero_Cero)THEN
        LEAVE ManejoErrores;
    END IF;
END IF;

UPDATE CREDITOS SET
    SeguroVidaPagado = SeguroVidaPagado + Par_MontoPago,

    Usuario         = Aud_Usuario,
    FechaActual     = Aud_FechaActual,
    DireccionIP     = Aud_DireccionIP,
    ProgramaID      = Aud_ProgramaID,
    Sucursal        = Aud_Sucursal,
    NumTransaccion  = Aud_NumTransaccion

    WHERE CreditoID = Par_CreditoID;


SET Par_NumErr := Entero_Cero;
SET Par_ErrMen := "Cobertura de Riesgo Pagado Exitosamente";


END ManejoErrores;

 IF (Par_Salida = Salida_SI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen AS ErrMen,
            'seguroVidaID' AS control,
            Par_Poliza AS consecutivo;
END IF;

END TerminaStore$$