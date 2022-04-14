-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOADMONXZONALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGTOADMONXZONALT`;DELIMITER $$

CREATE PROCEDURE `SEGTOADMONXZONALT`(
    Par_GestorID            INT(11),
    Par_TipoGestionID       INT(11),
    Par_EstadoID            INT(11),
    Par_MunicipioID         INT(11),
    Par_LocalidadID         INT(11),
    Par_ColoniaID           INT(11),

    Par_Salida              CHAR(1),
    INOUT Par_NumErr        INT,
    INOUT Par_ErrMen        VARCHAR(400),

    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
    )
TerminaStore: BEGIN

    DECLARE Var_Control      VARCHAR(100);
    DECLARE Var_NomEstado    VARCHAR(200);
    DECLARE Var_TipoGes      VARCHAR(200);
    DECLARE Var_Ambito       INT(11);



    DECLARE Cadena_Vacia    CHAR(1);
    DECLARE Entero_Cero     INT(11);
    DECLARE SalidaSI        CHAR(1);
    DECLARE TipoAmbito      INT(11);


    SET Cadena_Vacia    := '';
    SET Entero_Cero     := 0;
    SET SalidaSI        := 'S';
    SET TipoAmbito      := 3;

    SET Par_MunicipioID := IFNULL(Par_MunicipioID, Entero_Cero);
    SET Par_LocalidadID := IFNULL(Par_LocalidadID, Entero_Cero);
    SET Par_ColoniaID   := IFNULL(Par_ColoniaID, Entero_Cero);

    SET Aud_FechaActual := NOW();

    ManejoErrores: BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
        SET Par_NumErr = 999;
        SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
        concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-SEGTOADMONXZONALT');
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

    IF(IFNULL(Par_EstadoID,Entero_Cero)) = Entero_Cero THEN
            SET Par_NumErr  := 003;
            SET Par_ErrMen  := 'El Estado esta vacio';
            SET Var_Control := 'estadoID';
        LEAVE ManejoErrores;
    END IF;

    SET Var_NomEstado := (SELECT Nombre FROM ESTADOSREPUB
        WHERE EstadoID = Par_EstadoID);
    SET Var_TipoGes := (SELECT Descripcion FROM TIPOGESTION WHERE TipoGestionID=Par_TipoGestionID);

    SELECT  IFNULL(Seg.Ambito,Entero_Cero)
        INTO Var_Ambito
        FROM  SEGTOADMONGESTOR  Seg
            LEFT OUTER JOIN SEGTOADMONXZONA Segt
                ON Seg.GestorID=Segt.GestorID
            WHERE Segt.EstadoID = Par_EstadoID
                AND Seg.TipoGestionID = Par_TipoGestionID
                AND Seg.TipoGestionID = Segt.TipoGestionID
                AND Segt.MunicipioID = Entero_Cero;

        IF(Var_Ambito=TipoAmbito)THEN
                SET Par_NumErr  := 004;
                SET Par_ErrMen  := CONCAT("La Zona Geografica de: ", CONVERT(Var_NomEstado, CHAR), " ya se encuentra registrado
                                    para el Tipo de Gestion: ",CONVERT(Var_TipoGes, CHAR));
                SET Var_Control := 'gestorID';
                LEAVE ManejoErrores;
            END IF;


    SET Var_NomEstado := (SELECT Nombre FROM ESTADOSREPUB
        WHERE EstadoID = Par_EstadoID);
    SELECT  IFNULL(Seg.Ambito,Entero_Cero)
        INTO Var_Ambito
        FROM  SEGTOADMONGESTOR  Seg
            LEFT OUTER JOIN SEGTOADMONXZONA Segt
                ON Seg.GestorID=Segt.GestorID
            WHERE Segt.EstadoID = Par_EstadoID
                AND Seg.TipoGestionID = Par_TipoGestionID
                AND Seg.TipoGestionID = Segt.TipoGestionID
                AND Segt.MunicipioID = Par_MunicipioID
                AND Segt.LocalidadID = Entero_Cero;

        IF(Var_Ambito=TipoAmbito)THEN
                SET Par_NumErr  := 005;
                SET Par_ErrMen  := CONCAT("La Zona Geografica de: ", CONVERT(Var_NomEstado, CHAR), " ya se encuentra registrado
                                    para el Tipo de Gestion: ",CONVERT(Var_TipoGes, CHAR));
                SET Var_Control := 'gestorID';
                LEAVE ManejoErrores;
            END IF;

    SET Var_NomEstado := (SELECT Nombre FROM ESTADOSREPUB
        WHERE EstadoID = Par_EstadoID);
    SELECT  IFNULL(Seg.Ambito,Entero_Cero)
        INTO Var_Ambito
        FROM  SEGTOADMONGESTOR  Seg
            LEFT OUTER JOIN SEGTOADMONXZONA Segt
                ON Seg.GestorID=Segt.GestorID
            WHERE Segt.EstadoID = Par_EstadoID
                AND Seg.TipoGestionID = Par_TipoGestionID
                AND Seg.TipoGestionID = Segt.TipoGestionID
                AND Segt.MunicipioID = Par_MunicipioID
                AND Segt.LocalidadID = Par_LocalidadID
                AND Segt.ColoniaID = Entero_Cero;

        IF(Var_Ambito=TipoAmbito)THEN
                SET Par_NumErr  := 006;
                SET Par_ErrMen  := CONCAT("La Zona Geografica de: ", CONVERT(Var_NomEstado, CHAR), " ya se encuentra registrado
                                    para el Tipo de Gestion: ",CONVERT(Var_TipoGes, CHAR));
                SET Var_Control := 'gestorID';
                LEAVE ManejoErrores;
            END IF;

     IF(EXISTS(SELECT GestorID FROM SEGTOADMONXZONA
            WHERE GestorID = Par_GestorID
            AND TipoGestionID = Par_TipoGestionID
            AND EstadoID = Par_EstadoID
            AND MunicipioID = Par_MunicipioID
            AND LocalidadID = Par_LocalidadID
            AND ColoniaID = Par_ColoniaID))
            THEN
                SET Par_NumErr  := 007;
            SET Par_ErrMen  := CONCAT("La Colonia seleccionada ya se encuentra registrado
                                    para el Tipo de Gestion: ",CONVERT(Var_TipoGes, CHAR));
                SET Var_Control := 'gestorID';
                LEAVE ManejoErrores;
            END IF;



    INSERT INTO SEGTOADMONXZONA (
        GestorID,           TipoGestionID,      EstadoID,           MunicipioID,        LocalidadID,
        ColoniaID,          EmpresaID,          Usuario,            FechaActual,        DireccionIP,
        ProgramaID,         Sucursal,           NumTransaccion)
    VALUES(
        Par_GestorID,       Par_TipoGestionID,   Par_EstadoID,      Par_MunicipioID,    Par_LocalidadID,
        Par_ColoniaID,      Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
        Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

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