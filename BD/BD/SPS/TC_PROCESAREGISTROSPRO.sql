-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_PROCESAREGISTROSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TC_PROCESAREGISTROSPRO`;DELIMITER $$

CREATE PROCEDURE `TC_PROCESAREGISTROSPRO`(
-- ---------------------------------------------------------------------------------
--  Se encarga de procesar las transacciones de tarjetas de
--  credito que se cargaron con los archivos de transaccion
-- ---------------------------------------------------------------------------------
    Par_Transaccion BIGINT  ,               -- Numero de transaccion de la carga

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

    DECLARE Var_NumRegistro         INT;            -- Numero de registros cargados
    DECLARE Var_MaxFilas            INT;            -- Numero maximo de filas
    DECLARE Var_PosFila             INT;            -- Posicion del CURSOR
    DECLARE Var_CountProcesados     INT;            -- Contar los procesados
    DECLARE Var_TxtFila             VARCHAR(400);   -- Guarda el contenido de la fila
    DECLARE Var_TxtFecha            VARCHAR(10);    -- Fecha de operacion
    DECLARE Var_TxtTotalAplicar     DECIMAL(16,2);  -- Monto de operacion
    DECLARE Var_DatosTiempoAire     VARCHAR(20);    -- Datos de tiempo aire
    DECLARE Var_SalidaNo            CHAR(1);        -- Indica una salida de datos
    DECLARE Var_TipoArchivo         CHAR(1);        -- Tipo de Archivo Cargado

    DECLARE Var_FechaReporte        DATE;           -- Fecha del reporte
    DECLARE Var_FechaOperacion      DATE;           -- Fecha de la operacion
    DECLARE Var_FechaSistema        DATE;           -- Fecha actual del sistema
    DECLARE Var_HoraReporte         TIME;           -- Hora del reporte
    DECLARE Var_HoraOperacion       TIME;           -- Hora de Operacion
    DECLARE Var_TotalAplicar        DECIMAL(16,2);  -- Total a aplicar
    DECLARE Var_Exitosos            INT;            -- Numero de transacciones exitosas
    DECLARE Var_Fallidos            INT;            -- Numero de transacciones fallidas
    DECLARE Var_NumTransacciones    INT;            -- Nuero de transacciones

    -- >> Variables archivo

    DECLARE Var_CT              VARCHAR(2);         -- Tipo de operacion
    DECLARE Var_Tarjeta         VARCHAR(16);        -- Numero de tarjeta
    DECLARE Var_NombreNegocio   VARCHAR(25);        -- Nombre del lugar o negocio
    DECLARE Var_Ciudad          VARCHAR(14);        -- Nombre de la ciudad
    DECLARE Var_Pais            VARCHAR(5);         -- Nombre del pais
    DECLARE Var_MCC             VARCHAR(8);         -- Codigo del negocio
    DECLARE Var_Valor           VARCHAR(16);        -- Monto de operacion
    DECLARE Var_Moneda          VARCHAR(6);         -- Codigo de la moneda
    DECLARE Var_Referencia      VARCHAR(25);        -- Referencia de la operacion
    DECLARE Var_FTran           VARCHAR(6);         -- Folio de transaccion
    DECLARE Var_CPD             VARCHAR(6);         -- Fecha Juliana
    DECLARE Var_IRD             VARCHAR(6);         -- Familia asociada al negocio
    DECLARE Var_Comision        VARCHAR(16);        -- Monto de comision
    DECLARE Var_Autorizacion    VARCHAR(16);        -- Numero de Autorizacion
    DECLARE Var_IVA             VARCHAR(16);        -- Monto de IVA

    DECLARE Var_Naturaleza      CHAR(1);            -- Naturaleza del movimiento

    -- << -- Variables

    DECLARE Es_Local            CHAR(1);
    DECLARE Es_Internacional    CHAR(1);
    DECLARE Entero_Cero         INT;
    DECLARE Origen_Archivo      CHAR(1);
    DECLARE Salida_SI           CHAR(1);
    DECLARE Trans_POS           VARCHAR(5);
    DECLARE Des_TransLocal      VARCHAR(50);
    DECLARE Entero_Vacio        VARCHAR(5);
    DECLARE Cadena_Vacia        VARCHAR(5);

    SET Var_PosFila             := 1;
    SET Var_CountProcesados     := 0;
    SET Var_HoraOperacion       := '12:00:00';
    SET Var_DatosTiempoAire     := '';
    SET Cadena_Vacia            := '';
    SET Var_SalidaNo            := 'N';
    SET Es_Local                := 'L';
    SET Es_Internacional        := 'I';
    SET Var_Exitosos            := 0;
    SET Var_Fallidos            := 0;
    SET Entero_Cero             := 0;
    SET Origen_Archivo          := 'A';
    SET Trans_POS               := '1200';
    SET Entero_Vacio            := '0.00';
    SET Salida_SI               := 'S';
    SET Des_TransLocal          := 'Incoming Local';

ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
      BEGIN
        SET Par_NumErr  = 999;
        SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                  'esto le ocasiona. Ref: SP-TC_PROCESAREGISTROSPRO');
      END;

    SELECT COUNT(*)
        INTO Var_MaxFilas
        FROM TC_ARCHIVOTRANSTEMP
        WHERE Transaccion = Par_Transaccion;

    SET Var_MaxFilas := IFNULL(Var_MaxFilas,Entero_Cero);

    IF Var_MaxFilas = Entero_Cero THEN
        SET Par_NumErr:= 101;
        SET Par_ErrMen:= 'Archivo Vacio';
        LEAVE ManejoErrores;
    END IF;

    SELECT FechaSistema
        INTO Var_FechaSistema
        FROM PARAMETROSSIS
        WHERE EmpresaID = Par_EmpresaID;

    -- ----------------------------------------------------------
    --  Se revisan los encabezados del archivo
    -- ----------------------------------------------------------
    -- Fecha Reporte
    SELECT Contenido
            INTO Var_TxtFila
            FROM TC_ARCHIVOTRANSTEMP
            WHERE Transaccion = Par_Transaccion
            AND NumLinea = 1 ; -- Fecha

    SET Var_TxtFecha := trim(SUBSTRING_INDEX(Var_TxtFila, ' Reporte:', -1));
    SET Var_FechaReporte := str_to_date(Var_TxtFecha,'%d/%m/%Y');

    -- Hora Reporte
    SELECT Contenido
            INTO Var_TxtFila
            FROM TC_ARCHIVOTRANSTEMP
            WHERE Transaccion = Par_Transaccion
            AND NumLinea = 2 ; -- hora


    IF locate(Des_TransLocal,Var_TxtFila) > Entero_Cero THEN
        SET Var_TipoArchivo := Es_Local;
    ELSE
        SET Var_TipoArchivo := Es_Internacional;
    END IF;

    SET Var_HoraReporte := trim(SUBSTRING_INDEX(Var_TxtFila, 'HORA:', -1));

    -- Actualizar datos del archivo
    UPDATE TC_ARCHIVOTRANSACCION
        SET FechaReporte = Var_FechaReporte,
            HoraReporte = Var_HoraReporte,
            TipoArchivo = Var_TipoArchivo
    WHERE  NumTransaccion = Par_Transaccion;


    SELECT COUNT(*)
        INTO Var_NumTransacciones
        FROM TC_ARCHIVOTRANSTEMP tem, TC_TIPOSOPERACION tip
        WHERE Transaccion = Par_Transaccion
        AND substr(tem.Contenido,1,2) = tip.TipoOperacionID
        AND substr(tem.Contenido,3,1) = ' ';

    SET Var_NumTransacciones := IFNULL(Var_NumTransacciones, Entero_Cero);

    IF Var_NumTransacciones = Entero_Cero THEN
        SET Par_NumErr:= 102;
        SET Par_ErrMen:= 'Sin registros por procesar';
        LEAVE ManejoErrores;
    END IF;

    -- ----------------------------------------------------------
    --  Se inicia el ciclo para procesar cada linea del archivo
    --  Inicia a partir de la linea 7
    -- ----------------------------------------------------------
    SET Var_PosFila := 7;
    SET Var_TxtTotalAplicar := Entero_Cero;

    WHILE Var_PosFila <= Var_MaxFilas do
    CicloWhile:BEGIN

        SELECT Contenido
            INTO Var_TxtFila
            FROM TC_ARCHIVOTRANSTEMP
            WHERE Transaccion = Par_Transaccion
            AND NumLinea = Var_PosFila;

        IF EXISTS (SELECT  Contenido
                    FROM TC_ARCHIVOTRANSTEMP tem, TC_TIPOSOPERACION tip
                    WHERE Transaccion = Par_Transaccion
                    AND NumLinea = Var_PosFila
                    AND substr(tem.Contenido,1,2) = tip.TipoOperacionID
                    AND substr(tem.Contenido,3,1) = ' ') THEN

                -- Se inicia con la lectura del archivo por posiciones
                IF Var_TipoArchivo = Es_Local THEN
                    SELECT trim(substr(Var_TxtFila ,1,2))    AS CT ,
                           trim(substr(Var_TxtFila ,4,16))   AS Tarjeta ,
                           trim(substr(Var_TxtFila ,21,24))  AS NombreNegocio ,
                           trim(substr(Var_TxtFila ,46,13))  AS Ciudad ,
                           trim(substr(Var_TxtFila ,60,6))   AS Pais ,
                           trim(substr(Var_TxtFila ,66,6))   AS MCC ,
                           trim(substr(Var_TxtFila ,73,15))  AS Valor ,
                           trim(substr(Var_TxtFila ,89,9))   AS Moneda ,
                           trim(substr(Var_TxtFila ,98,25))  AS Referencia ,
                           trim(substr(Var_TxtFila ,125,7))  AS FTran ,
                           trim(substr(Var_TxtFila ,132,6))  AS CPD ,
                           trim(substr(Var_TxtFila ,139,6))  AS IRD ,
                           trim(substr(Var_TxtFila ,146,16)) AS Comision ,
                           trim(substr(Var_TxtFila ,164,15)) AS Autorizacion ,
                           trim(substr(Var_TxtFila ,180,16)) AS IVA
                    INTO Var_CT,        Var_Tarjeta,        Var_NombreNegocio,
                         Var_Ciudad,    Var_Pais,           Var_MCC,
                         Var_Valor,     Var_Moneda,         Var_Referencia,
                         Var_FTran,     Var_CPD,            Var_IRD,
                         Var_Comision,  Var_Autorizacion,   Var_IVA;
                ELSE
                    -- Es Internacional

                    SELECT trim(substr(Var_TxtFila ,1,2))   AS CT ,
                       trim(substr(Var_TxtFila ,4,16))      AS Tarjeta ,
                       trim(substr(Var_TxtFila ,21,24))     AS NombreNegocio ,
                       trim(substr(Var_TxtFila ,46,15))     AS Ciudad ,
                       trim(substr(Var_TxtFila ,61,6))      AS Pais ,
                       trim(substr(Var_TxtFila ,67,6))      AS MCC ,
                       trim(substr(Var_TxtFila ,73,6))      AS Moneda ,
                       trim(substr(Var_TxtFila ,98,12))     AS Comision ,
                       trim(substr(Var_TxtFila ,131,14))    AS Valor ,
                       trim(substr(Var_TxtFila ,153,23))    AS Referencia ,
                       trim(substr(Var_TxtFila ,177,7))     AS FTran ,
                       Cadena_Vacia AS CPD ,
                       Cadena_Vacia AS IRD ,
                       trim(substr(Var_TxtFila ,192,7)) AS Autorizacion ,
                       Entero_Vacio AS IVA
                    INTO Var_CT,        Var_Tarjeta,        Var_NombreNegocio,
                         Var_Ciudad,    Var_Pais,           Var_MCC,
                         Var_Moneda,    Var_Comision,       Var_Valor,
                         Var_Referencia,Var_FTran,          Var_CPD,
                         Var_IRD,       Var_Autorizacion,   Var_IVA;

                END IF;

                -- Se eliminan las comas del monto de transaccion
                SET Var_IVA := REPLACE(Var_IVA,',','.');

                SET Var_FechaOperacion := str_to_date(CONCAT(date_format(Var_FechaSistema,'%Y'),'/',Var_FTran),'%Y/%m/%d');

                SET Var_Valor := REPLACE(Var_Valor,',','');

                -- Se hace la llamada el SP para procesar las operaciones
                CALL TC_TRANSACCIONESPRO(
                    Origen_Archivo,     Trans_POS,      Var_CT,              Var_Tarjeta,           Var_Valor,
                    Entero_Cero,        Entero_Cero,    Entero_Cero,         Var_Moneda,            Var_FechaOperacion,
                    Var_HoraOperacion,  Var_MCC,        Var_IRD,             Var_NombreNegocio,     Var_Ciudad,
                    Var_Pais,           Var_Referencia, Var_DatosTiempoAire, Var_Autorizacion,      Cadena_Vacia,
                    Var_SalidaNo,       Par_NumErr,     Par_ErrMen ,

                    Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,     Aud_DireccionIP,       Aud_ProgramaID,
                    Aud_Sucursal,       Aud_NumTransaccion);

                IF Par_NumErr = Entero_Cero THEN
                    SET Var_Exitosos    := Var_Exitosos + 1;
                ELSE
                    SET Var_Fallidos    := Var_Fallidos + 1;
                END IF;

                SET Var_TxtTotalAplicar := Var_TxtTotalAplicar + CAST(Var_Valor AS DECIMAL(10,2));
                SET Var_CountProcesados := Var_CountProcesados + 1;

        END IF; -- Fin , valida operacion fila
        SET Var_PosFila := Var_PosFila + 1;
    END CicloWhile;
    END WHILE;

    /* -------------------- ACTUALIZAR DATOS ---------------------- */
    UPDATE TC_ARCHIVOTRANSACCION
                SET TotalAplicar = Var_TxtTotalAplicar,
                    NumRegistros = Var_NumTransacciones
            WHERE  NumTransaccion = Par_Transaccion;

            SET Var_PosFila := Var_MaxFilas + 1;


    SET Par_NumErr:= 0;
    SET Par_ErrMen:= CONCAT('Operaciones Procesadas Exitosamente <br> - Exitosas: ',Var_Exitosos,'<br> - Fallidas: ',Var_Fallidos);

END ManejoErrores;

    IF Par_Salida = Salida_SI THEN
        SELECT Par_NumErr AS NumErr,
               Par_ErrMen AS ErrMen,
               Var_Exitosos AS NumExitosos,
               Var_Fallidos AS NumFallidos,
               Var_CountProcesados AS NumProcesados;

    END IF;


END TerminaStore$$