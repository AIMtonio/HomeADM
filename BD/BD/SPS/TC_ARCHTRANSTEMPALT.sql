-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_ARCHTRANSTEMPALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TC_ARCHTRANSTEMPALT`;DELIMITER $$

CREATE PROCEDURE `TC_ARCHTRANSTEMPALT`(
-- ---------------------------------------------------------------------------------
-- REGISTRA EL CONTENIDO DE LOS ARCHIVOS CARGADOS PARA PAGOS Y TRANSACCIONES
-- ---------------------------------------------------------------------------------
    Par_Transaccion         BIGINT ,       -- Numero de transaccion
    Par_Contenido           VARCHAR(500),  -- Contenido del archivo

    Par_Salida              CHAR(1),       -- Salida
    INOUT Par_NumErr        INT,           -- Salida
    INOUT Par_ErrMen        VARCHAR(400),  -- Salida

    Par_EmpresaID           INT(11) ,       -- Auditoria
    Aud_Usuario             INT(11),        -- Auditoria
    Aud_FechaActual         DATETIME ,      -- Auditoria
    Aud_DireccionIP         VARCHAR(15) ,   -- Auditoria
    Aud_ProgramaID          VARCHAR(50) ,   -- Auditoria
    Aud_Sucursal            INT(11) ,       -- Auditoria
    Aud_NumTransaccion      BIGINT(20)      -- Auditoria

)
TerminaStore:BEGIN

DECLARE Var_NumRegistro INT;

DECLARE Entero_Cero     INT;
DECLARE Salida_SI       CHAR(1);

SET Entero_Cero         := 0;
SET Salida_SI           := 'S';

ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
                SET Par_NumErr  = 999;
                SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                    'Disculpe las molestias que esto le ocasiona. Ref: SP-TC_ARCHTRANSTEMPALT');
            END;

    SELECT  MAX(NumLinea)
    INTO Var_NumRegistro
    FROM TC_ARCHIVOTRANSTEMP
    WHERE Transaccion = Par_Transaccion;

    SET Var_NumRegistro := IFNULL(Var_NumRegistro,Entero_Cero)+1;

    INSERT INTO TC_ARCHIVOTRANSTEMP
    VALUES (Par_Transaccion,    Var_NumRegistro,    Par_Contenido,  Par_EmpresaID,  Aud_Usuario,
            Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion);

    SET Par_NumErr:= 0;
    SET Par_ErrMen:= 'Registro Contenido Exitoso';

END ManejoErrores;

   IF Par_Salida = Salida_SI THEN
        SELECT Par_NumErr AS NumErr,
               Par_ErrMen AS ErrMen;

    END IF;

END TerminaStore$$