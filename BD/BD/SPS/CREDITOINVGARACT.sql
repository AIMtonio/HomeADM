-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOINVGARACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOINVGARACT`;DELIMITER $$

CREATE PROCEDURE `CREDITOINVGARACT`(
    Par_CreditoInvGarID     BIGINT(12),
    Par_CreditoID           BIGINT(12),
    Par_InversionID         INT(11),
    Par_PolizaID            BIGINT(20),
    Par_NumAct              TINYINT UNSIGNED,

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
TerminaStore: BEGIN


DECLARE Cadena_Vacia        CHAR(1);
DECLARE Entero_Cero         INT;
DECLARE Fecha_Vacia         DATE;
DECLARE Salida_SI           CHAR(1);
DECLARE Salida_NO           CHAR(1);
DECLARE Act_Eliminar        INT;
DECLARE Act_Liberar         INT;
DECLARE Act_LiberarPagCre   INT;
DECLARE Act_LiberarInver    INT;
DECLARE Act_LiberarReinAut  INT;
DECLARE Act_AsignarReinAut  INT;
DECLARE TipoLiberar         CHAR(1);
DECLARE TipoAsignar         CHAR(1);
DECLARE Si_Genera           CHAR(1);

DECLARE VarControl          VARCHAR(50);
DECLARE Var_FechaSistema    DATE;
DECLARE Var_MontoEnGar      DECIMAL(14,2);
DECLARE Var_CreditoInvGarID BIGINT(12);
DECLARE Var_NuevaInverID    INT(11);
DECLARE Var_GeneraConta     CHAR(1);

DECLARE  cursorCreditoInvGar CURSOR FOR
    SELECT CreditoInvGarID
        FROM CREDITOINVGAR
        WHERE CreditoID = Par_CreditoID;

DECLARE  cursorInversionGar CURSOR FOR
    SELECT CreditoInvGarID
        FROM CREDITOINVGAR
        WHERE InversionID = Par_InversionID;

DECLARE  cursorReinversionAutomatica CURSOR FOR
    SELECT  CI.CreditoInvGarID, CI.InversionID, TI.NuevaInversionID
        FROM    CREDITOINVGAR   CI,
                TEMINVERSIONES  TI
            WHERE   CI.InversionID  = TI.InversionID;



SET Cadena_Vacia        := "";
SET Entero_Cero         := 0;
SET Fecha_Vacia         := "1900-01-01";
SET Salida_SI           := 'S';
SET Salida_NO           := 'N';
SET Act_Eliminar        := 1;
SET Act_Liberar         := 2;
SET Act_LiberarPagCre   := 3;
SET Act_LiberarInver    := 4;
SET Act_LiberarReinAut  := 5;
SET Act_AsignarReinAut  := 6;
SET Var_FechaSistema    := (SELECT FechaSistema FROM PARAMETROSSIS);
SET Aud_FechaActual     := NOW();
SET TipoLiberar         := 'L';
SET TipoAsignar         := 'A';
SET Si_Genera           := 'S';
ManejoErrores: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr = '999';
            SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                                'esto le ocasiona. Ref: SP-CREDITOINVGARACT');
            SET VarControl = 'sqlException' ;
        END;

    IF(IFNULL(Par_NumAct,Entero_Cero)) = Entero_Cero THEN
        SET Par_NumErr      := 3;
        SET Par_ErrMen      := 'Numero de Actualizacion esta vacio' ;
        SET VarControl      := 'inversionID';
        LEAVE ManejoErrores;
    END IF;

    SELECT ContabilidadGL INTO Var_GeneraConta
        FROM PARAMETROSSIS;

    IF(Par_NumAct = Act_Eliminar) THEN
        IF(IFNULL(Par_CreditoID,Entero_Cero)) = Entero_Cero THEN
            SET Par_NumErr      := 1;
            SET Par_ErrMen      := 'El Credito esta Vacio.' ;
            SET VarControl      := 'creditoID';
            LEAVE ManejoErrores;
        END IF;

        IF(IFNULL(Par_InversionID,Entero_Cero)) = Entero_Cero THEN
            SET Par_NumErr      := 2;
            SET Par_ErrMen      := 'La Inversion esta Vacia.' ;
            SET VarControl      := 'inversionID';
            LEAVE ManejoErrores;
        END IF;

        INSERT INTO HISCREDITOINVGAR(
                    Fecha,              CreditoID,      InversionID,    MontoEnGar,         FechaAsignaGar,
                    UsuarioAgrego,      UsuarioElimina, EmpresaID,      Usuario,            FechaActual,
                    DireccionIP,        ProgramaID,     Sucursal,       NumTransaccion)
            SELECT  Var_FechaSistema,   CreditoID,      InversionID,    MontoEnGar,         FechaAsignaGar,
                    Usuario,            Aud_Usuario,    Par_EmpresaID,  Aud_Usuario,        Aud_FechaActual,
                    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion
                FROM CREDITOINVGAR
            WHERE CreditoInvGarID =  Par_CreditoInvGarID;

        SELECT  MontoEnGar INTO Var_MontoEnGar
                FROM CREDITOINVGAR
            WHERE CreditoInvGarID =  Par_CreditoInvGarID;


        DELETE FROM CREDITOINVGAR
             WHERE  CreditoInvGarID = Par_CreditoInvGarID;


        IF Var_GeneraConta= Si_Genera THEN
            CALL INVERRECLACONTAPRO(
                Par_InversionID,    Var_MontoEnGar, TipoLiberar,        Entero_Cero,        Salida_NO,
                Par_NumErr,         Par_ErrMen,     Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,
                Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion);
            IF(Par_NumErr != Entero_Cero)THEN
                LEAVE ManejoErrores;
            END IF;
        END IF;
        SET Par_NumErr      := 0;
        SET Par_ErrMen      := 'Inversion en Garantia Eliminada Exitosamente.' ;
        SET VarControl      := 'creditoID';
    END IF;

    IF(Par_NumAct = Act_Liberar) THEN
        SET Par_InversionID := (SELECT  InversionID FROM CREDITOINVGAR WHERE CreditoInvGarID =  Par_CreditoInvGarID);

        INSERT INTO HISCREDITOINVGAR(
                    Fecha,              CreditoID,      InversionID,    MontoEnGar,         FechaAsignaGar,
                    UsuarioAgrego,      UsuarioElimina, EmpresaID,      Usuario,            FechaActual,
                    DireccionIP,        ProgramaID,     Sucursal,       NumTransaccion)
            SELECT  Var_FechaSistema,   CreditoID,      InversionID,    MontoEnGar,         FechaAsignaGar,
                    Usuario,            Aud_Usuario,    Par_EmpresaID,  Aud_Usuario,        Aud_FechaActual,
                    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion
                FROM CREDITOINVGAR
            WHERE CreditoInvGarID =  Par_CreditoInvGarID;

        SELECT  MontoEnGar INTO Var_MontoEnGar
                FROM CREDITOINVGAR
            WHERE CreditoInvGarID =  Par_CreditoInvGarID;


        DELETE FROM CREDITOINVGAR
             WHERE  CreditoInvGarID = Par_CreditoInvGarID;


        IF Var_GeneraConta= Si_Genera THEN
            CALL INVERRECLACONTAPRO(
                Par_InversionID,    Var_MontoEnGar,     TipoLiberar,        Par_PolizaID,       Salida_NO,
                Par_NumErr,         Par_ErrMen,         Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,
                Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);
            IF(Par_NumErr != Entero_Cero)THEN
                LEAVE ManejoErrores;
            END IF;
        END IF;

        SET Par_NumErr      := 0;
        SET Par_ErrMen      := 'Inversion en Garantia Liberada Exitosamente.' ;
        SET VarControl      := 'creditoID';
    END IF;


    IF(Par_NumAct = Act_LiberarPagCre) THEN
        OPEN  cursorCreditoInvGar;
        BEGIN
            DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
            CICLO:LOOP
                FETCH cursorCreditoInvGar INTO
                    Var_CreditoInvGarID;

                SET Par_InversionID := (SELECT  InversionID FROM CREDITOINVGAR WHERE CreditoInvGarID =  Var_CreditoInvGarID);

                SET Var_MontoEnGar  := (SELECT  MontoEnGar FROM CREDITOINVGAR WHERE CreditoInvGarID =  Var_CreditoInvGarID);


                IF Var_GeneraConta= Si_Genera THEN
                    CALL INVERRECLACONTAPRO(
                        Par_InversionID,    Var_MontoEnGar,     TipoLiberar,        Par_PolizaID,       Salida_NO,
                        Par_NumErr,         Par_ErrMen,         Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,
                        Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

                    IF(Par_NumErr != Entero_Cero)THEN
                        LEAVE CICLO;
                    END IF;
                END IF;
            END LOOP CICLO;
        END;
        CLOSE cursorCreditoInvGar;
        IF(Par_NumErr != Entero_Cero)THEN
            LEAVE ManejoErrores;
        END IF;


        INSERT INTO HISCREDITOINVGAR(
                    Fecha,              CreditoID,      InversionID,    MontoEnGar,         FechaAsignaGar,
                    UsuarioAgrego,      UsuarioElimina, EmpresaID,      Usuario,            FechaActual,
                    DireccionIP,        ProgramaID,     Sucursal,       NumTransaccion)
            SELECT  Var_FechaSistema,   CreditoID,      InversionID,    MontoEnGar,         FechaAsignaGar,
                    Usuario,            Aud_Usuario,    Par_EmpresaID,  Aud_Usuario,        Aud_FechaActual,
                    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion
                FROM CREDITOINVGAR
            WHERE CreditoID =  Par_CreditoID;


        DELETE FROM CREDITOINVGAR
             WHERE CreditoID =  Par_CreditoID;

        SET Par_NumErr      := 0;
        SET Par_ErrMen      := 'Inversion en Garantia Liberada Exitosamente.' ;
        SET VarControl      := 'creditoID';
    END IF;


    IF(Par_NumAct = Act_LiberarInver) THEN
        OPEN  cursorInversionGar;
        BEGIN
            DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
            CICLO:LOOP
                FETCH cursorInversionGar INTO
                    Var_CreditoInvGarID;

                SET Var_MontoEnGar  := (SELECT  MontoEnGar FROM CREDITOINVGAR WHERE CreditoInvGarID =  Var_CreditoInvGarID);

                IF Var_GeneraConta= Si_Genera THEN
                    CALL INVERRECLACONTAPRO(
                        Par_InversionID,    Var_MontoEnGar,     TipoLiberar,        Par_PolizaID,       Salida_NO,
                        Par_NumErr,         Par_ErrMen,         Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,
                        Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

                    IF(Par_NumErr != Entero_Cero)THEN
                        LEAVE CICLO;
                    END IF;
                END IF;
            END LOOP CICLO;
        END;
        CLOSE cursorInversionGar;
        IF(Par_NumErr != Entero_Cero)THEN
            LEAVE ManejoErrores;
        END IF;


        INSERT INTO HISCREDITOINVGAR(
                    Fecha,              CreditoID,      InversionID,    MontoEnGar,         FechaAsignaGar,
                    UsuarioAgrego,      UsuarioElimina, EmpresaID,      Usuario,            FechaActual,
                    DireccionIP,        ProgramaID,     Sucursal,       NumTransaccion)
            SELECT  Var_FechaSistema,   CreditoID,      InversionID,    MontoEnGar,         FechaAsignaGar,
                    Usuario,            Aud_Usuario,    Par_EmpresaID,  Aud_Usuario,        Aud_FechaActual,
                    Aud_DireccionIP,    Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion
                FROM CREDITOINVGAR
            WHERE InversionID =  Par_InversionID;


        DELETE FROM CREDITOINVGAR
             WHERE  InversionID =  Par_InversionID;
        SET Par_NumErr      := 0;
        SET Par_ErrMen      := 'Inversion en Garantia Liberada Exitosamente.' ;
        SET VarControl      := 'creditoID';
    END IF;


    IF(Par_NumAct = Act_LiberarReinAut) THEN
        OPEN  cursorReinversionAutomatica;
        BEGIN
            DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
            CICLO:LOOP
                FETCH cursorReinversionAutomatica INTO
                    Var_CreditoInvGarID,    Par_InversionID,    Var_NuevaInverID;

                SET Var_MontoEnGar  := (SELECT  MontoEnGar FROM CREDITOINVGAR WHERE CreditoInvGarID =  Var_CreditoInvGarID);

                IF Var_GeneraConta= Si_Genera THEN
                    CALL INVERRECLACONTAPRO(
                        Par_InversionID,    Var_MontoEnGar,     TipoLiberar,        Par_PolizaID,       Salida_NO,
                        Par_NumErr,         Par_ErrMen,         Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,
                        Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

                    IF(Par_NumErr != Entero_Cero)THEN
                        LEAVE CICLO;
                    END IF;
                END IF;

            END LOOP CICLO;
        END;
        CLOSE cursorReinversionAutomatica;

        IF(Par_NumErr != Entero_Cero)THEN
            LEAVE ManejoErrores;
        END IF;


        SET Par_NumErr      := 0;
        SET Par_ErrMen      := 'Inversion en Garantia Liberada Exitosamente.' ;
        SET VarControl      := 'creditoID';
    END IF;


    IF(Par_NumAct = Act_AsignarReinAut) THEN
        OPEN  cursorReinversionAutomatica;
        BEGIN
            DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
            CICLO:LOOP
                FETCH cursorReinversionAutomatica INTO
                    Var_CreditoInvGarID,    Par_InversionID,    Var_NuevaInverID;

                SET Var_MontoEnGar  := (SELECT  MontoEnGar FROM CREDITOINVGAR WHERE CreditoInvGarID =  Var_CreditoInvGarID);


                IF Var_GeneraConta= Si_Genera THEN
                    CALL INVERRECLACONTAPRO(
                        Var_NuevaInverID,   Var_MontoEnGar,     TipoAsignar,        Par_PolizaID,       Salida_NO,
                        Par_NumErr,         Par_ErrMen,         Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,
                        Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

                    IF(Par_NumErr != Entero_Cero)THEN
                        LEAVE CICLO;
                    END IF;
                END IF;
            END LOOP CICLO;
        END;
        CLOSE cursorReinversionAutomatica;

        IF(Par_NumErr != Entero_Cero)THEN
            LEAVE ManejoErrores;
        END IF;

        SET Par_NumErr      := 0;
        SET Par_ErrMen      := 'Inversion en Garantia Asignada Exitosamente.' ;
        SET VarControl      := 'creditoID';
    END IF;

END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
            Par_ErrMen AS ErrMen,
            VarControl AS control,
            Par_CreditoID AS consecutivo;
END IF;

END TerminaStore$$