-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_BITACORAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TC_BITACORAALT`;DELIMITER $$

CREATE PROCEDURE `TC_BITACORAALT`(
#SP PARA DAR DE ALTA EL MOVIMIENTO DE LA TARJATA
    Par_TarjetaCredID       CHAR(16),       -- tarjeta de credito
    Par_TipoEvenTDID        CHAR(16),       -- Tipo de evento
    Par_MotivoID            INT(11),        -- Motivo
    Par_DescripAdicio       VARCHAR(500),   -- Descrion del motivo
    Par_Fecha               DATETIME,       -- Fecha de registro
    Par_NombreCliente       VARCHAR(150),   -- Nombre del cliente

    Par_Salida              CHAR(1),        -- Salida
    OUT Par_NumErr          INT,            -- Salida
    OUT Par_ErrMen          VARCHAR(200),   -- Salida

    Aud_EmpresaID           INT(11),        -- Auditoria
    Aud_Usuario             INT,            -- Auditoria
    Aud_FechaActual         DATETIME,       -- Auditoria
    Aud_DireccionIP         VARCHAR(15),    -- Auditoria
    Aud_ProgramaID          VARCHAR(50),    -- Auditoria
    Aud_Sucursal            INT,            -- Auditoria
    Aud_NumTransaccion      BIGINT          -- Auditoria
    )
TerminaStore: BEGIN
    /*  variables*/
    DECLARE Var_Control             VARCHAR(100);


    #DECLARACION DE CONSTANTES
    DECLARE Entero_Cero        INT;
    DECLARE Cadena_Vacia       CHAR(1);
    DECLARE SalidaSI           CHAR(1);

    #ASIGNACION DE CONSTANTES
    SET Entero_Cero     := 0;
    SET Cadena_Vacia    := '';
    SET SalidaSI        := 'S';

    ManejoErrores: BEGIN

        DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
            SET Par_NumErr := 999;
            SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                    'Disculpe las molestias que esto le ocasiona. Ref: SP-TC_BITACORAALT');
            SET Var_Control:= 'SQLEXCEPTION' ;
        END;


        IF(IFNULL(Par_TarjetaCredID, Cadena_Vacia)) = Cadena_Vacia THEN
            SET Par_NumErr  := 1;
            SET Par_ErrMen  := 'eL Numero de tarjeta esta vacia';
            SET Var_Control := 'Par_TarjetaCredID';
            LEAVE ManejoErrores;
        END IF;
        IF(IFNULL(Par_TipoEvenTDID, Cadena_Vacia)) = Cadena_Vacia THEN
            SET Par_NumErr  := 2;
            SET Par_ErrMen  := 'El tipo de evento esta vacio';
            SET Var_Control := 'Par_TipoEvenTDID';
            LEAVE ManejoErrores;
        END IF;


        IF(IFNULL(Par_MotivoID, Cadena_Vacia)) = Cadena_Vacia THEN
            SET Par_NumErr  := 3;
            SET Par_ErrMen  := 'El motivo esta vacio';
            SET Var_Control := 'Par_MotivoID';
            LEAVE ManejoErrores;
        END IF;


        IF(IFNULL(Par_DescripAdicio, Cadena_Vacia)) = Cadena_Vacia THEN
            SET Par_NumErr  := 4;
            SET Par_ErrMen  := 'La descripcion del motivo esta vacia';
            SET Var_Control := 'Par_DescripAdicio';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_Fecha, Cadena_Vacia)) = Cadena_Vacia THEN
            SET Par_NumErr  := 5;
            SET Par_ErrMen  := 'La fecha esta vacia';
            SET Var_Control := 'Par_Fecha';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_NombreCliente, Cadena_Vacia)) = Cadena_Vacia THEN
            SET Par_NumErr  := 6;
            SET Par_ErrMen  := 'El nombre del cliente vacio';
            SET Var_Control := 'Par_NombreCliente';
            LEAVE ManejoErrores;
        END IF;

       INSERT INTO BITACORATARCRED (TarjetaCredID,          TipoEvenTDID,     MotivoBloqID,        DescripAdicio,      Fecha,
                                    NombreCliente,          EmpresaID,        Usuario,             FechaActual,        DireccionIP,
                                    ProgramaID,             Sucursal,         NumTransaccion)
                            VALUES(
                                    Par_TarjetaCredID,      Par_TipoEvenTDID, Par_MotivoID,        Par_DescripAdicio,  Par_Fecha,
                                    Par_NombreCliente,      Aud_EmpresaID,    Aud_Usuario,         Aud_FechaActual,    Aud_DireccionIP,
                                    Aud_ProgramaID,         Aud_Sucursal,     Aud_NumTransaccion
                                    );

        SET Par_NumErr  := 000;
        SET Par_ErrMen  := CONCAT('Registro de Bitacora Exitosamente: ', Par_TarjetaCredID);
        SET Var_Control := 'tarjetaCredID';

    END ManejoErrores;
    IF (Par_Salida = SalidaSI) THEN
        SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Entero_Cero AS consecutivo;
    END IF;
END TerminaStore$$