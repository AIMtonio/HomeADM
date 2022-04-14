-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITODEVGLALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITODEVGLALT`;DELIMITER $$

CREATE PROCEDURE `CREDITODEVGLALT`(
    Par_CreditoID           BIGINT(12),
    Par_ClienteID           INT(11),
    Par_CuentaID            BIGINT(12),
    Par_Monto               DECIMAL(14,2),
    Par_CajaID              INT(11),
    Par_SucursalID          INT(11),
    Par_Fecha               DATE,

    Par_Salida              CHAR(1),
    INOUT Par_NumErr        INT(11),
    INOUT Par_ErrMen        VARCHAR(400),

    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)

        )
TerminaStore:BEGIN


DECLARE Cadena_Vacia        CHAR(1);
DECLARE Entero_Cero         INT(11);
DECLARE SalidaSI              CHAR(1);
DECLARE Str_NO              CHAR(1);


DECLARE Var_Clave           VARCHAR(45);
DECLARE Var_Contrasenia     VARCHAR(45);
DECLARE Var_Control         VARCHAR(50);
DECLARE Var_Transaccion     INT(11);
DECLARE Var_UsuarioID       INT(11);



SET Cadena_Vacia        := '';
SET Entero_Cero         := 0;
SET SalidaSI             := 'S';
SET Str_NO              := 'N';


ManejoErrores: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr := 999;
            SET Par_ErrMen :=  CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                        'Disculpe las molestias que esto le ocasiona. Ref: SP-CREDITODEVGLALT');
        END;


IF EXISTS(SELECT CreditoID
                FROM CREDITODEVGL
                WHERE CreditoID=Par_CreditoID)THEN
        SET Par_NumErr  := 1;
        SET Par_ErrMen  := CONCAT('Ya se ha devuelto el monto de la Garantia Liquida del credito: ',Par_CreditoID);
        SET Var_Control  := 'creditoID' ;
        LEAVE ManejoErrores;
END IF;

IF(Par_Monto= Entero_Cero)THEN
        SET Par_NumErr  := 2;
        SET Par_ErrMen  := 'El monto esta vacio';
        SET Var_Control  := 'creditoID' ;
        LEAVE ManejoErrores;
END IF;

IF NOT EXISTS(SELECT CreditoID
                FROM CREDITOS
                WHERE CreditoID=Par_CreditoID)THEN
        SET Par_NumErr  := 3;
        SET Par_ErrMen  := 'El Credito no no existe';
        SET Var_Control  := 'creditoID' ;
        LEAVE ManejoErrores;
END IF;

IF NOT EXISTS(SELECT CuentaAhoID
                FROM CUENTASAHO
                WHERE CuentaAhoID=Par_CuentaID)THEN
        SET Par_NumErr  := 4;
        SET Par_ErrMen  := 'La Cuenta de Ahorro no Existe';
        SET Var_Control  := 'creditoID' ;
        LEAVE ManejoErrores;
END IF;

IF NOT EXISTS(SELECT ClienteID
                FROM CLIENTES
                WHERE ClienteID=Par_ClienteID)THEN
        SET Par_NumErr  := 5;
        SET Par_ErrMen  := 'El Cliente no existe';
        SET Var_Control  := 'creditoID' ;
        LEAVE ManejoErrores;
END IF;

IF NOT EXISTS(SELECT CajaID,SucursalID
                FROM CAJASVENTANILLA
                WHERE SucursalID=Par_SucursalID
                AND CajaID= Par_CajaID)THEN
        SET Par_NumErr  := 6;
        SET Par_ErrMen  := 'La caja especificada no existe o pertenece a otra sucursal';
        SET Var_Control  := 'creditoID' ;
        LEAVE ManejoErrores;
END IF;


    INSERT INTO CREDITODEVGL (
        CreditoID,       ClienteID,          CuentaID,              Monto,                CajaID,
        SucursalID,       Fecha,              EmpresaID,           Usuario,        FechaActual,
        DireccionIP,        ProgramaID,         Sucursal,            NumTransaccion)

    VALUES (
        Par_CreditoID,   Par_ClienteID,   Par_CuentaID,      Par_Monto,           Par_CajaID,
        Par_SucursalID,     Par_Fecha,      Par_EmpresaID,  Aud_Usuario,           Aud_FechaActual,
   Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,      Aud_NumTransaccion);


    SET Par_NumErr := 0;
    SET Par_ErrMen := "Devolucion Realizada Exitosamente";

END ManejoErrores;
 IF (Par_Salida = SalidaSI) THEN
     SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Entero_Cero AS consecutivo;
END IF;

END TerminaStore$$