-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APLICAPAGOINSTACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `APLICAPAGOINSTACT`;
DELIMITER $$

CREATE PROCEDURE `APLICAPAGOINSTACT`(
-- SP PARA ACTUALIZACION DE APLICACION DE PAGOS DE INSTITUCIONES
    Par_FolioNominaID        INT(11),           -- ID del folio de registro
    Par_FolioCargaID        INT(11),            -- ID del folio cargado
    Par_EmpresaNominaID     INT(11),            -- ID de la empresa de nomina
    Par_CreditoID           BIGINT(12),         -- ID del credito
    Par_ClienteID           INT(11),            -- ID del empleado

    Par_MontoPago           DECIMAL(18,2),      -- Monto del pago
    Par_TipoAct             INT(11),            -- Tipo de actualizacion
    Par_InstitucionID       INT(11),            -- Id del banco
    Par_NumCuenta           VARCHAR(30),        -- Numero de cuenta del banco
    Par_TipoMovID           INT(11),            -- ID del movimiento de tesoreria

    Par_Salida              CHAR(1),            -- Indica si espera un select de salida
    INOUT Par_NumErr        INT(11),            -- Numero de error
    INOUT Par_ErrMen        VARCHAR(400),       -- Mensaje de error
    Par_EmpresaID           INT(11),            -- Parametro de auditoria
    Aud_Usuario             INT(11),            -- Parametro de auditoria

    Aud_FechaActual         DATETIME,           -- Parametro de auditoria
    Aud_DireccionIP         VARCHAR(15),        -- Parametro de auditoria
    Aud_ProgramaID          VARCHAR(50),        -- Parametro de auditoria
    Aud_Sucursal            INT(11),            -- Parametro de auditoria
    Aud_NumTransaccion      BIGINT(20)          -- Parametro de auditoria
    )
TerminaStore: BEGIN
-- Declaracion de Variables
DECLARE Act_Reversa         INT(11);                -- Constante reversa
DECLARE Est_Cancelado       CHAR(1);            -- Estatus cancelado
DECLARE Var_PorAplicar      CHAR(1);            -- Variable por aplicar
DECLARE Var_Procesado       CHAR(1);            -- Variable procesado
DECLARE SalidaSI            CHAR(1);            -- Salida si
DECLARE Var_Control         VARCHAR(50);        -- Variable de control
DECLARE Entero_Cero         INT(11);            -- Constante entero cero
DECLARE Entero_Uno          INT(11);            -- Constante entero uno
DECLARE Est_Aplicado        CHAR(1);            -- Estatus aplicado
DECLARE Est_Vigente         CHAR(1);            -- Estatus vigente
DECLARE Est_NoAplicado      CHAR(1);            -- Estatus no aplicado
DECLARE Var_Transaccion     BIGINT(20);         -- Parametro de auditoria
DECLARE Var_CreditoID       BIGINT(12);         -- Variable Credito ID
DECLARE Var_FolioNomina     INT(11);            -- Variable Folio Nomina
DECLARE Var_ExistPagoPost   INT(11);            -- Variable si Existen Pagos Posteriores
DECLARE NumMovConcilia      BIGINT(20);         -- Variable de Numero de Movimiento de Conciliacion

DECLARE Var_EstatusCarga    INT(11);                -- Estatus carga
DECLARE Var_FolioCarga      INT(11);            -- Folio de carga
DECLARE Var_NumRegistros    INT(11);            -- Numero de registros en la tabla real
DECLARE Var_NumAmorti       INT(11);            -- Numero de amortización que corresponde al folio
DECLARE ContadorAux         INT(11);            -- Contador Aux
DECLARE Estatus_Activo      CHAR(1);            -- Estatus Activo

-- Tipo de Actualizacion
DECLARE Act_ApliMasiva      INT(11);            -- Actualizacion de Aplicacion Masiva
DECLARE Act_Individual      INT(11);            -- Actualizacion de Aplicacion Individual


-- Seteo de Cosntantes
SET Act_Reversa             := 1 ;
SET Var_PorAplicar          :='P';
SET Var_Procesado           :='P';
SET Est_Cancelado           :='C';
SET SalidaSI                :='S';
SET Entero_Cero             :=  0;
SET Entero_Uno              := 1;
SET Est_Aplicado            :='A';
SET Est_Vigente             :='V';
SET Est_NoAplicado          := 'N';
SET Estatus_Activo          := 'A';
SET Act_ApliMasiva          := 2;
SET Act_Individual          := 3;


