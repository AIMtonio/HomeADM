-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_ARCHIVOTRANSACCIONALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TC_ARCHIVOTRANSACCIONALT`;DELIMITER $$

CREATE PROCEDURE `TC_ARCHIVOTRANSACCIONALT`(
-- ---------------------------------------------------------------------------------
-- REGISTRA EL ENCABEZADO DEL ARCHIVO DE TRANSACCIONES
-- ---------------------------------------------------------------------------------
    Par_FechaCarga          DATE,           -- Fecha de carga del archivo
    Par_NombreArchivo       VARCHAR(400),   -- Nombre del archivo cargado
    Par_TipoArchivo         CHAR(1),        --  'L: Local, I: Internacional',
    Par_TipoCarga           CHAR(1),        --  'C: Compras, P: Pagos',

    Par_Salida              CHAR(1),        -- Salida
    INOUT Par_NumErr        INT,            -- Salida
    INOUT Par_ErrMen        VARCHAR(400),   -- Salida

    Par_EmpresaID           INT(11) ,       -- Auditoria
    Aud_Usuario             INT(11),        -- Auditoria
    Aud_FechaActual         DATETIME ,      -- Auditoria
    Aud_DireccionIP         VARCHAR(15) ,   -- Auditoria
    Aud_ProgramaID          VARCHAR(50) ,   -- Auditoria
    Aud_Sucursal            INT(11) ,       -- Auditoria
    Aud_NumTransaccion      BIGINT(20)      -- Auditoria


)
TerminaStore:BEGIN

DECLARE Var_NumArchivo  INT;
DECLARE Var_FechaCarga  DATE;

DECLARE Fecha_Vacia     DATE;
DECLARE Hora_Vacia      TIME;
DECLARE Entero_Cero     INT;
DECLARE Cadena_Vacia    VARCHAR(2);
DECLARE Salida_SI       CHAR(1);


SET Var_FechaCarga  := DATE(NOW());
SET Fecha_Vacia     := '1900-01-01';
SET Hora_Vacia      := '00:00:00';
SET Entero_Cero     := 0;
SET Cadena_Vacia    := '';
SET Salida_SI       := 'S';

ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
      BEGIN
        SET Par_NumErr  = 999;
        SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                  'esto le ocasiona. Ref: SP-TC_ARCHIVOTRANSACCIONALT');
      END;


    SELECT MAX(ArchivoTarCredID)
        INTO Var_NumArchivo
        FROM TC_ARCHIVOTRANSACCION;

    SET Var_NumArchivo := IFNULL(Var_NumArchivo,Entero_Cero) +1;
    SET Par_NombreArchivo := SUBSTRING_INDEX(Par_NombreArchivo, '/', -1);

    INSERT INTO TC_ARCHIVOTRANSACCION
        (ArchivoTarCredID,  FechaCarga,     FechaReporte,   HoraReporte,    NombreArchivo,
        TipoArchivo,        TotalAplicar,   NumRegistros,   BinExterno, TipoCarga,
        EmpresaID,          Usuario,        FechaActual,    DireccionIP,    ProgramaID,
        Sucursal,           NumTransaccion)
    VALUES
        (Var_NumArchivo,    Var_FechaCarga,     Fecha_Vacia,        Hora_Vacia,         Par_NombreArchivo,
         Par_TipoArchivo,   Entero_Cero,        Entero_Cero,        Cadena_Vacia,       Par_TipoCarga,
         Par_EmpresaID,     Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
         Aud_Sucursal,      Aud_NumTransaccion);

    DELETE FROM TC_ARCHIVOTRANSTEMP
        WHERE Transaccion = Aud_NumTransaccion;

    SET Par_NumErr:= 0;
    SET Par_ErrMen:= 'Registro Archivo Exitoso';

END ManejoErrores;

    IF Par_Salida = Salida_SI THEN
        SELECT Par_NumErr AS NumErr,
               Par_ErrMen AS ErrMen;

    END IF;

END TerminaStore$$