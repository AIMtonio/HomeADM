-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARCREDGIROSBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARCREDGIROSBAJ`;DELIMITER $$

CREATE PROCEDURE `TARCREDGIROSBAJ`(
-- SP PARA BAJA DE GIROS DE TARJETA
    Par_TarjetaCredID       CHAR(16),       -- ID de la tarjeta de credito

    Par_Salida          CHAR(1),        -- Salida
    INOUT Par_NumErr    INT,            -- Salida
    INOUT Par_ErrMen    VARCHAR(400),   -- Salida

    Aud_EmpresaID           INT,            -- Auditoria
    Aud_Usuario             INT,            -- Auditoria
    Aud_FechaActual         DATETIME,       -- Auditoria
    Aud_DireccionIP         VARCHAR(15),    -- Auditoria
    Aud_ProgramaID          VARCHAR(50),    -- Auditoria
    Aud_Sucursal            INT,            -- Auditoria
    Aud_NumTransaccion      BIGINT          -- Auditoria
        )
TerminaStore: BEGIN
-- DECLARACION DE VARIABLES
DECLARE Var_TarjetaCredID CHAR(16);
DECLARE VarControl        VARCHAR(50);


-- DECLARACION DE CONSTANTES
    DECLARE Cadena_Vacia    CHAR(1);
    DECLARE Salida_SI   CHAR(1);
    DECLARE Entero_Cero     INT;
    DECLARE consecutivo     INT;

-- ASIGNACION DE CONSTANTES
    SET Cadena_Vacia    := '';      -- Cadena Vacia
    SET Salida_SI       := 'S';     -- Salida
    SET Entero_Cero     := 0;       -- Enetro Cero
    SET consecutivo     := 0;       -- Consucutivo

    SET Aud_FechaActual := CURRENT_TIMESTAMP();

ManejoErrores:BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET Par_NumErr = 999;
        SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                        'esto le ocasiona. Ref: SP-TARCREDGIROSBAJ');
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
        SET VarControl  := 'tarjetaID' ;
        LEAVE ManejoErrores;
    END IF;

    DELETE  FROM   TARCREDGIROS
            WHERE  TarjetaCredID = Par_TarjetaCredID;


    SET Par_NumErr  := 000;
    SET Par_ErrMen  := CONCAT(' Giro Eliminado Exitosamente. ');
    SET VarControl  := 'tarjetaCredID' ;

END ManejoErrores;

IF(Par_Salida = Salida_SI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            VarControl AS control,
            Entero_Cero AS consecutivo;
END IF;

END TerminaStore$$