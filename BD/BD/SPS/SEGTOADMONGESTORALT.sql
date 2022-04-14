-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOADMONGESTORALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGTOADMONGESTORALT`;DELIMITER $$

CREATE PROCEDURE `SEGTOADMONGESTORALT`(
    Par_GestorID            INT(11),
    Par_TipoGestionID       INT(11),
    Par_SupervisorID        INT(11),
    Par_Ambito              INT(11),

    Par_Salida              CHAR(1),
    INOUT Par_NumErr        INT(11),
    INOUT Par_ErrMen        VARCHAR(400),

    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(11)
)
TerminaStore: BEGIN


    DECLARE Var_Control         VARCHAR(100);


    DECLARE Cadena_Vacia    CHAR(1);
    DECLARE Entero_Cero     INT;
    DECLARE SalidaSI        CHAR(1);


    SET Cadena_Vacia    := '';
    SET Entero_Cero     := 0;
    SET SalidaSI        := 'S';

    SET Aud_FechaActual := NOW();

ManejoErrores: BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
        SET Par_NumErr = 999;
        SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
        concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-SEGTOADMONGESTORALT');
        SET Var_Control = 'sqlException' ;
    END;


    SET Par_GestorID := IFNULL(Par_GestorID, Entero_Cero);
    IF (Par_GestorID != Entero_Cero) THEN
        IF(NOT EXISTS(SELECT UsuarioID
                        FROM USUARIOS
                            WHERE UsuarioID = Par_GestorID)) THEN
            SET Par_NumErr  := 001;
            SET Par_ErrMen  := 'El Gestor no Existe';
            SET Var_Control := 'gestorID';
            LEAVE ManejoErrores;
        END IF;
    END IF;

    SET Par_TipoGestionID := IFNULL(Par_TipoGestionID, Entero_Cero);
    IF (Par_TipoGestionID != Entero_Cero) THEN
        IF(NOT EXISTS(SELECT TipoGestionID
                        FROM TIPOGESTION
                            WHERE TipoGestionID = Par_TipoGestionID)) THEN
            SET Par_NumErr  := 002;
            SET Par_ErrMen  := 'El Tipo de Gestor no Existe';
            SET Var_Control := 'tipoGestorID';
            LEAVE ManejoErrores;
        END IF;
    END IF;

    SET Par_SupervisorID := IFNULL(Par_SupervisorID, Entero_Cero);
    IF (Par_SupervisorID != Entero_Cero) THEN
        IF(NOT EXISTS(SELECT UsuarioID
                        FROM USUARIOS
                            WHERE UsuarioID = Par_SupervisorID)) THEN
            SET Par_NumErr  := 003;
            SET Par_ErrMen  := 'El Supervisor no Existe';
            SET Var_Control := 'supervisorID';
            LEAVE ManejoErrores;
        END IF;
    END IF;

    IF(IFNULL(Par_GestorID,Cadena_Vacia)) = Cadena_Vacia THEN
            SET Par_NumErr  := 004;
            SET Par_ErrMen  := 'El Gestor esta vacio';
            SET Var_Control := 'gestorID';
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_TipoGestionID,Cadena_Vacia)) = Cadena_Vacia THEN
            SET Par_NumErr  := 005;
            SET Par_ErrMen  := 'El Tipo de Gestor esta vacio';
            SET Var_Control := 'tipoGestorID';
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_SupervisorID,Cadena_Vacia)) = Cadena_Vacia THEN
            SET Par_NumErr  := 006;
            SET Par_ErrMen  := 'El Supervisor esta vacio';
            SET Var_Control := 'supervisorID';
        LEAVE ManejoErrores;
    END IF;


    INSERT INTO SEGTOADMONGESTOR (
        GestorID,           TipoGestionID,      SupervisorID,       Ambito,             EmpresaID,
        Usuario,            FechaActual,        DireccionIP,        ProgramaID,         Sucursal,
        NumTransaccion)
    VALUES(
        Par_GestorID,       Par_TipoGestionID,  Par_SupervisorID,   Par_Ambito,         Par_EmpresaID,
        Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
        Aud_NumTransaccion);

            SET Par_NumErr  := 000;
            SET Par_ErrMen  := CONCAT("Gestor Agregado Exitosamente: ", CONVERT(Par_GestorID, CHAR));
            SET Var_Control := 'gestorID';
            SET Entero_Cero := Par_GestorID;

    END ManejoErrores;

    IF (Par_Salida = SalidaSI) THEN
        SELECT  Par_NumErr AS NumErr,
                Par_ErrMen AS ErrMen,
                Var_Control AS control,
                Entero_Cero AS consecutivo;

    END IF;

END TerminaStore$$