-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BECARGAPAGNOMINAWSACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BECARGAPAGNOMINAWSACT`;
DELIMITER $$

CREATE PROCEDURE `BECARGAPAGNOMINAWSACT`(
    Par_FolioCargaID            INT(11),            -- ID de Folio de Carga
    Par_EmpresaNominaID         INT(11),            -- Institucion de Nomina ID
    Par_TotalPagos              INT(11),            -- Numero Total de Pagos
    Par_NumExitos               INT(11),            -- Numero de Registros Exitosos
    Par_NumError                INT(11),            -- Numero de Registros Exitosos
    Par_MontoPagos              DECIMAL(12,2),      -- Monto de Pagos
    Par_NumAct                  TINYINT UNSIGNED,	-- Numero de Actualizacion

    Par_Salida                  CHAR(1),            -- Parametro de Salida
    INOUT Par_NumErr            INT(11),            -- Parametro de Numero de Error
    INOUT Par_ErrMen            VARCHAR(400),       -- Parametro de Mensaje de Error

    Par_EmpresaID               INT(11),            -- Parametros de Auditoria
    Aud_Usuario                 INT(11),            -- Parametros de Auditoria
    Aud_FechaActual             DATETIME,           -- Parametros de Auditoria
    Aud_DireccionIP             VARCHAR(15),        -- Parametros de Auditoria
    Aud_ProgramaID              VARCHAR(50),        -- Parametros de Auditoria
    Aud_Sucursal                INT(11),            -- Parametros de Auditoria
    Aud_NumTransaccion          BIGINT(20)          -- Parametros de Auditoria
        )
TerminaStore:BEGIN

    -- Declaracion de Variables
    DECLARE Var_Control         VARCHAR(100);
    DECLARE Var_Institucion     INT(11);            -- Variable de ID de Institucion de Nomina
    DECLARE Var_Solicitud       BIGINT(20);         -- Variable para la Solicitud de Credito
    DECLARE Var_FolioCtrl       VARCHAR(20);        -- Numero de control que la institucion de nomina tiene para el control de sus empleados
    DECLARE Var_FolioCarga      INT(11);            -- Folio Carga ID
    DECLARE Var_MontoPago       DECIMAL(12,2);      -- Monto Aplicado
    DECLARE Var_Consecutivo     INT(11);            -- Consecutivo
    DECLARE Var_FolioCargaID    INT(11);            -- Folio Nomina

    -- Declaracion de Constantes
    DECLARE Cadena_Vacia        CHAR(1);            -- Constante Cadena Vacia
    DECLARE Fecha_Vacia         DATE;               -- Constante Fecha Vacia
    DECLARE FechaSist           DATE;               -- Constante Fecha del Sistema
    DECLARE Entero_Cero         INT(11);            -- Constante Entero Cero
    DECLARE Decimal_Cero        DECIMAL(12,2);      -- Constante Decimal Cero
    DECLARE SalidaSI            CHAR(1);            -- Constante Salida SI 'S'
    DECLARE Con_NO              CHAR(1);            -- Constante N
    DECLARE Act_Principal       INT(11);            -- Actualizacion Principal

    -- Seteo de Constantes
    SET Cadena_Vacia        := '';
    SET Fecha_Vacia         := '1900-01-01';
    SET Entero_Cero         := 0;
    SET Decimal_Cero        := 0.0;
    SET SalidaSI            := 'S';
    SET Con_NO              := 'N';
    SET Act_Principal       := 1;


    SET FechaSist := (SELECT FechaSistema FROM PARAMETROSSIS);
    SET Aud_FechaActual := NOW();

    ManejoErrores: BEGIN

        DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
            SET Par_NumErr := 999;
            SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                        'Disculpe las molestias que esto le ocasiona. Ref: SP-BECARGAPAGNOMINAWSACT');
            END;


        IF(IFNULL(Par_FolioCargaID, Entero_Cero) = Entero_Cero ) THEN
            SET Par_NumErr  := 001;
            SET Par_ErrMen  := 'El folio de Carga esta Vacio.';
            LEAVE ManejoErrores;
        END IF;

        SET Var_FolioCargaID := (SELECT FolioCargaID FROM BECARGAPAGNOMINA WHERE FolioCargaID = Par_FolioCargaID);
        SET Var_FolioCargaID := IFNULL(Var_FolioCargaID, Entero_Cero);

        IF(Var_FolioCargaID  = Entero_Cero ) THEN
            SET Par_NumErr  := 002;
            SET Par_ErrMen  := 'El folio de Carga No Existe.';
            LEAVE ManejoErrores;
        END IF;

        IF(Par_NumAct = Act_Principal) THEN
            UPDATE BECARGAPAGNOMINA SET
                NumTotalPagos = Par_TotalPagos,
                NumPagosExito = Par_NumExitos,
                NumPagosError = Par_NumError,
                MontoPagos    = Par_MontoPagos
            WHERE FolioCargaID = Par_FolioCargaID;
        END IF;

    SET Par_NumErr  := 000;
    SET Par_ErrMen  := 'Registros de Carga Actualizado Exitosamente';
    SET Var_Control := 'institNominaID';

    END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control;
END IF;

END TerminaStore$$