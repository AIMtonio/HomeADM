-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARCREDGIROSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARCREDGIROSALT`;DELIMITER $$

CREATE PROCEDURE `TARCREDGIROSALT`(
-- SP PARA EL ALTA DE GIRO DE TARJETA DE CREDITO
    Par_TarjetaCredID   CHAR(16),        -- ID de la terjeta de credito
    Par_GiroID          CHAR(4),         -- Id del giro

    Par_Salida          CHAR(1),        -- Salida
    INOUT Par_NumErr    INT,            -- Salida
    INOUT Par_ErrMen    VARCHAR(400),   -- Salida

    Aud_EmpresaID       INT(11),        -- Auditoria
    Aud_Usuario         INT,            -- Auditoria
    Aud_FechaActual     DATETIME,       -- Auditoria
    Aud_DireccionIP     VARCHAR(15),    -- Auditoria
    Aud_ProgramaID      VARCHAR(50),    -- Auditoria
    Aud_Sucursal        INT,            -- Auditoria
    Aud_NumTransaccion  BIGINT          -- Auditoria
    )
TerminaStore: BEGIN
-- DECLARACION DE VARIABLES
DECLARE Var_TarjetaCredID CHAR(16);
DECLARE VarControl        VARCHAR(50);

-- declaracion de constantes
DECLARE Entero_Cero     INT;
DECLARE Cadena_Vacia    CHAR(1);
DECLARE Salida_SI       CHAR(1);
DECLARE Salida_NO       CHAR(1);

-- asignacion de constantes
SET Entero_Cero     := 0;
SET Cadena_Vacia    := '';
SET Salida_SI       := 'S';
SET Salida_NO       := 'N';


ManejoErrores:BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET Par_NumErr = 999;
        SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                        'esto le ocasiona. Ref: SP-TARCREDGIROSALT');
    END;


    SELECT TarjetaCredID INTO Var_TarjetaCredID
                    FROM TARJETACREDITO
                    WHERE TarjetaCredID = Par_TarjetaCredID;

    IF(Var_TarjetaCredID !=Par_TarjetaCredID) THEN
        SET Par_NumErr  := 1;
        SET Par_ErrMen  := 'La tarjeta no existe';
        SET VarControl  := 'tarjetaID' ;
        LEAVE ManejoErrores;
    END IF;
    IF(IFNULL(Par_TarjetaCredID,Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr  := 2;
        SET Par_ErrMen  := 'Especifique el numero de tarjeta';
        SET VarControl  := 'tarjetaHabiente' ;
        LEAVE ManejoErrores;
    END IF;
    IF(IFNULL(Par_GiroID,Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr  := 3;
        SET Par_ErrMen  := 'Especifique el Numero del Giro';
        SET VarControl  := 'tarjetaID' ;
        LEAVE ManejoErrores;
    END IF;

    INSERT INTO `TARCREDGIROS`  VALUES( Par_TarjetaCredID,      Par_GiroID,         Aud_EmpresaID,          Aud_Usuario,
                                        Aud_FechaActual,        Aud_DireccionIP,    Aud_ProgramaID,         Aud_Sucursal,
                                        Aud_NumTransaccion );

    SET Par_NumErr  := 000;
    SET Par_ErrMen  := CONCAT('Giro agregado exitosamente');
    SET VarControl  := 'tarjetaCredID' ;

END ManejoErrores;
IF(Par_Salida = Salida_SI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            VarControl AS control,
            Entero_Cero AS consecutivo;
END IF;

END TerminaStore$$