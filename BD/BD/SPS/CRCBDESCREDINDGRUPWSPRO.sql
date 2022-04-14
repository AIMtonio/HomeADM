-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRCBDESCREDINDGRUPWSPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRCBDESCREDINDGRUPWSPRO`;
DELIMITER $$

CREATE PROCEDURE `CRCBDESCREDINDGRUPWSPRO`(
# =====================================================================================
# ----- STORE PARA AUTORIZAR IMPRIMIR PAGARE Y DESEMBOLSAR CREDITOS GRUPALES IND WS --
# =====================================================================================
    Par_CreditoID           BIGINT(12),             -- ID del credito
    Par_GrupoID             INT(11),                -- ID del grupo
    Par_PolizaID            BIGINT(20),             -- ID de la poliza

    Par_Salida              CHAR(1),                -- indica una salida
    INOUT   Par_NumErr      INT(11),                -- parametro numero de error
    INOUT   Par_ErrMen      VARCHAR(400),           -- mensaje de error

    Par_EmpresaID           INT(11),                -- parametros de auditoria
    Aud_Usuario             INT(11),                -- parametros de auditoria
    Aud_FechaActual         DATETIME ,              -- parametros de auditoria
    Aud_DireccionIP         VARCHAR(15),            -- parametros de auditoria
    Aud_ProgramaID          VARCHAR(70),            -- parametros de auditoria
    Aud_Sucursal            INT(11),                -- parametros de auditoria
    Aud_NumTransaccion      BIGINT(20)              -- parametros de auditoria
)
TerminaStore: BEGIN
    -- Declaracion de Variables
    DECLARE Var_FechaSis            DATE;               -- Fecha del sistema
    DECLARE Var_CreditoID           BIGINT(12);         -- ID del credito
    DECLARE Var_EstatusC            CHAR(1);            -- Estatus del credito
    DECLARE Var_CuentaID            BIGINT(12);         -- ID de la cuenta
    DECLARE Var_ClienteID           INT(11);            -- Id del cliente
    DECLARE Var_SaldoDispo          DECIMAL(12,2);      -- Saldo disponible de la cuenta
    DECLARE Var_MontoPago           DECIMAL(12,2);      -- Monto del Pago
    DECLARE Var_Poliza              BIGINT(12);         -- Numero de Poliza
    DECLARE Var_Consecutivo         BIGINT(12);         -- Consecutivo
    DECLARE Var_TipoCredito         INT(11);            -- Tipo de Credito
    DECLARE Var_TipoPrepago         CHAR(1);            -- Tipo de prepago
    DECLARE Var_ProductoCreditoID   INT(11);            -- Producto de credito
    DECLARE Var_UsuarioID           INT(11);            -- Usuario ID
    DECLARE Var_GrupoID             INT(11);            -- ID del grupo
    DECLARE Var_EstatusCiclo        CHAR(1);            -- Estatus del ciclo actual del grupo
    DECLARE Var_NumIntegrantes      INT(11);            -- NUmero de integrantes Grupo
    DECLARE Var_NumCreditos         INT(11);
    DECLARE Var_FechaInicioAmo      DATE;
    DECLARE Var_EjecutaCierre       CHAR(1);            -- indica si se esta realizando el cierre de dia

    -- Declaracion de Constantes
    DECLARE Entero_Cero         INT(11);                -- entero cero
    DECLARE Entero_Uno          INT(11);                -- entero uno
    DECLARE Decimal_Cero        DECIMAL(14,2);          -- DECIMAL Cero
    DECLARE Salida_SI           CHAR(1);                -- salida SI
    DECLARE Fecha_Vacia         DATE;                   -- Fecha vacia
    DECLARE Cadena_Vacia        CHAR(1);                -- cadena vacia
    DECLARE EstatusVigente      CHAR(1);                -- Credito vigente
    DECLARE EstatusInactivo     CHAR(1);                -- Credito Vencido
    DECLARE ConstanteNo         CHAR(1);                -- Constamnte no
    DECLARE CreditoIndividual   INT(11);                -- Credito Individual
    DECLARE CreditoGrupal       INT(11);                -- Credito GRupal
    DECLARE ImprimePagare       INT(11);                -- numero de actualizacion para imprimir pagare de credito
    DECLARE AutorizaCredWS      INT(11);                -- numero de actualizacion para actualizacion de credito
    DECLARE EstatusCerrado      CHAR(1);                -- EStatus cerrado
    DECLARE EstatusActivo       CHAR(1);                -- EStatus activo
    DECLARE CerrarGrupo         INT(11);                -- Cierra el grupo
    DECLARE ValorCierre         VARCHAR(30);            -- INDICA SI SE REALIZA EL CIERRE DE DIA.

    -- Asignacion de constantes
    SET Entero_Cero         := 0;
    SET Entero_Uno          := 1;
    SET Decimal_Cero        := 0.00;
    SET Salida_SI           := 'S';
    SET Fecha_Vacia         := '1900-01-01';
    SET Cadena_Vacia        := '';
    SET EstatusVigente      := 'V';
    SET EstatusInactivo     := 'I';
    SET ConstanteNo         := 'N';
    SET CreditoIndividual   := 1;
    SET CreditoGrupal       := 2;
    SET ImprimePagare       := 2;
    SET AutorizaCredWS      := 11;
    SET EstatusCerrado      := 'C';
    SET EstatusActivo       := 'A';
    SET CerrarGrupo         := 3;
    SET Var_NumCreditos     := 0;
    SET ValorCierre         := 'EjecucionCierreDia';

    ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr := 999;
            SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al
                concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-CRCBDESCREDINDGRUPWSPRO');
        END;

        -- Asignamos valor a varibles
        SET Aud_FechaActual     := NOW();
        SET Var_Poliza          := Par_PolizaID;
        SET Var_Consecutivo     := Entero_Cero;
        SET Var_FechaSis        := (SELECT IFNULL(FechaSistema,Fecha_Vacia) FROM PARAMETROSSIS
                                    WHERE EmpresaID = Par_EmpresaID);
        -- Obtenemos usuario
        SELECT UsuarioID INTO   Var_UsuarioID
            FROM USUARIOS WHERE UsuarioID = Aud_Usuario;

        SET Var_EjecutaCierre := (SELECT  ValorParametro  FROM PARAMGENERALES WHERE LlaveParametro = ValorCierre);

        -- Validamos que no se este ejecutando el cierre de dia
        IF(IFNULL(Var_EjecutaCierre,Cadena_Vacia)=Salida_SI)THEN
            SET Par_NumErr  := 800;
            SET Par_ErrMen  := CONCAT('El Cierre de Dia Esta en Ejecucion, Espere un Momento Por favor.');
            LEAVE ManejoErrores;
        END IF;
        -- Validamos si se trata de un Credito Grupal o Individual
        IF(IFNULL(Par_CreditoID,Entero_Cero))= Entero_Cero THEN

            IF(IFNULL(Par_GrupoID,Entero_Cero))= Entero_Cero THEN
                SET Par_NumErr := 1;
                SET Par_ErrMen := 'Indicar Numero de Credito o Grupo.';
                LEAVE ManejoErrores;
            ELSE

                SET Var_TipoCredito := CreditoGrupal;
            END IF;
        ELSE
            SET Var_TipoCredito := CreditoIndividual;

        END IF;

        IF(Par_CreditoID <> Entero_Cero AND Par_GrupoID <> Entero_Cero)THEN
            SET Par_NumErr := 1;
            SET Par_ErrMen := 'Indicar Numero de Credito o Grupo.';
            LEAVE ManejoErrores;
        END IF;

        -- validaciones
        IF (IFNULL(Var_UsuarioID,Entero_Cero) = Entero_Cero) THEN
            SET Par_NumErr  := 2;
            SET Par_ErrMen  := 'Usuario Incorrecto.';
            LEAVE ManejoErrores;
        END IF;

        IF(Var_TipoCredito = CreditoIndividual)THEN

        -- Obtenemos valor de credito y cuentas
            SELECT  Cre.CreditoID,      Cre.CuentaID,   Cre.Estatus,    Cre.TipoPrepago,    Cre.ProductoCreditoID,  Cre.GrupoID,
                    Cre.FechaInicioAmor
                INTO
                    Var_CreditoID,      Var_CuentaID,   Var_EstatusC,   Var_TipoPrepago,    Var_ProductoCreditoID,  Par_GrupoID,
                    Var_FechaInicioAmo
                FROM CREDITOS Cre
                    WHERE Cre.CreditoID = Par_CreditoID;

            IF(IFNULL(Var_CreditoID,Entero_Cero))= Entero_Cero THEN
                SET Par_NumErr := 3;
                SET Par_ErrMen := 'El Numero de Credito No Existe.';
                LEAVE ManejoErrores;
            END IF;

            IF(IFNULL(Var_EstatusC,Cadena_Vacia))<> EstatusInactivo THEN
                SET Par_NumErr := 4;
                SET Par_ErrMen := 'El Estatus del Credito Es Incorrecto.';
                LEAVE ManejoErrores;
            END IF;

            SET Var_TipoPrepago := IFNULL(Var_TipoPrepago,Cadena_Vacia);

            IF Par_GrupoID <> Entero_Cero THEN

                 SELECT GrupoID,EstatusCiclo INTO Var_GrupoID, Var_EstatusCiclo
                    FROM GRUPOSCREDITO
                WHERE GrupoID = Par_GrupoID;

                IF(IFNULL(Var_GrupoID,Entero_Cero))= Entero_Cero THEN
                    SET Par_NumErr := 5;
                    SET Par_ErrMen := 'El Numero de Grupo No Existe.';
                    LEAVE ManejoErrores;
                END IF;


                IF(IFNULL(Var_EstatusCiclo,Cadena_Vacia))<> EstatusCerrado THEN

                     -- Se cierra el grupo
                    CALL GRUPOSCREDITOACT(
                        Var_GrupoID,        CerrarGrupo,    ConstanteNo,        Par_NumErr,         Par_ErrMen,
                        Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                        Aud_Sucursal,       Aud_NumTransaccion);

                     IF(Par_NumErr != Entero_Cero)THEN
                            LEAVE ManejoErrores;
                     END IF;

                 END IF;

            END IF;

            -- Se genera llamada SP Desembolsos
            CALL CRCBDESEMBOLSOCREDWSPRO(
                Var_CreditoID,      Var_FechaInicioAmo,     Var_FechaSis,       Var_TipoPrepago,    Var_Poliza,
                ConstanteNo,        Par_NumErr,             Par_ErrMen,         Par_EmpresaID,      Aud_Usuario,
                Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

            IF(Par_NumErr != Entero_Cero)THEN
                LEAVE ManejoErrores;
            END IF;

            SET Par_GrupoID := 0;
            SET Par_NumErr  := 0;
            SET Par_ErrMen  := CONCAT('Credito Desembolsado Exitosamente: ',Var_CreditoID);
            LEAVE ManejoErrores;

        ELSE

            IF(Var_TipoCredito = CreditoGrupal)THEN

                SELECT GrupoID INTO Var_GrupoID
                    FROM GRUPOSCREDITO
                WHERE GrupoID = Par_GrupoID;

                IF(IFNULL(Var_GrupoID,Entero_Cero))= Entero_Cero THEN
                    SET Par_NumErr := 5;
                    SET Par_ErrMen := 'El Numero de Grupo No Existe.';
                    LEAVE ManejoErrores;
                END IF;

                -- Se cierra el grupo
                CALL GRUPOSCREDITOACT(
                    Var_GrupoID,        CerrarGrupo,    ConstanteNo,        Par_NumErr,         Par_ErrMen,
                    Par_EmpresaID,      Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
                    Aud_Sucursal,       Aud_NumTransaccion);

                 IF(Par_NumErr != Entero_Cero)THEN
                        LEAVE ManejoErrores;
                 END IF;

                -- validacion del grupo
                SELECT  EstatusCiclo  INTO Var_EstatusCiclo
                    FROM GRUPOSCREDITO
                WHERE GrupoID = Par_GrupoID;

                 IF(IFNULL(Var_EstatusCiclo,Cadena_Vacia))<> EstatusCerrado THEN
                    SET Par_NumErr := 6;
                    SET Par_ErrMen := 'El Estatus del Grupo Es Incorrecto.';
                    LEAVE ManejoErrores;
                 END IF;

                DELETE FROM TMPCREDITOSGRUPALES WHERE NumTransaccion = Aud_NumTransaccion;

                -- Se inserta tabla con los valores de cada mienbro del grupo
                SET @Var_ConsecutivoID= Entero_Cero;
                INSERT INTO TMPCREDITOSGRUPALES(
                    SELECT  (@Var_ConsecutivoID:=@Var_ConsecutivoID+Entero_Uno), Cre.CreditoID,  Inte.GrupoID,    Cre.ProductoCreditoID,    Cre.FechaVencimien,
                            Cre.Estatus,    Cre.TipoPrepago, Cre.FechaInicioAmor
                FROM INTEGRAGRUPOSCRE Inte, CLIENTES  Cte,   SOLICITUDCREDITO Sol,  CREDITOS Cre
                WHERE Inte.GrupoID  = Par_GrupoID
                    AND Cre.ClienteID = Sol.ClienteID
                    AND Sol.ClienteID = Inte.ClienteID
                    AND Sol.SolicitudCreditoID = Inte.SolicitudCreditoID
                    AND Sol.SolicitudCreditoID = Cre.SolicitudCreditoID
                    AND Cte.ClienteID = Cre.ClienteID
                    AND Inte.Estatus = EstatusActivo
                    AND Cre.Estatus = EstatusInactivo);

                SET Var_NumIntegrantes := (SELECT MAX(CreditoGrupID) FROM  TMPCREDITOSGRUPALES WHERE GrupoID = Par_GrupoID AND NumTransaccion = Aud_NumTransaccion);

                IF(IFNULL(Var_NumIntegrantes,Entero_Cero))= Entero_Cero THEN
                    SET Par_NumErr := 7;
                    SET Par_ErrMen := 'El Grupo No Cuenta Con Creditos Registrados.';
                    LEAVE ManejoErrores;
                END IF;

                -- Se realiza el ciclo para registrar, imprimir pagare, autorizar los creditos y desembolsar
                WHILE  (Var_NumIntegrantes > Entero_Cero)  DO

                    SELECT CreditoID, TipoPrepago, FechaInicioAmo INTO Var_CreditoID, Var_TipoPrepago, Var_FechaInicioAmo
                    FROM TMPCREDITOSGRUPALES
                    WHERE CreditoGrupID = Var_NumIntegrantes AND NumTransaccion = Aud_NumTransaccion;

                    -- Se genera llamada SP Desembolsos
                    CALL CRCBDESEMBOLSOCREDWSPRO(
                        Var_CreditoID,      Var_FechaInicioAmo, Var_FechaSis,       Var_TipoPrepago,    Var_Poliza,    ConstanteNo,
                        Par_NumErr,         Par_ErrMen,         Par_EmpresaID,      Aud_Usuario,   Aud_FechaActual,
                        Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

                    IF(Par_NumErr != Entero_Cero)THEN
                        LEAVE ManejoErrores;
                    END IF;

                    SET Var_CreditoID       := Entero_Cero;
                    SET Var_TipoPrepago     := Cadena_Vacia;
                    SET Var_NumIntegrantes  := Var_NumIntegrantes - Entero_Uno;

                END WHILE;

                 IF(Par_NumErr != Entero_Cero)THEN
                    LEAVE ManejoErrores;
                END IF;

                DELETE FROM TMPCREDITOSGRUPALES WHERE NumTransaccion = Aud_NumTransaccion;

                SET Par_NumErr      := 0;
                SET Par_ErrMen      := CONCAT('Creditos Desembolsados Exitosamente, Grupo: ',Var_GrupoID);
                LEAVE ManejoErrores;
            END IF;
    END IF;

END ManejoErrores;

    IF (Par_Salida = Salida_SI) THEN
        SELECT
            Par_NumErr          AS NumErr,
            Par_ErrMen          AS ErrMen;

    END IF;

END TerminaStore$$