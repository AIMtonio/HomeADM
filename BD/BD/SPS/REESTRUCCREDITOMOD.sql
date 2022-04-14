-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REESTRUCCREDITOMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `REESTRUCCREDITOMOD`;DELIMITER $$

CREATE PROCEDURE `REESTRUCCREDITOMOD`(



    Par_FechaRegistro       DATE,
    Par_UsuarioID           INT(11),
    Par_CreditoOrigenID     BIGINT(12),
    Par_CreditoDestinoID    BIGINT(12),
    Par_SaldoCredAnteri     DECIMAL(12,2),

    Par_EstatusCredAnt      CHAR(1),
    Par_EstatusCreacion     CHAR(1),
    Par_NumDiasAtraOri      INT(11),
    Par_NumPagoSoste        INT(11),
    Par_NumPagoActual       INT(11),

    Par_Regularizado        CHAR(1),
    Par_FechaRegula         DATE,
    Par_NumeroReest         INT(11),
    Par_ReservaInteres      DECIMAL(14,2),
    Par_SaldoInteres        DECIMAL(14,2),

    Par_SaldoInteresMora    DECIMAL(14,2),
    Par_SaldoComisiones     DECIMAL(14,2),
    Par_Origen              CHAR(1),
    Par_Salida              CHAR(1),
    INOUT   Par_NumErr      INT(11),

    INOUT   Par_ErrMen      VARCHAR(400),

    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
    )
TerminaStore: BEGIN


DECLARE varCredito      BIGINT(12);
DECLARE Var_CreEstatus  CHAR(1);
DECLARE Var_SalInteres  DECIMAL(14,2);
DECLARE Var_Reserva     DECIMAL(14,2);
DECLARE Var_FecSistema  DATE;



DECLARE Cadena_Vacia    CHAR(1);
DECLARE Entero_Cero     INT;
DECLARE Fecha_Vacia     DATE;
DECLARE Var_SI          CHAR(1);
DECLARE Var_NO          CHAR(1);
DECLARE EstaAlta        CHAR(1);
DECLARE EstaCancela     CHAR(1);
DECLARE EstaPagado      CHAR(1);
DECLARE EstaInactivo    CHAR(1);
DECLARE EstaAutoriza    CHAR(1);



SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Entero_Cero     := 0;
SET Var_SI          := 'S';
SET Var_NO          := 'N';
SET EstaAlta        := 'A';
SET EstaCancela     := 'C';
SET EstaPagado      := 'P';
SET EstaInactivo    := 'I';
SET EstaAutoriza    := 'A';

ManejoErrores: BEGIN

SELECT  Estatus,
        ROUND(IFNULL(SaldoIntNoConta, Entero_Cero), 2) INTO
        Var_CreEstatus, Var_SalInteres
    FROM CREDITOS
    WHERE CreditoID = Par_CreditoOrigenID;

SET Var_CreEstatus  := IFNULL(Var_CreEstatus, Cadena_Vacia);
SET Var_SalInteres   := ROUND(IFNULL(Var_SalInteres, Entero_Cero), 2);

IF( Var_CreEstatus = Cadena_Vacia) THEN
    SET Par_NumErr := 1;
    SET Par_ErrMen := 'El Credito a Reestructurar no Existe.';
    LEAVE ManejoErrores;
END IF ;

IF( Var_CreEstatus = EstaPagado) THEN
    SET Par_NumErr := 2;
    SET Par_ErrMen := 'El Credito a Reestructurar ya esta Pagado.';
    LEAVE ManejoErrores;
END IF ;

IF( Var_CreEstatus = EstaInactivo OR Var_CreEstatus = EstaAutoriza) THEN
    SET Par_NumErr := 3;
    SET Par_ErrMen := 'El Credito a Reestructurar no esta Vigente.';
    LEAVE ManejoErrores;
END IF ;


SET varCredito := (SELECT CreditoOrigenID
                    FROM REESTRUCCREDITO
                    WHERE CreditoOrigenID = Par_CreditoOrigenID
                      AND CreditoDestinoID != Par_CreditoDestinoID
                      AND EstatusReest  != EstaCancela
                    LIMIT 1);

IF( IFNULL(varCredito, Entero_Cero) <> Entero_Cero) THEN
    SET Par_NumErr := 4;
    SET Par_ErrMen := 'El credito indicado ya fue Reestructurado.';
    LEAVE ManejoErrores;
END IF ;


SELECT  FechaSistema INTO Var_FecSistema
    FROM PARAMETROSSIS;

SET Var_Reserva :=  Var_SalInteres;

UPDATE REESTRUCCREDITO SET
    FechaRegistro   = Par_FechaRegistro,
    UsuarioID       = Par_UsuarioID,
    CreditoOrigenID = Par_CreditoOrigenID,
    SaldoCredAnteri = Par_SaldoCredAnteri,
    EstatusCredAnt  = Par_EstatusCredAnt,
    EstatusCreacion = Par_EstatusCreacion,
    NumDiasAtraOri  = Par_NumDiasAtraOri,
    NumPagoSoste    = Par_NumPagoSoste,
    NumPagoActual   = Par_NumPagoActual,
    Regularizado    = Par_Regularizado,
    FechaRegula     = Par_FechaRegula,
    NumeroReest     = Par_NumeroReest,
    ReservaInteres  = Var_Reserva,
    SaldoInteres    = Var_SalInteres,

    EmpresaID       = Par_EmpresaID,
    Usuario         = Aud_Usuario,
    FechaActual     = Aud_FechaActual,
    DireccionIP     = Aud_DireccionIP,
    ProgramaID      = Aud_ProgramaID,
    Sucursal        = Aud_Sucursal,
    NumTransaccion  = Aud_NumTransaccion

    WHERE CreditoDestinoID    = Par_CreditoDestinoID;

SET Par_NumErr := Entero_Cero;
SET Par_ErrMen := "Reestructura Modificada Exitosamente.";

END ManejoErrores;

 IF (Par_Salida = Var_SI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen AS ErrMen,
            'CreditoID' AS control,
            Entero_Cero AS consecutivo;
END IF;

END TerminaStore$$