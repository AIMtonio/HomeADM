-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BEERRORPAGNOMINWSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BEERRORPAGNOMINWSALT`;
DELIMITER $$

CREATE PROCEDURE `BEERRORPAGNOMINWSALT`(
    Par_FolioCargaID            INT(11),            -- ID de Folio de Carga
    Par_EmpresaNominaID         INT(11),            -- Institucion de Nomina ID
    Par_CreditoID               BIGINT(12),         -- Credito ID
    Par_Descripcion             VARCHAR(200),       -- Descripcion de Error
    Par_FolioNomina             INT(11),            -- Folio de Nomina

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

    -- Declaracion de Constantes
    DECLARE Cadena_Vacia        CHAR(1);            -- Constante Cadena Vacia
    DECLARE Fecha_Vacia         DATE;               -- Constante Fecha Vacia
    DECLARE FechaSist           DATE;               -- Constante Fecha del Sistema
    DECLARE Entero_Cero         INT(11);            -- Constante Entero Cero
    DECLARE Decimal_Cero        DECIMAL(12,2);      -- Constante Decimal Cero
    DECLARE SalidaSI            CHAR(1);            -- Constante Salida SI 'S'
    DECLARE Con_NO              CHAR(1);

    -- Seteo de Constantes
    SET Cadena_Vacia        := '';
    SET Fecha_Vacia         := '1900-01-01';
    SET Entero_Cero         := 0;
    SET Decimal_Cero        := 0.0;
    SET SalidaSI            := 'S';
    SET Con_NO              := 'N';


    SET FechaSist := (SELECT FechaSistema FROM PARAMETROSSIS);
    SET Aud_FechaActual := NOW();

    ManejoErrores: BEGIN

        DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
            SET Par_NumErr := 999;
            SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                        'Disculpe las molestias que esto le ocasiona. Ref: SP-BEERRORPAGNOMINWSALT');
            END;

        -- Se elimina el Registro en BEPAGOSNOMINA para pasarlo a la bitacora de Error
        DELETE FROM BEPAGOSNOMINA
            WHERE FolioNominaID = Par_FolioNomina
                AND FolioCargaID = Par_FolioCargaID
                AND CreditoID = Par_CreditoID;

       CALL CARGAPAGONOMERRORALT(   Par_FolioCargaID,       Par_EmpresaNominaID,    Par_Descripcion,         Par_CreditoID,           Con_NO,
                                    Par_NumErr,             Par_ErrMen,             Par_EmpresaID,           Aud_Usuario,             Aud_FechaActual,
                                    Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,            Aud_NumTransaccion);

    SET Par_NumErr  := 000;
    SET Par_ErrMen  := 'Folio Carga de Archivo Cargado Exitosamente';
    SET Var_Control := 'institNominaID';

    END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control;
END IF;

END TerminaStore$$