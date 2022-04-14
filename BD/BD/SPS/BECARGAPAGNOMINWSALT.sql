-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BECARGAPAGNOMINWSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BECARGAPAGNOMINWSALT`;
DELIMITER $$

CREATE PROCEDURE `BECARGAPAGNOMINWSALT`(
    Par_EmpresaNominaID         INT(11),            -- Institucion de Nomina ID

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
    DECLARE Var_FolioCarga      INT(11);
    DECLARE Var_Institucion     INT(11);

    -- Declaracion de Constantes
    DECLARE Cadena_Vacia        CHAR(1);
    DECLARE Fecha_Vacia         DATE;
    DECLARE FechaSist           DATE;
    DECLARE Entero_Cero         INT(11);
    DECLARE Decimal_Cero        DECIMAL(12,2);
    DECLARE SalidaSI            CHAR(1);
    DECLARE RutaArchivo         VARCHAR(250);
    DECLARE Con_NO              CHAR(1);

    -- Seteo de Constantes
    SET Cadena_Vacia        := '';
    SET Fecha_Vacia         := '1900-01-01';
    SET Entero_Cero         := 0;
    SET Decimal_Cero        := 0.0;
    SET SalidaSI            := 'S';
    SET Con_NO              := 'N';
    SET RutaArchivo         := 'PROCESO IMPORTADO MEDIANTE WS';


    SET FechaSist := (SELECT FechaSistema FROM PARAMETROSSIS);
    SET Aud_FechaActual := NOW();

    ManejoErrores: BEGIN

        DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
            SET Par_NumErr := 999;
            SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                        'Disculpe las molestias que esto le ocasiona. Ref: SP-BECARGAPAGNOMINWSALT');
            END;

        SET Var_Institucion := (SELECT InstitNominaID
                                    FROM INSTITNOMINA
                                    WHERE InstitNominaID = Par_EmpresaNominaID);

        SET Var_Institucion := IFNULL(Var_Institucion,Entero_Cero);

        IF(Var_Institucion = Entero_Cero )THEN
			SET	Par_NumErr 		:= 1;
			SET	Par_ErrMen		:= 'La Institucion especificada no Existe';
            SET Var_Control		:= 'institucionID';
            SET Var_FolioCarga := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

       CALL BECARGAPAGNOMINALT(Entero_Cero,     Par_EmpresaNominaID,        Cadena_Vacia,       Entero_Cero,        Entero_Cero,
                                Entero_Cero,    Decimal_Cero,               RutaArchivo,        Con_NO,             Par_NumErr,
                                Par_ErrMen,     Par_EmpresaID,              Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,
                                Aud_ProgramaID, Aud_Sucursal,               Aud_NumTransaccion);

        IF(Par_NumErr != Entero_Cero)THEN
            LEAVE ManejoErrores;
        END IF;

        SET Var_FolioCarga :=  (SELECT BE.FolioCargaID FROM BECARGAPAGNOMINA BE WHERE BE.NumTransaccion = Aud_NumTransaccion LIMIT 1);
        SET Var_FolioCarga := IFNULL(Var_FolioCarga, Entero_Cero);

        SET Par_NumErr  := 000;
        SET Par_ErrMen  := 'Folio Carga de Archivo Cargado Exitosamente';
        SET Var_Control := 'institNominaID';


    END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_FolioCarga AS consecutivo;
END IF;

END TerminaStore$$