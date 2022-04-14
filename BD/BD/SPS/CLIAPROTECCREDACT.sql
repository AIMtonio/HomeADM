-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIAPROTECCREDACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIAPROTECCREDACT`;DELIMITER $$

CREATE PROCEDURE `CLIAPROTECCREDACT`(
    Par_ClienteID           INT(11),
    Par_CreditoID           BIGINT(12),
    Par_MontoAplicaCred     DECIMAL(14,2),

    Par_Salida              CHAR(1),
    INOUT   Par_NumErr      INT(11),
    INOUT   Par_ErrMen      VARCHAR(350),

    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
    )
TerminaStore:BEGIN

DECLARE Var_FechaSistema            DATE;
DECLARE Var_EstatusCredito          CHAR(1);
DECLARE Var_CreditoID               BIGINT(12);
DECLARE Var_MontoTotalCred          DECIMAL(14,2);
DECLARE Var_MontoMaximoProteccion   DECIMAL(14,2);


DECLARE MontoAdeudo     DECIMAL(14,2);
DECLARE EnteroCero      INT;
DECLARE CadenaVacia     CHAR(1);
DECLARE SalidaSI        CHAR(1);
DECLARE Decimal_Cero    DECIMAL;

SET MontoAdeudo         :=0.00;
SET EnteroCero          :=0;
SET CadenaVacia         :='';
SET SalidaSI            :='S';
SET Decimal_Cero        :=0.00;


ManejoErrores:BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
            SET Par_NumErr = 999;
            SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                'Disculpe las molestias que esto le ocasiona. Ref: SP- CLIAPROTECCREDACT');

        END;


IF NOT EXISTS(SELECT ClienteID
                FROM CLIENTES
                 WHERE ClienteID = Par_ClienteID)THEN
    SET Par_NumErr  :=1;
    SET Par_ErrMen  :='El Cliente indicado no existe';
    LEAVE ManejoErrores;
END IF;

SELECT CreditoID, Estatus INTO Var_CreditoID, Var_EstatusCredito
                FROM CREDITOS
                WHERE CreditoID =Par_CreditoID;

IF(IFNULL(Var_CreditoID,EnteroCero) = EnteroCero)THEN
    SET Par_NumErr  :=2;
    SET Par_ErrMen  :='El Credito indicado no existe';
    LEAVE ManejoErrores;
END IF;

SET Var_MontoMaximoProteccion :=IFNULL((SELECT MontoMaxProtec
                                 FROM PARAMETROSCAJA LIMIT 1), Decimal_Cero);

SET Aud_FechaActual:=NOW();

UPDATE  CLIAPROTECCRED SET
        MontoAplicaCred = Par_MontoAplicaCred,

        EmpresaID       =Par_EmpresaID,
        Usuario         = Aud_Usuario,
        FechaActual     = Aud_FechaActual,
        DireccionIP     = Aud_DireccionIP,
        ProgramaID      = Aud_ProgramaID,
        Sucursal        =Aud_Sucursal,
        NumTransaccion  =Aud_NumTransaccion

        WHERE ClienteID = Par_ClienteID
            AND CreditoID = Par_CreditoID;

SELECT SUM(MontoAplicaCred) INTO Var_MontoTotalCred
        FROM CLIAPROTECCRED
            WHERE ClienteID = Par_ClienteID;
SET Var_MontoTotalCred := IFNULL(Var_MontoTotalCred, Decimal_Cero);

IF (Var_MontoTotalCred > Var_MontoMaximoProteccion)THEN
    SET Par_NumErr  :=3;
    SET Par_ErrMen  :='Se ha Superado el Monto Maximo para la Proteccion de Creditos';
LEAVE ManejoErrores;
END IF;


UPDATE  CLIAPLICAPROTEC SET
        MonAplicaCredito = Var_MontoTotalCred,

        EmpresaID       =Par_EmpresaID,
        Usuario         = Aud_Usuario,
        FechaActual     = Aud_FechaActual,
        DireccionIP     = Aud_DireccionIP,
        ProgramaID      = Aud_ProgramaID,
        Sucursal        =Aud_Sucursal,
        NumTransaccion  =Aud_NumTransaccion

        WHERE ClienteID = Par_ClienteID;


    SET Par_NumErr  :=0;
    SET Par_ErrMen  :='Proteccion de Credito Agregado Correctamente';
END ManejoErrores;

 IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            'clienteID' AS control,
            EnteroCero AS consecutivo;
END IF;

END TerminaStore$$