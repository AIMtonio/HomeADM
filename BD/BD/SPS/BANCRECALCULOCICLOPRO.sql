-- BANCRECALCULOCICLOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `BANCRECALCULOCICLOPRO`;
DELIMITER $$


CREATE PROCEDURE `BANCRECALCULOCICLOPRO`(

    Par_ClienteID               BIGINT(20),
    Par_ProspectoID             BIGINT(20),
    Par_ProductoCreditoID       INT(11),

    Par_Salida                  CHAR(1),
    INOUT   Par_NumErr          INT(11),
    INOUT   Par_ErrMen          VARCHAR(400),

    Aud_EmpresaID               INT(11),
    Aud_Usuario                 INT(11),
    Aud_FechaActual             DATETIME,
    Aud_DireccionIP             VARCHAR(15),
    Aud_ProgramaID              VARCHAR(50),
    Aud_Sucursal                INT(11),
    Aud_NumTransaccion          BIGINT
)
TerminaStore: BEGIN


    DECLARE Var_CicloCliente    INT(11);
    DECLARE Var_Control         VARCHAR(100);


    DECLARE Cadena_Vacia        CHAR(1);
    DECLARE Entero_Cero         INT(11);
    DECLARE Fecha_Vacia         DATE;
    DECLARE Salida_SI           CHAR(1);
    DECLARE Salida_NO           CHAR(1);


    SET Cadena_Vacia        := '';
    SET Fecha_Vacia         := '1900-01-01';
    SET Entero_Cero         := 0;
    SET Salida_SI           := 'S';
    SET Salida_NO           := 'N';


    SET Var_CicloCliente        := IFNULL(Var_CicloCliente, Entero_Cero);

    SET Par_ClienteID           := IFNULL(Par_ClienteID, Entero_Cero);
    SET Par_ProspectoID         := IFNULL(Par_ProspectoID, Entero_Cero);
    ManejoErrores: BEGIN

        DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
            SET Par_NumErr    := 999;
            SET Par_ErrMen    := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
            'Disculpe las molestias que esto le ocasiona. Ref: SP-BANCRECALCULOCICLOPRO');
            SET Var_Control := 'SQLEXCEPTION';
        END;

        CALL CRECALCULOCICLOPRO (
            Par_ClienteID,          Par_ProspectoID,            Par_ProductoCreditoID,          Entero_Cero,            Var_CicloCliente,
            Entero_Cero,            Salida_NO,                  Aud_EmpresaID,                  Aud_Usuario,            Aud_FechaActual,
            Aud_DireccionIP,        Aud_ProgramaID,             Aud_Sucursal,                   Aud_NumTransaccion
        );

        SET Par_NumErr := 0;
        SET Par_ErrMen := 'Se ha realizado el calculo de numero de creditos exitosamente';

    END ManejoErrores;

    IF (Par_Salida = Salida_SI) THEN
        SELECT  Var_CicloCliente AS CicloCliente,
                Par_NumErr AS NumErr,
                Par_ErrMen AS ErrMen;
    END IF;

END TerminaStore$$
