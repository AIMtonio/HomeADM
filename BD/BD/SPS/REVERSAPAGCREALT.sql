-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REVERSAPAGCREALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `REVERSAPAGCREALT`;

DELIMITER $$
CREATE PROCEDURE `REVERSAPAGCREALT`(
    -- Store Procedure para dar de alta el Registro de reversa de un crédito
    -- Modulo Cartera
    Par_TransaccionID   BIGINT(20),     -- Numero de Transaccion
    Par_CreditoID       BIGINT(12),     -- Numero de Credito
    Par_UsuarioClave    VARCHAR(25),    -- Clave de Usuario
    Par_ContraseniaAut  VARCHAR(45),    -- Contrasenia de usuario
    Par_Motivo          VARCHAR(400),   -- Motivo de la Reversa
    Par_CuentaAhoID     BIGINT(12),     -- Numero de Cuenta de Ahorro

    Par_Salida          CHAR(1),        -- Parametro de Salida
    INOUT Par_NumErr    INT(11),        -- Numero de Error
    INOUT Par_ErrMen    VARCHAR(400),   -- Mensaje de Error

    Par_EmpresaID       INT(11),        -- Parametro de auditoria ID de la empresa
    Aud_Usuario         INT(11),        -- Parametro de auditoria ID del usuario
    Aud_FechaActual     DATETIME,       -- Parametro de auditoria Feha actual
    Aud_DireccionIP     VARCHAR(15),    -- Parametro de auditoria Direccion IP
    Aud_ProgramaID      VARCHAR(50),    -- Parametro de auditoria Programa
    Aud_Sucursal        INT(11),        -- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  BIGINT(20)      -- Parametro de auditoria Numero de la transaccion
)
TerminaStore:BEGIN

    -- Declaracion de Variables
    DECLARE Var_FechaOper       DATE;       -- Fecha de Operacion
    DECLARE Var_UsuarioID       INT(11);    -- Numero de Usuario
    DECLARE Var_Contrasenia     VARCHAR(45);-- Contasenia de Usuario
    DECLARE Var_ClienteID       BIGINT;     -- Numero de Cliente
    DECLARE Var_Control         VARCHAR(50);-- Control de Retorno en Pantalla

    -- Declaracion de Constantes
    DECLARE Cadena_Vacia        CHAR(1);    -- Cadena Vacia
    DECLARE Entero_Cero         INT(11);    -- Constante Entero Cero
    DECLARE Fecha_Vacia         DATE;       -- Constante Fecha Vacia
    DECLARE Str_SI              CHAR(1);    -- Constante SI

    -- Asignacion de Constantes
    SET Cadena_Vacia        := '';
    SET Entero_Cero         := 0;
    SET Fecha_Vacia         :='1900-01-01';
    SET Str_SI              := 'S';

    ManejoErrores: BEGIN

        DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
            SET Par_NumErr = 999;
            SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que',
                                    ' esto le ocasiona. Ref: SP-REVERSAPAGCREALT');
        END;

        SELECT  UsuarioID , Contrasenia INTO  Var_UsuarioID,Var_Contrasenia
        FROM USUARIOS
        WHERE Clave = Par_UsuarioClave;

        SET Var_Contrasenia := IFNULL(Var_Contrasenia, Cadena_Vacia);

        IF(Par_ContraseniaAut != Var_Contrasenia)THEN
            SET Par_NumErr  := 1;
            SET Par_ErrMen  := "Contrasena o Usuario Incorrecto.";
            SET Var_Control :='usuarioAutorizaID';
            LEAVE ManejoErrores;
        END IF;

        IF(Var_UsuarioID = Aud_Usuario)THEN
            SET Par_NumErr  := 2;
            SET Par_ErrMen  := "El usuario que realiza la Transaccion no puede ser el mismo que  Autoriza.";
            SET Var_Control :='usuarioAutorizaID';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_Motivo, Cadena_Vacia) = Cadena_Vacia)THEN
            SET Par_NumErr  := 3;
            SET Par_ErrMen  := "El Motivo de la Reversa no Puede estar Vacio";
            SET Var_Control :='motivo';
            LEAVE ManejoErrores;
        END IF;

        SELECT FechaSucursal INTO Var_FechaOper
        FROM SUCURSALES
        WHERE SucursalID = Aud_Sucursal;

        SET Var_FechaOper   := IFNULL(Var_FechaOper, Fecha_Vacia);

        SELECT  ClienteID   INTO    Var_ClienteID
        FROM  CUENTASAHO
        WHERE CuentaAhoID = Par_CuentaAhoID;
        SET Var_ClienteID := IFNULL(Var_ClienteID,Entero_Cero);

        INSERT INTO REVERSAPAGCRE(
            TransaccionID,      Fecha,          CreditoID,          Motivo,             UsuarioAut,
            ClienteID,          EmpresaID,      Usuario,            FechaActual,        DireccionIP,
            ProgramaID,         Sucursal,       NumTransaccion)
        VALUES(
            Par_TransaccionID,  Var_FechaOper,  Par_CreditoID,      Par_Motivo,         Var_UsuarioID,
            Var_ClienteID,      Par_EmpresaID,  Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
            Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion);

        SET Par_NumErr  := Entero_Cero;
        SET Par_ErrMen  := 'Reversa de Pago de Credito, Realizada Exitosamente.';
        SET Var_Control :='creditoID';

    END ManejoErrores;

    IF (Par_Salida = Str_SI) THEN
         SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
                Par_ErrMen AS ErrMen,
                Var_Control AS control,
                Entero_Cero AS consecutivo;
    END IF;
END TerminaStore$$