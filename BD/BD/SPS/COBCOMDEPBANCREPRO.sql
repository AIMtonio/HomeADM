-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COBCOMDEPBANCREPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `COBCOMDEPBANCREPRO`;
DELIMITER $$


CREATE PROCEDURE `COBCOMDEPBANCREPRO`(

    Par_CreditoID       BIGINT(12),
    Par_CantidadMov     DECIMAL(12,2),
    Par_IvaMov          DECIMAL(12,2),
    Par_Fecha           DATE,

    Aud_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
        )

TerminaStore: BEGIN


    DECLARE Entero_Cero         INT;
    DECLARE Nat_Abono           CHAR(1);
    DECLARE Nat_Cargo           CHAR(1);
    DECLARE PolizaSI            CHAR(1);
    DECLARE PolizaNO            CHAR(1);
    DECLARE EstatusActivo       CHAR(1);
    DECLARE ConAhoCom           INT ;
    DECLARE ConAhoIvaCom        INT ;
    DECLARE ConAhoPasivo        INT ;
    DECLARE ConComDepCta        INT ;
    DECLARE ConComDepCtaDes     VARCHAR(150);
    DECLARE MovAComDepC         CHAR(4);
    DECLARE MovAComDepCDes      VARCHAR(45);
    DECLARE MovAIvaComDepC      CHAR(4);
    DECLARE MovAIvaComDepCDes   VARCHAR(45);


    DECLARE Var_CuentaAhoID     BIGINT(12);
    DECLARE Var_ClienteID       INT(11);
    DECLARE Var_MonedaID        INT(11);
    DECLARE Var_SucCliente      INT(11);
    DECLARE Var_Poliza          INT(11);
    DECLARE Par_NumErr          INT(11);
    DECLARE Par_ErrMen          VARCHAR(100);
    DECLARE Par_Consecutivo     BIGINT;


    SET Entero_Cero     := 0;
    SET EstatusActivo   := 'A';
    SET Nat_Abono       := 'A';
    SET Nat_Cargo       := 'C';
    SET PolizaSI        := 'S';
    SET PolizaNO        := 'N';
    SET ConAhoPasivo    := 1;
    SET ConAhoCom       := 28;
    SET ConAhoIvaCom    := 29;
    SET ConComDepCta    := 40;
    SET ConComDepCtaDes := (SELECT Descripcion FROM CONCEPTOSCONTA WHERE ConceptoContaID = ConComDepCta);
    SET MovAComDepC     := 225;
    SET MovAComDepCDes  := (SELECT Descripcion FROM TIPOSMOVSAHO WHERE TipoMovAhoID = MovAComDepC);
    SET MovAIvaComDepC  := 226;
    SET MovAIvaComDepCDes := (SELECT Descripcion FROM TIPOSMOVSAHO WHERE TipoMovAhoID = MovAIvaComDepC);




    SET Par_CreditoID := (SELECT IFNULL(CreditoID,Entero_Cero) FROM CREDITOS WHERE CreditoID = Par_CreditoID);

    IF(IFNULL(Par_CreditoID, Entero_Cero))= Entero_Cero THEN
        SELECT  '001' AS NumErr,
            'El Numero de Credito no Existe' AS ErrMen,
            'CreditoID' AS control,
            Entero_Cero AS consecutivo;
        LEAVE TerminaStore;
    ELSE

    SELECT CuentaID, ClienteID, MonedaID INTO Var_CuentaAhoID , Var_ClienteID, Var_MonedaID
        FROM CREDITOS
        WHERE CreditoID = Par_CreditoID;

    SELECT IFNULL(SucursalOrigen,Entero_Cero) INTO Var_SucCliente
        FROM CLIENTES
        WHERE ClienteID = Var_ClienteID;




    CALL CONTAAHORROPRO(    Var_CuentaAhoID,        Var_ClienteID   ,       Aud_NumTransaccion, Par_Fecha,          Par_Fecha,
                        Nat_Cargo,          Par_CantidadMov,        ConComDepCtaDes,        Par_CreditoID,      MovAComDepC,
                        Var_MonedaID,           Var_SucCliente,     PolizaSI,           ConComDepCta,           Var_Poliza,
                        PolizaSI,           ConAhoCom,          Nat_Abono,          Par_NumErr,         Par_ErrMen,
                        Par_Consecutivo,        Aud_EmpresaID,      Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,
                        Aud_ProgramaID,     Aud_Sucursal,           Aud_NumTransaccion);


    CALL CONTAAHORROPRO(    Var_CuentaAhoID,        Var_ClienteID   ,       Aud_NumTransaccion, Par_Fecha,          Par_Fecha,
                        Nat_Cargo,          Par_IvaMov,         MovAIvaComDepCDes,  Par_CreditoID,      MovAIvaComDepC,
                        Var_MonedaID,           Var_SucCliente,     PolizaNO,           ConComDepCta,           Var_Poliza,
                        PolizaSI,           ConAhoIvaCom,           Nat_Abono,          Par_NumErr,         Par_ErrMen,
                        Par_Consecutivo,        Aud_EmpresaID,      Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,
                        Aud_ProgramaID,     Aud_Sucursal,           Aud_NumTransaccion);


    CALL POLIZAAHORROPRO(
        Var_Poliza,     Aud_EmpresaID,  Par_Fecha,                  Var_ClienteID,  ConAhoPasivo,
        Var_CuentaAhoID,    Var_MonedaID,       (Par_IvaMov+Par_CantidadMov),   Entero_Cero,        ConComDepCtaDes,
        Par_CreditoID,  Aud_Usuario,        Aud_FechaActual,                Aud_DireccionIP,    Aud_ProgramaID,
        Aud_Sucursal,       Aud_NumTransaccion);

    SELECT  '000' AS NumErr,
        'Transaccion Realizada' AS ErrMen,
        'CreditoID' AS control,
        Var_Poliza AS consecutivo;
    LEAVE TerminaStore;

END IF;
END TerminaStore$$