ManejoErrores: BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr = 999;
            SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion.
                                    Disculpe las molestias que', 'esto le ocasiona. Ref: SP-APLICAPAGOINSTACT');
            SET Var_Control = 'sqlException' ;
        END;

    -- Obtener el id del cliente
    SET Par_ClienteID := (SELECT ClienteID FROM NOMINAEMPLEADOS WHERE NominaEmpleadoID = Par_ClienteID);


    IF(Par_TipoAct = Act_Reversa ) THEN

        IF EXISTS(SELECT FolioCargaID FROM DESCNOMINAREAL
            WHERE FolioCargaID > Par_FolioCargaID AND EstatPagBanco = Est_Aplicado )THEN
            SET Par_NumErr := 001;
            SET Par_ErrMen  := 'Existen Operaciones Posteriores Al Folio, la Reversa no puede ser Realizada';
            LEAVE ManejoErrores;
        END IF;

        SELECT MAX(TranRespaldo)
        INTO Var_Transaccion
        FROM RESPAMORTCRENOMINAREAL
            WHERE FolioProceso = Par_FolioCargaID;

        DELETE FROM REVERSADESCNOMINAREAL WHERE NumTransaccion = Aud_NumTransaccion;

        SET @Contador := 0;
        INSERT INTO REVERSADESCNOMINAREAL(
            FolioReversaID,         FolioCargaID,               CreditoID,      NumTransaccion)
        SELECT
           (@Contador := @Contador + 1),   MAX(RESP.FolioProceso),      RESP.CreditoID,     Aud_NumTransaccion
        FROM  RESPAMORTCRENOMINAREAL RESP
            WHERE  FolioProceso =  Par_FolioCargaID
                AND TranRespaldo = Var_Transaccion
                GROUP BY RESP.CreditoID;

        SET Var_NumRegistros := (SELECT COUNT(*) FROM REVERSADESCNOMINAREAL WHERE NumTransaccion = Aud_NumTransaccion );
        SET Var_NumRegistros := IFNULL(Var_NumRegistros, Entero_Cero);

        -- Variable Contador Auxiliar para el ciclo
        SET ContadorAux := 1;

        WHILE( ContadorAux<=Var_NumRegistros ) DO
            SELECT CreditoID
            INTO Var_CreditoID
            FROM REVERSADESCNOMINAREAL
            WHERE NumTransaccion = Aud_NumTransaccion
                AND FolioReversaID = ContadorAux;

            SELECT COUNT(*)
            INTO Var_ExistPagoPost
            FROM RESPAMORTCRENOMINAREAL
            WHERE FolioProceso > Par_FolioCargaID
                AND CreditoID = Var_CreditoID;

            SET Var_ExistPagoPost := IFNULL(Var_ExistPagoPost, Entero_Cero);

            IF (Var_ExistPagoPost > Entero_Cero)THEN
                SET Par_NumErr := 002;
                SET Par_ErrMen  := CONCAT('El Credito ', Var_CreditoID, ' Tiene Pagos de Institucion Aplicados Posteriores');
                LEAVE ManejoErrores;
            END IF;

            -- Se elimina registros de Tabla Original
            DELETE FROM AMORTCRENOMINAREAL WHERE CreditoID = Var_CreditoID;

            INSERT INTO AMORTCRENOMINAREAL(
                FolioNominaID,      CreditoID,      AmortizacionID,         FechaVencimiento,       FechaExigible,
                FechaPagoIns,       Estatus,        EstatusPagoBan,         EmpresaID,              Usuario,
                FechaActual,        DireccionIP,    ProgramaID,             Sucursal,               NumTransaccion)
            SELECT
                FolioNominaID,      CreditoID,      AmortizacionID,         FechaVencimiento,       FechaExigible,
                FechaPagoIns,       Estatus,        EstatusPagoBan,         EmpresaID,              Usuario,
                FechaActual,        DireccionIP,    ProgramaID,             Sucursal,               NumTransaccion
            FROM RESPAMORTCRENOMINAREAL
            WHERE FolioProceso = Par_FolioCargaID
                AND CreditoID = Var_CreditoID;

            -- Se elimina registro de Tabla Respaldo
            DELETE FROM RESPAMORTCRENOMINAREAL WHERE FolioProceso = Par_FolioCargaID  AND CreditoID = Var_CreditoID;

            SET ContadorAux := ContadorAux + 1;

        END WHILE;

        -- Se elimina los registros de la tabla temporal
        DELETE FROM REVERSADESCNOMINAREAL WHERE NumTransaccion = Aud_NumTransaccion;

        UPDATE DESCNOMINAREAL SET
            Estatus = Estatus_Activo
        WHERE  FolioCargaID = Par_FolioCargaID;

        -- Se actualiza el Folio de Procesamiento
        UPDATE DESCNOMINAREAL SET
            EstatPagBanco = Est_Vigente,
            FolioProcesoID = Entero_Cero
        WHERE FolioProcesoID = Par_FolioCargaID;

        -- Se actualiza el Movimiento de Conciliacion

        SELECT MovConciliado
        INTO NumMovConcilia
        FROM DETALLEPAGNOMINST
        WHERE FolioCargaID = Par_FolioCargaID;

        UPDATE TESOMOVSCONCILIA SET
            EstAplicaInst=Est_NoAplicado
        WHERE NumeroMov = NumMovConcilia;

        DELETE FROM DETALLEPAGNOMINST WHERE FolioCargaID = Par_FolioCargaID;



        -- VERIFICA SI LLAMA A SP DE REVERSA DE PAGO DE CREDITO

        SET Par_NumErr  := 000;
        SET Par_ErrMen  := 'Pagos Reversados Correctamente';
        SET Var_Control := 'institNominaID';

    END IF;

    IF(Par_TipoAct = Act_ApliMasiva)THEN
        UPDATE DESCNOMINAREAL SET
            FolioProcesoID = Par_FolioCargaID
        WHERE FolioCargaID = Par_FolioCargaID;

        SET Par_NumErr  := 000;
        SET Par_ErrMen  := 'Folio Proceso Actualizado Correctamente';
        SET Var_Control := 'institNominaID';
    END IF;

    IF(Par_TipoAct = Act_Individual)THEN
        UPDATE DESCNOMINAREAL SET
            FolioProcesoID = Par_FolioCargaID
        WHERE FolioNominaID = Par_FolioNominaID;

        SET Par_NumErr  := 000;
        SET Par_ErrMen  := 'Folio Proceso Actualizado Correctamente';
        SET Var_Control := 'institNominaID';
    END IF;

END ManejoErrores;

    IF (Par_Salida = SalidaSI) THEN
        SELECT  Par_NumErr AS NumErr,
                Par_ErrMen AS ErrMen,
                Var_Control AS control,
                Entero_Cero AS consecutivo;
    END IF;

END TerminaStore$$