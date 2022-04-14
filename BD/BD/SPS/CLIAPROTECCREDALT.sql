-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIAPROTECCREDALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIAPROTECCREDALT`;DELIMITER $$

CREATE PROCEDURE `CLIAPROTECCREDALT`(
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

DECLARE Var_EstatusCredito          CHAR(1);
DECLARE Var_CreditoID               BIGINT(12);
DECLARE Var_MontoMaximoProteccion   DECIMAL(14,2);
DECLARE Var_MontoAplicadoCreditos   DECIMAL(14,2);
DECLARE Var_SumaMontoAplicaraCred   DECIMAL(14,2);


DECLARE MontoAdeudo         DECIMAL(14,2);
DECLARE EnteroCero          INT;
DECLARE CadenaVacia         CHAR(1);
DECLARE SalidaSI            CHAR(1);
DECLARE Decimal_Cero        DECIMAL;
DECLARE EstatusRegistrado   CHAR(1);


SET MontoAdeudo         :=0.00;
SET EnteroCero          :=0;
SET CadenaVacia         :='';
SET SalidaSI            :='S';
SET Decimal_Cero        :=0.00;
SET EstatusRegistrado   :='R';

ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
            SET Par_NumErr = 999;
            SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                'Disculpe las molestias que esto le ocasiona. Ref: SP- CLIAPROTECCREDALT');

        END;

    IF NOT EXISTS(SELECT ClienteID
                    FROM CLIENTES
                     WHERE ClienteID = Par_ClienteID)THEN
        SET Par_NumErr  :=1;
        SET Par_ErrMen  :='El Cliente Indicado No Existe';
        LEAVE ManejoErrores;
    END IF;

    SELECT CreditoID, Estatus INTO Var_CreditoID, Var_EstatusCredito
                    FROM CREDITOS
                    WHERE CreditoID =Par_CreditoID;

    SET Var_EstatusCredito  :=IFNULL(Var_EstatusCredito,CadenaVacia);
    SET MontoAdeudo         := IFNULL(FUNCIONTOTDEUDACRE(Par_CreditoID), EnteroCero);

    IF(IFNULL(Var_CreditoID,EnteroCero) = EnteroCero)THEN
        SET Par_NumErr  :=2;
        SET Par_ErrMen  :='El Credito indicado no existe.';
        LEAVE ManejoErrores;
    END IF;

    IF(Par_MontoAplicaCred = Decimal_Cero)THEN
        SET Par_NumErr  :=3;
        SET Par_ErrMen  :='El Credito indicado no existe';
        LEAVE ManejoErrores;
    END IF;

    SELECT MontoMaxProtec INTO Var_MontoMaximoProteccion
            FROM PARAMETROSCAJA LIMIT 1;

    SET Var_MontoMaximoProteccion :=IFNULL(Var_MontoMaximoProteccion, Decimal_Cero);

    SELECT SUM(MontoAplicaCred) INTO Var_MontoAplicadoCreditos
            FROM CLIAPROTECCRED
                WHERE ClienteID =Par_ClienteID;

    SET Var_MontoAplicadoCreditos   := IFNULL(Var_MontoAplicadoCreditos, Decimal_Cero);
    SET Var_SumaMontoAplicaraCred   := Var_MontoAplicadoCreditos + Par_MontoAplicaCred;

    IF (Var_SumaMontoAplicaraCred > Var_MontoMaximoProteccion)THEN
        SET Par_NumErr  := 4;
        SET Par_ErrMen  := 'Se ha Superado el Monto Maximo para la Proteccion de Creditos';
        LEAVE ManejoErrores;
    END IF;

    SET Aud_FechaActual:=NOW();

    INSERT INTO CLIAPROTECCRED(
        ClienteID,      CreditoID,      MontoAdeudo,        Estatus,        MontoAplicaCred,
        EmpresaID,      Usuario,        FechaActual,        DireccionIP,    ProgramaID,
        Sucursal,       NumTransaccion)
    VALUES(
        Par_ClienteID,  Par_CreditoID,  MontoAdeudo,        Var_EstatusCredito, Par_MontoAplicaCred,
        Par_EmpresaID,  Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
        Aud_Sucursal,   Aud_NumTransaccion);

        SET Par_NumErr  :=0;
        SET Par_ErrMen  :='Solicitud al Programa Proteccion de Credito Agregado Correctamente';
    END ManejoErrores;

 IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            'clienteID' AS control,
            EnteroCero AS consecutivo;
END IF;

END TerminaStore$$