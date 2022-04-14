-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETESCALAINTPLDVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `DETESCALAINTPLDVAL`;DELIMITER $$

CREATE PROCEDURE `DETESCALAINTPLDVAL`(

    Par_OperProcID          BIGINT(12),
    Par_Consecutivo         INT,
    Par_NombreProc          VARCHAR(16),
    Par_Grupo               INT,
    Par_Salida              CHAR(1),

    INOUT   Par_NumErr      INT(11),
    INOUT   Par_ErrMen      VARCHAR(400),
    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,

    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)

        )
TerminaStore: BEGIN

    DECLARE Var_Cliente     INT;
    DECLARE Var_NivelRiesgo CHAR(1);
    DECLARE Var_FecDetec    datetime;
    DECLARE Var_ResulRev    CHAR(1);
    DECLARE Var_CadenaUno   CHAR(1);
    DECLARE Par_ResulRev    CHAR(1);
    DECLARE Var_CurCte      INT;
    DECLARE Var_CurCred     BIGINT(12);
    DECLARE Var_Control     VARCHAR(20);
    DECLARE Var_Consecutivo VARCHAR(20);


    DECLARE Cadena_Vacia    CHAR(1);
    DECLARE Fecha_Vacia     DATE;
    DECLARE Entero_Cero     INT;
    DECLARE Var_ProCuentasAh VARCHAR(16);
    DECLARE Var_ProInversion VARCHAR(16);
    DECLARE Var_ProLinCred  VARCHAR(16);
    DECLARE Var_ProCredkubo VARCHAR(16);
    DECLARE Var_ProSolCred  VARCHAR(16);
    DECLARE Var_ProSolFond  VARCHAR(16);
    DECLARE Var_ProCredito  VARCHAR(16);
    DECLARE NivelRiesgoAlto CHAR(1);
    DECLARE ResAutorizada   CHAR(1);
    DECLARE ResRechazada    CHAR(1);
    DECLARE ResEnSegto      CHAR(1);
    DECLARE Contador        INT;
    DECLARE TipoConOper     INT;
    DECLARE SalidaNO        CHAR(1);
    DECLARE SalidaSI        CHAR(1);
    DECLARE Seguimiento     CHAR(1);
    DECLARE Var_Sucursal    INT;
    DECLARE Var_SolFondPro  INT;

    DECLARE Error_Key       INT;
    DECLARE Error_TerCiclo  INT;



    DECLARE CURSORCREDITO CURSOR FOR

        SELECT      Cre.CreditoID,  Cre.ClienteID
            FROM    INTEGRAGRUPOSCRE    Inte,
                    GRUPOSCREDITO       Gru,
                    SOLICITUDCREDITO    Sol,
                    CREDITOS            Cre
                WHERE Inte.GrupoID = Gru.GrupoID
                AND Inte.GrupoID = Par_Grupo
                AND Inte.SolicitudCreditoID = Sol.SolicitudCreditoID
                AND Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
                AND Gru.EstatusCiclo = "C";




    SET Cadena_Vacia        := '';
    SET Fecha_Vacia         := '1900-01-01';
    SET Entero_Cero         := 0;
    SET Var_ProCuentasAh    := 'CTAAHO';
    SET Var_ProInversion    := 'INVERSION';
    SET Var_ProLinCred      := 'LINEACREDITO';
    SET Var_ProCredito      := 'CREDITO';
    SET Var_ProSolCred      := 'SOLICITUDCREDITO';
    SET Var_ProSolFond      := 'SOLICITUDFONDEO';
    SET Var_ProCredkubo     := 'CREDITOXSOLICITU';
    SET NivelRiesgoAlto     := 'A';



    SET TipoConOper         := 3;
    SET SalidaNO            := 'N';
    SET SalidaSI            := 'S';
    SET ResAutorizada       := 'A';
    SET ResRechazada        := 'R';
    SET ResEnSegto          := 'S';
    SET Seguimiento         := 'S';
    SET Var_CadenaUno       := '1';
    SET Par_ResulRev        := '';
    SET Error_TerCiclo      := 0;
    ManejoErrores: BEGIN
        DECLARE EXIT HANDLER FOR SQLEXCEPTION
                BEGIN
                    SET Par_NumErr := 999;
                    SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                    'Disculpe las molestias que esto le ocasiona. Ref: SP-DETESCALAINTPLDVAL');
                END;



        IF(Par_NombreProc = Var_ProCuentasAh) THEN

            SELECT  Cta.ClienteID,  Cta.SucursalID, Cte.NivelRiesgo
                        into
                    Var_Cliente,    Var_Sucursal,   Var_NivelRiesgo
                    FROM    CUENTASAHO Cta,
                            CLIENTES    Cte
                        WHERE Cta.CuentaAhoID = Par_OperProcID
                        AND  Cte.ClienteID = Cta.ClienteID;

            IF(Var_NivelRiesgo = NivelRiesgoAlto) THEN

                 SET    Var_FecDetec := (SELECT FechaSistema FROM PARAMETROSSIS);
                CALL PLDOPEESCALAINTCON(
                                        Par_OperProcID,     Par_NombreProc,     TipoConOper,        SalidaNO,           Par_NumErr,
                                        Par_ErrMen,         Par_ResulRev,       Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,
                                        Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);


                SET Var_ResulRev := IFNULL(Par_ResulRev,Cadena_Vacia);

                IF(Var_ResulRev = Cadena_Vacia) THEN

                            SET Par_NumErr  := 501;
                            SET Par_ErrMen  := "Para continuar el proceso requiere autorizacion, favor de verificar con el personal autorizado de escalamiento interno";
                            LEAVE ManejoErrores;
                END IF;

                IF(Var_ResulRev =   ResEnSegto) THEN
                            SET Par_NumErr  := 501;
                            SET Par_ErrMen  :=  "Para continuar proceso requiere autorizacion, favor de verificar con el personal autorizado de escalamiento interno";
                            LEAVE ManejoErrores;
                END IF;

                IF(Var_ResulRev =   ResAutorizada) THEN
                            SET Par_NumErr  := 502;
                            SET Par_ErrMen  := "Exito";
                END IF;

                IF(Var_ResulRev =   ResRechazada) THEN
                            SET Par_NumErr  := 503;
                            SET Par_ErrMen  := "La solicitud de Escalamiento ha sido Rechazada, favor de verificar con el personal autorizado de escalamiento interno";
                            LEAVE ManejoErrores;
                END IF;
            END IF;
        END IF;


        IF(Par_NombreProc = Var_ProInversion) THEN
            SELECT  Inv.ClienteID,  Cte.NivelRiesgo
                    into
                    Var_Cliente,    Var_NivelRiesgo
                FROM    INVERSIONES Inv,
                        CLIENTES    Cte
                    WHERE Inv.InversionID = Par_OperProcID
                    AND  Cte.ClienteID = Inv.ClienteID;
            IF(Var_NivelRiesgo = NivelRiesgoAlto) THEN
                SET Var_FecDetec := (SELECT FechaSistema FROM PARAMETROSSIS);

                CALL PLDOPEESCALAINTCON(
                                        Par_OperProcID,     Par_NombreProc,     TipoConOper,        SalidaNO,           Par_NumErr,
                                        Par_ErrMen,         Par_ResulRev,       Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,
                                        Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

                SET Var_ResulRev := IFNULL(Par_ResulRev,Cadena_Vacia);

                IF(Var_ResulRev = Cadena_Vacia) THEN

                                SET Par_NumErr  := 501;
                                SET Par_ErrMen  := "Para continuar el proceso requiere autorizacion, favor de verificar con el personal autorizado de escalamiento interno";
                        LEAVE ManejoErrores;

                END IF;
                IF(Var_ResulRev =   ResEnSegto) THEN
                            SET Par_NumErr  := 501;
                            SET Par_ErrMen  :=  "Para continuar proceso requiere autorizacion, favor de verificar con el personal autorizado de escalamiento interno";
                            LEAVE ManejoErrores;
                END IF;


                IF(Var_ResulRev =   ResAutorizada) THEN
                            SET Par_NumErr  := 502;
                            SET Par_ErrMen  := "Exito";
                END IF;


                IF(Var_ResulRev =   ResRechazada) THEN
                            SET Par_NumErr  := 503;
                            SET Par_ErrMen  := "La solicitud de Escalamiento ha sido Rechazada, favor de verificar con el personal autorizado de escalamiento interno";
                        LEAVE ManejoErrores;
                END IF;
            END IF;
        END IF;


        IF(Par_NombreProc = Var_ProLinCred) THEN

                SELECT  Lin.ClienteID,  Cte.NivelRiesgo
                        into
                        Var_Cliente,    Var_NivelRiesgo
                FROM    LINEASCREDITO Lin,
                        CLIENTES    Cte
                    WHERE Lin.LineaCreditoID = Par_OperProcID
                    AND  Cte.ClienteID = Lin.ClienteID;

            IF(Var_NivelRiesgo = NivelRiesgoAlto) THEN
                SET Var_FecDetec := (SELECT FechaSistema FROM PARAMETROSSIS);

                CALL PLDOPEESCALAINTCON(
                                        Par_OperProcID, Par_NombreProc, TipoConOper,        SalidaNO,       Par_NumErr,
                                        Par_ErrMen,     Par_ResulRev,       Par_EmpresaID,  Aud_Usuario,        Aud_FechaActual,
                                        Aud_DireccionIP,Aud_ProgramaID, Aud_Sucursal,       Aud_NumTransaccion);

                SET Var_ResulRev := IFNULL(Par_ResulRev,Cadena_Vacia);

                IF(Var_ResulRev = Cadena_Vacia) THEN
                                SET Par_NumErr  := 501;
                                SET Par_ErrMen  := "Para continuar el proceso requiere autorizacion, favor de verificar con el personal autorizado de escalamiento interno";
                                LEAVE ManejoErrores;
                END IF;

                IF(Var_ResulRev =   ResEnSegto) THEN
                            SET Par_NumErr  := 501;
                            SET Par_ErrMen  :=  "Para continuar proceso requiere autorizacion, favor de verificar con el personal autorizado de escalamiento interno";
                            LEAVE ManejoErrores;
                END IF;


                IF(Var_ResulRev =   ResAutorizada) THEN
                            SET Par_NumErr  := 502;
                            SET Par_ErrMen  := "Exito";

                END IF;


                IF(Var_ResulRev =   ResRechazada) THEN
                            SET Par_NumErr  := 503;
                            SET Par_ErrMen  := "La solicitud de Escalamiento ha sido Rechazada, favor de verificar con el personal autorizado de escalamiento interno";
                            LEAVE ManejoErrores;

                END IF;
            END IF;

        END IF;


        IF(Par_NombreProc = Var_ProCredito) THEN


            IF(Par_Grupo = Entero_Cero) THEN

                SELECT Cre.ClienteID,   Cre.SucursalID, Cte.NivelRiesgo
                        into
                        Var_Cliente,    Var_Sucursal,   Var_NivelRiesgo
                    FROM    CREDITOS Cre,
                            CLIENTES Cte
                    WHERE CreditoID = Par_OperProcID
                    AND Cte.ClienteID = Cre.ClienteID;

                IF(Var_NivelRiesgo = NivelRiesgoAlto) THEN
                    SET Var_FecDetec := (SELECT FechaSistema FROM PARAMETROSSIS);


                    CALL PLDOPEESCALAINTCON(
                                            Par_OperProcID,     Par_NombreProc,     TipoConOper,        SalidaNO,           Par_NumErr,
                                            Par_ErrMen,         Par_ResulRev,       Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,
                                            Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

                    SET Var_ResulRev := IFNULL(Par_ResulRev,Cadena_Vacia);

                    IF(Var_ResulRev = Cadena_Vacia) THEN
                                    SET Par_NumErr  := 501;
                                    SET Par_ErrMen  := "Para continuar el proceso requiere autorizacion, favor de verificar con el personal autorizado de escalamiento interno";
                                    SET Var_Control := 'creditoID';
                                    LEAVE ManejoErrores;

                    END IF;

                    IF(Var_ResulRev =   ResEnSegto) THEN
                                SET Par_NumErr  := 501;
                                SET Par_ErrMen  :=  "Para continuar proceso requiere autorizacion, favor de verificar con el personal autorizado de escalamiento interno";
                                SET Var_Control := 'creditoID';
                                LEAVE ManejoErrores;

                    END IF;


                    IF(Var_ResulRev =   ResAutorizada) THEN
                                SET Par_NumErr  := 502;
                                SET Par_ErrMen  := "Exito";
                                SET Var_Control := 'creditoID';
                    END IF;


                    IF(Var_ResulRev =   ResRechazada) THEN
                                SET Par_NumErr  := 503;
                                SET Par_ErrMen  := "La solicitud de Escalamiento ha sido Rechazada, favor de verificar con el personal autorizado de escalamiento interno";
                                SET Var_Control := 'creditoID';
                                LEAVE ManejoErrores;

                    ELSE
                                    SET Par_NumErr  := 502;
                                    SET Par_ErrMen  := "Exito";
                                    SET Var_Control := 'creditoID';


                END IF;
            END IF;


            IF(Par_Grupo != Entero_Cero) THEN
                SET Par_NumErr  := 0;
                SET Par_ErrMen  :='';
            OPEN CURSORCREDITO;
            BEGIN
                DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
                CICLOGLA:LOOP

                FETCH CURSORCREDITO into
                    Var_CurCred,Var_CurCte;
                START TRANSACTION;
                BEGIN

                    DECLARE EXIT HANDLER FOR SQLEXCEPTION SET   Error_Key = 1;
                    DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET   Error_Key = 2;
                    DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET   Error_Key = 3;
                    DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET   Error_Key = 4;

                    SET Error_Key   = Entero_Cero;
                    SET Var_Cliente = Entero_Cero;
                    SET Var_Sucursal = Entero_Cero;
                    SET Var_NivelRiesgo = '';



                    SELECT Cre.ClienteID,   Cre.SucursalID, Cte.NivelRiesgo
                            INTO
                            Var_Cliente,    Var_Sucursal,   Var_NivelRiesgo
                        FROM    CREDITOS Cre,
                                CLIENTES Cte
                        WHERE CreditoID = Var_CurCred
                        AND Cte.ClienteID = Cre.ClienteID
                        AND Cte.ClienteID= Var_CurCte;

                    IF(Var_NivelRiesgo = NivelRiesgoAlto) THEN
                        SET Var_FecDetec := (SELECT FechaSistema FROM PARAMETROSSIS);

                        CALL PLDOPEESCALAINTCON(
                                                Var_CurCred,        Par_NombreProc,     TipoConOper,        SalidaNO,           Par_NumErr,
                                                Par_ErrMen,         Par_ResulRev,       Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,
                                                Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

                        SET Var_ResulRev := IFNULL(Par_ResulRev,Cadena_Vacia);

                        IF(Var_ResulRev = Cadena_Vacia) THEN
                                        SET Par_NumErr  := 501;
                                        SET Par_ErrMen  := "Para continuar el proceso requiere autorizacion, favor de verificar con el personal autorizado de escalamiento interno";
                                        LEAVE CICLOGLA;

                        END IF;


                        IF(Var_ResulRev =   ResEnSegto) THEN
                            SET Par_NumErr  := 501;
                            SET Par_ErrMen  :=  "Para continuar proceso requiere autorizacion, favor de verificar con el personal autorizado de escalamiento interno";
                            LEAVE CICLOGLA;
                        END IF;


                        IF(Var_ResulRev =   ResAutorizada) THEN
                            SET Par_NumErr  := 502;
                            SET Par_ErrMen  := "Exito";
                            LEAVE CICLOGLA;
                        END IF;


                        IF(Var_ResulRev =   ResRechazada) THEN
                            SET Par_NumErr  := 503;
                            SET Par_ErrMen  := "La solicitud de Escalamiento ha sido Rechazada, favor de verificar con el personal autorizado de escalamiento interno";
                            LEAVE CICLOGLA;
                        END IF;
                    SET Error_TerCiclo := 1;

                    END IF;

                END;


                IF Error_Key = 0 THEN
                    COMMIT;
                END IF;
                IF Error_Key != 0 THEN
                    ROLLBACK;
                END IF;


            End LOOP;


        END;

        CLOSE CURSORCREDITO;

        IF(Error_TerCiclo = 1) THEN
            SET Par_NumErr := Par_NumErr;
            SET Par_ErrMen := Par_ErrMen;
            SET Var_Control := 'grupoID';
            LEAVE ManejoErrores;

        ELSE
            SET Par_NumErr  := 502;
            SET Par_ErrMen  := "Exito";
            LEAVE ManejoErrores;
        END IF;

        END IF;
    END IF;



        IF(Par_NombreProc = Var_ProSolCred) THEN

            SELECT  Sol.ClienteID,  Cte.NivelRiesgo,    Sol.SucursalID
                    into
                    Var_Cliente,    Var_NivelRiesgo,    Var_Sucursal
                FROM    SOLICITUDCREDITO    Sol,
                        CLIENTES            Cte
                    WHERE Sol.SolicitudCreditoID = Par_OperProcID
                    AND  Cte.ClienteID = Sol.ClienteID;


            IF(Var_NivelRiesgo = NivelRiesgoAlto) THEN
                SET Var_FecDetec := (SELECT FechaSistema FROM PARAMETROSSIS);

                CALL PLDOPEESCALAINTCON(
                                        Par_OperProcID,     Par_NombreProc,     TipoConOper,        SalidaNO,           Par_NumErr,
                                        Par_ErrMen,         Par_ResulRev,       Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,
                                        Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

                SET Var_ResulRev := IFNULL(Par_ResulRev,Cadena_Vacia);
                IF(Var_ResulRev = Cadena_Vacia) THEN

                                SET Par_NumErr  := 501;
                                SET Par_ErrMen  := "Para continuar el proceso requiere autorizacion, favor de verificar con el personal autorizado de escalamiento interno";
                                SET Var_Control := 'solicitudCreditoID';
                                LEAVE ManejoErrores;
                END IF;

                IF(Var_ResulRev =   ResEnSegto) THEN
                            SET Par_NumErr  := 501;
                            SET Par_ErrMen  :=  "Para continuar proceso requiere autorizacion, favor de verificar con el personal autorizado de escalamiento interno";
                            LEAVE ManejoErrores;
                END IF;


                IF(Var_ResulRev =   ResAutorizada) THEN
                            SET Par_NumErr  := 502;
                            SET Par_ErrMen  := "Exito";
                            LEAVE ManejoErrores;
                END IF;


                IF(Var_ResulRev =   ResRechazada) THEN
                            SET Par_NumErr  := 503;
                            SET Par_ErrMen  := "La solicitud de Escalamiento ha sido Rechazada, favor de verificar con el personal autorizado de escalamiento interno";
                            SET Var_Control := 'solicitudCreditoID';
                            LEAVE ManejoErrores;
                END IF;
            END IF;

            IF(Var_NivelRiesgo != NivelRiesgoAlto) THEN
                            SET Par_NumErr  := 502;
                            SET Par_ErrMen  := "Exito";
                        LEAVE ManejoErrores;
                    END IF;
            END IF;


        IF(Par_NombreProc = Var_ProSolFond) THEN

            SELECT  Fon.ClienteID,  Cte.NivelRiesgo
                    INTO
                    Var_Cliente,    Var_NivelRiesgo
                FROM    FONDEOSOLICITUD     Fon,
                        CLIENTES    Cte
                    WHERE Fon.SolFondeoID = Par_OperProcID
                    AND  Cte.ClienteID = Fon.ClienteID;


            IF(Var_NivelRiesgo = NivelRiesgoAlto) THEN

                SET Var_FecDetec := (SELECT FechaSistema FROM PARAMETROSSIS);

                CALL PLDOPEESCALAINTCON(
                                        Par_OperProcID,     Par_NombreProc,     TipoConOper,        SalidaNO,           Par_NumErr,
                                        Par_ErrMen,         Par_ResulRev,       Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,
                                        Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

                SET Var_ResulRev := IFNULL(Par_ResulRev,Cadena_Vacia);


                IF(Var_ResulRev = Cadena_Vacia) THEN
                                SET Par_NumErr  := 501;
                                SET Par_ErrMen  := "Para continuar el proceso requiere autorizacion, favor de verificar con el personal autorizado de escalamiento interno";
                                LEAVE ManejoErrores;
                END IF;

                IF(Var_ResulRev =   ResEnSegto) THEN
                            SET Par_NumErr  := 501;
                            SET Par_ErrMen  :=  "Para continuar proceso requiere autorizacion, favor de verificar con el personal autorizado de escalamiento interno";
                            LEAVE ManejoErrores;
                END IF;


                IF(Var_ResulRev =   ResAutorizada) THEN
                            SET Par_NumErr  := 502;
                            SET Par_ErrMen  := "Exito";
                END IF;


                IF(Var_ResulRev =   ResRechazada) THEN
                            SET Par_NumErr  := 503;
                            SET Par_ErrMen  := "La solicitud de Escalamiento ha sido Rechazada, favor de verificar con el personal autorizado de escalamiento interno";
                            LEAVE ManejoErrores;
                END IF;
            END IF;


        END IF;
            END IF;
    END ManejoErrores;

     IF(Par_Salida =SalidaSI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
                Par_ErrMen AS ErrMen,
                Var_Control AS control,
                Par_OperProcID AS consecutivo;
     END IF;


END TerminaStore$$