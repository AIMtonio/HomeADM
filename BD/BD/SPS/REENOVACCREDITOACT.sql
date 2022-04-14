-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REENOVACCREDITOACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `REENOVACCREDITOACT`;
DELIMITER $$

CREATE PROCEDURE `REENOVACCREDITOACT`(
    Par_FechaRegistro       DATE,
    Par_CreditoDestinoID    BIGINT(12),
    Par_SaldoCredAnteri     DECIMAL(12,2),
    Par_EstatusCredAnt      CHAR(1),
    Par_EstatusCreacion     CHAR(1),

    Par_NumDiasAtraOri      INT(11),
    Par_NumPagoSoste        INT(11),
    Par_NumPagoActual       INT(11),
    Par_Poliza              BIGINT,
    Par_TipoAct             INT(11),

    Par_Salida              CHAR(1),
    OUT Par_NumErr          INT(11),
    OUT Par_ErrMen          VARCHAR(400),

    Aud_EmpresaID           INT(11),
    Par_ModoPago            CHAR(1),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
    )
TerminaStore: BEGIN


    DECLARE Var_NumPagoSoste    INT;
    DECLARE Var_NumPagoActual   INT;
    DECLARE Var_EstCreacion     CHAR(1);
    DECLARE Var_Regularizado    CHAR(1);
    DECLARE Var_Reserva         DECIMAL(14,2);

    DECLARE Var_MonedaID        INT;
    DECLARE Var_ClasifCre       CHAR(1);
    DECLARE Var_ProdCreID       INT;
    DECLARE Var_SucCliente      INT;
    DECLARE Str_NumErr          CHAR(3);
    DECLARE Par_Consecutivo     BIGINT;
    DECLARE Var_SubClasifID     INT;
    DECLARE Var_NumAmorti       INT;


    DECLARE Cadena_Vacia    CHAR(1);
    DECLARE Entero_Cero     INT;
    DECLARE Fecha_Vacia     DATE;
    DECLARE Var_SI          CHAR(1);
    DECLARE Var_NO          CHAR(1);
    DECLARE Act_Desembolso  INT;
    DECLARE Act_PagoSost    INT;
    DECLARE NO_Regulariza   CHAR(1);
    DECLARE SI_Regulariza   CHAR(1);
    DECLARE Esta_Vencido    CHAR(1);
    DECLARE AltaPoliza_NO   CHAR(1);
    DECLARE Con_EstBalance  INT;
    DECLARE Con_EstResultados   INT;
    DECLARE Est_Desemb      CHAR(1);
    DECLARE AltaPolCre_SI   CHAR(1);
    DECLARE AltaMovCre_NO   CHAR(1);
    DECLARE AltaMovAho_NO   CHAR(1);
    DECLARE Nat_Cargo       CHAR(1);
    DECLARE Nat_Abono       CHAR(1);


    DECLARE Des_Reserva     VARCHAR(100);
    DECLARE Ref_Regula      VARCHAR(100);
    DECLARE Var_NumAmoExi   INT(11);
    DECLARE Esta_Pagado     CHAR(1);
    DECLARE Var_FechaSistema DATE;


    SET Cadena_Vacia    := '';
    SET Fecha_Vacia     := '1900-01-01';
    SET Entero_Cero     := 0;
    SET Var_SI          := 'S';
    SET Var_NO          := 'N';
    SET Act_Desembolso  := 1;
    SET Act_PagoSost    := 2;
    SET NO_Regulariza   := 'N';
    SET Esta_Vencido    := 'B';
    SET SI_Regulariza   := 'S';
    SET AltaPoliza_NO   := 'N';
    SET Con_EstBalance  := 17;
    SET Con_EstResultados   := 18;
    SET Est_Desemb      := 'D';
    SET AltaPolCre_SI   := 'S';
    SET AltaMovCre_NO   := 'N';
    SET AltaMovAho_NO   := 'N';
    SET Nat_Cargo       := 'C';
    SET Nat_Abono       := 'A';
    SET Des_Reserva     := 'CANC.ESTIM.CAPITALIZACION INTERES';
    SET Ref_Regula      := 'REGULARIZACION PAGO SOSTENIDO';
    SET Esta_Pagado     := 'P';





IF ( Par_TipoAct = Act_Desembolso) THEN

    UPDATE REESTRUCCREDITO SET
        EstatusReest        = Est_Desemb,

        EmpresaID           = Aud_EmpresaID,
        Usuario             = Aud_Usuario,
        FechaActual         = Aud_FechaActual,
        DireccionIP         = Aud_DireccionIP,
        ProgramaID          = Aud_ProgramaID,
        Sucursal            = Aud_Sucursal,
        NumTransaccion      = Aud_NumTransaccion

        WHERE CreditoDestinoID    = Par_CreditoDestinoID;
END IF;

IF (Par_Salida = Var_SI ) THEN
    SELECT '000' AS NumErr,
            'Reestructura Actualizada' AS ErrMen,
            Entero_Cero AS control,
            Entero_Cero  AS consecutivo;
    ELSE
    SET Par_NumErr := 0;
    SET Par_ErrMen := 'Reestructura Actualizada';
END IF;





END TerminaStore$$
